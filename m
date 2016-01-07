From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 00/20] KVM: ARM64: Add guest PMU support
Date: Thu, 07 Jan 2016 14:21:48 +0000
Message-ID: <568E747C.9060405@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <568E71DE.9030905@arm.com> <20160107141227.GE23028@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30DDB40FA6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 09:18:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZSg1EvK+t-x7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2016 09:18:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11176407A6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 09:18:08 -0500 (EST)
In-Reply-To: <20160107141227.GE23028@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvm@vger.kernel.org, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/01/16 14:12, Will Deacon wrote:
> On Thu, Jan 07, 2016 at 02:10:38PM +0000, Marc Zyngier wrote:
>> On 22/12/15 08:07, Shannon Zhao wrote:
>>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>>
>>> This patchset adds guest PMU support for KVM on ARM64. It takes
>>> trap-and-emulate approach. When guest wants to monitor one event, it
>>> will be trapped by KVM and KVM will call perf_event API to create a perf
>>> event and call relevant perf_event APIs to get the count value of event.
>>>
>>> Use perf to test this patchset in guest. When using "perf list", it
>>> shows the list of the hardware events and hardware cache events perf
>>> supports. Then use "perf stat -e EVENT" to monitor some event. For
>>> example, use "perf stat -e cycles" to count cpu cycles and
>>> "perf stat -e cache-misses" to count cache misses.
>>
>> I finally feel like we're pretty close to something we could merge. My
>> current concerns are:
> 
> The merge window opens on Monday and I'm not prepared to take further
> PMU changes at this point (unless they're bug fixes, of course).
> 
> This needs to wait until 4.6.

Fair enough. I guess I'll continue the review process and queue that
early in the next cycle.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
