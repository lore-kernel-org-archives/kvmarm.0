Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359724C9577
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778690086; cv=fail; b=e3q6IMK5ZsvKmM3e8wE+A+37u/aYq5rgepENGKlq1AE47aXJS1BGUkB2rQGamm1rfE5iGPx9kuLneIGnwo8Rg1fuBe35bf9YRXYc7vjunWsvBw8T5ReUssWpbn+t5hN4eW2ykpgKwo8RT0+VUi22aZE2OgazdNAz4Imy1QkEFx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778690086; c=relaxed/simple;
	bh=ANhBK52SULtfpiMqPqDxl8RdJB7NHVNbH8K2tq1otiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iaFxe2YzO7bimFjnOZcd3eIon4WBraNIebERY71gPc8E0YNkh1e8SB0tQDJ//NT7/asKUzGhpOUPB6gDzR5ARphddWL8X9Ke2SJECgjP4+O8bRUBw7qXAsqobt4AXCtCYyfZ6bkJU3Zx9cIz6qflp2u5zDDYKKKaBKGgkD2F+SI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=OARFURDk; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=y98vnMZj; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="OARFURDk";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="y98vnMZj"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGKXdo1855187;
	Wed, 13 May 2026 09:34:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=90/K6T/F6An7yz81jap0t445Ld1IqL33IR5l1tThA
	fY=; b=OARFURDkgFUq8MAGIBDLp2wqnh6wwKacbnJDDTw0UR+GgTV+bJ0pYbgqA
	peW4DQZ02R0Y5OwbBnP68To85zD4bgqWZTtH/tc3aCPS9dIENT+FkTkDGWpEML8X
	w+gjVdmDjL0aZMdolW0fYFdg5wOhqAnz5HzM2BYwD8/69gQFzrZVJoICpHKo/Z2A
	0+xDP6NGMNdLXZGNLtcLiinOV5zfBqHKrWnbjbcXT0IFzfhYhT2ic9gxd4Ryluel
	KcV0hgxvOd0Ud09NlzOhQk8+2VN7mp3IvJz+B+oaMWljFQXGUbBJFl0mmzcjB328
	mxfFSwbY+KnsY42hUto1k9Io2hEBg==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021116.outbound.protection.outlook.com [40.93.194.116])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nvke98r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NSm5RQDdLECsJiKQ/zBt45QWwsFWvlJueCfug/prdrh2DGKIlDkXwon34YynbP4MP+mo5eG4sR47OAyjt9B75DCCqIXd4R5aC/V10KhlnQe/6wWqQaG2NVzWQlCIADD769P/UJ0rJMk18leCqEuiBTaiOrmupcCsmHf9YTbj9U+FJRcwDRx3k3xBdl3GCakUPCVM3Ya0REeM8GLa+BvcLIiJcNWd6bWyJ0yf+qctQtKviBfWDIIJRtylrBLGvU+C+oqdxx4lr+KNaoYQlk1enoBPmPxILW1VVR+Pc8ShzKSCQU7NUTPwEeWYIUBxuN59Gesln25/s37qQWKZT2xN1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90/K6T/F6An7yz81jap0t445Ld1IqL33IR5l1tThAfY=;
 b=aIwQDX+NxW56geQp3O88ikmljGYwM8M3VCERjvIzAvCY03NiIFcBllRk8Dp5LxX8XBdr89scxAV46pQPyDKvXlF8YVp8sZlp6vk9kg5/JlmAYhUF1ig1K/VrUFKUcXoPY4qn2CvJ+Sx6Yaid8ru2uQ6kQksJ7JKDdGtwsiWTPHXqAwHzhBsp3GGSCKJ129uS/UOaY1yLp0r/cfioRwmjEoEj4GaOVn0w/zNWmeKzeSL5ajxhShV/OQWDPr9r9AvMctjo0mgU9uS/1exj0Phh7WuO/1A9WhcwDww/cR/77Kqh90gaMJojbPlEoyp/WKyBoXW4QrPsmaI4m1bOAsHAug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90/K6T/F6An7yz81jap0t445Ld1IqL33IR5l1tThAfY=;
 b=y98vnMZjepndOw/y+cqjWYmqMnBGlTkhmdy+qpmsPLwS8CoiF+HTQGTVQvEi+r56ODgm5b/kO16ORAjcpgqllbSOFjUwffQDo4Z7YdwEqX3kHb6seyLebT1pVNxYteBFaNCk8EnVQhp8G5JHOPnwolImzHI4tBi+yNMXqqd1qqwHQJc9nAjanC5/CvxSaQ+29WVN+4cogwI3hL5o2l5jop0O0FIBl6YfBI/TOoHOX67K5iQCDAxoFV/pIf9l5nVH5I6ZLLcyeRYK24KpKyewYSMF8r5SKkKu7U/K7voJh28VzJOGijW1lAfooFvqXCzJMojPsKf+TmogFlXVnA4bnQ==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by SJ0PR02MB8813.namprd02.prod.outlook.com
 (2603:10b6:a03:3d6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 16:34:28 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:28 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 11/13] target/arm: named_cpu_model: introduce named CPU models for selected CPUs
