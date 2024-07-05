Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3FE1474A3;
	Fri,  5 Jul 2024 09:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720171921; cv=none; b=KUDpdqsPHQTyKch3p2eDrUOB8z44LuJ6jQ26BqysB6UT9QZyXdr7DyWZXEJFrgMkuSqqXzpc9aoGZMS5bDt8N+IizIfQIRbzhLD4jnakx5Ik/2gaii8/HHJvHoJdTQ3vYhadt6Te2F44kdEhLuuoq/gq1D1XNhcSgd2zmlcEiv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720171921; c=relaxed/simple;
	bh=GJ1I7tTBeFCHTX2tR7t3dckUliPv66ihFKX42pTzlaI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LkoUgbmrNMV0hyb0xgSyvLvCpPad04BnlPALaVpzKfdxKYEOP3+oQO4gvchfYJrAcfGA/zmZsih45wF6Pwt2FDGYbghOWZYLA7ig8YKkQxd1q3Zj3Bo4wJv4JUfC3Ral0fgjjTYewr33y80NiVvP/1RD47cUxegoZoXZS8gOkfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2jpyzUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2jpyzUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CF6C4AF0B;
	Fri,  5 Jul 2024 09:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720171921;
	bh=GJ1I7tTBeFCHTX2tR7t3dckUliPv66ihFKX42pTzlaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2jpyzUXLIecjzta5xVfmWJaZzluULhfveAbqrErKtR46N0Y8mBppf1EjHNHxov7Q
	 cq6t+A5UH1Z2sTt497M6zQHca1S68fiTtTMiDyhZeGjUoa5ScZFuo+JV3nUqPYzU7+
	 lpn50ALL4r5VA7uRZXlkhrsi+lkEhEsbHpLL4RpsaQyfb4ZUvexU9EpRix70XlnLiP
	 v+VDf2XhxedlQh57BMTj1E1/pLN/F9LzcAFrNCd7uikxwxlx+c8lYzK0ROcD3BzBea
	 EcRzV+mZ/SXvGt/xx9xPZzBUWLKfiAUrf1I3h1Yxi+YVBQZnuI1y2qoRQdrHNYN+TL
	 VZ3QDPAzuYw5w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sPfIN-00A0NK-1O;
	Fri, 05 Jul 2024 10:31:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Nianyao Tang <tangnianyao@huawei.com>
Subject: [PATCH 2/3] irqchip/gic-v4: Substitute vmovp_lock for a per-VM lock
Date: Fri,  5 Jul 2024 10:31:54 +0100
Message-Id: <20240705093155.871070-3-maz@kernel.org>
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

vmovp_lock is abused in a number of cases to serialise updates
to vlpi_count[] and deal with map/unmap of a VM to ITSs.

Instead, provide a per-VM lock and revisit the use of vlpi_count[]
so that it is always wrapped in this per-VM vmapp_lock.

This reduces the potential contention on a concurrent VMOVP command,
and paves the way for subsequent VPE locking that holding vmovp_lock
actively prevents due to the lock ordering.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 27 ++++++++++++---------------
 include/linux/irqchip/arm-gic-v4.h |  8 ++++++++
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index a00c5e8c4ea65..b52d60097cad5 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1317,7 +1317,6 @@ static void its_send_vmovp(struct its_vpe *vpe)
 {
 	struct its_cmd_desc desc = {};
 	struct its_node *its;
-	unsigned long flags;
 	int col_id = vpe->col_idx;
 
 	desc.its_vmovp_cmd.vpe = vpe;
@@ -1329,6 +1328,12 @@ static void its_send_vmovp(struct its_vpe *vpe)
 		return;
 	}
 
+	/*
+	 * Protect against concurrent updates of the mapping state on
+	 * individual VMs.
+	 */
+	guard(raw_spinlock_irqsave)(&vpe->its_vm->vmapp_lock);
+
 	/*
 	 * Yet another marvel of the architecture. If using the
 	 * its_list "feature", we need to make sure that all ITSs
@@ -1337,8 +1342,7 @@ static void its_send_vmovp(struct its_vpe *vpe)
 	 *
 	 * Wall <-- Head.
 	 */
