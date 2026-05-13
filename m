Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881FC4DBD79
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691045; cv=fail; b=oLIX6/wl0Ilki90U0hhOopSagHZQvX4lFPnPMGe0gLlrajfFvxDQUHCLH4HB9zmG20W9OENbqBE2iACtyU2t2Q0wjABRlO+GV+NNTK3Kg80B0Q1RwYG24gsJzEh13LV/tg5QFoKBxsqVS7Ca6AXdTp653bRs40eaJo1Tc/yBd3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691045; c=relaxed/simple;
	bh=4f+xN4xqI5YLSdAw2eTq1NtpZn3uqz9K3DcP5lq6FN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lDkkWHjBLUvsXzMB+s6Evxpfdc6NynLOlRsrrm+s62Z8h0PqdpLHyivsGA3cT4Yoe5CVlMVfVx7USE3uu4AYo7+oFo9+gTEFexyJDQkrtWoPlK9m8zCN1KSvR+3yy/NQDUflgXfI0XyRTgKaA/dRNb+jAeFfxmuliGrvTMAl3fI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Rxt0kW6b; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=H2CQtvV8; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Rxt0kW6b";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="H2CQtvV8"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGLC5S2443715;
	Wed, 13 May 2026 09:34:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Qehw87LqGTidFltWgkPrhahfky/iAtDR2qfeAuhVG
	ik=; b=Rxt0kW6bZGZgVmIDbM+uYE01xdmvi22Eah5L9ByL1DkesaI0tZhoHWqzE
	x65VUpc7LQPWjs5MZIVVbHtL5w1by4bArsBSZvi+6RjEoztQTGSXRK5+0/mQgmJs
	5gh//hvADoa3YFdCrIXUnSmnFpRAG3PBXKnwZyhPTJ5VH5pBmdvoRPA18JqgNAuz
	KOLGzQpLeVZyKDqYcbLiekR6OyN6VdDhdKQrTJfHXzpJg2exwKRbgfUCm4ZsyrZQ
	JIubLBaE5lbne/SLzefXY25hGwfFvMj6k2BcBl8JcWjg7ZBNa5lvBjpkzNkY7XnX
	besmj5CM4mYpxJnEVj2Ed1wchtl4Q==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020138.outbound.protection.outlook.com [52.101.193.138])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nv6x8ym-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XGinTcRvggJPqTFJrqnxyGWMXMNzRQIaT0qNc6DLSL58wLcPvGQ0zR4L7bzo632CHVgqIAyMrSEjKjahRrykvN6afZGy6qto7+TMs3B34tKbvD0yC2vZYDsN2E4OvM0pN/dwFFXpIMoJ5bRmMp4rrvc0uGLY48Zx+YajZATzOSGY8aCVfTZem23Z2pD0V61ekKd9f4dH5s0DF5He9xv3xBBrxLZwIGQRy3xMPx1fhhCUhYT/VJGzzNeBj1kT3wPTY7elZom/tWUJ8TKDdFYhP15C8Hs1RJcPuGpdrTpAYMFE8MphTkx8TiZ2NoJCFvN2+FsGB+6cin10RmOXvgEejg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qehw87LqGTidFltWgkPrhahfky/iAtDR2qfeAuhVGik=;
 b=U4MjRQMKJdzMrcPobkOExW/CHehaG8Xw3m/fVY0P4AZqAXxTibXe93LlHL4MaB9Otu3BuFswbfiRdSc/ndK3WJ7d6Vmp6RBE4q9LuFUXFydP9q5WHXIrYpwIzamH5nUCAuDhkat6b32Hykk+DsDYzEml7kqkqpyoh3YdFDhyD9HYKXWWKCfV+JYf3POcmNaCa7zuld0Pzdn0bNE91UmLXaC1EX4bk0+Cmx/dbr7kgygzwbo8bHSY1zi55lVh/YoZyy90tVR5l9yK4tjXFdYx1IVeGIluEGz5/QOGcaDzvKlN5htCvhxfY686BYOfdXu4Dgim2CN0sGBobPrje0ScjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qehw87LqGTidFltWgkPrhahfky/iAtDR2qfeAuhVGik=;
 b=H2CQtvV8WjypxK5ZICCsD/Z4r4Gj9+qffG/Hgas9e0Vpajrrc7kGLPCKLFt4R4fiOpNE3XXzMoBrHny5F8Xw4gseyyy8/qdIdX9FAzAHYVV1je5pJE0kJxQPGHqI5zWiomUqzcCMikdoTLnxjsiuQGHbdIWIO7HH3rz9phwigYe0YE/zGzK8zYpymM9itzGkxZP4xnshtFgnRkRZk9LWhKyJVBHiIWja1Gv7r25gaCPpZU1OjZwOMFTfEI9MllRF2b6o67/cnQJ4VyJd0j0DaaY3UMHw6MOW9lQPVqaqkZ6CBAtCnGLk4uBZu3jCxzZMIlPsW1OVUQmE/NEN7y6THA==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by CH3PR02MB9564.namprd02.prod.outlook.com
 (2603:10b6:610:120::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Wed, 13 May
 2026 16:34:08 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:08 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 01/13] target/arm: named_cpu_model: define containers for ID registers and fields
