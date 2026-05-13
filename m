Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EFA3F4129
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778690105; cv=fail; b=bjZ5alEoLInhiVEUcNf5wrtQFz1s1VHY444BfQ6UDBaJF6eriJGchAsdojz/AfQbZCA8X+IDhFX2PiO8wP4tYcc/vQb6bv+u9YEa5eJnQDi0d5k1tbHHh3UV9ydDWpE+eduIeHH6k8x0rk29ZWyYaJH4jrEVXgGxEAXF7HFBtJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778690105; c=relaxed/simple;
	bh=lcK2mCT2c2PVfs0uyvSEB9QdK2TiBkv8ZGsLcS7R/Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S0bhSwKjUgM8h482j3caNmZWgc+YiBSmwpfIv5/QTgjqi4Z9e1BO6oSZMznYoOSjnse2p2S74vSU9PhwzM1gMGUNIrgZr4WiT5Cpy+ALvif2lROD+XCLvn+AWU1T6AtzrvfRn/q3OUTBuiGm5jCuzgr0LeFK363omXWYzDYarHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=nV4if1pl; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=nepeHrgD; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="nV4if1pl";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="nepeHrgD"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGKYGX737957;
	Wed, 13 May 2026 09:34:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=pX83whw34rYEWw8o2vrW5ivFlfflMvDudQK5SUiYs
	fE=; b=nV4if1plzZStgiDuysQtIaNhOwMKrtm3zNV8IWxFWSFZI2PoiTDThwNf2
	HwKBbjkNDaFJ8+zPrAf+KDC7MtQcS0xUTadzZUj02tklafIfhkDvTXvALrWjjBdx
	ZpQwqWzYvY7C4g4VxoJRNDLYoQ94qPtz7T0HiC/gJldOk+rxbrNx/jhqOD+lSTzC
	ZBbgB+b6L8jdEvw0YaG/z26SLzr3E10ZYrXG4wr5njK/23uU4rJI1tWGc3Eqqac1
	7UrZ5yfrmAcXMbwwo7Qduy9Y6KvyDCypfIslJF/gm3mdJbG3Fax7j+/tuRDHBgh3
	xPy/C/3Cm87CwB0QkXHMaJiP3+Pjw==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021126.outbound.protection.outlook.com [40.93.194.126])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nvap78u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N7dDtlXn9slWSDQbBVPuhJd5wmYEs54SoO5yfgLaMkOW1tBVoDqaip1PyDmE24uI1M3eKt055+EBXi8Rj4MoiGRHnNxoBAlMrSRkWanO9FhwunO/OUoAQr6fXqtwTyE85jMPNFNoApngfA6eDzd6H7FyO8okomyhhV38aLOSDO71EHqh3CucePvN/qLpLnFixTBcX5u9hRgmHC6axhkbH6P5AILEOLhoj4Xy3O93sVmjzsz2NL2BnVjIioVohdI83tADUTWPFwNGU/rdEfcBJ197Jl1rw0bU1Xq2s8EUcIwqgFZyJVSnqX8woGoQZw2jPX8HVri4mWvShjilBxio2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pX83whw34rYEWw8o2vrW5ivFlfflMvDudQK5SUiYsfE=;
 b=YkVSRGWZ9FrzFHfiX9wCdgNG8SMV118e/JwFzsQdjfSD1gRLIq8vKdh2rQH8o212p5YKX3g9kMlh+AC3DKel+K4+LcQT/p1H21IZHjcVRxMV4KSghppN9KlcQDr4PBbTAF+4LhTwOUC6uGaM14hp+511puYASa9kR/1GGp81pjkYU4dMlzGkbxl0uAw76DXsG0qMD7bt7CZDYd+CSFQh2UQd5ltM587TxygkKRrgAmsk5G4a8jrD5qz/7dXlOE4yoOOsMZFQwF6h4AdRfxN+mOU6D3kPPOqdKUMczo1ClF3vhL+FAurRgsSMJusS+iQwIN5FJjPxPvlA20dmWXdtXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pX83whw34rYEWw8o2vrW5ivFlfflMvDudQK5SUiYsfE=;
 b=nepeHrgD3l95LfIc2VPufZGv4/iYsiCXs0LXgVy87/tdOHqPMo2QZETgVMuQyyEJTUDawYhI5RF1wVpPQB8dw32/jEj+WaGhKkiWvu50vfSqgN98mfA2+s5hj/Vy26e2cLb4R7Vji9+uOMlWWEWBSCiRlCy1b3USXrBTeHAWlsaNjl49OtYSLAL13nVIQzSJRbYRrqyx0inY07uv3YHlgcyC7/cpL+UkQZ51jSauK/j6ivugbkvpZWXuM+AxVSUqJQ12208zrZmp2BwxSfCvqHgZv5LrEIxmMG+MUJESeAbmCrNMAkmk3B7XJykUdP12mfAvbwEUhum7OZo9Ixvh5Q==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by SJ0PR02MB8813.namprd02.prod.outlook.com
 (2603:10b6:a03:3d6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 16:34:22 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:22 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 08/13] target/arm: named_cpu_model: generate arm_cpu_props[] table
