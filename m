Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97DE4779BE
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 15:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338413; cv=pass; b=IXYBS8FXP0jPHOD3H4Rt46QjhJvLhmL5KkJbzbh9/ERuspTy74eJZCZSuge+TeXNrGzBDA3Joo5G6dkm5bjOCqQu5sfEkF/r/sDZrEI9skYESjONLRGPmSKYiPudlnrppXp1yxhslcEqmM4LHYFvzG67FQ/HtVNQNnzY2P9nq2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338413; c=relaxed/simple;
	bh=3BAdkEbGZqLfwXxKr2RxchaDtVa9lkmIZOkFm2/fWWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uOSspNp6SJPyragEl2jCmuLrR+I5LwcaFmY5qTuTEPaXIJGoiT7dLQA7HN0ZLTtql7ne/eMquoveB0TehA06MQ4c5+D7qt+GxdU7+K2kIuB3JrMsu3JqUHE47omsnPusmC/EvVt9jeQS/7JyqjgEz2Z/krv+fnt9+kN13uSy7oU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TcCJ9XvL; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TcCJ9XvL"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c10e86e52so279961cf.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 08:20:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785338410; cv=none;
        d=google.com; s=arc-20260327;
        b=YgM3eD0FAARWIDoBoMAhZfMcVkd/OkuERkpkoHvKMFLI7nPAWFBzlPfNorp8BwBUad
         wYYe2iIvjdyOgUEchQhNQC1dsveP9VQykq/WxPTrVd+sQLPRcYq4b+rzGkS/qfYPeTZR
         3MXk1X3qEH4T548INiRg/nXQYR4lppYDvomlWa3YsvKqh5qFKFC/isH86ziuMtee5LEw
         fJknri/2qrqOzb9HmysC16oFOtY8SSU449E4iWj8RYcJ6ImoYrVVAE2SvLCNBm3QlnrL
         PW69EmnzxHRMNqa1Q1Z0A1KmiqS5FbY60Gk/Q+Q3/I+s2l2Ll0TvyckfNdWMsW1VKzWY
         kzvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JYgZt/35SRTSOby0/Cc9E+OqarqONJhII6K0Q/18dbI=;
        fh=bXrkaioFycKQpC27YahRlP9bbkJJrvdNibQ13R62jR8=;
        b=hqwTrhROVBcFi7QZ6zDRyqXWnRC5pFKJVaScSOQj1AYkJIlrEzeNr4W7qCY4rap3Rx
         1w5IrkQb9qPCyChNRIsJuNcwesZUrG2jRsADMDuNo003g8khC+MyEBalCN10uLHuKwm7
         G4UKqYJ4vqPdeh26MFwLWEhYMallmr6OjthMQUi/nd/R7tRRzlikM1BjRRadEfIVBi21
         XWpbaOU+E/RIzQDVM0ciKlxnTLjJODYrsKfnZ4kvatNH/CnOFZ75fAljWfBkjaSsXqbm
         CN+T/mWshiwT2vA8o3dvpdo+Z8iG4uxPytF/5eEYW9BHpY4gRAhPcgwRhbuvAiR6jrRx
         +FMg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785338410; x=1785943210; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JYgZt/35SRTSOby0/Cc9E+OqarqONJhII6K0Q/18dbI=;
        b=TcCJ9XvL+nG/uis66wiZiUc1iy8Qz+d0WKUlgo4NMjvJupJdKc7uRFuXi1cnp2Q2vv
         Kg5LsIN2KU5veqP/nZuqs9jfzZLWoSdDCO3nwKEqvRgnbX9wccIpfOGc44SibUdZED7W
         zpaIwWXQCfm939dDwLwE+aElyaNPnQnFPU/ohdTjl4ZTd1UL6blTj9Hbb7Wrme8MHKyU
         kcD0Y/mUwLTnH2GdauXnu16+QZ80O/T74OvrTR44OPFu98ZPk+joLoNnYFmOpdpfRNgR
         8YRq1wJM/KFR8hNkeX3QRDllCo3wvm/iJkZBjYF1CHHPXPkCvJzZXmBICCpYWdueJTRd
         VrWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785338410; x=1785943210;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JYgZt/35SRTSOby0/Cc9E+OqarqONJhII6K0Q/18dbI=;
        b=Qgzj8vvkuSzCd5nDBrXWfP/jJsqqFg9Kdz6BG83ybUbCLEjg3J3H1en7btAlrJ1RRI
         uURPJSlYt8P8lmFxoMkrYg4/QVHHau1MXWC8Y990qbXeQcma0K/l78Ht1jp8WuHCOVuA
         vmM+kmBmyn1FbvvKXTu//vL12Gn5/+z2Fc505ScA4EEnz3Vd5PYYRvJLMiHLHU2UY+CH
         90fcm7VQcEchk6H5SHS0HFq6jsatEzDxitCk3faalPrmGmDsgZSCpzmjRuFVk4slgs89
         9489bBIBmf9OgAJIG3aznl1VmJVCOhuEjDoHO/4U5iYUq0T4H4rbrS08qOBEU+SUmMlv
         qLGw==
