Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92C6379EDF;
	Mon, 11 May 2026 11:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778499377; cv=none; b=ZmA6uhqnbfLK/3aLbuKpqTVeBZOMNkC8+a/9wp4YHZ2dqmtHoCqw5kHHxR/yeJ/skHFvhe5zcxySTsRvIbiWCczpREjVFV3KMKcXnD5/5jRf0ckfM+v3cME/76znNjlt1CJ5lDKQjNvDB55v0166cZlF2aIG4ttqjQVgj3gUzhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778499377; c=relaxed/simple;
	bh=DegH9MkiFeBJE4SexquMCZk24MzaVK8LsfzEy+mui64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulCHJkODvcFJ9IEw9rHNTay1L+9YxpUt2UDwbTGmYPdpxK4AGIeHzY9cRbdGj5bOPfWOuWNQyAAinhwTcluxJwNE3tXeDQjG9QRsUfE9s0pAElWnzJSmDaApWzimxZSnbwc69x0mL+KdKNHC8S8ZVNJE36lV7tCfMqo+OGvocw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BLRc22X8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BLRc22X8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wvcz1NQ1762dWyW3ikY0T2Hu3cBKQuR9OWUU0jS07tQ=; b=BLRc22X8JobnVWQx1+w28cGjTs
	P1+3b1A6VDdwLivNi/8y4wi33PZq9BlyUH+hxqjqPGRkD5bEskzLCIUva597dRmJJf5ENwTtNMGhM
	e48FcpfH11lIXmG1/+gDixtEVjCkZDP8c3db+s67jZA07VRzP4Ahdbo3oqnhMCLajZnmFDfz1hHB2
	Ufw3J1fc/Quz5MlvlRJ2niZ4vCb8MOmiv+268PXylNSqQQ6IfTJsWcqJdXY7O1RIZ3wBfiyL3I6eK
	+73Go0bqEsS5w3Uewv1iSXLdk+aoicmZywLC6nqN9jVAs3EnKUyjyBjEV+pCNm+AutV0hTkrFZI8Y
	ktN2IYBQ==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMOvZ-0000000BUT9-285J;
	Mon, 11 May 2026 11:36:02 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wMOvY-0000000Dx0c-14Kk;
	Mon, 11 May 2026 12:36:00 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Kees Cook <kees@kernel.org>,
	Timothy Hayes <timothy.hayes@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 3/4] KVM: arm64: vgic: Remove v2_groups_user_writable and use IIDR revision directly
Date: Mon, 11 May 2026 12:30:45 +0100
Message-ID: <20260511113558.3325004-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260511113558.3325004-1-dwmw2@infradead.org>
References: <20260511113558.3325004-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

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

This also fixes the inconsistency where GICv2 userspace could not write
IGROUPR at the default revision, even though the guest could.

As far as I can tell, QEMU commit eb8b9530b0c ("hw/intc/arm_gic_kvm.c:
Save and restore GICD_IGROUPRn state") made QEMU attempt to save/restore
the GICD_IGROUPR registers (which, again, are guest-writable but not
userspace-writable by default) without ever actually setting GICD_IIDR.

Fixes: 32f8777ed92d ("KVM: arm/arm64: vgic: Let userspace opt-in to writable v2 IGROUPR")
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
index 16811ec03d54..a9490e43d98d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -377,9 +377,6 @@ struct vgic_dist {
 #define KVM_VGIC_IMP_REV_3	3 /* GICv3 GICR_CTLR.{IW,CES,RWP} */
 #define KVM_VGIC_IMP_REV_LATEST	KVM_VGIC_IMP_REV_3
 
-	/* Userspace can write to GICv2 IGROUPR */
-	bool			v2_groups_user_writable;
-
 	/* Do injected MSIs require an additional device ID? */
 	bool			msis_require_devid;
 
-- 
2.51.0

