Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010029.outbound.protection.outlook.com [52.101.229.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18C04B8144
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 10:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767868972; cv=fail; b=e6feUe6oELpvHaijxKHBsJpOQfoNtRU5V4O1ACC+YPZjz3xLn9fx/q1SyS41tN2lZQA2tco4SYc+yjurWxj4iPZAGKUi64ROADRfkC6nSH6cwi37rfhgSpi2l1PNl2s91Z7kqPfMcPDjzXXaUKIN6ag44/T+1oDCk6c42b2VOVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767868972; c=relaxed/simple;
	bh=nqAC3WtbgO5vMh5gLfZNmmst8Ex8dl9IxZ7C0iHKN6E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i9jScaXF2wnmFUoDAfqVa4NLdl7TIugO4KpHiRe3kuQVKxSHO0MSZq9HV+72ifh8RY015/eYmJFwhqPAcP0aHjgEl/tgaw/7ZVLOdlyv8L6kKFMcoykZcbccIT8xNaEULs2VR/KUDJfsFWJjdnYkH/id4tECMqW7+9gpF2hd8E0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=fujitsu.com; spf=fail smtp.mailfrom=fujitsu.com; dkim=fail (0-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=K00QH0g5 reason="key not found in DNS"; arc=fail smtp.client-ip=52.101.229.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="K00QH0g5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RqguplJcvoiXhuAdmgN7VG9xEhM9seNbj8wLk9ZuQlLyB7h6u/td0VBV/Ykwq0YBUs0IHCbow44LLEmBl+r6jd9rTnFxNtggKrLK5nNWpAI1f/fmhiAy8Ty7EJBV9xQCjhIAG5i4Ld4pa9pEQ1Mm72otK4ZEJE3Efyw4COfJ4ZNEiX7ORlWteDa8Klj/ROqG6WG3PAI4uSdXj1g+Wv5ZFzBE2dzOR8Bwan1VChMPblrVB05SguMKwOimCyxtmZQiugyQGppLtn5KwKqpOub8P6NMjyy9USwmrFAODNBOYUII4hWwTXBk0aV2PrvYVpT5trP4CgGemDnoIM3/jYGEwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UsbvEg/IN7D5g3lsspBtjyfTCq5j2GyZiLE1o941TDA=;
 b=H8jHK16K3qmrtmi4ZctU+qgbKUdo/HUeOJyoe5kRnP8AQoEmEFheT72Qkn41ZKPZ/S/S5MV+VsoFKzw7J8fsdoEkeHrOEJfMEfieY+MU5qYswN9+osvqaFszil4GGGG5vJ5HxNH99ahHGKLc2v9U7tlPcAH3DFQAhXEnlX6RBGhWIq6F4l5Mqvq4Fy+9otiXAz6oJtT7fwQ6zPfwZwe+8+9NbJSpLPikuV5/f0whIqrOzVw014JV01LCMjX6yduJ47QEpWGFy2KHZdy9MXFOHV2/2gqMZEsGfBpv7oomp1bxJ0EHjHJ8hmD7mGQGx/T8cQzpfBx/wSpRcy9D7ZE7wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsbvEg/IN7D5g3lsspBtjyfTCq5j2GyZiLE1o941TDA=;
 b=K00QH0g5PyxHXcRi6N4WgrYI43gXMe08jWVmeDBveHC4t9AFIh4uFrPkpE0wcM1CXULgiW4FwSlKvPYV5ys3J9MDhZwpFUTofeQwZP1c3f0eLfCuOyoa198z4kKMLf8XWhiOWTMFOB8+9pbQysF6DXmMdzbipMgSzmexYCg+D5ytvl1lvxVV608igdVHAeNsQEVMwnQhTd3ILBViHRjMKcO3f8aIuJYijdQm8vxhXbgW/EhiqnoLDpCZbbWjcVQxaj7I8YekSwKzWCLPgINzHSZkXGuuAfJfv/eJgsBY6nxi6XE4Q45o5OIXiVaTDZ3BtanY3CxIxH4COKapoLoYJQ==
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com (2603:1096:604:15f::6)
 by TY4PR01MB15081.jpnprd01.prod.outlook.com (2603:1096:405:280::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.0; Thu, 8 Jan
 2026 10:42:38 +0000
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa]) by OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa%6]) with mapi id 15.20.9520.001; Thu, 8 Jan 2026
 10:42:38 +0000
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
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Zeng Heng
	<zengheng4@huawei.com>, "dave.martin@arm.com" <dave.martin@arm.com>
