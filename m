Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6F921500F
	for <kvmarm@lists.linux.dev>; Tue,  8 Oct 2024 20:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728418250; cv=none; b=adHQ5hkAYxUPDMOxRunQkUJvT1e3g8oHvWECfnTDvPv8QOnuNgeK7v3YOIIgznkjDbXkdJ4+KEsrWWzZwjE9AC/djo25Q7tUsjiuI1e59TRWOvG6jzmF7dTrcHZBULBnWWPfm6WzGE5g3ToV5G/pToAyDBCKS2bYJDV8Wfq8IXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728418250; c=relaxed/simple;
	bh=E7zPAoCmwBqBdf7PBNrujyJalnwi15pZnyEj/jpf2DQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VM8WXO4bJnaqgRwBHp6F32NIUW4xlJjXuEQt3iGigoUaBrI4fVWlGGxdfMHpcNUiboOO12pwwG2ImgJJsk43IDgH7z1dPUHcW93hACXwr2D6Anj3ejK+vdY2lyKeYP2NzNVNGs228iiLFSVFtk/DtFVXYfoxx4oEx75K8uPZQUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=Nyj9iPE1; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="Nyj9iPE1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1728418250; x=1759954250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BVMFzVxR0Kuh6OmNjVYTpAPSyJ3Xe7jNg3d6jsZiecE=;
  b=Nyj9iPE1HcWCbuZDdOalYjZCWe8sbzcaQ5WluUWA3Glb3U3g5xOajPhu
   rqzKjvOgN74i2I8TASuISLGfUnllK9THXDHxKkKeyHCOnL2i8SBEzA0Nk
   XZufF1svBL+fAXoCwNXOcIYwQ/SE00r99q5evKrWVDO0UeywlnKDTEk26
   c=;
X-IronPort-AV: E=Sophos;i="6.11,187,1725321600"; 
   d="scan'208";a="686074039"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 20:10:45 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.10.100:1906]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.8.31:2525] with esmtp (Farcaster)
 id bc1728f2-b0d2-4007-a03a-d2d583554258; Tue, 8 Oct 2024 20:10:42 +0000 (UTC)
X-Farcaster-Flow-ID: bc1728f2-b0d2-4007-a03a-d2d583554258
Received: from EX19D007EUA004.ant.amazon.com (10.252.50.76) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 8 Oct 2024 20:10:39 +0000
Received: from EX19MTAUWA002.ant.amazon.com (10.250.64.202) by
 EX19D007EUA004.ant.amazon.com (10.252.50.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Tue, 8 Oct 2024 20:10:38 +0000
Received: from email-imr-corp-prod-pdx-all-2c-475d797d.us-west-2.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Tue, 8 Oct 2024 20:10:38 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com [10.253.79.181])
	by email-imr-corp-prod-pdx-all-2c-475d797d.us-west-2.amazon.com (Postfix) with ESMTPS id 82532A0309;
	Tue,  8 Oct 2024 20:10:34 +0000 (UTC)
From: Fares Mehanna <faresx@amazon.de>
To: <rppt@kernel.org>
CC: <akpm@linux-foundation.org>, <ardb@kernel.org>, <arnd@arndb.de>,
	<bhelgaas@google.com>, <broonie@kernel.org>, <catalin.marinas@arm.com>,
	<david@redhat.com>, <faresx@amazon.de>, <james.morse@arm.com>,
	<javierm@redhat.com>, <jean-philippe@linaro.org>, <joey.gouly@arm.com>,
	<kristina.martsenko@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <mark.rutland@arm.com>, <maz@kernel.org>,
	<nh-open-source@amazon.com>, <oliver.upton@linux.dev>, <ptosi@google.com>,
	<rdunlap@infradead.org>, <rkagan@amazon.de>, <shikemeng@huaweicloud.com>,
	<suzuki.poulose@arm.com>, <tabba@google.com>, <will@kernel.org>,
	<yuzenghui@huawei.com>
Subject: Re: [RFC PATCH 0/7] support for mm-local memory allocations and use it
Date: Tue, 8 Oct 2024 20:06:32 +0000
Message-ID: <20241008200632.52082-1-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <ZvZZ0eQ2NUq3GWSj@kernel.org>
References: <ZvZZ0eQ2NUq3GWSj@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> > Hi,
> > 
> > Thanks for taking a look and apologies for my delayed response.
> > 
> > > Having a VMA in user mappings for kernel memory seems weird to say the
> > > least.
> > 
> > I see your point and agree with you. Let me explain the motivation, pros and
> > cons of the approach after answering your questions.
> > 
> > > Core MM does not expect to have VMAs for kernel memory. What will happen if
> > > userspace ftruncates that VMA? Or registers it with userfaultfd?
> > 
> > In the patch, I make sure the pages are faulted in, locked and sealed to make
> > sure the VMA is practically off-limits from the owner process. Only after that
> > I change the permissions to be used by the kernel.
> 
> And what about VMA accesses from the kernel? How do you verify that
> everything that works with VMAs in the kernel can deal with that being a
> kernel mapping rather than userspace?

