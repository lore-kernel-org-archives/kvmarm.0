Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7BD547057;
	Tue, 29 Sep 2026 22:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790720234; cv=none; b=I95mrVb1o7+tFEDF050Ll4OLR2FdKgjHQ6fLCpAnJw3v0v9d/JnaiEJ2TJkktfFjIRaC0BppcfCbme57zhnadOlEGyoC8mt6Tpg1X/UWKYMdejPfrFCWDb86ES/UJPBew5bMWUXVLjp72jupuSvzP/G3G5XFMGN9RsWxVuZxhZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790720234; c=relaxed/simple;
	bh=2U+cAcr8VcJVMr34PG0rQs6SPss8l1YbdTIFge5eJ3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ui3PhHV1Lb/QEqsrG02UpsYiH4v7DXkagDKbAqqLYPSnunj6cBliF9HGD/RNoOkElObzvlY4RH1MXfiw9lOHCDodOcDFCINx3XxKzTGAJCwkxSSYgR6dTJL/+AzKglkxS/vvHQ5p1gCThmuwJ+lLJHp6/0H3ThkBZ9I5N11WS94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XQoSVaj/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XQoSVaj/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC3CB1682;
	Tue, 29 Sep 2026 15:17:09 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6839F3F85F;
	Tue, 29 Sep 2026 15:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790720233; bh=2U+cAcr8VcJVMr34PG0rQs6SPss8l1YbdTIFge5eJ3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQoSVaj/joHDiB+a+Td9/wqeuygHIGRa4x9oWLe7eEDb/5FM0lKIoXcXl92wLTSB1
	 B1gw19h9UeWXp9nJ/EEuVZHgoXwvANX1XUVZaIllSXlm0ryyN/q5u7yL9yXvwkjvvP
	 +XUVKbXkU3aJ9LfMpmsO5X3er6QaCrnS6hKe+kaE=
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
Subject: [PATCH v20 9/9] firmware: arm_rmm: hotplug: Skip memory added to ZONE_MOVABLE
Date: Tue, 29 Sep 2026 23:16:23 +0100
Message-ID: <20260929221623.1342076-10-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929221623.1342076-1-suzuki.poulose@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
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
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v19:
 - New patch in v20, keeping this at the tail to allow for the rest of the
   series to proceed, while this patch gets discussed.
---
 drivers/firmware/arm_rmm/rmi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index d4d098448e46e..ef0a171ba9677 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -1043,6 +1043,18 @@ static int rmi_memory_notifier(struct notifier_block *nb,
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
+	if (page_zonenum(pfn_to_page(arg->start_pfn)) == ZONE_MOVABLE &&
+	    page_zonenum(pfn_to_page(arg->start_pfn + arg->nr_pages - 1)) == ZONE_MOVABLE)
+		return NOTIFY_DONE;
+
 	ret = rmi_prepare_memory(start, end);
 
 	return notifier_from_errno(ret);
-- 
2.43.0

