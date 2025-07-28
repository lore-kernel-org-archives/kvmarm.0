Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9489228540F
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725236; cv=none; b=VRcgynoEoByE/6RPFuHhy/Gr51qouFotyk9xXLsEkLZ9PF0nlYRUwwwqxxaPm1OUvCVKV+bbUaSINBkPiZsbdrVtaoUDbyIaZqdYIBwZty27DQtSyYE55TMuG/1IffZjwwo3GOjdGSXumIvZzvhDLnF27SCzz8rHgFnJM5fns7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725236; c=relaxed/simple;
	bh=dTOJzCAcVM/NCEsmIl4BGdJTrTBtAfQFPr+jJGgBymI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WpWsZSn4cwh6viyk+bJR7ocJ37VvpcTcsjiwvlrcCpgDRs6EwAjX6YLySC88EOnU2YDeClQLxVI4PDbglLPk7lbb3nj6GlAsvOeQjdP+A+UJNTKiPjGykDLM12E0ZRDACDykZEeReADQMxu1ov+fSf2qCdcntNOXrZ4CXRs9EUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Blwr4YgV; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Blwr4YgV"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b7807a33faso1118864f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725231; x=1754330031; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jnrJ8rRpiFcwZt6jaLJ2PB3oGBNZG+6tYm8EfAOijts=;
        b=Blwr4YgVaRdvM3QkNRje6HSJLP7xTUahDAII5ncFYqVV8+5YAWlbDnlOwxASR7cNAw
         +xLQJ8YKQvBY7nqR0kQiuuJZaRgnQztr8Wf2d54L4V3uISaO1p/vpVo1EUWmSH0ITk/3
         WVYnzp3Irs+360pHdGv3fqHrvKStyEe3jPx5z0mvSOZYvHIoxubVYYhgWEurZ1FRBHgT
         bTYTOZ7zY+MW+I6b58cuaQe6ryxQ0NUUixGg7w0+YTap8UlRpeJ0PdaI18u6k+4ntN6S
         BBC0dD+a/HigreMGvaiKZy4VX3A8V2Eqbw5fJqG3M4xiCl/6B6XwPmsGk77LMOKpTaho
         1nlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725231; x=1754330031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jnrJ8rRpiFcwZt6jaLJ2PB3oGBNZG+6tYm8EfAOijts=;
        b=M+BY+PF0bacnsrjoHelgycfSJs0ImtmFKEiPXECDglLbAF0602/8eh+pSVXLMKDus3
         f4hxFFKlz71/BLn8BejiXuMcfQRuydF6N0BU0JLteGGGJ9wIxZFCGWVsf3pRM+DqxkYB
         GrDKNM/f9Z4qOjxluTXTxyan63A2rAbaIYEwtSsrtQ23fOU5jXIVuVtb6aaMtOiZ43Kq
         yfyi1vwFOJ0dhvvQNoYB5BGoD4f3kGNzf/7swdPPi27Y6PW1MgBjO8X5OV0RjsF8N/rC
         QAUKqls69sRZewpHTtmCjlkiEpDm+/eQxXT1wv5vLdsqaqG0z0Jr9kFOStSXT5IgmYj/
         F6EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgmlMIPj5ZjAYHgGd/QK/DauDpBb3ynAXDTDMkaMR5LvNLX7dXlSf7gKQ2sK+e2prOiiUe0Jc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxA2mS0+3pFODQ+yur5WVWYnN7JrHyJM+gWxn1O5am2hpy49VKa
	/DjkhUaYSdSRUWIRIevr+xxV38jFEz26ps2FEwJ/bO1EpDgl42XQ0fOixW/7ZqvfS/gmkKCEo/d
	RE/SL0kJv7cBU+Q==
X-Google-Smtp-Source: AGHT+IGHsz9MPgnZj965sBmcV3dHVpcs8CmM+t34RmjDx7BARFkS1+Ew6W35n8N0of95SaKBxWolAPNzAtM27Q==
X-Received: from wrs6.prod.google.com ([2002:a05:6000:646:b0:3b4:972f:ca5c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:651:b0:3b7:76ac:8b72 with SMTP id ffacd0b85a97d-3b776ac8dccmr7943968f8f.12.1753725231478;
 Mon, 28 Jul 2025 10:53:51 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:53:09 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-23-smostafa@google.com>
Subject: [PATCH v3 22/29] iommu/arm-smmu-v3-kvm: Reset the device
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Now that all structures are initialized, send global invalidations and
reset the SMMUv3 device.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 74e6dfb53528..5e988ffede92 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -301,6 +301,40 @@ static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
 				       strtab_size >> PAGE_SHIFT, prot);
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
 	int i;
@@ -333,6 +367,9 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		goto out_err;
 
+	ret = smmu_reset_device(smmu);
+	if (ret)
+		goto out_err;
 	return ret;
 
 out_err:
-- 
2.50.1.552.g942d659e1b-goog

