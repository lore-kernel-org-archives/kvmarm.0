Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6886BFC0;
	Fri, 27 Sep 2024 07:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727421086; cv=none; b=eKCOzA/sUCACZlMILt67wxQtIHpYmxqzWuNN34OohRzsYKcMiPJxxGHEeRSDfrN9DqQ20YnURQF+yfGvI3I5UKorHj09FtZ3On2wbqyH6jj+3MIxqLPWY4YvdHJP7jtazEN4KY/BEf5PNXGAxaUqITzj1j2DRwzmQrSPKJfBFBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727421086; c=relaxed/simple;
	bh=+Y4NYDhIv45fFiVjtEzsSH3Epg2KxOSbf3DPyjYn7WM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IsPrK/utD82XgsnrKm2iCIgj+72B5E04avocEwxLMcRw+Fne0ZVKLp17TkrIKArvXJ4tvOQgcYGaOwVQ9J9TDDefthQYTa/Zi42F4kG3vsRNZTDgNpkMEXvGQ3FPhqMni7b4sIn2HxsfvO1CH1tls3nXUyVtaMY7qLd9PbMLEno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugLLetMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugLLetMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675F1C4CEC4;
	Fri, 27 Sep 2024 07:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727421086;
	bh=+Y4NYDhIv45fFiVjtEzsSH3Epg2KxOSbf3DPyjYn7WM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ugLLetMrCwYCHWCL1woa7XD/eluuBTMgumu7EVcVyPLlsY9ClB7wkiGnbLDlgSgdO
	 AsqQM4/4462e1d6Lp5enlqekSjLXP1PM77ux7gnqpXmwEMtS1OKJosefKxsr02B3LF
	 leAIuZr5BIAVv2W7olvcME1LCer3LZLSLGW9xCM/MltqA9GFWukXZnrPfLrMJiRux3
	 /W9kfPrqRWGnBwbVHlh+ZmOEKfjkcgWo+RgbwKzH9h9X/vV9ULF8UASi10hvUckbBF
	 RVXLaBWDZogRiybzKtwoCh41I5zWIsTD8XglHrFQC2WiUVsrtcjcrBHTzPkYk2qM3L
	 BFF1xTklOCbsw==
Date: Fri, 27 Sep 2024 10:08:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Fares Mehanna <faresx@amazon.de>
Cc: akpm@linux-foundation.org, ardb@kernel.org, arnd@arndb.de,
	bhelgaas@google.com, broonie@kernel.org, catalin.marinas@arm.com,
	david@redhat.com, james.morse@arm.com, javierm@redhat.com,
	jean-philippe@linaro.org, joey.gouly@arm.com,
	kristina.martsenko@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mark.rutland@arm.com, maz@kernel.org,
	nh-open-source@amazon.com, oliver.upton@linux.dev, ptosi@google.com,
	rdunlap@infradead.org, rkagan@amazon.de, shikemeng@huaweicloud.com,
	suzuki.poulose@arm.com, tabba@google.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [RFC PATCH 0/7] support for mm-local memory allocations and use
 it
Message-ID: <ZvZZ0eQ2NUq3GWSj@kernel.org>
References: <Zu1r5-JnL3sduoqy@kernel.org>
 <20240925153347.94589-1-faresx@amazon.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240925153347.94589-1-faresx@amazon.de>

On Wed, Sep 25, 2024 at 03:33:47PM +0000, Fares Mehanna wrote:
> Hi,
> 
> Thanks for taking a look and apologies for my delayed response.
> 
> > Having a VMA in user mappings for kernel memory seems weird to say the
> > least.
> 
> I see your point and agree with you. Let me explain the motivation, pros and
> cons of the approach after answering your questions.
> 
> > Core MM does not expect to have VMAs for kernel memory. What will happen if
> > userspace ftruncates that VMA? Or registers it with userfaultfd?
> 
> In the patch, I make sure the pages are faulted in, locked and sealed to make
> sure the VMA is practically off-limits from the owner process. Only after that
> I change the permissions to be used by the kernel.

And what about VMA accesses from the kernel? How do you verify that
everything that works with VMAs in the kernel can deal with that being a
kernel mapping rather than userspace?
 
> > This approach seems much more reasonable and it's not that it was entirely
> > arch-specific. There is some plumbing at arch level, but the allocator is
> > anyway arch-independent. 
> 
> So I wanted to explore a simple solution to implement mm-local kernel secret
> memory without much arch dependent code. I also wanted to reuse as much of
> memfd_secret() as possible to benefit from what is done already and possible
> future improvements to it.

Adding functionality that normally belongs to userspace into mm/secretmem.c
does not feel like a reuse, sorry.

The only thing your actually share is removal of the allocated pages from
the direct map. And hijacking userspace mapping instead of properly
implementing a kernel mapping does not seem like proper solution.
 
> Keeping the secret pages in user virtual addresses is easier as the page table
> entries are not global by default so no special handling for spawn(). keeping
> them tracked in VMA shouldn't require special handling for fork().
> 
> The challenge was to keep the virtual addresses / VMA away from user control as
> long as the kernel is using it, and signal the mm core that this VMA is special
> so it is not merged with other VMAs.
> 
> I believe locking the pages, sealing the VMA, prefaulting the pages should make
> it practicality away of user space influence.
> 
> But the current approach have those downsides: (That I can think of)
> 1. Kernel secret user virtual addresses can still be used in functions accepting
>    user virtual addresses like copy_from_user / copy_to_user.
> 2. Even if we are sure the VMA is off-limits to userspace, adding VMA with
>    kernel addresses will increase attack surface between userspace and the
>    kernel.
> 3. Since kernel secret memory is mapped in user virtual addresses, it is very
>    easy to guess the exact virtual address (using binary search), and since
>    this functionality is designed to keep user data, it is fair to assume the
>    userspace will always be able to influence what is written there.
>    So it kind of breaks KASLR for those specific pages.

There is even no need to guess, it will appear on /proc/pid/maps

> 4. It locks user virtual memory away, this may break some software if they
>    assumed they can mmap() into specific places.
> 
> One way to address most of those concerns while keeping the solution almost arch
> agnostic is is to allocate reasonable chunk of user virtual memory to be only
> used for kernel secret memory, and not track them in VMAs.
> This is similar to the old approach but instead of creating non-global kernel
> PGD per arch it will use chunk of user virtual memory. This chunk can be defined
> per arch, and this solution won't use memfd_secret().
> We can then easily enlighten the kernel about this range so the kernel can test
> for this range in functions like access_ok(). This approach however will make
> downside #4 even worse, as it will reserve bigger chunk of user virtual memory
> if this feature is enabled.
> 
> I'm also very okay switching back to the old approach with the expense of:
> 1. Supporting fewer architectures that can afford to give away single PGD.

Only few architectures can modify their direct map, and all these can spare
a PGD entry.

> 2. More complicated arch specific code.

On x86 similar code already exists for LDT, you may want to look at Andy's
comments on old proclocal posting:

https://lore.kernel.org/lkml/CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com/

> Also @graf mentioned how aarch64 uses TTBR0/TTBR1 for user and kernel page
> tables, I haven't looked at this yet but it probably means that kernel page
> table will be tracked per process and TTBR1 will be switched during context
> switching.
> 
> What do you think? I would appreciate your opinion before working on the next
> RFC patch set.
> 
> Thanks!
> Fares.
> 
> 
> 
> Amazon Web Services Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597
> 

-- 
Sincerely yours,
Mike.
