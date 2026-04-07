Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D9337AA82;
	Tue,  7 Apr 2026 21:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775596210; cv=none; b=OsSK6OAPeuiZPfPLIe5qBLm5EMDsvFefMA2z7wGGPdHo/DObHyTEVg6lVIhDw+HJozbBSgXbvzk8L3XLtNN484ony3HMjw0XXo+oyY5L6GGcgmY1gjG4uEANyDTWXWIAGQe8umwnVxN0gtwZ9xU95PyJ61+XNUnr4Z7xt5s6I2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775596210; c=relaxed/simple;
	bh=lH1xONMurjI8VuImvaz/o871XJjqcEmhhoQcyh+xb88=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRSud7o99WOwaYpRg+NiWJm5SB/aYbMB7UNT9eA7mj/kzP3etudhm3D2V5V1rktM6A/5uX6ydbbx814GrLSD2vqaVsiH6vhsGSIYKb4cQ3EvEbz9kxoMpZdA3cIcfjuxFvDacVvcQTM7kCMvkqe7JP6hGzxq3L4zSwjLIzVtBF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZV3n1nKq; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZV3n1nKq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Reply-To:
	Cc:Content-Type:Content-ID:Content-Description;
	bh=1cngJlnIlPxMsTV4SXm02aZ7wJ4Q9rU8NrxN7v94io8=; b=ZV3n1nKqH48ExdKXkA56lqEqgz
	YX2I6uzyquwqXj1doPwXw7hRQsduWM1eTOYsrxPstKcZXPCpfLvJI9i41s6q8h33cECTzu5RgrOWM
	ev5nqmCozbs1FD5EGojR7Ak2Le7olTXi+PYu+OHmY3p2IsYfImaqiG2OAh9o6rcJZsbaBOCZGHnxE
	8QHX/3ULjj6YBCvVCwE6YFmqskvixkpl7EPLgN5b2ZJjivA5ejp89vSi+qLABOqnfPIR9Mm32ksl0
	S79ZRQIc0UGUzoM/0UDLh6Xnxggvn8CimCDiWwos4ktbCSI9VypxF2trrcLRzvtbSkLh/ZdOWIYIs
	07mEiyCw==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wADgI-00000004GbA-3bHu;
	Tue, 07 Apr 2026 21:09:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wADgI-00000008iIB-20Dt;
	Tue, 07 Apr 2026 22:09:54 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 2/3] KVM: arm64: vgic: Allow userspace to set IIDR revision 1
Date: Tue,  7 Apr 2026 21:27:03 +0100
Message-ID: <20260407210949.2076251-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260407210949.2076251-1-dwmw2@infradead.org>
References: <20260407210949.2076251-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Allow userspace to select GICD_IIDR revision 1, which restores the
original pre-d53c2c29ae0d ("KVM: arm/arm64: vgic: Allow configuration
of interrupt groups") behaviour where interrupt groups are not
guest-configurable.

When revision 1 is selected:
 - GICv2: IGROUPR reads as zero (group 0), writes are ignored
 - GICv3: IGROUPR reads as all-ones (group 1), writes are ignored
 - v2_groups_user_writable is not set

This is implemented by checking the implementation revision in
vgic_mmio_read_group() and vgic_mmio_write_group() and returning
the fixed values when the revision is below 2.

Fixes: d53c2c29ae0d ("KVM: arm/arm64: vgic: Allow configuration of interrupt groups")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  5 +++++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  4 ++++
 arch/arm64/kvm/vgic/vgic-mmio.c    | 15 +++++++++++++++
 include/kvm/arm_vgic.h             |  1 +
 4 files changed, 25 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index 0643e333db35..14aa49f86f60 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -20,6 +20,8 @@
  * Revision 1: Report GICv2 interrupts as group 0 instead of group 1
  * Revision 2: Interrupt groups are guest-configurable and signaled using
  * 	       their configured groups.
+ * Revision 3: GICv2 behaviour is unchanged from revision 2.
+ * 	       (GICv3 gains GICR_CTLR.{IR,CES}; see vgic-mmio-v3.c)
  */
 
 static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
@@ -93,6 +95,9 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
 		 */
 		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, val);
 		switch (reg) {
+		case KVM_VGIC_IMP_REV_1:
+			dist->implementation_rev = reg;
+			return 0;
 		case KVM_VGIC_IMP_REV_2:
 		case KVM_VGIC_IMP_REV_3:
 			vcpu->kvm->arch.vgic.v2_groups_user_writable = true;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5913a20d8301..0130db71cfc9 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -74,8 +74,11 @@ bool vgic_supports_direct_sgis(struct kvm *kvm)
 /*
  * The Revision field in the IIDR have the following meanings:
  *
+ * Revision 1: Interrupt groups are not guest-configurable.
+ * 	       IGROUPR reads as all-ones (group 1), writes ignored.
  * Revision 2: Interrupt groups are guest-configurable and signaled using
  * 	       their configured groups.
+ * Revision 3: GICR_CTLR.{IR,CES} are advertised.
  */
 
 static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
@@ -196,6 +199,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 
 		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, val);
 		switch (reg) {
+		case KVM_VGIC_IMP_REV_1:
 		case KVM_VGIC_IMP_REV_2:
 		case KVM_VGIC_IMP_REV_3:
 			dist->implementation_rev = reg;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index a573b1f0c6cb..9eb95f13b9b6 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -48,6 +48,17 @@ unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu,
 	u32 value = 0;
 	int i;
 
+	/*
+	 * Revision 1 and below: groups are not guest-configurable.
+	 * GICv2 reports all interrupts as group 0 (RAZ).
+	 * GICv3 reports all interrupts as group 1 (RAO).
+	 */
+	if (vgic_get_implementation_rev(vcpu) < KVM_VGIC_IMP_REV_2) {
+		if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+			return -1UL;
+		return 0;
+	}
+
 	/* Loop over all IRQs affected by this read */
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
@@ -73,6 +84,10 @@ void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
 	int i;
 	unsigned long flags;
 
+	/* Revision 1 and below: groups are not guest-configurable. */
+	if (vgic_get_implementation_rev(vcpu) < KVM_VGIC_IMP_REV_2)
+		return;
+
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, intid + i);
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f2eafc65bbf4..90fb6cd3c91c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -248,6 +248,7 @@ struct vgic_dist {
 
 	/* Implementation revision as reported in the GICD_IIDR */
 	u32			implementation_rev;
+#define KVM_VGIC_IMP_REV_1	1 /* GICv2 interrupts as group 0 */
 #define KVM_VGIC_IMP_REV_2	2 /* GICv2 restorable groups */
 #define KVM_VGIC_IMP_REV_3	3 /* GICv3 GICR_CTLR.{IW,CES,RWP} */
 #define KVM_VGIC_IMP_REV_LATEST	KVM_VGIC_IMP_REV_3
-- 
2.51.0