X-Forwarded-Encrypted: i=1; AHgh+RowYDuddsPZZgJLJFCsGJadgvh+706upQWoq3ivTKG+D0SGDUOsIUHfp8pczxAgg4IuvKDS/80=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzeb0YuoLcD5a4I5GkDn8fntzkPiAAixtxPp3onbU0mlZ0g8vUF
	ayF2Zm7VCiOXmPcQMgi/yLomhkThEzg8AXVMkjssdHtOpdqzD7egREfGtCq8QdLtgoGFrTm7VS2
	DDXdn3QrZB8hq55YTJl4II2YO5Uwf408gVv35YTpJ
X-Gm-Gg: AR+sD12b1PoJ+ko3vF/32d0Yt2Ao/Z5mC3VKmCKQX59FUNB1FtRGSKdo4IMDl36aH6x
	lNEe8621qpSNVyCfckuMqYTV5fu8hZGXt+1fS6XAQ+WJ6H6vyca70CNKamyX1iwJYuYDOVp4eI/
	M57bCchvl1Jd8OxDRTNCmTX7kNUzj2vI1F8deY63VCtvTsPaFX4UeuV1KXB/rW4mi04Erj3SrRB
	cXiA7QHjy/dqBMEFYgTa0kPnxKhZmrYMDcv9smIqJ73nBAT2+dxZcZ6TPr1o86qmgmmNBViogZJ
	qv/1prJnwigt0az8GWsU8gWf40Fpj4kNVYUdVp5wUJqotSqsLUO1V6PE820R5PqvgFYNqaDcatS
	d/nPmk3RcwQ==
X-Received: by 2002:a05:622a:9014:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-52b34e95118mr803001cf.4.1785338408902; Wed, 29 Jul 2026
 08:20:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp> <20260720-hybrid-v9-3-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-3-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 29 Jul 2026 16:19:31 +0100
X-Gm-Features: AUfX_mwnVrQrZWbAViwhlMWDHtZtcw4flUU1g4ENMs-4TGfR7On64kQESsXcw8M
Message-ID: <CA+EHjTyYk0Dcc-8RbvQZHFBZ7HM7cekfg3O5MR4jo57qX5SohA@mail.gmail.com>
Subject: Re: [PATCH v9 03/16] KVM: arm64: PMU: Freeze counter count after
 first run
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Steffen Eiden <seiden@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Jul 2026 at 06:39, Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> PMU configuration is VM-scoped, but SET_NR_COUNTERS can be issued
> through any vCPU. Checking only whether that vCPU's PMU has been
> initialized allows userspace to change the counter count through an idle
> sibling after another vCPU has run.
>
> Reject the attribute once any vCPU has run. This keeps the VM-wide
> implemented counter mask and the PMCR_EL0.N value stable after guest
> execution begins.
>
> Fixes: b7628c797376 ("KVM: arm64: Allow userspace to limit the number of PMU counters for EL2 VMs")
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/pmu-emul.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index b5df6843dbcd..b4b877f31097 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1087,6 +1087,9 @@ static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
>  {
>         struct kvm *kvm = vcpu->kvm;
>
> +       if (kvm_vm_has_ran_once(kvm))
> +               return -EBUSY;
> +
>         if (!kvm->arch.arm_pmu)
>                 return -EINVAL;
>
>
> --
> 2.55.0
>
>
