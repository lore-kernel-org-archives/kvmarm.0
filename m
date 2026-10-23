Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789010;
	b=chbsnMgglWit7HkJSxWlOJnBQaPFNpU6XgAJ8IeYyaK5lBUlsE29xP2PrdPzQytHiIFR
	 69flG3XBthou+J8u9TuYQpMJ2+JfqGmp3BRF7XdJKIK2+HVuI35loOt8kh8S527zXGiUE
	 5rYk5uV0+6j5QTdmbjaCDvl6XUJvXGIT6AwPyDnYl9+TiNfo6kK6VyqF0JFHkhJNtXON8
	 b54l6ISfkmzosn1raYaRdY+5RBjf3tyrkuWhobn7At/T4keqGbkuVj+BRatcz2MbGfQzb
	 BwE4r/AITC9eorb+GNX04C4/1UZXr46u6+wN3zrLIaxCADU/iBPqkUcD3eang8+Bh8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=5Ou5frVv4rrQO/MMXzAhdD5Dua2c8heyFehfNMKqYks=;
	b=Fst4xH3y11XcEu6mhU082i3lOjcdCd+mRhLD6nuZkDLvkJL9vrNHf/gRYJNMHN1kUxxN
	 7tngSeWLtr27864hia1EkOsad8PCitIq2IXKXDaPt3HN9PIvXhrp58Au6t5+hhteQ2vo4
	 HVjPDwP9iKuPEAmU2t62IKutdDAWDrn/eEyfK8idSiWoGLzZqK1+FDQ37kGM18L9+w0+C
	 2601UA+veehh2QIihLW24MIktoXxzPAduRMojcZQmmFQuKiHLXAmlDQdrBPE1cOWYGolK
	 Lt69Fbl+QSOoYgeCwGqTGb1JHMeNmTqcyjOjy6JzjC0b7Z1lKVKhFu3QPjyI7c+R5Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jHyPa8tr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB79606A31D
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jHyPa8tr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A537D1F031E6;
	Fri, 23 Oct 2026 20:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789009;
	bh=5Ou5frVv4rrQO/MMXzAhdD5Dua2c8heyFehfNMKqYks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHyPa8trLgcXd6T35yj0mZUyMveA3kD1nE/PHwOtjoYSgK+vkJCHNGs0/RbX8+ek0
	 QeJsjSOAWozRsxxsIJhyEyPy1Me/O3mOAYg4TgCNf/qK6Q7rdUZg6At3CyoehcPDdm
	 /igHzVGUAPhBpFvqxcgx3tBLwattb2sfN4PzdPK6WirHRVEu8+HDIKEQ6mV2Kt6Lf5
	 UvwtvY7R947YaB9t3mBFIas5uZFsJZhEC8LpUcVha0kGskK4oa397svSmyMaDBiRyy
	 GAQa0XBEZZY4Lzj+SwI8UCzWRZSt75cysdIIScjYLKcl5OUNt2YQkuCJBftCOYDRb8
	 KFBhp0H1Boqug==
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
Subject: [PATCH v2 16/28] KVM: arm64: Grant write permission when DBM is set at S1
Date: Fri, 23 Oct 2026 13:55:58 -0700
Message-ID: <20261023205610.1044532-17-oupton@kernel.org>
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

The DBM bit effectively behaves as a permission bit when using direct
permissions, especially so in the context of accesses that do not update
the dirty state (like AT).

Treat AP[1] == 0 for the purposes of computing permissions, relying on
the walker to abort if it fails to set the dirty state where required.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 583fba1da73b..20cc50c0f694 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1078,11 +1078,23 @@ static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
 					  struct s1_walk_info *wi,
 					  struct s1_walk_result *wr)
 {
+	u8 ap = FIELD_GET(PTE_USER | PTE_RDONLY, wr->desc);
 	bool wxn;
 
+	/*
+	 * Descriptors with the DBM bit set while hardware dirty state are
+	 * considered writable, even though certain accesses (like AT instructions)
+	 * don't actually update the dirty state.
+	 *
+	 * Assume that walk_s1() made the necessary descriptor updates for the
+	 * access and just treat DBM as writable here.
+	 */
+	if (wi->hd && (wr->desc & PTE_DBM))
+		ap &= ~BIT(1);
+
 	/* Non-hierarchical part of AArch64.S1DirectBasePermissions() */
 	if (wi->regime != TR_EL2) {
-		switch (FIELD_GET(PTE_USER | PTE_RDONLY, wr->desc)) {
+		switch (ap) {
 		case 0b00:
 			wr->pr = wr->pw = true;
 			wr->ur = wr->uw = false;
@@ -1106,7 +1118,7 @@ static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
 	} else {
 		wr->ur = wr->uw = wr->ux = false;
 
-		if (!(wr->desc & PTE_RDONLY)) {
+		if (!(ap & BIT(1))) {
 			wr->pr = wr->pw = true;
 		} else {
 			wr->pr = true;
-- 
2.47.3

