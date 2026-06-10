Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B70E3F787C
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 11:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781092790; cv=none; b=X7hdLPNmb7yHJO/+eOUGMZA3LJyY9RcmSB63+AWcMUcCT1QfJizKho22LCNdt0WJ319Zo+GfzQKRJOJ/z8i8zd6zVnHXxSlPvVd8YEe3Nagfd74lDLeDza4YwYOJT/ESWF+U86h9d3NKjLLVoQpeB4P4XtHAfE2D/b/t4e8C84A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781092790; c=relaxed/simple;
	bh=u9EDB4T0+1GDi2LjsjVOwso18YXI7T4zBts/lmLz42o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CC4rUCRGEYw2sIqzWg0+HwDVsTAS2wxovcEr/VzkLfNL5io8zFejaWj36oJg3AHT347fWHmravtfmPzwecTXs2cyMEFR7eGYqlqdYj2Wh6OhiKpREL27p7h4QVTZaAveHXrvkLGLA84opTzym26A9RVnOzQCJATqFeO9PnsvBoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bo0QHK/i; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bo0QHK/i"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so27680055e9.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 04:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781092788; x=1781697588; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c28G8tbnZUyXO5kH0COrZ2xlMJ2YX0+1C3t/9VCQTd8=;
        b=bo0QHK/i3i5VroAOIa/fnZc7kpp2QeoP4DxncEJzxq0YpyDBVhyHDm+m1XA7HcEWEr
         5oNu8S5Pk0f2F6SN3q86IosFpdXlbdukuSUoLVp1lX/d3z8Ynq1KQ3XTuGoecoLcH2K/
         JeYVu8rdGl7ro14xlIBPkJTE1NTzLPcjxLwncYVF9RbgNfJDQZD10aky6KwxubWfp3Zp
         PGkKg+LfSjovFJKF1jlFoXLwqI9DJgwZ0BDDpG9s81lZIzfY9rJfvPKetOByEaUBP8iJ
         CXvlc8NnzhK9U8JbxszDOPf2R+4AGiO2JNRffFnv5IVtye5GzT6Vew17M08UpH8WNKTB
         3nlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781092788; x=1781697588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c28G8tbnZUyXO5kH0COrZ2xlMJ2YX0+1C3t/9VCQTd8=;
        b=CXmREHy0OOdZLvsV+Gn3KjjIoYTUwMlrHSRcoNjzkkMna+H99NwvrKgTcBJUk5QbQt
         f5m+XfS1sabRTc7XgGIs7hglZ8T1o3YK5fq34F7rB5BQgg19BSzxfVSmzVqr0xg8ElTa
         P5PCwYHjkfNK1efEpRLYtogVZriqr2tYIklcby8DfoB053C9kgqNWp9bDcDh8SNvF3ZN
         1vUyxn5NYZDf316lPripGwqzbofMwc4m5r3WVEY+22lyE8uLztlYA0P2hD1zOWsFLz/W
         ZKDk16lD9ZWfuxJYhcD4/78Jwj8lgkoqfgqYaqllpI/+D++owchmuB0Ggm+D0/4DRINw
         5C2A==
X-Forwarded-Encrypted: i=1; AFNElJ/xmGA6tPP0guTdxTFoSv21R80+Vn2u/1UVOuIwLePf9GD7s7tV+sexCoTnOdoWlZ/OKb+1HHQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHtr+zao3SLJbgk0BpJ3ggQYaG6lnyvbxYQ0W6dOv08bYibGwx
	QE0WCZqbUm4oK5XL/F/JBNO38f3aleP+m9d0ZIEOqU5e/Dg7mSS4NzCJp73RXl5TVQ==
X-Gm-Gg: Acq92OEn4GW2EK6I9d2jCfH+D/569qWsjN/wakzWZUO8Ozeq74hzJe6feSK3zxEr9nC
	M0ZkzleSyIg9i7+E9KnP1zFMi1E7OUXwIB7nD7mu/GyE0yAZl4o4vSPDUEH1syIMSItIrhrJnAg
	N+Pkf5F7f3P+HKqgLvRIQVVOWvYRInUluJgx//P6MdEDwaXqx4TKfhJUDLUvG1AeTsBqB9U15yE
	HZq1su+6n9hRXBK30YNTD/666JDSrdjPlqqps2Jcajbq7bDjW0GSvdc0vNo3dncSkwdVAIjLGKf
	rgDsnzk9xuqABAo+u3Ut85jfTLQN3P21RFEJHIv0TqNxOztDEI+h67rHPPDQXzKQ5SsXISyY25+
	LnUykRp+P8THk+DiyD5B4x2gZxNjTO1GDDzscVcXx263Kh2VJ8P+5QgCsapeAp5ylv6iMY8/DGi
	sI5/gVyhWysfphtca1VLsW7F7Ffzf6OBX/yOlH4Fmr8WSIjzsZvPDKHjJ+NQaA+ktVxC6xMVHWH
	pj1rQ==
X-Received: by 2002:a05:600c:6091:b0:490:601f:d766 with SMTP id 5b1f17b1804b1-490c259a103mr424487945e9.1.1781092787304;
        Wed, 10 Jun 2026 04:59:47 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f3446aesm78457172f8f.24.2026.06.10.04.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 04:59:46 -0700 (PDT)
Date: Wed, 10 Jun 2026 12:59:43 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 1/7] KVM: arm64: Support
 FFA_NOTIFICATION_BITMAP_CREATE in host handler
Message-ID: <ailRrxS5nbvNsbWB@google.com>
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

I wasn't really inspired this morning on the cruiser...

But nonetheless, that 17 should probably be a #define somewhere?
> 
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

Ha, we do not read 2 but nonetheless it is useful!

> 
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
