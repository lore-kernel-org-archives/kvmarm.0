Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED94D2045AD
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237999; cv=fail; b=j5IbfPnKpRHwcE2E5rfNS+ycCiRynJ4Uus901KQPk+s8XaS67X8wsXaIM7wsuWyws3T6j20HV14AVZ5Nl903NG15CsQk2tqkuOcloZ6/RtOkJTHitY1pJIbvORyDa8jOgLzlas9HqrEvf/PpIN0m91gPhdMfhxIhtM1p7wBj6VM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237999; c=relaxed/simple;
	bh=6XvMppt4ImUWFOfAOZmzJ3K36/1jT3gNGn1VrexaKhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RQ11q1g1EC16g7lG8ZfFTVnWHglkpma9tzzC9ewAZ2UvHJ0NmLGHQORMCxIpk2Vuoq62CiDyOY9LvB1BcPBEVHFC6Jqg095Qhegw1PSNW5qVimAozLOh09UW3IGL9S0i+26H2XldWhGkB2VxORTBaLW+9xCofA6WQwiTEpp7QYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=fKH4a+nX; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=eZQrkuEd; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="fKH4a+nX";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="eZQrkuEd"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrUwE1796534;
	Thu, 16 Jul 2026 14:39:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=7ftVkMcALZp5mhdHso5xT2g8zXa7kA61pMihzXyk3
	As=; b=fKH4a+nX+ybj+VQzutG6Hs3+3U9iVH/EfoQCUktq4gUcHqAD6se99tCvD
	6T2YjGmZbHYIwNtJCbsyfnv7TBnnAjH6CgYWT/B2+rkqnypaDMuD2p9ilNCqIcyT
	GmtTNIEc5PXgQZS3/cmVud8CfqfUOfkVI2579z+TECxapjUN6LqERn/exMw5bzNF
	mHEf3BnxqTnmp6t4V8UdXNZpdS+vFxTbmOHiLH0xb7PO1cr2UjyMrHe7oKQ5QkAL
	VaBl/YJxTXTOH5TzlFQruJlqoCqxJC0Avi3iOJvM6zPnXZboTFQduHXcgsfktq0p
	oUPkV0B3xUwoWPkLkYVkBRHhv9WNg==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11022136.outbound.protection.outlook.com [52.101.53.136])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fejrfb79p-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L7gf8YoHBInB75jv101Tgble0J6vO4CBosO9ifNawVFCwQYnsT6MnUkAsadHghlBlba1TEMN9Jmvr6WvMrqiBdkVNs4emrekJyRz25epnWCDfo1siNBDQ+n4qAXjudEPrcu/7skHOfsAbu+8rIWqU+/kcru570Ud00mUahJJL0LPUe/2wmIA+NgLxh0jnX4RWHJvVPB5ZjUkwa9hKVB2BCYqzipTsomajL7u1UM46OEMDQdkih9GPtil4gf3yLg2ZAR0pmByThfApGZVJizH/7Vpsw8yEqvGC2ZUuIiU3fywAZPVgFYc9iUHn4ohqvKG2pp+Pb+LAMS1iiBqVrHcHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ftVkMcALZp5mhdHso5xT2g8zXa7kA61pMihzXyk3As=;
 b=n87LEzzOI4gxY24wMKf4mF2rO01VHTvdpoeipQ4TTi3MEBroUKGcH9T/iTtYM1rfUMlttNIYMxETgVWHcj/zTIzsLsA/MCE9in2qjzY+qw95SH+NQBO32f3XQschsU7bLVU54MXY35f2a/oQoLx2KwhVoyd7fDz9aPuwpXoRP9Wjnk4HrjQ+IntJNakRNGUog1iHPrmg0f4dC44KPUT0G+W9Khw+PYtx74Prt5VIHBVjd5H+H1K4qI5K4zxQRKmtPyTL9DMXOj005n1shvzkshSC4hN++F0XhZ5YyJ1BYlZkjtHokJktYmMDw7zAiBdBD4um4ho/kzIFNZLr6Qhelg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ftVkMcALZp5mhdHso5xT2g8zXa7kA61pMihzXyk3As=;
 b=eZQrkuEdMb529V3mKfUGq/IWsV9E8cGvBAcTjF1wLyLAOHiejjm7i9c66LsWBTeRZOsyp2XuH5TWmYfQ3EgFSdLYeGOEO2d2S5bZE2+OaYm7jhM+FlzkeXw2YMTDz2LuPCqCNgWnBirfXTCUNmrEZooAuZyZXKCqiMJOl939mh3vrTjmad/PfC9j/LYa9Y0luAoL6vNleLnJGtZ2F/NgYqXOnrobvVpnKkMFVSKwXZEH0HZSO8OnswhrQvUYXieL2ubS00Jg//nhisP4s+tu9L/sr64Z7yROKsMKQX6PB7ttaTnrog0sqtiwMEvevdmBI+w0hIrbedO53yv5OJ9nUA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BN0PR02MB8255.namprd02.prod.outlook.com (2603:10b6:408:156::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:41 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:41 +0000
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
Subject: [RFC PATCH v3 18/19] target/arm/qmp: hook blockers in query-cpu-definitions
Date: Thu, 16 Jul 2026 21:38:57 +0000
Message-ID: <20260716213858.609699-19-khushit.shah@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|BN0PR02MB8255:EE_
X-MS-Office365-Filtering-Correlation-Id: d7513a30-306e-4299-01da-08dee382be57
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	aGK7YStxUJm5ZzvpyECRnR13UPFlE2AQNBXnKSxpaP/5w2gj7Gl217Tryy/X31WEwvZDizggLFFV50akRlDbGpGlZ+KMRluyxTsgG2wSgsny2nYVy9ihERr0Ef4U9JHflcKg0pu9BCfAyfsvUL4uc8QdYOPBR+xSpM0YwAoxOTrcx/ls89+oRj6VX5YhUrlwI9BXjmUYHGhHNPo5VARlp5wTe0e1oWefT3bfsPwELb+VHRqz4/o4VTpQUleGG0eFp1YdjMKQ4lvz5QFilql3uatAkL+ChR4Smb4GTQlu5IKO+OGxAAKoiEZuMxIfufZRj1oH0ha3d/iz/8xZ58D0G5brR4POarLumXmjcKa/NnU1ekhYM2fJ3Qq3Ch20RVRXGCkFHXw2NENmTewYeRvfiQNMVycOa0HYcT5TFbeJDLYCTMIXkPay01FwpIiL8rSwJcuY+xQ9o7Cv0uc23rmzkEcnPtZdDeyTVsrurpFVcgMgz1CNXIRzQR31uCOWbDH8Y/99uj3GeVdf/sgVe1O51NSAP4CMqlwnaSnOrmblnqX+w6E8RWHj/pcwVAfZQnp18DQf/bs43/SIXNP0nWAIQPG/lK2hBk9FuPeMrIkQNh1AGHG0wwMzcs3RDa6hITJNcjKllg+QYD/EWPxx2U87BsQeXLVpSuvXsSfCJXWiUNg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bRROr0M+WFOEjeOKPObCMea3NrPUIo0CVbA1GM77bRgdATOygc1n4oEuJ+V7?=
 =?us-ascii?Q?keWEeWlO8MAT14cTRPcs4LtpKnijrqmpNaZnLO0Gxzps6JlWT6DvwaEfcrQ1?=
 =?us-ascii?Q?ERUaKwfMFrkGkzLAew/P1/QxxCBhl6Dmbc+IPU8Z8mdDvKWF8yQGs5FEZN7X?=
 =?us-ascii?Q?2hK/v+orn2R6o6BwIjWJbVmz1SFmo34DLaP2T93vCn9PVOwijMM1Vc9QapfT?=
 =?us-ascii?Q?jdC207KvO8SAMbLldIqlWPyJ9ilMQhbRBHofatRnw1WMf+Kx/I1yb3m1lqOH?=
 =?us-ascii?Q?welikw7j2X3aO4/Wiz+vgUZ9CurIr7cS04930QkTfQgjNolb+eC7HweKyUET?=
 =?us-ascii?Q?QqVoJ05UfObCENnOACB4szFwKKzueN/Z8ePe042Nsm2zjfAxpmw809GGKJBB?=
 =?us-ascii?Q?CKsqcSzVYt6beNbb8TWP1Ap+7dC527Pz+wm5EQ1NbdCEhoxdzWyxD7GtmP57?=
 =?us-ascii?Q?QcsalW4fmGDaOEgRsuqLTOfxDYRWLhmPb0Wi0uX1Eu6bALhV0fEO2XcEkpV+?=
 =?us-ascii?Q?ixDqYWp56F0XNjiXeMaAmvohY+2RQlmU5CmHeTwH3SicEGoGTUfSJpnXbBSf?=
 =?us-ascii?Q?oXdOw17dsqbyQTvvFsX4OudDBDW1pEOveLFXuNjSf6oRqw9xmvAk+TAmwhrH?=
 =?us-ascii?Q?+UHUFTpnUdlUywqqmEIKyonOyzLCe7di41USbciHCnZ87TKv/RyR9cg9SF0P?=
 =?us-ascii?Q?hHCqToAsOqLtCxlv24e2f6yia01SBP2w3EWFW3mZ6xdt6Z+kO57vJC2da8FH?=
 =?us-ascii?Q?nlSRtX43i8HIU1xNvniQS2VlLPhNM0zyabgUVFWgrldXUCOgEiH3HOUMUm6c?=
 =?us-ascii?Q?GxUfVg7bUokJ92NplFADaIiJ1fDCwEOVG33Je4IFTCYAWpTBhst2lBwTdS4A?=
 =?us-ascii?Q?utdQJCHTF4GH2Fbj6crz3yvxCjaiR1k5WMp3LIwQVb14CW7v9AQ/p6wSWOmG?=
 =?us-ascii?Q?M9VEqmBaMDsrRcxC32/ux0wOJR5k2mPsBcyKKnFAYaeeC2GHw80P6+nHXawk?=
 =?us-ascii?Q?V0Io/A7CkC7RtZio7myGvOhqOh5mQx8T7RYuPspCkBKf5UCrZnUhrsKzthEj?=
 =?us-ascii?Q?woq4IodP5zRmjoz8PaR78I7/cGFUPVydEwGNDnx5dvGWPOoeS4tDn6WmEKfq?=
 =?us-ascii?Q?Os7p4r6Zrk33YLjWHE+duM6+t4dWwVGhIgvpCOdGs9nse/U9OmQ8zpVuh8o4?=
 =?us-ascii?Q?oMm48jAA71itz7OiDzAFwc8ig4eO4ZOglKgWbKeB/7bHz3gxwEftftHZOK2+?=
 =?us-ascii?Q?Swn3Ef+JDFFl8NfCK8/EDUS69X+PO7R2sLYem7/4Xp1r2lFTclrXM3R0nXAc?=
 =?us-ascii?Q?m9W560GHgd12HXk3vR87W0uwo5f0vaT6DWiszjkzqmQGhTYqnlDDOYllqjyi?=
 =?us-ascii?Q?B6RDYT0yMcFgn+BuAHI/JFmGI3XuswJokPQ2UFzR1v1N7qVamXE7zK9yepgE?=
 =?us-ascii?Q?aJoUpKFQU4KrZaZ+9dQ/kZf+C3LJUYC2CvG8gtFf5qYaWAfUq/mhyvo3C5+I?=
 =?us-ascii?Q?3mr+yqcXNniuIFGG4EZNdMLyI8TbmZTnnjLKnM4VZXEGYQA5FRyRtnvy2i8w?=
 =?us-ascii?Q?Q5oCo580R6LXPjhvBhbXQ1OzRuLSUYXAFCgtfsi199AVsLPCQSRARiAOqs01?=
 =?us-ascii?Q?q9s6ZjT8GjXJwdtA/Knuzyyh8XJAs2hyIaESa39CgEpNv94NxPs0A1H5t2t4?=
 =?us-ascii?Q?jSoG0udCupJ39ZpzA+5TC1AyzvijUzml7cy2OLORBaTPPn7D3jZ54xmTIsqd?=
 =?us-ascii?Q?qAHOFPOxKopm8h4mC2qZCvXyXEMkk6o=3D?=
