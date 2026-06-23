Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1FF38BF70
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240131; cv=none; b=WjHMXfuHaj2BEGqJFeMlS48RW8c3oaq/ZbSzkhqlKk+HXyG5iG1haLm2EVMxMnzdWZLZzMwCUJzVsoAEO35Xiva9K+gMdOX8DVhh1304wBJbih6Zi1Gndix2irfyeJyV9PRcTClimGdFFolfralg2CVVOg1teIXlCd6kEkbQuIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240131; c=relaxed/simple;
	bh=V0KyMekYGWc+xU5r+9s7fm452h5kHt1iOAlb4seBL90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1bpzOL1TYJyFt/Tird8MDOwGHLywEwuhxAVILIshbpejEOjfg+QGgVQ9CBrU77FB1F/BKbHZV3v3kgXfyK7UEVHC2ClYGa3T81pMoWkLn3+0MB/mM/Rjb62EwFTOYPYgbUJkouI03MWw73hGjotKBEoRC0KL4KNI4iYxquMRvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtKuYod6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtKuYod6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D7E1F00AC4;
	Tue, 23 Jun 2026 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240130;
	bh=BFDLtjcFnePDZEfV80rY2dSJmHUITi9nYsF61hpr9RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtKuYod6O2tPpiUaEvowPvVOMUzNVgCD6AtNIErhBJQlzfHnlX3oJFrlcPkNek8oy
	 EQhYk/u/dlyS5vTUmonyJ4xV5T5T928k5EJTT8d6sErUKx2qWpqKWdjluUy1EZymfc
	 e5qNmauLJOaBGy6KTNJfU3uvroSLeo/DqL4Yy85JvmxTuATSAqdGr3/19NboP/jt2d
	 ciVh2qU2Mci4X1071Fab6gboaWW1aum/WlOIZzLKBDGPOmbVij8SdF4pN712gcy3Vt
	 xGYwov8vfSUhoCrWd47gdC0A3iaRtMHoIQQBULNbkTFKl0VvWUFmoAPBZKPgNSnBPN
	 Mgvlb3xb/K1Hg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 22/22] HACK: KVM: arm64: nv: Set the dirty state for CMOs that fetch for write
Date: Tue, 23 Jun 2026 11:42:01 -0700
Message-ID: <20260623184201.1518871-23-oupton@kernel.org>
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

From: Oliver Upton <oliver.upton@linux.dev>

Cache maintenance instructions that fetch for write do not set the dirty
state on descriptors, effectively passing the permission check and
leaving the descriptor in a writable-clean state. While this may make
some sense as the literal write has already occurred, there is no way to
correctly represent a "writable, but only for CMOs" permission in the
shadow stage-2 in such a way that the next genuine write generates a
permission fault.

A possible alternative would be to treat CMOs using writable-clean
translations as NOPs, relying on FWB to force everything coherent on the
CPU. This mostly works but will lead to breakage for VMs that have
assigned devices performing non-coherent DMA.

Another option would be to set HCR_EL2.TPCP and do full trap+emulate of
CMOs. And yes, dear reader, that would suck.

Just do the obvious thing instead and mark the descriptor as dirty for
CMOs. Maybe we can get an architectural relaxation if we're lucky...

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/at.c     | 1 -
 arch/arm64/kvm/nested.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 31a55b9d3385..2be9100cb84e 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -480,7 +480,6 @@ static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step
 
 	switch (access->type) {
 	/* R_RKMHW */
-	case WALK_ACCESS_CMO:
 	case WALK_ACCESS_AT:
 	case WALK_ACCESS_NONARCH:
 		return false;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dc2a8b6483c2..54c5966e1a6f 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -246,7 +246,6 @@ static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step
 
 	switch (access->type) {
 	/* R_RKMHW */
-	case WALK_ACCESS_CMO:
 	case WALK_ACCESS_AT:
 	case WALK_ACCESS_NONARCH:
 		return false;
-- 
2.47.3

