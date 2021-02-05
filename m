Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C3EC433E6
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 05:21:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B21B164FBE
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 05:21:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B21B164FBE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BFEF4B352;
	Fri,  5 Feb 2021 00:21:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@intel.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FkPL94LcI-Ly; Fri,  5 Feb 2021 00:21:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 141EE4B353;
	Fri,  5 Feb 2021 00:21:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A58D04B352
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 00:21:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Wej2f9m3bih for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 00:21:25 -0500 (EST)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78C114B345
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 00:21:25 -0500 (EST)
IronPort-SDR: QbPLvSOuRjrQvvDTR4U1T+QyDO9mBcWP/0E2AI2ovyI68fLi1kfMtvJeIvTObew0miLay77yu2
 Kazj9qfD6DeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="200381238"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; d="scan'208";a="200381238"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 04 Feb 2021 21:21:24 -0800
IronPort-SDR: 3M5gup0Rs8f6luga6/rOPmaJOLR9KEG+GYOLd8e6crps1RwIbRtOcvHrFurVXfB4eG1V0vfH8k
 cAWLVRQd2gzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; d="scan'208";a="360235105"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
 by orsmga006.jf.intel.com with ESMTP; 04 Feb 2021 21:21:23 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Feb 2021 21:21:23 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 4 Feb 2021 21:21:23 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.50) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 4 Feb 2021 21:21:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRKMZd+YAIr+J0ZPNm5eG4tnrEJoP496sbmBMNUuK8a28u3VoXJYdOWVkLXEm/rl+4xRdlRZ7fIyOrpS/AborENbZB71kMySfVEsnpblrOCZ8+KtUFQxdCWq5/50ynr6iDGnAngK7DOMS1E4A19Xv8t0SlMFPQL0aZsObwOoXQHIvYjUTECsThokWWKxF02P8nXDPTyHUT1lFYMmcoxUWroStGW0uNgkSKKzM2oUvM0O83U14xGAAY6/cUiFVDTiZlLtYd54mRwzNh8KzfRLPwItBWZ3Oo10HP7SWmrK4JkupOeiy4uv+JDD4fqtBjbQatNZW4lf6nuyAfryqAR1Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYfMcmY3dpJS6ysVb/T7cSx0OkQHrnhMdaapWy7eV/M=;
 b=MYD+CA9tW5DMNCivc13NxFBq5UokMdYIY+MFVtxY+Ji+QoXkmECtMDi8xEQH7pqLc9JTMJePCWz6MxA4rPt5hxuSTiQO7eJGaBDdMjI7h4EAQfqO9MT+Jy7jm46M8Lsd7oFLL5QzJCK8+ccgonmDhKUA5TTzBJ4SmCpFH/Y8y7F8l/rk/sbyRIBc41J9Bhi/A1JsfSEyGiqcM/NXvFlpRyJSytyYIxIN6pwuO2f27o57w4bkj2Mh6oCnaDMhlYwUA8gYKCeHo4KQ4rOrtywRBrqwMXhpr4UnbiXNg0OSaE1ytiiG4Mo5MF/3a7PWLlVqBb6YlaCjzBZuIF5m0k/TPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com; 
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYfMcmY3dpJS6ysVb/T7cSx0OkQHrnhMdaapWy7eV/M=;
 b=sYH+8QDCon3aS62emzLlWbDJ+4R4v5cq+etB3M46UBJkA6exo/W9g/b1MKribJclEnphEwylGiH697G0oXnvWK0R/0f4SbCXvji9Ol5h6zQQB9BcRhcxIlj5l01T/oUkRLHtnoQagOtBAeMEYlhNaEWomIWPfw66y9SiRyBX9+8=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR1101MB2223.namprd11.prod.outlook.com (2603:10b6:301:54::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Fri, 5 Feb
 2021 05:21:20 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::f1b4:bace:1e44:4a46]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::f1b4:bace:1e44:4a46%6]) with mapi id 15.20.3825.019; Fri, 5 Feb 2021
 05:21:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Keqian Zhu <zhukeqian1@huawei.com>, Jean-Philippe Brucker
 <jean-philippe@linaro.org>
