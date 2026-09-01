Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC299471407
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250211; cv=none; b=HJn3zA/XWXpolGPPW1taoQcRWqJ0/Bntnpm1gXN8UerpQOH/dbQ0gmP8c9RA1m9eYa30tPuKKugrj1X2T6TFPUqCG0qq3v17ZJLx6nWQA2C9+ULs+ONVvp8tfo5EaSZ7+5QNAtpSrJk5zX9nPp1MR4W9oT66m4hL3iLF/mEg8hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250211; c=relaxed/simple;
	bh=sS2cu6IhXnpCrvV42v5lKCwwVPUt4uiZX3gLLloJgow=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t4WTGe2ayY/4dtkOEkDRCNFikz88nsoqvDjLuCCv6SxAIVqUSYATDEGmemeENLpJOh2Tfx2IATldW/0lsWTucHZux8AQ3l89DNYomXrDOdQMCbuXHv0IevJHJt65ypDV8wio+G6o/J/0NFrM1x4JLwCejw3qZQ5KUmSZhhTzh28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c/TUV4iG; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c/TUV4iG"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49b0e6638e3so34099955e9.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250208; x=1788855008; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=68IKPCSD45TUbedcch7fsQcHfPv+DE8pLAQ5PoKdxtY=;
        b=c/TUV4iGV6tboKTHGlqi3+AcHuwlto4xO+j5PPMJ5K3SLNYzI6W0yeBiwnGU6FnPw1
         pj3dJIJy60bESx8JEel1ko7oGnY4xcc91uJeB8xpv0iDniENfRyBMhuke25sn2121hZb
         h0Nufla6oIqKhNqZVxMe6Oduj6dFJyH9PssDuL6vKYrfU0ChfoDcy+NcTDuLp7TB0NwO
         Im7VBFmCibwfHLJIGjXo8zIf5HYvYvo53OjDUGx30RBh9ZGEnP7SWg3rBjqfHA/GcJ9f
         RmMNFaukbInpzVm556NR/MRqjccR9LMkjiNe0hK+Xis90x1d+tFV5MFmLZdQFTmo/1UF
         pxBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250208; x=1788855008;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=68IKPCSD45TUbedcch7fsQcHfPv+DE8pLAQ5PoKdxtY=;
        b=lNCIi8dxabQBX0udirU+/A9y4o2vAhVGVJFIrkc+/WtQYdnfTZxRqhJvdSes1rKHDU
         0uznNqFG1JN9+iAb0ulEr/4GoSyOItokSrhqDFFKgqjXzFYIvTTiX4sqS48oC2DlbT1K
         7klqB7i1MeE09kz2ZzqF+PdztBFQrRBMScQjxvtk887VKgtQzxzYvuiMdYw2/okx5orO
         fenLNpXWE6bi3gbjV//HHMLx0kq4GqjIwKTDSTDThd834N79cQO9/MzGCu7qkZTRUEe6
         zlrTODpAsqJ1W1SJUZ0nzS0IqrOARgvHkwje+Fo48AU+m3svAHsgjWfVbqc4Fl4k+EC5
         +Gsg==
X-Forwarded-Encrypted: i=1; AHgh+RoMGivzhopXzQI2sNe5G+Gk1ZTVL2R7ta7poVnVPM3m2CHD73qV/ixziYs6WEf2914KMRe5WBg=@lists.linux.dev
X-Gm-Message-State: AFuF++mmwcs4qoBU3gxNQX9+n5o2ifTLAfUBduUzQP5vhuxQYmEeZPwi
	VO6STq0TlRaQFqaEgAAF3T6k3v/N0X9+jqy7gU9khyf7zJxBRYcwliEzzokG5A8MGJRq+m+Hae7
	5oVwKHiTiLeI+CSlIENrvew==
X-Received: from wmbf8.prod.google.com ([2002:a05:600c:5948:b0:49c:d385:6ce1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8411:b0:499:bf0e:95c8 with SMTP id 5b1f17b1804b1-49cdc405494mr118324005e9.1.1788250207366;
 Tue, 01 Sep 2026 01:10:07 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:39 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-17-vdonnefort@google.com>
Subject: [PATCH v5 16/18] KVM: arm64: Reject hyp trace descriptors with fewer
 CPUs than hyp_nr_cpus
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

While a trace descriptor with fewer CPUs than hyp_nr_cpus currently
causes no functional issue, such a configuration is invalid and would
cause the hypervisor to skip ring buffer initialization when allocating
backing pages in EL2.

Enforce nr_cpus == hyp_nr_cpus during trace descriptor validation to
guarantee that every possible CPU has a valid ring buffer descriptor.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 65be6c9fb379..59349892b1e6 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -181,6 +181,9 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
 	desc_end = (void *)desc + desc_size;
 	nr_bpages = desc->bpages_backing_size / sizeof(struct simple_buffer_page);
 
+	if (desc->trace_buffer_desc.nr_cpus != hyp_nr_cpus)
+		return false;
+
 	for_each_ring_buffer_desc(rb_desc, cpu, &desc->trace_buffer_desc) {
 		/* Can we read nr_page_va? */
 		if ((void *)rb_desc + struct_size(rb_desc, page_va, 0) > desc_end)
-- 
2.55.0.897.gb25b4bd76c-goog

