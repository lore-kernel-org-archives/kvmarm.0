From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/3] KVM: arm64: BUG FIX: Correctly handle zero register
 transfers
Date: Thu, 03 Dec 2015 11:39:00 +0000
Message-ID: <566029D4.2050200@arm.com>
References: <cover.1449136209.git.p.fedin@samsung.com> <56601407.7020407@arm.com> <00cb01d12db8$cf9e8580$6edb9080$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00cb01d12db8$cf9e8580$6edb9080$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/12/15 10:53, Pavel Fedin wrote:
>  Hello!
> 
>>> The problem has been discovered by performing an operation
>>>
>>>  *((volatile int *)reg) = 0;
>>>
>>> which compiles as "str xzr, [xx]", and resulted in strange values being
>>> written.
>>
>> Interesting find. Which compiler is that?
> 
> $ aarch64-linux-gnu-gcc --version
> aarch64-linux-gnu-gcc (Linaro GCC 2014.11) 4.9.3 20141031 (prerelease)
> Copyright (C) 2014 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

OK. I was just wondering if that was a new thing or not.

[...]

>  Isn't it legitimate to write from ZR to MMIO register?
>  Another potential case is in our vgic-v3-switch.S:
> 
> 	msr_s	ICH_HCR_EL2, xzr
> 
>  It's only because it is KVM code we have never discovered this problem yet. Somebody could write such a thing in some other place,
> with some other register, which would be executed by KVM, and... boo...

I'm certainly not disputing that, this is a real bug that should be
fixed right now.

Looking forward to seeing your v2.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