Date: Wed, 13 May 2026 16:33:51 +0000
Message-ID: <20260513163356.3033159-9-shaju.abraham@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:930:1c::30) To PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR02MB10160:EE_|SJ0PR02MB8813:EE_
X-MS-Office365-Filtering-Correlation-Id: cef2a602-5938-492a-6e3a-08deb10d7c88
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	KOKmMIWx3SMIfVqDbQH1dkIpqzLXD5eLes9uyhDT7KpAW3iysWGJDHxcY2kXXwYJ3Xi0nMDv8ZEB1bDkjSWV2+rk7Oxyx58gUN29C/qLQ7cK+UWXKE6pDOPdr9OwbEDeP+osAyK9XqO1CzHdtRVnNB6lRLhtgtFBUrDjaK3JkKk3lK4WhN9+6ovhrlbIIhwvcAJPJDkutaAAWsnRekRegSUCTE+9uvJSFB2anZtQyugdWvbg8M1kLpRRZfeJ1QW4FA254201pHbqr5VJvjXxvhQdm5ickiTgfH4EHTy5g+Ql/xKa52oWd/dBQbDAmJXyCg0qkIiYwwP1ebomde2bCwCSsl5ljnYO6O9PRyFUzRbyWbSedOpFvKGp8wQBYL4SeMGVRF17gZn8dGvrzW8m2GEDKjgLvV8g3T1CMAaVGJz25f0zGxXqJK9AoerzkokghshnmlG9N54WzBEIX0XAT9GOmXfoUI7TN+g/LZ9PHjcQ94bTAcAtBJsBxD+vC4/eJkfMXE0N4XxK8JzmtpZ3q7M1wuA+HlGtbuoJegRI9JkxFzKdog6F3y4Iuodv8dC0a1wO4dLPsYxJs0jucvBaXHKpeUZ0EeWiKqBXD1Izn+sRJRpg+TI0N1oH6MHVBVbnLNUuDJsiFI4BSdRrAqPexuJUKI2AL2v7gGwpbsHfyUE9HW9fcKKCS9B42k4EOemfxR/XYKwkKsqa9iVT5fgGWblnXOJ26XFTcETSTr4ZXLs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1+bjyXzxIeU+8+QHAGqbeDlR8AJ8/Bhy9JBoztehKBnUpRYkCzXFa/ChjAOt?=
 =?us-ascii?Q?5LAK9sdeQo02yh0k0sOWUxjpFBV3XSOrPPMNtA5I60sXXYqjQm1afELEpX1b?=
 =?us-ascii?Q?QO37KzTgVgc6pX+cwDH9D3wzEtmPeG9rZlRMoYGn7YQQQlL33nxi4zuk6Gp7?=
 =?us-ascii?Q?TLT/XiZH0XDYD3QiiDrMYkliDJBhweZ5eWx84bdiLNN9TDddgeHToK/Pced4?=
 =?us-ascii?Q?QC3tZR3U5T+wqbtJLXu4FgBJPS5kDkcxaokyO4bHsfxPl1kXT0JTtnyulVbD?=
 =?us-ascii?Q?ScS8B9zXuPomtNP4Gvs6sIiMBQf2syta73YpC9kkukcB/8UToCDZ/hdUJyx0?=
 =?us-ascii?Q?v0ZohL5wG/KvMCPbr5WMRqwUYJNNR3JvXsd1zp/TlK5XJdvuYiW593wK3bCP?=
 =?us-ascii?Q?tz6rbtvmBZbJ2+Ex+Px0AEbeW754cK5oKk4RoLiwNQMBSclyvZxsI38gGeOa?=
 =?us-ascii?Q?CwtfRC5rtT2pZnbwm4JkHmCjXNIzuJHHg8+a1qzuUUsWMVEDeq3gkfhXBEKc?=
 =?us-ascii?Q?OC50sBm7UR/XREWFp1ypL/o86glgnucwcJ/8L958o30G6Gfi4Z2rYvT9VxNX?=
 =?us-ascii?Q?enu1NJl621pUeClvsZST/qdsMG75SR1q86t8KkRljNUJ2NBbMmTLvMZwuX81?=
 =?us-ascii?Q?kQM6vXd7Mr+C9Jwz1gmE1xTk+PM+J109uYEEG7wWaapvTskv/KwffJg5eTqd?=
 =?us-ascii?Q?y4O2Hvlk9QV1jXNzDpTxkYv7hyhryF7LYN9t4VUddpTbEH50yJHy6pdDdtCl?=
 =?us-ascii?Q?GiaV9qglM1FCOl+hjKxyfzE3RQ3qWqjaFof4wHqXyYmbDX3OGDPRnwbifWH/?=
 =?us-ascii?Q?WnR9tdsBICZIG8OW3Ybn03IT+MM21sgSuC6X7JdfNaWFAhDvolo1s1Yea98T?=
 =?us-ascii?Q?G4xJwVAgJGdF/tFQOs7p9KszxG4XsE6MtpivSpee2y1Tt66erCK1dKzKjTsC?=
 =?us-ascii?Q?Vlj7k2KM+tqQi+0gtM36zt6nWGUBsd2HzXONBg2LoVxBNBpDawFXbbFd91Jc?=
 =?us-ascii?Q?cLT3dWKTaEdpHApITQBNcTp4ZX9w9kblelBzMxOZIo/1pT4zVnCylHiP1zzB?=
 =?us-ascii?Q?qW0Z1nB71OPivKhsZuuHY6xmF1mr1OkwybHQxeFkaszMPmRv/ZKyOHQVzXkA?=
 =?us-ascii?Q?b5bivVE43icG8WlrI/vZW7jgjucpP7qb88AcuO6a5ty2cZpRL3dbd0EWIo5i?=
 =?us-ascii?Q?JCprT470MYb+jq3T5LsPc/d2vh/vhfDA8tPBE4kiBp8eVxFTLFYwG4X8UtIg?=
 =?us-ascii?Q?NWYiL99WAbozzQpaYXJY5Szvy+B4KYxETMmCZyubJ5hDNEa8T7uFe0FWluvT?=
 =?us-ascii?Q?S5QkUu1QTebi+KhMvsTRqjmOCZv8cYQtXBNDh5UQYmMqPOwS9CFrOUlTJCJz?=
 =?us-ascii?Q?gyK9J9eO91MqKauONnZu5Zf9Hvt/lY0jKPTzINuTUBwGtKAFmF7SP1ubR+dU?=
 =?us-ascii?Q?AzhOxoDcYVm1LoHjT0XhRfJgF00logprfdiXOI+Nn8c53/GGe9+n2XPzb585?=
 =?us-ascii?Q?BNVF9AF0uG8eZ6iR4dRcn4Jdcp+49p0/qtPhSYpH6/L5pxyCx1l+ZRCpzWBP?=
 =?us-ascii?Q?A3HlvQL+e1sYvxei+DZyXQe15huP6JYXtqrni1Kd0tvg9iQ3bG/wZndgtGEs?=
 =?us-ascii?Q?vMHjD+MsMtyZnLqkMvlBpjc2t+ni73GQZtWjUM9I2gjW3R1DYngxyqB6Lgo1?=
 =?us-ascii?Q?12ufmVmQhhtt38P1AHnAOQjcDbLAjssunjZHMkigSxg12h+f5SlL88HaoVnW?=
 =?us-ascii?Q?NIOULI4naE6LYlVNe1AP7vLGY/06YKQ=3D?=
