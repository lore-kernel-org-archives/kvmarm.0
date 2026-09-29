Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A3BF3176EF;
	Tue, 29 Sep 2026 22:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790720222; cv=none; b=hVucTr7N6j9ZoNaYU9ndgtW4U+j7yyozitVsB9ZsEmgxJxGIWNIW9MuGsrBoWhXUQzfE7dJpdjmtEE0mTmMEtpkYvZK1IKX5BgXi4wmbMm5eUooZXyi1ox4QcGKOgDxjXAUW9S4Eg/RliNzImT10bIudZvEenT35OxEfuUZ6qF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790720222; c=relaxed/simple;
	bh=8PAolXXFA8Ox/Vhqsh/tPUJnvwtmePPmFeXdc9DKbKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dv4Rt0P0WZeBuaGcTTbYkwz2ee7h4XSb9IDhPFzx0wRku7Frx3G2AIiw3qfjv9saZuaDL3L20fJumdRZn0YndrOdWVzsGWcZkU9IKb8Bm5Jb/VtFF3fdSZhrwgg0t8RBOlAFfyblR4zkHwQr8a3B/MSiq6ZxGwOX90ZKVYVsX+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pZ+zIwM2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pZ+zIwM2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0048D1516;
	Tue, 29 Sep 2026 15:16:54 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D11A83F85F;
	Tue, 29 Sep 2026 15:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790720217; bh=8PAolXXFA8Ox/Vhqsh/tPUJnvwtmePPmFeXdc9DKbKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZ+zIwM2VZDlZLrMs/FSvshCBRIi5fCZReE8feQkG6XeGk85LHEktZw0ss6vg3gpM
	 d2+E4b6aTjqYi6+r/MVUtspPy9TwUw6Fgy3/r7Dd1Gr2oVcxDaSAN/y7a1LF8ZODJi
	 84UW5mU4OPeqUo/ZBYhW2DugFSV57v88/kTypPno=
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
Subject: [PATCH v20 5/9] firmware: arm_rmm: Activate the RMM
Date: Tue, 29 Sep 2026 23:16:19 +0100
Message-ID: <20260929221623.1342076-6-suzuki.poulose@arm.com>
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

From: Steven Price <steven.price@arm.com>

Activate the RMM after the basic configuration. This is a memory
transferring stateful operation.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
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
index 8d839e9e61424..d982cf158f8da 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -850,7 +850,18 @@ static int __init arm64_init_rmi(void)
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

