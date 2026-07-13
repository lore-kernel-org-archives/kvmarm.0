Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638843A6B99
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783952011; cv=none; b=KJE857lIvxizTgykvGvmvwZl27cJDqxUAQtXU4wZitGvQCiiEAEjeTNu3i+nwHneO37cn3FsVCpDhmaBO78Dnm6cQqy8eQFJCUcDfL0r0OE6LX/TdXRyjjKxHa7V+DUGqr2+PockX5vc8csHVrcRQfqbCEgv/4MvQorvplhE7J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783952011; c=relaxed/simple;
	bh=FKDIwVSYjBERwvoYzAiPGNs0iOqLa4NYZ8QsY0Y2wyc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MTCFiYR4nWVUIKsw4WSlG1cd7d9DOxEobbgj8SviGposTCorWdwKAXZD9Vw1LiuPh/rYQPanlr/twL4rqBSuAYPrKbD13osbRBejdl0LPaMhdas1KQND4rJbJy1k/UB0MD+opV7Bv1POLSuNILKp/TFGPm8DR45SrlfBFDYK6Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mzWG8bNj; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mzWG8bNj"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-473941177b0so2621125f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 07:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783952009; x=1784556809; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8EAfjYCZ+mdecM/2UWmz0mAoe+dOmM9YeKRDVlIVuZo=;
        b=mzWG8bNjQYIfdJ6sy7JhhJXAeijSO9eMEB2E4W99P+JtB58KAMmJ9HtVv/UKmFjs2/
         hKQevM+fYpbjNA1H6waPh++iMvZuyWj5xD6LPeOxO2vkn7FlzDwwmSwu9Mh3xVSirtaU
         qPTdK60++a25R2fLkXLCmRVllpqE6u/DjQINa3Ehk8iG+7G8qNzmD1fr/ZAHQ11h2r2q
         Euf4xkgPilXaz7+BmTRs32xNnBfagITPV7bwPtsCEHRL50B1mJHiDZxvNicTSiwM9Qjs
         +YFiCsfF4i9tLbUkl3PMLnupaMDX0juFnwBM8N9LJlofTzYmDr508f4ODJlRzAKBfC6t
         MjLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783952009; x=1784556809;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8EAfjYCZ+mdecM/2UWmz0mAoe+dOmM9YeKRDVlIVuZo=;
        b=DjkKcVceBUq0d/RbkDq7h/Gse/tD4MUY9Y+gRIMhEbEeCxJ3UQEWdpPri8lZJBtq1r
         oVqvVlm/9XY42YIw0feqnbekSPxz3RJuj512UX5fBBkB/sE/B4bS6aFqUfUpkt8uOXp4
         0aVyBmkbkkJtq/w0Vk0EaMKDEDAWndDvKmgKBtfsr82SH/u4Y/UbUp43rD3WeDClCZ5v
         +Uf0uxM/UTN7vDC9LJPwkeZhOmpiB4DoIdrRMjp/ZHtYlaQG0l7QobU3uOX5VQKxPGNV
         Z2A5LUSlBtX+f21oySS68+XOL7teTvKakfwFIAtB5zVnzeAv/qJZGIff0Ve72mPvok5i
         ymxw==
X-Forwarded-Encrypted: i=1; AHgh+RpFD22zNNDIZNM9BE8cf89UlusRdVM9euiKTpke/UKyo+rCRNh8uRinNdkpxEmCpt0OaBsfQXQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmJ0PINXcRjFcQSXcLISyHtw56v0QOq5qBrCZeSWvA8W3lAj1A
	UlEoLBclq8EbqQavJ6oW4i4vz3X+fa63/AuHAeCvi6TfobI8DdnqVe5+wFUv1TqZOyEFjO5h+Um
	S6yuMhGlzWkNNiA==
X-Received: from wmxt9-n2.prod.google.com ([2002:a05:600d:8649:20b0:493:f85a:3733])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:190f:b0:492:4e09:9fc1 with SMTP id 5b1f17b1804b1-493f87e5b7fmr103931935e9.15.1783952008431;
 Mon, 13 Jul 2026 07:13:28 -0700 (PDT)
