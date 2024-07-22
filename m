Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6229916D4EF
	for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 12:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721651865; cv=none; b=UQavGt1alDZCWGnFG2gAqRSLJqoqDWAhAyj5QcmJmCAw9IPC8h1rVyC5sC5uzEUPzuwsdJnXGDmD50hzKLuygSLRTPURAnJYItrDVLOpIeXAZmZK6LKnfu3we/YXI+9hBfCqCOyia/Lzix3YwJbboCksKEaD9N++HdlMY4+IS2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721651865; c=relaxed/simple;
	bh=iWDaUkwWEWBgB57H5sIikhsnqjm73XvcLtj7fAkFRiM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=R95TWTJxNfSwhIkGlmV0wY0urIaLgYYbwIUfS0fCaXg7CWEvSS9IO4gPxD9HY18vKkSiCDuIoA4kzKBInY6w2qpzNGaZwOhCQMEP8T6vh6T4loJek50mwVBsZC/kz6/V9lveLW8qTUxVKGMN5uD6IiJKKZfjKTyBgRbrykhpEt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YfHukt5G; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YfHukt5G"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e08904584edso2044482276.3
        for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 05:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721651863; x=1722256663; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tB0NBb54ZJvMBtbd+5lg40R+dR/caZ0zF1MlN7F1oWs=;
        b=YfHukt5GaYxa4GsRVcEGzMolglgjqzuzDkLxQZ6gG+14aW3sxr+5cw76+++3RjqqAz
         zgodXrv3pik33/hd7VOiJLZH/7lPK8nG0BSeloV6iXksLV1g9Y4xVbYojeqKv8emkUE7
         r/LPIyCLsOB4dojttAhJ6ue+3si5fbc8KLRnzPGNtofdSyf1h+8WiTW9ON1IDe5THUqT
         KvFWoVE9RzcKyQ/MFSlf25ZhCaiu8J/bHunpOfeIiUHeuMDElxTvz8rqFknuSxXJKhFp
         QhPgqwy2ha48+vhgkgy/FMh5xxoL7tm+TZIWCxxu453aEO7ugDFIGeDPhoifm/2RtEgN
         XXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721651863; x=1722256663;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tB0NBb54ZJvMBtbd+5lg40R+dR/caZ0zF1MlN7F1oWs=;
        b=MCecnn0JHeY51BtZXlZArwtVek/OAe5TbRkEF8/DJODr/WsDWFuN95Qdjt2mIodL//
         9OmFrjWrMmlHRuH1k7QxcPyRFeFLpCs+pV+d2n4L+GgpK05+vTOmHom36iMWo76egWQN
         +ZQPGuL0ORo8zHTjFeuue5YACunZpY0uHit9t+K2bJkvMcdIoU7qrXTNbcyoRi2acxrw
         QHb0C3SFVAulPugsLWHObEifV6XUEGfPESoqRHtyfLZzPAK1hdZdoYWLhqwKmzzdRbCX
         bA1cE7RGRoowGcqhBd2gmQY0+MQFfk2bEl8dboba2ZAaEwGnmY/U7cqO8yTlhjq8GUkT
         njqA==
X-Gm-Message-State: AOJu0YwcRH/XDfDfvx7e4ryz84hBOPAPbuFcLcOU428W7hirS6xAw6X0
	BhSJFw0Apwv75Bi+x7EDOC97Cnjy4GLeQwwtyFGw3Y4zmhFgtFd6rfiy6thhLsFNs1i2DqSyEoS
	3cHf9AKWUdgH53U0sDdbNz9XluILdELS1zmfN5cduHxPQ3WBOVv60/Fg0GX6B4CYwEAlofQVtJ3
	iSD5qPWFE+hNMk+GLTF1npbJmzzfk=
X-Google-Smtp-Source: AGHT+IHxDaFJnCYoXUDvj1FrOKOitFCOMc2UhqbKkIVKqpb/bUB8p8/AAoaip/ok7we/mQYGn8fM8CH/OQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:70c:b0:e05:e3ce:cfaf with SMTP id
 3f1490d57ef6-e086fcb78d8mr15866276.0.1721651862734; Mon, 22 Jul 2024 05:37:42
 -0700 (PDT)
Date: Mon, 22 Jul 2024 13:37:40 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240722123740.674846-1-tabba@google.com>
Subject: [PATCH v1] KVM: arm64: Tidying up PAuth code in KVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, 
	smostafa@google.com, will@kernel.org, catalin.marinas@arm.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Tidy up some of the PAuth trapping code to clear up some comments
and avoid clang/checkpatch warnings. Also, do not bother setting
the PAuth HCR_EL2 bits for protected VMs in pKVM, since that is
handled by the hypervisor.

Fixes: 814ad8f96e92 ("KVM: arm64: Drop trapping of PAuth instructions/keys")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_ptrauth.h    | 2 +-
 arch/arm64/kvm/arm.c                    | 7 ++++---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 1 -
 arch/arm64/kvm/hyp/nvhe/switch.c        | 5 ++---
 4 files changed, 7 insertions(+), 8 deletions(-)

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
index 59716789fe0f..6516348024ba 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -510,10 +510,10 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_has_ptrauth(vcpu)) {
+	if (vcpu_has_ptrauth(vcpu) && !vcpu_is_protected(vcpu)) {
 		/*
-		 * Either we're running running an L2 guest, and the API/APK
-		 * bits come from L1's HCR_EL2, or API/APK are both set.
+		 * Either we're running an L2 guest, and the API/APK bits come
+		 * from L1's HCR_EL2, or API/APK are both set.
 		 */
 		if (unlikely(vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))) {
 			u64 val;
@@ -540,6 +540,7 @@ static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
 
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

