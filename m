Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DC2C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 12:21:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12E964A104;
	Thu, 27 Jan 2022 07:21:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5ssblk2TmRdu; Thu, 27 Jan 2022 07:21:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BF8F4A0FD;
	Thu, 27 Jan 2022 07:21:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5D3E49F24
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 07:21:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4psK2amW3730 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 07:21:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D3F049EE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 07:21:14 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 078E1113E;
 Thu, 27 Jan 2022 04:21:14 -0800 (PST)
Received: from eglon.cambridge.arm.com (unknown [10.1.196.218])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1A203F7D8;
 Thu, 27 Jan 2022 04:21:12 -0800 (PST)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 3/4] KVM: arm64: Stop handle_exit() from handling HVC twice
 when an SError occurs
Date: Thu, 27 Jan 2022 12:20:51 +0000
Message-Id: <20220127122052.1584324-4-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127122052.1584324-1-james.morse@arm.com>
References: <20220127122052.1584324-1-james.morse@arm.com>
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

Prior to commit defe21f49bc9 ("KVM: arm64: Move PC rollback on SError to
HYP"), when an SError is synchronised due to another exception, KVM
handles the SError first. If the guest survives, the instruction that
triggered the original exception is re-exectued to handle the first
exception. HVC is treated as a special case as the instruction wouldn't
normally be re-exectued, as its not a trap.

Commit defe21f49bc9 didn't preserve the behaviour of the 'return 1'
that skips the rest of handle_exit().

Since commit defe21f49bc9, KVM will try to handle the SError and the
original exception at the same time. When the exception was an HVC,
fixup_guest_exit() has already rolled back ELR_EL2, meaning if the
guest has virtual SError masked, it will execute and handle the HVC
twice.

Restore the original behaviour.

Fixes: defe21f49bc9 ("KVM: arm64: Move PC rollback on SError to HYP")
Cc: stable@vger.kernel.org
Signed-off-by: James Morse <james.morse@arm.com>
---
It may be possible to remove both this patch, and the HVC handling code
in fixup_guest_exit(). This means KVM would always handle the exception
and the SError. This may result in unnecessary work if the guest takes
the virtual SError when it is next restarted, but should be harmless if
SError are always re-injected using HCR_EL2.VSE.
---
 arch/arm64/kvm/handle_exit.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index fd2dd26caf91..e3140abd2e2e 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -228,6 +228,14 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 {
 	struct kvm_run *run = vcpu->run;
 
+	if (ARM_SERROR_PENDING(exception_index)) {
+		/*
+		 * The SError is handled by handle_exit_early(). If the guest
+		 * survives it will re-execute the original instruction.
+		 */
+		return 1;
+	}
+
 	exception_index = ARM_EXCEPTION_CODE(exception_index);
 
 	switch (exception_index) {
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
