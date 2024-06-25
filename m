Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021D61BC2F;
	Tue, 25 Jun 2024 01:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719280429; cv=fail; b=CJZolHr3txu/dQJ8Kt5V5uqyL7/ZBMF8q+3PdIRQ1Tf14jPs/F9NgrkRi79KrT/P4kVsF70tUG79ZsTmspRMydZfqQ6MMEX4qnRcHnRCwp5Eql2+jS9j6c5zquOPEVNVrQDihC4B3A9Bd3uy0lQh9qtBgG+ntEr0VGu0P+1OmpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719280429; c=relaxed/simple;
	bh=rWnDCvMxvTu6sMtWN+t7ldweA8P1nDScvs6J9AdlfpY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XorvH2dZG+gLtFGTEDDsiXhIY8ti8gvii2TMNjh+tC/TKEP/dY7jVc/s251MhZnK4mOynIj2XSivSS5Bw8FIRoyb6wtC85V3BosLUtI0Iu4qsPDLe1q6ZKBjN18NaZc+v+7rhFsnh1O9EcHvwXTgBeYeWG57ycfF84Vu+9ET20Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dpOcD04j; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dpOcD04j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719280427; x=1750816427;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rWnDCvMxvTu6sMtWN+t7ldweA8P1nDScvs6J9AdlfpY=;
  b=dpOcD04jeGZ76/nowPtq2VgCrYCcGOAqMRLYUnrwLMnGvEhciCzEPc0+
   /0LDMV5iAmPnzAJdftWtzvpHavJTg9UHogoWQO4oVx3btPA3ceHPEdo5o
   M5LpmKKEHn1j7wdXUitoVpKUGZvsiP0v+YwqAn0ayYOsrU6cUTJ3PqBdO
   BEVOacdJTQ2E97iTfcYq2kap0rogiNqwYvid/W56/JtAlEK/6TWFk9wGD
   YBx+eLklVfXI4+F2D6UCEECNaf9IBlOH5HDLjCPct33S2Ak0CxFSN+FJH
   +uLLel6BzW1DwmOlSBN/y7crwLAuSOdubPnb3BdOSB5GEPqQZNYIunGdP
   g==;
X-CSE-ConnectionGUID: +XOGiJY6SNK9yQxKm/M6/Q==
X-CSE-MsgGUID: +kUJ/M4BSiWESuXOOxe5Gg==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="38789549"
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="38789549"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 18:53:46 -0700
X-CSE-ConnectionGUID: zSoYn5sfQlOMtgToB+nMwg==
X-CSE-MsgGUID: VXqBJeofSwulPfSA20RpDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="43297148"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jun 2024 18:53:46 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 18:53:45 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 24 Jun 2024 18:53:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 18:53:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kit9QGN1dx+3+X+Fv5aHtSKEvrvy1j68W2s/oLeDQZti9Rd6K6vXB8Med8516zXcEdmIjW4wTpKULr+L2MViDW+Y4za8Nd/PfrhpcNC62ICcTBJULrue2JYZuDq2yyEmIPVmvJGOBVLhFL7mHr+wWTjbbSn+mLYihj/uglbJKS9Sqr3KZaXGtW7kaZBGL9UR31UO+awAQTY3UhYeWQRZMuVDECaz5wYLJcf4R0IvH4x33RcvFzwyasMxgndE14NGwGkMl4rrGwgGYYg4v1mdaLmcEjjWW56u2RxYbfpPDML0/nVwr72ALcuKbX0wDDUb4CUnISu916lUmRWjxwvdwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxRYgqUx+3kkVs4PU414dk5aBI/UzTWiE4PxjG3mrW4=;
 b=FN3YWtO/UqXkZI0z5mQBcZC82fBxNXh6eF08+d3py3xs8Ux6T1rIV9H6YakV7T9trqkBJjCbX1Sk8F+Q03oCinlTTf+XZPDMw8fSRZZVblb2sliICNzbI9zMAexP7z5omHNjPaWnRlivPDxkv5e0GuQAslp08DjDCLwBX1ILnbw0ViCVDDkLI9UuiCZE/dV4aFrHbxensye2Pg8Ikamn6eI39OIcxOBSuxcRxlReY7hTRYx52vVTZLwYi4JfMIN3P8CFlp6uUGNS3tYicz8nZ8ygHuBlMJuAEshKGDU5VBsOjAv/Zmrxnf9m6RX1TQPfv8xcQAPQmKOGa93J8Z+xHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 01:53:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 01:53:43 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Sean Christopherson
	<seanjc@google.com>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linuxarm@huawei.com"
	<linuxarm@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "will@kernel.org"
	<will@kernel.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
