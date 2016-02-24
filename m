From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v13 01/20] ARM64: Move PMU register related defines to
 asm/perf_event.h
Date: Wed, 24 Feb 2016 17:52:48 +0000
Message-ID: <20160224175247.GE12471@arm.com>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
 <1456290520-10012-2-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456290520-10012-2-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 24, 2016 at 01:08:21PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> To use the ARMv8 PMU related register defines from the KVM code, we move
> the relevant definitions to asm/perf_event.h header file and rename them
> with prefix ARMV8_PMU_.
> 
> Signed-off-by: Anup Patel <anup.patel@linaro.org>
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/include/asm/perf_event.h | 35 +++++++++++++++++++
>  arch/arm64/kernel/perf_event.c      | 68 ++++++++++---------------------------
>  2 files changed, 52 insertions(+), 51 deletions(-)

Looks fine to me, but we're going to get some truly horrible conflicts
in -next.

I'm open to suggestions on the best way to handle this, but one way
would be:

  1. Duplicate all the #defines privately in KVM (queue via kvm tree)
  2. Rebase this patch onto my perf/updates branch [1] (queue via me)
  3. Patch at -rc1 dropping the #defines from (1) and moving to the new
     perf_event.h stuff

Thoughts?

Will

[1] git://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git perf/updates
