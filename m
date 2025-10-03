Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09B02512EE
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498759; cv=none; b=bGcVw7lyfQa26DSsLU5eI9KkehCO+ugCn4xhq3P6z6jwqqsCXz6CJj2g9UmDjIMQD3PNcLTP8hHzkjxOHkmNRhDporShprkLxi9fAu07U3C48ON8eCQeZlYaMDqA7H2DSe0kNBguDkuRMzm4Z4b5UetKiYnBDuAMSgN8GMHtl+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498759; c=relaxed/simple;
	bh=jCbG47nIr2/y0UdsIaiKkxyaIjKy+gc2r3vZExVABsk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=afaQNLLwsJ1JewW/APvg1o2IszPWrSdpfzfidU+P8I5hzhq8ETOoOcibnLhaWNquht0qxV4LRgFUSBNzKD4gvHMh1nrRDSoOo76DPrjfOtrGhuUeJQOxp4H4y81en352xrFd271POxh8QNRO3ZskqVfOmKsX9jwFI4cYTgKS+Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UaS5MbX8; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UaS5MbX8"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e5bcf38dfso22013915e9.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498755; x=1760103555; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1VsntBoZ2UX1thgOJTBqIcQGNGyw+Zp/ZR+M9plVUyY=;
        b=UaS5MbX8fHNtW9w4qNMx1wIDOPbt2Noz3qNpcDeNZ2s458JPRw41+43GmqxxLKpQRW
         4cqsKJCAp336WkdA+UxzG2CF1sk2Z9bMexoJZfo8SP+ZqM1yGbBvNuWSXsL53qL76RTq
         RswNhEwHOC1vNP0z3rU1+IuHH6C9KKrMq8DS1NY2+n+HtGSuxWdE1ocax9fDVNvQPVcg
         q3+CElKYC0Xpdn4NajH/6QtiiucolWag9G9As5O7bBlrVEa0ybg7VGmwaryugaH80n3X
         JgX+TACfY80ni2CVtNUVUVLBgGK+ojVsfJbepr8p5KL8FUPyP2sF4hndtWr/U1zVvOZY
         7q0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498755; x=1760103555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1VsntBoZ2UX1thgOJTBqIcQGNGyw+Zp/ZR+M9plVUyY=;
        b=SPK1zNmItRria207n7z5lgnKYl1XJF+l/lt6n1C5up8SagtGWOYORkfEjAYHFGJT5c
         TVEd7m+SR1RVa5Ahi+RQtgAfMkD4KB5m99Loxa1gf1YBl6lzS2dcVoRnZ1WlyjixQMje
         /R+NX0+pMOG4PutU+RGyjcm/UVKL4HgboMhheNll4rAYnK7cNojVDfUbf+IFSkLlLZUi
         R93ncuum/3UXzwDusdbr1ss7cz3LC6GWKspDNqyhtnX+u52Nv2MLvBPA7orzOoc/iFfz
         MbzerrylfuLQdhM91O3+dk7c5J7d+jRpC8rBCc1g/AX3oWN/8aSMr8YejfMu78FxMCl3
         iIWw==
X-Gm-Message-State: AOJu0Yz6kBlGhiWrTOjgWylN6Yc0fPIMO6KVwdK/8c44EuISsUFV1wOn
	FjAc96W2H3whz2k1/MIdSKf9fGU8ihwlPgg6qHQHBGf2VVNZmpmhtI698YYYVHpYPl5QJyo4Azw
	Jez9mWfQyvSJpsUh6gFeP8g==
X-Google-Smtp-Source: AGHT+IFsYzxWE1q+iyfd/CPcAE+BH9Qt6DCpr8RRj96mk+HtmlAuCb4ka3fjLLxAs1Crrs+qBq6aGz3zEY320EBD
X-Received: from wmbdn6.prod.google.com ([2002:a05:600c:6546:b0:46e:6605:3ac2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83ca:b0:45d:5c71:769d with SMTP id 5b1f17b1804b1-46e70c5cef4mr26594895e9.8.1759498754928;
 Fri, 03 Oct 2025 06:39:14 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:16 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-20-vdonnefort@google.com>
Subject: [PATCH v7 19/28] KVM: arm64: Support unaligned fixmap in the pKVM hyp
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
2.51.0.618.g983fd99d29-goog

