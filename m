Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75BB3AE1AD
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 09:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786958832; cv=none; b=ZgJ9j1HN4WAnKF8YeQx2qfxILYXg4CEyeEh9b8/LxqaQmkLV4jx2Fc8KXwEQYKgbpR0+Casm32S1A0y5b5hrENRqgd6x/A7DQFBtvqID9Z1u8EuVb4Wz62plNg/xJQGX5iM3gBGfZ66/xVME0PVjxuRHC6uNNedBFr+j6t7Rr7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786958832; c=relaxed/simple;
	bh=+dxV1ztXc/nHuz2DsiaVJGccpUO0LYuVfovfEcscX04=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HwODP/6Zms2NMDc50bPpaQW2BQwsTsYg7MGbbgS2199jr66N2HQldBlEWVHlGtXfGntGZ8qKH82tY36sZNW/HcWTjshTJ/h3m+8ReGVa2cfaCoVbqeeYs6TmYaSSEQkiulp+jYN8eVCZdASLHsu+QJc3BARVYbGURxJHaC8aU9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ayDAGIY3; arc=none smtp.client-ip=91.218.175.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ayDAGIY3"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+dxV1ztXc/nHuz2DsiaVJGccpUO0LYuVfovfEcscX04=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786958828; v=1; x=1787563628;
 b=ayDAGIY37NhmHPH/8YfuOBrRFQb75dL1KL43PYagWL8Sz4Ggbe89IYHlJsGhuxLswZHmCG6R
 Xuwg3VFC/+ufw4jusQ2mdn8NNCVMEY+SEemVIckExIkxonV/bZwhbeiJCEhUw9aL5aUnOr40upJ
 U+SHj0X3NHQzVwOVa7CDayeQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 940d36e792b6947f;
	Mon, 17 Aug 2026 09:27:07 +0000
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: vgic-its: Reword the comment on a collection-less ITE
Date: Mon, 17 Aug 2026 10:27:05 +0100
Message-Id: <20260817092705.1112634-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The comment above the NULL collection check in vgic_its_save_ite()
names only MAPC with V=0, which is UNPREDICTABLE. The route that
requires the check is clearing GITS_BASER<coll>.Valid on a disabled
ITS, a legitimate operation that orphans every ITE at once. Name both
routes.

No functional change intended.

Suggested-by: Eric Auger <eauger@redhat.com>
Link: https://lore.kernel.org/all/0ce5e496-a067-48fd-80d2-94fe9981d505@redhat.com/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Based on kvmarm/next, since the comment this reworks was added by
    c6c156d931c3 ("KVM: arm64: vgic-its: Don't dereference a NULL collection
    on ITT save") and is not in a release yet.

 arch/arm64/kvm/vgic/vgic-its.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index f6538b1976f9b..26c665e0a2386 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2112,9 +2112,9 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	u64 val;
 
 	/*
-	 * MAPC with V=0 keeps the ITEs mapped but drops their collection,
-	 * and with it the ICID. Save a zeroed entry, which the restore path
-	 * reads back as invalid.
+	 * MAPC with V=0 and clearing GITS_BASER<coll>.Valid both keep the
+	 * ITEs mapped while dropping their collection, and with it the ICID.
+	 * Save a zeroed entry, which the restore path reads back as invalid.
 	 */
 	if (!ite->collection)
 		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);

base-commit: 57e7cf13ac26bf1a3dba6cfa601f7b2481811575
-- 
2.39.5

