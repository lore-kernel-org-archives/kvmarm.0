From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 09/38] KVM: arm64: Add the shadow context for virtual
 EL2 execution
Date: Tue, 18 Jul 2017 11:58:35 -0500
Message-ID: <1500397144-16232-10-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ABBB40D6B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CpTXlgMOs778 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:01 -0400 (EDT)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com
 [209.85.223.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7360549C12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:01 -0400 (EDT)
Received: by mail-io0-f175.google.com with SMTP id k71so16777871iod.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 09:59:50 -0700 (PDT)
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

With the nested virtualization support, a hypervisor running inside a VM
(i.e. a guest hypervisor) is now deprivilaged and runs in EL1 instead of
EL2. So, the host hypervisor manages the shadow context for the virtual
EL2 execution.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 57dccde..46880c3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -229,6 +229,19 @@ struct kvm_cpu_context {
 	};
 
 	u64 el2_special_regs[NR_EL2_SPECIAL_REGS];
+
+	u64 shadow_sys_regs[NR_SYS_REGS];  /* only used for virtual EL2 */
+
+	/*
+	 * hw_* will be written to the hardware when entering to a VM.
+	 * They have either the virtual EL2 or EL1/EL0 context depending
+	 * on the vcpu mode.
+	 */
+	u64 *hw_sys_regs;
+	u64 hw_sp_el1;
+	u64 hw_pstate;
+	u64 hw_elr_el1;
+	u64 hw_spsr_el1;
 };
 
 typedef struct kvm_cpu_context kvm_cpu_context_t;
-- 
1.9.1
