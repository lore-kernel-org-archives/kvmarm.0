From: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 08/13] arm64: expose user PAC bit positions via ptrace
Date: Mon, 10 Dec 2018 08:22:06 -0600
Message-ID: <ba48e082-3e47-43bc-77d1-97d741c59284@linaro.org>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-9-kristina.martsenko@arm.com>
 <a31ca10a-ee1a-71fb-2c3d-a6184e12b543@linaro.org>
 <20181210120330.GB4048@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181210120330.GB4048@arrakis.emea.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Andrew Jones <drjones@redhat.com>, Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Adam Wallis <awallis@codeaurora.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, Dave P Martin <dave.martin@arm.com>, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Steve Capper <Steve.Capper@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 12/10/18 6:03 AM, Catalin Marinas wrote:
>> However, it won't be too long before someone implements support for
>> ARMv8.2-LVA, at which point, without changes to mandatory pointer tagging, we
>> will only have 3 authentication bits: [54:52].  This seems useless and easily
>> brute-force-able.
> 
> Such support is already here (about to be queued):
> 
> https://lore.kernel.org/linux-arm-kernel/20181206225042.11548-1-steve.capper@arm.com/

Thanks for the pointer.

>> Unfortunately, there is no obvious path to making this optional that does not
>> break compatibility with Documentation/arm64/tagged-pointers.txt.
> 
> There is also the ARMv8.5 MTE (memory tagging) which relies on tagged
> pointers.

So it does.  I hadn't read through that extension completely before.

> An alternative would be to allow the opt-in to 52-bit VA, leaving it at
> 48-bit by default. However, it has the problem of changing the PAC size
> and not being able to return.

Perhaps the opt-in should be at exec time, with ELF flags (or equivalent) on
the application.  Because, as you say, changing the shape of the PAC in the
middle of execution is in general not possible.

It isn't perfect, since old kernels won't fail to exec an application setting
flags that can't be supported.  And it requires tooling changes.


r~
