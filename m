From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 00/20] KVM: ARM64: Add guest PMU support
Date: Thu, 07 Jan 2016 14:10:38 +0000
Message-ID: <568E71DE.9030905@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 22/12/15 08:07, Shannon Zhao wrote:
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

I finally feel like we're pretty close to something we could merge. My
current concerns are:

- the 32bit bugs, and the fact that it has obviously not been tested
with a 32bit guest. It would be good to give it a go (you'll probably
have to lie about the nature of the PMU in your QEMU code by pretending
it is a Cortex-A15 PMU, for example).

- The UNDEF path and the patch I've posted today. I've quickly tested
it, and it seems to do the right thing, but this warrant a thorough review.

- I'd like Peter Maydell (cc'd) to give his Ack to the last patch, as we
need the userspace ABI to be agreed upon.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
