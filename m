Return-Path: <SRS0=mzoY=IG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8617C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 18:12:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A082652AC
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 18:12:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A082652AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6D894B6FB;
	Mon,  8 Mar 2021 13:12:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tkfm96Zw3dVu; Mon,  8 Mar 2021 13:12:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 690814B717;
	Mon,  8 Mar 2021 13:12:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5DE4B717
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 13:12:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XATD39+NljJ4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Mar 2021 13:12:45 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 443FC4B6FB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 13:12:45 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615227164;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=g3PfKhdiqdgUwSWYSwDNbfusFaETS5oAF78BcOmOgew=;
 b=KojPM+aCjtw7dZvKWAuFFjs6OQ+SE59GTh2hxHMYuVClQNO6oqblWOga7PCeU6LdlMWpM7
 uBvzMxmmW0h4lUGVhr/DNChmtpgw9fxjy5Ui19gZkatH2nr1e2HqimRq+43k1O/jlDWMpm
 meieghCrrWB4REOn6/z9Yh6qNYhzNEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-LHQEfOXhMzaPdazJnqfR1g-1; Mon, 08 Mar 2021 13:12:40 -0500
X-MC-Unique: LHQEfOXhMzaPdazJnqfR1g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1E3980432E;
 Mon,  8 Mar 2021 18:12:35 +0000 (UTC)
Received: from [10.36.112.254] (ovpn-112-254.ams2.redhat.com [10.36.112.254])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 29A7D5D756;
 Mon,  8 Mar 2021 18:12:22 +0000 (UTC)
Subject: Re: [PATCH v12 03/13] vfio: VFIO_IOMMU_SET_MSI_BINDING
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20210223210625.604517-1-eric.auger@redhat.com>
 <20210223210625.604517-4-eric.auger@redhat.com> <YEIL3qmcRfhUoRGt@myrica>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <0e23edb9-9923-edb9-ac3d-8fb52d2fe8c6@redhat.com>
Date: Mon, 8 Mar 2021 19:12:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEIL3qmcRfhUoRGt@myrica>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: kvm@vger.kernel.org, vivek.gautam@arm.com, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com, yi.l.liu@intel.com, wangxingang5@huawei.com,
 maz@kernel.org, joro@8bytes.org, vsethi@nvidia.com, zhangfei.gao@linaro.org,
 jacob.jun.pan@linux.intel.com, will@kernel.org, nicoleotsuka@gmail.com,
 alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
 lushenming@huawei.com, iommu@lists.linux-foundation.org, robin.murphy@arm.com
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

On 3/5/21 11:45 AM, Jean-Philippe Brucker wrote:
> Hi,
> 
> On Tue, Feb 23, 2021 at 10:06:15PM +0100, Eric Auger wrote:
>> This patch adds the VFIO_IOMMU_SET_MSI_BINDING ioctl which aim
>> to (un)register the guest MSI binding to the host. This latter
>> then can use those stage 1 bindings to build a nested stage
>> binding targeting the physical MSIs.
> 
> Now that RMR is in the IORT spec, could it be used for the nested MSI
> problem?  For virtio-iommu tables I was planning to do it like this:
> 
> MSI is mapped at stage-2 with an arbitrary IPA->doorbell PA. We report
> this IPA to userspace through iommu_groups/X/reserved_regions. No change
> there. Then to the guest we report a reserved identity mapping at IPA
> (using RMR, an equivalent DT binding, or probed RESV_MEM for
> virtio-iommu).

Is there any DT binding equivalent?

 The guest creates that mapping at stage-1, and that's it.
> Unless I overlooked something we'd only reuse existing infrastructure and
> avoid the SET_MSI_BINDING interface.

Yes at first glance I think this should work. The guest SMMU driver will
continue allocating IOVA for MSIs but I think that's not an issue as
they won't be used.

For the SMMU case this makes the guest behavior different from the
baremetal one though. Typically you will never get any S1 fault. Also
the S1 mapping is static and direct.

I will prototype this too.

Thanks

Eric
> 
> Thanks,
> Jean
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
