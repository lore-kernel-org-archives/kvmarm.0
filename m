Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DF68476
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 19:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A6CC433D2;
	Thu, 12 Jan 2023 19:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673551353;
	bh=HzXSsUwByW2jAR2hO6nb9l7RS/h2EPWpRifFw83LriQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2d7YVIrWajomx4U9sTFi/IMLXHiL66QkuOXaBXk2knZdkAIB5VGpZaE4rhp/w69M
	 XHyg9FmPiHCkxeqdvABLQ6goqk8Kh5aMGllwGe7r1z0eoE2YPjZ2sddN4U5wLsLRKJ
	 zJasenOyS7HHvePpwMtJQmSm0xmdgStSnxjsimtQUevh/DOW4cC7G41dCzr6bs5+8F
	 yEtEyyPGyPBVnwTOrbDu3+vNPDLl5e6EEttW7ZnXTkE6VmK0wNVqGbtlTq8Evqvxa6
	 yF/ZjgXROwsprG1dpOrCLjUtSG00y6iHCC6i1JkXZzO334ibA/EqAfQtU7waE3F+NB
	 h1FIyh1DMbCog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pG37Q-001IWu-D8;
	Thu, 12 Jan 2023 19:20:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 51/68] KVM: arm64: nv: Deal with broken VGIC on maintenance interrupt delivery
Date: Thu, 12 Jan 2023 19:19:10 +0000
Message-Id: <20230112191927.1814989-52-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Normal, non-nesting KVM deals with maintenance interrupt in a very
simple way: we don't even try to handle it and just turn it off
as soon as we exit, long before the kernel can handle it.

However, with NV, we rely on the actual handling of the interrupt
to leave it active and pass it down to the L1 guest hypervisor
(we effectively treat it as an assigned interrupt, just like the
timer).

This doesn't work with something like the Apple M2, which doesn't
have an active state that allows the interrupt to be masked.

Instead, just disable the vgic after having taken the interrupt and
injected a virtual interrupt. This is enough for the guest to make
forward progress, but will limit its ability to handle further
interrupts until it next exits (IAR will always report "spurious").

Oh well.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 755e4819603a..919275b94625 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -225,4 +225,7 @@ void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
 		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
 				    vcpu->kvm->arch.vgic.maint_irq, state, vcpu);
 	}
+
+	if (unlikely(kvm_vgic_global_state.no_hw_deactivation))
+		sysreg_clear_set_s(SYS_ICH_HCR_EL2, ICH_HCR_EN, 0);
 }
-- 
2.34.1

