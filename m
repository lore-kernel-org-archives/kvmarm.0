Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795786182;
	b=QLG+fxq7R2RkoFJGnL5owwDqIptj+YoSIbstq6edMO20Rn+FVCDLSSFrSIue8wPVzZK5
	 +f9OvRGTXkFIOxmRlzABPGId2Y1H92Hy3WCIftCPD8AS2eT3yQs7LPMU94yz0Crxspxsk
	 SGYlhrj1ekgVzkOU4v6mUHnEMvaDQDIo7F2L6XwZrRw/LYAjMSlMPsR1hEoSiCgNkucO5
	 6xXw2t7sTJHtgST+NCXWXcQefteGR2LzsuUkzy108x153I+skUuPT/x+HVMg60TbLoq0Z
	 Aq5BA4S3aKO6VDV65tWV2j6Ojak/ott2PE/AKG7xaHMJfZyQpD9yVPI+g/QTMpXNa2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795786182;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ck511kPGuCN62RAGxAOqUpqHEHpgf3t/JnukiZZYPXo=;
	b=hcvurQLpBnbPIrbIy8+xrqW1hMhz3SWlIB+ht2jqH36k3QPqIOe25biQDIMz0Bvg28k9
	 U531JKdKCVsrJAAppFnq/pk2mzxM7j8ZgHwBIvOgGbbtr862doCQYuUmS9zZxd9ot+6r/
	 C5I/EOUAFFchzSItz7ty3SrWzrH332A+LonfdeSI0RiWsT5zqE9TnAWJY4FOQex2iEpyO
	 YtYpgPtuGZpHqcDw/q0Gging8joyWkA0cuEWdVjxzq8DpIH3sAocmayfrM/W4bks6eRjG
	 uIq7lGL/Tsa095/UTUJ0siyj//Obrj13PhOOkj5yt+matukXNnXL8aP1a5A5OXINncw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UTmdAnrv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFD2606A31F;
	Fri, 27 Nov 2026 13:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UTmdAnrv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F771F00893;
	Fri, 27 Nov 2026 13:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795786181;
	bh=ck511kPGuCN62RAGxAOqUpqHEHpgf3t/JnukiZZYPXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UTmdAnrvkcqZhhQSlkZefNubbNcDOW2d97b4Mu5o45a6thUKJZZUUaSn3NwMlFZDm
	 cgRXG43KVWU+M/oultDInN3nc+9pkCtnk5eaZ4h9APxPtV2kNGoQccYx9pRwaw2YbG
	 McXz0HvM/yGG2kVd3sI7QW0hCo2ZXcn4Zg17jh38yeP9Bi+77NFh1ysMLk8sxqq3Ep
	 GGe1GVKMOxaGVa9y9/sQOEaGekUnDq0S0kcaeJRbVwyuaAxRUiW2AcxSxqoOHfIWs3
	 l1IOp80Jvp3In+thI3vHGu3j35yffbUyZQC7FSfaD7FL9a477xf0R6FYfFt/Cp0tt5
	 2weIS/DJ5/j6w==
Date: Fri, 27 Nov 2026 13:29:33 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Wei-Lin Chang <weilin.chang@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	rkeilty@meta.com, atish.patra@linux.dev, dgreid@meta.com
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
Message-ID: <awmDZoqzL_t6A7go@gremlin>
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <awcXhk885lqDRAHy@LeoBrasDK>
 <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev>
 <awcoCklLOKeuXPhh@LeoBrasDK>
 <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev>
 <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq>
 <awhH1Dpu0uIwP6ea@gremlin>
 <awh5pmXCbNoFP5Ez@LeoBrasDK>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awh5pmXCbNoFP5Ez@LeoBrasDK>

On Thu, Nov 26, 2026 at 06:25:43PM +0000, Leonardo Bras wrote:
> > > > diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
> > > > index 9a126b9e2d7c99..5b61285d317e28 100644
> > > > --- a/arch/arm64/include/asm/kvm_types.h
> > > > +++ b/arch/arm64/include/asm/kvm_types.h
> > > > @@ -2,7 +2,12 @@
> > > >  #ifndef _ASM_ARM64_KVM_TYPES_H
> > > >  #define _ASM_ARM64_KVM_TYPES_H
> > > >
> > > > -#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> > > > +#define KVM_PGTABLE_FIRST_LEVEL		-1
> > > > +#define KVM_PGTABLE_LAST_LEVEL		3
> > > > +
> >
> > The -1 isn't needed here at all right? So why not just import
> > KVM_PGTABLE_LAST_LEVEL and do:
> >
> > #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE       KVM_PGTABLE_LAST_LEVEL
> >
> > ?
>
> Well, it kind of is :)
> The lowest level we have in a PGTABLE is level -1. (See RKSBQV)
>
> It could now be mathematically correct, but it could break in the future if
> we got a level-2, for instance. We could have (LAST - FIRST - 1), if that
> one page makes any diference.

Yup it's level -1 but isn't that only something meaningful for stage-1 I believe
due to concatenation? As per stage2_pgtable_levels() [where ipa is the number of
bits not the ipa... :)].

But you make a good point re: future changes!

Anyway, Marc has made it clear he wants something based on
kvm_mmu_cache_min_pages() at runtime, so it's all moot anyway, this needs to be
reworked for that.

Usama - I assume you are looking at that now?

--
Cheers, Lorenzo
