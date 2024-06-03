Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2597B74047
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 08:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717403875; cv=none; b=qHe4QBNIyFp9HsNpVO8lw5YnMJDYrG5o1dH7DzZlqlG1BsVyDIwyGPrKQhQTV1AQf60jO3rHox7hH0oaSGzhiP3/11654+9omLSsaeSsRrsCzzoKeeYPmldSzmVt5rjrS1vRegi5ilObSESSOvuStpuEo3eGHenhrJdXxmWzRG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717403875; c=relaxed/simple;
	bh=jxx3pJC2B68XCNNzyBISZy6L7wzF6f+d4Oln3C9A0fU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F3dTP0hWLBSV0piwgKFbkSo+wbtPRFzWSc1IHXPgj2/EV+tqxn6plZJ9k7M6nrhLohhA26/tZaSlgC/soG3SFW09WjAcfLjYrjg+T9k2P9ANoihN0xVYaDHRyFgw+lT9lQziSWmSTvIg0Y9VMXUfKMdg/utO3P1vJ/M3yDMRXKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QLNY4Tyg; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QLNY4Tyg"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4e93a260becso1661422e0c.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 01:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717403873; x=1718008673; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XaK2kUFcS8r9yNYKSh8t4ewJQekHf/Vna+ddTszUSIw=;
        b=QLNY4TygE8u+nGU7gi2xZl3Huvujf7BcSrGUDPcmZ6hqKRKD1dvMFZEFGtyAuuKRXS
         SM5KWq2t1ATpRqZyNby80UNlMkc0d6oA1Izt0iYorp5B9YyogTXktQUE5em0QrTv7vOv
         WXrqwtGrh0wTfPyzpUwyuNl8hb6ZznnO3S79TLNvihIvyvkrqyXVCuIdfxdZetKt03Iq
         PQIYaPA2KeYCnbooE8rM2R4ktNPSNQod9igMZQKA3gv3lXu8I5rGl0CPUHho/VUZquTo
         810SxT6CO2kYL0LxY3901SZtIp//aN6IvTTzZ/Q5GN1pCncS4L2BLPd5y+C4OmrEZ753
         K+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717403873; x=1718008673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XaK2kUFcS8r9yNYKSh8t4ewJQekHf/Vna+ddTszUSIw=;
        b=Mm3UKlWvs2w6dIj0vS1XztonX/6OSGrR7SKM6RICSRH40GqTfK7Qh5neXPrhOBSDQx
         sGeGYANFdrY0SVBUnCRJS1WZDkVhHzjgZ56GxsUjhK5fm3/dmMlK9r1Ifp42EKT76+ex
         UCo9Cj972uLJtoCn+dfTFoAEhxQj+posafDcuLtMJcUxopY+ewk/wZtX05bK6nNOOvUg
         ay8qKpcyXK6LOTdIY/0RfBZ2hodYg20VKt7sstFxdzIxxrIhdHW5sv0XXjUqkKNH4DWe
         RIGJ7ujQin2YNysUzubGe7i0jDBGuK92mThcdRbAty77pFPOEI+2o5uzX2cIUrpv/FgL
         AtSw==
X-Gm-Message-State: AOJu0YzvRGCTM56CwkksdGg+hCcgjdHykatplVMX0pL6Yvfeyr1AiV5e
	VyH7TOHlxDM0zggzM6Ozzj9WSnTEV85IRDkOKus5IJKl3+AZKqAIFj9AwSf9CSFSxbmRMRP5EYi
	G7tKKmkLUe8DupzwW52fqP6DjsZ2aOGTtwu+w
X-Google-Smtp-Source: AGHT+IF0kg6GwemTBIcPJqIpW4u992+6OzsYND2OUzTQhWPf/+Zmux4WBskVmRCBmdq1ma/3m3rXngAzfxlWdri8G7k=
X-Received: by 2002:a67:fdcb:0:b0:48a:325a:e284 with SMTP id
 ada2fe7eead31-48bc20cb26emr7627597137.6.1717403872724; Mon, 03 Jun 2024
 01:37:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com> <20240528125914.277057-6-tabba@google.com>
 <f205aea1-bc52-41ff-9545-704cda9e23ff@sirena.org.uk>
