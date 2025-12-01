Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6BC1DE887
	for <kvmarm@lists.linux.dev>; Mon,  1 Dec 2025 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764605057; cv=none; b=FOVzxAPKsEObmrzxY6pHW6ld5zRY2X+HrYFHaRQ/bCm3slgidgfxT865tdGUao5yE2t5pU6EGc+jnwxYkzCe8Z16sHHDticXkopbG6SpYUFXlGTOxynUbQa0n7DMWy6ZECpzTBNuZMirTUWkaYMTI7K7wGYW09UjBIguJVLqCAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764605057; c=relaxed/simple;
	bh=Z2YOr5kYk9GxOy65Jpo9uyk4Ob8LGIIPugQHeveeqto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XmRO/juu9PbujEkaaOgDTfzfkvBk15lgKpZkd4/Ey2vBalOoSIxSjDpdfXQBd33Ffg6TWvUSESzabLc5gVP7fu1Zs9EgZkcGd3M23vzlePnMzLfn/CRj89oc8M6zibIxGqT5QO0KQsOtWsSjnIqPu9RX0JvXZ/8902212owWwBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l+bqr71J; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l+bqr71J"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-597c83bb5c2so1140965e87.3
        for <kvmarm@lists.linux.dev>; Mon, 01 Dec 2025 08:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764605052; x=1765209852; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b9hMtV3PXrMhCjLem0M5KT+SZ8RXBResg7Pv80Fl+Ng=;
        b=l+bqr71JSrKkLzg8c08f02pkXWJ7QkGS+A81W1T91sSw1GEeRd75akJ7vcRX6vNN/9
         kSZhujgGgBLFoqd7dtGw9PbqrJtsdMz+cThV0JCFfZ/iYQDudGAII0xTxYrJ1rzGSX32
         E8MRBHmOiwosvOEqIrRm+2Gd/6iFnSoInE9tiT9ATUbcqw+lAhMVMTod5UcNUFwgFy5B
         24hL6C/4I73/IV8wus3Of7kCVmpJ7nMqECbJFHzvRKDTwKxh2geiDUu0D/YGnuRGQKb0
         UtrOkogrxACpGGawex2aT2x1ChvG3HQ6WeoC7Jh+1OuQaRKARZ8NU0yT7fUpowYNU+/D
         Rbug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764605052; x=1765209852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b9hMtV3PXrMhCjLem0M5KT+SZ8RXBResg7Pv80Fl+Ng=;
        b=CGMTgfNtHDaTiULBbkdBSxFaTZDvw99304O8lm5Bq1NRBtI1xlLlHD2uGLU6YMGrLC
         g9vA8QBBsbgwdSWLPnBw+BNL/igtZz3KXx1VVfkwCqwC2jA+0jhkD236b5YJsRvfO3eh
         gNY3W0kHAS6iGAKOZzknvXxs7SVvpdV1yvkqB8VWwpaftI92TLa4Gcq7r+j6M/pnEj04
         9QB8g6Fc7b762Cj9lDSH0LbbJcZx1jSF/OD+oL5xJsXgbY2fjCfjxr0/J1jNDKdF8Ys3
         QLY7yQY4keEEqkWcVpnuaskYXKMSF3q3D4hx02J3+dlyMkeGHQ0NBS9p/aLrGjL2gVvV
         rhpA==
X-Forwarded-Encrypted: i=1; AJvYcCVLgC8kDJfMDNGf8hh/n+BS9AttHztjJ8R7mUdjvNVMHd2pBTPSfbxDTdBCVcxFUAMbMJS33VE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVkDA+2m+0phbicGHvVq0VipEeE+Nta2W7WTqjmdIaPdpJ9bHY
	k05q02xbJDkrRJ0q1ncFJhaQJDsAGOVCPAaY6V76gwJa7vuq+hKdcTQBV81DqegvRw==
