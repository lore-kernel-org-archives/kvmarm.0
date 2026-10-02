Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26FF93EB7F4;
	Fri,  2 Oct 2026 06:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790921782; cv=none; b=DDBS9UMT0YRxGmNXIDrURvl7SAymONi4WBW+4BeHL0dchYddgAqDm/0LrjiUn5/adgoJsXVkcUgnO5qz89SyHww8kUtmTd5oGaYOH0SoMmgoxhchCaFFTMYUfGicnTvVc3I19KN6G32kRWi8Gu2Bv9b5Zw25i3T3yXa4GK+gnRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790921782; c=relaxed/simple;
	bh=tnXpJdsvz79ly1HeWLu/5oHQruvLIlQTSjflY77QwYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD39h8r9J09BBOi3qOiq/t1Joz/WTVG3haWAbssBH4SwBAflwp6x6M67/x+90AZYJmONKH/cP6GjKJAngN1wPHNk/g1V0SNNz8ZsTtQT/j0rsEWGmrLtlk5EaqI3IxLoNoLuv4r+LO6SN9E3t3EqZzIanWqE6KuUSncoULCNRh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=onyjg9j3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="onyjg9j3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 791DB1476;
	Thu,  1 Oct 2026 23:16:08 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4BF383F763;
	Thu,  1 Oct 2026 23:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790921771; bh=tnXpJdsvz79ly1HeWLu/5oHQruvLIlQTSjflY77QwYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onyjg9j33dQiYYoNArDmlsdmZ/ddqvxPdRKgZLXl5KEctv8CLAWcuqP24CIq52217
	 KenHwUwgPuMjP2dC5HDNO46rNvoFgD/hP/sDAhypVj1kcWxrt2PudKtg5MdBsR0TvS
	 P1u7Lm/KFvXF2Stt2LjiNeuvLmr6FtuYIHB4e3jE=
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
Subject: [PATCH v22 10/10] firmware: arm_rmm: hotplug: Skip memory added to ZONE_MOVABLE
Date: Fri,  2 Oct 2026 07:15:06 +0100
Message-ID: <20261002061507.1600269-11-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261002061507.1600269-1-suzuki.poulose@arm.com>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v20:
 - Use is_zone_movable_page() and only check the start_pfn
---
 drivers/firmware/arm_rmm/rmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index c064072690d46..c3c3cf6dad59a 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -1050,6 +1050,17 @@ static int rmi_memory_notifier(struct notifier_block *nb,
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

