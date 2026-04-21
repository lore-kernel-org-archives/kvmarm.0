Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936E62517AF
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 01:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776736095; cv=pass; b=IXnTMEUgYGW4E/8kAAfY7NGlQ1rdrXmUeBzeNnV7z2FI4CkjH8WcNsqGRQy2w5gURWZdwiHvmWsNYIAnMWK8DPmR6F/QQ2ZE9M5kLRT41INbqTxbK2uhQy3pN7vkcDYERKi4UjZjqNCbJz7eQKIjB4rUVUCxubR4TKRYaCc2UXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776736095; c=relaxed/simple;
	bh=Mojg7C7+NVFov05EqJ0IUfx/e0Bu+6+caM7VnthMIjg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LQxe/e+q5pjD2+xuioZ8RU8jLFXO5U9UsBvw/j7QBrjMM42mu09QqgmwgI5KScG8F9DGB0vH5CWL+gj5yf+2FpOm8cGAdRHRQRCrF4lbv2tlhd1X6/HF7mshHrW35XTEf7QxmwXZFMyrOdthyzch8QFPUzSKywqdWCzBOlMPrPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cMJclMHS; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cMJclMHS"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-78fc4425b6bso28681627b3.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 18:48:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776736093; cv=none;
        d=google.com; s=arc-20240605;
        b=Mizf+5DS31kj0cFTZ9e6KEKKod+AqosplS1YuS/crYoYmQn6hHNDS+YfgJH1Qz2jPr
         f2oUDD4nWxDG0SxEuBu+I+14T96lbGob2lZAwfyeC+lsEI0S4EojHvcKoJ26et6KXYwJ
         FCfD/2h4DuTKptCCyDy4gX4fRjkVIqKwOEd2XPqU0Uc9WLL4T9WB8w7CMU8PiGri/g+o
         YN4ZORKJemcrkWRYOEFnyMTCHMz31l9zBbQYCke59eQ+rnZcBlnTyomhuAUOLF8sEIZR
         PQDjwy3Wg+MN7KcyFL6wPWfoM/WeYlnoOP5w4mUQH+RxOA/0IiquvHohlrlBX3bYWyj/
         fmOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1bsPTwr1gAw0STIXQVY5UeTADBqDM+iND31hoYyVkv0=;
        fh=mU2ydR+Hd4TNhO9odbnAiYwVIMQ3Tqe6gCBv1ZG+lHI=;
        b=Ca5oquy8JzPWBJXeMXHaIVsBBHQ255LFGf7fQNrMOwt7oBdmxKjnUYpFFmypviWnJ3
         An1OPFEFZJUsW++TVtrpjLz1SA8Wno+/32C6op4Fx41EiB5w++sTjIGq2IDBfVZEXYqn
         yb9ye9eoZ7+MLH30RLG3xIFI31P8BrbRyulBbo2L+jJdttPYeHY+Zts5uVgf51cNn24p
         AqpDd+mldHeKtpLC4UoeRNCkMU1sajcwtChPXFcpf9iCXewcOYp42gBdTVdB6QuMYzXP
         tqh+6QPiiMZ29LlvmqijZA7ntm9fu8TFkJpf508zrfTvvj03XTaOfIlnSJr5sQPEsLUL
         4RiQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776736093; x=1777340893; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bsPTwr1gAw0STIXQVY5UeTADBqDM+iND31hoYyVkv0=;
        b=cMJclMHSxcWVyxthMg9N8z1H8i4bqFe6oewnvg0WV2s8YX/cVR3CUP4UrtWwtp192+
         PMNCqZuE8pZ1L00mhWF90VjjTEfd+33wNQYZP3oZCdVrFRwAq9P6NfAX+w+s4n6Q4EP5
         ZWzJ9+Vp+BCp89taLlHI5s9VKxNFm0cTm/qimEWAb6CqkyLDK1HpzSHPbh0Y8NtzNX48
         9w9yaCuvZIGnzQGHa/V7IerVCpztJSIMZllF+T4kwCuuPsFghdQ0cEXJSkytIL4PFA6S
         LiHGP116EJBZPgULkDepyRsI9ofdyzx55JleoIfGvGNtOqKIkutEDnLMonN5eKoUodTl
         W6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776736093; x=1777340893;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1bsPTwr1gAw0STIXQVY5UeTADBqDM+iND31hoYyVkv0=;
        b=GlNEwVg+JGbE2bwvS6jYcOeds0m1XOaZ3NCgtHrvxaOjJVuuQuWEEw5bu9UhXNt4bS
         caBpOO32sAX4Yok3Tyy3a0NYd7R9vxScJ232/tdvI5jNfKDNBdwlhlIL5ftHHnK1eXNW
         Td1aA+8JZaa88WyRhUQfoLbQed0CL6xrv+n52FNhhvN37vh68cdklGeRIC4hqFxiyesT
         9zAMvT9pnE1PZTfeUQ0fYIULQp3gctJ8vyd50KnMrVm9T7dQQKesJQIUbddw5vArbmTk
         iBH3ncnU3G3PaHp1CGSgHfTb3kcOy+VI9c1qMuuj0Xie8rLR+mqT257qMMHRAEqOU16p
         ZoQA==
