Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385AD1DDC0B
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 11:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742989154; cv=none; b=JnnWe+JpL8iFHR7HikJ1ChXgPNWfmkMDfo9Izn9qbOHRhw3QTB8WvEIv15qq1C40RjYZVHIOjr2pu/7kYL1unOEpItnL1tPYILBFxaPKg96qpbszHrNls6qtA354vdSf5X3bILqz8caQUYZDnJ8RVA6ULA54b1/T8L20hALWP5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742989154; c=relaxed/simple;
	bh=gBk9lt7tJRLeaaZ+rHtlU9qDo0L2uhlfMTlwA/Ull7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j/FdqeMzr4RiCBbOMyjegRs2RlA+/Gfp8Hu8E9FBv+BLzoNvE+iQHUhvQCXH7GUKkvjBrsQSAzOiEVZ1id8pQgvc9wITeAcojwcwTiSJjzFCmTYmUZYTC9n3Ddi3uRbgWa6PYFDMiVA/XOOYPh5cj4mIlsv9WBCqnD5jmYK3h2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LTnZF/RI; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LTnZF/RI"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cf172ff63so42613675e9.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 04:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742989151; x=1743593951; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GHf91QhT51iYy83lJisFmODA+pFXdAkAB/GuCBpC2zk=;
        b=LTnZF/RISxr6ngtIdUoKyEcdmR4ym1LxPb6TdC3BEJ0Uyzbcs05WFAJrDsiJUscc57
         fCsVmITzLszyQ4BfSM1eYxQ1SsSL9e3SxbLsYjSWRFu2apT0B5ssqFajzzsc71snnlmQ
         HRDSQjtNpE092ns8ZcUg7V71YiI6aXXzj0W7O0mkM16hmhro35wLiDrJNKBn3ugJA+ze
         bOJGCwiJScsmMOMPKC1IJjh2ze5AFOwBAujF4n1YNHVNWZRp1Ot3bGLQUni1ryrwJgPh
         FvfLQi7dnbct/FZhdTJPWonaAxBBtrWrDE28xGDKEyQePnMN3cQIjBSlSYohaGnmll6g
         SR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742989151; x=1743593951;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GHf91QhT51iYy83lJisFmODA+pFXdAkAB/GuCBpC2zk=;
        b=rA1inaKvwJ6OqP+FgSAI15FFXzApAFWRJY7FlwkuTvrvd3CSF83noA+k68QmtwKBC6
         I0/R6OhBMXQ2sMnSW2Mj68GlgReE8EXZ5mu2F5rkx9G917R8st1gcv74O/2GCR31fgqw
         Fg025amF4VPY9rBwndCfHTSEYpILfyVsnJIxHKRZTi4jVILV0Smpk6GQZBzThG61y1PV
         9MkbBso5BLqjzP9IJKhdGujV9QOfpRQzUGnFv0HomI1UdnimvHsfRdxC2Ed4EKLAwtDr
         0PRaWeGblEF+0C3TXAZvchx7efKAlVU+nCdt8IGULmGGsTGLZMkKUoJKXhJJnisJ/+8J
         CD1w==
X-Gm-Message-State: AOJu0YxhpcM3zVM/XzkTo4CNngjtgr8cfHNwwfej7UR6Sn8g9GHyMwA8
	kj1ISiPPoNSHJQXQTkZvQYQQT3g+pwV29GDIrvscf2seBV5zmE0wtwpxgraZUoQ2mOBLDwXA22J
	2w+YO7pltjptxf5n7HvsVI53ZcQ==
X-Google-Smtp-Source: AGHT+IHs0QnGDLw9n/4cRwsa7oyAsEcllQx68V0oWKnfOqB/3TAlLPJ14NKv8m2ojEKJA3YBjubucjAO0uNkMu+4Lz4=
X-Received: from wrck14.prod.google.com ([2002:a5d:524e:0:b0:390:e325:456e])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:6c61:0:b0:390:f902:f973 with SMTP id ffacd0b85a97d-3997f8f5c08mr18860296f8f.8.1742989151526;
 Wed, 26 Mar 2025 04:39:11 -0700 (PDT)
Date: Wed, 26 Mar 2025 11:39:01 +0000
In-Reply-To: <20250326113901.3308804-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250326113901.3308804-1-sebastianene@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250326113901.3308804-4-sebastianene@google.com>
Subject: [PATCH v4 3/3] KVM: arm64: Release the ownership of the hyp rx buffer
 to Trustzone
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com, qperret@google.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Andrei Homescu <ahomescu@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce the release FF-A call to notify Trustzone that the hypervisor
has finished copying the data from the buffer shared with Trustzone to
the non-secure partition.

Reported-by: Andrei Homescu <ahomescu@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 6df6131f1107..ac898ea6274a 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -749,6 +749,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
 	DECLARE_REG(u32, uuid3, ctxt, 4);
 	DECLARE_REG(u32, flags, ctxt, 5);
 	u32 count, partition_sz, copy_sz;
+	struct arm_smccc_res _res;
 
 	hyp_spin_lock(&host_buffers.lock);
 	if (!host_buffers.rx) {
@@ -765,11 +766,11 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
 
 	count = res->a2;
 	if (!count)
-		goto out_unlock;
+		goto release_rx;
 
 	if (hyp_ffa_version > FFA_VERSION_1_0) {
 		/* Get the number of partitions deployed in the system */
-		if (flags & 0x1)
+		if (flags & PARTITION_INFO_GET_RETURN_COUNT_ONLY)
 			goto out_unlock;
 
 		partition_sz  = res->a3;
@@ -781,10 +782,12 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
 	copy_sz = partition_sz * count;
 	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ffa_to_smccc_res(res, FFA_RET_ABORTED);
-		goto out_unlock;
+		goto release_rx;
 	}
 
 	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
+release_rx:
+	ffa_rx_release(&_res);
 out_unlock:
 	hyp_spin_unlock(&host_buffers.lock);
 }
-- 
2.49.0.395.g12beb8f557-goog

