Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2F9237FE4
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026747; cv=none; b=NIjG/awA2QIEeqPP8wr+U9SmpRvdD8PrbyI4tX12/F5AK1p9zuqt6/xaP/LaxNmL21XkVEQp9O/YIlkHI/9KS/qk+9yjEkdKFRiUspT5Ilcv+akXNBExkz6VPnP+uX5honjTPWhzQJYNBeG3WJwaoLPSP4OeKv2qAzPhQQhk76k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026747; c=relaxed/simple;
	bh=A77HVtgiNiiuQUM+4fbCpZhMG/L5Q9L2AOqjPUwbohA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AfIvVAUNWlrPX7rNKRRn5YNqGEJb0KDAxG119MJ5pdLQfC2l7Q3czaO6nbBdXeL20uN3E65ksvf7i+j1bc1lY9I+c0VVyBvH/NFkfma1CKZTN38tjRnQNOsdKnChdS5bcUZudp/PXpgz/fJVq0dsIXkq19A9smmqI+t7Sxjsw0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MO0EYzSa; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MO0EYzSa"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43626224274so5441995e9.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026744; x=1734631544; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JE/i5lAaPb/dJbCdJrBXAH1qN4sLI6tJdn5DSSo5Z6Q=;
        b=MO0EYzSagqpVVddeWDz4qh2TnNtlLA8igiZiv11VbWRQN+Zdc8bFGVTWUaFouwW/Kz
         3/1iGginoazbmj1TLWHgaNGzrUQRL4wp3qX22ve65ePjIlqpZa1M4VrPzspCs/iTLo7U
         pJgN069cHqEsTCxZ9mnQsSyaS6AZv4WWNAV2BangjnlwCgaRiQKTPuK4eR1JOVWn6IGj
         yb3q4hTv/MCFkcqWgzmxyR+2oWR3qebnCOrNPqN95FfkAAbUK3/biK9Fr3LMB+hfsTrX
         6AHE9T7Q4i+lA0WLG9IPSyKhMpxRDFDy2TgCwOEgboKcLykDkzFk9zSAWYFqF9SaIEWP
         XbLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026744; x=1734631544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JE/i5lAaPb/dJbCdJrBXAH1qN4sLI6tJdn5DSSo5Z6Q=;
        b=Gn4MqaHwhBdqLJLoT51caSQaQGUuNetD3d5QuL6HE2tE+9fVIth1w0izjTOowxEC08
         5ZFyR+Ivht+mqlN3wGIi6US2zgMLzzILoXEvQQchWvbG2Lwx+U19aJV6Jmv6M6lsSDWd
         njd1LLxXbNartVWRwWPQ59r3zzOaegXYeOKbA95+u7SjydaJEOHW4yCBqiafl89WTHbE
         XIxe4/0cQ/bDN3DpdvopQpEiXufGGgR2YRsJ7YPe3TF/QveCjWzznQnfSmDWlNfGWFDQ
         chFkV5Hid4DHjAZ6noUDMQGl4gtttU6zehU5zxedEAlbBsdEUPLSzFS7nUG5N8JhB1Cy
         PhbQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2K5IzfCtvbtwhysb9YNeksJEbXxBnmLg6DoCbWO3GouME1yvf63LtWIS1sCyTaBBjPsPiXCg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjVYhyouzZdGCZBntI7ytLgjIqh1n8jFn6Pm8O//2mnX7vdNpc
	eL9pn/BmloLtIxl6mE2jrceFj3mkvCOh9U9GBlCdGakJPxh+8gfQDUD8pu/P1TuMMQjYeF4820y
	D1v/BZcg70A==
X-Google-Smtp-Source: AGHT+IFLzVaDnxOQQpqmcBPGMzPT4gfF0J87Ucqw5+xEyz4q3jDg+AjzzwnSPOPsWSAVi+g32NOxN+jbO3aNIw==
X-Received: from wmbd18.prod.google.com ([2002:a05:600c:58d2:b0:434:a98d:6a1c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5029:b0:431:44fe:fd9a with SMTP id 5b1f17b1804b1-4361c3e010amr64441725e9.19.1734026744100;
 Thu, 12 Dec 2024 10:05:44 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:53 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-30-smostafa@google.com>
Subject: [RFC PATCH v2 29/58] KVM: arm64: smmu-v3: Setup event queue
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

The host can use the event queue for debuging, and unlike the command
queue, it would be managed by the kernel.
However, it must set in a shared state so it can't be donated to the
hypervisor later.

This relies on the ARM_SMMU_EVTQ_BASE can't be changed after
de-privilege.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 39 +++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index 43d2ce7828c1..5020f74421ad 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -342,6 +342,41 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+/*
+ * Event q support is optional and managed by the kernel,
+ * However, it must set in a shared state so it can't be donated
+ * to the hypervisor later.
+ * This relies on the ARM_SMMU_EVTQ_BASE can't be changed after
+ * de-privilege.
+ */
+static int smmu_init_evtq(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u64 evtq_base, evtq_pfn;
+	size_t evtq_nr_entries, evtq_size, evtq_nr_pages;
+	size_t i;
+	int ret;
+
+	evtq_base = readq_relaxed(smmu->base + ARM_SMMU_EVTQ_BASE);
+	if (!evtq_base)
+		return 0;
+
+	if (evtq_base & ~(Q_BASE_RWA | Q_BASE_ADDR_MASK | Q_BASE_LOG2SIZE))
+		return -EINVAL;
+
+	evtq_nr_entries = 1 << (evtq_base & Q_BASE_LOG2SIZE);
+	evtq_size = evtq_nr_entries * EVTQ_ENT_DWORDS * 8;
+	evtq_nr_pages = PAGE_ALIGN(evtq_size) >> PAGE_SHIFT;
+
+	evtq_pfn = PAGE_ALIGN(evtq_base & Q_BASE_ADDR_MASK) >> PAGE_SHIFT;
+
+	for (i = 0 ; i < evtq_nr_pages ; ++i) {
+		ret = __pkvm_host_share_hyp(evtq_pfn + i);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
 {
 	int ret;
@@ -429,6 +464,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		return ret;
 
+	ret = smmu_init_evtq(smmu);
+	if (ret)
+		return ret;
+
 	ret = smmu_init_strtab(smmu);
 	if (ret)
 		return ret;
-- 
2.47.0.338.g60cca15819-goog

