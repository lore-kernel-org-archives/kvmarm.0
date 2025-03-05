Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133AB16426
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 18:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741199768; cv=none; b=LKxaAccXLol98MuF98hkiIhAOp48QmYQwuO8dHtIKfg7pDBu4wJgHMr58QtaZN0UL2YCiHayUvdQu0V4fUX1ETNtNiVpztJJg3ATGxprKbAnibZPajp7IHGmIDVPCis18QxnTya2oxNBQm3Ana0G4vVChV5Xskglp8HcjVWdEJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741199768; c=relaxed/simple;
	bh=jWgHSsvysebCfA2IEKJdsbWxkPfFdu8pzBR+/gIGIoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hx5UXrCiV5/g18vts1Jkz+bqdyCnzSGpFFCr/xGvH3dkbQd/lHZKP9avFRlRxwHEETcamb7sBrExlhkQpE0HEC9I4ia6JVnTNdOcCYgR/xDP8GRae6nBzpCIapQG0sOqLd5P/GKR/3NI2W74OFPbL5KRMlh5NDtoTbpq93KjqlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JFR1AeB1; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JFR1AeB1"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43ba8a87643so5775e9.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Mar 2025 10:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741199764; x=1741804564; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a2OFT2OoedTJTEmeRVIN9FPGz/gwRD13KVUXjlzrTxU=;
        b=JFR1AeB1F2C7ClUlmnXHtjq5k0CZcI5QCxLyIiAWnaVL1ABCP2+U9QyZaF/ieKjbbw
         vyEztd0cNx7Sf/pIikHk1cu8PZULNSI7/1iU19iJ9W0BkqVpYsZ4J6+L09OhladeSK4n
         y280svr6OyoXa1EWf8qb6fmMRFxspgCPG9GUKF4h1DbQkGE87qpYB5DVxW2ClP8KDqXc
         148pcNMn0iaq1riIkXjuo3xagdgy801MkhkMOqqk8TyoAcwoQdSjjrHBsA9KkDpArAQ9
         0jcN27kty0sEC9YswSneK/AfJptY3rGiM81IacDXaLknvml7tPPPcF/3CeSNRGxT/yQ+
         fddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741199764; x=1741804564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2OFT2OoedTJTEmeRVIN9FPGz/gwRD13KVUXjlzrTxU=;
        b=uqDtrSv9mvDInFPpFvFviGelZje12x9HWoQvbpL3PxvQCcdP8bsvWBiakMfmmxx2VF
         E8eYYFvfcsLefMOZP+y95BoJbQlG2rx8UnnvHPIqD4ynrjMmSwf9M1+NvRJ2Rhzzm1Gg
         gML2g+Qd/8DsLs8A9Q7KG3O0ZrxuL9j9h41Oby23S4iqLFPtzGHqEylMQedezrplkQ5p
         1GT0HzPrE7vbsS0eMjpvglks6miFL4HH/HJ0Qf/4hXEU5KOzOFvcd2O/FBiKJv4fFFPZ
         64J+jIX0++0FalDI0favyB22NL3IY+c3l5zIwjcmjuhGRW7Si7Pzlj0Xg+RL7Le5SpNO
         9Awg==
X-Forwarded-Encrypted: i=1; AJvYcCWcSEUeCc/sBlEfKAdV4g/rUWtGGUkakxUbPhIVXiyBXMmESnROIx66ee9cMP38mWz8G9Tal4M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaLESXu+XTasFWC9WB3fPmvl6sn1R3m4tokbxgWev7SagR1SNP
	AWQ0t9wTB25hGP8wNotwVQxo6TqirTYBVY6TW/qAXAcVZtVsirKY+Sx3mdeUDg==
X-Gm-Gg: ASbGncsTey6zBCKlbBwG2jav0MXpRJnLXTBrkOeb8LlcaxPeyozPtpJiFaZzy5f4KfA
	2Veb6mGGMDSUP2Tm6xdcs4JAF7GK9lYUxwf1sV3bttvvYIyti30wqvxq8j0/8eJCqUGvNMOLr86
	NVlZwNt7x0JSJ57Jmkp9sdBijAmdrkZaQ7gf7MVr0B8tHjihJO/za2z994fwQo5C3QJlTuGM4dw
	0cw8HyvJysYH2i0+WGNBivF/AWdJ7+clOtbFyLfX0pIvVQcXw12CEd9oM2z1boo10YmSBqNkHXd
	cGnDErrPwemOKym65UToo46BELVLcd3aEFso49wAFe2LUKrW2cTZfzzpZA+ndtPXArT3lya5Uir
	oL4tS/EL2RVUc
X-Google-Smtp-Source: AGHT+IGuoCdVlssAi/H3pLNOEjzh/d6m6UEnCFgp+MZSf4rv9zgHb14AznLZkDz+7g00rolvyanVzA==
X-Received: by 2002:a05:600c:22d0:b0:43b:bfe6:d898 with SMTP id 5b1f17b1804b1-43bdbac5f6dmr43995e9.0.1741199763997;
        Wed, 05 Mar 2025 10:36:03 -0800 (PST)