Date: Mon, 13 Jul 2026 14:13:20 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260713141320.4065600-1-smostafa@google.com>
Subject: [PATCH v2] KVM: arm64: Avoid naming collision in tracing
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, Mostafa Saleh <smostafa@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

When the hypervisor tracing (CONFIG_NVHE_EL2_TRACING) is disabled, it
defines a static inline stub for trace_clock().

However, trace_clock() is already declared as an extern function in
linux/trace_clock.h which is pulled in EL2 compilation.

If the file <nvhe/clock.h> is included when CONFIG_NVHE_EL2_TRACING
is disabled (by including it manually in setup.c) it will cause:
In file included from arch/arm64/kvm/hyp/nvhe/setup.c:22:

./arch/arm64/kvm/hyp/include/nvhe/clock.h:14:19: error: static declaration =
of =E2=80=98trace_clock=E2=80=99 follows non-static declaration

   14 | static inline u64 trace_clock(void) { return 0; }

      |                   ^~~~~~~~~~~

on GCC and a linker error on LLVM (it seems to change the linkage to
global)

Although that is not a problem at the moment, as no other files
include <nvhe/clock.h>. That does not seem to be the intent of
this code and that will cause issues with more users as the SMMUv3
driver.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

---
I did not add Fixes tag as this is currently dormant and not breaking
anything.
---
 arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
 arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
 arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/i=
nclude/nvhe/clock.h
index 9f429f5c0664..ae03ec6965af 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
@@ -6,11 +6,11 @@
 #include <asm/kvm_hyp.h>
=20
 #ifdef CONFIG_NVHE_EL2_TRACING
-void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
-u64 trace_clock(void);
+void trace_hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_c=
yc);
+u64 trace_hyp_clock(void);
 #else
 static inline void
-trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
-static inline u64 trace_clock(void) { return 0; }
+trace_hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) {=
 }
+static inline u64 trace_hyp_clock(void) { return 0; }
 #endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/cloc=
k.c
index a7fc61976fd0..f3e2619db4e4 100644
--- a/arch/arm64/kvm/hyp/nvhe/clock.c
+++ b/arch/arm64/kvm/hyp/nvhe/clock.c
@@ -30,7 +30,7 @@ static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 sh=
ift)
 }
=20
 /* Does not guarantee no reader on the modified bank. */
-void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
+void trace_hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_c=
yc)
 {
 	struct clock_data *clock =3D &trace_clock_data;
 	u64 bank =3D clock->cur ^ 1;
@@ -48,7 +48,7 @@ void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns=
, u64 epoch_cyc)
 }
=20
 /* Use untrusted host data */
-u64 trace_clock(void)
+u64 trace_hyp_clock(void)
 {
 	struct clock_data *clock =3D &trace_clock_data;
 	u64 bank =3D smp_load_acquire(&clock->cur);
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trac=
e.c
index e7e150ab265f..65be6c9fb379 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -35,7 +35,7 @@ static bool hyp_trace_buffer_loaded(struct hyp_trace_buff=
er *trace_buffer)
 void *tracing_reserve_entry(unsigned long length)
 {
 	return simple_ring_buffer_reserve(this_cpu_ptr(trace_buffer.simple_rbs), =
length,
-					  trace_clock());
+					  trace_hyp_clock());
 }
=20
 void tracing_commit_entry(void)
@@ -290,7 +290,7 @@ void __tracing_update_clock(u32 mult, u32 shift, u64 ep=
och_ns, u64 epoch_cyc)
 	}
=20
 	/* ...we can now override the old one and swap. */
-	trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
+	trace_hyp_clock_update(mult, shift, epoch_ns, epoch_cyc);
 }
=20
 int __tracing_reset(unsigned int cpu)
--=20
2.55.0.795.g602f6c329a-goog

