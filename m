Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F411C49EA6
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:04:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 379C261404
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:04:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 379C261404
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D664D4B152;
	Thu, 24 Jun 2021 10:04:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QcgpXCm2UbYZ; Thu, 24 Jun 2021 10:04:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA1994B1B5;
	Thu, 24 Jun 2021 10:03:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCEED4B141
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 07:42:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e914T4a8P7Lh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 07:42:51 -0400 (EDT)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7168D4B134
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 07:42:51 -0400 (EDT)
Received: by mail-pf1-f172.google.com with SMTP id a127so4904326pfa.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 04:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:subject:to:cc:references:in-reply-to:mime-version
 :message-id:content-transfer-encoding;
 bh=UhPwCKz4xBakQQigMlpP/gU41+hzbpM8YRJNgrKv6O4=;
 b=t31VnJiTsxItJNeq7rCSt7OrhubYQjPInGwxS6i1vZcLD09YhtO7gbcC6yO0KhAuXD
 RMNK1+v4V64bLEWRl+uFQJxvO1OFOEUDB1cdjW7SCwjkzIAwx6kCwo+BFaUOwSBFxqwm
 KF14xx23G+PzVLnKBSxDToMDnayKV5w+2zzBDlSLDFjw04AEwsQJB5ALW2r4/++L3OKb
 Y99mu3t2yWWYdgnN6Jbc1YzGJEOeoaeDo24+jGjvAiXYbKelivBMh2/9F1XYtnHZ8Kb0
 gAIR7RWubhD3jnU73jhUW2+khX+sz10qzFL5QCRSUp9UUKI+z+pRuE/7R3jTuKwE1dBy
 waHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
 :mime-version:message-id:content-transfer-encoding;
 bh=UhPwCKz4xBakQQigMlpP/gU41+hzbpM8YRJNgrKv6O4=;
 b=UoLBstC7wNI5yfFcmRL0ldHY94kutEv2Zd3kRNqVSfO6OnF+7W4Nn5ULEVdHdZ6Xxg
 ODzedeSOE51hmurYARjnsg/mL1ZqiuLmEIll+W1Ji2u50CDur4HstSWoPsrkS1paWPS+
 sLAJq0pRZ7+EBxVMWjHmjgRbdco6vxyDp2iQku3P6LybUr4k88y1rTdoZ6W1oz8d0x62
 bX7KN6JZnC+N9akgZnetdXjMugCt42VcjYvsdNjNxiZUa5QXSzjNQ8KAQWu3CcwXqh5R
 l7bf5Rv3mWtUQ89V1QNOsZXSAhrMFhH1m4+yk2I3JDHl6FPThnq+NNA9UZzCg4UPVTE3
 kXMg==
X-Gm-Message-State: AOAM531+S1uXItcWmLooLZ3atp222/dz4CsXgGuFcUP/5meNjzykLebE
 P0gK1L63oISuzxnOX8ytfNw=
X-Google-Smtp-Source: ABdhPJyUktZmu2l7dyBNUjkdVcrHb1vguGlN8KJEIqyrGuksmppmmrU30UVZa2RBb657vluXrYRKpA==
X-Received: by 2002:a63:2503:: with SMTP id l3mr4358509pgl.237.1624534970415; 
 Thu, 24 Jun 2021 04:42:50 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
 by smtp.gmail.com with ESMTPSA id z18sm2539194pfe.214.2021.06.24.04.42.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Jun 2021 04:42:50 -0700 (PDT)
Date: Thu, 24 Jun 2021 21:42:44 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64 MMU
To: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Huacai Chen
 <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>, Paul Mackerras
 <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>, David Stevens
 <stevensd@chromium.org>, Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang
 <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <1624530624.8jff1f4u11.astroid@bobo.none>
In-Reply-To: <1624530624.8jff1f4u11.astroid@bobo.none>
MIME-Version: 1.0
Message-Id: <1624534759.nj0ylor2eh.astroid@bobo.none>
X-Mailman-Approved-At: Thu, 24 Jun 2021 10:03:53 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Stevens <stevensd@google.com>, intel-gfx@lists.freedesktop.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, kvmarm@lists.cs.columbia.edu,
 Will Deacon <will@kernel.org>, kvm-ppc@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-mips@vger.kernel.org,
 intel-gvt-dev@lists.freedesktop.org, Joerg Roedel <joro@8bytes.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Excerpts from Nicholas Piggin's message of June 24, 2021 8:34 pm:
> Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
>> KVM supports mapping VM_IO and VM_PFNMAP memory into the guest by using
>> follow_pte in gfn_to_pfn. However, the resolved pfns may not have
>> assoicated struct pages, so they should not be passed to pfn_to_page.
>> This series removes such calls from the x86 and arm64 secondary MMU. To
>> do this, this series modifies gfn_to_pfn to return a struct page in
>> addition to a pfn, if the hva was resolved by gup. This allows the
>> caller to call put_page only when necessated by gup.
>> 
>> This series provides a helper function that unwraps the new return type
>> of gfn_to_pfn to provide behavior identical to the old behavior. As I
>> have no hardware to test powerpc/mips changes, the function is used
>> there for minimally invasive changes. Additionally, as gfn_to_page and
>> gfn_to_pfn_cache are not integrated with mmu notifier, they cannot be
>> easily changed over to only use pfns.
>> 
>> This addresses CVE-2021-22543 on x86 and arm64.
> 
> Does this fix the problem? (untested I don't have a POC setup at hand,
> but at least in concept)

This one actually compiles at least. Unfortunately I don't have much 
time in the near future to test, and I only just found out about this
CVE a few hours ago.

---


It's possible to create a region which maps valid but non-refcounted
pages (e.g., tail pages of non-compound higher order allocations). These
host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
of APIs, which take a reference to the page, which takes it from 0 to 1.
When the reference is dropped, this will free the page incorrectly.

Fix this by only taking a reference on the page if it was non-zero,
which indicates it is participating in normal refcounting (and can be
released with put_page).

---
 virt/kvm/kvm_main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6a6bc7af0e28..46fb042837d2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2055,6 +2055,13 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 	return true;
 }
 
+static int kvm_try_get_pfn(kvm_pfn_t pfn)
+{
+	if (kvm_is_reserved_pfn(pfn))
+		return 1;
+	return get_page_unless_zero(pfn_to_page(pfn));
+}
+
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       unsigned long addr, bool *async,
 			       bool write_fault, bool *writable,
@@ -2104,13 +2111,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * Whoever called remap_pfn_range is also going to call e.g.
 	 * unmap_mapping_range before the underlying pages are freed,
 	 * causing a call to our MMU notifier.
+	 *
+	 * Certain IO or PFNMAP mappings can be backed with valid
+	 * struct pages, but be allocated without refcounting e.g.,
+	 * tail pages of non-compound higher order allocations, which
+	 * would then underflow the refcount when the caller does the
+	 * required put_page. Don't allow those pages here.
 	 */ 
-	kvm_get_pfn(pfn);
+	if (!kvm_try_get_pfn(pfn))
+		r = -EFAULT;
 
 out:
 	pte_unmap_unlock(ptep, ptl);
 	*p_pfn = pfn;
-	return 0;
+
+	return r;
 }
 
 /*
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
