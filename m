Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4606223BF8F
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 11:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761565190; cv=none; b=Rt/T54w8O2Co62qSDOVZGdnt6ZTUCvXMiZ0SQib1eu1fPCGdNlrGbg0efefsZepPz3ZPB88+WI4YIo8ZXT1K99z651G9b1Izr1OXeBuzeICW3omkNsFWbi0BDR9bzwnZ4h8TtKJnDIQXlTXIF2dFzUIxdUooDwNjFTZET8ZdZS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761565190; c=relaxed/simple;
	bh=EwxFgKeP0St3zShF0qDDg9DYguHFEO2VdLMShS3XBCc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uWPrRcJbFs+APasrhPqeC5NHRIsZ3gftxFiFFu0pFO19OB/HFA8Eol2mxxWy5wNuVKj39Vh6shsZ0Zx6GueBsaD9JCeOzIA78hofBks6/+QRdKcK5UU0ADuTixsUewvhBWZV1QiJhGbKSlzK0yqEfLxIIKtO9wnkNzCQD73IKN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AFxoNnFz; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AFxoNnFz"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4770c37331fso6811795e9.3
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 04:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761565187; x=1762169987; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ozzRAdvZp4aTU6VJQz375fyyvpAYZ+n17H++cGS5mc=;
        b=AFxoNnFzWbjOEIlu+vN/YSxlEA4lcdxwDWBXWxOHyRYhojIO/1znysI3xKG73YEXAc
         Lf31N1ZquUJ6vb3wPqnTyqi3KglH64LP8ujsalQ42iwnh+LRGAw7w8rd3TGJzKjda7Gw
         Dp2vhNIf2RyPSsFIM2/AHfbmxVFoJLgxn4LJYEmSCNbEyzcMvhhRNm9cbOpXmUyd41f2
         ZDuEeLxBMNKo/DDLnJABuFBSYN/X00RB9hhD5oJRiDO+heQ5EGY2A9neunDP0x5kIL8o
         fKcjL8O/FvGzvX49yz02DqisiACAuaR/35ZGwpSPGw9f+6Go1jYWqB8k6NXCPVgXZGdi
         Fu5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761565187; x=1762169987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ozzRAdvZp4aTU6VJQz375fyyvpAYZ+n17H++cGS5mc=;
        b=DWq7WZVBKWFS8Vcw2AudrwKf9s+d5scyl3GWFRNTHBNuWUBq/B+56cClGi9tyGw3JN
         AfISYo8SCO5pkWtFa4pHuGdX6cN607xXT/+9/pLlov8SAlB/0ImRYAX3EUp5yMTX6/00
         5W4SEybxLr/ImuNxW1VgLw6aMv7213Ji+QgZy0yZ1a/YfuE6FhtWTdP74uiLRqQphfAi
         Kp0+vGoHC+Fp1x+guepKSkx3joUQoIUaVvH1KnPcGWEW69P/eYBEHvPp5olAnB7Fmq1V
         D+fXGVNIPfzgfCM40huuNzmkwEc7vLWxiOHnmezZYlPY7HfasBleIzpzUtK4upl/kSEU
         WX1A==
X-Gm-Message-State: AOJu0YzgwQnobylp3TtVC+DgsGNAsrPu4cXG+TVlRpRGFF/NJ2ZQnppB
	1YPtWLaavcscFSkKKJWNlLhU1dwnO3nwXRLJbW1bePvz0MZLO72nZFoP7S5QU564lZH8CXF4BA5
	jlTJhiarp+XmqRq1jH/lgDOGOGyNITmyU0JU+R25ioP5urbM9vGJD2fBbKstfo0FOJCMkHXtAkh
	znMqNMZz4Osyf/tb3qfHMM1woqwst+BYo=
