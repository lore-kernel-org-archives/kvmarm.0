Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94371FB9
	for <kvmarm@lists.linux.dev>; Sat,  8 Apr 2023 16:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49675C433A7;
	Sat,  8 Apr 2023 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680969891;
	bh=o/DlzcCv84E0d74WXt/xXFCBSqi2CyUM8zi9WxCI7Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klPdRbLe352Fge1Qc59RuURYq2dt6qvaWC+FY7ocmmamZ0T3D+SCYF0E+cHnPMWXL
	 NQW76nhH62ihWXnx2y7M4Zm+Ek6bByRzQLj758zWzs2Ed7qtTbXXBEQGBT8S11yI+j
	 8Wd9fC++KB4wfMa6Hm+nhjjJDEue+1i7r5Yf549F5EQhxRHRp6TFcrIM8M2uxUO1tO
	 fc6RCgUxCM8JE3X5wqcDMpmfN5Zd+oCigqe0KL1++Wd8RouWFSvFpJkRcI4ILL+06k
	 OaI+rV/8P8D0O2o7dTY64FFOZZyV8sQbulf+Sad2t/ilMoxrYmLmBVDAFvjaWlw1Mu
	 U3zdoe+5QnJXw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1plB3Z-006wc5-FR;
	Sat, 08 Apr 2023 17:04:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 4/5] KVM: arm64: vhe: Synchronise with page table walker on MMU update
Date: Sat,  8 Apr 2023 17:04:26 +0100
Message-Id: <20230408160427.10672-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408160427.10672-1-maz@kernel.org>
References: <20230408160427.10672-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Contrary to nVHE, VHE is a lot easier when it comes to dealing
with speculative page table walks started at EL1. As we only change
EL1&0 translation regime when context-switching, we already benefit
from the effect of the DSB that sits in the context switch code.

We only need to take care of it in the NV case, where we can
flip between between two EL1 contexts (one of them being the virtual
EL2) without a context switch.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 7b44f6b3b547..b35a178e7e0d 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
 
 /*
  * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and
@@ -69,6 +70,17 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	__sysreg_save_user_state(host_ctxt);
 
+	/*
+	 * When running a normal EL1 guest, we only load a new vcpu
+	 * after a context switch, which imvolves a DSB, so all
+	 * speculative EL1&0 walks will have already completed.
+	 * If running NV, the vcpu may transition between vEL1 and
+	 * vEL2 without a context switch, so make sure we complete
+	 * those walks before loading a new context.
+	 */
+	if (vcpu_has_nv(vcpu))
+		dsb(nsh);
+
 	/*
 	 * Load guest EL1 and user state
 	 *
-- 
2.34.1