X-Exchange-RoutingPolicyChecked:
	UITeoE2QAIXNh6cpEHkGjiMTdfD5FAH7hIcDliZaBwgCan720TQTHCgUaBfZhQbYuzc93zsshaP3jykxLu7xzZsbmoRXVq+fzUUwRAL1qK0apYBGClLP3ERmf2nee++G+lVNrDGyihwUZNRwyB6EMm33sWlaGIey+3n1pfAEZiTJwRUEMj0gfmhYBWRl0CQqAD2cTpuhdWukHl3kSrhqvOzr3d/QJtR8CQSPdQv5FoiV4JZGdBqBRSm4Es5OWYPBw2Km04ynBgA1CPTwHcx0bI1Pf/7Ai9Wyvjj7Lvpnj32ix3KWbkiFzkIWFit2waP1f4OjSlUsJTMLCichIfXw4Q==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cef2a602-5938-492a-6e3a-08deb10d7c88
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:21.7681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +R5ZWydeUgt7VEUSej7SzL3f0cm29Dv8jQO8P4lxnhGavokaL549l/ed4VjRlxOW5v7Xcjj9KG7Y2KWyyNfbuOaAS53wesECpWrKkzNop2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8813
X-Proofpoint-GUID: zMwbGLhS3N5jxz7ca8NUsll_lZnDVoCD
X-Proofpoint-ORIG-GUID: zMwbGLhS3N5jxz7ca8NUsll_lZnDVoCD
X-Authority-Analysis: v=2.4 cv=apaCzyZV c=1 sm=1 tr=0 ts=6a04a810 cx=c_pps
 a=JUKW06bhoGHkwkYQWyoyLA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22
 a=64Cc0HZtAAAA:8 a=0VltMdkb-i5vEMuiUwIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfX5U1ELiugjnRt
 NWawuGY2qL9NJNh9BDH9mTu2DauCYQdBJ7epuU+ByXkIqYPUaDd9vERI9dZRVjH74l47YjNvrqI
 E0x0ZrEhD76XCwyb2PNoL1ATpO2g3z5LvWynlmOVmhuabieaS+0ONWhpOjIZcQK+yVY6HkgKe7w
 sbjFfeXGMjU//bkXyI2olOPXS5KNdW5Ynqcc+rBIQST0GMCV3xcpa+9q7Di1hU8cvmnfQNnFJjx
 2XKOw28McowXO8ArT6qWu4JuxcaM/ITkVGI4uZc3nmfzcBGq81sIEw5ZLTvlSBzE+p93D38ftkh
 7GBEXK8LHO7wse7rPqvACjUilTJgD9LidyqrAh1WeBxD0y5qk7iY7ffhFUKo4YBHwiCQ408PLDN
 g7pY9eIc9w3YiMOzToy2DvWgJYzC2dwuGtLqGB7VmCfQi252d9dInQ1juJ7vs9BXOuuTjLznycB
 dF0mpqwom1J+yDUA4nA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Expand the previously defined X-macros to generate arm_cpu_props[]. These