X-Exchange-RoutingPolicyChecked:
	Az3sYpFKOvUPOLTzvgF5vgfhTzTPZ1YkFHGsQ1DxES6FkU6j1dJ2+iH1DDK3X9SFDahogcWP8saXIlmvQAMOD5s/UXkgVG/N8CsySw+is86cBwG+cSkh0SE0kXVxwKldwYWu6+gnZIapbc5AXlmRmKmSpiI8axQ/ZaRYxooIY5o0kgYh28XfT2kQL96l5xu2L+s3HYF8PWJE+HFM2XuRnqFQf9m/VbN6h+WHdIDms562n0vkIqbdqHTDJuw9CFk4bzhPKf7yM3/Ki4kGaTqDQveO7h/e2lUBNMJOXJlM+GoY1fYzPBi2vZ9ftT/rvRaGOV6Xu+w7zbATmI8OxEPCjg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7513a30-306e-4299-01da-08dee382be57
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:41.3049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nIIcQ997SFoz7NO3AXGquimFihB+5tmFE6XrYkXE/kAtXojlMBNuJFNcnP5ewA/oknLrILyZpw6/p09yuLr7Q/h5VHE42EO21frn+ngalFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8255
X-Proofpoint-GUID: y9ANUC8jdPTItldooCub8fDfFJxhKScx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX5e1cSfJmHGUr
 +lbfAG5Avxy/wcd0VRDPKUV4SOTADWVe8XfGGMkVzrWFBENJYn7z+ZHCc+sT/KvNLKwI3af+pRn
 hwwYy+yJaPzGc2fEhkpeT2navrIqHSVDj1CLSqwQmwgpvvxFUkytCQyn255/OSgjde7lP41qhEe
 pvMrTZpB1s+IkpXSqJq8TnMp8ecKswtM4IO5BqQ5Ep1g+/VOyIStmpOxX7lE3N6hghjXn3S4AMw
 6EB+kvll4c84ak9V9uovCGnHedhZ6pTuuR+ylGnzlK2IZV3MST2998y/a667qdYhUNv/rsrQInC
 nh0gR5wPDjMIdFn002PMwSInOONPTP8xZPWf7yAITzWWbCzHWwvZEPP4YDK0njqilQK/yiXPW9I
 BHP6v9kOgSgnh5Xoy5w0LnxhBuY5+0crZ9dkRMSWil7n8Iugp/eA9d6Mtjzu1YwgB+WlTMJhhaz
 f15B3DBXX9HK3ETUW2g==
