Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B7FC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 02:42:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67DA74A1B0;
	Mon,  3 Jan 2022 21:42:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q-vVpqh0RiTl; Mon,  3 Jan 2022 21:42:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCA5B4A531;
	Mon,  3 Jan 2022 21:42:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 636374A193
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jan 2022 21:42:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q6nau9IGz3Ku for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jan 2022 21:42:45 -0500 (EST)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A5DC54A10E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jan 2022 21:42:45 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1641264165; x=1672800165;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-transfer-encoding:mime-version;
 bh=vBtYSwCg56aWiZ7B75Ont9c3/7mFCp9Qx0BepG1wTCw=;
 b=fND96EcyEVZ4mGSKX1+daiL99gyIWDaYnkeCBA04DIXLFKSBRBpB4D96
 R8eeYBAF83OQsM1OtaEZpk1EJG3KMJ7AvLU/I9cbuh6QmY6zY8ogC+vcW
 vgbG9PsAHvUxjGAuPLjHjblwnyUk2lDM73YB8LuQhqsY8R2JG+g+s0KVq
 cv+OzCn9K9KjRUO43ycP3ASO33Tcd9w94nHGM1dioSz7oS+MPVjnmpk4U
 gkCOTVrDAwR8uVLPxDRC8BaiLRyPu0xLPvUc/bOZqNPCnbCR0SP5AAXnK
 yPGouzw1QmEPa64uNfX/lcfTpbFIHZC+NUDcpRE5cVmlq0hkwWsVXwrPP Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="222817630"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; d="scan'208";a="222817630"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 03 Jan 2022 18:42:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; d="scan'208";a="573879030"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
 by fmsmga008.fm.intel.com with ESMTP; 03 Jan 2022 18:42:43 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 3 Jan 2022 18:42:43 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 3 Jan 2022 18:42:42 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 3 Jan 2022 18:42:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 3 Jan 2022 18:42:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2NxM0/A/XAbB6EOe3NnrnYhxZbfq9BHqgYAVQa6FMSSS1eXYl3DcFcmjmUwY0fQlpzXaso+3qLOsv0Knk3WFszeZz+zjwRmhrmrF52VmkA0/V4QzLBtYajW53SewXAa3+Jbtvs/G1drf8fM0D8g/qNLbjWR1xjBYx5GICRA4h0u13UHWN5rhf226pd2VT5dE9QdX9TnvbkXA53aLDl9Ds29WBO1Oy3+NlUmKOy4mHxeSJsa6NG/ji4Y44TgpHMxDAOhvkjUJhc44e5NstdzZJM/ZrIFP7nZrDVfVNWTQxiL7RhChOsiWT/1dXSyLC5HoUir0SyAJcICMgBBLpX+DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBtYSwCg56aWiZ7B75Ont9c3/7mFCp9Qx0BepG1wTCw=;
 b=mMy3dg5FHbWANK/NGHJXE7Ld4LH31nsZiavI5rbHhfJkayJWGtpqu06yA9CG2JVQsYY6qBpECZqTzOAdD5aeihrrcDV6oOJykxsuSy2rwc9zdAaIcexSqSJILxI7i26t4qT9XzCSePp6qfAAm5kEhw3BmjC7IgNRV1/av7jEOp8R/glkz4QYm0jFSYWzcup1yLGGs0HOtUHyGL3c6fHMZQn34ayjYWQZNuduHm9X0SBb6wQTvbiYLJfqvzTpxMZhHVToIN3/LvG9czZ17/hqxisHehHeLhYYbyTV7weNRR1FMSnt35hV3E2CKStnaX5wP7ux707xD6cohm6ZYn+Xmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3937.namprd11.prod.outlook.com (2603:10b6:405:77::28)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Tue, 4 Jan
 2022 02:42:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 02:42:39 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Topic: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Index: AQHXyx+9zoVf6ec36EaoAw6mFm2RjKwlh1WAgAGLFwCAARJNAIAAUNaAgABaKgCAAEnegIAAE6oAgACHsjCAABVZoIAAzVeAgAED4rCAAGBlgIAA7M0AgAj9m4CAHKu0oA==
Date: Tue, 4 Jan 2022 02:42:39 +0000
Message-ID: <BN9PR11MB52765F70759C3905177588768C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com> <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
 <BN9PR11MB527624080CB9302481B74C7A8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <BN9PR11MB5276D3B4B181F73A1D62361C8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20211209160803.GR6385@nvidia.com>
 <BN9PR11MB527612D1B4E0DC85A442D87D8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20211210132313.GG6385@nvidia.com>
 <BN9PR11MB527694446B401EF9761529738C729@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20211216204831.GD6385@nvidia.com>
