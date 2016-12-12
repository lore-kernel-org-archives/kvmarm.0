From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] ARM: dts: vexpress: Support GICC_DIR operations
Date: Mon, 12 Dec 2016 17:35:15 +0000
Message-ID: <9d9198a1-ba56-46e5-6226-89eb3825aac3@arm.com>
References: <20161210201351.25894-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E59C6402AF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2016 12:34:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e5yxszhC32H9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2016 12:34:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A097540296
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2016 12:34:13 -0500 (EST)
In-Reply-To: <20161210201351.25894-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org
Cc: lorenzo.pieralisi@arm.com, liviu.dudau@arm.com, linux@armlinux.org.uk, Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

[+Sudeep]

On 10/12/16 20:13, Christoffer Dall wrote:
> The GICv2 CPU interface registers span across 8K, not 4K as indicated in
> the DT.  Only the GICC_DIR register is located after the initial 4K
> boundary, leaving a functional system but without support for separately
> EOI'ing and deactivating interrupts.
> 
> After this change the system support split priority drop and interrupt
> deactivation.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
> index 0205c97..2e0cf39 100644
> --- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
> +++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
> @@ -126,7 +126,7 @@
>  		#address-cells = <0>;
>  		interrupt-controller;
>  		reg = <0 0x2c001000 0 0x1000>,
> -		      <0 0x2c002000 0 0x1000>,
> +		      <0 0x2c002000 0 0x2000>,
>  		      <0 0x2c004000 0 0x2000>,
>  		      <0 0x2c006000 0 0x2000>;
>  		interrupts = <1 9 0xf04>;
> 

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
