From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: Re: [RFC 17/17] arm64: compile the kernel with ptrauth
 -msign-return-address
Date: Thu, 11 Oct 2018 15:00:57 +0100
Message-ID: <edbb3ad0-a38e-743f-f2e7-2241f2ed12ee@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-18-kristina.martsenko@arm.com>
 <cd1eface-aebb-b654-c57c-91690087957f@foss.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cd1eface-aebb-b654-c57c-91690087957f@foss.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ramana Radhakrishnan <ramana.radhakrishnan@foss.arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <Catalin.Marinas@arm.com>, Christoffer Dall <Christoffer.Dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, Will Deacon <Will.Deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/10/2018 10:01, Ramana Radhakrishnan wrote:
> On 05/10/2018 09:47, Kristina Martsenko wrote:
>> Compile all functions with two ptrauth instructions: paciasp in the
>> prologue to sign the return address, and autiasp in the epilogue to
>> authenticate the return address. This should help protect the kernel
>> against attacks using return-oriented programming.
>>
>> CONFIG_ARM64_PTR_AUTH enables pointer auth for both userspace and the
>> kernel.
>>
>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
>> ---
>>   arch/arm64/Makefile | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
>> index 106039d25e2f..dbcd43ea99d8 100644
>> --- a/arch/arm64/Makefile
>> +++ b/arch/arm64/Makefile
>> @@ -56,6 +56,10 @@ KBUILD_AFLAGS    += $(lseinstr) $(brokengasinst)
>>   KBUILD_CFLAGS    += $(call cc-option,-mabi=lp64)
>>   KBUILD_AFLAGS    += $(call cc-option,-mabi=lp64)
>>   +ifeq ($(CONFIG_ARM64_PTR_AUTH),y)
>> +KBUILD_CFLAGS    += -msign-return-address=all
> 
> Glad to see this being done and being proposed for mainline.
> 
> I can see why you would prefer this though have you guys experimented at
> all with -msign-return-address=non-leaf as well ?

I've tried non-leaf and it works too. I'd be fine with switching to it,
I'm not sure which would be better for the kernel.

What kind of experiments did you have in mind? If I understand
correctly, then compared to non-leaf, "all" additionally protects leaf
functions that write to the stack. I don't know how many of those there
are in the kernel (or will be in the future). I also don't know the
additional performance impact of "all", as I don't think we have any
v8.3 hardware to test on yet. There is a minor code size impact (0.36%
on the current kernel), but I'm not sure how much that matters.

> Orthogonally and just fair warning - the command lines for this are also
> being revised to provide ROP and JOP protection using BTI from v8.5-a
> during the GCC-9 timeframe but I suspect that's a different option.

Thanks. I expect it will be a separate Kconfig option to build the
kernel with BTI and pointer auth, yes.

> Reviewed-by: Ramana Radhakrishnan  <ramana.radhakrishnan@arm.com>

Thanks!

Kristina
