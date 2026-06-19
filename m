Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB06833344A
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781855201; cv=pass; b=giPU8AwMr4N+EYstdMSd00amy1f8uZUx1OWznmhEbCaispyGU+9k739KV6dIqWjsKXLcSSQSQrWKP890dVZN7sGGtG6nZof3+pOs2y4R3y6tXcWSvexdCoMpcyuLcCxqObyv6GYrH/gfb99PY+GgmkkxarN7lUQuEOjGdank6vU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781855201; c=relaxed/simple;
	bh=xcty0z9UhnNB36J/7EuELFPBfvGhxlFASPGjSU2sjM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nxDJHy3ZDCuYsIqkBFXv37eLhRLYTb3TyGGGZylyKRuBh/s9JZGhrgqqU4CEiBBw3/Lz+MPbnRQl3uXmqdea6m0JizeeA3ShWnH3QKJvrNZN6S6wT4P1izTeFeS69I1eU8IX6549gNjl5lHDLSpV6G4TY8jfOrOZl5eS9hrYc98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TjfTyaqL; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TjfTyaqL"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5177d1ff061so108461cf.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:46:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781855198; cv=none;
        d=google.com; s=arc-20260327;
        b=NkT1aZXqIvmU02/YSr06tWgyEl22UQkx0UyB9f7SnJInvrLrsAAOgqgE3unAPvPTlH
         bks9U7VuZfG1HJcRc3a9nE2lkS5iTzJWHIwilBfIxWIk7UQy1RQY3F3TSlb6AGNlPGp3
         qTwBOefi7gxZoN4e5/Cc7lvm9Xsz6xLl3u/R0oD0mUcmRf1J1Lx16cw8kp5xw3xlTgfo
         ZVfm1kYl/vkibPTpfjd1aMXQkPwRZ6oNK1fJ9L3ytkAwTNGX4YpCleFB9U/Cwc4ng6RC
         iMaIkWWuvAt7haSmUabt3bSSdGbGJjILlTFhYHMKYW7ftGqd1auPpy5zI1ZfPS6qId5O
         OYYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uoBb9RhhJXeg2IBb64GG0HTmaW92lKQM/iFsDpm0ln4=;
        fh=o3NEfJSjrKd/G01UfnCDhWJebsK5fpobqpi06Nd213I=;
        b=JlE1YZaXu3RxsV7WcRSlHzkFPW+TZxe4V9i5b3qpFlutHilDo3UBNyNCHUX2Gu+7Bn
         NR6WtSTWDCKGgfQm+pqJ1jqVTtOD4WDx4m0HFoDDV/Ew/RIPDYK1kuvnlZpEwb/HD1MF
         CyDqzitFtIZjExx48L/YECddEYqI9e+ZjCz4tjr0/D+YllnNzrLLNZueHVyUEzCST3AC
         g80bbUZn5MDsH7jy/pPHmwX7GdLoRIR0ftrfbwbNHS8dXdLi2dd5l7RpDJIgRwLYTbow
         JJavF7KogiSbMrLU/rTlEhZHNLiN/yXrQn6eRNJPk3WBQmGqyFnXjEZxcYdj+mD3X89d
         dGmg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781855198; x=1782459998; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uoBb9RhhJXeg2IBb64GG0HTmaW92lKQM/iFsDpm0ln4=;
        b=TjfTyaqL8AlP5Nvnq3sPodiUfRmVIaSuY0vWJKKMysXKTy3bTDNHm7317cCzBFA1jI
         pQtzGzKwV54Itldn0pGqQLp9t5ttRyc8lcVL51aiSLcyaoLdeMryGaxTOo1kqQsbhe5k
         CNy7cbEIcsnflV9YCDtSY1GMCYREeIjZTFe6OSxnURS/m2MpVL56FwqvjIdfEUr6BQ4t
         2HyZ85IzzW8/ac2NJY1fwIZrRssxmRA7mpF2qS+/S3TJ0XeSGfxcNgFtMfeXYtk0t79h
         I5DHEHlfE0YaNa4EGmKGbrc2Hv+mprxICslB5Bod6pYUKm4CriPvx+OexNZY0xA4y96h
         YWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781855198; x=1782459998;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uoBb9RhhJXeg2IBb64GG0HTmaW92lKQM/iFsDpm0ln4=;
        b=c+p6+CpXs0FHrgaRZiykm7paLuvZLrwa74j9jmUyA6iMaaidsSo/2kwD4J/JM4jydz
         KWFLYkbKzOjEbrrlDBTlLMFXHM2MIo/CeWTNNYca0BvZNEKaN/TGYv5zKI1tw3yiSFVy
         NDjZx0NvzsZnX0O2YLMX9rj9753xMYZb2XBTzGuDd+AQJ4gnhkvuSSDyNTmRoo/B+Yrx
         edDon/sCpUjfLdxfcSXDMLZU6OB1qWqtxc6VwBa7+ewtKmPWWO6Wh+DYPLrEvH0n03Mw
         d9FkN6X3jy47P0wITcEU5qjbu1b1o0Sc9UC36sJa0agQ5Kl4S1nXNMVplsGoWjrUYuo+
         W08A==
