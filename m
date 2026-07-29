Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F263002B3
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 09:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785317322; cv=none; b=trZ6dNx3kC3tjSwWIrINGH6Hg3MrWGsvNzuHiqNvXgipp0WR0yBqdWYxcwm9sfckXsooXbKlzsY4OAupX7PD13O++ztM+10B8kXkmMMeIxwYQ0DzI/3+rTxdXqhEE4kVh7jYg1uLhVWU9J5sVrF3TZU2dr7r2LWjij1+upleOo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785317322; c=relaxed/simple;
	bh=D0AwLkB+ib5XChJALQ4tU8f6c9S6XTW4YEt9TV5JdTc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lYZ77am2kc/6XUtCtFAWumY14zhsbq2uiqOOBSti1yzARA6E9e/x9DMq8nsuITjzHOFw+4v5im+n7u6fT096Jj3aWVlrPtNC+Wc3ENh+kq1fa4UICZqMQyCa3yz4qp1SoOyiSp0LW3MfuSWwtOZ0X+fNEZnUp/N4z0by8dUVQHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iRchOIEb; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iRchOIEb"
X-Forwarded-Encrypted: i=1; AHgh+RqTQ8+mz2i7ZNPWW6OMHTUIgk2gO0LdHBGXE7AJWmKtgOq76WYBBmSUzAm0LT7iS+DVpILBxKg=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785317318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zFsPMEXZU81BZFPzI7zqvW1XcTW3Du/Pb7Xb48Wyri8=;
	b=iRchOIEbh04648DkIelWgo9/W2VgWpaFEZ5V2ERlVTc3p0HP4EsC11rhmTJbjJopSBd1Fi
	1x6i1QHHB6naJ6cmsqHRHnMSZIl5b7EUu56dyJsPHrQCGNGQtwnTOU9xR/i+S2HXs0MegV
	ck2Fzrc1ch6B7caaoDwE5MTUFWc75Yo=
X-Gm-Message-State: AOJu0YzAiwNaTKKHrgBjdRCjEynadLzqIhDAq8/ZlHogTlVgcodzDClc
	S+Iw2lBwe5s4++5At8JAYQw6KQWUQ9eRJPVdDf/duKmNeQmfwFlrnV7Gnrg4+EkHDSbQq+fx/Od
	1S6ymRD7AJFbPtVTsB1YDv9vX+nvFjC9XFFjgz7M+
X-Received: by 2002:a05:622a:514a:b0:51c:935d:8d74 with SMTP id
 d75a77b69052e-52b2cc85692mr5455941cf.9.1785317310847; Wed, 29 Jul 2026
 02:28:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260722202702.4165917-1-congkai@amazon.com> <20260722202702.4165917-2-congkai@amazon.com>
 <20260722204759.1582A1F000E9@smtp.kernel.org>
In-Reply-To: <20260722204759.1582A1F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 10:27:53 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzeVnqvgZ_Am+6huiZ+8MwJqQyCOxbJxf2xkxeJvAz6fQ@mail.gmail.com>
X-Gm-Features: AUfX_myVRObTEUj-itgLtxZQ6z_edRtdlBLQt5Xi5VdUYIKOMZceBmhDdSH-fSM
Message-ID: <CA+EHjTzeVnqvgZ_Am+6huiZ+8MwJqQyCOxbJxf2xkxeJvAz6fQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] KVM: arm64: Expose PMMIR_EL1.SLOTS under strict
 PMUv3 UAPI
To: sashiko-reviews@lists.linux.dev
Cc: Congkai Tan <congkai@amazon.com>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Wed, 22 Jul 2026 at 21:50, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] The implementation of `KVM_ARM_VCPU_PMU_V3_STRICT` introduces tw=
o logic errors that completely break the new feature and its API contract:
> 1. `KVM_VCPU_MAX_FEATURES` was not increased from 9 to 10 to accommodate =
the new flag (which is defined as 9). As a result, `KVM_VCPU_VALID_FEATURES=
` excludes bit 9, causing `kvm_vcpu_init_check_features()` to unconditional=
ly reject `KVM_ARM_VCPU_INIT` ioctls with `-ENOENT` when this feature is re=
quested.
> 2. Even if the feature validation were fixed, the code fails to enforce t=
he documented 'No default PMU creation' behavior. `kvm_setup_vcpu()` uncond=
itionally calls `kvm_arm_set_default_pmu()` if `kvm_vcpu_has_pmu()` is true=
, without checking if the strict flag is set. Thus, KVM will always assign =
a default PMU on initialization, defeating the stated purpose of the flag.

Both are done in patch 4: it bumps KVM_VCPU_MAX_FEATURES to 10 and
adds the !kvm_vcpu_has_pmuv3_strict() check in kvm_setup_vcpu(). Until
then the flag stays unsettable by design (INIT rejects bit 9 with
-ENOENT), so patches 1-3 are inert and there is no half-enabled state.

/fuad

> --
>
> --- Patch [1]: [PATCH v3 1/4] KVM: arm64: Expose PMMIR_EL1.SLOTS under st=
rict PMUv3 UAPI ---
> commit 5883b44965f93aed147ca4ed5fb390ae481daa37
> Author: Congkai Tan <congkai@amazon.com>
>
> KVM: arm64: Expose PMMIR_EL1.SLOTS under strict PMUv3 UAPI
>
> This commit introduces a new VCPU feature flag KVM_ARM_VCPU_PMU_V3_STRICT
> to prevent KVM from automatically creating a default PMU, and exposes
> the PMMIR_EL1.SLOTS value to the guest when a PMU is explicitly selected.
>
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uap=
i/asm/kvm.h
> > index 1c13bfa2d38aa..019e5e3d892e6 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -106,6 +106,7 @@ struct kvm_regs {
> >  #define KVM_ARM_VCPU_PTRAUTH_GENERIC 6 /* VCPU uses generic authentica=
tion */
> >  #define KVM_ARM_VCPU_HAS_EL2         7 /* Support nested virtualizatio=
n */
> >  #define KVM_ARM_VCPU_HAS_EL2_E2H0    8 /* Limit NV support to E2H RES0=
 */
> > +#define KVM_ARM_VCPU_PMU_V3_STRICT   9 /* No default PMU creation */
>
> [Severity: High]
> Does KVM_VCPU_MAX_FEATURES need to be updated to 10 to support this new f=
lag?
>
> Currently, KVM_VCPU_MAX_FEATURES in arch/arm64/include/asm/kvm_host.h is =
9,
> so KVM_VCPU_VALID_FEATURES (BIT(KVM_VCPU_MAX_FEATURES) - 1) only covers b=
its
> 0 through 8. When userspace attempts to use this new flag (bit 9),
> kvm_vcpu_init_check_features() will reject it with -ENOENT.
>
> Additionally, does this patch actually prevent default PMU creation?
>
> Looking at kvm_setup_vcpu() in arch/arm64/kvm/arm.c:
>
>         if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu)
>                 ret =3D kvm_arm_set_default_pmu(kvm);
>
> It appears that kvm_arm_set_default_pmu() will still be called on
> initialization even if the strict flag is set, since there is no check fo=
r
> kvm_vcpu_has_pmuv3_strict(vcpu) here.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722202702.41=
65917-1-congkai@amazon.com?part=3D1
>
