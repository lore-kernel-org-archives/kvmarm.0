Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789009;
	b=zybc6z/jXqNfzsHxk6UGtzNXwAbWvq4R5atk1BPsRQgj6U4udm+qh783ZLbebDUedaM6
	 jn9L8GfmDxyeCQKiAQ7i2eu1SN54+gUZaI438AVQnWtps9oTKUW42nECSAHaL3sWyb/cS
	 e0JE/qsWIE/9a91dq2Trfda92Im9LWL85UfcMHk36/i1b4G0OBNikTagB2WOwO2Tf8Fkz
	 xaJp/G3oP8G1G/dBaZz20yruHyDXXJuybJOUUFMhDvT84QPCjK94XdG8TqMZey6qJ43YM
	 exgpr5y6XxTHQ/6alDpWP71fcSa7+kd/ZG9nXYoRHvp3bDTpA1Pgbv4meA5zUhujV5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1wMewJHnqC5OQ0V4FLYS5HqAstn6TlHSiYZot9aW4p8=;
	b=GVHT8sPc0hINUNdAA4ZxrqxcoPoFd54TiqmlOMZIBhrygLfGFI6pEmfiGSD0GFskv3M9
	 t3j3l0xyNpi+fmI9zyMZefRu8Ra4CybXZWu4zs4Q3NC1GBSyVq0cCPEwrJB40ITe7AFAL
	 4bkL5Vd4cQb4rAqDr4YhXRLRJEpLmRu2xqAy/vMW0Wgw8qKHSSZPk693mjkBKJVm62fUq
	 ltgRnrFjpMHqG95N0W+6ucUK7ZGgaP0a0yYGm/bZyBb885MTccZ/0GSIG9KyYiyyM8fyH
	 Ex2ymRq+Y8GufIT1BOrlL+4mEDfkUpvTRFqehjnxJlJ5MyGeQ2CRK1KWPdSJHDTxe4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B9QX1iEf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B501606A31D
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B9QX1iEf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4041F031E4;
	Fri, 23 Oct 2026 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789009;
	bh=1wMewJHnqC5OQ0V4FLYS5HqAstn6TlHSiYZot9aW4p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9QX1iEfYgtzoFgOiPukuJODQz86nDaehA/e2OeA13Wy4hKZjXBxYK9xX0IXC8y7k
	 mSSxLqBFumdb9LuDnb8ii2tR/BCpOgwIcl6nR86joz6ZM4EcbyH8Cd1j2Lkp5BsEny
	 jPATEkeCqwxu01Z2hA1TxDjRN06oj3pikSj5pyAael1o9BQZYKCTJTaggEWjYXpE2c
	 F2JaWlAj/weHKb+akAoTJ9gW+e9rRdVJ1hnD+xTskVt2IKDR4kos9kGxKrJZna+u3Z
	 VPm3OGudPUMmPyzwtdDxpXJa2siVZl2vEjvUpmwXMQxmxhn2DK56Uj2EDbhdj647wQ
	 xa88kGASfoSBg==
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
Subject: [PATCH v2 13/28] KVM: arm64: Set dirty state at stage-1
Date: Fri, 23 Oct 2026 13:55:55 -0700
Message-ID: <20261023205610.1044532-14-oupton@kernel.org>
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

Mark the descriptor as dirty if the permissions are sufficient to grant
write access. Note that compute_s1_direct_permissions() already
considers the DBM bit as writable.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h    |  1 +
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/at.c                 | 34 ++++++++++++++++++++++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 678f0daed445..ad897dd71382 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -113,6 +113,7 @@
 #define TCR_EL2_DS		(1UL << 32)
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
 #define TCR_EL2_HPD		(1 << 24)
+#define TCR_EL2_HD		(1 << 22)
 #define TCR_EL2_HA		(1 << 21)
 #define TCR_EL2_TBI		(1 << 20)
 #define TCR_EL2_PS_SHIFT	16
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index d7c1fa66f029..f0ac36fff652 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -337,6 +337,7 @@ struct s1_walk_info {
 	bool	     		s2;
 	bool			pa52bit;
 	bool			ha;
+	bool			hd;
 };
 
 struct s1_walk_result {
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index eba51c6e01af..583fba1da73b 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -410,6 +410,10 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	wi->ha &= (wi->regime == TR_EL2 ?
 		  FIELD_GET(TCR_EL2_HA, tcr) :
 		  FIELD_GET(TCR_HA, tcr));
+	wi->hd  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, DBM) && wi->ha;
+	wi->hd &= (wi->regime == TR_EL2 ?
+		  FIELD_GET(TCR_EL2_HD, tcr) :
+		  FIELD_GET(TCR_HD, tcr));
 
 	return 0;
 
@@ -453,6 +457,22 @@ static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
 	return 0;
 }
 
+static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step *ws,
+				   struct s1_walk_result *wr, struct kvm_walk_access *access)
+{
+	bool perm = wi->as_el0 ? wr->uw : wr->pw;
+
+	switch (access->type) {
+	/* R_RKMHW */
+	case WALK_ACCESS_CMO:
+	case WALK_ACCESS_AT:
+		return false;
+	default:
+		/* R_NSXRD */
+		return access->write && wi->hd && perm;
+	}
+}
+
 static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			      struct s1_walk_step *ws, struct s1_walk_result *wr,
 			      struct kvm_walk_access *access)
@@ -465,6 +485,9 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	if (wi->ha)
 		new |= PTE_AF;
 
+	if (should_set_dirty_state(wi, ws, wr, access))
+		new &= ~PTE_RDONLY;
+
 	if (new == old)
 		return 0;
 
@@ -484,11 +507,16 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	}
 
 	ret = __kvm_at_swap_desc(vcpu->kvm, ws->desc_pa, old, new);
-	if (!ret || ret == -EAGAIN)
+	if (ret == -EAGAIN)
+		return ret;
+	if (ret) {
+		fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(ws->level), false);
 		return ret;
+	}
 
-	fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(ws->level), false);
-	return ret;
+	wr->desc = ws->desc;
+	wr->dirty = !(wr->desc & PTE_RDONLY);
+	return 0;
 }
 
 static void compute_s1_permissions(struct kvm_vcpu *vcpu,
-- 
2.47.3

