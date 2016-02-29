From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v13 01/20] ARM64: Move PMU register related defines to
 asm/perf_event.h
Date: Mon, 29 Feb 2016 19:03:10 +0000
Message-ID: <56D495EE.7060006@arm.com>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
 <1456290520-10012-2-git-send-email-zhaoshenglong@huawei.com>
 <20160224175247.GE12471@arm.com> <56CE6098.8070001@huawei.com>
 <56D4428B.5000505@arm.com> <56D492E5.4040709@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56D492E5.4040709@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 29/02/16 18:50, Shannon Zhao wrote:
> 
> 
> On 2016/2/29 21:07, Marc Zyngier wrote:
>> Shannon,
>>
>> On 25/02/16 02:02, Shannon Zhao wrote:
>>>
>>>
>>> On 2016/2/25 1:52, Will Deacon wrote:
>>>> On Wed, Feb 24, 2016 at 01:08:21PM +0800, Shannon Zhao wrote:
>>>>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>>>>
>>>>> To use the ARMv8 PMU related register defines from the KVM code, we move
>>>>> the relevant definitions to asm/perf_event.h header file and rename them
>>>>> with prefix ARMV8_PMU_.
>>>>>
>>>>> Signed-off-by: Anup Patel <anup.patel@linaro.org>
>>>>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>>>> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>>>>> ---
>>>>>  arch/arm64/include/asm/perf_event.h | 35 +++++++++++++++++++
>>>>>  arch/arm64/kernel/perf_event.c      | 68 ++++++++++---------------------------
>>>>>  2 files changed, 52 insertions(+), 51 deletions(-)
>>>>
>>>> Looks fine to me, but we're going to get some truly horrible conflicts
>>>> in -next.
>>>>
>>>> I'm open to suggestions on the best way to handle this, but one way
>>>> would be:
>>>>
>>>>   1. Duplicate all the #defines privately in KVM (queue via kvm tree)
>>> This way seems not proper I think.
>>>
>>>>   2. Rebase this patch onto my perf/updates branch [1] (queue via me)
>>> While to this series, it really relies on the perf_event.h to compile
>>> and test, so maybe for KVM-ARM and KVM maintainers it's not proper.
>>>
>>>>   3. Patch at -rc1 dropping the #defines from (1) and moving to the new
>>>>      perf_event.h stuff
>>>>
>>> I vote for this way. Since the patch in [1] is small and nothing else
>>> relies on them, I think it would be simple to rebase them onto this series.
>>>
>>>> Thoughts?
>>>>
>>> Anyway, there are only 3 lines which have conflicts. I'm not sure
>>> whether we could handle this when we merge them.
>>
>> I think you're missing the point:
>>
>> - We want both the arm64 perf and KVM trees to be easy to merge
>> - The conflicts are not that simple to resolve
>> - We want these conflicts to be solved before it hits Linus' tree
>>
> Ah, sorry. I realized this later.
> 
>> With that in mind, here's what I'm suggesting we merge as a first patch:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=queue&id=2029b4b02691ec6ebba3d281068e783353d7e108
>>
>> Once this and the perf/updates branch are merged, we can add one last
>> patch reverting this hack and actually doing the renaming work (Will has
>> posted a resolution for most of the new things).
>>
>> Thoughts?
>>
> It's fine I think. (It's first time to me to face this kind of problem.
> :)). Thanks for your help.

No worries. I've taken this patch plus most of your v14 series and the
v15 patch that you posted here, and applied the whole thing on top of
kvmarm/next (having rejigged a couple of things there). I've also fixed
the definition of ARMV8_PMU_PMCR_MASK to take PMCR_EL0.LC into account.

Please give it a go. Any fix will should now come as a patch on top of
this branch.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
