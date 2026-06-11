Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0D43BCD16
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 09:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781170233; cv=none; b=uAf7+TebUAGwjgTsZQvQAbuhmv63EJ4T0ILarwHiSUiFvFDLgtE9elV4/UXVRKJfEiQV+cQgZbZlj2ccnm5oLZjJzLp6ETboE/eqW4EdKCCMRwFF4lRIY+IPowH0S26/0oV/6HquT6YQlsO7PjvxM0iUoWktM/ZQDFtzl6Jxyzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781170233; c=relaxed/simple;
	bh=s7hBwMel7oALQbJ2W7oVVV7MTzlWhMwBYW3yS6EwLvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tms38p521ZURc+Xauy0w7qxTOVR1fzciYscGVznoZrBMMwW0ntzGzLEGJJN1dcTywOvVdumVPveYP33W4h2kUUn70A2JyO37LE0p7rDqv3JxbQVcQY9OPkyH0rMp2Fzryq53DS4LSqXj+Ph0t6D+yaRw5UymHmO/5So9wA3OG8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h8BXokUp; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h8BXokUp"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-68d22476e88so9736a12.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 02:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781170227; x=1781775027; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n/Oe3DW38b9AqfeR+BNHeTcKWnxDeKkYt2PnJ5PXJTI=;
        b=h8BXokUpkl8n1+AXoZ3dTy61ONhD+8pDQYYh1kiIiThLsjOs/zqjs8qKbl0Vfz0QEo
         8wXFbraKpOTQ+amwpW0dhZRC44sL3PpWj23zurUp+qg/n07z08ai+KotjOxFnNRBu9Yh
         yGnW1BWQVvkHQRwMDUp2s/Ga4edDsrk5Luz1A+aBdTNgg3fHN05RhNWDLJFN+PIGl6j8
         l34W5b6MAdtK1vTDWAsFVWNppgTDTbwjQKJo5xfBR6akIey4NzG+rlSDfUI9Hbioa/4O
         NK+AM7Iw4o9oeRsRhdVZ0ZGjS3GmgUrekEec5aD3MJWJZrraAYNrb8bNC9phc4WQhAS0
         PMdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781170227; x=1781775027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n/Oe3DW38b9AqfeR+BNHeTcKWnxDeKkYt2PnJ5PXJTI=;
        b=pAPIUbacZ9dqpy95m+2cG4A8qDKyubs2AW68Ujx7RuTTCc103xY/d02xd6PBft4/Lx
         /prC+ZEj3x3s/YSSKvn2dbZg6gWa13fxglRl2g8HP4tm4U46iTRUIjc8r6HS+fNMpPpp
         UQjXw5W6N6oAwvds1d6JrNr9wFcWmEfHT0cexfsp3cNtDeXbZESLNYSgWVna7lAgAo+0
         hFXNfNwxGaCoYHsi40e8SJYIKP+89HO+GO/6lMV0WO57SVGTPD4zMjsYT3k6Br4xb87r
         6ahs+jfR5KNepVx14vFOU51L1GDpLLgyQ9ISyJzu8CcafFLDDtWDsuztMljB7d4yz4vk
         b3ZQ==
X-Forwarded-Encrypted: i=1; AFNElJ8oddn3COTHapFMdnVkbY2dYanIMk/mi0GQC/stOnuSP7PdlCzFyibxfPU8sVFHWl10bNqZLz4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqJw9+YBWelZPvudTFfAoE2BS6dH15Y+qehYoTV8vVTBwT8Gxo
	C18AgETfoIQZ+pPWKxnT2f8IKmBjD3I5DNOgEZuEN4pwV7n/kderdMv+Wwxj5dzQew==
X-Gm-Gg: Acq92OFY94gbgIlQJBkerf+QoNhQReAZOPSmWaxlPDxtn1HVyVM99pJwoEpgDTcISiB
	d88ZRNg3rVXCLWx8rxHlTkqFX5BO5aI2d4s+mR+RIvMgSddqrATTtpjyVQ4cHi2PgZhDkL0Ljpq
	JTgbER8aBWbytSnXdkMtJh+Jn+rm1KfJCicEFQblOP8KNdz6PYbyXS/WcBc7yy6oYEP3BZLsBxQ
	0Y0k3zJM/uYOiGC1BMedReBERBvbXRRvqbL/Y/c6Zfk0ERaHNQfMoY12JLwext14y2UL7HVyvdw
	tEbqQSEpc8jXARI7Oz5GPoVK/K994ivJJz6vLAgCJ+UzD3BfHmp9+O8gDrPK1woEB1avZDk55LV
	WqGeB0r3cGEpodMU3VlSa8W6xq6ywAUQhYiX4iIfyCWkx8wXwQvFV+QQoflPeZngZzDinVOmN0a
	aDNfROrnzynHCsZFrHHBfWuW8QVLFnKSjGDN2HM574MZdpZu4TCffQvraQvCao4avJ56tocAnzM
	aVjMrRs
