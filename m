Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212E71D6DDC
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 08:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728980385; cv=none; b=FOJUjyWi4NrgCRSyVeDXu08eR+W+IfW2wckv1iqtumDmHMVi71yLV6Sfge3fkUvyupUIT7nEMu0Tb6kEsqnONfCh7UrxveOzaRDasdESDAOxIGPLol7LV2S0ZHakDWkJAmz0VTlN8hyGNAQJtQt07SB1pqNGAQ3Iu62NwYklEcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728980385; c=relaxed/simple;
	bh=iTXJwFIgD7Qdp7h2WcA+uKpYlTBncr52G0CuD6VfkFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tKKW4zIuFu828L988S3lexkv3AE4BRcaHHFzHXngFc3LLcsbOwPVB2msvcp+gI9ccNE7K59rKlpvC+R5McMBVjlTxP/yuLwAaeMt6kojoPXz5fe9mCBxV2WZsI9MAFJBRCV6tGUgE8088nCJdGDQY7E30yXotIL78drQh/JFd40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OpwD3koS; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OpwD3koS"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-539e681ba70so38506e87.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 01:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728980382; x=1729585182; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6NG5PSuVk39K7YK+uAxWBTVr6E+ZS2BWX+S3DckcAyo=;
        b=OpwD3koSg1lR4DMLBZS3IP1P1zLAbLF5CZqXNrt9PVTC3yK0uBmbiYfdzHITUTBjeI
         7jhadkuoYGH+LwMuTqQn0I1ae6hzwq1ZaqBJml3/RRGR9vNrrfQ30Xd4E2qF6pbeGhR/
         Rbpaqqu2k11ERdr7qhPOh4FJXD/dPR/gSaiYOpQAsDhAlwnPi6z5NXprZa+q66FTtfRw
         qrDvImXp8vmfB5GFIizED3QZhdxIsaj5YgXZP7mufx9LB/axSepyFO4ujJ4OcUJSdn9v
         HpnLsOvL8C5yi+zpP3W/W5qK2L+bA5gkQYUeJImua0vVZNnLkJtfMTMfvGMhq3b5Kx2H
         M+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728980382; x=1729585182;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6NG5PSuVk39K7YK+uAxWBTVr6E+ZS2BWX+S3DckcAyo=;
        b=E9MrltUNTrgB5U8CwvPGlT8wzFxpjZFVmPuGSNwDZzweXwt3Tm21Q9mh4486ExYgDQ
         DxD7bieO4nUjU/xeROtExV8JlMdQrBFaTv4r4WAcoZujdtjoGpA2eNHfwfOa3Ab+zWkz
         FSUy0lU1bT0la7u2oLEhN62ROmrOQbzeI2KhY+mKCfpbD6o7zY80FW/VtZzNHKQFuQ48
         YeXHjWnD32DTTjgXqbx1DVTJ+RWC2VgQi11AwO0e/8B08sI9kYXlg/nCIGxJCL4XGkia
         bem65Yv3s8AfAugP6HsGxZwihCc01O28nnPT7wsKUUVZCBTbNWs1zhgaVytxGK0Tbbzs
         0p8Q==
X-Gm-Message-State: AOJu0YxsU3tWEi1mZONLf2WRDhBfDBc+/2RgNA02kJVVDsAb7Alo93/O
	B4pKqMYxSG7eFU8jJqFaLX3/NhM4pnf+1kfzSU5eThjS4fefy3AzPsfv3LvNaa2XKwixh/+Xnlg
	N3x5r3AonkY7imbtwXt2nqHpQDq/C4k/FAOsA6Q4XuzZxIyfshQ==
X-Google-Smtp-Source: AGHT+IHfxzl14jQnVNPRx52bZJ3yacN8vsgGfZqMd+s/4Zi6+iqsuXoUxTgwvBHG65CVzuF08OmMLif0XxUCneBBvHM=
X-Received: by 2002:a05:6512:2821:b0:535:3d14:1313 with SMTP id
 2adb3069b0e04-539e5e762e7mr921214e87.0.1728980381985; Tue, 15 Oct 2024
 01:19:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241014102413.4092725-1-tabba@google.com> <20241014102413.4092725-5-tabba@google.com>
 <Zw4gUsF-j8H-x2CZ@linux.dev>
In-Reply-To: <Zw4gUsF-j8H-x2CZ@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 15 Oct 2024 09:19:03 +0100
Message-ID: <CA+EHjTzyAypPSXqrCxbc1oF5AH5P33GhtLruZfbFwY8GvnnSbg@mail.gmail.com>
Subject: Re: [PATCH v1 4/4] KVM: arm64: Initialize trap register values in hyp
 in pKVM
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, 15 Oct 2024 at 08:57, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Mon, Oct 14, 2024 at 11:24:12AM +0100, Fuad Tabba wrote:
> > Handle the initialization of trap registers at the hypervisor in
> > pKVM, even for non-protected guests. The host is not trusted with
> > the values of the trap registers, regardless of the VM type.
> > Therefore, when switching between the host and the guests, only
> > flush the required bits of the trap registers from the host's
> > view that are required for hyp-host communication.
>
> It'd be a bit more precise to just mention that the host is allowed to
> configure TWI and TWE still for opportunistic scheduling, as neither
> affects the protection of VMs or the hypervisor.

Sure, will do.

>
> >       pvm_init_trap_regs(vcpu);
> >       pvm_init_traps_aa64pfr0(vcpu);
> >       pvm_init_traps_aa64pfr1(vcpu);
>
> aside: it'd be great to reorganize all of these traps in terms of the
> affected trap register and not the feature register.
>
> But that can happen later.

I do have patches for that, but I thought I'll start with these first
since they pave the way to those.

Thanks,
/fuad

> --
> Thanks,
> Oliver
