Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2295648EC8F
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 13:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995686; cv=fail; b=cAFsaPRpUDEMRlLapnpRFK0ZkJVtOqJfo/pLVg8rWjxSr9Ux/nQnOb68jbVTF7ojlfE48X75vO0DyW490TckncFWFW3s94i9mV3FkVZIdud1DC7uSPyxD3DWeysbNqgK5aObsiLy0gQ97lLhflACxsQ/QDgBL7LLO/tIKDzXFvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995686; c=relaxed/simple;
	bh=s1RKvsBmOByzvm5iyrp5wudLZlzSZkamUxbEXo/6wy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TUsPizOGhr6YOc8DsgumNpQXceV7wRJygyesvvcGsDuZlcDA1MWSrAGdbiDS8pkIYU0SF/bWGIg6+RD0qVIYRjibphPgRUVPlHzjS+RwDc0NgUyowDf5HBbDeDoViPLLi9WBqAarKkjcFIbrsOaweuQe5tPqj5HNxrq/mSUTNnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=rMsz6tpt; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=wm4iz7+T; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="rMsz6tpt";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="wm4iz7+T"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAfaiY685521;
	Mon, 21 Sep 2026 05:33:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=RoA46Smm2kG7AgEkLGIlPx/3rudaOSdVVhNBIOQGU
	lQ=; b=rMsz6tptMmg4HQ1zjFA1XoV9CtjziEMmhraWaHhmI54X7HbhsR8caICyC
	zCzJKNamLSMfUZxj41fxaE5b3zQ22slL9+e29rH5KE1p1RUwSeI+CWI3qm9pAMiT
	HPlJxRNSHDkTEufeYZXXVAT59Hdepvz71VLIoJnveznGfLAPrDqvjo867FOgXCdF
	w3ydFOUCS0Qvz/fF18eCPMXRsY7echLBkAB7JHvqqhoztqiUYE+k8uObA6b+yy/w
	gMIeqn/KyTaobBcOc8/30lSk68ufktvTaHy3DckqG/xYZpJUWKPr5vLbSGgxRAGB
	SUwgLyyylMrYmXabAvVaOd+2k79GA==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022084.outbound.protection.outlook.com [52.101.48.84])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gsswvtxe8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CHuY56JkkvVTdlOpb85sfe5dePnjFNicz+LLsU0+DY7rvHll39YFFzABLJ3FWhUIGZuFGR/sBPirTYK7m1WXACOul0atzyufZGTIoLUOb85FprmPp7oVg+UomOB5U/OARiTLGaSJkcPfe+yB30m3COzUS7E3VFjdKG3WqMNaBAU6qQgD67zrYLA41N8cgLTF8wt9LgYl4c2ehEhXLgKTKbtvPb3YDmqhVDW2AIZVUXWmHr04yL23MsEPll+cWYy1lx79kiZj1Njk2x9fKD34VUUKRpbYUVS+A6duGqS5DDXfsP1XcnfDHBBmQLNPvg8V8id6CnCzE8zM8ShUSrc4Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RoA46Smm2kG7AgEkLGIlPx/3rudaOSdVVhNBIOQGUlQ=;
 b=AxQa90kiOuvus323XLDSVkLodj1MsKrRaW2j7RImZqidQzrppQAE0uAuKa7lB+skSFpafLwFp5F4EIMCo1FCAW1qiXkeCLDPTL3y9p/i/bH5l+hBB5sLFTWFYKhUV9QIo7Xhm5dAv42NSgPOqH7pWWWJdU4FY0vFxst2qOgyF5uV403sKMv4k+VChLSenm1UgmY2NxooBicLvAG4q/k6D0pUHbVmNRnfEmSRLI5VFNXGuFdMGeIDTAa5n96zhP9z+wxVMqCXt7tsAxAssiWKheBiH7iT9kjZC9cuDgOKCnV6Tpr7StSRnnLLnfceUss8zvf76G/gAqLyO7uxN0fjMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RoA46Smm2kG7AgEkLGIlPx/3rudaOSdVVhNBIOQGUlQ=;
 b=wm4iz7+THg24jFxjKRYj2f0JZ7hxRUhQHPb+WrtH5Toskiy3GS6mrD7A1ButI12YfkJAVMmJttEvi6s9jiAMtIwnZ4hDYlO7idcy/UAohInRWdpVYc6wNj9Iovk1a9n9uqRZPSeUE2sfo3DRFPXdv6oB7sONIZKBMhebw2IzcdFUqS/ubcy9kJG1YG4PYnXV+GGj9g0obaZNYDsqJOaWmXqrzv0cRude64fbhn9pnMa88qU3C2rwKoG+RPmkEF9NcoW/fsnOWarevH42ZSD23VNtc0Jkb9Vs4qKHxrrqrUgXZBGN0yBuHhy6tbAXyI+ZNqkJqz+WpyfJiYcV1rw2/Q==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6868.namprd02.prod.outlook.com (2603:10b6:a03:234::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:33:40 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:40 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, khushit.shah@nutanix.com,
        ping@khushitshah.com, sandesh.patel@nutanix.com
Subject: [RFC PATCH v4 22/25] target/arm/kvm: add kvm_arm_get_host_isar helper
Date: Mon, 21 Sep 2026 12:32:46 +0000
Message-ID: <20260921123249.1708067-23-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260921123249.1708067-1-khushit.shah@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF0001330D.namprd07.prod.outlook.com
 (2603:10b6:518:1::1c) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|BY5PR02MB6868:EE_
X-MS-Office365-Filtering-Correlation-Id: a82b6669-e07c-4857-409b-08df17dc90dd
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RWN2ABPrO3SWcjbv+0Mom54xpnBNU64XV/+SD0r9oEQniwM2w4Od3A98YeLzEwBLdD8ujsTpxyopwaLN++tH21Kw6qZDk5s2M4DD+3NQ5FVQoF325FmfjZfW0VfdxQorp8lpSW8+NReQbcv5cMqmeGHy5DY8D7l2BvxFL44Q7WdWs1fc8SwFoCWn4xUz9/8NdmhYqtBZzggHbaw/iFVlbY2pF9ivlY4OBFmzPycL9BavpQV24SVseCgtkQqcX100rjbwb2+Ojnz2o7V9AsQvgsmrrC2M44AnAnRnBPCAxoSmoNVAq8wSQP+C3AXqVxBGYylXZxvfL5ZzevqYWBvJ2ep7fy1dCw3dfUV/vOK4vvoMs0F9lPN0oimwFXfLYqqAG70wmhJwfh81p7FtIS31kkbUfi+/R+itssjaicXPKb21oR8lLTMi2AaKaD4M3sgA71A66DxqRpH4c83pC5KAC33In6aRLv6aDt1oqlliRC7Bdu5qx+qZbcXsAFtzTwm/dTikbeLVQVeg+tGRAl1iFfe+vQ23V7KedcinxUMuZlDw+50exeFuhcGReNaFFYpYCX2k0ND67MwzBgmzCCtmWX9sQM3ZYISS4RwK+8f6hPnrWPameI9LrkDbtyNLmKj5pNF5SZpEvhdKadX48LsD9c+WK0p/+8A3ZsCQFv98lU4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?84FAvx0vXtifrpJu3LnhS2KC7Y1o/YeKoNN6EMgIeojAt30F8r2hC0sBcogA?=
 =?us-ascii?Q?2bQvCiN1eFSf2w3P2RF1D0vonNCZn1knSEX7Nzq3pvy4CK5NEDeNfAG2iQgB?=
 =?us-ascii?Q?yZaQaHj2cqYcLSOGHrJBoYsBqOW+cC3MX/ArlnjfHEUA/gLFEHKCkrctSgjC?=
 =?us-ascii?Q?G8wIanZC3rEEoXIG8yL3NriDChf2IO2AIts1nG34vJ89EJBccx8Vnn6A4wzo?=
 =?us-ascii?Q?P/FjADTH2C/X42DV47IAEH41ImZ8tokGCOWW0fBQO/SVf7CuZuB8WeiiRrmm?=
 =?us-ascii?Q?pDMCukwuzIoDtqL/fZeMxeVLB5pvUksOl4nJ5O+a2ffPZ7adljuLv+jxSHWl?=
 =?us-ascii?Q?wzSN/uJ1pV4sPiq0fqSxNM0Lk58ey4yrMEekkGnXuATakGvMSGfV6YFiM8w0?=
 =?us-ascii?Q?Q/30w/pfIO7Q8lvOzZ+tJVmAoWbGhp6EehZHdT8RU6mNxTMCgNXpRGFHLReh?=
 =?us-ascii?Q?oFhYMwHkA2cLKMkEQhI2aH57IcsqkR/9IuyJKBTNUWjLOLNvXConQyyjSGX8?=
 =?us-ascii?Q?ELkAT9U1rvL5l/mGtE64trMWkCT4c/jdK+Zl4e5H0hUOCgflpeZRBEVVKKlb?=
 =?us-ascii?Q?6sj6rCJ0VavpBhJO8yvB2N27IaqbfTeFPPREDDVtqp6iBs4xQr8qcUxAaL9A?=
 =?us-ascii?Q?fy1cr9srHk72UU3CkRCpyvJz3tnz/+XueiLz9BoDx2GxpMKf8TusCcBBvfGb?=
 =?us-ascii?Q?cXqpV2EbGEC0CL8jSF++RE6zY2Whd2iiXyd2EJo040kcEF3srI6iEpTRjqJZ?=
 =?us-ascii?Q?pAHfk5TPmROFtN/rAkgbpzLiTQGk4/t/l90lxj5xsJbrAEr0hgncMz2N1N5o?=
 =?us-ascii?Q?va3pf/6nw8Ni4oPKdY0bBAQ9na+drD4cvaO0hnk46viV+9egwrO2bY03k2jT?=
 =?us-ascii?Q?GPamR7kY6rXOizLV+kluWCZkW3V92QykwU9tPiOxw7yml6jIFrpw/95Rnv21?=
 =?us-ascii?Q?Jqh2oQjl8J8cqpjhBN2RQ8oGokrrUQdFWvidqmXSTPLHicsX0i/ljSnis0nH?=
 =?us-ascii?Q?/KugnhXMA/kKe2dUsIR56vrgCR2gydzURTO9R0ZBWc4wtIsw1O6RXdpNu5G4?=
 =?us-ascii?Q?bBCsLohO1g21Hl5PDvgtt938bFzhCmDkcagKkSEE56r5kM6mgSxCalaztOKY?=
 =?us-ascii?Q?zqo5eXrRXII9c2ah6+uhNwWlC6OD1PzjGRNTYp+0iLVG5EZD/rluq5ukw3c+?=
 =?us-ascii?Q?2lzgijep523bdy7AlYwm7Y/r4kSwM/Vdl/4xyNNu/YCWqPpGHwtXqKjSAFiV?=
 =?us-ascii?Q?DcLqf2X0zM4EPhFPmxLTk15B3AbfRX2/4VUuZgKZ4I4U4T3MQpbghIscwUep?=
 =?us-ascii?Q?1LPzG/GtQDShOZR6SRr9JY2QXtcWGfpdv2DFwDXm7f78T8sDVE2O9g3LRzqS?=
 =?us-ascii?Q?7i60vzojxXySpX/K6R5EAqWl/CYVm3VDX6VGNAbrI4CDxWV5rEb7jNHDhJj1?=
 =?us-ascii?Q?Sa67R/jeC4lpaViyhTP/IJsh9qmFEBjiEp1L/gIfQXtzTD2VO631sTA8nrD0?=
 =?us-ascii?Q?eXhIpXvHRh58Q4AVc85hp1JoVwzCBhCN940DDRsqf7gDXZ4wRDofbW53DZX7?=
 =?us-ascii?Q?vr7pChf/Xtjy55QnFLDrEx0Qmg6y4N2ENDl55eMxenXHeEDvGeno+MiiZ8F8?=
 =?us-ascii?Q?kcitl4F3M7npSDfgFu6UsAi9T+iVGSYHIsl59jcYVaGPwzy/flyEQp7NAXKx?=
 =?us-ascii?Q?VA9om62e4zjhMm1im2Uugkmlb3/RhU53HGgrAqvFzKi/IIlTk9+3WSDwJqW2?=
 =?us-ascii?Q?i9/jdvG7DWiGCxNrsVWt0T6eiYm/Lc0=3D?=
X-Exchange-RoutingPolicyChecked:
	cCzIMMzpU+OPkiZM9jIcKCSKjnroAQxAg8W9GeEdbxayTJxkWimTqMV0VXaQmH6oECU0iNhsUprggL43Ys6i2D8U9lzV0LmubnU05rROIY3Ys6E0rdPyMQEqxU5Y/NZreucZvChOVOpfP5+6o2KVS+L/H5DM1FU+XPjC/qLdMabOSrfwipxtnp2CmfagpX4R7dbF0CTlZJ8SWfsP2gwuVOm3Nysq92/y6BoVjdvgHKWApt6ei4Ymsa1dtvAO8vvP7xXedTzVm3pPERRp7iZ4t27VkhCqMCyRoGbdfnQyWaUlsaSEgghmHqEknAAwNla9X06pb+AthYEnjrdhP1yVnQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a82b6669-e07c-4857-409b-08df17dc90dd
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:40.1690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V8fq9PL+WeJmB0ebrZcGr5fBu/CegEOF8DBF0i+eTePoJjyJvx11/S99AqJkawqUUEzCkg42G4VySSPElNgZMZl8e7RyOGXk6+sVphJJboY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6868
X-Proofpoint-GUID: ikiMjkgKyd94rx37XcLIK0S4rdCnmBWq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX5jqk7NQh63vf
 67wXq5f8sCpsoLievMddXdNH7bOG1aB2uXjsChn4VNmlfqfyg44SMqLu/O46FngOaz2oQa+V5Q7
 CUcYKPlXQBGZwOAgULaLODY07v5BRXPdL8fo0gwFjPXt1+mvTqKqgyA0CKiLa4FUBOHHBuFm6d+
 VdoWWXeKduRnvK/+aCn5CDaMrqStORz/pAqabZLmgLAKyl1JBs+ZQksUCxqV3HXbT5yG+5zyz4Y
 oMgND9XRtSs13jy77hViwE4jzGdh0617Lc1Yw32gPaxIYqEgNYpdDhbdu3T8MFjwn5Oa3D1hBGN
 5GK83S06sguvwxD7OgrqnaPkxnFgFB9S+AYkjSUcKPL5JN8bBGJ0BGZKKhJZzPxMJbGbT3UswgW
 yxwXZBoNobc3djn35UsbtRqVezMC4OlmCAJQrFhAk1eI947AZozamdU0wsrrBfD/ueofKjsHTzq
 zUxVwZ0Z7+vxeClZp0A==
X-Proofpoint-ORIG-GUID: ikiMjkgKyd94rx37XcLIK0S4rdCnmBWq
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX9JEnuqJzJfDe
 q1tlCJTieszKkD4R9DxkZC2iSfTeDhRorz2hgCPEiztYvBXggrnbFvGa7CQC6mLcT8d2RG4u+mf
 M/o8Zwkxki7zSGch367LBcju/cNP7oE=
X-Authority-Analysis: v=2.4 cv=J8g/fwnS c=1 sm=1 tr=0 ts=6ab12427 cx=c_pps
 a=fn/DPt3lPG6OhtMeQbTPHg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=vS_ObyiCXZHXlSlc3J4A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce kvm_arm_get_host_isar() to provide the host ISAR probed through
a scratch vCPU. It will be needed by later commits.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/kvm-stub.c | 5 +++++
 target/arm/kvm.c      | 8 ++++++++
 target/arm/kvm_arm.h  | 4 ++++
 3 files changed, 17 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index c9cd47bf47..059a7afdcb 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -151,3 +151,8 @@ void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
 {
     g_assert_not_reached();
 }
+
+const ARMISARegisters *kvm_arm_get_host_isar(void)
+{
+    return NULL;
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 0b5fb49dff..bb74f8c274 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -712,6 +712,14 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
     env->features = arm_host_cpu_features.features;
 }
 
+const ARMISARegisters *kvm_arm_get_host_isar(void)
+{
+    if (!arm_host_cpu_features.dtb_compatible) {
+        kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
+    }
+    return &arm_host_cpu_features.isar;
+}
+
 static bool kvm_no_adjvtime_get(Object *obj, Error **errp)
 {
     return !ARM_CPU(obj)->kvm_adjvtime;
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 9481e56412..ab01ce8665 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -15,6 +15,8 @@
 #include "system/kvm.h"
 #include "target/arm/cpu-qom.h"
 
+typedef struct ARMISARegisters ARMISARegisters;
+
 #define KVM_ARM_VGIC_V2   (1 << 0)
 #define KVM_ARM_VGIC_V3   (1 << 1)
 
@@ -290,6 +292,8 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
 
 void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level);
 
+const ARMISARegisters *kvm_arm_get_host_isar(void);
+
 void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3);
 
 /*
-- 
2.52.0

