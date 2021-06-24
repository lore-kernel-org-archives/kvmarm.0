Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73841C49EAB
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:03:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 265E5613F6
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:03:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 265E5613F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0B54B183;
	Thu, 24 Jun 2021 10:03:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TBkqgmGMIipY; Thu, 24 Jun 2021 10:03:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EBA04B15A;
	Thu, 24 Jun 2021 10:03:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3DD64B176
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 06:34:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j8ElyTFSHj-j for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 06:34:32 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF4724B183
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 06:34:32 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id g4so3242170pjk.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 03:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:subject:to:cc:references:in-reply-to:mime-version
 :message-id:content-transfer-encoding;
 bh=ISlLS/Bnqpf/oAWEGOJgKBZ0Rb18u3bU0Ep0kv2LMg0=;
 b=ItVpaR72A3eWg+6QNdd9RNw76aFcKOXvgi86A4U+ygjRobuSVtqGLn83lJQMbfCPA4
 LQIa3P9bWqZxWn65q97p0mTXZfMJxza4XBkddIpoDzA0Y1gz2b4OTCDChEW1fNnXNMtx
 Fd/HR/h+M9YqDeioWNf5AArKjGRkQ+rrWucptSeSf/UUf6QUwL4Nowo/4rEimVbdxS4Q
 CrrkCNn+4rsxvoMWh2fX66Avx4PzjnR2opDju0qKu/sbanWcGLqwESvvdl5Yw6PwyCya
 zQM4h5g6tjIbnWhNNgTE1fjofoOSBjtXdTRyzTMD0NSsHlc5YkGJ7hehN9KlI5q5bxjS
 Pecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
 :mime-version:message-id:content-transfer-encoding;
 bh=ISlLS/Bnqpf/oAWEGOJgKBZ0Rb18u3bU0Ep0kv2LMg0=;
 b=gLSjEEBDZa24jYqMPq5JiKhlrBUtXGJ7Cj2Mqnp4C8QkbIfU1ZvRNHMQE0/wCh9/6X
 OvI2fyYEbmoCwW/qS+K7r5cVZ+RsC1cz3cDlUTT5HbiJJR21w7M20RBlZz1Mf/rsm1j1
 Et9tO97XdJSTcMML7WaloxSQ5zsk+Mhq8CgcpyiREMwpZklDxu2FyC65e0A2HOrsP3gz
 9WCZUsJxCrU8CEYWpoVQGV4TDnnDKk6/p5uy1+kgPdKz9Dg4oQQAV7RsLgzqcfrb6SmN
 5EcNBOnp9RSVWAOLEGYnOJMsrTtcx6k6IDGyTlgv5ApwHKGCHI8k8WwdmxXXDS53q9cw
 uIrQ==
X-Gm-Message-State: AOAM530hLzw84oE/2JaI1rRQDzuBC9DP9t52sanJPNhMZGqDmDNbrxAN
 waSZGIpT3Xw27nxxOwKrbWk=
X-Google-Smtp-Source: ABdhPJy6kajrzF0OadUDC6nHAS6U7gmSDYSh4DBdORcOqITOBjGnDhRDrYwGVGZv+udz0pGSetXg8w==
X-Received: by 2002:a17:90b:4ac6:: with SMTP id
 mh6mr15043416pjb.210.1624530871905; 
 Thu, 24 Jun 2021 03:34:31 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
 by smtp.gmail.com with ESMTPSA id k63sm7664839pjh.13.2021.06.24.03.34.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Jun 2021 03:34:31 -0700 (PDT)
Date: Thu, 24 Jun 2021 20:34:25 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64 MMU
To: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Huacai Chen
 <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>, Paul Mackerras
 <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>, David Stevens
 <stevensd@chromium.org>, Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang
 <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
In-Reply-To: <20210624035749.4054934-1-stevensd@google.com>
MIME-Version: 1.0
Message-Id: <1624530624.8jff1f4u11.astroid@bobo.none>
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

Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
> KVM supports mapping VM_IO and VM_PFNMAP memory into the guest by using
> follow_pte in gfn_to_pfn. However, the resolved pfns may not have
> assoicated struct pages, so they should not be passed to pfn_to_page.
> This series removes such calls from the x86 and arm64 secondary MMU. To
> do this, this series modifies gfn_to_pfn to return a struct page in
> addition to a pfn, if the hva was resolved by gup. This allows the
> caller to call put_page only when necessated by gup.
> 
> This series provides a helper function that unwraps the new return type
> of gfn_to_pfn to provide behavior identical to the old behavior. As I
> have no hardware to test powerpc/mips changes, the function is used
> there for minimally invasive changes. Additionally, as gfn_to_page and
> gfn_to_pfn_cache are not integrated with mmu notifier, they cannot be
> easily changed over to only use pfns.
> 
> This addresses CVE-2021-22543 on x86 and arm64.

Does this fix the problem? (untested I don't have a POC setup at hand,
but at least in concept)

I have no problem with improving the API and probably in the direction 
of your series is good. But there seems to be a lot of unfixed arch code 
and broken APIs remaining left to do after your series too. This might 
be most suitable to backport and as a base for your series that can take
more time to convert to new APIs.

Thanks,
Nick

---

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6a6bc7af0e28..e208c279d903 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2104,13 +2104,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
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
@@ -2487,6 +2495,13 @@ void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
 
+static int kvm_try_get_pfn(kvm_pfn_t pfn)
+{
+	if (kvm_is_reserved_pfn(pfn))
+		return 1;
+	return get_page_unless_zero(pfn_to_page(pfn));
+}
+
 void kvm_get_pfn(kvm_pfn_t pfn)
 {
 	if (!kvm_is_reserved_pfn(pfn))
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
