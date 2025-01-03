Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BB41ABEAC
	for <kvmarm@lists.linux.dev>; Fri,  3 Jan 2025 18:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735928324; cv=none; b=KDzzyM3uZnEu+sIrlNsVPYmGw8vSScM7KWek5EsbA+Myun+QPePmzt5wHJzyGJQ9WXgi3uChOs4vQwHoA6zblg/glpKHL0YtVQ0Em6yvfwJo8Jrgf3uk5K+fOi3yNZGewf+Fu8n2vI38eltYcpi4KUxqVmrhYmisUzKoF+WAf6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735928324; c=relaxed/simple;
	bh=pxO/NktkU5DBpkU1jGn2Y3KNP8LSY+fi3uLD59T0a6Y=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xyxfwl0COW+HqOavsyBIJiPz/8jUFiRHDIpUbCwlY/bcWf+PHVCApb1r1HUd4/h96Cna+AYQv7rxRbqO6Lpa3+MKhQdZ/1r9BllL691yVSOR+EDmZMyT9AN3Ogzc2wAkr6mbrd/uqCKD0HBYW6trgFBe+xn0b2OaBnfTcbySWBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YPsHt0PHNz6K6G1;
	Sat,  4 Jan 2025 02:17:46 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id AD2E71404C4;
	Sat,  4 Jan 2025 02:18:38 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 3 Jan
 2025 19:18:37 +0100
Date: Fri, 3 Jan 2025 18:18:36 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Ryan Roberts <ryan.roberts@arm.com>
CC: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 =?UTF-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	<catalin.marinas@arm.com>, <corbet@lwn.net>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvmarm@lists.linux.dev>,
	<yangyicong@huawei.com>, <guohanjun@huawei.com>,
	<wangkefeng.wang@huawei.com>, <liaochang1@huawei.com>,
	<sunnanyong@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [RESEND RFC PATCH v1 2/5] arm64: Add BBM Level 2 cpu feature
Message-ID: <20250103181836.000045b1@huawei.com>
In-Reply-To: <2a6448f5-a48b-42fd-9589-acdb434f0a8a@arm.com>
References: <20241211160218.41404-3-miko.lenczewski@arm.com>
	<87cyhxs3xq.wl-maz@kernel.org>
	<084c5ada-51af-4c1a-b50a-4401e62ddbd6@arm.com>
	<86ikrprn7w.wl-maz@kernel.org>
	<2b1cc228-a8d5-4383-ab25-abbbcccd2e2c@arm.com>
	<86h678sy00.wl-maz@kernel.org>
	<5c551e43-78e9-4336-ab16-b55c0d6c7f92@arm.com>
	<20241219164528.GH24724@willie-the-truck>
	<20250102120704.00002984@huawei.com>
	<86ed1lpfdh.wl-maz@kernel.org>
	<20250103153512.GD3816@willie-the-truck>
	<2a6448f5-a48b-42fd-9589-acdb434f0a8a@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Fri, 3 Jan 2025 16:00:59 +0000
Ryan Roberts <ryan.roberts@arm.com> wrote:

> On 03/01/2025 15:35, Will Deacon wrote:
> > On Thu, Jan 02, 2025 at 12:30:34PM +0000, Marc Zyngier wrote:  
> >> On Thu, 02 Jan 2025 12:07:04 +0000,
> >> Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:  
> >>> On Thu, 19 Dec 2024 16:45:28 +0000
> >>> Will Deacon <will@kernel.org> wrote:  
> >>>> On Thu, Dec 12, 2024 at 04:03:52PM +0000, Ryan Roberts wrote:  
> >>>>>>>> If anything, this should absolutely check for FAR_EL1 and assert that
> >>>>>>>> this is indeed caused by such change.    
> >>>>>>>
> >>>>>>> I'm not really sure how we would check this reliably? Without patch 5, the
> >>>>>>> problem is somewhat constrained; we could have as many changes in flight as
> >>>>>>> there are CPUs so we could keep a list of all the {mm_struct, VA-range} that are
> >>>>>>> being modified. But if patch 5 is confirmed to be architecturally sound, then
> >>>>>>> there is no "terminating tlbi" so there is no bound on the set of {mm_struct,
> >>>>>>> VA-range}'s that could legitimately cause a conflict abort.    
> >>>>>>
> >>>>>> I didn't mean to imply that we should identify the exact cause of the
> >>>>>> abort. I was hoping to simply check that FAR_EL1 reports a userspace
> >>>>>> VA. Why wouldn't that work?    
> >>>>>
> >>>>> Ahh gottya! Yes agreed, this sounds like the right approach.    
> >>>>
> >>>> Please, can we just not bother handling conflict aborts at all outside of
> >>>> KVM? This is all dead code, it's complicated and it doesn't scale to the
> >>>> in-kernel use-cases that others want. There's also not been any attempt
> >>>> to add the pKVM support for handling host-side conflict aborts from what
> >>>> I can tell.
> >>>>
> >>>> For now, I would suggest limiting this series just to the KVM support
> >>>> for handling a broken/malicious guest. If the contpte performance
> >>>> improvements are worthwhile (I've asked for data), then let's add support
> >>>> for the CPUs that handle the conflict in hardware (I believe this is far
> >>>> more common than reporting the abort) so that the in-kernel users can
> >>>> benefit whilst keeping the code manageable at the same time.
> >>>>  
> >>>
> >>> Given direction the discussion is going in time to raise a hand.
> >>>
> >>> Huawei has implementations that support BBML2, and might report TLB conflict
> >>> abort after changing block size directly until an appropriate TLB invalidation
> >>> instruction completes and this Implementation Choice is architecturally compliant.  
> >>
> >> Compliant, absolutely. That's the letter of the spec. The usefulness
> >> aspect is, however, more debatable, and this is what Will is pointing
> >> out.
> >>
> >> Dealing with TLB Conflict aborts is an absolute pain if you need
> >> to handle it within the same Translation Regime and using the same
> >> TTBR as the one that has generated the fault. So at least for the time
> >> being, it might be preferable to only worry about the implementations
> >> that will promise to never generate such an abort and quietly perform
> >> an invalidation behind the kernel's back.  
> > 
> > Agreed. We're not dropping support for CPUs that don't give us what we'd
> > like here, we're just not bending over to port and maintain new
> > optimisations for them. I think that's a reasonable compromise?

Subject to usual maintainability vs performance questions sure.
Given we are the ones with the implementation, it's perhaps up to us
to prove the added complexity for a given optimization is worth the hassle
(maybe leaning on Arm to help out ;)  We have some activity going on
around this, but are unfortunately not ready to share.

> > 
> > That said, thanks for raising this, Jonathan. It's a useful data point
> > to know that TLB conflict aborts exist in the wild!  

My work here is done ;)

> 
> Indeed. Just to make it explicit; if we were to support all architecturally
> compliant BBML2 implementations, we would need to drop the final patch in this
> series. But since it sounds like we will be taking the approach of only allowing
> these optimizations for implementations that never raise conflict abort and
> handle it all in HW, it should be safe to keep the optimization in that final
> patch. I'll work with Miko to get this bashed into shape and reposted.

Obviously I'd want perf numbers to justify it (working on that) but I'd like
to keep on the table the option of patch 5 being the only part that is dependent
on being non conflict aborting hardware. I think even that is a performance
question rather than a correctness one - it simply widens the window in which
we might see a fault and have to dump the TLB. (I may well have missed something
though).

As a side note on that last patch, it is easy to conceive of a BBML2
solution that doesn't do conflict aborts, but for which it is still a performance
nightmare to not flush. As a fictional implementation, where our CPUs get a conflict
abort, we could instead have stalled the core and pushed the abort info to a management
controller, and flushed the whole TLB to resolve (plus probably the CPU pipeline).
If sufficiently rare that's not a totally stupid implementation (subject to some
optimizations). It is basically offloading what we are going to do in software on
a conflict abort with somewhat similar performance cost making widening the window
a very bad idea.

So the proposed allow list might need to be rather more nuanced than "can we get
a fault?"  We all love per uarch performance related opt ins.

Jonathan

> 
> Thanks,
> Ryan
> 
> > 
> > Will  
> 
> 

