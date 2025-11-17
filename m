Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E697324B22
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419411; cv=none; b=T9xsIcT3o8pOb39P0wCfwB8XF88SiCUSks0jmtdyDBi8ln2pl7j7gOd43OiV3igUQzVsqKKi1u4pYsW8nJapz4X4VRZ8RrXm4/eOe60RMKutDChq376DAt7l/LetXt5YTpVSfpKvbGSekTRwXijwY1CHRMApNTMiJj63CjCu3JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419411; c=relaxed/simple;
	bh=pqSKo8er0SoMTFLT6zNG7jCIWrfz1ZRG0V9yP9E1WoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jv8KWC/7uin+yxmq7p/IZUjSztfkL3TxMu4PrJiwsMvYP2AEDTsjOsz542T/2E3eoeXeUIGyGheygWsgE7gFAn2WcOvwoOPTNOxnq8kOfdT/HvSl9JtgyJPvSMeHdZUG9JzmCFzluKQCb3qjlePJG6XgaUUpuD7vMwvx1yQW1v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XAM0SkYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XAM0SkYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572DFC2BC87;
	Mon, 17 Nov 2025 22:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419410;
	bh=pqSKo8er0SoMTFLT6zNG7jCIWrfz1ZRG0V9yP9E1WoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAM0SkYZdvoAjuYbSllYpAUN7leRIh9KSePhaoS3pkqoazAHWWaFi3B4WHolMlPP8
	 P1inQXb2E4qV/Vx9r3rbjOQoeTLfGRZoKwuer/eBU7bhleEWB7dkjMBApYZgksaN1o
	 YnLcYMbCAPoR2CaPYL5cbyzJMDxY0R6LIsoT70Remy99wv3qYyCvuRGz9/p1mfhc0x
	 6xqVvYLdrks6H15S/vDF4nKe0MPjqEAnS1NnCLsclsPU733f60eGwlBot2RTGcW6UA
	 i4HSqXkybv6edRtmUJ1q8hF561kvvO430Uur3j74EEn0Rwy0PtelfT5JrULDB4xJrg
	 7jzIrsM16Ujtg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 06/14] KVM: arm64: Call helper for reading descriptors directly
Date: Mon, 17 Nov 2025 14:43:17 -0800
Message-ID: <20251117224325.2431848-7-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117224325.2431848-1-oupton@kernel.org>
References: <20251117224325.2431848-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Going through a function pointer doesn't serve much purpose when there's
only one implementation.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 08839a320a45..cf4b24e04a1a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -124,7 +124,6 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 }
 
 struct s2_walk_info {
-	int	     (*read_desc)(phys_addr_t pa, u64 *desc, void *data);
 	void	     *data;
 	u64	     baddr;
 	unsigned int max_oa_bits;
@@ -199,6 +198,15 @@ static int check_output_size(struct s2_walk_info *wi, phys_addr_t output)
 	return 0;
 }
 
+static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, void *data)
+{
+	struct kvm_vcpu *vcpu = data;
+	u64 val;
+	int r;
+
+	return kvm_read_guest(vcpu->kvm, pa, desc, sizeof(*desc));
+}
+
 /*
  * This is essentially a C-version of the pseudo code from the ARM ARM
  * AArch64.TranslationTableWalk  function.  I strongly recommend looking at
@@ -257,7 +265,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 			>> (addr_bottom - 3);
 
 		paddr = base_addr | index;
-		ret = wi->read_desc(paddr, &desc, wi->data);
+		ret = read_guest_s2_desc(paddr, &desc, wi->data);
 		if (ret < 0)
 			return ret;
 
@@ -325,13 +333,6 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 	return 0;
 }
 
-static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, void *data)
-{
-	struct kvm_vcpu *vcpu = data;
-
-	return kvm_read_guest(vcpu->kvm, pa, desc, sizeof(*desc));
-}
-
 static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
 {
 	wi->t0sz = vtcr & TCR_EL2_T0SZ_MASK;
@@ -364,7 +365,6 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	if (!vcpu_has_nv(vcpu))
 		return 0;
 
-	wi.read_desc = read_guest_s2_desc;
 	wi.data = vcpu;
 	wi.baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
 
-- 
2.47.3

