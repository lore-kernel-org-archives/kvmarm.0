Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A15147D95C
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650468; cv=fail; b=LaU8PEI4MoaMDmaaj3ETlHUarhgNNnmIy/2CX6bwx78/LVqf+yPRh41mxxgZZYQYXG029FlxSjRuxYXEIJX5Dl+KN2Hi0N6zLT15uowpOPHM0Hxb3qeehrLcmqxh+pxN5t7NaWJ3vGH+4SP1U/83lIil4MBEoVA/ibDf/PkyNiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650468; c=relaxed/simple;
	bh=rWjOndV26FKiGvPza1ncScJZl1czz5bCyrFAAx89CIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I7if3LT+X2ZcbeM8CGLdSeYQDD/l9yRTrBX3ffSl//IJtOsCIau2mbrQqeTyUSYHnJbEUTxxIRTbWQ+UQ+RSTtzwR0BG1trNxMlwqVOLKytyy5Q6NFAZQJA9Chy6JSjQspVn8qjDtKHaD98kqBUQwa/FSrAHh1aCtLipeWHo8TU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=BJcTURj2; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Pmw+9eyy; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="BJcTURj2";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Pmw+9eyy"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556Ocu1889016;
	Fri, 5 Jun 2026 01:43:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=xyp+G612mXjc7SgoFfos4/CCwaiPaA6mgEJO8/rgf
	m0=; b=BJcTURj2cR2bTVS99Fv7bJtMzOCO0Hh1TN+HvDNJ4Ykz0x5RImWA1GWLB
	agnVxYkeBjfI/nj0tJnuFpFNIeKQd4dnaifFt+Lyo83g2UY1zewZPVodATFeOqdi
	UvY/oF1IP33EWFtLKXdLSAFeitEMi2Pb07y32RnSvu72Lf33DZzvBn7PY19CRvwl
	G2yCtPJ0+QHE+T9IONqsveuBykEglDx+JXutX1pjV+oWpRPvRPtwFAOgbrUPG0jJ
	iV6/QFWXEx/VqotMbrf1/LtBQD5cU0WXfE54QugncvRBmtvYK3+LFpP2bpKFezaO
	sl58WFDo+D5zXpQgHKwB2fjeHehMg==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021117.outbound.protection.outlook.com [40.107.208.117])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ej5a2fxwg-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yh2/IoXrYzpqMTfVyF+EYMIbsba0rotL0ZnoYMtKVgMG5e1JgzsgPw6CH0bdJSW1m6oAwJN+cHp7flIk5oyArAIOFEXKkybtoVVUMw+B1bEjMI7+kppV184UmmNjjr31xH1EpJfTaDuOy8hfaojLJDifkxOeByBl2tVDl1Gw2truytlG6ShCpXUAT+rY++bAoDL3bPUqIKZfrwUX/h9sqcVdV+N5AAeS/TOcay9qYIvASv0zu+Z6A1PzHr20tZVMEWZvJyZRNoMr2LuG/rwghR87p6SAjBiuMpkkQDUM2opCUDlRbyuPZxB1v0+L6ksVytiRm2RiwDSf+eOGqvzmCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xyp+G612mXjc7SgoFfos4/CCwaiPaA6mgEJO8/rgfm0=;
 b=x41WeZ67Q76e0i5ID7vnOgwwwUSEoW2T6FO9EP7HlONmM9CQ/3+680mge/Llu1e1ZKYo/zQaWo+80WVPlYMO/qqJlSftDM/mqTa69heURvqZo+n9avZpeefHJvuksIYz2tfaQBdHNpqKO1Tv5qBNchbXACx+y1rEPOQEXOKBytxROljRWm4CeWXZ+VRbt5ZSHyzyt7YNPA7Z37nHwTO16beYsO6JZ74MO1cVecgAlZCyn9EPGb6YAdKT+vk7Zs44RkwnjDIdzI2iP+u3tEnOcG2ocQobB3V8uyJTGASnGojEpdnAG2o5yzLj/7HlGG6mHa50FxKSKwb9S6Pubn8rYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyp+G612mXjc7SgoFfos4/CCwaiPaA6mgEJO8/rgfm0=;
 b=Pmw+9eyyC/JYaWrbiXrwHyPBI5j2XzzLL9Xl2cbjZI5AU2bbyzcK/xDAYB5yegFB80Ax/vKFOuq5mfl93Zt+t6ibcN6GubCNTe69729CWdfvV653EzR7gA6GnitQFvgIJtdpMvGLiknS6zdqPpqJgM1/eRTydEcp0Nb5rDCU2sHahMhUU7bojQjiYFh3TnrKA7vTBcxiFpCWwrFVX3KRuGpgqxwP6NVXyX1W7ioT3PA0GpJLbk9dyCEKnp4bgXaMYzM+Qez+Iq7W1QhFrsrDd0FOaLrTVngNIStcpALVfhnHWZ4G+odvPU26Mk2expxrwN7SxeQG5KUisUarwAxWXw==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:12 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:12 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        Eric Auger <eric.auger@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Andrea Bolognani <abologna@redhat.com>,
        Jiri Denemark <jdenemar@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Sebastian Ott <sebott@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Jinqian Yang <yangjinqian1@huawei.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v2 09/29] target/arm: Add all ARM64 properties to host model
