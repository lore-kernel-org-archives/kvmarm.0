Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE400598BE4
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094981; cv=none; b=hZmXEQxnVcmYs8+ptJN2a7nQXKsP9319/00DfoTeRFBbnGR9nKtd0Ril5J/C1ZbHEIAe2T3C2OFPCbWhxdKQJoXr/54dow0O5l3gdXaZ3rn4Hb+Mg54qQix5qmPjhTK4N5noxu5Z611jWUGiQ1cuDtAPJ7GSIpDc/fe8X9WVn4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094981; c=relaxed/simple;
	bh=esGTvS6DZ/ClMQbU119hVRZc93nVCLe8LifqfkQfW5A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p3cCNpHsIt8fV2zxZDtZRR/zbsHbHP2gmBBplROexV0YcWX4ZVNvfhL7pmXWn5ZUj6RtjBLuSumUm7LRtSImVSowpk+va9kAAk1QpeDThN7Q9Ye/iTm0O3zSkgON4iIYTGoyEohStmnrDQLPcASe8JxoLTmuQmO7dt76KbQnckY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R5UaSZKD; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R5UaSZKD"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c4069f03949so10282666b.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094976; x=1792699776; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ACz9N/uLV4ni8vIh9HTqb065WbDM683/OQmKXL1iQNQ=;
        b=R5UaSZKDUf68vcdlRiPOvpqQsSlyRODD21YYviOtEd7CzHS167nMR2LGusOPR7nmf5
         tqcvGhc4vvADRLjidwSFk2sFTAGlsNP092mq0nv/z84pjJIrC0b7eeBwwNbv3sII7y34
         nwIzKsAEm3uCuD2/weN7PZMbbGDTiun4fdwQqKulYxG8pFcdP8VrFEq69y25aNB4tG4O
         /AXrs7xweMNrK5kTHPy3OxQR0MNGlJTl9jRzPgQKS6KyZguR38je6YviD1IM6+eg0F70
         5IL3OeVCxgFHF9oBszhEbg1575Cp8Z2c6CwaRIyIFQ1Ee6pxymOfBxlOSybngH4h36hO
         OGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094976; x=1792699776;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ACz9N/uLV4ni8vIh9HTqb065WbDM683/OQmKXL1iQNQ=;
        b=UUUZrWu0QfmB7z5/NMoNKhYwsfrUPXuNoFwiZSSt4gwuPjFMX9ZdJ/+AU3D9Mzs2h1
         /n0/TNP6TM/aefDD3/xRXBjrgd/u9ty3W8UQI6t6xLf+vzrR/ZMjF0DjpD011mcmXehH
         0dE/ElE9mmIB0YHyq3hi4eoQHrDBSwoydhXlza+YY0V1Pof72Cs0SbiitI8RNkkN6zSZ
         1lI1YejQeueBjYgSTUWJ5WtyiIxlf4LJx7I5ZhgljLI79vE6Rk6anTo4gZX6d5bIpyw2
         1XZv1QkVCVsxIUFJX3CmcqtJpYGOWiHafK02dzj7Uq73sXds2PYV8/1MX9WQyKAOdkz/
         68LA==
X-Forwarded-Encrypted: i=1; AKwUvBze/IUj8errJ8NsCJbk5rJI6WH4RLbnw6eTlACkJeqR1HgHjwQqdkDqvUMI2X6JBnlg7BJsUis=@lists.linux.dev
X-Gm-Message-State: AFq9FYIMVBckh4M8Q7wjvIbdA0SOSmvO5qupOFitM1QpX+chQ1sVqGDw
	4abT1njhLzJRLsN2LBKXwMSRaddx34utXgGlw+OlL6a1uumreWu7u2W54NyvZz9Fh2prW9Rw6Nu
	VGMrunQCZoCnWIg==
X-Received: from ejsh10.prod.google.com ([2002:a17:906:584a:b0:c3f:cc01:4b72])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:2d11:b0:c29:519b:3aee with SMTP id a640c23a62f3a-c402349d091mr109107066b.33.1792094975445;
 Thu, 15 Oct 2026 13:09:35 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:51 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-21-smostafa@google.com>
Subject: [PATCH v9 20/25] iommu/arm-smmu-v3-kvm: Emulate GBPA
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

The last bit of emulation is GBPA. it must be always set to ABORT,
as when the SMMU is disabled it's not allowed for the host to bypass
the SMMU.

That's is done by setting the GBPA to ABORT at init time, and host
writes are always ignored and host reads always return ABORT.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c    | 32 +++++++++++++++++--
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
index 1972df1d2a8d..943ffef0bb4a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
@@ -217,6 +217,22 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 	return smmu_sync_cmd(smmu);
 }
 
+static int smmu_abort_gbpa(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int ret;
+	u32 reg;
+
+	ret = smmu_wait(false,
+			(readl_relaxed(smmu->base + ARM_SMMU_GBPA) & GBPA_UPDATE) == 0);
+	if (ret)
+		return ret;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_GBPA);
+	writel_relaxed(GBPA_UPDATE | GBPA_ABORT | reg, smmu->base + ARM_SMMU_GBPA);
+	return smmu_wait(false,
+			 (readl_relaxed(smmu->base + ARM_SMMU_GBPA) & GBPA_UPDATE) == 0);
+}
+
 /* Put the device in a state that can be probed by the host driver. */
 static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 {
@@ -456,6 +472,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		goto out_deinit;
 
+	ret = smmu_abort_gbpa(smmu);
+	if (ret)
+		goto out_deinit;
+
 	return 0;
 
 out_deinit:
@@ -781,10 +801,16 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			val = smmu->host_ste_cfg;
 			goto out_update_regs;
 		}
-	/* Passthrough the register access for bisectability, handled later */
 	case ARM_SMMU_GBPA:
-		mask = read_write;
-		break;
+		if (len != sizeof(u32))
+			break;
+
+		/* Ignore write, always read to abort. */
+		if (!is_write) {
+			val = GBPA_ABORT;
+			goto out_update_regs;
+		}
+		goto out_ret;
 	case ARM_SMMU_CR0:
 		if (len != sizeof(u32))
 			break;
-- 
2.56.0.176.g3575e65682-goog

