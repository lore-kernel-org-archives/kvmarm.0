Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FE046EC8B
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250212; cv=none; b=qwHisfRGcaYouXiS0LYxxgJIDOm5tSea2hhiCFlZuUabS+T67IV6R9Ss77U6tm0Nib5O4acgFGZXGZnVF0eD1vYEwWUcDHj+OYoXtxudmnWYb4ptgsOZDVpK6xzGP1DAhSmnFlLI6gIDVpvvmSneAM40PKc/U/uQbazVI0ts2kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250212; c=relaxed/simple;
	bh=kWJXaWyuesCIsFCpL6YdsJI1YLQp/6NcdM6dO9pkqnw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R+JxsqoVQeQM+OmWz3zc7AIvyNm+Qb+YSp8MXrY6yBuMARjvgQFz5NJernTIeLjQK1jQQGZ0hMWE3GcgA9Mf5aWpG7xNPVK9euPcQZl4USOuLJow6evyEfUmznwj9IDBTyv2yiRdofxpg+f6WpIujrD4r2m+iyTk7tje3My7yoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H9Zmx+8N; arc=none smtp.client-ip=209.85.208.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H9Zmx+8N"
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a1188c8948so4004526a12.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250209; x=1788855009; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xSVZnyl33hU0dXkrobfXyrVOZKlqCn75gAfkTpJqmhs=;
        b=H9Zmx+8Nt1sZujnn70DNCQ4FYURcHxDDVIZMM4O4ACuDYbR9cbx8C6ZUve6lPPVBga
         cgH5gTygGaXj28bsjIzunZHMQNovG46hvlVd01Ka9Tl3MAEQDxOQQpekX+9dWP/QZQuk
         Uwkv3D4+/z6zHShs1R/WeMN3TS83LgnHzkW5RDLHCK0JGnDj+TeuFBbtTzjXkA2DdL+R
         LMhjh4WTSV3EZG48mUN+4JfJwrVtcH42OVzX4oQ7TSn/uVPpU5CFARJwLznK3Lw7mWxZ
         yD4/i/eL10dfRzHeTRzU5RbwOh449Ht+W7zEs2KJyPfR2UhmnxwVMjZlop14x4o+GEey
         tVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250209; x=1788855009;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xSVZnyl33hU0dXkrobfXyrVOZKlqCn75gAfkTpJqmhs=;
        b=F93L+r3NC2l1anuY9RSXT+dJ2hOdkpq7TLnVhIqSOUepLZyk98y8agLkGElYK+Xd6v
         pmFnPv+OFirtBZ5huT7Sh2iokmkt9xNDvmT33fgGIU9E95UeHiTCZ6mIe+mGHzuGVIVo
         Pz/mTEWf7y8AfNbsMpcATEalzFxs95nibnye8LSl9gTSNg2oPO1UAK6nxKZz4RC4CUtO
         j1cFhkiCPxgemsLOf51rfvLGKGeNBfHqVSXW7krF5rKIneZYvP5AA94BIBiDgk3paGoc
         I1cpvs16+YPYBJPqqlYY2BuP7O0mx0NCbZjRG2FaWxgPtc4RgU6V+F9vnxRKj8S+wJts
         1pkQ==
X-Forwarded-Encrypted: i=1; AKwUvBwuJnGX8H+mf8wpWlU22JI3zGUtgX9VW74NH9gB0Gpg2oEDUqXVMlK3joTAV9G7jjoJVverAYE=@lists.linux.dev
X-Gm-Message-State: AFuF++mSXT6e1/MBvDeE5tfaQ68FLLPI5Y8n9bcjhMSXeW7fXUtESA7Y
	FBLGuFnEAmxNuEKyfAOKv0ejj41bBrOgo9fJQaiJfyU4zwhu2WzaMpzsbG8ZgBDDBQc3GDVa4Yg
	mGEN9s5m/ZZ+U+YeGJmJuQA==
X-Received: from edxn4.prod.google.com ([2002:a05:6402:5c4:b0:6a6:45d:a371])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2382:b0:6a6:2434:7cd8 with SMTP id 4fb4d7f45d1cf-6a663a0cc34mr3639971a12.5.1788250208768;
 Tue, 01 Sep 2026 01:10:08 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:40 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-18-vdonnefort@google.com>
Subject: [PATCH v5 17/18] KVM: arm64: Reject hyp trace descriptors with fewer
 than 3 pages
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

A trace descriptor with 0 nr_page_va allocates a 0-size bpages
backing region, which makes the ring buffer appear unloaded. Reject
descriptors with nr_page_va < 3 in hyp_trace_desc_is_valid() as this is
in any case the lower-limit for simple_ring_buffer.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 59349892b1e6..e34f9133e5d9 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -189,6 +189,10 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
 		if ((void *)rb_desc + struct_size(rb_desc, page_va, 0) > desc_end)
 			return false;
 
+		/* simple_ring_buffer_init_mm() expects at least 3 pages */
+		if (rb_desc->nr_page_va < 3)
+			return false;
+
 		/* Overflow desc? */
 		if ((void *)rb_desc + struct_size(rb_desc, page_va, rb_desc->nr_page_va) > desc_end)
 			return false;
-- 
2.55.0.897.gb25b4bd76c-goog

