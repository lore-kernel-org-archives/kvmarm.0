From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/2] arm: KVM: Do not update PC if the trap handler has
 updated it
Date: Thu, 07 Jan 2016 09:05:06 +0000
Message-ID: <568E2A42.7040606@arm.com>
References: <1450778118-12715-1-git-send-email-marc.zyngier@arm.com> <1450778118-12715-2-git-send-email-marc.zyngier@arm.com> <CAFEAcA8F2TJuRR5ELvit0FPa3XFMJ847S8WK25i5aVdGBU=PUA@mail.gmail.com> <20151222143947.GA5631@cbox> <CAFEAcA9dALQv8Xcyg5FLAvRaJfH5UT2u4jrLjofLh5Ff2yo=8Q@mail.gmail.com> <568E26CD.8020500@arm.com> <568E28F0.9010405@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <568E28F0.9010405@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, Shannon Zhao <shannon.zhao@linaro.org>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/01/16 08:59, Shannon Zhao wrote:
> 
> 
> On 2016/1/7 16:50, Marc Zyngier wrote:
>> On 22/12/15 14:50, Peter Maydell wrote:
>>> On 22 December 2015 at 14:39, Christoffer Dall
>>> <christoffer.dall@linaro.org> wrote:
>>>> On Tue, Dec 22, 2015 at 11:08:10AM +0000, Peter Maydell wrote:
>>>>> Won't this result in our incorrectly skipping the first insn
>>>>> in the fault handler if the original offending instruction
>>>>> was itself the first insn in the fault handler?
>>>>>
>>>> Wouldn't that then loop with the exception forever?
>>>
>>> Yes, but so would real hardware...
>>
>> Indeed. As it is, this patch is not doing what it should. On the other
>> hand, I came to the conclusion that we do not need to fix this just yet,
>> as long as we only let KVM inject an UNDEF, and that's what the PMU code
>> requires.
>>
>> I'll comment on the PMU thread, but the gist of it is:
>> 1) fix the arm64 UNDEF/PABRT/DABRT code to properly account for the the
>> source EL (Table D1-7 of the ARMv8 ARM).
> This looks like something we add in the PMU patch set.
> 
> +		switch (cpsr & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
> +		case PSR_MODE_EL0t:
> +			exc_offset = EL0_EXCEPT_SYNC_OFFSET_64;
> +			break;
> +		case PSR_MODE_EL1t:
> +			exc_offset = EL1_EXCEPT_BAD_SYNC_OFFSET;
> +			break;
> +		case PSR_MODE_EL1h:
> +			exc_offset = EL1_EXCEPT_SYNC_OFFSET;
> +			break;
> +		default:
> +			exc_offset = EL0_EXCEPT_SYNC_OFFSET_32;
> +		}
> +

Indeed, plus some additional code to select the actual vector and not be
limited to a Synchronous exception (even if that's the only thing we use
today).

See the patch I've just posted for more details.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
