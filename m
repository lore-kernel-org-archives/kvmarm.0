Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E792ECEA9
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 08:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764083; cv=none; b=Bwa7XnSAn5p6PrMh1IiSwY6w/giWztPVukfSaQsnNPiEN/sbpnWGdN39z3+nxqcQwbEw1A+PNPMNSoVyVGXNIiAzaUDmEWaTLJRiN6XXDbApzIfAJYW/1gfZR/cdSZqEQLViQKP992Pu9slrEapetjZ9Btg040XWCuLAUbAVHrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764083; c=relaxed/simple;
	bh=djyw3UFCiwMzV7bmORQp1O1b0BX5/uC4F49iUhOQOjY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gae7QbGM9RJxF3TSdjaL5X6clcqBQIlI5FncXDPVI8VdqK1pZI1UBk1cZ4UwVo+53CrX1nkyZVZO6c7H8VkQV8MSZ/kvWXLrEQomvfW7UL17NUhRV4Rq76ieUYIdkL2pWlddSAONFC+RdsgnMvFY9ZteeXFRH3armsF3rEyUP0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SYQGrUUl; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SYQGrUUl"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b9d41b82beso487393f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 01:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755764080; x=1756368880; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MPIqYp3UxnrgGl3qJNmgFxP+ej/sPqPAZCQlcsmkZcU=;
        b=SYQGrUUlEtsm8+fZoDCZOZh9+WPliGOA/FCB4CDTjqOXq0sYkUeOjAGvRp+AkyKOqW
         EpvS03uJGznZ7ELW/VsVEBsOv6ZD12kJp+e8A+1DX5F7ixfBOdqTub2rs3/Zk+8Az9er
         rcmjVwn2LZZmQr1sxakbnMh4QCBEnKqoGZFO3R+vGi/Q9VkV5s6U2KxrLKlAQTqmgiGD
         84rDoYNDsVQa6OZW4If+4G2ArTtiwu7C1Znp0FSHncBNKb51xIkVFb2ezXtOrxiKvRKb
         UkOVgYp1v1Tk2N2zm+JXoRkznXoUEKJSSuVLiYxIGsZNbydyg90VxYz4ZhhjUGmibS+n
         udwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755764080; x=1756368880;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MPIqYp3UxnrgGl3qJNmgFxP+ej/sPqPAZCQlcsmkZcU=;
        b=Fmog6j60kqdrjNI2tRic6fZ0ekomYAqRqQQcliMzAHjAanF2UiMqxrbRTELcgN+yaT
         yevDnrSHG1VMED7Ku8uvAFvATqiFZPJ19oFYYJ9vBZ84wPe0ry5DWZOCRkiYU3c0apUV
         zYmODJYS/ezEX8i0Hjs9d3EzAcqu+MR46Bqniy++gXHhBDBcfU0CmB3TQwmisNyXuiWr
         7FyPuGmUKqFqWuM7YCv7KgZhbBmETTL7yK183vu7BaIHnjKTGUvtreEK0wP896zPrI6V
         0Vu//jzOVBLyPkzQulKS2feDZo4hccYAKMW1DlfC9oo9ZM3s4nviYzDwRdfiGDgKmcZd
         SuWw==
X-Gm-Message-State: AOJu0YzGhz6lX4PPQunxZ2EeEDAWlLQF64GDC1MFV0cXjt93IZqECuXi
	AtQdc0tkxFN1RikRrg+myYXpA7cD2tU99ElL6OGkQOCSpGvr4V8X+sn1014e97bs2sQcy7lzyJb
	/3Hy/iyFSth6BdCftJpENeA==
X-Google-Smtp-Source: AGHT+IFW0oHYaYpDIBDZYmTqCX5wHO/vO6Eo9gvoYMFEfcVe8Gc0SJN49mBNwuBaONnBa7e5yp3hTafs+zGb5o3m
X-Received: from wrno12.prod.google.com ([2002:adf:eacc:0:b0:3b8:e019:9f6b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:220b:b0:3b7:8412:4540 with SMTP id ffacd0b85a97d-3c49596dddcmr1244691f8f.27.1755764080019;
 Thu, 21 Aug 2025 01:14:40 -0700 (PDT)
Date: Thu, 21 Aug 2025 09:14:03 +0100
In-Reply-To: <20250821081412.1008261-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821081412.1008261-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250821081412.1008261-16-vdonnefort@google.com>
Subject: [PATCH v6 15/24] KVM: arm64: Support unaligned fixmap in the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Return the fixmap VA with the page offset, instead of the page base
address. This allows to use hyp_fixmap_map() seamlessly regardless of
the address alignment.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index ae8391baebc3..75014dc7d82e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -239,7 +239,7 @@ static void *fixmap_map_slot(struct hyp_fixmap_slot *slot, phys_addr_t phys)
 	WRITE_ONCE(*ptep, pte);
 	dsb(ishst);
 
-	return (void *)slot->addr;
+	return (void *)slot->addr + offset_in_page(phys);
 }
 
 void *hyp_fixmap_map(phys_addr_t phys)
-- 
2.51.0.rc2.233.g662b1ed5c5-goog

