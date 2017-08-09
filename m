From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 22/27] arm64/sve: KVM: Treat guest SVE use as undefined
 instruction execution
Date: Wed,  9 Aug 2017 13:05:28 +0100
Message-ID: <1502280338-23002-23-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A98B749C65
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:06:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r9hdUKoKTTjZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Aug 2017 08:06:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B14E049C5A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:06:49 -0400 (EDT)
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When trapping forbidden attempts by a guest to use SVE, we want the
guest to see a trap consistent with SVE not being implemented.

This patch injects an undefined instruction exception into the
guest in response to such an exception.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/handle_exit.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 17d8a16..e3e42d0 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -147,6 +147,13 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
+static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	/* Until SVE is supported for guests: */
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
 static exit_handle_fn arm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
 	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
@@ -160,6 +167,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_HVC64]	= handle_hvc,
 	[ESR_ELx_EC_SMC64]	= handle_smc,
 	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
+	[ESR_ELx_EC_SVE]	= handle_sve,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_SOFTSTP_LOW]= kvm_handle_guest_debug,
-- 
2.1.4
