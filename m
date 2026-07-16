Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17EB3C871E
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237996; cv=fail; b=MrcsX8SWNegVFPR1UK//Os7yXB+Av5mCNUF2lo5ZI7vxrXVIkcDZ8IJwuedgYqB7uyU7ylxNUcgKMmbhpXgrUA00Ik7AzAyrxqSyjLOXrGbB+5shuERfWCBUV6ppoNZ12YO7yplt+O3lOSxz+DlMMUOXk/gTk6x0aZ5D+JsrsqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237996; c=relaxed/simple;
	bh=vy9cMRc0BqhCUv3cDGc2wBl56dYX2hODZ+kgXF01h5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I6cGRRn9yR9YqZ0hKQWYjZiTHW96TAt1WklWMz30cJ2lwTLrGQjl570SCVAJQKdJ+QVxnJ7E05jenn86WAoDlz0b9MvLG3JFUC0HHERmLc9EBpGYNvWESYP4Sc78uuVVkvIPQsnKV7ijbuyxb3XUqtD1JiY+DgjdXMhsojftC0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=DE88+PpB; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=GW4Zlo/Y; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="DE88+PpB";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="GW4Zlo/Y"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZht1763910;
	Thu, 16 Jul 2026 14:39:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Fi30cKsKyJSysTxErUME0Zo4fHrFHKMrEVyh/JRVH
	FI=; b=DE88+PpBFn0HKDQDWpH4oj1NJEE7ADQ2hjKeyDVUFuCrVhi7sFzSBzFlU
	NjpAXy76t3O3uc1ppVLn+YNMea/HDOuDEyg5BZ8EWltfN0jO9kp8hJKXaUpWJnNL
	wB6Lz/SdPmK1SDPgXbzzFZYo2Kb4fXaIt81AR+5Ys/NjCyq0G1eV6I2hKw+ZfsGS
	CEVh5YHGwgTr7OdJkcnEIRE80kXXkFMKHFhqMxz+WLBr2l2M8cREyT966qZLcxyF
	JlPJbp/JVqO238pj4Y7sC3zWEyhojw4R4PSQyRivJqd6DzrywwC+t5RMhNSa0kVb
	phhGiyIiUeykTCpsfB6IdMH75Kezw==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-11
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bQZVTOWgEm4ftTT7RaEakQ0OsslL8JVCubKsdkC4QFnKyWrVRuXy/wP/P7EF38Mlecxw6MfEvZcV451em1iZpfsrUiwnHRWMGdFvBaNXru/31RSGqlFiwy0ky86jDAY1KFDP418rHqiIedfbxSEbxgGc1RBGxmonv5mZ7hs/Qg5//56kcLZsgU2uchLePGnIZ1YnC4K2WxrC7iX/qiTD7g4F0kLcEB0zb1xmLCbsb0OFOvvYtZTx+Ctsne2YF03srh7Xp3jzEPBtiPdgC3uq3m+6Ct8WHxhKBPH6HWj4Yq6uggXT13xkOA0Rd6dpYU0j8ZMwunLnuk68IemGHLG0yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fi30cKsKyJSysTxErUME0Zo4fHrFHKMrEVyh/JRVHFI=;
 b=FY/BP0Y+BcgGSNR47981e/HYwAWCzLk3Brq/jn/9cKXDyv/voKZG8g3HKVtVrnNWXmiKsBcf1U2ub5wAUHf7GLK/kv9ZUAabQVUIa5hS27NJIYDq7Y9lM7OWRPBcgCt7daSwBS2D58PdZrNQ5bIMNEJDRVKIj5s6H9VAh0dtwzL4EpR/OHLd15WDLN6hL15vedT7TkP82mLuc1IVgVNEPArH4/6NqYP9t3slDsGrWw3qQOq57/jfxxKq1gJ3NP9DHMhbNv4voB3H3eM7j5O5FhPDTYJgxINAFBaN6skoAufS5StdTzxQu5GQ5Q+NNgtO0eLNBH4SYBSgFVEjKvPh0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fi30cKsKyJSysTxErUME0Zo4fHrFHKMrEVyh/JRVHFI=;
 b=GW4Zlo/Yz+r9CBbgOHMxay/jToeNsnrRyUFGGFgC/u1MRfhBbYOJ2gSsE2lqY6TujTXt8uERliILV4bI2HiQmL+Vu9+4wATvtAn/3GWwJ2R2RZjmQjJYznImM8QgNUHTX3baeeC0RnbpswTxd0G1xT0qQ1CX2OAL2zM4vBqVWEloVk1WxK+pBZo39+jRaChWkPNZzc+8TevbH0OOcv3Uj/dwih36+bTNwAY5mmJHpcfRrKrXcWNLgrOiN9+hbk+Ry7JjdIGISxIGrnHMcJo4xDUqdH6mYzsSWhykAjxvWXnqzdy9RHmez/pjzCeTh9ZnXpfvd0Kop/p9sawVcZ7yug==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:35 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:34 +0000
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
Subject: [RFC PATCH v3 10/19] target/arm: Add Nvidia Grace named model
Date: Thu, 16 Jul 2026 21:38:49 +0000
Message-ID: <20260716213858.609699-11-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7dd4f96d-9a26-4805-e318-08dee382ba8a
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	6eAZ1ASggV4qmnNCjjceI+kvBeskw6wNIRxrooi3vOsrED2tDNiDtDh7hbW2z5v3n5BxfJFEdFD5TV4PPX9TY7X0eGcryxA2gl872DKyOraIQNh7rJZMohVi0yNPyfu+lpL9wOosgrBRJBIHIX1yMZsxeZycJvuwIBgM3l4rKN0xNeWYTJ18K+Z624+e9g0nZZWJs4tXz9ttGtQEMTSxrRH0hxZTVaSCvdB1bNu1p/AuZkkHEQzoRkjXD7Ze7mWD/kxTRFQNrQP2CRA1+ymf/egf4pHUxitB1cpWaY4yJBOg+MMPjdfJ/r2LX05fn0uEjGqcEC5Xrtg1BhY1PLOGlhmK2v0pMsoqxKtwnfsA27xtAFhx2dAYLAGdqVmKq+G+zblYG19APRmrx087HV3oLC6v/GooyxZEL3dqnP6LoDzpEPrVgpR84BioUlQakVqfykQLyomwS8W0Wznk2RdwbcENKctyKMLOwXbGy96Q+ceSqjIXWO92AOj0d8/EmSvPbK5RJSulXH0vymbsv0h8o3OjlGeUZeyNGJwitW79ev5aMh6PXGtMJKL0gfeI9N45RVKx5nER2b73m10TnxxtgYzeD2EPs9ee6NDlX8OFXh7AI2jvo+Veh5wXdWogpGBUFU8nD3BamCoTUn7Quyk/mH+fyxzKETPTOXQ/YLZwo60=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hv/hJp0BkBkVPVL1ZoZherWK5sCmdsT8PZldYZhNBtzGZAchvh8akOprRklB?=
 =?us-ascii?Q?/SopUKFSdAtkCHgtW6/E6W2RX9LfOkciRDGdpMif78xTPkBDQQC38+2YBZaj?=
 =?us-ascii?Q?4rATousGd4fZmO7LMVEufEsoNHm1zZ8qpw1suZQugKg2OPCTohmUtwpvcxdD?=
 =?us-ascii?Q?ZG1/+dI9heTOjQJ25o10ubgqemmyCXcnlfFWDvX2Bp8QA/TW+fRVmOWknFpg?=
 =?us-ascii?Q?dcgjTo3Ey4Cyr4ZcHGOtGi5Ge9NFMSjPxObUW+i1fudfl16Mj3VEECdudZhi?=
 =?us-ascii?Q?46qKMsmruW08ROqLU5Q9AiRYn/YNio2v9EH7Vm2x1/lyOtXguVGpbSV93aNJ?=
 =?us-ascii?Q?mRCScDAaUvV7RQKhZcXihf0D0NhowMODCzZM7N02C1SYFZkSQhB5x0phfabr?=
 =?us-ascii?Q?MfFMqZyuMGn0YivbNAVhVe8hqm3FDOadq+QQDAhWR7yE2ji+9jZPRlDGdtgv?=
 =?us-ascii?Q?4wK5Ld3UJB4kIFgQ1c8AXEPQ1lNH5sIGqI9l/Xmf7rDQz2DpsHrClFfcStjH?=
 =?us-ascii?Q?4mm2Pz6ox93knjwvER/o7oivn9RjSTLQBJgFkNIh8j816fLXwaJihH7QXdsh?=
 =?us-ascii?Q?dwHKnXwQ9xn/2c0ztrpcUs5iSqzLyXwNBeHMeMMMI/wDmC8jdztEZyK7I9fw?=
 =?us-ascii?Q?uQlqy3dSYvRzTKDye7+GmCSPlo958TkCYYJGLXgWs8b+5ai0V3YUZ7TanG5S?=
 =?us-ascii?Q?dvpdTQepmpojq4mLL01F3qlb5E8aXA7PBNNHVKG0RMLtzdDf4vgnlbjffYAS?=
 =?us-ascii?Q?rcnlXP+nIW7QM2mPu3w86YVtb72SgVx/vD0wMEsuUjJ2T3ync6R9etzGRD97?=
 =?us-ascii?Q?MU60xIoYW9m1oVJ4IaRhOEo+ALZ2KkkIcNk0kOQGE0our8ry1b0eBLbE4cem?=
 =?us-ascii?Q?16qSHlEHDjl+aakWODD4vxwVoI68ZeFJyflQwNGvKd4Q0BwnmHy3zHkV/+kA?=
 =?us-ascii?Q?RnfMnycq13btEahvWIV5FEXyjWtntLDY3vcCfTWbfyl/l564GVSFSvQCClyE?=
 =?us-ascii?Q?nsUN51Vjoa964uVzKeTCdhE6HOjaPOHICIonYpUUJKrNTLJulJEw9oNULwSs?=
 =?us-ascii?Q?+EtqV+st4hS8J5QykVL5+rKMvkKsFtfhT5Nr5o2CWqrNFbWWxMIxRujkGeG4?=
 =?us-ascii?Q?0YeSH9Udi4sC0zjTyCd1x0RljXb7hFGrE/fAStZMnpbwYEbAyU1GzcWHkbqU?=
 =?us-ascii?Q?bQ1wJsp/TmDMc0WpWZWcgtGSjesxlR+Xcwl89wShmfy1yqXjG35CDu4NFj8D?=
 =?us-ascii?Q?aq3jqcdh82sKMCPUpW4kr8xHolQz7H6FP3tPdJWbYcYyc40YLI8+1Ok8jTY7?=
 =?us-ascii?Q?ftR+1d0DnwSHdhLDZGrrUdxbnSxHxVv8Tvd5B/ZTVXEqQCFZp0HlRmzQepOT?=
 =?us-ascii?Q?6QtyqP2bau2FnCjfRrmhTiD9eGf3S94josC0G4lfWESA3ZksUAo79cU/UIYE?=
 =?us-ascii?Q?pCQiTBUv1dC1YsSaYEcPrWFpMaCNkB2C/TJc/yq5Cb9QEUrFKPX5vg7jT5Mh?=
 =?us-ascii?Q?N3vekmeT7V1t1N1f3sm7+KARmrMBUILrZilBYECg4D/ouBCVZqfp1d0MqgIx?=
 =?us-ascii?Q?zSgKHDg6aioVLWKJ1KdH8fA6qy/VOI58kvSsKcbtc1G3gfogwu94LeaxZONE?=
 =?us-ascii?Q?LjhnKFl6qmo2PJ4glMtOl9cWW2+hrgZph2MR+6OgLe5hT+XZVYpTb9MoPhpO?=
 =?us-ascii?Q?v64Car0Ew7nNSgXqHh6j9ORHHQE999aPiY4wLDS4C8WcJyt3xsKXhwqeYviA?=
 =?us-ascii?Q?+ilT/38bxFJJrNoLyfkJTpIIsJ7zJJQ=3D?=
