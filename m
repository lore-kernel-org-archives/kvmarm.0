Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C8F19995E
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 12:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774441018; cv=pass; b=eR/Z1IHRJDRp0dD05jA9+SxyzjxMqcOz0mGdhtokedfpPw9en2Cdzdo2a1CMhgJpei4vaKB2LaMNJutTme2tniStRPcHB8AfeQE04CudvbHyEOKbuncVS9br9T9qOUk/Py3halWbIEU7YDTnVdTvWQG5ZCoyTa34qvhoNl6pGp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774441018; c=relaxed/simple;
	bh=Wox9yCBHIxSy+j7gCVEVu0Sn7F+MiAmK3t4AcWGw4tg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dHa9ZyVd0MaRjIEjC5fwpbbfgUKL0gKD6ts2xruyjuZ/Ej1Yko/cEaE8IaJhnH4jCkdcRKD0JTbeSnyXLZBdM+2vvPa1mSMV7gihrJFWNpL8Y4zejBeZpdJTi24zp7O8pskEvXCWmktk832r3vEa6NQgNqV9b3dV8Lt1ZKeZu5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TH6T0V+c; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TH6T0V+c"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-509062d829dso476071cf.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 05:16:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774441015; cv=none;
        d=google.com; s=arc-20240605;
        b=OBxvgbW7BFfdyjaqlYKFHQ3FtPBHHdONxn5TE6jf03RhiOIH4VXhw5Yzyeu52Mr0D7
         fGYcuYFAJKib4AY7rO/8lgI7oAGccc7YsqSTLZ40rgfV+/10JbU+0i9s38734liXWec3
         9pa6vvx2At3wyRihY6PxVIeK8KifHx5yXkQpJOYEFQ6qwBFknLj3zzYtSXe/FUYLJS4e
         AF052nrI+TOxoRgph/rMOoAD9z+CGFzEJ1hno8p6YI6g5HU/3DGzY2+z7P/logcryjWN
         GvTiim8u4goWOObE0dMsd0KKWv53qS61aNz6y0Wpr7oW+dN9edjn7nKRfXnCW1iEwBD6
         LS9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6HiReDp40rAShKhFmk6aQGrdV2dk4gym9DDo3pfkhCw=;
        fh=e0+M+aINqnz8CcGoTSfr7rEayruJCVzJzH/dE5SpPAo=;
        b=jQ2ZSyhb9zgTwYKIJd1borqWZi/F1hJKTkwUlnTFsnfgGTmbZDitmH/XRpylTInfHh
         Y3XwD3Pe0x9sC9d0KcpCoZ96ek0JArXo/DC08FNf8Q4mSOl53N1tJQ4nvY1TXM2foDq9
         FoBv/Swi2BIXGmegZ2SLIWrRB8GNIQi76AIz7XqF+fWkrBujmmjr5vQIumIKCTJiKtIR
         iJHQgV5odrABN8RXNTp6Jj6HMzElPg0dfrd1BccAl5tyX93/i4Dq8F+cuSygpm/CZWlT
         f2E4PvKuliXuFjstY2NBsTXsXl29NsjdMAbf6nLAgQEA3RVGSsgxgv0pScXf3ZGFKxVy
         CmXQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774441015; x=1775045815; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6HiReDp40rAShKhFmk6aQGrdV2dk4gym9DDo3pfkhCw=;
        b=TH6T0V+cjmPOaZkqAgHA9vjtipqGULIXt2Uhqz9k22uKgIfPW5K/+JYVL203Tw3ZYD
         RMVg5q2Flqc67LmV96xb7ORY7LUUalLMAjIhJF2PdVx2BzaVY1Lq3tg8FN20IhDoZoMJ
         qSe8zMPO9NdzborapTVmIBZJuVv7drnKuM5awsVYD+/Fku+OlH4Q56DvZNpMlc08T9B4
         n85cgrrRNcroZVBmLfuEnH01FjAQq9A1GZQOxLyX7AXNc2OA2S8IQK8PZKdGxXdOEn1h
         ShhhMnstgEYtpH3yNhaWtXoIqrc7DbGKIhP/TKXxfa6YE//cfq7FpomZMdw6vuPWNFZn
         wYng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774441015; x=1775045815;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6HiReDp40rAShKhFmk6aQGrdV2dk4gym9DDo3pfkhCw=;
        b=mQGh1FtncdKkTJO2u851c1elhb0hk7rd/g35ksrUkOxtqL/E+j0J7kf+wuZ3qUEsS0
         l7L8xJHrJBxTQQHPZYHp8KNvJlV/33qrQUlj09i+omB+0X4ruiQYlOZgUAj9r/u3rqsL
         wQ2d0rTbDmLVtZ3qZgVCn2dZ116875TGwG2uQJScxHPr6lfdVzJudLqxqRXn7RXKGrrn
         McSZXjNAViPoGxHG1pU9yLHZUNmQAm1VmPssBSI2667li+cIVIWrpb77ptqIGwC6XBf7
         4GgcQFgpeNF/IftYECjUFyUayC3JyMTIW50a6nO0fKjVpWaQQEqnU734nul2SdNtKNH2
         aOJQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6a0E8iBRqRlUCBkZ7wg41X77WrpPdZqUXM90HDKBjDVYPd7nIC52cEvicF/0jqfE9VxqJRzk=@lists.linux.dev