Date: Wed, 13 May 2026 16:33:54 +0000
Message-ID: <20260513163356.3033159-12-shaju.abraham@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 094a4113-2449-4b99-2729-08deb10d804b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|18002099003|22082099003|56012099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	1L1xxN1VLvPgu31wQ11sIcf5ikRmwxidwrCAhig7x3BxnLufBYZmz/OpIYkpjCkQPtYbctpVLP8QAL/LOYOUdPpWg4VsLAKdBeKuYrHWfLn5amE+KNfCbV3+Z+GtoBCFzuOYVJOPM6HLJdxV5v9heFC5YWQbRp53p0/+auHXaPGU4rElV/pwFO5bVI4b6mtnaP1x52j3J94XB4hW69/tmE3Eg00gLkWRYlTteu7FGDK56eLJzQO1Z3QrH7s6U6e9/uEAoUtQswvEY/p+JMGl8g3mfjOWTcTe7gLAgU72+6P8R9XorIEdrKFkn1D0abXQE9DfFvI5KYmJ2ctAVRO3JgtUGI22wKMepFs+zXjsJzF/yBNMwKvkXm+YLO5agkEWrlzJ5/CRsQrDaNtoNzRKxK9yalv/2Ku7LaPsVVsvms3Wzb49zjdXnls+yvENAkjvp/j46yBKGTYyR/pj3IXI3JfDdvMIexvBvVPcl/ULsUzRxCaxBcJ1zTROzk2+34U1dHYvjHgGILN1q7YQPDzXaDIy7HqioF4MFwPHXzW1cKkj5w7qGvgwMM8PvgT96OSYgCggfrMcNCPl6LstIQj0K4D7cPAaxrPwIkLouq+n1LAq98OgDCnhwA0CQiQmIQBK5vLhqnhJ2GY12VjmP5vyvRVTJVS4W+5hQPSUzDfgimJzYVgdIdq30/05ptLqvBbqUhf0M5qhmzP6J1oXt8enFJ7XqL+mfHVffKjg/i3U57k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(18002099003)(22082099003)(56012099003)(3023799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AOs/nMMldNW7FzO506vbrPT+nP/TN9dYMlQoy/B5aVzVlQeXsabDl1bDEGiS?=
 =?us-ascii?Q?GZ4bkyMHJmOnrlVtKtE1u/GU55XTgo1DcPnAKBsGJgjNexhTMesDYRF6CTvW?=
 =?us-ascii?Q?sKM+Lu25gb3/8mK4BolGUXLPQZXcHN6dLJ1xbjFMo/0p8Bp1un6k/+QqGemw?=
 =?us-ascii?Q?W221zGidwjs2+YHkAdJwdlEhz1vutFnLxkahdmZT2axvJFGY4CTle5OGl7bE?=
 =?us-ascii?Q?NYFKMj3pzPcmEbhb+EWOZ+Fy4DztYeY/190zjc07c3ErcrTBDJzusRt6p9bl?=
 =?us-ascii?Q?9wNiwQzbSrdZumZXzhscO+HswyWMMhQovJn6OQn8tgwBTU9XWuIGvVl0yIkv?=
 =?us-ascii?Q?t4/2A/FqJJJJumXJRYjXG5yrI1KPslNts+4TOfO22vedWMwSCf5W/krBqHbd?=
 =?us-ascii?Q?12PZMHdGaRo87OijQncfYOiI1WEI/iFmHfIurIGQ78rre4DvIwGBjBnOhx9F?=
 =?us-ascii?Q?OYQ4A7hr/PF31vqfVKBWDn3DWMtfv/4W8fHkg0isnd824TAa+sIDPtUc577I?=
 =?us-ascii?Q?kllkG4T+cs9T7F0RPQmaN9EpbEqpz//M5ENw+jSxfUUESti0Run9pOmBeJ17?=
 =?us-ascii?Q?MvkVGkMan7jJw8N2TtgtNV+A2bpuHTouGW9akcpVxP9oWVrDmJweoP/7eRVo?=
 =?us-ascii?Q?dX7xdlm/Kkduca3Vm2k1cTQ6MdFPk9A41PZddsodDBFZENsBr2oPg9WD1oNJ?=
 =?us-ascii?Q?XR5toDegLdVS/m2dP0uDpz0uGwsHx9a09sd9Yjuo5O5+p1ilvQIeFKyqpaE/?=
 =?us-ascii?Q?kGpYGDnN463tWe9rnoZLQ43aOzJ4xIiNCO3/VvmejJXD9XaEa1ckOh25Vja0?=
 =?us-ascii?Q?D99gj4nSKlZ2hVVTlY/lwy6LXFUnoEC3tkVX/tTeB6U7v+yLDTwyv7g8JjE6?=
 =?us-ascii?Q?JSfB6Jbej6kMVDHrk8EPFyA5kzqjpJomwdadhJ/xS4ib+4mwML1LyN9PeWAr?=
 =?us-ascii?Q?NqO9tWBz8hzVQHQqPtX26pDh2cmBuX4/avYYfAT24C728ZUxmKUDCSaDq3jb?=
 =?us-ascii?Q?2We6EayObA96UP3XVeZtjxUraN6gO6Ow51Zjlx1ggqzRjKMRGoefVOKO3+sO?=
 =?us-ascii?Q?zzf85GyeDb7LYK4Ejqg2jyzE/dOHt3uE/lMOro3ypmOAQCJonau1X8dJbHib?=
 =?us-ascii?Q?Lc99Lmw0EbzvZepuCoCuYADB1p7BoRhVuTzA7luVSH7FiZAI4P6YG2UAYeJU?=
 =?us-ascii?Q?hevAy/l2myNY1njwU/YBwBH1m6Ut6O+91N4bKrJJzR3Ny0RFHqGXCsVD/6h2?=
 =?us-ascii?Q?w+L2LL43pdO8xYog26ynTgFz9j8KsELI7iHENqsiYXKN9vqgx4hmW2V+F9//?=
 =?us-ascii?Q?3fRP0hFtytewK1ylH1bdMdinXrPJDf4I4irxjXlqsByG4IoN65yzy2KxRvYF?=
 =?us-ascii?Q?WiL0n2o1mReGb6DWpV+ivaHnxof1gquz3cF0Ys2h2wXRC/0Hx1Os6larPfIp?=
 =?us-ascii?Q?14UDRn9GObgIZ5PS4QgRN6XghrhrLVPY/fR08mAhGJ9lsYCA6bx84XDHsvAU?=
 =?us-ascii?Q?dgZW+BJDc5G+CXVMv6Nk5soAfJJ4+9SoqXGx8SZE8p7NmJEucDw5kVf4aG/p?=
 =?us-ascii?Q?F0qIt9GOT1fOJC+YjxARxbdZ/tnE15IpxeYRYUTG1lMRG6qhoBbZQrl3GXgJ?=
 =?us-ascii?Q?JKIJacLW1oiCmZtQoaKTTF/AVRN4OXT+4+jyszlmukB6Oz3QNrcEsUdShp2g?=
 =?us-ascii?Q?pUec0CpIYguQdno4vPXNKsClcKU44vDheaDmFKkKCVsiTg8rMXmBa/EDmT86?=
 =?us-ascii?Q?mEmq4lIyK65RTmByz2uT0efhpOBX6bg=3D?=
X-Exchange-RoutingPolicyChecked:
	o3U8IvQNyIyI9NPZ84y36WMplj/vYO75EAJk1pqRrNbDgjNCGTAeQBvf1OEVO16SuhWTtebCNP026G3TtfZwNRZjKqBP0oThJmn8YgFma82GeoFfCgQID8TY3fgxkclz+ePD3cKTXp8aTNPa1HNOHvkounbYkiySvaRJHT8wg+dLlOIH6/XwajAHnw9E/UJy2ObfLnWJExRFzGWUverDbrBjplZM2/LRFvlSuOZHlCiRDeIEKCxfBEwxJZginCebfRJDFbnFVYZqb8L7UrmWWF+2Nd99nlQtetVTSrY7SrKcgJELe8CcGnbnHvfEXDN7r519YklNgjpe92Ql/Q9Q1w==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 094a4113-2449-4b99-2729-08deb10d804b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:28.0550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gr4MenAUqbXIQRnovQeENqttviHJbNSWg2hniFprf4qO76jwQTBVRMd/9ylIGfXGilK+RN7VuM3rKssJL4umt4dl2IGRZNo/EYumMvLpJZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8813
X-Proofpoint-GUID: HZ35R1swqmrLdcPCv5gfFH70FizbdPvV
X-Authority-Analysis: v=2.4 cv=WcU8rUhX c=1 sm=1 tr=0 ts=6a04a816 cx=c_pps
 a=U/cWNT7cGANcmDM7K3LxiQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22
 a=64Cc0HZtAAAA:8 a=JU90o9GPsxMSsgw1v4MA:9
X-Proofpoint-ORIG-GUID: HZ35R1swqmrLdcPCv5gfFH70FizbdPvV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfX5efM/KQKlJWl
 AfxSSdiZetx8lhBghPuTVf8sdFuXlrZAQkmooTmHMeju9tONX8bH1LkKmf23CKSmR/awkdntepY
 aYn//Okz1cBohiywxhNSAZEQ28Dg7mVav1iQlXsUfhEyR86on91E0Mad6gl0nT0Q/Xr4xxG9suY
 GA2AUIxuODZ1WKjAe2OY3psMyJUKQsD9ER5RW+T20+dAJAQU+oKpDAbueigaznJ/z74aptDtKfY
 ekm6zbetcf2K1aHaRCV4BpLlrwNRg2RcTpIeOwJF5N1cDdU6Kb5/sYO4a/ekyAjprGgL3MYDwfu
 i0+odlNbZ8bkNt6/WLcwtd1jUV0xEOCCI3vzvDE3qG3fJEJOkNIZ23d6q9yXQMURw2/Db4GYk3f
 /J/Q+BdbhDViL0/kDado3eGDFSNIKmruLlKQRiwU8B1HSVHiHPox/tBqkmrGuTF6aACgEFK+6uz
 vJTFE8U8rFpYDedd9CA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce a small named-CPU-model layer on top of the field-backed property
infrastructure. Each model is a flat table of (name, value) overrides and a
parent pointer. At instance-init, the parent chain is walked root-first and
every level's properties are applied via QOM, so a child entry overrides
its ancestors for the same name.

For example, the grace-v1 named model hierarchy is:
kvm-base-v1     KVM-imposed quirks (chain root)
arm-v8_4-a-v1   ARMv8.4-A architectural mandate
arm-v9_0-a-v1   ARMv9.0-A architectural deltas
neoverse-v2-v1  Neoverse V2
grace-v1        NVIDIA Grace

arm-v8_4-a-v1, arm-v9_0-a-v1:
Only features mandated by the corresponding ARM ARM
revision. No optional features.

neoverse-v[12]-v1:
Referrence manual derived feature values for the reference core. Values
differ from reference core values based on what was exposed to the guest
with -cpu host.

grace-v1:
SoC integration choices (crypto pin, cache hints,
PAuth alg).

model realization logic:
1. arm_idregs_reset_to_defaults(cpu): Reset cpu->isar.idregs[] to the
   default values.
2. Add all properties to the CPU Object
3. arm_realize_model_chain(obj, model, &error_abort): Walk the parent chain
   from root first and apply all the properties.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
---
 hw/arm/virt.c                   |   8 ++
 target/arm/arm-cpu-models.c     | 214 ++++++++++++++++++++++++++++++++
 target/arm/arm-cpu-models.h     |  43 +++++++
 target/arm/arm-v8_4-a-v1.inc.h  |  22 ++++
 target/arm/arm-v9_0-a-v1.inc.h  |  28 +++++
 target/arm/grace-v1.inc.h       |  17 +++
 target/arm/graviton3-v1.inc.h   |  16 +++
 target/arm/kvm-base-v1.inc.h    |  13 ++
 target/arm/meson.build          |   5 +-
 target/arm/neoverse-v1-v1.inc.h |  64 ++++++++++
 target/arm/neoverse-v2-v1.inc.h |  64 ++++++++++
 11 files changed, 493 insertions(+), 1 deletion(-)
 create mode 100644 target/arm/arm-cpu-models.c
 create mode 100644 target/arm/arm-cpu-models.h
 create mode 100644 target/arm/arm-v8_4-a-v1.inc.h
 create mode 100644 target/arm/arm-v9_0-a-v1.inc.h
 create mode 100644 target/arm/grace-v1.inc.h
 create mode 100644 target/arm/graviton3-v1.inc.h
 create mode 100644 target/arm/kvm-base-v1.inc.h
 create mode 100644 target/arm/neoverse-v1-v1.inc.h
 create mode 100644 target/arm/neoverse-v2-v1.inc.h

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 10b1954382..bbb5f0a241 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -4069,6 +4069,14 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
             g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("host")));
         }
     }
