Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5C23CE4A7
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 10:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781777917; cv=pass; b=dHtcVCGBBl1GxD/heXWgM8Me31pTKIjk6H5dOFqYDq5Wv+Ow4aW8wCEQV78wPU4V43o0OZ22ZYP/2jgR0msCEflr3Xi1U1V/OeOLFvZOJfLhxJXdTwcOxJhZK/aKr2Kg4/fqoRbqDpkWHEE8VEnOASeJuR5SGbLO4uroA9J3WTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781777917; c=relaxed/simple;
	bh=TtaugEzwOJfQo/R70PjAClcwyy5LTnOGY0jEYm58U5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oEydezpHovaew3EGcDhEar6pO83JQv1wcOqUDv4pMUkeLBJGoeBOCd4sY1LBALQ4VDPFzh0Eurwa5v7i3cw7ubnAiSDqCDCxWpdbkUk8Ff2NNfMuhfcJs0uVfzg6Y0/3OKnr5McXk5mGyR8MxqcxP97UbUeL8NKdC3OCvgUTSs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k0ruXvWh; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k0ruXvWh"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5ad2abf31aeso4472e87.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 03:18:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781777914; cv=none;
        d=google.com; s=arc-20260327;
        b=cvQlyG57g2ELk5YQyE4+jpAhfHb4QncSyHCfaoe9bbto8ghSiDm32fTqNO+byza82W
         8yM0+/RPGt6CjESLKtJQkUgu7sVU3sJIj14olvkVZImJ1ugXfFN7WO0w/WtKBGKksf7F
         aTU9ychtZrLCqa6rkqpk5X+668BO8Kl6EwT92yapZgztWXABHusU/ytfzQ+KB+84A3M6
         fQBbPHGzE3+HuTbH4JdzrJ8SO8RQYZ2cOjvqjORVlQYZcWG6+UzUssX8dPLrl+29advD
         pPX4XoX0C8j+G5GGhAjw1N2dm/XXf0wCfDwft1wtxUh3hZTy7orxNDcsq1+83MvHMgZK
         enpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ibhvPjwqpM4eGx3+CK2N8NcqS34AHd1q3JqAVLGl61E=;
        fh=ZwDYgNrgOWg87QwwMn313BVr3N+/R5XiraJqpsf5RbI=;
        b=dt1julp1fLn314K2mKR0464lQEP6M/zi47fu+0knavOwC2k30DIdKnL4HKSTl5WQiL
         TC0tCpfVff+RlA7vj3PAK/1feQbxomXbTlxpO8uTF7vuMMZw+79Pwn44epgq91LXViT9
         VF1m/jO9pPhQkeerfl5WAYfezhkMrClKn7jqOACBKXU6H7nRfGthbr6YHtkUrB0X9UG1
         rGEDdm7d6ytSg139OQCTbj8Qp7FNouse0kZ+fRqIeBDyvY+xW5L5fgcE62On8mirjQm6
         D1kUgexf44bzErUkEvTUj5atw/rCHCRrvKzY1+OdbrVYXZHFs1mRIbl44Zis74h116n/
         RXMg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781777914; x=1782382714; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ibhvPjwqpM4eGx3+CK2N8NcqS34AHd1q3JqAVLGl61E=;
        b=k0ruXvWhKbRC4+1FzQFpwGYnz5nuK3eJg4aJ/Lcu0Sigra6YRDX4OVohPrkVoCSAor
         /NVpUQmSu9mlrs24mqtS20cQx1e+eANaQzn402EKdJ4JKTC45UA+GR07SuzRx8ZIAWKV
         FjsnRlcErFZB2tJuai5SR83jmvOW81vRIHDvACzSiagYnHXkKYjf15rMlHYWTjeIjHJ5
         NAn+Dmri2rp5lOhTsoR3GuID/aRu6cqkYq2Ya4LN8qUmDsyajBEqsP0caszBL52O15bh
         7Pq6fzv99VvctPSV5yPVgIjMHv1WyBPAnM51lhhk6QQXISrDT8QwF+IY0ppnLgD3yYfy
         0f8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781777914; x=1782382714;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ibhvPjwqpM4eGx3+CK2N8NcqS34AHd1q3JqAVLGl61E=;
        b=eTXqb4wBY/FfuuCDSHt25xEkx6znolETg5Oo/nIhJVmPRyPIjmeR8gmu7FrzeuI95Y
         +REWQ9DYT73kYEE0Ljlc24zy/zB26K2dtYMCkvXLfLX0/eHOFy6AOQbZRH5HIgWqJZ+F
         rGD6R2WBhF5Hf0id86KqJdoFcheypF9bgwbPgWAdcg548tAFc+DmfW8/jgnacffR2RQ3
         wFqyoqAm2BNtqMY3FqXIzRsXUz6MRSijFTZhv8FjSlDJ0COKugFQu8p2OTPE9oxjQo7d
         Iq7XIAnGotIeoUaexWNdfeFo8vEkUOMqxdzfK2jHd5x4Tt0InCDw5+pl67fTj1TPWsap
         2B/w==
