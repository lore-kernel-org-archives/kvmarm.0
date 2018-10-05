From: Ramana Radhakrishnan <ramana.radhakrishnan@foss.arm.com>
Subject: Re: [RFC 17/17] arm64: compile the kernel with ptrauth
 -msign-return-address
Date: Fri, 5 Oct 2018 10:01:04 +0100
Message-ID: <cd1eface-aebb-b654-c57c-91690087957f@foss.arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-18-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-18-kristina.martsenko@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <Catalin.Marinas@arm.com>, Christoffer Dall <Christoffer.Dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, Will Deacon <Will.Deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/10/2018 09:47, Kristina Martsenko wrote:
> Compile all functions with two ptrauth instructions: paciasp in the
> prologue to sign the return address, and autiasp in the epilogue to
> authenticate the return address. This should help protect the kernel
> against attacks using return-oriented programming.
> 
> CONFIG_ARM64_PTR_AUTH enables pointer auth for both userspace and the
> kernel.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> ---
>   arch/arm64/Makefile | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index 106039d25e2f..dbcd43ea99d8 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -56,6 +56,10 @@ KBUILD_AFLAGS	+= $(lseinstr) $(brokengasinst)
>   KBUILD_CFLAGS	+= $(call cc-option,-mabi=lp64)
>   KBUILD_AFLAGS	+= $(call cc-option,-mabi=lp64)
>   
> +ifeq ($(CONFIG_ARM64_PTR_AUTH),y)
> +KBUILD_CFLAGS	+= -msign-return-address=all

Glad to see this being done and being proposed for mainline.

I can see why you would prefer this though have you guys experimented at 
all with -msign-return-address=non-leaf as well ?

Orthogonally and just fair warning - the command lines for this are also 
being revised to provide ROP and JOP protection using BTI from v8.5-a 
during the GCC-9 timeframe but I suspect that's a different option.

regards
Ramana

Reviewed-by: Ramana Radhakrishnan  <ramana.radhakrishnan@arm.com>
