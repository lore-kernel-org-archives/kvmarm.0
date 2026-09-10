Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857D62DEA89;
	Thu, 10 Sep 2026 09:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033953; cv=fail; b=rWbz+bzWaWV6+5j5dBzBn+j0EbTLXHQonwkkaToYHCe0DFKbGxcLG/3hUe/Irnd6bXCVFXz0Dn7VdecIH4sh3PREJud/eW/hfqn0LL7+MIkzkPaB2tRDoCcXvywgXAg95Jj5Jsasw9lvTRMEPZgWonjCLJtLGilxVymiOcS/47g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033953; c=relaxed/simple;
	bh=cwuDeSs6O0WqbtwQDRJJjDgxSv/p4Py1x8HnuY0KXhA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AwKU8KUSlNrCUQ8kUwU3P4HWL6NwzpYU2TuBs2r3xpNRlTCRHooTGx+m8YSsIGbfGcK+jA2WKZ5TC3PcTjnUiclg/7ez89QN5lQc/UeWpwXgSfxMqrshLOzlu3hVy2gY5lieg5dbM9PKlm52yuozkzB2ogduBBPD+Ruy7t9jZSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nsqp0zTS; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nsqp0zTS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789033952; x=1820569952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cwuDeSs6O0WqbtwQDRJJjDgxSv/p4Py1x8HnuY0KXhA=;
  b=Nsqp0zTS6OznNGcoVu8rfE0O/dceJYfIP9+S3TaksqG2pWI6mlmCHjbj
   xwLCUe38NyKYrEFya+GqkIy2pUjNvucFcZsqSPXR0A+qDzlhEhLC9gJb4
   O1m+xXD9p8JkOLSMd4LAlqDyMRRO7N+tNGJenBvRcAb/TmXlnW5SGH0GE
   3kpw/ROPzZUgiUmlKXfJqWz7HfuHlzcBKuKNxhvXS4Tsg8/78yoKIgPMP
   Hpfzdod7BfIuS+jf1JOIkt7nI+UPdO+RwmZ4z11+qrhDkevoPHYYwvOEz
   nRDDMglrRFDxQ+4J5p9mQL/HFRbU0O54yWZz/7n9zs0uqDaJ60kd11W7W
   g==;
X-CSE-ConnectionGUID: BnwyujgqRU2t3vDUl211fg==
X-CSE-MsgGUID: C5piu5edQuGvTNxIZieGrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="106848542"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="106848542"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 02:52:25 -0700
X-CSE-ConnectionGUID: M3ag0ds8QqqFEGSJhD8ysQ==
X-CSE-MsgGUID: hbSwkrdyTCe2eBcSj8r6jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="276836653"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 02:52:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 10 Sep 2026 02:52:21 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 10 Sep 2026 02:52:21 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.3) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 10 Sep 2026 02:52:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RXKl6Am61R3rqm0qyMa0FT2Vm8A2/sAjfbQWWv4/GqN1GBFvPM0q2fj9An0F4vz/k5RojnFjbd6ScSlkql3xWUd9PlV07WXQkCR2FQX+4gVvL1QtwAXkVEphR8EMKLjRBIk9TJHeaNZaOQ7b04ghOomhetZj4kXRm6GhQ5hFEHUvQzvU9cdsBqRfyC/S+VJOaq9k8pao4nCDkLcqc1vHKkeB/wOppLQs6sZd8Xz6qABg/U0otXQ7CcMNnI1EM8+sdGaLIDL68EEWRG1OGZyYtxWUSbhdJcGTHOgEPYdM0bxLgEH72HNsQAd8aMgFOfhoa6PWioz/WmDEe0QKunkMsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gb4mhiu0dcnHqvgj3iouuBiDnBtWxTtZaBv5Fc/fLc8=;
 b=FuIblAO5ZgLbs+nVNAQKbJyDmmZFxSi8ixgcwK8fyxDEbCiC/RLnPywZAlBaOmbxrEbvvjEvApK5gM6SFDut7/Fx6HCxZa4CcxHaYD2CT/tv71y+5MNXGbdduJHIhc9fH4K6572rpn/+OdvF1TvxA+/ZnSfQxAB9+TyMUNyjkZcOoJy5mTZfmft+r/WKkLQOFhlsxJjhP87E0hCOqDsZ2Om7ILNV1QyAN7QFTf5Ro06m+BV1YrEVg7NpL7INTX24Nvoasdn9in0q9jF11P4u37XiOIQYD6IVCbynuFhyXLKVlIGL3th6SxE81VNb7M5gY1joXdi79jo+BdEdr2CXpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22)
 by CH3PR11MB8657.namprd11.prod.outlook.com (2603:10b6:610:1ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 09:52:13 +0000
Received: from CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225]) by CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225%7]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 09:52:12 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Aneesh Kumar K.V <aneesh.kumar@kernel.org>
CC: Nicolin Chen <nicolinc@nvidia.com>, "linux-coco@lists.linux.dev"
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
Thread-Index: AQHdN/EwiLvbaU+6lE2MX0oxJV5il7a5dWsAgAAN2ICAAErrgIABNM4AgAA3CgCAABBnAIAAON+AgAB6EYCAAGKGgIAAwE4AgAXLI4CAADRDAIAC9yOAgAAr2QCAAS/H0A==
Date: Thu, 10 Sep 2026 09:52:12 +0000
Message-ID: <CO1PR11MB4835512E374074A5F4AD0A6C8CBF2@CO1PR11MB4835.namprd11.prod.outlook.com>
References: <yq5a8q5kkoz3.fsf@kernel.org> <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org> <yq5aecfbzjyk.fsf@kernel.org>
 <20260902235609.GG2890729@ziepe.ca> <yq5a8q5izxz4.fsf@kernel.org>
 <20260903171704.GK2890729@ziepe.ca> <yq5acxupjsy2.fsf@kernel.org>
 <20260907125228.GB667892@ziepe.ca> <yq5atsnyag84.fsf@kernel.org>
 <20260909124628.GH2543240@ziepe.ca>
