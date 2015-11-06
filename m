From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm: Fix crash in free_hyp_pgds() if timer initialization
 fails
Date: Fri, 06 Nov 2015 13:50:10 +0000
Message-ID: <563CB012.3090705@arm.com>
References: <1445931608-8824-1-git-send-email-p.fedin@samsung.com> <20151105152440.GF5819@cbox> <002601d11876$1bc3cf40$534b6dc0$@samsung.com> <20151106114223.GI5819@cbox> <006d01d11899$2f7932f0$8e6b98d0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <006d01d11899$2f7932f0$8e6b98d0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/11/15 13:43, Pavel Fedin wrote:
>  Hello!
> 
>>>> Did you check if PAGE_HYP_DEVICE can mean something sane on a stage-2
>>>> page table entry and vice verse?
>>>
>>>  I tried to, the chain of macros and variables is complicated enough not to
>>> get 200% sure, but anyway PAGE_HYP_DEVICE (as well as PAGE_S2_DEVICE)
>>> includes PROT_PTE_DEVICE, so this is definitely device.
>>>  I even tried to construct some mask in order to make a single check for only
>>> DEVICE flags, but, to make things even less understandable and predictable,
>>> the same code with different bitfields is reused by ARM64. So, i thought that
>>> it will be more reliable just to add a second test.
>>
>> The thing I want to avoid is PAGE_HYP_DEVICE covering some normal S2
>> mapping, which we *should* flush but that we now end up ignoring?  That
>> doesn't sound like it can be the case because the device bit is the same
>> bit for both types of page tables, correct?
> 
>  Yes, this is exactly what i think. If DEVICE bit is set, then it's somehow
> device memory and it doesn't need flashing.
> 
>  Or, in order to be 200% sure, we could modify the whole unmapping logic to carry
> over a flag, telling whether we are removing normal or HYP mappings. But wouldn't
> this be much more complicated?

We could do without that complexity. Also, the test itself is wrong (see
Ard's patch that was posted this morning for the real fix).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