I added `VM_MIXEDMAP` if the secret allocation is intended for kernel usage,
this should make the VMA special and prevent a lot of operations like VMA merging.
Maybe the usage of `VM_MIXEDMAP` is not ideal and we can introduce a new kernel
flag for that. But I'm not aware of a destructive VMA operation from kernel side
while the VMA is marked special, mixed-map and sealed.

> > > This approach seems much more reasonable and it's not that it was entirely
> > > arch-specific. There is some plumbing at arch level, but the allocator is
> > > anyway arch-independent. 
> > 
> > So I wanted to explore a simple solution to implement mm-local kernel secret
> > memory without much arch dependent code. I also wanted to reuse as much of
> > memfd_secret() as possible to benefit from what is done already and possible
> > future improvements to it.
> 
> Adding functionality that normally belongs to userspace into mm/secretmem.c
> does not feel like a reuse, sorry.

Right, because the mapping in user virtual space most of the operations belongs
to userspace yes. I thought this way would be easier to demonstrate the approach
for RFC.

> The only thing your actually share is removal of the allocated pages from
> the direct map. And hijacking userspace mapping instead of properly
> implementing a kernel mapping does not seem like proper solution.

Also we get:
1. PGD is private when creating new process.
2. Existing kernel-secret mappings for given process will be cloned on fork(),
   so no need to keep track of them to be cloned on fork().
3. No special handling for context switching.

> > Keeping the secret pages in user virtual addresses is easier as the page table
> > entries are not global by default so no special handling for spawn(). keeping
> > them tracked in VMA shouldn't require special handling for fork().
> > 
> > The challenge was to keep the virtual addresses / VMA away from user control as
> > long as the kernel is using it, and signal the mm core that this VMA is special
> > so it is not merged with other VMAs.
> > 
> > I believe locking the pages, sealing the VMA, prefaulting the pages should make
> > it practicality away of user space influence.
> > 
> > But the current approach have those downsides: (That I can think of)
> > 1. Kernel secret user virtual addresses can still be used in functions accepting
> >    user virtual addresses like copy_from_user / copy_to_user.
> > 2. Even if we are sure the VMA is off-limits to userspace, adding VMA with
> >    kernel addresses will increase attack surface between userspace and the
> >    kernel.
> > 3. Since kernel secret memory is mapped in user virtual addresses, it is very
> >    easy to guess the exact virtual address (using binary search), and since
> >    this functionality is designed to keep user data, it is fair to assume the
> >    userspace will always be able to influence what is written there.
> >    So it kind of breaks KASLR for those specific pages.
> 
> There is even no need to guess, it will appear on /proc/pid/maps

Yeah but that is easily fixable, however the other issue stays the same unless
I allocated bigger chunk from userspace and moved away from VMA tracking.

> > 4. It locks user virtual memory away, this may break some software if they
> >    assumed they can mmap() into specific places.
> > 
> > One way to address most of those concerns while keeping the solution almost arch
> > agnostic is is to allocate reasonable chunk of user virtual memory to be only
> > used for kernel secret memory, and not track them in VMAs.
> > This is similar to the old approach but instead of creating non-global kernel
> > PGD per arch it will use chunk of user virtual memory. This chunk can be defined
> > per arch, and this solution won't use memfd_secret().
> > We can then easily enlighten the kernel about this range so the kernel can test
> > for this range in functions like access_ok(). This approach however will make
> > downside #4 even worse, as it will reserve bigger chunk of user virtual memory
> > if this feature is enabled.
> > 
> > I'm also very okay switching back to the old approach with the expense of:
> > 1. Supporting fewer architectures that can afford to give away single PGD.
> 
> Only few architectures can modify their direct map, and all these can spare
> a PGD entry.
> 
> > 2. More complicated arch specific code.
> 
> On x86 similar code already exists for LDT, you may want to look at Andy's
> comments on old proclocal posting:
> 
> https://lore.kernel.org/lkml/CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com/

Ah I see, so no need to think about architectures that can't spare a PGD. thanks!
I read the discussion and LDT is x86 specific and I wanted to start with aarch64.

I'm still thinking about the best approach for aarch64 for my next PoC, aarch64
track two tables in TTBR0/TTBR1, what I'm thinking of is:
1. Have kernel page table per process, with all its PGD entries shared other than
   a single PGD for kernel secret allocations.
2. On fork, traverse the private PGD part and clone existing page table for the
   new process.
3. On context switching, write the table to TTBR1, thus the kernel will have
   access to all secret allocations per this process.

This will move away from user vaddr and VMA tracking, with the expense of each
architecture will support it on its own way.

Does that sound more decent?

Thank you!
Fares.

> > Also @graf mentioned how aarch64 uses TTBR0/TTBR1 for user and kernel page
> > tables, I haven't looked at this yet but it probably means that kernel page
> > table will be tracked per process and TTBR1 will be switched during context
> > switching.
> > 
> > What do you think? I would appreciate your opinion before working on the next
> > RFC patch set.
> > 
> > Thanks!
> > Fares.



Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

