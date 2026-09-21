Received: from mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCB43F54D2
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 07:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975819; cv=none; b=tAO3AV3lyL4i0pM2Mm5GOFXH9f7p9qfkrhrI0O8/N/zfrrvpjYgd2n9HqCj0fuVQ3hHCoFh27T4SeAiavCe36UnZirogYVG8ksouDK6JRdeILJrrrHBxBV/YCJdjVlrTezQBldrvJdVsSGwm1Sxr2BiHo+EAqaoMElSW/r2CajQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975819; c=relaxed/simple;
	bh=YRjrdcXSvz0c+tqwc5MA976Iks7cA0z99Etwh6VpwMA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=grnarxKAEHM8ksQckOrPDZU0glSlVCJDoHfb/S4wWFtlgwXWXONiX7qDt3sc7bHL7bXmEPVfE1HBZyH2FCIxZMj0qv6lhn1rps14aa0ecEk37/3dFcyfhH2+pD65VxN3xvegIEb9EQg1AqSFE2Bbk9DBexfU+hSJxp9lVIoXKuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DaDljx4u; arc=none smtp.client-ip=91.218.175.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DaDljx4u"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=YRjrdcXSvz0c+tqwc5MA976Iks7cA0z99Etwh6VpwMA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789975810; v=1; x=1790580610;
 b=DaDljx4uFs92xDoGEgm5aWvJGBdl3MXVab8XdwtYH7wesR+RFrmQ70PpCGT2q1FjZCQ8pM94
 riYTtkzE/RY9FKYCvk8Iy/W8g/nzz+0MkdDw+OKQmKWko6Sqhhdh+Q6+gheFw9m2PZsQrZ/0i4Y
 pucYo+zoYVwUicM2oNFihRf4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5b3602680922a617;
	Mon, 21 Sep 2026 07:30:07 +0000
X-Mizu-Trace-ID: 5b3602680922a617
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
Subject: [PATCH v3 2/4] irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs() allocated on failure
Date: Mon, 21 Sep 2026 08:29:56 +0100
Message-Id: <20260921072958.2918477-3-fuad.tabba@linux.dev>
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
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
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

