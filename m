From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [PATCHv2] arm: Fail on unknown subtest
Date: Fri, 2 Oct 2015 11:21:34 +0200
Message-ID: <20151002092134.GA3719@hawk.localdomain>
References: <20150929154752.GA21067@hawk.localdomain>
 <1443728785-10461-1-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443728785-10461-1-git-send-email-cov@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 01, 2015 at 03:46:25PM -0400, Christopher Covington wrote:
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arm/selftest.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arm/selftest.c b/arm/selftest.c
> index fc9ec60..f4a5030 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -376,6 +376,9 @@ int main(int argc, char **argv)
>  		cpumask_set_cpu(0, &smp_reported);
>  		while (!cpumask_full(&smp_reported))
>  			cpu_relax();
> +	} else {
> +		printf("Unknown subtest\n");
> +		abort();
>  	}
>  
>  	return report_summary();
> -- 
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
> 

Reviewed-by: Andrew Jones <drjones@redhat.com>

and applied to https://github.com/rhdrjones/kvm-unit-tests/tree/staging

Thanks,
drew
