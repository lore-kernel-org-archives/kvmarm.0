Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4253DBB3
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 02:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175512; cv=none; b=b3MjGik4boUoSRyn6U6JvaDZj4oFjfvzziWsaMUz93TM1gOsrv4sfUtAsEQZopvmmSvZgdZIC/OxYll7laaXpY36DARZ0QnXqAnwybvaVR7/a2Ftw6uDGpn6L3dcnKx3Tc0+qEB5jTPddnJNLZ+R026U9zWACRWq77QRXV3hxRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175512; c=relaxed/simple;
	bh=ntmqS432o2IecDkbveS88A7jvkU9H2eMDxulzMNm4uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SR2RoSp9JnWYjLbL5ySciOUrm0RvGPmk3ZqvozJFHp9tNFKA0xPx8T/XoTm2jL3o+cC95o6BmERbSyu2nwFQ6OY2BCQ43xX4zXiPiYgosMVblF30Sqrdk3fd+qfUP/xX2SQIm5+h9of164ViP3DkSKF5NXCw44je+soYtgwLkO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=d3H+1ngX; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="d3H+1ngX"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e581ba25e1so334854b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 18:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175510; x=1709780310; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ni2jT8j4ual03uOxDJftxXgB5iCIPPNSKtQ7Mr+vnE0=;
        b=d3H+1ngX0jJLkU9hOb3rGZnoA+unlnrAt3yFh+JB5ASIdYHUv22JU9K/Uj8G/p5YdU
         U3eFPG6uIVWotxe2/SQyr8uBE9cE/em6blL0+FY7j4PpDA2nW4DWgPQmX+IgmpDM1QS4
         oMMll3ZiHEbrutzpDCC0DJvaO4OMMfNtqqyII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175510; x=1709780310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ni2jT8j4ual03uOxDJftxXgB5iCIPPNSKtQ7Mr+vnE0=;
        b=E6JUDfyZWOdfis8FCp/AoPfhVJdb/NZbY2WcTMZyE2ZZZN357ka2tRPV/t3s/yRRdt
         EllPDWquyf1jKAAXDmtdz+AJ962tg0kVcJl5zrOj+M6Nleuouo6r7IEqkbTMG0dl31i0
         WbxD4/NfHOFoejQWhN+lBDLJnon6gFqFKRDqbm7rKu12ID92SyH92Jg2a7x/Mm27nV5D
         Vcr2uHJ5TwPKqV8j8V5sqEGoRW27O3Ykj6ceFdGhCW82ozMJQ8m72WXIozcw1+H7w4Xy
         yNqhusTYyvHPPR3g7eEVTlI/XKkto1w43ymlfUYZka+cavC7JOYyURQt/bbjNGfj3lEy
         30Rg==
X-Forwarded-Encrypted: i=1; AJvYcCWHGoJrYIDbpY2NOktsYuttISjpzXbVrx9uYeI50RHl0XLxVJCstia6HGKXeLz6JE+y0jSraBArdxam0+noVFEuUOB1Y0M9
X-Gm-Message-State: AOJu0YxqhPst/23+kds8cax8hbm6vy7RJ/sXUwUY1jGpXXYDjBZ16sfY
	4Mo6TG9mUBhAbT1bs4B7ViNoIJ5NAml5yqTlzEPWPIyD/aAFkCC2sugnPHvskQ==
X-Google-Smtp-Source: AGHT+IFrTrtIz8ZueShqadVtdqzR++6dqKD8QrlfV9UFyrfW9Ry/CvODvFWbe40fOMGg2kbfHMju+Q==
X-Received: by 2002:a05:6a00:cc4:b0:6e5:37cb:64c4 with SMTP id b4-20020a056a000cc400b006e537cb64c4mr952284pfv.9.1709175509796;
        Wed, 28 Feb 2024 18:58:29 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id x65-20020a626344000000b006da96503d9fsm167784pfb.109.2024.02.28.18.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:29 -0800 (PST)
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
Subject: [PATCH v11 5/8] KVM: Migrate kvm_vcpu_map() to kvm_follow_pfn()
Date: Thu, 29 Feb 2024 11:57:56 +0900
Message-ID: <20240229025759.1187910-6-stevensd@google.com>
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

Migrate kvm_vcpu_map() to kvm_follow_pfn(). Track is_refcounted_page so
that kvm_vcpu_unmap() know whether or not it needs to release the page.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 24 ++++++++++++++----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 66516088bb0a..59dc9fbafc08 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -295,6 +295,7 @@ struct kvm_host_map {
 	void *hva;
 	kvm_pfn_t pfn;
 	kvm_pfn_t gfn;
+	bool is_refcounted_page;
 };
 
 /*
@@ -1270,7 +1271,6 @@ void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 984bcf8511e7..17bf9fd6774e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3184,24 +3184,22 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
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
 
@@ -3221,6 +3219,7 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 	map->hva = hva;
 	map->pfn = pfn;
 	map->gfn = gfn;
+	map->is_refcounted_page = !!kfp.refcounted_page;
 
 	return 0;
 }
@@ -3244,7 +3243,12 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
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
2.44.0.rc1.240.g4c46232300-goog