In-Reply-To: <f205aea1-bc52-41ff-9545-704cda9e23ff@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 3 Jun 2024 09:37:16 +0100
Message-ID: <CA+EHjTz_u2M-wsNnD_f=_R+dJoYwL9gUrBz=YwdqGZbtTT-aaA@mail.gmail.com>
Subject: Re: [PATCH v3 05/11] KVM: arm64: Eagerly restore host fpsimd/sve
 state in pKVM
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Fri, May 31, 2024 at 3:09=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Tue, May 28, 2024 at 01:59:08PM +0100, Fuad Tabba wrote:
>
> > +static inline void __hyp_sve_save_host(void)
> > +{
> > +     struct cpu_sve_state *sve_state =3D *host_data_ptr(sve_state);
> > +
> > +     sve_state->zcr_el1 =3D read_sysreg_el1(SYS_ZCR);
> > +     write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
>
> As well as the sync issue Oliver mentioned on the removal of
> _cond_update() just doing these updates as a blind write creates a
> surprise if we ever get more control bits in ZCR_EL2.

I'm not sure it does. The other bits are RES0, and this is always
setting the length. So even if new control bits are added, this
shouldn't matter.

Also, one of the concerns in terms of performance is now with
nested-virt support being added, and the overhead of doing the
conditional update when we know that it's unlikely that anyone is
implementing vectors as big as the max.

>
> > +static void __hyp_sve_restore_host(void)
> > +{
> > +     struct cpu_sve_state *sve_state =3D *host_data_ptr(sve_state);
> > +
> > +     /*
> > +      * On saving/restoring host sve state, always use the maximum VL =
for
> > +      * the host. The layout of the data when saving the sve state dep=
ends
> > +      * on the VL, so use a consistent (i.e., the maximum) host VL.
> > +      *
> > +      * Setting ZCR_EL2 to ZCR_ELx_LEN_MASK sets the effective length
> > +      * supported by the system (or limited at EL3).
> > +      */
> > +     write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
>
> Setting ZCR_ELx_LEN_MASK sets the VL to the maximum supported/configured
> for the current PE, not the system.  This will hopefully be the same
> since we really hope implementors continue to build symmetric systems
> but there is handling for that case in the kernel just in case.  Given
> that we record the host's maximum VL should we use it?

You're right, but even if the current PE had a different vector
length, ZCR_ELx_LEN_MASK is the default value for ZCR_EL2 when the
host is running (this is the existing behavior before this patch
series). It is also the value this patch series uses when saving the
host SVE state. So since we are consistent I think this is correct.

> > +static void fpsimd_sve_flush(void)
> > +{
> > +     *host_data_ptr(fp_owner) =3D FP_STATE_HOST_OWNED;
> > +}
> > +
>
> That's not what I'd have expected something called fpsimd_sve_flush() to
> do, I'd have expected it to save the current state to memory and then
> mark it as free (that's what fpsimd_flush_cpu_state() does in the host
> kernel).  Perhaps just inline this into the one user?
>
> > +static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
> > +{
> > +     if (!guest_owns_fp_regs())
> > +             return;
> > +
> > +     cpacr_clear_set(0, CPACR_ELx_FPEN|CPACR_ELx_ZEN);
> > +     isb();
>
> Spaces around |.

Will do.

> >  static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  {
> >       struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> >
> > +     fpsimd_sve_flush();
> > +
> >       hyp_vcpu->vcpu.arch.ctxt        =3D host_vcpu->arch.ctxt;
> >
> >       hyp_vcpu->vcpu.arch.sve_state   =3D kern_hyp_va(host_vcpu->arch.s=
ve_state);
> > -     hyp_vcpu->vcpu.arch.sve_max_vl  =3D host_vcpu->arch.sve_max_vl;
> > +     hyp_vcpu->vcpu.arch.sve_max_vl  =3D min(host_vcpu->arch.sve_max_v=
l, kvm_host_sve_max_vl);
>
> This needs a comment I think.

Will do.

Thanks!
/fuad
