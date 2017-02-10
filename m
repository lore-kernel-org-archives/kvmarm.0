From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/4] arm64: mmu: map .text as read-only from the outset
Date: Fri, 10 Feb 2017 10:41:58 -0800
Message-ID: <CAGXu5jKQjtwZ-JFPBQ8epjuXYbQ4d4s404-=hJm_y=CpsHQFAA@mail.gmail.com>
References: <1486747005-15973-1-git-send-email-ard.biesheuvel@linaro.org> <1486747005-15973-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6482-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: keescook@google.com
In-Reply-To: <1486747005-15973-4-git-send-email-ard.biesheuvel@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Laura Abbott <labbott@fedoraproject.org>, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 10, 2017 at 9:16 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Now that alternatives patching code no longer relies on the primary
> mapping of .text being writable, we can remove the code that removes
> the writable permissions post-init time, and map it read-only from
> the outset.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Awesome!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Pixel Security
