From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v5 00/21] KVM: ARM64: Add guest PMU support
Date: Mon, 07 Dec 2015 22:47:02 +0800
Message-ID: <56659BE6.3070601@linaro.org>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
 <5665937F.90507@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 772C14130B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 09:45:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VAqxCcNYQAGs for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2015 09:45:22 -0500 (EST)
Received: from mail-pa0-f42.google.com (mail-pa0-f42.google.com
 [209.85.220.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 272F140FA6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 09:45:21 -0500 (EST)
Received: by pacej9 with SMTP id ej9so126207965pac.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Dec 2015 06:47:08 -0800 (PST)
In-Reply-To: <5665937F.90507@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 2015/12/7 22:11, Marc Zyngier wrote:
> Shannon,
>
> On 03/12/15 06:11, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> This patchset adds guest PMU support for KVM on ARM64. It takes
>> trap-and-emulate approach. When guest wants to monitor one event, it
>> will be trapped by KVM and KVM will call perf_event API to create a perf
>> event and call relevant perf_event APIs to get the count value of event.
>>
>> Use perf to test this patchset in guest. When using "perf list", it
>> shows the list of the hardware events and hardware cache events perf
>> supports. Then use "perf stat -e EVENT" to monitor some event. For
>> example, use "perf stat -e cycles" to count cpu cycles and
>> "perf stat -e cache-misses" to count cache misses.
>>
>> Below are the outputs of "perf stat -r 5 sleep 5" when running in host
>> and guest.
>>
>> Host:
>>   Performance counter stats for 'sleep 5' (5 runs):
>>
>>            0.510276      task-clock (msec)         #    0.000 CPUs utilized            ( +-  1.57% )
>>                   1      context-switches          #    0.002 M/sec
>>                   0      cpu-migrations            #    0.000 K/sec
>>                  49      page-faults               #    0.096 M/sec                    ( +-  0.77% )
>>             1064117      cycles                    #    2.085 GHz                      ( +-  1.56% )
>>     <not supported>      stalled-cycles-frontend
>>     <not supported>      stalled-cycles-backend
>>              529051      instructions              #    0.50  insns per cycle          ( +-  0.55% )
>>     <not supported>      branches
>>                9894      branch-misses             #   19.390 M/sec                    ( +-  1.70% )
>>
>>         5.000853900 seconds time elapsed                                          ( +-  0.00% )
>>
>> Guest:
>>   Performance counter stats for 'sleep 5' (5 runs):
>>
>>            0.642456      task-clock (msec)         #    0.000 CPUs utilized            ( +-  1.81% )
>>                   1      context-switches          #    0.002 M/sec
>>                   0      cpu-migrations            #    0.000 K/sec
>>                  49      page-faults               #    0.076 M/sec                    ( +-  1.64% )
>>             1322717      cycles                    #    2.059 GHz                      ( +-  1.88% )
>>     <not supported>      stalled-cycles-frontend
>>     <not supported>      stalled-cycles-backend
>>              640944      instructions              #    0.48  insns per cycle          ( +-  1.10% )
>>     <not supported>      branches
>>               10665      branch-misses             #   16.600 M/sec                    ( +-  2.23% )
>>
>>         5.001181452 seconds time elapsed                                          ( +-  0.00% )
>>
>> Have a cycle counter read test like below in guest and host:
>>
>> static void test(void)
>> {
>> 	unsigned long count, count1, count2;
>> 	count1 = read_cycles();
>> 	count++;
>> 	count2 = read_cycles();
>> }
>>
>> Host:
>> count1: 3046186213
>> count2: 3046186347
>> delta: 134
>>
>> Guest:
>> count1: 5645797121
>> count2: 5645797270
>> delta: 149
>>
>> The gap between guest and host is very small. One reason for this I
>> think is that it doesn't count the cycles in EL2 and host since we add
>> exclude_hv = 1. So the cycles spent to store/restore registers which
>> happens at EL2 are not included.
>>
>> This patchset can be fetched from [1] and the relevant QEMU version for
>> test can be fetched from [2].
>>
>> The results of 'perf test' can be found from [3][4].
>> The results of perf_event_tests test suite can be found from [5][6].
>>
>> Also, I have tested "perf top" in two VMs and host at the same time. It
>> works well.
>
> I've commented on more issues I've found. Hopefully you'll be able to
> respin this quickly enough, and end-up with a simpler code base (state
> duplication is a bit messy).
>
Ok, will try my best :)

> Another thing I have noticed is that you have dropped the vgic changes
> that were configuring the interrupt. It feels like they should be
> included, and configure the PPI as a LEVEL interrupt.
The reason why I drop that is in upstream code PPIs are LEVEL interrupt 
by default which is changed by the arch_timers patches. So is it 
necessary to configure it again?

> Also, looking at
> your QEMU code, you seem to configure the interrupt as EDGE, which is
> now how yor emulated HW behaves.
>
Sorry, the QEMU code is not updated while the version I use for test 
locally configures the interrupt as LEVEL. I will push the newest one 
tomorrow.

> Looking forward to reviewing the next version.
>
> Thanks,
>
> 	M.
>

-- 
Shannon
