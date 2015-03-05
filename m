From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH] KVM: vgic: add virt-capable compatible strings
Date: Thu, 05 Mar 2015 16:42:58 +0100
Message-ID: <54F87982.5090203@redhat.com>
References: <1425566864-5509-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00E4847DB8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 10:37:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RkLOUg2VyCdQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2015 10:37:03 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC09647DB5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 10:37:02 -0500 (EST)
In-Reply-To: <1425566864-5509-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: Michal Simek <monstr@monstr.eu>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/05/15 15:47, Mark Rutland wrote:
> Several dts only list "arm,cortex-a7-gic" or "arm,gic-400" in their GIC
> compatible list, and while this is correct (and supported by the GIC
> driver), KVM will fail to detect that it can support these cases.
> 
> This patch adds the missing strings to the VGIC code. The of_device_id
> entries are padded to keep the probe fucntion data aligned.

Side note: there's a typo in "function".

Laszlo


> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Andre Przywara <andre.przywara@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Michal Simek <monstr@monstr.eu>
> ---
>  virt/kvm/arm/vgic.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 0cc6ab6..86cec79 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1865,8 +1865,10 @@ static struct notifier_block vgic_cpu_nb = {
>  };
>  
>  static const struct of_device_id vgic_ids[] = {
> -	{ .compatible = "arm,cortex-a15-gic", .data = vgic_v2_probe, },
> -	{ .compatible = "arm,gic-v3", .data = vgic_v3_probe, },
> +	{ .compatible = "arm,cortex-a15-gic",	.data = vgic_v2_probe, },
> +	{ .compatible = "arm,cortex-a7-gic",	.data = vgic_v2_probe, },
> +	{ .compatible = "arm,gic-400",		.data = vgic_v2_probe, },
> +	{ .compatible = "arm,gic-v3",		.data = vgic_v3_probe, },
>  	{},
>  };
>  
> 