Subject: RE: [RFC] Use SMMU HTTU for DMA dirty page tracking
Thread-Topic: [RFC] Use SMMU HTTU for DMA dirty page tracking
Thread-Index: AQHWMFylSKWbJMD/rEatnfJX129kWai4sCAAgAKbIaCAADjSgIAAH3UAgAAKMACBjtAkgIAAHmAQ
Date: Fri, 5 Feb 2021 05:21:20 +0000
Message-ID: <MWHPR11MB18869021F6B6F66BD71346C88CB29@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <b926ec0b-fe87-0792-c41d-acad56c656a4@huawei.com>
 <20200522171452.GC3453945@myrica>
 <e68c1158-8573-a477-42ce-48cee510c3ce@huawei.com>
 <MWHPR11MB16454475DA1FF417CEF5A32B8CB10@MWHPR11MB1645.namprd11.prod.outlook.com>
 <897a84ac-0a71-ace7-e05b-3cc9f0b05c28@huawei.com>
 <MWHPR11MB1645AA007D24F2D005794E5C8CB10@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200527091428.GB265288@myrica>
 <c1c96639-2311-398a-15e0-2ff2d59fe320@huawei.com>
In-Reply-To: <c1c96639-2311-398a-15e0-2ff2d59fe320@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.199]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa966df7-2504-4da9-d5e9-08d8c995df0e
x-ms-traffictypediagnostic: MWHPR1101MB2223:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2223FBF080B102CC5013B2518CB29@MWHPR1101MB2223.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FTeAagbTa+RTrstGdS9o+3YEuK5Mb7RJEPXGCuh62+QAgApa4g7e04Bm/CuwuMyYwJXnrsQ4HOhaG8p4X91FS6iHAb4MwXqzgw8jea+ubEaqOzCZ5OOREDYwts9B30JnC8Wjl8zgeAGk1Suq9lvlNPHfitlI7JgG3gLiFkNaOMHn5Rbx3XNFFkW8d/IJdUyYNkwU1YtO5yEhTUPVZeAbZssQlH07t9mRuvpBG4EQzm1hnFgTQQhH6sYueELA0POwe76NciCL3mpdx8jFybFDMPBF5TuhFhdY4pwRxuek4IRnjok7H6AD7eVl3Ck1w/HOIS6evOrgu0PxRrBN7PBtnt3a4SewmQ582wMvjPy0/J2cgEMTldBbvUgYAmROOY+cOw2rBPviJ0/w/Xo6rLq40U/3j0ZiEFavGVS7U7e23MixKh6YygA4BeuHRCUAS9cReJbEvex4Qapp+SO07C36IhHkMFHAoYBP1PLJ1hQy/zl1hGiri5ngf5IQcEk3VQICTxXdZxaEaT7wmREkWbi5FVusIZO/TRYP/w6DIhrJ4I8USyLnjRBbaNuHjChx0FxkAQsA8XYSO2QqkGeVqTrnq/ueu9/6tsxGFSvoXEHNckxf966VScDdkYH3DFNw76xLelj6bU5A7E9Zli07d8l6ZQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MWHPR11MB1886.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(2906002)(53546011)(26005)(6506007)(66556008)(66476007)(7416002)(66446008)(478600001)(9686003)(64756008)(110136005)(7696005)(71200400001)(316002)(66946007)(52536014)(54906003)(86362001)(33656002)(55016002)(76116006)(186003)(8676002)(5660300002)(8936002)(83380400001)(966005)(4326008)(107886003)(14143004);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?h8kjBtjKumO1hSCvFbf0eOfPJwBpciPPtcevZh/WB5oMG95DqOIwHTUpJVTR?=
 =?us-ascii?Q?RB+PCnAbVxZth0r6adSSo8t53Y599MBL//Mzbpkt4ryPUDn4aZyVYZq+0n2J?=
 =?us-ascii?Q?wY3wDZaCE6wwXWUE4Wsl57APNC5zqmSaB7UrduTQpFDxGCsyepaG+pbXeQSC?=
 =?us-ascii?Q?SJRP0PGsgDPOPai05JGLYFU7kBjlkU/BUBd00ntqLJxgNldL9xAygrQCjhMC?=
 =?us-ascii?Q?rd9F6mi0hLSu/QNc0SWAqzqLAAbkf4zKkzSkaCdz2KHI+tYoGh3BN+Lz2KP7?=
 =?us-ascii?Q?ySQKG+DZW8wTFTfaLXeZtbyJQx2MK+w4hccHT9tIn8I1uMgi1oydqdNUo3eA?=
 =?us-ascii?Q?tvFFJRUa274sSGzmY7+rXP9ePlQCcS70O1iOqgkgl7A12QnaOWNAXiXqfcYr?=
 =?us-ascii?Q?KMk6onsIc3O9L3SWt30wGRKnAncDwxqirYCSXQ1HPYucZiJOGdWYbg5GbM4U?=
 =?us-ascii?Q?TrqHoWgmVDZdTNYlbOKCAwEbV/wvCKJZVToxBRHtdlTS51iUzB8iK9hiqymB?=
 =?us-ascii?Q?0oyyvRKcZg5mFwVwGBCVnc4tAvO28nx39xLifZ1IRxW6rra51Ik1CyahyFzS?=
 =?us-ascii?Q?sBAQ4BLPmLemmPuBxT8Tcl3pks4X3XyFM7aalKYDWdTqvqwytMrgEJ9/3lyJ?=
 =?us-ascii?Q?GQTLIqwiknCkuW//HXPcpOAYVTyIj58Py3VRQkHRObhDaSNfxRN2H6W7ueK4?=
 =?us-ascii?Q?OXo8Lgg/BeJNZURCBKUWD2LjgwJ07dGaaXCAGdztxZV5OdrGfSVgEbb3NSzg?=
 =?us-ascii?Q?rxSIglVyDmVEOdx2h9dTYtN3Z0R0CRJ0Ym1NcVJ2CHG6PUmC1u18VY+FNsfa?=
 =?us-ascii?Q?ZvSpFUZ7Kissf+l6fpslJw0uZhX39fHU4ozwOJUTAA2NjfWCrNlrDAc+NwU8?=
 =?us-ascii?Q?NCSp+MMd3FCXmtXD2eLqbnJvrl4bePEnXN3kAkH3qKGKUUn6pcJyGS/lI7/b?=
 =?us-ascii?Q?jD8G5/L0i86cfnlQGo8U/9BgmJnt3FwdNLPBIb3PVf4I1enKQRsLf/gijoNi?=
 =?us-ascii?Q?IxHBdhsAbeZqSD6WRCnq3t41HyNpKCxj8hv2+lFbJhphtzKMHX2RyiWM5mYF?=
 =?us-ascii?Q?Zh8JWO26LXITP4/gPhwOSYx+3XIGxou3Bvxh5QN5fDkgdf0vQmNTJ18kt9o6?=
 =?us-ascii?Q?EMfzeNthvAEIj6ep+Xik5W/NxwDPb9C/fMpgFiybd6d6Ngcv0q0nY7nendyL?=
 =?us-ascii?Q?gzQoMCCYwV+9GyIYeFDLHvDLA438vL5Kf/vZnZLg4xOHqn3yGa6sUq5Bz3fO?=
 =?us-ascii?Q?uZqbMUgyTfBhrsPl92mhcQxY3j6qjTCEJZlm2oUy5euOx97HWxjeN/F83LPb?=
 =?us-ascii?Q?875A2TyCkxZRPM4IaX3gMpeb?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa966df7-2504-4da9-d5e9-08d8c995df0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 05:21:20.0837 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TG1ulS8cZNqhhAarMPDFYb1BaybseS8OcQjX8DIeMSK0Y2q2hXCUgRJkUctSrVvg3XYIUo9VvQk2gPTbKgtDYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2223
