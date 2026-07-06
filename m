Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DF53FB043
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 08:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783326994; cv=none; b=p5OAhGcTpYHgirb2vFu2lzNhM+m2+CiH+QfcGKpgkyi6HpQBDH2w9d31q+JNujvWOEguaA2h7u98CWu2dJ3qzX3uEMvP6G4VQ5stVExKMXixNcyepdUgrEMEAPxriQRTmphWHuhmUMigzPPorA3ruLBDpWnWYWrWtaZ339GnK14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783326994; c=relaxed/simple;
	bh=b4jDjuxEOIrdUmoqCbCK5y91rdmVS82n2noSmjfnCgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oZgOvLVs6ygCStkmZ9iK1SyrU3lQUvskd9hiyeGDVTSOm4KVdZ4iCO3CdyUmZEn8/A2SsYrC30oo/h2gpv1KnodTmb4FCGfVxkx4EemVfT2f+oqSFTISk8RTf7JvwOPF2RD0KNguhNHqh/HMxDbUA7VwJHu+R2MXZD3fz9jvpsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k2iWWElB; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k2iWWElB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783326968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hhNE4t658F9hrYNrxZLdN8R/PyGLJh0z8G8fKiyshwk=;
	b=k2iWWElBi0Br+u7f9Sj4hzSqwhfvlNP8jzh20D92F6EKEhTiwgcqRAaILmVLzhTVfmhc+L
	J5Yo+AXsT8BZd8DH7jAAfWvI8rXzcUV1XpzyndHntaMM9zCuZjSQlRACg8cPocpK/AqpnE
	hqva/4u8K6KiTYBOBp4TI7FhY+ogD6g=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH kvmtool v1 2/5] Remove newline from end of die() aborts
Date: Mon,  6 Jul 2026 09:35:52 +0100
Message-Id: <20260706083555.302972-3-fuad.tabba@linux.dev>
In-Reply-To: <20260706083555.302972-1-fuad.tabba@linux.dev>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

die() already adds the newline at the end of the string.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 util/util.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/util/util.c b/util/util.c
index 6f41e2c..05d49c4 100644
--- a/util/util.c
+++ b/util/util.c
@@ -128,14 +128,14 @@ void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 	unsigned long blk_size;
 
 	if (statfs(htlbfs_path, &sfs) < 0)
-		die("Can't stat %s\n", htlbfs_path);
+		die("Can't stat %s", htlbfs_path);
 
 	if ((unsigned int)sfs.f_type != HUGETLBFS_MAGIC)
-		die("%s is not hugetlbfs!\n", htlbfs_path);
+		die("%s is not hugetlbfs!", htlbfs_path);
 
 	blk_size = (unsigned long)sfs.f_bsize;
 	if (sfs.f_bsize == 0 || blk_size > size) {
-		die("Can't use hugetlbfs pagesize %ld for mem size %lld\n",
+		die("Can't use hugetlbfs pagesize %ld for mem size %lld",
 			blk_size, (unsigned long long)size);
 	}
 
@@ -144,10 +144,10 @@ void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 	snprintf(mpath, PATH_MAX, "%s/kvmtoolXXXXXX", htlbfs_path);
 	fd = mkstemp(mpath);
 	if (fd < 0)
-		die("Can't open %s for hugetlbfs map\n", mpath);
+		die("Can't open %s for hugetlbfs map", mpath);
 	unlink(mpath);
 	if (ftruncate(fd, size) < 0)
-		die("Can't ftruncate for mem mapping size %lld\n",
+		die("Can't ftruncate for mem mapping size %lld",
 			(unsigned long long)size);
 	addr = mmap(NULL, size, PROT_RW, MAP_PRIVATE, fd, 0);
 	close(fd);
-- 
2.39.5

