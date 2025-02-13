Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5E52063DA
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 08:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739436773; cv=none; b=EHWVIqzGSPuX7/+ctoQM5+5HmW9/jtaKuFtv8LPjanVBHr2ifxvXlwHSZLBbG+crVKaXBSh3JquA7V2ovXb8M5ny1PgZqORg5GTEheU2TVt+gcwoXWkgkNq8K0oYxwvyHHDCNwITHQ9vPFxglG1uBDgWTnxgAIhb7zsAiLuT+Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739436773; c=relaxed/simple;
	bh=aeltaq5F+EMvjtZgSTQeyt72v0Z1F94i/IxbvZGjCiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C9TGMJKh+64OxKI3P3TxB4CaKgDDrnP8ams/93atfVTNFGmZkstF28dtwOJ2qwm0lrsNe7r9+CK55DF/hx33vuiv4n9702ZWvXkuuK9j2bVF7aJUom60SiB5kyxvg1gEXw+qydgVbzqz/fdo41Qd7CPxfqHos8ylFkFLdnGMBQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cZB5HWin; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cZB5HWin"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4bbd3cff198so373503137.2
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 00:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739436770; x=1740041570; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KRQ3dUIptAKwY6MQYxUEHGw6dXXH6tF8Q68IhjO6QLY=;
        b=cZB5HWinu/SczoSjiSVsxL9yz9D2l/fjTaW8jdb8s/zVXlntRxcEAnBQHOykSlGW7S
         d2jvmle9nGVbRnNQ6AzXPM90h0h62s/BVDyN2+BcsosZG5dTGfpvhPf4EInhE8SYqdga
         iSie1PN1P9dgDaoidCmm1LpEtKUy2SsBWHd3RCmzO0G+g3ihPAIpFqYThaM6wskDKiIy
         YwLnmCsvcmGdurJQ9IicYq+SFcCpJHQ6vFB/rFjbwjHL9cMvkOTcoUZN43hl5VZj+qai
         gu8q53Zll1tju26aNreD4Fssma/K223Xo97wEGXLvxomev6IGXDzmkUJRUc72adA88MV
         Mzyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739436770; x=1740041570;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KRQ3dUIptAKwY6MQYxUEHGw6dXXH6tF8Q68IhjO6QLY=;
        b=AfEhbnsgCZ7+q5TomlPwHScypG7WE7yZLZtt/au7p8G8UoC50R42vC+xxXKv1I8s/2
         Zi6bG3yOL+QKe5o9la0qDuHW7Hv596wtNjw7MougEs3tq8nfK5xFfoFlZztv/uIka7H3
         0cQeG7TWJBuxUPbLcLeXSGGGKdXlgYreD5sGKHR2JWisOtP0CaS3Ieu4uwPx6OvIGibQ
         6LGS+v5Tz/3pW4l6OpY023MDEFar5791O1VRQKRT0h2PdfZN2buCSYUZpTsXGXA5kqvT
         yiCe1qQHVLBrhxSg9LeeAmtAHZiaC0evkvN5IufNya9n2GJ3/lLaO27o1dZUAOHO6+do
         FGqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLd61PYythtnMTazsVPAgi2zr93n2tLJPRAsod4y4ioBBYPCSz/Tp9m9SIfQmQ9ll3CQxeDtA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwW/7GV6NKADFFrV4GwD0BxIbUFMdIambeLisAYaq/q7R5kjqYK
	m2igUYaOGJYsSTvaS7f9zuL3b0Ni9spS1tzO6B2V6LplBSedniULEGSzdEy67jYGo0UkNobbv6h
	brbenEeyK+h83z7aLS03655tRuZw2xz++vrEG6w==
X-Gm-Gg: ASbGncssk6OtcV267oY+6UHtFoefG0+Dy19ICxTpfa9TqexJ3eQDh0jlTTHq4u7thvc
	rVWtN0HD0w6CBpVHDo1YTBtjNZgBWSY4og7mSbKhFCnXtQfTLFpJ6G2IFDCysQeJ6cRwHJAjTW+
	8=
X-Google-Smtp-Source: AGHT+IFnDuYWfE3Q7CuyUtwzYDsXyv9n6Um+OIw404XCQ3zk/sY/TE8+9JT3A2om7er1oTaCb7OwGKlKwkPboIKhvIY=
X-Received: by 2002:a05:6102:4187:b0:4bb:d062:452 with SMTP id
 ada2fe7eead31-4bbf207219fmr5886514137.3.1739436770171; Thu, 13 Feb 2025
 00:52:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CA+G9fYt6Cuu6=OO9w80yhJbZB77Q0qf7nzYdvjbgDbgAw6t1jw@mail.gmail.com>
 <8634gku30g.wl-maz@kernel.org> <3902208d-8814-46fe-ba98-3db833b9a886@stanley.mountain>
 <86wmdvs1oh.wl-maz@kernel.org>
In-Reply-To: <86wmdvs1oh.wl-maz@kernel.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 13 Feb 2025 14:22:39 +0530
X-Gm-Features: AWEUYZlmVi_oOrzpHstaYQ-1DQU14Cx8usJ0Mr5C5xxxvEXLMKHSQVpMklUZaec
Message-ID: <CA+G9fYtKxd8C5W4e5sO93TMC77pRVyJYL8w+i6q988jHk6ztxw@mail.gmail.com>
Subject: Re: kvm: nVHE hyp panic at: __kvm_nvhe_kvm_hyp_handle_sysre
To: Marc Zyngier <maz@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, kvmarm@lists.linux.dev, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	open list <linux-kernel@vger.kernel.org>, virtualization@lists.linux.dev, 
	Mark Brown <broonie@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 12 Feb 2025 at 19:30, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 12 Feb 2025 11:41:38 +0000,
> Dan Carpenter <dan.carpenter@linaro.org> wrote:
> >
> > On Tue, Feb 11, 2025 at 11:36:31AM +0000, Marc Zyngier wrote:
> > > For the crash at hand, which clearly shows nVHE, can you report
> > > whether the following hack fixes it for you?
> > >
> > >     M.
> >
> > No luck, I'm afraid.  It still crashes the same way.
>
> Right. It was one level deeper. The following change fixes it for
> me. YMMV.

Anders applied this patch and tested on rk3399-rock-pi-4b,
and confirmed that the regression is resolved.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Link:
 - https://lkft.validation.linaro.org/scheduler/job/8119717#L1251

>
>         M.
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index f838a45665f26..b899d815d272f 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -501,9 +501,22 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
>         return true;
>  }
>
> +/* Open-coded version of timer_get_offset() to allow for kern_hyp_va() */
> +static inline u64 hyp_timer_get_offset(struct arch_timer_context *ctxt)
> +{
> +       u64 offset = 0;
> +
> +       if (ctxt->offset.vm_offset)
> +               offset += *kern_hyp_va(ctxt->offset.vm_offset);
> +       if (ctxt->offset.vcpu_offset)
> +               offset += *kern_hyp_va(ctxt->offset.vcpu_offset);
> +
> +       return offset;
> +}
> +
>  static inline u64 compute_counter_value(struct arch_timer_context *ctxt)
>  {
> -       return arch_timer_read_cntpct_el0() - timer_get_offset(ctxt);
> +       return arch_timer_read_cntpct_el0() - hyp_timer_get_offset(ctxt);
>  }
>
>  static bool kvm_handle_cntxct(struct kvm_vcpu *vcpu)
>
> --
> Without deviation from the norm, progress is not possible.

--
Linaro LKFT
https://lkft.linaro.org
