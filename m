Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C2638CFFA;
	Wed,  8 Apr 2026 11:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647991; cv=none; b=rVxcI0sPx29RCaze4QbKzMG5KuOYamcO7c7SCZxn2NKmaRzD7QdfS6J8HNR5pFDFn2sLieJTTeUaFbnbROu+/Y3n6alJCX2zkhHAhHzTRFvhdLXF0a4aSxMlCwv+qBNhg8ZSmjtNBY1Yppl123tli6+zdCefoMUQMOLmAjJ7Mf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647991; c=relaxed/simple;
	bh=mdwRDp8YLqgumiXdhHRNN3fKMkEcUchvcvqPUCSB9p8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SphRKJZKsYfVvw2e01lZgvDMMeDRFqNQsD5JCYV7osZKS/Q/3H16QmTq14fF5nqNhor7t+bfqBL9iOG1cDwIX8Jq45tlaG9ahIB2M/Lrn7ZBrAFZVPhVrK0GkVI5PqKRLtqcrqJt8PWImEsPlbc+9DCvbsBPdAXnHcmpum+84w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eUcfCmZx; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eUcfCmZx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Reply-To:
	Cc:Content-Type:Content-ID:Content-Description;
	bh=9Od+JVLkp+gy2eU3w9akPPssxGqEG5+BPOep9rVB8SM=; b=eUcfCmZxOJRbp/50bNSr4dhzOS
	ylmTygzOZdaxyXJObExOptwY3MV2Ll+7uRhc36T0x/9nYl0SU/55kTWPhOTrR95g262r9rmCGchkA
	GJwXFLsRYGWWhlwAGywIpvqvrrLpg9nZsOmdSLpBTNtmBaGPz5Zg/i2X6CPp02aRgx9cOEumtL6+z
	W1OmQU3jNd4JSu3Lt9dCKB2i5AqqIFOtCOtG7EHI+A+cnouxG31Rdxo7DUNBs/XNQ+7qPU0/uH3fh
	VzSicvqTynFxgxR+3IoAnVEMzO0g7Rp7dOjF0TEZ0ICfiPPQOPkDcdM0kAGU7KpLXGYuqlJgW3xzU
	gNYNaZvw==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAR9V-00000005Ies-2pz5;
	Wed, 08 Apr 2026 11:32:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAR9V-00000008nA9-1wCC;
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
Subject: [PATCH v2 4/5] KVM: arm64: vgic: Remove v2_groups_user_writable and use IIDR revision directly
Date: Wed,  8 Apr 2026 12:30:35 +0100
Message-ID: <20260408113256.2095505-5-dwmw2@infradead.org>
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

The v2_groups_user_writable flag was introduced to gate GICv2 userspace
IGROUPR writes until userspace explicitly wrote the IIDR, signalling
awareness of the group semantics. However, the guest write path through
vgic_mmio_write_group() was never gated by this flag, allowing a GICv2
guest to modify interrupt groups regardless of whether userspace had
opted in.

Rather than adding the same flag check to the guest path, remove the
flag entirely and make both guest and userspace IGROUPR writability
follow the IIDR implementation revision directly. Groups are writable
when the revision is >= 2, which is the case when userspace explicitly
sets the IIDR to revision 2 or 3. When userspace does not write the
IIDR, vgic_init() defaults to KVM_VGIC_IMP_REV_LATEST (currently 3),
so the behaviour is unchanged for userspace that doesn't set the IIDR.

This also fixes the inconsistency where a GICv2 guest could write
IGROUPR even when the IIDR had not been explicitly set by userspace.

Fixes: d53c2c29ae0d ("KVM: arm/arm64: vgic: Allow configuration of interrupt groups")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/arm64/kvm/vgic/vgic-mmio-v2.c | 16 +++++-----------
 include/kvm/arm_vgic.h             |  3 ---
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index e5714f7fd2ec..e5fc673a1ea9 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -84,21 +84,15 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 
 		/*
-		 * If we observe a write to GICD_IIDR we know that userspace
-		 * has been updated and has had a chance to cope with older
-		 * kernels (VGICv2 IIDR.Revision == 0) incorrectly reporting
-		 * interrupts as group 1, and therefore we now allow groups to
-		 * be user writable.  Doing this by default would break
-		 * migration from old kernels to new kernels with legacy
-		 * userspace.
+		 * Allow userspace to select the GICv2 IIDR revision.
+		 * Group writability follows the revision directly:
+		 * groups are guest/user writable for revision >= 2.
 		 */
 		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, val);
 		switch (reg) {
+		case KVM_VGIC_IMP_REV_1:
 		case KVM_VGIC_IMP_REV_2:
 		case KVM_VGIC_IMP_REV_3:
-			vcpu->kvm->arch.vgic.v2_groups_user_writable = true;
-			fallthrough;
-		case KVM_VGIC_IMP_REV_1:
 			dist->implementation_rev = reg;
 			return 0;
 		default:
@@ -114,7 +108,7 @@ static int vgic_mmio_uaccess_write_v2_group(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len,
 					    unsigned long val)
 {
-	if (vcpu->kvm->arch.vgic.v2_groups_user_writable)
+	if (vgic_get_implementation_rev(vcpu) >= KVM_VGIC_IMP_REV_2)
 		vgic_mmio_write_group(vcpu, addr, len, val);
 
 	return 0;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 90fb6cd3c91c..cdfab2c20877 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -253,9 +253,6 @@ struct vgic_dist {
 #define KVM_VGIC_IMP_REV_3	3 /* GICv3 GICR_CTLR.{IW,CES,RWP} */
 #define KVM_VGIC_IMP_REV_LATEST	KVM_VGIC_IMP_REV_3
 
-	/* Userspace can write to GICv2 IGROUPR */
-	bool			v2_groups_user_writable;
-
 	/* Do injected MSIs require an additional device ID? */
 	bool			msis_require_devid;
 
-- 
2.51.0