Subject: Re: [PATCH v2 25/45] arm_mpam: resctrl: Add support for 'MB' resource
Thread-Topic: [PATCH v2 25/45] arm_mpam: resctrl: Add support for 'MB'
 resource
Thread-Index: AQHccRNFfpG5gKgmjkanwRk8L+U/wLVINKC3
Date: Thu, 8 Jan 2026 10:42:38 +0000
Message-ID:
 <OSZPR01MB8798E323F3DC4A528C411FB58B85A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-26-ben.horgan@arm.com>
In-Reply-To: <20251219181147.3404071-26-ben.horgan@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-01-08T10:42:38.383Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB8798:EE_|TY4PR01MB15081:EE_
x-ms-office365-filtering-correlation-id: fa4a44d2-a37e-487c-6f6d-08de4ea2a4a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700021|1580799027;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?R0Z4eURDWm5tL2pPUE5BT1ZoM05BTmRvaXk5VHlnVEJJUVJ1cFZETFE0?=
 =?iso-2022-jp?B?cVpjU1ZUTlZQM2hXaDZaSnhhZVJHQXVVU0ttcFZuckNMZ2pxc2VxYlBU?=
 =?iso-2022-jp?B?UTQyNVFhdVNYSDV6d0xXQVVIaGJiZjFWeDBodFRXNHNmcUdOMlJMaWVl?=
 =?iso-2022-jp?B?eU1UREdybzE4UXM3V2M0c0xSSjVZOEVBMENyOHd0dm9qb3lpcG9kQldC?=
 =?iso-2022-jp?B?bUZHemw4ZFdESS85RGFUWXFtd215TGlYTlozbGM1dWZpSTFLWUNRR2N1?=
 =?iso-2022-jp?B?SmJqSmh1SFBLQXlTbzRkY0pMVm5ia2tLNy8vTVFqdFZBS2VxVERWQlhX?=
 =?iso-2022-jp?B?b21LWjBjMkZJZi9HaGdSaHI3Y2c0Z0lCc1hRMzNaOUpOOW1LNHFXNDhI?=
 =?iso-2022-jp?B?UEU0bGVrai9rMkFaY25Nc2VVRmQ1WWZUdC8vcVRIbDQ2MWZrV0UyM0Fn?=
 =?iso-2022-jp?B?emtiQlRoMGpySHNOWXNGWXJEdzRPdkduMjZZMlFwK2lwYTV0MnljRmNV?=
 =?iso-2022-jp?B?TUxWZWYrN1MveWhVcU5JL0tDaldTdGpaNVlCMnIyMHZCWDB2ZXNwaW5Q?=
 =?iso-2022-jp?B?MFlWS1haRXlHNzB0VUNQZ1gyOVhIWEsxelVtSkYyYUd5VHErOE04cEZB?=
 =?iso-2022-jp?B?ay9KL0tlZytqL0N5RFl0STMwOXFPMXNSL2pCSC9ad3ZZajkxQjM2eXZD?=
 =?iso-2022-jp?B?bFl6OWxsQ2FqUTRiRVZkanFPRmhDVkpiSThSbDRNb3FXK2REV0JRVFpC?=
 =?iso-2022-jp?B?bUh5eVNLNXZZQmQ5NE1rVUZITFhOdjNSbkR4TVdYOGU5RG5RUklNcDl5?=
 =?iso-2022-jp?B?ay94aW5BN25Wd1lQSmFsSWVDY1BiK3FjQ1RaNktDTFRpamIyR21WVlR4?=
 =?iso-2022-jp?B?SVBGU3hMeTVDVXNiSHZQRHlxVnB1QS8xQ0NydmQ4RVpSVk55c3l1NWZ3?=
 =?iso-2022-jp?B?anBGL2lzVCtPRnc4YlBXQ0lSY2lyWldnS0hvanZmTTl4MDdmVXBHdmZu?=
 =?iso-2022-jp?B?Y2ZpSmxjUHRRbE1yU2hqd3FpWjUrQzZYZnh6NkRJMnFRUldKVGpabG0w?=
 =?iso-2022-jp?B?TmEzUndocmJDRnJNdk0rZ1hQdkJPRlVtd2J4cUhjWTRCRU5MYlorTGVC?=
 =?iso-2022-jp?B?OHA4dkJtQmpkdlRMOTVxdi9JcFNySTVlQWEwdlNwWXAwQzNyY25YQWFs?=
 =?iso-2022-jp?B?L3Q0VGlmV25zVlh0OXhXMWFpMFFodWFpU2liWWh4NGJ2bkdpR0dhOVV2?=
 =?iso-2022-jp?B?Z1AvQXFqUzVSREwwSEc5ZHBYcDEzZm51OXBTdWhNUVZ1djZOVytzODBh?=
 =?iso-2022-jp?B?ZFZKSVZGZ283UHhQTStUR0I5QU9JelY5TmptN0l4cXI0ZmdXaVY2ODh6?=
 =?iso-2022-jp?B?UTgxZ01IZXVmekJnUFZVaFhscmloaEdKNUxUTWQ1djYyK0UrU2paby9I?=
 =?iso-2022-jp?B?Q0JKd1FPRitKN1JzOENZL3ozSCs5OG5zaGROUUpGdXBnWHJkTFQ1L0Y3?=
 =?iso-2022-jp?B?SkdvUmJaYkhiNkp3bDhDY1dCQVVuL3NvaE9lMm8rb1hPOHkwM2Q3QURG?=
 =?iso-2022-jp?B?U2FYNXFIcjkzalJxQ3IxRm9pYitsN1ljT29qTDA5TURsR3lhcVBMVUZG?=
 =?iso-2022-jp?B?N1ZRdkZuNGxKaWJHeTU3SEhqL0V2ZDJnS0ZrS1lHVmRQaWs0SkRmRnNF?=
 =?iso-2022-jp?B?Z0FGS2xabkQwYktUSVFuSjZheDB6cmplKysvM3lMZjZZdnZoYWtFZkxU?=
 =?iso-2022-jp?B?RHVLcS92MklMTVpHUE1NNGZoNmJZNEtFM2ZVTXdjWTkyalVNRFE1QVNW?=
 =?iso-2022-jp?B?V0NTWDF5aVJ5eFJJT1RXZlNGUE5aRmNTYWNVZTAwbGtsY2dJakJZSDBy?=
 =?iso-2022-jp?B?QjRNYjdvS0t2TFhJMTlqR2Fpd2tCVHdmUWpSek1leEhpN0huN21lbFMz?=
 =?iso-2022-jp?B?UkNONXR3cFgyRGRDbmJpY2FPWk1PaGx5SVVSRzJQQ0o4UmVyYkVsQzd0?=
 =?iso-2022-jp?B?bGE1N0s5K3haSENiLy9pUUhMTVlaR05kbHR4M3dndDVvTjQ1VnZ0aFBE?=
 =?iso-2022-jp?B?VHpLdHFaanJvNkN5b0J4U2R3ME43R2syYVNkMGpYbEJIQnNyUlRuZnEz?=
 =?iso-2022-jp?B?SFo4Q0NuRi9LZm10QlBEZFNnMC9NOEFETHJCbUN0TGt1SkZENUNkM0xE?=
 =?iso-2022-jp?B?ZDI4Zk9mTVZ6Zk50V1BsZjlDNUp4OEVIL3k0T1dIWVQ4Mlo2VGlVVjNN?=
 =?iso-2022-jp?B?bFBUQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB8798.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700021)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?VzV5VXorVDlpaGNZanduM0dGMUFybWtBanUrZUdGOWk2eHRlWkFlc3NT?=
 =?iso-2022-jp?B?Wk9oR2FPZ1ZOdmYvYjVzSjNxV0RQdmpJWDU3OUthbmw0c1ltcVVmaFRx?=
 =?iso-2022-jp?B?MUZLTXBmTVJYZ1V6cDMzRVIvUUZBVnRLa2ZnbldzVkNRV242c1NweEUr?=
 =?iso-2022-jp?B?ZU5ldk05ZkpPL0szUk4reTdQbi9HL1pOUmF6YUNhM0ZHRGVITHJFYjJU?=
 =?iso-2022-jp?B?RmZLeWdxUW12d28zWWllM3BVNlMvUU5WNnR0MTB5TmdjaWJ2U2k3dU9Q?=
 =?iso-2022-jp?B?OWE5SE9LMk40S0ExZUtXVDFza2tVN2g3Ryt3dmxLSFFTOTY3ZXMvNFJn?=
 =?iso-2022-jp?B?amZqd1AyekpXOGZ4cndRSDc5WXBEYTBsOUR2ZEs3dzdtNVRUMXk0RnVi?=
 =?iso-2022-jp?B?MGlFS0M0N3dkWUlEbnVGVFBJSm1VR0M2bDc0anp3UytCZEVlaC91NGF1?=
 =?iso-2022-jp?B?d2lWMDZGdmVVTFZKbkgxWHlZM3k4RDhpMzNuQ24yK0h4cm5VZzl2Z1hJ?=
 =?iso-2022-jp?B?TUREc1NWUFJmakhCdFhUQXVsUG1rSDFMWHZWZUUybklYOUdvaVg0Y2Rr?=
 =?iso-2022-jp?B?aWNUWjJ5bzd6SksxQ29SWFJ6ZjI5SXpIc1hrb1o4KzU5Slhxd3VRdnFO?=
 =?iso-2022-jp?B?cnoxVlo0K3dyeXFxZWtseENYRDIxYVF3ZnlQMUJTSVU0cHRxMWNPOTFB?=
 =?iso-2022-jp?B?QmxKd09zc2ptYnVEVzVEWFZsTnVyaUdhTzd1bkY5dTdmWCtqaWVja3RP?=
 =?iso-2022-jp?B?R1ZWTDBrZHJsa3ZaQjNhaG5oVDFlUkxrNHFvYk1reDVOb3dEeVVpMTNZ?=
 =?iso-2022-jp?B?Q0Zna1dYOEszMUYweFdmQUtmWjNiT2c5NjhoT3N2WHFrMW0rd2hGYUJ0?=
 =?iso-2022-jp?B?WFAvN1c4cG5yblBGdStpMmd6WjhWei8wOEpCbmxPZUdqQWljTU5oc21D?=
 =?iso-2022-jp?B?Rm9oRnFFZVF3SnRodm91ckFQcC9iUkQ5MUVKUGFCWHhGaEhGMC9iUStt?=
 =?iso-2022-jp?B?aE5RVndzYTlzYlpCOTVJR3MvSXF3eWNDejNnT09seHhpS3o1OXVPTVZY?=
 =?iso-2022-jp?B?Z3k3dmFkcGxyOENBajZSZk1xVnZUcFR1eG10cUFWS0xONTVFcFZja0Nh?=
 =?iso-2022-jp?B?Qk1LYmk3WjRXQ1RvSXg1MXJCSVhYSzNqTldrZjh4SlhkVXZwV1Flay9K?=
 =?iso-2022-jp?B?SnlGaGI5SUtQeG5GZjY5MFNFSjcySGZsT2tQMDAxcFkrcGR6MUtZTjNC?=
 =?iso-2022-jp?B?dFpTTWtGdElrdWxxVmowNmZ2MDl0OUZOenJoakNKSk5pN2g1NWtZVFox?=
 =?iso-2022-jp?B?REF0aURoWVBpd0dNaUhrM1FPbjhPeGwzUDZ2Tmx4OVUxa1ZMRUtNYzdX?=
 =?iso-2022-jp?B?T2VSZkZhZWREZEkxdzlUMjhVOU9nckdtT25peW55eDZjcEF6ZURlLzNh?=
 =?iso-2022-jp?B?WGdXL1NoUktKYkNtTnhUMExPMHRkeHRZYWlzOG92aXlyWkZNdVYrajJ3?=
 =?iso-2022-jp?B?Q1c0amdsejVsMkNCOWc3QzRjTGFnOU0rZCs1RjRDUzNMeEJ4Z3JpU2JI?=
 =?iso-2022-jp?B?dGFOR0hLMmpreUxjSVlkQitmRG9nM3pNZm1IL2p4dDZFSzNTWFAvWE45?=
 =?iso-2022-jp?B?NGFaWTdKS1FQZ2U4b1RpNVd5TG1LbkpCcWIxOHJ3dDhFbithNW9FZTBK?=
 =?iso-2022-jp?B?UXh0TitYM2E3aFczbkduTTZTNHZlU21Vd3h5alVvSTBiMzY5UWlRRm8x?=
 =?iso-2022-jp?B?aE9sMHhxKzVvVE9jdDVOaVZ6cWJLOUQ3cDhNQzFEMWxJUnFVcGprVUdK?=
 =?iso-2022-jp?B?dXpWbG1lb3NWNEVHdXdweWZWTDRuakwxMlh6RG5XaE1Sd2t5bE5nc0kw?=
 =?iso-2022-jp?B?WnBkeWEzM2R0ZzBiWno3djJvVTZOTFBRazdKU3dsbi9QQUJSVldiNzd3?=
 =?iso-2022-jp?B?RzJaa25SazVOUStUSEppcnNzcmcvQmhJclBVNzJYOEJmeDlxM2ZWVjVp?=
 =?iso-2022-jp?B?SndyRmdST3Q0TDVSTU9MQVd0Y2FYc2NTMzQ5a0IwemUySEFrNHlFdkNN?=
 =?iso-2022-jp?B?OEVPcnV4YVllYVpGSThyUzJYelIwT3hqejVnNTNhSTR5eFJ5N3ZoTHZF?=
 =?iso-2022-jp?B?bm91cTZtWEpzUjUremV6WjNTUkRZMUY4R3orL3dFaGVCQlNzT0l1WjJs?=
 =?iso-2022-jp?B?OUVZR0xodzFrejdxVjNDSTdIZlVxN05CY1lsQk51bU9OYUNiejJZd0th?=
 =?iso-2022-jp?B?YkJYdTFBYW02Z2RoSzlwbUQ3NG5qd09nYW9NZHJCYnRIb2ZBaDNxMkpp?=
 =?iso-2022-jp?B?OW1WUmZRcEFURndEbFJKNkEzLzR2Y0xMdVZ1WEE4SnhvdEJScDFOd2Y1?=
 =?iso-2022-jp?B?c3BmS0hCUVdzMytYS1MzaEZJdnZINS9sem9PcERoTEZ2RkZvQlB1dXU5?=
 =?iso-2022-jp?B?dHJOZnFNYzJtUnpVOFJjbkhuUlJDdG1EL2F0UjlrSTVYQW1nODlVWmhM?=
 =?iso-2022-jp?B?UEU1ZmkxRkRUY1BsQ3BLY0pjV1QrNmlwYkZ5QT09?=
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
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB8798.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa4a44d2-a37e-487c-6f6d-08de4ea2a4a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 10:42:38.6697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gx7dF/nxP5aZ3/lMrsuYIOFKSD56f49f5mRvCeu0oEiapdJ57rT5U3lGUs2SPx6CxoXlgMXrNi+7IGbN+AxI+ykXa0IwbIPKmlF/50ZOSFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY4PR01MB15081