Date: Fri,  5 Jun 2026 08:33:38 +0000
Message-ID: <20260605083358.1320563-10-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260605083358.1320563-1-khushit.shah@nutanix.com>
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:510:324::18) To PH0PR02MB7557.namprd02.prod.outlook.com
 (2603:10b6:510:54::17)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|CO6PR02MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: 325ec81c-e129-4814-c64d-08dec2de7a0f
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mwUiCxwI9RG4wbmi5zgCpauwtcr9KIoFzGwkD3wpPzW7RxpnCnxleG+U0TSRFZ82yCEmXQ5tlY9NZN9NvdDf0OpEypZjlCIqqIZMIR75lvPzdDoMYIclqM+UfJrkVsgh506ehBz0N3aKO89YNu8EexRoRmxeOlKJLpOwjkWcL8e7/7qB5Tei1iKhm5i+8XvxhdTiBcfNI1NES7k+iWiOnstg9rxKaCNqbgocoACim8n/HASe3054kH0Q526xHVASQAFrdA14U6oomNdQW1N6WB9yPjNiCOjqZIm/5QYCF6+E5wFcyabr3YW4fLsDhSKLiWNtl/Kn/z6bEAlV3n1eTRsfT7PEKMV+EdALQKANZ+DaSv39beAzfJSFoB4L/os7REc/UYmt7b4U7PQpoCO2DDFfAqx8Wvzlnc9JeI4URl/cSpvZoQoB2NUlYftBkkur6H4ZqIt1h4bU7kvRW+COCe9gS2xPCq8kTpg9locwARGBpM7Ow0d10sYy87QyXVF6r7fy3wyWIWe8aJ0nId3edKNPePVmabX9LBNd6TqZmIk6kyCz7Er7gsFdZqxAFZ7QBwKRDZmzt8L+WJUvG/vbRXZ/gu8mEAkkGFw+Tyddv456q7QTVhjArt9Dgi0WKhLdRhA3zAOVVz6WHDloUBkFOvKh1e/TtUD9LPhaItL00syX/LuuimM0sEx/ghmeQbTi
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VTWDn/edCJ+gtX2egUMyzMKHjaEgh0oMu4iwYuEaeyIaw+7h0BUW9FjxrmrG?=
 =?us-ascii?Q?9Yqrjx5F6JhUXvaSDbyXCNg3QTgWHJp1GeaS6IMl9eKim4pFJp29f/EeL9MT?=
 =?us-ascii?Q?GYLn5xq/4hBtGb9ZlRtuZCKQd7iNSjm8KeZV4R8gYq+pou0X5z4QrduArzg5?=
 =?us-ascii?Q?5aKbGA25trFLZ90ClsBTSVZZnZvjemtDdThORfgu81JldJM2n6hodkRJlop5?=
 =?us-ascii?Q?6teubd8XnVzIBroplvDtbyx73btM2290YJfRGl0UqGl6KoDFShgFz5CRfwkK?=
 =?us-ascii?Q?NunArURGgOTj/pHHo8AJfKUDNz3+nXsTuy/7AA0QsZmaxBA+fM7jZ3Hu+0xB?=
 =?us-ascii?Q?rRbQ7gK9oypMFvmwCdt+xusiT6oI37r7+djkAWCVOUKoRiS8r6hykilYlgOo?=
 =?us-ascii?Q?BaOAVfaRI3DQ9yLGJthRhIrtRdDiTpY86s8Fw05jye77zYCAnmOBzzxRikFP?=
 =?us-ascii?Q?4Y2jkuZi72K8IH/A11yuZuwuv9Oz6OCnWa3nnteWM7hyfDyAR33jZNzcXCqZ?=
 =?us-ascii?Q?N83wXkxtur8HT3Vh4GMl65jKxjeHGfckROAHJx7IJFnQ26oADjrpfMa6EAjv?=
 =?us-ascii?Q?+m/EOr3V1pUNgx+NGk1S0JyV0TWfAZ86zICfcQINgw+Rc6vlrZPbwrbK3ig8?=
 =?us-ascii?Q?q5OywHgoqL3NrkK+M1+uaByPPmD3IOXLbwNssASR/779oa9h1HIUo5opfTQP?=
 =?us-ascii?Q?bJSFBqCAfi6bR9mbQMxMc9l0egBEO37/M1uUdepCEEz7K2rwiVFekZVlhVMa?=
 =?us-ascii?Q?E3zLNzBWgP1hXZvP7E5ugJJhTBX6kVpK7UF1ltDMNzpG4ekz4s20jk/k7Q3f?=
 =?us-ascii?Q?ag7ka0E65BGhBH52EJHUj14+RzyQiB4U1wRaFdZdMXOvL2M7UqO7j+GETZtj?=
 =?us-ascii?Q?FTl1hzRlmUJBARijn/SUKKNkgXrq3dPm5nQJkFcIzzdpY+P5D+bKnWvMRTKp?=
 =?us-ascii?Q?Ks19l7keu/ORdkbVWM2OTjf36ueU8V23JG2GUNyLtQrZ2aJTUbyQdxAL4HRH?=
 =?us-ascii?Q?yDlafuALWY7+O9CmetwCDsNaTahkh2TSxTxKnQ/kNmTzZHQC9bdWKe4sxLyY?=
 =?us-ascii?Q?3Vk96Q82XLvWrhvbU8Uh4ssImj29/t1i+NwZdlPbbF/WhQCCx1wtZdYasGym?=
 =?us-ascii?Q?58Y+qwsjYZ8Pc4Do9PCOLKgwsmVpeCHZ7TEmzBEZifqBYNBfXkbEFo41hgTU?=
 =?us-ascii?Q?fWYf4MPwjTNa74JT9dyyXr+L6NSFsMPEE2sh5UW4rMZyp9RzM+bNykcbh4/w?=
 =?us-ascii?Q?OKcM8GwiWFHCeFFAtCgjwbrhmoiFftxWxfPndMYk2EbRoAONorlkQEwano+k?=
 =?us-ascii?Q?maRI1fG+9IyAlmmFhVPqJoW58+TysyphqBdqAbNkjTL0g0XjF9b34t+nawhT?=
 =?us-ascii?Q?g4lxMeAaLSFAnZ++oOPcoWNlyq2nEeLiDdnkpik94I+CXghrdJlNNJfh+imp?=
 =?us-ascii?Q?951sRV6t7UE65UVe2xdL03/J5VvHWBd9jEedeYDw//Qh+09HC5dqPP3nWWuH?=
 =?us-ascii?Q?Ez4ujg4ym+HymAcOw5PVTcpSKF2PsJibz0Cyq1MWDxjv/ySCdX7L+NdTFaHd?=
 =?us-ascii?Q?9tIdlMVW3RgkOeYQUdxxVML6VZ9NMhX6X1vnnLtm9fdg9DVDth2XwA2Rkese?=
 =?us-ascii?Q?vPliGFjkIsBUrIjYxlXHG/wxZcaD8pmilR/GKMeAWJCEiDi8GRd857Vt0tP6?=
 =?us-ascii?Q?M27BxDroi12+of5ul71aVKYRJsFVFdoXfkVG0vCZfML2vxaRk6Zvys7Z/wt2?=
 =?us-ascii?Q?FbyARFP0sLv+GaojUZPL7lo9tVttotw=3D?=
