Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820087;
	b=o4WRxtSS28CDoe2s8PSFEQXEgQYuRnOc/mITMhcekjHJZR9TrIHFeZ/VJPxUZEBOlPhs
	 u2yPYsDx3+hut2u/zXirEDvJQ6ETkYG+iKMzBDEknCsNeWjB3kZQo/e9LyraMnERrgdpf
	 pJ6FNCNcHINYcjF10hMfVybECqSnuMZyDGacNBpcf1Fxh5BcHeLamDn6copUHPtZ0nTev
	 VC9kVKtC58B09vVJw6XAu1QE7tFJyUHHn3UAkdlw+6OZQ7hvU5JpYfpLnNP53gtxS7aU6
	 svtC0F63Nv540bB8MBi+GlHWJ8/dEp5abd/UawHkZgaKrIHhvYRDHR/N48kLFvvPe1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Y0f7uGxVNpWvHQNtijc/ZhCy34277NVjDYOWOyjIBNw=;
	b=V2t86a01pyrrv09IEAcIe5VYUi/XxlwX05ChByPExBOeHBksvwO+OIA5iNilnIMohgBA
	 TWpqxm2KQlNXjWlk++YdCqWqgLBzAVESnYL3suPpgP03MUQJGWeJwpQ/xhk4qbofsA3yD
	 vu7kMkSwXAiba6XuuuFcVbw3W4JJPYJ2x4Uh2Haiv9QTgM0XI/24Cr3VRppMruBTzjJqi
	 tm3W3UyGQNmPJbaMO3B/sM+PRUjrnB4B6oRQMwN5EuQyECZxlfzNT1oFb0qULSmYjzVKZ
	 SmXOfJxGCDkkNkNS36HE45zQYoq1KY6d0565B9ClIcfetIZPdOJDtPQar4KqxNFsJOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UXRLNCmz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CC5606AB2A
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 19:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UXRLNCmz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DF71F00A15;
	Wed,  4 Nov 2026 19:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820087;
	bh=Y0f7uGxVNpWvHQNtijc/ZhCy34277NVjDYOWOyjIBNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXRLNCmzSKyhgqHsdkoTUPWtoXEvK0mZcGFXffRy4BfPdwFLH4TS7J15CTEi1+Jd6
	 etfC71HBEhBCAX12EiQIKCZ2KwQ142dbs045L88Fk98jJvzxJaakC03UTGjwdaobJm
	 wyDmW7uZOpkPuCEZVjKm/+/3eydPPc37qd8UGQXLnPxuggAuxnUeW95QgrktDzQ++S
	 iwxejD2YJaCCDN+zeqatKITvFVWnugFAYqg04X9Ql+9QHeeaqoWrI0fFpD0dRNgHuL
	 pbyfq11gwftHeRhrHevVMeqzNVXcZ2pTXhV7ZCQvJV1v2SBwKHL0gWyUdTF2LApoKv
	 UZ9tOTotiPx8Q==
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
Subject: [PATCH 3/8] KVM: arm64: Separate user / guest visibility flags
Date: Wed,  4 Nov 2026 11:21:19 -0800
Message-ID: <20261104192124.3932743-4-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104192124.3932743-1-oupton@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org>
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