X-Google-Smtp-Source: AGHT+IF5QHgUQNJTKSQK9WbcSKrTjNjq/NfGqYHOtYzl4gUqkfeIRIWhUH4rgAEh4vdNAHpfjVISCm2K/A==
X-Received: from wmbgz3.prod.google.com ([2002:a05:600c:8883:b0:475:de6a:c2eb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:41ee:b0:476:84e9:b55a
 with SMTP id 5b1f17b1804b1-47684e9bfbdmr45223985e9.12.1761565186463; Mon, 27
 Oct 2025 04:39:46 -0700 (PDT)
Date: Mon, 27 Oct 2025 11:39:41 +0000
In-Reply-To: <20251027113943.1282568-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251027113943.1282568-1-tabba@google.com>
X-Mailer: git-send-email 2.51.1.838.g19442a804e-goog
Message-ID: <20251027113943.1282568-3-tabba@google.com>
Subject: [PATCH v1 2/4] KVM: arm64: Add compile-time type check for register
 in __vcpu_assign_sys_reg()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The 'r' (register) and 'val' (value) parameters in
__vcpu_assign_sys_reg() can be easily transposed. The register ID is an
enum, whereas the value is a u64. This has led to bugs in the past, and
the risk was increased by the historically inconsistent parameter
ordering of the vcpu_write_sys_reg() function.

To prevent this class of bugs, add a compile-time type compatibility check
to prevent the 'r' parameter from having a 'u64' type.

This directly catches the erroneous transposition (passing the 'u64'
value as 'r') while remaining flexible, as it does not force 'r' to
be a specific enum type.

This patch also updates several local variables in
arch/arm64/kvm/pmu-emul.c from 'u64' to 'enum vcpu_sysreg' to fix
build failures caused by the new check.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
NOTE: In practice, 'enum vcpu_sysreg' cannot grow to become compatabile
with u64 since we are limited by the size of arrays that index sysregs.
If it does grow, other compile-time issues show up before this check
becomes an issue.

I verified that this would catch the bug that commit 798eb5978700
("KVM: arm64: Sync protected guest VBAR_EL1 on injecting an undef
exception") introduced, which was fixed later.
---
 arch/arm64/include/asm/kvm_host.h | 17 +++++++++--------
 arch/arm64/kvm/pmu-emul.c         |  7 ++++---
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1b8a420f9add..2c33ea5fdb1c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1136,14 +1136,15 @@ static inline u64 *___ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 
 u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 
-#define __vcpu_assign_sys_reg(v, r, val)				\
-	do {								\
-		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
-		u64 __v = (val);					\
-		if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)	\
-			__v = kvm_vcpu_apply_reg_masks((v), (r), __v);	\
-									\
-		ctxt_sys_reg(ctxt, (r)) = __v;				\
+#define __vcpu_assign_sys_reg(v, r, val)					\
+	do {									\
+		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;		\
+		u64 __v = (val);						\
+		BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(r), u64));\
+		if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)		\
+			__v = kvm_vcpu_apply_reg_masks((v), (r), __v);		\
+										\
+		ctxt_sys_reg(ctxt, (r)) = __v;					\
 	} while (0)
 
 #define __vcpu_rmw_sys_reg(v, r, op, val)				\
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b03dbda7f1ab..c7e2d9be77ae 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -160,7 +160,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 static void kvm_pmu_set_pmc_value(struct kvm_pmc *pmc, u64 val, bool force)
 {
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-	u64 reg;
+	enum vcpu_sysreg reg;
 
 	kvm_pmu_release_perf_event(pmc);
 
@@ -230,7 +230,8 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
 static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-	u64 reg, val;
+	enum vcpu_sysreg reg;
+	u64 val;
 
 	if (!pmc->perf_event)
 		return;
@@ -776,7 +777,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx)
 {
 	struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, select_idx);
-	u64 reg;
+	enum vcpu_sysreg reg;
 
 	reg = counter_index_to_evtreg(pmc->idx);
 	__vcpu_assign_sys_reg(vcpu, reg, (data & kvm_pmu_evtyper_mask(vcpu->kvm)));
-- 
2.51.1.838.g19442a804e-goog

