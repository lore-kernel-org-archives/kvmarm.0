Return-Path: <SRS0=tdS3=5W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23B0C2BA18
	for <kvmarm@archiver.kernel.org>; Mon,  6 Apr 2020 06:29:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7808920719
	for <kvmarm@archiver.kernel.org>; Mon,  6 Apr 2020 06:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7808920719
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D45734B1F8;
	Mon,  6 Apr 2020 02:29:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rZW5+nKUPdqr; Mon,  6 Apr 2020 02:29:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC8A14B1FC;
	Mon,  6 Apr 2020 02:29:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85EB04B1F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Apr 2020 02:29:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XMBlB1buDABp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Apr 2020 02:29:38 -0400 (EDT)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B1754B164
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Apr 2020 02:29:38 -0400 (EDT)
IronPort-SDR: QE6J1zfJ1n86iYl4qGx1qo3+v85Fiy0gFDzuwIgMaonTX30aUnwn+0VBMZ3DuRLMSVW8dbATpK
 9pJPpQr2arsQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Apr 2020 23:29:36 -0700
IronPort-SDR: 7e5L34Y+rt3E7GG9GfybLo7T4EOEtglNQ7+WMHvNTxahyFk7KZ5UFlI+0W46C7I61/CGt+apdu
 m0aSTz8EJbJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,350,1580803200"; d="scan'208";a="285778220"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
 by fmsmga002.fm.intel.com with ESMTP; 05 Apr 2020 23:29:36 -0700
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 5 Apr 2020 23:29:36 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 FMSMSX113.amr.corp.intel.com (10.18.116.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 5 Apr 2020 23:29:36 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.138]) with mapi id 14.03.0439.000;
 Mon, 6 Apr 2020 14:29:32 +0800
From: "Liu, Yi L" <yi.l.liu@intel.com>
To: Auger Eric <eric.auger@redhat.com>, "eric.auger.pro@gmail.com"
 <eric.auger.pro@gmail.com>, "iommu@lists.linux-foundation.org"
 <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com"
 <alex.williamson@redhat.com>, "jacob.jun.pan@linux.intel.com"
 <jacob.jun.pan@linux.intel.com>, "jean-philippe.brucker@arm.com"
 <jean-philippe.brucker@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, 
 "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region
 type
Thread-Topic: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region
 type
Thread-Index: AQHV/tNxynbYpV5vT0iLn8klxfIfp6hkUe3A//995QCAB+uK0A==
Date: Mon, 6 Apr 2020 06:29:32 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A222F4C@SHSMSX104.ccr.corp.intel.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-5-eric.auger@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A21DBDF@SHSMSX104.ccr.corp.intel.com>
 <893039be-265a-8c70-8e48-74122d9857de@redhat.com>
In-Reply-To: <893039be-265a-8c70-8e48-74122d9857de@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
MIME-Version: 1.0
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>,
 "Raj, Ashok" <ashok.raj@intel.com>,
 "marc.zyngier@arm.com" <marc.zyngier@arm.com>
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

Hi Eric,
> From: Auger Eric <eric.auger@redhat.com>
> Sent: Wednesday, April 1, 2020 9:31 PM
> To: Liu, Yi L <yi.l.liu@intel.com>; eric.auger.pro@gmail.com; iommu@lists.linux-
> Subject: Re: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region
> type
> 
> Hi Yi,
> 
> On 4/1/20 3:18 PM, Liu, Yi L wrote:
> > Hi Eric,
> >
> > Just curious about your plan on this patch, I just heard my colleague
> > would like to reference the functions from this patch in his dsa driver work.
> 
> Well I intend to respin until somebody tells me it is completely vain or dead follows.
> Joking aside, feel free to embed it in any series it would be beneficial to, just please
> cc me in case code diverges.

got it. Please also cc me in future version. :-)

Regards,
Yi Liu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
