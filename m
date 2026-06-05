Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757AD409633
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649035; cv=fail; b=b8tmtA56TLBqpu6GBB4zFFRd7Co3aunRX0RFZNy/tX8EC+PSEFCvdaVAHvOXwxGhShL0p/w9POYotMII0MBC23s4jdqSXmf3pWJAZQosVDREaz4WvRB07jzpNH9bY6f5uCXXTwakbE8Gl0QsApLxi60VOG5BnKH6RVcpgBlknnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649035; c=relaxed/simple;
	bh=Pij1znjtBDM3ECnSRNyxmnEUyUqLutA9uion8id5004=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UbxvCVhk/yGG1JIku95etiqg0y5jKeV6ihmHNBdnKXj6Gch1O63eJPB10AW7fw0z7h9TkGvjZAxxwmXuE9IQeILbruVlYgVXJA4gD0plEJNDRs3KVt44E2rWDwRciR06KC+y4mzaRtEB4QGUnDD5NqdnkROtb5MgylhOZcTsWFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=2wpKpK4m; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=lWQ9GoMe; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="2wpKpK4m";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="lWQ9GoMe"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556Octx889016;
	Fri, 5 Jun 2026 01:43:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=OHSlXuT0J85xziwfgk6v9QonCha77xwYWCSG3uqBg
	hk=; b=2wpKpK4mAPjSxkFjJr5RHmuMUGYG6CTeoQUBJsJv8JQHkJ8cvoPoy5EFC
	PkpBYr2fNB2xwrOReiUds2bnkCO1ihzfwuQpWfCwj7wVv56+YTlvD1hiUOXvLruC
	lPJo/qkn5r8m+N4zuJBiY/rDEkiXjCtPsi+r3VWRjriSkAj40TXjKcaY1t5bsIPp
	r3cBVRKFUYJZWK+rqJ2tSG4l+mukxIWcdYPdYeZ8fkGnbZHT7T+2lF/UJE1M+mqP
	iw4uyef9gfyhWy8Ep1zPG3ABS7zZUz/EmbmSO9TRs+4ZVLLz15pzKnGG6YgJzSUh
	dPzWSURcTj/bHRVPlp+GrSL2nYV7w==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021117.outbound.protection.outlook.com [40.107.208.117])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ej5a2fxwg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XKQOgLvk0dmdrvUBebRL8H5m5TNm3LNPpR05H464o70rMSn1sDhK51q7oApLlwaxDXQgrlOq+X1Fp1IwsUYayqRU6nWt57fAHjlbIMrAPDS0oBYK7VODAnOPQSFFr0zYhLK8kDCQSP+KqiJ90Kf+eEOutzJpvC0PWu2WVTlyw9xzj31KUR5mMDhe3RrLHTTbOSQchYjo9KqqUNO6w0bIL/BEex2kW7PsuTKgFJXutT4fNLpg0nE+k+ikIubOmR7uK2Q9sVBIv5kC+5MIjF0JwoZqDHU1uphahsJRTc+pKOeUuwTUF+xQYzpeEad0FTFn9gW1OMRE/tDgfuQC8NK1mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHSlXuT0J85xziwfgk6v9QonCha77xwYWCSG3uqBghk=;
 b=aLXGL8aFa9xSXTNcW+fM3k7FRgO1DVNPUAlD4TG/HFUC5zQRB8Kt/qkJzI7nVMiy1OxZUSIsKmRoj+Kp4VBwWu1m9Nh+losLxcmkDzSnBhb7so66HRsw1GALR/T7vxIjpfeD74wjrMx1+bPbqXtXZJ0a0wxaRxG6j9Tp0MABV/J4ZUNWLTj67bg4+J7JFeMzdDfcTfT2qR9gNlfeXZC8qaRu5du0gMWsXV3RRmnMjesEh2Eki6RFk6781ky6+MhGtsUo1DsLN6CC4FiprD9f40vWMaHdWPvyU6YPh+6Wa2JNxqLlmFhdHVsbWixl+LH2ACHx2fu/nO/yg+fv+BCC4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHSlXuT0J85xziwfgk6v9QonCha77xwYWCSG3uqBghk=;
 b=lWQ9GoMeCrw7cJzs28uraycqQtdMuyFsKq09XDk9bsWxfs3rb38K/Doej1rd8BAj1iQZRrh4Gh2ffwL0G0MSmogJX4FQw9BmbswYsJse5rLRV/4klphd61JMX5hIK1Tv3ROqMtBeU/BN6xiElaF0yCl+WLMIEifFj7Nom5CFuE9vxRFXW0lXQmFhgb+oL3VJe8eHH2E66oRRMV0X+2C1fbLs4nhVnaKgeeSs9w4KX/fbLTj55fyPv53oZQZZinpd5TslZPHySmTlpMo2ycoCZAuuqkGq8rsPbYVu+DBEU91fEWDyk6ImrjBPzYZd3ClM2AwYGKrgbhARpnKyMksCvg==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:13 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:13 +0000
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
Subject: [RFC PATCH v2 13/29] target/arm/kvm: enable writable implementation ID registers
Date: Fri,  5 Jun 2026 08:33:42 +0000
Message-ID: <20260605083358.1320563-14-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: ec9e6292-3fa1-49eb-0da8-08dec2de7afd
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qxmniajN4a139DJBUGk6almnoF6sbOUZC2ZnMpeJ4oKKJ//xDGi4+kbRu4cb98h2n7YXh2s61yI4xn9HqXJPbP4BCof0kkv7LhqXmIGYfmvT/qvax5GhorksQAt03qKdOZeZwnFF4mFoyHzrtKIz6HVCeAlG2GciWOrUqtSDWrzLKT9EaQDHLraaJlCOgvhn2KNVonEwR4z1TCYjV7klJElLBWE6GgUlXftLRc5zSwtJSH33KSzCvdAGpdIKCJ19JDPMsDfw84XTRMQAUWd43cl5kX24F/0D3lHj/O5kQUPaLLAaBnSalaWJB44voP3d5KO8GFWzJ0g6/gec8RifGUUF+R2SmsYxCDFocmQFfp7jt3BIo+rYb9xapc4TvogQp7P+CyiqXjtOVW1JicMicgj4qu+SqBy4cqtclE+Pr9OrAKPadm9qIbNLetxdKYcRjsbfv0+6CZY+FQrb5ESANe4IqTfm+VjH1HX+4dWFTWUi4HWCX9jyZlkpfapnLeRlcFX4hS+uclxT/fs2n0zw2l1vBmSm9gwntpG9YWaPRSeduAuUOII3XADHD9YhE4Gy85daSVveRVY5CvciQZOBgKrWDHHIsroc3gjSA5MZch2LQjOwclUmiRqMZ2lFrLzBKnKHOx3bBpbZnU9W0PNGJfftGLEtpFMu62bVPYFJZcSqAHHptKi4psgI+JTYfH+m
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mRaH5emnbq5wzVbxq6JvYlEzUnvPfRAI4ov9K6ZASng7LIprATLcpDJCZxze?=
 =?us-ascii?Q?BknfOHPZkAw0oRGFrqACkhxsLR2QXydt4bmQzLkCPQpTvBCk9Pb6UyGrdqU3?=
 =?us-ascii?Q?PI1jzH9q+5ifrLREb9O3y/qbLTyeRiQD/6SyUILC/NY8LakthrIX9JwvSE3A?=
 =?us-ascii?Q?eXnErO5TdVHueyp+RTScYZfV3qe57AkO7biRG7yNOl5ntKVVOTnY+4s2ckTx?=
 =?us-ascii?Q?G0XHH+HnPJAxYkMMmoIuBfh3jzF+qDntUiFN4Rgoj+7JGlQBz6u3BAo6wE1q?=
 =?us-ascii?Q?+gE8dGARIwwa3m4oUOx7PEgFfLthC+QWbLdDerUa81bH4MTS5ccpzQmmthHb?=
 =?us-ascii?Q?pR1+p0fHTW9rcrbouKGlB9PV9Lp0qO0lfGQxgFTTILFH3MYYlpIUYJ0Of/R8?=
 =?us-ascii?Q?YwDNMKxvx1YeSM/cvAgVvxdOpO1LFIoKN+sozUuZljF6yAVPqVPvE5b22WYq?=
 =?us-ascii?Q?iPEwLrnF4OX7BJ4z2CH+/7/Q81x8VP/Ej46dCD5TYI+Wn2kzycM3HwUsPhUH?=
 =?us-ascii?Q?c3eXKZ9ub1runez8bntSO+YlWuHUUbTutLDXHoR0fqIs9bOe0u1Nd5+j6YU4?=
 =?us-ascii?Q?6u2CPsvFD0fIl8Lh3yF6DWlC3DgY8fX1CxnBWzu5HFBgzCl5HEAuHLO52L/s?=
 =?us-ascii?Q?++lM4JysyFw4hx1E3irXnTq2hOTwePMUAszJPZwMdF0+p0wAs+22MgPL/Qv3?=
 =?us-ascii?Q?VXd2PwBixafrjLbya3CaoZ6nWaHN9mAmo6i+Mkz3lVDgdAtwuEBsPRz2sItn?=
 =?us-ascii?Q?VLSUq1NihuEgHd4DO4meKWxGHKfqoW5k7JE0VwMaQgdDPdFhk8jj5+mbBUTp?=
 =?us-ascii?Q?aEnPnd1yW6PISVapNMecxkNhKzxKwWCx2SIWwYTonmCpdPca+RXV6GqS9g5L?=
 =?us-ascii?Q?WEj0W4HeW21VJdu2EMa9Khm4k8pgphKFyDqdcZ3stCqe5R9JM98/8Y7yqLXz?=
 =?us-ascii?Q?dMih1NUlTBzzWR5jwiVLpsuvxdBK20coCAJRBS0ZJQcQGbI0CypDf0P1T8T5?=
 =?us-ascii?Q?d+CCqhI7HPzG0xX9YQn8L4Iiz+3AakSNq8OwHEQu+GyluMAb4PRhSGSjaPcb?=
 =?us-ascii?Q?EmHzT0UVJqve2Z9xwwBMOpgoXu4PSjue/asf4+bRBLXQz2NSjHbLgV4FVCAz?=
 =?us-ascii?Q?5P6h5uvU6DviyjE+FIfTNa7mCx3qN2IkPCimNDQtPRE21i+DL2hTjCTmDJCB?=
 =?us-ascii?Q?m4zktaCYB3etiVSMVWFb/JlhxcDjY+6Ug/HvZn5SJVFZZnX6/hJnmM9/cbLh?=
 =?us-ascii?Q?UNa494A8IrgtbXOY2r4bHo5PgokjM54Xd1+qlt0dGArFj2/3q8U476pNxsr+?=
 =?us-ascii?Q?A9SV7dSkvFOqGdHhQVnN5AhvZSQ5CI0Ti0uiTRzlqir9rANtc0OjZBdJ4mZm?=
 =?us-ascii?Q?gRkQ44HFKwNM/p05cnuKxShZ3+xqTbSKn48lJNezLXZuUzozjGdLrsBqE+yz?=
 =?us-ascii?Q?nXeZqZdwFwys+KF4DH6yNAz1EUDVIfz/lDDR/ezRW/bHOXsYCBpnQc8nSkOA?=
 =?us-ascii?Q?yuxKBaao6pgAlUAvnWRrWKr1QIXEpJutN63avfY8Ob91cfvmL3HSwz+DUK8Y?=
 =?us-ascii?Q?Qtfnb9Sht0P+d8ueKLQsECLEnY9KXtKuinP/2SxZ5peN+CwIT6qi641RBsnT?=
 =?us-ascii?Q?7fUgCzkPS5znVLUr4p4NJ03k2VFnhAIVO643/D8o1ERfplgqkx72g3TV1j6l?=
 =?us-ascii?Q?hR4MyX30Gqe3fHP13AnfEAkaJLeSTvU8wMQYh3mFt1GYE+6qDZwW6YPzn7fY?=
 =?us-ascii?Q?LZML5dWuu/V+l56MeDlYffO40ReGjhE=3D?=