X-Authority-Analysis: v=2.4 cv=d4HFDxjE c=1 sm=1 tr=0 ts=6a594f9f cx=c_pps
 a=wT4O3adra3cfqKKwvhZ7sQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22
 a=64Cc0HZtAAAA:8 a=oSinNBb-mIJOy2iRG7MA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX98KowGRw3vCi
 i212QmBKU7ZaLuOzkYWWSOsr26GWFPXj+EcDkfe/fLQg4zeGhFpARjKFWJ60+F1YR1ncf/4NGhB
 k8KmzJxGRT3LF2OlSgoHT5D4NCKTEeE=
X-Proofpoint-ORIG-GUID: y9ANUC8jdPTItldooCub8fDfFJxhKScx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Now, report blocker for named cpu models in query-cpu-definitions.
Heavy handling is done by validating the realized ID registers values
against the host values. sveNNNN needs special handling as those
are not stored in any ID registers.

Introduces arm_cpu_class_check_missing_features() and
aarch64_idregs_get_blockers() to achieve this. This way we need not
instantiate each model to check if it can be realized and we also get
granular information on the ID reg fields blocking the realization.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-models-stub.c |  5 ++++
 target/arm/arm-cpu-models.c      | 35 ++++++++++++++++++++++
 target/arm/arm-cpu-models.h      |  2 ++
 target/arm/arm-qmp-cmds.c        | 12 ++++++++
 target/arm/cpu64.c               | 51 ++++++++++++++++++++++++++++++++
 target/arm/internals.h           |  3 ++
 target/arm/kvm-stub.c            | 10 +++++++
 target/arm/kvm.c                 |  4 +--
 target/arm/kvm_arm.h             | 17 +++++++++++
 9 files changed, 137 insertions(+), 2 deletions(-)

