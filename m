Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D617254CF53
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082813; cv=none; b=gJ7bpgV8pN/bO2QhUsBEuZiYlpQGPIGV/zwT14idd71b7WwI6yy2USXDsFfYnjG62Ai4mcVTcQ+YYiFRnf0UyIwq0BzpJYib14HgljdEn7PYq2oGeZ8CR3M8zoVZI+IzoruHLBBtvSzy2cP2h63CcI3dh8jjOCNGbzzDuBYHgu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082813; c=relaxed/simple;
	bh=mTHSYZ8oIyH5+jZA9kzIy7do9Yh3x2nmm+86lRMfbrU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d8PmxTwZY7WRj0uxOis9ju5gz1pYgHsIGhbC8wyxLYrUl2H6J8xszEvz1EbSEE4deFAmnrbJD5QmvRG37lJPQsJnWCUtyJISXa6G4sfyB5RAieyGtsfDT5jgY6GfUfHUcmyuZUUjZbmBq8jfVpyXjJE7Sy+2B8qKFlLSUDC6wyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v/+VP+K3; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v/+VP+K3"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49fce60a8d4so17375855e9.3
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082807; x=1790687607; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P3DEXLWinBeC2wh/ugj+OMoPA5T1eV0IuqxQq4Yim5M=;
        b=v/+VP+K3a5qWF7rZPEvhBx2bf4oUrWyGZKcrOkknfRmmVtOFEteHhfBP2d9mg/BUd7
         CQCH3Bibq6JxCeCwZ4dsLRbmxXa1h10tMUJg1eTSw6pphYjildNJtC4KxzcNcQ/sdVlI
         80M6pNfLHDZAIk1DMhFcZQvNFrH5GH+VhhGomaJC887iV1Q3Gw6xrGEmmjLXCPjCM7lk
         tWjnq3Lh4dZPqZUU3NTCVLrPdarUbYyC97mdF6Ldgs5aNBEUaP86LdJb03YScMtxR4sR
         pi8ue+TXtK6BLesGiK8yOsYULNUEorvosbsTUPUBec0ZOrDU+rFkJMOZlDczksLmfORh
         uT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082807; x=1790687607;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P3DEXLWinBeC2wh/ugj+OMoPA5T1eV0IuqxQq4Yim5M=;
        b=qFemqCBbZxpVFM2Et+zeIh+FxvDKi/XYqTX1zDwjqzBxPzo3GCcIrkVFyGM05UE02U
         rv0eP9xlLYvVAb18+K7eBDqTUTEiWfXkG4pEOd7xM7PN9yxosVdUhfJasX8NnIKDgBwE
         x1pT6cV+BiKT+Jr6J8+Ne+HTYcd7QdOXZ662T479Tuh5dWtYjRPP3k/Y1daFCjRCwHt8
         Zk7YQqMChJj9p84Db5ouz0ytaQtJhcGzcF+OrDXfKHu3ZzZQSmOnIOvIPnomVHJNeYY5
         sqIbhDDkGh1EQJC1+++e/VgGyt7+nnTurnk4LLNX3YEKyZf5azL75id+31cr4+CT5JvN
         nNwg==
X-Forwarded-Encrypted: i=1; AKwUvBwhTP6eoBZM+EEhyVsNQ9lh3oWBROx62EdbdEUUoCxu+cMCZl0LCaK65XAu+ogZOyUrbCa1+Ms=@lists.linux.dev
X-Gm-Message-State: AFuF++nwKq8qIoLxLMl+wvbDdc20x98GaSrU48d0zj9Xn0AaPWaAhgkS
	TGQTFI/+SfUR/Q/I9SbIshHw6OjKDJUeQO+9ofVmu2fih6YZswc6QPp2laBzmb+ri9018w2VVK+
	S0tVWxa9tsjWOjA==
X-Received: from wmxt2-n1.prod.google.com ([2002:a05:600d:8642:10b0:49e:6b4f:f95d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3585:b0:49c:cee0:f383 with SMTP id 5b1f17b1804b1-49fc5734ef6mr253475505e9.16.1790082807063;
 Tue, 22 Sep 2026 06:13:27 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:53 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-21-smostafa@google.com>
Subject: [PATCH v8 20/25] iommu/arm-smmu-v3-kvm: Emulate GBPA
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

The last bit of emulation is GBPA. it must be always set to ABORT,
as when the SMMU is disabled it's not allowed for the host to bypass
the SMMU.

That's is done by setting the GBPA to ABORT at init time, and host
writes are always ignored and host reads always return ABORT.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 32 +++++++++++++++++--
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 00528380774f..6e023e968ed3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -215,6 +215,22 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
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
@@ -453,6 +469,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		goto out_ret;
 
+	ret = smmu_abort_gbpa(smmu);
+	if (ret)
+		goto out_ret;
+
 	return 0;
 
 out_ret:
@@ -778,10 +798,16 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
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
2.55.0.1082.g2b9226bbc0-goog

