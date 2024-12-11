Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145581DE3BC
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 16:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733932991; cv=none; b=jCCzMXW+KS+GIxZ9yV4h/v75nbGL+jNJu9IwXOYVe+STk8FfouVWMgdZ27eRkwxrs8WiBruLFWF4NtZI5Ftm8+yc3ChHMohG6qRZDiTAdqLl7FcE5L/iHZKV/Ma4vckL35siIk06b7SkB8+IVEv7SgGLehuYnRPA/AEd+c4C3nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733932991; c=relaxed/simple;
	bh=WNhpzgsdAKtSd1yhrheXVoze9Qh5uwyI4MdEQXOJRBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DaRBC3veISspY79M04BKaLb4i0qu3O9lMx5XCSd65ymATsdMQH4msywchZewVcVNxKgcr7RZi9Shw766ZUCt3Zw8dB/kvLw3I0Kn/7w4Oq9CQsYOQKrCVWvYlImcJrxys9Wf30PeiSSGqyiwd6CywUhZ6xDfJ24poYj5zt6NE7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C32071713;
	Wed, 11 Dec 2024 08:03:37 -0800 (PST)
Received: from mazurka.cambridge.arm.com (mazurka.cambridge.arm.com [10.1.196.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0CF63F5A1;
	Wed, 11 Dec 2024 08:03:07 -0800 (PST)
From: =?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>
To: ryan.roberts@arm.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Cc: =?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [RESEND RFC PATCH v1 5/5] arm64/mm: Elide tlbi in contpte_convert() under BBML2
Date: Wed, 11 Dec 2024 16:01:41 +0000
Message-ID: <20241211160218.41404-6-miko.lenczewski@arm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211160218.41404-1-miko.lenczewski@arm.com>
References: <20241211160218.41404-1-miko.lenczewski@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If we support BBM level 2, we can potentially avoid an intermediate
TLB invalidation, as hardware is capable of managing the TLB itself
in this situation. Hardware will either silently clear out the
offending entry, or will take a TLB Conflict Abort Exception.

Note that such aborts should not occur on Arm hardware and indeed
were not seen on any of the benchmarked systems.

Eliding the invalidation results in a 12% improvement on a
microbenchmark which targeted the worst case of contpte_convert(), which
represents an 80% reduction in the overhead of contpte_convert().

Note also that this patch is pending review to ensure that it is
architecturally valid, and we are working with Arm architects to
validate this patch.

Signed-off-by: Mikołaj Lenczewski <miko.lenczewski@arm.com>
---
 arch/arm64/mm/contpte.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index fc927be800ee..009690770415 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -72,9 +72,6 @@ static void contpte_convert(struct mm_struct *mm, unsigned long addr,
 		__flush_tlb_range(&vma, start_addr, addr, PAGE_SIZE, true, 3);
 
 	__set_ptes(mm, start_addr, start_ptep, pte, CONT_PTES);
-
-	if (system_supports_bbml2())
-		__flush_tlb_range(&vma, start_addr, addr, PAGE_SIZE, true, 3);
 }
 
 void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
-- 
2.45.2

