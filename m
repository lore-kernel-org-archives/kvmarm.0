Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F753C8731
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237996; cv=fail; b=Chp3r96qMwGga4BeVhW675ktRFNVOspxSSHq/NGOgHHSFtL2zHESlm27hyAkXC//w/aVJX5s82P9zWDTVmI5UTSDNMPCtvTWwo5742KAkUoDmi85ywOMLJmu/P56W1ZTylelttaL2ED+4ZWvb0dGxR5pPC5ciZTN3RtpRwb7G08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237996; c=relaxed/simple;
	bh=5NJDhH2ftjaBX/Y0brzqfXHoBevQGCcf7o0t5NknVfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HrCiJehjn4M6O8PXeYciPWUE4Qn4S+XYlJjWbIjSeQ/8FaFFg5xNRSsguLDojCzFTFCXlNWxaUVNP6kTn5haCmRvfXIEZu2v1kh6tOWps/7lpqqxisCgVuciv/Fz1JpHtUF9vZpUihStlS5u4JuGiirh9I3s8xvTa278sS9Zb9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=DZaIcmdl; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=nZizmDbv; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="DZaIcmdl";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="nZizmDbv"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZhn1763910;
	Thu, 16 Jul 2026 14:39:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=1rPYAEe28VKl3zt74hrITF/9pIZB2AyzLLGJGVfte
	R4=; b=DZaIcmdljQYf4twzEqmJvr1iu3zKcoySm6ct4deuL9P/BeoGHl5HstAgu
	zfrXt5dP0B4sBmTPx7jIgVl2m99rko8vGOtGQgQOySPmrOAHCcjkI18OsX/8QGte
	iEZxoPdEcmlar2KtL+qfyOIKPYz67AEAWqjd8BzMFWCFPwCwtVEaDVWwidJZfT6v
	09HMrwO4/levw4LGh4Y3Id55Upd9n6SweuKP4XSkRS9LR0D17lzlqT+ALn3jDoNb
	8RvuFiAJkW1Gg6sn4lexS/+fzHmMhynpKHWZFGUqeQwNy8DP2y8Zhxmi+uxQlfeU
	lDSpM9jIGth9a8gGbPkL/CELcKuCg==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-5
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XIOdxYK23udIaZY5soSl9lTKEtwKYecvsbNpmmihHNpoj6G3EQYCj3qYLsC72ZEtt3rCwFkR9uE+A1cKmy1+s0Avq10kTQ+qw50q4mn+2OyGrA3DZn3A5G2Beh88wRNp7kz25tq9ltNdsQ+1DP8e3oJk/V/C+SJT63vmnqG3jKC/pLoFgeyCjXfTb9JCnjViY6IpgXy2T+c15wcAxG9oFcE3fi2dj/RnqfKy3FfawTFaLqtNOlF/6tu0SzymVY13we2vfJ6akzqzHhQjFfvo57F99paBjmvid8ErYUPBjnsDMfyVyp6fgtgIaukQ3WPWPg2CiWTYGGo/I74v+64EdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rPYAEe28VKl3zt74hrITF/9pIZB2AyzLLGJGVfteR4=;
 b=xQuUhkUGM79cjiLcdY/OdsruOLssStOlAj2MNMKGlO/wDuiGbfcPi5iomZ80St+3W7oYAiw4vmgbptbKPs/49bWtU4wluTdfPfixj25kkZYnZ2gvdh4c47pXojMs716GgBtcvsE/A2oZlpl6OQvGiAg0jrPv2C1Z+nVts6QXGRvhmTisnr9O4vpesNmatoSJuuiHKC/xgwDYtYgmPh4u67/6CjuGqAB4tmmDCX94ojG7Y9k3HMFAxYgQLym8CKN+1gK8XhZTZHUBhnztvgBG4IFv+ciOXnBZXQp9QuUA3ND8hlXEeJ43lr8d1e0bFhI9q6mdW8iArPJ/uUT5uFZPyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rPYAEe28VKl3zt74hrITF/9pIZB2AyzLLGJGVfteR4=;
 b=nZizmDbvEypg7urNmJpC1/yuH/hKg/p673EvDPMsWGYaqmUUVn28FwuVg8pp/A0sb3LZuGUzNvLND677uCLjFLJuJr8VOV6tTqK5FWppy+FDvLXYyhHO3zf1bGMkJU859ixGllQnL3ogz4e+bgifB9Ge7rNVZ0DWWlvNQdBLh0pBRzxotCGB4ozEvZ7oRXt7xJDdsgJmRkOc7f6/bL88LE13KHo1s8NoUglK1vZamyC4rqTMqT4mOsExiuAIws3t7kwnHs3c2uXLXIc1vvyiBRpa6fDkiVle6KNrLCRdNSHH1toncyX1G7Krw8b5i60KOWe0uAeij1KhA5Pws3Bu+A==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:30 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:30 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, khushit.shah@nutanix.com,
        prerna.saxena@nutanix.com