Date: Wed, 13 May 2026 16:33:44 +0000
Message-ID: <20260513163356.3033159-2-shaju.abraham@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: PH7PR02MB10160:EE_|CH3PR02MB9564:EE_
X-MS-Office365-Filtering-Correlation-Id: bf32e7d2-7c7f-4a77-a379-08deb10d7455
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|22082099003|921020|56012099003;
X-Microsoft-Antispam-Message-Info:
	hVzzHM/sayyFhpyXaP04FRyFSlmpl/kNYdcXVHi+OnqxlECe2CtSMQRT347gIqqluQOVtNAz4GkJTtsd8pMov5XxzNAPLuxAtYr6EI1/xskeKFtskAEc/YEdX45ibyGxkIfhoO6W7FZITMUqmu/d2RfMo5Ez3rZsQFwIp5Sd2Kc7GWcYQToQKcEQ/5xG6AJYgmW6pHf5BsFLPJ4EucjQwRnHMHubuSWxmbaLw6e5v1HYH9YyaBEV1XP70UW0OTiD+2BA5tDwrYNlwMm3yfbEi/qCxpDXQNin0R0csyaTITFJG10yor3V+tZ3OfPSpbHm0oVNfc63v9MCmmP/pZn3JbLsgY+h3tn9fz53ZZ/bAH6n8us5+MygMvXb60bhvmvGUC6z4qAEkxPbcag2vc67GjstXxQDCX0dJTKxEu5TZYUjip11HOCpOHlQ/rrYr3wC5Lggzpqv8P9a+lI4RiEIBCqe9eEaN599J5nkwU9mA4AuC6+A0Ry8g06s1it4lFvNo85TjcX0eOxoa+80Nryn0zpP74CiLkI5lbcisWfvCrornStpj54wAZ1SMkOa6w9JQaL5jDvUXzy1vNFOBrFfU5IsiW8+u9kwYuUklGlvHoeq8ZvapqKVB8WubFZUz/XDAXumNc/tM184dVDns90CGUGxFgeA74wM+zj7kvL07w3xaCqKWpz/WgO8VvP5LCO/PFcYDWL4yNI3hEfIpxnqV3ElQP2AG3cAqJXH41uCBVc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(921020)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9oy0oFDFhOnoF8Aiq2eTpHQPZizBpgHH6tQjPYPOKSM6xP089vSdTEG8Yxoi?=
 =?us-ascii?Q?pMbri8s57Ji+b6Mrtw7CMdhlQ6c0e4cnA/lMY8+KYoDauVBCSnFbCG/yjBgi?=
 =?us-ascii?Q?wo5YquBB0eShLW9oN5U2jhhbDReYhZGZKBEeaxyfW32WVP1GClBt1n7exxN2?=
 =?us-ascii?Q?cxae99v3hG4JT1jJZSbBIGaW83pimv2bO/bRzu3e2C98TNxC5KZxN1nVf55B?=
 =?us-ascii?Q?6QDZ1D61zViDQn8O8rany67e/eEAPgmM2LJQfpM9O6Z4MrkqaT9Of34uuPT1?=
 =?us-ascii?Q?czmaF3gev5ZO1eCNdiR/ZS1FL1Efo3T2/dmoPTqjTBpOlpxX/Oir9xmqZi0h?=
 =?us-ascii?Q?XnjDVznYbaeAapww0ai/G7PEZEHx9umfRNxcKlWMxuuvoV6BE8mM04eap3/M?=
 =?us-ascii?Q?eeZXXhLmO/g/rzPsf3SOuh9xrmquu45HGwRfdKecggp6k4rjQMbVgIiB/nbQ?=
 =?us-ascii?Q?zYAGeDZ3fYquIxm/CtFK7bCBgSPac1zCZoouzOz45C6zkDUkehUr7uQxpmHo?=
 =?us-ascii?Q?84ZQCGJ+JG3WQXW7/1L994uhBwfl6igdjsbb3kABdi8O9nSFXEHScRsdcXIE?=
 =?us-ascii?Q?T4KmLStnRcPuNciTHM1SJV/qc+0adxthma2FkJzl8BUw2lBg1bLjSe7ylh33?=
 =?us-ascii?Q?B8ENnGXyvYbUPMGZEuLJjP6FzOobpT1XoEk9XSSE6kuhABU8BvNUYviU2zKJ?=
 =?us-ascii?Q?WwXVmU86PxuMSb1KvJ0N1r6R3u+7b4wgf3VA3iCJ+ckr2d3y4tbpqfRz/Ny3?=
 =?us-ascii?Q?mYqZqAyQgpXO8ZoWq8udaKrk9HTOLULA7riV6Z/jgY+1kisNdZKkAZ1+MG2S?=
 =?us-ascii?Q?WhE9ZTAYTe95KYgFjwok2S09d3z9H0GqqsskIak8D4hW5RTZniI37/heM1Pc?=
 =?us-ascii?Q?wCi1Z9hwuZ5t3rEjiN8YGwA1kbtlK7IKsjYhDKmeSqtra7hX59s8AYXVeqbq?=
 =?us-ascii?Q?wU4uEg6NhpdjqGYH/Y4fLtRR8rCBmoAOeNmFoD2Zx6Ulm+1Kb81jY+n5ZCfJ?=
 =?us-ascii?Q?AhSh+Nj7841mZautAFkcpFLysLJK1T+cyPjwAM47wDjDlWub5YSiUqLpRFWo?=
 =?us-ascii?Q?4DpvmHWqvh6YTEZQiZPbbZFlfpLcelqSG0g4vZmmzgslrZLFjzb/ArXeGxlb?=
 =?us-ascii?Q?/KHbT5mq1gnhbUIWg4gwU7V9yE+BUuify9eXJBbwyPbB0BvZawCn4YnL1/xD?=
 =?us-ascii?Q?R8nUmyShgeUT7ZbxtfHlGTeX+2fPCWeGhEtJQZVW1GcdhRGLgjSxRDaWQkh7?=
 =?us-ascii?Q?bHN4iQB1MXhINI4IxVzV+0IFxOcEuztrUG+XgQB/QAR/vZW7IhgEyRsfH0Pt?=
 =?us-ascii?Q?M/sekdfNLIEOld1VhDBlem9k5GW6UvMhcDeqqdqFXtsX5BGX2MPFA2qDehtV?=
 =?us-ascii?Q?KI/BDKa5YsU6+6PLi/mgPQibEoloNOTmzDcXsSDv5+Wje0+d0raKbWrPnzjP?=
 =?us-ascii?Q?cTpwIfncM7B7btpGVDAZbQjPZ/ypFuAF/NKqeV5pIxlIXHsBatWSzaKYUz2O?=
 =?us-ascii?Q?Iirf4h+Qmd4Pmva8Xnt4Rb5MoLWFzoR1y+A3A8C6kVefkm5U2lnSM2lDAQtI?=
 =?us-ascii?Q?PK0WuNk+yFkCvwoBr0PaIt1thic3wmnEPIKpyGkmaNqPUwvUgzCMO98iwpgI?=
 =?us-ascii?Q?Y3VzfMfmhr7l9SyLqs/jfx1F7hwDPNXdHf7UyrTRSBdM+AcTYDjzxaxRUqJD?=
 =?us-ascii?Q?L4fjjM8Z8pQvnTxcHh9Cyp/VwJ/sjIdSSJB40LzRLbvx/UmPG3+nBdl90Z2z?=
 =?us-ascii?Q?622cpEbEaqDh62cHetwGoE/oQQJcKjI=3D?=