Subject: RE: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Thread-Topic: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Thread-Index: AQHaWqKFGeofU1Sez0G/MdZ+760zdLEAlXwAgNf5sxA=
Date: Tue, 25 Jun 2024 01:53:43 +0000
Message-ID: <BN9PR11MB527662A2AB0A9BABD5E20E6D8CD52@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
 <20240208154210.GP31743@ziepe.ca>
In-Reply-To: <20240208154210.GP31743@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB6088:EE_
x-ms-office365-filtering-correlation-id: a71e1de2-d9d4-43a0-d968-08dc94b9a4b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|7416011|1800799021|376011|38070700015;
x-microsoft-antispam-message-info: =?us-ascii?Q?j4sM8pRXdsc80Q+4nAC2S5HfsE9xwvcV5VeMjmMuvjwS0zTR50qj42nxMVjf?=
 =?us-ascii?Q?CSDK+j9pYEvCfZil4kM29aJIl1ejdamjjfEynwxsQTOqf7AbQ3iHz3MHwWDE?=
 =?us-ascii?Q?7MP1E+C/dimTI2GWwbcPjW9cEXy7b2YfeVlOR/VRYd18cKUqR94MTPRmvS+z?=
 =?us-ascii?Q?3eN1aqJnxB6rK6k8giJDDXJMIJkJq5MWzftaaZjapoTQ/VjL+3uvP32wQHYS?=
 =?us-ascii?Q?US3tUzc2Rv+I1r01qvdhOBcgBMv92G+tZOyOW/krU99Hk6+QHQ0+lIjcPswq?=
 =?us-ascii?Q?Gx/zuQNSejzwprWLY3/AlxdwHxPfsIgL+T2p9Sv+b7jGl8JZcXPax4eq0unJ?=
 =?us-ascii?Q?ajnSyxDmc31XHqxO7PD6KsMTEColye/6AKtMEPK+E/zfIfuog2+yyxtBES+C?=
 =?us-ascii?Q?r35Ai147xsAptcRkulrc3kMspfOUoXf9hs4v4S7KBnOH0//G2ZdX9+gmecEX?=
 =?us-ascii?Q?uAxGcvoqHiJ08sJzWGsa8kq7N9bsZMXl0P1L37GSRsw5RnMOPRt5LjDC7Xfv?=
 =?us-ascii?Q?McAnxlOiyqy+bII+11ZCkDZC0x8LRCLnyDCz7AJaWs3w9f0T62bFI0OX+RbG?=
 =?us-ascii?Q?M0BjhM4n39Q9GG6wfjqq+BiUTldOKTB3CqhbG5dFOcoWMyFaFwe2Wa7SwXr6?=
 =?us-ascii?Q?UGoec8rsFgqqr738Sy8FyvItKNp8JhjUCzSQ+QgZGGRZmzCvC+/WH+cTqa5W?=
 =?us-ascii?Q?OZEIbv+7w9T2sLpdCR3WVHq3rZ3uW6OpwLr4gzbmRz1lRg40OKj+qPtr7YDG?=
 =?us-ascii?Q?oNi2+lRdVaFiRfBOjYPcuD1Fgsz3hpdnrd9ku27S9BzQWMVdL+x3g6F+ka6V?=
 =?us-ascii?Q?J286EWiRvqbSxZotqzWHI6c2Avz1B1w2PCnIR2DOyBpbXygf2vZeiuYZW6qX?=
 =?us-ascii?Q?HVBGrUnMPzen+z/tQ7X7H3tJh6c/E4/y+WZIJsSvUBc2PuQmd/Z8sPvQwZW2?=
 =?us-ascii?Q?pemhgN1RP9CgU8RyvIplQ+AlvSnrm/2pvyVdlySnN3y1IdpvV8Bj4jAKOKx7?=
 =?us-ascii?Q?yDQLkWMh0+5Y4V8Ttsrg2tknDo3z/kqDrueGsbBStHKynoz7hGwuVxZq+lIz?=
 =?us-ascii?Q?rZ6rn7CSAS1/DKhz0R+V+7hHDUgdnjUZx3VtenyvF1gCQ8YrjvHqApLTbW3k?=
 =?us-ascii?Q?FastgPrOBB2pyG18wk6OMpcqXSk56f5J/OFg49QotheVlJ/Yn1psTfnRmcn/?=
 =?us-ascii?Q?90rPGFZvPG3g/jqYUngRQSenR9oAtzz3qwpxYwEGOJVhHMspbNPdjBp3t4DJ?=
 =?us-ascii?Q?w1bnElIxD7m6TLXq865dWA4a3DsrymogEow0xhsHwqhbREa95B+19W2Ip2jH?=
 =?us-ascii?Q?Ze/9bC4ShWiiyi7K9EVJN8ZUD3IRiVpG2j3rf+WQYriTr+NbUlGLd6a+ihR7?=
 =?us-ascii?Q?+mWma2g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(1800799021)(376011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vTnuzgI6jWrJAEEs9rxTg36so0ZDxVBhg3ZHl3bnN0Hg7jwhwja5O0IwSESw?=
 =?us-ascii?Q?x3trQdMwuqbhVT4p6A3iD189z7lwm7yxvPy/HLr7TGBfILlbvHa3jYvfSgsI?=
 =?us-ascii?Q?dxJCYQHWZBWqX0w+/2pTsokkoZRugWmXd4WuZ4dGEFHDqu7ukFw53/zFqlhJ?=
 =?us-ascii?Q?Y0mjClN8ok8NlzxgPWc3d/hwwSCNPPNdD53I0CwD1pslcZL85GW3NDXG9ktn?=
 =?us-ascii?Q?1lskWIOFpH1vK9Kxm+bJ1Ios+u3afSaA0T/BCkmPNRLqhUvxXojM6UI5e1BJ?=
 =?us-ascii?Q?8xqbmks4xOzgVN5k6nHZL2+oZdBaOVsRQ+JeF7CGgj0I+auyvpSV8kzP9peX?=
 =?us-ascii?Q?uTPLS9JeqxbQlDMVwrZuas2G1l+hb9lsvd4mqnsy9CvN0oH84jR7vnFkdHXW?=
 =?us-ascii?Q?PU1dfsyJMdD8nTwptB4LyvT8hNCBUnHEkOLzPHqqOERZyTLiRtsyvqfTtVW9?=
 =?us-ascii?Q?MLnbKPEy/yaPmZSSRqhHgDIa9mS48hI2rSviVTfCbxpzVXE5gl0nxAhwT03S?=
 =?us-ascii?Q?TUXn4BJcCjltgBY1/NGz5DzB3Ru1K9n3//4mtMnU7WKzfa6FWs7aasafmwHB?=
 =?us-ascii?Q?AbpWE0d72IWbQdeZR1qbpha9xExOsXuhXZhkT0CXL0sKBwJ4pkqZT+s+gSC+?=
 =?us-ascii?Q?cwC48/K2aMxnZF+oGit4hDLiiBKgXNto/qnpwkK6mh3apoO5BI/+btownTDY?=
 =?us-ascii?Q?X0iLKl7C2mG7AqrqGQ/clsDR1RVKoA2C+4/gsOoBFq2NvxvzAHCN81shyEMK?=
 =?us-ascii?Q?ZuhiziBxlidiWk+ywgIEQCy1uC51YcYPv6Awy9Yyz1cnGXLlJWBWxg9rBW8W?=
 =?us-ascii?Q?1SwQ6q99C7ivHjTQdtQgYlDq+DGgoiyGcLPIrynIWTfb3Ls5KhHqrvVpGMIj?=
 =?us-ascii?Q?JTThGVxnRaiTlWNekf1ZHg8CQMFm857NHtJLZIfr5FNyu6jSXbPx6wGGgpU5?=
 =?us-ascii?Q?0dGTRlJ/TjbKLEJ8knarxcJufSrmVkmiCfzL3DfxUCa1jxzk++geQDfE/8Xb?=
 =?us-ascii?Q?CHsmvwYKQ3xEfzlJeii8HyzSX0zOAiYzXpPKgQYDvIAaGkyMF0oEQ91ij2J6?=
 =?us-ascii?Q?cHGQcXenZgGnSkDeBbL0/rGMFR037ddHJ7lYrphodv3VMrqsZhotvBnU448d?=
 =?us-ascii?Q?ehNW5DBcnrMmA1MJVt9V7Ucvu45x5FB+ZSeEiLU9ZE8HSukOUbDeStwtdIiv?=
 =?us-ascii?Q?mOSIy0OxosUPV/G3Bg3wi9cDdRq2nORcAZAv28AQoSw3wPxP+3vHG5VImY0h?=
 =?us-ascii?Q?UkW3LUzU1slE7HK+I1xrZmIAKp988Q+EuEdd632k4vC4OWTTVOQBaLticj+l?=
 =?us-ascii?Q?TsDSMa6c32lUV0U6lSQjvxvGSlanE0/6H37dzHTYSzI7iPEtz0vZ8uiPNeZY?=
 =?us-ascii?Q?Pb8d6zo6qRiUQCwjSsrS/BcQiX1oQcsGZ6Fj2stVWQHqzd5J1BrAIuGvjDky?=
 =?us-ascii?Q?CFJMjLgdgr8gFoaHY1fIYVWqHW0yAi9xtAEzQnTkkeDw3GsxgavT4bEj+gdl?=
 =?us-ascii?Q?vRQ1MinIltyli5m7LwaziMIXHrR9gqyI65G2kv8mI1gMzH/trTPDbfy9ioNa?=
 =?us-ascii?Q?+3BdHSS0ovZ0sm4iXzD6wtR0btwxG9QF/tGOyKEj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a71e1de2-d9d4-43a0-d968-08dc94b9a4b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 01:53:43.1436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lpWdBY7mPmJzY/sYyHqvaUkWxRoK6xgRs7I//W75IuCEM0ljtCPv1QbcEbl7IWRDxuXHHKVBFHSVQxUonuvPQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6088
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, February 8, 2024 11:42 PM
>=20
> On Thu, Feb 08, 2024 at 03:18:34PM +0000, Shameer Kolothum wrote:
>=20
> > diff --git a/drivers/iommu/iommufd/iommufd_private.h
> b/drivers/iommu/iommufd/iommufd_private.h
> > index 991f864d1f9b..28ede82bb1a6 100644
> > --- a/drivers/iommu/iommufd/iommufd_private.h
> > +++ b/drivers/iommu/iommufd/iommufd_private.h
> > @@ -16,6 +16,7 @@ struct iommu_domain;
> >  struct iommu_group;
> >  struct iommu_option;
> >  struct iommufd_device;
> > +struct kvm;
> >
> >  struct iommufd_ctx {
> >  	struct file *file;
> > @@ -27,6 +28,8 @@ struct iommufd_ctx {
> >  	/* Compatibility with VFIO no iommu */
> >  	u8 no_iommu_mode;
> >  	struct iommufd_ioas *vfio_ioas;
> > +	/* Associated KVM pointer */
> > +	struct kvm *kvm;
> >  };
>=20
> Associating the KVM with the entire iommufd is a big hammer, is this
> what we want to do?
>=20
> I know it has to be linked to domain allocation and the coming
> "viommu" object, and it is already linked to VFIO.
>=20
> It means we support one KVM per iommufd (which doesn't seem
> unreasonable, but also the first time we've had such a limitation)
>=20
> The other option would be to pass in the kvm to the individual sub
> objects.
>=20
> Kevin?
>=20

I prefer to not imposing such limitation. Passing it in optionally
to the individual sub objects e.g. hwpt or viommu makes more
sense to me.
