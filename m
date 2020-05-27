Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D23C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 03:27:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4DEF1207D8
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 03:27:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=intel.onmicrosoft.com header.i=@intel.onmicrosoft.com header.b="t7OR6TuT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DEF1207D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD1B74B1B6;
	Tue, 26 May 2020 23:27:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@intel.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G6PhHH5O6j12; Tue, 26 May 2020 23:27:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83F114B1B5;
	Tue, 26 May 2020 23:27:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC51B4B1B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 23:27:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3W16c8x1pS39 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2020 23:27:50 -0400 (EDT)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C87084B17F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 23:27:49 -0400 (EDT)
IronPort-SDR: KQXSj5bV7MDtSUZm5V8YHTujgG28oLLly4+WSLLdiaYuJJFxGCfASstc4MqJcQgM+63h9rJLSy
 7OG7Z60jptxw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 26 May 2020 20:27:48 -0700
IronPort-SDR: Wg2daB6xUYgbP61JpkF4sz+Azr4I2SWGGgi7T+o4Cwtazh6/VNlHX+QkGeUAgWzdV9j3ldmtcC
 RaXx2mqsjenw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; d="scan'208";a="468589474"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
 by fmsmga006.fm.intel.com with ESMTP; 26 May 2020 20:27:48 -0700
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 26 May 2020 20:27:47 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX123.amr.corp.intel.com (10.22.240.116) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 26 May 2020 20:27:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 26 May 2020 20:27:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDlFA7ocN5WViwSbRG9px/zsQAIJNeQ00lxGBDnJNiG2B2ZOCNy/nRSjMpGxrpptvmWzFgjMZpzvhRzdQkDWsVoNqlt1SwWUeHpj/BpMDnHo/BJ9lj2FfIK3swEHmx3OAjtXthHUab4TfMR7+6H/iALY8WGqx2YFP37rfgGEyBFN6QkOm0t5J/IeLZsWt997cxQv3QOTBM3MrSyucEhKGyn2aL4n0H30sBRanCnWvJuN51BYdLjjXvCNyFISM9eDMttymH7BZojgxff+JgDoxva3D3gs/tIm0P4ndmTD3zvpX/Akbs6Js4XfciXuePKyk4NioZuUbBup4HRAv1f/7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuCP09GFIpCbXzVrIAS8QLGUXrK+6QhkOXgsTwLQnFY=;
 b=j1SA97FYKoy94o0lFUu2LyX8XvV1gDZzyJQxnYqRE3oyWZWX519wW8WDDwLWJNEsnSSUo1bkZEx1VH4A6MFe8CwV9Br0KB1LPX5J21ZTEQkcGcCFDVAsuoJHJXWGF6Wqw9EsweUXogkk0L1vSbstp8KLKvtP9zJ9Nj9FvUK5kyP7VqCizTQlC6RYJreccDr7gk+EoUHFehKUzuSShMYxKGTTI/4VE39mcz1S6n6hpZYYokMPLGJ2s28Iv/iE35SRBF2Ka4ADQrLJKlzT7ZIFO8/g3GN31dH23MqM9PPBXZPK3xkyRoaMjNEI1LUuMvP81kwoaWXP7wjVYH1kZYWAcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com; 
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuCP09GFIpCbXzVrIAS8QLGUXrK+6QhkOXgsTwLQnFY=;
 b=t7OR6TuTEjVekaw2P3SxSyTLh86XL3PTEIEuZQnNh7vNlb9r3HMvrAkhC+ln9Rq3ObIm5C2W8KMbG/qSycUDIK0UIY73YAJd+20NXuMeJ1Z6MVf50vYMW5itCbeiZ8Y7wKtKgfZqfIQdRfnuBHTgMbbrY4I7YlQuVilWp+iVUP8=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1277.namprd11.prod.outlook.com (2603:10b6:300:29::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 03:27:45 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::b441:f6bd:703b:ba41]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::b441:f6bd:703b:ba41%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 03:27:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Xiang Zheng <zhengxiang9@huawei.com>, Jean-Philippe Brucker
 <jean-philippe@linaro.org>
