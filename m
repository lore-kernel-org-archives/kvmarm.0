Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0040037B023;
	Wed, 16 Sep 2026 05:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789538215; cv=fail; b=O3+cDWwpeQ8HKRag87j3pY+Yioaqm/tJg+oktI77cNA/cAgQlt6MqxNsx69nRG8zrxt6ST1swI7GKfZ8OsPW3EZT9CJufJdjknbRWZhdW9QI+SVt9sOIze4xvAIzwUwMNXzlvkUTIVDLbL9C3MMzLR45LJ+fPYEtOi6dYWIewjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789538215; c=relaxed/simple;
	bh=Iibnl9Gx8bg2D0RZHMkY6qWr84bIb2wX5A2pNri/rB0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QsmWFls/Y2M/PcmJ3HmA96vD3Fgfa3Vd+g/W6QZIGXV491gQo7Dk1US8HwwMhF1+kJv5Pyy+lsrx71bIAW4323xHQ/OB0GXZehUQmMn6OcbvU9Pc5+uF9c2yiOFRJuYm/gbY1vuINQl1uhZkEFKo7lobqk5yEGT9pcCr8/t5UE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Db63nIGj; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Db63nIGj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789538214; x=1821074214;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Iibnl9Gx8bg2D0RZHMkY6qWr84bIb2wX5A2pNri/rB0=;
  b=Db63nIGjryfx7QZcUex8zGZfLObicUpXZs/c4SjCo1opYGXTURw2QNtU
   XxIsfkxBXaxb5RnE/PV72Ni7F7TO5l9SOZqWer9uGjBvSa/xQQ81GmXZz
   EdzeW62Ri5bsZ5FXav4yTfbN9dkx9a69PCF358e0/L6O3A6EKkWhlLuN/
   xu/WqgL2knPfgnfX1eXbaTwwNKSrl5jVW67Yi1IpD6UBJMMKPHvVI0Arl
   yYzz9/P2M1SlGhEOi93RALNfIvRrTUGM2Fl5tgVU+oTIHyLTH5CplTT+I
   hghIAudzSDafn2Wf89ASc7f3WJJVvizgImqQP9sGpZxz6v8hm36bERFH4
   w==;