X-Gm-Message-State: AOJu0YywCvv9p7j9BqYphOypuUSxKBDflfp+ScQC1hZe0hSmFwefp4WE
	nw6KpXVtRDBxoRODWBrakuo5YmhXWpeAwMHQoCgqtz26f/X38it5uMBYt3aST+tsaufgQ4ERjwL
	zJ+43arWYRvFkRe6iFWF4e5NHjNRlfABXoU0PjVFW
X-Gm-Gg: ATEYQzz8JDetsnCKAGnmLxlw3ey8/oro9FOrRuhDHxGdiuwayJ14xoOtjGPsRjcPsVb
	iRAS9evLBKElUP/y18gNSZlsPU2nrp2p3+9TC5DorpYZp0h9tBLJVTHa4vM7eMCCapg8j0nRhUj
	wROj8WLQQooPUjh7/B8ATcaIo0jFHWzjrP5Rcrox+paFCQH9Ghlq0UNpoaArVXniTDkjYiKwQCq
	c6HTIbsd+XH7EZkHPA+0+H2eY192KmuwJlvS0LkGLF4TYVVT3xuRBxZhFpYJEg+Bdn9Ori41ZPp
	mXw9tcXMu/hvH3pwUaUm48QYjezwoHYKGA7M+Q==
X-Received: by 2002:a05:622a:5a8d:b0:509:1c2c:866 with SMTP id
 d75a77b69052e-50b83d1af72mr10972521cf.11.1774441014886; Wed, 25 Mar 2026
 05:16:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260325113138.4171430-1-sebastianene@google.com>
 <acPIdoA8oc7T8wKX@google.com> <acPJ3Z9hDKc0Sm2t@google.com>
In-Reply-To: <acPJ3Z9hDKc0Sm2t@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 25 Mar 2026 12:16:17 +0000
X-Gm-Features: AQROBzAMJ0mLdR0624TEieVBSiHs3RBFsNy7Xl2T_dOXjsqgRi5JInx2E5cEcKU
Message-ID: <CA+EHjTzeRiUvhDwAExpscWJfPNoRujeRAJ5dEDV4SMpOJK1K6A@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Prevent the host from using an smc with
 imm16 != 0
To: Sebastian Ene <sebastianene@google.com>
Cc: Vincent Donnefort <vdonnefort@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, catalin.marinas@arm.com, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 25 Mar 2026 at 11:41, Sebastian Ene <sebastianene@google.com> wrote:
>
> On Wed, Mar 25, 2026 at 11:35:18AM +0000, Vincent Donnefort wrote:
> > On Wed, Mar 25, 2026 at 11:31:38AM +0000, Sebastian Ene wrote:
> > > The ARM Service Calling Convention (SMCCC) specifies that the function
> > > identifier and parameters should be passed in registers, leaving the
> > > 16-bit immediate field of the SMC instruction un-handled.
> > > Currently, our pKVM handler ignores the immediate value, which could lead
> > > to non-compliant software relying on implementation-defined behavior.
> > > Enforce the host kernel running under pKVM to use an immediate value
> > > of 0 by decoding the ISS from the ESR_EL2 and return a not supported
> > > error code back to the caller.
> > >
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > ---
> > > v1 -> v2:
> > >
> > >  - Dropped injecting an UNDEF and return an error instead
> > >    (SMCCC_RET_NOT_SUPPORTED)
> > >  - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
> > >  - Updated the title of the commit message from:
> > >    "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
> > >     smc with imm16 != 0
> >
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > index e7790097db93..4ffe30fd8707 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > @@ -762,6 +762,12 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
> > >             handle_host_hcall(host_ctxt);
> > >             break;
> > >     case ESR_ELx_EC_SMC64:
> > > +           if (ESR_ELx_xVC_IMM_MASK & esr) {
> > > +                   cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
> > > +                   kvm_skip_host_instr();
> > > +                   break;
> > > +           }
> > > +
> >
> > I wonder if it isn't better to move that into handle_host_smc() as this is part
> > of how we handle the SMC after all? (and it calls that kvm_skip_host_instr()
> > already)
> >
>
> I was thinking of doing that as well but I prefer this since we don't
> have to look again at the esr in the callee.

This is a non-trivial amount of code to have in a switch. Can you
please put it in a helper?

Thanks,
/fuad

>
> > >             handle_host_smc(host_ctxt);
> > >             break;
> > >     case ESR_ELx_EC_IABT_LOW:
> > > --
> > > 2.53.0.1018.g2bb0e51243-goog
> > >
