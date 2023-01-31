Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC17E808
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 09:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3F6C433D2;
	Tue, 31 Jan 2023 09:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675158054;
	bh=62VNiXgtEcJnQhdzskHxVPAOADe2yEDFvlnzy+HXPMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oa6e04L/D3HuuMc27vDX9Oly0DzfTktapDjHxbhP/nWByPoSU8HAdWY5/AMuwul8R
	 hV1sHB7H8UcXt1/vetJiWda+AaK8S8+Z7QkVMoz5p0vmAwMQRr1X0WGyx3pMiIavS7
	 9jZBeEzqW/wFiGyzshP5fPZq51tePhOmt0tfGjgG7WnVypFWlMLbDRe+jEZwiShoJg
	 Ugfz2j4INxOf8K/XXXlp8F/3nsGRMyLQjg/HlPdvzZ92Qsr8ngwqCdPVi/jg3rL+qm
	 7d6bTw2B99xhLjYJX6yjA3YP0mMslT+n7eIN3iyWJXWBEDyMGmjyl4LJfNxisvyvj4
	 X2v7PotbKQSuw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pMmtr-0067U2-73;
	Tue, 31 Jan 2023 09:25:59 +0000
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
Subject: [PATCH v8 46/69] KVM: arm64: nv: Load timer before the GIC
Date: Tue, 31 Jan 2023 09:24:41 +0000
Message-Id: <20230131092504.2880505-47-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
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

In order for vgic_v3_load_nested to be able to observe which timer
interrupts have the HW bit set for the current context, the timers
must have been loaded in the new mode and the right timer mapped
to their corresponding HW IRQs.

At the moment, we load the GIC first, meaning that timer interrupts
injected to an L2 guest will never have the HW bit set (we see the
old configuration).

Swapping the two loads solves this particular problem.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 92d56959cb27..cdeb4cbd4aa7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -412,8 +412,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vcpu->cpu = cpu;
 
-	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
+	kvm_vgic_load(vcpu);
 	if (has_vhe())
 		kvm_vcpu_load_sysregs_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
-- 
2.34.1

