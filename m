Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4693CF034
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 09:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774949352; cv=pass; b=I1MRuwoN/7wQcE/pX+4BvZaDoEBCrXcyLquMJVbWULV1hpjqrYaSGSrEwJnqk0vKI057pOy9M3Ywslr1Mm01Six82Eq8fqKP2RShmG2eGaP5PlNhqxrA0Ond6+7mlJoYmC6u7odGcC72GViwmsWryx99ILHwMOoAi9NtdX7hxBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774949352; c=relaxed/simple;
	bh=0635JPjAuXsfwnqDNp1f5e91YgJi0G3R857dLoQ6i3E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m/y2DDb5KuIwwdGfhiDWvlKOjuEKxLpDZZJoBeeO68n9yQVTrN8XNtvunEfqaN5t8jvCLnr6TzK+QVedgZwlrUE3kAr0sW+VG+6ES37EcebyK82T53/06m3LJxXE8nTAIIWRAAnQqeNBHl0OmgJCqFZ0CrrKP4HujfbNzpBpKJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MSDHkYp5; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MSDHkYp5"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-509069a7a7fso471171cf.0
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 02:29:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774949350; cv=none;
        d=google.com; s=arc-20240605;
        b=RAvUKrQCXSMpe6rf9Y1xSkVWqqdDZOJXG78r0Pfn0y/HMhhD/p3WLtSXA4nv6oU8qA
         B5GoZXB0yoY05S/MLQqHTUjB8zEr5FzQ5wGtt/Cm8jj41Y27ImTf1GQXgoU9Mtsdp91N
         baKA7Nxmwa3ppA0Iw7DK28+5Xz7owMuJpKadMMIoIV4sIbfNHXJ/OcfMclvw4km8mQeG
         oboLnx06a+5BGlFwfBV1nUdGc+fhuNg6WAxfKA8UuLXwzlCq14Efj3M8yyQSWYcnGnbA
         0mzTy2eeo5jpgBBWoprLhW8WKnmiH4G0ubAbhLNxFU5eqODyDeN4ZVeW+Cjc6kCeCMZb
         YZ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wyuKKl7mhKF/xTEpwQMmSLKf43fn/HmTygtNoZ9fG44=;
        fh=alb9fk7E3YwzeiAnOs8Mqi892OQr4/IXj8sSBNrU2EE=;
        b=CkRkk3pZOWdaETl15kPt2q9ebaghzTXWrdHxl7wBjejvHj/jGUqUNus5WvYiikF5oG
         wQu9anOuMuDs8mTqwav5orfjG4aKwlCuPV9X7zChRQMUKzmSEWPJp734AR/9dFkro0Ge
         tEaArJPE4+rc55VTQ+5JRa/rcNorx5PxK549sdHfqbags1+s2eKtyHUhjANo4XyFGO9q
         UuILJD4pr+L3159d7TLez9EVTdw1BPtNV5PSabXIJvlfyi6pPdwRwwm7GBkwOQrOZxJf
         mc6Q6Kg3dQixDPLwTHgKr9plwAkx8p2bB4gZr9v8xjDXUnK6LyeOwFCyJFsLIWmTVY/E
         moTw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774949350; x=1775554150; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wyuKKl7mhKF/xTEpwQMmSLKf43fn/HmTygtNoZ9fG44=;
        b=MSDHkYp5UTT6CChIDfZUKeBWsWfptVwljdYbQNb2Mb9Q/LjWLYL3/7CSFOUOuW2sWf
         fIbkL3EXUzimaohcagJ9/7s4ErFO3/rN09+cJM3zg+nAk98ZYc+4DjT5tJQoE4LCNEjN
         TvB0yYjZtf3U5OoMJaJrzckEiY6VqYyys9FwMvmKJlGpw3Tf05qwU4y/MbMgJZz3/A5/
         YjsAr6xt5O6aUA4woUgQqnWqNmNEtYgbMkEZxxufK/+/5HyYliPe9SsPbYi3ZsJ4I5v2
         mGMA1m95a6SWSIueZma+G3nc8QpGbCsWwrFQKXE2JUWovGg2YkvS8WpAU1Wz30KT2prq
         1PRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774949350; x=1775554150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wyuKKl7mhKF/xTEpwQMmSLKf43fn/HmTygtNoZ9fG44=;
        b=mHxwga5TxOihnBodd94YzPsI8ydkEDabJBBHbi59I/mf2t2XCgduOxd5SAjBUubxyU
         JXpxtFUaWa7y3dn/F44sTNUEv3LEZQ6Tngyz5OwboI1gl13ppyCzCdLfWJ20YDeVIKep
         BCdJr82vX2KhQxHFMFB02q+LPvpQDaLK24SNVr6dqop0ZUysWM0H/Rr8qMd0qdvdgI8o
         eMr58GJ7eQQWW462dNEL2EPrlD3SBgH3N+7HxMsIiEsqNCNAD9uvbjdW9WY+GF0Vtbcs
         1lnQnqj6fzhRZgDQAA5MNf2CQhbDSuKJiRU72UrGdZKxJcC0aiSOOy3B8e5kc1lT6XFA
         l1ag==
