Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C637838385
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 02:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175498; cv=none; b=YK1Ig4nQDkuEnYUcMGFTm3Q6UQI/2wTikqKBf2PFk7bR0xoeH0RFK5FtBs1T6KmN5+yTDojygAxRHdTOj4bNEVYNfIkJQHLFyQMxuIfonm836OtU1tpk/B0suIclg8sXFO+kn4eGP16ijMnAXyKcMVa2BxjORmGThwCoZKnCv8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175498; c=relaxed/simple;
	bh=vBxpG3Dz9ZyzQmLOVkEwkMADJ6mdtbcyVLq+Z9tdtMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfrj1RQWu0fi7Kb9hkHr9gpIxatN6zPUkEk0cKrYav09l44h0ypd9KB73yfSJ/8nYNDZRLRhPSEVB/q0/UpD5hu2O8lXuPMR1h2IfPfLhTxr0CDjsa1dfnoSMCyTftGcPWvK0ZXlt3uoChnPxlqMR70ce59cCswNbPlBuq9bD4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=EBvZl5HN; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EBvZl5HN"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6da9c834646so313361b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 18:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175496; x=1709780296; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DqzBf0lbp1ARHQDBEkHQmEKBBGeWS/SzkM01JYF1z0o=;
        b=EBvZl5HNAKRZV+r9yEYhk3jduVH4ZVItwnx+F31yBuDYkDfCOhsumYWfhpdDPSKFXT
         rNguTmvW14SjRF6pLRiBui2qvzFv0hrzEGLdSzppNIk6CrK6nlwWYJ+WlGnZISjQ6LhR
         kkkgBHrUDnsmVCDUJM7cdbVDHRgXGqpBN/E7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175496; x=1709780296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DqzBf0lbp1ARHQDBEkHQmEKBBGeWS/SzkM01JYF1z0o=;
        b=P+hHhogr76Gs5awiO4qCa7nRCbLt+4umMe//FMZaDY569R3vXrImL61I2PkF9yoIj7
         VRqwL5g2lBXICi8VWSnjC5vsCorvZFO9lzhJErJz8ozxghrINRVUIv5Rq8DDW+c9ANUY
         lWIh+XZ2vm/n7xP9rO3dfxCxaBTBA/fEQonWL9U5oYw8l2ZTOaZboDXkRhynPOyKH/5s
         RMGqsZoJRN9KPQnwaLiVuZxYL0Vcso+A7YoXjeZHI4ZVwp4qOvZkA+uB1NzAiEfkorcI
         vrztXjq737/mGAeig2GReGCtLjQYYxCgBp93xHLyHEbcr2FfVKEBoozAyOsQXfgB4YQU
         eGAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJ+zf23ZhjfL5yNmSXuRt0IgCdf3tzGHdHr1vH30wje3J2AJblXuQWYLPSi5UHSqBpub+F/E6tnuK2g6cc2csOMLcYAwC6
X-Gm-Message-State: AOJu0YzZWctEFs5jPwQc4TauJEhqjnhZ1ZCKNwu0WlHn7oCNABIuqcqb
	ZzxMp9n6z7mNr99kTgIUpV7w64HhhNkgZD0qr1VXZlglMmHV/9DyRbG8RrmQJRXCqBICTkmU8sU
	=
X-Google-Smtp-Source: AGHT+IEaA3Yk5H5sm7OqlYuWJldrbQt1FyGNtf9CVSLw7qF8ebCkHsyFpFiViHyqoeQ9pbU7fRjgjg==
X-Received: by 2002:a05:6a20:c887:b0:1a0:f713:8317 with SMTP id hb7-20020a056a20c88700b001a0f7138317mr1259104pzb.61.1709175496202;
        Wed, 28 Feb 2024 18:58:16 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id a1-20020a17090aa50100b002997f192d4esm2055537pjq.1.2024.02.28.18.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:15 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v11 2/8] KVM: Relax BUG_ON argument validation
Date: Thu, 29 Feb 2024 11:57:53 +0900
Message-ID: <20240229025759.1187910-3-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
In-Reply-To: <20240229025759.1187910-1-stevensd@google.com>
References: <20240229025759.1187910-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

hva_to_pfn() includes a check that KVM isn't trying to do an async page
fault in a situation where it can't sleep. Downgrade this check from a
BUG_ON() to a WARN_ON_ONCE(), since DoS'ing the guest (at worst) is
better than bringing down the host.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Stevens <stevensd@chromium.org>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c5e4bf7c48f9..6f37d56fb2fc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2979,7 +2979,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 	int npages, r;
 
 	/* we can do it either atomically or asynchronously, not both */
-	BUG_ON(atomic && async);
+	WARN_ON_ONCE(atomic && async);
 
 	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
 		return pfn;
-- 
2.44.0.rc1.240.g4c46232300-goog

