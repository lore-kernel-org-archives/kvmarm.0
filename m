Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B275FC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 30 Dec 2021 19:26:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27AF549EBF;
	Thu, 30 Dec 2021 14:26:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 41u1sXAd3-Xz; Thu, 30 Dec 2021 14:26:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F5CA49E48;
	Thu, 30 Dec 2021 14:26:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F86E40D26
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 14:26:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sVEgJL15i1Ct for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Dec 2021 14:26:54 -0500 (EST)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60E7240D0B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 14:26:54 -0500 (EST)
Received: by mail-pj1-f45.google.com with SMTP id jw3so21872920pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 11:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=TZUph+1LIEWHwkUrkggqde2R87m4Flj/r9dmdwLX5Gk=;
 b=YjPirROoPg13DarDjbdzx+b6JXQsjXJAroXjMUwNDC76kjIF6C1cS8keBNKHMwtVRz
 ISz7aWmvSYfhUT0/mv+fQimuFcM7IpQYiGSj5GneQoSRXJf27E+/a7kX/zz7OILY+ohR
 KvvILQ1tJEBcxhfEfb4Sze3gNLGOdNBvx2AM7nRMVaOKJ6zXjhHHSmfR5Ea/RkSYkONc
 Vv5TuUD92KHd0ioNQnac3ovtQjfZUOUlYaj5MyVEagQy5v7ICbkHPQwcB/friSppUclP
 moI5YE9d9gjNvOeLdaVxqsBZYX+6aAerSR+/sdxPKQZlefucqnMpLtkqSkdgP7uOLynp
 C4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TZUph+1LIEWHwkUrkggqde2R87m4Flj/r9dmdwLX5Gk=;
 b=0PKhiQqHcXyQhNF7eordUpDpPwPFv+z2mCsvsVQ+jPJSIz5+wtQAT6rHnnvac2lE6b
 DdC6Mc71Es4Zcm0EjCSUTxeJeaMlnL/2yNByNSwWPxoULiwxXJknrQ5BKoLecIm59YTI
 wVak+geYiPJnUp76k8akgfAPtjJ1btBZ6F0qpO48cT2NazEHqiUn2O6t5lTuH4vCzAP/
 eRurXQ6IPG+1/vBRPud+72tQi0gYZ0aSZMz5+t7CaKFPpI/rvayyLqZGkEOvdidSlDFF
 zGzxz7bRrt0X3BChiD/UwAYo0hIh4MiWJ3tX4OXzbtOLiOmpxiLAwkHrIyn1T7bWK0SZ
 Q6+A==
X-Gm-Message-State: AOAM530LOxyxr6gFzKPdClNEz9Dp2dcCdme1jb3qVeKU4O2S2wSVVBw9
 wj2rZrTzNy/f1lfraRvVSFdHzg==
X-Google-Smtp-Source: ABdhPJy75H5vqTjoxkUn2lk86SVP6fu7EF2sx90j7RLzIByICIqLM9zp/fNPB/CyaOJtZQ2wXQ2z2A==
X-Received: by 2002:a17:902:ab53:b0:149:7902:bc8f with SMTP id
 ij19-20020a170902ab5300b001497902bc8fmr22576921plb.85.1640892413370; 
 Thu, 30 Dec 2021 11:26:53 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id u71sm23209813pgd.68.2021.12.30.11.26.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Dec 2021 11:26:52 -0800 (PST)
Date: Thu, 30 Dec 2021 19:26:49 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v5 1/4] KVM: mmu: introduce new gfn_to_pfn_page functions
Message-ID: <Yc4H+dGfK83BaGpC@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-2-stevensd@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129034317.2964790-2-stevensd@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Nov 29, 2021, David Stevens wrote:
> +static kvm_pfn_t ensure_pfn_ref(struct page *page, kvm_pfn_t pfn)

"ensure" is rather misleading as that implies this is _just_ an assertion, but
that's not true since it elevates the refcount.  Maybe kvm_try_get_page_ref()?

> +{
> +	if (page || is_error_pfn(pfn))

A comment above here would be very helpful.  It's easy to overlook the "page"
check and think that KVM is double-counting pages.  E.g.

	/* If @page is valid, KVM already has a reference to the pfn/page. */

That would tie in nicely with the kvm_try_get_page_ref() name too.

> +		return pfn;
> +
> +	/*
> +	 * If we're here, a pfn resolved by hva_to_pfn_remapped is
> +	 * going to be returned to something that ultimately calls
> +	 * kvm_release_pfn_clean, so the refcount needs to be bumped if
> +	 * the pfn isn't a reserved pfn.
> +	 *
> +	 * Whoever called remap_pfn_range is also going to call e.g.
> +	 * unmap_mapping_range before the underlying pages are freed,
> +	 * causing a call to our MMU notifier.
> +	 *
> +	 * Certain IO or PFNMAP mappings can be backed with valid
> +	 * struct pages, but be allocated without refcounting e.g.,
> +	 * tail pages of non-compound higher order allocations, which
> +	 * would then underflow the refcount when the caller does the
> +	 * required put_page. Don't allow those pages here.
> +	 */
> +	if (kvm_is_reserved_pfn(pfn) ||
> +	    get_page_unless_zero(pfn_to_page(pfn)))
> +		return pfn;
> +
> +	return KVM_PFN_ERR_FAULT;
> +}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