In-Reply-To: <20260909124628.GH2543240@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4835:EE_|CH3PR11MB8657:EE_
x-ms-office365-filtering-correlation-id: 45778814-e4b9-4764-609c-08df0f21304a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|38070700021|4143699003|6133799003|10067099003|5023799004|11063799006|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info: vsIvw5j76BAI19xDZqr+6Id2yooC6nD8zkuNr7/+SXUMq13ZkMlxBIU/LgnWCAI6SN3HxplBwjkjJla6mVqakHOFisfvs92ibgUI8uabjgVMjSdNflxOWmBPfr8L+ABBigQs3xJ3FSxJdODoov4NSqiKk31nMofzjoKZOrxwB1hhrJX5IWZrzEc+b4U62cmrFt+IZ5HBXOYzqazH9Jebe6qjEWtQIKSwsXWJH6ag+EsY8fQXedsu1tAAjH0g0N0YyFegMcB8JVz7F2dTDRimt3PIELMBoYfNLpgTX29q/0XfPNhApeR8ENxNAo64PDnaYFGXgvUTCns9MGtqoPe8qsv+i22PVb8aXa1QgS3uRxbEBCDveIWq+AP033Gdw53sqxjJfHK90kcdJdojL6CDOzXt2laHIBrspaLBdoNTr5wOMUnAJ+NNjDhy5l/fC5chE4tFaxeGJ1oVYXc1xWQTfkMruVdVvkAxCr9OWiu/pdq76tAPwUoOW3zpdyA5mSnx9y9wgUI/GrzqSarvFc8fw24YH8KEztKW+bFWKFKaZsFXegeWgm/gVWdDdvitkwzKZMiHsTv7BUGz9C13J+o4PPlW57Jwds09WkAhqBHiaq/iTn3gTaNR9GIKuk3geK19Z/z/rAWqXnSQHnpUP/A8H5vbWwJaRv8C8+aV2qnaPY9RqTmFzkTcpIwmiR1FHIegnya/fLY+GKVIRgM8tRBglNDntcLBRP64+mxiHFwOuyk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4835.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(38070700021)(4143699003)(6133799003)(10067099003)(5023799004)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?08bc7nFSqTcnuVDe/3nhrnHBCIz86ZKlLuQSAtR+f/Zf+LhuKbTDb1UOfaxd?=
 =?us-ascii?Q?WGbDOhsjkViNK3ziPWp1DBpWznvPvIhgdxAGedPytVdiVUh+wfr3q0reAcVe?=
 =?us-ascii?Q?Blv5ReDhNhh4sGfBGJMm1KqDy4kikPrsNccfl1DXsxmOrgjTcYoLYqrXEmfZ?=
 =?us-ascii?Q?LPVnOmctMBTAvCptALDMSO1kxZfpWYXMiWJKmwWksEwWw8BTkXM8O9ucV7Jz?=
 =?us-ascii?Q?MKbmNLRQ2trXhSUG/TejFPAbkNizgMjxlwTUdn19yY0idr3KOGtxWsAogsQe?=
 =?us-ascii?Q?lFOjt0Pizhot7NUAEuoWfWdhP5s85Ych2gHYd83OMaKJ9yn1S/0RXm7PYtjr?=
 =?us-ascii?Q?rwqt09tFwj1NDgCJFiw8bv4J8HhQq0T4v92eZtoK66nIfJPxsUmXbcQCaXK4?=
 =?us-ascii?Q?TIdHhs/dYBVyKNipdaSR0+lGRS1mXXVTsSYN00ROWp0eNYgcqdTB/S6O74ph?=
 =?us-ascii?Q?U5wQZoNtI8ionAlkrsDZLPjDGUuWZBphczyz1C0kvegJcp3cLW/AoO1Ui9lN?=
 =?us-ascii?Q?MUskTlJFvGbK3MUXe/fqVL4geI8ilHz3wsGBjwRXR6RH5NwS5LadnlrNcllw?=
 =?us-ascii?Q?b4x4qyx1xVa8t6BFyW6QDikhgvHfAHGt8LMEw+7Bu5y7xNDE7MJombwafpuV?=
 =?us-ascii?Q?321suHnX9EH1pdLhUWkv8JmDrl5BiKIU8kNCEg145j4ZODKUZAqqpvg+HPHE?=
 =?us-ascii?Q?OiFuTUeiNEDbRTAvyT26wx+X4GcOjuOv0OowhQxHrHYd8aJJqb9g1fcqfozV?=
 =?us-ascii?Q?EgmmTJ53z9d19ezeE9v16VqowxKVS32f4IMn98yNzYQ6bmIaSCRTLevmgItZ?=
 =?us-ascii?Q?bMOezg8J0Z8qQVNkU3uAgSEY/nf9CMMxtcVglMLu/dHQ1cz1t2wTk4BTMzbc?=
 =?us-ascii?Q?65h42KjpO/EgElUxBN55w72RrdGGyOz1tBxzlKPl1QkcHDzoXio+ESWUhrDj?=
 =?us-ascii?Q?T457Ubfzwt9xTr3q3vFjYU8ArC2gY5OIPXU4MMaZrWijiLHYMn2laWWMADbt?=
 =?us-ascii?Q?pIqIwbiwX8eDhlTF7h+A9oMmN9LrBsWfHH1zv+n/F3x1TQJ4gD6GUnSGFHti?=
 =?us-ascii?Q?DC14pylq+8BpKCHZx4uxAC4o9fXjirsDgH2VFjsxAXrXcCT1OJShU8lrOV12?=
 =?us-ascii?Q?aWWg2HH6CCVfx3PqcfQG+/+dagzDyuI/xh2tQo3n19AsU5FyB7tW3HRIOGTb?=
 =?us-ascii?Q?BtTPNd6svWDM+homyOMhY9n15kH3ULzHM9QSzsi62IyHC2qonjZcAIi72Iz4?=
 =?us-ascii?Q?Ibvg/amqYa6urLXeAKsINJHTfSVYb1SUPDf+VaaGRpNfrSSPqON7BK2lVMNT?=
 =?us-ascii?Q?LLAf1XJ39jmDfkSknVc/p8ueyNrDlDcKQ6OoQgavZOhTiynhaDVqW0Ll2Tty?=
 =?us-ascii?Q?9IKqp88n49FWXdsK+mgov05mZYP1PrTwv1cAuLBtdrTczmHM11unraB8Bq/d?=
 =?us-ascii?Q?Y4kV8acat609oh7IF2iMZ995oVuVQ/JthWv1E4eSgoDHzoBQeD51/OwVCuHB?=
 =?us-ascii?Q?CZkfVgDCt8jEc/Wi4ApSkx6vJmXd+feVYXnbCSbCVBv26vM0x53bsIWAcF9v?=
 =?us-ascii?Q?rDh2iG4JCrEWmQL8GbI0BBeN20hn5DYeB7QY+P1PjJrRoxUEAaL0xnjB+Dxg?=
 =?us-ascii?Q?A3GhiPzFHP20X7SMvecPmUNiOsUv+QF85PBt8ly9K9TAjHD5xYkrGYllQ03j?=
 =?us-ascii?Q?FpBq9Ln6BDtotNNvN3zevJW/Ds/OaD42SLWlDeI01wMBJH35?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: bWQMGJznY2Q4SVynstEjvBgFf1y+nDsfaNNfmVkh+lGtG3TTIRPYGgg/oTfF/OwIKOMV7uvVxTfZw0ws7Pz4/o7FO969bMSojgw13oHif76iW12dUw2KXIwwvsa2EQ7wFmErxlyvt6NDH47gc7IKMU04d20PPR9oCkmI5imaqfjsSXxwQyKWtBSxg1bsPUYiG4fBpGybdX+HENtslKIsVULZAMcta1yvdoVk1y+38yRgSJi7rf0qtnBdDtTerScbHn/U/8xAj851+M3PUUuay394PTyp2IOuouGBMQUXrWidKCuLhPUg+ox0225+U8WlVz0piKcyH8e78ILwI5Pxdg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4835.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45778814-e4b9-4764-609c-08df0f21304a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2026 09:52:12.7953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gu3eGyjH5wy6UzveFEbmU9bFjylOUozPZt3tN3MrVUQPPaax18o1qjqsL9cL0khL34kgKpo5ncoGo8y1+XCIhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8657
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Wednesday, September 9, 2026 8:46 PM
>=20
> On Wed, Sep 09, 2026 at 03:39:31PM +0530, Aneesh Kumar K.V wrote:
[...]
> > The TSM disconnect path will now fail while any vdevice is alive or
> > active.
>=20
> Yes, that's makes sense.
>=20
> > Destroying a vdevice will unlock and destroy the VDEV.
>=20
> Yes
>=20
> > I think we can also unmap its MMIO mappings at that point, provided
> > we track the mapping requests in a list alongside the vdevice
> > details.
>=20
> The mmio is owned by vfio, there should be a handshake in VFIO to
> remove mmio when it becomes private, otherwise I don't think we need
> to do anything more?

