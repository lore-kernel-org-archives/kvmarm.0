Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C534DB55C
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691610; cv=fail; b=f+KbT270Oft8zYfr1u5FZKlBwpCBMMTJjUdPP/bLRUJrBkfmqlspsagh6CIlRJlp+L552BNI7CjxVqI4iiavbec7IppjGuWB8o9pAZAnrekcN2+MYvGHYxPsp3E7759ClMcFMRm5u6/euUshBEOc9U0FHQyvNB8xYSy9BgUnJWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691610; c=relaxed/simple;
	bh=M1uluXdoXz2UmkKoMHKUAmldUyXd9xHUgrg5Vk+2vlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g3wjfkhEsoCPW1lUIm721UWfWZzc6IwbFAmRzt4COaKIdjTCa2i+PSpCa1iFqxW1r6n9EmeO43ze6DW9qE4vmSF0wOgyyATX9oStGgDKdfDq7D5jO2Md4fwZXMoWfltCJpnIGqJEyJ9ZuIFJT4jP+qc2TE7tjJQyesWf7YaL1tY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=nsgOF7ij; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=JPnnpnFp; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="nsgOF7ij";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="JPnnpnFp"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGLKTm4149398;
	Wed, 13 May 2026 09:34:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=L73Uw9Um5kU3p7Uv0nNRjoWBNgOAHdnlFRQeQAV21
	B8=; b=nsgOF7ijr7lYXrjTj52bgmbNWIGu61LqUHR08avOuLQHw36O4ITB2phbb
	wAkfIUmqwsnWIy/qR8SQBnI3mQO860wlXW3abVk37BMPegpw3/shT5cSFiJJjKkR
	DCaWTKGUqCk/cijBbHBCjAys09gvL3ohA6l6RSBUFbo9Gh6I39mD0r2FIz5N+X6p
	vDF7xj1ewjUqLWHavgqMNZsp5ZOY3Fymcx2j+9rROfyYxiyMvtdu0Z2yK5qPyHX2
	6O29lRi9yVnafEh4t1Dxn5CXu/JoAtD2TlbcvdIftliRH+Q+/OQSAEy/HYXm0Xog
	8Xv/oJXL/wMDFRkaQ7bFrv26suvFQ==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021113.outbound.protection.outlook.com [40.93.194.113])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nva675w-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YtgCZCscsNN1wkx2deQBOJ7ptykn+COeXJC9FLZmDq5rdvZdSV52a18gBeajofGwv2f8J6TFFHBmE4t0vWNJcHCi1aWMFfqe+YhmMZGBn5GZOOGHR9E2kAArCYVvBvKMDBU6DJlX3a+/anZaaCF1cM6xpebQT0DsABg2rbtxKmkFT1oIt2c3QpbyjZ8sY1QB0ykcjOaC1mrZTCiIwHk6w6BXiZhRXAkWAyVxYlohOqtg7hW1JvPFy2KHPahyi8lWhBkSuaK2IiZv8yB31T9UcxPrlVBfTfFeTlcT8ZEqbfUREaN8MiEllsX8twaqp9sO+zYck77unuBf1G56bQNujQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L73Uw9Um5kU3p7Uv0nNRjoWBNgOAHdnlFRQeQAV21B8=;
 b=kuX1Vqzt/NaxIk8LqTUu9wGvZ7gdbx8QIA8AgDCpEMTDzD9jVs42lbvkQS62GiTO/zHe7txWsQZvDXCC4SHIh1Ztv6/aF9a0d2hnf5Gt/VUQ3idlm2DkMdfJX2rPo1+nhwCwEFdOhGS7xvKHw6MUV/95w5IGmRaxkP7AKTRejzAXZisiHknREOvfv2akB3/RPONoIz4zgvO/Sut5QEYZcEoU/1QVHMynB9EzyMeBHZpSfCfBwXbGEfRgsirj21q4qBMHvv/rr7b2RdJ4hY0KXNs0Osnrn3Fvlb7Ou3eQpjAjZlzUumV0bssRhr3+vqDIjfr5OJOGLorvbG80YgyusQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L73Uw9Um5kU3p7Uv0nNRjoWBNgOAHdnlFRQeQAV21B8=;
 b=JPnnpnFpc05um9raApXpVUP45tVdF88ExSrwa3kwk8Mzf88PUY1Rmmv8HyDLtX8NBN0V+vZnYrkslKyvKLRgrGJdwQgusFdlri8EVPb293WvWHuhwJ2OKZCIpm6EzXnkmaYik4hr5xJfoNm3+8WaBapXKd+FkjY9kAXFCzRmSnOfLnC54Hp5eLQN9uNr2nWG4tlGaasi9xcQWNhehvAPwz5aMIZXNZClFro9XRRUmGIw960Qso9e8NRilgUzS20oMYeH7Spfyij1s9XmxNAxUlSlMwqPSoDqCvGMNbmqWe/pJBmxVfttQV3FocnZHcXAdFCNbSS0V9ypmOp8xikOcA==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by SJ0PR02MB8813.namprd02.prod.outlook.com
 (2603:10b6:a03:3d6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 16:34:24 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:24 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 09/13] target/arm: named_cpu_model: Add ID register field helper functions
