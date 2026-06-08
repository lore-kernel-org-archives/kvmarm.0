Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6723F4DCE;
	Mon,  8 Jun 2026 14:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929811; cv=none; b=aJh15OEIXCBpHoJOdgIDr10+AeDif9dg8Lbp489g8dJlfWF4hQzC+xypyy5OZzFeLja9bqCwhPSEMB5dvQadp+pMziho/QYvQ7nuIbOaPfq1Q0OE7g+pVO0TxRk0PfRUsv/Quarsm+k9mBc3CVcJoNnKIdKSRi2iABA898HApyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929811; c=relaxed/simple;
	bh=F02lYJzbyOlPLmx72TZVwtvZBBZwfMakGfpwggkLVQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rd4ZiBsAaiKGGytR0Gu3FABGj/6ma1j8x0F5qOhrD4L38xG1ICUgkmNd8Mau/LhGtAbK17qxwMWKzpBX+6BwIcJ08tisoMzGpjNCkrtTom3ODrT3hOm21jwSqSv4H4KXnivWTUpVq2hK7Y4dUI8KjNUcrUYNIwsEBJm8IUQ358c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 0BE7C2028C8;
	Mon,  8 Jun 2026 16:43:13 +0200 (CEST)
From: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com
Subject: [PATCH 37/60] kvm: Pass plane_level to kvm_set_routing_entry()
Date: Mon,  8 Jun 2026 16:42:29 +0200
Message-ID: <20260608144252.351443-38-joro@8bytes.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608144252.351443-1-joro@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <joerg.roedel@amd.com>

The plane_level is used to route MSI IRQs to the correct plane.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/arm64/kvm/vgic/vgic-irqfd.c | 6 ++++--
 arch/loongarch/kvm/irqfd.c       | 6 ++++--
 arch/powerpc/kvm/mpic.c          | 5 +++--
 arch/riscv/kvm/vm.c              | 5 +++--
 arch/s390/kvm/interrupt.c        | 3 ++-
 arch/x86/kvm/irq.c               | 7 ++++---
 include/linux/kvm_host.h         | 3 ++-
 virt/kvm/irqchip.c               | 2 +-
 8 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index 479b896c8954..53e5fcc591d7 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -33,11 +33,13 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
  * @kvm: the VM this entry is applied to
  * @e: kvm kernel routing entry handle
  * @ue: user api routing entry handle
+ * @plane_level: target plane level
  * return 0 on success, -EINVAL on errors.
  */
 int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