X-CSE-ConnectionGUID: CN9T1+nfSoWYBnD8Zh2vIg==
X-CSE-MsgGUID: bXWES8PNRtK+fOlMvksoqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="88846923"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="88846923"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 22:56:50 -0700
X-CSE-ConnectionGUID: Za9oZDdASUWDK9P4hgXpNA==
X-CSE-MsgGUID: y/oT4OVCTdKFQSYutaqu5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="268961119"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 22:56:50 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 22:55:03 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 15 Sep 2026 22:55:03 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.69) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 22:55:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nuCd7MkxVuPbyk+nfaKxMexpsawBCSFlCJTK7dImjkOxB3Y+9in4D+k+T5uPAgwMyTTfPk40sFJdIQicJxEoa2AOrGNdDN4ilSpIZfQ1vvMIdayhRt6dg5nl0lj14LMa6A3iJgBHBzGXtd1KL1yN8t5b5lXZrK1fR3RUx1Tf7QiOAl39rQQc5c0FvcOEDcyZxMGEy+JO8iovaUKehaW+xWpZcARY232dJLVw/vR6lTd6+LBtFSb29PkiWFIA/Qzi7/N3GJvPvj/FXnHhXiuptH8wCWnz1gWqEup2zU8XpLcdKav5QT4CO8ovDa+3vsLjaeJ0FHHGsP2Otnx8g9Azvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iibnl9Gx8bg2D0RZHMkY6qWr84bIb2wX5A2pNri/rB0=;
 b=AP0SKwo6TiyyHQ584smIcqhNjvGO5w1z7gPgz9DX1KCh0Hun6bKqLp8cMH29jMwwMrIYkZEBnqqKKlK6PtIlQ3LONNvW9FSWQZ2Y3Lsq26tVdf6sXpb5cR3AJm/gqLpvUzTtNYXzvjY1WdOJJMQtgDmbxBgs8TnrbZjJobVcYHHidyhOv9Koh2dKnravm8fJqQr9/ecIYA1wSQtEh3yIr5xS4FzuYVfrIJxN9o6FY93fNdXUPsG6oZR+OTmikvmMkQ12EWJZoS+wcsHZ2dx8rz3BAzKAbqMmXpxDh5I8xm756aP9aluVYWStQz8EeZ2p0XMklxVX+4aKfr5YYq2XGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22)
 by SJ0PR11MB6741.namprd11.prod.outlook.com (2603:10b6:a03:47a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 05:54:57 +0000
Received: from CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225]) by CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225%4]) with mapi id 15.21.0406.007; Wed, 16 Sep 2026
 05:54:57 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Aneesh Kumar K.V <aneesh.kumar@kernel.org>, Nicolin Chen
	<nicolinc@nvidia.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Alexey Kardashevskiy <aik@amd.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, Pranjal Shrivastava <praan@google.com>, "Robin
 Murphy" <robin.murphy@arm.com>, Samuel Ortiz <sameo@rivosinc.com>, "Steven
 Price" <steven.price@arm.com>, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Suravee
 Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: RE: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Thread-Topic: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Thread-Index: AQHdN/EwiLvbaU+6lE2MX0oxJV5il7a5dWsAgAAN2ICAAErrgIABNM4AgAA3CgCAABBnAIAAON+AgAB6EYCAAGKGgIAAwE4AgAXLI4CAADRDAIAC9yOAgAAr2QCAAS/H0IAAYpMAgAdUwACAAJbEAIABAFjw
Date: Wed, 16 Sep 2026 05:54:57 +0000
Message-ID: <CO1PR11MB4835562E7714F368E669D3B48CB92@CO1PR11MB4835.namprd11.prod.outlook.com>
References: <20260902235609.GG2890729@ziepe.ca> <yq5a8q5izxz4.fsf@kernel.org>
 <20260903171704.GK2890729@ziepe.ca> <yq5acxupjsy2.fsf@kernel.org>
 <20260907125228.GB667892@ziepe.ca> <yq5atsnyag84.fsf@kernel.org>
 <20260909124628.GH2543240@ziepe.ca>
 <CO1PR11MB4835512E374074A5F4AD0A6C8CBF2@CO1PR11MB4835.namprd11.prod.outlook.com>
 <20260910124632.GB4083318@ziepe.ca>
 <CO1PR11MB4835FF972283C09D7D683DAE8CBA2@CO1PR11MB4835.namprd11.prod.outlook.com>
 <20260915134318.GB3196566@ziepe.ca>
