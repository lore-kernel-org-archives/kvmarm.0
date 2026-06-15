Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437FF3E5A2D
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 12:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781527745; cv=pass; b=rHGlAOmKIbeWhZwg826E0NtQxslKVfRoSoltg1sx1lzLhX2geqDFdswwJKWRcFNROd3IGSo2H+9tuaPUu8nmAgsvsiWzIIPWnq/zAqeaCkiMd3IPpO/BWm9v3JdD7HFKq6oRUZ3zzzLmv0w3NXkSxnXUwA5PKCO42ZbXI6ObYTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781527745; c=relaxed/simple;
	bh=LJe15JjUek5fw6XKFzJA+271/vt7M6VL9YSeUdshYcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W8F/b9E8yCwkqMe2h6RJ193Oi3Y+AEXePG4W/MpbKGI1JFH7eOwy1NAlL88F1PdLin3CDVXoBxrabA88964Q6G/ejuCHSKH2uFrO7JDCxPb9mP7AMd9gO8u1kOdWc8UnQNkVlghbLKzENt5TM/GunCONZuaQESVWjTccIRpDsYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VYUTMcAH; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VYUTMcAH"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5175d339e8bso993821cf.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 05:49:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781527743; cv=none;
        d=google.com; s=arc-20240605;
        b=K/PyzjwzQwM1IxKPeIVSp0eRO5rJ//B6Zsc36VUb+m2ZNS8ofzeQn1XtDFkzzP9y7M
         x5IxamEpB4erVBj9AGGLhrFNki/mALCStP64b0jGRCF8FeeLoAbQ+c+gI+zqhyhEmTUQ
         aAbjVVkMGYhdki+cvkkXfXhUftWgK9vA7vzon3ukXI0BKQtr8xDliMk6T+lj1HaDlnE9
         Q08An8MkM14wu2oBcS3XVbMKuemOFNZzmxZqr3SQVcLDRiaGJVhY9QfqN+A9bYpBtg14
         oHnXjxKZsH3XA5uV1u6k+FLPHjJxzelHuAVht4yRTNdXKPnM6rFp9ohPBEpgXHCHbg85
         wxNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zFCZ8PiCdles8sGmomIgyqjJQ3JYp7FDY2a/owznabc=;
        fh=54vTMDWPXahx78+ZbPga2Bmh7VLpGtI+lt1HTJtbebk=;
        b=jFbAXji7rBeobJ6OCGPm+M07WV4BVG6RWff78NYK+wKMzKOpJKh2KdKzW0+Y9sONf7
         GsKvU6K1IzTW1NpBnazJ8AIujc5vh95Az1LJlcrxgsc5YzJJH2OM/NAEpqLyWRSM1+Zz
         WMKwUEdfs+Mr2WYqVUJQLijnl13XgslUGss1S4D40CFJo+3s5iYQQbTVHsob4JwbYiZE
         6j+pmd0Zd7OGVXVtJfPAc/ghqq2Ia2YbPFHwkpVZDVluaYt2veRH3OaLHcDK4WXup22C
         JOKbrpPiPLWjFNEll2SkfW6+EZCueMiQkcZXNsDG1DaSFOonB+K6ntge9yPNI33Ysnk/
         9KCA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781527743; x=1782132543; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zFCZ8PiCdles8sGmomIgyqjJQ3JYp7FDY2a/owznabc=;
        b=VYUTMcAHA1q4lmUxOwxdXjawgEeZX13g3mrK2jjd9AxYVBDs0wD8QO9Q8o1vHlZ0rQ
         4WagY5qy3geWbU30F+zYYDZJXP10heZdSdHV+FOLiSxe2y73HWLFcnEQ+ILd9tiaBmG5
         AZHA9UhJuWCi8m0SYO5nyD33zynfg2YDLmCkC9oR1FKW3bZk1J7PqhBU2m9nvjouf6dy
         E23wiM9/gIltglgmmMoUd++rYrYhZQDED5l3stM7xTqx1wR0aOTB5muUrdDb2pBBE8sH
         h0h8ocBn4Qm7gmRAhkeOymO/hCzhcR4Pb7lshFSkcZZ0qC1romvEc9VI7AOSKRss2uv5
         Vd6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781527743; x=1782132543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zFCZ8PiCdles8sGmomIgyqjJQ3JYp7FDY2a/owznabc=;
        b=qavWc/Uq7mKxFZclN1OSG1jDLkCu7WXVypLiK2YYU7duzVl4AWunzgH4XnqSp9OinS
         iC5o42ZgcYceAv4j733p46+p0TvtSlXm80BekWZxAqNPRUAWBAlhjjmAPN0vyIUnsbQu
         4BVDcmr/m/9ZCDwa3TzCRLKkLj8lPdMKlMziTU3UYFQAcsYM9R59lQU7XL+pcoign6hB
         1CpTSYWmdaJoHhdXIJWvsKgWwbOoc86z+jJ2cz8S6KbXvy1LzI78lGiIg9NQEtSHDTwP
         6CyvI0O5j90kudLZEklLHM8sda/4HACaaELPwUjjF+Sna6TLWmUbCOW2JlFzWOboHByu
         ghkQ==
