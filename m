Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB3137F756;
	Wed,  8 Apr 2026 11:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647992; cv=none; b=aqwK3NG4w85DR8g4qaOAOt5U2yk4WnHf0jimX88f5PhCKX2C1kbym0bsrAozmQd//KqdVAqpusAaf0PXcfVSDu1dPsbz6o3srGjHTm5cfh44CBSk6Cz5QOXMEpTnc8DdtYEwf0UJ2l0DnfgTj36PGvpd0OA87tQBIzAZdAZdkb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647992; c=relaxed/simple;
	bh=UB7cLBYqceVznXKOfj0+CXRY3qoVhyFhBa9zIpOB3fA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogF7MSuuT2ZocCTv4HBdIcRYDfv5DrnDzVuxp7ODCfcNlVvfIehZzAqf6Cf6rMddOTkbntvtdsW0IoeJEvknt71FvwkV8Ct+lJqFvqfTu4EEo7TcNnG+1OC9Wbl1FDDxUhj92HX7VazQe5bFJ4TBAvvMUZVOzvZEB13gp2eiPVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Uzlv0WHM; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Uzlv0WHM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Reply-To:
	Cc:Content-Type:Content-ID:Content-Description;
	bh=H3hFAFNcslxpDg/Ul/EXFDtViLZPEKgFNWJWexTFvTs=; b=Uzlv0WHMQeMPAolhX7GOLp61L8
	tzrAwwklgCiomobfcC9Nm8i2lGEknMyZCNCe7KGOCNjxQkVocOQvdTC7cFA2PHA9gRjJm9JRu5A6t
	MugVEeE6lD2hTlmTZhvhQubMTHqmPsPMXY07OO2CuH6YFrsburzebjfIX0sCpLlfEk28POsL++yNa
	4iXgRaO7uEBx+0MwFoQgr0DWB8CUxW+Kx+jdYC/7XbnY2ff2dZ4QRpqs/ALbEQHxUAafQ/AWqsN30
	EycDYQVvSFAwNLg3RpZSv5hOYp0vnmbhjyQ6XZqZD5lOJCFfQa9XvRhJX9ymxcQwxbEghSPaERpeJ
	KGDoOcVA==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAR9V-00000005Ieq-2izT;
	Wed, 08 Apr 2026 11:32:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAR9V-00000008nA3-1PDi;
	Wed, 08 Apr 2026 12:32:57 +0100
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
Subject: [PATCH v2 2/5] KVM: arm64: vgic: Allow userspace to set IIDR revision 1
Date: Wed,  8 Apr 2026 12:30:33 +0100
Message-ID: <20260408113256.2095505-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260408113256.2095505-1-dwmw2@infradead.org>
References: <20260408113256.2095505-1-dwmw2@infradead.org>
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
vgic_mmio_write_group() and suppressing writes when the revision is
below 2. The read side needs no change since the per-IRQ group reset
values already match the expected behaviour.

Note that d53c2c29ae0d wired guest IGROUPR writes directly to
vgic_mmio_write_group() without any revision check, while only gating
the userspace write path via v2_groups_user_writable. This meant a
guest could modify interrupt groups even at revision 1, which was
never intended. The write_group revision check fixes both the guest
and GICv3 userspace paths.

Fixes: d53c2c29ae0d ("KVM: arm/arm64: vgic: Allow configuration of interrupt groups")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/arm64/kvm/vgic/vgic-mmio-v2.c | 3 +++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 4 ++++
 arch/arm64/kvm/vgic/vgic-mmio.c    | 4 ++++
 include/kvm/arm_vgic.h             | 1 +
 4 files changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index 0643e333db35..e5714f7fd2ec 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -20,6 +20,7 @@
  * Revision 1: Report GICv2 interrupts as group 0 instead of group 1
  * Revision 2: Interrupt groups are guest-configurable and signaled using
  * 	       their configured groups.
+ * Revision 3: GICv2 behaviour is unchanged from revision 2.
  */
 
 static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
@@ -96,6 +97,8 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
 		case KVM_VGIC_IMP_REV_2:
 		case KVM_VGIC_IMP_REV_3:
 			vcpu->kvm->arch.vgic.v2_groups_user_writable = true;
+			fallthrough;
+		case KVM_VGIC_IMP_REV_1:
 			dist->implementation_rev = reg;
 			return 0;
 		default:
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
index a573b1f0c6cb..4fbe0ad22adf 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -73,6 +73,10 @@ void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
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

