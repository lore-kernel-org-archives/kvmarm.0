From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 21/21] arm64: Panic when VHE and non VHE CPUs coexist
Date: Tue, 26 Jan 2016 14:25:43 +0000
Message-ID: <56A781E7.2050408@arm.com>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-22-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDA49409A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 09:20:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id erhBYL8z+s2g for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2016 09:20:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F559407A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 09:20:51 -0500 (EST)
In-Reply-To: <1453737235-16522-22-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 25/01/16 15:53, Marc Zyngier wrote:
> Having both VHE and non-VHE capable CPUs in the same system
> is likely to be a recipe for disaster.


> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index b1adc51..bc7650a 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -113,6 +113,9 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
>   			pr_crit("CPU%u: failed to come online\n", cpu);
>   			ret = -EIO;
>   		}
> +
> +		if (is_kernel_mode_mismatched())
> +			panic("CPU%u: incompatible execution level", cpu);


fyi,

I have a series which tries to perform some checks for early CPU features,
like this at [1] and adds support for early CPU boot failures, passing the error
status back to the master. May be we could move this check there(once it settles),
and fail the CPU boot with CPU_PANIC_KERNEL status.


[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-January/401727.html

Thanks
Suzuki
