Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D53414BF92
	for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 07:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721719232; cv=none; b=PqYl/QONDCA86/lmWQQHn3zlPfbF6WDlit6b1fdBFzKczd7Ad7Oyk3kN8bH844cc/PrOl7C53Ia31vgexCfJ1Sv9TqReeq+qiDECQbePTJPHHnuFBz1P/PNyg76CBDDq/wzXejr7dIC5CzZkqOOdL6ByZr2vYCrJ8EX9doEwz74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721719232; c=relaxed/simple;
	bh=ugSFRNfolVFaZFhTPXj1YzkkOIkmqVODorCNrT6Dm+s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ehoj8EYbHRLD5xf+VRkOOELC46wSAisGr5ijnDiJQDI5RPSLsZWZG4CFubjnZXtUsXc/fN4pdht7i8uNZny21JXyzLmlBmWn1yDHcqj0zWOYqxl6hEpLamw6i/c19uZs9Ff1pYSvmr0fhlFBJCmnqoB3e8fPJ+EpQfXLDa+S9O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lz29zFbw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lz29zFbw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721719230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HVGmWP/opItNhG7cy70QzT+jwvzCuIhunCgI+uRjxE0=;
	b=Lz29zFbwZoTclQypgpz7LDCS2uJUz0i6g5FTahEe8f9I94LelUsJLpN8eRnN83IKb1/oZs
	+BF+PT1TI2VKFalcFZy3WOosi5NvPprCqU2y1Mb00HvH3i495bIc4YK5CsNlY2K/yaleQt
	DM4eIAhTne13DGszna5JrpqKuIJ0tTk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-SPKrIC3hMza5yII2H2l7QA-1; Tue,
 23 Jul 2024 03:20:21 -0400
X-MC-Unique: SPKrIC3hMza5yII2H2l7QA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D73A1955D48;
	Tue, 23 Jul 2024 07:20:19 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2151A1955F40;
	Tue, 23 Jul 2024 07:20:17 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Cc: Eric Auger <eauger@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/4] KVM: arm64: Use kvm_has_feat() to check if FEAT_SSBS is advertised to the guest
Date: Tue, 23 Jul 2024 03:20:01 -0400
Message-Id: <20240723072004.1470688-3-shahuang@redhat.com>
In-Reply-To: <20240723072004.1470688-1-shahuang@redhat.com>
References: <20240723072004.1470688-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Currently KVM use cpus_have_final_cap() to check if FEAT_SSBS is
advertised to the guest. But if FEAT_SSBS is writable and isn't
advertised to the guest, this is wrong.

Update it to use kvm_has_feat() to check if FEAT_SSBS is advertised
to the guest, thus the KVM can do the right thing if FEAT_SSBS isn't
advertised to the guest.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/hypercalls.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5763d979d8ca..ee6573befb81 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -317,7 +317,7 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 				 * to the guest, and hide SSBS so that the
 				 * guest stays protected.
 				 */
-				if (cpus_have_final_cap(ARM64_SSBS))
+				if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SSBS, IMP))
 					break;
 				fallthrough;
 			case SPECTRE_UNAFFECTED:
@@ -428,7 +428,7 @@ int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
  * Convert the workaround level into an easy-to-compare number, where higher
  * values mean better protection.
  */
-static int get_kernel_wa_level(u64 regid)
+static int get_kernel_wa_level(struct kvm_vcpu *vcpu, u64 regid)
 {
 	switch (regid) {
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
@@ -449,7 +449,7 @@ static int get_kernel_wa_level(u64 regid)
 			 * don't have any FW mitigation if SSBS is there at
 			 * all times.
 			 */
-			if (cpus_have_final_cap(ARM64_SSBS))
+			if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SSBS, IMP))
 				return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
 			fallthrough;
 		case SPECTRE_UNAFFECTED:
@@ -486,7 +486,7 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
-		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
+		val = get_kernel_wa_level(vcpu, reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
 		break;
 	case KVM_REG_ARM_STD_BMAP:
 		val = READ_ONCE(smccc_feat->std_bmap);
@@ -588,7 +588,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
 			return -EINVAL;
 
-		if (get_kernel_wa_level(reg->id) < val)
+		if (get_kernel_wa_level(vcpu, reg->id) < val)
 			return -EINVAL;
 
 		return 0;
@@ -624,7 +624,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		 * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
 		 * other way around.
 		 */
-		if (get_kernel_wa_level(reg->id) < wa_level)
+		if (get_kernel_wa_level(vcpu, reg->id) < wa_level)
 			return -EINVAL;
 
 		return 0;
-- 
2.40.1

