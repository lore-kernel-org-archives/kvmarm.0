Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD4F221264
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757713938; cv=none; b=NeJXv6aym6iGGejVZMTqxajAEA0gKXVCzAbCjNkEqJmTA+P7Xt6eLhcmjHM7gQwE9pfMkntd4I2vSoNzLn46FwbOnZ6KhXFWyZnlpjZ160ED3GThOXkPlZy2LPobWvh4ca/HxumvQHLvgkGeZl48B1TWAVlsmvJ7li2rORT0LfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757713938; c=relaxed/simple;
	bh=UooGI52nlAQgeeftc3z/f9MMFmjSDsxj3ij5l6I4URY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XumMr+Qtizg1l7gINIQKA99iQJb/x6OA1J9x6TW2fv/19q5wT8IOEk9a7r/d/gOyJ4Rl7gHUtOAf9WdwfmEeNekT2TOX9Q8gYB00iJ0C+MlIkz8dXu1boH8FcIGEj3o87B/JCZl42kMdpduFZdJC+UuuOOYYapqDNbKlRW0DPUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RBdbbhgj; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RBdbbhgj"
Date: Fri, 12 Sep 2025 14:51:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757713924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KeZJskDrLdyI31cFaw160l4iI66D6Vs9RjJCvNrmuS0=;
	b=RBdbbhgjcHEyfj2dOzPwo9K7/WXxmFcSrY5PcSj9ybaMhFFXF4ySWXr2Xfqd3wqlxQDaA9
	ZwlGCinuMV3u8Hu53xZR/N5pdVHx9aqpV1aJoKSTT00Rug9BB7k1PldTYm66ontUvmhLUG
	MRPF9Ff8BZvypxYSFejo8gfph6/R7Dg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jinqian Yang <yangjinqian1@huawei.com>
Cc: yuzenghui@huawei.com, maz@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, liuyonglong@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH v3 1/2] KVM: arm64: Make ID_AA64MMFR1_EL1.{HCX, TWED}
 writable from userspace
Message-ID: <aMSV_tLO-W4VKYRX@linux.dev>
References: <20250911114621.3724469-1-yangjinqian1@huawei.com>
 <20250911114621.3724469-2-yangjinqian1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911114621.3724469-2-yangjinqian1@huawei.com>
X-Migadu-Flow: FLOW_OUT

Hi Jinqian,

On Thu, Sep 11, 2025 at 07:46:20PM +0800, Jinqian Yang wrote:
> Allow userspace to downgrade {HCX, TWED} in ID_AA64MMFR1_EL1. Userspace can
> only change the value from high to low.
> 
> Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 82ffb3b3b3cf..db49beb8804e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3002,8 +3002,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  				      ~(ID_AA64MMFR0_EL1_RES0 |
>  					ID_AA64MMFR0_EL1_ASIDBITS)),
>  	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
> -					ID_AA64MMFR1_EL1_HCX |
> -					ID_AA64MMFR1_EL1_TWED |
>  					ID_AA64MMFR1_EL1_XNX |
>  					ID_AA64MMFR1_EL1_VH |
>  					ID_AA64MMFR1_EL1_VMIDBits)),

I still have a bone to pick with Marc regarding the NV implications of
this :) Attaching conversation below. Although for non-nested this LGTM.

On Tue, Sep 09, 2025 at 11:10:28AM +0100, Marc Zyngier wrote:
> My concern here is the transitive implications of FEAT_HCX being
> disabled: a quick look shows about 20 features that depend on
> FEAT_HCX, and we don't really track this. I can probably generate the
> dependency graph, but that's not going to be small. Or very useful.
>
> However, we should be able to let FEAT_HCX being disabled without
> problem if the downgrading is limited to non-EL2 VMs. Same thing for
> FEAT_VHE.
>
> What do you think?

So I'm a bit worried about making fields sometimes-writable, it creates
a very confusing UAPI behavior. On top of that, our writable masks are
currently static.

What if we treat the entire register as RES0 in this case? It seems to
be consistent with all the underlying bits / features being NI. A
mis-described VM isn't long for this world anyway (e.g. FEAT_SCTLR2 && !FEAT_HCX)
and in that case I'd prefer an approach that keeps the KVM code as
simple as possible.

We do, after all, expect some level of sanity from userspace of feature
dependencies as we do not enforce the dependency graph at the moment.
Hell, this could be useful for someone cross-migrating a nested VM from
a machine w/o FEAT_HCX to one that has it.


Thanks,
Oliver
