Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC9F2FFDF8
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 10:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762944757; cv=none; b=dVlsKA0kExo8CnZcyKjEUxG/xKrCH9+YyGMQb/DTXd/1Dh+XM0jKmbCCIfhQSVi+pecdv7bGTqJ2QjerRib+iEQGuuHyh716vT/SbMAJsVl6DfWcQQGJiz2j3TQsmjRNkBnAPZs2LHhtBeXU3qKHF5EciGIyTDGD8bzW5qRhrEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762944757; c=relaxed/simple;
	bh=6AGPldyrHuBJ/qzLf0A20ECVa3RXsc+6ZS1F7vCuAT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XcsmBPCe54m4N6Nn5z+jbfh0ykTGXZaCBVbsypPUg0R5HM/rKTZmn1dZR7VhGim1ZHkOh440PlXjizWoHCSerhxorQrjjL32CjDzsMui62WImKSwqZrYDq2Vmqehi1IXLuyJ0fVuaMhVb3VyMyIihzqtfCWIMBVGbg8ZoAr2/tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=blewlyUn; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="blewlyUn"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ed67a143c5so253631cf.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 02:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762944755; x=1763549555; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WNEmHsCQ3cI11oAI1u83nSxC6LWPxu8t+VCOL7GAmx4=;
        b=blewlyUnrWTeMVpWbDVmhLVYjTAEXDXkFixwQ6FpOaYTWpvTMuKn4RVyLLAEGXo4Ry
         SNrTFqL3C6c4bJM/RoQ8SOItMShQiO0M8fWkGt1dx1GddEtwn63H6r1f3HjJy9+aGd8m
         KwdkqRYbd168iD6u5j/E1xbk87wvNlh1f6cXRd41bREyVlBEoZ1B7j+Tx8B3lq6OSB22
         ZOwrP6zjq/oS0VWwyaqH768ZutY5TJ4KZ3CB3qstSsVaXLnXitNMw8Fe1Jq2jj+sX0mR
         KxiiFAQ8AnFbn4AZxUSb9ai5cQI5YGAkS7/rdWsq/nEoGSir70RrogbcqVEBfO+w3Rjp
         JCOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762944755; x=1763549555;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WNEmHsCQ3cI11oAI1u83nSxC6LWPxu8t+VCOL7GAmx4=;
        b=EHPXeoQojS/Gugy1Spmyk94StY2aIPzypQT3PrN1/LVurVmUJwaPx3SwAxZOVJohlJ
         GLFsEH4W3wBxUpcp3Tv/V09C/zclDyaS/Jpk5NqbccAU3BIPMx/m3c29CEFRhwYP+7fK
         dNVKgAN03D+tuaaMcKFkOugqqeFxWIW+fqf2Og4OY+MqyGmjiJRyXuNUUT3eHjvi6CJ/
         esVEH5f0O5OMAn0D3B0F8LH6/BXhhaN4RTvKoAsqKOmQ3eGstoa6x13nmstRqcTPjrHI
         yyQ85ADtcroBz1Dx8b8m+Gjqc5Vy/5iZQYwK76HL1t0IJZS883CxXiZYivMPBSDioaKj
         77vA==
X-Gm-Message-State: AOJu0YyjlI6NIfa1PmDUxQQNRNXIephBb1KpImnreiKaTjaNMCltR5F0
	fcG86ty6jW1OTgF5PMWTCKy+Ayu/pVboqLQHg1Vnpp5TlJ1VPnSBv0t9XFHQ+OCHpxXDrYXQUNu
	HutZhApgksTVfGjuPu6lNSOpnP9nevoE1RNE6H0I0
X-Gm-Gg: ASbGncvM/kqqx47r9epicF+3cSEf8v9j52YlX+vkDtfZyGAo7zZqzbAk6JnDuMUUj4o
	uHpRpuA5rBKNzTpUfb9e97gGUDzo5mDDQGaXvHN9Pb3UoGZ3F+geLbT1B2IQR09aC+Zz/Ar+lxy
	s43t67X7vJQSZFIJImTy37jW4GwlvMxZU45ujVtOIGIHKRz+/7GQuKQ5XF3Urh/gLhl4QYgYGBA
	vMFnFR2JvvfrsnBO3jbzi11Hju9l0C2aRT4Xc4e7qJ1K+8D1wJLQInjxJMqd4y/6ilzNk2d3lKg
	7Q4cJ292FeDy+jw6dAs3XHXqmi+/DvthIzw=
X-Google-Smtp-Source: AGHT+IH2kbrp2wOONl68BTyAziYAcWVjit+MdfPXbN9/MBL9IDmErGLT+GrOxTm+S9zHBlZfWlLxLVKM03Url96aZNE=
X-Received: by 2002:a05:622a:246:b0:4e5:7827:f4b9 with SMTP id
 d75a77b69052e-4eddcf51ffdmr5007411cf.3.1762944754666; Wed, 12 Nov 2025
 02:52:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251112092051.1376245-1-tabba@google.com> <20251112092051.1376245-8-tabba@google.com>
 <aRRcYltFUrBlcbfX@kernel.org>
