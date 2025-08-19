Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C317341666
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640371; cv=none; b=DajumAITkQxs6c9Tupwb4B+bdID3hmG/r0CJtZFoZ/Z5pFW3OJtTpnja+nO9YNWJVC9BQH0BJ68ZOk3BU4UoIJGUsQmqIlIjYxCCZ6pwHxUBWvvoi8bUMAKKUwx/jAk8eueIEjNg7cW7VvCuz+UwnB2gtEMLC668aC+S4KBt43M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640371; c=relaxed/simple;
	bh=zmVhO1Fx//55azUTuwuZDUNjyqH7HeyRTi3vIAgq+T8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RenQWfMnFAz20iLLJLAP1RUCPLC4H9HLpePzgYylulCk9ZilFylcQ/SQPoiCzkb/FtxuyaJOxLHJs/N1BabHMNzUDs+jEc5H5Fwgpo3PXoOet7v753dnjFMoNwJpwvUyF7F6FmiDSXRjiwgLHnQH0nfk8Z6MtjIGMy+Z2zsj1/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=guK4b80F; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="guK4b80F"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1ba17bbcso25763285e9.0
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640368; x=1756245168; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w5Xrv+yZchFUzMTWX2SO30dKLg2MrQIxC8g2iyFC05M=;
        b=guK4b80FtrxJHpiMn22ls8NWpWj9gvHaHzDugL0xkQf5Gvs13S8AkYM6w74DLOR+TQ
         emeA4rU3175bBA4kXuv2hoVxDlNEGxIj+3ymU7AMfvJ/u5OnyjKkDguBLaMY8QENMSNZ
         dnZ7DmgOcXRXhQlHnLvxwPvKGWJbSx1bjT3CzfyjTQvMV2AstWx9LLt9W3yKMOIMnuY2
         Y32sOZXnrnXhLkGDCrjvqZV2R+YTTxECIrhvvQV6LzMp/xK+rRnOKKufQrKiBWcEZF7B
         yK+gir4cbp3nsx34wly9iNSvM9WaWLc4Igz8Md+tgfu8o6Bqol/imlettOyKo6qNM04c
         pQog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640368; x=1756245168;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w5Xrv+yZchFUzMTWX2SO30dKLg2MrQIxC8g2iyFC05M=;
        b=VNMImy3k0z3IsL37t15LfVYQrAOecHtNf2i6PSKq5PaCkp6d+PjLOhrCivnpZyyxVc
         Lrr9eDSFRF/7/21t/P5r9i6X34wSTB3+5T7soCAkZikGQwXybVPXJFKhrHsVTMbsPkC+
         QC00JUwaFSeDK8xndJRyosbCQLxZjU8VAIwTdY85SgVevslCoT7igAxMlYHkXzTNDmET
         zObkPpLwNhxx21wyo3qdtzsaqThrW7pXDrwvL7rJvCluyuSoa940xXU3l473DU6w4+7q
         itbFET9bivnYsLrK+/s+vbgfLJFw44Z+MHyxj112C4Dbe2eCGMMK3UtXB3SxaJ3+Xv8E
         cO9g==
X-Forwarded-Encrypted: i=1; AJvYcCWYKsr5NPQJTGgNkQC373inGm8uuhQT4qxUomTenyW2HgkSIsCvBg7iG42ix+AxLUWa7rPxYGk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+CaYQcC77fOZiCYLBoE6AqKiyqFssYoYBEgFXrMRX8j3j7PcM
	FiScliw2oWTg04rjs42pYaxbzdGoPLxCv6WxUrZHcugl5Cjgc7cjiW0EAsK9VfwVA7nbqg7g/pc
	CzajcIVGc+IAhTA==
X-Google-Smtp-Source: AGHT+IEkIYLt8jKXZ6jlGQreyOBP5MPpq4IR1pMtFairXlGsN9A2lAviNYTKCG1j1G3gzMwAxgyEa1tGajcbqg==
X-Received: from wmqa4.prod.google.com ([2002:a05:600c:3484:b0:459:dbaa:93b0])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3ba7:b0:458:bb0e:4181 with SMTP id 5b1f17b1804b1-45b47d904a1mr1114035e9.10.1755640367876;
 Tue, 19 Aug 2025 14:52:47 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:53 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-26-smostafa@google.com>
Subject: [PATCH v4 25/28] iommu/arm-smmu-v3-kvm: Emulate GBPA
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The last bit of emulation is GBPA. it must be always set to ABORT,
as when the SMMU is disabled it=E2=80=99s not allowed for the host to bypas=
s
the SMMU.

That =E2=80=98s is done by setting the GBPA to ABORT at init time, when the=
 host:
- Writes, we ignore the write and save the value without the UPDATE bit.
- Reads, return the saved value.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 21 ++++++++++++++++---
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  2 ++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iom=
mu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 0f890a7d8db3..db9d9caaca2c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -100,6 +100,13 @@ static int smmu_unshare_pages(phys_addr_t addr, size_t=
 size)
 	return 0;
 }
=20
+static int smmu_abort_gbpa(struct hyp_arm_smmu_v3_device *smmu)
+{
+	writel_relaxed(GBPA_UPDATE | GBPA_ABORT, smmu->base + ARM_SMMU_GBPA);
+	/* Wait till UPDATE is cleared. */
+	return smmu_wait(readl_relaxed(smmu->base + ARM_SMMU_GBPA) =3D=3D GBPA_AB=
ORT);
+}
+
 static bool smmu_cmdq_full(struct arm_smmu_queue *cmdq)
 {
 	struct arm_smmu_ll_queue *llq =3D &cmdq->llq;
@@ -416,6 +423,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_dev=
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
@@ -663,10 +674,14 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_d=
evice *smmu,
 			smmu->host_ste_cfg =3D val;
 		}
 		goto out_ret;
-	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_GBPA:
-		mask =3D read_write;
-		break;
+		if (is_write)
+			smmu->gbpa =3D val & ~GBPA_UPDATE;
+		else
+			regs->regs[rd] =3D smmu->gbpa;
+
+		WARN_ON(len !=3D sizeof(u32));
+		goto out_ret;
 	case ARM_SMMU_CR0:
 		if (is_write) {
 			bool last_cmdq_en =3D is_cmdq_enabled(smmu);
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iom=
mu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index cf85e5efdd9e..aab585dd9fd8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -31,6 +31,7 @@
  * @host_ste_cfg	Host stream table config
  * @host_ste_base	Host stream table base
  * @strtab_cfg		Stream table as seen by HW
+ * @gbpa		Last value of GBPA from the host
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -54,6 +55,7 @@ struct hyp_arm_smmu_v3_device {
 	u64			host_ste_cfg;
 	u64			host_ste_base;
 	struct arm_smmu_strtab_cfg strtab_cfg;
+	u32			gbpa;
 };
=20
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
--=20
2.51.0.rc1.167.g924127e9c0-goog

