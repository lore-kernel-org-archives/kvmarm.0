Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2351DC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 13:16:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E48264EEE
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 13:16:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E48264EEE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7BF4B580;
	Fri, 19 Mar 2021 09:16:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VTIhB5kVrDrg; Fri, 19 Mar 2021 09:16:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBCA24B5F2;
	Fri, 19 Mar 2021 09:16:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5FAD4B5D8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 09:16:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zG2L+fbpmDSQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 09:16:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6D9C4B5D5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 09:16:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1616159768;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zB9UEU6BuHfafy+D8H0sW7LkYxmyna8jjh3ThNLf5Jc=;
 b=TZYb6mefrEEy+TV1TDLLhjjGyMOOcrPgS1j5zxvofaZihtjlnGFop6iURqO+dj8wM76dAg
 KHJ3M1W6w5BFZKZYhmawsQiAJ/4Z/B8AVeoINXUudfKG/B21dsVkuEzj7dxOgR+hM674lX
 Jy726/hra1FBp9YP2FDA2gYOMFTPJAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-t0J6TXHyOP2fdb4TiXXgXg-1; Fri, 19 Mar 2021 09:16:03 -0400
X-MC-Unique: t0J6TXHyOP2fdb4TiXXgXg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9F76800D53;
 Fri, 19 Mar 2021 13:15:58 +0000 (UTC)
Received: from [10.36.113.141] (ovpn-113-141.ams2.redhat.com [10.36.113.141])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D57396085A;
 Fri, 19 Mar 2021 13:15:49 +0000 (UTC)
Subject: Re: [PATCH v14 05/13] iommu/smmuv3: Implement
 attach/detach_pasid_table
To: Keqian Zhu <zhukeqian1@huawei.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
 alex.williamson@redhat.com, tn@semihalf.com
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-6-eric.auger@redhat.com>
 <5a22a597-0fba-edcc-bcf0-50d92346af08@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <31290c71-25d9-2b49-fb4d-7250ed9f70e7@redhat.com>
Date: Fri, 19 Mar 2021 14:15:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <5a22a597-0fba-edcc-bcf0-50d92346af08@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 wangxingang5@huawei.com, lushenming@huawei.com, nicoleotsuka@gmail.com,
 vivek.gautam@arm.com, yi.l.liu@intel.com, vsethi@nvidia.com,
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

On 3/2/21 9:35 AM, Keqian Zhu wrote:
> Hi Eric,
> 
> On 2021/2/24 4:56, Eric Auger wrote:
>> On attach_pasid_table() we program STE S1 related info set
>> by the guest into the actual physical STEs. At minimum
>> we need to program the context descriptor GPA and compute
>> whether the stage1 is translated/bypassed or aborted.
>>
>> On detach, the stage 1 config is unset and the abort flag is
>> unset.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
> [...]
> 
>> +
>> +		/*
>> +		 * we currently support a single CD so s1fmt and s1dss
>> +		 * fields are also ignored
>> +		 */
>> +		if (cfg->pasid_bits)
>> +			goto out;
>> +
>> +		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
> only the "cdtab_dma" field of "cdcfg" is set, we are not able to locate a specific cd using arm_smmu_get_cd_ptr().
> 
> Maybe we'd better use a specialized function to fill other fields of "cdcfg" or add a sanity check in arm_smmu_get_cd_ptr()
> to prevent calling it under nested mode?
> 
> As now we just call arm_smmu_get_cd_ptr() during finalise_s1(), no problem found. Just a suggestion ;-)

forgive me for the delay. yes I can indeed make sure that code is not
called in nested mode. Please could you detail why you would need to
call arm_smmu_get_cd_ptr()?

Thanks

Eric
> 
> Thanks,
> Keqian
> 
> 
>> +		smmu_domain->s1_cfg.set = true;
>> +		smmu_domain->abort = false;
>> +		break;
>> +	default:
>> +		goto out;
>> +	}
>> +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>> +	list_for_each_entry(master, &smmu_domain->devices, domain_head)
>> +		arm_smmu_install_ste_for_dev(master);
>> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>> +	ret = 0;
>> +out:
>> +	mutex_unlock(&smmu_domain->init_mutex);
>> +	return ret;
>> +}
>> +
>> +static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
>> +{
>> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>> +	struct arm_smmu_master *master;
>> +	unsigned long flags;
>> +
>> +	mutex_lock(&smmu_domain->init_mutex);
>> +
>> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
>> +		goto unlock;
>> +
>> +	smmu_domain->s1_cfg.set = false;
>> +	smmu_domain->abort = false;
>> +
>> +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>> +	list_for_each_entry(master, &smmu_domain->devices, domain_head)
>> +		arm_smmu_install_ste_for_dev(master);
>> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>> +
>> +unlock:
>> +	mutex_unlock(&smmu_domain->init_mutex);
>> +}
>> +
>>  static bool arm_smmu_dev_has_feature(struct device *dev,
>>  				     enum iommu_dev_features feat)
>>  {
>> @@ -2939,6 +3026,8 @@ static struct iommu_ops arm_smmu_ops = {
>>  	.of_xlate		= arm_smmu_of_xlate,
>>  	.get_resv_regions	= arm_smmu_get_resv_regions,
>>  	.put_resv_regions	= generic_iommu_put_resv_regions,
>> +	.attach_pasid_table	= arm_smmu_attach_pasid_table,
>> +	.detach_pasid_table	= arm_smmu_detach_pasid_table,
>>  	.dev_has_feat		= arm_smmu_dev_has_feature,
>>  	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
>>  	.dev_enable_feat	= arm_smmu_dev_enable_feature,
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
