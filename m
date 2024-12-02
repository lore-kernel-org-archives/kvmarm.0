Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23FB1FA249
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 09:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733131048; cv=none; b=XZFfP71bVqn/gA++29f2xkI36C1XuhDCdCFxibYTpT3t2QQ1wcGJaToRyuzwZCkZduWAyK/EcaXKuMxYHPckgWbLDEnUhKZcP8n/hL3LoCgrCZiqf6tGPUzT9Yyq2+d1yBg9gciMKoS99UjdCjWhf4dTBXPIPqVal51ubV0CvSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733131048; c=relaxed/simple;
	bh=kTHhJ/8tNQjb+VrEBECXDpR4+1NcYq6BJUyupy6YzCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n4QIvoL93dppeFq05MzCcDnL1DLXQpqEHW7xXcDTgPF2w9Z2TRPFN/A744oi3iqqbjVOBL1tKa3I99GVg1EJkxYFjuHzncbIvkdjgdVReeBugZqPiVwja+8xRVJllSOjNegD8mYaOtTsSeeQtwcSxwt3HVPVV0AFJpLnyp1DwiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gndb0FTM; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gndb0FTM"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4349ea54db7so207455e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 01:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733131045; x=1733735845; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xheUdNTjQZCXCu1iqFVovuDp12XGPVK2eJ3J0wQfUu0=;
        b=Gndb0FTM1sUyUpjKYkuSoa1E0qlmRIS2nKtrtd0pCguvvhaZ2uoSYSY1hFQY0Jrq9C
         CVbci0SPWVTAIv8jHemk9U1gP243/3cQYmXfGYCVEcINk4DAf8sZGmPMQZGhzScJw3EG
         tt1s1Ubac8uOZ2wuab/oUC+6Xb/C1/i8b7BsHO5US5BSQyEAdSbdqUK31fi2QrsFIQ5D
         yjiyGSYWijd2VJ2Q0YqCgJGYfHAhqlMfmV54MnV+IWr+9nq6KDL8yZq3Y3ySM2ZcbrSU
         9aRDzqe7OChQ2OxHFwTp4A1fgR+WodLD5NUcMygxtMPuezg9QE1KYFLbIA7J74dYWrIC
         pSOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733131045; x=1733735845;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xheUdNTjQZCXCu1iqFVovuDp12XGPVK2eJ3J0wQfUu0=;
        b=FCUG0xn+kl4fEsYMI8FWursPtHUSBYKMfcFF/9BZ33JCLEQjCcTO/K3DESCNpZbnHm
         tKBAzkAx7a6KB9nrmfnLWXclc/zPpMIeiWegMs61nvTRL4TsyYuyAfa9JmK/R9T5VXe6
         q0UWWKgtR+da/eI10MZAU36WNDhWrzg0jScEwo+UHiklm6slDjdRqPQcNNQcSQtqTUbt
         WN8Lpx1/Kfhus99Dl+iOaMpXewKIuLpL7nQqh2Xg3pCFNZcIQI1Zj2o2ZThWqP0H+5Cs
         8VqzVi88Yxy4qL3fcS1UVXAUbJ+V+hcIzzuy+zziGE17WEuB+j0HTl99ZO89FK2CzPhl
         C1Wg==
X-Gm-Message-State: AOJu0YwClt6ow9MU/DUxkSpwhFMrK7JY5w6nldFMdlBUOgXWsjcAABsI
	OFarCjxOKlw0ZI/FaUUnLfhaU+hqBD56bkgM49SR0kCWJ5XiBkefCTwp2yetgyifOLXN9h8QXd+
	FIzr4WwBzlubVLIPnrZYG3J6UYYome+Go6hH3
X-Gm-Gg: ASbGncuPuRXcteiwm75K8Wp6nYFIWSg6ojA8sfjg6RDWAj8ERjdZGyXXZVO/Z3teznI
	ojTIgZX/MthSUVzjVbDCS0+8iIGUAhw==
X-Google-Smtp-Source: AGHT+IGdGsEiB9WCD/AraN19zYGjoqrq86Rwh4ys+1rlPGRuRnqjVWf7BZbYMcLYEbVI3xMnZtgZrN3VG06AQdhaNtM=
X-Received: by 2002:a05:600c:6a88:b0:42b:a961:e51 with SMTP id
 5b1f17b1804b1-434b0401690mr4445725e9.0.1733131044951; Mon, 02 Dec 2024
 01:17:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com> <20241128123515.1709777-16-tabba@google.com>
 <8634j7v9rm.wl-maz@kernel.org>
In-Reply-To: <8634j7v9rm.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Dec 2024 09:16:48 +0000
Message-ID: <CA+EHjTxnYi7_kStfQtExuQTyBEZict5ekmfn_vg100tHFv_VJQ@mail.gmail.com>
Subject: Re: [PATCH v3 15/15] KVM: arm64: Renumber remaining vcpu guest
 configuration flags
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, james.clark@linaro.org, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

On Sun, 1 Dec 2024 at 13:00, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 28 Nov 2024 12:35:15 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > With the vcpu's SVE and PtrAuth configuration flags removed,
> > there are gaps in the numbering of the cflag bits. Renumber
> > VCPU_INITIALIZED to bit 0 to remove the gaps.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index c5c80c789ad0..2e4afec09728 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -864,10 +864,10 @@ struct kvm_vcpu_arch {
> >  #define vcpu_set_flag(v, ...)        __vcpu_set_flag((v), __VA_ARGS__)
> >  #define vcpu_clear_flag(v, ...)      __vcpu_clear_flag((v), __VA_ARGS__)
> >
> > +/* KVM_ARM_VCPU_INIT completed */
> > +#define VCPU_INITIALIZED     __vcpu_single_flag(cflags, BIT(0))
> >  /* SVE config completed */
> >  #define VCPU_SVE_FINALIZED   __vcpu_single_flag(cflags, BIT(1))
> > -/* KVM_ARM_VCPU_INIT completed */
> > -#define VCPU_INITIALIZED     __vcpu_single_flag(cflags, BIT(3))
> >
> >  /* Exception pending */
> >  #define PENDING_EXCEPTION    __vcpu_single_flag(iflags, BIT(0))
>
> Please fold this with the relevant patches, even if that makes two
> consecutive renumbering patches.

Will do.

Thanks!
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
