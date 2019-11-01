Return-Path: <SRS0=K73f=YZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D4DCA9ECF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Nov 2019 10:58:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1351E2086D
	for <kvmarm@archiver.kernel.org>; Fri,  1 Nov 2019 10:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1351E2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56CE14ACF4;
	Fri,  1 Nov 2019 06:58:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 29JqUThjLodt; Fri,  1 Nov 2019 06:58:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36EA84ACE9;
	Fri,  1 Nov 2019 06:58:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D237B4ACE9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Nov 2019 06:58:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wc-lOf9W2YJz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Nov 2019 06:58:38 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F40EC4ACB0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Nov 2019 06:58:37 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id B9F4B2E8BE2247BC05AB;
 Fri,  1 Nov 2019 18:58:34 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 1 Nov 2019
 18:58:26 +0800
Subject: Re: [PATCH v2 12/36] irqchip/gic-v4.1: Implement the v4.1 flavour of
 VMAPP
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20191027144234.8395-1-maz@kernel.org>
 <20191027144234.8395-13-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d949743b-049b-cebf-1342-8034aa3a500c@huawei.com>
Date: Fri, 1 Nov 2019 18:58:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191027144234.8395-13-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Jayachandran C <jnair@marvell.com>, Thomas Gleixner <tglx@linutronix.de>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2019/10/27 22:42, Marc Zyngier wrote:
> The ITS VMAPP command gains some new fields with GICv4.1:
> - a default doorbell, which allows a single doorbell to be used for
>    all the VLPIs routed to a given VPE
> - a pointer to the configuration table (instead of having it in a register
>    that gets context switched)
> - a flag indicating whether this is the first map or the last unmap for
>    this particulat VPE

particular

> - a flag indicating whether the pending table is known to be zeroed, or not
> 
> Plumb in the new fields in the VMAPP builder, and add the map/unmap
> refcounting so that the ITS can do the right thing.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 60 +++++++++++++++++++++++++++---
>   include/linux/irqchip/arm-gic-v4.h | 18 +++++++--
>   2 files changed, 69 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 478d3678850c..220d490d516e 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -422,6 +422,27 @@ static void its_encode_vpt_size(struct its_cmd_block *cmd, u8 vpt_size)
>   	its_mask_encode(&cmd->raw_cmd[3], vpt_size, 4, 0);
>   }
>   
> +static void its_encode_vconf_addr(struct its_cmd_block *cmd, u64 vconf_pa)
> +{
> +	its_mask_encode(&cmd->raw_cmd[0], vconf_pa >> 16, 51, 16);
> +}
> +
> +static void its_encode_alloc(struct its_cmd_block *cmd, bool alloc)
> +{
> +	its_mask_encode(&cmd->raw_cmd[0], alloc, 8, 8);
> +}
> +
> +static void its_encode_ptz(struct its_cmd_block *cmd, bool ptz)
> +{
> +	its_mask_encode(&cmd->raw_cmd[0], ptz, 9, 9);
> +}
> +
> +static void its_encode_vmapp_default_db(struct its_cmd_block *cmd,
> +					u32 vpe_db_lpi)
> +{
> +	its_mask_encode(&cmd->raw_cmd[1], vpe_db_lpi, 31, 0);
> +}
> +
>   static inline void its_fixup_cmd(struct its_cmd_block *cmd)
>   {
>   	/* Let's fixup BE commands */
> @@ -605,19 +626,45 @@ static struct its_vpe *its_build_vmapp_cmd(struct its_node *its,
>   					   struct its_cmd_block *cmd,
>   					   struct its_cmd_desc *desc)
>   {
> -	unsigned long vpt_addr;
> +	unsigned long vpt_addr, vconf_addr;
>   	u64 target;
> -
> -	vpt_addr = virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->vpt_page));
> -	target = desc->its_vmapp_cmd.col->target_address + its->vlpi_redist_offset;
> +	bool alloc;
>   
>   	its_encode_cmd(cmd, GITS_CMD_VMAPP);
>   	its_encode_vpeid(cmd, desc->its_vmapp_cmd.vpe->vpe_id);
>   	its_encode_valid(cmd, desc->its_vmapp_cmd.valid);
> +
> +	if (!desc->its_vmapp_cmd.valid) {
> +		if (is_v4_1(its)) {
> +			alloc = !atomic_dec_return(&desc->its_vmapp_cmd.vpe->vmapp_count);
> +			its_encode_alloc(cmd, alloc);
> +		}
> +
> +		goto out;

(note to myself, the reason for "goto out" here is that in GICv4.1,
the remaining field are RES0 when V==0.)


Thanks,
Zenghui

> +	}
> +
> +	vpt_addr = virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->vpt_page));
> +	target = desc->its_vmapp_cmd.col->target_address + its->vlpi_redist_offset;
> +
>   	its_encode_target(cmd, target);
>   	its_encode_vpt_addr(cmd, vpt_addr);
>   	its_encode_vpt_size(cmd, LPI_NRBITS - 1);
>   
> +	if (!is_v4_1(its))
> +		goto out;
> +
> +	vconf_addr = virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->its_vm->vprop_page));
> +
> +	alloc = atomic_inc_and_test(&desc->its_vmapp_cmd.vpe->vmapp_count);
> +
> +	its_encode_alloc(cmd, alloc);
> +
> +	/* We can only signal PTZ when alloc==1. Why do we have two bits? */
> +	its_encode_ptz(cmd, alloc);
> +	its_encode_vconf_addr(cmd, vconf_addr);
> +	its_encode_vmapp_default_db(cmd, desc->its_vmapp_cmd.vpe->vpe_db_lpi);
> +
> +out:
>   	its_fixup_cmd(cmd);
>   
>   	return valid_vpe(its, desc->its_vmapp_cmd.vpe);
> @@ -3349,7 +3396,10 @@ static int its_vpe_init(struct its_vpe *vpe)
>   
>   	vpe->vpe_id = vpe_id;
>   	vpe->vpt_page = vpt_page;
> -	vpe->vpe_proxy_event = -1;
> +	if (gic_rdists->has_rvpeid)
> +		atomic_set(&vpe->vmapp_count, 0);
> +	else
> +		vpe->vpe_proxy_event = -1;
>   
>   	return 0;
>   }
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> index ab1396afe08a..6213ced6f199 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -37,8 +37,20 @@ struct its_vpe {
>   	irq_hw_number_t		vpe_db_lpi;
>   	/* VPE resident */
>   	bool			resident;
> -	/* VPE proxy mapping */
> -	int			vpe_proxy_event;
> +	union {
> +		/* GICv4.0 implementations */
> +		struct {
> +			/* VPE proxy mapping */
> +			int	vpe_proxy_event;
> +			/* Implementation Defined Area Invalid */
> +			bool	idai;
> +		};
> +		/* GICv4.1 implementations */
> +		struct {
> +			atomic_t vmapp_count;
> +		};
> +	};
> +
>   	/*
>   	 * This collection ID is used to indirect the target
>   	 * redistributor for this VPE. The ID itself isn't involved in
> @@ -47,8 +59,6 @@ struct its_vpe {
>   	u16			col_idx;
>   	/* Unique (system-wide) VPE identifier */
>   	u16			vpe_id;
> -	/* Implementation Defined Area Invalid */
> -	bool			idai;
>   	/* Pending VLPIs on schedule out? */
>   	bool			pending_last;
>   };
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
