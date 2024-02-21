Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640963D3B8
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 07:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500384; cv=none; b=Xs/za26rnRkqn5RVmjDIyMclpnLZPMRptqvHsnc2rJViVB1ZUi900MWqHN02pEMZJwjjo88UY7iQE8m5rRf+fZkWx8hVJp9WdM6swygmjqJ7KBZXYB7CN+isrKnY7FUY1oXJo9jnYzDzqBcVY8oky3+ozW4dFqZ7zf1dzDVlqfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500384; c=relaxed/simple;
	bh=vFAefepjz3E0t+04lpw2yPf+Nx3onOaZVt72QR755hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmFeFVFL76F66ftSKhbzREDb9/nEUkYtyrpSHzv6bh4NJHYL61VDS1DPLMdadkPBHZl2Ff1xhLHwjaMSLPgkpB/SNwiwdUvPsC+0hJy+BEjHrWbNkik2npwT/1ybdEFPa3MRaCtbnChMqPhPvHL7AwZYMa2XiRV9Z5Blrtq2bBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Cz/RVeZg; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Cz/RVeZg"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d93edfa76dso39473205ad.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 23:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708500381; x=1709105181; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWEaXNkEutzzfeWk4tkEh/aV9qyvddav9W73rpwAgUc=;
        b=Cz/RVeZgBrqaWbYFBCLvgELNa/LF0ofX5TsI6skwTDIwWZpHPF9Z7rKOEBiWpoZh0m
         PqpDX/81pJi3Y2qJ8dDzm/FEL7+s2hqqIGBjiTg5ltNTsF72iqNWO3qvITqE69cvzukw
         2qMCldczI2TvgcfR7HoVtK/BVE1FS2FVvzNGs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708500381; x=1709105181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SWEaXNkEutzzfeWk4tkEh/aV9qyvddav9W73rpwAgUc=;
        b=YeGNWEvcS+OPtDfoqiS76dgXJgiom9s+DOpgC+ftm8qeS9IXCH86K51cLcTwuJkkG1
         8+kog1T9ztbtspbvXDTPGU1/uBlZWNWcOQhCNl5mG7K54rk52D/V39IkcEa8br/3mPXd
         m/dYUNNv2pv4RmJ8wrmnbN6mbAqOx2WqQg0O9Z0bQcA6XK7a7zogxftYegnp5wu5szMD
         rxbscmVSWL+FukBQJBFO1SC7GyiiMOVF/RW/bSiYerIep0GWdcY1p3DBZwukQY5FU6rb
         QJ/rYUlhSp8v65hetEDj6fIXERdt32cOzqVKnbwrlCt7bcBLkuZvH/cYQrugAc5YDqTL
         vQWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVz/h6qMKAAoOKfV6boAuX0oZVrN1kCgaoi2aP5h+1k/xOV+pT8r4miq9DQ4WRtFeteKkLowKhILVoJTdINgFI9c0ZY8+F+
X-Gm-Message-State: AOJu0YwqNSXK+JX2qBQSqNnvPZzaU1rON0XzXoT1GzlzRbmD7Y8Q9Dex
	0l/ZoAs8ZFOpRDkwUwSOkkYAAFz3gDBFkCa/nPoV0IGrBAHImRNNDooFndrHWA==
X-Google-Smtp-Source: AGHT+IHTaM/Rw7dtF9Vc7sCfD1uYbTKNFQjI2s6I8Jpo/gJ3zxDAIPGiSzfjjSJYmob/3WCYbNzzWg==
X-Received: by 2002:a17:902:6841:b0:1da:1c72:2ca7 with SMTP id f1-20020a170902684100b001da1c722ca7mr17564758pln.29.1708500380788;
        Tue, 20 Feb 2024 23:26:20 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:b417:5d09:c226:a19c])
        by smtp.gmail.com with UTF8SMTPSA id s3-20020a170902c64300b001d93ba1120dsm7387923pls.200.2024.02.20.23.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 23:26:20 -0800 (PST)
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
Subject: [PATCH v10 5/8] KVM: Migrate kvm_vcpu_map() to kvm_follow_pfn()
Date: Wed, 21 Feb 2024 16:25:24 +0900
Message-ID: <20240221072528.2702048-7-stevensd@google.com>
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

Migrate kvm_vcpu_map() to kvm_follow_pfn(). Track is_refcounted_page so
that kvm_vcpu_unmap() know whether or not it needs to release the page.

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