X-Exchange-RoutingPolicyChecked:
	lYZ/5iijMOTMr8PUK00gsOHgLiWgu77ck7uK0s8o4iqelUwvwLCRyGMpM40POTJ43osPXUv0kQ1b6HAS6aoB7FjMdYmJn1TjvIRrqPDzw45SO8FaIwldr9gZrJaQqNInFMIM4aOEuoGw6wdQ3cHQNwjHQBqHPRnltCvnuNvNpbtiuBMCpfvUqfU1LZi+HK/bFfh9OFKITrzyafP6GyX84y4lMeFYbvX2bsJW94eErC79loaZ//K0Ow4LZQjv591tuWF57IPn2u21VQPZolUinOz9psN2c99IjVCj16pSxVINNTOa6LYcOdxZ2FmMWkdQBZOtJ2oK7LyhTPOEMTvXvQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd4f96d-9a26-4805-e318-08dee382ba8a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:34.9364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bxRcmVuHbBn25K5RXEam2VElrUVUCPvEKv9bpTBj9gsUg0SqOUKsmMn9/eFEgdMT2p9sgQYBKUJz9zODsnHsdWcRb0yqxJMGCrqcUSwiNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX5UNi+h+YKyhY
 VjxJTWY2DcAVinth3ESLmtlKcVmEqKMWTGgg0YbK8sgNUVUiLVqGixGnnwR1a34mWhsFcv84sLf
 M1J06lAD+IBVItNjJypwRKul2hWRKvtc+UYweorfWv3w15j22EpCleZMnRrlPVStrj93UKgb0oR
 uSdHQ3D1/xXWzbgbQAsQp4Pd4cfaFOnhA4+L3f6ZUujRWeR5moRZ1XCctAAO1HreW/P/sGdAt0o
 nTslvA7Bq1gzPFi/OhvojyVxWbkYPQaWf76/wHxXzMSLsfRANHbTK/mDJMy7VbkhWa2rM0kp0fC
 ohauhCyisvhPWDMRfd0dYTF19UMXicl0HPQ07AJ4CQlyxaT7QneK+ujpV2otdNVnPGcBejQkmGZ
 flJpVchy64+VPIeDH1nimTXu0s6wtSHLD2PwYGKFe22fobcKEyQ7UvVAhU3FBKNdtVtKrJi1DRz
 fSz5Alfut8QwO5Rj3yA==
