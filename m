Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789010;
	b=okshNW/w+1/N5imDvBTU+saqOKoDgXX7WdePMfMZNgmGZYtVkOsxjT0QmWlueEM7VCoT
	 58lRaKe4xw8aV07YGVzWf2O6vKMQpSkepPDKocFGByHUUP6eT+rAS1PFiURqIiEI4Ujwy
	 Ctx/Gf2B2f/vPuiPEo+MGBwaMdg1l6xlN8gv4GVXyIPPweTaYKoKWlXRPmcBJu9I5mOvc
	 KtuHx/ob3E/S0O8aljXDOOE/prPR3qorGiqp/MBPuLTdnzh25KDHLPd0afbeXEkHRGNCP
	 j8KA/m5YBavyUOvtAKV2Np37jeLrylRIrRqco5GzV5BfSlAyY5DlW/28k7czYoO3jaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=pIU5d6j9Ys00lAMXVHCBFg580+GrlC7IugJoG1GKGeU=;
	b=vRdJ4D0PRbMJbT4nprVw8U4XGHAbaodMQrz+NUnvIzUtnpqeH2GEsWCR4owS8tKK3GYw
	 JyTmBGY1iHQvWQM4hdQknTcXY3r9DtlPHoZF18m1senFkRisZyB+dVmwdcswMXEnDi4+Y
	 0S0gCKRl+lDZBPQvpJtBE2QHaZY1nocJ9wKkRBej6wr8Nd5hl/B2ZwVLC29HDdQ3T8Kit
	 3iMFOJx28jD5oT55Xahne/SKDnNkuSxwIBJMvfV9/IQyTaJTD6y+ErHH33bD6TfTCdYH3
	 ijBlXKeNylFdQFcorh63nEPMuwYtFFHp3B7oDIPfWBbjMM6equiTE+ZLzIJUUeRk25w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AGgfsGLa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279B8606A326
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AGgfsGLa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CCB1F031E4;
	Fri, 23 Oct 2026 20:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789010;
	bh=pIU5d6j9Ys00lAMXVHCBFg580+GrlC7IugJoG1GKGeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGgfsGLaViXRwov8tZpb2xrtZwMaNSm9SPUk+laowJhr9GuzIfwVOH/Zu8f2w6feA
	 uZfeUszIpQZX+N4NUUcaXedOjWl6N3Mlb/KcHkytbGBkp46wQU0OF3r9Tx9/f06/0M
	 89ghJa20322Pib3vMz9/6rlFBuEHEzVzzSFZMPBDxWhW6HGOt1NjSXrmR2VrRyezBC
	 s8RicU6uhfHF2Zu1votHm2PVOemdz9nO6lmo59V+wfIQ0oQuWtmQdMlWWJwWl5E0Zm
	 u1lbRivyTg/X0cS7DKro4RMhMuDo/Ova3LYNj6n6MtPB4kmn8MnAy+M2by2WT6QQ3F
	 6ajh0xfvNePPQ==
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
Subject: [PATCH v2 17/28] KVM: arm64: Don't update descriptors for "non-arch" access
Date: Fri, 23 Oct 2026 13:55:59 -0700
Message-ID: <20261023205610.1044532-18-oupton@kernel.org>
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

WALK_ACCESS_NONARCH is a special indicator that the page table walk
request is not due to an architectural behavior and instead used
internally for KVM. Currently, the only user of this is SEA injection to
identify the correct translation level that generated the abort.

Ensure "non-arch" table walks are not made visible to the guest and
explicitly avoid descriptor updates. These accesses are not expected to
be used for pseudo-TLB fills, nor are they used to dirty any memory.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c     | 15 ++++++++++++++-
 arch/arm64/kvm/nested.c | 12 +++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 20cc50c0f694..2ce34af3b9f2 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -457,6 +457,15 @@ static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
 	return 0;
 }
 
+static bool should_set_access_flag(struct s1_walk_info *wi, struct s1_walk_step *ws,
+				   struct kvm_walk_access *access)
+{
+	if (access->type == WALK_ACCESS_NONARCH)
+		return false;
+
+	return wi->ha;
+}
+
 static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step *ws,
 				   struct s1_walk_result *wr, struct kvm_walk_access *access)
 {
@@ -466,6 +475,7 @@ static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step
 	/* R_RKMHW */
 	case WALK_ACCESS_CMO:
 	case WALK_ACCESS_AT:
+	case WALK_ACCESS_NONARCH:
 		return false;
 	default:
 		/* R_NSXRD */
@@ -482,7 +492,7 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	old = new = ws->desc;
 
-	if (wi->ha)
+	if (should_set_access_flag(wi, ws, access))
 		new |= PTE_AF;
 
 	if (should_set_dirty_state(wi, ws, wr, access))
@@ -558,6 +568,9 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 				.write	= wi->ha,
 			};
 
+			if (access->type == WALK_ACCESS_NONARCH)
+				s2_access.type = WALK_ACCESS_NONARCH;
+
 			ret = kvm_walk_nested_s2(vcpu, &s2_access, &ws.s2_trans);
 			if (ret == -EAGAIN)
 				return ret;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 964331dbf475..7dda95d37925 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -247,6 +247,15 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
 	return 0;
 }
 
+static bool should_set_access_flag(struct s2_walk_info *wi, struct s2_walk_step *ws,
+				   struct kvm_walk_access *access)
+{
+	if (access->type == WALK_ACCESS_NONARCH)
+		return false;
+
+	return wi->ha;
+}
+
 static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step *ws,
 				   struct kvm_s2_trans *out, struct kvm_walk_access *access)
 {
@@ -254,6 +263,7 @@ static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step
 	/* R_ZYGHJ */
 	case WALK_ACCESS_CMO:
 	case WALK_ACCESS_AT:
+	case WALK_ACCESS_NONARCH:
 		return false;
 	default:
 		/* R_NSXRD */
@@ -270,7 +280,7 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
 
 	old = new = ws->desc;
 
-	if (wi->ha)
+	if (should_set_access_flag(wi, ws, access))
 		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
 
 	if (should_set_dirty_state(wi, ws, out, access))
-- 
2.47.3

