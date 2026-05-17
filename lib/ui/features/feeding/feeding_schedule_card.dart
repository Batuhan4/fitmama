import 'package:flutter/material.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../data/services/feeding_schedule.dart';
import '../../../utils/localized.dart';
import '../../core/widgets/fitmama_card.dart';

const _scheduleTitle = L(
  'Beslenme programı',
  'Feeding schedule',
  more: {
    'hi': 'फीडिंग शेड्यूल',
    'pt': 'Horário de alimentação',
    'es': 'Horario de alimentación',
    'id': 'Jadwal menyusui',
    'ur': 'فیڈنگ کا شیڈول',
    'bn': 'খাওয়ানোর সময়সূচী',
    'ar': 'جدول الرضاعة',
    'ru': 'График кормления',
    'de': 'Fütterungsplan',
    'fr': 'Horaire d\'alimentation',
    'it': 'Programma alimentazione',
    'ja': '授乳スケジュール',
    'ko': '수유 일정',
    'zh': '喂奶时间表',
    'fil': 'Iskedyul ng pagpapakain',
    'vi': 'Lịch cho bú',
    'fa': 'برنامه شیردهی',
    'pl': 'Harmonogram karmienia',
  },
);
const _everyLabel = L(
  'Her',
  'Every',
  more: {
    'hi': 'हर',
    'pt': 'A cada',
    'es': 'Cada',
    'id': 'Setiap',
    'ur': 'ہر',
    'bn': 'প্রতি',
    'ar': 'كل',
    'ru': 'Каждые',
    'de': 'Alle',
    'fr': 'Toutes les',
    'it': 'Ogni',
    'ja': '毎',
    'ko': '매',
    'zh': '每',
    'fil': 'Tuwing',
    'vi': 'Mỗi',
    'fa': 'هر',
    'pl': 'Co',
  },
);
const _daily = L(
  'kez',
  'times',
  more: {
    'hi': 'बार',
    'pt': 'vezes',
    'es': 'veces',
    'id': 'kali',
    'ur': 'مرتبہ',
    'bn': 'বার',
    'ar': 'مرات',
    'ru': 'раз',
    'de': 'Mal',
    'fr': 'fois',
    'it': 'volte',
    'ja': '回',
    'ko': '번',
    'zh': '次',
    'fil': 'beses',
    'vi': 'lần',
    'fa': 'بار',
    'pl': 'razy',
  },
);
const _suggested = L(
  'Önerilen alarm saatleri',
  'Suggested alarm times',
  more: {
    'hi': 'सुझाए गए अलार्म समय',
    'pt': 'Horários de alarme sugeridos',
    'es': 'Horas de alarma sugeridas',
    'id': 'Waktu alarm yang disarankan',
    'ur': 'تجویز کردہ الارم کے اوقات',
    'bn': 'সাজেস্টেড অ্যালার্ম সময়',
    'ar': 'أوقات التنبيه المقترحة',
    'ru': 'Рекомендуемое время будильника',
    'de': 'Vorgeschlagene Weckzeiten',
    'fr': 'Heures de réveil suggérées',
    'it': 'Orari sveglia suggeriti',
    'ja': 'おすすめアラーム時間',
    'ko': '추천 알람 시간',
    'zh': '建议闹钟时间',
    'fil': 'Mga iminungkahing oras ng alarm',
    'vi': 'Giờ báo thức đề xuất',
    'fa': 'زمان‌های پیشنهادی هشدار',
    'pl': 'Sugerowane godziny alarmu',
  },
);
const _nightOn = L(
  'Gece beslenmesi devam ediyor',
  'Night feeds still expected',
  more: {
    'hi': 'रात को दूध पिलाना अभी भी अपेक्षित है',
    'pt': 'Mamadas noturnas ainda esperadas',
    'es': 'Tomas nocturnas aún esperadas',
    'id': 'Menyusui malam masih diharapkan',
    'ur': 'رات کو دودھ پلانا اب بھی متوقع ہے',
    'bn': 'রাতে খাওয়ানো এখনও প্রয়োজন',
    'ar': 'لا تزال الرضعات الليلية متوقعة',
    'ru': 'Ночные кормления все еще ожидаются',
    'de': 'Nachtfütterungen werden noch erwartet',
    'fr': 'Les tétées nocturnes sont encore attendues',
    'it': 'Poppate notturne ancora previste',
    'ja': '夜間の授乳はまだ必要です',
    'ko': '야간 수유가 여전히 필요합니다',
    'zh': '仍需夜间喂奶',
    'fil': 'Inaasahan pa rin ang pagpapakain sa gabi',
    'vi': 'Vẫn cần cho bú đêm',
    'fa': 'شیردهی شبانه هنوز مورد انتظار است',
    'pl': 'Karmienia nocne są nadal oczekiwane',
  },
);
const _disclaimer = L(
  'Bu saatler öneri niteliğindedir — pediatristine danış.',
  'These times are suggestions — always check with your pediatrician.',
  more: {
    'hi': 'ये समय केवल सुझाव हैं — हमेशा अपने बाल रोग विशेषज्ञ से जाँच करें।',
    'pt': 'Estes horários são sugestões — sempre consulte seu pediatra.',
    'es': 'Estos horarios son sugerencias — siempre consulta con tu pediatra.',
    'id': 'Waktu-waktu ini adalah saran — selalu konsultasikan dengan dokter anak Anda.',
    'ur': 'یہ اوقات صرف مشورے ہیں — ہمیشہ اپنے ماہر اطفال سے مشورہ کریں۔',
    'bn': 'এই সময়গুলি শুধু পরামর্শ — সর্বদা আপনার শিশু বিশেষজ্ঞের সাথে পরীক্ষা করুন।',
    'ar': 'هذه الأوقات هي اقتراحات — استشيري طبيب الأطفال دائمًا.',
    'ru': 'Это время — рекомендации, всегда консультируйтесь с педиатром.',
    'de': 'Diese Zeiten sind Vorschläge — frage immer deinen Kinderarzt.',
    'fr': 'Ces horaires sont des suggestions — consulte toujours ton pédiatre.',
    'it': 'Questi orari sono suggerimenti — consulta sempre il tuo pediatra.',
    'ja': 'これらの時間は提案です — 常に小児科医に確認してください。',
    'ko': '이 시간들은 제안입니다 — 항상 소아과 의사와 확인하세요.',
    'zh': '这些时间仅为建议 — 请务必咨询儿科医生。',
    'fil': 'Ang mga oras na ito ay mungkahi — laging kumunsulta sa iyong pediatrician.',
    'vi': 'Những giờ này là gợi ý — luôn kiểm tra với bác sĩ nhi khoa của bạn.',
    'fa': 'این زمان‌ها پیشنهاد هستند — همیشه با پزشک متخصص اطفال خود مشورت کنید.',
    'pl': 'Te godziny to sugestie — zawsze skonsultuj się z pediatrą.',
  },
);
const _hoursAbbr = L(
  'sa',
  'h',
  more: {
    'hi': 'घं',
    'pt': 'h',
    'es': 'h',
    'id': 'j',
    'ur': 'گھن',
    'bn': 'ঘ',
    'ar': 'س',
    'ru': 'ч',
    'de': 'Std',
    'fr': 'h',
    'it': 'h',
    'ja': '時間',
    'ko': '시간',
    'zh': '小时',
    'fil': 'oras',
    'vi': 'giờ',
    'fa': 'س',
    'pl': 'godz',
  },
);

