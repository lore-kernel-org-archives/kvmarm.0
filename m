Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB28DC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 09:14:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E3672084C
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 09:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cMob0knk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E3672084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD08F4B207;
	Wed, 27 May 2020 05:14:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FdaqgHZrUOQf; Wed, 27 May 2020 05:14:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CCE24B1FC;
	Wed, 27 May 2020 05:14:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F56B4B1FC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 05:14:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tl8tTLT2ber5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 05:14:40 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AD3F4B1E8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 05:14:40 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id u188so2302824wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 02:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ERVcxFTM0vT/1MH9e0iwQ2bGR9XL129932mJIGULC34=;
 b=cMob0knkFSJDBlUwLV6UPNqIun4MapJpUgHYb9tboeOz36yVvhh9l2hDsgB54ivPJO
 yiCC30cVW3EKTZ3OO3AfHqU8x+VtFkIIr0R9fGSd418KPIu5PXD3MofWwt9Cn2ZLKNWJ
 WbqhPncsVCI9jaz/XYl8TQfUkBhZcJJIY+1dRZnbr6+8xGUCHKX6T3hTbccnFO0xr8m3
 3EGoD8UDVloV9br85tJzoOvF0n7pBVf6BYmpEDvTfr4K+VpGOi5q5unNylupXEFoRhUj
 VLg7JlpiPYNFEZAuzR0Ht67wXC9aZNcjXjxPiAMlvjYvrPxmhzj07ZCy89z8WzMRBcry
 p1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ERVcxFTM0vT/1MH9e0iwQ2bGR9XL129932mJIGULC34=;
 b=KKD7ZrG54jxz7K+vDdlqYi8jBqd1nF5V2M3k158MOIDCWMVn0CYq/bEIgckxozqVSO
 awOPmnO+eCCLlXAmZwHMu81QKPUUT5+a2iRmqgfOwWosifsENRVRhokJbGn/2O5T68ws
 HsHjASnKtVcbIDgUTuPtj9Z1uMyER8cE0rdBuuGVT7qKMTTN0IYD6H9UZG0kYhbq0P9I
 7uzN370hIGnv8Xe0Qyc+zNtzVgpe9CbUdtWsTcJNuVqMUuFKSEXJVmWZJ0XPpiww9boH
 O6YRwxQf2TGhnJtPPgdGEeREH/d0iHC9nCfIZECbFDEIppRa0waLWjxFNIbMgubp1NAb
 zbAA==
X-Gm-Message-State: AOAM530gcV9dXzQXQ+IstjBasfwSiPJHqK6dKLDEVfOlOXIcmjt9fVva
 Y9ysGdTUI6BB+Z5wxKkHWdvO5A==
X-Google-Smtp-Source: ABdhPJwwb+zSrIRkBY0A0SsuRcJOHMxMcWGLJGJHnizfqmIO4FBg2RexGKWtdOVRtUHcowLTG/s5zA==
X-Received: by 2002:a7b:c5d7:: with SMTP id n23mr3582615wmk.185.1590570879183; 
 Wed, 27 May 2020 02:14:39 -0700 (PDT)
Received: from myrica ([2001:171b:226e:c200:c43b:ef78:d083:b355])
 by smtp.gmail.com with ESMTPSA id r5sm2369132wrq.0.2020.05.27.02.14.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 May 2020 02:14:38 -0700 (PDT)
Date: Wed, 27 May 2020 11:14:28 +0200
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RFC] Use SMMU HTTU for DMA dirty page tracking
Message-ID: <20200527091428.GB265288@myrica>
References: <b926ec0b-fe87-0792-c41d-acad56c656a4@huawei.com>
 <20200522171452.GC3453945@myrica>
 <e68c1158-8573-a477-42ce-48cee510c3ce@huawei.com>
 <MWHPR11MB16454475DA1FF417CEF5A32B8CB10@MWHPR11MB1645.namprd11.prod.outlook.com>
 <897a84ac-0a71-ace7-e05b-3cc9f0b05c28@huawei.com>
 <MWHPR11MB1645AA007D24F2D005794E5C8CB10@MWHPR11MB1645.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645AA007D24F2D005794E5C8CB10@MWHPR11MB1645.namprd11.prod.outlook.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "maz@kernel.org" <maz@kernel.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "prime.zeng@hisilicon.com" <prime.zeng@hisilicon.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, Will Deacon <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