Subject: [RFC PATCH v3 04/19] target/arm: expose all ID regs fields as properties
Date: Thu, 16 Jul 2026 21:38:43 +0000
Message-ID: <20260716213858.609699-5-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260716213858.609699-1-khushit.shah@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0071.namprd17.prod.outlook.com
 (2603:10b6:510:325::28) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SA2PR02MB7756:EE_
X-MS-Office365-Filtering-Correlation-Id: baf552d6-9abd-49ed-3a08-08dee382b7b6
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	SQnMoBrEnNOIl4NcRkR9RkPS4idxhwetcb8Q5eScVuI8N4ogPKpeRLZPh6ry0uwvoA1uyTlGbi5fXxgojAUuOInIrYVDThUK2CKgEJiofM73RboK9yalVdsmQcRAgvNK0aXQo2E4kZyhgWgKMgmIXUvXZu+/Av/nPdSy9ZrcmGEVRPBbZUmYI3KNL84ACm9y9CxmIPXxvgd32NtgCjy/kRD7AS6vnNpVxOVfG372OW2kwoBMUuKVgGsSkfIQ9VpxirWZdoiyDDI8B4z0C1p/aOgX/oSt6b1ChVxdVI9hYZAQQEMwGB6JsYXNioO0ayUHaGq3nGUHj6BiOme9m23NNnlxWMb+K8A7jTZEMvqvPUbm/s2xsLzn4Espmspk/6+FQuysipT9TnilpKBOZicGCVjFiRzyiusaTqvl4BnigNBQXKSctsvRx5sB1MA9RjP2w7nWCZh8UGSGOFdAdjyCOyx33e/BL9mbhTiSGGJehDu5BcslpgOyb367+OuBiJEWOYrH6aTNHaejNL2CieZGok5v6zZYoZvKPYsSvLcbPGKhbGxkY7C4Ww0TpJPIg+64IkIWxMUHFYyGtdqVaU2EqjOQNCXMhmLv5dIm24MYyUjQGqxHFDEvPRlIZvwIb15V39BWBYkpj6LFBRBrmaZ1IKhYgXuzK59dboCiHfEBlgQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q2lCojjj7cDtVOp9l6k/NNuB/HWtrWml48ZYd8l7/4kZmCOIj//omrPhqKd+?=
 =?us-ascii?Q?vAD4tX8HUiWAV4rHrB6yvYxNLPCRt+Ak7azEtfpv9sXMyjA1LI0glUlNGiJI?=
 =?us-ascii?Q?ay+SoRU9gAKFM/+mS5Ym/qrp2dI3gcyZG7sYKnJvwMW1e1QS4pX+QddohCCR?=
 =?us-ascii?Q?PNXWTtjfE+so2I9jFQmisnEhnSi36IPRH9men6yvQOOl/NF5dpsuXmRbBwSB?=
 =?us-ascii?Q?WEwVO35YcYNVI43CXk6nTqSVJYK7wsGgVEs/xTZ+F5psh51/BZsL99fi6/Rz?=
 =?us-ascii?Q?WK2qbAyYmgAJFy3tuHarzpwMS+e2u9+nKAQdhpbu0feqVXIwI6stjzeC8aBZ?=
 =?us-ascii?Q?PSowe0cXryeaoXa/WnLPVnoX6UlHEUqgphjBN3kdFzomB5vA4wBcEvo8As3n?=
 =?us-ascii?Q?cyA+mEAut7gMrcZw+QY2GRA83IRz6InErTm6O9FApTy/krALpkqwG7gW0cGN?=
 =?us-ascii?Q?lELD1RQnend1FFJ68anFBXpsiZvI2tMox+5CX4LFauaC0P531/sU1tKLuCZd?=
 =?us-ascii?Q?R2vVSVyYpdGo5iU7Pixcyftgr3AEyOXN/zxGJONEZmahzeOYXAkHvkI83gz4?=
 =?us-ascii?Q?Lyr6/z8iZrYPPVm/9L+zXxruIyapXCLE/EujCF/syItqRP5eD0finqFT/hCe?=
 =?us-ascii?Q?EyU2A7AKj3P561idg2ACSUFYxtM29XBCedphA/WEzGmgOwkBd+4Glvi8odS/?=
 =?us-ascii?Q?s2dhGuBWaFeYIwwdrSZk3O71X0crAu4mua/QTCuo5hZMJkpgEzY/IYYKhnuW?=
 =?us-ascii?Q?ptd39j4DuYWemKbJRVW5dXtda/uubrAiWf0F60huFqozXGk8z2BZjJ/R0Ruj?=
 =?us-ascii?Q?MINr83oZ4YFgdmyJ/owTBGTiUsLM7MjkxP66ZwLvQrv1zYX7Gh6o/6/9beAq?=
 =?us-ascii?Q?0V7arUGdxOo396qedW4PGNioD+aHrcu/Fap76aq2Rqp4fi/ZrWhvSgWn1BZK?=
 =?us-ascii?Q?A6eSh7/K42X2hbZ0f2Ucy10LG9PhjsO8GTxzxUjKBwJS7rrmdn5jGsWxKUp8?=
 =?us-ascii?Q?atUdCizDcnRhXsND8dBfyYOPRow6Rq+k+TiEyI5IXAX1C1Qne2dmZCEBjkGl?=
 =?us-ascii?Q?8yQeOJpHwWls0yYSkrAXuneVBcZWVAK1bLOG2B/Ww6BSUOncykZygOwnWZw3?=
 =?us-ascii?Q?tide/APHDIMORsWRuu52bXpNx5gO/Wo1NPx+qB1QWZIRDeLsbvMLiUsRA9vL?=
 =?us-ascii?Q?dkyQs7zXlOkUymkjuCNbCMvyMegI5AtrKifJLcBJPqJ6604sp3k/srgJN6ba?=
 =?us-ascii?Q?5WzxB7jRYawMofMTnv0krq6SW8ldbYaXP5Dq34eRNqZr4pA8N2aXw0cJHsi9?=
 =?us-ascii?Q?6XslrOPao2X0JoiHjnhMGRpR/5vvFjIMz1TNLeu/qMZyq/6Qbhd6nDeab/RH?=
 =?us-ascii?Q?dKvQaFeGo5vuHRw/Kb52iZWG2hR994Oknbov5fmIFBvvsIWvx3tSuqV+osDu?=
 =?us-ascii?Q?u0V3f76qO3xq9TR63ceMTNMVCw4majVzTY4HoCId7tiXwck+HfLxCfR679yL?=
 =?us-ascii?Q?tG89GGmKeVN3AM2YDxZuMO8DwKHr3Ybvubk15KHj5+vP7g10D+h8tHIbimfX?=
 =?us-ascii?Q?0NwTI8XKN9f8SCteowxNLf0JLpmcCrtFm86gZQ1xuNx+eU6BV44kaZb0k7hK?=
 =?us-ascii?Q?gbNq/n7VZIEugBZMzR0popMnWFsn6/cvo7b9+ZrO7j6MvVhnEEgCoLL1h7l4?=
 =?us-ascii?Q?ClqugvhJTYsXR6L6eACrHIonyFqAVWpvaGINi3bY0NhOh3+9lwlYIlq4ZuHy?=
 =?us-ascii?Q?SpbeSgxBUWdGIiAeovm1XuJXeGXpMDc=3D?=
