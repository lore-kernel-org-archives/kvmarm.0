Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905DB19CCEC
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 11:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732100554; cv=none; b=M2oNlFiH5zdvd8Od/9DUJ9LwHURkQXZEEFM6BPvPWCsubkY+4c8ORtWl56rrfPWeNKAROt3ru+cybIh5rrwLX1vnzFlbivUAY/z39JVMzWQgbh+m0V7oZiAhMOa8O6TSeZOuM17E+vREYZM0JFr0va+eMIdD3XPdJJDBSuiMM94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732100554; c=relaxed/simple;
	bh=UaIFaPHAN99w9qz7TofjnOcBOs6nN62ynwBUyqP8ERI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KCzQX3jjwwWWMCbnpOEMuhkEkwwzXo38KJPtKZVt/h1DuZ9l8Jgss+ea2vU3UJIMPW2Tz2ZOgvHgnf0RYNyjGxIVDd+ypH/tJeU0+bB0bItzmz+vtMX4QbROBqhFzr6JSmG9WWI0lqa436rWjGMiltXCximLWJnR2tRb74AFPEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vzMQt/Xb; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vzMQt/Xb"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43150ea2db6so121445e9.0
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 03:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732100550; x=1732705350; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=noKpNbsu/8J3MQcJ0MB00uooJSIdAZ7N8CsX2/H7nrg=;
        b=vzMQt/XblwigPf+tHF7hDdjPRttI+o3DWfJExiYRW0PnbZpzmMwGqBBVwu+WvN1BJo
         da4gsjpR2S/FimyJ8duhvzQpNvKi88cAzJVeiUhd7l+pdDFiBDrBF/J80qWFHOj6Eegm
         GBkbokrtYTEZtu+QwC8PCvE7vgpjaUSfqh4F/HK2wAKtT2hfKxc01esLpTFDvw3NnSpG
         L7ZP2QENrK+3pPuBiwDnpxFBbxQIHdIA7ru8U5y393kh1WDhOvUV+QqtPo2a0PmQ823K
         R0bQnqN6M5L7GZ7qkB/DhOARWFKfjQtKBidyBlk5qO3AUWcUw8Ib5ywsXCbDTcckfq0T
         McPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732100550; x=1732705350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=noKpNbsu/8J3MQcJ0MB00uooJSIdAZ7N8CsX2/H7nrg=;
        b=M+NfLoq2htYHHB1y0dr6JZ2IZK25gTF4fYf6ZP20OcBWrU1OuT/HAxX60twtYKUZat
         Q6aOtIA5RP5s0gJUo8s4mc2BhWU0lp923o8IysVEH2yKidyooDRW7dDJJ8WwVPBT+oHr
         aLxGrsuGKdn1X6ycSgYnorAnl/VgxTZljvWirUEXIyC4bL2TVZUkGbRF4Q6SSOyXIR7n
         +giv5WN6DRGxdiNpu6CB9N5DGeThJU1+WM1CwpFtxH4y4d1LqWVMaHUmOofqDvgbrG8T
         i42Z+53X+LeLvsK3s0X9uGin05kwTBXqB7StFMWcEQQPvQMZoB86Qml+7kveFZJnJ2JM
         Ukvg==
X-Gm-Message-State: AOJu0Ywy7IaTtG/+n1DCgPKJJCcodBh30Eop933ViRKMR2Br93fAM3sv
	lIhIqB9mdfvpR42dFNhW5T74u0CF9K9GVlpRnGf/PPkZEiRSLDCODlQiULHb0Rju8WSDDYiSQdQ
	7uc7058qSdQXu4/rBMacv17VMa/bxYldNzmidpZ80M75oRWSQ6Q==
X-Gm-Gg: ASbGnctjKdpYvyAk+klD542KLhAXTT6NrGxzTYCD8OUT4M+rS5+1pv1K8yRMaN/l5St
	aNGeJApsDgVJNWNL/edvmzCKaUUpZMZg+Bcg4u4z6vopaQ0PsEwEcT5R8wKIF
X-Google-Smtp-Source: AGHT+IFWapXmeo6Cj0T9528tM07HHvM3xMoQi/T027qGlMPAxMjPrqnczz9/mYUi1PPvJ9NTm45LmkIXT7oK3OkNXIk=
X-Received: by 2002:a05:600c:1c0d:b0:42b:a8fc:3937 with SMTP id
 5b1f17b1804b1-4334899de42mr997515e9.4.1732100550453; Wed, 20 Nov 2024
 03:02:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com> <20241120105254.2842020-13-tabba@google.com>
In-Reply-To: <20241120105254.2842020-13-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 Nov 2024 11:01:53 +0000
Message-ID: <CA+EHjTz=i2YAoh=CVG57YtP23JK1VJ=5JuvF1Gm92_wUJKmrzg@mail.gmail.com>
Subject: Re: [PATCH v1 12/12] fixup! KVM: arm64: Initialize feature id
 registers for protected VMs
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

Apologies for this patch. I made a mistake when generating the latest
set of patches.

Cheers,
/fuad

On Wed, 20 Nov 2024 at 10:53, Fuad Tabba <tabba@google.com> wrote:
>
> ---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 54f23d9fea18..62d06d5f5bca 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -477,7 +477,6 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
>   */
>  void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
>  {
> -       /* List of feature registers to reset for protected VMs. */
>         const u32 pvm_feat_id_regs[] = {
>                 SYS_ID_AA64PFR0_EL1,
>                 SYS_ID_AA64PFR1_EL1,
> --
> 2.47.0.338.g60cca15819-goog
>
