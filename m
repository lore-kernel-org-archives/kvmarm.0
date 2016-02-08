From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 6/6] kvm: arm64: Add ACPI support for virt arch timer
Date: Mon, 8 Feb 2016 17:10:00 +0000
Message-ID: <56B8CBE8.7020305@arm.com>
References: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
 <1454358418-5157-7-git-send-email-fu.wei@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C57849A02
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 12:04:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x8og0JgTaf50 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2016 12:04:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02E59499DE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 12:04:22 -0500 (EST)
In-Reply-To: <1454358418-5157-7-git-send-email-fu.wei@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: fu.wei@linaro.org, rjw@rjwysocki.net, lenb@kernel.org, daniel.lezcano@linaro.org, tglx@linutronix.de, christoffer.dall@linaro.org, gleb@kernel.org, pbonzini@redhat.com, hanjun.guo@linaro.org, wei@redhat.com, a.spyridakis@virtualopensystems.com
Cc: leo.duran@amd.com, al.stone@linaro.org, kvm@vger.kernel.org, linaro-acpi@lists.linaro.org, jcm@redhat.com, richardcochran@gmail.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, davem@davemloft.net, linux-acpi@vger.kernel.org, wim@iguana.be, arnd@arndb.de, jeffrey.t.kirsher@intel.com, catalin.marinas@arm.com, graeme.gregory@linaro.org, robherring2@gmail.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/02/16 20:26, fu.wei@linaro.org wrote:
> From: Fu Wei <fu.wei@linaro.org>
> 
> This patch adds ACPI/GTDT support for virt arch timer
> using the API in GTDT driver.
> 
> Signed-off-by: Fu Wei <fu.wei@linaro.org>
> ---
>  virt/kvm/arm/arch_timer.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 0a279d3..4077347 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -385,6 +385,9 @@ static int kvm_timer_get_ppi(unsigned int *ppi)
>  {
>  	struct device_node *np;
>  	int ret = -EINVAL;
> +#ifdef CONFIG_ACPI_GTDT
> +	struct arch_timer_data data;
> +#endif
>  
>  	np = of_find_matching_node(NULL, arch_timer_of_match);
>  	if (!np) {
> @@ -397,6 +400,11 @@ static int kvm_timer_get_ppi(unsigned int *ppi)
>  	of_node_put(np);
>  
>  skip_of:
> +#ifdef CONFIG_ACPI_GTDT
> +	if (!*ppi && !gtdt_arch_timer_data_init(NULL, &data))
> +		*ppi = data.virt_ppi;
> +#endif
> +
>  	if (*ppi)
>  		return 0;
>  
> 

As I already pointed out in another thread hacking some KVM ACPI stuff,
this is the wrong approach.

We should have a *common* accessor in the timer code that exports the
relevant information, whatever the firmware "du jour" is.

See Julien's series, which seems to address the issue in a much more
convincing way:

https://lists.cs.columbia.edu/pipermail/kvmarm/2016-February/018531.html

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
