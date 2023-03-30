Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF211C3E
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 10:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C98C433A0;
	Thu, 30 Mar 2023 10:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680170670;
	bh=o/DlzcCv84E0d74WXt/xXFCBSqi2CyUM8zi9WxCI7Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VeInNzsZMa0jPEJw1SspdxfYhK7gdpOXGqILzywX8dWlc6IxMEFBz3KK6zCeRpC27
	 4b9LFtAXoI6Yrve6xdLAlMIdp2K0wezM4BG0C7XqQOjSjW1UUZoZC2EQT4dBfOoqzQ
	 5JqdqOH0hbEJZ9mji7FXRI+UiJgDhQDtw6414sL03lFqczOSsDMca+Gw13ivWIFR9l
	 +ecs/BFjKQ+o6zycslEFaga6enNlVlsx819BXnklJAQPcMXU092gN4i13U8MYKGfDs
	 bBSPlG/LHsXMsaDjiPS16DXgZiq5XIlYf3Rth5EJzUfSiLr/rmu2GH4t5Pv1cQlkTi
	 ngJb4cvkpmOjA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1php8u-004K66-Cz;
	Thu, 30 Mar 2023 11:04:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 2/2] KVM: arm64: vhe: Synchronise with page table walker on MMU update
Date: Thu, 30 Mar 2023 11:04:19 +0100
Message-Id: <20230330100419.1436629-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330100419.1436629-1-maz@kernel.org>
References: <20230330100419.1436629-1-maz@kernel.org>
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