diff --git a/target/arm/arm-cpu-models-stub.c b/target/arm/arm-cpu-models-stub.c
index 0481f0f946..dadd3b7647 100644
--- a/target/arm/arm-cpu-models-stub.c
+++ b/target/arm/arm-cpu-models-stub.c
@@ -11,3 +11,8 @@ const ArmNamedCpuModel *arm_find_model(const char *name)
 {
     return NULL;
 }
+
+void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
+{
+    return;
+}
diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index 40e8578591..44e7d3cfa2 100644
--- a/target/arm/arm-cpu-models.c
+++ b/target/arm/arm-cpu-models.c
@@ -475,6 +475,41 @@ static void arm_named_cpu_initfn(Object *obj)
     arm_realize_model_chain(obj, model, &error_abort);
 }
 
+void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
+{
+    Error *err = NULL;
+    Object *obj = object_new_with_class(OBJECT_CLASS(acc));
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    if (!kvm_enabled() || !arm_find_model(acc->info->name)) {
+        goto out;
+    }
+
+    if (cpu_isar_feature(aa64_sve, cpu)) {
+        arm_cpu_sve_finalize(cpu, &err);
+        if (err) {
+            error_free(err);
+            err = NULL;
+            uint32_t host_vq_map = cpu->sve_vq.supported;
+            uint32_t model_vq_map = cpu->sve_vq.map;
+
+            if ((model_vq_map & host_vq_map) != model_vq_map) {
+                for (int vq = 1; vq <= ARM_MAX_VQ; vq++) {
+                    uint32_t vq_bit = (1 << (vq - 1));
+                    if ((model_vq_map & vq_bit) && !(host_vq_map & vq_bit)) {
+                        QAPI_LIST_PREPEND(*blockers,
+                            g_strdup_printf("sve%d", vq * 128));
+                    }
+                }
+            }
+        }
+    }
+
+    aarch64_idregs_get_blockers(cpu, kvm_arm_get_host_isar(), blockers);
+out:
+    object_unref(obj);
+}
+
 void arm_register_named_cpu_models(void)
 {
     size_t i;
diff --git a/target/arm/arm-cpu-models.h b/target/arm/arm-cpu-models.h
index ac4e510499..6c8fba2aeb 100644
--- a/target/arm/arm-cpu-models.h
+++ b/target/arm/arm-cpu-models.h
@@ -7,6 +7,7 @@
 
 #include "qapi/error.h"
 #include "qom/object.h"
+#include "cpu.h"
 
 typedef enum ArmModelPropType {
     ARM_MODEL_PROP_BOOL,
@@ -31,5 +32,6 @@ typedef struct ArmNamedCpuModel {
 void arm_register_named_cpu_models(void);
 
 const ArmNamedCpuModel *arm_find_model(const char *name);
+void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers);
 
 #endif /* ARM_CPU_MODELS_H */
diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 457cc3edf3..6f11681c87 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -341,6 +341,18 @@ static void arm_cpu_add_definition(gpointer data, gpointer user_data)
     info->name = cpu_model_from_type(typename);
     info->q_typename = g_strdup(typename);
 
+    /* calculate blockers */
+    if (kvm_enabled()
+            && !g_str_equal(info->name, "host")
+            && !g_str_equal(info->name, "max")
+            && arm_find_model(info->name) != NULL) {
+        arm_cpu_class_check_missing_features(ARM_CPU_CLASS(oc),
+                                    &info->unavailable_features);
+        if (info->unavailable_features) {
+            info->has_unavailable_features = true;
+        }
+    }
+
     QAPI_LIST_PREPEND(*cpu_list, info);
 }
 
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 44dd9acf80..f41bcf2e81 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -20,6 +20,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "qapi/util.h"
 #include "cpu.h"
 #include "cpregs.h"
 #include "qemu/module.h"
@@ -779,6 +780,56 @@ void aarch64_add_idregs_properties(Object *obj)
         aarch64_add_idreg_properties(obj, reg);
     }
 }
