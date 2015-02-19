From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: dts: Fix GIC reg sizes for APM X-Gene
Date: Thu, 19 Feb 2015 16:51:38 +0100
Message-ID: <20150219155138.GA24460@cbox>
References: <1422342206-4750-1-git-send-email-psawargaonkar@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47747460B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 10:45:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GAAbeg9XeeiX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Feb 2015 10:45:50 -0500 (EST)
Received: from mail-lb0-f179.google.com (mail-lb0-f179.google.com
 [209.85.217.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E27A7460AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 10:45:49 -0500 (EST)
Received: by lbvp9 with SMTP id p9so668561lbv.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 07:51:17 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1422342206-4750-1-git-send-email-psawargaonkar@apm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pranavkumar Sawargaonkar <psawargaonkar@apm.com>
Cc: devicetree@vger.kernel.org, arnd@arndb.de, Feng Kan <fkan@apm.com>, marc.zyngier@arm.com, jcm@redhat.com, patches@apm.com, Tushar Jagad <tjagad@apm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 27, 2015 at 12:33:26PM +0530, Pranavkumar Sawargaonkar wrote:
> In APM X-Gene, GIC register space is 64K aligned while the sizes mentioned
> in the dt are 4K aligned. This breaks KVM when kernel is built with 64K page
> size due to size alignment checking in vgic driver for VCPU Control and
> VCPU register.
> 
> This patch corrects the sizes to be inline with the hardware spec.
> 
> CC: linux-arm-kernel@lists.infradead.org
> CC: kvmarm@lists.cs.columbia.edu
> CC: arnd@arndb.de
> CC: marc.zyngier@arm.com
> CC: christoffer.dall@linaro.org
> CC: jcm@redhat.com
> Signed-off-by: Pranavkumar Sawargaonkar <psawargaonkar@apm.com>
> Signed-off-by: Tushar Jagad <tjagad@apm.com>
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>  arch/arm64/boot/dts/apm/apm-storm.dtsi |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/apm/apm-storm.dtsi b/arch/arm64/boot/dts/apm/apm-storm.dtsi
> index f1ad9c2..65f0e6d 100644
> --- a/arch/arm64/boot/dts/apm/apm-storm.dtsi
> +++ b/arch/arm64/boot/dts/apm/apm-storm.dtsi
> @@ -81,10 +81,10 @@
>  		compatible = "arm,cortex-a15-gic";
>  		#interrupt-cells = <3>;
>  		interrupt-controller;
> -		reg = <0x0 0x78010000 0x0 0x1000>,	/* GIC Dist */
> -		      <0x0 0x78020000 0x0 0x1000>,	/* GIC CPU */
> -		      <0x0 0x78040000 0x0 0x2000>,	/* GIC VCPU Control */
> -		      <0x0 0x78060000 0x0 0x2000>;	/* GIC VCPU */
> +		reg = <0x0 0x78010000 0x0 0x10000>,	/* GIC Dist */
> +		      <0x0 0x78020000 0x0 0x20000>,	/* GIC CPU */
> +		      <0x0 0x78040000 0x0 0x10000>,	/* GIC VCPU Control */
> +		      <0x0 0x78060000 0x0 0x20000>;	/* GIC VCPU */
>  		interrupts = <1 9 0xf04>;	/* GIC Maintenence IRQ */
>  	};
> 
> --
> 1.7.9.5
> 

This looks good to me and works with 4K and 64K pages on the mustang I
have at hand.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
