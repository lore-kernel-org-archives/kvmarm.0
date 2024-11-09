Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4D1194AFB
	for <kvmarm@lists.linux.dev>; Sat,  9 Nov 2024 23:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731196000; cv=none; b=IsP9i2uuc5ktlaUeCpnKeDTHtZDv6HRW8wcbjGNccHfOGSUBsjNDNu/n/BK58GoFaaZ43fddsb7bpl9vMTIta3fU9KLz733s9APdvb7x2dM2MnU5R1PaIgUVYynMVLprXUQxRJtL5Yb934/Zx2DWLeByFLJoE3t/VXLwEIt3yig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731196000; c=relaxed/simple;
	bh=6/+8NvmCqtk8DnYrU9M5xA9am8brQT05BjwTL4/85cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cqImXOSSzbkjfmc1Jzf9b17Tg87SIBz79Wv4EuSxLIw9PUDi+teaHMWZE+2AMxS2Ar9Pxcu3Ja9EgRB9S6JPvxEQqM4xe0vmHFzmygB/in1CSTjb2W3zkFIBIqizhXYckiN7jAtJV4AF2UKJlQoWilbhbb7gTGfvaAChxKt8+Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hyZFYf0Q; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hyZFYf0Q"
Date: Sat, 9 Nov 2024 15:46:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731195994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZPnxbwiatu+anfTRV+//m+rlFka0SdhYTuAid7SQpGg=;
	b=hyZFYf0QD5aJ7oGkaN8KpBl8RRVTCWE1OA5zJDduDQCfLgYMA7X/+GJF4G1xowBoVLNMxv
	i4P9VI6TIq/rzxJGiv+IwFdyBb8L6guJEBYHOTrINyxPe++XcE+MNqi1iQztHiD3bKedQK
	9znonSFJDzdt+y7UvOaCiefCbO6j7kA=
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
Message-ID: <Zy_0T00hOjVfmKTz@linux.dev>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
 <20241108222418.1677420-12-oliver.upton@linux.dev>
 <86y11szjwk.wl-maz@kernel.org>
 <Zy-Zbj_BYovU5qch@linux.dev>
 <87bjyot4n6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bjyot4n6.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Nov 09, 2024 at 10:37:49PM +0000, Marc Zyngier wrote:
> On Sat, 09 Nov 2024 17:18:38 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Sat, Nov 09, 2024 at 12:11:39PM +0000, Marc Zyngier wrote:
> > > >  static bool trap_debug_regs(struct kvm_vcpu *vcpu,
> > > >  			    struct sys_reg_params *p,
> > > >  			    const struct sys_reg_desc *r)
> > > >  {
> > > >  	access_rw(vcpu, p, r);
> > > >  	if (p->is_write)
> > > > -		vcpu_set_flag(vcpu, DEBUG_DIRTY);
> > > >
> > > >  	kvm_handle_debug_access(vcpu);
> > > 
> > > Something has gone wrong here, and I don't think you wanted to make
> > > the ownership conditional on the access being only a write.
> > 
> > That's very much intentional (probably not clear enough in changelog). I
> > don't think there's any value in special-casing this to writes.
> 
> Look again. You *are* special-casing it by only dropping the
> vcpu_set_flag() call. Hint, the indentation is misleading.

/facepalm I clearly can't read... or code.

Thanks for spotting that one.

-- 
Best,
Oliver
