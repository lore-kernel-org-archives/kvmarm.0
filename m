From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 4/6] target-arm: kvm64 sync FP register state
Date: Thu, 26 Mar 2015 17:20:34 +0000
Message-ID: <CAFEAcA8i8tptcox=PhUHqSWhBaSu0RyoeFKQoT_GvH_6A5oHcA@mail.gmail.com>
References: <1427130344-27986-1-git-send-email-alex.bennee@linaro.org> <1427130344-27986-5-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427130344-27986-5-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 23 March 2015 at 17:05, Alex Benn=C3=A9e <alex.bennee@linaro.org> wr=
ote:
> +    /* Advanced SIMD and FP registers
> +     * We map Qn =3D regs[2n+1]:regs[2n]
> +     */
> +    for (i =3D 0; i < 32; i++) {
> +        int rd =3D i << 1;
> +        float128 fp_val =3D make_float128(env->vfp.regs[rd + 1],
> +                                        env->vfp.regs[rd]);

float128 is part of softfloat; it doesn't really belong here...

-- PMM
