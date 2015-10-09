From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 03/15] arm64: Introduce helpers for page table levels
Date: Fri, 9 Oct 2015 10:22:23 +0100
Message-ID: <5617874F.5010104@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-4-git-send-email-suzuki.poulose@arm.com>
 <20151007082652.GM9011@cbox> <5614E536.9040007@arm.com>
 <20151008144546.GD20936@cbox> <5616A65A.50003@arm.com>
 <20151008172856.GQ17192@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C791C41451
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Oct 2015 05:20:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0JlmpCL92Ngh for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Oct 2015 05:20:23 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [146.101.78.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C8FA413E1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Oct 2015 05:20:23 -0400 (EDT)
In-Reply-To: <20151008172856.GQ17192@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 08/10/15 18:28, Catalin Marinas wrote:
> On Thu, Oct 08, 2015 at 06:22:34PM +0100, Suzuki K. Poulose wrote:
>> On 08/10/15 15:45, Christoffer Dall wrote:
>>> On Wed, Oct 07, 2015 at 10:26:14AM +0100, Marc Zyngier wrote:
>>>> I just had a chat with Catalin, who did shed some light on this.
>>>> It all has to do with rounding up. What you would like to have here is:
>>>>
>>>> #define ARM64_HW_PGTABLE_LEVELS(va_bits) DIV_ROUND_UP(va_bits - PAGE_SHIFT, PAGE_SHIFT - 3)
>>>>
>>>> where (va_bits - PAGE_SHIFT) is the total number of bits we deal
>>>> with during a page table walk, and (PAGE_SHIFT - 3) is the number
>>>> of bits we deal with per level.
>>>>
>>>> The clue is in how DIV_ROUND_UP is written:
>>>>
>>>> #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>>>>
>>>> which gives you Suzuki's magic formula.
>>>>
>>>> I'd vote for the DIV_ROUND_UP(), which will make things a lot more readable.
>>>>
>>> Thanks for the explanation, I vote for DIV_ROUND_UP too.
>>
>> Btw, DIV_ROUND_UP is defined in linux/kernel.h, including which in the required
>> headers breaks the build. I could add the definition of the same locally.
>
> Or just keep the original magic formula and add the DIV_ROUND_UP one in
> a comment.
>

OK, will keep proper documentation with the cryptic formula ;)

Suzuki
