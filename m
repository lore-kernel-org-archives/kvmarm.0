Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB8E145B27;
	Fri,  5 Jul 2024 09:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720171921; cv=none; b=qEIyiF84YWXZcNyX4hVMn0bvHaON5NIBFpbjsA4tFdxX+roqZ/5JMr7qhFzmcHWoIGdazIxGL/b02+MwCxORdW68RVowx9CUMRlPwV7UMoLCnlAbfWkH2R2zi35za4DQbM3s7Nx9lt3OXdj51UmSoFW/qjmSkCCNrVdZxe5/VII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720171921; c=relaxed/simple;
	bh=nzaJSHHvHLH4tw2NS88X2blB90LpkIyqdRotWeSvNdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QqdQTGTDMtPpiccs39Wq4qtPuLcUKin/v4GztP+FNhnn9BI0No0MoAuuIfKQrlhwUaRYWIURPsWdI/etbUoomZiLYcHZ2mNDbD+ZnIDJQ+PVZ3S/DqxaiPsPIdJGirQ77tYzqGlru6RbnT2F61Ibt+BMabDr76bVlemhdc8tSQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1x7D6Tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1x7D6Tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5DCC32781;
	Fri,  5 Jul 2024 09:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720171921;
	bh=nzaJSHHvHLH4tw2NS88X2blB90LpkIyqdRotWeSvNdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1x7D6TbGvzN0orBc1T5rVFA9zBXP6ySBl1DRMs7OBq2jTKIh0HogJS+qy1CWoK3v
	 xTF52gz5KHoVCuVE8tdni+gUbp8I5nmK86yaUe4dDDPtTfkDHSdidv0iy8xRw4sKPO
	 /LCG/9aQb8iD623oAja57AtHxuKPhi6PUZbda6WNo+GmQyTo8MFu1pUs3tHNLvTZM4
	 CAkrqJRTnbYPl9oQv3EVtM36SyhFvz7SbNAjr/J5SEfnTCqwZZF7G76j/MFwk7PSvf
	 GDilttOWS7Dft3HUfLPLjxh6LyyGiY5CiP6+ek/xv75zUtVnYfNLmXZoRQ3rbtbxz7
	 BeCz/wkr9ojBA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sPfIM-00A0NK-PY;
	Fri, 05 Jul 2024 10:31:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Nianyao Tang <tangnianyao@huawei.com>
Subject: [PATCH 1/3] irqchip/gic-v4: Always configure affinity on VPE activation
Date: Fri,  5 Jul 2024 10:31:53 +0100
Message-Id: <20240705093155.871070-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240705093155.871070-1-maz@kernel.org>
References: <20240705093155.871070-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, tangnianyao@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently have two paths to set the initial affinity of a VPE:

- at activation time on GICv4 without the stupid VMOVP list, and
  on GICv4.1

- at map time for GICv4 with VMOVP list

The latter location may end-up modifying the affinity of VPE
that is currently running, making the results unpredictible.

Instead, unify the two paths, making sure we only set the
initial affinity at activation time.

Reported-by: Nianyao Tang <tangnianyao@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 3c755d5dad6e6..a00c5e8c4ea65 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1809,13 +1809,9 @@ static void its_map_vm(struct its_node *its, struct its_vm *vm)
 
 		for (i = 0; i < vm->nr_vpes; i++) {
 			struct its_vpe *vpe = vm->vpes[i];
-			struct irq_data *d = irq_get_irq_data(vpe->irq);
 
-			/* Map the VPE to the first possible CPU */
-			vpe->col_idx = cpumask_first(cpu_online_mask);
 			its_send_vmapp(its, vpe, true);
 			its_send_vinvall(its, vpe);
-			irq_data_update_effective_affinity(d, cpumask_of(vpe->col_idx));
 		}
 	}
 
@@ -4562,6 +4558,10 @@ static int its_vpe_irq_domain_activate(struct irq_domain *domain,
 	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
 	struct its_node *its;
 
+	/* Map the VPE to the first possible CPU */
+	vpe->col_idx = cpumask_first(cpu_online_mask);
+	irq_data_update_effective_affinity(d, cpumask_of(vpe->col_idx));
+
 	/*
 	 * If we use the list map, we issue VMAPP on demand... Unless
 	 * we're on a GICv4.1 and we eagerly map the VPE on all ITSs
@@ -4570,9 +4570,6 @@ static int its_vpe_irq_domain_activate(struct irq_domain *domain,
 	if (!gic_requires_eager_mapping())
 		return 0;
 
-	/* Map the VPE to the first possible CPU */
-	vpe->col_idx = cpumask_first(cpu_online_mask);
-
 	list_for_each_entry(its, &its_nodes, entry) {
 		if (!is_v4(its))
 			continue;
@@ -4581,8 +4578,6 @@ static int its_vpe_irq_domain_activate(struct irq_domain *domain,
 		its_send_vinvall(its, vpe);
 	}
 
-	irq_data_update_effective_affinity(d, cpumask_of(vpe->col_idx));
-
 	return 0;
 }
 
-- 
2.39.2