class FeedingScheduleCard extends StatelessWidget {
  const FeedingScheduleCard({super.key, required this.repository});

  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final profile = repository.profile;
    if (profile == null) return const SizedBox.shrink();
    final weeks = weeksSince(profile.babyBirthDate);
    final schedule = scheduleForWeeks(weeks);
    final now = TimeOfDay.now();
    final hh = _hoursAbbr.of(context);

    return FitmamaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primary.withValues(alpha: 0.12),
                ),
                child: Icon(Icons.schedule_rounded,
                    color: scheme.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_scheduleTitle.of(context)} (${schedule.ageLabel.of(context)})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${_everyLabel.of(context)} ${schedule.intervalHoursMin}-${schedule.intervalHoursMax} $hh · ${schedule.dailyFeedsMin}-${schedule.dailyFeedsMax} ${_daily.of(context)} · ${schedule.amountMlMin}-${schedule.amountMlMax} ml',
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _suggested.of(context),
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.1,
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: schedule.alarmTimes.map((time) {
              final parts = time.split(':');
              final h = int.tryParse(parts[0]) ?? 0;
              final m = int.tryParse(parts[1]) ?? 0;
              final past = h < now.hour ||
                  (h == now.hour && m < now.minute);
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: past
                      ? scheme.surfaceContainerHighest
                      : scheme.primary.withValues(alpha: 0.14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      past
                          ? Icons.check_circle_outline_rounded
                          : Icons.notifications_active_outlined,
                      size: 12,
                      color: past
                          ? scheme.onSurfaceVariant
                          : scheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: past
                            ? scheme.onSurfaceVariant
                            : scheme.primary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: scheme.secondary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 14, color: scheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    schedule.note.of(context),
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          if (schedule.nightFeeding) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.bedtime_rounded,
                    size: 12, color: scheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  _nightOn.of(context),
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          Text(
            _disclaimer.of(context),
            style: TextStyle(
              fontSize: 10,
              color: scheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
