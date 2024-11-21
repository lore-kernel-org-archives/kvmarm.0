Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402FC1AE014
	for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 10:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732183822; cv=none; b=cPM/NTdeAM8N6d2mwRlAie/PlSjPV1d22C10RFInFcOZjuTdGqn9oSZREFKE7z3WnLWF/bEyf2z1s0dBlllB07wCcNm1EOnOMW4n5zIhcy3MC+7Pe6dDmb66oPQe6OLvXps6tSDIZpmFwwYEn8bcCwlwKGUwLitn/XjH9ovJzPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732183822; c=relaxed/simple;
	bh=rZ9VUFjNND5aBHSZhd6MTMonAu2meqWgJJciHOCMegI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQsOC9+VnF/4xyilvuSewnq3uJCvDhW1dfbZHacXRophykra+BFBfaAdnFw2NG33f9xVzZT/AqpZXDfw+on9HAlCYf4PxaR7X2x/j5VGe/gbkN2PnTSQjskY/hoA3IldjnjCjN6v1PuwwrPfoQtc9U96O/iitigLm6nI3DyJwSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k9+naLJo; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k9+naLJo"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-539fb49c64aso1106034e87.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 02:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732183819; x=1732788619; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RS5Hs2w0z8GYAD0nMVEYMTgAAwiFwMjKEdDralf7cns=;
        b=k9+naLJovTRKGIFM23LfmWFD/E7dWdnucWyVvfubUy0bgq0W7vdJAg9vtAiYp1EVig
         eC/4dqHL9gRM8S5h2XihZzTIQAByDMYchmEihKWC6CeKnemwMqeSqyX5cxkIUfcjxqXo
         RhkGFYqBnKXsFcYDVPL4uSizGdT3f8P8zKZi4TUHfgtoHtlm87L0vgvR2hxj4nxksPHm
         sxt+MG5Odsf5wH15sxPNpiOQvmqNd+ACP9pCh6URcz2EVm2qa5uwGa4iaN3roaYfEKBH
         s6gUq8dd6vGGDQkv71sb56+88wmqOJnLxAIYwHPuA/CkGGL7ILmmHeq126O56IVgg/QQ
         bQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732183819; x=1732788619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RS5Hs2w0z8GYAD0nMVEYMTgAAwiFwMjKEdDralf7cns=;
        b=ZABdCX0QFfjOUOqJcdc3HzCIj5xXR69TLSWCxJVMGIWx/WpEzoARJCUtU5iaKVKRI9
         nrArjynB0Sr9XcasN8W+6nW7BIIikOA0fhs48I2cGyOolWtb9ZRsSz6S9Zu56rlMeNwj
         sh8JlAKJPFTO9StRM/kRkmMTzaMFRR2EiVEk4O7WUabSnH3B1TrlGI6aIT4LsKJysC95
         RASSnKEDHnC1ZOWeyOrLPzoBVMjQhi4urK0ftZqSFZ6ppcZ359EkPVl4KTew/6KXJjQ8
         N0yJ7XHOYlF1VEulIEoixJJEIpZwjRHFKfoB2CL7VR8aQO9xD+RSxV1GSUEcaiK5s9Sg
         y8Fg==
X-Gm-Message-State: AOJu0YxZejr5QHag3jnMSmxJyJML0zs0NsSHkqJ3y02e7K8jnyGohSFj
	pbP9jGWTIEW4l9Bo0vxP4gU82JdS9SnWBO5nrApSgSKRKznIeUvy5wEmBDvabA==
X-Google-Smtp-Source: AGHT+IHkiSNPA+QGDLKCuSwgtQUmmyBPeJbea/alPoOjAHHscS7MrZ/jLyvmJqypRsXk+rlet92klg==
X-Received: by 2002:a05:6512:2209:b0:53b:1fd1:df34 with SMTP id 2adb3069b0e04-53dc1363785mr5058086e87.45.1732183818934;
        Thu, 21 Nov 2024 02:10:18 -0800 (PST)
Received: from google.com (40.162.204.35.bc.googleusercontent.com. [35.204.162.40])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f42d49c4sm63280866b.123.2024.11.21.02.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 02:10:18 -0800 (PST)
Date: Thu, 21 Nov 2024 10:10:15 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Subject: Re: [PATCH v1 10/12] KVM: arm64: Calculate cptr_el2 traps on
 activating traps
Message-ID: <Zz8HB8KQtUyj8d9O@google.com>
References: <20241120105254.2842020-1-tabba@google.com>
 <20241120105254.2842020-11-tabba@google.com>
 <Zz7wBU3BHW-XNnbr@google.com>
 <CA+EHjTyGzjOnVnyqfS6LO5=_EhQY3CS18HyrnSmnfNF483yz6w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyGzjOnVnyqfS6LO5=_EhQY3CS18HyrnSmnfNF483yz6w@mail.gmail.com>

On Thursday 21 Nov 2024 at 09:41:46 (+0000), Fuad Tabba wrote:
> Hi Quentin,
> 
> On Thu, 21 Nov 2024 at 08:32, Quentin Perret <qperret@google.com> wrote:
> >
> > Hi Fuad,
> >
> > On Wednesday 20 Nov 2024 at 10:52:52 (+0000), Fuad Tabba wrote:
> > > -static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
> > > -{
> > > -     struct kvm *kvm = vcpu->kvm;
> > > -     u64 val = vcpu->arch.cptr_el2;
> > > -
> > > -     if (!has_hvhe()) {
> > > -             val |= CPTR_NVHE_EL2_RES1;
> > > -             val &= ~(CPTR_NVHE_EL2_RES0);
> > > -     }
> >
> > To be on the safe side, should keep the RES1 stuff for nVHE?
> 
> Sure. My thinking in removing this is that, once consolidated, it
> would be easy to spot whether we could be clearing the wrong bit. But
> I could reintroduce this when I respin.

Actually, my bad, while checking how this worked for nVHE prior to your
patch I've realised kvm_get_reset_cptr_el2() was already setting those
bits correctly, which is arguably the right place to do it.

Thanks,
Quentin
