Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB959C6FA89
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 08:35:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6685C4BC7F;
	Wed, 14 Sep 2022 04:35:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3wADpnV5mquR; Wed, 14 Sep 2022 04:35:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26DC64BC0F;
	Wed, 14 Sep 2022 04:35:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D83F84BC43
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:35:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h6UqS2IqgFtD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 04:35:35 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8EE8C4BC6F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:35:35 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B004BB811C5;
 Wed, 14 Sep 2022 08:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DD7C433C1;
 Wed, 14 Sep 2022 08:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663144534;
 bh=USTrkOz14Psk3Fomoa4pEpP7pHlt3Yl8eSD2PtSGQGk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=AFZyulIC6BQB7+gPmAROa+0dCj3F5bS4WAnO/gQp/InYqU34/8px8vO4qv4Nzvlzt
 y3dub7wtGgE0AK2b3tKNrXmlxW2AVMdH18opWJmK7sallQ2zqXK+i4kO9w+pAJKucT
 4Ew1uh7nJRWPZui2/ngB0SiqmieZSMhQ1b/ZWip52w683+5aUFLYKCZvKleWn7liIi
 ZonzGRvLZWGoVqPkLRd4owp4LyZ77Sm0NXD5YES93KkWbQ5hJ0cZWSVsi+e4JchzA9
 kwxgC0S9erMJuo6DhqRGWOf1PluEl4RwPEchh2n/fB5tADmvM2tQ6z7sBvrXyJoeMp
 N82E/cajdtenA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 07/25] KVM: arm64: Prevent the donation of no-map pages
Date: Wed, 14 Sep 2022 09:34:42 +0100
Message-Id: <20220914083500.5118-8-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Quentin Perret <qperret@google.com>

Memory regions marked as "no-map" in the host device-tree routinely
include TrustZone carevouts and DMA pools. Although donating such pages
to the hypervisor may not breach confidentiality, it could be used to
corrupt its state in uncontrollable ways. To prevent this, let's block
host-initiated memory transitions targeting "no-map" pages altogether in
nVHE protected mode as there should be no valid reason to do this in
current operation.

Thankfully, the pKVM EL2 hypervisor has a full copy of the host's list
of memblock regions, so we can easily check for the presence of the
MEMBLOCK_NOMAP flag on a region containing pages being donated from the
host.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index c30402737548..a7156fd13bc8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -193,7 +193,7 @@ struct kvm_mem_range {
 	u64 end;
 };
 
-static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
+static struct memblock_region *find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 {
 	int cur, left = 0, right = hyp_memblock_nr;
 	struct memblock_region *reg;
@@ -216,18 +216,28 @@ static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 		} else {
 			range->start = reg->base;
 			range->end = end;
-			return true;
+			return reg;
 		}
 	}
 
-	return false;
+	return NULL;
 }
 
 bool addr_is_memory(phys_addr_t phys)
 {
 	struct kvm_mem_range range;
 
-	return find_mem_range(phys, &range);
+	return !!find_mem_range(phys, &range);
+}
+
+static bool addr_is_allowed_memory(phys_addr_t phys)
+{
+	struct memblock_region *reg;
+	struct kvm_mem_range range;
+
+	reg = find_mem_range(phys, &range);
+
+	return reg && !(reg->flags & MEMBLOCK_NOMAP);
 }
 
 static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
@@ -346,7 +356,7 @@ static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot pr
 static int host_stage2_idmap(u64 addr)
 {
 	struct kvm_mem_range range;
-	bool is_memory = find_mem_range(addr, &range);
+	bool is_memory = !!find_mem_range(addr, &range);
 	enum kvm_pgtable_prot prot;
 	int ret;
 
@@ -424,7 +434,7 @@ static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
 	struct check_walk_data *d = arg;
 	kvm_pte_t pte = *ptep;
 
-	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
+	if (kvm_pte_valid(pte) && !addr_is_allowed_memory(kvm_pte_to_phys(pte)))
 		return -EINVAL;
 
 	return d->get_page_state(pte) == d->desired ? 0 : -EPERM;
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
