From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 17/20] KVM: ARM64: Add PMU overflow interrupt routing
Date: Thu, 7 Jan 2016 13:28:27 +0000
Message-ID: <20160107132827.402b11f0@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
	<1450771695-11948-18-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450771695-11948-18-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 22 Dec 2015 16:08:12 +0800
Shannon Zhao <zhaoshenglong@huawei.com> wrote:

> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> When calling perf_event_create_kernel_counter to create perf_event,
> assign a overflow handler. Then when the perf event overflows, set the
> corresponding bit of guest PMOVSSET register. If this counter is enabled
> and its interrupt is enabled as well, kick the vcpu to sync the
> interrupt.
> 
> On VM entry, if there is counter overflowed, inject the interrupt with
> the level set to 1. Otherwise, inject the interrupt with the level set
> to 0.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
