Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E251340A6C
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405335; cv=none; b=NjalaWrP9F3Nvim6JXNOupE1t3WxBKrRDc6Me1APgROxx4AzxOpXrM5IQIQfUbiWW1UmDi5EtocdXfTFgBlj+SW2faQLBjejknP/kpBQU0J8OROBmFEbcf0YArCszkl9nKkRy7LYkK3It0m4q2igrZlw3LOTrRg2sF8HnubiALs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405335; c=relaxed/simple;
	bh=hrcmq+7BKS+7RyD2MLzXmh7hMuGNu7NQQpndrNeBtvg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pHN4QwLxSTy6JFJyt5ilRqQ6Xhgs/mTNYjSjZ4elD9Bm1XRQMWQghagR+UJ+ZMENpdfWOIZ9Nj2js4gRKC0i+oLnSxh3Hv1Fzwva7BWVJ59gKFriYtiAxuYNAmjEsP7AmKXXQzTKiQk/rZBTg90t5SxUCVoj6iJ2Oiug16xAh1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ncGk+3Gz; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ncGk+3Gz"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2c8fb84fso2461653f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405330; x=1764010130; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Pr/AhyDI18gHyudCTe0PajcLVV2Ma7cRe8uP5zP/9Y=;
        b=ncGk+3Gz77Hj00I1DSxdcserk5MFzmkNVeE/0qkXADMyhot3zuZD3I/J54uwIGFROI
         Si0fg9Vu8u8Epr4T0ZtFTQnQEMr169bHxxqRgKQVxf7D6fBA9r1V6aAv/UVwg59SMiTV
         X8PaEksm88UkQtbN8lhKVC6VsteJ4NHOC9T2OdsdlUUFpFB9h96J1ll1i65gLSTbVyJT
         fyWGaOnz4k/8aFjT+fPyl+5fUY6zfgi/aYdcWCO2AGeXF0ISSEm30DDPgxINZ6hF7lG9
         mUD7kobk0d9fLTEZige3FTjeRu1TBtTwhZTlw5xxeuNOAa+XJ3SuXEftNZ1ikqKXe1FP
         2zjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405330; x=1764010130;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7Pr/AhyDI18gHyudCTe0PajcLVV2Ma7cRe8uP5zP/9Y=;
        b=rdADvQhsuaW8QPESXon30bI1zSFdc4MBHR9VjNoDnwmUB3wQb6PeFa9O7+E5y9NO2W
         XgV1ps21ilIhUpboarVSFpku2TGQqZMbdGvdQbsGlL9p4KcWQAi6UqTSbI5s9qLJ1we/
         r99CVcsvBEH2bFLl/ztCnXchGUoDPwbdxCUGEFv+kSsq/B3Es+jlpvm4DHifKth/rbma
         2BuNatqOlkrRA4Ot4zvXx6++T0XsIwDw2IHawaRsGT6Fp86JcsRNMS9hitAeRCSM2mbY
         z2rPpWLLEsJ/SZusuzaaywL70tlAP1KjqNjqlL2DaJ7hcQ2JHq6dUZ0UIsu2Xt9csmSa
         DUrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrTbRQIbM1DHSMR6tQg322ABZ0U2oKsPNRz3Plu0qEDXiR/+oddSKQFO5JTW4MnuIcWhwe670=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6fjxMXoq75YMN+6w3VbwrxtRKaXvh7HcO0nmHHkMozFiXcvvs
	Qyj/3p/uHXF3YTE5U+LDOWLUyGfz/LRUxnXHZ785ryGUPWCYTuXD9sCV4bXj/PVxX91hvIzmjRT
	k1f3lw7tr6mftmw==
X-Google-Smtp-Source: AGHT+IEp1GJrifJg25A7HBsu430z3IudVIoooo816bFplXawdroOYHu2KCfVFavBNdBdQ4MlmLiDzZJPVbDY1w==
X-Received: from wrbee4.prod.google.com ([2002:a05:6000:2104:b0:42b:3308:563])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1849:b0:429:d725:4125 with SMTP id ffacd0b85a97d-42b5959e88dmr13794450f8f.54.1763405329830;
 Mon, 17 Nov 2025 10:48:49 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:11 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-25-smostafa@google.com>
Subject: [PATCH v5 24/27] iommu/arm-smmu-v3-kvm: Emulate GBPA
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The last bit of emulation is GBPA. it must be always set to ABORT,
as when the SMMU is disabled it=E2=80=99s not allowed for the host to bypas=
s
the SMMU.

That =E2=80=98s is done by setting the GBPA to ABORT at init time, and host
writes are always ignored and host reads always return ABORT.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 21 ++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iom=
mu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index fbe1e13fc15d..0a2ce6c06f4f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -115,6 +115,14 @@ static int smmu_unshare_pages(phys_addr_t addr, size_t=
 size)
 	return 0;
 }
=20
+static int smmu_abort_gbpa(struct hyp_arm_smmu_v3_device *smmu)
+{
+	writel_relaxed(GBPA_UPDATE | GBPA_ABORT, smmu->base + ARM_SMMU_GBPA);
+	/* Wait till UPDATE is cleared. */
+	return smmu_wait(false,
+			 readl_relaxed(smmu->base + ARM_SMMU_GBPA) =3D=3D GBPA_ABORT);
+}
+
 static bool smmu_cmdq_has_space(struct arm_smmu_queue *cmdq, u32 n)
 {
 	struct arm_smmu_ll_queue *llq =3D &cmdq->llq;
@@ -435,6 +443,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_dev=
ice *smmu)
 	if (ret)
 		goto out_ret;
=20
+	ret =3D smmu_abort_gbpa(smmu);
+	if (ret)
+		goto out_ret;
+
 	return 0;
=20
 out_ret:
@@ -672,10 +684,13 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_d=
evice *smmu,
 			smmu->host_ste_cfg =3D val;
 		}
 		goto out_ret;
-	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_GBPA:
-		mask =3D read_write;
-		break;
+		/* Ignore write, always read to abort. */
+		if (!is_write)
+			regs->regs[rd] =3D GBPA_ABORT;
+
+		WARN_ON(len !=3D sizeof(u32));
+		goto out_ret;
 	case ARM_SMMU_CR0:
 		if (is_write) {
 			bool last_cmdq_en =3D is_cmdq_enabled(smmu);
--=20
2.52.0.rc1.455.g30608eb744-goog