In-Reply-To: <20260915134318.GB3196566@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4835:EE_|SJ0PR11MB6741:EE_
x-ms-office365-filtering-correlation-id: b1819bc7-ce43-497a-0371-08df13b709d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|18002099003|22082099003|38070700021|4143699003|10067099003|56012099006|11063799006|6133799003;
x-microsoft-antispam-message-info: gIewZjaP+g4q/XLD0uJ0qNU5Z7/Uvcf344kiBz8xE+WDQvmmdb/UhOpbGtfVZ5rfwdQ8HbJ5YGUU8Nk0x3ilN+7HBqUMpTVE85h/DFB46yVmNR9+iLeUBKIqozSZLt64F/1z7kSss6I1A62bNVgDRhQQoYNv2RmJycaHGZ7RuwTNR0Kk7SYT69pSmQRcF1M9LFTrzjtD+XmKJRjJvjdc7+AAaxaJg7FKJ6yfqBpv/kk/kjbi27nX1oL6JaUknPp4IsjBLrRxEZqYk4sM73kbcx0Am9voHjViFT6YKKaNwznSBlC5APvKQesyB721dN7KBbIehYG+pHoNWh24aQcOpr0qjicdEhpDQTht6QdrmiNrGyKO3Im7PR6TZN9mpuORzygbx/2Tj4G8cJrKr7nJsRKGo7KxuqKzzo9qrlTaZFFzJAJD2TiJy5OcLW5BbDkzFb9FWBA1NyDLeKvEoYOrW2N//8wtF08amJOtLzhwM2I6ffdF4PN53aQ3aTfDiVjsD+pjqHRZ8VIeT+yoe3Go71fx+njFNOSPGtFzb7ekWaX9sKHtFux8vW4PtjjjAqh0+XnbGz4yiZqz0z2GnPumPDl/RQZsTaU6eR6pvouOgBeDTMaMax33HUDVxl7sreDUD6S7vhecywE0iueTJhHtR0wbu/FzXZkizXUdg8XjwMC3uPHbi/AinSqGO/p3gzVG4F2fuy0MiR753bRrcvutAdpX4nhjHiQImoz7UdJUwtA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4835.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(18002099003)(22082099003)(38070700021)(4143699003)(10067099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qHkE88RudTQHcftwqOZM38e1v2HmWYSFTbEdeWIBsZGRqyeRamP5Y04uhI8g?=
 =?us-ascii?Q?yLaWyyZYM1na/gE3Jd8M/4+MgIr5Logsd91BxX9mBIPryrkkpHyRptiQL7aY?=
 =?us-ascii?Q?I4FDddj4tvWFY2bGqv+hIMmOO+Xdw2KDhCKZnNR7ntJeamVZHYk+opIIVhtm?=
 =?us-ascii?Q?OnOU27UsNnwB5xpIFe/H2RtenXyYCoga4VBNffQEJgexqgTcfoQIkrM7jLa2?=
 =?us-ascii?Q?Fh/uJ04mfOYUk8TLD7A0nQiPMpCiw/wEWyP/1gsKCW9zgT5h5tmMDF8amGD0?=
 =?us-ascii?Q?7n584piITtlpTEeI7/xpWxaV+oaAVCykLtkEMKmawddC6U57zjjV+Y9kK5op?=
 =?us-ascii?Q?9JS24Pe7XpuWb9ob0wABXnkP4X1LPcaLffmiN/ZkxtWvweof/g71AjD98GLq?=
 =?us-ascii?Q?E7dAkNt5SyM9AQxmXo8txzE6xmHUU7Lecj+8Hy2zLRAH0MY/2ZqiGoxL8PJt?=
 =?us-ascii?Q?S3+d7DU0hPbUyzzipCImAopz4Pg+DmsidDORvD5T758jWrMQxImKqLumW6e+?=
 =?us-ascii?Q?kXmfB4/iQoUjxwGD1A2B35ooRmHvKAronb23UVfCfoWWVviclIcVMwl0qOSq?=
 =?us-ascii?Q?GgRB4OXvqPCDLGWVOYQBi2GZqP1d3dWz07/pOY+qAQhJQjSMGg88hN295bRh?=
 =?us-ascii?Q?T2+R9XvZC1BQ3TsuYhOATAn1Atvq2QHa5nRGM5SdFlflBTux1trMK/HjwVP3?=
 =?us-ascii?Q?3Q3ev9G72OHni82uHiQ7so6chv2uwit/2RIcX5PgklxDbq+bJ4aTdQN8eZuU?=
 =?us-ascii?Q?N+JSzwrWJZH3yoAWINv+V1kmB6EWglI8Hw+bFCWw0zgVhBya7kOemhxT/Yp5?=
 =?us-ascii?Q?GGaI0hZ68PYiLKC52HcrKtf/SezyIGLxkS50L0GAVAtQz99igf4LKSN1TRJw?=
 =?us-ascii?Q?QRKR9K9ZJrGebYWiZuhdXh0kNc/oPEvch/NJNTPBElX04TyvUhwwWULqhipE?=
 =?us-ascii?Q?Dl1IC1xBEIDMtiwKbKn7Ud5JH+IMZzG1vVetWa48l07/FFr/6ZyouKhBARkK?=
 =?us-ascii?Q?PCca2/CD8qBtWwPLhkIggrFj5kfVFoYVmlHEDfwQZK2MpH1+WcgiJrQw5htp?=
 =?us-ascii?Q?ORvicCNZ+e8Quxq1h73IZ+BSOX2S/mVcaCYm5RozWFpMl9jcZZ1yDsAD4bDb?=
 =?us-ascii?Q?dO/8tRE4m2BZKwesJJLu2ZtV1OFXB5jA9sh//ikL/GcUOStsE0eukwmi6RPH?=
 =?us-ascii?Q?YkP/OFxJs65I5qTpofgMozxgFfAbLQsnS37E6rtZxjO4DxkSZQHlUnoJFIDZ?=
 =?us-ascii?Q?qMA4X+5c6BA1kcSS1WhTopfmRo62xMiHTIdVuJs0HJhuCTo0Doe2vYQvuxhn?=
 =?us-ascii?Q?l6GmwQFyJp+ChlPirbHn9lWOkSq2hnx4RR40EAiNpqHjVhozbsnu4qu2f+9o?=
 =?us-ascii?Q?MpIhf5SLpvCXEmOBXechHnRYdUvJO4hrKqDkYKVAhjyqFOZ0p9v+AqVvC/D5?=
 =?us-ascii?Q?SrywJDs5YlHQB1ALDgAqWoaru6AZR46/63iQAOWUMlQsIUSOeA5Gjwp/pT28?=
 =?us-ascii?Q?IzZ7jIWhqUs7gQKqkSVLDOX5bBubzFcZWoyuc2tLBijGDVZWT3LUyS9HlDPq?=
 =?us-ascii?Q?BoryBMklZq349didIrsDoQyV9BB057cHHGdociAMzag0uy1D/+uoMYvgdjz0?=
 =?us-ascii?Q?7s28DeBOEvPWmg4KNxA5W2ML61I3RIWc0FOiaFoBebnsRbxEhFXd4rlYoQ3d?=
 =?us-ascii?Q?kXuQES/NnkUz+ICkw2uvmuWZLE7k6/er0qZj7fyXi0a5QYqKyeIvD/zqkqaF?=
 =?us-ascii?Q?VS/K1jGMyQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: mrrwv01V7I5EM7MHcoq5+pwDQpoGY582NHYBHLWs1iQpoBfhLkVB060A+B6wOvPqfH/d8R3plAixPGMORtVLIkjAAsWrn368Vro4tdA4VfIPIh0+QLVqXYUTfPjIyUkEVNZZ1AxWeNqGstP445LTrxm1gqI7P1rc4HWoWR2mbvKPG1gu5gfp1YK921u6RFyucoXzZaiddyvdJE+jCc4hLYAcvCdGYO5y7o2MB5GnU/AjIee9Rn2rIxhp02EHiKCpWcSRWeoVa2P8su3iT5AxaY4CtVP8Fo7y4Cbr60AI95Th2XHxRGNjITqR09VAB7Hx8Hf+34q9zbGnQ2AOMsRU+Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4835.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1819bc7-ce43-497a-0371-08df13b709d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2026 05:54:57.4322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UnmN6Ww9RAYQ+rGGlgP+bAfmZv5kxtzcqhm5uYhixaoGRh0726owISPvWDJXg0vO4H+TpL9qBwjtkQLrdKBdDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6741
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, September 15, 2026 9:43 PM
>=20
> On Tue, Sep 15, 2026 at 07:13:48AM +0000, Tian, Kevin wrote:
> > > Yes, this already has to be true or our lifecylce model is
> > > nonsense. Once the iommufd creates the vdevice the guest is running
> > > and we cannot disconnect it without unplugging it from the guest. Thu=
s
> > > the locking can rely on that. Within an iommufd ioctl context the vde=
v
> > > and underlying connection must be stable.
> >
> > btw looks a related suggestion is having the tsm driver (arm-cca-host
> > here) implement the viommu ops while leaving the original smmu driver
> > largely intact, and "obtain the viommu through tsm_ops not through
> > iommu_ops".
> >
> > It's not super clear to me about the implication behind after reading
> > related discussions and what the "obtain" part means.
> >
> > Could you help elaborate this part?
> >
> > The old way is kind of:
> >
> > vdevice_tsm_ops -> tsm_ops -> tsm driver -> iommu driver
> >
> > then it will become:
> >
> > viommu_ops (tsm related) -> tsm_driver
> >
> > where tsm driver will fully handle tsm related viommu_ops?
>=20
> At least for ARM there is effectively no entanglement with the actual
> host iommu driver. The viommu is entirely provided by software in the
> RMM world, so it can have its own dedicated driver. In ARM T=3D1
> transactions are alwayus routed to the RMM's iommu and there is no
> relation to the host.
>=20
> I am interested how Intel works here, but I thought it was similar.

