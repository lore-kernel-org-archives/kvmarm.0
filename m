Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DC6C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:27:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 852B461139
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:27:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 852B461139
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 334604B0F5;
	Wed,  3 Nov 2021 02:27:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pZgDpnQRDwCE; Wed,  3 Nov 2021 02:27:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D28FF4B0C2;
	Wed,  3 Nov 2021 02:27:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAB7249E57
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:27:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eU42QTyPHpzl for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:27:37 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B9A34B154
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:27:37 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 r11-20020a170902be0b00b0013f4f30d71cso633744pls.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2kkWf9Zdg9qBQvwRcMyQK3V/8Ny7lbc2Hbppz7GxNUU=;
 b=ZLc1WdJUS93vqQce2eG799TQxbD2srN4onYKkVcfL2Qy9TnekNN3Vl6DK8+Ri32oM7
 YYTKpD6QQGLRVUs2Gep5QkIzNUqeJ3Xk3zrHbHMSNJv2EmE1u0worcGwk4rHrtl6x+Ey
 EGlfhtIg5LeD5CyBmJa9zwPtN17NgP+YlqYLEzSdMOo75fpLdVtX/9JyPaow0wpXj5Hh
 GIbKaWe1vB0I6uGb2fsaGUAWiLwVur8adMQn5JSZDCqMN2VCtyDl0k5CSAE1L1dpyJSd
 RCi61slMNASXPLLAxW4pmUBIseVDXZk+lfLUimHZPGz9agQQU/7wy2EsjEHbduCLM4zH
 T4SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2kkWf9Zdg9qBQvwRcMyQK3V/8Ny7lbc2Hbppz7GxNUU=;
 b=09DUCtXgp5bMhucVQ2CaLyMUDMlVaMsvo65n3SodDn/P6/meSo+SVeJMn6avVOI3Vu
 uk4c651ms8jm8O/6FdCc4fGmmoTocUFyYoNCdTTc9GerzOejgGVDWUzJAKW+LEXXOtFl
 GNGbInOZ3kQqvWLNhW7b92U8us/Hsx4vSjRBQu7cxac8fFhPEzZKHWLPPFqMqdU3UGJ9
 NzR+01ejSSPn6XFBfrOzaevqVSzbQlFZ63b3ghsWXisIVoXg1FOm+PhErbuqKEt0PGeB
 QpKjhOUOpbPwohkpwoff7uKgcb5ko7HYzvPzlyqJe1igPQSiWAIIbydbPXUJiraam+WV
 0aNw==
X-Gm-Message-State: AOAM531tye4tExKk7iB13/xvsF5EmjFNSV4lc4sapS8hA4iEH1HXtKNz
 Cbdow6erHiiTlQTdGBNxxBzLBTMP5gw=
X-Google-Smtp-Source: ABdhPJziBhn4stzQ3o4JqWAXRAPRH2k+xrO4rqj56Fh+Dx8pv+gOVGokRNBtSBx8lVyj+81XUSJwFXkbmak=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1254:b0:481:29f7:398 with SMTP id
 u20-20020a056a00125400b0048129f70398mr8484996pfi.33.1635920856329; Tue, 02
 Nov 2021 23:27:36 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:24:56 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-5-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 04/28] KVM: arm64: Keep consistency of ID registers
 between vCPUs
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

All vCPUs that are owned by a VM must have the same values of ID
registers.

Return an error at the very first KVM_RUN for a vCPU if the vCPU has
different values in any ID registers from any other vCPUs that have
already started KVM_RUN once.  Also, return an error if userspace
tries to change a value of ID register for a vCPU that already
started KVM_RUN once.

Changing ID register is still not allowed at present though.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              |  4 ++++
 arch/arm64/kvm/sys_regs.c         | 31 +++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0cd351099adf..69af669308b0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -745,6 +745,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..83cedd74de73 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -595,6 +595,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 		return -EPERM;
 
 	vcpu->arch.has_run_once = true;
+	if (kvm_id_regs_consistency_check(vcpu)) {
+		vcpu->arch.has_run_once = false;
+		return -EPERM;
+	}
 
 	kvm_arm_vcpu_init_debug(vcpu);
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 64d51aa3aee3..e34351fdc66c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1436,6 +1436,10 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
 		return -EINVAL;
 
+	/* Don't allow to change the reg after the first KVM_RUN. */
+	if (vcpu->arch.has_run_once)
+		return -EINVAL;
+
 	if (raz)
 		return 0;
 
@@ -3004,6 +3008,33 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
+{
+	int i;
+	const struct kvm_vcpu *t_vcpu;
+
+	/*
+	 * Make sure vcpu->arch.has_run_once is visible for others so that
+	 * ID regs' consistency between two vCPUs is checked by either one
+	 * at least.
+	 */
+	smp_mb();
+	WARN_ON(!vcpu->arch.has_run_once);
+
+	kvm_for_each_vcpu(i, t_vcpu, vcpu->kvm) {
+		if (!t_vcpu->arch.has_run_once)
+			/* ID regs still could be updated. */
+			continue;
+
+		if (memcmp(&__vcpu_sys_reg(vcpu, ID_REG_BASE),
+			   &__vcpu_sys_reg(t_vcpu, ID_REG_BASE),
+			   sizeof(__vcpu_sys_reg(vcpu, ID_REG_BASE)) *
+					KVM_ARM_ID_REG_MAX_NUM))
+			return -EINVAL;
+	}
+	return 0;
+}
+
 static void id_reg_info_init_all(void)
 {
 	int i;
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
