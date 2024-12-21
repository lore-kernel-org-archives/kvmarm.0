Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35071D5CDD
	for <kvmarm@lists.linux.dev>; Sat, 21 Dec 2024 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734818331; cv=none; b=FljhJ2L+YdhfgdczdhWajznl2KuSfmSdBGyiZHsiVwroAMv/QnBLad0g0n3rj/x1NAKOLMD+H69shOmpqwb88zNX66uuaj1vjBxynNKhQOl7LKZzLTlNMDiDo/ysqhcfrNBd5c2wzPYeGtVZXTgUJQ1L/AMojnnyb/xrmQY3Ix4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734818331; c=relaxed/simple;
	bh=YmqEabFpC/1TJIUM0H58+TKJqMOxL0YYqTaF+I7Yf14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGr27ddMYWIVr0zWlOQIWqG6U3Lv6OENM+thpGxIAVbppzD/9k9K27oIpc6C1CKfdL6xpZNzo5p5HEFm1WaB74C+JxXVnHzjOjd/xAjqbLKeW2hVejEyo0FNjjqIqWdsnLlik4MWcgUXeW+/KpEgp0DM1DZ1TAoBrpB0J/8gTX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EknnvT+C; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EknnvT+C"
Date: Sat, 21 Dec 2024 13:58:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734818325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UIxrn6gDBkTgraPiBRw+gNRB2bS9Ks0FdtrVzsG+Kzg=;
	b=EknnvT+CTw9gKiB+Xw7ZwYqNKELcHsd1ZsrQW01NthyXKt6fZ8ZuruypV3qFto2Yo3HWBF
	x/2xL5NOOEIZ0/dOeExugYmjUfks51yPerp3hxDq3lbLaV5HjdeRZd/9nQSTYwnB/y5cVA
	tTn4uvrsgtx/rfcl0q+YMkhERjk6BDI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v2 01/12] KVM: arm64: nv: Add handling of EL2-specific
 timer registers
Message-ID: <Z2c6DJYW1_sSbFIw@linux.dev>
References: <20241217142321.763801-1-maz@kernel.org>
 <20241217142321.763801-2-maz@kernel.org>
 <Z2Yb8BWnqpt441V-@linux.dev>
 <874j2xs6hz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874j2xs6hz.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Dec 21, 2024 at 09:57:44AM +0000, Marc Zyngier wrote:
> On Sat, 21 Dec 2024 01:38:28 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Tue, Dec 17, 2024 at 02:23:09PM +0000, Marc Zyngier wrote:
> > > @@ -3879,9 +4020,11 @@ static const struct sys_reg_desc cp15_64_regs[] = {
> > >  	{ SYS_DESC(SYS_AARCH32_CNTPCT),	      access_arch_timer },
> > >  	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR1_EL1 },
> > >  	{ Op1( 1), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_ASGI1R */
> > > +	{ SYS_DESC(SYS_AARCH32_CNTVCT),	      access_arch_timer },
> > >  	{ Op1( 2), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI0R */
> > >  	{ SYS_DESC(SYS_AARCH32_CNTP_CVAL),    access_arch_timer },
> > >  	{ SYS_DESC(SYS_AARCH32_CNTPCTSS),     access_arch_timer },
> > > +	{ SYS_DESC(SYS_AARCH32_CNTVCTSS),     access_arch_timer },
> > >  };
> > 
> > Huh. You know, I had always thought we hid 32-bit EL0 from nested
> > guests, but I now realize that isn't the case. Of course, we don't have
> > the necessary trap reflection for exits that came out of a 32-bit EL0,
> > nor should we bother.
> > 
> > Of the 4 NV2 implementations I'm aware of (Neoverse-V1, Neoverse-V2,
> > AmpereOne, M2) only Neoverse-V1 supports 32-bit userspace. And even
> > then, a lot of deployments of V1 have a broken NV2 implementation.
> > 
> > What do you think about advertising a 64-bit only EL0 for nested VMs?
> 
> I'm completely OK with that.
> 
> Actually, we already nuke the guest if exiting from 32bit context, no
> matter the EL (vcpu_mode_is_bad_32bit() is where this happens).  But
> we're missing the ID_AA64PFR0_EL1.EL0 sanitising, which is a bug. I'll
> send a patch shortly.
> 
> Now, for this particular patch, I still think we should gracefully
> handle access to the EL1 timer from a 32bit capable, non-NV guest.
> Just in case we end-up with a CPU with a broken CNTVOFF_EL2 *and*
> 32bit capability.
> 
> In the end, it doesn't cost us much to support this case, and it helps
> that we can verify that we handle all registers without exception.
> 
> Thoughts?

Absolutely. The only reason I made the comment is because the 32-bit
changes had nudged me into thinking about it. Happy with the patch as
is.

-- 
Thanks,
Oliver
