Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8744657C4
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 14:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707914; cv=none; b=XMksoQ1+a67M5IeyJKsXkOA7w1yQk5mqQxzKMLWJscHDAY5RiRFb1FA9EJJAXA4p+h0L/mQjuyoPXGLOdugIwv5MDSRzeGmJ4L7Y5QeNRYMFiTZ8J0EZxlEaHjJvKNd/LZluK5shb/+VkrHodFxVJ3urkbbd+DASWpeBo0TsPX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707914; c=relaxed/simple;
	bh=YPcdEz5k/hYGptLVZPb5hMmpS8SHy17Aj5bLXZLACHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KEaKPqvlC929uP1KShXHgakCEEm23hP1imK5rc6y1tIDqyK983TOV0aPJnsHbdxCP2QuPnUENT7JP55Gg7dnSXFSyTPt6Y2YL5md/0DWeqmazLngN770Vm4w2+lbQBLANgK4q7ql3h6/uk11WtPsm9aLUPWjZLtOQYkf+OCy6Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cF+/q6W5; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cF+/q6W5"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-462c4593a33so569480f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 07:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707911; x=1782312711; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aw1QEoh+UiZ5XFZdVoOucXmJoUZRDixdHeCpCeuLYa8=;
        b=cF+/q6W5TLQoo4+qsrVLHKOS3mcIpAhBSo051CR6cjBUFn8ylnOLwznF6AU0+mcAOf
         VW2ksyRjWywKVEFZc+Mv6pskmZVvde1wg7kW/PQdt1KA2g606nHcjm62WruMVV1+0OjI
         r/iw5Nwne86RdhJbsxllmOGDNP29HcTI0xfn7JImNkRSo8JU3vm8aPwy+y4YnLirJGPu
         8Ny4U6iplxPULwreUa+0lYBf/0pTjuCROCXIVETh55+YBPure1dBgmgWfdGb6HQhTVhv
         QEt9XswfpWdDShsHs5L8mymkscrFSwckpzNGQfiEdK+z66vAyE3Jx0Bwh+HFUb7s66rc
         zgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707911; x=1782312711;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aw1QEoh+UiZ5XFZdVoOucXmJoUZRDixdHeCpCeuLYa8=;
        b=UiYDpoGYNlqCq6hWXXXaF9OV7hXUryNfQu4o6Wdqe4/3nsxVH5G2kr2P2xgx5zTfm3
         kWZngMKK/cXqa6r4znpBm/1SLn83PHEUyWUmewIFZ1hLBo/HYVCeJVW9IutQ74FIN1gE
         tSdXfafUws1X3VOAkhKAPEgOfxcJAHs21iFfkchf7Qsh8jMbyuzq5h0sAYufA58EYVoc
         v060ptlQrOXb3w3pmP5qgqmDZtA7+WCnrFphnt738w9oKEGH9QDrA7syJcWr/f2XBRWT
         baIoRN8qdHWxAxSwE/c82du1W5paAx8jm861sLxtmw2rrin5Vtx7kXgkyT6BqwHiwONL
         igcg==
X-Forwarded-Encrypted: i=1; AFNElJ9dHEtlh7ACGYdAEmWtKbDVOEv2OkPuD8/fWwoyHDH6khAqNxQI0womm6FJgS5h2rWB1RbY7fE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwffSKrK4ZewlebwKF4Zewa+m6HQ9UvXtogYwzx51ovxCLptcQT
	AwbhvhHT+y8QUUpZ5CVcMKdv7WxrPU2wvJvWF8hmNIStzO8/ZzTSh5+mp3XmfnXcGka4bnkoH59
	/OUEsqDFXMe/u2kQt1aGzunjClVkIjA==
X-Received: from wmxb4-n2.prod.google.com ([2002:a05:600d:8444:20b0:490:4477:50d3])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3148:b0:490:b5d0:598e with SMTP id 5b1f17b1804b1-4923412f0e7mr58923595e9.21.1781707910745;
 Wed, 17 Jun 2026 07:51:50 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:51:29 +0000
In-Reply-To: <20260617145130.3729015-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260617145130.3729015-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617145130.3729015-7-sebastianene@google.com>
Subject: [PATCH v7 6/7] KVM: arm64: Ensure FFA ranges are page aligned
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org, 
	will@kernel.org
Cc: jens.wiklander@linaro.org, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, maz@kernel.org, mrigendra.chaubey@gmail.com, 
	op-tee@lists.trustedfirmware.org, perlarsen@google.com, 
	sebastianene@google.com, seiden@linux.ibm.com, smostafa@google.com, 
	sumit.garg@kernel.org, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

From: Mostafa Saleh <smostafa@google.com>

At the moment we only check that the size of the range is page
aligned, and truncate the address to the page boundary.
This make an assumption that TZ will do the same.

However, it might decide to use the extra offset of the neighbour
page at the end, which is valid under FFA if NS is using larger
page size.

Harden this check by also checking that the base address is aligned
and reject it otherwise.

Fixes: 436090001776 ("KVM: arm64: Handle FFA_MEM_SHARE calls from the host")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1a2abd0154c6..d7c5701d0584 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -352,7 +352,7 @@ static u32 __ffa_host_share_ranges(struct ffa_mem_region_addr_range *ranges,
 		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
 		u64 pfn = hyp_phys_to_pfn(range->address);
 
-		if (!PAGE_ALIGNED(sz))
+		if (!PAGE_ALIGNED(sz | range->address))
 			break;
 
 		if (__pkvm_host_share_ffa(pfn, sz / PAGE_SIZE))
@@ -372,7 +372,7 @@ static u32 __ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
 		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
 		u64 pfn = hyp_phys_to_pfn(range->address);
 
-		if (!PAGE_ALIGNED(sz))
+		if (!PAGE_ALIGNED(sz | range->address))
 			break;
 
 		if (__pkvm_host_unshare_ffa(pfn, sz / PAGE_SIZE))
-- 
2.54.0.1136.gdb2ca164c4-goog

