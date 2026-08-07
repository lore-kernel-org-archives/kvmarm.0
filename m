Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B73541D206
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 10:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786099290; cv=none; b=RYONAVAiR3wfYEHf6rBndVooJpuJPIrZ1Db4wTmYWFSMtkrYq9IyYc0ORcHc3WXBmRNTBmRzMybVY14cifN+ythVNoKUrnO8DnxxAmwIFklG2xuTmEjpIw7CqOzz54x9wmvLxK1O83y1GxM1B5GPGTfEHD9+57m+/90dMSUWJK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786099290; c=relaxed/simple;
	bh=dooZ2Nsw+1ffRigL9s2oct8rGMhsJ7urG/uzFCCcWZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o7thjIUbqE0B0i84ANIokwMtDVQNgeWFUK9rJ2gqt+ApaIonetrOLXcvTj4XxQ5oYxsgyIDom2+KPaGJR0w3EYkhfX27g3/eZXQwFdb2LnYeXG+ArJvGNsM0+d6LWbP1bsutrj8QP3gBJTPgLsxe8+qn7Q+9Nz9QJCNyXHsZtUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iauK43Lz; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iauK43Lz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786099285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3nr/a0dOZRkxfGZoRpT42C6sSO2flc3qcvSm9XbBZls=;
	b=iauK43LzFFEk438JMee7/pnVbCao2fOGE8Vj+GrWkJP5A0Ql9PLgc5IyAoOuBVwggvJdfA
	HVK7SqW89K8YcqJ26dFijI5Skizch3Z4iPLVIbhsp+0ddDrZN/lCmQ6/Eiqzujyjlblo/n
	9SxEuIcr5p0Fpn0X/UMATxCraq0ZnUU=
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
Subject: [PATCH v2 3/4] KVM: arm64: vgic-its: Don't save collections the table cannot hold
Date: Fri,  7 Aug 2026 11:41:01 +0100
Message-Id: <20260807104102.2410744-4-fuad.tabba@linux.dev>
In-Reply-To: <20260807104102.2410744-1-fuad.tabba@linux.dev>
References: <20260807104102.2410744-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A guest that disables the ITS and rewrites GITS_BASER with fewer pages,
VALID still set, keeps every collection it mapped against the larger
table: KVM stores the new BASER unconditionally and frees the list only
when VALID is cleared. vgic_its_save_collection_table() then walks the
whole list, writing up to 448K past the end of the table, and saves
collection IDs that vgic_its_restore_cte() rejects, so the save succeeds
and the restore fails with -EINVAL on the destination. The overrun stays
in guest memory, as vgic_write_guest_lock() validates every gfn.

Validate each collection against the current table with
vgic_its_check_id() and return -EINVAL, as vgic_its_save_device_tables()
does for devices. Collection IDs are unique and the collection table is
never indirect, so the check also bounds the walk.

Fixes: ea1ad53e1e31a ("KVM: arm64: vgic-its: Collection table save/restore")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ed281fbf008b9..1589f06e66904 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2540,6 +2540,9 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
 	list_for_each_entry(collection, &its->collection_list, coll_list) {
+		if (!vgic_its_check_id(its, baser, collection->collection_id, NULL))
+			return -EINVAL;
+
 		ret = vgic_its_save_cte(its, collection, gpa);
 		if (ret)
 			return ret;
-- 
2.39.5

