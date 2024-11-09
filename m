Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F3CECF
	for <kvmarm@lists.linux.dev>; Sat,  9 Nov 2024 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731172729; cv=none; b=DmSk9vSwS2t0AJPWqRfp2WZ/b8SioRNXHsdgh3/xI2wE1m6qQQCcj+gic009u7WPu7HQDTyoqRvAI0Jv9bezd3QspZUK2DHawVwVeBfjV49mu7ViaamPjeacUzUG5KMg7k52S2lJK3mDuDyptg5ZPKJDpZapDfZ5gsCOyVnSMZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731172729; c=relaxed/simple;
	bh=aHMm2YDowCIBqY+mochksI0tJh2fhEbTmW7cUUY42kw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tzMbpD6sWO0yWwFN3UHlJ3PWXSdSl5yyeR4e79+/ikHjRrwbbCZ6yCkSpCtjWrKymeMcUwNtHYHwaTeYJq9hjUxk0p4plurGxFVcX2oN/I7FJrV2hJaEsrSTSCuO47R9eM/QLBpOIU8gAXE7Jx2/19RS9rQ3DlNOWB0eE542d/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eoy8wOPJ; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eoy8wOPJ"
Date: Sat, 9 Nov 2024 09:18:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731172724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f4XPlEhpVkYJjot+wr8lH3+lPUuZZC6+BDuoFXuZBow=;
	b=eoy8wOPJx1XLt2dACPm4XkT46CTReXYw7V9gXB1pap+izFF7JoY1Uq3HfUlUEKp6C9l2OI
	Me4OuHvlNHkna1edV6c7Uu2DQ7SQI37YnNasb+DxU8izj0JF5GHfx5F8cM8d5DUkVCWGES
	YwbQ+8Hej2zWaUShVp3K/gqGHBrrQSA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 11/15] KVM: arm64: Use debug_owner to track if debug regs
 need save/restore
Message-ID: <Zy-Zbj_BYovU5qch@linux.dev>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
 <20241108222418.1677420-12-oliver.upton@linux.dev>
 <86y11szjwk.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y11szjwk.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Nov 09, 2024 at 12:11:39PM +0000, Marc Zyngier wrote:
> >  static bool trap_debug_regs(struct kvm_vcpu *vcpu,
> >  			    struct sys_reg_params *p,
> >  			    const struct sys_reg_desc *r)
> >  {
> >  	access_rw(vcpu, p, r);
> >  	if (p->is_write)
> > -		vcpu_set_flag(vcpu, DEBUG_DIRTY);
> >
> >  	kvm_handle_debug_access(vcpu);
> 
> Something has gone wrong here, and I don't think you wanted to make
> the ownership conditional on the access being only a write.

That's very much intentional (probably not clear enough in changelog). I
don't think there's any value in special-casing this to writes.

If memory serves, Windows saves/restores the entire set of debug registers
rather frequently, and imposing a read trap storm on the save implementation
feels like a waste of cycles.

-- 
Thanks,
Oliver