+
+void aarch64_idregs_get_blockers(ARMCPU *cpu,
+                             const ARMISARegisters *host_isar,
+                             strList **blockers)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        ARM64SysReg *reg = &arm64_id_regs[i];
+
+        if (!reg->name) {
+            continue;
+        }
+
+        for (uint32_t j = 0; j < reg->fields_count; j++) {
+            const ARM64SysRegField *field = &reg->fields[j];
+            ArmFieldValueSet *vs = NULL;
+            bool supported = false;
+            uint64_t model_val;
+
+            /* Not a blocker if the field is never written back to KVM. */
+            if (arm_field_skip_writeback_always(field) ||
+                (!arm_field_is_writable(field) &&
+                 arm_field_skip_writeback_if_not_writable(field))) {
+                continue;
+            }
+
+            model_val = extract64(cpu->isar.idregs[field->index],
+                                  field->shift, field->length);
+
+            /*
+             * If the field is written back, make sure a "supported" value
+             * is requested.
+             */
+            arm_field_get_supported_values(field, host_isar, &vs);
+            for (size_t k = 0; k < vs->n_ranges; k++) {
+                if (model_val >= vs->ranges[k].min &&
+                    model_val <= vs->ranges[k].max) {
+                    supported = true;
+                    break;
+                }
+            }
+            g_free(vs->ranges);
+            g_free(vs);
+
+            if (!supported) {
+                QAPI_LIST_PREPEND(*blockers,
+                    g_strdup_printf("SYSREG_%s_%s", reg->name, field->name));
+            }
+        }
+    }
+}
 #endif
 
 void aarch64_add_pauth_properties(Object *obj)
