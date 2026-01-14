Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CBB38E120
	for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 10:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768385349; cv=pass; b=rtTindfOCfKQP5YnU3R4p4YY9MV0GVTgwN36ATbfyT0hhv7Mzth6o9UVQjwPLKIJB1Zix0WyIphwvP+mftzvG/d3/AGzWGMuHJNHu5NM49pbFkyuFonY+a6XUVcoKi3x9Tem/ZURcbcfbzQ8OhZLwGKovnd09Qk5nxsCUyo6KLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768385349; c=relaxed/simple;
	bh=cboAZC/N7GAkgRpHFH255dWg88gOhZq5k/rXBB7Or3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t0M2jV5KYFK/f4yZ6WC1NFB/HqeW1r1BiaBDwxxZBwD5N5iy4/WQd5sukq7kso+2aRpPjImIdVeZuf79g2h28bznWKG/9qhL1kG2bcF5pHaPn30H9HjV5lobdfOPBQJbITrVrs6MGWwhm0v7E1E9Xc92Sk5FNZHui2DpGfVM+XY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ELgeT6+b; arc=pass smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ELgeT6+b"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47ee0a62115so41515e9.0
        for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 02:09:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768385346; cv=none;
        d=google.com; s=arc-20240605;
        b=ksGN26r6X93pvPU8srXCLFpjkWiYIDaXINJMXiWmrjgsf0sM21GcY8XYjyTMylCRii
         kLie0zM+F79ZTo5ZJW1aEjvTFUJ+QPMNi7UFrYhiSFOEu+zhmTL/Tfsnen6zhyeclUKT
         nkYqcn8RrBzUjXXP7nyeHQXDXrSdQNR7N3Sp0aUYsCtJEdieB95lK9oDKPThHNuADGx1
         VUjFngaAgmucBDZA8O7zv83P9yXwNfG32iQFvzuY6LJFzOYDkHOsr+NiozsexUdZVNmE
         OvcERJyQgcwsuMy8++LVDn8DZx4Y6vCCF2BH6cMfF2BneAY57wUCHpTQ/gEgGDQasy2F
         BngQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9I9WuN49vDzL3jcHM+WJ2QBCVFtv9a9q6bPtMasJkpo=;
        fh=HOiaXTy8wxiqu6Bl7rYQS27FLeXSuG90i1tV9HVtrH8=;
        b=AxX2S1ySwUVC4amn4i2yyq7Oe8QP5PexMHtwDBhaQLq+nRsb0/vx3MUnhtQ13vZe+f
         MbRFp8Dgx1pxfqkV9PxgL1s3tIdrwB8K7TcOh7Gw89C/fYEhywSZFD5omJfYXdWzvYDQ
         ty5demi1EzbPLgpICgB+1NJxOcEG8oBfRX/cZ+QBELWq9cFgGFzE4HMt9ppSdiWtDI4V
         iXkZaE+tj3IaBFAFUXmqpsodES/gSg7Tg85FX/OZjfmuXSKJkdqs4zlr3V4VWR6EsGFY
         U3H+d4Ukrrld1ThOYUjjc4WfRy+Ix9FIvryIPzxWF0kEXg98y5zcQ887hv9UM+RUOpMT
         0XsA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768385346; x=1768990146; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9I9WuN49vDzL3jcHM+WJ2QBCVFtv9a9q6bPtMasJkpo=;
        b=ELgeT6+bD0pEHoOus9rQfsM6mgbSEYjEYHcLIV/9JBywMgeqM/AMxt0W/xoFcnx62T
         mIj9XNEKOqV9IKDYKO2omyDkD3ZcKW0oawBT0xrRRgkxspjA0YqMrjaYheIkeP07jXwb
         wVMoEJn5mDJq4mQt2sdQaIhLGyN0Ma7GeDzBDZ0q9ab7f54R4ieuk7Y14NCyhlvtnR9G
         wuHC8VTD3npCjaq79WdpLmaJHgDK53Z5Q5ho8NzuzMrPTBApqfTgV/QNujD/xZlPiZU0
         KCOlPFF6MqF8NH/N9pUrsRqm6wiZ9060CRpMvu0UJnq9AIR2k39dMqKga7yS2BxPe5wr
         iyJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768385346; x=1768990146;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9I9WuN49vDzL3jcHM+WJ2QBCVFtv9a9q6bPtMasJkpo=;
        b=INItQMwPmajfKcc/cWwpZMLzU//VHk+lmyM397NxcjLpIGFQZ9i4X0p9H7KKLhuVPD
         IHjKbufJwGTsu2zikb3hvPdUamtI13TpQ2C4EqGTk2kSq2W+tJKXwGvD/AC5CUqYCoK5
         IEHQMvaeTdfpL8ao1NoNH2IAnimgQ31zsVz5yKfQaxcBp8pVVdzbzf4j7cbclPArbrU3
         TJNcfVOYN4/AdkQA9ZZXI/5M+moPvbZ5Mav+p44Twl2GW0R6omEc8orESVOjG3zYDUxJ
         I/59uXfCvv1jbO2VaLSf61ansNyDxff/ru1wYqA6iVLNaDQpbs7pxa3WrjnT2hBn0qJp
         rmRg==
