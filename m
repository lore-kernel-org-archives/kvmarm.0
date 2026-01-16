Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011041.outbound.protection.outlook.com [40.107.74.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E90D214204
	for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 10:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768559672; cv=fail; b=PJS0bo9cXThpE+K9Enfa/FOKpj0tv0oMs9aNrEZgPxUPwzaDcvhOJgGzZb2PwscMvWYBhbw6FVbjT3kFaeJ4+B1devmZnTiQUBbVpi3X17OPduSVNbJCIeQaZ1jQ/j4U+s+XuNQbjXvnMTON/Oy0DTQhJwy3G1MQZoudz+O9Q6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768559672; c=relaxed/simple;
	bh=zq9EGyZWbkjAOOWpNpMT+O2mlquNoWJ1Zp3+v0cT9SA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Cavq8R8nbT2Iltr1eK91Fath4TG0jiOBY/QausJsQDDrxtgAA8AvtLnV8uRwu3Gl0F9zu53zdBfYU4x2epbeVQIVSm1pABj+Ym76dU/XabzDTHKrRDTseiAjPASJ5SZqzGWs7/cmZ9G8Gud3RHsZMvKijQeI7hD/YfkWakIOR5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=CGv905DD; arc=fail smtp.client-ip=40.107.74.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="CGv905DD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iqyqJBPlpCcD0ZZpC9g6FZEPfzdknea9bmVoFUqgMqLoxdWen1Ke6n4XRRptH+voipiijINfKG5rOpRuag9phGZdCMj9us7TLaQECm9XK2ee8C73cZp/Jxi5MltyuS7Mxmafddc+gtllvdlKVKCzbe26H9ipvwFX/Zah0vzCDOpNjuUbZDXcUSIvOwW0wMTGwaiI0Ho/VSGkGr7aanUUepDts4K8rpsZJi/9eRxA6CJ/YIBvQ+fGMDUko7jpWwyIkcfldLusiIWr3FObLD0FWaGllWNXxEHU1O1PMvtJ2NMB07hSXs6n3mXS/IaVITwsgC62DIQoCAGtk8BmPBf0Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=woEuRgPAJX6y0zlPQ4xe+xheNWvpre1ttFom5V4lpfk=;
 b=KJlGUqgJyQkxIHOuZ9fOjOy+w3wSnrvFeZ8H0gvF46r9bPIYxgds6WgV7V8yIrf7/AwDUubtcY2Tea22eHAofc1GQxt/s9oFtJpOvKFZnbptEcQGjT7kVsZ3pX7O0fe8n5HuGLwnykBuMaxy4nGwZiu2U35J3DR5UfLxxj9WIiXoKGU9EqlSjvEespYcOn1YkVzVyrZnaC4tynRISvJ/G7SYmztOTAUhhNXo/aInDiS2eZZCaAy+88ceKYnXL2E7Qn55NTvGM+xMwmXKyle8UM8Tg3shAznXD2Emac3BpUSnxlJG4JKyectEVgtg3vHMWDR1ReTr+Tg4D8BJHEQlMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woEuRgPAJX6y0zlPQ4xe+xheNWvpre1ttFom5V4lpfk=;
 b=CGv905DDWNIPCM8x79vNntZPDanNmFCsLYL257zV824HRWCLunaDUaLzcJjhjpqDe1Y/wpPc5oaTkvfU8+WniW0pCSwoA7ezKRD0gHenj8BcA6Ufpx5nS3Ek4rwfU7in0ST8M6cFjz3fQTelFqzEl3E+wb+YT0Mg7RF7j9TbdTDpPNOb4Bno3X7P+wXy+S6D5eFT+S03Pab6JG1pOlskk5ZF4YqaB16Ka4Zhj2UNLOAnj66Uc2XrbeqpiYyu20Dn3kuNZ98tlD/vVeHmqCA3bs3Lg+D364JTKuPo2BlhBVwgyun76lEok7Ry4DF4jfOLrJpcDVH+SeJRCOkuN9tLWg==
Received: from TYCPR01MB8804.jpnprd01.prod.outlook.com (2603:1096:400:18d::10)
 by TY4PR01MB14689.jpnprd01.prod.outlook.com (2603:1096:405:23b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 10:34:27 +0000
Received: from TYCPR01MB8804.jpnprd01.prod.outlook.com
 ([fe80::b2f6:161a:adee:a32c]) by TYCPR01MB8804.jpnprd01.prod.outlook.com
 ([fe80::b2f6:161a:adee:a32c%5]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 10:34:27 +0000
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
Subject: Re: [PATCH v3 31/47] arm_mpam: resctrl: Pre-allocate assignable
 monitors
Thread-Topic: [PATCH v3 31/47] arm_mpam: resctrl: Pre-allocate assignable
 monitors
Thread-Index: AQHcg+VESbBf/iaHsEKL/WXyHoRzuLVUn1hY
Date: Fri, 16 Jan 2026 10:34:27 +0000
Message-ID:
 <TYCPR01MB88047C83A1CE49648667437B8B8DA@TYCPR01MB8804.jpnprd01.prod.outlook.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-32-ben.horgan@arm.com>
In-Reply-To: <20260112165914.4086692-32-ben.horgan@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-01-16T10:34:27.154Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB8804:EE_|TY4PR01MB14689:EE_
x-ms-office365-filtering-correlation-id: 82168fb7-1c46-4d01-2050-08de54ead32a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|1580799027|38070700021;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?UklBWnBuZG45NWMzMFRBWkVVVk1jeHkvWnNHek02RjVERC9MdnVZMjNZ?=
 =?iso-2022-jp?B?azFFQ281N1dsbFVOUnFxUTR6RHN2a0JqSlBvQnVYaVJBV0ZxSWQ0Ym4w?=
 =?iso-2022-jp?B?U0RObG9QalowZTVYdnRoNi9aeXZZWmFTL1Vlc3VKWldyenpXMXBJd1JX?=
 =?iso-2022-jp?B?UytVenJiNDl2c0cwUkxEWFhSV3JJbnhhbUp3bUsybGp1VjFUUXNKNlhE?=
 =?iso-2022-jp?B?eDVnb1NLRlpOYW5lbFdJcVYzWFE1Wm1PU25uaktzcDhCRmVYNkFkWlFU?=
 =?iso-2022-jp?B?VWdGQnRCQkRtTDFxaWhsU042UkRQejREZzNscFdYNWEzamg1bHFLSGI4?=
 =?iso-2022-jp?B?d1RXemt2NWdaaXYweFdpbGhtQUVLV05CRHdQc2pHZDNiUGlNbUM1aGU2?=
 =?iso-2022-jp?B?bmtLTDBVZ3diM3RLTlVXdEc3K3RsRWxjS2NjaVVZQ1hFcmE2T0ZIMUtK?=
 =?iso-2022-jp?B?OTF6aGNsWlVZK0kvaUI2RVByNDdJMWROSlA3dStrdkRTUlk4ellzQXh5?=
 =?iso-2022-jp?B?ZWtvSHNPZ3M3Q3FXUDB0ZDFwWHd2OEN4NDJaY0VFcEg5amxGWHQzaEtG?=
 =?iso-2022-jp?B?blV5QUFPN3ZCZUd6ZjNWWE45NzlVaFhrdDQ5UTB3OGJGOThraDNNQm9L?=
 =?iso-2022-jp?B?OEhIQU5CeWFMUEdKcE4yK2ZTUUJOcUF0QmtPWlhhNW9Ka2FnY2JLSmFj?=
 =?iso-2022-jp?B?Y05udGRZMm1kQy9sK0tXWTFoU1BoTnRHenZYL1JNaERybldPZktrM0tR?=
 =?iso-2022-jp?B?VnVlRDNnNk5CWE5DZ2pIVWNYSHlLQjRPNnFFYVlkTzUxOFVrZjQvVmlI?=
 =?iso-2022-jp?B?L01XT3kxekdDZG5lRGhOWVM5OGQ5M2Jma0VoVzY2azYyREI0TkNDc1ZL?=
 =?iso-2022-jp?B?bXU2K0Z5cTBydU1MNFhrekVoSE90bGF3MWtRY3kxZVhnbEZyeXFvSUZG?=
 =?iso-2022-jp?B?am11c3dLL3FXdE1KTzZzRWxHQTlhck1kYWtLRUtaTWEwYU5JSmcyeDEr?=
 =?iso-2022-jp?B?STFBNVVJdjRpQkl1cGluNVpQdWMwdm9ScjF1UlV0VkxmRUhpR29pcnpo?=
 =?iso-2022-jp?B?R2o5ck1wNlFOVk93eGQ0R3VVWHpuRDgzcVo2T01TMmZhN3RpNzZVRUpE?=
 =?iso-2022-jp?B?bG4xWi9CVjB1Rk9pN3FheVFpbXNoUlVLTnhQU2dPZjFPc1Bra1ZwUUM4?=
 =?iso-2022-jp?B?WWRtRFZGMytyZm5aWENKZUVwTzNETXNnS0wvWk5VT09aODcrMGl5Qjdl?=
 =?iso-2022-jp?B?cUFvZmJyWGRsWnJBWWxQVVBJZGsxZVBvSmhuemJOd3ZhRkF2RkpyT2pI?=
 =?iso-2022-jp?B?M3Y5UUU0LzZDMmhMdnA1STJydjdSOCtRODJSVzZrYkZkd0s2TDRsWEM0?=
 =?iso-2022-jp?B?TU5RWFZ4VGV0U0tUOUJiZG1pRlpVV2F5YUZDREg3RGV4ZDdkUDBjVzhH?=
 =?iso-2022-jp?B?YXlJVUFHd3pOQ0VoUnNMRUR4cTBpMGtFSUVpU2FzbTRrQ0dnejNWNDM4?=
 =?iso-2022-jp?B?NzJ4SnZNLy9IYkp1SFhQM3djNDVaMk5lakZqaW5BUTIzWGhWUCtpWlZu?=
 =?iso-2022-jp?B?ZUdvSzBGV25IRjNCTldOeGUrOHoxbmZDcVdGNjBUUnc5cVFmQ2R5VzVy?=
 =?iso-2022-jp?B?VlZyVncrU0NBZGZHelUxeDFtc1lHRmFXUUhKbWlyeXYreldaZ3krbERk?=
 =?iso-2022-jp?B?L0hkaktrNjJnd1JMRHlQY1N5Lys2Y1FQV3NJR0pXellhQ3pidHRyV0o1?=
 =?iso-2022-jp?B?ZTdjS3FSNDRYdXNseks5NG9sR2pnUUdyVTF5dnU1a1RWUzFrTmxCdzFT?=
 =?iso-2022-jp?B?MWVMSjhMUisvSjhMcTU5WUdNNGt5SldpY3BWU2F4ZDJCVkRHSE5JM1VI?=
 =?iso-2022-jp?B?VGFQNXJ2dEgrVHBWanN5ZmFUR2lOUU5mT1VTTGFHTDdxWGp3WGx0a1ND?=
 =?iso-2022-jp?B?V1ArZ1VGQ0VTR3JCK2NPMWJOaEVjZXRWOVFyZVlmdi9nRmlTem02R0NK?=
 =?iso-2022-jp?B?b3hWRjBNLzF5ekJLemJLcU9FZHNLeUoyNHdVb1FUSjRuemxZUUQwSGFi?=
 =?iso-2022-jp?B?WGROek5uNFMrMkZjZkpCTC8weG5sUDdFMnFWRzBlWlE0UytpNkkyRGp1?=
 =?iso-2022-jp?B?cnJVM014WDdUWXpnazB3WnNkV2Nwb1VuYUhkdjV1cG14VUZZNjY2Vk43?=
 =?iso-2022-jp?B?U2tONVZST2ExTnc0Lzl0Yk45WTFKN1c5TVhRaEUrcERyRHl2clNETHRi?=
 =?iso-2022-jp?B?S2Zrb3pUbTFHa1NSZ25kNUJSZTdBb1BRVnM0YUFCVy9sK3pDQzlidTVM?=
 =?iso-2022-jp?B?RnIvM0Q0MkR1Sk93dWdJaFBoNWFQdUJzRUJHSDBWeXBiZlVLMVE2QlZ0?=
 =?iso-2022-jp?B?OE1tYjk1ZFRyR1JRdzArbTZIaGo3MjZwbm0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB8804.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(1580799027)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?emZWS1pwYmgyNVRlalJhVkFWRkFRbGZHbE0vQWRKSzIyaG5DaG5zM09p?=
 =?iso-2022-jp?B?Tzg5eDVmb1ZHZVg1Tm1UU1RyMWtKaHE1ZUtncVkxY0ltNEhvaEhvenFC?=
 =?iso-2022-jp?B?R0l0MU0rTjE2NjNjUzNkYkhLbjZCTWlEMG8yZ3NNYTA4MElTWE9rSUYw?=
 =?iso-2022-jp?B?ZkJwSHo3QmlUZlV6OWFRb2NYWVA4emo1ZTVEa0ovZmcyaXk1Y1pWSE14?=
 =?iso-2022-jp?B?RjFXdUgveDdUY1pXMXNvWWNlNUdyd0tzaHMxWm1Ub01VUFM5b0RsMjJs?=
 =?iso-2022-jp?B?NENGRmhSVDI2dy9RcXNxcUl6UUdmdEtxN2lwN3hjenpYWHVkdW1hQTIw?=
 =?iso-2022-jp?B?dkxSS2pJWEJUUXRpYzVGYWxpT0hjcFpLNERoN1JBN0xFVk9CQU9MajNR?=
 =?iso-2022-jp?B?Z29Rc2gvYnJvOGhvSllDTUZDYnZxWHozRUprWnpxZHVpMmFscDRqMWJi?=
 =?iso-2022-jp?B?ajhvNXkzeTdMMkZZb05ZUWJBRmJzcFBGV0lSTUNOZ0JueTBpSVphVzBN?=
 =?iso-2022-jp?B?OTJxY2Y1MjZPNVMwSzhkVFBrdVY5WVAxUWZtOGl6WUZsbjE1dnNTS3cw?=
 =?iso-2022-jp?B?SGtYbFpDSUNFSStRWGdMOHFlV3JNZzlCYlZRRTZUK3RjZms2VGF3MXBu?=
 =?iso-2022-jp?B?Y0J5SXM0QzFzYm1CVWdYaEp6aG9zZlQrWHVyWGt3VHB4WGtMV2d1OUxr?=
 =?iso-2022-jp?B?bDhhVXpmeVAzN0JITXZoQnRUd0JJd2o1MnRZY2I3djFDc1FoaElTN3li?=
 =?iso-2022-jp?B?b3lVVk1XTlJFYkZKTDR5aE5EaDFXWGVYV29wZTJWd2RNZ29qemVvRHNZ?=
 =?iso-2022-jp?B?SHFFTm9BRTNkSkNYV2xwSlZxeWl3WGtyeTFxNUpETG15N2FhUlkzOEV3?=
 =?iso-2022-jp?B?amV5Rm04OEZPWHM5UjRFNGJBbnhubVRGZ2FIVzVOQjNVby9TVkJGS2hT?=
 =?iso-2022-jp?B?ZnRYSlhSNUJUZEVCTDdWTW52dTRRWUM5SDg0NjZVaDY3YWJnKzJoTTkr?=
 =?iso-2022-jp?B?Q1Rka2dFQkpTM3l5dkNnZ3JabEFuVWRoK3dhd0Zmd2I2Zlhwd3JvQjZE?=
 =?iso-2022-jp?B?OTk0KzdET1lFb3hwVFlxU3pkeEtaN29TNVFId1JPQi9ia1NoZEd2VTZt?=
 =?iso-2022-jp?B?RWhZY1hLWWZyOGIvakE2QUh6M1p6QUdaNlpITk93RzdVVnVTd3Z6MGsw?=
 =?iso-2022-jp?B?RCtJOCtpcTI4SG1uR01sMHBjeHFGT0cyLzNJbmg0RUsxRTRBZ3d5Q3A2?=
 =?iso-2022-jp?B?ZlhFSkJVVXNhUVF1WXEwTHBCNi9uaXZWYXBBc1NqdnhTS3phUGtsMFU3?=
 =?iso-2022-jp?B?VG1ZMldwdVBaR1FpWFhRekhKWXdhSkUzamR1Nkt3d1V1Zi9Ib2oxZGdE?=
 =?iso-2022-jp?B?SlFxY0FuWU5WNXVDaTcxeE1mK3owYXpGVTh1eFFQWHFiVFgwQzVWcGVF?=
 =?iso-2022-jp?B?REE1RGhzUjhuMUsycmxnRDZtZEM2SXhaWXdOc0IxTnpBR1FCellZRFZs?=
 =?iso-2022-jp?B?bnp1NjFpU0JyT1dIU0hZM3Rydk5JSlJiOHZ3bDFqb3hJdzRzYnI2SkNM?=
 =?iso-2022-jp?B?Z3pCbU5WR0FKakJ4VEJUMjQwMXYwdm9qVTR0OGpGRmkvQTk5NldpTWpQ?=
 =?iso-2022-jp?B?TXFuN0UrbHk1cS9rNWE4N2d5c05VMTJ6NWJIMlJvQXl4ZG02LzNTTjl4?=
 =?iso-2022-jp?B?Z0J2NjVST3lOcjhBTFQyT0Z6Z3BUL2hWL0k1UFFqaUlEaXhuR2ZvdUI3?=
 =?iso-2022-jp?B?bWtjVWs1SVpYaVZQUnN1czM4d3VRelRQSlRieXFWVGlkcHJZOUw0a0I4?=
 =?iso-2022-jp?B?MkI1S3owSlduNzZjRDRHdHpSZDZndHY1MkQ3OHVYRHoraFlORjRNSkhy?=
 =?iso-2022-jp?B?NnJzdVBXajJ5YTBrNmdnWFZkYW0xV252R2RHeXA2eTh0eXV5MFRrQUFq?=
 =?iso-2022-jp?B?OVo2NnhmUnBRRCthY0VlTHIzQ21uVHBiN0lWMW8raTEzcnY5NUZSWlIw?=
 =?iso-2022-jp?B?aEEyL1ZRaVRndVF4THlDUU50VW1aQUFuMW5acmJlaGYzeHZ1MVVWTUpz?=
 =?iso-2022-jp?B?SHU5RWZ2WUs0S0puaFhqRldncFVMRFh6NjZCS0RTTU9ueFNtbkQ5Q3Vy?=
 =?iso-2022-jp?B?UGhidkhFVTV5KzBITHBJRlhlZUROZkVTQjd3YTVOcUVQOWxCTys5WHpL?=
 =?iso-2022-jp?B?aWVKVjIwemJ2QStKZFVMejBvNFFIaFZQbXd5RE5KSTF5OEIrVnZXemRR?=
 =?iso-2022-jp?B?MmZ4R01pT0VCTERKaTFkY2kvWUZveGwrbzdhalNpcTZxbXg5N21zcW52?=
 =?iso-2022-jp?B?NU9mSDhNS2RSWnFLSDU3TER4WnVJanJKNVBtUjZJMUZ6NjBXaHNIRzFr?=
 =?iso-2022-jp?B?c3k4V3RhOUhMRGhNM1hFVGJDV2ZiRy9aQzA3cCtTUHVmaW1XQy9YVVdy?=
 =?iso-2022-jp?B?QUpQbkNGSm1uZkQxYjBCNlB3QUNqYnAzWGlqNUI1c0RKaWNOYk5WR2xC?=
 =?iso-2022-jp?B?MmFuS0llTmt4aXRYeEhiTE5NbjBvZk1RUG5pUT09?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 82168fb7-1c46-4d01-2050-08de54ead32a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 10:34:27.4671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: onQ2TwE+N9iMqVwYzQgFbVBS8YOdNyIxknbeT57UzF8bbV/rYu+ea0HTULY32V6AyYJDQT9YOSSYyPrj8QN3txBobDyfSmRj9Q+AVmk+X2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY4PR01MB14689

Hello Ben,=0A=
=0A=
> From: James Morse <james.morse@arm.com>=0A=
> =0A=
> When there are not enough monitors, MPAM is able to emulate ABMC by makin=
g=0A=
> a smaller number of monitors assignable. These monitors still need to be=
=0A=
> allocated from the driver, and mapped to whichever control/monitor group=
=0A=
> resctrl wants to use them with.=0A=
> =0A=
> Add a second array to hold the monitor values indexed by resctrl's cntr_i=
d.=0A=
> =0A=
> When CDP is in use, two monitors are needed so the available number of=0A=
> counters halves. Platforms with one monitor will have zero monitors when=
=0A=
> CDP is in use.=0A=
> =0A=
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>=0A=
> Signed-off-by: James Morse <james.morse@arm.com>=0A=
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>=0A=
> ---=0A=
> Changes since rfc:=0A=
> Move __free=0A=
> kmalloc -> kcalloc=0A=
> =0A=
> Changes since v2:=0A=
> kcalloc -> kmalloc_array=0A=
> sizeof(*rmid_array)=0A=
> Return error from resctrl_arch_mbm_cntr_assign_set()=0A=
> ---=0A=
>  drivers/resctrl/mpam_internal.h |  7 +++=0A=
>  drivers/resctrl/mpam_resctrl.c  | 97 +++++++++++++++++++++++++++++++++=
=0A=
>  2 files changed, 104 insertions(+)=0A=
> =0A=
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_inter=
nal.h=0A=
> index 89f9d374ded0..58076abd5de3 100644=0A=
> --- a/drivers/resctrl/mpam_internal.h=0A=
> +++ b/drivers/resctrl/mpam_internal.h=0A=
> @@ -367,6 +367,13 @@ struct mpam_resctrl_mon {=0A=
>           * un-assigned (closid, rmid) are -1.=0A=
>           */=0A=
>          int                     *mbwu_idx_to_mon;=0A=
> +=0A=
> +       /*=0A=
> +        * Array of assigned MBWU monitors, indexed by idx argument.=0A=
> +        * When ABMC is not in use, this array can be NULL. Otherwise=0A=
> +        * it maps idx to the allocated monitor.=0A=
> +        */=0A=
> +       int                     *assigned_counters;=0A=
>  };=0A=
>  =0A=
>  static inline int mpam_alloc_csu_mon(struct mpam_class *class)=0A=
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctr=
l.c=0A=
> index 3af12ad77fba..2a9efc6c6fae 100644=0A=
> --- a/drivers/resctrl/mpam_resctrl.c=0A=
> +++ b/drivers/resctrl/mpam_resctrl.c=0A=
> @@ -68,6 +68,12 @@ static bool cdp_enabled;=0A=
>  static bool cacheinfo_ready;=0A=
>  static DECLARE_WAIT_QUEUE_HEAD(wait_cacheinfo_ready);=0A=
>  =0A=
> +/*=0A=
> + * L3 local/total may come from different classes - what is the number o=
f MBWU=0A=
> + * 'on L3'?=0A=
> + */=0A=
> +static unsigned int l3_num_allocated_mbwu =3D ~0;=0A=
> +=0A=
>  /* Whether this num_mbw_mon could result in a free_running system */=0A=
>  static int __mpam_monitors_free_running(u16 num_mbwu_mon)=0A=
>  {=0A=
> @@ -76,6 +82,15 @@ static int __mpam_monitors_free_running(u16 num_mbwu_m=
on)=0A=
>          return 0;=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * If l3_num_allocated_mbwu is forced below PARTID * PMG, then the count=
ers=0A=
> + * are not free running, and ABMC's user-interface must be used to assig=
n them.=0A=
> + */=0A=
> +static bool mpam_resctrl_abmc_enabled(void)=0A=
> +{=0A=
> +       return l3_num_allocated_mbwu < resctrl_arch_system_num_rmid_idx()=
;=0A=
> +}=0A=
> +=0A=
>  bool resctrl_arch_alloc_capable(void)=0A=
>  {=0A=
>          return exposed_alloc_capable;=0A=
> @@ -120,9 +135,26 @@ static void resctrl_reset_task_closids(void)=0A=
>          read_unlock(&tasklist_lock);=0A=
>  }=0A=
>  =0A=
> +static void mpam_resctrl_monitor_sync_abmc_vals(struct rdt_resource *l3)=
=0A=
> +{=0A=
> +       l3->mon.num_mbm_cntrs =3D l3_num_allocated_mbwu;=0A=
> +       if (cdp_enabled)=0A=
> +               l3->mon.num_mbm_cntrs /=3D 2;=0A=
> +=0A=
> +       if (l3->mon.num_mbm_cntrs) {=0A=
> +               l3->mon.mbm_cntr_assignable =3D mpam_resctrl_abmc_enabled=
();=0A=
> +               l3->mon.mbm_assign_on_mkdir =3D mpam_resctrl_abmc_enabled=
();=0A=
> +       } else {=0A=
> +               l3->mon.mbm_cntr_assignable =3D false;=0A=
> +               l3->mon.mbm_assign_on_mkdir =3D false;=0A=
> +       }=0A=
> +}=0A=
> +=0A=
>  int resctrl_arch_set_cdp_enabled(enum resctrl_res_level ignored, bool en=
able)=0A=
>  {=0A=
>          u32 partid_i =3D RESCTRL_RESERVED_CLOSID, partid_d =3D RESCTRL_R=
ESERVED_CLOSID;=0A=
> +       struct mpam_resctrl_res *res =3D &mpam_resctrl_controls[RDT_RESOU=
RCE_L3];=0A=
> +       struct rdt_resource *l3 =3D &res->resctrl_res;=0A=
>  =0A=
>          cdp_enabled =3D enable;=0A=
>  =0A=
> @@ -138,6 +170,7 @@ int resctrl_arch_set_cdp_enabled(enum resctrl_res_lev=
el ignored, bool enable)=0A=
>          WRITE_ONCE(arm64_mpam_global_default, mpam_get_regval(current));=
=0A=
>  =0A=
>          resctrl_reset_task_closids();=0A=
> +       mpam_resctrl_monitor_sync_abmc_vals(l3);=0A=
>  =0A=
>          return 0;=0A=
>  }=0A=
> @@ -321,6 +354,11 @@ static bool class_has_usable_mbwu(struct mpam_class =
*class)=0A=
>                  return true;=0A=
>          }=0A=
>  =0A=
> +       if (cprops->num_mbwu_mon) {=0A=
> +               pr_debug("monitors usable via ABMC assignment\n");=0A=
> +               return true;=0A=
> +       }=0A=
> +=0A=
>          return false;=0A=
>  }=0A=
>  =0A=
> @@ -597,6 +635,8 @@ static int __alloc_mbwu_mon(struct mpam_class *class,=
 int *array,=0A=
>                  array[i] =3D mbwu_mon;=0A=
>          }=0A=
>  =0A=
> +       l3_num_allocated_mbwu =3D min(l3_num_allocated_mbwu, num_mbwu_mon=
);=0A=
> +=0A=
>          return 0;=0A=
>  }=0A=
>  =0A=
> @@ -736,6 +776,19 @@ static void mpam_resctrl_pick_counters(void)=0A=
>                               mpam_resctrl_counters[QOS_L3_MBM_TOTAL_EVEN=
T_ID].class);=0A=
>  }=0A=
>  =0A=
> +bool resctrl_arch_mbm_cntr_assign_enabled(struct rdt_resource *r)=0A=
> +{=0A=
> +       if (r !=3D &mpam_resctrl_controls[RDT_RESOURCE_L3].resctrl_res)=
=0A=
> +               return false;=0A=
> +=0A=
> +       return mpam_resctrl_abmc_enabled();=0A=
> +}=0A=
> +=0A=
> +int resctrl_arch_mbm_cntr_assign_set(struct rdt_resource *r, bool enable=
)=0A=
> +{=0A=
> +       return -EINVAL;=0A=
> +}=0A=
=0A=
$ echo "default" | sudo tee /sys/fs/resctrl/info/L3_MON/mbm_assign_mode=0A=
default=0A=
tee: /sys/fs/resctrl/info/L3_MON/mbm_assign_mode:Invalid argument=0A=
"return  -EOPNOTSUPP;" might be better.=0A=
=0A=
Best regards,=0A=
Shaopeng TAN=0A=
=0A=
=0A=
>  static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)=0A=
>  {=0A=
>          struct mpam_class *class =3D res->class;=0A=
> @@ -811,6 +864,42 @@ static int mpam_resctrl_pick_domain_id(int cpu, stru=
ct mpam_component *comp)=0A=
>          return comp->comp_id;=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * This must run after all event counters have been picked so that any f=
ree=0A=
> + * running counters have already been allocated.=0A=
> + */=0A=
> +static int mpam_resctrl_monitor_init_abmc(struct mpam_resctrl_mon *mon)=
=0A=
> +{=0A=
> +       struct mpam_resctrl_res *res =3D &mpam_resctrl_controls[RDT_RESOU=
RCE_L3];=0A=
> +       struct rdt_resource *l3 =3D &res->resctrl_res;=0A=
> +       struct mpam_class *class =3D mon->class;=0A=
> +       u16 num_mbwu_mon;=0A=
> +=0A=
> +       if (mon->mbwu_idx_to_mon) {=0A=
> +               pr_debug("monitors free running\n");=0A=
> +               return 0;=0A=
> +       }=0A=
> +=0A=
> +       int *rmid_array __free(kfree) =3D=0A=
> +               kmalloc_array(resctrl_arch_system_num_rmid_idx(), sizeof(=
*rmid_array), GFP_KERNEL);=0A=
> +=0A=
> +       if (!rmid_array) {=0A=
> +               pr_debug("Failed to allocate RMID array\n");=0A=
> +               return -ENOMEM;=0A=
> +       }=0A=
> +       memset(rmid_array, -1, resctrl_arch_system_num_rmid_idx() * sizeo=
f(int));=0A=
> +=0A=
> +       num_mbwu_mon =3D class->props.num_mbwu_mon;=0A=
> +       mon->assigned_counters =3D __alloc_mbwu_array(mon->class, num_mbw=
u_mon);=0A=
> +       if (IS_ERR(mon->assigned_counters))=0A=
> +               return PTR_ERR(mon->assigned_counters);=0A=
> +       mon->mbwu_idx_to_mon =3D no_free_ptr(rmid_array);=0A=
> +=0A=
> +       mpam_resctrl_monitor_sync_abmc_vals(l3);=0A=
> +=0A=
> +       return 0;=0A=
> +}=0A=
> +=0A=
>  static int mpam_resctrl_monitor_init(struct mpam_resctrl_mon *mon,=0A=
>                                       enum resctrl_event_id type)=0A=
>  {=0A=
> @@ -857,6 +946,14 @@ static int mpam_resctrl_monitor_init(struct mpam_res=
ctrl_mon *mon,=0A=
>                   * group can be allocated freely:=0A=
>                   */=0A=
>                  l3->mon.num_rmid =3D mpam_pmg_max + 1;=0A=
> +=0A=
> +               switch (type) {=0A=
> +               case QOS_L3_MBM_LOCAL_EVENT_ID:=0A=
> +               case QOS_L3_MBM_TOTAL_EVENT_ID:=0A=
> +                       return mpam_resctrl_monitor_init_abmc(mon);=0A=
> +               default:=0A=
> +                       return 0;=0A=
> +               }=0A=
>          }=0A=
>  =0A=
>          return 0;=0A=
> --=0A=
> 2.43.0=0A=
