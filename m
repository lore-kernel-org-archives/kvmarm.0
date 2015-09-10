From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 3/4] irqchip: GIC: Convert to EOImode == 1
Date: Thu, 10 Sep 2015 11:55:34 +0100
Message-ID: <55F161A6.7070602@arm.com>
References: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com> <1440604845-28229-4-git-send-email-marc.zyngier@arm.com> <55F08731.3050402@citrix.com> <55F15353.2000800@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55F15353.2000800@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Grall <julien.grall@citrix.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Ian Campbell <ian.campbell@citrix.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/09/15 10:54, Marc Zyngier wrote:
> Hi Julian,
> 
> On 09/09/15 20:23, Julien Grall wrote:
>> Hi,
>>
>> I've been trying the latest linus/master (a794b4f), which include this
>> patch, as baremetal kernel on X-gene. This is failing on early boot
>> without much log.
>>
>> After bisecting the tree, I found the error coming from this patch.
>> While this patch is valid, it made me remembered that X-Gene (at least
>> the first version) as an odd GICv2.
>>
>> The GICC is divided in 2 area of 4K, each one aligned at a 64KB address.
>> This means that, the address of GICC_DIR won't be 0x1000 but 0x10000.
> 
> Not really. I already mentioned that one a while ago:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-March/332249.html
> 
> The first page of GIC is aliased over the first 64kB, and the second 
> page aliased over the second 64kB. So you get a consistent mapping if 
> you use (base + 0xF000) to address GICC. Also, the DT that's in 
> mainline is showing a 4kB CPU interface, which doesn't enable 
> EOImode==1. You must be using a firmware that's newer than mine, since 
> I'm perfectly able to boot my Mustang with these patches.
> 
>> We had the same issue on Xen when we did the first port of X-gene [1].
>> Although, we choose to add a quirk in Xen for this platform in order to
>> map contiguously in the virtual memory the 2 part of GICC.
>>
>> Note that, back then, Ian suggested to extend the bindings to support a
>> such platform [2]. AFAICT, there was no follow-up on it.
> 
> The main problem here is not to update the binding, but the fact that 
> you *cannot* update the DT on x-gene (the firmware will replace your 
> GIC node with what it thinks it is), and the APM guys can't be bothered 
> to fix their stuff.
> 
> In the meantime, can you give the following patch a shot? My Mustang is 
> wired to a 4kB CPU interface, so I'll need your help to test it.
> 
> Thanks,
> 
> 	M.
> 
> From f0f086a4462198a5a2ac840901d9b8fd23b25134 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <marc.zyngier@arm.com>
> Date: Thu, 10 Sep 2015 10:23:45 +0100
> Subject: [PATCH] irqchip/GIC: Add workaround for aliased GIC400
> 
> The GICv2 architecture mandates that the two 4kB GIC regions are
> contiguous, and on two separate physical pages. This doesn't work
> very well when PAGE_SIZE is 64kB.
> 
> A relatively common hack to work around this is to alias each 4kB
> region over its own 64kB page. Of course in this case, the base
> address you want to use is not really the begining of the region,
> but base + 60kB (so that you get a contiguous 8kB region over two
> distinct pages).
> 
> Normally, this would be describe in DT with a new property, but
> some HW is already out there, and the firmware makes sure that
> it will override whatever you put in the GIC node. Duh. And of course,
> said firmware source code is not available, despite being based
> on u-boot.
> 
> The workaround is to detect the case where the CPU interface size
> is set to 128kB, and verify the aliasing by checking that the ID
> register for GIC400 (which is the only GIC wired this way so far)
> is the same at base and base + 0xF000. In this case, we update
> the GIC base address and let it roll.
> 
> And if you feel slightly sick by looking at this, rest assured that
> I do too...
> 
> Reported-by: Julien Grall <julien.grall@citrix.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index e6b7ed5..b62f2b2 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -1119,12 +1119,50 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  #ifdef CONFIG_OF
>  static int gic_cnt __initdata;
>  
> +static bool gic_check_eoimode(struct device_node *node, void __iomem **base)
> +{
> +	struct resource cpuif_res;
> +
> +	of_address_to_resource(node, 1, &cpuif_res);
> +
> +	if (!is_hyp_mode_available())
> +		return false;
> +	if (resource_size(&cpuif_res) < SZ_8K)
> +		return false;
> +	if (resource_size(&cpuif_res) == SZ_128K) {
> +		u32 val;
> +
> +		/*
> +		 * Verify that we have a GIC400 aliased over the first
> +		 * 64kB by checking the GICC_IIDR register.
> +		 */
> +		val = readl_relaxed(*base + GIC_CPU_IDENT);
> +		if (val != 0x0202043B)
> +			return false;
> +
> +		val = readl_relaxed(*base + GIC_CPU_IDENT + 0xF000);
> +		if (val != 0x0202043B)
> +			return false;
> +
> +		/*
> +		 * Move the base up by 60kB, so that we have a 8kB
> +		 * contiguous region, which allows us to use GICC_DIR
> +		 * at its normal offset.
> +		 */
> +		*base += 0xF000;
> +		cpuif_res.start += 0xF000;
> +		pr_warn("GIC: Adjusting CPU interface base to %pa",
> +			&cpuif_res.start);
> +	}
> +
> +	return true;
> +}
> +
>  static int __init
>  gic_of_init(struct device_node *node, struct device_node *parent)
>  {
>  	void __iomem *cpu_base;
>  	void __iomem *dist_base;
> -	struct resource cpu_res;
>  	u32 percpu_offset;
>  	int irq;
>  
> @@ -1137,14 +1175,11 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>  	cpu_base = of_iomap(node, 1);
>  	WARN(!cpu_base, "unable to map gic cpu registers\n");
>  
> -	of_address_to_resource(node, 1, &cpu_res);
> -
>  	/*
>  	 * Disable split EOI/Deactivate if either HYP is not available
>  	 * or the CPU interface is too small.
>  	 */
> -	if (gic_cnt == 0 && (!is_hyp_mode_available() ||
> -			     resource_size(&cpu_res) < SZ_8K))
> +	if (gic_cnt == 0 && !gic_check_eoimode(node, &cpu_base))
>  		static_key_slow_dec(&supports_deactivate);
>  
>  	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
> 

Meh. Multiple revisions of GIC400. This patchlet on top of the above
should take care of it:

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index b62f2b2..a9ecb29 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1122,6 +1122,8 @@ static int gic_cnt __initdata;
 static bool gic_check_eoimode(struct device_node *node, void __iomem **base)
 {
 	struct resource cpuif_res;
+	u32 mask = 0xffff0fff;
+	u32 gic400_id = 0x0202043B;
 
 	of_address_to_resource(node, 1, &cpuif_res);
 
@@ -1137,11 +1139,11 @@ static bool gic_check_eoimode(struct device_node *node, void __iomem **base)
 		 * 64kB by checking the GICC_IIDR register.
 		 */
 		val = readl_relaxed(*base + GIC_CPU_IDENT);
-		if (val != 0x0202043B)
+		if ((val & mask) != gic400_id)
 			return false;
 
 		val = readl_relaxed(*base + GIC_CPU_IDENT + 0xF000);
-		if (val != 0x0202043B)
+		if ((val & mask) != gic400_id)
 			return false;
 
 		/*

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
