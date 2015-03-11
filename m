From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 6/6] target-arm/cpu.h: document why env->spsr exists
Date: Wed, 11 Mar 2015 15:47:44 +0000
Message-ID: <CAFEAcA8jRtdCtxCE5KLNCBLi7CgEb3=qSUVU--HPu=QTt5wadw@mail.gmail.com>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org> <1424880159-29348-8-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1424880159-29348-8-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 25 February 2015 at 16:02, Alex Benn=C3=A9e <alex.bennee@linaro.org>=
 wrote:
> I was getting very confused about the duplication of state. Perhaps w=
e
> should just get rid of env->spsr and use helpers that understand the
> banking?

I've already disagreed with this. I would suggest putting
tentative questions about future direction of the codebase
below the '---' rather than in the commit log :-)


> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> diff --git a/target-arm/cpu.h b/target-arm/cpu.h
> index 11845a6..d7fd13f 100644
> --- a/target-arm/cpu.h
> +++ b/target-arm/cpu.h
> @@ -155,6 +155,11 @@ typedef struct CPUARMState {
>         This contains all the other bits.  Use cpsr_{read,write} to a=
ccess
>         the whole CPSR.  */
>      uint32_t uncached_cpsr;
> +    /* The spsr is a alias for spsr_elN where N is the current
> +     * exception level.

This isn't true for AArch32 (which has multiple different SPSRs
any of which might be the one in env->spsr when we're at EL1).

-- PMM