X-Proofpoint-GUID: FK3UaOatZ0mlv1fgwaR6sC3U5gvwKLvA
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfXyrya/kCZ9B6i
 1bdeHNqDVAyFbJiuLDE/jE4pIE3BrHjZ0uSjUERsULSxTotGrbVNZVyJwybWpqsMZM14tCD8zQO
 AE1buqHzN4PJ6Wjwsy+8lMcXe25fWfk=
X-Proofpoint-ORIG-GUID: FK3UaOatZ0mlv1fgwaR6sC3U5gvwKLvA
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f9b cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=qRvJWlhRAHAo-js89rYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add Nvidia Grace named model alongside its hierarchy (neoverse-v2,
armv9-a)

Field values were derived from the ID register view that KVM exposes to
QEMU with -cpu host on an Nvidia Grace system.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/arm/virt.c               |   3 +
 target/arm/arm-cpu-models.c | 154 +++++++++++++++++++++++++++++++++++-
 2 files changed, 156 insertions(+), 1 deletion(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 34e56dc1f1..3b27c7a710 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -3816,6 +3816,9 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v8_4-a-v1")));
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v1-v1")));
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("graviton3-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v9_0-a-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("grace-v1")));
     }
     g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("max")));
 
diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index 747e0df010..40e8578591 100644
--- a/target/arm/arm-cpu-models.c
+++ b/target/arm/arm-cpu-models.c
@@ -14,7 +14,9 @@
  *     arm-v8_4-a-v1                ARMv8.4-A architectural mandate
  *       neoverse-v1-v1             Neoverse V1 (TRM 102649)
  *         graviton3-v1             AWS Graviton3
