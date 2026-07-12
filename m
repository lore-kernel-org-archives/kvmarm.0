Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9F2253340
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 15:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783870732; cv=none; b=d4DQZx5+IC95Vd30bddfJs7FwAVetxiItdfUd6JATenK8NF7RuhhlQ1IqnwFCcGJz0u8QIengQDAEZjPuw91e5fX+ytRg+hdCsBSO5Avrm/VcmsI8jq2t/tGESgeiWlGU6CX+aTy/GiJvAPqcGXn66vYh+4N2HaRKh/wXUv8BkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783870732; c=relaxed/simple;
	bh=FmQDkaXVosTaBGvaCFFP1YMXKMODSo63wIgdXG4YCMw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aybxsaATdKjBpkPeJ8Kv8/i71UbVZi65qEX6iidg2AOvfdsOVvuRk6bqSMXrITfWUSXFkeTg0fwwOmaP4fOnqfdWAHATxSPzOq7/OuPl4OwCAGgp2m+uXSBQicmVMfuqsTH7rIPzNsrDz2pLN6WswHJjrybl9YsAYpePGnf7Yww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CeLJdGx2; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CeLJdGx2"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493e260e62bso12424315e9.1
        for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 08:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783870728; x=1784475528; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Q4E9hh3K2pv4VCZFsG0zDJ0k6GBrQNGUvEBLw2wLUQw=;
        b=CeLJdGx2msqfi5L0UU3w0mAXAUERj7/IRzgABmFvDE6eo+rN3+/NyYJtzbSWcYZaR9
         TLwrP1IrBwgH+Iw9E7vXX7ULCWi3Z23DF1l3TqS/ukoMxWzzNSNIvvAzx9f8JurAcgW4
         x7XUvUhTutOCsNXHeoMj47qCfR2yPSxyChfeWOjuF8CJ09GPkuBiMIoYAv0N0kDpK5/4
         4fEY8gu29IrwPpPOULl3whPZxE2W5ivdCpGUqsg5hDrd7EOBxIagsMJgJmyYwp3ut52Y
         GFCjjIYsptC+/qM8IM5Hlv2VFsCHz3vrvaaim9jbMfatAFyABR5Ov2plGWWCRKGlE6vT
         ax0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783870728; x=1784475528;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q4E9hh3K2pv4VCZFsG0zDJ0k6GBrQNGUvEBLw2wLUQw=;
        b=UIvrcVfa9VHX9ayEN0teIrTWLHgk56F6TOq5BNf/gdvINDUgwfz+u036otLkL2Q9iJ
         t6UBh+WbUbkG8ifbeLsvPoeUgrSFRh8kDzE8cV6JusTqukM53smfoKDQJMRxbelPXlKu
         mM6EsdAMliSzsXh3bXW78avRQcvyG+FJ0GEmfrxe6OrqK5ETC+6hRDoSgOso+4TRaMTy
         /yxBT7XCIAyEeG9Y35BCN4/z0l/8x+cFP/8GntuqrGe2P+3jshLcr/f5wxRoZdePyXDo
         K8TQRX75YkROVrswrjJ9YEs5GK3J5VfYiqhn7BxwOe1l59IXP6UkN6dtOna+ODYszzv4
         3Ukw==
X-Forwarded-Encrypted: i=1; AHgh+RpwqMZlju7WpxllxKz6HKSTTE7wacQNNVeF9e/INEmKjZZIAMbGKKrnAG1aqKW7eqDGY8bchX4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyhEJ7X1f6Q8AGAqSt00GI1NtOJ9NSbfrutePs5lrRiPUsHo2RX
	2NyxY4Lnh/JcV1SpkxQA2z8Ykljlra67/J0elMr0oWRJWWGzdjKqt3u4BZsKJIreesgRjK6Vrjg
	gKuiM8kIWhzd9TQ==
X-Received: from wmpm32.prod.google.com ([2002:a05:600c:920:b0:493:b55e:f03f])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4688:b0:493:d9f7:a3cf with SMTP id 5b1f17b1804b1-493f87f1ff4mr58578045e9.17.1783870727433;
 Sun, 12 Jul 2026 08:38:47 -0700 (PDT)
Date: Sun, 12 Jul 2026 15:38:35 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260712153835.2264905-1-smostafa@google.com>
Subject: [PATCH] KVM: arm64: Avoid naming collision in tracing
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, Mostafa Saleh <smostafa@google.com>
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

--
I did not add Fixes tag as this is currently dormant and not breaking
anything.
---
 arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
 arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
 arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/i=
nclude/nvhe/clock.h
index 9f429f5c0664..c2ccd0e8bf22 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
@@ -6,11 +6,11 @@
 #include <asm/kvm_hyp.h>
=20
 #ifdef CONFIG_NVHE_EL2_TRACING
-void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
-u64 trace_clock(void);
+void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_c=
yc);
+u64 hyp_trace_clock(void);
 #else
 static inline void
-trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
-static inline u64 trace_clock(void) { return 0; }
+hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) {=
 }
+static inline u64 hyp_trace_clock(void) { return 0; }
 #endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/cloc=
k.c
index a7fc61976fd0..8adefb0b696c 100644
--- a/arch/arm64/kvm/hyp/nvhe/clock.c
+++ b/arch/arm64/kvm/hyp/nvhe/clock.c
@@ -30,7 +30,7 @@ static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 sh=
ift)
 }
=20
 /* Does not guarantee no reader on the modified bank. */
-void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
+void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_c=
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
+u64 hyp_trace_clock(void)
 {
 	struct clock_data *clock =3D &trace_clock_data;
 	u64 bank =3D smp_load_acquire(&clock->cur);
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trac=
e.c
index e7e150ab265f..f2a32463c6c2 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -35,7 +35,7 @@ static bool hyp_trace_buffer_loaded(struct hyp_trace_buff=
er *trace_buffer)
 void *tracing_reserve_entry(unsigned long length)
 {
 	return simple_ring_buffer_reserve(this_cpu_ptr(trace_buffer.simple_rbs), =
length,
-					  trace_clock());
+					  hyp_trace_clock());
 }
=20
 void tracing_commit_entry(void)
@@ -290,7 +290,7 @@ void __tracing_update_clock(u32 mult, u32 shift, u64 ep=
och_ns, u64 epoch_cyc)
 	}
=20
 	/* ...we can now override the old one and swap. */
-	trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
+	hyp_trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
 }
=20
 int __tracing_reset(unsigned int cpu)
--=20
2.55.0.795.g602f6c329a-goog

