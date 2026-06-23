Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5429E38B7BA
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240129; cv=none; b=nMRlMPSjomVIPmdgPiavLJn+Ynj6EMn8YudnEFMZCXXu4XHFJRz9GCBwcXIZurzsgLAQydMg9w7aXS0KEGR53vpEQeq6Rcjc5Rj7Nt2wd4lZifSEB7tWKaXyPfU7hdQJszkDwC+7z82zWJOP6mpzDOl9PZo0/IH9EPfZ71E1IGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240129; c=relaxed/simple;
	bh=XCaU6bsb7cFGhio8oTMKtsIaBnbfIi1qUUPIkuYsc2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3LmxDaogY12LZ6T1uc0VF6oQEXGCkegpVeNwZ/MNzZaQZmrYd7kzVfCdwJgHyJSIc6xze2PzPwOacQTjzWcDr7nHxx0HYAsnjyIFrc12TfbEEUoZNUI3fUQbnc+bR7ubZ+9J6yCKw+Muz4l4YekN5kev12HCy+Z29zvKkDBMN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MBTo+zfG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MBTo+zfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244241F00ACF;
	Tue, 23 Jun 2026 18:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240128;
	bh=eBKpBlHEBv5mZqxiZ5Q8kV8/3pnZGECbuSisnTVMdaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBTo+zfGhfPJvGdBgqcEBPjcuNOR/rPWsOAzccz7VJWp1tepf2kVhyq0YTouqjQWF
	 IMYyWT6SlOkL0I7Hnt5j529vUQC/3zbjGaSA2MlnxF3PIMJCD4eoLorJojRJzy6z5r
	 crA3QgqObNDy7IqhRkJc4IWqzorMC0ER0CfZ2QVnyOEPEDsHhdZbcj3t+k4QWbOpVG
	 bpK3AtW37Oli26CimwaMVA74mFxPAJVFW3AKu1Rge8wM2/wAtWEp8XKq+p/R50e416
	 dkm0FtFhwYcme/5YzvG4ccwzcTwzzwrSIseueCK2SxMStreUS9OojAYLAyBoCl0bV+
	 th6lOPLeBiU5w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 14/22] KVM: arm64: Grant write permission when DBM is set at S1
Date: Tue, 23 Jun 2026 11:41:53 -0700
Message-ID: <20260623184201.1518871-15-oupton@kernel.org>
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

The DBM bit effectively behaves as a permission bit when using direct
permissions, especially so in the context of accesses that do not update
the dirty state (like AT).

Treat AP[1] == 0 for the purposes of computing permissions, relying on
the walker to abort if it fails to set the dirty state where required.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index bfba31b270a9..faffb69c2eef 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1077,11 +1077,23 @@ static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
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
@@ -1105,7 +1117,7 @@ static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
 	} else {
 		wr->ur = wr->uw = wr->ux = false;
 
-		if (!(wr->desc & PTE_RDONLY)) {
+		if (!(ap & BIT(1))) {
 			wr->pr = wr->pw = true;
 		} else {
 			wr->pr = true;
-- 
2.47.3

