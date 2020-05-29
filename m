Return-Path: <SRS0=vHWX=7L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B572C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:03:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21FB4207BC
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="l24fAm13"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21FB4207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D07694B287;
	Fri, 29 May 2020 12:03:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LmuAPXF8t+Vh; Fri, 29 May 2020 12:03:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F6A74B28E;
	Fri, 29 May 2020 12:03:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F05CE4B28E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:03:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tr+2UPFi+bt9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2020 12:03:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 939594B28A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:03:26 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C36BA207F9;
 Fri, 29 May 2020 16:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590768205;
 bh=ox5DskgEilhU7+ZeBhHJcLWnRN2xYIH7FioH/4inlBM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=l24fAm13aDBEva2JKA5ZcZjIp5mCQFNMxLz5a+33W+/hAhsXcPNme9U8toWlh3wtA
 Nc5w9dvqCTaczMwZDFa8eits7jEcx5olBG6qXi+E3tkE7+kBREkbM6pifD/mMo0e5u
 /CtpgwwaKh4tf6JQNI+tkNT5hKrSzUZ+pHLz9Z4c=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jehSJ-00GJKc-Me; Fri, 29 May 2020 17:02:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 19/24] KVM: arm64: Refactor vcpu_{read,write}_sys_reg
Date: Fri, 29 May 2020 17:01:16 +0100
Message-Id: <20200529160121.899083-20-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com,
 dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com,
 zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Jiang Yi <giangyi@amazon.com>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
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

Extract the direct HW accessors for later reuse.

Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 128 +++++++++++++++++++++-----------------
 1 file changed, 71 insertions(+), 57 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 620eaf11e672..50e328ca1419 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -64,11 +64,8 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 {
-	if (!vcpu->arch.sysregs_loaded_on_cpu)
-		goto immediate_read;
-
 	/*
 	 * System registers listed in the switch are not saved on every
 	 * exit from the guest but are only saved on vcpu_put.
@@ -79,40 +76,37 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 	 * thread when emulating cross-VCPU communication.
 	 */
 	switch (reg) {
-	case CSSELR_EL1:	return read_sysreg_s(SYS_CSSELR_EL1);
-	case SCTLR_EL1:		return read_sysreg_s(SYS_SCTLR_EL12);
-	case ACTLR_EL1:		return read_sysreg_s(SYS_ACTLR_EL1);
-	case CPACR_EL1:		return read_sysreg_s(SYS_CPACR_EL12);
-	case TTBR0_EL1:		return read_sysreg_s(SYS_TTBR0_EL12);
-	case TTBR1_EL1:		return read_sysreg_s(SYS_TTBR1_EL12);
-	case TCR_EL1:		return read_sysreg_s(SYS_TCR_EL12);
-	case ESR_EL1:		return read_sysreg_s(SYS_ESR_EL12);
-	case AFSR0_EL1:		return read_sysreg_s(SYS_AFSR0_EL12);
-	case AFSR1_EL1:		return read_sysreg_s(SYS_AFSR1_EL12);
-	case FAR_EL1:		return read_sysreg_s(SYS_FAR_EL12);
-	case MAIR_EL1:		return read_sysreg_s(SYS_MAIR_EL12);
-	case VBAR_EL1:		return read_sysreg_s(SYS_VBAR_EL12);
-	case CONTEXTIDR_EL1:	return read_sysreg_s(SYS_CONTEXTIDR_EL12);
-	case TPIDR_EL0:		return read_sysreg_s(SYS_TPIDR_EL0);
-	case TPIDRRO_EL0:	return read_sysreg_s(SYS_TPIDRRO_EL0);
-	case TPIDR_EL1:		return read_sysreg_s(SYS_TPIDR_EL1);
-	case AMAIR_EL1:		return read_sysreg_s(SYS_AMAIR_EL12);
-	case CNTKCTL_EL1:	return read_sysreg_s(SYS_CNTKCTL_EL12);
-	case PAR_EL1:		return read_sysreg_s(SYS_PAR_EL1);
-	case DACR32_EL2:	return read_sysreg_s(SYS_DACR32_EL2);
-	case IFSR32_EL2:	return read_sysreg_s(SYS_IFSR32_EL2);
-	case DBGVCR32_EL2:	return read_sysreg_s(SYS_DBGVCR32_EL2);
+	case CSSELR_EL1:	*val = read_sysreg_s(SYS_CSSELR_EL1);	break;
+	case SCTLR_EL1:		*val = read_sysreg_s(SYS_SCTLR_EL12);	break;
+	case ACTLR_EL1:		*val = read_sysreg_s(SYS_ACTLR_EL1);	break;
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
+	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
+	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
+	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
+	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
+	default:		return false;
 	}
 
-immediate_read:
-	return __vcpu_sys_reg(vcpu, reg);
+	return true;
 }
 
-void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+static bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 {
-	if (!vcpu->arch.sysregs_loaded_on_cpu)
-		goto immediate_write;
-
 	/*
 	 * System registers listed in the switch are not restored on every
 	 * entry to the guest but are only restored on vcpu_load.
@@ -122,32 +116,52 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 	 * once, before running the VCPU, and never changed later.
 	 */
 	switch (reg) {
-	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	return;
-	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	return;
-	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	return;
-	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	return;
-	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	return;
-	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	return;
-	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	return;
-	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	return;
-	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	return;
-	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	return;
-	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	return;
-	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	return;
-	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	return;
-	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12); return;
-	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	return;
-	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	return;
-	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	return;
-	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	return;
-	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	return;
-	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	return;
-	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	return;
-	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	return;
-	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	return;
+	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	break;
+	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	break;
+	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	break;
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
+	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
+	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
+	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
+	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
+	default:		return false;
 	}
 
-immediate_write:
+	return true;
+}
+
+u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+{
+	u64 val = 0x8badf00d8badf00d;
+
+	if (vcpu->arch.sysregs_loaded_on_cpu &&
+	    __vcpu_read_sys_reg_from_cpu(reg, &val))
+		return val;
+
+	return __vcpu_sys_reg(vcpu, reg);
+}
+
+void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+{
+	if (vcpu->arch.sysregs_loaded_on_cpu &&
+	    __vcpu_write_sys_reg_to_cpu(val, reg))
+		return;
+
 	 __vcpu_sys_reg(vcpu, reg) = val;
 }
 
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
