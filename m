Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFCA1DF97C
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769195803; cv=none; b=vCc9sCU78uZG3ruaPADebDGGFAWVZkC5ajg/FJxxLMKeD61G+tC1dkJOinq98jUhbY9RNYayb7+G6OkBWklYD6SwMWe1PXjsZGAVsXJLhupwYeUuDVrSN/z5hhgRxQXB1nSvgc6bzRYdyKPdX/YYio5IUpVtlWvh4Svwf1zrzZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769195803; c=relaxed/simple;
	bh=9rLCNYcKbPurJNMKZwPicJGqVzWqMF0eXcse6bywNwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqevVot7DRtZTNPi4YtfQIMWsJg7Aw1ZMemKtg5KIID1nR1Y+JsGV2ucWUQr1JHJWyISuViJHnFgGudZzjXJp1FUG/c762wgf7hR/a6yzboNnwMagOxn9XzG/tBBr0AUZj87ltz/soBDGuG+jSeth9ozScnMEnSYGrjGEj97o7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VF+4R3w4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VF+4R3w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB28C4CEF1;
	Fri, 23 Jan 2026 19:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769195803;
	bh=9rLCNYcKbPurJNMKZwPicJGqVzWqMF0eXcse6bywNwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VF+4R3w4Rdp3BO9CrR+APcM3lKO2ZXFeBeQO76RWwdG4CT49Ur3US8AUt8In+CQF6
	 GUD2rbFb32917CjtCBEhs+SBp+al+g2QbXroaSdfUK2twtgWw5eB6okv078RNNIRmh
	 xIHlyDZS37W66NqCQfGj6xI0vsBmy1TJEx+/idAIp/ohWH0w8QqiG+2a4oGO6OGeKR
	 V76lCTdYodzvMli22K5DtMwTku37JgFm/IvICecB0z7p9o14MKritmZQWDjgygv4i/
	 GHdDm1vk9dhQi9xliWXw+8GnElH4CP1jy03QvirhL7rOMBJDkqqgC3nDDJLdaIcaff
	 bhk5XWxZwo6fA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vjMe9-00000005A2V-3DAj;
	Fri, 23 Jan 2026 19:16:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 5/5] KVM: arm64: Simplify PAGE_S2_MEMATTR
Date: Fri, 23 Jan 2026 19:16:37 +0000
Message-ID: <20260123191637.715429-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123191637.715429-1-maz@kernel.org>
References: <20260123191637.715429-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, qperret@google.com, tabba@google.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Restore PAGE_S2_MEMATTR() to its former glory, keeping the use of
FWB as an implementation detail.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/pgtable-prot.h | 4 ++--
 arch/arm64/kvm/hyp/pgtable.c          | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 161e8660edddc..d27e8872fe3c8 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -109,10 +109,10 @@ static inline bool __pure lpa2_is_enabled(void)
 #define PAGE_KERNEL_EXEC	__pgprot(_PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_EXEC_CONT	__pgprot(_PAGE_KERNEL_EXEC_CONT)
 
-#define PAGE_S2_MEMATTR(attr, has_fwb)					\
+#define PAGE_S2_MEMATTR(attr)						\
 	({								\
 		u64 __val;						\
-		if (has_fwb)						\
+		if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))		\
 			__val = PTE_S2_MEMATTR(MT_S2_FWB_ ## attr);	\
 		else							\
 			__val = PTE_S2_MEMATTR(MT_S2_ ## attr);		\
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 00e33a16494bd..a6f7533ce4974 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -653,13 +653,12 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 
 #define KVM_S2_MEMATTR(pgt, attr)					\
 	({								\
-		bool __fwb = cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);	\
 		kvm_pte_t __attr;					\
 									\
 		if ((pgt)->flags & KVM_PGTABLE_S2_AS_S1)		\
-			__attr = PAGE_S2_MEMATTR(AS_S1,	__fwb);		\
+			__attr = PAGE_S2_MEMATTR(AS_S1);		\
 		else							\
-			__attr = PAGE_S2_MEMATTR(attr, __fwb);		\
+			__attr = PAGE_S2_MEMATTR(attr);			\
 									\
 		__attr;							\
 	})
-- 
2.47.3