X-Forwarded-Encrypted: i=1; AFNElJ95IjB4snKqaVgVo3MrGlb1yB2f7XmnYdwgCb5BflaMz1sUq0SXEVp8sNnUOGCzj2zYxJ+jJO0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDJhkkF4YpQIdWH7y9dwcDDwal9WMAOTL14eD4SzDDxIJrgyC2
	0DeBj4U+edWvR49oPyCaGqaoz11ozB7GfO6bYsgv4GmH1BVBpuUmxi93P78qk+O2W7cPz6H6q0Z
	iBrCeY5emakL63LVhht3l9yjbAGi1/dI=
X-Gm-Gg: AeBDieutlQyHX81RDMUvy2QHo0PPCcterZQw371FbuIBhdTCLQoYFdNI1JConfjXANp
	7Q3d1OocEqMIFHnzQ5i02+qpYhUxJzj3I/tVWwm3j9/SB4xUq+XvRW1Vg57Q8yhYR1JmLjmzXoh
	SiGFpNCSiqPfTZwugM9l2XVI1nFwXASub2dxoQvG7LOjKGJUvmHbQraSGMV9jNmrz2GpzWfTGoa
	XngqRZJdVekOeM76L6kXd6Q5BGGRToaqvvPoOSaC0dcdqmOQ9ugOhMKClLrEDvGcxUzKxo8Pt+D
	s9ZjMph9iw1a5U9G+1em5k1NOKN5RzW1mxhWF2UHqx/+wlNGnzCRrWqRMzU0K2nuqDiLWoS5JmH
	aUPLt
X-Received: by 2002:a05:690c:c511:b0:7ba:f056:9dfa with SMTP id
 00721157ae682-7baf056a27amr61371247b3.27.1776736093552; Mon, 20 Apr 2026
 18:48:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260412080437.38782-1-kartikey406@gmail.com> <865x5r2dik.wl-maz@kernel.org>
In-Reply-To: <865x5r2dik.wl-maz@kernel.org>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 21 Apr 2026 07:18:02 +0530
X-Gm-Features: AQROBzDLrHnv7airCGGjaBWUTwxc6pwlsiqRT1yXWgBrUbR7TxbGb5jMVqZbUDc
Message-ID: <CADhLXY4pL2BrPukVxr_kySzx48gMt7zFxOq8=eFSXqOB4at7aQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: KVM: Initialize vGIC before preempt-disabled
 section in kvm_reset_vcpu()
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	drjones@redhat.com, christoffer.dall@arm.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, 
	syzbot+12b178b7c756664d2518@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 7:50=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Sun, 12 Apr 2026 09:04:37 +0100,
> Deepanshu Kartikey <kartikey406@gmail.com> wrote:
> >
> > kvm_reset_vcpu() calls kvm_timer_vcpu_reset() inside a preempt-disabled
> > section to avoid races with preempt notifiers that also call vcpu put/l=
oad.
> >
> > However, kvm_timer_vcpu_reset() eventually calls kvm_vgic_inject_irq()
> > which triggers vgic_lazy_init() if the vGIC has not been initialized ye=
t.
> > vgic_lazy_init() acquires a mutex and calls vgic_init() which invokes
> > synchronize_srcu_expedited() -- both of which may sleep. Sleeping insid=
e
> > a preempt-disabled section is illegal and causes:
> >
> >   BUG: scheduling while atomic: syz.1.49/3699/0x00000002
> >
> > Fix this by calling vgic_lazy_init() before preempt_disable(). On the
> > second call inside kvm_vgic_inject_irq(), vgic_initialized() will retur=
n
> > true and vgic_lazy_init() will return immediately without sleeping.
> >
>
> I think this really goes in the wrong direction. Forcing the vgic (a
> global resource) to initialise when the vcpu's timer (a local
> resource) is reset feels at best bizarre. Now you are promoting it to
> be forced at vcpu reset. This makes things worse.
>
> You probably want to take a step back and look at *why* we end-up
> here. The core reason seems to be that the timer emulation caches the
> level in a per-timer structure, and tries hard not call into the vgic
> unless the level changes. Which means that unless the vgic is
> initialised and is able to latch that state, the initial pending state
> will not be propagated to the guest.
>
> But do we need this optimisation? I don't think so. Other emulated
> devices don't require it. We can let the vgic know the state of the
> timer at every vcpu entry, just like we do for other virtual
> interrupts that the kernel injects (PMU, vgic MI).
>
> Once you remove the this cache and the need for the vgic to buffer
> things outside of normal execution, you can also drop the magic init
> from the interrupt injection path, because the injection will happen
> on the run path, just like any other PPI.
>
> That'd be a much better approach IMO.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.


Hi Marc,

Thank you for the detailed feedback! I apologize for the delayed
response =E2=80=94 I was away on holiday.

I understand your point. My fix addresses the symptom rather than the
root cause. Forcing vGIC (a global resource) to initialize during
timer (a local resource) reset is not the right approach.

I will take your suggestion and work on:

I will send a v2 once I have something ready.

Thanks again for the guidance!

Best regards,
Deeanshu Kartikey
