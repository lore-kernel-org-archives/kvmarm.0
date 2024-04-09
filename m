Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A40F7FBB7
	for <kvmarm@lists.linux.dev>; Tue,  9 Apr 2024 09:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712655291; cv=none; b=JulFlONQWqKNzEnlQbDKpddeehuBlhR9hHur5UYnAyFibFibB3Kj0uDuoBb13L3piOdSF+J7xC5aXNULEm7idU/DyhL3h4zyTzSTCnFM6WJad8zIxbiCCs7lDAbhvXlLsVBD/x82U/UoYXypIprcDh8PUWbHTnbRZLT38X45YEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712655291; c=relaxed/simple;
	bh=xB2/qy9W3d9EgJd3xQojedunrEZFzu/RNEA00n3YCMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hq7V+JzoVR/ZBS47Ll0WvL7KTmWSeoWIFlMOMiRGjMBosY/yNSFPBTiYs4Cpu5RpebqV8Ej4p4FEJ88JitFTGA/XMJhd/m3KfMqW5nDV12G4Awkp0PmtCeAZQALntDtfB+AgVUOxAYzh7942W+2j433j0N77cNWgcpCBva8/Js0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jk2Xb+A8; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jk2Xb+A8"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-479e12bde9fso1326267137.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Apr 2024 02:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712655289; x=1713260089; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TnO1yqi2WXeFs1xkme74/QF8fZz3eSneNjm1ucrfI4c=;
        b=Jk2Xb+A8rJ2QzCPAOanBRr9CFW+yjiqglR/xL6Y9cyCGyD05OYAvnFOBnynDLJcAzq
         iWthBP3nsmwrp5C/gvFnzUc8sp1jnq2J/8gjaUq1XC0xijHBaN0/jcOhpfi0ksQfWJq3
         NqYYauuvtk3u29X5RbjrCpUFq0p/x3afkk1GAKqoMzY2pCWHTP1n01Xuf904kV0ZA+7j
         F9eNQ75P90G5tv1n5f9sJjONM+69R3M3c4zCtKBG40uIQE1YNhEvlVUAWdpiGo9HM9zG
         eH9sLO9VzUag9oHoCHN8aLFnYAY/uZCeGvEP1yXb/YPKDn0NhVF+1QucDqMubqX1iHG3
         Mayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712655289; x=1713260089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TnO1yqi2WXeFs1xkme74/QF8fZz3eSneNjm1ucrfI4c=;
        b=s3ajifNihxlJOkujnSj3dJLepIZ+YAbSucqEYSAOmjOjlBotJ3DfTS/wyFBdyBI7lO
         uZ7+yPjlImQ7IdKAQlA3DHJH2guZzpuYx5zKP6pTnsAd3xUHI8K+HHdBfXPr73hnXaaX
         kFzbpiF4zH3XlVe0E4c8Ohg0Ay3gkc7Oe2+L75an7YO6xrLi4t1N3rs+9z163iUe1GHz
         xiGERRk/vqhr+xWjDe6jRGriOBTWB0pl9m2FL8fXbkq9ZJyDWGVOZruKHma0JmHKvlPE
         aS48S8fsfx5tOvwx2B/BJJQHfky/ZM42H7A0g94p1g90bZ9drRjcTznPr7vp61hEIEwk
         Ocug==
X-Gm-Message-State: AOJu0Yxc1wo3TQnbcXqqa3AL3nQnIOE9yamBmRmGjOvTLxl5+ovMO5zN
	H5LRWeQx3vVJUfTfTGGXQufOOk8cvSgG6XTqgbRC4W/z6D54k7PQhvcwbjFoaGkW/7tL0bKQ4Hz
	z3X3rx6HnKewvfcIq6uM1ZdPH1/KkIL0PanI2
X-Google-Smtp-Source: AGHT+IFsHLVEiuA+TIrMu6Qq/X0bctXHzfaHpHMv6zUj0d8kTV8KCOZwf4UVzBr3qLyiGhDM2N7j6lNrubP4LsJfZi0=
X-Received: by 2002:a05:6102:3ec6:b0:476:ce4f:a365 with SMTP id
 n6-20020a0561023ec600b00476ce4fa365mr10136600vsv.28.1712655289024; Tue, 09
 Apr 2024 02:34:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com> <20240327173531.1379685-16-tabba@google.com>
 <0cf02eac-318f-4507-8ca7-510dbb1ca98d@sirena.org.uk>
In-Reply-To: <0cf02eac-318f-4507-8ca7-510dbb1ca98d@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 9 Apr 2024 10:34:12 +0100
Message-ID: <CA+EHjTz0ciZOZjUbY5+QBsEQUaCkGHRbu_91Dynqjn2EXabnfQ@mail.gmail.com>
Subject: Re: [PATCH v1 15/44] KVM: arm64: Use active guest SVE vector length
 on guest restore
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, mark.rutland@arm.com, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,


On Thu, Mar 28, 2024 at 7:17=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Wed, Mar 27, 2024 at 05:35:02PM +0000, Fuad Tabba wrote:
> > On restoring guest SVE state, use the guest's current active
> > vector length. This reduces the amount of restoring for the cases
>
> For this to work don't we also need to also save the state with the
> currently operational guest VL, all the saves and loads are done with VL
> dependent operations?  It has crossed my mind to save and load the guest
> state with the currently active guest VL since that's probably a little
> quicker but we don't appear to be doing that.
>
> > where the maximum size isn't used. Moreover, it fixes a bug where
> > the ZCR_EL2 value wasn't being set when restoring the guest
> > state, potentially corrupting it.

I apologize, but I realized that I'm missing other patches that should
have gone before this. I'll either include them on the respin, or drop
this altogether for now.

> >  static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
> >  {
> > -     sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
>
> What was the bug with ZCR_EL2 not being set - I'm not clear how this
> could be skipped?
>
> > +     u64 zcr_el1 =3D __vcpu_sys_reg(vcpu, ZCR_EL1);
> > +     u64 zcr_el2 =3D min(zcr_el1, vcpu_sve_max_vq(vcpu) - 1ULL);
>
> This works currently since all the bits other than LEN are either RES0
> or RAZ but will break if anything new is added, explicit extraction of
> LEN is probably safer though slight overhead.

Noted. I'll fix this on the respin (or future patches if this doesn't make =
it).

Thanks,
/fuad
