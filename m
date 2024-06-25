Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D09811CBD;
	Tue, 25 Jun 2024 02:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719282073; cv=fail; b=IxPOmR620fUieiDqKyqcdoXSBUqyYQrSgz04q/RK49W/lVqWQZoQFg3NZrwS2THdp1XUjX/awk/3FEBeDIfqRl1jKq/r+Nl8KDGW+Jr8sQPj7sJONRcXQnhTwhAn0AXFqPD9RkDDtENb9qVj3gQs2C/3my+r6eBFx5W1gUdwHgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719282073; c=relaxed/simple;
	bh=bGXN7uPZx+hAoyXJMSF0GeawKVR+QZfS0I4Cf3Q8YyM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jbru+UGl2r5btHE6S+Q8xr5vZBUusRCYeB+80nGzgnZ0EVUMmbrHf+Cgp4lj59QUDxjwOtPC6noDCEljg1wvqRS8yCN/tISffgD0cOKUj7iPRAkPIaK1WL37QUaK9c48GR561R3lpcZOEtKCgSs3Om+/KXN00QsMkdOb4lKJEbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JFajHp4P; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JFajHp4P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719282071; x=1750818071;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bGXN7uPZx+hAoyXJMSF0GeawKVR+QZfS0I4Cf3Q8YyM=;
  b=JFajHp4Pa2dxEtYGpsQMdMztz951tICpHDAuMQOAr07/RvCF11F0HRy+
   D47p7p/fEARamGL/Y697zjI2THU4+Z4JD7YpFlf9j1vG680EoHl3ZiEBL
   Tus32sDz3afv5/7gKh9Wq7QyXJGJF+PfK5LxRHBUJY4XEQr6V1PssLzne
   btrl+C71GB/48ADBZuQ5KeAa9gJBqiDSWgKicM5WHwkQxWWZ1vaubxUd6
   Aw17DJCuWN2x81XQKP07cEGbeXH41Hv1MUpPV3KEOMcG/vKH+p+qJjT1x
   q3sKneZY8FDtrUWobikCC4G+j01SPVuMQPiMySozfXIhMt8XVxvMqdv5S
   w==;