Subject: RE: [RFC] Use SMMU HTTU for DMA dirty page tracking
Thread-Topic: [RFC] Use SMMU HTTU for DMA dirty page tracking
Thread-Index: AQHWMFylSKWbJMD/rEatnfJX129kWai4sCAAgAKbIaA=
Date: Wed, 27 May 2020 03:27:45 +0000
Message-ID: <MWHPR11MB16454475DA1FF417CEF5A32B8CB10@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <b926ec0b-fe87-0792-c41d-acad56c656a4@huawei.com>
 <20200522171452.GC3453945@myrica>
 <e68c1158-8573-a477-42ce-48cee510c3ce@huawei.com>
In-Reply-To: <e68c1158-8573-a477-42ce-48cee510c3ce@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfe24859-021e-40fa-eeb6-08d801edec16
x-ms-traffictypediagnostic: MWHPR11MB1277:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB12779AEB5FBA459A61D5A9288CB10@MWHPR11MB1277.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k+S344j/6Y/72khmcvXATyNtL37jYgE9l7Z7/B8IzB7pTbvJNtBzF5oXe4etrrJcfssBoocWzFTkpoY43hClJ9b84h542zKq+5dcT1OjiHAK+4fbfD3e1OQnxO5lffXY6DeIMpjmQRSB/2rlqjMPQ5RmJO3/G9ZOoRKNkhQxMXdAlaI3FxM85AEQOEfv6ZnmTz5ej0cXm0qFZZSuv/hdxzphrttShbUtvpTr7TdMWg6taxQIYkGkTNwiv4KX5x3XTsQMo67fJE/vjNyZo3Wclpo/oVz7j/jU8dHtKp6HIjhX0i0MBYNrBXKkMecbs2yNXH8SQ6POg0byzh0UXjt5QHROF1ojidRm3EqoWmOa7i4BCF7R4++AaNh1J51SVKfhr90UtCW2T2kF+TomzAKf37IeBa5FEaCc5Xw4HUndwJNIm9FEtifd8bb3AJz0PA154AvKAG8Fz4KE8fXhV1GMAA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MWHPR11MB1645.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFTY:;
 SFS:(396003)(39860400002)(136003)(366004)(346002)(376002)(26005)(55016002)(186003)(966005)(64756008)(478600001)(7416002)(7696005)(86362001)(53546011)(66556008)(83380400001)(8936002)(66946007)(66476007)(33656002)(76116006)(66446008)(2906002)(6506007)(316002)(9686003)(54906003)(4326008)(110136005)(5660300002)(8676002)(71200400001)(52536014)(14143004);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata: Bxk2QFZQFa9dN2KwthZztJJA2csJscwbhPS1E4ZB1L5f77NAfOw9uh03+0KP/EmPsom+/3XfobQWqCzWwlEt0lht+YT03gwOVlQ6VaRsYwdE/XxYUfiKFXWaV+U6F0mJI6MgU3bG13fU8KxCMrSFmRQ3nSARh45gSszGg4Oc0oHDn2l7gDXSus2eVUspMnjHziCe+Mo4Mygpy8geryJLqY19RwKjGVURGq27MfwN9jYkZfNdu//qIkmkUow5KzXHcjKG7e4bo6VHJ0TiEK3Y0LBN8g6kgwqp4YDBNDrTNRM8v34iFOp4GIEp0Hfhjz5qkngSJuT7IWfNv7uZIVkAmwSOLXlMb64yada+3PfwQkWG3fGqMzCk8GC5V95KMdx96PKbGwlk5W07jHpUJRBerX+Mrh+VSygTKWePLLC5GVnOSiAvN8V6ZBEeHZZcTovg/OJ4DOyxt2X4PjHG8jo0LDJjeDck5SkO5KHCpfEVRlqZqfV6hV86juJ7NL8j8Hw9
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe24859-021e-40fa-eeb6-08d801edec16
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 03:27:45.1458 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SN1tHEQ5CKrYDxp+LsStR/LsEPTO9An5e5+UZzZ6VB0xQwObPjRTsl4VL0ETqcl1Cbdv+wVk1rjAT29btCKErw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1277
X-OriginatorOrg: intel.com
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "maz@kernel.org" <maz@kernel.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 Kirti Wankhede <kwankhede@nvidia.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "prime.zeng@hisilicon.com" <prime.zeng@hisilicon.com>, Will
 Deacon <will@kernel.org>,
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

