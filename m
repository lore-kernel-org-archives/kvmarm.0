Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E382777F9
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 15:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754407583; cv=none; b=GWIOBePbhsNFeayWjTF2dc3Oo8lUvy/fCJkD4meW1IRoFD2EGVQjbLFgyljpNQ5pLqAA7/3DF7Z7hSy0y7tmPa05/K8gYi40mzpd507CMPAIKc7D/88h9Itm4T/feG1ILQugmXksbBcuXuv6nOFxoohDVan+ir9LQYGbiL5iK94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754407583; c=relaxed/simple;
	bh=85LFVfz3EHtKAnH+R08aZcwRaoR3Ar74rwBiG0VRHcI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=brf83kS2DTQCdZoDuJddC8uzBHAlqbXH34GwFYRalzl5QRP26fYBZpIpK7Lzb1rxkrAPsZaa3W1RnQjtvKNi59+6iZAA/I1n4bt+Q5zGWyCMuROaVsB9mse2uQSMIOn3pDGyVtSsKI8W0IlVC5eCtevy2f4a1f7bHL2ipcyEoHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NBeoKIUy; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NBeoKIUy"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b07a5e9f9fso454511cf.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 08:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754407581; x=1755012381; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2i1Q1DU3TAUIFLraB4yYdaRtcD0rhW97RSVmaj5w/Uw=;
        b=NBeoKIUyk40l3xJRlJpJLg0YSmAwuSUePJLU9lHjc0xky/xolGyjd1AKMfnp2ALZJJ
         62Ys0lPveqlqnwbUiMUJH/mbaNUE2B6ICiD5unl9VJwSp3toCkdDdW2VSx+wnMe3qxIK
         JElGEcrgh+XWQ+fkLZH/I7y+FfR3oJhaY1HqD39clknam6v2LTrP2mFCAaS7hxzA5npq
         OJ5E9aIqB9ieVArswMTP2/V3+TRrCoy7vy4WSEMFkh8w8cOs5uR6GDfUa9cNuMqd3NH/
         KOEZccdLjmOwC40Xr/k+NzesQxYrROghDKkjSR7ilnKDRUXBcI56X7NQmBRVEyt6PYk4
         DktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754407581; x=1755012381;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2i1Q1DU3TAUIFLraB4yYdaRtcD0rhW97RSVmaj5w/Uw=;
        b=D9fVgltli6zdwRzZcrwuxwl5M5ZflwK5ir1nK6Z+gnjqQlGa66Ij35EQ/fcaKCOAgN
         feUts11784m0Aa3NW75Tv2RWxkIpzUWz14OTGVpNsm3xusVzkYw42/dvW0C6YmM3tA27
         0XDPNU6HBljCS1THhVfAX2JdNlzg80aade1sNHFob8w187kv2EZmH+H5ZgC7rO7BjpN+
         y/UgqwAaTtJNnDJN/LtqsiPM5ut+Stinij0CIiQ2ocmGY2Op4BKNDR2nVGZ0WhQBQjMW
         0d6QuHotGloAaHgbMiKASSzcSQLwq4sWOtJpRZUW03VWse9uXn9hJCl+QNZE8/MZFNN+
         6jqA==
X-Gm-Message-State: AOJu0YyJ9WLPnyTAamWnEugKpGpImEmKEoO1KQqalVL+lc7VYFtU2zZe
	hDr4J/fvqT4vGAqDJEJciMVLdtoyeqBqfa9MN1CZO8F2PDxL7/DfJPbo+JOvmCObSQBVv9cI9JX
	+349SwLZh+XRUmoZiy2aoK3Mr9F+3z3He9gHv27Rl
X-Gm-Gg: ASbGnctCbu2Qq4xlaaoeRz6U1FRalMsXrSgm4y4WhPMVIzs+6HG0Mji8JDZpWdNo5Fv
	bpc17UCC+kEzKqBIdCEna/MxnFpKvezB5qkQXxGcD6fbEE9DsF0z4u5TerzLSYDxRWwd+8CEQrj
	IjvejZNP53ZWLyKI456/yV3ZuZDEUdo6rZgYJsnNQS8l1d8u+pHJUwcWdNgyPr104mFCn7gxkW2
	hO0HIiIaI/x7LlR4jJmL+lD4gjdNw==
X-Google-Smtp-Source: AGHT+IEPn9BAGcyC9RdcMH/TSHPcwTUayFCZLped6m7ux8g9VELmwHfnCo7ockxlrmEucnHiOvlt+/on7eAnUN3nm54=
X-Received: by 2002:a05:622a:188a:b0:4a9:e34a:58a1 with SMTP id
 d75a77b69052e-4b0850188c9mr3535311cf.21.1754407580322; Tue, 05 Aug 2025
 08:26:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250805135617.831971-1-tabba@google.com> <20250805135617.831971-4-tabba@google.com>
 <aJIWyNwWAAaCf_cw@willie-the-truck>
In-Reply-To: <aJIWyNwWAAaCf_cw@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 5 Aug 2025 16:25:44 +0100
X-Gm-Features: Ac12FXwES16-Z6v36CMKkJpW1AjsyxfYdUX8eXVbea0sO4LsoBDdHYz-X1Ffbsk
Message-ID: <CA+EHjTx_3oYJk=Hu=33VjVT34RBRvSp=uPwo+NNnzs-t38K91A@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] KVM: arm64: Sync protected guest VBAR_EL1 on
 injecting an undef exception
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Tue, 5 Aug 2025 at 15:35, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Aug 05, 2025 at 02:56:16PM +0100, Fuad Tabba wrote:
> > In pKVM, a race condition can occur if a guest updates its VBAR_EL1
> > register and, before a vCPU exit synchronizes this change, the
> > hypervisor needs to inject an undefined exception into a protected
> > guest.
> >
> > In this scenario, the vCPU still holds the stale VBAR_EL1 value from
> > before the guest's update. When pKVM injects the exception, it ends up
> > using the stale value.
> >
> > Explicitly read the live value of VBAR_EL1 from the guest and update the
> > vCPU value immediately before pending the exception. This ensures the
> > vCPU's value is the same as the guest's and that the exception will be
> > handled at the correct address upon resuming the guest.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > index bbd60013cf9e..b34b10be1ad7 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -253,6 +253,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
> >
> >       *vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
> >       *vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
> > +     vcpu_write_sys_reg(vcpu, read_sysreg_el1(SYS_VBAR), VBAR_EL1);
>
> You say "in pKVM" in the commit message, but why isn't this applicable
> to !VHE in general?

Because this function is only used in pKVM. I guess there's nothing
stopping anyone from using it in other non-VHE code in the future
though

Cheers,
/fuad

> Will
