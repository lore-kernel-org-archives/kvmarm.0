Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C7C1D547
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 23:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692944; cv=none; b=OCkFxou1vnVDl1tXDIcZNU5EoVCklY05H8+G+qEyARj1Yxu2orHDrkS2aJpSzfVpVni21E2wuawAa5FMwpEkULg+ycqDf9iwmFxT/qLVwEiTAzaLe053PatpTUGm3B2UfPGMTZL5RGK9I0QWJlDphdhkJVpu2MNZslWx/YdS+PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692944; c=relaxed/simple;
	bh=NTDcn6T8fLIs6YadbTeN074GujB3V6sBy0oUQNr3oS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTONufug9dE3JlxvEviKuFXMBxgVLWXVrWGnUJxZntxEfCQVVolwmNwnzfA0RoDaikyl49SqeaX0TnsdHEegMa19Uv4RG+3sXph44Mm6ZACGqCnd/MBUqkV5NaybPbrGnvLtlvaM02INUFandUTY1NOpfnXj08FvkhJbOmErIeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ybn8L9SM; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ybn8L9SM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714692940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bxXGP+lyjrue2CXapAmnMElc+J1kV8edTpVgML7KvzY=;
	b=Ybn8L9SMi2R081HLrCyc7qTyzTnHBSDyLlzUUYRdNUng020RluBRxtaaphERlfUzayKyip
	t2JytY43yq5ivzwh0p+P1jKYqCSse1vDUKO5XWzX9wnuyh9OA1eeejP74Ff4UC2mFQHDmh
	quQ5fblwAJoHNg5h3iQbDHjKsIuV3r8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/7] KVM: arm64: Rename is_id_reg() to imply VM scope
Date: Thu,  2 May 2024 23:35:23 +0000
Message-ID: <20240502233529.1958459-2-oliver.upton@linux.dev>
In-Reply-To: <20240502233529.1958459-1-oliver.upton@linux.dev>
References: <20240502233529.1958459-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The naming of some of the feature ID checks is ambiguous. Rephrase the
is_id_reg() helper to make its purpose slightly clearer.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c9f4f387155f..51a6f91607e5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1570,9 +1570,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
 
 /*
  * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
- * (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+ * (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8, which is the range of ID
+ * registers KVM maintains on a per-VM basis.
  */
-static inline bool is_id_reg(u32 id)
+static inline bool is_vm_ftr_id_reg(u32 id)
 {
 	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
 		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
@@ -3521,7 +3522,7 @@ static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
 	lockdep_assert_held(&kvm->arch.config_lock);
 
 	/* Initialize all idregs */
-	while (is_id_reg(id)) {
+	while (is_vm_ftr_id_reg(id)) {
 		IDREG(kvm, id) = idreg->reset(vcpu, idreg);
 
 		idreg++;
@@ -3547,7 +3548,7 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
 		const struct sys_reg_desc *r = &sys_reg_descs[i];
 
-		if (is_id_reg(reg_to_encoding(r)))
+		if (is_vm_ftr_id_reg(reg_to_encoding(r)))
 			continue;
 
 		if (r->reset)
@@ -4014,7 +4015,7 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *
 		 * compliant with a given revision of the architecture, but the
 		 * RES0/RES1 definitions allow us to do that.
 		 */
-		if (is_id_reg(encoding)) {
+		if (is_vm_ftr_id_reg(encoding)) {
 			if (!reg->val ||
 			    (is_aa32_id_reg(encoding) && !kvm_supports_32bit_el0()))
 				continue;
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

