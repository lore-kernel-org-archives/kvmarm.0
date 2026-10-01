Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996E9521215
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864970; cv=none; b=BuUzdz22IHeN+PT/gYFha48vF+/5/TdIMfBRvASHyZGNMuBrvpalKLnEckCET3ZYBOMuC/M51zCBik7iIsLVIez3x4YXJUCbAO3DtkbxES2zVn4YF2fSwxDAkpIQxCmqga/3jp8DaL2XMmX87npiRkLJ4kDUnAeICj/ip7YNghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864970; c=relaxed/simple;
	bh=mEUTDjZ8jq8BYixT2yu1AjeNT67iNrk0ei6CP39VjPM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=emSREUeG7isHiX69S7Vh8NOJ38WXtmrhSVoZI/qEKuWkB8p7AehCGyLMwOsh5u4Ex5a2iDY/wbMSqayvkAO/CeSe5rZh8ykU2aF2LstEx7DhXdwEgoeyLYT+Gd29+Qdtx0tl3VGdq7JwYl6uBffHKs+8+KDyIcubWiI2q0eV1U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D5EJYnm4; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D5EJYnm4"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4870663a5c4so3352100f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864959; x=1791469759; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5aJhDXgEDSV7qScb/Rc6CoH0I6fM9qFOzvBEEtPC6+I=;
        b=D5EJYnm4hkhC9xEBO3B+9chuz27ui5XuwJxRbVWyo68BpR1IfN47gasLoKg85veaS5
         hZXOCfyoLDMqVl0fC3dDuTeV67S35+0qY/HBgZsKQlVzSJaasdsN8+b4jb/DK6BUvI+u
         dL92nuiAJZsyXy2Cp32ZL+JrujYH2ChB6DV7TY8ED6qJ/rkyqrl0iA6nyMv0za1BYx5k
         WAj/QPtnoLQjHqJKPUXyC5gF2/2CiB0/sRL4W5/owizNO0sDdzt7UrLkrya9Z8Ci3PfW
         Dvmir7V4zcv/WaxBpxPQXnQ81KOQbd9Z5xzlt4/L6IaaykeAWTvRmGfJDA0iDimlgxFk
         zR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864959; x=1791469759;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5aJhDXgEDSV7qScb/Rc6CoH0I6fM9qFOzvBEEtPC6+I=;
        b=1po0qXtuTeR3QZHZZEr4PrehH+gsLOWK2dehS/5I26TSCUD+BNCNMpfhJHWGMFvvJr
         cWwphuNX2STvsBm79KFzO/3dMQOurOxNvPRImSKDGneaJucgsKZyxoTRgRroJmeoGz1V
         7XBZbtdpxl5xQ7KTyv9cW3jyGsLyTyXpZdQ8liVmcRNY/DZZ7O0EkH3l4cuq2xF45Ctj
         QoC3uv9Hp6gN/Gmdafj3iIlPJ+F36OgDIrJed+JhELFe+D/ny8IYDwfXMM+ekk06kjyw
         ds7f2XmLmC/w7Ogz0myRntaubElul1NcTdSRyxn2PVy3tn0g5RhpfaajStjS8ospAdyq
         TuMw==
X-Forwarded-Encrypted: i=1; AKwUvBzCIOAh3VB4kd+its4sMB/nIMboko3j7aFrmSByJOdjoFUzT3dbt/W00TP193aN/STiy9RxO8c=@lists.linux.dev
X-Gm-Message-State: AFq9FYIRbRfQMkrfCuzRxmCM5XiSt/alnWI+W12hJRJT2oI9hJ88K6MX
	YgXI0PS+ASaiQyE0H/WQHBLJwS5F7YMjqDX4E2gWk5hqKlB11zX4E0eCfnXDKmTaYLH5xhj8rMR
	pIeHUrSZQRmDk2qWUU11XVw==
X-Received: from wrbfp4.prod.google.com ([2002:a05:6000:2784:b0:485:82f9:4ab3])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2f85:b0:48b:1175:e76e with SMTP id ffacd0b85a97d-48b1175e88bmr972912f8f.30.1790864958096;
 Thu, 01 Oct 2026 07:29:18 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:48 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-18-vdonnefort@google.com>
Subject: [PATCH v6 17/18] KVM: arm64: Reject hyp trace descriptors with fewer
 than 3 pages
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

A trace descriptor with 0 nr_page_va allocates a 0-size bpages
backing region, which makes the ring buffer appear unloaded. Reject
descriptors with nr_page_va < 3 in hyp_trace_desc_is_valid() as this is
in any case the lower-limit for simple_ring_buffer.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index e9e584694506..7acb81ae0e6a 100644
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
2.56.0.rc1.315.gc6ed9934b7-goog