-	raw_spin_lock_irqsave(&vmovp_lock, flags);
-
+	guard(raw_spinlock)(&vmovp_lock);
 	desc.its_vmovp_cmd.seq_num = vmovp_seq_num++;
 	desc.its_vmovp_cmd.its_list = get_its_list(vpe->its_vm);
 
@@ -1353,8 +1357,6 @@ static void its_send_vmovp(struct its_vpe *vpe)
 		desc.its_vmovp_cmd.col = &its->collections[col_id];
 		its_send_single_vcommand(its, its_build_vmovp_cmd, &desc);
 	}
-
-	raw_spin_unlock_irqrestore(&vmovp_lock, flags);
 }
 
 static void its_send_vinvall(struct its_node *its, struct its_vpe *vpe)
@@ -1791,12 +1793,10 @@ static bool gic_requires_eager_mapping(void)
 
 static void its_map_vm(struct its_node *its, struct its_vm *vm)
 {
-	unsigned long flags;
-
 	if (gic_requires_eager_mapping())
 		return;
 
-	raw_spin_lock_irqsave(&vmovp_lock, flags);
+	guard(raw_spinlock_irqsave)(&vm->vmapp_lock);
 
 	/*
 	 * If the VM wasn't mapped yet, iterate over the vpes and get
@@ -1814,19 +1814,15 @@ static void its_map_vm(struct its_node *its, struct its_vm *vm)
 			its_send_vinvall(its, vpe);
 		}
 	}
-
-	raw_spin_unlock_irqrestore(&vmovp_lock, flags);
 }
 
 static void its_unmap_vm(struct its_node *its, struct its_vm *vm)
 {
-	unsigned long flags;
-
 	/* Not using the ITS list? Everything is always mapped. */
 	if (gic_requires_eager_mapping())
 		return;
 
-	raw_spin_lock_irqsave(&vmovp_lock, flags);
+	guard(raw_spinlock_irqsave)(&vm->vmapp_lock);
 
 	if (!--vm->vlpi_count[its->list_nr]) {
 		int i;
@@ -1834,8 +1830,6 @@ static void its_unmap_vm(struct its_node *its, struct its_vm *vm)
 		for (i = 0; i < vm->nr_vpes; i++)
 			its_send_vmapp(its, vm->vpes[i], false);
 	}
-
-	raw_spin_unlock_irqrestore(&vmovp_lock, flags);
 }
 
 static int its_vlpi_map(struct irq_data *d, struct its_cmd_info *info)
@@ -3922,6 +3916,8 @@ static void its_vpe_invall(struct its_vpe *vpe)
 {
 	struct its_node *its;
 
+	guard(raw_spinlock_irqsave)(&vpe->its_vm->vmapp_lock);
+
 	list_for_each_entry(its, &its_nodes, entry) {
 		if (!is_v4(its))
 			continue;
@@ -4527,6 +4523,7 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 	vm->db_lpi_base = base;
 	vm->nr_db_lpis = nr_ids;
 	vm->vprop_page = vprop_page;
+	raw_spin_lock_init(&vm->vmapp_lock);
 
 	if (gic_rdists->has_rvpeid)
 		irqchip = &its_vpe_4_1_irq_chip;
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 2c63375bbd43f..ecabed6d33075 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -25,6 +25,14 @@ struct its_vm {
 	irq_hw_number_t		db_lpi_base;
 	unsigned long		*db_bitmap;
 	int			nr_db_lpis;
+	/*
+	 * Ensures mutual exclusion between updates to vlpi_count[]
+	 * and map/unmap when using the ITSList mechanism.
+	 *
+	 * The lock order for any sequence involving the ITSList is
+	 * vmapp_lock -> vpe_lock ->vmovp_lock.
+	 */
+	raw_spinlock_t		vmapp_lock;
 	u32			vlpi_count[GICv4_ITS_LIST_MAX];
 };
 
-- 
2.39.2

