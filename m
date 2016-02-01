From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 06/21] arm64: KVM: VHE: Patch out use of HVC
Date: Mon, 1 Feb 2016 18:08:31 +0100
Message-ID: <CAKv+Gu9_KG7Zss3g1OMzcnRKQFhCcYtbSDEk-gwwgqPP-R6DOA@mail.gmail.com>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-7-git-send-email-marc.zyngier@arm.com>
 <20160201131634.GI1478@cbox> <56AF5ED8.7010303@arm.com>
 <20160201153635.GH15514@e104818-lin.cambridge.arm.com>
 <56AF85D8.7080907@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0724C40F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 12:03:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kdRTlOzHntsE for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2016 12:03:14 -0500 (EST)
Received: from mail-ig0-f169.google.com (mail-ig0-f169.google.com
 [209.85.213.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28A8E40BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 12:03:13 -0500 (EST)
Received: by mail-ig0-f169.google.com with SMTP id ik10so40658634igb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Feb 2016 09:08:32 -0800 (PST)
In-Reply-To: <56AF85D8.7080907@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 February 2016 at 17:20, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 01/02/16 15:36, Catalin Marinas wrote:
>> On Mon, Feb 01, 2016 at 01:34:16PM +0000, Marc Zyngier wrote:
>>> On 01/02/16 13:16, Christoffer Dall wrote:
>>>> On Mon, Jan 25, 2016 at 03:53:40PM +0000, Marc Zyngier wrote:
>>>>> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
>>>>> index 93e8d983..9e0683f 100644
>>>>> --- a/arch/arm64/kvm/hyp/hyp-entry.S
>>>>> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
>>>>> @@ -38,6 +38,32 @@
>>>>>    ldp     x0, x1, [sp], #16
>>>>>  .endm
>>>>>
>>>>> +.macro do_el2_call
>>>>> +  /*
>>>>> +   * Shuffle the parameters before calling the function
>>>>> +   * pointed to in x0. Assumes parameters in x[1,2,3].
>>>>> +   */
>>>>> +  stp     lr, xzr, [sp, #-16]!
>>>>
>>>> remind me why this pair isn't just doing "str" instead of "stp" with the
>>>> xzr ?
>>>
>>> Because SP has to be aligned on a 16 bytes boundary at all times.
>>
>> You could do something like:
>>
>>       sub     sp, sp, #16
>>       str     lr, [sp]
>>
>
> Ah, fair enough. I'll fold that in.
>

Since we're micro-reviewing: what's wrong with

str lr, [sp, #-16]!

?