In-Reply-To: <20211216204831.GD6385@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c996295-63c1-44d7-f6ba-08d9cf2bdff2
x-ms-traffictypediagnostic: BN6PR11MB3937:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB39372FC45AC9EE936CA6C9998C4A9@BN6PR11MB3937.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: omkoJ0foRPpFwMQ0WX7UcjFYafYJ+gcLWkmaCB2cYMfsJajKL4DiTPx5nRIRY6Slgma1oET+/HW5ogFne4k66bs9Hg1zCUkff1QtuX1OH9W5ZAUCUqt/rfvpL3HOVR9G0LKhxIfP8IRf+18vSyIwBcjxk0thr1cDELywO5dOpurlrTKC+KN6I6sLlAVqXa1z7PjgqltWMBJ05LoMP/5O9uKNbwvOnqWvWdzMlu4AkYT/DCyzTUlOx9d3xMypvrmVKjNFHWVSzS2rTdJ1BXqWQP3wq3m69nABtlMWXqRV2G6D+Vg6Ka3DQrq0g/czRMj2QwkMZET1gQteksYiPCNwQgCTW2hL3Hjw2stiyfUlI5dRJ3LX1WCh+L7UWjh4iWYjYR8mL+Hs7frdrQJiLrz6MqTcbAjC0oqjF0oNX/DAdYYREjbCPk69KkKEjH5QkJvSrA0uP+zDQ5ZkzpzxzIdj4LHsM4vh+TyMOALXmCpXguWgJJU6ntC89xacTnCDnJpoqfZMLZmnPHTYB7hLFN8h39FuzaxcQR4AGlwqDWEzZqaaTGNcxT8RxddAedqgqNiTelrV4p4UHkRjifqIjQ2oxrWm0pZr9Upo+Om6MyqttnqarNUYsYhA9wI+y85IkbnQC6p8hZ4v//ncdtKEnGg7+65/BB36UbXt2BgUUIQwEXalSbAfXAh4lv/nqRCBTEatgPL22d1PyLBcZ4e5WBWBeQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BN9PR11MB5276.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(366004)(4326008)(5660300002)(316002)(26005)(186003)(38070700005)(55016003)(33656002)(508600001)(86362001)(52536014)(71200400001)(7696005)(82960400001)(122000001)(6506007)(9686003)(38100700002)(54906003)(66446008)(64756008)(76116006)(66556008)(8936002)(6916009)(2906002)(7416002)(66946007)(8676002)(66476007);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dGlUp7vLVMoS/st0FA52PzS+mp+szmnYAo2EoBW4OWCUKIbf2yQse+PGQ8jW?=
 =?us-ascii?Q?4/jNCbT4W5z7HG/+4DddVVbbxJwazue1g0p0i7Kl+pQXujy54QeOsmapA34Z?=
 =?us-ascii?Q?x6uIeeDO5AP1M2L8M0MlqYjumpay2+lMBF5XSlnSS+R9K/ZDWA/cQAtp+veF?=
 =?us-ascii?Q?1XDb7VTusL8XKcQet6grhQZcTIduoIAF/sDPVTCy2TGf+ia3vZ2KEw6n0D2f?=
 =?us-ascii?Q?6O4PjUtcZJ4GUFLvWVNo8zzuGpjlLEmNjtzqXZnHxCaphP8OrQPe/fuWrMme?=
 =?us-ascii?Q?QPvDv5Ui+GmxFCNkLIjc/AA9aut+Ys0SRwUg3ZgIcu63pnSHwnzJfKQSbZPA?=
 =?us-ascii?Q?EoFSQBrMJCEoPGik06CpOsY/8OdZAI6R0QKR55MfQm0cdT5qBwzemaHws+7S?=
 =?us-ascii?Q?jq89uIiWJHZvUPJ8kMlpZi3spti4zH5laaKLmaTomJFUXmr1dbVEeN9pIH51?=
 =?us-ascii?Q?xLmbikMs2+yjR3GCPiRvyi6Qcfyx1dUyXTzV2w3u8pvphuVNXwyDq1x+X4SX?=
 =?us-ascii?Q?Gb5hcq6cAUNq/bsvmNn20EbEa0qYHVkkqfstuF5Fz250HT12bxMSLgixvpzg?=
 =?us-ascii?Q?VPYJ39IHppLsy9IZ28W/r7JnF5f/fa5rQvZ4aW3jEIgZzngSy6Pk2ZWqi9+7?=
 =?us-ascii?Q?VyfFILkrVoraM+VDAI+tIE+I8IdTnO/3g7o1vhQdZkmGMarQqKrNL/TGW0mY?=
 =?us-ascii?Q?lEunW0z63wzxmrSfy/0J4rJBJBvveFsUq7T+qJgqTCEPzSoSbeu2WbOsSw20?=
 =?us-ascii?Q?i9pfL7lySVOnpgVQsfNEMZRmA4Nw82PYSjw3KvI2vmSgCJKC3My9bRBIEZtg?=
 =?us-ascii?Q?uK+x3qoQuhKpnNM3zRjouJPot+2LAgNJ16YNBaJmLXABiBxLRWAnCM2xHA6o?=
 =?us-ascii?Q?EhO+90+qEGlVf/HIVTh1JszeuPypPc3k/iXLuSdiIkP4KGpg6SxuCaBLKr+U?=
 =?us-ascii?Q?75trXkvVJqT6+1Qk37750cC0fMwiTSVtQ/4jfrH76LDDvWaFnY/8A+ZLkwCu?=
 =?us-ascii?Q?SAb65gszG25SmpTs4e3Zx4UWir20fBRKxgK1BHAv3auMXx1a1g66F7aweqlN?=
 =?us-ascii?Q?qRPYlYuaj0MjFHrqevmbnQSGQq4KfdfDOYvo2Y06kBx5fi1wzwprbIOE4uyi?=
 =?us-ascii?Q?m+LTRwHhpRSvLvp+NN6rWosxImfa5ZtrVJ5Jq3IVHEgV0qAshtRFMGmhNRY4?=
 =?us-ascii?Q?16PJmwyW9+i8CcsE/B0qSy4occYksalOSnsrEXRYCxyu9ie5uyZe07pNKhlt?=
 =?us-ascii?Q?L/GsmVhXiGVszVHGyU+A0dOT+8rY1L18hAzNpjFPANGm5zwZc979DFC9NqV8?=
 =?us-ascii?Q?61aDBpJl/dwO1lNe88hbcVIjKwYaA24O0euHn4q6IT74tQ6PpOOWVeQpHyNg?=
 =?us-ascii?Q?LuBaZF9LG/N8Nq5+I1pPvhew4tln3UGvQp8qHqaMdSgBhP9ghuyliMmtVR/8?=
 =?us-ascii?Q?7gqg9R+BNGvbi9hsO6Xa8Kp6UvtWGtG1ccEKlOD4Luq6p3RonfSovfEPQrw0?=
 =?us-ascii?Q?4yMBXcB7nzdpgcBIhVuyeP5F8N7hC0rB0VYk0GVKrZ1iasZNb75sdfjl2sCf?=
 =?us-ascii?Q?TngMzi3sq4blDR9yxYDbhFDeUlwpSxNNphjcUriKsoGmKvv+7jwoJ1H32dsr?=
 =?us-ascii?Q?1PYBp+MzjnTjf7biJxa28so=3D?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c996295-63c1-44d7-f6ba-08d9cf2bdff2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2022 02:42:39.6823 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F807j9kmC+t0SZJtwEOKbwfMnHMN75iGDubU4pTawlmORIyoHj19ieq8d1sF7+gNRxQqsrEF+Jv3KJ+w49dMKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3937
