Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B01418363;
	Sat, 12 Sep 2026 08:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202222; cv=none; b=pYKoRSY71MGbsMPTHl4H0U8fZmRHPzHKG5HVf9IGLi6jkQ8c7jKbUbxtf8aOlpQ9jw0fOBYQGNBOGGsxE4pzd/3D1emmfgqwGJLf5SBy8Zs3X1ZlLTen9wgGFHdFx5PttDcm+vf4pS8O9AbK/7BFo7LLxvEqwVUb1GJv0A0Br7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202222; c=relaxed/simple;
	bh=GjkCl1rRW7deuJHjwHozpX3OphQOimiRmcFSba0i5JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBXeQDtiRNNo09+w24c3LMuAcce8qY9TERNEPMbdU+uNiT9Q+SX1zVyggJnoPhsw8OkdpF+0EEo8HjM3/2tBtMp+JVMFyeu/G337FjfQ7xsdY8lMzVpeCQDW8a1laH6wHmwrv/tbdYO2yR38S/GxtVsponRN9l4HeXGqM+BI9qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jIKI18y4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jIKI18y4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87C591713;
	Sat, 12 Sep 2026 01:36:56 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8FFE03F7B4;
	Sat, 12 Sep 2026 01:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789202220; bh=GjkCl1rRW7deuJHjwHozpX3OphQOimiRmcFSba0i5JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIKI18y4TRh5WEcxO3W2cqoEVHu0yXk9ZcbJ4vvk1jxmzn6MqUTsfuPGLy4UwQgEZ
	 psCeT8GFGA8Jxa4zw5RvRdaSQD/5CrF7z4KKWb1W0vNweKMfjkKlPpQifL0FmDH1Tl
	 yFHjlKSwU2NBA5n/++dVeSiEFf81GEW48KA/6CYs=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v18 5/7] firmware: arm_rmm: Activate the RMM
Date: Sat, 12 Sep 2026 09:36:08 +0100
Message-ID: <20260912083611.2513845-6-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260912083611.2513845-1-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

Activate the RMM after the basic configuration. This is a memory transferring,
stateful operation.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v17:
 * Inline RMM_ACTIVATE command and remove the definitions from arm-rmi-cmds.h
 * Use scope-based cleanup to free sro object
Changes since v16:
 * Split into a new patch
---
 drivers/firmware/arm_rmm/rmi.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 4f9898ece7547..ecc89e91d264d 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -762,6 +762,7 @@ static int rmi_configure(void)
 static int __init arm64_init_rmi(void)
 {
 	int ret;
+	struct rmi_sro_state *sro __free(kfree) = NULL;
 
 	/* Continue without realm support if we can't agree on a version */
 	ret = rmi_check_version();
@@ -776,7 +777,18 @@ static int __init arm64_init_rmi(void)
 	if (ret)
 		return ret;
 
-	return 0;
+	/* Activate the RMM */
+	sro = kmalloc_obj(*sro);
+	if (!sro)
+		return -ENOMEM;
+
+	ret = rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_ACTIVATE);
+	if (ret) {
+		pr_err("RMM activate failed\n");
+		ret = ret < 0 ? ret : -ENXIO;
+	}
+
+	return ret;
 }
 
 /*
-- 
2.43.0

