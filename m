Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE74623A564
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 00:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548170; cv=none; b=ipkyitLs0cL2Acw80UC6qZT4YyVDrr3WPDyNtijWo74dET5TywM28GJ4KFLFJzznCdn9rwbBUVdNSYNJpHTf7s23OoDXNgdvYygcViGH9ExSAwZE58TG/nzanE2XQhYT/yaXSECg156nIgyKDGaxSz/nH/+FLsWJT2YeaF+uRcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548170; c=relaxed/simple;
	bh=HssReSiAlT9GEXO7mAzhj5J3aEcuKLz/8VblparhWCo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HyQbfUeU8b5AnczEoLo7kPp0hA0D2Ko3HyF8PCsUXiu05Q6PQISGgT3izaRFbEuuZ37ij+/mr8lAA5pOhbEuC1nw2VoxmemKiZ4W8Dh4U+74BDtOGWsdmPdO1ZxqjM2Zqpj2yMpq2CnHGn57XwRI65+VoYvbEDdmN/5krxUUKX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rHZoKp4z; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rHZoKp4z"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ad147cdf07so15131995ad.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 16:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771548166; x=1772152966; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GQ2slfqXqEtWCx20U8reQyZN3PZwYuE3292l0oaA+/E=;
        b=rHZoKp4zkz5flb/DT01xu8F7cMfJhEfKyuSCZF0xGKvk9ozcf1Xy+1HYNQMPIda3vI
         YK+vJp34SCFRK9yy6md+2odlfEczS25OU3e9AlWdQVPrVWRVDtXdgdy6njSMlvN2h5XX
         rxjleSydrct9jFAxKUppkbQeMY6AN3zfx/0eQnCDql0FHv/S50qZDnlA6M8RiafHwS9K
         5KSrp+COEwvGoGTRpfE8xNvzYglEtc4xujKYfQvm+8ieEbhy16e1BpCglkvu/6HmUARK
         6D4V4nEntPgr74EYO2Tp6BXt/ZdaY8hn6UPmpZznjiIzJo3SZYvck9B7QlgnYPGyjSzE
         ZKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548166; x=1772152966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GQ2slfqXqEtWCx20U8reQyZN3PZwYuE3292l0oaA+/E=;
        b=TGrCB/mL+8CBi2bRcx/aavW89p40WYdZsRJTHXAujLIvZGwsgQOiIlqdN2RlB4PUCz
         whAe0AwuskvcTvlzfxJYZYY/bMy3ymMaJrhTzZk0n0ufZ1co6+3OLIqS5rb+Ha6eTmST
         gkmAgk4bu8V0vURzYrp+fvTv7lZcz9bRyJ4fs5TPv759DJulat7+TZm/KeCXDylmZErr
         khmFHvBRQuVqu74iRBy4wQK3t8cAHlPM/mdkSd0kUwVfIwk2quUc1TKbXaNSrhKjvzZe
         b6YAl8XPqlToo4qB2yzp5BABVH810sKVOgRV61lDW1HHAQg/JqZz0+Zx/JvjZ1UbComh
         0soQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMFTFgviitNun6e2OGoFFDld94pDu+rF/ExXll1jKtTyakoc7uFJWE6OFjyCYtoeuqRwk/Y0w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXM9w0Pu9LwdEoiiJVkBvkgqzixm/zAEOlIDxGsZxBwWTmqf8z
	tRoM86ZFXEoxL83KSuLRB6UvKGumbmmXYcOYJGzHDpvmxWPlqXreOV5ED6PZVbTMAJkGlc/Nv0T
	s5oJRSzFyf2xusA==
X-Received: from pjbso13.prod.google.com ([2002:a17:90b:1f8d:b0:34a:c039:1428])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5282:b0:34c:635f:f855 with SMTP id 98e67ed59e1d1-3584481e367mr17810869a91.7.1771548166016;
 Thu, 19 Feb 2026 16:42:46 -0800 (PST)
Date: Fri, 20 Feb 2026 00:42:20 +0000
In-Reply-To: <20260220004223.4168331-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260220004223.4168331-8-dmatlack@google.com>
Subject: [PATCH v2 07/10] KVM: selftests: Use s32 instead of int32_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Bibo Mao <maobibo@loongson.cn>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Colin Ian King <colin.i.king@gmail.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Use s32 instead of int32_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/int32_t/s32/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../kvm/arm64/arch_timer_edge_cases.c         | 24 +++++++++----------
 .../selftests/kvm/include/arm64/arch_timer.h  |  4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index f8b183f13864..f7625eb711d6 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -25,8 +25,8 @@
 /* Depends on counter width. */
 static u64 CVAL_MAX;
 /* tval is a signed 32-bit int. */
-static const int32_t TVAL_MAX = INT32_MAX;
-static const int32_t TVAL_MIN = INT32_MIN;
+static const s32 TVAL_MAX = INT32_MAX;
+static const s32 TVAL_MIN = INT32_MIN;
 
 /* After how much time we say there is no IRQ. */
 static const u32 TIMEOUT_NO_IRQ_US = 50000;