X-Received: by 2002:aa7:ca54:0:b0:693:17e4:c6b0 with SMTP id 4fb4d7f45d1cf-69317e4c895mr18477a12.9.1781170227170;
        Thu, 11 Jun 2026 02:30:27 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68e64c2f34asm11046002a12.4.2026.06.11.02.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 02:30:25 -0700 (PDT)
Date: Thu, 11 Jun 2026 09:30:21 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 3/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host
 handler
Message-ID: <aiqALaxb_1r9lbZE@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <20260608165549.1479409-4-sebastianene@google.com>
 <aikobxnyWj_G2iPT@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aikobxnyWj_G2iPT@google.com>

On Wed, Jun 10, 2026 at 10:03:43AM +0100, Vincent Donnefort wrote:
> On Mon, Jun 08, 2026 at 04:55:45PM +0000, Sebastian Ene wrote:
> > Verify the arguments of the FF-A notification bind call and forward the
> > message to Trustzone.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 32 +++++++++++++++++++++++++++++++-
> >  1 file changed, 31 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 91e89d889c44..eedb01955a45 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -42,6 +42,8 @@
> >   */
> >  #define HOST_FFA_ID	0
> >  
> > +#define FFA_NOTIF_SENDER_ENDP_MASK	GENMASK(31, 16)
> 
> Could we move the MASK definitions form arm_ffa to include/linux/arm_ffa.h?
> 

I wanted to keep it here since it is not used anywhere else other than
this file.

> > +
> >  /*
> >   * A buffer to hold the maximum descriptor size we can see from the host,
> >   * which is required when the SPMD returns a fragmented FFA_MEM_RETRIEVE_RESP
> > @@ -688,7 +690,6 @@ static bool ffa_call_supported(u64 func_id)
> >  	case FFA_MEM_DONATE:
> >  	case FFA_MEM_RETRIEVE_REQ:
> >         /* Optional notification interfaces added in FF-A 1.1 */
> > -	case FFA_NOTIFICATION_BIND:
> >  	case FFA_NOTIFICATION_UNBIND:
> >  	case FFA_NOTIFICATION_SET:
> >  	case FFA_NOTIFICATION_GET:
> > @@ -912,6 +913,32 @@ static void do_ffa_notif_bitmap_destroy(struct arm_smccc_1_2_regs *res,
> >  	arm_smccc_1_2_smc(args, res);
> >  }
> >  
> > +static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
> > +			      struct kvm_cpu_context *ctxt)
> > +{
> > +	DECLARE_REG(u32, endp_id, ctxt, 1);
> > +	DECLARE_REG(u32, flags, ctxt, 2);
> > +	struct arm_smccc_1_2_regs *args;
> > +
> > +	if (ffa_check_unused_args_sbz(ctxt, 5)) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> > +
> > +	if (FIELD_GET(FFA_NOTIF_SENDER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> > +
> > +	if (flags & GENMASK(31, 1)) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> 
> 	if (flags > 1) ?
> 

sure, I can replace it with this.

> > +
> > +	args = (void *)&ctxt->regs.regs[0];
> > +	arm_smccc_1_2_smc(args, res);
> 
> And of course just like all the other functions, it should use
> the hyp_ prefix.
> 

Added this.

> > +}
> > +
> >  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  {
> >  	struct arm_smccc_1_2_regs res;
> > @@ -976,6 +1003,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  	case FFA_NOTIFICATION_BITMAP_DESTROY:
> >  		do_ffa_notif_bitmap_destroy(&res, host_ctxt);
> >  		goto out_handled;
> > +	case FFA_NOTIFICATION_BIND:
> > +		do_ffa_notif_bind(&res, host_ctxt);
> > +		goto out_handled;
> >  	}
> >  
> >  	if (ffa_call_supported(func_id))
> > -- 
> > 2.54.0.1064.gd145956f57-goog
> > 


Thanks,
Sebastian
