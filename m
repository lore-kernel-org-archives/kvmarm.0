Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874AF23A582
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026762; cv=none; b=m42x78+nBWLU0E9AQXWBOSr5JOyKeSxweH7bSaI1+u7ybwk3jf5o+PQnzEBj8cGBwm0Sm42cdcaGNzst5fUvAGRcOWbfRbEsFclCUwOVzlxhmbgJ2O6LrSbVDfmpDXOmWsU8sCc5CI+TgO7OpelwtXY6ff32aDhvwPZCXPOejYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026762; c=relaxed/simple;
	bh=Esq0hs9+O5d4DdE62i+3pgWl+hf7rAK4wQPxx+ppKUk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ejnUnjaqNBrG5lF69r3dRjto8d+fBkdHzaJNm0656g8IAM24rIAuZrC4C3TfGoXdtTfJJa89MDh+PseMFkASYrlBQHqIDxQn/9z3UDPQVygyp93bG52rPi3M+EUkYk5HBPaxTvq4SkCBjGHewvOI9GvYF7m42we9zDIlqdSPwgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U81slY4C; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U81slY4C"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43625ceae52so5430995e9.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026759; x=1734631559; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUMjhbgyZS8tSMuBeujFF8/B0cPiplUozEzmSYJ1apc=;
        b=U81slY4CZ6F1/MNYEjijcL5VjLSfC0dI80ywIxx2hFHG4ZgPyvtfZ1GDTekSBTP/8t
         IpF4ce23YuB4kSu1N7UBFfLWtYzu02rAII9sgu9NCd0fAeIgikgchRLXLg+4NB3Pnfj0
         J7n6EQ3vcKotZbaFZBU7UAzhXS//gQXXOe8JHygOUn1eLZDi7jdaHTqADjaeuz1kkV37
         QV/VJ82/Xus8jGBrBL8hxiQkcq2Oi1IAIMwns0ia6nrdc/40DyvElqfAmpYEJ2S0h9q2
         F7Rf8AukeOEdClUiOLqPlud3q0PVKRumLn2eHxzQuDBgXIZoXKZtgwAPbF9IHFqOM0vJ
         eCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026759; x=1734631559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CUMjhbgyZS8tSMuBeujFF8/B0cPiplUozEzmSYJ1apc=;
        b=fAG7AsQc9VoXYjgX/sdeva7wuaZ82Sy+L/f90wacd9FvW0VS9cayJ6aM00JABCao0T
         65DLMLEo1NqQcoI0RMWuj6kILaS5KIlIhfzHxJwY3lhoDnELHP+FSMhWDDsP+CtIp89Z
         YW7L6qtYfRiEIPTYspB5ZTXsGw1QJfSVrWOd/+N0vBt4s4Vz/zKBdoX0s+K6oq+XdOE0
         nfNlj2S11K//JyDhW3AzLHPSczxSxi7H4TJgQZ9l2DOX2L0AUjm/e34Q5iSwC1lxAayP
         iigj0q8TD2jaCBYMjdQDD393hEVKLf8qtViQSuXeNpY1FTvbDJxVOibbi/rfVCLmKrHu
         NVyw==
X-Forwarded-Encrypted: i=1; AJvYcCU6HOQ8YrAt3UKuTJ+1A04ShHVl+0AJMSzK4UBwKtk9DTYkddXyNiQlYFHqn3RQ8JMp8GVv+3w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd26fx0pYO2QJb+emq3oClEzo9wNELwn4u3fcNLq9QR3PVEt2t
	z6o45Z9J9ppeWQtGGPTx9aM8NLFML8NgVfZyICZaG1TImSBPgwUsKwVNvRYvP4SsyJzg9Yl4jx0
	QQag7sdNRng==
X-Google-Smtp-Source: AGHT+IFcyCwxNNcgpiKYzT5jMC9sdAfx92qcWV3X5IeJOyZQbObkA8pT7Uz0LF7/zxo+itcxy4bJEL7vJH7gOw==
X-Received: from wmro18.prod.google.com ([2002:a05:600c:3792:b0:434:f2eb:aa72])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3583:b0:434:f871:1b9d with SMTP id 5b1f17b1804b1-4362287091cmr39010485e9.33.1734026759052;
 Thu, 12 Dec 2024 10:05:59 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:00 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-37-smostafa@google.com>
