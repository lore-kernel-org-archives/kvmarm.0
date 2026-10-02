Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E9C3EC6B9;
	Fri,  2 Oct 2026 06:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790921765; cv=none; b=L8Vg9yrLlmibg004lUCDiJouGwagq2kNHKgh4rCgl8ZuOBSfJTkOz8xGJThsywTlz8xhJYhcBwaoPC73RqKSPVBrvmGXlHhZ8NwxAlmwPkRvqztXzjoWA/Lz2NTE+xFOcqR//xfAiqTwr0172VBDyiJ80p99XDUACgdk1wSBTVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790921765; c=relaxed/simple;
	bh=pyqFQeqXPMLfWzm76om5tMIFi1OCqmnWHHZjMX/UxtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o280uSk99TcN+rblU3OiKU07Hm3qENZN8L59owgrgm8gpeX1bEOkkcYjA/kbNVWNIZhmv+CTa5yCSHYJY1qOT5e98Nb78TgFCJS5BDAtmAiZGaTpvTvGQ3ioay3GxF30QO9kFMB1E+mb57Bpi9pQ4kJmfGMTL6W4Jiyta4xTzYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lkw0rSzB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lkw0rSzB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5933416F8;
	Thu,  1 Oct 2026 23:15:49 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4BEB63F8C6;
	Thu,  1 Oct 2026 23:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790921752; bh=pyqFQeqXPMLfWzm76om5tMIFi1OCqmnWHHZjMX/UxtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkw0rSzBJZFtYxfwT2xbXy2fexYN/9xxQwA4G0uwE1s6puTvUY4Q2v5uI6TK8fN4O
	 B7R6C34ISMf/cvl7n9oW8LfTLopeZfcnvxLRJ/PAazLHxcze+sznKvGtlFf7ZOFHHZ
	 dgpScgqKVz3t1lQh7YHzkuKWNgbTdGPyMt3TkkIc=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v22 05/10] firmware: arm_rmm: Activate the RMM
Date: Fri,  2 Oct 2026 07:15:01 +0100
Message-ID: <20261002061507.1600269-6-suzuki.poulose@arm.com>
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

From: Steven Price <steven.price@arm.com>

Activate the RMM after the basic configuration. This is a memory
transferring stateful operation.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v17:
 * Inline RMM_ACTIVATE command and remove the definitions from arm-rmi-cmds.h
 * Use scope-based cleanup to free sro object
Changes since v16:
 * Split into a new patch
---
 drivers/firmware/arm_rmm/rmi.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index a78f180281322..f093cb39fa0d2 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -857,7 +857,18 @@ static int __init arm64_init_rmi(void)
 	if (ret)
 		return ret;
 
-	return 0;
+	/* Activate the RMM */
+	struct rmi_sro_state *sro __free(kfree) = kmalloc_obj(*sro);
+	if (!sro)
+		return -ENOMEM;
+
+	ret = rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_ACTIVATE);
+	if (ret) {
+		pr_err("RMM activate failed (%d)\n", ret);
+		ret = ret < 0 ? ret : -ENXIO;
+	}
+
+	return ret;
 }
 
 /*
-- 
2.43.0

