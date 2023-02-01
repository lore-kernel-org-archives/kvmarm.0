Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8089A63B2
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:39 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id q10so17233310wrm.4
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4ZFCF/kj9JqjH+47Ky0Y78YqQW+BJekFTNH3LkgsVQ=;
        b=TIKoMpZW1BvDRnxSXaAWdb9Z6gbW/Bmx02AF0RaQaqWCB0fas41UW6YPpQC5xfHEcd
         Ugp15psKl7+slDSydMROOXPIKgbP++UGE6DIExTtheeEuElJbB4m4nahwg2Jij3r/NJx
         ygXJcAoDpYPifyEhGy4lxRCbRq+7MXYTnoNYUvmLQydiBftIuBRwm+UFJ3Mmu49HWHqS
         0B+ZQF7hs+S+RvjhEZYVdpqgECox6eBowAI4ERfZn85PRWbQCQOaDy97OjKJZzRLQjJq
         NOIg53GuyNPkAg01BPG1Xs4QXG4dFDQjEOoaQV4eLqeBpSZAp8r/olni6DrlnAdH/SWu
         SQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4ZFCF/kj9JqjH+47Ky0Y78YqQW+BJekFTNH3LkgsVQ=;
        b=A7TCxMFCbSFWuX2uuYlW9vcK3aM9urvjxd+3c514V7rk4NQJMJe+WqQKZZcq6VoSVx
         hBh6u8rRBUFTMEV1imMHE6BQ/mKZQRODXCYK8rVr86uq8Bnqg5z88T4LwCFgSr4In48g
         7HUIwmIpkiGrmmm8tng0G5OPDsIIgUgcMXCg/lfiHdp5QxAI9+MfeoShsb1qitqDzJDm
         SPWTnv/Q5IU/vtZAfIJQwPkrSpr44EBekA6ywYzKh3C6Htsgq6cgv/c+etR72PwbblIw
         wSFYvtTaX2o0HEAblrzcBDTAWhJR2IrhUh/d6hTMvT90hr2cjPfk37LSu2mGCgl7ssRS
         VkQg==
X-Gm-Message-State: AO0yUKWUecwr3pdHzyPlbfehj3hoGMq9eXQMrH9GTkTzX77iPbU26Ob/
	t+rf9v+7mXbKN8xMoe+31goN8g==
X-Google-Smtp-Source: AK7set8XSHTrtAK2V3ctWiwWsh1zVJknKd8Kdu/64oZhyD+qkm6qA8gnDokv19FpIPFhHLRnm1ArEg==
X-Received: by 2002:adf:d084:0:b0:2bf:c805:7b36 with SMTP id y4-20020adfd084000000b002bfc8057b36mr5646436wrh.49.1675256379109;
        Wed, 01 Feb 2023 04:59:39 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:38 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 25/45] KVM: arm64: smmu-v3: Reset the device
Date: Wed,  1 Feb 2023 12:53:09 +0000
Message-Id: <20230201125328.2186498-26-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that all structures are initialized, send global invalidations and
reset the SMMUv3 device.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 36 ++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index 021bebebd40c..81040339ccfe 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -348,6 +348,40 @@ static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+static int smmu_reset_device(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int ret;
+	struct arm_smmu_cmdq_ent cfgi_cmd = {
+		.opcode = CMDQ_OP_CFGI_ALL,
+	};
+	struct arm_smmu_cmdq_ent tlbi_cmd = {
+		.opcode = CMDQ_OP_TLBI_NSNH_ALL,
+	};
+
+	/* Invalidate all cached configs and TLBs */
+	ret = smmu_write_cr0(smmu, CR0_CMDQEN);
+	if (ret)
+		return ret;
+
+	ret = smmu_add_cmd(smmu, &cfgi_cmd);
+	if (ret)
+		goto err_disable_cmdq;
+
+	ret = smmu_add_cmd(smmu, &tlbi_cmd);
+	if (ret)
+		goto err_disable_cmdq;
+
+	ret = smmu_sync_cmd(smmu);
+	if (ret)
+		goto err_disable_cmdq;
+
+	/* Enable translation */
+	return smmu_write_cr0(smmu, CR0_SMMUEN | CR0_CMDQEN | CR0_ATSCHK);
+
+err_disable_cmdq:
+	return smmu_write_cr0(smmu, 0);
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	int ret;
@@ -372,7 +406,7 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		return ret;
 
-	return 0;
+	return smmu_reset_device(smmu);
 }
 
 static int smmu_init(void)
-- 
2.39.0

