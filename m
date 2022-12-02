Received: from out-212.mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA33110C
	for <kvmarm@lists.linux.dev>; Fri,  2 Dec 2022 18:52:25 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670007143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZCh4EK+ILrdNiTkDxgoQos8GcG756fNB3ErlzEuT8I=;
	b=oIRtW/qtFE+f4BRGQbkhz9LDxzzx4jHeyI9Kr0i7Q8X237Bcpai7BotPaX/3hUG5tesQIk
	cEyEUI31AfdEY2A3AHbp0YGJ75fHka73HJXRL0JgsS4pFl9SRkWSiwXdZxTV0TuRmHmuEf
	YhFScCjKQgwpM8fNDDxvtEDM8wq+Q8E=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] KVM: arm64: Don't serialize if the access flag isn't set
Date: Fri,  2 Dec 2022 18:51:54 +0000
Message-ID: <20221202185156.696189-5-oliver.upton@linux.dev>
In-Reply-To: <20221202185156.696189-1-oliver.upton@linux.dev>
References: <20221202185156.696189-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221202185154.8zYvezdZaEn1wl_8s0YhjXlurLUd9cJrEfoaSdEaTVo@z>

Of course, if the PTE wasn't changed then there are absolutely no
serialization requirements. Skip the DSB for an unsuccessful update to
the access flag.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 204e59e05674..aa36d896bd8c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1116,10 +1116,14 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
-	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				 &pte, NULL,
-				 KVM_PGTABLE_WALK_HANDLE_FAULT);
-	dsb(ishst);
+	int ret;
+
+	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
+				       &pte, NULL,
+				       KVM_PGTABLE_WALK_HANDLE_FAULT);
+	if (!ret)
+		dsb(ishst);
+
 	return pte;
 }
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

