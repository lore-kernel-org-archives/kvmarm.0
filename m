Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29128C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Dec 2021 10:22:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B0504B0B4;
	Tue,  7 Dec 2021 05:22:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9nwixsJvBxdF; Tue,  7 Dec 2021 05:22:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2F944B0AC;
	Tue,  7 Dec 2021 05:22:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA5974B0A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 05:22:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iqBNdUF-GXY9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 05:22:36 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47BB14B099
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 05:22:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638872556;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vIblGTzXX40hR9szafjbMCGgx30k6YagvsBGLTnN0YI=;
 b=iFfOarRVgI8cZkql5FIvedwBHmGQMBUSQm9tIli7QHA3GTDnYyOOTAcPggbtGO6N0CaPt/
 dJ7YL7YuB9XJxy+YHrGbFo3ns/or5h3nh6kK8RffoKGog6dTlRvluxCkF3tQkCy20jbbLX
 m+kwVVmEh6RNmLw44vz1UHCrKvPIzDk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-Z9qAD1qXOnagPS-KXODOqg-1; Tue, 07 Dec 2021 05:22:33 -0500
X-MC-Unique: Z9qAD1qXOnagPS-KXODOqg-1
Received: by mail-wm1-f71.google.com with SMTP id
 bg20-20020a05600c3c9400b0033a9300b44bso1171479wmb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 02:22:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=vIblGTzXX40hR9szafjbMCGgx30k6YagvsBGLTnN0YI=;
 b=e+SY9Bh1d+tH+QIJ4kYNPIOgQRhbkq1hxCTpCqN1mkSJ5vcM3uR4986FFImlsm4O3N
 f0wcIGjTTnzHNIASJzdWKl+t62Ao9g3PVZeAyhcAnObSlMs1CDGgiwV4/XVq9rIQku/e
 cMhjYjDgsIieIQb6fH+dwIHdT3Drp3NP5l/Diz41YlU7VK09r0BERFds8iTf0D5OWLDz
 FVVlyGyZrUwvxHNbbT0GYTw8/OVYiUihgZ6bcMbHv9UXwP2S53DsdH+ng+V+y9SNp8sf
 U1qZ8kUKqzbzqbwmi9Tq0EDaR5KC6fA7D6/PPZjxBhahVfgcNSZEZSW/D946tYL7+kPp
 eu+Q==
X-Gm-Message-State: AOAM530x8UG1FPyCoeZvResf2ARVGhR9aX5oomyV/bFRyA547VaB3eiy
 GApBcvsBAWLfqU8PaRsVa2nxIA4otYxtUXe3kY231EOue4p7mX3YuxcaxnSOsQTsfhYdZOZNoOv
 PWP20BSNY4mGnH48+elx2iFaK
X-Received: by 2002:a05:600c:4f55:: with SMTP id
 m21mr5891544wmq.68.1638872552032; 
 Tue, 07 Dec 2021 02:22:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOgIcH/ywM872FWWEzo4wI3r37JDW61iH1Cfi/iZw3pSmHii9bhQ9WabrWC9ggWBBYhH9xLg==
X-Received: by 2002:a05:600c:4f55:: with SMTP id
 m21mr5891493wmq.68.1638872551786; 
 Tue, 07 Dec 2021 02:22:31 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id k8sm13945681wrn.91.2021.12.07.02.22.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 07 Dec 2021 02:22:31 -0800 (PST)
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To: Joerg Roedel <joro@8bytes.org>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
Date: Tue, 7 Dec 2021 11:22:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Ya3qd6mT/DpceSm8@8bytes.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, vivek.gautam@arm.com, vdumpa@nvidia.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com,
 jean-philippe@linaro.org, yi.l.liu@intel.com, ashok.raj@intel.com,
 maz@kernel.org, vsethi@nvidia.com, nicolinc@nvidia.com,
 zhangfei.gao@linaro.org, sumitg@nvidia.com, kevin.tian@intel.com,
 jacob.jun.pan@linux.intel.com, will@kernel.org, nicoleotsuka@gmail.com,
 alex.williamson@redhat.com, wangxingang5@huawei.com, chenxiang66@hisilicon.com,
 linux-kernel@vger.kernel.org, lushenming@huawei.com,
 iommu@lists.linux-foundation.org, robin.murphy@arm.com
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

Hi Joerg,

On 12/6/21 11:48 AM, Joerg Roedel wrote:
> On Wed, Oct 27, 2021 at 12:44:20PM +0200, Eric Auger wrote:
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
>> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> This Signed-of-by chain looks dubious, you are the author but the last
> one in the chain?
The 1st RFC in Aug 2018
(https://lists.cs.columbia.edu/pipermail/kvmarm/2018-August/032478.html)
said this was a generalization of Jacob's patch


  [PATCH v5 01/23] iommu: introduce bind_pasid_table API function


  https://lists.linuxfoundation.org/pipermail/iommu/2018-May/027647.html

So indeed Jacob should be the author. I guess the multiple rebases got
this eventually replaced at some point, which is not an excuse. Please
forgive me for that.
Now the original patch already had this list of SoB so I don't know if I
shall simplify it.


>
>> +int iommu_uapi_attach_pasid_table(struct iommu_domain *domain,
>> +				  void __user *uinfo)
>> +{
> [...]
>
>> +	if (pasid_table_data.format == IOMMU_PASID_FORMAT_SMMUV3 &&
>> +	    pasid_table_data.argsz <
>> +		offsetofend(struct iommu_pasid_table_config, vendor_data.smmuv3))
>> +		return -EINVAL;
> This check looks like it belongs in driver specific code.
Indeed, I will fix that in my next respin :-)

Thanks!

Eric
>
> Regards,
>
> 	Joerg
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
