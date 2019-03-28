From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v6 19/27] KVM: arm64: Enumerate SVE register indices for
 KVM_GET_REG_LIST
Date: Thu, 28 Mar 2019 16:59:46 +0000
Message-ID: <9832368a-dfd6-d0eb-ee05-3663e1bda3c1@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
 <1553017938-710-20-git-send-email-Dave.Martin@arm.com>
 <612e5089-fc43-eee4-1856-cdca89ce3b50@arm.com>
 <20190327103319.GT3567@e103592.cambridge.arm.com>
 <71c30b21-9a4b-42d5-02a8-25bc18044c1f@arm.com>
 <20190328122702.GB3567@e103592.cambridge.arm.com>
 <7ac932dd-18b4-41c0-d7d8-1ddb74e088d1@arm.com>
 <20190328164833.GC3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E1F4A320
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 12:59:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZeSVw+iqgOCr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Mar 2019 12:59:51 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BE0C4A2E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 12:59:51 -0400 (EDT)
In-Reply-To: <20190328164833.GC3567@e103592.cambridge.arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 28/03/2019 16:48, Dave Martin wrote:
> On Thu, Mar 28, 2019 at 02:29:23PM +0000, Julien Thierry wrote:
>>
>>
>> On 28/03/2019 12:27, Dave Martin wrote:
>>> On Wed, Mar 27, 2019 at 03:21:02PM +0000, Julien Thierry wrote:
>>>>
>>>>
>>>> On 27/03/2019 10:33, Dave Martin wrote:
> 
> [...]
> 
>>>>> 	return slices;
>>>>> }
>>>>>
>>>>> This may be clearer, but felt a bit like overkill...
>>>>>
>>>>> Thoughts?
>>>>
>>>> Seems a bit overkill yes... I was more thinking of a define and the
>>>> person in charge of adding the slice support would just need to look for
>>>> references to that define to know (some of) the places that would need
>>>> rework/review.
>>>>
>>>> So, unless someone else thinks it's good to introduce it right now you
>>>> can ignore that.
>>>
>>> OK, how about the following?  This keeps things minimal, but should help
>>> future maintainers know that something may need updating here in the
>>> future. 
>>>
>>
>> Yes, I think this looks good.
> 
> OK, are you happy for me to keep your Reviewed-by with that change?
> 

Yes, please do!

Thanks,

-- 
Julien Thierry
