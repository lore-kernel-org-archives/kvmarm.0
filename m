From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 00/19] KVM: ARM64: Add guest PMU support
Date: Tue, 15 Dec 2015 15:41:54 +0000
Message-ID: <567034C2.8090307@arm.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 15/12/15 08:49, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> This patchset adds guest PMU support for KVM on ARM64. It takes
> trap-and-emulate approach. When guest wants to monitor one event, it
> will be trapped by KVM and KVM will call perf_event API to create a perf
> event and call relevant perf_event APIs to get the count value of event.
> 
> Use perf to test this patchset in guest. When using "perf list", it
> shows the list of the hardware events and hardware cache events perf
> supports. Then use "perf stat -e EVENT" to monitor some event. For
> example, use "perf stat -e cycles" to count cpu cycles and
> "perf stat -e cache-misses" to count cache misses.
> 
> Below are the outputs of "perf stat -r 5 sleep 5" when running in host
> and guest.
> 
> Host:
>  Performance counter stats for 'sleep 5' (5 runs):
> 
>           0.549456      task-clock (msec)         #    0.000 CPUs utilized            ( +-  5.68% )
>                  1      context-switches          #    0.002 M/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 48      page-faults               #    0.088 M/sec                    ( +-  1.40% )
>            1146243      cycles                    #    2.086 GHz                      ( +-  5.71% )
>    <not supported>      stalled-cycles-frontend
>    <not supported>      stalled-cycles-backend
>             627195      instructions              #    0.55  insns per cycle          ( +- 15.65% )
>    <not supported>      branches
>               9826      branch-misses             #   17.883 M/sec                    ( +-  1.10% )
> 
>        5.000875516 seconds time elapsed                                          ( +-  0.00% )
> 
> 
> Guest:
>  Performance counter stats for 'sleep 5' (5 runs):
> 
>           0.640712      task-clock (msec)         #    0.000 CPUs utilized            ( +-  0.41% )
>                  1      context-switches          #    0.002 M/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 50      page-faults               #    0.077 M/sec                    ( +-  1.37% )
>            1320428      cycles                    #    2.061 GHz                      ( +-  0.29% )
>    <not supported>      stalled-cycles-frontend
>    <not supported>      stalled-cycles-backend
>             642373      instructions              #    0.49  insns per cycle          ( +-  0.46% )
>    <not supported>      branches
>              10399      branch-misses             #   16.230 M/sec                    ( +-  1.57% )
> 
>        5.001181020 seconds time elapsed                                          ( +-  0.00% )
> 
> 
> Have a cycle counter read test like below in guest and host:
> 
> static void test(void)
> {
> 	unsigned long count, count1, count2;
> 	count1 = read_cycles();
> 	count++;
> 	count2 = read_cycles();
> }
> 
> Host:
> count1: 3049567104
> count2: 3049567247
> delta: 143
> 
> Guest:
> count1: 5281420890
> count2: 5281421068
> delta: 178
> 
> The gap between guest and host is very small. One reason for this I
> think is that it doesn't count the cycles in EL2 and host since we add
> exclude_hv = 1. So the cycles spent to store/restore registers which
> happens at EL2 are not included.
> 
> This patchset can be fetched from [1] and the relevant QEMU version for
> test can be fetched from [2].
> 
> The results of 'perf test' can be found from [3][4].
> The results of perf_event_tests test suite can be found from [5][6].
> 
> Also, I have tested "perf top" in two VMs and host at the same time. It
> works well.

So while things are steadily improving, there is still more things to do
(and the more I review the code, the more I find things, which worries me).

The biggest issue at the moment is the handling of accesses at EL0,
which should be forwarded to EL1 instead of ignoring the access when
denied. There is also the UNDEFINED accesses (which are pretty easy to
solve), and a couple of straightforward bugs and other nits that should
be easy to fix.

If you can fix the above and that the result looks good, I'll try to put
it into -next. But at the moment, it looks like we're not really on
track to make it into 4.5.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
