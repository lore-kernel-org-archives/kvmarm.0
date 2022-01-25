Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66069C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 15:38:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 095A649ED3;
	Tue, 25 Jan 2022 10:38:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B7VTskFnpN4U; Tue, 25 Jan 2022 10:38:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD1E749EDF;
	Tue, 25 Jan 2022 10:38:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F18449ECB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 10:38:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id is8xXncvbT4G for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 10:38:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D20D749E42
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 10:38:24 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58FCFD6E;
 Tue, 25 Jan 2022 07:38:24 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EFCA3F793;
 Tue, 25 Jan 2022 07:38:23 -0800 (PST)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/4] KVM: arm64: Avoid consuming a stale esr value when SError
 occur
Date: Tue, 25 Jan 2022 15:38:01 +0000
Message-Id: <20220125153803.549084-3-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220125153803.549084-1-james.morse@arm.com>
References: <20220125153803.549084-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

When any exception other than an IRQ occurs, the CPU updates the ESR_EL2
register with the exception syndrome. An SError may also become pending,
and will be synchronised by KVM. KVM notes the exception type, and whether
an SError was synchronised in exit_code.

When an exception other than an IRQ occurs, fixup_guest_exit() updates
vcpu->arch.fault.esr_el2 from the hardware register. When an SError was
synchronised, the vcpu esr value is used to determine if the exception
was due to an HVC. If so, ELR_EL2 is moved back one instruction. This
is so that KVM can process the SError first, and re-execute the HVC if
the guest survives the SError.

But if an IRQ synchronises an SError, the vcpu's esr value is stale.
If the previous non-IRQ exception was an HVC, KVM will corrupt ELR_EL2,
causing an unrelated guest instruction to be executed twice.

Check ARM_EXCEPTION_CODE() before messing with ELR_EL2, IRQs don't
update this register so don't need to check.

Fixes: defe21f49bc9 ("KVM: arm64: Move PC rollback on SError to HYP")
Cc: stable@vger.kernel.org
Reported-by: Steven Price <steven.price@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 58e14f8ead23..331dd10821df 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -424,7 +424,8 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
-	if (ARM_SERROR_PENDING(*exit_code)) {
+	if (ARM_SERROR_PENDING(*exit_code) &&
+	    ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ) {
 		u8 esr_ec = kvm_vcpu_trap_get_class(vcpu);
 
 		/*
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