for TDX a callback in VFIO is invoked to revoke the dmabuf.

btw I didn't see any dmabuf related in this series (even in a hackish
way as Yilun sent out last year). Is it not required by CCA or just
skipped now waiting for the framework to be settled?

>=20
> > All CCA operations will use pci_tsm_pf0::lock, though I think the
> > locking can be made more fine-grained.
>=20
> Sure
>=20
> > I will send a cleaned-up series so that we can review the code changes.
>=20
> Does it seems reasonable to you? Was there any oddness with modeling
> the vdev/bind through the viommu?
>=20

Try to catch up the implied changes to other arch's...

So viommu will become the abstraction point for tsm operations and
directly talks to the tsm driver instead of going through the merged=20
tsm_ops (bind/unbind/guest_req).

currently what tsm_ops provides additionally is more about synchronization
with connect/disconnect, otherwise just calls into underlying tsm driver. A=
s
long as viommu creation holds a reference to tsm then disconnection is
blocked then it's safe.

Is that the rationale behind?

and IOMMU_VDEVICE_TSM_BIND will be removed. Seems originally this series
does SMC_RMI_VDEV_CREATE and SMC_RMI_VDEV_LOCK both in tsm
bind op. Then the proposal is moving them all to vdevice creation time so
no separate bind step is required.

Does it mean that ARM CCA is essentially an early-bind model i.e. the TDI
starts in locked state from guest p.o.v.?

but https://lore.kernel.org/all/yq5aecfbzjyk.fsf@kernel.org/ seems to indic=
ate
that guest_req() still handles the bind request from the guest:

"
- cca_tsm_guest_req() now handles TSM_REQ_SET_TDI_STATE requests for
   the unlocked, locked, and running states.
"

a bit confusing, but maybe due to stale info cited from different timing...

for TDX we're currently pursuing a late-bind model (i.e. TDI starts in shar=
ed
state in guest), so a separate bind interface is still necessary. We could =
look
at whether it should be an explicit @bind viommu op or carried by=20
@guest_req (say, if most preparation works can be moved to vdevice creation=
).

any other suggested changes to think about?

btw per past discussions VFIO should block some operations (reset, etc.)
while a TDI is locked. Do we expect a callback into VFIO to notify the lock=
ed
state, or require VFIO's own interface to place a cdev into a special state
which prevents sensitive operations even before binding it to iommufd
(and allow creating TDI vdevice only on such idevice)?

Thanks
Kevin