-			  const struct kvm_irq_routing_entry *ue)
+			  const struct kvm_irq_routing_entry *ue,
+			  unsigned plane_level)
 {
 	int r = -EINVAL;
 
@@ -57,7 +59,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->msi.data = ue->u.msi.data;
 		e->msi.flags = ue->flags;
 		e->msi.devid = ue->u.msi.devid;
-		e->msi.plane_level = 0;
+		e->msi.plane_level = plane_level;
 		break;
 	default:
 		goto out;
diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
index 50f0c32df46c..a36a8a9d8a66 100644
--- a/arch/loongarch/kvm/irqfd.c
+++ b/arch/loongarch/kvm/irqfd.c
@@ -39,11 +39,13 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
  * @kvm: the VM this entry is applied to
  * @e: kvm kernel routing entry handle
  * @ue: user api routing entry handle
+ * @plane_level: target plane level
  * return 0 on success, -EINVAL on errors.
  */
 int kvm_set_routing_entry(struct kvm *kvm,
 			struct kvm_kernel_irq_routing_entry *e,
-			const struct kvm_irq_routing_entry *ue)
+			const struct kvm_irq_routing_entry *ue,
+			unsigned plane_level)
 {
 	switch (ue->type) {
 	case KVM_IRQ_ROUTING_IRQCHIP:
@@ -60,7 +62,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->msi.address_lo = ue->u.msi.address_lo;
 		e->msi.address_hi = ue->u.msi.address_hi;
 		e->msi.data = ue->u.msi.data;
-		e->msi.plane_level = 0;
+		e->msi.plane_level = plane_level;
 		return 0;
 	default:
 		return -EINVAL;
diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
index 0f568f5fff8b..6b6eba7fbf75 100644
--- a/arch/powerpc/kvm/mpic.c
+++ b/arch/powerpc/kvm/mpic.c
@@ -1824,7 +1824,8 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 
 int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
-			  const struct kvm_irq_routing_entry *ue)
+			  const struct kvm_irq_routing_entry *ue,
+			  unsigned plane_level)
 {
 	int r = -EINVAL;
 
@@ -1841,7 +1842,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->msi.address_lo = ue->u.msi.address_lo;
 		e->msi.address_hi = ue->u.msi.address_hi;
 		e->msi.data = ue->u.msi.data;
-		e->msi.plane_level = 0;
+		e->msi.plane_level = plane_level;
 		break;
 	default:
 		goto out;
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index f518247e699b..6b3c8a0e74e2 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -118,7 +118,8 @@ bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
 
 int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
-			  const struct kvm_irq_routing_entry *ue)
+			  const struct kvm_irq_routing_entry *ue,
+			  unsigned plane_level)
 {
 	int r = -EINVAL;
 
@@ -138,7 +139,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->msi.data = ue->u.msi.data;
 		e->msi.flags = ue->flags;
 		e->msi.devid = ue->u.msi.devid;
-		e->msi.plane_level = 0;
+		e->msi.plane_level = plane_level;
 		break;
 	default:
 		goto out;
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 1d66ef9f7527..dbd6029773aa 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2862,7 +2862,8 @@ void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
 
 int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
-			  const struct kvm_irq_routing_entry *ue)
+			  const struct kvm_irq_routing_entry *ue,
+			  unsigned plane_level)
 {
 	const struct kvm_irq_routing_s390_adapter *adapter;
 	u64 uaddr_s, uaddr_i;
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b7e08eddb765..d2ecfd54d57a 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -295,7 +295,8 @@ bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
 
 int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
-			  const struct kvm_irq_routing_entry *ue)
+			  const struct kvm_irq_routing_entry *ue,
+			  unsigned plane_level)
 {
 	/* We can't check irqchip_in_kernel() here as some callers are
 	 * currently initializing the irqchip. Other callers should therefore
@@ -304,7 +305,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 	switch (ue->type) {
 #ifdef CONFIG_KVM_IOAPIC
 	case KVM_IRQ_ROUTING_IRQCHIP:
-		if (irqchip_split(kvm))
+		if (irqchip_split(kvm) || plane_level != 0)
 			return -EINVAL;
 		e->irqchip.pin = ue->u.irqchip.pin;
 		switch (ue->u.irqchip.irqchip) {
@@ -332,7 +333,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->msi.address_lo = ue->u.msi.address_lo;
 		e->msi.address_hi = ue->u.msi.address_hi;
 		e->msi.data = ue->u.msi.data;
-		e->msi.plane_level = 0;
+		e->msi.plane_level = plane_level;
 
 		if (kvm_msi_route_invalid(kvm, e))
 			return -EINVAL;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 16dcca3132d3..cfb6911d6771 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2355,7 +2355,8 @@ int kvm_set_irq_routing(struct kvm *kvm,
 int kvm_init_irq_routing(struct kvm *kvm);
 int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
-			  const struct kvm_irq_routing_entry *ue);
+			  const struct kvm_irq_routing_entry *ue,
+			  unsigned plane_level);
 void kvm_free_irq_routing(struct kvm *kvm);
 
 #else
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index ae47e56176f1..14480d1df4f9 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -146,7 +146,7 @@ static int setup_routing_entry(struct kvm *kvm,
 
 	e->gsi = gsi;
 	e->type = ue->type;
-	r = kvm_set_routing_entry(kvm, e, ue);
+	r = kvm_set_routing_entry(kvm, e, ue, 0);
 	if (r)
 		return r;
 	if (e->type == KVM_IRQ_ROUTING_IRQCHIP)
-- 
2.53.0

