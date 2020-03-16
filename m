Return-Path: <SRS0=WgPl=5B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F87AC2BB1D
	for <kvmarm@archiver.kernel.org>; Mon, 16 Mar 2020 18:14:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1500B2071C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Mar 2020 18:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdZXrh/9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1500B2071C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85C544B087;
	Mon, 16 Mar 2020 14:13:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jeV5XYOu2QlC; Mon, 16 Mar 2020 14:13:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E8224A4C0;
	Mon, 16 Mar 2020 14:13:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A60534A1B0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 14:13:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JVllE7EXmLkS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Mar 2020 14:13:55 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [216.205.24.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70B6B40217
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 14:13:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584382435;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pjAxZRDDan7ryXmWGRweJtzmrNZhvBPPuRNk/aD4e6E=;
 b=BdZXrh/9UtWxlQIBiWHA40w1f2/CHm6EwxCApVjKUQzf1PjNFjJwW1mW3XKm0FMpYDpmM2
 hAcb8CLQg4EnfqmmXXvIIQ2UChqf2LwNdLFkJW9VwGjLo//ieo87cPGQUscS+qeaSbDjbg
 6D8tRKkc3z1+cA7t46XDB5FNLQ+yadQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-wmGEeCJoMsaS6LlXN3ar2g-1; Mon, 16 Mar 2020 14:13:50 -0400
X-MC-Unique: wmGEeCJoMsaS6LlXN3ar2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4631E1945268;
 Mon, 16 Mar 2020 17:53:27 +0000 (UTC)
Received: from [10.36.118.12] (ovpn-118-12.ams2.redhat.com [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 342198FBF9;
 Mon, 16 Mar 2020 17:53:20 +0000 (UTC)
Subject: Re: [PATCH v5 09/23] irqchip/gic-v4.1: Add initial SGI configuration
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-10-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <4ccc36c5-1e0a-b4f6-b014-8691fdb50c84@redhat.com>
Date: Mon, 16 Mar 2020 18:53:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-10-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> The GICv4.1 ITS has yet another new command (VSGI) which allows
> a VPE-targeted SGI to be configured (or have its pending state
> cleared). Add support for this command and plumb it into the
> activate irqdomain callback so that it is ready to be used.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c   | 79 +++++++++++++++++++++++++++++-
>  include/linux/irqchip/arm-gic-v3.h |  3 +-
>  2 files changed, 80 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 112b452fcb40..e0db3f906f87 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -380,6 +380,15 @@ struct its_cmd_desc {
>  		struct {
>  			struct its_vpe *vpe;
>  		} its_invdb_cmd;
> +
> +		struct {
> +			struct its_vpe *vpe;
> +			u8 sgi;
> +			u8 priority;
> +			bool enable;
> +			bool group;
> +			bool clear;
> +		} its_vsgi_cmd;
>  	};
>  };
>  
> @@ -528,6 +537,31 @@ static void its_encode_db(struct its_cmd_block *cmd, bool db)
>  	its_mask_encode(&cmd->raw_cmd[2], db, 63, 63);
>  }
>  
> +static void its_encode_sgi_intid(struct its_cmd_block *cmd, u8 sgi)
> +{
> +	its_mask_encode(&cmd->raw_cmd[0], sgi, 35, 32);
> +}
> +
> +static void its_encode_sgi_priority(struct its_cmd_block *cmd, u8 prio)
> +{
> +	its_mask_encode(&cmd->raw_cmd[0], prio >> 4, 23, 20);
> +}
> +
> +static void its_encode_sgi_group(struct its_cmd_block *cmd, bool grp)
> +{
> +	its_mask_encode(&cmd->raw_cmd[0], grp, 10, 10);
> +}
> +
> +static void its_encode_sgi_clear(struct its_cmd_block *cmd, bool clr)
> +{
> +	its_mask_encode(&cmd->raw_cmd[0], clr, 9, 9);
> +}
> +
> +static void its_encode_sgi_enable(struct its_cmd_block *cmd, bool en)
> +{
> +	its_mask_encode(&cmd->raw_cmd[0], en, 8, 8);
> +}
> +
>  static inline void its_fixup_cmd(struct its_cmd_block *cmd)
>  {
>  	/* Let's fixup BE commands */
> @@ -893,6 +927,26 @@ static struct its_vpe *its_build_invdb_cmd(struct its_node *its,
>  	return valid_vpe(its, desc->its_invdb_cmd.vpe);
>  }
>  
> +static struct its_vpe *its_build_vsgi_cmd(struct its_node *its,
> +					  struct its_cmd_block *cmd,
> +					  struct its_cmd_desc *desc)
> +{
> +	if (WARN_ON(!is_v4_1(its)))
> +		return NULL;
> +
> +	its_encode_cmd(cmd, GITS_CMD_VSGI);
> +	its_encode_vpeid(cmd, desc->its_vsgi_cmd.vpe->vpe_id);
> +	its_encode_sgi_intid(cmd, desc->its_vsgi_cmd.sgi);
> +	its_encode_sgi_priority(cmd, desc->its_vsgi_cmd.priority);
> +	its_encode_sgi_group(cmd, desc->its_vsgi_cmd.group);
> +	its_encode_sgi_clear(cmd, desc->its_vsgi_cmd.clear);
> +	its_encode_sgi_enable(cmd, desc->its_vsgi_cmd.enable);
> +
> +	its_fixup_cmd(cmd);
> +
> +	return valid_vpe(its, desc->its_vsgi_cmd.vpe);
> +}
> +
>  static u64 its_cmd_ptr_to_offset(struct its_node *its,
>  				 struct its_cmd_block *ptr)
>  {
> @@ -3870,6 +3924,21 @@ static struct irq_chip its_vpe_4_1_irq_chip = {
>  	.irq_set_vcpu_affinity	= its_vpe_4_1_set_vcpu_affinity,
>  };
>  
> +static void its_configure_sgi(struct irq_data *d, bool clear)
> +{
> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +	struct its_cmd_desc desc;
> +
> +	desc.its_vsgi_cmd.vpe = vpe;
> +	desc.its_vsgi_cmd.sgi = d->hwirq;
> +	desc.its_vsgi_cmd.priority = vpe->sgi_config[d->hwirq].priority;
> +	desc.its_vsgi_cmd.enable = vpe->sgi_config[d->hwirq].enabled;
> +	desc.its_vsgi_cmd.group = vpe->sgi_config[d->hwirq].group;
> +	desc.its_vsgi_cmd.clear = clear;
> +
> +	its_send_single_vcommand(find_4_1_its(), its_build_vsgi_cmd, &desc);
I see we pick up the first 4.1 ITS with find_4_1_its(). Can it happen
that not all of them have a mapping for that vPEID and if so we should
rather use one that has this mapping?

The spec says:
The ITS controls must only be used on an ITS that has a mapping for that
vPEID.
Where multiple ITSs have a mapping for the vPEID, any ITS with a mapping
may be used.

> +}
> +
>  static int its_sgi_set_affinity(struct irq_data *d,
>  				const struct cpumask *mask_val,
>  				bool force)
> @@ -3915,13 +3984,21 @@ static void its_sgi_irq_domain_free(struct irq_domain *domain,
>  static int its_sgi_irq_domain_activate(struct irq_domain *domain,
>  				       struct irq_data *d, bool reserve)
>  {
> +	/* Write out the initial SGI configuration */
> +	its_configure_sgi(d, false);
>  	return 0;
>  }
>  
>  static void its_sgi_irq_domain_deactivate(struct irq_domain *domain,
>  					  struct irq_data *d)
>  {
> -	/* Nothing to do */
> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +
> +	/* First disable the SGI */
> +	vpe->sgi_config[d->hwirq].enabled = false;
> +	its_configure_sgi(d, false);
> +	/* Now clear the potential pending bit (yes, this is clunky) */
nit: Without carefuly reading the VSGI cmd notes, it is difficult to
understand why those 2 steps are needed: maybe replace this comment by
something like:
to change the config, clear must be set to false. Then clear is set and
this leaves the config unchanged. Both steps cannot be done concurrently.

"
> +	its_configure_sgi(d, true);
>  }
>  
>  static struct irq_domain_ops its_sgi_domain_ops = {
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index b28acfa71f82..fd3be49ac9a5 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -502,8 +502,9 @@
>  #define GITS_CMD_VMAPTI			GITS_CMD_GICv4(GITS_CMD_MAPTI)
>  #define GITS_CMD_VMOVI			GITS_CMD_GICv4(GITS_CMD_MOVI)
>  #define GITS_CMD_VSYNC			GITS_CMD_GICv4(GITS_CMD_SYNC)
> -/* VMOVP and INVDB are the odd ones, as they dont have a physical counterpart */
> +/* VMOVP, VSGI and INVDB are the odd ones, as they dont have a physical counterpart */
>  #define GITS_CMD_VMOVP			GITS_CMD_GICv4(2)
> +#define GITS_CMD_VSGI			GITS_CMD_GICv4(3)
>  #define GITS_CMD_INVDB			GITS_CMD_GICv4(0xe)
>  
>  /*
> 
Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
