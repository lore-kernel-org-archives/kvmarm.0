Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D618C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B647461056
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B647461056
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CE354B0D6;
	Tue, 12 Oct 2021 00:36:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rfx0fjPum0kC; Tue, 12 Oct 2021 00:36:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BD6A4B093;
	Tue, 12 Oct 2021 00:36:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E87954B0A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L9Y+leozxOKN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:28 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5174C4048B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:27 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 g26-20020a63521a000000b0029524f04f5aso8047793pgb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=N5SZSA+fUqRTbjo35OUmhwDTNPioIOsC+zg6mLlAOeI=;
 b=Frtj842iBGMNrPh6OG3pi0Ms5HCdrLoaoymnVC+SUwO8+nKGBSOJVdpZwwm/QTQbF8
 OTYgVScpMIOT0ud7g2c8hytKJ2CjSjDz8M4XdeW7TJqSm2DEPdgyODcnwhB2ODPv6mBy
 aCnGplUEJ7fzS1cDJvyDiowSxXzf1dgt50MFJ/Uk5H21JMyKTRiuLsErBtQwO2+JItNz
 iBxKlc8wMy4/NwvNuNqhflcxOhfd2YbyIgr5mN/ngArSdHJllHqhq/3p1yIaKfs1EZGh
 Cvc+6I1dKsoE3RBupUrn125tyGYruhnhJUP/+o/18uTjunuMSuy2ARiKdbaEzViiwxtU
 j8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=N5SZSA+fUqRTbjo35OUmhwDTNPioIOsC+zg6mLlAOeI=;
 b=uz9/gk6TmfstH+e15eK1Q0Hrt3lCExMV8NvzuYdJrZILvQPT7enD/PXG0oLptMgWJE
 sRGx2xuKPfWzfi8zENoVHcnMYb3n81SFmC9cflQiJKMbmnYsn1+xLSseKk0T92raARHv
 fXLFMM0w8XuCBc1EbgI0JaSSw8ChekbSD4+67IDXdmnCOMBo8JnMYpWRct3sjgdQa4W7
 QJyzmoZQmhBWk7gtV5LOnW7xNafvzVhc2gyOPHTXC0+GhsN6NJn0OlslfCEaZJkdZX81
 t44dN17HFka7Zh/BZz4236pJA8YnS92CYtgKXSC6Xfh96DJin1Je00Dy8D8TwS9DaPUN
 5Tpg==
X-Gm-Message-State: AOAM530Yjbzip6+0510z95hlaXfEjUddmrpBi3rApy6ulEUxDbigzoYD
 BlIBi1s0amdKpyKOv3leIkPwoZfwyOU=
X-Google-Smtp-Source: ABdhPJxq/Mk4VVM9slvxTOJugnOnUA71qyKTuAL0h3f8/ueBhLbCcxivpgKtoQVfP4/2KUnvpPsw8Foxo9o=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a62:60c7:0:b0:40a:4bd7:752c with SMTP id
 u190-20020a6260c7000000b0040a4bd7752cmr29343562pfb.52.1634013386318; Mon, 11
 Oct 2021 21:36:26 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:15 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-6-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 05/25] KVM: arm64: Keep consistency of ID registers
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
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/sys_regs.c         | 31 +++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

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
index fe102cd2e518..45ca72a37872 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -620,6 +620,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 
 	ret = kvm_arm_pmu_v3_enable(vcpu);
 
+	if (kvm_id_regs_consistency_check(vcpu))
+		return -EPERM;
+
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8a0b88f9a975..2fe3121d50ca 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1331,6 +1331,10 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
 		return -EINVAL;
 
+	/* Don't allow to change the reg after the first KVM_RUN. */
+	if (vcpu->arch.has_run_once)
+		return -EINVAL;
+
 	if (raz)
 		return (val == 0) ? 0 : -EINVAL;
 
@@ -2901,6 +2905,33 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
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
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