properties will be added to CPU object in future patch.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
---
 target/arm/arm-cpu-props.c | 43 ++++++++++++++++++++++++++++++++++++++
 target/arm/meson.build     |  1 +
 2 files changed, 44 insertions(+)
 create mode 100644 target/arm/arm-cpu-props.c

diff --git a/target/arm/arm-cpu-props.c b/target/arm/arm-cpu-props.c
new file mode 100644
index 0000000000..f22fe7f08b
--- /dev/null
+++ b/target/arm/arm-cpu-props.c
@@ -0,0 +1,43 @@
+/*
+ * ARM CPU feature property definitions.
+ *
+ * Maps ID-register fields described in cpu-idregs.inc.h to user-facing
+ * QOM properties.
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qapi/visitor.h"
+#include "qom/object.h"
+#include "cpu.h"
+#include "arm-cpu-props.h"
+
+/*
+ * Generate all ArmFracVal tables for each fractional fields.
+ */
+#define FRAC_TABLE_START(base_fld) \
+    static const ArmFracVal base_fld##_frac_vals[] = {
+#define FRAC_VAL(name, base, frac) \
+    { (name), (base), (frac) },
+#define FRAC_TABLE_END(base_fld) \
+    { NULL }, \
+    };
+#include "arm-cpu-frac.inc.h"
+#undef FRAC_TABLE_END
+#undef FRAC_VAL
+#undef FRAC_TABLE_START
+#define ARM_PROP(prop_name, _type, reg, fld)                            \
+    { .name = (prop_name), .type = ARM_PROP_##_type,                     \
+      .base_field = ARM_FIELD_IDX(reg, fld) },
+
+#define ARM_FRACTIONAL_PROP(prop_name, base_reg, base_fld, frac_reg, frac_fld) \
+    { .name = (prop_name), .type = ARM_PROP_FRACTIONAL,                  \
+      .base_field = ARM_FIELD_IDX(base_reg, base_fld),                   \
+      .frac_field = ARM_FIELD_IDX(frac_reg, frac_fld),                   \
+      .vals = base_fld##_frac_vals },
+
+const ArmCpuPropDesc arm_cpu_props[] = {
+#include "arm-cpu-props.inc.h"
+    { .name = NULL },
+};
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 64d1ec63ab..01b1e91a1c 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -18,6 +18,7 @@ arm_common_ss.add(files(
 ))
 
 arm_common_system_ss.add(files(
+  'arm-cpu-props.c',
   'arm-qmp-cmds.c',
   'cpu-idregs.c',
 ))
-- 
2.52.0

