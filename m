Return-Path: <SRS0=Kjqu=TI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9374BC04A6B
	for <kvmarm@archiver.kernel.org>; Wed,  8 May 2019 14:05:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 279B420675
	for <kvmarm@archiver.kernel.org>; Wed,  8 May 2019 14:05:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 279B420675
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F21C4A4A4;
	Wed,  8 May 2019 10:05:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C946rP-a-69H; Wed,  8 May 2019 10:05:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 186024A477;
	Wed,  8 May 2019 10:05:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEA4E4A477
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 May 2019 10:05:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xKCxmFM8oeFe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 May 2019 10:05:52 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 612404A36B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 May 2019 10:05:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75DEFA78;
 Wed,  8 May 2019 07:05:51 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9513D3F238;
 Wed,  8 May 2019 07:05:48 -0700 (PDT)
Subject: Re: [PATCH v7 11/23] iommu/arm-smmu-v3: Maintain a SID->device
 structure
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-12-eric.auger@redhat.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <e3b417b7-b69f-0121-fb72-6b6450e1b2f2@arm.com>
Date: Wed, 8 May 2019 15:05:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408121911.24103-12-eric.auger@redhat.com>
Content-Language: en-GB
Cc: kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com,
 marc.zyngier@arm.com
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

On 08/04/2019 13:18, Eric Auger wrote:
> From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> 
> When handling faults from the event or PRI queue, we need to find the
> struct device associated to a SID. Add a rb_tree to keep track of SIDs.

Out of curiosity, have you looked at whether an xarray might now be a 
more efficient option for this?

Robin.

> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> ---
>   drivers/iommu/arm-smmu-v3.c | 136 ++++++++++++++++++++++++++++++++++--
>   1 file changed, 132 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index ff998c967a0a..21d027695181 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -588,6 +588,16 @@ struct arm_smmu_device {
>   
>   	/* IOMMU core code handle */
>   	struct iommu_device		iommu;
> +
> +	struct rb_root			streams;
> +	struct mutex			streams_mutex;
> +
> +};
> +
> +struct arm_smmu_stream {
> +	u32				id;
> +	struct arm_smmu_master_data	*master;
> +	struct rb_node			node;
>   };
>   
>   /* SMMU private data for each master */
> @@ -597,6 +607,7 @@ struct arm_smmu_master_data {
>   
>   	struct arm_smmu_domain		*domain;
>   	struct list_head		list; /* domain->devices */
> +	struct arm_smmu_stream		*streams;
>   
>   	struct device			*dev;
>   };
> @@ -1243,6 +1254,32 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
>   	return 0;
>   }
>   
> +__maybe_unused
> +static struct arm_smmu_master_data *
> +arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
> +{
> +	struct rb_node *node;
> +	struct arm_smmu_stream *stream;
> +	struct arm_smmu_master_data *master = NULL;
> +
> +	mutex_lock(&smmu->streams_mutex);
> +	node = smmu->streams.rb_node;
> +	while (node) {
> +		stream = rb_entry(node, struct arm_smmu_stream, node);
> +		if (stream->id < sid) {
> +			node = node->rb_right;
> +		} else if (stream->id > sid) {
> +			node = node->rb_left;
> +		} else {
> +			master = stream->master;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&smmu->streams_mutex);
> +
> +	return master;
> +}
> +
>   /* IRQ and event handlers */
>   static irqreturn_t arm_smmu_evtq_thread(int irq, void *dev)
>   {
> @@ -1881,6 +1918,71 @@ static bool arm_smmu_sid_in_range(struct arm_smmu_device *smmu, u32 sid)
>   	return sid < limit;
>   }
>   
> +static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
> +				  struct arm_smmu_master_data *master)
> +{
> +	int i;
> +	int ret = 0;
> +	struct arm_smmu_stream *new_stream, *cur_stream;
> +	struct rb_node **new_node, *parent_node = NULL;
> +	struct iommu_fwspec *fwspec = master->dev->iommu_fwspec;
> +
> +	master->streams = kcalloc(fwspec->num_ids,
> +				  sizeof(struct arm_smmu_stream), GFP_KERNEL);
> +	if (!master->streams)
> +		return -ENOMEM;
> +
> +	mutex_lock(&smmu->streams_mutex);
> +	for (i = 0; i < fwspec->num_ids && !ret; i++) {
> +		new_stream = &master->streams[i];
> +		new_stream->id = fwspec->ids[i];
> +		new_stream->master = master;
> +
> +		new_node = &(smmu->streams.rb_node);
> +		while (*new_node) {
> +			cur_stream = rb_entry(*new_node, struct arm_smmu_stream,
> +					      node);
> +			parent_node = *new_node;
> +			if (cur_stream->id > new_stream->id) {
> +				new_node = &((*new_node)->rb_left);
> +			} else if (cur_stream->id < new_stream->id) {
> +				new_node = &((*new_node)->rb_right);
> +			} else {
> +				dev_warn(master->dev,
> +					 "stream %u already in tree\n",
> +					 cur_stream->id);
> +				ret = -EINVAL;
> +				break;
> +			}
> +		}
> +
> +		if (!ret) {
> +			rb_link_node(&new_stream->node, parent_node, new_node);
> +			rb_insert_color(&new_stream->node, &smmu->streams);
> +		}
> +	}
> +	mutex_unlock(&smmu->streams_mutex);
> +
> +	return ret;
> +}
> +
> +static void arm_smmu_remove_master(struct arm_smmu_device *smmu,
> +				   struct arm_smmu_master_data *master)
> +{
> +	int i;
> +	struct iommu_fwspec *fwspec = master->dev->iommu_fwspec;
> +
> +	if (!master->streams)
> +		return;
> +
> +	mutex_lock(&smmu->streams_mutex);
> +	for (i = 0; i < fwspec->num_ids; i++)
> +		rb_erase(&master->streams[i].node, &smmu->streams);
> +	mutex_unlock(&smmu->streams_mutex);
> +
> +	kfree(master->streams);
> +}
> +
>   static struct iommu_ops arm_smmu_ops;
>   
>   static int arm_smmu_add_device(struct device *dev)
> @@ -1929,13 +2031,35 @@ static int arm_smmu_add_device(struct device *dev)
>   		}
>   	}
>   
> +	ret = iommu_device_link(&smmu->iommu, dev);
> +	if (ret)
> +		goto err_free_master;
> +
> +	ret = arm_smmu_insert_master(smmu, master);
> +	if (ret)
> +		goto err_unlink;
> +
>   	group = iommu_group_get_for_dev(dev);
> -	if (!IS_ERR(group)) {
> -		iommu_group_put(group);
> -		iommu_device_link(&smmu->iommu, dev);
> +	if (IS_ERR(group)) {
> +		ret = PTR_ERR(group);
> +		goto err_remove_master;
>   	}
>   
> -	return PTR_ERR_OR_ZERO(group);
> +	iommu_group_put(group);
> +
> +	return 0;
> +
> +err_remove_master:
> +	arm_smmu_remove_master(smmu, master);
> +
> +err_unlink:
> +	iommu_device_unlink(&smmu->iommu, dev);
> +
> +err_free_master:
> +	kfree(master);
> +	fwspec->iommu_priv = NULL;
> +
> +	return ret;
>   }
>   
>   static void arm_smmu_remove_device(struct device *dev)
> @@ -1952,6 +2076,7 @@ static void arm_smmu_remove_device(struct device *dev)
>   	if (master && master->ste.assigned)
>   		arm_smmu_detach_dev(dev);
>   	iommu_group_remove_device(dev);
> +	arm_smmu_remove_master(smmu, master);
>   	iommu_device_unlink(&smmu->iommu, dev);
>   	kfree(master);
>   	iommu_fwspec_free(dev);
> @@ -2265,6 +2390,9 @@ static int arm_smmu_init_structures(struct arm_smmu_device *smmu)
>   {
>   	int ret;
>   
> +	mutex_init(&smmu->streams_mutex);
> +	smmu->streams = RB_ROOT;
> +
>   	ret = arm_smmu_init_queues(smmu);
>   	if (ret)
>   		return ret;
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
