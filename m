Return-Path: <SRS0=mEDx=HE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA22C433E6
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 07:20:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1A13C64ED9
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 07:20:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A13C64ED9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0194B178;
	Tue,  2 Feb 2021 02:20:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hV3aTniZuE9q; Tue,  2 Feb 2021 02:20:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A4B14B167;
	Tue,  2 Feb 2021 02:20:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA56F4B165
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 02:20:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U-AxpEkzwLXD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 02:20:39 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21AE34B12C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 02:20:39 -0500 (EST)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DVGQW4F44z162wf;
 Tue,  2 Feb 2021 15:19:15 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 15:20:32 +0800
Subject: Re: [PATCH v13 03/15] iommu/arm-smmu-v3: Maintain a SID->device
 structure
To: Auger Eric <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
 <joro@8bytes.org>, <maz@kernel.org>, <robin.murphy@arm.com>,
 <alex.williamson@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-4-eric.auger@redhat.com>
 <a5cc1635-b69b-50a6-404a-5bf667296669@huawei.com>
 <c457b450-8755-308e-7c7a-abe23b33d0d6@redhat.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <04fb111d-304e-2707-e5bb-e77b5ae93ed5@huawei.com>
Date: Tue, 2 Feb 2021 15:20:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <c457b450-8755-308e-7c7a-abe23b33d0d6@redhat.com>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
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

Hi Eric,

On 2021/2/2 1:19, Auger Eric wrote:
> Hi Keqian,
> 
> On 2/1/21 1:26 PM, Keqian Zhu wrote:
>> Hi Eric,
>>
>> On 2020/11/18 19:21, Eric Auger wrote:
>>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>>
>>> When handling faults from the event or PRI queue, we need to find the
>>> struct device associated to a SID. Add a rb_tree to keep track of SIDs.
>>>
>>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> [...]
>>
>>>  }
>>>  
>>> +static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
>>> +				  struct arm_smmu_master *master)
[...]

>>>  	kfree(master);
>>
>> Thanks,
>> Keqian
>>
> Thank you for the review. Jean will address this issues in his own
> series and on my end I will rebase on this latter.
> 
> Best Regards
> 
> Eric
>

Yeah, and hope this series can be accepted earlier ;-)

Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