Hello Ben,=0A=
=0A=
> From: James Morse <james.morse@arm.com>=0A=
> =0A=
> resctrl supports 'MB', as a percentage throttling of traffic somewhere=0A=
> after the L3. This is the control that mba_sc uses, so ideally the class=
=0A=
> chosen should be as close as possible to the counters used for mba_local.=
=0A=
> =0A=
> MB's percentage control should be backed either with the fixed point=0A=
> fraction MBW_MAX. The bandwidth portion bitmaps is not used as its tricky=
=0A=
> to pick which bits to use to avoid contention, and may be possible to=0A=
> expose this as something other than a percentage in the future.=0A=
> =0A=
> CC: Zeng Heng <zengheng4@huawei.com>=0A=
> Co-developed-by: Dave Martin <Dave.Martin@arm.com>=0A=
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>=0A=
> Signed-off-by: James Morse <james.morse@arm.com>>=0A=
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>=0A=
> ---=0A=
>  drivers/resctrl/mpam_resctrl.c | 212 ++++++++++++++++++++++++++++++++-=
=0A=
>  1 file changed, 211 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctr=
l.c=0A=
> index a20656e49edc..e376841c5596 100644=0A=
> --- a/drivers/resctrl/mpam_resctrl.c=0A=
> +++ b/drivers/resctrl/mpam_resctrl.c=0A=
> @@ -247,6 +247,33 @@ static bool cache_has_usable_cpor(struct mpam_class =
*class)=0A=
>          return class->props.cpbm_wd <=3D 32;=0A=
>  }=0A=
>  =0A=
> +static bool mba_class_use_mbw_max(struct mpam_props *cprops)=0A=
> +{=0A=
> +       return (mpam_has_feature(mpam_feat_mbw_max, cprops) &&=0A=
> +               cprops->bwa_wd);=0A=
> +}=0A=
> +=0A=
> +static bool class_has_usable_mba(struct mpam_props *cprops)=0A=
> +{=0A=
> +       return mba_class_use_mbw_max(cprops);=0A=
> +}=0A=
> +=0A=
> +/*=0A=
> + * Calculate the worst-case percentage change from each implemented step=
=0A=
> + * in the control.=0A=
> + */=0A=
> +static u32 get_mba_granularity(struct mpam_props *cprops)=0A=
> +{=0A=
> +       if (!mba_class_use_mbw_max(cprops))=0A=
> +               return 0;=0A=
> +=0A=
> +       /*=0A=
> +        * bwa_wd is the number of bits implemented in the 0.xxx=0A=
> +        * fixed point fraction. 1 bit is 50%, 2 is 25% etc.=0A=
> +        */=0A=
> +       return DIV_ROUND_UP(MAX_MBA_BW, 1 << cprops->bwa_wd);=0A=
> +}=0A=
> +=0A=
>  /*=0A=
>   * Each fixed-point hardware value architecturally represents a range=0A=
>   * of values: the full range 0% - 100% is split contiguously into=0A=
> @@ -287,6 +314,96 @@ static u16 percent_to_mbw_max(u8 pc, struct mpam_pro=
ps *cprops)=0A=
>          return val;=0A=
>  }=0A=
>  =0A=
> +static u32 get_mba_min(struct mpam_props *cprops)=0A=
> +{=0A=
> +       u32 val =3D 0;=0A=
> +=0A=
> +       if (mba_class_use_mbw_max(cprops))=0A=
> +               val =3D mbw_max_to_percent(val, cprops);=0A=
> +       else=0A=
> +               WARN_ON_ONCE(1);=0A=
> +=0A=
> +       return val;=0A=
> +}=0A=
> +=0A=
> +/* Find the L3 cache that has affinity with this CPU */=0A=
> +static int find_l3_equivalent_bitmask(int cpu, cpumask_var_t tmp_cpumask=
)=0A=
> +{=0A=
> +       u32 cache_id =3D get_cpu_cacheinfo_id(cpu, 3);=0A=
> +=0A=
> +       lockdep_assert_cpus_held();=0A=
> +=0A=
> +       return mpam_get_cpumask_from_cache_id(cache_id, 3, tmp_cpumask);=
=0A=
> +}=0A=
> +=0A=
> +/*=0A=
> + * topology_matches_l3() - Is the provided class the same shape as L3=0A=
> + * @victim:            The class we'd like to pretend is L3.=0A=
> + *=0A=
> + * resctrl expects all the world's a Xeon, and all counters are on the=
=0A=
> + * L3. We play fast and loose with this, mapping counters on other=0A=
> + * classes - provided the CPU->domain mapping is the same kind of shape.=
=0A=
> + *=0A=
> + * Using cacheinfo directly would make this work even if resctrl can't=
=0A=
> + * use the L3 - but cacheinfo can't tell us anything about offline CPUs.=
=0A=
> + * Using the L3 resctrl domain list also depends on CPUs being online.=
=0A=
> + * Using the mpam_class we picked for L3 so we can use its domain list=
=0A=
> + * assumes that there are MPAM controls on the L3.=0A=
> + * Instead, this path eventually uses the mpam_get_cpumask_from_cache_id=
()=0A=
> + * helper which can tell us about offline CPUs ... but getting the cache=
_id=0A=
> + * to start with relies on at least one CPU per L3 cache being online at=
=0A=
> + * boot.=0A=
> + *=0A=
> + * Walk the victim component list and compare the affinity mask with the=
=0A=
> + * corresponding L3. The topology matches if each victim:component's aff=
inity=0A=
> + * mask is the same as the CPU's corresponding L3's. These lists/masks a=
re=0A=
> + * computed from firmware tables so don't change at runtime.=0A=
> + */=0A=
> +static bool topology_matches_l3(struct mpam_class *victim)=0A=
> +{=0A=
> +       int cpu, err;=0A=
> +       struct mpam_component *victim_iter;=0A=
> +       cpumask_var_t __free(free_cpumask_var) tmp_cpumask;=0A=
> +=0A=
> +       if (!alloc_cpumask_var(&tmp_cpumask, GFP_KERNEL))=0A=
> +               return false;=0A=
> +=0A=
> +       guard(srcu)(&mpam_srcu);=0A=
> +       list_for_each_entry_srcu(victim_iter, &victim->components, class_=
list,=0A=
> +                                srcu_read_lock_held(&mpam_srcu)) {=0A=
> +               if (cpumask_empty(&victim_iter->affinity)) {=0A=
> +                       pr_debug("class %u has CPU-less component %u - ca=
n't match L3!\n",=0A=
> +                                victim->level, victim_iter->comp_id);=0A=
> +                       return false;=0A=
> +               }=0A=
> +=0A=
> +               cpu =3D cpumask_any(&victim_iter->affinity);=0A=
> +               if (WARN_ON_ONCE(cpu >=3D nr_cpu_ids))=0A=
> +                       return false;=0A=
> +=0A=
> +               cpumask_clear(tmp_cpumask);=0A=
> +               err =3D find_l3_equivalent_bitmask(cpu, tmp_cpumask);=0A=
> +               if (err) {=0A=
> +                       pr_debug("Failed to find L3's equivalent componen=
t to class %u component %u\n",=0A=
> +                                victim->level, victim_iter->comp_id);=0A=
> +                       return false;=0A=
> +               }=0A=
> +=0A=
> +               /* Any differing bits in the affinity mask? */=0A=
> +               if (!cpumask_equal(tmp_cpumask, &victim_iter->affinity)) =
{=0A=
> +                       pr_debug("class %u component %u has Mismatched CP=
U mask with L3 equivalent\n"=0A=
> +                                "L3:%*pbl !=3D victim:%*pbl\n",=0A=
> +                                victim->level, victim_iter->comp_id,=0A=
> +                                cpumask_pr_args(tmp_cpumask),=0A=
> +                                cpumask_pr_args(&victim_iter->affinity))=
;=0A=
> +=0A=
> +                       return false;=0A=
> +               }=0A=
> +       }=0A=
> +=0A=
> +       return true;=0A=
> +}=0A=
> +=0A=
>  /* Test whether we can export MPAM_CLASS_CACHE:{2,3}? */=0A=
>  static void mpam_resctrl_pick_caches(void)=0A=
>  {=0A=
> @@ -329,10 +446,63 @@ static void mpam_resctrl_pick_caches(void)=0A=
>          }=0A=
>  }=0A=
>  =0A=
> +static void mpam_resctrl_pick_mba(void)=0A=
> +{=0A=
> +       struct mpam_class *class, *candidate_class =3D NULL;=0A=
> +       struct mpam_resctrl_res *res;=0A=
> +=0A=
> +       lockdep_assert_cpus_held();=0A=
> +=0A=
> +       guard(srcu)(&mpam_srcu);=0A=
> +       list_for_each_entry_srcu(class, &mpam_classes, classes_list,=0A=
> +                                srcu_read_lock_held(&mpam_srcu)) {=0A=
> +               struct mpam_props *cprops =3D &class->props;=0A=
> +=0A=
> +               if (class->level < 3) {=0A=
> +                       pr_debug("class %u is before L3\n", class->level)=
;=0A=
> +                       continue;=0A=
> +               }=0A=
> +=0A=
> +               if (!class_has_usable_mba(cprops)) {=0A=
> +                       pr_debug("class %u has no bandwidth control\n",=
=0A=
> +                                class->level);=0A=
> +                       continue;=0A=
> +               }=0A=
> +=0A=
> +               if (!cpumask_equal(&class->affinity, cpu_possible_mask)) =
{=0A=
> +                       pr_debug("class %u has missing CPUs\n", class->le=
vel);=0A=
> +                       continue;=0A=
> +               }=0A=
> +=0A=
> +               if (!topology_matches_l3(class)) {=0A=
> +                       pr_debug("class %u topology doesn't match L3\n",=
=0A=
> +                                class->level);=0A=
> +                       continue;=0A=
> +               }=0A=
> +=0A=
> +               /*=0A=
> +                * mba_sc reads the mbm_local counter, and waggles the MB=
A=0A=
> +                * controls. mbm_local is implicitly part of the L3, pick=
 a=0A=
> +                * resource to be MBA that as close as possible to the L3=
.=0A=
> +                */=0A=
> +               if (!candidate_class || class->level < candidate_class->l=
evel)=0A=
> +                       candidate_class =3D class;=0A=
> +       }=0A=
> +=0A=
> +       if (candidate_class) {=0A=
> +               pr_debug("selected class %u to back MBA\n",=0A=
> +                        candidate_class->level);=0A=
> +               res =3D &mpam_resctrl_controls[RDT_RESOURCE_MBA];=0A=
> +               res->class =3D candidate_class;=0A=
> +               exposed_alloc_capable =3D true;=0A=
> +       }=0A=
> +}=0A=
> +=0A=
>  static int mpam_resctrl_control_init(struct mpam_resctrl_res *res,=0A=
>                                       enum resctrl_res_level type)=0A=
>  {=0A=
>          struct mpam_class *class =3D res->class;=0A=
> +       struct mpam_props *cprops =3D &class->props;=0A=
>          struct rdt_resource *r =3D &res->resctrl_res;=0A=
>  =0A=
>          switch (r->rid) {=0A=
> @@ -361,6 +531,20 @@ static int mpam_resctrl_control_init(struct mpam_res=
ctrl_res *res,=0A=
>                   * 'all the bits' is the correct answer here.=0A=
>                   */=0A=
>                  r->cache.shareable_bits =3D resctrl_get_default_ctrl(r);=
=0A=
> +               break;=0A=
> +       case RDT_RESOURCE_MBA:=0A=
> +               r->alloc_capable =3D true;=0A=
> +               r->schema_fmt =3D RESCTRL_SCHEMA_RANGE;=0A=
> +               r->ctrl_scope =3D RESCTRL_L3_CACHE;=0A=
=0A=
Could you please elaborate why RESCTRL_L3_CACHE is required here?=0A=
=0A=
Best regards,=0A=
Shaopeng TAN=0A=
=0A=
> +               r->membw.delay_linear =3D true;=0A=
> +               r->membw.throttle_mode =3D THREAD_THROTTLE_UNDEFINED;=0A=
> +               r->membw.min_bw =3D get_mba_min(cprops);=0A=
> +               r->membw.max_bw =3D MAX_MBA_BW;=0A=
> +               r->membw.bw_gran =3D get_mba_granularity(cprops);=0A=
> +=0A=
> +               r->name =3D "MB";=0A=
> +=0A=
>                  break;=0A=
>          default:=0A=
>                  break;=0A=
> @@ -376,7 +560,17 @@ static int mpam_resctrl_pick_domain_id(int cpu, stru=
ct mpam_component *comp)=0A=
>          if (class->type =3D=3D MPAM_CLASS_CACHE)=0A=
>                  return comp->comp_id;=0A=
>  =0A=
> -       /* TODO: repaint domain ids to match the L3 domain ids */=0A=
> +       if (topology_matches_l3(class)) {=0A=
> +               /* Use the corresponding L3 component ID as the domain ID=
 */=0A=
> +               int id =3D get_cpu_cacheinfo_id(cpu, 3);=0A=
> +=0A=
> +               /* Implies topology_matches_l3() made a mistake */=0A=
> +               if (WARN_ON_ONCE(id =3D=3D -1))=0A=
> +                       return comp->comp_id;=0A=
> +=0A=
> +               return id;=0A=
> +       }=0A=
> +=0A=
>          /*=0A=
>           * Otherwise, expose the ID used by the firmware table code.=0A=
>           */=0A=
> @@ -418,6 +612,12 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, =
struct rdt_ctrl_domain *d,=0A=
>          case RDT_RESOURCE_L3:=0A=
>                  configured_by =3D mpam_feat_cpor_part;=0A=
>                  break;=0A=
> +       case RDT_RESOURCE_MBA:=0A=
> +               if (mpam_has_feature(mpam_feat_mbw_max, cprops)) {=0A=
> +                       configured_by =3D mpam_feat_mbw_max;=0A=
> +                       break;=0A=
> +               }=0A=
> +               fallthrough;=0A=
>          default:=0A=
>                  return resctrl_get_default_ctrl(r);=0A=
>          }=0A=
> @@ -429,6 +629,8 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, s=
truct rdt_ctrl_domain *d,=0A=
>          switch (configured_by) {=0A=
>          case mpam_feat_cpor_part:=0A=
>                  return cfg->cpbm;=0A=
> +       case mpam_feat_mbw_max:=0A=
> +               return mbw_max_to_percent(cfg->mbw_max, cprops);=0A=
>          default:=0A=
>                  return resctrl_get_default_ctrl(r);=0A=
>          }=0A=
> @@ -473,6 +675,13 @@ int resctrl_arch_update_one(struct rdt_resource *r, =
struct rdt_ctrl_domain *d,=0A=
>                  cfg.cpbm =3D cfg_val;=0A=
>                  mpam_set_feature(mpam_feat_cpor_part, &cfg);=0A=
>                  break;=0A=
> +       case RDT_RESOURCE_MBA:=0A=
> +               if (mpam_has_feature(mpam_feat_mbw_max, cprops)) {=0A=
> +                       cfg.mbw_max =3D percent_to_mbw_max(cfg_val, cprop=
s);=0A=
> +                       mpam_set_feature(mpam_feat_mbw_max, &cfg);=0A=
> +                       break;=0A=
> +               }=0A=
> +               fallthrough;=0A=
>          default:=0A=
>                  return -EINVAL;=0A=
>          }=0A=
> @@ -754,6 +963,7 @@ int mpam_resctrl_setup(void)=0A=
>  =0A=
>          /* Find some classes to use for controls */=0A=
>          mpam_resctrl_pick_caches();=0A=
> +       mpam_resctrl_pick_mba();=0A=
>  =0A=
>          /* Initialise the resctrl structures from the classes */=0A=
>          for (enum resctrl_res_level i =3D 0; i < RDT_NUM_RESOURCES; i++)=
 {=0A=
> --=0A=
> 2.43.0=0A=
