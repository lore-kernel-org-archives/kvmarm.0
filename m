Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5467917C8
	for <kvmarm@lists.linux.dev>; Mon, 11 Sep 2023 02:16:51 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1c0c6d4d650so32470145ad.0
        for <kvmarm@lists.linux.dev>; Sun, 10 Sep 2023 19:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694398610; x=1695003410; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xD7OvstxKA2joN48f33NVGVEMdOf8iSPumL3dY1BcYQ=;
        b=kwWLt/ru4U9kGEzZuzjRwjtA3whuHquQuf5IzwclLOhOsjy4L+jaIe3YkG1wkG8D7i
         qcEfaelRp2eJgY2tsLzEHbm9pKSC+hGyO8+1Vvpweg+YAvKPrJtODgnm/Gu+jEIVNPCc
         QMwZh3GN/mG7RjZPkdZDk8AiHGont6zaUzKVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694398610; x=1695003410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xD7OvstxKA2joN48f33NVGVEMdOf8iSPumL3dY1BcYQ=;
        b=lnFgG6GUtfLaq8ShCayWLvifydWfdb3tUMBCq+kUj0ZJoYrXG8eXHT+BKke3qN87a6
         MUdNtVYQXuBt+qW2uqPLCc8cuQBok++507R+NdhFmxlk7gOYvMpzmsLe454eMKiAbXdn
         qdd9n8d14z9kiEot42NJnflFi84rL2/3w5iDdL9LlYz3PDUIQijJZprQfhp9L2Q1QFsz
         mhSQyh+1yhNNhIV/xEaQBXqIwRCs2vtTenXzMHqHVeexHYh9vIOqdfQw5F4A449QXW5T
         vRjpvouQYsd0BlJEBaNMAaUyScg85Ngq7Qun3rZouNsEz4yozJWlkleMak+z4buZy8Cw
         LuAg==
X-Gm-Message-State: AOJu0YwV0JlUekR5r2lqQ2AOpA8556aY4NH8np8FzdnnHo/TqDm+YbUg
	61NHRt5fa5Doik1bOnBR4lw8vg==
X-Google-Smtp-Source: AGHT+IFy++BuFNruJ3+F43z5nLA2htPWCJELp/lRQsizzfJXm9VzGe4L5Ti1kzq6zJIZvRm4jK0CGg==
X-Received: by 2002:a17:903:228d:b0:1c3:9aaf:97be with SMTP id b13-20020a170903228d00b001c39aaf97bemr5233193plh.56.1694398610653;
        Sun, 10 Sep 2023 19:16:50 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:282a:59c8:cc3a:2d6])
        by smtp.gmail.com with UTF8SMTPSA id x12-20020a1709028ecc00b001b8a897cd26sm5162528plo.195.2023.09.10.19.16.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Sep 2023 19:16:50 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v9 1/6] KVM: Assert that a page's refcount is elevated when marking accessed/dirty
Date: Mon, 11 Sep 2023 11:16:31 +0900
Message-ID: <20230911021637.1941096-2-stevensd@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230911021637.1941096-1-stevensd@google.com>
References: <20230911021637.1941096-1-stevensd@google.com>
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
index d63cf1c4f5a7..ee6090ecb1fe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2914,6 +2914,19 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
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
2.42.0.283.g2d96d420d3-goog