X-Exchange-RoutingPolicyChecked:
	P18ncruISGsx9TnI2ABlkM6tOeyTF0fALuLYcIUFx6Buu6I/Baa9gNRzAdVRyRG7TcBEaZVGUtUXlBZ4VT+sT8P1g4HzI+CAHA9flWLW0Udtg/7FZfGu1xfVmlX4TMJcREVxU12H9rht49X7+SNnSbS/i4XYeQ9/ZBS9euwryOSc4BjRLM8BWOSpd2HXt3HG+sWmp68bXB6qtaMR5gwjoTwYpbo97ub9bBuXzhCcg/i7sGKpXuUbbl4Y94jScY7hdNm9gWvBooy0VHtu6GiXH+LlJu+XwyWYx36ELXjCjib6pXDr040xoyVXfbtnfkiwHiZQ7EniGDyP1Kse7DosVQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf32e7d2-7c7f-4a77-a379-08deb10d7455
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:07.9287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GbgNYKgMqjUL2nbQCqGm5OzydReUWXIjRoNx/gqtEE2Nnyi6MeOL7dAGqf/p5EEtxN4heVGzY8UdFsi7Tqw6ydTc7EzjD8SlkdHqFgq8Qaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9564
X-Proofpoint-ORIG-GUID: LQlOHEOEweKRbfIAZpJ6RVyAXbvCkB6i
X-Authority-Analysis: v=2.4 cv=P7QKQCAu c=1 sm=1 tr=0 ts=6a04a803 cx=c_pps
 a=wpg3e3TFAlO0qOiIlNsFBg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22
 a=64Cc0HZtAAAA:8 a=yZbjWOkPDpPANDiVIK4A:9