> From: Xiang Zheng
> Sent: Monday, May 25, 2020 7:34 PM
> 
> [+cc Kirti, Yan, Alex]
> 
> On 2020/5/23 1:14, Jean-Philippe Brucker wrote:
> > Hi,
> >
> > On Tue, May 19, 2020 at 05:42:55PM +0800, Xiang Zheng wrote:
> >> Hi all,
> >>
> >> Is there any plan for enabling SMMU HTTU?
> >
> > Not outside of SVA, as far as I know.
> >
> 
> >> I have seen the patch locates in the SVA series patch, which adds
> >> support for HTTU:
> >>     https://www.spinics.net/lists/arm-kernel/msg798694.html
> >>
> >> HTTU reduces the number of access faults on SMMU fault queue
> >> (permission faults also benifit from it).
> >>
> >> Besides reducing the faults, HTTU also helps to track dirty pages for
> >> device DMA. Is it feasible to utilize HTTU to get dirty pages on device
> >> DMA during VFIO live migration?
> >
> > As you know there is a VFIO interface for this under discussion:
> > https://lore.kernel.org/kvm/1589781397-28368-1-git-send-email-
> kwankhede@nvidia.com/
> > It doesn't implement an internal API to communicate with the IOMMU
> driver
> > about dirty pages.

We plan to add such API later, e.g. to utilize A/D bit in VT-d 2nd-level 
page tables (Rev 3.0). 

> 
> >
> >> If SMMU can track dirty pages, devices are not required to implement
> >> additional dirty pages tracking to support VFIO live migration.
> >
> > It seems feasible, though tracking it in the device might be more
> > efficient. I might have misunderstood but I think for live migration of
> > the Intel NIC they trap guest accesses to the device and introspect its
> > state to figure out which pages it is accessing.

Does HTTU implement A/D-like mechanism in SMMU page tables, or just
report dirty pages in a log buffer? Either way tracking dirty pages in IOMMU
side is generic thus doesn't require device-specific tweak like in Intel NIC.

Thanks
kevin

> >
> > With HTTU I suppose (without much knowledge about live migration) that
> > you'd need several new interfaces to the IOMMU drivers:
> >
> > * A way for VFIO to query HTTU support in the SMMU. There are some
> >   discussions about communicating more IOMMU capabilities through VFIO
> but
> >   no implementation yet. When HTTU isn't supported the DIRTY_PAGES
> bitmap
> >   would report all pages as they do now.
> >
> > * VFIO_IOMMU_DIRTY_PAGES_FLAG_START/STOP would clear the dirty bit
> >   for all VFIO mappings (which is going to take some time). There is a
> >   walker in io-pgtable for iova_to_phys() which could be extended. I
> >   suppose it's also possible to atomically switch the HA and HD bits in
> >   context descriptors.
> 
> Maybe we need not switch HA and HD bits, just turn on them all the time?
> 
> >
> > * VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP would query the dirty
> bit for all
> >   VFIO mappings.
> >
> 
> I think we need to consider the case of IOMMU dirty pages logging. We want
> to test Kirti's VFIO migration patches combined with SMMU HTTU, any
> suggestions?
> 
> --
> Thanks,
> Xiang
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
