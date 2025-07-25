Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6CB2EE5F6;
	Fri, 25 Jul 2025 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463288; cv=none; b=ro55/MtgOx3S05jvoy5lGfbrKKy4L4qJEX24L0nRacIM30M195EDAFkHerdwHHFsDJ3tIkbO9WEHF37bwkJsWXARd3Lfux54FdgEeHZQyxA+RxW8O3mr6xYMyr1eQnUmOg8iJj3/n4HoPK5FUxB1qktTM+pxitteOhkpdkLRu6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463288; c=relaxed/simple;
	bh=eEiIL0rv55Mb2Vf0/AmSi7VJDqvdOD9ADdquhg19Z44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8kIN+/Y7k9o49XzpYBr36hhuFkXyvhjNPnQDHeqxJnCO0DNN4F2m9Y6JuvgxRzyD1JM6b096mUFzOKoOLjc8hmez4aGw4VISOekXZzJBVh+aVO3odW4nrpJ4QJukJdvJlEWAhdSOt+vjeG6hXO+gt4Vwxb6QMZhe2hPVrTuk2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqns/GEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqns/GEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3832BC4CEE7;
	Fri, 25 Jul 2025 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753463287;
	bh=eEiIL0rv55Mb2Vf0/AmSi7VJDqvdOD9ADdquhg19Z44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zqns/GEB3bmWH+iIQWRad69gSqXISVZ56gvDEmAHEGZ+iO2A8kwbdAAR3JUSJ0Go6
	 YBqyQFLrgTFdlcgFa21yjYMkzKEcJOXcZ2OgimQgjqA9jXUj5DTSMhEClqto1FqL0M
	 b26HA8kAP3Y1At2Q4c6tVwgJufnh9R6TsVr//u8w=
Date: Fri, 25 Jul 2025 19:08:03 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Tom Rix <trix@redhat.com>,
	Christopher Covington <cov@codeaurora.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 6.1.y] KVM: arm64: silence -Wuninitialized-const-pointer
 warning
Message-ID: <2025072504-easel-propose-0474@gregkh>
References: <20250724-b4-clidr-unint-const-ptr-v1-1-67c4d620b6b6@google.com>
 <2025072553-chevy-starter-565e@gregkh>
 <20250725163851.GB684490@ax162>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250725163851.GB684490@ax162>

On Fri, Jul 25, 2025 at 09:38:51AM -0700, Nathan Chancellor wrote:
> On Fri, Jul 25, 2025 at 10:58:05AM +0200, Greg KH wrote:
> > On Thu, Jul 24, 2025 at 06:15:28PM -0700, Justin Stitt wrote:
> > > A new warning in Clang 22 [1] complains that @clidr passed to
> > > get_clidr_el1() is an uninitialized const pointer. get_clidr_el1()
> > > doesn't really care since it casts away the const-ness anyways.
> > 
> > Is clang-22 somehow now a supported kernel for the 6.1.y tree?  Last I
> > looked, Linus's tree doesn't even build properly for it, so why worry
> > about this one just yet?
> 
> Our goal is to have tip of tree LLVM / clang be able to build any
> supported branch of the kernel so that whenever it branches and
> releases, the fixes for it are already present in released kernel
> versions so users can just pick them up and go. We are going to have to
> worry about this at some point since it is a stable-only issue so why
> not tackle it now?
> 
> > > Silence the warning by initializing the struct.
> > 
> > Why not fix the compiler not to do this instead?  We hate doing foolish
> > work-arounds for broken compilers.
> 
> While casting away the const from the pointer in this case is "fine"
> because the object it pointed to was not const, I am fairly certain it
> is undefined behavior to cast away the const from a pointer to a const
> object, see commit 12051b318bc3 ("mips: avoid explicit UB in assignment
> of mips_io_port_base") for an exampile, so I am not sure the warning is
> entirely unreasonable.

Hah, we've been doing that for _decades_ with container_of(), so if that
is UB, and the compiler can't handle it, I'd declare that a broken
compiler :)

Look at e78f70bad29c ("time/timecounter: Fix the lie that struct
cyclecounter is const") in linux-next as one example of me trying to fix
that mess up.  It's going to take a bunch of work to get there, but
eventually we will.  We will not be backporting all of those patches
though, that would be way too much work.

Anyway, as the maintainer doesn't seem to want this, I guess I'll just
ignore it for now?

thanks,

greg k-h
