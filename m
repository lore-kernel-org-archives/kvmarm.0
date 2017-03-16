From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH 15/33] irqchip/gic-v4: Add management structure
 definitions
Date: Thu, 16 Mar 2017 09:58:46 +0100
Message-ID: <d5ebd612-96f0-943e-df01-28251c77c327@redhat.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-16-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3F6640B58
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 04:57:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AjfsKo+DrNvg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 04:57:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 931A340B40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 04:57:13 -0400 (EDT)
In-Reply-To: <1484648454-21216-16-git-send-email-marc.zyngier@arm.com>
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
> Add a bunch of GICv4-specific data structures that will get used in
> subsequent patches.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/linux/irqchip/arm-gic-v4.h | 92 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 92 insertions(+)
>  create mode 100644 include/linux/irqchip/arm-gic-v4.h
> 
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> new file mode 100644
> index 0000000..6e9c2b3
> --- /dev/null
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -0,0 +1,92 @@
> +/*
> + * Copyright (C) 2016 ARM Limited, All Rights Reserved.
> + * Author: Marc Zyngier <marc.zyngier@arm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __LINUX_IRQCHIP_ARM_GIC_V4_H
> +#define __LINUX_IRQCHIP_ARM_GIC_V4_H
> +
> +/* Embedded in kvm.arch */
> +struct its_vm {
> +	struct irq_domain	*domain;
> +	struct page		*vprop_page;
> +	irq_hw_number_t		db_lpi_base;
> +	unsigned long		*db_bitmap;
> +	int			nr_db_lpis;
> +};
> +
> +/* Embedded in kvm_vcpu.arch */
> +struct its_vpe {
> +	struct page 		*vpt_page;
> +	struct its_vm		*its_vm;
> +	irq_hw_number_t		vpe_db_lpi;
> +	u16			col_idx;
the role of the collection id remains obscure to me. Are collections
still used for VLPIs? On VMAPTI the vPE is directly provided whereas on
MAPTI we used the collection indirection to the actual PE, right? So
what is it used for?
> +	u16			vpe_id;
> +	bool			idai;
> +	bool			pending_last;
where is it used?
> +};
> +
> +/*
> + * struct its_vlpi: structure describing a VLPI. Only to be
> + * interpreted in the context of a physical interrupt it complements.
> + *
> + * @vintid:	Virtual LPI number
> + * @db_enabled:	Is the VPE doorbell to be generated?
> + * @vpe_idx:	Index (0-based) of the VPE in this VM. Not the vpe_id!
> + */
> +struct its_vlpi {
> +	u32			vintid;
> +	bool			db_enabled;
> +	u16			vpe_idx;
> +};
> +
> +/*
> + * struct its_vlpi_map: structure describing the mappings of all vlpis
> + * for a single device. To be used as the vcpu_info passed to
> + * irq_set_vcpu_affinity().
> + *
> + * @vpes: Array of struct its_vpe, describing the GICv4 view of the
> + * 	  vpus.
> + * @vlpis: Array of struct vlpi, each one matching one the
> + *	   corresponding LPI
s/one the/a/?
> + * @nr_vpes: Size of the @vpes array
> + * @nr_vlpis: Size of the @vlpis array
> + */
> +struct its_vlpi_map {
> +	/* nr_vpes  */
to be removed?
> +	struct its_vpe		**vpes;
> +	struct its_vlpi		*vlpis;
> +	int			nr_vpes;
> +	int			nr_vlpis;
> +};
> +
> +enum its_cmd_type {
> +	MAP_VLPI,
> +	UNMAP_VLPI,
> +	PROP_UPDATE_VLPI,
> +	SCHEDULE_VPE,
> +	DESCHEDULE_VPE,
> +	INVALL_VPE,
> +};

its_vcpu_info_cmd_type? At the first reading I mixed that with GITS_CMD_*

Thanks

Eric


> +
> +struct its_cmd_info {
> +	enum its_cmd_type		cmd_type;
> +	union {
> +		struct its_vlpi_map	*map;
> +		u8			config;
> +	};
> +};
> +
> +#endif
> 
