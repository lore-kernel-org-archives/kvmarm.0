Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012006.outbound.protection.outlook.com [52.101.48.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFD42EFD9B;
	Fri, 18 Sep 2026 02:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789700383; cv=fail; b=HJ6Mx77QPArLC94e2DS1B0+hlBT8ASGKhcvtwX+6ZISg+EZuLKCoukn78yaAnwWpk0XycDUgET8n90twn8SH+sSbirNfyD8DS0vSe4+aVZ0VwrSQFp5/vrn+T8wtr6L+5bSD9VSWa86eXpJwGW3qFPGl77e6DUmGSGGnQqW8uUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789700383; c=relaxed/simple;
	bh=dGEH1bFy2hiai4hJi+Okvvaf6Xt7ZmFOXiJDK+krhWY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m5gi4xVmQNEKrHzEE3DOj+y3Im6AIoZEEAa85zqCTfB/ernotLUwkMP4C3Cjhxel3BtmIuGIVZyFI029+tSBFuvx7g+eZQaNHEZE6WoqGi4Lz5ek2x3ZoenzGwc0OGYerGniA0jwHNWm3Mv+lZUUXSkDlVbx8Ng1A2uVXciqMWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VtOZlXfQ; arc=fail smtp.client-ip=52.101.48.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VtOZlXfQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nLHKq9zxPhocxTW06dgEGWKifSB1H/LpKvs7hgxsQZWoqG1y8pL5Q/2qtSVPzIwqAt7ognbh6cxJJnAWHhDQZ5dlSCJxfPJgFILZD+JZZfpCVL012bnhvOHUfzhCEGXy1NIWUqtoVpYXgrKyNz9py4O7zGe01aGnXW1pJyUGdreZTVOpuFhCLDQ4m1QMEeAoQKXdPne0qjHfMSTrCOBQh+yi8w7KHe4C0FmHfj5OhptC+lEcdMjEr/XwjpUTD/uJC2K0bIp59tJSTZfpNuAVUBjMcUDlko6yBVQMkaMHxKI7hfdQyh5c8Z5AIEVHrsB9+MvZtmowwWYlpCLC62ToCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZUL3Eplppm51Vvf3wRkb6Rb9P1+9cpJIHUMnzRdvMo=;
 b=JUG57x5HdiXtsGIEOEnW2wPNOUwv51Ahe1YrzikJT9iM6l1tQlcDM9PFvOdZ8pyXnV7B4I9gFcmtQvff/xsPKzRmt1Ud5tSGbaHqSTvYORb3pNSkkv7ahLg29ev5E2QDOfuBU3L3hv+3tk+QLq9E8V64tHMl7/uNaHYRIgHM4+C7rXRjiHsqmJcfdH1NK8xd7knI+BO6kebROWjG4B4+OQY0pHwkiY+vpVn1xav42+jvW/DxlG4pa1b+WLMqhpG8KKUhCWKYdGbnTgm+EPE1xEB7eMrFb75fDT562sBlI20kWEgSYLJE86HeikPUEKIwBREaMYuB3yl6MPY4/xKHpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZUL3Eplppm51Vvf3wRkb6Rb9P1+9cpJIHUMnzRdvMo=;
 b=VtOZlXfQ7Dp5D9dQbb5WYhCeSNtwDHGDSFE6PReR/BYNhdktwuoc7HYmESkgRCpQG+hM6NcSomG1jTrzCu8iFSSM+BIu2d3gdOlYXezxTw7r/uFPQDjn02qWGBwfTTnZ6mkomx7J6Jb8OsTAkRFvSy+WzeM5HUpB42P+TllxD19zU96VkjbICWIbYo4w9aXb2ITKiVkEmbdORJHLnh5XSdvwCtycrQ4dSoRybGfyuuaRXVOkByfAIeFuLQgAtyXQzLCUQkrEK9o16JfOBNGwMeQVymHVxGI6/rGOdK+idUjtvlWH9YGL7W7wznlsYgInwB3YYCOw7hg2VSJFLU4RCQ==
Received: from SAWPR12MB999267.namprd12.prod.outlook.com
 (2603:10b6:806:55f::17) by CY5PR12MB6132.namprd12.prod.outlook.com
 (2603:10b6:930:24::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Fri, 18 Sep
 2026 02:55:55 +0000
Received: from SAWPR12MB999267.namprd12.prod.outlook.com
 ([fe80::fe35:8a00:d9eb:40f9]) by SAWPR12MB999267.namprd12.prod.outlook.com
 ([fe80::fe35:8a00:d9eb:40f9%4]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 02:55:55 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: Alexey Kardashevskiy <aik@amd.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Jonathan Cameron <jic23@kernel.org>, Marc Zyngier
	<maz@kernel.org>, Samuel Ortiz <sameo@rivosinc.com>, Steven Price
	<steven.price@arm.com>, Suzuki K Poulose <Suzuki.Poulose@arm.com>, Will
 Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [PATCH v5 11/15] coco: host: arm64: Connect RMM pdev streams for
 IDE devices
Thread-Topic: [PATCH v5 11/15] coco: host: arm64: Connect RMM pdev streams for
 IDE devices
Thread-Index: AQHdQTBNZsWT6J6bdkaQWvWFEK2da7bTrZ40
Date: Fri, 18 Sep 2026 02:55:55 +0000
Message-ID:
 <SAWPR12MB9992670293875EF547CA440A18B0872@SAWPR12MB999267.namprd12.prod.outlook.com>
References: <20260910140509.868402-1-aneesh.kumar@kernel.org>
 <20260910140509.868402-12-aneesh.kumar@kernel.org>
In-Reply-To: <20260910140509.868402-12-aneesh.kumar@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SAWPR12MB999267:EE_|CY5PR12MB6132:EE_
x-ms-office365-filtering-correlation-id: aeddfb62-d449-4c05-d3d5-08df15305bfc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|10067099003|4143699003|18002099003|22082099003|56012099006|11063799006|38070700021;
x-microsoft-antispam-message-info:
 6n59Z9ql29wnkppqkGHsx35tq0NUMcyMhGavkCUDyZbRsPM2QJW7fX233y6iq5wpW7M671gDSODRLQEVi9v+ytgpbFyo+vcmhHLWUtAAKAIbl12X9+i46O4gzBW2izdLHKzYGy/CI5nbNDfvtvG6K2A3ehGTHwrILyychtdUAVLZ7tFG5jpWnepkBVfndygxe7Cqdd/pIjWvYZ9CfxsLEyoAIi4sLGy8iVqFLnTtRmNPUxNt9dEROVwMQmPX4ZuFRpM5qG1ok7GSiwrw4K+AP1zuKnoY+AdW6mQ/gqk+mu8ZlaTDGqhxHiV7aEJTUOJM0M7Ih66BKDymvP6T4ZTkT+QBUD/XOYjofcRUdoG52EZ/RiXgvDnGlKQ0nGfgY37WqNhAEX2Yv0ZezNGJUO1BKj98mYi4aTyP0ZXr128s8jzP57chkpPzyk2CX40EbvyAG8LwlZsa4jnM0JdQkReW8ywq13lQHhLuYkcpUXahqNLP2EqCJZwMeQOvGnz0wRe4AKIFdfP3iQ1yr1YUdKfV9Qa6FhiVeI8C1msIbIUHUafgb4tBsMA8Vi2htE+Q2MMm+JlZwqrj0fNkelo+YD9toeRjy/pZapkAqxTBCKWVZW0NcV1HfACxwZZ9lMcLG6Mv6VsvRDINajIVIDy9S/KlY5eQGXf+VeVTFxU3PCiKZmJvIQaKWS5khpQFN7Kjb5FaHJ/0+zTd/zR4TTejReRT72I/wdnJUzdn461zK+B1wrY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SAWPR12MB999267.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(10067099003)(4143699003)(18002099003)(22082099003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?/joV5VzVRLiA6BOR3vtVnPZXTB8SW/zDmsX+2GMweqXhucZnnAxrna6GQb?=
 =?iso-8859-1?Q?yxQQ2wUrTOGM7WAQayCf/Z/dHlN1KlTxEQr1yX4s5OSnja8qo6KtzIQupv?=
 =?iso-8859-1?Q?5v2gcKNu0HpUJ5oPGc6ls9Xd3B8OFifXce3+oY+zbh22TNsEpiRSxAvPIA?=
 =?iso-8859-1?Q?4TMXzDhk3rg91UOYFHivwomHArMQ03PGXYKdMvAOPxEqK5C61FOyz9PSzc?=
 =?iso-8859-1?Q?DMcGHjIBKgJ52g5/i7f3dd33OHk0PnNlktU4kLzSfsbVUoDVh3OJDCQMEp?=
 =?iso-8859-1?Q?DzRRy486URRWomP7sUmcCWhZgGCHfzsS/mSCt3q7o2FwbH5t+reULZdhZh?=
 =?iso-8859-1?Q?9Ll/AfnGpgN3XvB2rvKCaza7Xaw6HurACSbVr/PG7CWrsYUIBYJRws1/Pf?=
 =?iso-8859-1?Q?+egVF0wH4mKVB5oRvNBeyBI5aKXV4GLLeBnjky6AEpZbus9UFwqSNcNvJn?=
 =?iso-8859-1?Q?ujdj91T0GAM5UIWXrbqsEsB7EtSUeizk08PT0EO31/ZX50wHM0qA+/OaGX?=
 =?iso-8859-1?Q?oFtOulheZOgHJ6AQmN2m20K5EEVyN6BLQqac6l42E8k2l9vmFtT64fTwNS?=
 =?iso-8859-1?Q?8t/dzysdATLL3+Av2PrVzAXasPo4OvIZz74u+A3qaa5tnxFh9phFtdzoNe?=
 =?iso-8859-1?Q?ZXrNN47ewQiUSJ8AkT/9zjURY9YG8VZ+65tGUDCE0lSvqjix62d3Lxu0YS?=
 =?iso-8859-1?Q?C96yJfXNmmyk9SrJHv97mAPqXDqXYifL/SN3XVTGnMZ3Z8v9NLpnPj5/1v?=
 =?iso-8859-1?Q?SBqz/8jndnezLEPmcPU7faz1KVNKF1kAu8QVk0otQewdLy9kWyCcmFu4ta?=
 =?iso-8859-1?Q?W5pBEhHA1WZo0ib4MxWLGzGvVSJcJlP/5GBzK2kJSC/KBPlMWGIN3rnw5B?=
 =?iso-8859-1?Q?e1cSkqdSG3IGU+liEKFe6V73dOXNNUN7uZtSFue69lkmHGmuzTYR4QhlPe?=
 =?iso-8859-1?Q?9W5oV+Txu+E3u+t3+t4Rb3pTk2rPhxZuK8C5Hl0W2v6qZBMF78nv/mIVF5?=
 =?iso-8859-1?Q?rPkmCt6OzMK1vl4txHb6ONcgF/NIZ3quOECAFO0UYk7Lya8IpxNzwE8hDU?=
 =?iso-8859-1?Q?V9Hk0wxy8tu4h1LWYxrQDtXu0SPvMSncYkhfiiUkZ5XeqvIN2NpcAny+XW?=
 =?iso-8859-1?Q?4tSQIrfrB/GAZM/xJ7OXsGzH6I68498FcQAcAE7BS2GjtAivKNOg/hUn5D?=
 =?iso-8859-1?Q?QOT3Rx7hWzcXthmOWcfCfHX7UpVRBf/XPDQLVNj7NZnm8pf9v+We9IfU5S?=
 =?iso-8859-1?Q?S4LPH2AC51SUTQs3UrKsbuKJ+TE/tLIr08TjJuxZMIv99UTWZUa17pRDgQ?=
 =?iso-8859-1?Q?sIVftpjWKjKGKDp4KCHCzLI/8eX8ufxqxen7Po0jxyCMhWTulDxhqpaCQu?=
 =?iso-8859-1?Q?8mhv1tzBJlf+YmzaGljPmRV7+F2+PVyYMS3NMizezFQbpicrXVnu2crxtO?=
 =?iso-8859-1?Q?lR60zvIJnTcEK1QjW+15se/JihrfVklCxIRCdLIXm+jAJj59DqIypsQ9O6?=
 =?iso-8859-1?Q?dqsVOp0xhE5WdyIuB16tjG8pqKc3mT1QhGA9b7OUb1QtxxPqfiZG/uTOOX?=
 =?iso-8859-1?Q?6QZNhKrC/Wf+wQzpeQMBUyuJPA9dDoIQ/gKA+8V7MJBfDBYV5vU4ddTRIi?=
 =?iso-8859-1?Q?F4o4lccEg2v6Oyqd5NLi/sTP68X01ZyLrFJgqDnAxhLeXXJ6/W3OXJc9Dc?=
 =?iso-8859-1?Q?gJ0KcTlz1HUePhhKfevn6wKoiQTZtsSsLzaIm98zsnZ7F9v8PYVo7Qov/b?=
 =?iso-8859-1?Q?8G1MU2buDjoEu6LAOSJgjWe4laVtXOckk+IvcwqgWg5oBK?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SAWPR12MB999267.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeddfb62-d449-4c05-d3d5-08df15305bfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2026 02:55:55.5443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2sEJzabHGbQMZrRylSCkfcUeqRmS0uPOvHVKGyxqTqj+FjLMAgaqHteXjvgjnr8O+s4r91zLqpm2JPai9LHjrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6132

Hi Aneesh=0A=
=0A=
As I read it, the address ranges handed to RMM in this patch are captured=
=0A=
once and at the point cca_tsm_connect() runs. That becomes the address=0A=
range RMM has on record for the pdev/stream going forward.=0A=
=0A=
So a couple of questions on that..=0A=
1.  Is connect -> {driver probe / vfio-pci bind } the intended=0A=
     sequence or is that ordering left entirely to userspace/VMM policy?=0A=
2. Are the resources/BARs captured at connect time assumed to be=0A=
    fixed for the lifetime of the PDEV? If a PCI rescan (or resource=0A=
    reassignment such as pci=3Drealloc, a hotplug re-enumeration=0A=
    happens after connect, is that expected to be rejected/blocked?=0A=
=0A=
Thanks=0A=
