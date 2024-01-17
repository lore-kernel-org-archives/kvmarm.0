Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4618A24B25;
	Wed, 17 Jan 2024 23:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705532841; cv=none; b=NJ51rsf89Sn71d27x6I4GBsUKwyaDteiw2qTXupsXeKw9DUHelNRir3KEEzVXmNd4uu62nB6vetqfLbzlXe8mW4fucCVRN8TxfYY7Q1K5TFFLKG6Ao7nnQQnNduwkhgm002kaMhfeiunVAZ8Oko+4hHYJfNQ9fQMlnRGsP379Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705532841; c=relaxed/simple;
	bh=+6nIeOFxhPy+roORj2aw1phO7CMig6PwRogWUATtFQs=;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding; b=DiKDIJunhydp4+j4VOMHjryK1mOP1S96WUGEIbsmcotm1u+XgwHKxqIEAJ+cNGcM27RifbFm/81WtqKB8ONSIctG2HtVrbO3BV2aKbi16kt06a/sb969jFZii30ckyiPnRE+EBJ1YY02U4AZjVph1yKoUTKwgPlfL4sizqKc1RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KxkaUt4P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KxkaUt4P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rf9WG8QoK+Em5J0jsQlsXY6tjkvOuZcYJxM/46Zr9do=; b=KxkaUt4PI8Mca+F7Kp2LvXFHOr
	gtPmoYFkMinRaue70E8zThkunG5etxWpKM8R0oeW4vwqKhDWwYtpWE7R4FTYN+FeNSS3e9WbNCN5h
	na5rG1e5Dzja9o3seH+r28SicPs8xCGkdf2ydmNmSEKBxpwzYXe3dKA7NAVk40kXu5aq7BXX/SM9D
	e1TcIMn94LOtvKMj9N7W00HDCJgcz+WzwSVDB5+nJheKbjcW5b49VABjQxHBf2eWtZmhW+ozxpacB
	t0Uwdq62LjsCMLp6dSPTCp98mEHAkSkCjNA2jl7aq1X6UcKBsq++LmXvJCMyNJWWXvwwpCIuEqBVA
	CFPVnSbg==;
Received: from [50.53.46.231] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rQF0B-0011su-1T;
	Wed, 17 Jan 2024 23:07:19 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 05/10] KVM: arm64: mmu: fix a kernel-doc warning
Date: Wed, 17 Jan 2024 15:07:09 -0800
Message-ID: <20240117230714.31025-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240117230714.31025-1-rdunlap@infradead.org>
References: <20240117230714.31025-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the correct function name in a kernel-doc comment to prevent
a warning:

arch/arm64/kvm/mmu.c:321: warning: expecting prototype for unmap_stage2_range(). Prototype was for __unmap_stage2_range() instead

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -- a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -305,7 +305,7 @@ static void invalidate_icache_guest_page
  * does.
  */
 /**
- * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
+ * __unmap_stage2_range -- Clear stage2 page table entries to unmap a range
  * @mmu:   The KVM stage-2 MMU pointer
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