X-Exchange-RoutingPolicyChecked:
	mprU8wCoDcLJOfJkQnCNBM2+DOLK57Vsr+3yk9XG7VFZKpJ539MMx8N5lZFjwRV+tnRgeQiHOvNQ2RwEkDnDxiJyBJ7dgUtTWsXGg+QtmZXHQJTCmswz2/iXaudqnWElqEERkHBXLoaFBxEBtgIczgZwo+gia7GAzfcRz6u3Kks4QoMY5c/MQNF8PDq060tsiek6zB83IUPVuZVdDz0WQqpkukKb7LlOPWK+xPDr9x4tEa5YbJ54eUL5GwLbcAZpQLzzHU0+kVKW8ly5rqMU7ymB1H9cqhHLtQ4/LoNpgLuZ3zqmQTv8RQ7dM/T0jeai/z+dkmuh98A7ggWpmW2BCA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baf552d6-9abd-49ed-3a08-08dee382b7b6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:30.2099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gct7W8yJoP+9tDIqqCFzGlZgVUWdgAGvOVMsvlGi5HiRBg3s667vvpjPoH3y4zf3ycg0O8ZQhLe4h7lE4TwMtJmeFBN4v56xE5/XlozmFcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX+1RYLvP9h1Bw
 T7xO49TqeZw/VJ+Xww++9uH0yGb88S0fw7EZcb6HNP2F0JwPmnupyqe8dos00xny2zz4vfdemp0
 R53AUnxWpR6qU8luGu9dBOca7eqV14heTzVoZjR79p7Oz2rpN7hsgw4I07fBanRQPMslaTIXuZ9
 EajsFEI5TcXpiwOETbbvPFLMdhKg3W5I1SgJ2hazelW0O8qvbsHQC1fiX3rOui7KZu0Sbb+2XpN
 UJ9EkNjKihX7BX1ATEFtv5bbrYglgP0IlmVnQfo2+bGiVRX2VtdSSXR6NI++ncfgyiS8cke29fi
 oRqPsQ1ycjRPqsBX45SGB5cwPjBRXgoIFU5Uo8E+kgpdK8w1Xc6QVIiGFsSB8pUyojG/YB4D6FJ
 bs7ckr4nCz6UfVz1osytR+ImIFGJ5Czyt7LV5hZtcD8KhoOJ7hrqmCS++vKwbUg69ds7bz7Yo1x
 XkVtGIftYXSeVkHSB1A==
