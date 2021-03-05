Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCE7C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 10:46:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EBB5D64FEE
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 10:46:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBB5D64FEE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 521524B422;
	Fri,  5 Mar 2021 05:46:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c3c7Zx7BYsmH; Fri,  5 Mar 2021 05:46:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 529524B54E;
	Fri,  5 Mar 2021 05:46:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4CDC4B414
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 05:46:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NHEFvRR5VCUw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 05:46:13 -0500 (EST)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C04D4B422
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 05:46:13 -0500 (EST)
Received: by mail-wm1-f42.google.com with SMTP id u187so1012666wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Mar 2021 02:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=QYcloRQYqoQYeneB9TUL5LWRoYdegubdAgTSoIagbwI=;
 b=l1f+UOwIgVlt828ar7VR0vnkFXh4cRc5C417MtipeTaqlFL9hi+QxQf/kRpJECja4M
 b1VgvXtLOV2KpkBB58JtxLb1r7x39cua/HRZI9XXxtgnnfrWNKNfRFRTEas45fO773zY
 7mJT+4G1Sc+QLV2KsJ35V7xN27sbUzT0B7bZHtGhOQSugEZHgtKaZ8IjZJJY8KECnj/e
 NDxYvkkIxMp0CEG5YQG2rPAaxqFREGuonfLmWbqP9a2as8Ty/JDljoFuQmk5w49uAPkM
 S2mRfInX6LS/JeefCGRhe0mbClkNBjicwLmnvj5wLTXA7t3Uwhc3PfpgO3P27y1rnfyj
 Tanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QYcloRQYqoQYeneB9TUL5LWRoYdegubdAgTSoIagbwI=;
 b=o8a7XjaAIp11JY6PSc+qDbyyZR8AVOqeb8nIvjVKZ9864Fgenqgcn1W1PZBTYxKwiG
 1GaGLzgG5Omw5Wt6PIsxuo0fZmCFyhXPZpoQjruB43ovYxzT9zq6txeHgT+syK2Uv6hT
 XsP3ujnrgkE3EsgFQ0kFJ5lhUnq9Z97alYDZfJ1U1Ttp3RTazkSHZ89X74Q2qKd59/eU
 wz3c4gqK20uamhEONIHfBsLa+oBG9X66TaFqEeSeBtTf1mGic+vbd9Y9VO1haS2ewqG7
 BvGrRSntrS7XHBrTurotxyBxckFke4WypzUq2HkYWmF/HViwOp3Qlp+gfkRXbYzm+GhC
 jLew==
X-Gm-Message-State: AOAM533Xk4F27GqZR3IFNI+Y2ucc/quyr58LQA2P3KHlZxbh3aarYq1d
 MQzYxZGM1ToSyBucVDXgl/SOoA==
X-Google-Smtp-Source: ABdhPJyPsHNdCZQ/LIRLnpXLb4jgGrGPiuq6+S8OtX5p5lHKSRBR7HyNChZTX5gDnxX/xPZN/4jXLA==
X-Received: by 2002:a1c:2049:: with SMTP id g70mr8213376wmg.7.1614941172536;
 Fri, 05 Mar 2021 02:46:12 -0800 (PST)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
 by smtp.gmail.com with ESMTPSA id o11sm4083278wrq.74.2021.03.05.02.46.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Mar 2021 02:46:12 -0800 (PST)
Date: Fri, 5 Mar 2021 11:45:50 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v12 03/13] vfio: VFIO_IOMMU_SET_MSI_BINDING
Message-ID: <YEIL3qmcRfhUoRGt@myrica>
References: <20210223210625.604517-1-eric.auger@redhat.com>
 <20210223210625.604517-4-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210223210625.604517-4-eric.auger@redhat.com>
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

Hi,

On Tue, Feb 23, 2021 at 10:06:15PM +0100, Eric Auger wrote:
> This patch adds the VFIO_IOMMU_SET_MSI_BINDING ioctl which aim
> to (un)register the guest MSI binding to the host. This latter
> then can use those stage 1 bindings to build a nested stage
> binding targeting the physical MSIs.

Now that RMR is in the IORT spec, could it be used for the nested MSI
problem?  For virtio-iommu tables I was planning to do it like this:

MSI is mapped at stage-2 with an arbitrary IPA->doorbell PA. We report
this IPA to userspace through iommu_groups/X/reserved_regions. No change
there. Then to the guest we report a reserved identity mapping at IPA
(using RMR, an equivalent DT binding, or probed RESV_MEM for
virtio-iommu). The guest creates that mapping at stage-1, and that's it.
Unless I overlooked something we'd only reuse existing infrastructure and
avoid the SET_MSI_BINDING interface.

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
