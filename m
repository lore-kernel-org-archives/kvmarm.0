Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B80C52379B
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867820; cv=none; b=FcRqVjPqPStzYl+lQ8tWQk9ss++o5hbhS/9Q+q7rIPhBSvX08OpiDLshalUuA9WE8UdXCN9N9GPl1qFZEXa1sTE8HxJV8GM2BIkIjS/CDoJI/2+wBXQ4MrE+TLjXdhRtD/Tf5SXOqodW34X/EgEUZT2EP42FsH7dOJRG6zZ6ZXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867820; c=relaxed/simple;
	bh=RqX1dKA94PNL95k4kUy4PZ37p5pKhJ3DhPD1Hepjc8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neMlNZkmk0VsueKtnd22VqMyCqTLiu935fNcLtLlEm9pgfvLxoObgxjSmj5WMANuHzfT/X3QPIr45YrhB7sb+d6/PiUpbz725VgT+LUy9Iv5ioez15SwzM577H/f+CuNOmDmtrKeg6DSefEfEIl1HalEQM0R+WbVIErXVYKwDqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Zqi7mjsN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Zqi7mjsN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F1741476;
	Thu,  1 Oct 2026 08:16:54 -0700 (PDT)
Received: from e143914.cambridge.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96A8F3F86F;
	Thu,  1 Oct 2026 08:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790867817; bh=RqX1dKA94PNL95k4kUy4PZ37p5pKhJ3DhPD1Hepjc8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zqi7mjsNpEp9xAKmS0D/85gV63YlpnvwBoBXMEst8BviLfQfXiyke/+M1eDDKTUqA
	 ZqhBcn/8zx80bzwDAaDPGDnlwMP8vIk99qiW6zt0pzpslF+A72dLNemEflZTX51BgP
	 Fg0hzOm6YPhmzF4UqXE9if9IfbNFaIr61q76gAow=
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	andrew.jones@linux.dev,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH v3 1/8] lib/alloc_page: check for NULL ptr passed to free_pages()
Date: Thu,  1 Oct 2026 16:16:38 +0100
Message-ID: <20261001151645.2427065-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001151645.2427065-1-joey.gouly@arm.com>
References: <20261001151645.2427065-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't call virt_to_pfn() before checking for NULL.
---
 lib/alloc_page.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 84f01e11..cbada1f7 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -265,13 +265,14 @@ static bool coalesce(struct mem_area *a, u8 order, pfn_t pfn, pfn_t pfn2)
  */
 static void _free_pages(void *mem)
 {
-	pfn_t pfn2, pfn = virt_to_pfn(mem);
+	pfn_t pfn2, pfn;
 	struct mem_area *a = NULL;
 	uintptr_t i, p;
 	u8 order;
 
 	if (!mem)
 		return;
+	pfn = virt_to_pfn(mem);
 	assert(IS_ALIGNED((uintptr_t)mem, PAGE_SIZE));
 
 	/* find which area this pointer belongs to*/
-- 
2.43.0

