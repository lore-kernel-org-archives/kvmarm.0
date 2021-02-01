Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD312C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 17:20:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3027364EA2
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 17:20:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3027364EA2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 689944B2FB;
	Mon,  1 Feb 2021 12:20:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FUlhwkm9wcMG; Mon,  1 Feb 2021 12:20:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 542694B39F;
	Mon,  1 Feb 2021 12:20:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 251B44B2FB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 12:20:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 37eKm27Z9DBK for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 12:20:49 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DAC04B2BE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 12:20:49 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612200049;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=lB7mBZJ0mzw9zDnoYSD9tBEDLyo8dn6HvaUbvp5AL4E=;
 b=FV9aPAK/WGJcJ6yOJ8M/mos7OiWrGEuP8Rt8jG3s8DKmS+734XfnjW5/EnwUC+1Gacgc5R
 O5tD/J6dIUNtiM4JIJ2SUo5m/b/lScl2erQiAwga+ZHEjZEeAIY+HFVYBxtRtPmp5/UZq0
 nhRQM2lh3av0J9x4o52eHLloV+O4ShA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-ASbusc4dOImfoaj0ARpUQw-1; Mon, 01 Feb 2021 12:20:44 -0500
X-MC-Unique: ASbusc4dOImfoaj0ARpUQw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A17001922048;
 Mon,  1 Feb 2021 17:20:35 +0000 (UTC)
Received: from [10.36.113.43] (ovpn-113-43.ams2.redhat.com [10.36.113.43])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DF93A74AA7;
 Mon,  1 Feb 2021 17:19:53 +0000 (UTC)
Subject: Re: [PATCH v13 03/15] iommu/arm-smmu-v3: Maintain a SID->device
 structure
To: Keqian Zhu <zhukeqian1@huawei.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
 alex.williamson@redhat.com
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-4-eric.auger@redhat.com>
 <a5cc1635-b69b-50a6-404a-5bf667296669@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <c457b450-8755-308e-7c7a-abe23b33d0d6@redhat.com>
Date: Mon, 1 Feb 2021 18:19:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a5cc1635-b69b-50a6-404a-5bf667296669@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, yi.l.liu@intel.com,
 zhangfei.gao@linaro.org
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

Hi Keqian,