Subject: [RFC PATCH v2 36/58] KVM: arm64: smmu-v3: Add detach_dev
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

Add detach_dev for stage-1 and stage-2 domains.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 76 ++++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index a96eb6625c48..ec3f8d9749d3 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -335,7 +335,6 @@ static u64 *smmu_alloc_cd(struct hyp_arm_smmu_v3_device *smmu, u32 pasid_bits)
 	return (u64 *)hyp_virt_to_phys(cd_table);
 }
 
-__maybe_unused
 static void smmu_free_cd(u64 *cd_table, u32 pasid_bits)
 {
 	u32 order = get_order((1 << pasid_bits) *
@@ -1052,6 +1051,80 @@ static int smmu_attach_dev(struct kvm_hyp_iommu *iommu, struct kvm_hyp_iommu_dom
 	return ret;
 }
 
+static int smmu_detach_dev(struct kvm_hyp_iommu *iommu, struct kvm_hyp_iommu_domain *domain,
+			   u32 sid, u32 pasid)
+{
+	struct arm_smmu_ste *dst;
+	int i, ret;
+	struct hyp_arm_smmu_v3_device *smmu = to_smmu(iommu);
+	struct hyp_arm_smmu_v3_domain *smmu_domain = domain->priv;
+	u32 pasid_bits = 0;
+	u64 *cd_table, *cd;
+
+	kvm_iommu_lock(iommu);
+	dst = smmu_get_ste_ptr(smmu, sid);
+	if (!dst) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	/*
+	 * For stage-1:
+	 * - The kernel has to detach pasid = 0 the last.
+	 * - This will free the CD.
+	 */
+	if (smmu_domain->type == KVM_ARM_SMMU_DOMAIN_S1) {
+		pasid_bits = FIELD_GET(STRTAB_STE_0_S1CDMAX, dst->data[0]);
+		if (pasid >= (1 << pasid_bits)) {
+			ret = -E2BIG;
+			goto out_unlock;
+		}
+		cd_table = (u64 *)(dst->data[0] & STRTAB_STE_0_S1CTXPTR_MASK);
+		if (WARN_ON(!cd_table)) {
+			ret = -ENODEV;
+			goto out_unlock;
+		}
+
+		cd_table = hyp_phys_to_virt((phys_addr_t)cd_table);
+		if (pasid == 0) {
+			int j;
+
+			/* Ensure other pasids are detached. */
+			for (j = 1 ; j < (1 << pasid_bits) ; ++j) {
+				cd = smmu_get_cd_ptr(cd_table, j);
+				if (cd[0] & CTXDESC_CD_0_V) {
+					ret = -EINVAL;
+					goto out_unlock;
+				}
+			}
+		} else {
+			cd = smmu_get_cd_ptr(cd_table, pasid);
+			cd[0] = 0;
+			smmu_sync_cd(smmu, sid, pasid);
+			cd[1] = 0;
+			cd[2] = 0;
+			cd[3] = 0;
+			ret = smmu_sync_cd(smmu, sid, pasid);
+			goto out_unlock;
+		}
+	}
+	/* For stage-2 and pasid = 0 */
+	dst->data[0] = 0;
+	ret = smmu_sync_ste(smmu, sid);
+	if (ret)
+		goto out_unlock;
+	for (i = 1; i < STRTAB_STE_DWORDS; i++)
+		dst->data[i] = 0;
+
+	ret = smmu_sync_ste(smmu, sid);
+
+	smmu_free_cd(cd_table, pasid_bits);
+
+out_unlock:
+	kvm_iommu_unlock(iommu);
+	return ret;
+}
+
 /* Shared with the kernel driver in EL1 */
 struct kvm_iommu_ops smmu_ops = {
 	.init				= smmu_init,
@@ -1060,4 +1133,5 @@ struct kvm_iommu_ops smmu_ops = {
 	.free_domain			= smmu_free_domain,
 	.iotlb_sync			= smmu_iotlb_sync,
 	.attach_dev			= smmu_attach_dev,
+	.detach_dev			= smmu_detach_dev,
 };
-- 
2.47.0.338.g60cca15819-goog

