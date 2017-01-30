From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v4 2/4] arm64: Work around Falkor erratum 1003
Date: Mon, 30 Jan 2017 17:09:34 -0500
Message-ID: <f85f5b08-1f95-e008-b2e2-ca40d875efff@codeaurora.org>
References: <20170125155232.10277-1-cov@codeaurora.org>
 <20170125155232.10277-2-cov@codeaurora.org>
 <20170127143848.GA25899@leverpostej>
 <e3343971-9e21-3462-f07b-569b496ab8ad@codeaurora.org>
 <20170130105627.GA1160@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9247B4095B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 17:09:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 11c8Mz7Criyi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 17:09:20 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A2AC40430
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 17:09:20 -0500 (EST)
In-Reply-To: <20170130105627.GA1160@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Neil Leeder <nleeder@codeaurora.org>, Jon Masters <jcm@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

On 01/30/2017 05:56 AM, Mark Rutland wrote:
> Hi,
> 
> On Fri, Jan 27, 2017 at 04:52:23PM -0500, Christopher Covington wrote:
>> On 01/27/2017 09:38 AM, Mark Rutland wrote:
>>> On Wed, Jan 25, 2017 at 10:52:30AM -0500, Christopher Covington wrote:
> 
>>>> Replacing the above sequence with the one below will ensure that no TLB
>>>> entries with an incorrect ASID are used by software.
>>>>
>>>>   write reserved value to TTBRx_EL1[ASID]
>>>>   ISB
>>>>   write new value to TTBRx_EL1[BADDR]
>>>>   ISB
>>>>   write new value to TTBRx_EL1[ASID]
>>>>   ISB
>>>>
>>>> When the above sequence is used, page table entries using the new BADDR
>>>> value may still be incorrectly allocated into the TLB using the reserved
>>>> ASID. Yet this will not reduce functionality, since TLB entries incorrectly
>>>> tagged with the reserved ASID will never be hit by a later instruction.
>>>
>>> I agree that there should be no explicit accesses to the VAs for these
>>> entries. So tasks should not see erroneous VAs, and we shouldn't see
>>> synchronous TLB conflict aborts.
>>>
>>> Regardless, can this allow conflicting TLB entries to be allocated to
>>> the reserved ASID? e.g. if one task has a 4K mapping at a given VA, and
>>> another has a 2M mapping which covers that VA, can both be allocated
>>> into the TLBs under the reserved ASID?
>>>
>>> Can that have any effect on asynchronous TLB lookups or page table
>>> walks, e.g. for speculated accesses?
>>
>> A speculative access that inserts an entry into the TLB could
>> possibly find the conflict but will not signal it. Does that answer
>> your question?
> 
> Yes!
> 
> The other case I was worried about was intermediate caching. I take it
> the values in TLBs are not used as part of subsequent page table walks?
> 
> If so, the above sounds fine to me.
> 
> Otherwise, we'll need additional TLB maintenance.

Errant TLB entries will not be used for any legitimate subsequent page
table walks.

I have some minor changes which I'll send as v5 based on
kernel/git/arm64/linux.git for-next/core.

Thanks,
Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