X-Exchange-RoutingPolicyChecked:
	mYUhRuEeROMih5L56t7367bjaKGQH4lFCNlLXuNNxN5b6PAVMtvR7JSLtyiRa/4kDTXUiIUdgT5RYFEFyyz/kO/ueMVkuQ7/i3Ss62srbqoXvCdtlrzAoyRpN/AXKQVM4BYuNq8tegsQ0nx0lF6PVQN0VSaDSDPLDYb6a0WNY3w7e9J9yvUJf/4RbPoSm0VVwLSrmS+HvgK9xVNdVuxnCDQ0sJ2sVh1hLp5Ytq53z9SB8ST2JZyHwHlKz+C87DeJIYvBBZWwY0YkrhzEirxcg8FGCAq+gfimRixG7MtOD8B1IA95h5S2V0b5V+k215kwjQA23YXqjz8uLuAq2Psc+w==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec9e6292-3fa1-49eb-0da8-08dec2de7afd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:13.6348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfOpyuQcnNk827lICJu377JGBuE7sovboGBN9auVjAYZzPxZQfbcVpFHG0yKVDiEQku9F/GxriGPdL1TfpLR2EZ+CeKjrLNUFqsQHHQY+GU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Authority-Analysis: v=2.4 cv=Mq5iLWae c=1 sm=1 tr=0 ts=6a228c25 cx=c_pps
 a=fJIB0T+C2yAfE4P2TQxPqg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22
 a=64Cc0HZtAAAA:8 a=zu2ZhKAq3Qwx2YJsANoA:9
