Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C0FC433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 03:31:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25A2B64F92
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 03:31:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25A2B64F92
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6991F4B2EB;
	Thu,  4 Feb 2021 22:31:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HI4vIJfr94On; Thu,  4 Feb 2021 22:31:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34F9B4B2F1;
	Thu,  4 Feb 2021 22:31:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44D884B2EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 22:31:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fuz1B5tQftdR for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 22:30:58 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDB624B2EA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 22:30:57 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DX19j3NZpzlGfQ;
 Fri,  5 Feb 2021 11:29:13 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 11:30:47 +0800
Subject: Re: [RFC] Use SMMU HTTU for DMA dirty page tracking
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, "Tian, Kevin"
 <kevin.tian@intel.com>
References: <b926ec0b-fe87-0792-c41d-acad56c656a4@huawei.com>
 <20200522171452.GC3453945@myrica>
 <e68c1158-8573-a477-42ce-48cee510c3ce@huawei.com>
 <MWHPR11MB16454475DA1FF417CEF5A32B8CB10@MWHPR11MB1645.namprd11.prod.outlook.com>
 <897a84ac-0a71-ace7-e05b-3cc9f0b05c28@huawei.com>
 <MWHPR11MB1645AA007D24F2D005794E5C8CB10@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200527091428.GB265288@myrica>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <c1c96639-2311-398a-15e0-2ff2d59fe320@huawei.com>
Date: Fri, 5 Feb 2021 11:30:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200527091428.GB265288@myrica>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "maz@kernel.org" <maz@kernel.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 Kirti Wankhede <kwankhede@nvidia.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "prime.zeng@hisilicon.com" <prime.zeng@hisilicon.com>, Will
 Deacon <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

Hi Jean and Kevin,

FYI, I have send out the SMMUv3 HTTU support for DMA dirty tracking[1] a week ago.

Thanks,
Keqian

[1] https://lore.kernel.org/linux-iommu/20210128151742.18840-1-zhukeqian1@huawei.com/

On 2020/5/27 17:14, Jean-Philippe Brucker wrote:
> On Wed, May 27, 2020 at 08:40:47AM +0000, Tian, Kevin wrote:
>>> From: Xiang Zheng <zhengxiang9@huawei.com>
>>> Sent: Wednesday, May 27, 2020 2:45 PM
>>>
>>>
>>> On 2020/5/27 11:27, Tian, Kevin wrote:
>>>>> From: Xiang Zheng
>>>>> Sent: Monday, May 25, 2020 7:34 PM
>>>>>
>>>>> [+cc Kirti, Yan, Alex]
>>>>>
>>>>> On 2020/5/23 1:14, Jean-Philippe Brucker wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On Tue, May 19, 2020 at 05:42:55PM +0800, Xiang Zheng wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> Is there any plan for enabling SMMU HTTU?
>>>>>>
>>>>>> Not outside of SVA, as far as I know.
>>>>>>
>>>>>
>>>>>>> I have seen the patch locates in the SVA series patch, which adds
>>>>>>> support for HTTU:
>>>>>>>     https://www.spinics.net/lists/arm-kernel/msg798694.html
>>>>>>>
>>>>>>> HTTU reduces the number of access faults on SMMU fault queue
>>>>>>> (permission faults also benifit from it).
>>>>>>>
>>>>>>> Besides reducing the faults, HTTU also helps to track dirty pages for
>>>>>>> device DMA. Is it feasible to utilize HTTU to get dirty pages on device
>>>>>>> DMA during VFIO live migration?
>>>>>>
>>>>>> As you know there is a VFIO interface for this under discussion:
>>>>>> https://lore.kernel.org/kvm/1589781397-28368-1-git-send-email-
>>>>> kwankhede@nvidia.com/
>>>>>> It doesn't implement an internal API to communicate with the IOMMU
>>>>> driver
>>>>>> about dirty pages.
>>>>
>>>> We plan to add such API later, e.g. to utilize A/D bit in VT-d 2nd-level
>>>> page tables (Rev 3.0).
>>>>
>>>
>>> Thank you, Kevin.
>>>
>>> When will you send this series patches? Maybe(Hope) we can also support
>>> hardware-based dirty pages tracking via common APIs based on your
>>> patches. :)
>>
>> Yan is working with Kirti on basic live migration support now. After that
>> part is done, we will start working on A/D bit support. Yes, common APIs
>> are definitely the goal here.
>>
>>>
>>>>>
>>>>>>
>>>>>>> If SMMU can track dirty pages, devices are not required to implement
>>>>>>> additional dirty pages tracking to support VFIO live migration.
>>>>>>
>>>>>> It seems feasible, though tracking it in the device might be more
>>>>>> efficient. I might have misunderstood but I think for live migration of
>>>>>> the Intel NIC they trap guest accesses to the device and introspect its
>>>>>> state to figure out which pages it is accessing.
>>>>
>>>> Does HTTU implement A/D-like mechanism in SMMU page tables, or just
>>>> report dirty pages in a log buffer? Either way tracking dirty pages in IOMMU
>>>> side is generic thus doesn't require device-specific tweak like in Intel NIC.
>>>>
>>>
>>> Currently HTTU just implement A/D-like mechanism in SMMU page tables.
>>> We certainly
>>> expect SMMU can also implement PML-like feature so that we can avoid
>>> walking the
>>> whole page table to get the dirty pages.
> 
> There is no reporting of dirty pages in log buffer. It might be possible
> to do software logging based on PRI or Stall, but that requires special
> support in the endpoint as well as the SMMU.
> 
>> Is there a link to HTTU introduction?
> 
> I don't know any gentle introduction, but there are sections D5.4.11
> "Hardware management of the Access flag and dirty state" in the ARM
> Architecture Reference Manual (DDI0487E), and section 3.13 "Translation
> table entries and Access/Dirty flags" in the SMMU specification
> (IHI0070C). HTTU stands for "Hardware Translation Table Update".
> 
> In short, when HTTU is enabled, the SMMU translation performs an atomic
> read-modify-write on the leaf translation table descriptor, setting some
> bits depending on the type of memory access. This can be enabled
> independently on both stage-1 and stage-2 tables (equivalent to your 1st
> and 2nd page tables levels, I think).
> 
> Thanks,
> Jean
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
