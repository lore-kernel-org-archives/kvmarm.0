Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C593B790
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 07:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500361; cv=none; b=Kwmall9ZqA5RSIb2xrIHiw4DEQCO3uRMfgP6HzvM4Gv0KAjFm+x1Iw/SC0NoRp7jOntGJbeXBZzJcaAnaxTrvnuqWHz14ekC1s9ta9Ef88z7OhblPhDqcF9+VV3kh7VAmlxEKIWhdbSlzRqFPdXrhrCn7Ri1EMyHpa8BWStV8UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500361; c=relaxed/simple;
	bh=ts94nRAA8qijZ1+V+8RhVz7hYImR2xwd7IhA+JpQbfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Csy6SuQ2AC47VTafr2kvu266eDe8m9R0NkP8gW9dDXh4ROKzK4sZq/CnEhBbr+r+AnoV/Bydy04ZzgBkVyXacWYkTidfOZfL5xN0sVHYuKd/DpjTyV+BXnN62ELI5FIgoP+YvYul5RfxiKGizCoOrkjy+mjPE7vLGx71/wb5TfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=WE9ik2W3; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WE9ik2W3"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5a01ba2f815so20467eaf.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 23:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708500359; x=1709105159; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+hdGBpVbr7bFPAdmaXUhe5OHdgegQxKZy+RG2n/NC8=;
        b=WE9ik2W3YogmIRr1dPuHi8Pnxvn8sja3sAjIJKK1lNHCoHzDmVpyo+SrOpnqDdk0BC
         BO5mELOCQWLnENKYo5GEdJ1CxOrMdKKb07YZhyaCJZZq0v16CxSi7k0ESBqZ/7U/A3lU
         69juoue9kgVOw77DotDUY9qNqZ4Hgnw9beBXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708500359; x=1709105159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+hdGBpVbr7bFPAdmaXUhe5OHdgegQxKZy+RG2n/NC8=;
        b=BRzYvxrBh1OgBVbwbYZgL8x1+RD6DZ4dex3xfubtzuUEr1YRNCQ/vLukpe7Az1AJ8B
         jkGnakEqFXyYMi/dC3OQdrrfeCM7/p71uGuIC9KX0d3tTMP8uM+QBnhYyXGHDRi/6KPE
         oxteLIi9VovR46SiAmpPamxQ1muHKDzTy7LZTbe0MKXPEYwl0/XuCqPJBuGNec0fVSYA
         PsHfwSFY/tOfSiHeZt/BJ+eBibH//OVnOLktCQpiI6P6T2ulCISGVdLKI9Jw+Q+owEUv
         cKooag4dPg0hUhclduiFKJTUhf9aZmiL4Jb8HjNBGPYUatwBwD37m8wME9ovx9lNBKB1
         iRhw==
X-Forwarded-Encrypted: i=1; AJvYcCV8H7lo0rIiG2DLI0su9YNo2TSHz2DB4GfeJ6j4JORv1iVJklEEU+d85z409QA5YCKR9FoyPXAGl/KozSlfxZo6lkdUVV5o
X-Gm-Message-State: AOJu0YzCSR4VLoS2ojmTbKsddw8TB0ytFkJBJcB8ugB+XiY+11VGmF0m
	5PEBVQ4yQz/FVrfQfmcebee/1VGSvecXoRc3q4A3hYwZ+gT5jJmznYiC5WUr3w==
X-Google-Smtp-Source: AGHT+IE2G1nq+fsRegEtXbcZKijUFBnow+nd04+2OKpMuJUnEvCAkTRVdFsn5NwLBnQPzSaj9SDRPg==
X-Received: by 2002:a05:6358:caa:b0:178:c51c:7af5 with SMTP id o42-20020a0563580caa00b00178c51c7af5mr20488158rwj.32.1708500359251;
        Tue, 20 Feb 2024 23:25:59 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:b417:5d09:c226:a19c])
        by smtp.gmail.com with UTF8SMTPSA id u4-20020a62d444000000b006e2b23ea858sm8097492pfl.195.2024.02.20.23.25.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 23:25:58 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v10 1/8] KVM: Assert that a page's refcount is elevated when marking accessed/dirty
Date: Wed, 21 Feb 2024 16:25:19 +0900
Message-ID: <20240221072528.2702048-2-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240221072528.2702048-1-stevensd@google.com>
References: <20240221072528.2702048-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Assert that a page's refcount is elevated, i.e. that _something_ holds a
reference to the page, when KVM marks a page as accessed and/or dirty.
KVM typically doesn't hold a reference to pages that are mapped into the
guest, e.g. to allow page migration, compaction, swap, etc., and instead
relies on mmu_notifiers to react to changes in the primary MMU.

Incorrect handling of mmu_notifier events (or similar mechanisms) can
result in KVM keeping a mapping beyond the lifetime of the backing page,
i.e. can (and often does) result in use-after-free.  Yelling if KVM marks
a freed page as accessed/dirty doesn't prevent badness as KVM usually
only does A/D updates when unmapping memory from the guest, i.e. the
assertion fires well after an underlying bug has occurred, but yelling
does help detect, triage, and debug use-after-free bugs.

Note, the assertion must use page_count(), NOT page_ref_count()!  For
hugepages, the returned struct page may be a tailpage and thus not have
its own refcount.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 10bfc88a69f7..c5e4bf7c48f9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3204,6 +3204,19 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
 static bool kvm_is_ad_tracked_page(struct page *page)
 {
+	/*
+	 * Assert that KVM isn't attempting to mark a freed page as Accessed or
+	 * Dirty, i.e. that KVM's MMU doesn't have a use-after-free bug.  KVM
+	 * (typically) doesn't pin pages that are mapped in KVM's MMU, and
+	 * instead relies on mmu_notifiers to know when a mapping needs to be
+	 * zapped/invalidated.  Unmapping from KVM's MMU must happen _before_
+	 * KVM returns from its mmu_notifier, i.e. the page should have an
+	 * elevated refcount at this point even though KVM doesn't hold a
+	 * reference of its own.
+	 */
+	if (WARN_ON_ONCE(!page_count(page)))
+		return false;
+
 	/*
 	 * Per page-flags.h, pages tagged PG_reserved "should in general not be
 	 * touched (e.g. set dirty) except by its owner".
-- 
2.44.0.rc0.258.g7320e95886-goog

