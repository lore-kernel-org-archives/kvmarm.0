Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C661DFDAE
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 10:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733479531; cv=none; b=hwo3XgP+cltju3z19sZbCJRjbN3pCdZJvgzw0KVLQ0ikFMVVUrHmrbQymO3vOExWiwx/hkU0sTUsLHRpIInw/DXiDyc5Q2oW04B76of6gn0KDp4DoOtOjMbbBHg/+qxG5X2X1mcD2N5/5ssg8nkXVZgRfLHwDyAeIh1zOa1Renc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733479531; c=relaxed/simple;
	bh=lHABhTzGG3AoXRqC8Dw7Njh7aAXJ/vsc3Kxn8IHFDkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z1tfcgvoiLLBVwPxiOQym6IcgdeoIlX2+jGeppIRSHFxN9La1PdE/4sKkIXSyrR9Saar20lniX2r7/PmOSqw57ZSFyN2Bf3McxxW4Y2oeBiEKDh/HwI9Cw9HWVjSbjqSAqSICR3sHnxpQCszrqu7tmzb8NB1Utd1wA/YT+C8wDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ADmefG48; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ADmefG48"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4349338add3so34285e9.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Dec 2024 02:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733479528; x=1734084328; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R/ryQ2lrpgoHQc48zNvSjIhEhICpUtxTSCqioMkrH6I=;
        b=ADmefG487xabcVD097jOm725/vrfPhEOaAUTRwYcvRPoDhHRz0KVUSrgf3MQkcuhAN
         zJ/FG7eME7jUCiq/ocew0svxZzstp7/ECgqfJxd6B4AY+xaJ8kd0JVHNvMiXVtPAqp/s
         8nrwDzJOZeCol0rYyE2aKd0XuiMyue4JbNX8U50p3V34z1iMMQhu0Fl5tMxwHA62DUY+
         Ycj84maS05DMzBCRWuQi865PWwhiqdvxZ4RPAVnrVuNLL2VHqcahi7l+K8vtyZq6/eLR
         pyHylWAgep1/g0X8Ud7pXXceCOWv6yUP3wbwwM7wnM87BCS+Xd0YIVvbQW3i0HBRi52a
         rcuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733479528; x=1734084328;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R/ryQ2lrpgoHQc48zNvSjIhEhICpUtxTSCqioMkrH6I=;
        b=HU4R8UNtDs98sYAx0BiVILS23WUt2cu7qDSL8bXfUCP+8SZA0u4C2X2go1RHB62F3O
         Hrt8ySpG5bobVdLzrAuKzTC0F72LWjhWBoaiY1pubUcTurONBMbzPKItXPkFdkG4k629
         1klvOBU8fOhttl4ponvwdy2sz127qQORRM4eOZyPJkSLZHdXEcUN2+XoSVb1Z+o4EHTl
         X0141McpMgNkUBQuxqhcOqW4DM2wVr95XUOZIov3lMm8yk+9FrsUDVoFokg4LQxsK2Ra
         X85ufddkD9WPVufODVde4t/g9p9YIS9eCVp/diNPASGl8X2qGqxRCn64pk9sNmiW7Xo8
         6tsw==
X-Gm-Message-State: AOJu0YzFsiBjDpxJvXkzAxNYfuoKwpbcXcaHHiDUNRPPFoqDveL0P1v8
	zdg6q8FFMyrcE68kDn/4PIukAQYDPPyGWdabIGacNel1wmPnL2WuxMc9pNL8RI1iJyMH6pK0Iq3
	BIFpzjCPDiUJuui/pejAtR5tn3ynltCqhNfet
X-Gm-Gg: ASbGnctPdICuHmSxMXxN03i4jmzkfY7ocLPMceYzjIpjVB5YTUCPguKqeYbfiF2W/GH
	IKb+NHCz1a7cjAd+aGXLpPiDelilaQQ==
X-Google-Smtp-Source: AGHT+IG+4dJpEo5yLtZoUhglN3xuWlQYiuH64fyMBXTPh3lbLD+/Gl4eqok3Nj9uu15d8KD5B/bL+1d4FMP7EJcyEYA=
X-Received: by 2002:a05:600c:1f83:b0:434:c967:e4b5 with SMTP id
 5b1f17b1804b1-434def170d7mr668415e9.1.1733479528294; Fri, 06 Dec 2024
 02:05:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com> <20241202154742.3611749-6-tabba@google.com>
 <Z1JNGmcZka1hl2ha@linux.dev>
In-Reply-To: <Z1JNGmcZka1hl2ha@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Dec 2024 10:04:51 +0000
Message-ID: <CA+EHjTyTODB42oSy0iBkqBGiyH-FUfG_mqgVWzaZ33qnkeESZQ@mail.gmail.com>
Subject: Re: [PATCH v4 05/14] KVM: arm64: Initialize feature id registers for
 protected VMs
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, james.clark@linaro.org, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	broonie@kernel.org, qperret@google.com, kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Fri, 6 Dec 2024 at 01:02, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Fuad,
>
> On Mon, Dec 02, 2024 at 03:47:32PM +0000, Fuad Tabba wrote:
> > +/*
> > + * Initializes feature registers for protected vms.
> > + */
> > +void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm *kvm = vcpu->kvm;
> > +     struct kvm_arch *ka = &kvm->arch;
> > +     u32 r;
> > +
>
> Can you add an assertion that this is called while holding the
> vm_table_lock? Otherwise it isn't clear why its safe to initialize
> per-VM state.

Will do, and I'll update the documentation around vm_table_lock to
clarify that. Should I respin after this, or would you like me to wait
a bit?

Thanks,
/fuad

> > +     if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
> > +             return;
> > +
> > +     /*
> > +      * Initialize only AArch64 id registers since AArch32 isn't supported
> > +      * for protected VMs.
> > +      */
> > +     for (r = sys_reg(3, 0, 0, 4, 0); r <= sys_reg(3, 0, 0, 7, 7); r += sys_reg(0, 0, 0, 0, 1))
> > +             ka->id_regs[IDREG_IDX(r)] = pvm_calc_id_reg(vcpu, r);
> > +
> > +     set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
> > +}
> > +
> >  /*
> >   * Checks that the sysreg table is unique and in-order.
> >   *
> > --
> > 2.47.0.338.g60cca15819-goog
> >
>
> --
> Thanks,
> Oliver
