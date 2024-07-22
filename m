Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5676016E891
	for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 16:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721665996; cv=none; b=T26mBUQAbnytpoy0XtXC57XuDK064WNmgd3l1KqpC3ISPY/kQ2xjpG5brr+g/tLeUNP8t5pEnld3VvAgbtyHqNDhvofK+AD/kyBHoRcSz3GON6WmBsTOVSIk9ZuZZwoSKHTgnGEtNC5cyRHPmZNkYFFtEH2/YbHYrIEfj9O7SO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721665996; c=relaxed/simple;
	bh=fZgS7TgZ42eho+bWVbFEHL4ReLLaIhELAIqaYa051wg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ecKB8OMwfRCB277FGezF0Z3SCt7RbBmMk1Es59KP7kdz57j1LOo/5PuGq+5u3S3LrfIuXhkRroBjNKHhTw8asPjiZV/0F+mZmSfeUV38JcZM/ix/zETWo5KWu5636xXr4TE/Cg/MwadFE2BZSylbnS3YvOBsSmUrI6YR4sXUtU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Y40lt8u; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Y40lt8u"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0335450936so10606158276.1
        for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 09:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721665994; x=1722270794; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oBZRiaoiPHpjvaQGdbS690AKipoWmT5TbMFGcfqkUO0=;
        b=3Y40lt8uoB4Npq2COHS8y5Pgp3YSmTM22zYXhMqgC3kfds57wBIKb+oU2U+qqK6zdJ
         lGDRSi8et1hYC8kMo3mPT/d5cyTPBQPUir3C6lTgZYjeVQ1YdED44qUHdIGo2fGoluJF
         bkfVrEF6pNRy8LIZzITtgLgOYC1JQOd07f93/DX48FnRyZeQLaqv31LMOTn27J+KZOHg
         mWn6/vVcjnFOs266SXA9LEi+JVRFpnirh49CUWHcMitWRzOkqYOqHpU3bLmEqC/uUG+i
         0QvvK1phAzlPZlRbv51QJIo/bfoGm/Nus1Pmj8J+ML0BE7LdYQLcL0kEmQ7asIGu82ma
         Z2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721665994; x=1722270794;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oBZRiaoiPHpjvaQGdbS690AKipoWmT5TbMFGcfqkUO0=;
        b=tzTmCy3pBte93dnVdVUEHOgXst+xGxQL5gB1h2MOgsbexJBYrY3o+sbkbVQzdsgzgu
         gl6QwE1JT7Phmirxy0KO/CM+S4Md0obgdRBcYSgEQGmZ7RBeN64Up5JycOlnEk4GbJLw
         AIO+Y/Dda6v1fZpOMaXgWF+W4ANJIGUyVgg0PvgeMX8jpiiA8HYb0YnAt/4vbXfshmI0
         pDEKjZtpex9NtSSytBpFcshVdhK5wQB3TImiX/UT+fsVOZoQgAkrs1jnfuDKhTgjRqr/
         JhgcYIIpKAPLYmvSRHPW+iA6j6AvyaJ/a++hJOJb8C0vr8EHfuH1Dq9NsDEvbhgESiop
         Txcw==
X-Gm-Message-State: AOJu0YyT4QTN2dq75AMDCSQvHcWpGeQWWY/8vSJ8PyYs8PpcJo0fbNr2
	o/fCSJa/mApyCORdei2B/BkhqR1KCDT2V90qsW3/OYZ48HI/XSOq58jOTk26JFpMUNOp3CP00E6
	wR1G6oy3GdPaaiIqwJTaZPg8XI4vccnS1d6sLSMQhnIk+3aO3VzqUHbpXENIDbFmBLqc03F3VrL
	lctKCjYkoUaG+VWHKTwfTqPzUNQpA=
X-Google-Smtp-Source: AGHT+IFXQXtYk0FO0kPs5t/RuUOYUBqe5JlDDGV5fhstCWib/h+tYLUfDNmsTP4nSsWUg1CowyIIFTXYog==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2b91:b0:e03:5b06:6db2 with SMTP id
 3f1490d57ef6-e086fe42d0cmr17487276.3.1721665993794; Mon, 22 Jul 2024 09:33:13
 -0700 (PDT)
Date: Mon, 22 Jul 2024 17:33:11 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240722163311.1493879-1-tabba@google.com>
Subject: [PATCH v2] KVM: arm64: Tidying up PAuth code in KVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, 
	smostafa@google.com, will@kernel.org, catalin.marinas@arm.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Tidy up some of the PAuth trapping code to clear up some comments
and avoid clang/checkpatch warnings. Also, don't bother setting
PAuth HCR_EL2 bits in pKVM, since it's handled by the hypervisor.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_ptrauth.h    |  2 +-
 arch/arm64/kvm/arm.c                    | 14 ++++----------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  1 -
 arch/arm64/kvm/hyp/nvhe/switch.c        |  5 ++---
 4 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
index d81bac256abc..6199c9f7ec6e 100644
--- a/arch/arm64/include/asm/kvm_ptrauth.h
+++ b/arch/arm64/include/asm/kvm_ptrauth.h
@@ -104,7 +104,7 @@ alternative_else_nop_endif
 
 #define __ptrauth_save_key(ctxt, key)					\
 	do {								\
-		u64 __val;                                              \
+		u64 __val;						\
 		__val = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
 		ctxt_sys_reg(ctxt, key ## KEYLO_EL1) = __val;		\
 		__val = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 59716789fe0f..95e6d22a9d3f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -510,10 +510,10 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_has_ptrauth(vcpu)) {
+	if (vcpu_has_ptrauth(vcpu) && !is_protected_kvm_enabled()) {
 		/*
-		 * Either we're running running an L2 guest, and the API/APK
-		 * bits come from L1's HCR_EL2, or API/APK are both set.
+		 * Either we're running an L2 guest, and the API/APK bits come
+		 * from L1's HCR_EL2, or API/APK are both set.
 		 */
 		if (unlikely(vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))) {
 			u64 val;
@@ -530,16 +530,10 @@ static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
 		 * Save the host keys if there is any chance for the guest
 		 * to use pauth, as the entry code will reload the guest
 		 * keys in that case.
-		 * Protected mode is the exception to that rule, as the
-		 * entry into the EL2 code eagerly switch back and forth
-		 * between host and hyp keys (and kvm_hyp_ctxt is out of
-		 * reach anyway).
 		 */
-		if (is_protected_kvm_enabled())
-			return;
-
 		if (vcpu->arch.hcr_el2 & (HCR_API | HCR_APK)) {
 			struct kvm_cpu_context *ctxt;
+
 			ctxt = this_cpu_ptr_hyp_sym(kvm_hyp_ctxt);
 			ptrauth_save_keys(ctxt);
 		}
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0c4de44534b7..9eb68c0dd727 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -27,7 +27,6 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
-#include <asm/kvm_ptrauth.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6af179c6356d..8f5c56d5b1cd 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -173,9 +173,8 @@ static void __pmu_switch_to_host(struct kvm_vcpu *vcpu)
 static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	/*
-	 * Make sure we handle the exit for workarounds and ptrauth
-	 * before the pKVM handling, as the latter could decide to
-	 * UNDEF.
+	 * Make sure we handle the exit for workarounds before the pKVM
+	 * handling, as the latter could decide to UNDEF.
 	 */
 	return (kvm_hyp_handle_sysreg(vcpu, exit_code) ||
 		kvm_handle_pvm_sysreg(vcpu, exit_code));

base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
-- 
2.45.2.1089.g2a221341d9-goog

