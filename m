Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B07C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 06:25:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F17161159
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 06:25:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9F17161159
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BF5A4B0DF;
	Tue, 28 Sep 2021 02:25:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kpoKG4VSuC8T; Tue, 28 Sep 2021 02:25:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 078034B0FC;
	Tue, 28 Sep 2021 02:25:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CEDF4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 02:25:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MS2zVfY7Du7V for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 02:25:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEFAE4B0A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 02:25:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632810340;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9wq1dVPtAXDMCZC9S+u92KoCxHpT0A4H8ulsqFHsRII=;
 b=iYzpm3mCwn7BhzwGwrV3Xa1Cl9lIvXZLjLoRo4i4C5Qq3d8EwsXeHSTv2zAdEuFAVHliFF
 /7xDikWMziL3YkE0lKdEuz/D9hVDcrxCqRHpLhQNvqI4NO9uihVnZzYYYzwLsknQzRmaWK
 ygWPqrbrQpP6UFhYe3p5SvHp0Jzr3oA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-tLVHS_NfNtKPVXrwRx0NTw-1; Tue, 28 Sep 2021 02:25:37 -0400
X-MC-Unique: tLVHS_NfNtKPVXrwRx0NTw-1
Received: by mail-wr1-f70.google.com with SMTP id
 f7-20020a5d50c7000000b0015e288741a4so14718464wrt.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 23:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=9wq1dVPtAXDMCZC9S+u92KoCxHpT0A4H8ulsqFHsRII=;
 b=VLONYk0nam99W9tyKKrV65l0ycZDN5oceOET2VSlGwPmn/UzbeGQSsWjVrc0lwyv+R
 dQ7pdRKpqxB89hXgnfNp7wUDwWALG2kSFLYT17XJfaU7H1CG3TUls728wNulYjr+tR0N
 mG3wRHzXMswjjoXa6XeI5OusyP2Vf50eHFzQVLAjtEkAQmswmf8/wiSNArGQ+KaE9LDz
 ZCVyeGwY9ET9PxFzJqVI5MRTOmsn3PrYa/bXXnYGK8WTo5sdbpGNio2vYO7/aHFWZwZE
 uZBTDUpwoqFx3yMXtlGrgFAgYUdHJnIMk6YMl0jl+vsHjPQybYQMkbBPQocAUJhDlh30
 ajkQ==
X-Gm-Message-State: AOAM532NIRsKskDILkQ4IvUJyk49wQ8xgp0kYbqlPVajMXCF2cN+K89N
 THAfZ5JrnwvrjHYzQM8+RuwYN1k3TbBY4mWNtINhjvp3LlA2vX1Ra1UvYGBrJ309+7SrN/Cu6M4
 u9ikBaYtIk+Uc18T/axm6cEaG
X-Received: by 2002:a5d:64cf:: with SMTP id f15mr4278522wri.284.1632810336264; 
 Mon, 27 Sep 2021 23:25:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqSUu50iJ95OWE4UOFTINQsxuRK/ueiYpb9FlWfdG9FdcSiC/DUJ4GzrvCnuOU9QL4gLjBUA==
X-Received: by 2002:a5d:64cf:: with SMTP id f15mr4278495wri.284.1632810336011; 
 Mon, 27 Sep 2021 23:25:36 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id l10sm1663709wmq.42.2021.09.27.23.25.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 27 Sep 2021 23:25:35 -0700 (PDT)
Subject: Re: [PATCH v15 00/12] SMMUv3 Nested Stage Setup (IOMMU part)
To: Krishna Reddy <vdumpa@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "will@kernel.org" <will@kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "tn@semihalf.com" <tn@semihalf.com>,
 "zhukeqian1@huawei.com" <zhukeqian1@huawei.com>
References: <20210411111228.14386-1-eric.auger@redhat.com>
 <BY5PR12MB37640C26FEBC8AC6E3EDF40BB3A79@BY5PR12MB3764.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <c3fcc2fb-3173-af83-2b30-423c2c1ab83d@redhat.com>
Date: Tue, 28 Sep 2021 08:25:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB37640C26FEBC8AC6E3EDF40BB3A79@BY5PR12MB3764.namprd12.prod.outlook.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
 "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
 "lushenming@huawei.com" <lushenming@huawei.com>,
 "chenxiang66@hisilicon.com" <chenxiang66@hisilicon.com>,
 "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
 "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>, Vikram Sethi <vsethi@nvidia.com>,
 "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

On 9/27/21 11:17 PM, Krishna Reddy wrote:
> Hi Eric,
>> This is based on Jean-Philippe's
>> [PATCH v14 00/10] iommu: I/O page faults for SMMUv3
>> https://www.spinics.net/lists/arm-kernel/msg886518.html
>> (including the patches that were not pulled for 5.13)
>>
> Jean's patches have been merged to v5.14.
> Do you anticipate IOMMU/VFIO part patches getting into upstream kernel soon?

I am going to respin the smmu part rebased on v5.15. As for the VFIO
part, this needs to be totally redesigned based on /dev/iommu (see
[RFC 00/20] Introduce /dev/iommu for userspace I/O address space
management).

I will provide some updated kernel and qemu branches for testing purpose
only.

Thanks

Eric
>
> -KR
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
