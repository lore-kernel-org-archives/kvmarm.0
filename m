Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477A63064A0
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 11:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767957520; cv=none; b=rH6G9Hgd7NwvWC7ZKtZ6pIoiy9MCoXhp1H70KxtslJX5UQz19gIWBkP+yFnUm3ri4CQlkzHKJjoXx/E0KwabPpdLEWOlWOChz/lHWInGVaN24V61YVSI/GwTtsyhBsDaBo5zL90dr/BKvNqJ2WTDKiR+sHuK8dW3cOwqWmbEMho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767957520; c=relaxed/simple;
	bh=l7AkI4fdFk0CQnpocg/oG/SiDKajWkqbJOnxr7H9+mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Av3ThS3p0Z5mjJZlVzY1br6rigzqTFDi1CbRAwd88I5ptaFdj9gy9fuwqSm2peA+5MLxRgzk6K7FUCwXEkwQkuEmoStEgUf6q2Vt7qnzTAFyDvLoxQA0pl+Z2q+YkbK3z269UhAc99S//xysAGhDJcm5JeJcq+dhQXxO7mWr6Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U+7jbonr; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U+7jbonr"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4779a4fb9bfso48945e9.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 03:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767957518; x=1768562318; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LcRKW9XG66IWSuObrKpBcxYjxRwc8D6DgwgNC2eRp3A=;
        b=U+7jbonrhTNVEMFu/OJOeKRHPCpUAc+bj6bp9upJakbIZJC7B/KtO2Dd0rIyrkAw1v
         gdqoB4MQua5CLhBC/tTNPv+OTFM9bJYyd1Ynpk/jDhcFjJc5gWNsvQA5L8IKgKxTF5XO
         breKjNkEu4MXHiIFfFHIKQGrnBVNJ+JV2lh3Nz64Bxo0QnDxLd3Lly+itrIj5wU4BKbs
         jg7hn3vAZLju52MkWNROAwtkO70eet5a4uoY8CfkT++WQ5w2rqTco6fJbyMOFaLke76g
         D0wqRLjHKMZjR0ajFwgX3fxzNe3VqeraB8iTh4j1jjrge57eQChfuzudge4OMl26+acI
         HxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767957518; x=1768562318;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LcRKW9XG66IWSuObrKpBcxYjxRwc8D6DgwgNC2eRp3A=;
        b=vtbRz6/LUMyGcpPV/Wa9zCs1KcBoTX0cBMm3dedzny1jWkXE78YTQ40r5/Y+Qz8yBK
         38FIq6N+pmJdo8yuB1nIJRVZUPjWl+tvKj00ONb2/Rspbwox0g56KT2Q7sMzZz+OTiV7
         LAecenlTHV+lw+49UE0YInlcK0HYjbgjVHPGEp7uCJXZkmr7yOQZO+xJsusNw4n3gvMr
         etaRAbSAIVUoDY8MoNBahkri6yxxqoZ+t6jGADSDgERedVdDihhVanExtR4Mz6MxmtDd
         6HShBXhOmXvwp/YngBma44FGCQL+OTdcGM4ZpMFkTfa37eHdtYpV4sgKxlDG1BNOC37w
         UtOw==
X-Forwarded-Encrypted: i=1; AJvYcCXry9RbFKGpiVDOSfASHK8UeN2jPgzEVwWC8WBWTC1EJYw2VT9ICjbE1XP1nlp86iu7ryw53HI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4KD661ahzJ1GOiIAu6cI4clmH3D/n9HzeXxRBojJ1TzQkIJAg
	g0K00ay7VL/1iPJqlATNN3MNRx6Xm1LCrrqmCtpqmhKtDc0wZUvKkUKDKmE66ZP9xQ==
