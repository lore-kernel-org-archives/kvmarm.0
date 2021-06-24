Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB57C49EA7
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:04:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F084F6140A
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:04:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F084F6140A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BD124B1A7;
	Thu, 24 Jun 2021 10:04:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8YaRw0V0KI+m; Thu, 24 Jun 2021 10:04:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD5324B1BA;
	Thu, 24 Jun 2021 10:03:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8851B4B195
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 08:58:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ukTUqt6v45No for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 08:58:01 -0400 (EDT)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 866374B178
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 08:58:01 -0400 (EDT)
Received: by mail-pf1-f175.google.com with SMTP id c8so5103793pfp.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 05:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:subject:to:cc:references:in-reply-to:mime-version
 :message-id:content-transfer-encoding;
 bh=uZuciq1P1LLIv86omk3p15CWzxu9H3VjtHemSC+vWOI=;
 b=rznw7O6D2Zt35p7Og+3iCwDgw2dkNPfwzD7rlUMP0y2Ej6O0tM+y3kSEcf8SWyT54d
 ublbOGuxe9Umj5fFSx3kLcve+5qwIiX31Bd1k9qJoijVaEMTrXxDg0VCRopT0Otp624H
 vQfbCt9QT5NQGNwfAmJ+KqkgxcPuOAOPjB6i02zSgoYEerKJgc/pbPT1wHARr0++dvZS
 Cel9tp2O0yGrWOTbrGUMXfBkZ8Eb/NzV2+WsHAOwG6gVAXQkKI9dWxURNSfgfHu0j01+
 sMqgBmAGdH9hfo97BHqdnz3MvquYkt7SnDT6LlXF4LTAyCM7dcMF+YevSRJYr4EeGBsv
 ThKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
 :mime-version:message-id:content-transfer-encoding;
 bh=uZuciq1P1LLIv86omk3p15CWzxu9H3VjtHemSC+vWOI=;
 b=nJwenFudGP6lUa8maIP7WbxF8KOeeSPML/cQBD/rbBISSGDXiGdVWKrQ25UN04JjVs
 VlXj4d/oPR0ELqJ/zuLnjDczJR06xGWSTuctGQLhdOU7Ue/hfHZXpaWz9o8G14tmWVPV
 Ydd+0nfgmHrKYuDC+1VVbG7fJ6yw3V9BdPIcrfsTZRvgWI4zk9q3d/HNcbSHJX7PPLw7
 8CN85Hhj9Fz4ghUOfIhp1i6neWnmh8DuFErT7UwRkGY2GGR/SnSG5+5zoF6FNqChPJq/
 OQjwB/DHNZkE2lZjsS2JfN9EXdVzys9oS4KmZ/JgCpfaMjFXDJ95JWhT2le6cPOLPpfE
 QtTg==
X-Gm-Message-State: AOAM531Pv1GObIoK+pPREv/7sbmaIJ/6CgSimiXzZHAGHRnRdwc/ntf7
 9/5ZGT6rlpC7GIzaUy8HMI8=
X-Google-Smtp-Source: ABdhPJyRyvJn5C7VYeX4UgUoQTwK2Wl40+EfEX+5KjgwzBTc5sLi33BY4sgc5lVA8ilsgegR5j26Eg==
X-Received: by 2002:a63:530a:: with SMTP id h10mr4685438pgb.98.1624539480323; 
 Thu, 24 Jun 2021 05:58:00 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
 by smtp.gmail.com with ESMTPSA id h22sm2909006pfc.21.2021.06.24.05.57.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Jun 2021 05:58:00 -0700 (PDT)
Date: Thu, 24 Jun 2021 22:57:54 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64 MMU
To: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Huacai Chen
 <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>, Paul Mackerras
 <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>, David Stevens
 <stevensd@chromium.org>, Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang
 <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <1624530624.8jff1f4u11.astroid@bobo.none>
 <1624534759.nj0ylor2eh.astroid@bobo.none>
 <0d3a699a-15eb-9f1b-0735-79d14736f38c@redhat.com>
In-Reply-To: <0d3a699a-15eb-9f1b-0735-79d14736f38c@redhat.com>
MIME-Version: 1.0
Message-Id: <1624539354.6zggpdrdbw.astroid@bobo.none>
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

Excerpts from Paolo Bonzini's message of June 24, 2021 10:41 pm:
> On 24/06/21 13:42, Nicholas Piggin wrote:
>> Excerpts from Nicholas Piggin's message of June 24, 2021 8:34 pm:
>>> Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
>>>> KVM supports mapping VM_IO and VM_PFNMAP memory into the guest by using
>>>> follow_pte in gfn_to_pfn. However, the resolved pfns may not have
>>>> assoicated struct pages, so they should not be passed to pfn_to_page.
>>>> This series removes such calls from the x86 and arm64 secondary MMU. To
>>>> do this, this series modifies gfn_to_pfn to return a struct page in
>>>> addition to a pfn, if the hva was resolved by gup. This allows the
>>>> caller to call put_page only when necessated by gup.
>>>>
>>>> This series provides a helper function that unwraps the new return type
>>>> of gfn_to_pfn to provide behavior identical to the old behavior. As I
>>>> have no hardware to test powerpc/mips changes, the function is used
>>>> there for minimally invasive changes. Additionally, as gfn_to_page and
>>>> gfn_to_pfn_cache are not integrated with mmu notifier, they cannot be
>>>> easily changed over to only use pfns.
>>>>
>>>> This addresses CVE-2021-22543 on x86 and arm64.
>>>
>>> Does this fix the problem? (untested I don't have a POC setup at hand,
>>> but at least in concept)
>> 
>> This one actually compiles at least. Unfortunately I don't have much
>> time in the near future to test, and I only just found out about this
>> CVE a few hours ago.
> 
> And it also works (the reproducer gets an infinite stream of userspace 
> exits and especially does not crash).  We can still go for David's 
> solution later since MMU notifiers are able to deal with this pages, but 
> it's a very nice patch for stable kernels.

Oh nice, thanks for testing. How's this?

Thanks,
Nick

---

KVM: Fix page ref underflow for regions with valid but non-refcounted pages

It's possible to create a region which maps valid but non-refcounted
pages (e.g., tail pages of non-compound higher order allocations). These
host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
of APIs, which take a reference to the page, which takes it from 0 to 1.
When the reference is dropped, this will free the page incorrectly.

Fix this by only taking a reference on the page if it was non-zero,
which indicates it is participating in normal refcounting (and can be
released with put_page).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
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