X-OriginatorOrg: intel.com
Cc: "Raj, Ashok" <ashok.raj@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>, "will@kernel.org" <will@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "vsethi@nvidia.com" <vsethi@nvidia.com>,
 "lushenming@huawei.com" <lushenming@huawei.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
 "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "wangxingang5@huawei.com" <wangxingang5@huawei.com>
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, December 17, 2021 4:49 AM
> 
> On Sat, Dec 11, 2021 at 03:57:45AM +0000, Tian, Kevin wrote:
> 
> > This might be the only open as I still didn't see why we need an
> > explicit flag to claim a 'full device' thing. From kernel p.o.v the
> > ARM case is no different from Intel that both allows an user
> > page table attached to vRID, just with different format and
> > addr width (Intel is 64bit, ARM is 84bit where PASID can be
> > considered a sub-handle in the 84bit address space and not
> > the kernel's business).
> 
> I think the difference is intention.
> 
> In one case the kernel is saying 'attach a RID and I intend to use
> PASID' in which case the kernel user can call the PASID APIs.
> 
> The second case is saying 'I will not use PASID'.
> 
> They are different things and I think it is a surprising API if the
> kernel user attaches a domain, intends to use PASID and then finds out
> it can't, eg because an ARM user page table was hooked up.
> 
> If you imagine the flag as 'I intend to use PASID' I think it makes a
> fair amount of sense from an API design too.
> 
> We could probably do without it, at least for VFIO and qemu cases, but
> it seems a little bit peculiar to me.
> 

ok, combining the kernel user makes the flag more sensible.

Thanks
Kevin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
