Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989922;
	b=gksR6e3QeQX5jgebPXWz3z2AUevcM/biQQFpuz7t4q4UJgNx2m6OSVURKFO9Hi8m5d4A
	 B75/o8feNWQkf2g2s9FR4KhuNGqq48BKew1OmX/z/azw9aAfPZ30e0FB/l1IOwfNQk4Cf
	 sNj8uIml0ROrzc/+QcRx4iITglIC2qvPZAFoVY2jJMAYzaodKZN4ClHMDzrLgHYXUclYf
	 I+ewdYhHeoh58CbEoqOJe/VVK/T0JMnsoXwoH8XKgmKED5Q6cKMlgemIBBrR6qbraglBS
	 Zh6pc69dE6uiNderltWL17ZWnunYAn7ElunbvsXTSZbFYGwfodqqxawvTyoBK3kkE0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Y0f7uGxVNpWvHQNtijc/ZhCy34277NVjDYOWOyjIBNw=;
	b=SDD2P64wlO5UgEPdklJLY+Rt3QyUZxsxVbCkA+3CayuKidE/QUzMldP4bFzB5icQ/hR0
	 XYQVGxpxtTfnqyTBjkkS/xf84/ONtpxuJz996gO1FjZD9Ozq4MeKI14H/YwJp7npAYsbO
	 0z0FKVog2mesro69rEdZAZlBFhZokkSlArVlQbJsO1d3uxPg03++2ev64mMPbr1+8HgDY
	 xst0kyqf+5wYmIZ6LfJGInRFlgWmbE5MtjzRbeAe2fAKaQyyFzUTWtxq/J71d2XfCdXNt
	 egRQ18sqUjMl8vTB7VBF56N8AmTpyqQ1AXdh9OKvmjuU/i9gmvWAlsP/an8AmYQMtRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cwwt2UHo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD91B606A326
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 18:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cwwt2UHo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8914F1F008A4;
	Fri,  6 Nov 2026 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793989921;
	bh=Y0f7uGxVNpWvHQNtijc/ZhCy34277NVjDYOWOyjIBNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cwwt2UHodMrTMoar4vtFBMb+RQYZmfVtuW+W1DNy5SghL5OgsHauw5/8zNiz89Ans
	 rxzhQ4OXJ5KrEZEDcwGMgY9h/yt4gAq7Esn4j7FLSwXPVlwjdyCxJGzLPB7fTCJqe5
	 FjNhbFmjgDt24Jfj5t3QDhmhWd315N1uWUffYFg/GuUgOZmkAuD42B3hjIgbjiXQvt
	 hfuaqqj1gIDbU8G6UKm3/JvvH4MlPu/Zjclzey52iNzHf1zo0GsaV+j/dOK0RfKjzO
	 1NVFXCx1YAyQMwXrm/Xf/927rQUUgIrrnP1y6CTYPlmES+0IExgBNJJEDKtA+iDz7h
	 eYwj6h8hSsRxw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 3/8] KVM: arm64: Separate user / guest visibility flags
Date: Fri,  6 Nov 2026 10:31:49 -0800
Message-ID: <20261106183154.3590825-4-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106183154.3590825-1-oupton@kernel.org>
References: <20261106183154.3590825-1-oupton@kernel.org>
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

