Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788976;
	b=M8DUYyStZDTQWduZxw9tyfhgIKs9RQchfkGLhCzkgW9TOH4WHrAn6/EzjpSIqovALGsD
	 VFUSyoBM248MI86k6J9rKHSLZnvmaLmP0BK0CQiFjDYFPPALyIhNzb1KYAKNt1yxHb2CC
	 YkBUvTw0j2HPlHi3guQG698DKShmUhLAo4mtJAB/mSFsiolKlw1NhL/aUXiOQ/MNdEhUB
	 6asTeCTlkBhg1kgNh4mUK6clr9nFuR7eVw+OkVezS0nFgcxIvgckhU9oLryAvKFUfcT6K
	 tNz0CqXLpQR04F++fQvKm9MVKAAZSjrJBh1W8/dRULRjOS8ODgY+UgMWUYBHV0FOGkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=g7VKSOzkpiyl7nAQmWMVCNV7wbrSwFJ3bMUwS0TsYbY=;
	b=A+Jo7SDy5aq34TbKev6NIMUvYx8cD7937oLKgV6+SCfgMev5pUX7XoHJqXQnCJM9iqep
	 nSwjNMdnaQ7WUDHvEzKR7PjDcgD0vqlfhXDFBTb3klKhUvmsBNWcY4F95DKq0g4212eQ5
	 S7nMfDAdGpLxBIticKAVhiTZzleB2IMvOQB0Ze6lGtzQkIB42Gi9dDQ7kRu6iAJFF/wI5
	 eXv0w0QHoQVbsYqrTdxG3SUSNoeUIxPQroTJPLzmWQiVHlGE2zVoz61IjciN94EsfCMrD
	 Wvm7WZK8bRlY6oE1eRp7JLCFPlKkS/F5m6oKh94I8sYfV47vGMqqc2I9FzxMjr4MVkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="AxIRWp/N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5061D606A31D
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AxIRWp/N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FF81F031E2;
	Fri, 23 Oct 2026 20:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788976;
	bh=g7VKSOzkpiyl7nAQmWMVCNV7wbrSwFJ3bMUwS0TsYbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxIRWp/NN8KtVHUTQEF9c6Kjg3nU/WQelRMYA7yNZ9nDrtiqUxe4VMJ61LdAJ+ouo
	 Hj/57W5bpPZUtAxoznNGitmFgip/hZe369MMOwNpIgAaurwI8CpuFV6axEzpu5RGHg
	 SY3hnW6Ih9n+JfxZ9z/p2PwH935GffMTtdwWcXSsR+2fUxygmcW3F7lTcE4n0HoYVX
	 2Y/MDvvNl1aUdkmCsbjo2oceIBnSNJuXe1BueytLMqRLb+e1xVGFwAxbkl1MmgO0kn
	 DKstDlD5V0zE57sSg2YcefW048DCRfjnx60Ri/Vr8SItBTDRWSnd2CQyhHaoMazsz3
	 L9RL9aAj98PPw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 02/28] KVM: arm64: nv: Consolidate computation of stage-2 permissions
Date: Fri, 23 Oct 2026 13:55:44 -0700
Message-ID: <20261023205610.1044532-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Computing the output permissions from a translation requires
contextualization, as fields in the descriptors may change depending on
the MMU context. Centralize the computation of stage-2 permissions
within the table walk rather as opposed to inspecting the descriptor in
the case of pX and uX permissions.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h  | 42 ++++++++--------------------
 arch/arm64/include/asm/kvm_pgtable.h |  5 ++--
 arch/arm64/kvm/nested.c              | 33 ++++++++++++++++++++--
 3 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 0f899addafa8..ba628d5bbe6e 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -93,13 +93,15 @@ extern void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu);
 extern void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu);
 
 struct kvm_s2_trans {
-	phys_addr_t output;
-	unsigned long block_size;
-	bool writable;
-	bool readable;
-	int level;
-	u32 esr;
-	u64 desc;
+	u64		desc;
+	phys_addr_t	output;
+	unsigned long	block_size;
+	int		level;
+	u32		esr;
+	bool		writable;
+	bool		readable;
+	bool		px;
+	bool		ux;
 };
 
 static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
@@ -135,34 +137,12 @@ static inline bool kvm_has_xnx(struct kvm *kvm)
 
 static inline bool kvm_s2_trans_exec_el0(struct kvm *kvm, struct kvm_s2_trans *trans)
 {
-	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, trans->desc);
-
-	if (!kvm_has_xnx(kvm))
-		xn &= 0b10;
-
-	switch (xn) {
-	case 0b00:
-	case 0b01:
-		return true;
-	default:
-		return false;
-	}
+	return trans->ux;
 }
 
 static inline bool kvm_s2_trans_exec_el1(struct kvm *kvm, struct kvm_s2_trans *trans)
 {
-	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, trans->desc);
-
-	if (!kvm_has_xnx(kvm))
-		xn &= 0b10;
-
-	switch (xn) {
-	case 0b00:
-	case 0b11:
-		return true;
-	default:
-		return false;
-	}
+	return trans->px;
 }
 
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1c9c57cd6ae4..edfae3a6f362 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -87,6 +87,8 @@ typedef u64 kvm_pte_t;
 #define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
 #define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
 #define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R |	\
+					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
 #define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
 #define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
 #define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
@@ -103,8 +105,7 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
 
-#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
-					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
+#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP |	\
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
 /* pKVM invalid pte encodings */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9ceb3a42767d..7bed32c43ea2 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -260,6 +260,36 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u6
 	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
 }
 
+static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
+				   struct s2_walk_step *ws, struct kvm_s2_trans *trans)
+{
+	u8 s2ap = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S2_S2AP, ws->desc);
+	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, ws->desc);
+
+	if (!kvm_has_xnx(vcpu->kvm))
+		xn &= 0b10;
+
+	switch (xn) {
+	case 0b00:
+		trans->px = trans->ux = true;
+		break;
+	case 0b01:
+		trans->px = false;
+		trans->ux = true;
+		break;
+	case 0b10:
+		trans->px = trans->ux = false;
+		break;
+	case 0b11:
+		trans->px = true;
+		trans->ux = false;
+		break;
+	}
+
+	trans->readable = s2ap & BIT(0);
+	trans->writable = s2ap & BIT(1);
+}
+
 /*
  * This is essentially a C-version of the pseudo code from the ARM ARM
  * AArch64.TranslationTableWalk  function.  I strongly recommend looking at
@@ -401,8 +431,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	out->output = (ws.desc & GENMASK_ULL(47, addr_bottom)) |
 		      (ipa & GENMASK_ULL(addr_bottom - 1, 0));
 	out->block_size = 1UL << ((3 - ws.level) * stride + wi->pgshift);
-	out->readable = ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
-	out->writable = ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+	compute_s2_permissions(vcpu, wi, &ws, out);
 	out->level = ws.level;
 	out->desc = ws.desc;
 	return 0;
-- 
2.47.3

