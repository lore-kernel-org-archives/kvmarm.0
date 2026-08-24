Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD2739E9D6
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 07:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557384; cv=none; b=Da7StY1IEw+45UnR1ejcRKA/1ZB+JYRVnhP+oeM8u1Ok33U5klEhOMKQGnKMQodY8z/OWfzFBjqSozWrOwhsu46oSrur4tiuZ/cogdxY0kkMWyKQLuI9fGcvtQoKffzx1wkUr+pLiYeApw3MUCy0ohcJgCyMpg/aeOMJ/YZK8oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557384; c=relaxed/simple;
	bh=DMAf1c7UHhlCupwZA/0QkeFewyx6PmcAOPgc7+1CLxc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mwaRURfab2qrfjsgs1zXCNrTiz4YYpUijmPV8u38Xk3Lv2aaCqxtv0OLUviy+51FCLy+KntYPeRJHj0xmI+DH/TIEMoPzQy0r23IXV35zo/jc3ZNr7giZGH+tsOcotelbKWtJnnDKCUdznt/szcBSRuNFrwwe4zwvL5AsSvy2eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Uf0DEm+X; arc=none smtp.client-ip=95.215.58.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Uf0DEm+X"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=DMAf1c7UHhlCupwZA/0QkeFewyx6PmcAOPgc7+1CLxc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787557379; v=1; x=1788162179;
 b=Uf0DEm+XnIXlEOFOoPd2/ZOLLV6osBajla7iUPqXZHn3779pbmXxIc/LxUHjuNHK6rs/PnMU
 LPxFqzh6R+wM55dUwDjX1Q1mVPpmqicl1l8CkEiaDpGItElLZkOF1mWFNMuJzS5pbVlxPuilHdB
 qST+9hU+BHpAY25w9smieD4Y=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id 3a916f8011f966dc;
	Mon, 24 Aug 2026 07:42:59 +0000
X-Mizu-Trace-ID: 3a916f8011f966dc
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
Subject: [PATCH v2 2/4] irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs() allocated on failure
Date: Mon, 24 Aug 2026 08:42:43 +0100
Message-Id: <20260824074245.710955-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260824074245.710955-1-fuad.tabba@linux.dev>
References: <20260824074245.710955-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A failure in the its_alloc_vcpu_sgis() loop leaves behind both the SGI
domains created for the vPEs below the failing index and the vPE irqs
allocated before the loop, since irq_domain_remove() frees neither. Each
leaked vPE takes its ITS state with it, a vpe_id and an LPI pending
table.

Free both from a second label before the existing unwind. With the
freed pointers now cleared, its_free_sgi_irqs() can skip a vPE with no
SGI domain and be reused there. The check has to precede the lookup:
irq_find_mapping(NULL, 0) falls back to irq_default_domain, and the
live irq it returns would then be freed.

Fixes: 6d31b6ff985d ("irqchip/gic-v4.1: Add VSGI allocation/teardown")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 drivers/irqchip/irq-gic-v4.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 754839e409f88..f707a3cb281aa 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -159,6 +159,8 @@ static int its_alloc_vcpu_sgis(struct its_vpe *vpe, int idx)
 	return -ENOMEM;
 }
 
+static void its_free_sgi_irqs(struct its_vm *vm);
+
 int its_alloc_vcpu_irqs(struct its_vm *vm)
 {
 	int vpe_base_irq, i;
@@ -189,11 +191,14 @@ int its_alloc_vcpu_irqs(struct its_vm *vm)
 		vm->vpes[i]->irq = vpe_base_irq + i;
 		ret = its_alloc_vcpu_sgis(vm->vpes[i], i);
 		if (ret)
-			goto err;
+			goto err_free_irqs;
 	}
 
 	return 0;
 
+err_free_irqs:
+	its_free_sgi_irqs(vm);
+	irq_domain_free_irqs(vpe_base_irq, vm->nr_vpes);
 err:
 	if (vm->domain) {
 		irq_domain_remove(vm->domain);
@@ -215,8 +220,13 @@ static void its_free_sgi_irqs(struct its_vm *vm)
 		return;
 
 	for (i = 0; i < vm->nr_vpes; i++) {
-		unsigned int irq = irq_find_mapping(vm->vpes[i]->sgi_domain, 0);
+		unsigned int irq;
 
+		/* irq_find_mapping() falls back to the default domain on NULL. */
+		if (!vm->vpes[i]->sgi_domain)
+			continue;
+
+		irq = irq_find_mapping(vm->vpes[i]->sgi_domain, 0);
 		if (WARN_ON(!irq))
 			continue;
 
-- 
2.39.5