X-OriginatorOrg: intel.com
Cc: "Sun, Yi Y" <yi.y.sun@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 Kirti Wankhede <kwankhede@nvidia.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "prime.zeng@hisilicon.com" <prime.zeng@hisilicon.com>, Will
 Deacon <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

> From: Keqian Zhu <zhukeqian1@huawei.com>
> Sent: Friday, February 5, 2021 11:31 AM
> 
> Hi Jean and Kevin,
> 
> FYI, I have send out the SMMUv3 HTTU support for DMA dirty tracking[1] a
> week ago.
> 
> Thanks,
> Keqian
> 
> [1] https://lore.kernel.org/linux-iommu/20210128151742.18840-1-
> zhukeqian1@huawei.com/

Thanks for the pointer. We will take a look.

> 
> On 2020/5/27 17:14, Jean-Philippe Brucker wrote:
> > On Wed, May 27, 2020 at 08:40:47AM +0000, Tian, Kevin wrote:
> >>> From: Xiang Zheng <zhengxiang9@huawei.com>
> >>> Sent: Wednesday, May 27, 2020 2:45 PM
> >>>
> >>>
> >>> On 2020/5/27 11:27, Tian, Kevin wrote:
> >>>>> From: Xiang Zheng
> >>>>> Sent: Monday, May 25, 2020 7:34 PM
> >>>>>
> >>>>> [+cc Kirti, Yan, Alex]
> >>>>>
> >>>>> On 2020/5/23 1:14, Jean-Philippe Brucker wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> On Tue, May 19, 2020 at 05:42:55PM +0800, Xiang Zheng wrote:
> >>>>>>> Hi all,
> >>>>>>>
> >>>>>>> Is there any plan for enabling SMMU HTTU?
> >>>>>>
> >>>>>> Not outside of SVA, as far as I know.
> >>>>>>
> >>>>>
> >>>>>>> I have seen the patch locates in the SVA series patch, which adds
> >>>>>>> support for HTTU:
> >>>>>>>     https://www.spinics.net/lists/arm-kernel/msg798694.html
> >>>>>>>
> >>>>>>> HTTU reduces the number of access faults on SMMU fault queue
> >>>>>>> (permission faults also benifit from it).
> >>>>>>>
> >>>>>>> Besides reducing the faults, HTTU also helps to track dirty pages for
> >>>>>>> device DMA. Is it feasible to utilize HTTU to get dirty pages on device
> >>>>>>> DMA during VFIO live migration?
> >>>>>>
> >>>>>> As you know there is a VFIO interface for this under discussion:
> >>>>>> https://lore.kernel.org/kvm/1589781397-28368-1-git-send-email-
> >>>>> kwankhede@nvidia.com/
> >>>>>> It doesn't implement an internal API to communicate with the
> IOMMU
> >>>>> driver
> >>>>>> about dirty pages.
> >>>>
> >>>> We plan to add such API later, e.g. to utilize A/D bit in VT-d 2nd-level
> >>>> page tables (Rev 3.0).
> >>>>
> >>>
> >>> Thank you, Kevin.
> >>>
> >>> When will you send this series patches? Maybe(Hope) we can also
> support
> >>> hardware-based dirty pages tracking via common APIs based on your
> >>> patches. :)
> >>
> >> Yan is working with Kirti on basic live migration support now. After that
> >> part is done, we will start working on A/D bit support. Yes, common APIs
> >> are definitely the goal here.
> >>
> >>>
> >>>>>
> >>>>>>
> >>>>>>> If SMMU can track dirty pages, devices are not required to
> implement
> >>>>>>> additional dirty pages tracking to support VFIO live migration.
> >>>>>>
> >>>>>> It seems feasible, though tracking it in the device might be more
> >>>>>> efficient. I might have misunderstood but I think for live migration of
> >>>>>> the Intel NIC they trap guest accesses to the device and introspect its
> >>>>>> state to figure out which pages it is accessing.
> >>>>
> >>>> Does HTTU implement A/D-like mechanism in SMMU page tables, or
> just
> >>>> report dirty pages in a log buffer? Either way tracking dirty pages in
> IOMMU
> >>>> side is generic thus doesn't require device-specific tweak like in Intel NIC.
> >>>>
> >>>
> >>> Currently HTTU just implement A/D-like mechanism in SMMU page
> tables.
> >>> We certainly
> >>> expect SMMU can also implement PML-like feature so that we can avoid
> >>> walking the
> >>> whole page table to get the dirty pages.
> >
> > There is no reporting of dirty pages in log buffer. It might be possible
> > to do software logging based on PRI or Stall, but that requires special
> > support in the endpoint as well as the SMMU.
> >
> >> Is there a link to HTTU introduction?
> >
> > I don't know any gentle introduction, but there are sections D5.4.11
> > "Hardware management of the Access flag and dirty state" in the ARM
> > Architecture Reference Manual (DDI0487E), and section 3.13 "Translation
> > table entries and Access/Dirty flags" in the SMMU specification
> > (IHI0070C). HTTU stands for "Hardware Translation Table Update".
> >
> > In short, when HTTU is enabled, the SMMU translation performs an atomic
> > read-modify-write on the leaf translation table descriptor, setting some
> > bits depending on the type of memory access. This can be enabled
> > independently on both stage-1 and stage-2 tables (equivalent to your 1st
> > and 2nd page tables levels, I think).
> >
> > Thanks,
> > Jean
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> > .
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