diff --git a/target/arm/internals.h b/target/arm/internals.h
index 7502b6db8a..d05e35ba83 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -1756,6 +1756,9 @@ void aarch64_add_sve_properties(Object *obj);
 void aarch64_add_sme_properties(Object *obj);
 #ifndef CONFIG_USER_ONLY
 void aarch64_add_idregs_properties(Object *obj);
+void aarch64_idregs_get_blockers(ARMCPU *cpu,
+                                 const ARMISARegisters *host_isar,
+                                 strList **blockers);
 #endif
 
 /* Return true if the gdbstub is presenting an AArch64 CPU */
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index d19c53927d..eb8fdda236 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -131,3 +131,13 @@ void arm_field_get_supported_values(const ARM64SysRegField *field,
 {
     g_assert_not_reached();
 }
+
+bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
+{
+    g_assert_not_reached();
+}
+
+bool arm_field_skip_writeback_if_not_writable(const ARM64SysRegField *field)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ce77758c87..b909a11dfd 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1394,7 +1394,7 @@ done:
     (*value_set)->ranges = (ArmFieldRange *)g_array_free(ranges, false);
 }
 
-static bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
+bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
 {
     /*
      * GIC is controlled by the gic-version property and fabricated by KVM
@@ -1412,7 +1412,7 @@ static bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
         || field->index == CLIDR_EL1_IDX;
 }
 
-static bool arm_field_skip_writeback_if_not_writable(const ARM64SysRegField *field)
+bool arm_field_skip_writeback_if_not_writable(const ARM64SysRegField *field)
 {
     /*
      * KVM populates ID_DFR0_EL1.PerfMon even for AArch64-only guests but
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 4a04d72e39..6409bec735 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -172,6 +172,23 @@ void arm_field_get_supported_values(const ARM64SysRegField *field,
                                     const ARMISARegisters *host_isar,
                                     ArmFieldValueSet **value_set);
 
+/**
+ * arm_field_skip_writeback_always:
+ * @field: the ID-register field to test
+ *
+ * Returns: true if @field must never be written back to KVM (and so may
+ * legitimately differ from the host value).
+ */
+bool arm_field_skip_writeback_always(const ARM64SysRegField *field);
+
+/**
+ * arm_field_skip_writeback_if_not_writable:
+ * @field: the ID-register field to test
+ *
+ * Returns: true if @field should be skipped when it is not writable.
+ */
+bool arm_field_skip_writeback_if_not_writable(const ARM64SysRegField *field);
+
 /**
  * kvm_arm_steal_time_finalize:
  * @cpu: ARMCPU for which to finalize kvm-steal-time
-- 
2.52.0

