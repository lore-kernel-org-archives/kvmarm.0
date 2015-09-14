From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v2 00/22] KVM: ARM64: Add guest PMU support
Date: Mon, 14 Sep 2015 20:58:47 +0800
Message-ID: <55F6C487.5060801@linaro.org>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
 <20150914115300.GM15712@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 169D441022
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 08:58:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8K3OjodahARl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2015 08:58:03 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 270FE40FA7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 08:58:02 -0400 (EDT)
Received: by wicgb1 with SMTP id gb1so140711016wic.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 05:58:55 -0700 (PDT)
In-Reply-To: <20150914115300.GM15712@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/9/14 19:53, Christoffer Dall wrote:
> Hi Shannon,
>
> On Fri, Sep 11, 2015 at 04:54:53PM +0800, Shannon Zhao wrote:
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
>>            0.551428      task-clock (msec)         #    0.000 CPUs utilized            ( +-  0.91% )
>>                   1      context-switches          #    0.002 M/sec
>>                   0      cpu-migrations            #    0.000 K/sec
>>                  48      page-faults               #    0.088 M/sec                    ( +-  1.05% )
>>             1150265      cycles                    #    2.086 GHz                      ( +-  0.92% )
>>     <not supported>      stalled-cycles-frontend
>>     <not supported>      stalled-cycles-backend
>>              526398      instructions              #    0.46  insns per cycle          ( +-  0.89% )
>>     <not supported>      branches
>>                9485      branch-misses             #   17.201 M/sec                    ( +-  2.35% )
>>
>>         5.000831616 seconds time elapsed                                          ( +-  0.00% )
>>
>> Guest:
>>   Performance counter stats for 'sleep 5' (5 runs):
>>
>>            0.730868      task-clock (msec)         #    0.000 CPUs utilized            ( +-  1.13% )
>>                   1      context-switches          #    0.001 M/sec
>>                   0      cpu-migrations            #    0.000 K/sec
>>                  48      page-faults               #    0.065 M/sec                    ( +-  0.42% )
>>             1642982      cycles                    #    2.248 GHz                      ( +-  1.04% )
>>     <not supported>      stalled-cycles-frontend
>>     <not supported>      stalled-cycles-backend
>>              637964      instructions              #    0.39  insns per cycle          ( +-  0.65% )
>>     <not supported>      branches
>>               10377      branch-misses             #   14.198 M/sec                    ( +-  1.09% )
>>
>>         5.001289068 seconds time elapsed                                          ( +-  0.00% )
>>
>> This patchset can be fetched from [1] and the relevant QEMU version for
>> test can be fetched from [2].
>>
> Is there a changelog for this patch set somewhere?
>

I forgot this, while I realized it after sending this patchset out.

> If not, can you include this in v3 addressing Marc's comments?
>
> Thanks,
> -Christoffer
>

-- 
Shannon
