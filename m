Received: from OS0P286CU011.outbound.protection.outlook.com (mail-japanwestazon11010064.outbound.protection.outlook.com [52.101.228.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986BA30F953
	for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 10:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.228.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768560465; cv=fail; b=IDxms+w22PNi9xeJ5U1a0XIAbYmoeYhuhAO91JFVps2bFDao+VyCw0zNc3xPFL/XJlmMuDdwOscva1tJ0EcruTW8eU1xTg0tHg6GacWZRZ4qd0rQTV9j6VCdFmZ4MU8Vf6krV3zS4s+zYw6NBOsgisBLRaHoRBlIjO0XMq4VWA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768560465; c=relaxed/simple;
	bh=Xo6yx0UFiZA3Uaj3HokuGBWBREUgRndD+HGzAieefpU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jcujzlceLG2BmscHGTaOOW5Jsjhdl6MJrVxUKCvnScYtm3TGEqlu3UFLmUd5t1yPjsEn9avpeavUeipWI5fFnm/gatGhJ2M0HM3MPUzhrBUBZuJLQy50PUJMFZVzwlCjN0aqCOXwP2Fi9cbN3ZThQRh11VEAWWjUEd4d9tPeDMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=cf06fKpY; arc=fail smtp.client-ip=52.101.228.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="cf06fKpY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mHxVM6ca1/FqjZLypGMjeKren4KfKFeihCFsTBC8GnyhZDzWWreslAwpNASzvWMpU4S+VkYj01Hxtpsr+/wCfNg4YugXnfce8lp38GmHkIC5MBC3Yqi+28fStp8fdKUL4VcDgdygaTWLHEcd2npub50lYkgj5s2dtjmWNZFaD+yKqLSXSooEPxXUj7+zTYOBL+Npbgg6LORiIvlMWIfPXxKOlAb9FiyUrT+hhf2+BYvtwV5Pw4nAB6jObvihYc1lFHSdz2KYRzXwlCrtEcbF98jxcvv5R9xyrnXwT2k9soiwouC2hf08ABvkPtph3e1oWAx+dSdY26Bb6Eesu8e34w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yJPzBFUqzRgykZV5hvAPQuJyX4mt3YL+gWtt2RzI98=;
 b=jifHQsI7ZlXWVkRkpKMy4wcE/by06QkRn0meAE1ctco9jvIWCHO0ge+8p2sIC3645ty2GlQaFD0VrQryQCEAzYEKxS7kbr/IrMSJpzcuMxWTeRj29pCgVJBaT9zvZedSUr6VfjQIq573ONCecSw9/WCHXbIN2rczoUO6/XN67SUDwq7x7W6OoxgSwdfkjoz9CHmYUSa2BahQAOcWeNt8rggUjVFyzjWg3Xwil2zOoc89qBfuQDh2/e8tJFPU3+JJwxMyOMj598wLPdbsKMBlOPKLVvQ8ddrkgmGXtpBerCxg7k89Hnk5fCV49kwCoC2b/zbrQpnbigRNWDziXvk32A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yJPzBFUqzRgykZV5hvAPQuJyX4mt3YL+gWtt2RzI98=;
 b=cf06fKpYske77dRmvipxUOHm6JzCZu/1xAncTS/nc2L5W7ppuY3b+EtLduRiN7EmJZMbhhpP54u6NOfa5MIc+LOjHUeKKayKaBw4hRw+ZdF8w+SqniWt8CjYtpmixozONYrpe4cXcPNBOug8/+tL+R4JUKSVxBiJFIvLYKn3HIyx1YXTKxR99BCpVIv8iPH+CwpegbUf/3/ntyla6csGzqdgELfQuhbF25FDqaWXuCu5bZ4aZAVeEmaGDuEN5AaGrLkNWeeK68rvfGGYK5BmfsMEYvvUpKtwBYmtgeWMggLKxm1ZuQVIRtO+alO6jSuQViSd+U7xhKiwyMU1UObNXQ==
Received: from TYCPR01MB8804.jpnprd01.prod.outlook.com (2603:1096:400:18d::10)
 by OSAPR01MB7302.jpnprd01.prod.outlook.com (2603:1096:604:11d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 10:47:40 +0000
Received: from TYCPR01MB8804.jpnprd01.prod.outlook.com
 ([fe80::b2f6:161a:adee:a32c]) by TYCPR01MB8804.jpnprd01.prod.outlook.com
 ([fe80::b2f6:161a:adee:a32c%5]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 10:47:40 +0000
From: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>
To: Ben Horgan <ben.horgan@arm.com>
CC: "amitsinght@marvell.com" <amitsinght@marvell.com>,
	"baisheng.gao@unisoc.com" <baisheng.gao@unisoc.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
	"dave.martin@arm.com" <dave.martin@arm.com>, "david@kernel.org"
	<david@kernel.org>, "dfustini@baylibre.com" <dfustini@baylibre.com>,
	"fenghuay@nvidia.com" <fenghuay@nvidia.com>, "gshan@redhat.com"
	<gshan@redhat.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"kobak@nvidia.com" <kobak@nvidia.com>, "lcherian@marvell.com"
	<lcherian@marvell.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "punit.agrawal@oss.qualcomm.com"
	<punit.agrawal@oss.qualcomm.com>, "quic_jiles@quicinc.com"
	<quic_jiles@quicinc.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "rohit.mathew@arm.com" <rohit.mathew@arm.com>,
	"scott@os.amperecomputing.com" <scott@os.amperecomputing.com>,
	"sdonthineni@nvidia.com" <sdonthineni@nvidia.com>, "xhao@linux.alibaba.com"
	<xhao@linux.alibaba.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v3 00/47] arm_mpam: Add KVM/arm64 and resctrl glue code
Thread-Topic: [PATCH v3 00/47] arm_mpam: Add KVM/arm64 and resctrl glue code
Thread-Index: AQHcg+TnrSTV+MHTO0+Snf+apphKqrVUoyLl
Date: Fri, 16 Jan 2026 10:47:40 +0000
Message-ID:
 <TYCPR01MB8804896CC8CF6EC43780F2628B8DA@TYCPR01MB8804.jpnprd01.prod.outlook.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
In-Reply-To: <20260112165914.4086692-1-ben.horgan@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-01-16T10:47:40.392Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB8804:EE_|OSAPR01MB7302:EE_
x-ms-office365-filtering-correlation-id: ef6ac3e9-3ca7-4688-36db-08de54ecabf9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|1580799027|38070700021;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?eHVYc0krNkt2UmVka1hYSytDNVAxZFlxYXd5TkdsdTRISVFEbnlUZzB6?=
 =?iso-2022-jp?B?bTNzMXlZR3ZaZFNRRGxhNjNnSmpBaXkySzlKVk11QnVXNWk0UHNXZjlT?=
 =?iso-2022-jp?B?ZzhYVjRQdjgyazN1UDlPaDlOQngrYjI5SmJOTFVsdzhGcXNDbnNXSkow?=
 =?iso-2022-jp?B?aXpVdHpCaUNNL0VCQnhweDZCWTgyWDRZTUI0OTA1dHQrVmw0ZGNaWXRD?=
 =?iso-2022-jp?B?Q3Y2cGdsMU5MdXRWMVoxemlVbS9IcGgrTS9GaitjMVFXeGxUQ3M0LzRv?=
 =?iso-2022-jp?B?emZ5SWUvdk9Ra1BLVE9LYjhqYThGeVRkWitoQkpETTdsUEc0RGZXeDNw?=
 =?iso-2022-jp?B?ZUZPTVFETk04M2dwZ2hUWGpMZHV5cnZDNjUwSVJpenE0ZGI2UmtxSm1o?=
 =?iso-2022-jp?B?MUlrYmxuSkVScXdOakR0YVBpREVyQmh5S3lUb1NYT2NoQnN6a3VuejlC?=
 =?iso-2022-jp?B?Nm45YnMrZXFYVktTcEtvN1dZVEdwa1hZSmNpZnE0L2dUSDZoYnE2WnhM?=
 =?iso-2022-jp?B?b1NmdFExWVJCQzRHVzlUSHZQQ0NDbWN5MXlQWjdhdE9XeTVEclh1L2c2?=
 =?iso-2022-jp?B?QTNNa09ETWVld3VaL1FHTHZkN2tCaVg5dU03aGNpWGJpd1UrWStsTjlG?=
 =?iso-2022-jp?B?TzVTTVFrV04rU3BpK2IzenJtOVd2M2hraVZaT25wL050QmhteEpwQngx?=
 =?iso-2022-jp?B?Q2RNcjQvU2UzbFNreVdpcCtibXV0S0FxV1lPbmpnQ0ZRRldIdjkvKy9G?=
 =?iso-2022-jp?B?ZXVCZkEwL2I4c0kwWkpMZnUrWnJwZGtsYjJPNVRTLzVPRzRqL2xVd0Qv?=
 =?iso-2022-jp?B?SGZVWEFnaHEyUGQwaTZmRnRtbHlNUkZ2dFhNY3UrK0lydFR5Z052MDVH?=
 =?iso-2022-jp?B?V3NvQlRBYnlUSGpkdmhqVTN3c3RZYUNTekkzQUVrd2xRNVZKRHBacXpa?=
 =?iso-2022-jp?B?OGRNajN3Ym9Nakx2RTkrVXkydWZROURPZ29OWjBsUUkxVXhRbDhFVlc3?=
 =?iso-2022-jp?B?c2U3dUg3cUVhdG00OC9TaWtnbXFSaklyS0gvQmtoMlM3SVhYRWlXN0wr?=
 =?iso-2022-jp?B?UEJtOEdJRmY1elQ5bndVZm4wWlJORUJkVndhUk00ckVsM3haamxYL0R0?=
 =?iso-2022-jp?B?cHNXcWgwalBNY2tuYlVmU05SckF1NC9hNXg4YkhxYXI3VXJmY0pjVWxj?=
 =?iso-2022-jp?B?L3hLSHVqaHprSUFBdytMYUJFcjR2RUlsSDdmMUxXS0c5aUV6UjZYNXlJ?=
 =?iso-2022-jp?B?a1dWYmp0NE4rbEJseHBDU0R5aXIxU0cxbVhxaHlZT3U0LzJqSUcrYXJt?=
 =?iso-2022-jp?B?S0F5b2E5TlpJdHFHWU1DTzVWcWp4QjFkY2Fza1VqNENVZjB3ZVRkdm5Q?=
 =?iso-2022-jp?B?OEpZdGJrQVNTMDljSnB0OFQzL1p2RkRUWkJSRnRDM292MVJDQncwVFRl?=
 =?iso-2022-jp?B?ajJsb3pBdWdDai9FamhSMHdrMklvOGFtMVR3K21lUDBpSVVnT1pwb3NH?=
 =?iso-2022-jp?B?RjRZMjRjVXA0eUVvemsreFZiVW52UVh4ZWpaS2ZtWjloSzZlc2ZBOTlX?=
 =?iso-2022-jp?B?K0hlS2h5OUd1N1RQQTl3N2NxRlFaUnFDQnlzVUFqTWRidm1rQnRCQjlk?=
 =?iso-2022-jp?B?NDVpcVNaYXMrNW5UUlhmYW9naUx5ZmVMYll1TTRFYUtOZ3A2TkgvQk9B?=
 =?iso-2022-jp?B?dVVoT3NkSGZmYXMrdWpDNXVOTzRqNnB0b3lHWDY2QjdlbkRjNXlyTlZ5?=
 =?iso-2022-jp?B?U1ZCK1lyWDVwR3YrNzdXWjR0RW83dXZ4Ynd5d0N0OUg4UEJZbEFvTXcw?=
 =?iso-2022-jp?B?R3dsZE85eDNjMkRiZUNPTFRMVTlmRkVlNGNaMmhXUHpnY3hBQUk5Q0to?=
 =?iso-2022-jp?B?TUZSQkxMbXBZK1hTUlY1RDQ2T2phc2UrUXY0SVpmS29ya0JOZVZES2pP?=
 =?iso-2022-jp?B?NXp5UTBLZUpqZ3pUMy9qUFM5OVVjNmU5YVRhdFQxdS9qWkRsQjRFRjNm?=
 =?iso-2022-jp?B?QUpoZlIzOCtRSFBSOEZOL09VY2xxUSt1TnFVcm1zeC9PTnduOGZGVDZq?=
 =?iso-2022-jp?B?L0h3L1I4YVA4bHNRN3lYWVFmYmZEY09mUkNMMHBkbWtxTlFENEZvdFlU?=
 =?iso-2022-jp?B?Z3JFUWYrZW5lUnpoalhsYkhMaEIxSWljZkNmU0NuZVFBWWQ5Sm1YUzhm?=
 =?iso-2022-jp?B?TFBHcFRBUFNPNVgwOG5EUmFZR1NKeit6ZkRsYTJPL09FZWNnelU0eDVv?=
 =?iso-2022-jp?B?Mmt5MnppcHlkeTU3SUJQeEUwdXozM04xYjY2YS9mbTJjMXV1SjQyTnE1?=
 =?iso-2022-jp?B?MEo0U1NxUHlBOHZoU1lkOTFYY1VRQXFIaHU2VzVtZE1DTnpmQkh6LzZJ?=
 =?iso-2022-jp?B?czhWN0NvL04xMWYxc0VGMTE5cUUzeVViblY=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB8804.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(1580799027)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?ZUFaNmRubUkraDNSVXJnS2VJYy9HWmszYXBFQzZOeGI3MDZUUStkd0Vz?=
 =?iso-2022-jp?B?RVJmMTBtNEdSSXJCRk42L2NaZjJBYlNReWhGaGNEUUd1WndoOEw3azlp?=
 =?iso-2022-jp?B?K1VjU1N6YUlqNzhnQXYySGV2L1prZW9QSkh2R1hNNEZrY2I0VHhhNkRa?=
 =?iso-2022-jp?B?VVZmYklUNDBTczFVMTJXbHAxUGdUMkkzL095cW9aSmtvRTNrdmtKbWt4?=
 =?iso-2022-jp?B?Qll3Q2Iwc2JzRDlIaHZOQXdKbXhRZGM4MnVlekNGemdiOHJNaCtPK3VJ?=
 =?iso-2022-jp?B?MmVodFBZK3ZKS3ZNR3hDekpUTHhTZERrUlF0Qml4ajY3MXFtK0phbDEv?=
 =?iso-2022-jp?B?aVdNaXU1Y2tNSzdvQVhmaGhaYlVtTkh3SzVUaFZEUkhHaE5EOXBvREFX?=
 =?iso-2022-jp?B?MzhPMUdVdm5taTcrWmt3NWx3bkZkRVhvVDZ6UjM0QzU0UTZUSXJodklC?=
 =?iso-2022-jp?B?TGM4RU5RY25YK2k5bjllWjUwQVgrT3hpczhGcEluaGNxMEJnYnI2UTVj?=
 =?iso-2022-jp?B?VTBycWNOVEJvaFpxM0ZsZExHQkRtOHRNeEgxcERTVHBtQ3puQ0RFdUZq?=
 =?iso-2022-jp?B?bHFpS1NqYVQ1d0hBR2orajRxUTM4OFFPZG1vaG1LbWZJM3VuVE9QN3Ar?=
 =?iso-2022-jp?B?RkIycjY3MGIrNGlKL05OSzIxcnRqMnd3azZqOHhzS2s0djlERmJ4L0lh?=
 =?iso-2022-jp?B?TnMzMkJ4MStHckR1bEx3a1g0NWhnbytVQzZHbWZWRlQxUWhYVmk5NFBn?=
 =?iso-2022-jp?B?VFE1UENCTHNHLzREU0NRY0Y5ZWE3ZHBBRXlkMzVCV2xXM0VBcmJsWm03?=
 =?iso-2022-jp?B?bDh1TzQ0VmU3a0hPdTlCTjAzNnEzVVFhTCt0SkVGMDNIMFNJTVBhdEl5?=
 =?iso-2022-jp?B?ZExxZWpaTWV6WVpPSTJWeEMyYVJrSWdQa2dhTUthMnlDUFVwcHBrRitY?=
 =?iso-2022-jp?B?ZnFTRHVHU09lcTNjaERQRFRzY3hBWUhmNGp3SGZvLzdpeC9HY2JuOWpH?=
 =?iso-2022-jp?B?UzVsWmV3Tlc2VEM5MHg2cEpKQlErZDR3MXBGdVNjUW1FZ05neHJYMjFS?=
 =?iso-2022-jp?B?NTc3NVBTUzBaNDY0QlUyYm56bGUyb1VDdXFxeXJ6SWc5eG04UG5ocnF5?=
 =?iso-2022-jp?B?eDcyUXZ2Nm1tVU5kOUF4d1ZBWVRHOWZ1QVpWRXA3ZGNObS8wQWNDK1dB?=
 =?iso-2022-jp?B?Zjg2djlPaTRYOWZrOGk1VlhqS1A4MHJYQnRXQ0t1ZERWYWJMR2NRaGd0?=
 =?iso-2022-jp?B?VXh5MSt6TE81aExwQXBpakJ0NDdUQmtqZDdpcnFERUoyTjBCS0x1dUlB?=
 =?iso-2022-jp?B?amxORUZzR2dGekVmV0dNR29VZEpmUUFpV1I4OWpSSGs2NytXL2wya0o4?=
 =?iso-2022-jp?B?R2pFRlZNRjRibGhJMGtTOGRrUkRjcFliRVhlZGhxS3FFbWpFN2NnaVpZ?=
 =?iso-2022-jp?B?Y25rNDRhT3BJZUlxNk5VV3cwMWczbDJFSndnUk9lNlk4WnJwRzRxcERT?=
 =?iso-2022-jp?B?dG1ZOHQ4a2E3ajNWYmFkOTlOamVJS05BUkpqdnI4STV1UTZXS0FROU03?=
 =?iso-2022-jp?B?Qmg2cFVCbTdNSndBVkdDa2FzRTZBQllLUnFrYkdFOWMyK015L2RFNTJN?=
 =?iso-2022-jp?B?VDU2UFRFUHlSQUhsMERIOCs4UnhBM3NVR2J1SEtNWFpSc0FlNkJVZ3h2?=
 =?iso-2022-jp?B?dVpONmhsMSt5R042MERremRieStoTlBzdVVHc0Y0OHlZUGQzMW1wMW1j?=
 =?iso-2022-jp?B?TG1uU2ZRVXNuTjhrdVdOdVEvWmpOSS81bWE2WEhEVFZKa0JZbjcyaFJP?=
 =?iso-2022-jp?B?cWRzazhiOFFIRGlkczVKdW1VWlRzcStvNjBHUExtclZLZUxsNWU2VEd5?=
 =?iso-2022-jp?B?RGEvQUJYcVlyRGJ6VEhWT3RrMkZncEJlRVBNS1BZRlU1QXZGbmxJZ2U5?=
 =?iso-2022-jp?B?aXRQTTFhcE95ZUZBOHJUbWNWZ25NemRrYlVOODZZNzgrYXlNaHJkSms5?=
 =?iso-2022-jp?B?UU5OQmNWNGVuZ1VzTGhxbVpGNERRQ01ySkx1TkFrenFFaTRBMSttMkNx?=
 =?iso-2022-jp?B?MHBWVW41RThtblVlanZpd2FPWW5nWXFHTlljSXVQbFBRd2pUZU8rVWFB?=
 =?iso-2022-jp?B?aDVCbWNiRlN4cWhxL3BncXhqaFBxOXpkbnFmbmlScGRKaDF6dGU2TWpT?=
 =?iso-2022-jp?B?RksxYllNa3RsT1cxakNVVndxODBwZy9tZ09oRXkwWnRtSkIwejFPNGVv?=
 =?iso-2022-jp?B?WjJ2RktaUXFQa0hLM2QxRnlpVDRRQ3ZrL1Q5ZHB0VFh0cXA3d0VpK1VQ?=
 =?iso-2022-jp?B?eENadmdxYmlDUmZJWVI4K21wS2M4SFZtSm5MdWFYRXNGcnQvQWtsdW5D?=
 =?iso-2022-jp?B?M0N6QU9QVnhXajlkbEhEeXE5WUpLQk5yK0h2Y3dQZUNEbkhsQWpCalFk?=
 =?iso-2022-jp?B?TkpiWWdoYUhGTitOaFAyTzROc1lpcW4xaGlDM2pXV2ZFckY4MS9VY1FP?=
 =?iso-2022-jp?B?OGhCVlBNSm9EMnBMSDd4ajRUb0IyVXc0bVBXZz09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB8804.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef6ac3e9-3ca7-4688-36db-08de54ecabf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 10:47:40.6876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E4htavO7vKmYKPwE4OgNja7kAoYFuHhwEg/vd9DEmxdWdiHOCLQludNmUYDKaiCQExct96pLJfBbxpMX6zg89nEYd0RKVHAZwqv8J1HVHmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB7302

Hello Ben,=0A=
=0A=
I ran the MPAM driver on NVIDIA's Grace machine,  and it seems to be workin=
g fine.=0A=
=0A=
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>=
