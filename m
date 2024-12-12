Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31F9238E1F
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026750; cv=none; b=oUzWvsN1Uf5Iku2aP7X8cEuYAKCon3V1qHFbjvjEU+u/qgDn2a4lZmOauCkkIv1Zn2JZwKxZoksS2UpNZ6nbmKpOj2e2ZaRtaPRZht7bbDsuZfWXehlVbhSUnM4u/lJKRX06iAIZI9lXXJrKmeeaY4/C4Iv3E84dcFoDL58d8+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026750; c=relaxed/simple;
	bh=ZTCW3MPLRkAgIQ6KHNuQcNDS5MIsVNoOiDzEFUuD1n4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lp19Npn+Cwzrc+jzQ2mfSqvMzo+ir0RoRenwh8af4UvrgMKbGkXqWC2ztzsaZSUDYFG4/suUUpOuqkTfXS7Yc5u2GE6OpPOULcAvq+90FeSKwPNMlLA/k4KfH7v1IbUNlIS11a/9eKw8YQTjY1ki6ED81TKJX2YvFSJYbrwMsY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zAsXtir/; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zAsXtir/"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4361efc9d23so9229665e9.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026747; x=1734631547; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HFThXzKnjRTlltuWbtKfTZlx0mgnbefnBgFBqpI1yLQ=;
        b=zAsXtir/1tzeRfJZP2YDSTjChiQFceFGw8vtYI0kHUjG0XsL6by8liCe/0n++a4LyK
         Oq+AQLnqQtaynyzLuNFBi8M+tRN+1B/eUpM0scOu7lfBhaxvprzU9ber2rsaWubEMOT3
         ElkpSRM08HwqjXO9v3G+TROF3V+apt0gId9uZYMyfexF0Z7RFFus6u5oW3YuOOPKZ42f
         bOEowvonTIPNjw5bdoRsxduNZH/wbu8WETvxHZaBielBRXw/BJnivGYj5eEaTJyt5WNs
         0kRzFtIxFNJQ0NI+IBImn+cgIzP8S10goUo4B1WS2lABQIhfiG9/bTzHtSF7gDi5EDSu
         lE4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026747; x=1734631547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HFThXzKnjRTlltuWbtKfTZlx0mgnbefnBgFBqpI1yLQ=;
        b=ccHG7S1E06YwATRMrFh/XA3bpwKTkbu4uH/CfQnN1mQ4Io+JjJULUg0RjHwaOkXI7D
         H+2OxnI83Pckpd0bcbd4Mx+yh/CtE35tRxHQAMNd5H74r4160rq2r686d5U2bFarhKxI
         dXyAhp7qXf+tmq91cZMMwELnI1MZxKEUakuKqPRIbNRzcQR9BE+xqIUFB4HmHYj4Ap+6
         XyeqkN4ACwLrg6Le1FCVaQAhIN8v/3dG2HgnDZaytfHHPMMVs9YhSzgZCy/40j6Dut4p
         No2M7zNmxNOQ7eMAae3krcq52GeE1kv54b5jbDlIk77pzvgVdx95EABarrwFNpDV13p5
         9Cpg==
X-Forwarded-Encrypted: i=1; AJvYcCXtha8omliyFxsfGw+WOzbMD/W5El0SjcFa6qD012yylOhhOEiBq9nV3/WqSj3wRhrsxWaHoEU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3yWGPzrItkjJ/1j+wSmxa/M75xrS2Z3gkqiPksw3WzT4VOjLx
	zmdAQErV03orEG1uFBfrknEkxHtagLrbRjk57q8PuljvzC5dCmqHzBp95hWB97BEsaeLfxfm+NH
	TEgOE32kWEQ==
X-Google-Smtp-Source: AGHT+IEcA6NxPQcYOWP3jecw4tajvZQj85hXUMMgjZMFtmkSC/sm2wXlubiRoWv+mV1LLv3tR1NkxUnUlZkBAA==
X-Received: from wmdv18.prod.google.com ([2002:a05:600c:12d2:b0:436:164a:763e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:524b:b0:434:a781:f5d9 with SMTP id 5b1f17b1804b1-4361c3aaefamr76123965e9.11.1734026746134;
 Thu, 12 Dec 2024 10:05:46 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:54 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-31-smostafa@google.com>
Subject: [RFC PATCH v2 30/58] KVM: arm64: smmu-v3: Reset the device
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Now that all structures are initialized, send global invalidations and
reset the SMMUv3 device.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 38 +++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index 5020f74421ad..58662c2c4c97 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -441,6 +441,40 @@ static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
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
@@ -472,6 +506,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		return ret;
 
+	ret = smmu_reset_device(smmu);
+	if (ret)
+		return ret;
+
 	return kvm_iommu_init_device(&smmu->iommu);
 }
 
-- 
2.47.0.338.g60cca15819-goog