X-Proofpoint-GUID: jhr5thzBiXAkC2h4484wCb9-uPvYttSL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX+/LfOSAkEZ+l
 3FG8vb1CK/JzUtdoONBhDm0+dMWXqHMw3l6XqsSzXqzzlx1qjXEkA3krhOnoXGXC0GITQlXk5Fz
 bs1FGcYa/l8k32GYLRd1IZfNRnwhyrA=
X-Proofpoint-ORIG-GUID: jhr5thzBiXAkC2h4484wCb9-uPvYttSL
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f96 cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=yqO6HB84dvTlIR-rmkgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Upcoming named cpu models layer requires exposing all the ID register
fields as properties.

While doing so also move the code to cpu64.c to make it
accelerator-agnostic, and rename the function to
`aarch64_add_idregs_properties()`.

This makes porting this solution to other accelerators easy in future.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu64.c      | 116 +++++++++++++++++++++++++++++-
 target/arm/internals.h  |   3 +
 target/arm/kvm.c        | 151 ----------------------------------------
 target/arm/kvm_arm.h    |   8 ---
 target/arm/trace-events |   4 +-
 5 files changed, 119 insertions(+), 163 deletions(-)

diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 92a01d4ce7..cdad0fc46d 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -38,6 +38,7 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "cpu-idregs.h"
+#include "trace.h"
 
 /* convert between <register>_IDX and SYS_<register> */
 #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
@@ -644,6 +645,113 @@ static const Property arm_cpu_pauth_qarma3_property =
 static Property arm_cpu_pauth_qarma5_property =
     DEFINE_PROP_BOOL("pauth-qarma5", ARMCPU, prop_pauth_qarma5, false);
 
