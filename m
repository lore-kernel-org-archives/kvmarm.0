From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv3 2/3] arm: pmu: Check cycle
 count increases
Date: Tue, 6 Oct 2015 21:49:38 +0200
Message-ID: <20151006194938.GG9323@hawk.localdomain>
References: <5612EDA5.9010506@redhat.com>
 <1444153766-12532-1-git-send-email-cov@codeaurora.org>
 <1444153766-12532-3-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 825EC4117E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 15:47:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gjfx7hzyFetU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Oct 2015 15:47:49 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E76840FAB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 15:47:48 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1444153766-12532-3-git-send-email-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 06, 2015 at 01:49:25PM -0400, Christopher Covington wrote:
> Ensure that reads of the PMCCNTR_EL0 are monotonically increasing,
> even for the smallest delta of two subsequent reads.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arm/pmu.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 91a3688..589e605 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -33,6 +33,8 @@ struct pmu_data {
>  	};
>  };
>  
> +static const int samples = 10;

#define NR_SAMPLES 10

> +
>  /* As a simple sanity check on the PMCR_EL0, ensure the implementer field isn't
>   * null. Also print out a couple other interesting fields for diagnostic
>   * purposes. For example, as of fall 2015, QEMU TCG mode doesn't implement
> @@ -56,11 +58,38 @@ static bool check_pmcr(void)
>  	return false;
>  }
>  
> +/* Ensure that the cycle counter progresses between back-to-back reads.
> + */

style nit: your block quotes don't have opening wing (the preferred
kernel style - and, fwiw, my preference too...)

> +static bool check_cycles_increase(void)
> +{
> +	struct pmu_data pmcr;
> +
> +	pmcr.enable = 1;
> +	asm volatile("msr pmcr_el0, %0" : : "r" (pmcr));
> +
> +	for (int i = 0; i < samples; i++) {
> +		int a, b;
> +
> +		asm volatile(
> +			"mrs %[a], pmccntr_el0\n"
> +			"mrs %[b], pmccntr_el0\n"
> +		: [a] "=r" (a), [b] "=r" (b));
> +
> +		if (a >= b) {
> +			printf("Read %d then %d.\n", a, b);
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
>  int main(void)
>  {
>  	report_prefix_push("pmu");
>  
>  	report("Control register", check_pmcr());
> +	report("Monotonically increasing cycle count", check_cycles_increase());
>  
>  	return report_summary();
>  }
> -- 
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
> 
