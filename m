Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CDC57F74C
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 20:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790195014; cv=none; b=C49FO0TLqzoTkgCOxBXnNwc0vIAQ7tQg82Os/OkEXDOZXN3MEDyR4pEkRPwRx0Z8jwoYyKnjEaZqNytOo4dW54rJets0hOiNhnp/kB+/Kmomrlc1SuBANcW38nIbXmiLcA1tzb+tPr5WFdKi/vEFdcgmWoh6oDtZTkjCItLvMV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790195014; c=relaxed/simple;
	bh=UFFtPEpyDLeXh+0+VyaxHYcK70Pz8EgZ5FURss4FQ9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NOjSw73X2/in3V279ARz4Pk7iJdVlsYSANW1AD8eU/2GNNDsCJjjIJTtXesFzjUlip7hzkMNYuYfGB952a9dylYMsVTPIFGXoIO7nmKosLE7aorMOy2oZfTupLJoIPuvKVoZZjXs0YS277KG1abu1wIcShI+ra4vof19MmJSC7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPAMB2lk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPAMB2lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409351F000FF;
	Wed, 23 Sep 2026 20:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790195003;
	bh=4OWaYSDuW0vcQmV3LmjyoYmrHXT7n0MPJe/ZEXVHN9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GPAMB2lkru9NBrpxoY5s8XmyTZtT2+DbA1RHZhvOwTS0lRJXH11ICv427yqk28y/6
	 2hNuYbLf2ovOeOWV8Ev1CWM183qhs2HJECsprbVA/10WF8oC4fQQMwZzwpfe0xWsiE
	 JYjmDVMzTYgpjNRTjt7M/sIcyWFUelTPVPVByT30BkW5yjMvmta2vhtsYG4QVXlbCg
	 T5OVTOs9Xc078xxE0COzwscGJYIH1+kV0kMNvMjeaca7oT81PWFv9uNTf+C4jkaAhh
	 /RtsDBHUCeLsVXQggcjgtgvsOP6nUdcG0WSS2fX7//PSBQMcpm2wcl0CmUVotYLPlL
	 56Ic/ZUriU0LA==
Date: Wed, 23 Sep 2026 13:23:22 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 11/22] KVM: arm64: Use a struct for stage-1 walk context
Message-ID: <arQ1OiEQjAtWwiDy@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-12-oupton@kernel.org>
 <arQGa54nNYBokQ8F@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arQGa54nNYBokQ8F@LeoBrasDK>

On Wed, Sep 23, 2026 at 06:03:39PM +0100, Leonardo Bras wrote:
> > @@ -482,15 +490,15 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> >  	while (1) {
> >  		u64 index;
> >  
> > -		va_bottom = (3 - level) * stride + wi->pgshift;
> > +		va_bottom = (3 - ws.level) * stride + wi->pgshift;
> >  		index = (va & GENMASK_ULL(va_top, va_bottom)) >> (va_bottom - 3);
> >  
> > -		ipa = baddr | index;
> > +		ws.desc_ipa = ws.desc_pa = baddr | index;
> >  
> >  		if (wi->s2) {
> >  			struct kvm_walk_access s2_access = {
> >  				.type	= WALK_ACCESS_S1PTW,
> > -				.ia	= ipa,
> > +				.ia	= ws.desc_ipa,
> 
> I only see desc_ipa being used here, and at this point, desc_ipa is the 
> same as desc_pa, and we are copying it's value to this new struct.

This distinction is intentional, we overloaded @ipa to mean either the
IPA of the descriptor or the PA of the descriptor depending on the
presence of a stage-2 && where we are in the PTW.

I'm happy to burn another 8 bytes if it means the code is legible and
more easily debuggable with something like bpftrace.

> Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!

Best,
Oliver