X-CSE-ConnectionGUID: aj3PZa4iQpKQ6z6vA284dQ==
X-CSE-MsgGUID: fNf2UT51R0+/DS1keP//xA==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="16422306"
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="16422306"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 19:21:04 -0700
X-CSE-ConnectionGUID: ZdwRHYihTkSPLpIYV8mISg==
X-CSE-MsgGUID: JI+oF0D0Sjao4K+I4zgMOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="43562827"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jun 2024 19:21:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 19:21:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 24 Jun 2024 19:21:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 19:21:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsnfGn8Lb/a3peFO3yGZu2L1Gu+Bj484IEF1Ym6fF6kDTm8fnaS3+MqFfzBRAoVQVMtXeJYd8w1ODXvxnBBeLXb1vUb/y1FqXH0HpwICrmMfFWXLMcrvpdzYpzpB2WNd/oMidIG6UQI8vkXNFaO+FZHawhFfB5sWpU6uDINaohsr5dVjEk21yMyO4EFxDF3GrVMk5OT0+/xGjIgnfByXKjt3KGmYTJCBpKZ7xi5fKtOhIpaYmuIvgJc0x57bZuce3+COOsMTParkz8UAF3EhIjDyypuVAn+EMlIExbUO9hnsDCgTTUdmm1rE8cnGhF69/UcoxWvOpFA9r2xQXXJWiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5hkxyBg4Hu28eHywm4/VBhCcFF25KCD4Ew57QUjS4M=;
 b=S0Jc+hsT0z7DXOhGdDMzG6N5RyXk9rhCTqAEyhQzqBfSGeOE2k+uhWVtjKg7xVkxsoQ6bVIZUHcuvdWANb5czWZMpfTCIKHYDnYe/XE5Y7NjIjrLurGDQ+8W+gQ3NsAhkpmegiexTI0KijOHrEeNKB0fqe4VREZgQEtWjocof9xKao11FBW7njiAYUyrSALvXU217bqkntOeKuB5YdIqZdAcTehwppHC5IbDtu5Qfs5Q0Zw0vZ7Qa6YHFr6rGINdJtPDSsWMcLkFwV7Bjf2LQ9dCpAGgrilCkrc9kHO3bJt3b8t/Tp73mAiAhVREAmm/u3TP5G8Q6AyIWzTrZ7MV3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7354.namprd11.prod.outlook.com (2603:10b6:208:434::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 02:21:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 02:21:01 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>, Oliver Upton
	<oliver.upton@linux.dev>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linuxarm@huawei.com"
	<linuxarm@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "jean-philippe@linaro.org"
	<jean-philippe@linaro.org>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: RE: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Thread-Topic: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Thread-Index: AQHaWqKFGeofU1Sez0G/MdZ+760zdLEAlXwAgNdjMACAAAQhgIAADRaAgAACAQCAABPXAIAABI+AgABvrjA=
Date: Tue, 25 Jun 2024 02:21:01 +0000
Message-ID: <BN9PR11MB527632A1BE23BE3F8165A3B78CD52@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
 <20240208154210.GP31743@ziepe.ca> <ZnmkbOfWBJHrO2sx@google.com>
 <20240624170747.GA1515249@ziepe.ca> <Znmy3QPAUIX9SnGx@google.com>
 <20240624180148.GV791043@ziepe.ca> <ZnnFML-P1dzHdraI@linux.dev>
 <ZnnJA3ueCXsDtyB7@google.com>
In-Reply-To: <ZnnJA3ueCXsDtyB7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7354:EE_
x-ms-office365-filtering-correlation-id: 5855a398-b1dc-4404-3f85-08dc94bd7528
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|7416011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info: =?us-ascii?Q?faT2znuHhSAvSpSlixiin+2QIMUu9zewgcynVpBgKJWj6KWDN2W9Z6sKmWAI?=
 =?us-ascii?Q?qlFSy//b+ao0LFX2A09sqj9L2LtT25BbJjy4NmRCR8Pw9sFLolz5xoiO0uQr?=
 =?us-ascii?Q?xV0LokKruhiONcjsUa6/1b+f7DAg5LTLFh7etFcJb/7t9bwV2oSllp+s6UVR?=
 =?us-ascii?Q?ChT5KDNwjYH52LMCU0j/QvOJzZScDglwRDhb2D9sRWf6mnFX05/gmwINh1BB?=
 =?us-ascii?Q?ZXEpwufkfb681d8I9T9LSHvHAbvZkGm4f3WxbQYTLIQeIsd4UaOEOyUMaoan?=
 =?us-ascii?Q?3pmFXm5cnG53b4JfnUyIVIYskRXp+/NRa7Tgc2UbW77ut9navMMWfBrEhmOC?=
 =?us-ascii?Q?8GwG8TsUzLBVxsse3m4UoK1ovU6pkjxzsOKkghcg+dQQa13tKz4tmcsPf8tx?=
 =?us-ascii?Q?wsjt3l2jZGXVh6VmNNP8NXhRds1EORGtkJQSBby445wwlSdzIp89UDu0/lWR?=
 =?us-ascii?Q?Ss/bVyOLR/xbYbBT3bHNXhHEepG9KlaqEWFQMhuPeyNshNga0pODfzPKIeG3?=
 =?us-ascii?Q?6pYNwV0BlNnjgKZU4dbL5C2Q7YurrqNrUG61PT4WnmuIOIAzDABdnbTUA8RA?=
 =?us-ascii?Q?2pQFkdHfFVf65GYwCdi0EeXQKIIog4kRUQ8LwsFSdyMJQZJZ0lnk1kGV8Xee?=
 =?us-ascii?Q?OPP0UheKgY1ixwd2/kygbgSrNVRVSRuDUxk4L2g7FxWYSdl+a4xXHIRRbAxe?=
 =?us-ascii?Q?pulJXPo/huXS4uCJR717KNIc88Q0Nz8toGeKKxS9jIT91CZoQQHtVOA50s9J?=
 =?us-ascii?Q?xeW1Mefafu0dUlZ/QpWuyPu0V6YKik47l8vI376Ydm1R/F4Db4AXOZNmZrIp?=
 =?us-ascii?Q?Ljobz3oCmHx3CjZk8GzTlmNlgeI9KnD3nj016yxVhjqG0N+P7NA0xWgN5sbj?=
 =?us-ascii?Q?CjLgDGkysdAzoSjPB1B43P+lJdWbDUK4lyEKshs5cu8lPu1E2BgybVqH4yN2?=
 =?us-ascii?Q?f/UAdbmereaKcCV+h1JkLISpg9vujlTnn1YY4zp4yGvToGHOY6YnbuvRLtwp?=
 =?us-ascii?Q?IVzxUmKftFQ+7WpYVLOMZU0Or0IKhjxG5lOZ/AVqxqIkjRcw76jKuDzW38lb?=
 =?us-ascii?Q?bkEr8KKRtQslFNTGSnFt1HG6kEn/hOLacEAnOtkIG1t5n2rtIVHu990igGNp?=
 =?us-ascii?Q?hGkR4ahURY+fmh3esi3DytafI3krRGwO17lyY2Cp9ADGj9a2ypVVJmz+lZVr?=
 =?us-ascii?Q?4+l+cRLDS3FppYC9l56+4soYMzLC/huBEqdcQ/bMx+AIjjSlEygbVp0pYhxW?=
 =?us-ascii?Q?Q+qZSXv2E/7t+yyP+UqScRMyB2cKLUtlq+Zcr8WU3XRMCd6jQ0Dwb94MLLCq?=
 =?us-ascii?Q?8zzYMnBXhqPV2v5+6AyXZWxrPN+fCPojmJItxQ/Zha7WAC4cRx+GPY5Veyvg?=
 =?us-ascii?Q?UntnB1o=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ws+gFMN5krShkmTh9KbESfxje+ZfWcVfD2+JOH3kU5rgL46hfK6D/WIhMgU3?=
 =?us-ascii?Q?1X3DjDo7axwG2bJJ1R2LbhBH8aR86NW4qcfeuvzcn/u5tVTGWddsPfhIGdCE?=
 =?us-ascii?Q?Boqr0ChIdTAhzyFCTZK2fq6x4slCJfryrxZnKPTbpG69DXuUGbQSJubbP9ha?=
 =?us-ascii?Q?M+j/wa1BXuZdNyIt4sEN2Ws7o4CAgVxRD9bt7IhttfKi1V4KBGWhlnjKW2Y2?=
 =?us-ascii?Q?u4cMgMW7FWsggUjLwK/xclhtjZysabDVA+yg7kkb7CC98/ATiBp+kGdY8dKa?=
 =?us-ascii?Q?youJare7txjk2dQTFM4EmJq8OZItJ460iUN6FahpZr6MlbSWZ+M+Jy/9Mqr9?=
 =?us-ascii?Q?jOieuJt8aJSVxrdWKuRUcMpfJYrihML7W3Ycce77N5RtI5GHvswUl3En2mJ9?=
 =?us-ascii?Q?l0hagMaO0Kv182CdXfBUuqBIUiKdWjWGjIsqeVXZ+4/6ufddDk6UPnIomWbU?=
 =?us-ascii?Q?qwXdhPJbX3/I/2YExiFN//M0Xw8C30GcLtqdVIF4QJEMS9mmEd8Y6K8+00tz?=
 =?us-ascii?Q?1yfBxc+gUF0lFueJshaMgLBVceCPoYOrmarrAyT0dRvRtKK8RsDg9HOzqsp0?=
 =?us-ascii?Q?v1RITqK2Jt+/Ij3QQrGphlUEsXdEk5xGPl9VwhQtMeiKncERaM215QPdl3Lv?=
 =?us-ascii?Q?pdefl7ARLg/Sf34TJ6J9N9E9HmIzfm1OFnIv1SkSud6yIUx4FSxR/+yWT/k4?=
 =?us-ascii?Q?niao43vtsqhC0Kz1GkEzSGjZM/5E8a9SsUjvLgDSrTA9prUCsHrq0R9PnLo/?=
 =?us-ascii?Q?zYVMrZOZKYvltjolULwrE83+Z0YpY9q3WSGejTUcWCYsrg8VVGjRiCtCA4vP?=
 =?us-ascii?Q?bxnB9Ms6EgZL9mMR425WLsKKL7w6VY8JTb6ssgcYgUPMVABt5cb6WuacmPR5?=
 =?us-ascii?Q?90dWDUXZHHsuFgyvQB9MH5HyQzIchcWVAm8riRPPPrQHk7NGoqTahMjx93Pi?=
 =?us-ascii?Q?ZjJ84m+gytJqvwQgpNu0zGzKNiVGfpocbByiyLhx0ssZuCtzvG7rsHBGWswl?=
 =?us-ascii?Q?YtvH1go10UdVctNre56NIisaH1BqQnhhr6r27H6TUDZRXa25VxvftpYpp5dh?=
 =?us-ascii?Q?FdF2J2PWN6zZTtfOKk4yU484CgAATWk0pEyULbktImRdQwuIqO6au22JcFzM?=
 =?us-ascii?Q?uYKNaja7FdPti8iy5QMJMcDIYC9atpy9RsPuIFY8KdEOuqT5N/0I89VbJylW?=
 =?us-ascii?Q?TvYZEBRN+6C0RDNQF8GIROagCmnlrnZ5PQZA1iefMaMmuYOOKS/TRo9zDfhf?=
 =?us-ascii?Q?6RPenzJi3x8CexSMSXBhIoALsMzAeB+79/Yq27X+AO43T2A4h19sfLbP60Ep?=
 =?us-ascii?Q?DNxv8UgaaNz3+o+jSXtjtNOSxqdo43ichkXWohpWuo31Fu+w7bJQ2wYHPhSb?=
 =?us-ascii?Q?MWtgVnZ40pkYLAVrZiOk21IWcBiIDLf5Xr4qcdC4Rurfouy5cEKWExqks/bD?=
 =?us-ascii?Q?P3Twh7e/6AkUuVBz1HKR7l7baCUpfezhDH9k2bRORkzJN+3UISpnW7uSgofx?=
 =?us-ascii?Q?CTzqPlao3JkGJe3ZfOi4IkyJL5QPhUOg1wpYhrQgWpWayTelvowdELoUfXcs?=
 =?us-ascii?Q?zzHv9YBfgy4DKeowwjibtTdOsXmY/LduEdW0ehol?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5855a398-b1dc-4404-3f85-08dc94bd7528
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 02:21:01.4666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8EVRS1yXk53agyJTHeQtId+dzvoIofGnGeU6WAbZTSIdrYA01s2IL2ScInyRTGKup9QJSf/QgrhWCiEBW+OCTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7354
X-OriginatorOrg: intel.com

> From: Sean Christopherson <seanjc@google.com>
> Sent: Tuesday, June 25, 2024 3:29 AM
>=20
> On Mon, Jun 24, 2024, Oliver Upton wrote:
> > VMID=3D0 is associated with the host's MMU context, which is relevant w=
hen
> > running {n,h}VHE mode, as the VMID tags TLB entries even if stage-2
> > translation is disabled (HCR_EL2.VM =3D 0).
>=20
> Heh, I assumed VMID=3D0 is the host MMU, Intel and AMD have the same
> effective
> behavior :-)

side note - Intel VT-d spec recommends stage-1 translations using a
VMID different from those associated with stage-2, but not necessarily
to be 0. intel-iommu driver uses '1' so far:

/*
 * Domain ID reserved for pasid entries programmed for first-level
 * only and pass-through transfer modes.
 */
#define FLPT_DEFAULT_DID                1
