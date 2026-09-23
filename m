Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941E55326D2;
	Wed, 23 Sep 2026 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790170225; cv=none; b=nlKsvtXl/0tW5dzSk+rQsdzv4lX6wXpfdSNJ/pdRYZmVbnNASj+PqP3X8k4DxBeR9In7FPluQhUKGJIIe/LlWAiUS2Iie4HP0BiZg7fAbw6WITLfiKb6qV8PeF99woPSFXzqx8Q147YKgOscNgwrO050WwscqXKIN8kf+wRqt64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790170225; c=relaxed/simple;
	bh=oXYh4IkYQ+XabqSw/bucxzadbAOaFPdMa3dqqn9RxvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ISkf7ZT7Vhfp+lMe3v/8rpwj+syKn3yKnPx/hnkr4LmlJPHCYdJBPcQVJHqZEnDmGp8q//b2gTcYLARypJKn51OL2Xr4WUlPiGWz2GzjVXGb5Wm9HfDE2VMfzk/QtmC5PXII9ZtJnSh/lw0lLbRTyzk3EbKz6g+TCNmXuw9E5VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3/2fGhW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3/2fGhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A308E1F000FF;
	Wed, 23 Sep 2026 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790170222;
	bh=oXYh4IkYQ+XabqSw/bucxzadbAOaFPdMa3dqqn9RxvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X3/2fGhW4QV58LV2DE1YeQu00ts8v4E4IvR9766pi7WjFwuvQbFeDr2qfjU8WmL42
	 Xok6NMR/bm8HMNGmB+SrgB38frIhfUS/Q8SMIbLCXMfKaWvITfBCDzTZMM1/lhwyek
	 S3vicvvn4rZUoVrTEDoAEBoo/k+fmh1ZGR8OdJoYGUeVMLSm2NV1FPZpikMOwFbEvr
	 fwWVfvPG4/N7/bTQmlkg7cQYbkpdUs/hffzKutGCi2xijfEr0vBBWsuV6e3XeEqyJY
	 OG05Tc8t5t7EtW9ih4cvy2kKB4dM4rJHylAoiE6veSKXYgNAZh0UdVJh4n/erNkG7g
	 kPU2L7nnR6XgQ==
Date: Wed, 23 Sep 2026 14:30:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: sashiko-reviews@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 07/14] KVM: arm64: Size the stage-2 memcache from the
 fault MMU
Message-ID: <arPUT7DyofLwFhjt@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-7-787bd3bc7e3f@kernel.org>
 <20260922143157.0E84B1F000FF@smtp.kernel.org>
 <CA+EHjTziT=qEvCpjGriVhC5g7=nyQNfvEQenw-JXSJuWtJwTRg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTziT=qEvCpjGriVhC5g7=nyQNfvEQenw-JXSJuWtJwTRg@mail.gmail.com>

On Wed, Sep 23, 2026 at 12:00:55PM +0100, Fuad Tabba wrote:
> Hi Lorenzo,
>
> On Tue, 22 Sep 2026 15:31:56 +0100, sashiko-bot@kernel.org wrote:
> [...]
> > Does this decoupling of s2fd->mmu and vcpu->arch.hw_mmu cause a spurious
> > allocation downstream in kvm_s2_fault_map()?
> [...]
> > Could this lead to an unnecessary allocation in the ioctl path that might
> > spuriously fail and return -ENOMEM to userspace?
>
> Sashiko might be right about this one, though the mismatch comes from
> patch 5 rather than this patch: patch 5 moves kvm_s2_fault_map()'s pgt
> to s2fd->mmu and leaves the allocation check above it on
> s2fd->vcpu->arch.hw_mmu. Could patch 5 switch that check to s2fd->mmu
> as well, the way gmem_abort() tests pgt->mmu?

Yeah oops, will do that for v4.

>
> This patch looks fine to me though.
>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Thanks!

>
> Cheers,
> /fuad

--
Cheers, Lorenzo
