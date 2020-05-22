Return-Path: <SRS0=EL0d=7E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06E8C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 22 May 2020 17:15:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 557B820738
	for <kvmarm@archiver.kernel.org>; Fri, 22 May 2020 17:15:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r/uep0uu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 557B820738
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A166A4B26D;
	Fri, 22 May 2020 13:15:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SLOOE+FbfZhr; Fri, 22 May 2020 13:15:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90BB04B254;
	Fri, 22 May 2020 13:15:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E5F94B236
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 May 2020 13:15:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ScOVxQUrKJoo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 May 2020 13:15:06 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63AD34B230
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 May 2020 13:15:06 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id e1so10870944wrt.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 May 2020 10:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=09cuiPopIOJ5aAQOSJRwjVEJJoZ5ZgmUzhsRLgEZpY0=;
 b=r/uep0uuJQLYx20aHcrEbEpO3MMibL4LPe/jFDu4IN2wSG9yqX5PXP245RsG//+TO/
 Cocvp89LCLIPNNYlc6OykX8uBrz6LwI+ReTQvzxRSOMOey16m0EEisxn2tx5VunYYTPP
 1jbBQZtV83OTjzCQnsh+N53ProKGcWMS8TGEyyuf7fSKcAfptwIo5LRCJv+avtpmP8L4
 hw0ACBaOW0MFC/hnBrM5W8WeEfd600mle588Ys+xGLVDUUVJWDPhAxhlT3jyUMO8ckJo
 0HWO5mb4UdgvRrUcQTNZ8YcozyhK/90aBnlFS7/6rR61MKaYkOxfcqk8kWjHK77a+8sz
 MR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=09cuiPopIOJ5aAQOSJRwjVEJJoZ5ZgmUzhsRLgEZpY0=;
 b=h3zxR4ASXCZtMhsoBvpMmlLPj+aiYIFA3PjquDlvBgl0qo05u/zcWJQBmGr32dzm6s
 IVC6wo8y4w0x48ljHZqDUsO2JBzEclrfdug0kjcQMWByhfV89Cx5MA+kDZajxB1OTlfW
 X0Vae7vqeLiHLO3achhNew8VFI8VnNVz8myL0fdsPwtPsDkAtB8pMKQ2Z7SCCbZeJeJ3
 TXymud+dMN+HHI2t2QyNq7u/GwM4NNoH5/jV4OwpIYeoOtOt1hRvf1EO1L3KuclZ+txv
 CNx8Rji+DMfYGPrTpGMGK3zz28iw+k5e1sAp3BrOI5ViCh4Rp6JHo7g/ovNkC7M+U5B+
 MgOg==
X-Gm-Message-State: AOAM532gM2FpgWCdCqW3NeFYxRYbUOrJstrGF71YVF3upKe/PIaMsJvn
 R2moabfW5LuyuIusx9xc4N65fA==
X-Google-Smtp-Source: ABdhPJyxZ7kAMuA18QTw/krT1LaT+RyS8m/xIWMdni16UN7OYLdnQFqzGTPLW06K+87Eh9MIsX4pmw==
X-Received: by 2002:a5d:49c5:: with SMTP id t5mr4331584wrs.18.1590167705375;
 Fri, 22 May 2020 10:15:05 -0700 (PDT)
Received: from myrica ([2001:171b:226e:c200:c43b:ef78:d083:b355])
 by smtp.gmail.com with ESMTPSA id h74sm10394613wrh.76.2020.05.22.10.15.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 22 May 2020 10:15:04 -0700 (PDT)
Date: Fri, 22 May 2020 19:14:52 +0200
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Xiang Zheng <zhengxiang9@huawei.com>
Subject: Re: [RFC] Use SMMU HTTU for DMA dirty page tracking
Message-ID: <20200522171452.GC3453945@myrica>
References: <b926ec0b-fe87-0792-c41d-acad56c656a4@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b926ec0b-fe87-0792-c41d-acad56c656a4@huawei.com>
Cc: maz@kernel.org, iommu@lists.linux-foundation.org, wangzhou1@hisilicon.com,
 prime.zeng@hisilicon.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, May 19, 2020 at 05:42:55PM +0800, Xiang Zheng wrote:
> Hi all,
> 
> Is there any plan for enabling SMMU HTTU?

Not outside of SVA, as far as I know.

> I have seen the patch locates in the SVA series patch, which adds
> support for HTTU:
>     https://www.spinics.net/lists/arm-kernel/msg798694.html
> 
> HTTU reduces the number of access faults on SMMU fault queue
> (permission faults also benifit from it).
> 
> Besides reducing the faults, HTTU also helps to track dirty pages for
> device DMA. Is it feasible to utilize HTTU to get dirty pages on device
> DMA during VFIO live migration?

As you know there is a VFIO interface for this under discussion:
https://lore.kernel.org/kvm/1589781397-28368-1-git-send-email-kwankhede@nvidia.com/
It doesn't implement an internal API to communicate with the IOMMU driver
about dirty pages.

> If SMMU can track dirty pages, devices are not required to implement
> additional dirty pages tracking to support VFIO live migration.

It seems feasible, though tracking it in the device might be more
efficient. I might have misunderstood but I think for live migration of
the Intel NIC they trap guest accesses to the device and introspect its
state to figure out which pages it is accessing.

With HTTU I suppose (without much knowledge about live migration) that
you'd need several new interfaces to the IOMMU drivers:

* A way for VFIO to query HTTU support in the SMMU. There are some
  discussions about communicating more IOMMU capabilities through VFIO but
  no implementation yet. When HTTU isn't supported the DIRTY_PAGES bitmap
  would report all pages as they do now.

* VFIO_IOMMU_DIRTY_PAGES_FLAG_START/STOP would clear the dirty bit
  for all VFIO mappings (which is going to take some time). There is a
  walker in io-pgtable for iova_to_phys() which could be extended. I
  suppose it's also possible to atomically switch the HA and HD bits in
  context descriptors.

* VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP would query the dirty bit for all
  VFIO mappings.

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