On 2/1/21 1:26 PM, Keqian Zhu wrote:
> Hi Eric,
> 
> On 2020/11/18 19:21, Eric Auger wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> When handling faults from the event or PRI queue, we need to find the
>> struct device associated to a SID. Add a rb_tree to keep track of SIDs.
>>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> [...]
> 
>>  }
>>  
>> +static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
>> +				  struct arm_smmu_master *master)
>> +{
>> +	int i;
>> +	int ret = 0;
>> +	struct arm_smmu_stream *new_stream, *cur_stream;
>> +	struct rb_node **new_node, *parent_node = NULL;
>> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
>> +
>> +	master->streams = kcalloc(fwspec->num_ids,
>> +				  sizeof(struct arm_smmu_stream), GFP_KERNEL);
>> +	if (!master->streams)
>> +		return -ENOMEM;
>> +	master->num_streams = fwspec->num_ids;
> This is not roll-backed when fail.
> 
>> +
>> +	mutex_lock(&smmu->streams_mutex);
>> +	for (i = 0; i < fwspec->num_ids && !ret; i++) {
> Check ret at here, makes it hard to decide the start index of rollback.
> 
> If we fail at here, then start index is (i-2).
> If we fail in the loop, then start index is (i-1).
> 
>> +		u32 sid = fwspec->ids[i];
>> +
>> +		new_stream = &master->streams[i];
>> +		new_stream->id = sid;
>> +		new_stream->master = master;
>> +
>> +		/*
>> +		 * Check the SIDs are in range of the SMMU and our stream table
>> +		 */
>> +		if (!arm_smmu_sid_in_range(smmu, sid)) {
>> +			ret = -ERANGE;
>> +			break;
>> +		}
>> +
>> +		/* Ensure l2 strtab is initialised */
>> +		if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
>> +			ret = arm_smmu_init_l2_strtab(smmu, sid);
>> +			if (ret)
>> +				break;
>> +		}
>> +
>> +		/* Insert into SID tree */
>> +		new_node = &(smmu->streams.rb_node);
>> +		while (*new_node) {
>> +			cur_stream = rb_entry(*new_node, struct arm_smmu_stream,
>> +					      node);
>> +			parent_node = *new_node;
>> +			if (cur_stream->id > new_stream->id) {
>> +				new_node = &((*new_node)->rb_left);
>> +			} else if (cur_stream->id < new_stream->id) {
>> +				new_node = &((*new_node)->rb_right);
>> +			} else {
>> +				dev_warn(master->dev,
>> +					 "stream %u already in tree\n",
>> +					 cur_stream->id);
>> +				ret = -EINVAL;
>> +				break;
>> +			}
>> +		}
>> +
>> +		if (!ret) {
>> +			rb_link_node(&new_stream->node, parent_node, new_node);
>> +			rb_insert_color(&new_stream->node, &smmu->streams);
>> +		}
>> +	}
>> +
>> +	if (ret) {
>> +		for (; i > 0; i--)
> should be (i >= 0)?
> And the start index seems not correct.
> 
>> +			rb_erase(&master->streams[i].node, &smmu->streams);
>> +		kfree(master->streams);
>> +	}
>> +	mutex_unlock(&smmu->streams_mutex);
>> +
>> +	return ret;
>> +}
>> +
>> +static void arm_smmu_remove_master(struct arm_smmu_master *master)
>> +{
>> +	int i;
>> +	struct arm_smmu_device *smmu = master->smmu;
>> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
>> +
>> +	if (!smmu || !master->streams)
>> +		return;
>> +
>> +	mutex_lock(&smmu->streams_mutex);
>> +	for (i = 0; i < fwspec->num_ids; i++)
>> +		rb_erase(&master->streams[i].node, &smmu->streams);
>> +	mutex_unlock(&smmu->streams_mutex);
>> +
>> +	kfree(master->streams);
>> +}
>> +
>>  static struct iommu_ops arm_smmu_ops;
>>  
>>  static struct iommu_device *arm_smmu_probe_device(struct device *dev)
>>  {
>> -	int i, ret;
>> +	int ret;
>>  	struct arm_smmu_device *smmu;
>>  	struct arm_smmu_master *master;
>>  	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
>> @@ -2331,27 +2447,12 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
>>  
>>  	master->dev = dev;
>>  	master->smmu = smmu;
>> -	master->sids = fwspec->ids;
>> -	master->num_sids = fwspec->num_ids;
>>  	INIT_LIST_HEAD(&master->bonds);
>>  	dev_iommu_priv_set(dev, master);
>>  
>> -	/* Check the SIDs are in range of the SMMU and our stream table */
>> -	for (i = 0; i < master->num_sids; i++) {
>> -		u32 sid = master->sids[i];
>> -
>> -		if (!arm_smmu_sid_in_range(smmu, sid)) {
>> -			ret = -ERANGE;
>> -			goto err_free_master;
>> -		}
>> -
>> -		/* Ensure l2 strtab is initialised */
>> -		if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
>> -			ret = arm_smmu_init_l2_strtab(smmu, sid);
>> -			if (ret)
>> -				goto err_free_master;
>> -		}
>> -	}
>> +	ret = arm_smmu_insert_master(smmu, master);
>> +	if (ret)
>> +		goto err_free_master;
>>  
>>  	master->ssid_bits = min(smmu->ssid_bits, fwspec->num_pasid_bits);
>>  
>> @@ -2389,6 +2490,7 @@ static void arm_smmu_release_device(struct device *dev)
>>  	WARN_ON(arm_smmu_master_sva_enabled(master));
>>  	arm_smmu_detach_dev(master);
>>  	arm_smmu_disable_pasid(master);
>> +	arm_smmu_remove_master(master);
>>  	kfree(master);
> 
> Thanks,
> Keqian
> 
Thank you for the review. Jean will address this issues in his own
series and on my end I will rebase on this latter.

Best Regards

Eric


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
