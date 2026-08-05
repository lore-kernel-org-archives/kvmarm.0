Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1823FDBE7
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 09:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785922745; cv=none; b=BRXyN8oIKjMpKilTexyJIFinkD3bzPYWpgm3yXNcf3U3Z8WTIwd/IsMgX8WZ9vvzOIswkrI60EX6NzKHR6807XzoDbI6JqLVHmd6j7sWg1/3S8UKj5TejjIxcT9FI/VkMHCRVBUCqrlyQPWbBUcs99nHo1hQ6PIXuhHCtyBXyYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785922745; c=relaxed/simple;
	bh=43nIU2EkqeEwkSPw2nRlklzH3Ir/5IlnjdHXbjU4Dts=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vC1rXu9fQGY9wsZYL5lbQE25PcXw5DNEXWvEJ0+c0Nck3Fn/PWVD1yyHht4JuWdoxt/59YFATdq8BvGm0p+crD6sWENksA1ISQ3qLF2e9AP+ze7esBTf89e2hpmWjALoClMclAayl0jxIya73lmfoB/800Lz18Ia57/TlsehyI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HKh4IXIv; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HKh4IXIv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785922741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rPDR+Ax2mjvgE26rYgUW+aQnYDPjJl0AyLsMcbzCS2k=;
	b=HKh4IXIvqrrAd7KFVo/dSmdjPRRZMObTmeFaKbo5EMkOmXXM+1o86Ee0aN/gyM/SzcPAnJ
	q68WWH/Xtvr3kpy/Mgn/KTFGjaWSu8EuI7GlcrwH4K1bz/0GzWHXWB1yrd3u9f935NnRB0
	jrFbV/x1AQD13RPGtMysx7Wje4vSNXM=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: arm64: vgic-its: Don't write past the end of the collection table
Date: Wed,  5 Aug 2026 10:38:28 +0100
Message-Id: <20260805093828.3626610-4-fuad.tabba@linux.dev>
In-Reply-To: <20260805093828.3626610-1-fuad.tabba@linux.dev>
References: <20260805093828.3626610-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

vgic_its_save_collection_table() computes max_size but uses it only to
decide whether to append a terminator, leaving the walk over
its->collection_list unbounded. A guest that disables the ITS and
rewrites GITS_BASER with fewer pages, VALID still set, keeps every
collection it mapped against the larger table, because KVM stores the
new BASER unconditionally and frees the list only when VALID is
cleared. A save then writes up to 448K past the end of the table.

The writes stay in guest memory, as vgic_write_guest_lock() validates
every gfn, so the guest only corrupts itself. Stop at the boundary
regardless and return -EINVAL, which is what
vgic_its_save_device_tables() returns when a device falls outside its
own table. -ENOSPC describes the condition better, but -EINVAL is
already in the error set documented for KVM_DEV_ARM_VGIC_GRP_CTRL,
and -ENOSPC is not.

Fixes: ea1ad53e1e31a ("KVM: arm64: vgic-its: Collection table save/restore")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ed281fbf008b9..c709fc5e17cda 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2540,6 +2540,9 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
 	list_for_each_entry(collection, &its->collection_list, coll_list) {
+		if (filled == max_size)
+			return -EINVAL;
+
 		ret = vgic_its_save_cte(its, collection, gpa);
 		if (ret)
 			return ret;
-- 
2.39.5

