From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 00/21] KVM: ARM64: Add guest PMU support
Date: Tue, 08 Dec 2015 17:56:20 +0000
Message-ID: <566719C4.9030305@arm.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Shannon,

On 08/12/15 12:47, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> This patchset adds guest PMU support for KVM on ARM64. It takes
> trap-and-emulate approach. When guest wants to monitor one event, it
> will be trapped by KVM and KVM will call perf_event API to create a perf
> event and call relevant perf_event APIs to get the count value of event.

There is still some work to do. A number of bugs, some design issues,
and in general a lot of tidying up to do. If you want this in 4.5,
you're going to have to address this quickly.

But quickly doesn't mean rushing it, and I have the feeling that this is
what you've done over the past week. Also, I've reviewed this series 3
times during that time, and I feel a bit exhausted.

So please do not send another one before the end of the week. take the
time to address all the comments, ask questions if needed, and hopefully
I can review it again next Monday.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