X-Gm-Gg: ASbGncvW387uTCFREjkufRtaTlZ2bDqTwUg1zXodeB7rJIiJHzqnO99Ooxrh2EHJH18
	82c37IwEtzhja7QMDa11ApIIrckTqHXA/fuooOC5FU0NDTvmbvUb7YMn+tG7dIioW31hmKpbJ/R
	7Le2RVc8IAwHZy1kRjbLXfyguOfEVa+yyt0PqbuDM8mmkewzu8FNhzxN4Ah4euBsiagIr5Wihfh
	YvqZSryWfAN9KDiMhwSM998Hl8CszU/4lMDFykrBr3EMXIfFKGLcIubcKikDJWRaW6MaNOCYSN6
	m0Cocg8+SpJF6Yhrk0ElcEpAHheVtw7+3/OM2sAWkm7Jwg4SUTfcUKc+LiFwSARYgXyg+vZeQVD
	1agh9r6Rld2hOMy7zLcAAez0WOBpZBkneAc5cRQQIf2D3Fto533B4B6kCL5es3xmBRpSGLJL/UG
	vJMECRYIR6SpX7IjzxaB7FFAapoV0PNF3R78BHz9Z7N4Qe+PLc+w==
X-Google-Smtp-Source: AGHT+IGwL72Aeg7rfy2TscsPc6xQDUxQw9XmpdcK/OUqxD4opRrcqN2Rq5mq6/N45bshnzXhV6B/iw==
X-Received: by 2002:a05:6512:1595:b0:595:831d:22eb with SMTP id 2adb3069b0e04-596a3e9fda1mr14183062e87.1.1764605051684;
        Mon, 01 Dec 2025 08:04:11 -0800 (PST)
Received: from google.com (120.54.38.34.bc.googleusercontent.com. [34.38.54.120])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-596bfa48c90sm3661068e87.80.2025.12.01.08.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 08:04:11 -0800 (PST)
Date: Mon, 1 Dec 2025 16:04:07 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 26/28] KVM: arm64: Add hyp_enter/hyp_exit events to
 pKVM hyp
Message-ID: <aS28dyrKgZaOmMNr@google.com>
References: <20251107093840.3779150-1-vdonnefort@google.com>
 <20251107093840.3779150-27-vdonnefort@google.com>
 <87345vfiqj.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87345vfiqj.wl-maz@kernel.org>

On Sun, Nov 30, 2025 at 07:00:52PM +0000, Marc Zyngier wrote:
> On Fri, 07 Nov 2025 09:38:38 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > The hyp_enter and hyp_exit events are logged by the hypervisor any time
> > it is entered and exited.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
> > index d6e033c96c52..ce3953bc884a 100644
> > --- a/arch/arm64/include/asm/kvm_hypevents.h
> > +++ b/arch/arm64/include/asm/kvm_hypevents.h
> > @@ -7,4 +7,21 @@
> >  #include <nvhe/trace.h>
> >  #endif
> >  
> > +HYP_EVENT(hyp_enter,
> > +	HE_PROTO(void),
> > +	HE_STRUCT(
> > +	),
> > +	HE_ASSIGN(
> > +	),
> > +	HE_PRINTK()
> > +);
> > +
> > +HYP_EVENT(hyp_exit,
> > +	HE_PROTO(void),
> > +	HE_STRUCT(
> > +	),
> > +	HE_ASSIGN(
> > +	),
> > +	HE_PRINTK()
> > +);
> >  #endif
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h b/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h
> > new file mode 100644
> > index 000000000000..4b69d33e4f2d
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h
> > @@ -0,0 +1,13 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +
> > +#include <asm/kvm_hypevents.h>
> > +
> > +#include <linux/arm-smccc.h>
> > +
> > +#undef arm_smccc_1_1_smc
> > +#define arm_smccc_1_1_smc(...)					\
> > +	do {							\
> > +		trace_hyp_exit();				\
> > +		__arm_smccc_1_1(SMCCC_SMC_INST, __VA_ARGS__);	\
> > +		trace_hyp_enter();				\
> > +	} while (0)
> 
> Huh. No, please. Don't override existing kernel constructs behind
> everybody's back. I know that tracing folks love to play that sort of
> game, but I really don't want any of that here.

And you haven't seen what I had for arm_smccc_1_2_smc()

> 
> Just define a wrapper that is KVM-specific, and use that.
> 
> Then from a semantic perspective, an SMC call, an ERET back to EL1
> host, and an ERET back to EL1 guest are all very different events that
> you lump under the "exit" category. That's not right. Same thing for
> "enter".

The idea of those events is just to know when we enter and exit the hypervisor,
purely from a timing point of view. In ACK, we already have other separated
events that can give the "cause" for entering or exiting the hypervisor. I
haven't added them to that series because I thought it was big enough.

So happy to add now or do a follow-up, once we're done with that one?

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
