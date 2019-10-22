Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EA0CA9EA0
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 12:44:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 467AC21783
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 12:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 467AC21783
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7DF84A9A1;
	Tue, 22 Oct 2019 08:44:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PrjNlfKGwfyr; Tue, 22 Oct 2019 08:44:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8196C4A98B;
	Tue, 22 Oct 2019 08:44:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D21B4A989
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 08:44:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1-e0l807gJXc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 08:44:51 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E143A4A960
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 08:44:50 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iMtWo-0006QL-Cu; Tue, 22 Oct 2019 14:44:46 +0200
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] irqchip/gic-v3-its: Use the exact ITSList for VMOVP
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Tue, 22 Oct 2019 13:44:46 +0100
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <1571742366-21008-1-git-send-email-yuzenghui@huawei.com>
References: <1571742366-21008-1-git-send-email-yuzenghui@huawei.com>
Message-ID: <34e9236f057b22d49f40146b21f81282@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, tglx@linutronix.de,
 jason@lakedaemon.net, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, wanghaibin.wang@huawei.com,
 jiayanlei@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: jason@lakedaemon.net, jiayanlei@huawei.com, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Zenghui,

On 2019-10-22 12:06, Zenghui Yu wrote:
> On a system without Single VMOVP support (say GITS_TYPER.VMOVP == 0),
> we will map vPEs only on ITSs that will actually control interrupts
> for the given VM.  And when moving a vPE, the VMOVP command will be
> issued only for those ITSs.
>
> But when issuing VMOVPs we seemed fail to present the exact ITSList
> to ITSs who are actually included in the synchronization operation.
> The its_list_map we're currently using includes all ITSs in the 
> system,
> even though some of them don't have the corrsponding vPE mapping at 
> all.
>
> Introduce get_its_list() to get the per-VM its_list_map, to indicate
> which ITSs have vPE mappings for the given VM, and use this map as
> the expected ITSList when building VMOVP.
>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>
> I haven't seen any broken with the current its_list_map, but behavior
> might differ between implementations.  Let's do what the spec expects
> us to do and try not to confuse the implementation.  Or is there any
> points I've missed?

No, I think you're right, and this is just an oversight on my part:
for example, we seem to do the right thing when handling a guest 
invall,
where we scan the ITS nodes and only emit a vinvall on an ITS that
has VLPI mapped in.

I don't think this is likely to cause any harm (after all, a DISCARD 
and
a VMOVP could race at any time), but it is certainly a performance gain
not to throw extra commands at unsuspecting ITSs. So thanks for 
spotting this.

A couple of comments below:

>
>  drivers/irqchip/irq-gic-v3-its.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c
> b/drivers/irqchip/irq-gic-v3-its.c
> index c81da27044bf..eebee588ea30 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -175,6 +175,19 @@ static DEFINE_IDA(its_vpeid_ida);
>  #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>  #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + 
> SZ_128K)
>
> +static inline u16 get_its_list(struct its_vm *vm)

Please drop the inline, the compiler will do it for you.

> +{
> +	struct its_node *its;
> +	unsigned long its_list;
> +
> +	list_for_each_entry(its, &its_nodes, entry) {

You probably want to skip non v4 ITSs, as they don't have a list_nr 
associated
to them (and you'd probably end-up hitting ITS #0 for no good reason).

> +		if (vm->vlpi_count[its->list_nr])
> +			set_bit(its->list_nr, &its_list);

We don't need to be atomic here, so __set_bit would be just as fine.

> +	}
> +
> +	return (u16)its_list;
> +}
> +
>  static struct its_collection *dev_event_to_col(struct its_device 
> *its_dev,
>  					       u32 event)
>  {
> @@ -982,7 +995,6 @@ static void its_send_vmovp(struct its_vpe *vpe)
>  	int col_id = vpe->col_idx;
>
>  	desc.its_vmovp_cmd.vpe = vpe;
> -	desc.its_vmovp_cmd.its_list = (u16)its_list_map;

Careful here, you're leaving the its_list field uninitialized, and it
really should be 0 when GITS_TYPER.VMOVP == 1 (i.e. when its_list_map
is zero). Just initialize the whole descriptor to zero.
>
>  	if (!its_list_map) {
>  		its = list_first_entry(&its_nodes, struct its_node, entry);
> @@ -1003,6 +1015,7 @@ static void its_send_vmovp(struct its_vpe *vpe)
>  	raw_spin_lock_irqsave(&vmovp_lock, flags);
>
>  	desc.its_vmovp_cmd.seq_num = vmovp_seq_num++;
> +	desc.its_vmovp_cmd.its_list = get_its_list(vpe->its_vm);
>
>  	/* Emit VMOVPs */
>  	list_for_each_entry(its, &its_nodes, entry) {

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