+    if (kvm_enabled() && target_aarch64()) {
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v8_4-a-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v9_0-a-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v1-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("grace-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("graviton3-v1")));
+    }
     g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("max")));
 
     return vct;
diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
new file mode 100644
index 0000000000..fff7522a64
--- /dev/null
+++ b/target/arm/arm-cpu-models.c
@@ -0,0 +1,214 @@
+/*
+ * ARM named CPU model definitions.
+ *
+ * Each model is defined in its own .inc.h file using the ARM_PROP()
+ * macro, listing only the properties that DIFFER from the parent
+ * model.  At realisation the parent chain is walked root-first and
+ * every level's props are applied via QOM, so the leaf's values
+ * naturally override its ancestors.
+ *
+ * Hierarchy (single-parent inheritance):
+ *
+ *   kvm-base-v1                    KVM-imposed quirks (chain root)
+ *     arm-v8_4-a-v1                ARMv8.4-A architectural mandate
+ *       arm-v9_0-a-v1              ARMv9.0-A architectural deltas
+ *         neoverse-v2-v1           Neoverse V2 (TRM 102375)
+ *           grace-v1               NVIDIA Grace
+ *       neoverse-v1-v1             Neoverse V1 (TRM 102649)
+ *         graviton3-v1             AWS Graviton3
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qemu/error-report.h"
+#include "system/kvm.h"
+#include "cpu.h"
+#include "internals.h"
+#include "kvm_arm.h"
+#include "arm-cpu-models.h"
+#include "arm-cpu-props.h"
+#include "cpu-idregs.h"
+
+static const ArmModelPropValue kvm_base_v1_props[] = {
+#include "kvm-base-v1.inc.h"
+};
+
+static const ArmModelPropValue armv8_4_a_v1_props[] = {
+#include "arm-v8_4-a-v1.inc.h"
+};
+
+static const ArmModelPropValue armv9_0_a_v1_props[] = {
+#include "arm-v9_0-a-v1.inc.h"
+};
+
+static const ArmModelPropValue neoverse_v1_v1_props[] = {
+#include "neoverse-v1-v1.inc.h"
+};
+
+static const ArmModelPropValue neoverse_v2_v1_props[] = {
+#include "neoverse-v2-v1.inc.h"
+};
+
+static const ArmModelPropValue grace_v1_props[] = {
+#include "grace-v1.inc.h"
+};
+
+static const ArmModelPropValue graviton3_v1_props[] = {
+#include "graviton3-v1.inc.h"
+};
+
+static const ArmNamedCpuModel arm_cpu_models[] = {
+    {
+        .name   = "kvm-base-v1",
+        .parent = NULL,
+        .props  = kvm_base_v1_props,
+    },
+    {
+        .name   = "arm-v8_4-a-v1",
+        .parent = "kvm-base-v1",
+        .props  = armv8_4_a_v1_props,
+    },
+    {
+        .name   = "neoverse-v1-v1",
+        .parent = "arm-v8_4-a-v1",
+        .props  = neoverse_v1_v1_props,
+    },
+    {
+        .name   = "graviton3-v1",
+        .parent = "neoverse-v1-v1",
+        .props  = graviton3_v1_props,
+    },
+    {
+        .name   = "arm-v9_0-a-v1",
+        .parent = "arm-v8_4-a-v1",
+        .props  = armv9_0_a_v1_props,
+    },
+    {
+        .name   = "neoverse-v2-v1",
+        .parent = "arm-v9_0-a-v1",
+        .props  = neoverse_v2_v1_props,
+    },
+    {
+        .name   = "grace-v1",
+        .parent = "neoverse-v2-v1",
+        .props  = grace_v1_props,
+    },
+};
+
+static ARMCPUInfo arm_named_cpu_infos[ARRAY_SIZE(arm_cpu_models)];
+static const ArmNamedCpuModel *arm_find_model(const char *name)
+{
+    size_t i;
+    for (i = 0; i < ARRAY_SIZE(arm_cpu_models); i++) {
+        if (g_str_equal(arm_cpu_models[i].name, name)) {
+            return &arm_cpu_models[i];
+        }
+    }
+    return NULL;
+}
+
+static void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
+                                  Error **errp)
+{
+    const ArmModelPropValue *pv;
+    ERRP_GUARD();
+
+    for (pv = props; pv->name; pv++) {
+        switch (pv->type) {
+        case ARM_MODEL_PROP_STR:
+            object_property_set_str(obj, pv->name, pv->str, errp);
+            break;
+        case ARM_MODEL_PROP_BOOL:
+            object_property_set_bool(obj, pv->name, pv->b, errp);
+            break;
+        case ARM_MODEL_PROP_NUM:
+            object_property_set_uint(obj, pv->name, pv->num, errp);
+            break;
+        default:
+            g_assert_not_reached();
+        }
+        if (*errp) {
+            error_prepend(errp, "property '%s': ", pv->name);
+            return;
+        }
+    }
+}
+
+static void arm_realize_model_chain(Object *obj, const ArmNamedCpuModel *model,
+                                    Error **errp)
+{
+    const ArmNamedCpuModel *cur, *parent;
+    const ArmNamedCpuModel *chain[ARRAY_SIZE(arm_cpu_models)];
+    size_t depth = 0;
+    for (cur = model; cur; ) {
+        if (depth >= ARRAY_SIZE(chain)) {
+            error_setg(errp, "model '%s': parent chain too deep "
+                       "(possible cycle)", model->name);
+            return;
+        }
+        chain[depth++] = cur;
+
+        if (!cur->parent) {
+            break;
+        }
+        parent = arm_find_model(cur->parent);
+        if (!parent) {
+            error_setg(errp, "model '%s': unknown parent '%s'",
+                       cur->name, cur->parent);
+            return;
+        }
+        cur = parent;
+    }
+
+    while (depth--) {
+        arm_apply_model_props(obj, chain[depth]->props, errp);
+        if (*errp) {
+            return;
+        }
+    }
+}
+
+static void arm_named_cpu_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    ARMCPUClass *acc = ARM_CPU_GET_CLASS(obj);
+    const ArmNamedCpuModel *model = arm_find_model(acc->info->name);
+    if (!model) {
+        error_report("'%s' CPU model entry not found)",
+                     acc->info->name);
+        return;
+    }
+
+    if (!kvm_enabled()) {
+        error_report("'%s' CPU model requires KVM (-accel kvm)",
+                     acc->info->name);
+        return;
+    }
+
+    kvm_arm_set_cpu_features_from_host(cpu);
+    if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
+        return;
+    }
+
+    arm_idregs_reset_to_defaults(cpu);
+
+    aarch64_add_sve_properties(obj);
+    aarch64_add_pauth_properties(obj);
+    arm_add_cpu_props(obj);
+
+    arm_realize_model_chain(obj, model, &error_abort);
+}
+
+void arm_register_named_cpu_models(void)
+{
+    size_t i;
+    for (i = 0; i < ARRAY_SIZE(arm_cpu_models); i++) {
+        arm_named_cpu_infos[i].name = arm_cpu_models[i].name;
+        arm_named_cpu_infos[i].initfn = arm_named_cpu_initfn;
+        arm_cpu_register(&arm_named_cpu_infos[i]);
+    }
+}
+
+type_init(arm_register_named_cpu_models)
diff --git a/target/arm/arm-cpu-models.h b/target/arm/arm-cpu-models.h
new file mode 100644
index 0000000000..830a9bdc4a
--- /dev/null
+++ b/target/arm/arm-cpu-models.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * ARM named CPU model definitions - public API.
+ */
+#ifndef ARM_CPU_MODELS_H
+#define ARM_CPU_MODELS_H
+
+#include "qapi/error.h"
+#include "qom/object.h"
+
+typedef enum ArmModelPropType {
+    ARM_MODEL_PROP_STR,
+    ARM_MODEL_PROP_BOOL,
+    ARM_MODEL_PROP_NUM,
+} ArmModelPropType;
+
+typedef struct ArmModelPropValue {
+    const char     *name;
+    ArmModelPropType type;
+    bool            b;
+    uint64_t        num;
+    const char     *str;
+} ArmModelPropValue;
+
+typedef struct ArmNamedCpuModel {
+    const char              *name;
+    const char              *parent;
+    const ArmModelPropValue *props;
+} ArmNamedCpuModel;
+
+#define ARM_PROP_FIELD_STR  str
+#define ARM_PROP_FIELD_BOOL b
+#define ARM_PROP_FIELD_NUM  num
+
+#define ARM_PROP(_name, _type, _value) \
+    { .name = (_name), .type = ARM_MODEL_PROP_##_type, \
+      .ARM_PROP_FIELD_##_type = (_value) }
+
+#define ARM_PROP_END  { .name = NULL }
+
+void arm_register_named_cpu_models(void);
+
+#endif /* ARM_CPU_MODELS_H */
diff --git a/target/arm/arm-v8_4-a-v1.inc.h b/target/arm/arm-v8_4-a-v1.inc.h
new file mode 100644
index 0000000000..1bad59ba2d
--- /dev/null
+++ b/target/arm/arm-v8_4-a-v1.inc.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+ARM_PROP("feat_CRC32", STR,  "on"),
+ARM_PROP("feat_ATOMIC", STR,  "on"),
+ARM_PROP("feat_HPDS", STR,  "on"),
+ARM_PROP("feat_LO", STR,  "on"),
+
+ARM_PROP("feat_DPB", STR,  "on"),
+ARM_PROP("feat_RAS", STR,  "1.0"),
+ARM_PROP("feat_PAN", STR,  "pan2"),
+ARM_PROP("feat_UAO", STR,  "on"),
+ARM_PROP("feat_CNP", STR,  "on"),
+ARM_PROP("feat_IESB", STR,  "on"),
+
+ARM_PROP("feat_DIT", STR,  "on"),
+ARM_PROP("feat_DBG", STR,  "v8p4"),
+ARM_PROP("feat_PMU", STR,  "v3p4"),
+ARM_PROP("feat_TS", STR,  "flagm"),
+ARM_PROP("feat_LRCPC", STR,  "lrcpc2"),
+ARM_PROP("feat_AT", STR,  "on"),
+ARM_PROP("hw_prop_IDS", STR,  "0x18"),
+
+ARM_PROP_END,
diff --git a/target/arm/arm-v9_0-a-v1.inc.h b/target/arm/arm-v9_0-a-v1.inc.h
new file mode 100644
index 0000000000..5ebe728133
--- /dev/null
+++ b/target/arm/arm-v9_0-a-v1.inc.h
@@ -0,0 +1,28 @@
+
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+ARM_PROP("feat_BT", STR, "on"),
+ARM_PROP("feat_CSV2", STR, "1.0"),
+ARM_PROP("feat_CSV3", STR, "on"),
+ARM_PROP("feat_DPB", STR, "dpb2"),
+ARM_PROP("feat_E0PD", STR, "on"),
+ARM_PROP("feat_SB", STR, "on"),
+ARM_PROP("feat_SPECRES", STR, "on"),
+ARM_PROP("feat_SSBS", STR, "ssbs2"),
+
+ARM_PROP("feat_DoubleLock", STR, "off"),
+ARM_PROP("feat_FP", STR, "on"),
+ARM_PROP("feat_AdvSIMD", STR, "on"),
+ARM_PROP("feat_TS", STR, "flagm2"),
+ARM_PROP("feat_FRINTTS", STR, "on"),
+ARM_PROP("feat_RDM", STR, "on"),
+ARM_PROP("feat_DP", STR, "on"),
+ARM_PROP("feat_FHM", STR, "on"),
+ARM_PROP("feat_FCMA", STR, "on"),
+ARM_PROP("feat_JSCVT", STR, "on"),
+
+ARM_PROP("feat_SVE", STR, "on"),
+ARM_PROP("feat_SEL2", STR, "on"),
+ARM_PROP("feat_VH", STR, "on"),
+ARM_PROP("feat_XNX", STR, "on"),
+
+ARM_PROP_END,
diff --git a/target/arm/grace-v1.inc.h b/target/arm/grace-v1.inc.h
new file mode 100644
index 0000000000..048ebb993d
--- /dev/null
+++ b/target/arm/grace-v1.inc.h
@@ -0,0 +1,17 @@
+
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+ARM_PROP("cpu_revision", NUM, 0x0),
+
+ARM_PROP("feat_AES", STR, "pmull"),
+ARM_PROP("feat_SHA1", STR, "on"),
+ARM_PROP("feat_SHA2", STR, "sha512"),
+ARM_PROP("feat_SHA3", STR, "on"),
+ARM_PROP("feat_SM3", STR, "on"),
+ARM_PROP("feat_SM4", STR, "on"),
+
+ARM_PROP("hw_prop_IDC", BOOL, true),
+ARM_PROP("hw_prop_DIC", BOOL, true),
+
+ARM_PROP("cpu_revidr", NUM, 1),
+
+ARM_PROP_END,
diff --git a/target/arm/graviton3-v1.inc.h b/target/arm/graviton3-v1.inc.h
new file mode 100644
index 0000000000..9538c3e539
--- /dev/null
+++ b/target/arm/graviton3-v1.inc.h
@@ -0,0 +1,16 @@
+
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+ARM_PROP("feat_AES", STR, "pmull"),
+ARM_PROP("feat_SHA1", STR, "on"),
+ARM_PROP("feat_SHA2", STR, "sha512"),
+ARM_PROP("feat_SHA3", STR, "on"),
+ARM_PROP("feat_SM3", STR, "on"),
+ARM_PROP("feat_SM4", STR, "on"),
+ARM_PROP("feat_RNDR", STR, "on"),
+
+ARM_PROP("hw_prop_IDC", BOOL, true),
+ARM_PROP("hw_prop_DIC", BOOL, true),
+
+ARM_PROP("cpu_revidr", NUM, 1),
+
+ARM_PROP_END,
diff --git a/target/arm/kvm-base-v1.inc.h b/target/arm/kvm-base-v1.inc.h
new file mode 100644
index 0000000000..e0bae90629
--- /dev/null
+++ b/target/arm/kvm-base-v1.inc.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+ARM_PROP("el0_mode", STR, "aarch64"),
+ARM_PROP("el1_mode", STR, "aarch64"),
+ARM_PROP("el2_mode", STR, "off"),
+ARM_PROP("el3_mode", STR, "off"),
+ARM_PROP("feat_GIC", STR, "on"),
+ARM_PROP("feat_AMU", STR, "off"),
+ARM_PROP("feat_MPAM", STR, "0.0"),
+ARM_PROP("feat_NV", STR, "0.0"),
+ARM_PROP("feat_MTE_FRAC", STR, "async"),
+ARM_PROP("hw_prop_CCIDX", STR, "32"),
+
+ARM_PROP_END,
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 01b1e91a1c..79a22eec3f 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -22,7 +22,10 @@ arm_common_system_ss.add(files(
   'arm-qmp-cmds.c',
   'cpu-idregs.c',
 ))
-arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
+arm_system_ss.add(when: 'CONFIG_KVM',
+                  if_true: files('arm-cpu-models.c',
+                                 'hyp_gdbstub.c',
+                                 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss.add(files('cpu.c'))
diff --git a/target/arm/neoverse-v1-v1.inc.h b/target/arm/neoverse-v1-v1.inc.h
new file mode 100644
index 0000000000..5ded208a5e
--- /dev/null
+++ b/target/arm/neoverse-v1-v1.inc.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+ARM_PROP("cpu_implementer", NUM, 0x41),
+ARM_PROP("cpu_variant", NUM, 0x1),
+ARM_PROP("cpu_architecture", NUM, 0xF),
+ARM_PROP("cpu_partnum", NUM, 0xD40),
+ARM_PROP("cpu_revision", NUM, 0x1),
+
+ARM_PROP("hw_prop_BRPS", NUM, 0x5),
+ARM_PROP("hw_prop_WRPs", NUM, 0x3),
+ARM_PROP("hw_prop_CTX_CMPs", NUM, 0x1),
+ARM_PROP("feat_DoubleLock", STR, "off"),
+
+ARM_PROP("feat_RDM", STR, "on"),
+ARM_PROP("feat_DP", STR, "on"),
+ARM_PROP("feat_FHM", STR, "on"),
+
+ARM_PROP("feat_DPB", STR, "dpb2"),
+ARM_PROP("feat_JSCVT", STR, "on"),
+ARM_PROP("feat_FCMA", STR, "on"),
+ARM_PROP("feat_BF16", STR, "on"),
+ARM_PROP("feat_DGH", STR, "on"),
+ARM_PROP("feat_I8MM", STR, "on"),
+
+ARM_PROP("feat_FP", STR, "fp16"),
+ARM_PROP("feat_AdvSIMD", STR, "fp16"),
+ARM_PROP("feat_RAS", STR, "1.1_base"),
+ARM_PROP("feat_CSV2", STR, "1.0"),
+ARM_PROP("feat_CSV3", STR, "on"),
+
+ARM_PROP("feat_SSBS", STR, "ssbs2"),
+
+ARM_PROP("hw_prop_PARANGE", STR, "48"),
+ARM_PROP("hw_prop_ASIDBITS", STR, "16"),
+ARM_PROP("feat_BIGEND", STR, "on"),
+ARM_PROP("feat_SNSMEM", STR, "on"),
+ARM_PROP("hw_prop_TGRAN4", STR, "on"),
+ARM_PROP("hw_prop_TGRAN16", STR, "on"),
+ARM_PROP("hw_prop_TGRAN64", STR, "on"),
+ARM_PROP("hw_prop_TGRAN4_2", STR, "tgran4"),
+ARM_PROP("hw_prop_TGRAN16_2", STR, "tgran16"),
+ARM_PROP("hw_prop_TGRAN64_2", STR, "tgran64"),
+
+ARM_PROP("feat_HAFDBS", STR, "dbm"),
+ARM_PROP("hw_prop_VMIDBITS", STR, "16"),
+ARM_PROP("feat_VH", STR, "on"),
+ARM_PROP("feat_HPDS", STR, "hpds2"),
+ARM_PROP("feat_XNX", STR, "on"),
+ARM_PROP("feat_SpecSEI", STR, "off"),
+
+ARM_PROP("hw_prop_FWB", STR, "on"),
+ARM_PROP("feat_BBM", STR, "2"),
+ARM_PROP("feat_EVT", STR, "ttlbxs"),
+
+ARM_PROP("feat_E2H0", STR, "on"),
+
+ARM_PROP("hw_prop_IMInline", NUM, 4),
+ARM_PROP("hw_prop_L1IP", STR, "pipt"),
+ARM_PROP("hw_prop_DMInline", NUM, 4),
+ARM_PROP("hw_prop_ERG", NUM, 4),
+ARM_PROP("hw_prop_CWG", NUM, 4),
+
+ARM_PROP("hw_prop_BS", NUM, 0x4),
+
+ARM_PROP_END,
diff --git a/target/arm/neoverse-v2-v1.inc.h b/target/arm/neoverse-v2-v1.inc.h
new file mode 100644
index 0000000000..a32f80cd55
--- /dev/null
+++ b/target/arm/neoverse-v2-v1.inc.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+ARM_PROP("cpu_implementer", NUM, 0x41),
+ARM_PROP("cpu_variant", NUM, 0x0),
+ARM_PROP("cpu_architecture", NUM, 0xF),
+ARM_PROP("cpu_partnum", NUM, 0xD4F),
+ARM_PROP("cpu_revision", NUM, 0x2),
+
+ARM_PROP("hw_prop_BRPS", NUM, 0x5),
+ARM_PROP("hw_prop_WRPs", NUM, 0x3),
+ARM_PROP("hw_prop_CTX_CMPs", NUM, 0x1),
+ARM_PROP("feat_PMU", STR, "v3p5"),
+
+ARM_PROP("feat_TLB", STR, "range"),
+
+ARM_PROP("feat_BF16", STR, "on"),
+ARM_PROP("feat_DGH", STR, "on"),
+ARM_PROP("feat_I8MM", STR, "on"),
+
+ARM_PROP("feat_FP", STR, "fp16"),
+ARM_PROP("feat_AdvSIMD", STR, "fp16"),
+ARM_PROP("feat_RAS", STR, "1.1_base"),
+
+/*
+ * V2 silicon may report CSV2=2 (FEAT_CSV2_2) per TRM page 392, but
+ * KVM clamps the guest-visible limit to 1.
+ */
+ARM_PROP("feat_CSV2", STR, "1.0"),
+
+
+ARM_PROP("hw_prop_PARANGE", STR, "48"),
+ARM_PROP("hw_prop_ASIDBITS", STR, "16"),
+ARM_PROP("feat_BIGEND", STR, "on"),
+ARM_PROP("feat_SNSMEM", STR, "on"),
+ARM_PROP("hw_prop_TGRAN16", STR, "on"),
+ARM_PROP("hw_prop_TGRAN64", STR, "on"),
+ARM_PROP("hw_prop_TGRAN4", STR, "on"),
+ARM_PROP("hw_prop_TGRAN16_2", STR, "on"),
+ARM_PROP("hw_prop_TGRAN64_2", STR, "on"),
+ARM_PROP("hw_prop_TGRAN4_2", STR, "on"),
+
+ARM_PROP("feat_HAFDBS", STR, "dbm"),
+ARM_PROP("hw_prop_VMIDBITS", STR, "16"),
+ARM_PROP("feat_HPDS", STR, "hpds2"),
+ARM_PROP("feat_PAN", STR, "pan3"),
+ARM_PROP("feat_ECBHB", STR, "off"),
+ARM_PROP("feat_SpecSEI", STR, "off"),
+
+ARM_PROP("hw_prop_FWB", STR, "on"),
+ARM_PROP("hw_prop_ST", STR, "48_47"),
+ARM_PROP("feat_TTL", STR, "on"),
+ARM_PROP("feat_BBM", STR, "2"),
+ARM_PROP("feat_EVT", STR, "ttlbxs"),
+ARM_PROP("feat_E2H0", STR, "on"),
+
+
+ARM_PROP("hw_prop_IMInline", NUM, 4),
+ARM_PROP("hw_prop_L1IP", STR, "pipt"),
+ARM_PROP("hw_prop_DMInline", NUM, 4),
+ARM_PROP("hw_prop_ERG", NUM, 4),
+ARM_PROP("hw_prop_CWG", NUM, 4),
+
+ARM_PROP("hw_prop_BS", NUM, 0x4),
+
+ARM_PROP_END,
-- 
2.52.0

