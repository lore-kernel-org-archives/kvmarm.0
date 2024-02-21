Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB663CF72
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 07:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500379; cv=none; b=rhKj0uLn3G1OSuaAfv5K/FvQftTeCdnlpbhKDh+zb8dlytUH1VV/ZoKoRvLDH0SQRt0sN17MOfoVRUizNG3TtioWMvelClUm1UhALhkf9Le7qcAkJgIZQn0eoZKG9gCAaTFRFlVO1R7oF41Kh0RV56Z3nea8OR2VjagevQC5MgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500379; c=relaxed/simple;
	bh=1ox+KlmFyzigfEM1ahAanGLox6PX2sF7DV2hmNrOSqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZbS0graqj9tUnDkuaH0Q7kZvivWS3iKhSgzUk0Jjxv2RO+ZI1rS2j0YPAuB+3hclncvU0kM/57+3YblS6TNUrqcB2CFrH11bC3aBKn79b9JDpc1TPXGa1xpSTsHrzwY4Nh3S/Zq9BKDeevAZjYMv6AmqfiaYCSHEf9v9fLL2Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=VPasyeN1; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VPasyeN1"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6e458a77be3so1293835a34.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 23:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708500377; x=1709105177; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wkUtPwrd2MxLHuSBqQ67neXeqjLzee+wPf1sR5jV+c0=;
        b=VPasyeN1THYAxRDnXkqvv4sOp3hrKmZAqovzckoLgqx7PF5KDSwgqct2nAiuEv733M
         paqrEYktyp6bddMxHarOM6WqOdhwioGPMBDRLsmGYYFmjnn3pE15Hu/9VoPC8Awt5liM
         kJvtp1m0MSvmfjin24E6i8cJKZVX+BZr8CaiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708500377; x=1709105177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wkUtPwrd2MxLHuSBqQ67neXeqjLzee+wPf1sR5jV+c0=;
        b=dx9oAE6aABPtxqf/rsnptPSImi3w/Y7Pid6+JFPBmBEb+8T52NvzgTRiWJe1qxBran
         lld9sXwsV3IaU2Vat/akyKIQkGPzg4AA7kjNhzSSXXwzhMrg8WvkUiyvre+NBtmuqXZG
         e253d8UIRLzEr+D1YWH8D/dMdBDCheMfPsqE4Vnth8kGVw/YwaGOWmTUQR8l29Hglyky
         Zoxa08ehphRLCxDuCBgXo6KdgF2wCRsFwT1RFR84lU5azT76mKVRca9jMNfaLBplGuHj
         9fUe1Ir2slj3p51LVccTErR2UudmKdk0fivvq/DSlZY4SoAnobwD/JMngtKIaL67sL8D
         W1Vw==
X-Forwarded-Encrypted: i=1; AJvYcCUYlE+oVubW90Nu8WTiyXSOffZLfLCMfNXjpOCx77GzKvqKC4QZOz1IeaHUpgoK7+9+rV5LHFNFwdu1a3+d5Iw6Z9FWOoxS
X-Gm-Message-State: AOJu0YzC+DbXb6eghkcDrvan92+VLiuYemq9zODIb39+kaYOwm0imrVI
	lVxjrtYZ+ZxGhxS1R03qUg/lgSm1VoxYMvDK7mkjNVujljDXh7oCrB6UWkpOMQ==
X-Google-Smtp-Source: AGHT+IHIRmw7KOf0S7zevk1ZVHq4HTPptYom7wxTZTyuRHTWKzNijZn/KQq93KqEbVhWnYt7rNUGVA==
X-Received: by 2002:a05:6830:10d3:b0:6e2:d888:6502 with SMTP id z19-20020a05683010d300b006e2d8886502mr21734446oto.11.1708500376915;
        Tue, 20 Feb 2024 23:26:16 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:b417:5d09:c226:a19c])
        by smtp.gmail.com with UTF8SMTPSA id d18-20020a63ed12000000b005dcbb699abfsm7827438pgi.34.2024.02.20.23.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 23:26:16 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v10 5/8] KVM: Migrate kvm_vcpu_map to __kvm_follow_pfn
Date: Wed, 21 Feb 2024 16:25:23 +0900
Message-ID: <20240221072528.2702048-6-stevensd@google.com>
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

From: David Stevens <stevensd@chromium.org>

Migrate kvm_vcpu_map to __kvm_follow_pfn. Track is_refcounted_page so
that kvm_vcpu_unmap know whether or not it needs to release the page.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 24 ++++++++++++++----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 88279649c00d..f72c79f159a2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -295,6 +295,7 @@ struct kvm_host_map {
 	void *hva;
 	kvm_pfn_t pfn;
 	kvm_pfn_t gfn;
+	bool is_refcounted_page;
 };
 
 /*
@@ -1265,7 +1266,6 @@ void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c10dc546c8d..e617fe5cac2e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3188,24 +3188,22 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
-{
-	if (dirty)
-		kvm_release_pfn_dirty(pfn);
-	else
-		kvm_release_pfn_clean(pfn);
-}
-
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
 	kvm_pfn_t pfn;
 	void *hva = NULL;
 	struct page *page = KVM_UNMAPPED_PAGE;
+	struct kvm_follow_pfn kfp = {
+		.slot = gfn_to_memslot(vcpu->kvm, gfn),
+		.gfn = gfn,
+		.flags = FOLL_GET | FOLL_WRITE,
+		.allow_non_refcounted_struct_page = true,
+	};
 
 	if (!map)
 		return -EINVAL;
 
-	pfn = gfn_to_pfn(vcpu->kvm, gfn);
+	pfn = kvm_follow_pfn(&kfp);
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
 
@@ -3225,6 +3223,7 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 	map->hva = hva;
 	map->pfn = pfn;
 	map->gfn = gfn;
+	map->is_refcounted_page = !!kfp.refcounted_page;
 
 	return 0;
 }
@@ -3248,7 +3247,12 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 	if (dirty)
 		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
 
-	kvm_release_pfn(map->pfn, dirty);
+	if (map->is_refcounted_page) {
+		if (dirty)
+			kvm_release_page_dirty(map->page);
+		else
+			kvm_release_page_clean(map->page);
+	}
 
 	map->hva = NULL;
 	map->page = NULL;
-- 
2.44.0.rc0.258.g7320e95886-goog

