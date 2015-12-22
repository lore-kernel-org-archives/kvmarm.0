From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v5 3/3] KVM/arm/arm64: enable enhanced armv8 fp/simd lazy
 switch
Date: Tue, 22 Dec 2015 10:01:46 -0800
Message-ID: <5679900A.9080108@samsung.com>
References: <1449450434-2929-1-git-send-email-m.smarduch@samsung.com>
 <1449450434-2929-4-git-send-email-m.smarduch@samsung.com>
 <20151218135403.GH32720@cbox> <5674B00C.1050900@samsung.com>
 <20151219074538.GA9370@cbox> <56785441.3070708@samsung.com>
 <20151222080612.GA3076@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED9E4412A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 12:59:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jLeqd+w2Ih24 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Dec 2015 12:59:05 -0500 (EST)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CD9D41267
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 12:59:04 -0500 (EST)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NZR00HCZU300B80@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 22 Dec 2015 13:01:48 -0500 (EST)
In-reply-to: <20151222080612.GA3076@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 12/22/2015 12:06 AM, Christoffer Dall wrote:
> On Mon, Dec 21, 2015 at 11:34:25AM -0800, Mario Smarduch wrote:
>>
>>
>> On 12/18/2015 11:45 PM, Christoffer Dall wrote:
>>> On Fri, Dec 18, 2015 at 05:17:00PM -0800, Mario Smarduch wrote:
>>>> On 12/18/2015 5:54 AM, Christoffer Dall wrote:
>>>>> On Sun, Dec 06, 2015 at 05:07:14PM -0800, Mario Smarduch wrote:
[...]

>>>>>> +  *	we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
>>>>>> +  */
>>>>>> +ENTRY(__kvm_vcpu_enable_fpexc32)
>>>>>> +	mov	x3, #(1 << 30)
>>>>>> +	msr	fpexc32_el2, x3
>>>>>> +	isb
>>>>>
>>>>> this is only called via a hypercall so do you really need the ISB?
>>>>
>>>> Same comment as in 2nd patch for the isb.
>>>>
>>>
>>> Unless you can argue that something needs to take effect before
>>> something else, where there's no other implicit barrier, you don't need
>>> the ISB.
>>
>> Make sense an exception level change should be a barrier. It was not there
>> before I put it in due to lack of info on meaning of 'implicit'. The manual has
>> more info on implicit barriers for operations like DMB.
> 
> if the effect from the register write just has to be visible after
> taking an exception, then you don't need the ISB.

Good definition, should be in the manual :)

Thanks.
> 
>>
>> Speaking of ISB it doesn't appear like this one is needed, it's between couple
>> register reads in 'save_time_state' macro.
>>
>> mrc     p15, 0, r2, c14, c3, 1  @ CNTV_CTL
>> str     r2, [vcpu, #VCPU_TIMER_CNTV_CTL]
>>
>> isb
>>
>> mrrc    p15, 3, rr_lo_hi(r2, r3), c14   @ CNTV_CVAL
>>
> 
> I think there was a reason for that one, so let's not worry about that
> for now.
> 
> -Christoffer
> 
