From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v6 04/13] arm64/kvm: hide ptrauth from guests
Date: Wed, 19 Dec 2018 15:21:49 +0000
Message-ID: <CAFEAcA99QrjnHRT8_WK1MjUHv_X9yGMmnQAtWL94Y8=FJotikg@mail.gmail.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-5-kristina.martsenko@arm.com> <57966497-d21c-5439-e4ba-d75f5552282f@linaro.org>
 <a2eb07e5-6663-aede-fb75-cc91cf3fffa5@arm.com> <1f179017-4237-0d36-7adc-0a1470b5fd46@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1f179017-4237-0d36-7adc-0a1470b5fd46@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Henderson <richard.henderson@linaro.org>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, awallis@codeaurora.org, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, amit.kachhap@arm.com, Dave P Martin <dave.martin@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, keescook@chromium.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 10 Dec 2018 at 20:22, Richard Henderson
<richard.henderson@linaro.org> wrote:
>
> On 12/10/18 2:12 PM, Kristina Martsenko wrote:
> > The plan was to disable trapping, yes. However, after that thread there
> > was a retrospective change applied to the architecture, such that the
> > XPACLRI (and XPACD/XPACI) instructions are no longer trapped by
> > HCR_EL2.API. (The public documentation on this has not been updated
> > yet.) This means that no HINT-space instructions should trap anymore.
>
> Ah, thanks for the update.  I'll update my QEMU patch set.

Just to follow up on this loose end, this change to HCR_EL2.API
trap behaviour is documented in the 00bet9 release of the system
register XML which came out today:
https://developer.arm.com/products/architecture/cpu-architecture/a-profile/exploration-tools/system-registers-for-armv8-a

thanks
-- PMM