X-Proofpoint-ORIG-GUID: 07U1btTtkJALe566k6qGssO3BULSRreV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MiBTYWx0ZWRfXx+InM55EAQ7T
 Wsgi2NOuajJmikkLIBuQs2QirZl/UR1FIKKtchzx1ZMypXPxYwW+jH3FQ52RO/k9kR510XvT9FB
 WrkiZ6A8jxg5zyHJ4mBEZNLqujdP3dAfbNpOaLEa5Z8ntwY5wmuORYMpDcDbtxyvTOSk6Oe1YEZ
 +EH1tIGphG8/jvZ5OVvzA7XtKMgk1UKqkrns9pj5O5JV+139vE8wFiKF3NNStWlqb4jUrBm+Pzk
 LbcVJPjarVs0YfkLrrBbW/m39CyxmRP2Jc6jV5S0b4f4UzQ+dNg4/Fm79NwvDHRKQE6g+xJCt1p
 MhRudCiMzEvXPlZ8TsfAuOtVg1clXBc0VBXR1Cj98YjufGebPLUlBZBBLrRY4W1Cc3Nx7WPpVKI
 zx7Nn0cXadpuUhGE/Gc61Ka8k43TU2BDec4+C0xB/NM7k5DLuLRLBh+QAE/Vy3UQZFV5PYjKgnN
 WoNHfaY3V+Viavp64Ew==
X-Proofpoint-GUID: 07U1btTtkJALe566k6qGssO3BULSRreV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Enable KVM_CAP_ARM_WRITABLE_IMP_ID_REGS if the host kernel supports it.
This allows QEMU to write implementation-defined ID registers (MIDR,
REVIDR) so that named CPU models can present the correct values to the
guest instead of inheriting the host's identity.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/kvm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index dc64cfbeb6..288b5ebe85 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -711,6 +711,13 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    if (kvm_check_extension(s, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS)) {
+        if (kvm_vm_enable_cap(s, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0)) {
+            error_report("Failed to enable "
+                         "KVM_CAP_ARM_WRITABLE_IMP_ID_REGS cap");
+        }
+    }
+
     if (s->kvm_eager_split_size) {
         uint32_t sizes;
 
-- 
2.52.0

