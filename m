Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211941EE00A
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 10:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768820218; cv=none; b=DTz2T+8R4q/0B7Ufzo+QGmAY83eKoXARKRdu226I24S83DggBko81b1oBip9egW8maR2OqFe4rGNau/H8zL3PzFNUCYzKJK+AWKaw3CeudX6rWU34I/pgYi7D/lAuNwSMy55TRq/fYwbx5ONTPTg24olN2YQl3dqlLY5Lb7YQt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768820218; c=relaxed/simple;
	bh=S+d7dcrSisjP88iOeAUf6TBHCdFaRU9DyBerjTFuYU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGEYZpIw9m29NDBBFt/3g5Fnx+aAbNNLESmvyB5NMXlnFZWPdfXb0Ynj+E6uBrGz1J28UXu2jKo5pY6Q+E6T7sIQcfwio8E2EUXUV2wkIzU+VOwMmekbjiq8ABJBa8rlkqa2SzhgLJ6cUI+ElhpVDdN0Wnkq5/TRxcwmPnd5wtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6e4LrkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6e4LrkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB52C19425;
	Mon, 19 Jan 2026 10:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768820217;
	bh=S+d7dcrSisjP88iOeAUf6TBHCdFaRU9DyBerjTFuYU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6e4LrkNppSWjaM5xObnJIDmqO2vz3n+YS+yKTWV+mBhYAkcHBDninybuIp/FRXGl
	 i7dtf7Mwzag94AEkRCgn1fXRavyzNGjR/SZKTZ+pgnCIxpEBCFtcTSFnGrHzHLKA0g
	 qtF7wXKlq4UIdrOJCqper/TmXww0DyI5q9JnexC07rF0OZ7ZtOd3mQm6c11PThthfX
	 a4uU8pD4BxzxaAziwG0a2B3b5UGew9PxsYbEwVOvob8PgBClHX+yYx1qzVJDfNPO7m
	 SLJUyhJ0FR34MJnNTzuX2U3vSkUSF8cK6tTjOZ8HNX9FM5wuH++t/blrnZKgqM1Dle
	 PglhRaG7BBqdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vhmwK-00000003YVK-0Iyd;
	Mon, 19 Jan 2026 10:56:56 +0000
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
Subject: [PATCH 6/6] KVM: arm64: Simplify PAGE_S2_MEMATTR
Date: Mon, 19 Jan 2026 10:56:51 +0000
Message-ID: <20260119105651.255693-7-maz@kernel.org>
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

Restore PAGE_S2_MEMATTR() to its former glory, keeping the use of
FWB as an implementation detail.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/pgtable-prot.h | 4 ++--
 arch/arm64/kvm/hyp/pgtable.c          | 6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

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
index 3c2f7967fdc03..34c9afa442932 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -660,11 +660,9 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	({								\
 		kvm_pte_t __attr;					\
 		if((pgt)->flags & KVM_PGTABLE_S2_AS_S1)			\
-			__attr = PAGE_S2_MEMATTR(AS_S1,			\
-						 stage2_has_fwb());	\
+			__attr = PAGE_S2_MEMATTR(AS_S1);		\
 		else							\
-			__attr = PAGE_S2_MEMATTR(attr,			\
-						 stage2_has_fwb());	\
+			__attr = PAGE_S2_MEMATTR(attr);			\
 									\
 		__attr;							\
 	})
-- 
2.47.3

