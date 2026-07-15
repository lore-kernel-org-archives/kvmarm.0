Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A9444BCB0
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116783; cv=none; b=p6vkb7hjtoscXPP5pJ/MBk2hLdi9ayovNIx/PLYpc4dT3NB2IcfcNCqL6vTHQ0bjxX2yxkw/8Kq1fVeHKpC9kKMHOrAkl8GRglEnKxBKMNucbBJGT1fJT/HpP0FuYfu5gK/2scGNBsmgqpcrcHqE7joIV/en94O2+S9WWjv/sx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116783; c=relaxed/simple;
	bh=i5CStW7O9rQaAZkBUoHFyUYObK2PXVqrXOInPeWi3Ys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lUInF+sbCFNbcMa/Re047j/H1fdLjVnYrTrdIJro2W6oCOGzcf8+Kd4JReqmP0Lw7B2Buk+Dxzq5Eolt8PGKvvzL7ro8v2K68cIaSMClnGVsFcvAIEWfnfwGWdKhYCcfHeuvFhWlWbThL7uLc59qy4umosF2i55blSsvPO/gjY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IVwId+MK; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IVwId+MK"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-473bc66c837so4578895f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116779; x=1784721579; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8eFC7jmqsBzC+eazaElzsGpHmLo+EQxKGjp4/qK1rg8=;
        b=IVwId+MKu7trodQcXQCnxBeBeq0AVMe+uiKMttO0/2CQy7qRpblMuc8AntkqN+MVvJ
         mFxvD4GvGQjfHBnKgHSzCeKcKWEaQyHxKdBTNNc9yGMkN7YBczmR0lOWM1Q3ZKhV7Wj+
         +fzhgUlqMngG6yV13BZ4n9a/eYyv+AT0tDV9BACxkSaODFCdgndU6jX2U1ydX8bN8lDX
         SMgE4ubbzqBe8DdY/JncfYG0vCECSX97a6P96d8wcZ2/xeK6aEaFN3ezKmG6O7HfBQXI
         bLOK6PpH+gCDu+gg9xb8Tlz2Ylq/DGUTqP+C4RXDPBmP266KMOOUK5GDcHPWLtGZ6ucQ
         Acug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116779; x=1784721579;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8eFC7jmqsBzC+eazaElzsGpHmLo+EQxKGjp4/qK1rg8=;
        b=ibwqIs4IeaFBDtRKFUzgaIMe3SBcH3k0fi5zm4d8KWiADKSK2Bpmf8V/D+/PDiqqEy
         JWFH/xZ4gLPlCwfSguEs7eYz96kovxUAjUopdaaoiEgFxa6JPPHguDE43w3bhCjdB2WC
         9dF8NYh/CRZPB/p76BN0XALn6V5+Vx8AQiXbwTkAA7FL4cM1jin2u9rPLOR28eWyP8DN
         GeEZojT+W4f2s651MRa+7Z1QOIwUGo14jsCs3OJLwrRgr3vpomLSYbg72i8nJBfeD5uA
         hkNq3ssqAYVdO3ROE+bSq2UNclWQs+A+s95TzZGwzNxxETbbrdLFocyAnbNf4KPBJlvO
         922g==
X-Forwarded-Encrypted: i=1; AHgh+Ro2CAdvPm/fIxRGlO/ehs8pnx7M7+9Wh2DH3Ko4/KJ+oAVYf4S1mKAjGqcHlvEt+MJOwW2d/pU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFqeIdcgDXuU7ipS7cdz/NYzGtXeScZe/8boz8IgbpIMPshl21
	Uy9sZXephuoTi93wDFr0N7HaYEwmXdck3f1784HC4nDfnxeWVUN67S+31BWiiuHtMcJol2OUdec
	TbcfvthW7Gmr6pQ==
X-Received: from wrrg11.prod.google.com ([2002:adf:fc8b:0:b0:47f:4e4d:2531])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:310d:b0:474:83d4:9916 with SMTP id ffacd0b85a97d-47f4885698emr7936900f8f.17.1784116778676;
 Wed, 15 Jul 2026 04:59:38 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:59:01 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-21-smostafa@google.com>
Subject: [PATCH v7 20/24] iommu/arm-smmu-v3-kvm: Emulate GBPA
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The last bit of emulation is GBPA. it must be always set to ABORT,
as when the SMMU is disabled it=E2=80=99s not allowed for the host to bypas=
s
the SMMU.

That's is done by setting the GBPA to ABORT at init time, and host
writes are always ignored and host reads always return ABORT.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 32 +++++++++++++++++--
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iom=
mu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 11de73640a6f..45dbab1b18ad 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -139,6 +139,22 @@ static bool smmu_cmdq_has_space(struct arm_smmu_queue =
*cmdq, u32 n)
 	return queue_has_space(llq, n);
 }
=20
+static int smmu_abort_gbpa(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int ret;
+	u32 reg;
+
+	ret =3D smmu_wait(false,
+			(readl_relaxed(smmu->base + ARM_SMMU_GBPA) & GBPA_UPDATE) =3D=3D 0);
+	if (ret)
+		return ret;
+
+	reg =3D readl_relaxed(smmu->base + ARM_SMMU_GBPA);
+	writel_relaxed(GBPA_UPDATE | GBPA_ABORT | reg, smmu->base + ARM_SMMU_GBPA=
);
+	return smmu_wait(false,
+			 (readl_relaxed(smmu->base + ARM_SMMU_GBPA) & GBPA_UPDATE) =3D=3D 0);
+}
+
 static bool smmu_cmdq_full(struct arm_smmu_queue *cmdq)
 {
 	struct arm_smmu_ll_queue *llq =3D &cmdq->llq;
@@ -450,6 +466,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_dev=
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
@@ -763,10 +783,16 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_d=
evice *smmu,
 			val =3D smmu->host_ste_cfg;
 			goto out_update_regs;
 		}
-	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_GBPA:
-		mask =3D read_write;
-		break;
+		if (len !=3D sizeof(u32))
+			break;
+
+		/* Ignore write, always read to abort. */
+		if (!is_write) {
+			val =3D GBPA_ABORT;
+			goto out_update_regs;
+		}
+		goto out_ret;
 	case ARM_SMMU_CR0:
 		if (len !=3D sizeof(u32))
 			break;
--=20
2.55.0.141.g00534a21ce-goog

