Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131654D487F;
	Thu,  1 Oct 2026 08:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844418; cv=none; b=qZJ1rsa3kOuqrfNLaeNLm8bXPWmfYHEGBWUkSXaIPtY4nj7aiJw/K8BbTnCHZ+dRCy8FqpXCOIfbY4uDqQZAQo9GOUIW4dDSiBJVU8qBy1mfsdb/W24QZmZwP/zT/Hpeqq5XJ0SPBc/YAez1tpA7FL7hk0cNcsDj+O+EvinlYAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844418; c=relaxed/simple;
	bh=/hbqQXvydI/cbOiE3kBOkvhziUA1TXNotJV14+0m5x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqLZJOm1qPQyHH9JYApWSD9HeZvnZBmvSVTG9IpYAA1+x6fV4qALcC4lcN0VP1ude3qWVAUUBLTevCCZd7+EXgQQbAR3LfY2bfcNFijssW1sMg6HTz1OZumnla8V5N/VgwXCgtYj95K+egAPiNDb6enW0NbIQk87cndKLorBKG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kE7v9ici; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kE7v9ici"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F759169E;
	Thu,  1 Oct 2026 01:46:53 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 596103F85F;
	Thu,  1 Oct 2026 01:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790844416; bh=/hbqQXvydI/cbOiE3kBOkvhziUA1TXNotJV14+0m5x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kE7v9iciE/7+WAnqZqeUn3Pr2zvxK8K2TQskagzUbY91Xxm2KwiNTmNQtJCo1ZQh1
	 k5DGHfM5n4Z8eVkBoasw04xMX/buFJp6/XMz1zEL0fQxpmfpSXM0pRBpgUG8mXZ9z7
	 NFWtoCORAOkrS5/UHeJFNEgr8FF2Tmy5+XKkiQR4=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH v21 9/9] firmware: arm_rmm: hotplug: Skip memory added to ZONE_MOVABLE
Date: Thu,  1 Oct 2026 09:45:55 +0100
Message-ID: <20261001084555.1456543-10-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001084555.1456543-1-suzuki.poulose@arm.com>
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the hotadded memory is in ZONE_MOVABLE, we could allow that to proceed
without the RMM having fine grained tracking, as we won't allocate pages
from there for guest-memfd or kernel allocation

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v20:
 - Use is_zone_movable_page() and only check the start_pfn
---
 drivers/firmware/arm_rmm/rmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index d0842d621cd4b..a01ab69a64c7c 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -1043,6 +1043,17 @@ static int rmi_memory_notifier(struct notifier_block *nb,
 	start = PFN_PHYS(arg->start_pfn);
 	end = PFN_PHYS(arg->start_pfn + arg->nr_pages);
 
+	/*
+	 * If the hotplugged memory region is in ZONE_MOVABLE, neither the
+	 * guest-memfd nor the kernel allocations can come from there. So we are
+	 * fine to skip this.
+	 * For boot time memory, we don't allow this discount, as the
+	 * decision to move boot memory pages to ZONE_MOVABLE is purely
+	 * a kernel choice and the firmware must have decided what it covers.
+	 */
+	if (is_zone_movable_page(pfn_to_page(arg->start_pfn)))
+		return NOTIFY_DONE;
+
 	ret = rmi_prepare_memory(start, end);
 
 	return notifier_from_errno(ret);
-- 
2.43.0