Date: Wed, 13 May 2026 16:33:52 +0000
Message-ID: <20260513163356.3033159-10-shaju.abraham@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: e8b3a214-b750-4f5b-c34d-08deb10d7dda
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	PMsBqrIQAby9Unbg3zUH0NcAC3QNoYFWSRL7kYpaA6K0B7/tT9O2rBxCow09ORDkURYIjqh/FZ5kUcdaz6HBFG8tXnFm5isxHbo7ph1RDK7hh5Hl2tATfRdTikrR7uWRz2rEz2XqP8XOQwJzXJ2A10DZot5Kj3IJMEImZsqppdxLf4VKcLCGh1e9cmekDRzH2Xy+H190LMVhhYvOB0hOGfrR523u+fVlnShI9ag61nYpqboNho99FRGCQD12q42WQcGZkBY4BdD3YIxFrVtyMK0OS137uNebt3osQHzIoHt3iHmK2Gt/U8wXmuJRFa12nsEfv6xdxnEscaVVu95TML74uJ5Z1zQuquW1JIeCLycvYEQp5TKJHyiRTFfCkn48qv0Z0kZYgCLgcnpNaxrmvwU1y3l/MOJ9pmkXX+Zm4cZLo8pnl5+gwqSzww0tDQGKX2A9NAs9wJTl2Bfuviw+jDGmBbOwc1YuUYn7G6ARpFdT6FaAwI4dw0hfaLEjitD6gsNpLXurZXv9fwPU7Xz51doEQLdFe3Z/wGBxW0vFGDvJ/ESdkiJTYptkUH0R4eWkpakLhsNA070FiLig4uDxKRl/KydM6ueRg/KnrKfI9DsOPE18CMQzSAu5S7NUgPkxAW0aKhu833ncT7eZl9qnE8wgWpobyi8N47Ib7I4VhTfBgAUqGbadCWFkB55G41IIH3+hRGcZjbaYMrsA0lWq0e2G5sE7Jz/koW63X+g/YCo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+XG3eIn/eJvBpXE0Lk5eCPLyEhTN6/l5ySH5Buboc4SfG04rsXoxUPGZhpeK?=
 =?us-ascii?Q?FnuhIqqJrEp/+21udFGD3HC62hsExmYfFeIpoYpp5CJOIU8RUte4N1ZWFGLd?=
 =?us-ascii?Q?xnaRmxyGlE7czn/NmJrgsEFFObOJ9rsnk87Ij2ifLftRyLgDzv1M4xiAzxge?=
 =?us-ascii?Q?ei1dfRHu7AbPPZ8O5Ra1WiE1N28tACOXyk6AxlA01n/7s96ssra7P8LDZ5Tn?=
 =?us-ascii?Q?i17scm0OpQx/fdJ68f1jGYmIoIXv1Vb1T7a6tlONHpB4AZmBVNlSQdul0t7B?=
 =?us-ascii?Q?9mayyk4R42XtaevBb2NfFNlq09Bx9xtX8oJTQ5mGKzpW0orhd79bTFnbyCW+?=
 =?us-ascii?Q?n8cQmvPSKiJ9VOW/GT+V+Jmq5/3Yd8xWeBGLJYQwA6Lxp/XndjOn7F2zBdGu?=
 =?us-ascii?Q?v0IFZE1tUXVC1zHETCRmcjTTH/rM0+wk6RAl1W4Syoqv6MkweJb676ke0Hs2?=
 =?us-ascii?Q?74vNa/B4yYRWg30FtTu0msyfyvQ7tCfy8Lg/sztbTwUJpiDtjvXpC5dPhudM?=
 =?us-ascii?Q?QuZvGJWpoKgV4VC+YjF4ro+sMO5ZHnbozsUv7kFBDAFqX5J2h1hVGiI1SVpR?=
 =?us-ascii?Q?TbeEpKAe1XWt8d9ApMHYof7iKIhKZM43tfMW163UDhvRlKKO5ymL+U1pcUoy?=
 =?us-ascii?Q?o5eRwpNx4G2sULnQ8/HVZfVTS5RykrX2up6xKSEiH2+cXjXBaDis7CdUz4rH?=
 =?us-ascii?Q?7YOolLAFCTPzwvY2UxG9CC3DWC36/reABXhTdtnkuvrXKVrD0p/RloAccRzy?=
 =?us-ascii?Q?ccj+NxZbSRWEF0as1bDsrPNv9Vo50qkj7YhtvpvGUja/7Fd8XTvHP26IZ+4S?=
 =?us-ascii?Q?W7dd35RcdZxdewVjc7p8yVonNpMfPJoF8hZ/4QDsu+7mGQJGCzSNqHBtifDk?=
 =?us-ascii?Q?ZkvEVwImtcWB/UszMDgfSLFSr1LjgWki422B6PKo8GDGbqH1Dt56P952KDZZ?=
 =?us-ascii?Q?XsOF1EMH68B7nzf5yyyaB0raxpK3cPqEKJDzDkO2VBKmO6FBAtA0SgUBWDeO?=
 =?us-ascii?Q?jNecYEJCvm9gAYR8kSrbVi3hzse1l/2stuxHxCKs2huxRSRWhaHXOH2tg8b3?=
 =?us-ascii?Q?DOJJqbC/ZBMRxjUyyZFGfvprtwZwobmM193vA8C2g1VNWjjmuylsdVjbqm6b?=
 =?us-ascii?Q?4/mv7dD8IRSpmx9qHhWzllbZ4SPYV0YMlXSVnZxQi9/yJkUgoUqFMLUJaKTc?=
 =?us-ascii?Q?mp/agOANXO36bTAMJrBYRYlp9ayPvKR+nRiE7K7AQk75vkoxyy6+yeSWvdbI?=
 =?us-ascii?Q?HnDubC5FmUvVXgM3HUxJydRSe9mELbUOb3UwciZTRF0Jl75jvhxXPExasX2N?=
 =?us-ascii?Q?0exgBeDG+sQ7Xr1EcubjBEvc8b/WN181DbB7M4FagMX2V1Zaa2bbwmWziXib?=
 =?us-ascii?Q?nLPPKOPu8XTrybV5c43S2YzOiY9RKnM9jegVOBnYDyu1se9lZQ74XBHt4Vnp?=
 =?us-ascii?Q?eJZmoYLrA/VAE7yBR36QlAVL36LrRIi8uXSEdGhp+F5sGbwFi0VBOAIGS7hJ?=
 =?us-ascii?Q?ObcEZV400NtdzCM38YeakjTnFunG97f4j939eiMkGVQ09yZ4trqU+MYbXhZ9?=
 =?us-ascii?Q?MMWCe9QubtFVBupJNmfREZFYXhUfO13cHwNcBjd5Gaf8xR291OmAXvCnMJoY?=
 =?us-ascii?Q?6YuWGFEN/5esi4lfkDLMfFdufkCay79jgr3ngT4nm9ClZnfCIN9koPbOSMFI?=
 =?us-ascii?Q?gVsv6JrOgc8ojO5oc8UxlG30ZxMorFjt0TJlcWxKcqCL/saoAF1U7dU/m5/N?=
 =?us-ascii?Q?6/IsXmspHYU7BeBMjp3iolB0oqp6xd8=3D?=
