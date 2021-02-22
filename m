Return-Path: <SRS0=UwAz=HY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68D8C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 11:04:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0AD3064E61
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 11:04:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AD3064E61
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79AB64B15F;
	Mon, 22 Feb 2021 06:04:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id svTdS9z7K5ps; Mon, 22 Feb 2021 06:04:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A93F04B166;
	Mon, 22 Feb 2021 06:04:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A75824B15E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 06:04:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mvx2kps1AMUG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Feb 2021 06:04:20 -0500 (EST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A5B1D4B105
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 06:04:20 -0500 (EST)
Received: by mail-wr1-f49.google.com with SMTP id n8so18546297wrm.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 03:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=w6npELERY6rB3Dp9A7WDHsdNDwVeXG2MhW1a6MllviU=;
 b=AGxhojrCDx89PT+ATbFNrC9o05X4CdmNDewjWlY4kRAotuz6K4g8lTe6F7MI7TAsd/
 t1UhE4GmUc8UU2jRgOT0UAim4SDtwchNBcEbJ2sIByMB5Tz+tmZ+4ScgArPT/rJ8b4p3
 ktA6fXbESdmdl6LnOCWbo/LB1Vwth9A4NTM7YLsuGSRnNz2GRmy1Xm4dL4KHhs/rNzzY
 WwrSZ3pPjl4Jfc5qxHuPLE66PdyE5HIjrFQ18myghhwepi7VO5/ZOpnlmktzJrlhgp20
 vR0P9zbdP1TmxvGqisnhieWerU/Zekskp/sE9zs/6zhpfmIcWerjSFCzxJMYQsLcOV+M
 XCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=w6npELERY6rB3Dp9A7WDHsdNDwVeXG2MhW1a6MllviU=;
 b=cGJ6j4QutCLsH45xPPwaF2Z6CRonQb2ktz08YTcewj+BqZck1RV/AEVcvOW2t6Pt9+
 z5BGj9iql/15srnC9d7/u42b4GDN3/AjHx317rvEPOHZ8nD9Vl32S6xn/8kSXBdrRUOP
 NVQyyAoDl04SXouFaYtloQ6ZwGmH0OgOS59o51mVHdKzLgUvwR1nWxPXM+Salm4pm/Ln
 Ar68iQ55lRmpjOOkjp1BMIvRbDTCr7r1BsKhOTwR8YlnNj+TdLm8EOLezCpRhUuWRn/Q
 4WlF8lqT0DxkQj0gdmC0lthbKAIJe3GECJFZ23MH/5K2hshMc8Q2gU4g41MuWn0r2V4E
 1ldw==
X-Gm-Message-State: AOAM531ILglyZKkqSTNP21JncCLbg/zl+wGn4hxMugw8CTZ4QA1D09va
 5lUhtKnl5pjeYZbf6m6X5yCLNQ==
X-Google-Smtp-Source: ABdhPJxgFDcmq5dsILmm6KR9g+MsM/rBJTmBsyfH/l7oU2+CjNz1rIn8Osx2uhrrwoGXu4U3HE8c4w==
X-Received: by 2002:a5d:6148:: with SMTP id y8mr21007272wrt.238.1613991859512; 
 Mon, 22 Feb 2021 03:04:19 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id z21sm20005568wma.29.2021.02.22.03.04.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 Feb 2021 03:04:19 -0800 (PST)
Date: Mon, 22 Feb 2021 11:04:16 +0000
From: Quentin Perret <qperret@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v2 16/26] KVM: arm64: Prepare Hyp memory protection
Message-ID: <YDOPsBG7dPD2M3Xm@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-17-qperret@google.com>
 <20210203143709.GA18907@willie-the-truck>
 <YDAEWu7RkG1OBFed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YDAEWu7RkG1OBFed@google.com>
Cc: devicetree@vger.kernel.org, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Hi Sean,

