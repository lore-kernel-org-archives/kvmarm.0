Return-Path: <SRS0=zWKl=TC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1858FC04AAB
	for <kvmarm@archiver.kernel.org>; Thu,  2 May 2019 16:43:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 961B0208CB
	for <kvmarm@archiver.kernel.org>; Thu,  2 May 2019 16:43:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 961B0208CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAAE44A4F7;
	Thu,  2 May 2019 12:43:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cL7Gkwiupumm; Thu,  2 May 2019 12:43:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2A6F4A4F0;
	Thu,  2 May 2019 12:43:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E725E4A4EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 12:43:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SYuBzq9guIYP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 May 2019 12:43:39 -0400 (EDT)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 484A24A4A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 12:43:39 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 02 May 2019 09:43:37 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
 by orsmga002.jf.intel.com with ESMTP; 02 May 2019 09:43:37 -0700
Date: Thu, 2 May 2019 09:46:24 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v7 05/23] iommu: Introduce cache_invalidate API
Message-ID: <20190502094624.43924be8@jacob-builder>
In-Reply-To: <6af5ddb7-75ad-7d3f-b303-f6f06adb1bf0@arm.com>
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-6-eric.auger@redhat.com>
 <a9745aef-8686-c761-e3d0-dd0e98a1f5b2@arm.com>
 <e5d2fdd6-4ce1-863e-5198-0b05d727a5b6@redhat.com>
 <6af5ddb7-75ad-7d3f-b303-f6f06adb1bf0@arm.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Cc: jacob.jun.pan@linux.intel.com,
 "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "ashok.raj@intel.com" <ashok.raj@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Marc Zyngier <Marc.Zyngier@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
 Will Deacon <Will.Deacon@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 Vincent Stehle <Vincent.Stehle@arm.com>, Robin Murphy <Robin.Murphy@arm.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190502164624._yy-TEMFKlfmvO3yR0TQ7T3if_-aXfXGF0TZVCOoNbI@z>

On Thu, 2 May 2019 11:53:34 +0100
Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:

> On 02/05/2019 07:58, Auger Eric wrote:
> > Hi Jean-Philippe,
> > 
> > On 5/1/19 12:38 PM, Jean-Philippe Brucker wrote:  
> >> On 08/04/2019 13:18, Eric Auger wrote:  
> >>> +int iommu_cache_invalidate(struct iommu_domain *domain, struct
> >>> device *dev,
> >>> +			   struct iommu_cache_invalidate_info
> >>> *inv_info) +{
> >>> +	int ret = 0;
> >>> +
> >>> +	if (unlikely(!domain->ops->cache_invalidate))
> >>> +		return -ENODEV;
> >>> +
> >>> +	ret = domain->ops->cache_invalidate(domain, dev,
> >>> inv_info); +
> >>> +	return ret;  
> >>
> >> Nit: you don't really need ret
> >>
> >> The UAPI looks good to me, so
> >>
> >> Reviewed-by: Jean-Philippe Brucker
> >> <jean-philippe.brucker@arm.com>  
> > Just to make sure, do you accept changes proposed by Jacob in
> > https://lkml.org/lkml/2019/4/29/659 ie.
> > - the addition of NR_IOMMU_INVAL_GRANU in enum
> > iommu_inv_granularity and
> > - the addition of NR_IOMMU_CACHE_TYPE  
> 
> Ah sorry, I forgot about that, I'll review the next version. Yes they
> can be useful (maybe call them IOMMU_INV_GRANU_NR and
> IOMMU_CACHE_INV_TYPE_NR?). I guess it's legal to export in UAPI values
> that will change over time, as VFIO also does it in its enums.
> 
I am fine with the names. Maybe you can put this patch in your sva/api
branch once you reviewed it? Having a common branch for common code
makes life so much easier.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
