From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 03/15] arm64: Introduce helpers for page table levels
Date: Thu, 8 Oct 2015 18:22:34 +0100
Message-ID: <5616A65A.50003@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-4-git-send-email-suzuki.poulose@arm.com>
 <20151007082652.GM9011@cbox> <5614E536.9040007@arm.com>
 <20151008144546.GD20936@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151008144546.GD20936@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 08/10/15 15:45, Christoffer Dall wrote:
> On Wed, Oct 07, 2015 at 10:26:14AM +0100, Marc Zyngier wrote:
>> On 07/10/15 09:26, Christoffer Dall wrote:
>>> Hi Suzuki,
>>>


>> I just had a chat with Catalin, who did shed some light on this.
>> It all has to do with rounding up. What you would like to have here is:
>>
>> #define ARM64_HW_PGTABLE_LEVELS(va_bits) DIV_ROUND_UP(va_bits - PAGE_SHIFT, PAGE_SHIFT - 3)
>>
>> where (va_bits - PAGE_SHIFT) is the total number of bits we deal
>> with during a page table walk, and (PAGE_SHIFT - 3) is the number
>> of bits we deal with per level.
>>
>> The clue is in how DIV_ROUND_UP is written:
>>
>> #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>>
>> which gives you Suzuki's magic formula.
>>
>> I'd vote for the DIV_ROUND_UP(), which will make things a lot more readable.
>>
> Thanks for the explanation, I vote for DIV_ROUND_UP too.

Btw, DIV_ROUND_UP is defined in linux/kernel.h, including which in the required
headers breaks the build. I could add the definition of the same locally.

>
> You can stash this away for a cryptic interview question ;)

;)


Suzuki
