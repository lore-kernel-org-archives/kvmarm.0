Received: from mta0.migadu.com (out-219.mta0.migadu.com [91.218.175.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB013F65E0
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 07:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975815; cv=none; b=r1NOraacsiSiSWjGGr3WVEj7cEDgYpeCkLg/g/fhhB7ZNMaCq6WY0hzIxKhEvm6TWlxllDeZN/atoD7VhfwdR5nNyXooYlDyRQeuVvXnHNZTYm89fLm5qz/HLL3kgha8S/IkMxbSLHNy4PlUDjA+sEmLsRxZh4yZgUT/+o5wobg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975815; c=relaxed/simple;
	bh=nEDmvpsFQHvopfMtsbrOfCA7ee7FniKC/B0/dYc8A2o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a2NJdBtwlVBwWBQr+3GBxq+wlkpInHYF8553vZRJCbPpnjHO29OucfNQDd5u6SXj6IflJkJhJ2NTfKkGVOnxh9dPY60ywTNRxBtYRa8Q9MASV6fQeFCSh1lkAYtnC7Sv9SQM9+PuQwwVCGppnEqSfU6PJ7BjexUWCaoXyBXS2Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aBnx3md7; arc=none smtp.client-ip=91.218.175.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aBnx3md7"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=nEDmvpsFQHvopfMtsbrOfCA7ee7FniKC/B0/dYc8A2o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789975806; v=1; x=1790580606;
 b=aBnx3md7Yrlx3qyh2vn6oF1yCjS3pHaVvTWSE4apgWbz9Ep8SYvWdmz42z2k1ap2MmVWBrsi
 rndUppOpfFRYFEuWsJeexMYr1c+sF9jIX7jBi/9YnfObiY1naKzdv3Lhk5T72i8nQnbw2r+EjzC
 k1lW6xs2XgvTc/bvkPdwLglg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a323088f969dfdb3;
	Mon, 21 Sep 2026 07:30:04 +0000
X-Mizu-Trace-ID: a323088f969dfdb3
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] irqchip/gic-v4: Clear the domain and fwnode pointers after freeing them
Date: Mon, 21 Sep 2026 08:29:55 +0100
Message-Id: <20260921072958.2918477-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260921072958.2918477-1-fuad.tabba@linux.dev>
References: <20260921072958.2918477-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The GICv4 allocation and teardown paths free their irq domains and
fwnodes but leave the pointers set, and the allocation error paths test
those pointers before removing them. struct its_vm and struct its_vpe
are embedded in KVM's per-VM and per-vCPU state, so nothing re-zeroes
them between two attempts, and an error path taken after an earlier one
already freed the domain calls irq_domain_remove() on freed memory.

Reaching this takes two allocation failures, one to leave the stale
pointer behind and one to send the next attempt down the error path.

Fixes: 7de5c0af9c7c ("irqchip/gic-v4: Add per-VM VPE domain creation")
Fixes: 6d31b6ff985d ("irqchip/gic-v4.1: Add VSGI allocation/teardown")
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 drivers/irqchip/irq-gic-v4.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 8455b4a5fbb0d..754839e409f88 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -147,10 +147,14 @@ static int its_alloc_vcpu_sgis(struct its_vpe *vpe, int idx)
 	return 0;
 
 err:
-	if (vpe->sgi_domain)
+	if (vpe->sgi_domain) {
 		irq_domain_remove(vpe->sgi_domain);
-	if (vpe->fwnode)
+		vpe->sgi_domain = NULL;
+	}
+	if (vpe->fwnode) {
 		irq_domain_free_fwnode(vpe->fwnode);
+		vpe->fwnode = NULL;
+	}
 	kfree(name);
 	return -ENOMEM;
 }
@@ -191,10 +195,14 @@ int its_alloc_vcpu_irqs(struct its_vm *vm)
 	return 0;
 
 err:
-	if (vm->domain)
+	if (vm->domain) {
 		irq_domain_remove(vm->domain);
-	if (vm->fwnode)
+		vm->domain = NULL;
+	}
+	if (vm->fwnode) {
 		irq_domain_free_fwnode(vm->fwnode);
+		vm->fwnode = NULL;
+	}
 
 	return -ENOMEM;
 }
@@ -215,6 +223,8 @@ static void its_free_sgi_irqs(struct its_vm *vm)
 		irq_domain_free_irqs(irq, 16);
 		irq_domain_remove(vm->vpes[i]->sgi_domain);
 		irq_domain_free_fwnode(vm->vpes[i]->fwnode);
+		vm->vpes[i]->sgi_domain = NULL;
+		vm->vpes[i]->fwnode = NULL;
 	}
 }
 
@@ -224,6 +234,8 @@ void its_free_vcpu_irqs(struct its_vm *vm)
 	irq_domain_free_irqs(vm->vpes[0]->irq, vm->nr_vpes);
 	irq_domain_remove(vm->domain);
 	irq_domain_free_fwnode(vm->fwnode);
+	vm->domain = NULL;
+	vm->fwnode = NULL;
 }
 
 static int its_send_vpe_cmd(struct its_vpe *vpe, struct its_cmd_info *info)
-- 
2.39.5

