Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8906E38D687
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240129; cv=none; b=KloBJVk1R70rUrz7L7gQwkCxsqKwFvkjwGhFFH4ruT8wflo5sph80PCC2lVkyXa/LlTJV7NCsS9YmEUEccYHA+thoVzSOpAyrKe4PrAB6rPrpGfJUCRstvkk4HEzIky87WcUWPrDQdS/mFUv3BwGfJ00kz24ENCB2Jd5jk0Olas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240129; c=relaxed/simple;
	bh=Wy2nbSA0QKDGbWCvBUOoYbGhuW169m1/uE5Z84HQN7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHTz/ZRVA4E/5KanTimOYalGK9EbtO5re8xVTsabIXGTLM5+e+HGL9OFxlMl5qcPlRF8A1STfXsr16ZT88rxw8KI/xPm5YE/wHU8qvmiu2x1Wa6mO25mNCQEkPmzj6Su8v1hPIJWiXQtiww+1A8mQsxreMs5MS5BvPxhESC9vDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvbeVA/c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvbeVA/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4BB1F00A3F;
	Tue, 23 Jun 2026 18:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240128;
	bh=NtmD9jZWN2RUGCB8CxAKxRzaBY6g/P1gDAAuGNGcETE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvbeVA/c4+fjgWQFtU1axCPuyQWNgsRT0gVRBAqKYpZrOl8dmDev1Z/Hcy4YwUaRh
	 cGgBcEzAD3ms8diuq10yE34qrDGciirSfzlCrT9/c9yjI/wew/dh9s0HycscWdAoSY
	 D+BsrEzK08EZXskrqVsjWM6BPX4R8AoQiboTp5sxb7Ux9TzvtWH9AOSWnQV4xiqrAv
	 7mEYkgX8Fnzu6ni3xye2erJcph2/Gl/05TTf4nYWEAoCmd9bMNApDXD5h+MD1liXSU
	 PemGjTIllVGHSU9CKzVk4zzUQ8/ALvQvYjjmkDNLxjKcPnaR8Kp08CXbhVt7CBkAD+
	 mL3aGBuILqGew==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 15/22] KVM: arm64: Don't update descriptors for "non-arch" access
Date: Tue, 23 Jun 2026 11:41:54 -0700
Message-ID: <20260623184201.1518871-16-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623184201.1518871-1-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

WALK_ACCESS_NONARCH is a special indicator that the page table walk
request is not due to an architectural behavior and instead used
internally for KVM. Currently, the only user of this is SEA injection to
identify the correct translation level that generated the abort.

Ensure "non-arch" table walks are not made visible to the guest and
explicitly avoid descriptor updates. These accesses are not expected to
be used for pseudo-TLB fills, nor are they used to dirty any memory.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c     | 15 ++++++++++++++-
 arch/arm64/kvm/nested.c | 12 +++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index faffb69c2eef..8d76eaf463c9 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -459,6 +459,15 @@ static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
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
@@ -468,6 +477,7 @@ static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step
 	/* R_RKMHW */
 	case WALK_ACCESS_CMO:
 	case WALK_ACCESS_AT:
+	case WALK_ACCESS_NONARCH:
 		return false;
 	default:
 		/* R_NSXRD */
@@ -484,7 +494,7 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	old = new = ws->desc;
 
-	if (wi->ha)
+	if (should_set_access_flag(wi, ws, access))
 		new |= PTE_AF;
 
 	if (should_set_dirty_state(wi, ws, wr, access))
@@ -555,6 +565,9 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 				.write	= wi->ha,
 			};
 
+			if (access->type == WALK_ACCESS_NONARCH)
+				s2_access.type = WALK_ACCESS_NONARCH;
+
 			ret = kvm_walk_nested_s2(vcpu, &s2_access, &ws.s2_trans);
 			if (ret == -EAGAIN)
 				return ret;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 54228db30371..4d128003ae7a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -228,6 +228,15 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
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
@@ -235,6 +244,7 @@ static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step
 	/* R_RKMHW */
 	case WALK_ACCESS_CMO:
 	case WALK_ACCESS_AT:
+	case WALK_ACCESS_NONARCH:
 		return false;
 	default:
 		/* R_NSXRD */
@@ -251,7 +261,7 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
 
 	old = new = ws->desc;
 
-	if (wi->ha)
+	if (should_set_access_flag(wi, ws, access))
 		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
 
 	if (should_set_dirty_state(wi, ws, out, access))
-- 
2.47.3

