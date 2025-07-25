Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9553D3BBF2;
	Fri, 25 Jul 2025 16:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753461537; cv=none; b=YjLR4Vvsd93S5FBvZIzXq70INHBb9xxgno438wDYscABca76Zm+RAtg+JyP1AbI0AQuT6yintnfLCTHStERAGDmeRzqEa236Hi+RjMy58zkqWWjkRPhIPf/FFddtb/hQNTqT/abNyB6TczbV7UHqtKrtRnqmM7F7LRokSSzBc3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753461537; c=relaxed/simple;
	bh=ph09R88EGj0H43KIRGl9OnKpp1uyR+qA9PEna2s/QNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYYeLy7WZHHTwc1c/M2COHwXAEg/gHBjPqgi/bkFQ0gq5UqSfxWEazr9I1Cn8rbGp6itf+Xvxy6sek6qhbSlC82ydUkcQqCBE52WbimYjBLWGxzx9G6MfRMyziK0KqS4JaWVNpTw8yodaAm1p+qb6RnOVdm1QP1SYoCdyOO4kiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/3owUOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/3owUOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292A6C4CEE7;
	Fri, 25 Jul 2025 16:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753461537;
	bh=ph09R88EGj0H43KIRGl9OnKpp1uyR+qA9PEna2s/QNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r/3owUOetdGfJ7NIolrwZMMOxRlDHBwquuCvs3fYNgdlE2+s8SrMe8N7hMu5JJ0ow
	 /ZSz+d6zYcTZgVq3fXq12zRN68fSteTIG+YZuZgHFb1Y2NZwlTz0aXkGzTnLzICNZz
	 agu2z5TUwRfLzLCs2DoHCEbueY0ip/cwCXEUqR1LOUOd7aHYtd7nfm0H1i5Lr1OR2+
	 fHQ+sfSBfvmQld5NyMrp8iwsHrEFcEOCRDX13kdNHhj8c+tZJFNyGTE0a/Eta35aPU
	 ioYtyNmXsuDO+cSmQVU54BwWFBJllFSsUzsc1PrAwLU4ia/+Lk8ST893Eqh525HBxB
	 phA7AsoV+ZP8w==
Date: Fri, 25 Jul 2025 09:38:51 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
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
Message-ID: <20250725163851.GB684490@ax162>
References: <20250724-b4-clidr-unint-const-ptr-v1-1-67c4d620b6b6@google.com>
 <2025072553-chevy-starter-565e@gregkh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025072553-chevy-starter-565e@gregkh>

On Fri, Jul 25, 2025 at 10:58:05AM +0200, Greg KH wrote:
> On Thu, Jul 24, 2025 at 06:15:28PM -0700, Justin Stitt wrote:
> > A new warning in Clang 22 [1] complains that @clidr passed to
> > get_clidr_el1() is an uninitialized const pointer. get_clidr_el1()
> > doesn't really care since it casts away the const-ness anyways.
> 
> Is clang-22 somehow now a supported kernel for the 6.1.y tree?  Last I
> looked, Linus's tree doesn't even build properly for it, so why worry
> about this one just yet?

Our goal is to have tip of tree LLVM / clang be able to build any
supported branch of the kernel so that whenever it branches and
releases, the fixes for it are already present in released kernel
versions so users can just pick them up and go. We are going to have to
worry about this at some point since it is a stable-only issue so why
not tackle it now?

> > Silence the warning by initializing the struct.
> 
> Why not fix the compiler not to do this instead?  We hate doing foolish
> work-arounds for broken compilers.

While casting away the const from the pointer in this case is "fine"
because the object it pointed to was not const, I am fairly certain it
is undefined behavior to cast away the const from a pointer to a const
object, see commit 12051b318bc3 ("mips: avoid explicit UB in assignment
of mips_io_port_base") for an exampile, so I am not sure the warning is
entirely unreasonable.

Cheers,
Nathan
