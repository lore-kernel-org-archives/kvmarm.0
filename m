Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B493C3429
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 09:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781171170; cv=none; b=tumKPZdaeo3dxtngXml/Z47OiCi7VGoFLTWJ1ASdhCf0Z0fEfB9XtSfI+8YAphFOFigMmXlMA6UvkCkDK+oRt5iBkqIAQEQuQVNaE5zJ7l8ge8c04NEcK/Myrj3IoJfZJM26r7iJe/OQSwEdB1/273pHaOnpG22Y7m1ZjLXbNe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781171170; c=relaxed/simple;
	bh=oYrwKPXFNZ0ScqQrR/5KgKcm0e527VCHipAbmxHtOUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VKGza9PZhkR57adQC2lEdURvPGjPL0Pw5SVs0IvGl6dtcmSdzU5DemytsrNoxV11hrBQGP8YMhfeccKGgxnZgdEX6vPhjnC5iZG6wJ0e6p5rcK2UWvKscYSwVMDDrAtHbmR6QAG0/m08DsvVbXF3UOEjyocBeQEZeW1pGUGNPwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=czbyWh4m; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="czbyWh4m"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-68bd7ec2371so7776a12.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 02:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781171168; x=1781775968; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=caoKMgRrh781zMJjCERxNdYYkromYU4iEkGrg3oyQos=;
        b=czbyWh4mqEUGUVXUQA/pi3gFZRcm7LWBblUv/e1FRhvfmoMjM1rU+bXUE62dlo4rdR
         79bxLh3yKibh+etZ5/5IR1zDz+eXoMq8mHr/XJ9pUSol4Www89JvPwGqZHNgvAWMD4M9
         EDOR0YlHlMrN/e9Fq1IgUen4OmTkTw9V/HL7f5zSIYfSv/8ZSbtNhC4a/ADsKcNVzMay
         aZBFSyjkgQkQvmTW6aFVaYSdMINSZTEqOwXtgAZ46UiJ5/wRmfSvG5oOAhsTWbIfQKwL
         5n6T5RhbUhkEZAkzAMG+PqAn+2pkF9VnrH4jvlrVLNhXw5FWSPUFMtZ+XleEhz+T+0U2
         Stxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781171168; x=1781775968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=caoKMgRrh781zMJjCERxNdYYkromYU4iEkGrg3oyQos=;
        b=kpHbWVxcJeaq04DPY9vNPG+iE6ljzrarn6a1JaNZuAJcI5cNuajwmSVpVSC0ekODg6
         tP2AusKuYvUVXlrRKfQNS2qx/fUyD9iyhpjWWTOKaJXYDfVuU+T2hZZhki88OJ16T3NF
         eVaje9nbHkTX316TgGQLBjlFZ+CzrVuVcuJWZ4ikUf2RMm+/QlrL3p9oYZm4AG2v/IkZ
         8kyEx0xer0U+gxm7bvWjJI20Pu7Nuy2n2iZQc50SHgxCxIULoj9rMEOsiuJIDUvhJzzC
         3mmOWeFq6VYAUlxPDAVuM6e9tJj0o5qAXqjPsWd5/hgvZexBiIMvXKt8bSARlxtej3tj
         xpiQ==
X-Forwarded-Encrypted: i=1; AFNElJ8BGYC98LTJgXRZljOfUW1/Fjnf2OuOZEL9K7JEfRfvwV2MMXbZ13J2Mv2MSqo0fyer1iBJo10=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHsvG0M0ugBX/uQTkyk9KpKVqnKkY1QYc4vJetkrJR62ap+otK
	36jIA38fk5FBxrS2wV+B4ZOmR/AX8yrrnD5vX+fTz/m4cBCJD/pi5/ac6fkNYWIqtQ==
X-Gm-Gg: Acq92OE+QfVDaJtyt2E1Q0rzzkcKAagzzOXhVsNU621iP8ufXpkxGwgKfzLHBzcTkPe
	rHnDIegqE3fx5vIJGHl0tz8615e8O71sY1JenqdjwIiHkqXN93EGNvm5eNjEs9y2NSyft/T+EL/
	OgcDNz67NRcwwhGAD78UAA4dx/FQhTG99TeR7/z97Ye+uWhQja8dLu7Khh9UAsrdl9ePrYV+ClI
	bU/W5SWiNhCkgyDEbK1lrkqL+n2KBQesODkQrQ1YK/7zzJpR7MQDs8OZMqrgtbFHdCkzDCRzApR
	SpIMAvpBlz0Tfq2s8Bt4fsjNNfEa3RaKaMgwbcAQZlA02HjPRAbgWTTyJptUV8IaJze4gjGLEWu
	IJ7AjAS2vNxdRpFVDlWfazk6JCZ5yT5D1A1mRtOv/aiHuqTMlU4ouxXGqO7GiKWz1fmrFSfvtmL
	YlYq8XHUK4W0+E/3hm0W+KB1DfidOPa2N0iL7tzGy9l801HwcFPFQR+fO+iVtrseusK7qCkCTQG
	5mHhxcq