X-Gm-Message-State: AOJu0Yyxyg3vvoB8DExigSHi+JlOW1JxuG4xFBcbCiCd/weKwfTm0vQJ
	6c/07xIExufGqZ6aE5H70TEhp2MHAovTKesSoJoshUw+0pPiUPiDLnPbeVxBek4xX0BBp0BQEAb
	5NczSggKRWDY0jBWYc8+iXhaO7nmNRmZj6SgXfo/q
X-Gm-Gg: ATEYQzx9TPh9ZWccn4LT2/hJRNVxAVsh67eXK+y1IpIMSCJhZpqNsJSaLM6tm4mymMY
	sBWa7Bgg7sJqpzQ1SK2CG+M5WgXofIAWx/OcaCv9VgflZAKOIHSXId7Du+Lf+npo9Slkl5q6LMi
	FROK2pHy/Pcj41L7bwZaqXlmSTVTWieu6PAHIrMc/si9SvfVeOn4EMEfIxqgRzdmGnLabJTl86k
	hXPkxDyL7/vF84We0+BFAmCbG4D/ju+zYNxs9KhlBmuaD8FQX6SnGpYxCBki/olcRtk9LwiK45j
	gAQG
X-Received: by 2002:a05:622a:181d:b0:506:1f23:e22c with SMTP id
 d75a77b69052e-50d2d5dd617mr13252121cf.6.1774949349586; Tue, 31 Mar 2026
 02:29:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260330105441.3226904-1-sebastianene@google.com> <acs0Qbjfdmlkvd1e@google.com>
In-Reply-To: <acs0Qbjfdmlkvd1e@google.com>
From: Sebastian Ene <sebastianene@google.com>
Date: Tue, 31 Mar 2026 10:28:58 +0100
X-Gm-Features: AQROBzA0mi-WHSU_4dItH79nF8_VINh3IWNunZim_OnJBlTbzQ54B3kyAH5c3X8
Message-ID: <CAHLR_pbA0W7zhXD6Un=kPzLiCu3GMPa3evx2-2Bb7mBoxAEFHA@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: arm64: Prevent the host from using an smc with
 imm16 != 0
To: Vincent Donnefort <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, android-kvm@google.com, catalin.marinas@arm.com, 
	joey.gouly@arm.com, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	suzuki.poulose@arm.com, tabba@google.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2026 at 3:41=E2=80=AFAM Vincent Donnefort <vdonnefort@googl=
e.com> wrote:
>
> On Mon, Mar 30, 2026 at 10:54:41AM +0000, Sebastian Ene wrote:
> > The ARM Service Calling Convention (SMCCC) specifies that the function
> > identifier and parameters should be passed in registers, leaving the
> > 16-bit immediate field un-handled in pKVM when an SMC instruction is
> > trapped.
> > Since the HVC is a private interface between EL2 and the host,
> > enforce the host kernel running under pKVM to use an immediate value
> > of 0 only when using SMCs to make it clear for non-compliant software
> > talking to Trustzone that we only use SMCCC.
> >
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
>

Hello,

> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
>

Thanks for reviewing,
Sebastian

> > ---
> > v2 -> current:
> >  - move the ESR decoding of the imm16 in the handle_host_smc where it
> >    was supposed to be
> >  - updated the commit message to include the reason behind while we are
> >    not doing for HVCs as well
> >  - updated the commit message to clarify that pKVM is not handling the
> >    imm16
> >
> > v1 -> v2:
> >  - Dropped injecting an UNDEF and return an error instead
> >    (SMCCC_RET_NOT_SUPPORTED)
> >  - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
> >  - Updated the title of the commit message from:
> >    "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
> >     smc with imm16 !=3D 0"
> >
> > Link to v2:
> > https://lore.kernel.org/all/20260325113138.4171430-1-sebastianene@googl=
e.com/
> > Link to v1:
> > https://lore.kernel.org/all/20260324135728.3532400-1-sebastianene@googl=
e.com/
> >
> > ---
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index e7790097db93..461cf5cb5ac7 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -676,8 +676,14 @@ static void default_host_smc_handler(struct kvm_cp=
u_context *host_ctxt)
> >  static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
> >  {
> >       DECLARE_REG(u64, func_id, host_ctxt, 0);
> > +     u64 esr =3D read_sysreg_el2(SYS_ESR);
> >       bool handled;
> >
> > +     if (esr & ESR_ELx_xVC_IMM_MASK) {
> > +             cpu_reg(host_ctxt, 0) =3D SMCCC_RET_NOT_SUPPORTED;
> > +             goto exit_skip_instr;
> > +     }
> > +
> >       func_id &=3D ~ARM_SMCCC_CALL_HINTS;
> >
> >       handled =3D kvm_host_psci_handler(host_ctxt, func_id);
> > @@ -686,6 +692,7 @@ static void handle_host_smc(struct kvm_cpu_context =
*host_ctxt)
> >       if (!handled)
> >               default_host_smc_handler(host_ctxt);
> >
> > +exit_skip_instr:
> >       /* SMC was trapped, move ELR past the current PC. */
> >       kvm_skip_host_instr();
> >  }
> > --
> > 2.53.0.1018.g2bb0e51243-goog
> >
