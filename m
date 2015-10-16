From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v3 00/20] KVM: ARM64: Add guest PMU support
Date: Fri, 16 Oct 2015 13:01:15 -0400
Message-ID: <56212D5B.1050207@codeaurora.org>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
 <5620833B.5050803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49B8A411E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 12:58:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CHyIN0+afCvS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Oct 2015 12:58:57 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8FC1411AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 12:58:57 -0400 (EDT)
In-Reply-To: <5620833B.5050803@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Wei Huang <wei@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/16/2015 12:55 AM, Wei Huang wrote:
> 
> 
> On 09/24/2015 05:31 PM, Shannon Zhao wrote:
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
>>  Performance counter stats for 'sleep 5' (5 runs):
>>
>>           0.551428      task-clock (msec)         #    0.000 CPUs utilized            ( +-  0.91% )
>>                  1      context-switches          #    0.002 M/sec
>>                  0      cpu-migrations            #    0.000 K/sec
>>                 48      page-faults               #    0.088 M/sec                    ( +-  1.05% )
>>            1150265      cycles                    #    2.086 GHz                      ( +-  0.92% )
>>    <not supported>      stalled-cycles-frontend
>>    <not supported>      stalled-cycles-backend
>>             526398      instructions              #    0.46  insns per cycle          ( +-  0.89% )
>>    <not supported>      branches
>>               9485      branch-misses             #   17.201 M/sec                    ( +-  2.35% )
>>
>>        5.000831616 seconds time elapsed                                          ( +-  0.00% )
>>
>> Guest:
>>  Performance counter stats for 'sleep 5' (5 runs):
>>
>>           0.730868      task-clock (msec)         #    0.000 CPUs utilized            ( +-  1.13% )
>>                  1      context-switches          #    0.001 M/sec
>>                  0      cpu-migrations            #    0.000 K/sec
>>                 48      page-faults               #    0.065 M/sec                    ( +-  0.42% )
>>            1642982      cycles                    #    2.248 GHz                      ( +-  1.04% )
>>    <not supported>      stalled-cycles-frontend
>>    <not supported>      stalled-cycles-backend
>>             637964      instructions              #    0.39  insns per cycle          ( +-  0.65% )
>>    <not supported>      branches
>>              10377      branch-misses             #   14.198 M/sec                    ( +-  1.09% )
>>
>>        5.001289068 seconds time elapsed                                          ( +-  0.00% )
>>
> 
> Thanks for V3. One suggestion is to run more perf stress tests, such as
> "perf test". So we know the corner cases are covered as much as possible.

I'd also recommend Vince Weaver's perf_event_tests. It tests things like
signal-on-counter-overflow that I've never seen anywhere else (other than some
of my own code).

https://github.com/deater/perf_event_tests

Christopher Covington

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
