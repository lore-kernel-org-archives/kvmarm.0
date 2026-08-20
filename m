Received: from mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8578F40B6C9
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 12:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787230264; cv=none; b=Ub4c98M9rqFNCBPzFZATI+boFCryr4NecuGYigPJP9fO0eVLIW1L9CPsBCSI3qGsjJykjs1hKfaKW6j2Kgt9gJ7vbQKK49BKGoegt4S1u5no1dPj6DChrjKOYnYUNDt5tBdhWaKXLVDnqSUE0QFrkjr6aAMjq52ZjQdft4KwdhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787230264; c=relaxed/simple;
	bh=tLmq2HrjLCESAVz5nI7NICH8bUrsH/OHxKa8Tyxl6MQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PloAZqDJ1tl2nUS+RlRGhS3NrIrs8S6/VtA8iPbDq3ct7TEbVIRtBpnARhIyE/7TT+CkO2T5s8jeFCvj35dtTKOVSC13fWTgKCN96OoCBDs4TfKcDg7JwcBF43I9shL4rTI2aEXoIYiEXSRPfBesrkVzGP/N7ooVHHk1byuDJy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=izz7ATC+; arc=none smtp.client-ip=95.215.58.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="izz7ATC+"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=tLmq2HrjLCESAVz5nI7NICH8bUrsH/OHxKa8Tyxl6MQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787230258; v=1; x=1787835058;
 b=izz7ATC+WN/k4xaVA5ScrcFYWmZkeeW6+U8AKugYk1SaPxiq3PKdaRDNr7h+CpkZXGQg4Cpp
 wYwEr2+p3hd6Z6RhSzjWk1Isc98ke9lqc0t6UARODgvjWU7036ILYOYBx1i86NbJkxLawvrY62w
 8QQJ4esOKPRTZQY0c2YGsafk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id a3afca9ef7e413da;
	Thu, 20 Aug 2026 12:50:58 +0000
X-Mizu-Trace-ID: a3afca9ef7e413da
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
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] irqchip/gic-v4: Clear the domain and fwnode pointers after freeing them
Date: Thu, 20 Aug 2026 13:50:51 +0100
Message-Id: <20260820125053.2951078-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260820125053.2951078-1-fuad.tabba@linux.dev>
References: <20260820125053.2951078-1-fuad.tabba@linux.dev>
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