There's need for even more visibility hacks to differentiate between
userspace and guest. Decompose REG_HIDDEN into two parts and test for
the user-specific flag on all the appropriate UAPI surfaces.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/sys_regs.c        | 10 +++++-----
 arch/arm64/kvm/sys_regs.h        | 23 +++++++++++++++++------
 arch/arm64/kvm/vgic-sys-reg-v3.c |  2 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c |  2 +-
 4 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 850eba167aad..870dcb25d0d7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4866,7 +4866,7 @@ static void perform_access(struct kvm_vcpu *vcpu,
 	trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden(vcpu, r)) {
+	if (sysreg_guest_hidden(vcpu, r)) {
 		kvm_inject_undefined(vcpu);
 		return;
 	}
@@ -5490,7 +5490,7 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
 	r = get_reg_by_id(id, table, num);
 
 	/* Not saved in the sys_reg array and not otherwise accessible? */
-	if (r && (!(r->reg || r->get_user) || sysreg_hidden(vcpu, r)))
+	if (r && (!(r->reg || r->get_user) || sysreg_user_hidden(vcpu, r)))
 		r = NULL;
 
 	return r;
@@ -5571,7 +5571,7 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 	int ret;
 
 	r = id_to_sys_reg_desc(vcpu, id, table, num);
-	if (!r || sysreg_hidden(vcpu, r))
+	if (!r || sysreg_user_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (r->get_user) {
@@ -5611,7 +5611,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 		return -EFAULT;
 
 	r = id_to_sys_reg_desc(vcpu, id, table, num);
-	if (!r || sysreg_hidden(vcpu, r))
+	if (!r || sysreg_user_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (sysreg_user_write_ignore(vcpu, r))
@@ -5705,7 +5705,7 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 	if (!(rd->reg || rd->get_user))
 		return 0;
 
-	if (sysreg_hidden(vcpu, rd))
+	if (sysreg_user_hidden(vcpu, rd))
 		return 0;
 
 	if (!copy_reg_to_user(rd, uind))
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index a3cccad2766f..50214271b24a 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -104,9 +104,14 @@ struct sys_reg_desc {
 				   const struct sys_reg_desc *rd);
 };
 
-#define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
-#define REG_RAZ			(1 << 1) /* RAZ from userspace and guest */
-#define REG_USER_WI		(1 << 2) /* WI from userspace only */
+#define REG_GUEST_HIDDEN	BIT(0)
+#define REG_USER_HIDDEN		BIT(1)
+	/* Hidden from userspace and guest */
+#define REG_HIDDEN		(REG_GUEST_HIDDEN | REG_USER_HIDDEN)
+	/* RAZ from userspace and guest */
+#define REG_RAZ			BIT(2)
+	/* WI from userspace only */
+#define REG_USER_WI		BIT(3)
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -168,10 +173,16 @@ static inline unsigned int sysreg_visibility(const struct kvm_vcpu *vcpu,
 	return r->visibility(vcpu, r);
 }
 
-static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
-				 const struct sys_reg_desc *r)
+static inline bool sysreg_user_hidden(const struct kvm_vcpu *vcpu,
+				      const struct sys_reg_desc *r)
+{
+	return sysreg_visibility(vcpu, r) & REG_USER_HIDDEN;
+}
+
+static inline bool sysreg_guest_hidden(const struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *r)
 {
-	return sysreg_visibility(vcpu, r) & REG_HIDDEN;
+	return sysreg_visibility(vcpu, r) & REG_GUEST_HIDDEN;
 }
 
 static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 89315336b9d3..f41c21ee9e89 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -465,7 +465,7 @@ int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *
 	r = get_reg_by_id(attr_to_id(attr->attr), gic_v3_icc_reg_descs,
 			  ARRAY_SIZE(gic_v3_icc_reg_descs));
 
-	if (r && !sysreg_hidden(vcpu, r))
+	if (r && !sysreg_user_hidden(vcpu, r))
 		return 0;
 
 	return -ENXIO;
diff --git a/arch/arm64/kvm/vgic-sys-reg-v5.c b/arch/arm64/kvm/vgic-sys-reg-v5.c
index 6b255eacbf60..e62d5e908f5a 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v5.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v5.c
@@ -495,7 +495,7 @@ int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *
 	r = get_reg_by_id(attr_to_id(attr->attr), gic_v5_icc_reg_descs,
 			  ARRAY_SIZE(gic_v5_icc_reg_descs));
 
-	if (r && !sysreg_hidden(vcpu, r))
+	if (r && !sysreg_user_hidden(vcpu, r))
 		return 0;
 
 	return -ENXIO;
-- 
2.47.3