X-Forwarded-Encrypted: i=1; AFNElJ977aChjGUT2CGT+F4TQKrGg7mGOaaa8N7GTQdpcuPYLMI/Jxb/lD9TWMKuWmFyWfmxV4e9Cic=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0eXgOkp9FCacXQSd7l87vgw+E2ZNUTFZSl+Cgtrkkfz7aEh9D
	/QS+X0M4dfdcJ1+sbC8hEzw0Z3VP6BMwcDfOMHpoFJrSKnb1UjuOrtBGk9heiLdLm2DopfIweuG
	/VURJMD63cdwviaBPzUb2pL70iRO+OhJNiOhpDs/D
X-Gm-Gg: AfdE7clLWc8QaTeZCMcFis1AWZXjiPPmhJlq3QVhwicZuLHG61s/FNILFGIZpvlrL8O
	5m1hNdVr/NZI1hVFYfVGjAaFW/LVdK3KoUAiMSai6Ym6wc/WMArgzWCRenkQD+LulhjO+8yflwN
	Sh64nsOoJdtZWNeGv5cJpicDZxzM83QwyM1VNgbOV33C9pfpeOGIoqb0kuHmBPPkYgD1bFDWOsG
	j2Z65JOBxCUtiglguRuaVxupCF+cENCEr4/onv051igVjJV/9r5Nj4cGzFFoTCMt2HdM8Y5mGYl
	fWlWPnNE
X-Received: by 2002:a05:6512:239e:b0:5aa:6ede:1a68 with SMTP id
 2adb3069b0e04-5ad4db8512amr132698e87.10.1781777913716; Thu, 18 Jun 2026
 03:18:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com> <20260612065925.755562-11-tabba@google.com>
 <86h5n0rwfw.wl-maz@kernel.org>
In-Reply-To: <86h5n0rwfw.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 18 Jun 2026 11:17:55 +0100
X-Gm-Features: AVVi8CepfST9Vimf9vJgqw8SnCpHejknggCFsqVgJ1T1PMI5H1qLsWqwdsPK1Pc
Message-ID: <CA+EHjTyHxtyh+CJz=8amZ4bERVazOtYj_qO=BiofxBqZOpjwyw@mail.gmail.com>
Subject: Re: [PATCH v1 10/11] KVM: arm64: Add primitives to flush/sync the
 VGIC state at EL2
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Jun 2026 at 11:10, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 12 Jun 2026 07:59:24 +0100,
> tabba@google.com wrote:
> >
> > From: Marc Zyngier <maz@kernel.org>
> >
> > pKVM performs its own world switch for protected VMs but has no
> > primitives to move the per-vCPU VGIC state between the host and
> > hypervisor vCPU contexts.
> >
> > Add flush_hyp_vgic_state() and sync_hyp_vgic_state(). Flush copies
> > vgic_hcr, the in-use list registers and used_lrs from the host into the
> > hyp vCPU and pins vgic_sre to a fixed value; sync copies vgic_hcr,
> > vgic_vmcr and the in-use list registers back. The active priority
> > registers are handled separately by the save/restore-aprs path.
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Co-developed-by: Fuad Tabba <tabba@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 50 +++++++++++++++++++++++++-----
> >  1 file changed, 42 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 2f165b6c7b07..23e644c24a03 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -99,6 +99,46 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
> >       *host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
> >  }
> >
> > +static void flush_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> > +     struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
> > +     unsigned int used_lrs, max_lrs, i;
> > +
> > +     host_cpu_if     = &host_vcpu->arch.vgic_cpu.vgic_v3;
> > +     hyp_cpu_if      = &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> > +
> > +     max_lrs         = (read_gicreg(ICH_VTR_EL2) & ICH_VTR_EL2_ListRegs) + 1;
>
> This really needs to be rebased on the current state of kvmarm/next,
> particularly 8cc8bbbfab14c ("KVM: arm64: Bound used_lrs when flushing
> the pKVM hyp vCPU").
>
> I really want to avoid using ICH_VTR_EL2 on each and every entry to
> the guest, as this has really bad performance impacts when running
> this under NV (which is the only way I run pKVM).

Will do.

Thanks,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