X-Exchange-RoutingPolicyChecked:
	rlkTwoju5onUPlQToQLWFQknMnnEDhj23UagS8/qNZU/+kj6NhnkD8f/uiC4xneghnw7+wy/ScTbEmplyr1g4xzWzXti8pGYmr1CP++j5hEvWwthI/gRAoR2W2Ich011SEQlVAXA493v19QkSCF/H70XivwM8HSqhO+Txiwb6jXcNfIMkvFLYBHr8xMAXZPf3wfULU5X8OM54c8GcwsN2ZC5aPo96Z92c4vCpbKmez+SKD6MMvItrt3soTaFadxKfyo/aJYtggInSDbBzRXg/C4hWI5om1igGxvMQ0MP9/QMA0IEiniZ7WdTiYKbWlujCJIu8JeDhENvAq59E3mllQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 325ec81c-e129-4814-c64d-08dec2de7a0f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:12.1062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dNPMvsTMerzaLy/M68FZvNpVRErs3p7qlvnR1DYcp+7ZFAOGTV+f3SqLbP8KTRz5VxVWDYgskS0Ju2I33FjErCoWrTt0QRECymTjhmhACBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Authority-Analysis: v=2.4 cv=Mq5iLWae c=1 sm=1 tr=0 ts=6a228c27 cx=c_pps
 a=fJIB0T+C2yAfE4P2TQxPqg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22
 a=64Cc0HZtAAAA:8 a=JslzhcA6x4sdzHi93S0A:9
