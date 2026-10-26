Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793025885;
	b=CCROgzRyUt8OY9AKVNX9njtSHQkSP1GGeZC/eqtLQlA8E8YAd33BobpLVLngFOxRDYrz
	 houJ5ueaX/wJ7dsqNNDUTxJGExT6NfTi7sSp1DqAyT7YlU7oJAP2YhSUVVeOHvn2+JsVw
	 HSpPeLWIom5nXPTnQl33I+xUZphvorQ3G7T4sL44b2rk2wp/L+B8TBDhTRySNpYK7duM4
	 Q5y0mf1Aj9uDdRusecMbh38zfLeRybQom/Hmp403KRBIz1Y9sFon7H9oWUFX03WnyOMcB
	 cMW5IBtlUufQPITUUVUl0/M3t2x4nXGKO67yF1v5cghwyRfINXJHu6zP120U3IYk2XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793025885;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding;
	bh=GSEN1e/y0bwGfJJMQ9Hg+c2qcQyTslgLVny4UlJpg1o=;
	b=QoHAu46FIwUyy7dUgHg11t6RI0E+Xz93y2flNarWgStdzA+SXXxbJc650jaK9YiRq60b
	 2P7+Cj9+Q0l+zaTIRgkQ5SyCa1bEPSr1DlO5wfUHWCSqRW848aWW4TeHSxniVymfwPr+I
	 Bv7lzP5p3IMMH8D+RqOdX5ScdHH06EE0b1iyeaWOMwYBtllLs6yBX4/zg5N6kIOGc90jn
	 yTrPZP7ZwePv80ecKjroI5ruc+lbxa9BDPDYdMNoSc0T0r931/4rZy0X/nWphhl9+92zC
	 PX4LwJo+yJOlcUeu04puMm8wqLS1LxA4HvUOneZbhlfV0G7otu1Cs0MEF4MD94M8rVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tc2dGiQf;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A37D7606A328
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 14:44:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A37D7606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tc2dGiQf
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2BDC2720;
	Mon, 26 Oct 2026 07:44:40 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD66B3F7B4;
	Mon, 26 Oct 2026 07:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793025883; bh=lqK7uGIZ/jkYXTWUZmtWT+d67C2f5jU7aALBqK7r/3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tc2dGiQfjBvRRqB83xDgLfT7zZBGGXCOJ/y/RYJCTy0uzkUQD6qVBVtFxLC4QFy0P
	 QMrVMRfz9N6Tu4NyMPmo9maOMAYfFWxIMFkCTSiuBjeLbF1mhFwY1juF6ZmQIItpJq
	 tEwHexZYWuH2RcdnrBz20PdT3yRc/HTIUBk41W2U=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 1/3] KVM: arm64: pgtables: Set DBM attribute on writable Stage-2 PTEs
Date: Mon, 26 Oct 2026 14:44:07 +0000
Message-ID: <20261026144413.441566-2-leo.bras@arm.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026144413.441566-1-leo.bras@arm.com>
References: <20261026144413.441566-1-leo.bras@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3059; i=leo.bras@arm.com; h=from:subject; bh=lqK7uGIZ/jkYXTWUZmtWT+d67C2f5jU7aALBqK7r/3M=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLLup5u3z2By3Ri9qyTVOL/ze8XX5j+3r3DXf9jx7tzrd S86Vge/7ihlYRDjYpAVU2SRfTR/Fc/3KRlHrvxYADOHlQlkCAMXpwBMxLaWkeHF7OOelhsb3O52 xp20aLMsf1ic4ltp/X76thmVUZ+qODYyMtzMubvoaMYU0d3TzL5kXngj45Lzab/2Ln22Rc5PuM5 ObmUFAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

As a preparation to the introduction of HAFDBS-based features, set the DBM
bit (along with S2AP[1]) to all writable PTEs. Also unset DBM and S2AP[1]
when a PTE is made read-only again.

DBM bit works as following:
- If HAFDBS is disabled, DBM bit is ignored.
- If HAFDBS is enabled, and DBM bit is set, a write to non-writable page
  can promote it's PTE to writable (S2AP[1]=1) without taking a fault.

Since it's being set on writable and unset on read-only, it should cause no
functional change.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 3 +++
 arch/arm64/kvm/hyp/pgtable.c         | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..37baa86d6fd8 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -91,14 +91,17 @@ typedef u64 kvm_pte_t;
 #define KVM_PTE_LEAF_ATTR_HI_S1_UXN	BIT(54)
 #define KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
 
+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
+
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
 
 #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
+					 KVM_PTE_LEAF_ATTR_HI_S2_DBM | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
 /* pKVM invalid pte encodings */
 #define KVM_INVALID_PTE_TYPE_MASK	GENMASK(63, 60)
 #define KVM_INVALID_PTE_ANNOT_MASK	~(KVM_PTE_VALID | \
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..8c2320c6a7f1 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -730,11 +730,11 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 
 	if (prot & KVM_PGTABLE_PROT_R)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
 
 	if (prot & KVM_PGTABLE_PROT_W)
-		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
 	if (!kvm_lpa2_is_enabled())
 		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
@@ -1286,10 +1286,11 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 }
 
 int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
+					KVM_PTE_LEAF_ATTR_HI_S2_DBM |
 					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
 					NULL, NULL,
 					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
 }
 
@@ -1366,11 +1367,11 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 
 	if (prot & KVM_PGTABLE_PROT_R)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
 
 	if (prot & KVM_PGTABLE_PROT_W)
-		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
 	if (prot & KVM_PGTABLE_PROT_X) {
 		ret = stage2_set_xn_attr(prot, &xn);
 		if (ret)
 			return ret;
-- 
2.56.0

