From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 03/25] arm64: KVM: Implement HVC_GET_VECTORS in the init
 code
Date: Mon,  6 Mar 2017 14:24:36 +0000
Message-ID: <20170306142458.8875-4-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27EAA40C4C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:24:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2F0q2vMfNxFl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:24:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC57840C2A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:24:47 -0500 (EST)
In-Reply-To: <20170306142458.8875-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, james.morse@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that we have an infrastructure to handle hypercalls in the KVM
init code, let's implement HVC_GET_VECTORS there.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp-init.S | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 6cf98ccd10f2..1d89995378e9 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -124,7 +124,12 @@ __do_hyp_init:
 ENDPROC(__kvm_hyp_init)
 
 ENTRY(__kvm_handle_stub_hvc)
-	cmp	x0, #HVC_RESET_VECTORS
+	cmp	x0, #HVC_GET_VECTORS
+	b.ne	1f
+	mrs	x0, vbar_el2
+	b	exit
+
+1:	cmp	x0, #HVC_RESET_VECTORS
 	b.ne	1f
 	/*
 	 * Reset kvm back to the hyp stub.
-- 
2.11.0