@@ -355,7 +355,7 @@ static void test_timer_cval(enum arch_timer timer, u64 cval,
 	test_timer_xval(timer, cval, TIMER_CVAL, wm, reset_state, reset_cnt);
 }
 
-static void test_timer_tval(enum arch_timer timer, int32_t tval,
+static void test_timer_tval(enum arch_timer timer, s32 tval,
 			    irq_wait_method_t wm, bool reset_state,
 			    u64 reset_cnt)
 {
@@ -385,10 +385,10 @@ static void test_cval_no_irq(enum arch_timer timer, u64 cval,
 	test_xval_check_no_irq(timer, cval, usec, TIMER_CVAL, wm);
 }
 
-static void test_tval_no_irq(enum arch_timer timer, int32_t tval, u64 usec,
+static void test_tval_no_irq(enum arch_timer timer, s32 tval, u64 usec,
 			     sleep_method_t wm)
 {
-	/* tval will be cast to an int32_t in test_xval_check_no_irq */
+	/* tval will be cast to an s32 in test_xval_check_no_irq */
 	test_xval_check_no_irq(timer, (u64)tval, usec, TIMER_TVAL, wm);
 }
 
@@ -463,7 +463,7 @@ static void test_timers_fired_multiple_times(enum arch_timer timer)
  * timeout for the wait: we use the wfi instruction.
  */
 static void test_reprogramming_timer(enum arch_timer timer, irq_wait_method_t wm,
-				     int32_t delta_1_ms, int32_t delta_2_ms)
+				     s32 delta_1_ms, s32 delta_2_ms)
 {
 	local_irq_disable();
 	reset_timer_state(timer, DEF_CNT);
@@ -504,7 +504,7 @@ static void test_reprogram_timers(enum arch_timer timer)
 
 static void test_basic_functionality(enum arch_timer timer)
 {
-	int32_t tval = (int32_t) msec_to_cycles(test_args.wait_ms);
+	s32 tval = (s32)msec_to_cycles(test_args.wait_ms);
 	u64 cval = DEF_CNT + msec_to_cycles(test_args.wait_ms);
 	int i;
 
@@ -685,7 +685,7 @@ static void test_set_cnt_after_xval_no_irq(enum arch_timer timer,
 }
 
 static void test_set_cnt_after_tval(enum arch_timer timer, u64 cnt_1,
-				    int32_t tval, u64 cnt_2,
+				    s32 tval, u64 cnt_2,
 				    irq_wait_method_t wm)
 {
 	test_set_cnt_after_xval(timer, cnt_1, tval, cnt_2, wm, TIMER_TVAL);
@@ -699,7 +699,7 @@ static void test_set_cnt_after_cval(enum arch_timer timer, u64 cnt_1,
 }
 
 static void test_set_cnt_after_tval_no_irq(enum arch_timer timer,
-					   u64 cnt_1, int32_t tval,
+					   u64 cnt_1, s32 tval,
 					   u64 cnt_2, sleep_method_t wm)
 {
 	test_set_cnt_after_xval_no_irq(timer, cnt_1, tval, cnt_2, wm,
@@ -718,7 +718,7 @@ static void test_set_cnt_after_cval_no_irq(enum arch_timer timer,
 static void test_move_counters_ahead_of_timers(enum arch_timer timer)
 {
 	int i;
-	int32_t tval;
+	s32 tval;
 
 	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
 		irq_wait_method_t wm = irq_wait_method[i];
@@ -753,7 +753,7 @@ static void test_move_counters_behind_timers(enum arch_timer timer)
 
 static void test_timers_in_the_past(enum arch_timer timer)
 {
-	int32_t tval = -1 * (int32_t) msec_to_cycles(test_args.wait_ms);
+	s32 tval = -1 * (s32)msec_to_cycles(test_args.wait_ms);
 	u64 cval;
 	int i;
 
@@ -789,7 +789,7 @@ static void test_timers_in_the_past(enum arch_timer timer)
 
 static void test_long_timer_delays(enum arch_timer timer)
 {
-	int32_t tval = (int32_t) msec_to_cycles(test_args.long_wait_ms);
+	s32 tval = (s32)msec_to_cycles(test_args.long_wait_ms);
 	u64 cval = DEF_CNT + msec_to_cycles(test_args.long_wait_ms);
 	int i;
 
diff --git a/tools/testing/selftests/kvm/include/arm64/arch_timer.h b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
index 4fe0e0d07584..a5836d4ab7ee 100644
--- a/tools/testing/selftests/kvm/include/arm64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
@@ -79,7 +79,7 @@ static inline u64 timer_get_cval(enum arch_timer timer)
 	return 0;
 }
 
-static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
+static inline void timer_set_tval(enum arch_timer timer, s32 tval)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -95,7 +95,7 @@ static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
 	isb();
 }
 
-static inline int32_t timer_get_tval(enum arch_timer timer)
+static inline s32 timer_get_tval(enum arch_timer timer)
 {
 	isb();
 	switch (timer) {
-- 
2.53.0.414.gf7e9f6c205-goog

