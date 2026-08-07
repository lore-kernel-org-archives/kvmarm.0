Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64C642F6E3
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 10:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786099293; cv=none; b=CNPhUymL2J74NPohQiwKn5WA4ZUWopU5/2K6JA39R0XDddDm/SVaZITEwY9Jtw2DHbdSIV3imR5E3I9VqLL66uKTkvcUSwfbmDlZvsbyc7n43SobAAa3yQqQluuNIfnzgI8a+FhgTNjumTuaNl/LGZmkDRuF8+zhU8lfk+8gFPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786099293; c=relaxed/simple;
	bh=sBAMk3TIjuNteCkbUOcCaHOcuRV3JfadVEPYVHAwTrw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tR55s7x9ht/1cZXrfKbtgDoSZHXqUMIYlVlgu96unN+QHg2WGdxNs9XjzIGQaHaQ4ssZFu6nWEfYzjAymvwUOJmvjti1AZjCB3TB4+DQlW3oQ6y0QgTclBrcH+kwsM4QJ5m1X8Fw+cBTpRe4j9rIPLfM/tVq7CA1e5hv1IgyjIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kyHH7hsL; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kyHH7hsL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786099287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FXAUwRKtIA0sEu908Fyzr1rasWtjR+9/qFmLbf34T8M=;
	b=kyHH7hsLJROPYWYpdDqxaH6UQTXc3sRl2HQttC8Q+OCWBcKB3LHKv8tx9G3nVrgLbNGkO1
	MzUycBBIi52m5RAPF0d3UoQnyVoONLV2H9D5Y+5R0zq2fgDHiXrKQeCDAtipbRPQfU2CHs
	GVzmNRrVMC/0B422oEcoL07SZL6/x3Q=
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
Subject: [PATCH v2 4/4] KVM: arm64: vgic-its: Point saved ITEs at the next valid entry
Date: Fri,  7 Aug 2026 11:41:02 +0100
Message-Id: <20260807104102.2410744-5-fuad.tabba@linux.dev>
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

An ITE whose collection was dropped is saved as an invalid entry, and
vgic_its_restore_ite() has no offset to follow from one, so the scan
steps a single entry at a time until it reaches a valid entry or the
end of the ITT.

Compute the offset to the next ITE that is saved as valid instead.

Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 1589f06e66904..9e782a4fea7e5 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2035,15 +2035,16 @@ static u32 compute_next_devid_offset(struct list_head *h,
 
 static u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
 {
-	struct its_ite *next;
-	u32 next_offset;
+	struct its_ite *next = ite;
 
-	if (list_is_last(&ite->ite_list, h))
-		return 0;
-	next = list_next_entry(ite, ite_list);
-	next_offset = next->event_id - ite->event_id;
+	/* Point at the next ITE that vgic_its_save_ite() stores as valid. */
+	list_for_each_entry_continue(next, h, ite_list) {
+		if (next->collection)
+			return min_t(u32, next->event_id - ite->event_id,
+				     VITS_ITE_MAX_EVENTID_OFFSET);
+	}
 
-	return min_t(u32, next_offset, VITS_ITE_MAX_EVENTID_OFFSET);
+	return 0;
 }
 
 /**
-- 
2.39.5

