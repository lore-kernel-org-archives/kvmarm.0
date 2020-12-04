Return-Path: <SRS0=T6xz=FI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B5DC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 10:24:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ACA7022519
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 10:24:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACA7022519
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 236C74B1F5;
	Fri,  4 Dec 2020 05:24:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W+ansMRQbTIK; Fri,  4 Dec 2020 05:24:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10EE04B15F;
	Fri,  4 Dec 2020 05:24:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ED8C4B147
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 05:24:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FYdR+M7s26Gk for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Dec 2020 05:24:19 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61FA54B11F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 05:24:19 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1607077459;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2T15ek84GRYZBFIB7crwXKiwkKfTgxR0/uZEpJtiF7w=;
 b=bfIHGsbHkh52/70HynzLze12z7NeTwS2b5kRUVJ1m24iMymYuWhlyWetHmJifSs/aEZId3
 1uIMt4wfFXac2EDUyewo4PZu1AqOc4iplaFohYcu61Fehu194unNDP3XLXzObO9ZC8Al60
 DwUFxFt0UKMLn+V1325aoOukKXX2RXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-EHJ7jY99MrmUOFed-1HElg-1; Fri, 04 Dec 2020 05:24:13 -0500
X-MC-Unique: EHJ7jY99MrmUOFed-1HElg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E4C8180A087;
 Fri,  4 Dec 2020 10:24:11 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 59A2C620D7;
 Fri,  4 Dec 2020 10:23:59 +0000 (UTC)
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
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <0bf50dd6-ef3c-7aba-cbc1-1c2e17088470@redhat.com>
Date: Fri, 4 Dec 2020 11:23:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <2de03a797517452cbfeab022e12612b7@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: Xieyingtai <xieyingtai@huawei.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 wangxingang <wangxingang5@huawei.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 qubingbing <qubingbing@hisilicon.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>
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

On 12/4/20 11:20 AM, Shameerali Kolothum Thodi wrote:
> Hi Jean,
> 
>> -----Original Message-----
>> From: Jean-Philippe Brucker [mailto:jean-philippe@linaro.org]
>> Sent: 04 December 2020 09:54
>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
>> Cc: Auger Eric <eric.auger@redhat.com>; wangxingang
>> <wangxingang5@huawei.com>; Xieyingtai <xieyingtai@huawei.com>;
>> kvm@vger.kernel.org; maz@kernel.org; joro@8bytes.org; will@kernel.org;
>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>> vivek.gautam@arm.com; alex.williamson@redhat.com;
>> zhangfei.gao@linaro.org; robin.murphy@arm.com;
>> kvmarm@lists.cs.columbia.edu; eric.auger.pro@gmail.com; Zengtao (B)
>> <prime.zeng@hisilicon.com>; qubingbing <qubingbing@hisilicon.com>
>> Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
>> unmanaged ASIDs
>>
>> Hi Shameer,
>>
>> On Thu, Dec 03, 2020 at 06:42:57PM +0000, Shameerali Kolothum Thodi wrote:
>>> Hi Jean/zhangfei,
>>> Is it possible to have a branch with minimum required SVA/UACCE related
>> patches
>>> that are already public and can be a "stable" candidate for future respin of
>> Eric's series?
>>> Please share your thoughts.
>>
>> By "stable" you mean a fixed branch with the latest SVA/UACCE patches
>> based on mainline? 
> 
> Yes. 
> 
>  The uacce-devel branches from
>> https://github.com/Linaro/linux-kernel-uadk do provide this at the moment
>> (they track the latest sva/zip-devel branch
>> https://jpbrucker.net/git/linux/ which is roughly based on mainline.)
> 
> Thanks. 
> 
> Hi Eric,
> 
> Could you please take a look at the above branches and see whether it make sense
> to rebase on top of either of those?
> 
> From vSVA point of view, it will be less rebase hassle if we can do that.

Sure. I will rebase on top of this ;-)

Thanks

Eric
> 
> Thanks,
> Shameer
> 
>> Thanks,
>> Jean
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