X-Forwarded-Encrypted: i=1; AFNElJ+EX6UTy+5NGImF76opmWReWt6XpBf5ATwuKMorFy/3afAa1ATK4uAoz4zymhZ43Ar0xhfGoLM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtY+ZkyAofi6CwhBrUuV0rRbm4VK+PEaBmO17WRn7jw4J9MlrX
	NxdDBJ4WnII3TRbdoufJPaNP7+8esztGgZYOG8yvLOoXGa/lyCdOHywufc8TmYG6lvJDwWOvAEY
	22XywcX/KkX8ep1RoP5i19x8CKzKUSJMXklxMKu7X
X-Gm-Gg: AfdE7cnMRJ8AZ+8ejYr2nSRF1V+HI9UdgwsFlYngB3MMPA5Mk8Zx3PdFgidfvAPyp9v
	qjhgh4VYtyv0tCcLv81bbMNNTP6fkGQjAqSQsuG/F4rg1zBGjSyUu1OWJImy3wozVL2HUPXTRNZ
	TWAZFu/tpHxHZMtNM92LRZh72/JHg5IZ3gkTyVTxaDkLrCFGn1o1kuJoYArDQ9oo/ipEf/Yc1XC
	FA5WmhlwaWCKAmpk3AdnNnrJ1WxrpDEuKZnZgGP45hDGpgijYo9hfKHfw1JL2G81PPjhMrJISg4
	7XJJMiux
X-Received: by 2002:a05:622a:2489:b0:519:56a8:2693 with SMTP id
 d75a77b69052e-519e4a7350amr6361661cf.24.1781855197057; Fri, 19 Jun 2026
 00:46:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com> <20260619070719.812227-8-tabba@google.com>
 <20260619072121.395E71F000E9@smtp.kernel.org> <86bjd7rn86.wl-maz@kernel.org>
In-Reply-To: <86bjd7rn86.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 08:45:59 +0100
X-Gm-Features: AVVi8Cc5P1L4xDU-nNWT0r99gLLz_hNu_mDPa9aphJH_JNODIeQOsQU0RdoZtMA
Message-ID: <CA+EHjTw2Q=QV_oXioGeJpY9ycNAD7m5ZmFjBxiwH3vwETchh5g@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] KVM: arm64: Add primitives to flush/sync the VGIC
 state at EL2
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Jun 2026 at 08:41, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 19 Jun 2026 08:21:20 +0100,
> sashiko-bot@kernel.org wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> >
> > New issues:
> > - [High] flush_hyp_vgic_state() fails to copy vgic_vmcr from the host vCPU to the hyp vCPU, causing host-side VMCR updates to be silently lost and subsequently clobbered.
> >
> > Pre-existing issues:
> > - [High] flush_hyp_vcpu() unconditionally copies mdcr_el2 from the untrusted host vCPU, allowing the host to control debug trap configurations for protected VMs.
> > --
> >
> > commit 5eaa1440f7e2f022736f913bec34aaa0cbd53a5d
> > Author: Marc Zyngier <maz@kernel.org>
> >
> > KVM: arm64: Add primitives to flush/sync the VGIC state at EL2
> >
> > pKVM performs its own world switch for protected VMs but has no primitives
> > to move the per-vCPU VGIC state between the host and hypervisor vCPU
> > contexts. Add flush_hyp_vgic_state() and sync_hyp_vgic_state() to handle
> > the required copying.
> >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > index f3233ee343a39..2db56146ec493 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > [ ... ]
> > > @@ -104,6 +104,45 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
> > >     *host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
> > >  }
> > >
> > > +static void flush_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> > > +{
> > > +   struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> > > +   struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
> > > +   unsigned int used_lrs, i;
> > > +
> > > +   host_cpu_if     = &host_vcpu->arch.vgic_cpu.vgic_v3;
> > > +   hyp_cpu_if      = &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> > > +
> > > +   used_lrs        = host_cpu_if->used_lrs;
> > > +   used_lrs        = min(used_lrs, hyp_gicv3_nr_lr);
> > > +
> > > +   hyp_cpu_if->vgic_hcr    = host_cpu_if->vgic_hcr;
> > > +   /* Should be a one-off */
> >
> > [Severity: High]
> > Does flush_hyp_vgic_state() need to copy vgic_vmcr from the host vCPU to the
> > hyp vCPU here?
> >
> > For GICv2-on-GICv3 emulation, guest writes to GICC_VMCR and GICC_CTLR trap
> > to the host (EL1) as MMIO.
>
> GICC_VMCR doesn't exist, so the guest can't write to it. There is no
> MMIO involved with pKVM, since it is GICv3 only. And the whole point
> of having a VGIC is to avoid trapping on each access.
>
> More importantly, VMCR is not allowed to change behind the guest's
> back, because it contains the state that the *guest* has programmed
> there.
>
> Can someone *please* unplug Sashiko? I've had enough of it.

I am trying to at least fix it :) Key phrase I am adding in my PR:

`## Grounding: you do not have the ARM ARM`

along with other things, so it wouldn't hallucinate it :)

Testing this now locally before I send the PR.

Cheers,
/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