X-Gm-Gg: AY/fxX6MEacn4EENP9xuR8xNMIk6z46DMxJPUbp9l32RWAu7Umd///+uFbHaXeOroPF
	LSB4Op4QxLJbRPHiceOmpIOekYVtTeeXOawU1f0953G+XTcd21o1MdxQikJrzXFnuDYDumz5p3F
	yHRWjB8mSpJbj6k9BRYE9jWSymejA9ogBQIG5rfF0fEoyc/wLhCcDqFwegDvA34GGVXaW4FZuVJ
	PTPD+vFduwhh2VJKrAySP7biKM+PyGGbEANN7rVR9t3O1HWhWIi+ZwP7zTbRmBTR3kz+YOiYDIz
	omvPoUklahuPJ4ibrDBwa3jauk2a9Md3K/jEHoVrxh3cT3PJOZ2ihNgTLQu212UsEUULQc4/Qpc
	hRZdfeII0072ByMWvwnVrEjDPAy07My3WeHxAkEFFt6lhRS5p3FCE2v4/gGefxjZoTmI5hJTWuL
	IaLWat1wdihave4KSWM2dQlSnVw2vGzqeMH85dUQivVaYeKstIX7q5
X-Received: by 2002:a05:600c:755:b0:477:b358:c0cd with SMTP id 5b1f17b1804b1-47d904419ebmr504375e9.18.1767957517587;
        Fri, 09 Jan 2026 03:18:37 -0800 (PST)
Received: from google.com (238.18.78.34.bc.googleusercontent.com. [34.78.18.238])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f703a8csm200896695e9.13.2026.01.09.03.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 03:18:37 -0800 (PST)
Date: Fri, 9 Jan 2026 11:18:33 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: perlarsen@google.com, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Armelle Laine <armellel@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in
 host handler
Message-ID: <aWDkCQ7m1-w8e-Py@google.com>
References: <20251119-host-direct-messages-v3-0-c74d04944b26@google.com>
 <20251119-host-direct-messages-v3-1-c74d04944b26@google.com>
 <aV_MnW8cg7IsWPuD@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV_MnW8cg7IsWPuD@willie-the-truck>

On Thu, Jan 08, 2026 at 03:26:21PM +0000, Will Deacon wrote:

Hi Will,

> On Wed, Nov 19, 2025 at 02:07:53AM +0000, Per Larsen via B4 Relay wrote:
> > From: Sebastian Ene <sebastianene@google.com>
> > 
> > Allow direct messages to be forwarded from the host. The host should
> > not be sending framework messages so they are filtered out.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > Signed-off-by: Per Larsen <perlarsen@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 22 ++++++++++++++++++++++
> >  include/linux/arm_ffa.h       |  3 +++
> >  2 files changed, 25 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 58b7d0c477d7fce235fc70d089d175c7879861b5..a38a3ab497e5eac11777109684a33f02d88d09a1 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -862,6 +862,23 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
> >  	hyp_spin_unlock(&host_buffers.lock);
> >  }
> >  
> > +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
> > +			      struct kvm_cpu_context *ctxt,
> > +			      u64 vm_handle)
> > +{
> > +	DECLARE_REG(u32, flags, ctxt, 2);
> > +
> > +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
> > +
> > +	/* filter out framework messages */
> > +	if (FIELD_GET(FFA_MSG_FLAGS_MSG_TYPE, flags)) {
> 
> Wouldn't we be better off just checking that flags is 0? The rest of it
> is SBZ or MBZ in the current spec.

Yes, we can simplify it in this way.

> 
> > +		ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> > +
> > +	arm_smccc_1_2_smc(args, res);
> > +}
> > +
> >  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  {
> >  	struct arm_smccc_1_2_regs res;
> > @@ -920,6 +937,11 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  	case FFA_PARTITION_INFO_GET:
> >  		do_ffa_part_get(&res, host_ctxt);
> >  		goto out_handled;
> > +	case FFA_MSG_SEND_DIRECT_REQ:
> > +	case FFA_FN64_MSG_SEND_DIRECT_REQ:
> > +
> 
> Weird whitespace addition ^^
> 

Let me clear this space out.


> > +		do_ffa_direct_msg(&res, host_ctxt, HOST_FFA_ID);
> 
> What's the point of passing HOST_FFA_ID here? Is that supposed to end up
> in the Sender ID bits of W1?

I can remove it, this doesn't bring too much for upstream but on the
android kernel with guest-ffa it makes sense because we need to validate
the sender to prevent impersonation.

> 
> Will

Thanks,
Sebastian
