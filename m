Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FFECA51
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 09:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91DAC433CC;
	Wed, 27 Sep 2023 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695805759;
	bh=SukBelkNld/+KfqGlJLCx5XPqjafNh6F4NcPqIZXwU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rghtXBWVKJRbpfGhFi8TLYbKl0gGAIJLlH1aDbrapIl/9QI2mOKO9Y3jVF6wAlVwm
	 brFbg/PHCy8mTmJiTms0x38JG+GNhWb9VWkSTrjH+0zpMLnZ+Hb3j91xYt9expM+Rd
	 cCGjgQb1YXBB6VWw/SxKxtav3duiFtp3LmrEoUN9oGIcdXK60dmctkVOLClbqyrqyA
	 CtuCJwa6BBundM4TI6fVxCsNa5lNoxBxtWZZRpubOOuSxr8w07AL7tCHqKsjPNMi49
	 r8ukiv1npMIHxPPXLdRIsVn0OQWFql/sDs3fN4pwy6Hl3HmgEHFv2Xmh2vqOtlHIs4
	 80W0JbWIZpdPQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qlQXl-00GaLb-Cp;
	Wed, 27 Sep 2023 10:09:17 +0100
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
Subject: [PATCH v3 05/11] KVM: arm64: vgic: Use vcpu_idx for the debug information
Date: Wed, 27 Sep 2023 10:09:05 +0100
Message-Id: <20230927090911.3355209-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927090911.3355209-1-maz@kernel.org>
References: <20230927090911.3355209-1-maz@kernel.org>
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

When dumping the debug information, use vcpu_idx instead of vcpu_id,
as this is independent of any userspace influence.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
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