- *
+ *       arm-v9_0-a-v1              ARMv9.0-A architectural deltas
+ *         neoverse-v2-v1           Neoverse V2 (TRM 102375)
+ *           grace-v1               NVIDIA Grace
  * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
@@ -197,6 +199,141 @@ static const ArmModelPropValue graviton3_v1_props[] = {
     MODEL_PROP_END,
 };
 
+static const ArmModelPropValue armv9_0_a_v1_props[] = {
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_BT", NUM, 1),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV2", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_CSV2_frac", NUM, 0),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV3", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_DPB", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_E0PD", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_SB", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_SPECRES", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_SSBS", NUM, 2),
+
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DoubleLock", NUM, 0xF),
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_FP", NUM, 0),
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_AdvSIMD", NUM, 0),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_TS", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_FRINTTS", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_RDM", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_DP", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_FHM", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_FCMA", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_JSCVT", NUM, 1),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_SVE", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_SEL2", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_VH", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_XNX", NUM, 1),
+
+    MODEL_PROP_END,
+};
+
+
+static const ArmModelPropValue neoverse_v2_v1_props[] = {
+    MODEL_PROP("SYSREG_MIDR_EL1_Implementer", NUM, 0x41),
+    MODEL_PROP("SYSREG_MIDR_EL1_Variant", NUM, 0x0),
+    MODEL_PROP("SYSREG_MIDR_EL1_Architecture", NUM, 0xF),
+    MODEL_PROP("SYSREG_MIDR_EL1_PartNum", NUM, 0xD4F),
+    MODEL_PROP("SYSREG_MIDR_EL1_Revision", NUM, 0x2),
+
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_BRPs", NUM, 0x5),
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_WRPs", NUM, 0x3),
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_CTX_CMPs", NUM, 0x1),
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_PMUVer", NUM, 6),
+
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_TLB", NUM, 2),
+
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_BF16", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_DGH", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_I8MM", NUM, 1),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_FP", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_AdvSIMD", NUM, 1),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_RAS", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_RAS_frac", NUM, 0),
+
+    /*
+     * V2 silicon may report CSV2=2 (FEAT_CSV2_2) per TRM page 392, but
+     * KVM clamps the guest-visible limit to 1.
+     */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV2", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_CSV2_frac", NUM, 0),
+
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_PARange", NUM, 5),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_ASIDBits", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_BigEnd", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_SNSMem", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64", NUM, 0),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4", NUM, 0),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16_2", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64_2", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4_2", NUM, 2),
+
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HAFDBS", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_VMIDBits", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HPDS", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_PAN", NUM, 3),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_ECBHB", NUM, 0),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_SpecSEI", NUM, 0),
+
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_FWB", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_ST", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_TTL", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_BBM", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_EVT", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR4_EL1_E2H0", NUM, 0),
+
+    MODEL_PROP("SYSREG_CTR_EL0_IminLine", NUM, 4),
+    MODEL_PROP("SYSREG_CTR_EL0_L1Ip", NUM, 3),
+    MODEL_PROP("SYSREG_CTR_EL0_DminLine", NUM, 4),
+    MODEL_PROP("SYSREG_CTR_EL0_ERG", NUM, 4),
+    MODEL_PROP("SYSREG_CTR_EL0_CWG", NUM, 4),
+
+    MODEL_PROP("SYSREG_DCZID_EL0_BS", NUM, 0x4),
+
+    /* pauth */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_APA", NUM, 5),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_GPA", NUM, 1),
+
+    /* sve */
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_SVEver", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_BF16", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_BitPerm", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_I8MM", NUM, 1),
+    MODEL_PROP("sve128", BOOL, true),
+
+    MODEL_PROP_END,
+};
+
+
+static const ArmModelPropValue grace_v1_props[] = {
+    MODEL_PROP("SYSREG_MIDR_EL1_Revision", NUM, 0x0),
+
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_AES", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA1", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA2", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA3", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SM3", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SM4", NUM, 1),
+
+    MODEL_PROP("SYSREG_CTR_EL0_IDC", NUM, 1),
+    MODEL_PROP("SYSREG_CTR_EL0_DIC", NUM, 1),
+
+    MODEL_PROP("SYSREG_REVIDR_EL1_VAL", NUM, 1),
+
+    /* sve crypto (base sve inherited from neoverse-v2) */
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_AES", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_SHA3", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_SM4", NUM, 1),
+
+    MODEL_PROP_END,
+};
+
 static const ArmNamedCpuModel arm_cpu_models[] = {
     {
         .name   = "non-zero-defaults-v1",
@@ -218,6 +355,21 @@ static const ArmNamedCpuModel arm_cpu_models[] = {
         .parent = "neoverse-v1-v1",
         .props  = graviton3_v1_props,
     },
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
 };
 
 static ARMCPUInfo arm_named_cpu_infos[ARRAY_SIZE(arm_cpu_models)];
-- 
2.52.0