X-Proofpoint-ORIG-GUID: ve3TnaxrUIkuPMndQ4NmHs0BMzz8TcdC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MiBTYWx0ZWRfX9eKUYpXcezmo
 HZuHuXc5d+iFlSxYyaFY5A7gz9U1Dct3ymHtmxbsbF2fyqv/crlXCeqOSBSG8aegwnqvwGdD/JU
 0emVC6eA7PBjQazm4MnenUx3OMGRwmz1AY9NLKf+hBRVY1qUMtQZv9VTZkJ8QjUGph1IsBpgWa3
 hbsLuIN8Ul0an5slLIh7fvrPwkstpuMVXEsl2N4mOggbgY9tHEZAEJ+uMRJL3je9HlFkCTUa+9P
 rG21N+DepTEVfBxMerym1fXS/t/dSEKmOshxU80vlvx90LSbmxJr1xJg6xvAfEU3wXMJA8fa3kg
 OPKX0DhOOa/swjctsHjmrB98R9eHGVjCu2zAzC0gXnG3Q7ASoV/OeEWBkdVfirqAF/XH3feAMn2
 Kxx6fmxkwAbtg8aJGJvK+IoFJOM0krvJ1FxP6sOIeJtR8A7AMDu+2n01h8fRwM+Su2F4ZrBeGse
 D58I3JBM4u2lj/JD3OA==
X-Proofpoint-GUID: ve3TnaxrUIkuPMndQ4NmHs0BMzz8TcdC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

All all properties defined in arm_cpu_props to the host model under
CONFIG_KVM.

Properties are processed in the order they appear in cmdline:
for example, saying -cpu host,sve=off,feat_SVE=on is same as saying
-cpu host,sve=off,sve=on.

There is an exception for pauth, as it is backed by cpu->prop_pauth,
doing -cpu host,pauth=on,hw_prop_APA/API/APA3=0 will lead to an error.
And just doing hw_prop_APA/API/APA3/GPA/GPI=<val> will not turn on
pauth.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 7fb3791643..0300f8677f 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -863,6 +863,7 @@ static void aarch64_host_initfn(Object *obj)
     kvm_arm_set_cpreg_mig_tolerances(cpu);
     kvm_arm_set_cpu_features_from_host(cpu);
     aarch64_add_sve_properties(obj);
+    arm_add_cpu_props(obj);
 #elif defined(CONFIG_HVF)
     hvf_arm_set_cpu_features_from_host(cpu);
 #elif defined(CONFIG_WHPX)
-- 
2.52.0