X-Forwarded-Encrypted: i=1; AJvYcCVYpLkfuYhsBObb8mak9XwS7fQ1gq7FcLcXQcTjfegLD1l9FLv/igr6v4zAlRulxpmypu4buvY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8whNphWU40xMRhv4uo4fbML6RyRTjEhBGkvPZbiApOj2fSd0C
	B7/lDKZXa1cvOF9L27vnqZklDv/LqZK/7B+nemvItHt3OUFdZgJ7yy1JVYs1CNTQv4Z5EuSSSY1
	LyUNKrHQ9VupEuOhWFnXsVYjjc6wiiU0nqW2bSfUx
X-Gm-Gg: AY/fxX4UnaP0kjJ7DxlcZD9/uy5+b9Q+UOUCo21kLqsckAQkoIi23MwjEOf3gGaONzu
	N/DsrmVA94gxbn0Z+NxsdngZaO8mAHe2ctzmbil+qsHHSsjx8mnDSmz/uwDh/LM0YCRXYOos7Pl
	LsvWs4Dw1c1EhyRbnBbFY2h75K5i1VgeFJfl2hgy80Xa5KUbOKtdZuRtgPsBk5z8fJEyg/MutQi
	/yQMXN2/vVnQabf5dANIt9BzfUilDluCHU/RM4nlZmBwlreJs//vaW14WVNyBczWo/chSC6w+3p
	yJ6Lngd9/rk44zu33aoXO+6Kwg==
X-Received: by 2002:a05:600c:4c09:b0:477:772e:9b76 with SMTP id
 5b1f17b1804b1-47ee452990amr280725e9.7.1768385345996; Wed, 14 Jan 2026
 02:09:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-19-8be3867cb883@kernel.org> <CA+EHjTwQ4fLBE1YXoB6M0eamSgGDW=nfLaC+-_surBfVbh3byQ@mail.gmail.com>
 <6f0e94ab-7c9c-4705-a90b-aea09ca629de@sirena.org.uk>
In-Reply-To: <6f0e94ab-7c9c-4705-a90b-aea09ca629de@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 14 Jan 2026 10:08:27 +0000
X-Gm-Features: AZwV_QjZbcO1T13jUPtvWgDAfMEoLsYIn7-Rzu9SF6LWm46DZ1iruQdxKvCCi9Y
Message-ID: <CA+EHjTwJw0D2w3oGC_ZSJsciUgiACoLAcRQv+_QSsA_bJKYj+A@mail.gmail.com>
Subject: Re: [PATCH v9 19/30] KVM: arm64: Provide assembly for SME register access
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 Jan 2026 at 19:20, Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Jan 12, 2026 at 05:59:17PM +0000, Fuad Tabba wrote:
> > On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> > > +void __sme_save_state(void const *state, bool restore_zt);
> > > +void __sme_restore_state(void const *state, bool restore_zt);
>
> > Would it be a good idea to pass the VL to these functions. Currently,
> > they assume that the hardware's current VL matches the buffer's
> > intended layout. But if there is a mismatch between the guest's VL and
> > the current one, this could be difficult to debug. Passing the VL and
> > checking it against _sme_rdsvl would be an inexpensive way to avoid
> > these.
>
> This mirrors the way that we've handled this for the SVE and for the
> host kernel.  We don't really have any good way to tell anything about
> problems if things go wrong inside the hypervisor.

I know this is how we've handled this for the SVE, but back then we
only had one VL and one mode to worry about. The chances of something
going wrong now are much higher.


> > > +SYM_FUNC_START(__sve_get_vl)
> > > +       _sve_rdvl       0, 1
> > > +       ret
> > > +SYM_FUNC_END(__sve_get_vl)
>
> > Since this is just one instruction, would it be better to implement it
> > as an inline assembly in the header file rather than a full
> > SYM_FUNC_START, to reduce the overhead?
>
> Actually this isn't referenced anymore so could just be deleted.  It
> mirrors what we've got in the host code, we have to hand assemble
> everything because we still don't require binutils that supports SVE,
> let alone SME, and that's done with macros that do argument validation
> which don't play nice with C.  Even with an assembler that supports the
> instruction using a SVE instruction from C code gets annoying.  It has
> crossed my mind to inline but it never seemed worth the effort
>
> > > +SYM_FUNC_START(__sme_save_state)
>
> > I think that this needs an isb(). We need to ensure that SMCR updates
> > are visible here. Looking ahead to where you introduce
> > __hyp_sme_save_guest(), that doesn't have a barrier after updating
> > SMCR. The alternative is to call the barrier where it's needed, but
> > make sure that this is well documented.
>
> I think we should put the barrier where the update that needs it is.

That's fine, but then we should at least document this.

Cheers,
/fuad
