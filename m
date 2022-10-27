Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9966BA53
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 09:44:51 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id y4so885362plb.2
        for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 02:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/j2A0pYLkA8OsROkAILPzXlvLVVJYZZ6PND++hwpXgU=;
        b=Bi2tqtjzvm62JhERu0Dr85gYqo7fXeNGrI7jJ6XOQjf4gDYlRqOBDD9w5Pn8483eun
         vTzLT+9Tx05xLvpt+Tc4ggZH/UkccJXkV9LdLiU5wjemb0K0R/lEv95CMvl9J6VMB3Wu
         SVA/nJ7GkrHk4wgpmvGICg27eMUjjeWai2+a411SMAjyvDttt/ZR/yjFi2G4u9uvf9Dt
         SfgEHCfPDgT4jJML0V/fP15dn9WPKTaInd5uCyltS8tzyxPDHWmhnV1dQSuG2e8uZFVV
         6OP01BY74Wbz/VZrI8tKMN27l1K18wwQf/mQuqlFQyYyc3n+5F7UPiCdkdUlUVr/vYo0
         5zKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/j2A0pYLkA8OsROkAILPzXlvLVVJYZZ6PND++hwpXgU=;
        b=MgQF/yyMtgS5lfuXeC3BHLGpppe26Ecz0WlfcIQO3HDJBpOEQNjkmx1A2Otu3LrjoG
         wgF05CEC5oGtIu9X5O9aWjAFcs8wfZhGKuU+JyKGW2NhRRK39OCKL+p17NnDA/pk5Ylv
         jcOORrF4i6H/1/nbEA1U+uXmqT+3NCjXVXaBh9D66N5W5lCwZ9vNnYc2fb8FACMLPeyV
         yImOPqrU/s92MQt/4TF3Zj+7uRCnBTGv/3ZCgxJFvs72uAaWKNamtZYucMD0WRwk7a2h
         BHUwX1QVXGUaKgA3//xOAW5W5CnZGCo1iaO1HLhU1pfHJpNHMRwJ23+mTguIp+tFMff+
         5r0w==
X-Gm-Message-State: ACrzQf1ch8f2Rf+iYVeWxSy2O0N7gPDsjZJrhAxYzYldxVaGkHbAJus+
	RJpLpG0g4dKekVQUjFY19EWGFCg7JP9vEaq8ox7hRw==
X-Google-Smtp-Source: AMsMyM4f4UsZpIqXzUihy1JpWuqwZkgkq5kT5JFzO74jTIwBrorDI66kx8uGjVi+dxWLAcm9nUy2gPnNU1TiEfXv7rA=
X-Received: by 2002:a17:90b:1d04:b0:20b:cb40:4b3 with SMTP id
 on4-20020a17090b1d0400b0020bcb4004b3mr8994406pjb.215.1666863891323; Thu, 27
 Oct 2022 02:44:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Y1lEWJ7rO4m1CKWL@google.com> <Y1lNKcXfy/nHzTQ9@sirena.org.uk>
 <86ilk6ef5x.wl-maz@kernel.org> <Y1lhrB3lq5dZAin1@sirena.org.uk>
In-Reply-To: <Y1lhrB3lq5dZAin1@sirena.org.uk>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 27 Oct 2022 10:44:39 +0100
Message-ID: <CAFEAcA-mo_ywRnC53aFfkYP=q3zDBD7U4sBSrzg7ZfRQA7QYXA@mail.gmail.com>
Subject: Re: Hang with nVHE mode and SME
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, kvmarm@lists.linux.dev, 
	catalin.marinas@arm.com, will@kernel.org, 
	Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 26 Oct 2022 at 17:34, Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Oct 26, 2022 at 05:13:46PM +0100, Marc Zyngier wrote:
> > Mark Brown <broonie@kernel.org> wrote:
> > > On Wed, Oct 26, 2022 at 03:29:44PM +0100, Vincent Donnefort wrote:
>
> > > rather than on the if statement?  A brief grep around the qemu source
> > > suggests that this register and fine grained traps in general are not
> > > implemented which is invalid with SME since this is required for SME in
> > > nVHE.  SME is a v9.2 feature, and v9.2 includes all the requirements of
> > > v8.7.  FEAT_FGT has been mandatory since v8.6 (where it was added).

Yeah. This is pretty common for QEMU, because we don't have the
resources to implement the full breadth of the architecture. We
just implement various features and rely on the kernel to do
fine-grained checking of ID registers rather than assuming that
because feature X is present feature Y must be too, or that because
some feature is in vX.Y then it must imply presence of all features
in some other vA.B. Mostly this works out OK...

> > It is very unfortunate that the SME spec doesn't call out this
> > explicitly, while it is calling out the dependency on FEAT_HCX (OK,
> > one is mandatory and the other isn't).
>
> Indeed.  It was there in the internal drafts but it looks like it got
> removed as redundant when the v9.2 dependency was decided on but it does
> make it harder to spot the interaction.
>
> > > I did originally have a check in there for either/both this or FEAT_HCX
> > > but it got taken out during review due to the architecturual
> > > requirement.
>
> > So the question is whether we work around this in the kernel (not
> > enabling either KVM or SME if FEAT_FGT is not present), or leave it as
> > is with the hope that QEMU gets updated.
>
> > I'm inclined to do the latter. Thoughts anyone?

Is the "kernel needs FEAT_FGT here" requirement a strong "the design
just means it's kind of expected" one, or a weak "the features
aren't really strongly tied together, it would be easy to do without"
one?

> I tend to agree.
>
> Note that we don't need to use FGT in VHE mode so we could restrict
> virtualisation with SME only in cases where we're in nVHE mode, though
> narrowing the restriction does make things more complicated so may well
> be more trouble than it's worth and we might need to revise if we start
> using the SMPRI_El1 trap in future.

We don't have any super-immediate plans to implement FGT, though
we might want to think about adjusting the roadmap.

We have released 7.1 with SME support, so you will see QEMU binaries
in the field with SME but not FGT.

thanks
-- PMM
