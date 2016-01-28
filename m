From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v10 19/21] KVM: ARM64: Add a new feature bit for PMUv3
Date: Thu, 28 Jan 2016 21:54:18 +0100
Message-ID: <20160128205418.GK16453@hawk.localdomain>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
 <1453866709-20324-20-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453866709-20324-20-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 27, 2016 at 11:51:47AM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> To support guest PMUv3, use one bit of the VCPU INIT feature array.
> Initialize the PMU when initialzing the vcpu with that bit and PMU
> overflow interrupt set.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> Acked-by: Peter Maydell <peter.maydell@linaro.org>
> ---
> CC: Peter Maydell <peter.maydell@linaro.org>
> ---
>  Documentation/virtual/kvm/api.txt | 2 ++
>  arch/arm64/include/asm/kvm_host.h | 2 +-
>  arch/arm64/include/uapi/asm/kvm.h | 1 +
>  arch/arm64/kvm/reset.c            | 3 +++
>  include/kvm/arm_pmu.h             | 2 ++
>  include/uapi/linux/kvm.h          | 1 +
>  virt/kvm/arm/pmu.c                | 9 +++++++++
>  7 files changed, 19 insertions(+), 1 deletion(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com> 
