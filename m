Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0CA34EEFD;
	Tue, 30 Jun 2026 15:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782834263; cv=none; b=Ev1MV37M6Dy8lI6RCeJ72DhXo6Dp34gs9Kp4JNO+q54B5LauaCdqbUE9Q4RpSeHr0/6EkUGOz8zb9Gx4Yowj+ffGclo8jG9yoqc7limZ+kmhNvxEMSG2w6sec67NkzNk28Zz2dIEtILJ6TsAaFK4cw3/WyCZk/4yuhTV1SGr5ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782834263; c=relaxed/simple;
	bh=xJlETisceaoQr6SOFhAjR4tLS6ntrZvAD9La15OrU+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QTOg/2iIZ+0c/ddBTU8h1t2lPcsgoZc7UA1udaDvu/SN9nokkAfj9RHFlQ7FDWwO0YSDpeX+JC/kbT3Y359/GGGA2arhtXrsb3eLcE7l+rrB+SJYr8MyLk0cVOZcWvOWuwpqZft7Izck1vYYitqKkQ+LaqT6lfc8zAqTfYq2Z4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EPJtyVuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EPJtyVuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895A21F000E9;
	Tue, 30 Jun 2026 15:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782834261;
	bh=kC71ZF1kU53NLjP9UflQ+W4nP0189uDbEuX/DDRpMDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EPJtyVuVdzjkHUcPss+Ig2MSQjEu5Ef8JMWUxUcjBPCJL6k3RrqZsGxPXV85bt7ml
	 6g35L5LEW+F1PCyzAx2FIGPPnpjXuionvHgkkWl4r77GYyns05i/DQIaMTJbCU0Ltb
	 PIKheb/4o1RbneFocrwvReKWLB886gaVK0dbM6OHAOayE8XeSDRyF4n+ZiRxM1jXIf
	 gDgDf+FKDLERrDaQ2TYEga6t4ejSkUMKJAwBNSwqhC5vcjBPPy6EGuFRgRK0nASk+I
	 pdBVTkPRCU5YOoD4Oc9dVqQ/KKPc47FjM7Y9RiAK4lbjjA7L6pIjzIJV0U+ZmWhj6e
	 qz4lvMSQQ2BEA==
Date: Tue, 30 Jun 2026 08:44:20 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v2 02/13] KVM: arm64: Enable eager hugepage splitting if
 HDBSS is available
Message-ID: <akPkVASjWWYQpkx1@kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-3-leo.bras@arm.com>
 <20260629113645.BE6801F000E9@smtp.kernel.org>
 <akKFlzAdB43lRpi1@LeoBrasDK>
 <akKmHqRaZEUjN3zY@kernel.org>
 <akO9iHJmKN7MzTjM@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akO9iHJmKN7MzTjM@LeoBrasDK>

On Tue, Jun 30, 2026 at 01:58:48PM +0100, Leonardo Bras wrote:
> On Mon, Jun 29, 2026 at 10:06:38AM -0700, Oliver Upton wrote:
> > > But this raises a topic I would like to understand:
> > > - Do we actually need this to be a block_size to assure correctness? or is 
> > >   it just about efficiency?
> > 
> > What value is there in having a chunk size larger than the largest
> > possible block mapping? The whole UAPI is deliberately tied up with page
> > table geometry.
> 
> Not larger, possibly smallerv My concern was the difference in pages to 
> split between 4k, 16k and 64k.

Ok, well in any case the upper bound is going to be the largest possible
block mapping for a given page granule.

> > 
> > Overall, I'm not buying the argument for changing the behavior of
> > KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE. There are very good reasons for
> > *not* eagerly splitting the entire address space, especially if you know
> > the working set of the VM is small.
> > 
> > You can still use HDBSS without eagerly splitting, so long as block
> > mappings are {DBM, S2AP_W} = {0, 0} and leaf mappings (which have
> > a writable PFN) are {1, 0}.
> > 
> 
> Block mappings being read-only, and leaf mappings being writable-clean, 
> then? Could you please ellaborate on why does not it need eager-split?

Read-only translations will continue to generate permission faults
whereas writable-clean descriptors can be updated by hardware. You get
the opportunity to split a block mapping lazily while preserving
hardware dirty tracking for page mappings.

> As a review, what I recall from the strategy for hw dirty-logging was:
> - If we have HDBSS, add DBM for all writable pages {1, 1}
> - On dirty-logging start, make them writable-clean {1, 0}
>   - Can be done using HACDBS
>   - Enable HDBSS & HAFDBS
> 
> We don't have a fault for making pages dirty anymore, as this is done 
> by HAFDBS and recorded by HDBSS, so splitting does not happen on demand 
> anymore. So if we want to split pages, for better tracking granularity, or 
> anything, we have to eager-split them.

What I'm saying is the presumption that eager page splitting is always a
net-win is wrong. Nor is eager page splitting a hard requirement for
using HDBSS since you can set up the stage-2 in such a way that only
page granularity mappings are dirtied by hardware.

You could, in theory, have a workload that is read-heavy for a majority
of the VM's address space and writes to only a subset of that memory.
Eagerly splitting pages would likely regress the workload from a higher
rate of TLB refills / more TLB walk steps.

Lazily splitting would have the effect of leaving block mappings in
place for most of the VM. This is exactly why the VMM is in the driver
seat for deciding whether to lazily or eagerly split the stage-2.

The approach I think we may need is:

 - Use a software bit in the PTE to stash whether or not a PFN is
   'software-writable' when constructing the stage-2. By this I mean
   we've already faulted it in for write from the primary MMU.

 - At the time of write protection, reap the hardware-writable state
   from all PTEs but preserve the software-writable bit.

 - Whenever splitting a block mapping, set the DBM bit in the page-level
   PTEs if the block was software-writable and HDBSS is present.

That way you'd have sufficient metadata in the PTE to safely set DBM. We
could even make use of that metadata for write faults on non-HDBSS
hardware to avoid the overheads of user_mem_abort() (e.g. VMA lookup)
and treat it more like access flag updates.

The last point still needs some thought.

Thanks,
Oliver
