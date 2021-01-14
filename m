Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B441C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 16:58:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A0F123B1C
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 16:58:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A0F123B1C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB9494B203;
	Thu, 14 Jan 2021 11:58:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BDhojKwV-upj; Thu, 14 Jan 2021 11:58:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 947884B204;
	Thu, 14 Jan 2021 11:58:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37F4D4B204
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 11:58:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BWV6wtsQN3U1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 11:58:41 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAD1B4B203
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 11:58:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610643521;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JUsobyLQttNjQOv/bXY7/VpogIuR8SlRFnvnIc1/ovQ=;
 b=OCHrQB1c8JFTdXvwysL6/jKJth9+S//OBDu/NmQeFMxckh63WE4UllokXthl0BwYRamWyP
 aK40f/dnEP18/pJJ22VD0qAAwK7uzRJBA4Oui0DDYOEPvYv5S22rM4MBsfSupaKAjrSLr7
 DvpSxJ08g1ua6YT7cj0xvRQrqQc4i5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-kDmtCxkbOTycjfoyiKu1nw-1; Thu, 14 Jan 2021 11:58:38 -0500
X-MC-Unique: kDmtCxkbOTycjfoyiKu1nw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3FA69CC03;
 Thu, 14 Jan 2021 16:58:35 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4845D5D9E2;
 Thu, 14 Jan 2021 16:58:29 +0000 (UTC)
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
 <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
 <20201204095338.GA1912466@myrica>
 <2de03a797517452cbfeab022e12612b7@huawei.com>
 <0bf50dd6-ef3c-7aba-cbc1-1c2e17088470@redhat.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <d68b6269-ee99-9ed7-de30-867e4519d104@redhat.com>
Date: Thu, 14 Jan 2021 17:58:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <0bf50dd6-ef3c-7aba-cbc1-1c2e17088470@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: Xieyingtai <xieyingtai@huawei.com>, wangxingang <wangxingang5@huawei.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 qubingbing <qubingbing@hisilicon.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
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

Hi Shameer, Jean-Philippe,

On 12/4/20 11:23 AM, Auger Eric wrote:
> Hi Shameer, Jean-Philippe,
> 
> On 12/4/20 11:20 AM, Shameerali Kolothum Thodi wrote:
>> Hi Jean,
>>
>>> -----Original Message-----
>>> From: Jean-Philippe Brucker [mailto:jean-philippe@linaro.org]
>>> Sent: 04 December 2020 09:54
>>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
>>> Cc: Auger Eric <eric.auger@redhat.com>; wangxingang
>>> <wangxingang5@huawei.com>; Xieyingtai <xieyingtai@huawei.com>;
>>> kvm@vger.kernel.org; maz@kernel.org; joro@8bytes.org; will@kernel.org;
>>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>>> vivek.gautam@arm.com; alex.williamson@redhat.com;
>>> zhangfei.gao@linaro.org; robin.murphy@arm.com;
>>> kvmarm@lists.cs.columbia.edu; eric.auger.pro@gmail.com; Zengtao (B)
>>> <prime.zeng@hisilicon.com>; qubingbing <qubingbing@hisilicon.com>
>>> Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
>>> unmanaged ASIDs
>>>
>>> Hi Shameer,
>>>
>>> On Thu, Dec 03, 2020 at 06:42:57PM +0000, Shameerali Kolothum Thodi wrote:
>>>> Hi Jean/zhangfei,
>>>> Is it possible to have a branch with minimum required SVA/UACCE related
>>> patches
>>>> that are already public and can be a "stable" candidate for future respin of
>>> Eric's series?
>>>> Please share your thoughts.
>>>
>>> By "stable" you mean a fixed branch with the latest SVA/UACCE patches
>>> based on mainline? 
>>
>> Yes. 
>>
>>  The uacce-devel branches from
>>> https://github.com/Linaro/linux-kernel-uadk do provide this at the moment
>>> (they track the latest sva/zip-devel branch
>>> https://jpbrucker.net/git/linux/ which is roughly based on mainline.)
As I plan to respin shortly, please could you confirm the best branch to
rebase on still is that one (uacce-devel from the linux-kernel-uadk git
repo). Is it up to date? Commits seem to be quite old there.

Thanks

Eric
>>
>> Thanks. 
>>
>> Hi Eric,
>>
>> Could you please take a look at the above branches and see whether it make sense
>> to rebase on top of either of those?
>>
>> From vSVA point of view, it will be less rebase hassle if we can do that.
> 
> Sure. I will rebase on top of this ;-)
> 
> Thanks
> 
> Eric
>>
>> Thanks,
>> Shameer
>>
>>> Thanks,
>>> Jean
>>
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
