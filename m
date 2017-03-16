From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH 16/33] irqchip/gic-v3-its: Add GICv4 ITS command
 definitions
Date: Thu, 16 Mar 2017 09:58:53 +0100
Message-ID: <01036799-4239-0c0c-4100-3a8e3afafa3e@redhat.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-17-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CE6F40BBB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 04:57:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XH4v7XiIVCJl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 04:57:20 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B94840B5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 04:57:20 -0400 (EDT)
In-Reply-To: <1484648454-21216-17-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 17/01/2017 11:20, Marc Zyngier wrote:
> Add the new GICv4 ITS command definitions, most of them, being
> defined in terms of their physical counterparts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  include/linux/irqchip/arm-gic-v3.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index dc7dcc6..1b3a070 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -338,6 +338,18 @@
>  #define GITS_CMD_SYNC			0x05
>  
>  /*
> + * GICv4 ITS specific commands
> + */
> +#define GITS_CMD_GICv4(x)		((x) | 0x20)
> +#define GITS_CMD_VINVALL		GITS_CMD_GICv4(GITS_CMD_INVALL)
> +#define GITS_CMD_VMAPP			GITS_CMD_GICv4(GITS_CMD_MAPC)
> +#define GITS_CMD_VMAPTI			GITS_CMD_GICv4(GITS_CMD_MAPTI)
> +#define GITS_CMD_VMOVI			GITS_CMD_GICv4(GITS_CMD_MOVI)
> +#define GITS_CMD_VSYNC			GITS_CMD_GICv4(GITS_CMD_SYNC)
> +/* VMOVP is the odd one, as it doesn't have a physical counterpart */
> +#define GITS_CMD_VMOVP			GITS_CMD_GICv4(2)
> +
> +/*
>   * ITS error numbers
>   */
>  #define E_ITS_MOVI_UNMAPPED_INTERRUPT		0x010107
> 
