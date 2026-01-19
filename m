Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CFA306486
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 10:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768820217; cv=none; b=QjEXqeJdOzZPuUDjhDUS3K7NkDP/w/wcLi2Xa6OwZAWHz/tJzDRFscyK9IRIppuLys1XGuZtHtlWrckPg7aq4iKW7Y07UPCzSIUaIb3Tz4hQrahwQMGRgF3JXQgzxq7D1eF9kbXKtiv/aAtxjAHj5L/rErAhKU17UdrLstCTmIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768820217; c=relaxed/simple;
	bh=SGH3ts8Vw9wIWOIUny++sl2jqEmIiwIy+4HgW5CQ+I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vf1Mx7Z8TT5yO8jR96nua9ldp9tjQqIXk7GomIHwdL8Xpp9ClEEYo/76yFwgox5g+IEv6CLLulQU+PH2/TjSg3QchoXEdsRF4SK5Sm4FIeg55Iu+6WihIWr+qIrEl8qci/2tEHZDEP7UiH+Rmnocswem8kUqP8VTrObhclYaBvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDLBj9NB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDLBj9NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BAEC19422;
	Mon, 19 Jan 2026 10:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768820217;
	bh=SGH3ts8Vw9wIWOIUny++sl2jqEmIiwIy+4HgW5CQ+I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDLBj9NBj6Wpr0asAuXsL0HDF+wOP3F6eyHwOJpZYl6Qz1CVmXE2/rNcYnB6oOuka
	 bBOSjeaIkcyOEVrH5afpeUQy1BMEwVc29V1OBLzPmjdydT32nQcJkq3hCqWUvE66A3
	 qP2lOWGl0VlnFQ1mUahVW6oYt3qw20M6MVNDRk4O+A8OmOIN8Ri0waKJw7KYbblHZ7
	 Vrj4Ivw+7aKTp0KKPg5O9xIQMQeAk9CN5tSJcLaQkwfDNmC62cDHR5PjViSj/AY3H4
	 VnFZTqZKr7MdYLmxgV8fzb6+ZazaBCuG5fIaB6Cu9qR9COSz30Z0SNoy14H5qxH3TD
	 i47pVO16+e6nw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vhmwJ-00000003YVK-0lL7;
	Mon, 19 Jan 2026 10:56:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 2/6] KVM: arm64: Add KVM_PGTABLE_S2_AS_S1 flag
Date: Mon, 19 Jan 2026 10:56:47 +0000
Message-ID: <20260119105651.255693-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119105651.255693-1-maz@kernel.org>
References: <20260119105651.255693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, qperret@google.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Plumb the MT_S2{,_FWB}_AS_S1 memory types into the KVM_S2_MEMATTR()
macro with a new KVM_PGTABLE_S2_AS_S1 flag.

Nobody selects it yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index fc02de43c68dd..9ce51a637da0a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -232,10 +232,12 @@ struct kvm_pgtable_mm_ops {
  * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
  *				ARM64_HAS_STAGE2_FWB.
  * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
+ * @KVM_PGTABLE_S2_AS_S1:	Final memory attributes are that of Stage-1.
  */
 enum kvm_pgtable_stage2_flags {
 	KVM_PGTABLE_S2_NOFWB			= BIT(0),
 	KVM_PGTABLE_S2_IDMAP			= BIT(1),
+	KVM_PGTABLE_S2_AS_S1			= BIT(2),
 };
 
 /**
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 947ac1a951a5b..3c5f399b1b986 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -659,7 +659,18 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	}
 }
 
-#define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
+#define KVM_S2_MEMATTR(pgt, attr)					\
+	({								\
+		kvm_pte_t __attr;					\
+		if((pgt)->flags & KVM_PGTABLE_S2_AS_S1)			\
+			__attr = PAGE_S2_MEMATTR(AS_S1,			\
+						 stage2_has_fwb(pgt));	\
+		else							\
+			__attr = PAGE_S2_MEMATTR(attr,			\
+						 stage2_has_fwb(pgt));	\
+									\
+		__attr;							\
+	})
 
 static int stage2_set_xn_attr(enum kvm_pgtable_prot prot, kvm_pte_t *attr)
 {
-- 
2.47.3

