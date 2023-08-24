Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944625671
	for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 08:04:54 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1bc3d94d40fso50513285ad.3
        for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 01:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692864294; x=1693469094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iV3LzITJwv11zEQaTKqycZRD5Ms/f2qTTnP9Z8Na2Dc=;
        b=hTSVm1KpsiVl32iXwZgDBmPH+embp/HaAL1ZLu2uR7cF3H6hTl34Q9JKEmO30iZR28
         vaejshZyHwxBtl2bVKV19vbjkB/8FGyJFYPLkrisnF9qRlAILfqlwg9vcKyHYNMNE+7T
         4vD6MFlPiDmwbS1FIANXvqkYrzJusW2+2tYbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692864294; x=1693469094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iV3LzITJwv11zEQaTKqycZRD5Ms/f2qTTnP9Z8Na2Dc=;
        b=lfCvjyMjtoNaFTxE74TCse0KdfYcLyd6nRosOLygxsHTzt9yn3KSfNTqLRMQC5weOW
         xrcr+QmDVJmw+KxZL0iS5Ks7FKgqfEHLHqEShKo8FisiS0VcBWEoRCFi/eebFaSHsGwC
         GPj1v1seE9Ys0+0vVppqZNSdVsqm8VeehygQ5PvgHOqx/3yB9UQQ1QacWblMJQ2IeT3q
         hEpdcHDyvnUjv0Y8DO6RP1x3Bue0LwcJJmgx1H9jXa5qyk1Ov8vtaKV3hQCyl1NXq0yy
         AU9/TbuSW2Xig1z+LANQHJE5OAgPxyF3Dm14zF0j4uMIeSXFpXAkgVPZRyneiP94kUKE
         D0ow==
X-Gm-Message-State: AOJu0YyE4gaO7r7HjPqXSZfgcUI9d5O1F5AmgHp0RjdgyaJjw6sMMvt5
	YoIdQqkLv7H/afXZBHe6qj3XwA==
X-Google-Smtp-Source: AGHT+IHagCrEiCSTUeawSO2RaSCgtKrRoyrdFRSlC2mm085LYzwbHRTmVonAanytbmYPqEcAnMXU/A==
X-Received: by 2002:a17:902:ab4f:b0:1be:f53c:7d1d with SMTP id ij15-20020a170902ab4f00b001bef53c7d1dmr14752623plb.23.1692864293682;
        Thu, 24 Aug 2023 01:04:53 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:515:8b2a:90c3:b79e])
        by smtp.gmail.com with UTF8SMTPSA id g12-20020a1709026b4c00b001bdb167f6ebsm12152992plt.94.2023.08.24.01.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 01:04:53 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [PATCH v8 1/8] KVM: Assert that a page's refcount is elevated when marking accessed/dirty
Date: Thu, 24 Aug 2023 17:04:01 +0900
Message-ID: <20230824080408.2933205-2-stevensd@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230824080408.2933205-1-stevensd@google.com>
References: <20230824080408.2933205-1-stevensd@google.com>
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
index 5bbb5612b207..1e4586aaa6cb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2888,6 +2888,19 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
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
2.42.0.rc1.204.g551eb34607-goog