X-Exchange-RoutingPolicyChecked:
	Qx+Xu6h/qVLeIgnHQu3U7/urxLi1fSGVbn93t7Hsng3JxY0qjtSEoV2YnqIe6seKed7wKsD2MCGuoEgoini7QRfePjiHrbXx+BrmlRECOtas/YpR0lYUOZzowtLJHsULRCyHyvnzICqOXRfXUDIX02urLk0LMbfQiurk4AZkyYcYdn6sY+IZNpV2mx3t628Hzuxlu7ArzfxkZd5IPBKuy9BrQ7w5wQkGuqWo/U4HjuA+x6ZRbUzSy9vTpUvJQCdYWGOgpZ7gAA2gp/SavROufgFSwC4NCMQf6dVAFc2RWl+UsKEa4oADY5CBfqx/h6EFCy4iKgm5aTdTzu+ZGsavvQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b3a214-b750-4f5b-c34d-08deb10d7dda
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:23.9724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r3YqoGc0aElk85kWGYAqLDjrcWoVtXTdnbEznXQVuIjdXK5q8EkoZSTi39O+6pLxU2QS16/Gewtypmd3KR04HKgghaQVb6OQtAZpESWxfpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8813
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfXwKofUIeW5V24
 9AVNbEe0sJJ30vwzKfoa5dJuLbaXp6NqI8VkE2QwflTQSB3tIEZ/rYJBMvALO3mdFMRL3VGBKLz
 E4r04kmTvzukv6NYPw9UIjKvUaw0hRqAh2qYruEp+h3jWJUq687H27/Pp6aNjpnynFs/dGEAgXD
 9HhoTIBf5PdUBqdKpMoJ19fHW3U4c5wgmpsffYZWvilZvzqw/HrUzrYLrUZnjszdgFt3fPZ5fqR
 FBVN3rbweJbOpzq05x1s9QQ26D3X1/BgWguuvmebc+f/RKELLgp72mmjuiA/pp9kXMGNjPSlSD5
 9RrYzUen1Fe/rMqFuFxA08ChiKZ9j4mZAKcDbcAOt270BM59H4nUnSQ7m5izA4KVcDJzkhvP5rK
 tFVZczjdcBNXmLDBp+PcRJMtUupwUJULHi1sy+sM42AyE3F8ZpzR1rZGbawUGbylF4oPxHiEuS+
 qabsfzs9jZ5e7US2SsA==
