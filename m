Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA361A583
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 18:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD7DC433CD;
	Wed, 20 Sep 2023 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695233860;
	bh=OvTnh8UHlSYCCG4Btbi7L6uQqPfkzFjL8On87GirJBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBA/WMH2f0BrCPdItWtCNO2MiygAFYVeUtaNjx8o7exjoh5T/eOv7/6F4sMJM/opJ
	 FIHXNCXzQsbqT8Ea78BnWU3kCdORaVSkHGVFhadcN+rE4b3LEBhWM8ewcU0LyvWni3
	 3U0sAW7yM0U3cpZOHMNqQpeiblO4fSG1rtD6WQSpl3y8LpJIRHeyQHuxCgXCjjGYyb
	 MXJjohFI14tPik1Dsktte1HuLAtWXa6sXFl0H60+fOA/h/CLAEs5aGOoT3ZBvIymcJ
	 iBKDaWeNzdky3AyA9oGYXoabpOBm9v2bBV2uqlcuhk79FmcCmxZshayXCwuwXDKMCQ
	 vp6+Q6pyNd/qQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qj1lZ-00Ejx0-VB;
	Wed, 20 Sep 2023 19:17:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 05/11] KVM: arm64: vgic: Use vcpu_idx for the debug information
Date: Wed, 20 Sep 2023 19:17:25 +0100
Message-Id: <20230920181731.2232453-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230920181731.2232453-1-maz@kernel.org>
References: <20230920181731.2232453-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 07aa0437125a..85606a531dc3 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -166,7 +166,7 @@ static void print_header(struct seq_file *s, struct vgic_irq *irq,
 
 	if (vcpu) {
 		hdr = "VCPU";
-		id = vcpu->vcpu_id;
+		id = vcpu->vcpu_idx;
 	}
 
 	seq_printf(s, "\n");
@@ -212,7 +212,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 		      "     %2d "
 		      "\n",
 			type, irq->intid,
-			(irq->target_vcpu) ? irq->target_vcpu->vcpu_id : -1,
+			(irq->target_vcpu) ? irq->target_vcpu->vcpu_idx : -1,
 			pending,
 			irq->line_level,
 			irq->active,
@@ -224,7 +224,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 			irq->mpidr,
 			irq->source,
 			irq->priority,
-			(irq->vcpu) ? irq->vcpu->vcpu_id : -1);
+			(irq->vcpu) ? irq->vcpu->vcpu_idx : -1);
 }
 
 static int vgic_debug_show(struct seq_file *s, void *v)
-- 
2.34.1

