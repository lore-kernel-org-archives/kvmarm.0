Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F6FC55178
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 16:41:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3991D22275
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 16:41:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPZBbG87"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3991D22275
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC4AA4B470;
	Mon,  2 Nov 2020 11:41:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2XSLw+HuAqdo; Mon,  2 Nov 2020 11:41:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F2964B4BE;
	Mon,  2 Nov 2020 11:41:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D70064B413
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 11:41:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id axye7RsTqiJO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 11:41:09 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 683484B3F3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 11:41:09 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8A8C72231B;
 Mon,  2 Nov 2020 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604335268;
 bh=kYgjV+zUa5izDdI+aOngBG9r7zCtSRk+PElBDCD4ErI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=OPZBbG877Wci6F14VEM8eSLTK2UdxP2o7Q6e93LIQmRTGVzE7umxsimCXTpdEAOpb
 DZfIVmLrdpdbtKKpkgPHY9fQunI5VzQ/3FidXmQJJGDHqnmdpxYLKGVG8irNIUzgd9
 GuN5UiHnxJJzb2x6SOGb2ocO7hh+7LqMDu2QYG0c=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kZctG-006jJf-SN; Mon, 02 Nov 2020 16:41:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 05/11] KVM: arm64: Move VHE direct sysreg accessors into
 kvm_host.h
Date: Mon,  2 Nov 2020 16:40:39 +0000
Message-Id: <20201102164045.264512-6-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164045.264512-1-maz@kernel.org>
References: <20201102164045.264512-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com,
 will@kernel.org, mark.rutland@arm.com, qperret@google.com, dbrazdil@google.com,
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
accessors to a common include file, with a VHE-specific guard.

No functionnal change.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 91 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         | 81 ---------------------------
 2 files changed, 91 insertions(+), 81 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7991a1c13254..0672b3db6121 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -439,6 +439,97 @@ struct kvm_vcpu_arch {
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
+	if (!has_vhe())
+		return false;
+
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
+	case PAR_EL1:		*val = read_sysreg_par();		break;
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
+	if (!has_vhe())
+		return false;
+
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
index 6a6f06205ea7..26c7c25f8a6d 100644
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
-	case PAR_EL1:		*val = read_sysreg_par();		break;
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