X-Forwarded-Encrypted: i=1; AFNElJ+lbSyL7go42nI2N4ANw41ZOYLTvpJGIYwZ2OTlE+U9odTWZCc4gtdZgMTEq4pSxnGBrj1y2Kw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQWuIB0jfbfw/g7uYtQpS3qUyk3kHnik4M4wUsnejAwdWE8gNJ
	cOHPa0ViPje71+9qcA/igCe/LSINzGMXKsAqnLHqPlUFEDuI3dc/pE0jCt3HQJ1ucHwmfbmbzh/
	PfqqgbiZm2VrKSphjzIPwr1wCYQpqqx2A89+9zh6WLu6Zz6Xcfsu/xutzLaw=
X-Gm-Gg: Acq92OHPwIW+vxA28jYTHu+7GEXsbv2pyoCbrl5yUbNsD1LKEcnaFoj9MaIixG05kwf
	fjtQzjAzHf0jaHGV4IlfAE+iV8MdwmdhC2Nt13YSKGHu1cXdEIrin0LhZeWNjWPmPCI85qZfduj
	iu3rAJdEpoDnhxH+uJuQXiNpW5xehXzGi1vKso2XF1GONHbE2WxOSFFPl+66yDLacuQtMYhdi/0
	sX5h3xGGE+qIdEvAw3YtHDEHcjrF+qhJcT7bY6O2g2c/v7knSaeVhr100Xe8QtBoqvZFvNOtJYQ
	rg3m7YbE
X-Received: by 2002:a05:622a:1cc5:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-519872e72c6mr1555771cf.4.1781527742564; Mon, 15 Jun 2026
 05:49:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260614163336.3490925-6-tabba@google.com> <20260614164640.2C2741F000E9@smtp.kernel.org>
In-Reply-To: <20260614164640.2C2741F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 13:48:25 +0100
X-Gm-Features: AVVi8CdTpojXp5Rg93zTw6F_4PdLKLBfJzTQdQahYiR_o2rdoYlbw7YfqZYAuPQ
Message-ID: <CA+EHjTyq7YG4zap3uRYOm7CRs=OToH65iSZ2bPjkvaSpgUm=QA@mail.gmail.com>
Subject: Re: [PATCH 5/7] KVM: arm64: Set IL for emulated SError injection
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 14 Jun 2026 at 17:46, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] The patch series attempts to fix SError syndrome IL bits, but th=
e constructed ESR is silently dropped when injecting a nested SError becaus=
e `kvm_inject_el2_exception()` ignores the `esr_el2` argument.
> --
>
> commit 3adb0abe8b63984396e6d2ad4fb963bab5512c79
> Author: Fuad Tabba <tabba@google.com>
> Subject: KVM: arm64: Set IL for emulated SError injection
>
> This commit updates kvm_inject_serror_esr to include the IL bit when
> constructing an SError syndrome. It fixes an architectural compliance iss=
ue
> where IL must be 1 for SErrors unconditionally.
>
> > diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_faul=
t.c
> > index 444d219b02174..d6c4fc16f8795 100644
> > --- a/arch/arm64/kvm/inject_fault.c
> > +++ b/arch/arm64/kvm/inject_fault.c
> > @@ -381,7 +381,7 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u6=
4 esr)
> >        */
> >       if (!serror_is_masked(vcpu)) {
> >               pend_serror_exception(vcpu);
> > -             esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
> > +             esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) |=
 ESR_ELx_IL;
>
> [Severity: High]
> This is a pre-existing issue, but while we are ensuring the SError syndro=
me
> is correctly populated here, does the nested SError injection path drop t=
he
> syndrome entirely?
>
> When injecting a nested SError, kvm_inject_nested_serror() passes the
> constructed syndrome down to kvm_inject_el2_exception(). However, looking=
 at
> kvm_inject_el2_exception() in arch/arm64/kvm/emulate-nested.c:
>
> arch/arm64/kvm/emulate-nested.c:kvm_inject_el2_exception() {
>         ...
>         switch (except_type) {
>         case except_type_sync:
>                 kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
>                 vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
>                 break;
>         case except_type_serror:
>                 kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
>                 break;
>         ...
> }
>
> Unlike the except_type_sync case, the except_type_serror case does not ca=
ll
> vcpu_write_sys_reg() to write esr_el2 into ESR_EL2.
>
> Will this cause the guest hypervisor to observe a stale ESR_EL2 value whe=
n
> it takes the SError, effectively rendering the syndrome fixes ineffective=
 for
> nested guests?

Yes : https://lore.kernel.org/all/ai-DsLydd7ry0RpS@kernel.org/

>
> >               vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
> >               return 1;
> >       }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260614163336.34=
90925-1-tabba@google.com?part=3D5