X-Authority-Analysis: v=2.4 cv=evLvCIpX c=1 sm=1 tr=0 ts=6a04a814 cx=c_pps
 a=+jjOclGHkOGhuepu6R0Llw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=2magLiQhmqer7YsuebIA:9
X-Proofpoint-ORIG-GUID: 1Bnqj1_J7JTUo6V-_3O9Ucp3V47LeyKw
X-Proofpoint-GUID: 1Bnqj1_J7JTUo6V-_3O9Ucp3V47LeyKw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add helper functions to extract and set fields from the ID registers.
These include reading/writing individual fields, looking up architectural
value names, and resetting ID registers to their default values.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
---
 target/arm/cpu-idregs.c | 107 ++++++++++++++++++++++++++++++++++++++++
 target/arm/cpu-idregs.h |   9 ++++
 2 files changed, 116 insertions(+)

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index 8fced7d8d7..5ffdeb5f21 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -122,3 +122,110 @@ const ArmIdRegFieldLoc arm_field_locs[ARM_FIELD__MAX] = {
 #undef IDREG_FIELD_START
 #undef IDREG_END
 #undef IDREG_START
+
+void arm_idreg_field_read(ARMCPU *cpu, ArmFieldIdx field, uint64_t *value)
+{
+    ARMIDRegisterIdx reg_idx = ARM_FIELD_REG(field);
+    uint64_t reg_value = cpu->isar.idregs[reg_idx];
+    uint32_t shift = ARM_FIELD_SHIFT(field);
+    uint32_t length = ARM_FIELD_LENGTH(field);
+
+    *value = extract64(reg_value, shift, length);
+}
+
+bool arm_idreg_field_write(ARMCPU *cpu, ArmFieldIdx field, uint64_t value,
+                           Error **errp)
+{
+    ARMIDRegisterIdx reg_idx = ARM_FIELD_REG(field);
+    uint64_t reg_value = cpu->isar.idregs[reg_idx];
+    uint32_t shift = ARM_FIELD_SHIFT(field);
+    uint32_t length = ARM_FIELD_LENGTH(field);
+    ArmIdReg *reg;
+    ArmIdRegField *fdesc;
+
+    if (length < 64 && value > ((1ULL << length) - 1)) {
+        reg = &arm_idregs[reg_idx];
+        fdesc = &reg->fields[ARM_FIELD_REG_FIELD(field)];
+
+        error_setg(errp, "value %" PRIu64 " is too large for field %s.%s",
+                   value, reg->name, fdesc->name);
+        return false;
+    }
+
+    cpu->isar.idregs[reg_idx] = deposit64(reg_value, shift, length, value);
+    return true;
+}
+
+static const ArmIdRegField *arm_get_field_desc(ArmFieldIdx field)
+{
+    ARMIDRegisterIdx reg_idx = ARM_FIELD_REG(field);
+    uint16_t field_idx = ARM_FIELD_REG_FIELD(field);
+    return &arm_idregs[reg_idx].fields[field_idx];
+}
+
+const char *arm_arch_val_name(ArmFieldIdx field, uint64_t val)
+{
+    uint32_t i;
+    const ArmIdRegField *f = arm_get_field_desc(field);
+
+    for (i = 0; i < f->arch_vals_count; i++) {
+        if (f->arch_vals[i].value == val && f->arch_vals[i].name) {
+            return f->arch_vals[i].name;
+        }
+    }
+    return NULL;
+}
+
+bool arm_arch_val_from_name(ArmFieldIdx field, const char *name,
+                            uint64_t *val)
+{
+    uint32_t i;
+    ArmIdRegArchVal *av;
+    const ArmIdRegField *f = arm_get_field_desc(field);
+
+    for (i = 0; i < f->arch_vals_count; i++) {
+        av = &f->arch_vals[i];
+
+        if (av->name && g_ascii_strcasecmp(av->name, name) == 0) {
+            *val = av->value;
+            return true;
+        }
+    }
+    return false;
+}
+
+bool arm_field_is_idreg_any(ArmFieldIdx field)
+{
+    const ArmIdRegField *f = arm_get_field_desc(field);
+
+    return f->arch_vals_count == 1 &&
+           f->arch_vals[0].value == 0xffffffffUL &&
+           f->arch_vals[0].name == NULL;
+}
+
+void arm_idregs_reset_to_defaults(ARMCPU *cpu)
+{
+    int i;
+    uint32_t j;
+    ArmIdReg *reg;
+    ArmIdRegField *f;
+    uint64_t val = 0;
+
+    for (i = 0; i < NUM_ID_IDX; i++) {
+        reg = &arm_idregs[i];
+
+        if (!reg->name) {
+            warn_report("target/arm: no field table for ID register slot "
+                        "%d; cpu->isar.idregs[%d] left at 0x%016"
+                        PRIx64, i,
+                        i, cpu->isar.idregs[i]);
+            continue;
+        }
+
+        for (j = 0; j < reg->fields_count; j++) {
+            f = &reg->fields[j];
+            val = deposit64(val, f->shift, f->length, f->default_val);
+        }
+        cpu->isar.idregs[i] = val;
+    }
+}
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index 4e568e877d..0127bc0a95 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -119,4 +119,13 @@ extern const ArmIdRegFieldLoc arm_field_locs[ARM_FIELD__MAX];
 #define ARM_FIELD_IDX(reg, field) ARM_FIELD_##reg##_##field
 
 extern ArmIdReg arm_idregs[NUM_ID_IDX];
+
+void arm_idreg_field_read(ARMCPU *cpu, ArmFieldIdx field, uint64_t *value);
+bool arm_idreg_field_write(ARMCPU *cpu, ArmFieldIdx field,
+                           uint64_t value, Error **errp);
+const char *arm_arch_val_name(ArmFieldIdx field, uint64_t val);
+bool arm_arch_val_from_name(ArmFieldIdx field, const char *name,
+                            uint64_t *val);
+bool arm_field_is_idreg_any(ArmFieldIdx field);
+void arm_idregs_reset_to_defaults(ARMCPU *cpu);
 #endif /* CPU_IDREGS_H */
-- 
2.52.0

