Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B79156F5A
	for <kvmarm@lists.linux.dev>; Wed, 15 May 2024 17:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715793800; cv=none; b=gozRywQHRr3KCPF77cW2m39BR81SjeEs8bJgHs4cI4l8Cv2tB876fEqLrZquVHDJE8dcwserJjHRCyXNkR9NG/davvNK0p+B1P5k8um2i8z2CboRB8C2KRDaFIi50teTBIgWPJ6chOtDMhAFX4StHu+XutLgJBKJzxiNeK+JUic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715793800; c=relaxed/simple;
	bh=Mmpk3cTXYb9Cytx2OXyWdNPcR2iwoJfjJ8SD4AaSDlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fq4HwSpYwBDzzyMI+4UXnOV8b+v8wd5nuBflix6cA7tJqE8hN/UMr3Z+Ev8OCeQMx9UE7gC5h/S4HjY/6YqbhQJP23VvVcmyOYTSsvbVkBVUNQAGQJrE9/w/7ltnlYztvUcWuTvU00ooPOyC2IQw0sO37w2mBDfinzVLi2pPveQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rRhsr6bm; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rRhsr6bm"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41dc9c831acso38466725e9.0
        for <kvmarm@lists.linux.dev>; Wed, 15 May 2024 10:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715793797; x=1716398597; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9HVNMjO2akSMcTTiBfbdxnnFw0wMMSm8FW4gVmT1QRI=;
        b=rRhsr6bmaumQKEC/0OdC71bNANnNmkf2gy+LOIU4CjFp1TQpkbY7r6JpbF74fVgRBO
         q46+paISQKaV+p/+/cpwjfKVWRBRTw53yQVwq88rJpP8Wt+/juTICZfupYGY/xAStbzO
         LojAmG7asblAIOalmapUiOo/45FrznytqcMpIND81Rt0BxnRdkpOTHMtsrMP11Y4R0we
         Q/CFNylURa2JmAVMw4dBavltVH9iulatNqKMVuUDMszxXC3+uhpbloHOTHwemXvwIEBg
         6ykF8nZaC9WDiFIlMmvyQO8QPQKnZ39V37wteEVgZp9e58DgNYVO101tIj0aROyK0kMc
         ya8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715793797; x=1716398597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9HVNMjO2akSMcTTiBfbdxnnFw0wMMSm8FW4gVmT1QRI=;
        b=J7WcHalBgNK0dnClO579A9aEcsV+lMdXigenTvpOn2g0nhmlHy5BX/LQDQC4CF1dul
         0FR+9qttsaw+KpujEPIB8jzrztW7+xIu7zOzslVB7LUuMUTe0THvc8+78l7PoUXq5gIB
         4LRYzmY2+ZObowtb4B97Fo6o8w+1Mpix9309+WxcNU8nkMi24S5O2yAf6KFsCGFEgaiO
         pu+VkAkYDuzoQQ6iKKGR1WXQ0k4uGJkWcHqqhtkURX8XdcZzfvL1ZYWPk363q3cfl+fc
         oBmiiL7hWhxWZ+zFt+W2vJDngq2FXFBsF9FP7fJkYocYdN9JxgBjw7DHWFfGbdVw6RO5
         IedA==
X-Gm-Message-State: AOJu0Yw5rvHEPZyGbgXKmX8yawrZyDHqELmFpcDP7h0IbnKQgwol4B8G
	AR1hWfN8i6mvBDOvblTUq71m8UABlwoJMNglwmZOPwcN+K19nagvLyzG9o23BuSIyxu/2Z13/y0
	XxsaM1wsQIJTFWfxjmJs/rNInPA==
X-Google-Smtp-Source: AGHT+IF2+ZdhABrnKPyUROWJCaWhOUajRbqGLHWL21MZQxT/ip0TW6XIGdVRzaMZh4Ur0gPZC6lIS0u4//WU4M/kut0=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:511d:b0:41e:8c00:94a4 with
 SMTP id 5b1f17b1804b1-41fead6accamr2395155e9.3.1715793797270; Wed, 15 May
 2024 10:23:17 -0700 (PDT)
Date: Wed, 15 May 2024 17:22:58 +0000
In-Reply-To: <20240515172258.1680881-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240515172258.1680881-1-sebastianene@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240515172258.1680881-5-sebastianene@google.com>
Subject: [PATCH v2 4/4] KVM: arm64: Use FF-A 1.1 with pKVM
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com, 
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com, 
	lpieralisi@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the layout of the structures is compatible with 1.1 it is time
to probe the 1.1 version of the FF-A protocol inside the hypervisor. If
the TEE doesn't support it, it should return the minimum supported
version.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index f9664c4a348e..bdd70eb4114e 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -458,7 +458,7 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
 	memcpy(buf, host_buffers.tx, fraglen);
 
 	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, FFA_VERSION_1_0);
+			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
 	offset = ep_mem_access->composite_off;
 	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -537,7 +537,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
 	fraglen = res->a2;
 
 	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, FFA_VERSION_1_0);
+			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
 	offset = ep_mem_access->composite_off;
 	/*
 	 * We can trust the SPMD to get this right, but let's at least
@@ -846,7 +846,7 @@ int hyp_ffa_init(void *pages)
 	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
 		return 0;
 
-	arm_smccc_1_1_smc(FFA_VERSION, FFA_VERSION_1_0, 0, 0, 0, 0, 0, 0, &res);
+	arm_smccc_1_1_smc(FFA_VERSION, FFA_VERSION_1_1, 0, 0, 0, 0, 0, 0, &res);
 	if (res.a0 == FFA_RET_NOT_SUPPORTED)
 		return 0;
 
@@ -866,7 +866,11 @@ int hyp_ffa_init(void *pages)
 	if (FFA_MAJOR_VERSION(res.a0) != 1)
 		return -EOPNOTSUPP;
 
-	hyp_ffa_version = FFA_VERSION_1_0;
+	if (FFA_MINOR_VERSION(res.a0) < FFA_MINOR_VERSION(FFA_VERSION_1_1))
+		hyp_ffa_version = res.a0;
+	else
+		hyp_ffa_version = FFA_VERSION_1_1;
+
 	tx = pages;
 	pages += KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE;
 	rx = pages;
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