Largely yes. Main difference at Intel side is that TDX still relies on the
host to initiate iotlb invalidation (upon notification from KVM on S-EPT
change). Currently we put this logic in intel-iommu driver but it's more
about wrapping invalidation info and passing it to the firmware. Moving
it into the tsm driver should be straightforward.

Maybe there'll be other subtle connections to host iommu driver but
it doesn't sound a hard problem to solve.

>=20
> AMD is different and I suspect AMD will have to continue to use the
> viommu from the AMD iommu driver, but I am not sure.

ARM/Intel may support guest viommu in the future. So AMD's case is
a good reference. Maybe for ARM/Intel we'll stay with two or more
viommu ops: one from tsm driver (TDI w/o guest viommu), 2nd from
the host iommu driver (legacy w/ guest viommu), 3rd from the host
iommu driver (TDI w/ guest viommu), etc. We'll see...

>=20
> > btw I held the impression of blocked operations from past discussion [1=
].
> > Initial attempt tried to proactively unbind the TDI upon any operations
> > which may transit the TDI to the ERROR state. Then the suggestion at
> > the moment was:
>=20
> With this construction the iommufd vdev is created and permanently
> exist as long as the VM and viommu exist.
>=20
> How/when the tsm driver links this to a arch specific "bind/unbind"
> operation is more up to that driver, but I would expect what is
> thought of as "bind" should be the affiliation of the device's T=3D1
> stream with the viommu and the target VM. It should not be sensitive
> to the TDISP state.

Not sure about this part.

Each arch has its own definition about the binding flow (about 'how'),
but sharing a common step by sending TDISP message to transit the
TDI into the CONFIG_LOCKED state upon guest request (i.e. 'when').

According to the TDISP spec, memory reads/writes with T bit set is
accepted only when the TDI is in RUN state (except MSI/MSI-X writes
are allowed with T bit set in LOCKED but I don't think any arch supports
it yet).

So your definition of 'bind' essentially affiliate it to the RUN state?

>=20
> That is not prohibited, the TSM driver could do some auto
> "bind/unbind" whatever that means triggered by ops or tdisp state
> changing under the covers. But this cannot leak out as some kind of
> asynchronous vdev destruction.

Maybe it'd be clearer using an example e.g. ARM to clarify the
suggested split. Or wait for Aneesh's next version...

>=20
> > " But now the suggestion is never let VFIO do unbind, instead VFIO
> > should block these operations when device is bound. "
> >
> > [1] https://lore.kernel.org/all/aEFmPaYorqaYCKBY@yilunxu-OptiPlex-7050/
>=20
> IDK, if the host wants to put a device into error I don't see why the
> kernel should block it? There are many reasons a device can reach
> error, that needs to be handled.
>=20

hmm that's a good point!
