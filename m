Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A8EC4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:35:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 28DF624640
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbgT24c2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28DF624640
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE8424B1DF;
	Mon, 26 Oct 2020 09:35:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SmmCVep2W5zE; Mon, 26 Oct 2020 09:35:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90F724B4B4;
	Mon, 26 Oct 2020 09:35:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 005DA4B172
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:35:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0+2zRJDoffqo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 09:35:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 034C14B4F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:35:07 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 04FB92465B;
 Mon, 26 Oct 2020 13:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603719306;
 bh=CvaKTnQotYybp5phggcR7y33tgV64QvHq8mztyYvrgE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=dbgT24c22Ke6qzLQ5xeSOE5SnmKegKSRH6R4/khInlOWrNrKdpfOqH/whVDkAe88/
 66BiIlq2CbLTz8rw9ft94cnbVwcl+PTge3BihFV4foOQG1oJ+fZu5PvQm2zvz5cDSf
 d6RKTwqkc8Kd4J63S2AY//h5mn86bVGkgwhHDfO8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kX2eO-004Kjh-8O; Mon, 26 Oct 2020 13:35:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 05/11] KVM: arm64: Move VHE direct sysreg accessors into
 kvm_host.h
Date: Mon, 26 Oct 2020 13:34:44 +0000
Message-Id: <20201026133450.73304-6-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026133450.73304-1-maz@kernel.org>
References: <20201026133450.73304-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com,
 will@kernel.org, qperret@google.com, dbrazdil@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

As we are about to need to access system registers from the HYP
code based on their internal encoding, move the direct sysreg
accessors to a common include file.

No functionnal change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 85 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         | 81 -----------------------------
 2 files changed, 85 insertions(+), 81 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9a75de3ad8da..0ae51093013d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -438,6 +438,91 @@ struct kvm_vcpu_arch {
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
 
+static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
+{
+	/*
+	 * *** VHE ONLY ***
+	 *
+	 * System registers listed in the switch are not saved on every
+	 * exit from the guest but are only saved on vcpu_put.
+	 *
+	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
+	 * should never be listed below, because the guest cannot modify its
+	 * own MPIDR_EL1 and MPIDR_EL1 is accessed for VCPU A from VCPU B's
+	 * thread when emulating cross-VCPU communication.
+	 */
+	switch (reg) {
+	case CSSELR_EL1:	*val = read_sysreg_s(SYS_CSSELR_EL1);	break;
+	case SCTLR_EL1:		*val = read_sysreg_s(SYS_SCTLR_EL12);	break;
+	case CPACR_EL1:		*val = read_sysreg_s(SYS_CPACR_EL12);	break;
+	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
+	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
+	case TCR_EL1:		*val = read_sysreg_s(SYS_TCR_EL12);	break;
+	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
+	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
+	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
+	case FAR_EL1:		*val = read_sysreg_s(SYS_FAR_EL12);	break;
+	case MAIR_EL1:		*val = read_sysreg_s(SYS_MAIR_EL12);	break;
+	case VBAR_EL1:		*val = read_sysreg_s(SYS_VBAR_EL12);	break;
+	case CONTEXTIDR_EL1:	*val = read_sysreg_s(SYS_CONTEXTIDR_EL12);break;
+	case TPIDR_EL0:		*val = read_sysreg_s(SYS_TPIDR_EL0);	break;
+	case TPIDRRO_EL0:	*val = read_sysreg_s(SYS_TPIDRRO_EL0);	break;
+	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
+	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
+	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
+	case ELR_EL1:		*val = read_sysreg_s(SYS_ELR_EL12);	break;
+	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
+	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
+	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
+	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
+	default:		return false;
+	}
+
+	return true;
+}
+
+static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
+{
+	/*
+	 * *** VHE ONLY ***
+	 *
+	 * System registers listed in the switch are not restored on every
+	 * entry to the guest but are only restored on vcpu_load.
+	 *
+	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
+	 * should never be listed below, because the MPIDR should only be set
+	 * once, before running the VCPU, and never changed later.
+	 */
+	switch (reg) {
+	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	break;
+	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	break;
+	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	break;
+	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
+	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
+	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
+	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
+	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
+	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
+	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	break;
+	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	break;
+	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	break;
+	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12);break;
+	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	break;
+	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	break;
+	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
+	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
+	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
+	case ELR_EL1:		write_sysreg_s(val, SYS_ELR_EL12);	break;
+	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
+	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
+	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
+	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
+	default:		return false;
+	}
+
+	return true;
+}
+
 /*
  * CP14 and CP15 live in the same array, as they are backed by the
  * same system registers.
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 01f63027cf40..f7415c9dbcd9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -64,87 +64,6 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
-{
-	/*
-	 * System registers listed in the switch are not saved on every
-	 * exit from the guest but are only saved on vcpu_put.
-	 *
-	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
-	 * should never be listed below, because the guest cannot modify its
-	 * own MPIDR_EL1 and MPIDR_EL1 is accessed for VCPU A from VCPU B's
-	 * thread when emulating cross-VCPU communication.
-	 */
-	switch (reg) {
-	case CSSELR_EL1:	*val = read_sysreg_s(SYS_CSSELR_EL1);	break;
-	case SCTLR_EL1:		*val = read_sysreg_s(SYS_SCTLR_EL12);	break;
-	case CPACR_EL1:		*val = read_sysreg_s(SYS_CPACR_EL12);	break;
-	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
-	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
-	case TCR_EL1:		*val = read_sysreg_s(SYS_TCR_EL12);	break;
-	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
-	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
-	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
-	case FAR_EL1:		*val = read_sysreg_s(SYS_FAR_EL12);	break;
-	case MAIR_EL1:		*val = read_sysreg_s(SYS_MAIR_EL12);	break;
-	case VBAR_EL1:		*val = read_sysreg_s(SYS_VBAR_EL12);	break;
-	case CONTEXTIDR_EL1:	*val = read_sysreg_s(SYS_CONTEXTIDR_EL12);break;
-	case TPIDR_EL0:		*val = read_sysreg_s(SYS_TPIDR_EL0);	break;
-	case TPIDRRO_EL0:	*val = read_sysreg_s(SYS_TPIDRRO_EL0);	break;
-	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
-	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
-	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
-	case ELR_EL1:		*val = read_sysreg_s(SYS_ELR_EL12);	break;
-	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
-	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
-	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
-	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
-	default:		return false;
-	}
-
-	return true;
-}
-
-static bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
-{
-	/*
-	 * System registers listed in the switch are not restored on every
-	 * entry to the guest but are only restored on vcpu_load.
-	 *
-	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
-	 * should never be listed below, because the MPIDR should only be set
-	 * once, before running the VCPU, and never changed later.
-	 */
-	switch (reg) {
-	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	break;
-	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	break;
-	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	break;
-	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
-	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
-	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
-	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
-	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
-	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
-	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	break;
-	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	break;
-	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	break;
-	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12);break;
-	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	break;
-	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	break;
-	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
-	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
-	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
-	case ELR_EL1:		write_sysreg_s(val, SYS_ELR_EL12);	break;
-	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
-	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
-	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
-	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
-	default:		return false;
-	}
-
-	return true;
-}
-
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
 	u64 val = 0x8badf00d8badf00d;
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