X-Received: by 2002:a05:6402:a545:20b0:68f:d41d:ca5d with SMTP id 4fb4d7f45d1cf-6930e145acdmr20838a12.11.1781171167189;
        Thu, 11 Jun 2026 02:46:07 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfcb0f14edbsm40206466b.3.2026.06.11.02.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 02:46:06 -0700 (PDT)
Date: Thu, 11 Jun 2026 09:46:02 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 1/7] KVM: arm64: Support
 FFA_NOTIFICATION_BITMAP_CREATE in host handler
Message-ID: <aiqD2sy-PawXWXQU@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <20260608165549.1479409-2-sebastianene@google.com>
 <aiklq5QvztNk8FZR@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiklq5QvztNk8FZR@google.com>

On Wed, Jun 10, 2026 at 09:51:55AM +0100, Vincent Donnefort wrote:
> Hi Seb,
> 
> On Mon, Jun 08, 2026 at 04:55:43PM +0000, Sebastian Ene wrote:
> > Allow FF-A notification bitmap creation messages to be forwarded to
> > Trustzone from the host and introduce a helper to check for SBZ
> > register fields.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 36 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 35 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 1af722771178..c20d45191085 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -71,6 +71,18 @@ static u32 hyp_ffa_version;
> >  static bool has_version_negotiated;
> >  static hyp_spinlock_t version_lock;
> >  
> > +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
> > +{
> > +	int reg;
> > +
> > +	for (reg = first_reg; reg < 17; reg++) {
> 
> The upper limit should probably be something like ARRAY_SIZE(ctx->regs.regs) - first_reg?
> 

The upper limit is 17 since the smc64 uses x1-x17 as arguments and w0 as
a function identifier. ARRAY_SIZE(ctx->regs.regs) is 31 

> > +		if (cpu_reg(ctxt, reg))
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> >  static void ffa_to_smccc_error(struct arm_smccc_1_2_regs *res, u64 ffa_errno)
> >  {
> >  	*res = (struct arm_smccc_1_2_regs) {
> > @@ -676,7 +688,6 @@ static bool ffa_call_supported(u64 func_id)
> >  	case FFA_MEM_DONATE:
> >  	case FFA_MEM_RETRIEVE_REQ:
> >         /* Optional notification interfaces added in FF-A 1.1 */
> > -	case FFA_NOTIFICATION_BITMAP_CREATE:
> >  	case FFA_NOTIFICATION_BITMAP_DESTROY:
> >  	case FFA_NOTIFICATION_BIND:
> >  	case FFA_NOTIFICATION_UNBIND:
> > @@ -862,6 +873,26 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
> >  	hyp_spin_unlock(&host_buffers.lock);
> >  }
> >  
> > +static void do_ffa_notif_bitmap_create(struct arm_smccc_1_2_regs *res,
> > +				       struct kvm_cpu_context *ctxt)
> > +{
> > +	DECLARE_REG(u32, vmid, ctxt, 1);
> > +	struct arm_smccc_1_2_regs *args;
> > +
> > +	if (ffa_check_unused_args_sbz(ctxt, 3)) {
> 
> Is that expected we start at 3 but only read 0 and 1?
>

That's what they are saying in the ffa doc (16.1
FFA_NOTIFICATION_BITMAP_CREATE). They use w2 to hold the number of
vcpus, that's why they start at 3.

> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> > +
> > +	if (vmid != HOST_FFA_ID) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> > +
> > +	args = (void *)&ctxt->regs.regs[0];
> > +	arm_smccc_1_2_smc(args, res);
> 
> Should be hyp_smccc_1_2_smc()
> 

Yes, replaced it with this.

> > +}
> > +
> >  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  {
> >  	struct arm_smccc_1_2_regs res;
> > @@ -920,6 +951,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  	case FFA_PARTITION_INFO_GET:
> >  		do_ffa_part_get(&res, host_ctxt);
> >  		goto out_handled;
> > +	case FFA_NOTIFICATION_BITMAP_CREATE:
> > +		do_ffa_notif_bitmap_create(&res, host_ctxt);
> > +		goto out_handled;
> >  	}
> >  
> >  	if (ffa_call_supported(func_id))
> > -- 
> > 2.54.0.1064.gd145956f57-goog
> > 

Thanks,
Sebastian
