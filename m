Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEDDC433E6
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 08:22:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5D9664FF5
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 08:22:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5D9664FF5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24FD14B5E5;
	Tue, 16 Mar 2021 04:22:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Maxc7NGzIW6t; Tue, 16 Mar 2021 04:22:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 203FF4B5D5;
	Tue, 16 Mar 2021 04:22:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 343DB4B4FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 04:22:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id egvWy+gjyxnc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 04:22:28 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 628E24B417
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 04:22:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615882948;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jgBW73IfZOFUYHFY6ABzyMEw2s2SPKAK0wW2bLnOaus=;
 b=FelNlBrixo0CiaHLtxrv5As8eEjguBKaU35YmQAmfUpt1+wHbHF8JWyz7AFDJe5G2yjELt
 W69ML380YnQ9J0o7BY/C0V/q4BgZqGm8zN8LU+6yWRz4h3VwcDEi3UD/uTdWFcf/xDTjpI
 zwuOqttYA3F7xU34cN49X105S0wDzEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-7iVAxc8DNEu8pHjCZoVk6w-1; Tue, 16 Mar 2021 04:22:23 -0400
X-MC-Unique: 7iVAxc8DNEu8pHjCZoVk6w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4F0993920;
 Tue, 16 Mar 2021 08:22:20 +0000 (UTC)
Received: from [10.36.112.254] (ovpn-112-254.ams2.redhat.com [10.36.112.254])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BB6BF690F0;
 Tue, 16 Mar 2021 08:22:12 +0000 (UTC)
Subject: Re: [PATCH v13 00/15] SMMUv3 Nested Stage Setup (IOMMU part)
To: Krishna Reddy <vdumpa@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "will@kernel.org" <will@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <BY5PR12MB3764285E7E8064B636132C65B36C9@BY5PR12MB3764.namprd12.prod.outlook.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <d9934ef7-3bf0-b004-3fe9-e0adbcae5c05@redhat.com>
Date: Tue, 16 Mar 2021 09:22:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB3764285E7E8064B636132C65B36C9@BY5PR12MB3764.namprd12.prod.outlook.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 Bryan Huntsman <bhuntsman@nvidia.com>, Yu-Huan Hsu <YHsu@nvidia.com>,
 Vikram Sethi <vsethi@nvidia.com>,
 "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
 Sachin Nikam <Snikam@nvidia.com>,
 "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>
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

Hi Krishna,
On 3/15/21 7:04 PM, Krishna Reddy wrote:
> Tested-by: Krishna Reddy <vdumpa@nvidia.com>
> 
>> 1) pass the guest stage 1 configuration
> 
> Validated Nested SMMUv3 translations for NVMe PCIe device from Guest VM along with patch series "v11 SMMUv3 Nested Stage Setup (VFIO part)" and QEMU patch series "vSMMUv3/pSMMUv3 2 stage VFIO integration" from v5.2.0-2stage-rfcv8. 
> NVMe PCIe device is functional with 2-stage translations and no issues observed.
Thank you very much for your testing efforts. For your info, there are
more recent kernel series:
[PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part) (Feb 23)
[PATCH v12 00/13] SMMUv3 Nested Stage Setup (VFIO part) (Feb 23)

working along with QEMU RFC
[RFC v8 00/28] vSMMUv3/pSMMUv3 2 stage VFIO integration (Feb 25)

If you have cycles to test with those, this would be higly appreciated.

Thanks

Eric
> 
> -KR
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
