From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 38/38] KVM: arm64: Respect the virtual CPTR_EL2.TCPAC
 setting
Date: Tue, 18 Jul 2017 11:59:04 -0500
Message-ID: <1500397144-16232-39-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7583B49C0E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1C6mV4e6VBEH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:55 -0400 (EDT)
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com
 [209.85.223.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9065B49C7D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:55 -0400 (EDT)
Received: by mail-io0-f172.google.com with SMTP id 5so16514594iow.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:44 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Forward CPACR_EL1 traps to the virtual EL2 if virtual CPTR_EL2 is
configured to trap CPACR_EL1 accesses from EL1.

This is for recursive nested virtualization.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6f67666..ba2966d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1091,6 +1091,11 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
 
+	/* Forward this trap to the virtual EL2 if CPTR_EL2.TCPAC is set*/
+	if (!el12_reg(p) && !vcpu_mode_el2(vcpu) &&
+	    (vcpu_sys_reg(vcpu, CPTR_EL2) & CPTR_EL2_TCPAC))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	/*
 	 * When the virtual HCR_EL2.E2H == 1, an access to CPACR_EL1
 	 * in the virtual EL2 is to access CPTR_EL2.
-- 
1.9.1
