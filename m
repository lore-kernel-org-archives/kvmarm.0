From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 00/17] ARMv8.3 pointer authentication support
Date: Mon, 15 Oct 2018 15:42:31 -0700
Message-ID: <CAGXu5jLtxRitee143FE37PYkPCs0UArGgNEsiU8fzsQL9N8S-Q@mail.gmail.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-1-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 5, 2018 at 1:47 AM, Kristina Martsenko
<kristina.martsenko@arm.com> wrote:
> This series adds support for the ARMv8.3 pointer authentication
> extension. The series contains Mark's original patches to enable pointer
> authentication for userspace [1], followed by early RFC patches using
> pointer authentication in the kernel.

It wasn't obvious to me where the PAC mismatch exceptions will be
caught. I'm mainly curious to compare the PAC exception handling to
the existing stack-protector panic(). Can you point me to which
routines manage that? (Perhaps I just missed it in the series...)

Thanks for the series! I'm quite excited for ARMv8.3 hardware. :)

-Kees

-- 
Kees Cook
Pixel Security