In-Reply-To: <aRRcYltFUrBlcbfX@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 12 Nov 2025 10:51:58 +0000
X-Gm-Features: AWmQ_blDGZmge2Sw8Vj1BBhA5Hq-sY9Tzxc1CXj4hBJ5LlqC72ETgAVnLelWlpE
Message-ID: <CA+EHjTwyu5PZnPeEuD6VRV2zfAnP=KSMq+VVcGeq-zGRSUjaSA@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Wed, 12 Nov 2025 at 10:07, Oliver Upton <oupton@kernel.org> wrote:
>
> Hi Fuad,
>
> On Wed, Nov 12, 2025 at 09:20:50AM +0000, Fuad Tabba wrote:
> > +/*
> > + * Check whether the KVM VM IOCTL is allowed in pKVM.
> > + *
> > + * Certain features are allowed only for non-protected VMs in pKVM, which is why
> > + * this takes the VM (kvm) as a parameter.
> > + */
> > +static inline bool kvm_pkvm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
> > +{
> > +     switch (ioctl) {
> > +     case KVM_CREATE_IRQCHIP:
> > +             return kvm_pkvm_ext_allowed(kvm, KVM_CAP_IRQCHIP);
> > +     case KVM_ARM_SET_DEVICE_ADDR:
> > +             return kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SET_DEVICE_ADDR);
> > +     case KVM_ARM_MTE_COPY_TAGS:
> > +             return kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_MTE);
> > +     case KVM_ARM_SET_COUNTER_OFFSET:
> > +             return kvm_pkvm_ext_allowed(kvm, KVM_CAP_COUNTER_OFFSET);
> > +     case KVM_HAS_DEVICE_ATTR:
> > +     case KVM_SET_DEVICE_ATTR:
> > +     case KVM_GET_DEVICE_ATTR:
> > +             return kvm_pkvm_ext_allowed(kvm, KVM_CAP_DEVICE_CTRL) ||
> > +                    kvm_pkvm_ext_allowed(kvm, KVM_CAP_VM_ATTRIBUTES);
> > +     case KVM_ARM_GET_REG_WRITABLE_MASKS:
> > +             return kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
> > +     default:
> > +             return true;
> > +     }
> > +}
> > +
>
> I was thinking of something a bit more tabular since CCA will impose its
> own restrictions + pKVM could share the ioctl <=> KVM_CAP association.

Sure. Before I respin, how about something along these lines:

struct kvm_ioctl_cap_map {
    unsigned int ioctl;
    long ext;
};

/*
 * Sorted by ioctl to allow for potential binary search,
 * though linear scan is sufficient for this size.
 * (Note to Oliver: If you like, I can add a runtime check if we want
to support binary search.)
 */
static const struct kvm_ioctl_cap_map vm_ioctl_caps[] = {
    { KVM_CREATE_IRQCHIP, KVM_CAP_IRQCHIP },
    { KVM_ARM_SET_DEVICE_ADDR, KVM_CAP_ARM_SET_DEVICE_ADDR },
    { KVM_ARM_MTE_COPY_TAGS, KVM_CAP_ARM_MTE },
    { KVM_SET_DEVICE_ATTR, KVM_CAP_DEVICE_CTRL },
    { KVM_GET_DEVICE_ATTR, KVM_CAP_DEVICE_CTRL },
    { KVM_HAS_DEVICE_ATTR, KVM_CAP_DEVICE_CTRL },
    { KVM_ARM_SET_COUNTER_OFFSET, KVM_CAP_COUNTER_OFFSET },
    { KVM_ARM_GET_REG_WRITABLE_MASKS, KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES },
    { KVM_ARM_PREFERRED_TARGET, -1 }, /* Basic IOCTLs, no gating capability */
};

/*
 * Set *ext to the capability, which is -1 for basic capabilities.
 * Return 0 if found, or -EINVAL if no IOCTL matches.
 */
long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext)
{
    int i;

    for (i = 0; i < ARRAY_SIZE(vm_ioctl_caps); i++) {
        if (vm_ioctl_caps[i]. ioctl == ioctl)
            *ext = vm_ioctl_caps[i].ext;
            return 0;
   }

    return -EINVAL;
}

> Anyway, ioctl filtering should be an allowlist (default to false) just
> like kvm_pkvm_ext_allowed(). The default assumption is that new UAPI is not
> supported for pVMs unless explicitly stated otherwise.

Of course, that's what we do with capability checks.

Thanks,
/fuad

> Thanks,
> Oliver