X-Proofpoint-GUID: LQlOHEOEweKRbfIAZpJ6RVyAXbvCkB6i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfX6U7FwoAd58q+
 juXK+uEryr5LpJSHAngDCfZMlmOnDErlbHWQLPOj/b0xitTsvnCL0ZYMcW65l+KYlNYafQIPh+e
 mlQCsCixiVtLQRceNbtx1sLqXHmUQyfdwgfXdN8zBGaiECDLMOsTl0sRcQ7LxWCz0976tvW92cb
 Phe9e5qiQEfJJs/U/F34JQO2ELRtMPOHo1svoI/4P/xCa+SZjxN3GkEOsThG1U7LsfCm7Yvg6Xb
 jGnQ0NOZU2QK5AJX5dS66BDJYUHu2fqRAOQ2SRHWva18SW9nh1EWcCjg5MpJV2rpKEEpsGvpjDL
 mNYY8LKugIbpgge/nvdGBdCn/gQLcpSVkJnIkyGa6ND5cxZ4OMyVWnSTRKVKiRO9/1/Bet8uCJQ
 J/tAhLpV66w+PrfdIOrZE5KD0nAc5gp8LOn3p96GEq3rQ594KD4Mw7Afq4pEcsneMvADhBunduX
 P3Q9GDBepx+oOzSOkTQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Define data structures for mapping the ARM ID registers and ID register
fields.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
---
 target/arm/cpu-idregs.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 target/arm/cpu-idregs.h

diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
new file mode 100644
index 0000000000..403190cbd7
--- /dev/null
+++ b/target/arm/cpu-idregs.h
@@ -0,0 +1,41 @@
+/*
+ *   ARM ID register field table -- shared declarations.
+ *
+ *   SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef CPU_IDREGS_H
+#define CPU_IDREGS_H
+
+typedef enum ArmIdRegSafeRule {
+    IDREG_SAFE_LOWER,
+    IDREG_SAFE_HIGHER,
+    IDREG_SAFE_HIGHER_OR_ZERO,
+    IDREG_SAFE_SIGNED_LOWER,
+    IDREG_SAFE_EXACT,
+    IDREG_SAFE_ANY,
+} ArmIdRegSafeRule;
+
+typedef struct ArmIdRegArchVal {
+    uint64_t value;
+    const char *name;
+} ArmIdRegArchVal;
+
+typedef struct ArmIdRegField {
+    const char *name;
+    uint32_t shift;
+    uint32_t length;
+    ArmIdRegSafeRule safe_rule;
+    uint64_t default_val;
+    ArmIdRegArchVal *arch_vals;
+    uint32_t arch_vals_count;
+} ArmIdRegField;
+
+typedef struct ArmIdReg {
+    const char *name;
+    struct ArmIdRegField *fields;
+    uint32_t fields_count;
+} ArmIdReg;
+
+
+#endif /* CPU_IDREGS_H */
-- 
2.52.0