Received: from google.com (100.235.22.34.bc.googleusercontent.com. [34.22.235.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e4796600sm21673887f8f.20.2025.03.05.10.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 10:36:03 -0800 (PST)
Date: Wed, 5 Mar 2025 18:36:01 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Map the hypervisor FF-A buffers on
 ffa init
Message-ID: <Z8iZkQHknZfY7mpn@google.com>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-4-sebastianene@google.com>
 <20250303234259.GA30749@willie-the-truck>
 <Z8ZPBZF7J-qKdb_i@google.com>
 <20250304015633.GA30882@willie-the-truck>
 <Z8c6enoolJe7Zeqk@google.com>
 <20250305003808.GA31667@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305003808.GA31667@willie-the-truck>

On Wed, Mar 05, 2025 at 12:38:08AM +0000, Will Deacon wrote:
> On Tue, Mar 04, 2025 at 05:38:02PM +0000, Sebastian Ene wrote:
> > On Tue, Mar 04, 2025 at 01:56:35AM +0000, Will Deacon wrote:
> > > On Tue, Mar 04, 2025 at 12:53:25AM +0000, Sebastian Ene wrote:
> > > > On Mon, Mar 03, 2025 at 11:43:03PM +0000, Will Deacon wrote:
> > > > > On Thu, Feb 27, 2025 at 06:17:48PM +0000, Sebastian Ene wrote:
> > > > > > Map the hypervisor's buffers irrespective to the host and return
> > > > > > a linux error code from the FF-A error code on failure. Remove
> > > > > > the unmap ff-a buffers calls from the hypervisor as it will
> > > > > > never be called.
> > > > > > Prevent the host from using FF-A directly with Trustzone
> > > > > > if the hypervisor could not map its own buffers.
> > > > > > 
> > > > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > > > ---
> > > > > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 46 +++++++++++++----------------------
> > > > > >  1 file changed, 17 insertions(+), 29 deletions(-)
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > @@ -861,6 +842,7 @@ int hyp_ffa_init(void *pages)
> > > > > >  {
> > > > > >  	struct arm_smccc_res res;
> > > > > >  	void *tx, *rx;
> > > > > > +	int ret;
> > > > > >  
> > > > > >  	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
> > > > > >  		return 0;
> > > > > > @@ -911,5 +893,11 @@ int hyp_ffa_init(void *pages)
> > > > > >  		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
> > > > > >  	};
> > > > > >  
> > > > > > +	/* Map our hypervisor buffers into the SPMD */
> > > > > > +	ret = ffa_map_hyp_buffers();
> > > > > > +	if (ret)
> > > > > > +		return ret;
> > > > > 
> > > > > Doesn't calling RXTX_MAP here undo the fix from c9c012625e12 ("KVM:
> > > > > arm64: Trap FFA_VERSION host call in pKVM") where we want to allow for
> > > > > the host to negotiate the version lazily?
> > > > 
> > > > We still have the same behaviour where we don't allow memory
> > > > sharing to happen until the version is negotiated but this
> > > > separates the hypervisor buffer mapping part from the host.
> > > 
> > > Sadly, the spec doesn't restrict this to the memory sharing calls:
> > > 
> > >   | [...] negotiation of the version must happen before an invocation of
> > >   | any other FF-A ABI
> > > 
> > 
> > We do that, as the hypervisor negotiates its own version in
> > hyp_ffa_init.
> 
> hyp_ffa_init() only issues FFA_VERSION afaict, which is the one call
> that you're allowed to make during negotiation. So the existing code is
> fine.
> 
> > I think the host shouldn't be allowed to overwrite the
> > hyp_ffa_version obtained from _init, this feels wrong as you
> > can have a driver that forcefully downgrades the hypervisor to an old
> > version.
> 
> I think that's also fine. The FFA code in the hypervisor exists solely
> to proxy requests from the host; it's not used for anything else and so,
> from the host's persective, FFA should behave identically to the case in
> which the proxy is not present (e.g. if we were just using VHE). That
> means that we're doing the right thing by deferring to the host for
> version negotation.
> 
> Are you saying there's a bug in the current code if the host negotiates
> the downgrade?

It is an issue *only* for doing guest-ffa (which isn't posted here yet).
If we allow the host to dictate the version & there is an issue with TZ
FF-A dispatcher in that version => the guests will be affected by this
as well.

> 
> > We need to do three things, Sudeep & Will please correct me if I am
> > wrong, but this is how I see it:
> > 
> > - the hypervisor should act as a separate entity (it has a different ID and
> > in the current implementation we don't do a distinction between host/hyp) and
> > it should be able to lock its own version from init.
> 
> I strongly disagree with that. The hypervisor isn't using FFA for
> anything other than proxying the host and so we don't need to negotiate
> a separate version.
> 
> What would we gain by doing this? Is there a bug with what we're doing
> at the moment?

I think we need to make a distinction between the host and the
hypervisor when we are adding support for guest-ffa. We currently have
the same id (== 0) for both of them.

> 
> > - keep a separate version negotiated for the host
> > - trap FFA_ID_GET from the host and return ID=1 because
> >   currently we forward the call to the TZ and it returns the same ID
> >   as the (hypervisor == 0).
> 
> Why is this beneficial? It just looks like complexity at EL2 for no gain
> to me, but maybe I'm missing something.
>

Because the host can impersonate the hypervisor using ff-a direct calls atm.
and we are in a position to restrict the host from playing nasty games
with TZ.

> Will

Thanks,
Sebastian