+#ifndef CONFIG_USER_ONLY
+static void set_sysreg_prop(Object *obj, Visitor *v,
+                            const char *name, void *opaque,
+                            Error **errp)
+{
+    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
+    ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
+    uint64_t old, value, mask;
+    int lower = field->shift;
+    int length = field->length;
+    int index = field->index;
+
+    if (!visit_type_uint64(v, name, &value, errp)) {
+        return;
+    }
+
+    if (length < 64 && value > ((1ULL << length) - 1)) {
+        error_setg(errp,
+                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
+                   name, value, length);
+        return;
+    }
+
+    if (field->arch_vals) {
+        /* this field has some enum values */
+        for (int i = 0; i < field->arch_vals_count; i++) {
+            if (value == field->arch_vals[i].value) {
+                goto valid;
+            }
+        }
+        error_setg(errp,
+                   "idreg %s set value (0x%lx) does not match any "
+                   "arch valid enum value!", name, value);
+        return;
+    }
+
+    /* If the field is RESx or RAZ, it should not be written anything else */
+    if (strstr(field->name, "RES0") && value != 0) {
+        error_setg(errp, "idreg %s is RES0 field and cannot write %ld",
+            name, value);
+        return;
+    } else if (strstr(field->name, "RAZ") && value != 0) {
+        error_setg(errp, "idreg %s is RAZ field and cannot write %ld",
+            name, value);
+        return;
+    } else if (strstr(field->name, "RES1") && value != 1) {
+        error_setg(errp, "idreg %s is RES1 field and cannot write %ld",
+            name, value);
+        return;
+    }
+
+valid:
+    mask = MAKE_64BIT_MASK(lower, length);
+    value = value << lower;
+    old = idregs[index];
+    idregs[index] = old & ~mask;
+    idregs[index] |= value;
+    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
+}
+
+static void get_sysreg_prop(Object *obj, Visitor *v,
+                            const char *name, void *opaque,
+                            Error **errp)
+{
+    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
+    ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
+    uint64_t value, mask;
+    int lower = field->shift;
+    int length = field->length;
+    int index = field->index;
+
+    mask = MAKE_64BIT_MASK(lower, length);
+    value = (idregs[index] & mask) >> lower;
+    visit_type_uint64(v, name, &value, errp);
+    trace_get_sysreg_prop(name, value);
+}
+
+static int
+aarch64_add_idreg_properties(Object *obj, ARM64SysReg *reg)
+{
+    int nb_sysreg_props = 0;
+
+    for (int i = 0; i < reg->fields_count; i++) {
+        ARM64SysRegField *field = &reg->fields[i];
+        char *prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name,
+                                          field->name);
+        object_property_add(obj, prop_name, "uint64",
+                            get_sysreg_prop, set_sysreg_prop, NULL, field);
+        g_free(prop_name);
+        nb_sysreg_props++;
+    }
+
+    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
+    return 0;
+}
+
+void aarch64_add_idregs_properties(Object *obj)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        ARM64SysReg *reg = &arm64_id_regs[i];
+        aarch64_add_idreg_properties(obj, reg);
+    }
+}
+#endif
+
 void aarch64_add_pauth_properties(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
@@ -865,8 +973,12 @@ static void aarch64_host_initfn(Object *obj)
     kvm_arm_set_cpu_features_from_host(cpu);
     aarch64_add_sve_properties(obj);
 
-    /* generate SYSREG properties according to writable masks */
-    kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
+#ifndef CONFIG_USER_ONLY
+    /* generate SYSREG properties */
+    if (kvm_enabled()) {
+        aarch64_add_idregs_properties(obj);
+    }
+#endif
 
 #elif defined(CONFIG_HVF)
     hvf_arm_set_cpu_features_from_host(cpu);
diff --git a/target/arm/internals.h b/target/arm/internals.h
index a632584a4e..7502b6db8a 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -1754,6 +1754,9 @@ void aarch64_max_tcg_initfn(Object *obj);
 void aarch64_add_pauth_properties(Object *obj);
 void aarch64_add_sve_properties(Object *obj);
 void aarch64_add_sme_properties(Object *obj);
+#ifndef CONFIG_USER_ONLY
+void aarch64_add_idregs_properties(Object *obj);
+#endif
 
 /* Return true if the gdbstub is presenting an AArch64 CPU */
 static inline bool arm_gdbstub_is_aarch64(ARMCPU *cpu)
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 892433a612..76583db3f0 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -327,157 +327,6 @@ static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
     return err;
 }
 
