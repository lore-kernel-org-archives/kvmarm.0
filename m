Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC2CAD46
	for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 12:47:29 +0000 (UTC)
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4053c6f1087so133826195e9.0
        for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 05:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695991648; x=1696596448; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B2Baqv/p94at+BEzxik746G5coKuSURMzwoefIjj1qM=;
        b=OrstkeX0xYID2KwuyLi0txQPKE5Ob1nvHedtcn6BsNdySY8vgCKLP0bmc/2wXIHI3D
         Z2tkJlg8dR4cLK3gkobikoK9ORkC/sQ0EK1LE43FKBTIfUehRkeZ7tzLgLMDE/N97lIj
         vpXG4QsLLiiNvgLPM5Gixner3u4fJdxnBvW51hrWeqK5eNUMNiqjPofuSWNpb7lnErGh
         ivq/G2Bm7ygHo1GnGtOFYByJsaszQvSwB9nXOqBkiq13jo5nSBe0Km0NIsfGeskfFp/Q
         r3CZ8vCdf1jluwA/zVOqeP2ESmefTG8PJWxAIN7RdNZJIxAyKBB3HzYT9sZeTyVYYPzq
         jehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695991648; x=1696596448;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B2Baqv/p94at+BEzxik746G5coKuSURMzwoefIjj1qM=;
        b=W3Dr+tyM8TLgITGDegXOo2MMDfD57m0krAcTDVSyauM50xYAlyDwDbj+yPFscgOAS3
         78SuLVai+xKs1pcavYl4Tfi/tES2gmy+BtxXwTrKDGDRUVGRawnMMu1mAZNv2x7/MRhP
         cbRricuVtkMLk75moCkT1HcGWjxG9H024tRZbi4bbEKRMfX44rIGeAUf+GAjNiCXCvtF
         M3IPrk7aycn9CcDYuG84kr1PuIkQqXJtw1zrDI8eOWD5xrFMz6/wDNMaDub5Pkp8gaDQ
         0dM3QgeqRqY09Mk6tkpG/wUmCp7Rtas40mCNHYDBJ3yAHoz71tMXGpXqPkcgAHBAmmUp
         eBeA==
X-Gm-Message-State: AOJu0YyiOwEG8y0dwW9D/lWe0BH4ifOSiDVyVTaluXg3hriEJCoq5Q6d
	2j9ZgmEnq2DQ6G+Jm1KVRqosDg==
X-Google-Smtp-Source: AGHT+IGue8b8bEC+SI+KHA/m1EPo6RoKJXOOvZN4bJqOr64nXH/TGLkK2dooTdLn+rtWyPAgPI77XQ==
X-Received: by 2002:a7b:c40f:0:b0:405:37bb:d942 with SMTP id k15-20020a7bc40f000000b0040537bbd942mr3771978wmi.4.1695991647554;
        Fri, 29 Sep 2023 05:47:27 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c294900b00401c595fcc7sm1373481wmd.11.2023.09.29.05.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Sep 2023 05:47:26 -0700 (PDT)
Date: Fri, 29 Sep 2023 13:47:23 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
	will@kernel.org, willy@infradead.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: Do not transfer page refcount for THP
 adjustment
Message-ID: <ZRbHW-kFNSxN9mmJ@google.com>
References: <20230928173205.2826598-1-vdonnefort@google.com>
 <20230928173205.2826598-2-vdonnefort@google.com>
 <3a05f8a1-5759-8744-49eb-e975c5cf129c@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a05f8a1-5759-8744-49eb-e975c5cf129c@redhat.com>

On Fri, Sep 29, 2023 at 04:59:20PM +1000, Gavin Shan wrote:
> On 9/29/23 03:32, Vincent Donnefort wrote:
> > GUP affects a refcount common to all pages forming the THP. There is
> > therefore no need to move the refcount from a tail to the head page.
> > Under the hood it decrements and increments the same counter.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 587a104f66c3..de5e5148ef5d 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1295,28 +1295,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
> >   		if (sz < PMD_SIZE)
> >   			return PAGE_SIZE;
> > -		/*
> > -		 * The address we faulted on is backed by a transparent huge
> > -		 * page.  However, because we map the compound huge page and
> > -		 * not the individual tail page, we need to transfer the
> > -		 * refcount to the head page.  We have to be careful that the
> > -		 * THP doesn't start to split while we are adjusting the
> > -		 * refcounts.
> > -		 *
> > -		 * We are sure this doesn't happen, because mmu_invalidate_retry
> > -		 * was successful and we are holding the mmu_lock, so if this
> > -		 * THP is trying to split, it will be blocked in the mmu
> > -		 * notifier before touching any of the pages, specifically
> > -		 * before being able to call __split_huge_page_refcount().
> > -		 *
> > -		 * We can therefore safely transfer the refcount from PG_tail
> > -		 * to PG_head and switch the pfn from a tail page to the head
> > -		 * page accordingly.
> > -		 */
> >   		*ipap &= PMD_MASK;
> > -		kvm_release_pfn_clean(pfn);
> >   		pfn &= ~(PTRS_PER_PMD - 1);
> > -		get_page(pfn_to_page(pfn));
> >   		*pfnp = pfn;
> >   		return PMD_SIZE;
> 
> The local variable @pfn can be dropped either.

I would like to keep it for the following patch: pfn_to_folio(pfn);

> 
>                 *pfnp &= ~(PTRS_PER_PMD - 1);
> 
> Thanks,
> Gavin
> 