On Friday 19 Feb 2021 at 10:32:58 (-0800), Sean Christopherson wrote:
> On Wed, Feb 03, 2021, Will Deacon wrote:
> > On Fri, Jan 08, 2021 at 12:15:14PM +0000, Quentin Perret wrote:
> 
> ...
> 
> > > +static inline unsigned long hyp_s1_pgtable_size(void)
> > > +{
> 
> ...
> 
> > > +		res += nr_pages << PAGE_SHIFT;
> > > +	}
> > > +
> > > +	/* Allow 1 GiB for private mappings */
> > > +	nr_pages = (1 << 30) >> PAGE_SHIFT;
> > 
> > SZ_1G >> PAGE_SHIFT
> 
> Where does the 1gb magic number come from?

Admittedly it is arbitrary. It needs to be enough to cover all the
so-called 'private' mappings that EL2 needs, and which can vary a little
depending on the hardware.

> IIUC, this is calculating the number
> of pages needed for the hypervisor's Stage-1 page tables.

Correct. The thing worth noting is that the hypervisor VA space is
essentially split in half. One half is reserved to map portions of
memory with a fixed offset, and the other half is used for a whole bunch
of other things: we have a vmemmap, the 'private' mappings and the idmap
page.

> The amount of memory
> needed for those page tables should be easily calculated

As mentioned above, that is true for pretty much everything in the hyp
VA space except the private mappings as that depends on e.g. the CPU
uarch and such.

> and assuming huge pages can be used, should be far less the 1gb.

Ack, though this is no supported for the EL2 mappings yet. Historically
the amount of contiguous portions of memory mapped at EL2 has been
rather small, so there wasn't really a need, but we might want to
revisit this at some point.

> > > +	nr_pages = __hyp_pgtable_max_pages(nr_pages);
> > > +	res += nr_pages << PAGE_SHIFT;
> > > +
> > > +	return res;
> 
> ...
> 
> > > +void __init kvm_hyp_reserve(void)
> > > +{
> > > +	u64 nr_pages, prev;
> > > +
> > > +	if (!is_hyp_mode_available() || is_kernel_in_hyp_mode())
> > > +		return;
> > > +
> > > +	if (kvm_get_mode() != KVM_MODE_PROTECTED)
> > > +		return;
> > > +
> > > +	if (kvm_nvhe_sym(hyp_memblock_nr) < 0) {
> > > +		kvm_err("Failed to register hyp memblocks\n");
> > > +		return;
> > > +	}
> > > +
> > > +	sort_memblock_regions();
> > > +
> > > +	/*
> > > +	 * We don't know the number of possible CPUs yet, so allocate for the
> > > +	 * worst case.
> > > +	 */
> > > +	hyp_mem_size += NR_CPUS << PAGE_SHIFT;
> 
> Is this for per-cpu stack?

Correct.

> If so, what guarantees a single page is sufficient? Mostly a curiosity question,
> since it looks like this is an existing assumption by init_hyp_mode().  Shouldn't
> the required stack size be defined in bytes and converted to pages, or is there a
> guarantee that 64kb pages will be used?

Nope, we have no such guarantees, but 4K has been more than enough for
EL2 so far. The hyp code doesn't use recursion much (I think the only
occurence we have is Will's pgtable code, and that is architecturally
limited to 4 levels of recursion for obvious reasons) and doesn't have
use stack allocations.

It's on my todo list to remap the stack pages in the 'private' range, to
surround them with guard pages so we can at least run-time check this
assumption, so stay tuned :)

> > There was a recent patch bumping NR_CPUs to 512, so this would be 32MB
> > with 64k pages. Is it possible to return memory to the host later on once
> > we have a better handle on the number of CPUs in the system?
> 
> Does kvm_hyp_reserve() really need to be called during bootmem_init()?  What
> prevents doing the reservation during init_hyp_mode()?  If the problem is that
> pKVM needs a single contiguous chunk of memory, then it might be worth solving
> _that_ problem, e.g. letting the host donate memory in N-byte chunks instead of
> requiring a single huge blob of memory.

Right, I've been thinking about this over the weekend and that might
actually be fairly straightforward for stack pages. I'll try to move this
allocation to init_hyp_mode() where it belongs (or better, re-use the
existing one) in the nest version.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