-static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
-{
-    for (int f = 0; f < reg->fields_count; f++) {
-        struct ARM64SysRegField *field = &reg->fields[f];
-        int upper = field->shift + field->length - 1;
-
-        if (i >= field->shift && i <= upper) {
-            return field;
-        }
-    }
-    return NULL;
-}
-
-static void set_sysreg_prop(Object *obj, Visitor *v,
-                            const char *name, void *opaque,
-                            Error **errp)
-{
-    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
-    ARMCPU *cpu = ARM_CPU(obj);
-    uint64_t *idregs = cpu->isar.idregs;
-    uint64_t old, value, mask;
-    int lower = field->shift;
-    int length = field->length;
-    int index = field->index;
-
-    if (!visit_type_uint64(v, name, &value, errp)) {
-        return;
-    }
-
-    if (length < 64 && value > ((1 << length) - 1)) {
-        error_setg(errp,
-                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
-                   name, value, length);
-        return;
-    }
-
-    if (field->arch_vals) {
-        /* this field has some enum values */
-        for (int i = 0; i < field->arch_vals_count; i++) {
-            if (value == field->arch_vals[i].value) {
-                goto valid;
-            }
-        }
-        error_setg(errp,
-                   "idreg %s set value (0x%lx) does not match any "
-                   "arch valid enum value!", name, value);
-        return;
-    }
-
-valid:
-
-    mask = MAKE_64BIT_MASK(lower, length);
-    value = value << lower;
-    old = idregs[index];
-    idregs[index] = old & ~mask;
-    idregs[index] |= value;
-    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
-}
-
-static void get_sysreg_prop(Object *obj, Visitor *v,
-                            const char *name, void *opaque,
-                            Error **errp)
-{
-    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
-    ARMCPU *cpu = ARM_CPU(obj);
-    uint64_t *idregs = cpu->isar.idregs;
-    uint64_t value, mask;
-    int lower = field->shift;
-    int length = field->length;
-    int index = field->index;
-
-    mask = MAKE_64BIT_MASK(lower, length);
-    value = (idregs[index] & mask) >> lower;
-    visit_type_uint64(v, name, &value, errp);
-    trace_get_sysreg_prop(name, value);
-}
-
-/*
- * decode_idreg_writemap: Generate props for writable fields
- *
- * @obj: CPU object
- * @reg: description of the sysreg
- */
-static int
-decode_idreg_writemap(Object *obj, ARM64SysReg *reg)
-{
-    uint64_t map = reg->writable_mask;
-    int i = ctz64(map);
-    int nb_sysreg_props = 0;
-
-    while (map) {
-        ARM64SysRegField *field = get_field(i, reg);
-        int lower, upper;
-        char *prop_name;
-        uint64_t field_mask;
-
-        if (!field) {
-            warn_report("%s bit %d of %s is writable but no named field "
-                        "in target/arm/cpu-idregs.h.inc",
-                        __func__, i, reg->name);
-            warn_report("%s is target/arm/cpu-idregs.h.inc up-to-date?", __func__);
-            map =  map & ~BIT_ULL(i);
-            i = ctz64(map);
-            continue;
-        }
-        lower = field->shift;
-        upper = field->shift + field->length - 1;
-
-        /* Sanity check the field is not a reserved field */
-        if (strstr(field->name, "RES0") || strstr(field->name, "RES1") ||
-            strstr(field->name, "RAZ")) {
-            trace_unexpected_writable_reserved_field(reg->name, field->name,
-                                                     lower, upper);
-            continue;
-        }
-        prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name, field->name);
-        trace_decode_idreg_writemap(field->name, lower, upper, prop_name);
-        object_property_add(obj, prop_name, "uint64",
-                            get_sysreg_prop, set_sysreg_prop, NULL, field);
-        g_free(prop_name);
-        nb_sysreg_props++;
-
-        field_mask = MAKE_64BIT_MASK(lower, field->length);
-        map = map & ~field_mask;
-        i = ctz64(map);
-    }
-    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
-    return 0;
-}
-
-/* analyze the writable mask and generate properties for writable fields */
-void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
-{
-    Object *obj = OBJECT(cpu);
-
-    for (int i = 0; i < NUM_ID_IDX; i++) {
-        ARM64SysReg *sysregdesc = &regs[i];
-
-        if (sysregdesc->writable_mask) {
-            /*
-             * special case REVIDR_EL1 and AIDR_EL1 which are writable but
-             * do not expose named fields. They will need to be handled
-             * separately
-             */
-            if (strcmp(sysregdesc->name, "REVIDR_EL1") &&
-                strcmp(sysregdesc->name, "AIDR_EL1")) {
-                decode_idreg_writemap(obj, sysregdesc);
-            }
-        }
-    }
-}
 
 static void
 kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf)
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 2b3474cc36..133a026036 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -143,14 +143,6 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
 
 typedef struct ARM64SysReg ARM64SysReg;
-/**
- * kvm_arm_expose_idreg_properties:
- * @cpu: The CPU object to generate the properties for
- * @reg: registers from the host
- *
- * analyze the writable mask and generate properties for writable fields
- */
-void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs);
 
 /**
  * kvm_arm_steal_time_finalize:
diff --git a/target/arm/trace-events b/target/arm/trace-events
index e67730de6b..f33b0d821d 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -15,11 +15,11 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
 kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
-decode_idreg_writemap(const char* name, int lower, int upper, char *prop_name) "%s [%d:%d] is writable (prop %s)"
+
+# cpu64.c
 get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
 set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
 nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
-unexpected_writable_reserved_field(const char *reg_name, const char *field_name, int lower, int upper) "Unexpected writable reserved field: %s.%s [%d,%d], skip it ..."
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.52.0