On Wed, May 27, 2020 at 08:40:47AM +0000, Tian, Kevin wrote:
> > From: Xiang Zheng <zhengxiang9@huawei.com>
> > Sent: Wednesday, May 27, 2020 2:45 PM
> > 
> > 
> > On 2020/5/27 11:27, Tian, Kevin wrote:
> > >> From: Xiang Zheng
> > >> Sent: Monday, May 25, 2020 7:34 PM
> > >>
> > >> [+cc Kirti, Yan, Alex]
> > >>
> > >> On 2020/5/23 1:14, Jean-Philippe Brucker wrote:
> > >>> Hi,
> > >>>
> > >>> On Tue, May 19, 2020 at 05:42:55PM +0800, Xiang Zheng wrote:
> > >>>> Hi all,
> > >>>>
> > >>>> Is there any plan for enabling SMMU HTTU?
> > >>>
> > >>> Not outside of SVA, as far as I know.
> > >>>
> > >>
> > >>>> I have seen the patch locates in the SVA series patch, which adds
> > >>>> support for HTTU:
> > >>>>     https://www.spinics.net/lists/arm-kernel/msg798694.html
> > >>>>
> > >>>> HTTU reduces the number of access faults on SMMU fault queue
> > >>>> (permission faults also benifit from it).
> > >>>>
> > >>>> Besides reducing the faults, HTTU also helps to track dirty pages for
> > >>>> device DMA. Is it feasible to utilize HTTU to get dirty pages on device
> > >>>> DMA during VFIO live migration?
> > >>>
> > >>> As you know there is a VFIO interface for this under discussion:
> > >>> https://lore.kernel.org/kvm/1589781397-28368-1-git-send-email-
> > >> kwankhede@nvidia.com/
> > >>> It doesn't implement an internal API to communicate with the IOMMU
> > >> driver
> > >>> about dirty pages.
> > >
> > > We plan to add such API later, e.g. to utilize A/D bit in VT-d 2nd-level
> > > page tables (Rev 3.0).
> > >
> > 
> > Thank you, Kevin.
> > 
> > When will you send this series patches? Maybe(Hope) we can also support
> > hardware-based dirty pages tracking via common APIs based on your
> > patches. :)
> 
> Yan is working with Kirti on basic live migration support now. After that
> part is done, we will start working on A/D bit support. Yes, common APIs
> are definitely the goal here.
> 
> > 
> > >>
> > >>>
> > >>>> If SMMU can track dirty pages, devices are not required to implement
> > >>>> additional dirty pages tracking to support VFIO live migration.
> > >>>
> > >>> It seems feasible, though tracking it in the device might be more
> > >>> efficient. I might have misunderstood but I think for live migration of
> > >>> the Intel NIC they trap guest accesses to the device and introspect its
> > >>> state to figure out which pages it is accessing.
> > >
> > > Does HTTU implement A/D-like mechanism in SMMU page tables, or just
> > > report dirty pages in a log buffer? Either way tracking dirty pages in IOMMU
> > > side is generic thus doesn't require device-specific tweak like in Intel NIC.
> > >
> > 
> > Currently HTTU just implement A/D-like mechanism in SMMU page tables.
> > We certainly
> > expect SMMU can also implement PML-like feature so that we can avoid
> > walking the
> > whole page table to get the dirty pages.

There is no reporting of dirty pages in log buffer. It might be possible
to do software logging based on PRI or Stall, but that requires special
support in the endpoint as well as the SMMU.

> Is there a link to HTTU introduction?

I don't know any gentle introduction, but there are sections D5.4.11
"Hardware management of the Access flag and dirty state" in the ARM
Architecture Reference Manual (DDI0487E), and section 3.13 "Translation
table entries and Access/Dirty flags" in the SMMU specification
(IHI0070C). HTTU stands for "Hardware Translation Table Update".

In short, when HTTU is enabled, the SMMU translation performs an atomic
read-modify-write on the leaf translation table descriptor, setting some
bits depending on the type of memory access. This can be enabled
independently on both stage-1 and stage-2 tables (equivalent to your 1st
and 2nd page tables levels, I think).

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
