Return-Path: <SRS0=mEDx=HE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90A6C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 06:40:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE01A64EE1
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 06:40:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE01A64EE1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FE3C4B169;
	Tue,  2 Feb 2021 01:40:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hfosVtgTyKgR; Tue,  2 Feb 2021 01:40:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FE474B16E;
	Tue,  2 Feb 2021 01:40:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1064B4B159
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 01:40:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oh2snmwdzjqm for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 01:40:07 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF98A4B0C8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 01:40:06 -0500 (EST)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DVFWK6sbBzlFB2;
 Tue,  2 Feb 2021 14:38:21 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 14:39:54 +0800
Subject: Re: [PATCH v13 03/15] iommu/arm-smmu-v3: Maintain a SID->device
 structure
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, Eric Auger
 <eric.auger@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-4-eric.auger@redhat.com>
 <a5cc1635-b69b-50a6-404a-5bf667296669@huawei.com> <YBgbESEyReLV124Z@myrica>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <e579b8d7-1e8e-965f-965c-00efdf604eef@huawei.com>
Date: Tue, 2 Feb 2021 14:39:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YBgbESEyReLV124Z@myrica>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: jacob.jun.pan@linux.intel.com, alex.williamson@redhat.com,
 kvm@vger.kernel.org, maz@kernel.org, joro@8bytes.org,
 linux-kernel@vger.kernel.org, nicoleotsuka@gmail.com, vivek.gautam@arm.com,
 iommu@lists.linux-foundation.org, yi.l.liu@intel.com, zhangfei.gao@linaro.org,
 robin.murphy@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

Hi Jean,

On 2021/2/1 23:15, Jean-Philippe Brucker wrote:
> On Mon, Feb 01, 2021 at 08:26:41PM +0800, Keqian Zhu wrote:
>>> +static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
>>> +				  struct arm_smmu_master *master)
>>> +{
>>> +	int i;
>>> +	int ret = 0;
>>> +	struct arm_smmu_stream *new_stream, *cur_stream;
>>> +	struct rb_node **new_node, *parent_node = NULL;
>>> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
>>> +
>>> +	master->streams = kcalloc(fwspec->num_ids,
>>> +				  sizeof(struct arm_smmu_stream), GFP_KERNEL);
>>> +	if (!master->streams)
>>> +		return -ENOMEM;
>>> +	master->num_streams = fwspec->num_ids;
>> This is not roll-backed when fail.
> 
> No need, the caller frees master
OK.

> 
>>> +
>>> +	mutex_lock(&smmu->streams_mutex);
>>> +	for (i = 0; i < fwspec->num_ids && !ret; i++) {
>> Check ret at here, makes it hard to decide the start index of rollback.
>>
>> If we fail at here, then start index is (i-2).
>> If we fail in the loop, then start index is (i-1).
>>
> [...]
>>> +	if (ret) {
>>> +		for (; i > 0; i--)
>> should be (i >= 0)?
>> And the start index seems not correct.
> 
> Indeed, this whole bit is wrong. I'll fix it while resending the IOPF
> series.
> 
> Thanks,
> Jean
OK, I am glad it helps.

Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
