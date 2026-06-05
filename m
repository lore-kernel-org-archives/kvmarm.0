Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884B44BCAB1
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650437; cv=fail; b=KcBAXNnHXXqXMOaHZf4g1i9Y21unqBJzEtN1kTM3BKMdwZFs0SWcbP8gC4N4enRdDb/9mFVqI5D9bvbsbLgsLHjQqNU3EdkCJ+9FcdfrkNTfhB3/Z/c98Yx7YhDSBAnqO6MeokbhCzsKJ3H7YJe9A6MbJOz/kL322lobaiJuGiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650437; c=relaxed/simple;
	bh=g5zSulfjdcaQRjJhV8Fx7FxYUDP66bhqC1aGM8l8568=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uV+dVBwJ75Q1hytaHR7NieRzCaISPmQMSze1Q2mmQFxZJIIdHcMzicmo2PHy8iBKYOfDQZ5WA+/7ShlufsRRW4vxu9EaXCZ3Op9fp/DPQFqeaFe2/R6no5EmGpTTTW9BkUFdJ3tjVH7fYnn0bmlaZEyq/e4Pd8nUMltTSf2XfHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=jTKO1s7x; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Cr36SwB0; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="jTKO1s7x";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Cr36SwB0"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556Ocu2889016;
	Fri, 5 Jun 2026 01:43:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=IDJdjnOhS2BXWdfHG0C8C4reDPyRPFg0F1ED9Npro
	M8=; b=jTKO1s7x5wMLgmLkrNMdUxBQ7zv+PlrYW9X6rJO3vbSEn9fqixvwImj90
	+NY4P6P26Vw56TV17atTC7uG3UHEmKuAygTHxxg8ITslUppf2yJPMz1GXajsiPdz
	p7o548O3SbGFTR31D8sHorvY+/tsI2j/7d5CMUkVG1z4Irmdp/wYSYtq1+VDmdMK
	+OpkDRXLeTXAT2pispCD5cxJFVYCxaRQs/nmUNkFea35u7D7Netm2493UToaHeqX
	Moxo36hPdkJRGeAB9ERJpI5Q7MLMnvp/k0HdNJkU8NNaXQ9pdGQ99sUr+yzSGr+3
	Cvd6Tqn17mLXjWxwyUZSmpz4oBv2w==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021117.outbound.protection.outlook.com [40.107.208.117])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ej5a2fxwg-4
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uMZtwHWU4Kn6ZlAHoy7VKkXFhvAxW+alO5cBwft5O1dYIbCjx+rESMwsxhS/eryY5gH/yGbbTZUxRrR0xuoEynQx+QyJm5zHCiFIqrXrVUwMDbzy9O+ubhs076GeYb9DlccDXncpYoDfv8Dpq8qJdK4gCW24nNHclhAhaX2iwA7wSpjI11+j3HtgfReJoPAlIJCL5pRqD4JK9MOYFJ2lrfkZITLR6VNTBTIa/RlTkYFylrjeU081eI/7GwMyZH85mNAmcExl0/9DGN4vM99ETX6+cAskBwk21dK8DclxLgZfidK2EywcpdPL38Iq3pWw9SWebV0eYz6GqPbbLdqmsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDJdjnOhS2BXWdfHG0C8C4reDPyRPFg0F1ED9NproM8=;
 b=QtGplJyOHX3BkzSe1VbNhedfyh0PR4hDyVOjj4r2PBz5nBi9I4M/uUEkSAuUrBv9y3C7vn6S0l2k3jxu+Yh1VSCVdDKibMHpR+9P1tsLraQjvmo0bzahozWcFB9PtaZVSajs62kIcF3O+IO880fb5MilxrW5tJYkISzJY0S60RUH7U5Rx5xXG8upcGGSbzThId+nCZnGrvg5NFYOq5nSOvUt0fo3U37tka/VTLfrXLRDyAUqt3tABT12kKrGnUnAc9BuUUw/QcA+/7iUSxt75teOpTOtpMF5CC+NDhg/ZR8C+mIfo8KULsfCiCCaHKigrLKko/dcFPO+qiI5RYZNHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDJdjnOhS2BXWdfHG0C8C4reDPyRPFg0F1ED9NproM8=;
 b=Cr36SwB02/+lTtLntrxyixe6w8Rag99p51U3hclF0PvD2w9peXfh7yBfHYryagFYXig6rgS4guVvCbv2K2y7YvNbLmPOLLBYXIMdP/Uy8TlHTymOdHwGv7FRtWp2X+voNg1KaSmmyDa1mJevQl8m59rWebEDCKmeos8UezS7JgWGMue2bV7FZmhGaF8zWSnL0j+cUEkZvuxNrVVOycAPOJ2rvEiX8FoBTsuPjxkXHv5T9fF2/b3s6MfPl59tYcW4YQwN3qKFrsHFpF7GoI9mXE1KTmGa6nu65bBa0gj6AYmT1I93onX9+Kqqefc1yeGGCmaRDJwH8aZB+FriH5C5Dg==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:15 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:15 +0000
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
Subject: [RFC PATCH v2 17/29] target/arm: Add composite property type to model definitions
Date: Fri,  5 Jun 2026 08:33:46 +0000
Message-ID: <20260605083358.1320563-18-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: a55163c9-add0-4e33-f9ad-08dec2de7bfb
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	beSgKuIgzGDIEnIulLkplo8898Dd3kTu2WEauSk4IDnPoeDRQDePSPJCcksTdroDdSmW5oNX6pVYiIieczqy22oRAqx211402GvCozO4Omz3X0yIYxfqIXsHdXCEHZx4a2Z7iLxOGndU5VJV5j0hdYFPrfEPwWMDVQ9VjZ7BgyxapvKkItQXDJ5IET0iW7jrk+AJzZqvttnR4B9qb3Nvi9HdiOaT8ZZze0J5h6zCWqOjzDzJZjl+VRO8qQQwUQ740LeAacVDAaD5tsui91IiEiI+24xs+6g3QlbuWeNWB3HCUaROUUUQ9yYQWSWdKJ8AxI9kx9KoDIYqjVePNadF3Js4D3Wfne8b392QcdffYJsbYXAyZ3SeYEZeZZF212REqce9gRvTm6g1vWeUqH57WHUxK7x2pw/0XLUBbo8UgGYnPcKhdNjVdwj7RhX8CVxKHpKuxGmeG7YPMsn6NoHPqQkWhu0z/cevL8txUUlSNUiQQyO0hJSm7Te+/UW1TbjYZIQrZIBcFt3ZVfqXzc8cWCpJ2iWoxpNPJXnGAxzfbxQlyA47jmY9tYHCSt0qspI397tssZSto3DqmaD/HMdqnsV9Q5bUTXxvp49Cs4E72BPwFPMraP9jAa4qhOUMklhXPdlkn54BFm4mLurv2KmJXcadF3nlQ2UKlW52orJbVM99ioaOS5IPYG3il8jzTppS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kl1qO/r/QSgwuOCSk1DykAcsaiVqNLVk/d0sy5/0UyzYgmzmZ0pJh+aT5njP?=
 =?us-ascii?Q?BhLwMRzNfcLdKdwesyIpp5kbJDZqzbxw+r+v5/jBhlKeKvIj8jkPSSqHwmvt?=
 =?us-ascii?Q?QBfGdaTdJIRWTDSQOFavMVnkL9+XBlv6NZkZrd//GX9uf4xvzOtzA9e49w5b?=
 =?us-ascii?Q?0tvxiPhBMbZmhJ2GcnkoV2d4bpNONErGYyC6ymmXGZYZlIRSXY6LPjqrJ/dY?=
 =?us-ascii?Q?ehr/zYrMd0UxN20i0tbiwHyu9s35P1nkFXsEnKGzxKTo9uEF0jbK0fdQYgJ8?=
 =?us-ascii?Q?4y8hG5DtfOsQM3b5CYOflkETBhBMSyL5zS8RZWRKEYNTGCdy1FMDp7VT2lxA?=
 =?us-ascii?Q?KmMIYf06USlSJ0qOM/C+d3d0/XV6+XX6Yv4/79ow3qjtXD2DK/05CTb7cIIT?=
 =?us-ascii?Q?mwklzlTQmmFLItRF/ZvepegoJCulCbQijIAi7QntSOyi3i02ZuSczPJdK6zW?=
 =?us-ascii?Q?MuFXsyWL9SgIeZeuZkGMWaS9sm7Ocv2Z/UAVBfrl6+3svUesF4kFGeBfm0I5?=
 =?us-ascii?Q?tZ84ch8aFVqP8NC/e5AqGKrn+6D7wm6ne3eKJIdw1gI76EeOh74I4ZliXJQm?=
 =?us-ascii?Q?Ud2mIApyIAKp56jdc5eGte1+iUf4qIPbQ9z4j9X/lIa5kK/xXQKE/b3qbHfN?=
 =?us-ascii?Q?x90fXm+RTxTntsFGYwxUYXgZBon2RSFjGt2d9vDdOARbBFpjNwgG9xhQc8JU?=
 =?us-ascii?Q?7/Q3QQ1+cHt+YzVFWq8AnPCzc8+zEIYXpGI4+uKSFbzweGvcNUU62RQ2nAnz?=
 =?us-ascii?Q?lzmjzRrBiN0FJk9ebPYeyEjdDqfcKdnvNGtPblPSE6rvEE99r7PQ//H2Pn5A?=
 =?us-ascii?Q?ccHiv7Ubi9D8Y/MJR49fQDfnmN3OiGywvkr4FmiBXsWtjFmzxoI/ZKZgCk1s?=
 =?us-ascii?Q?8lT+GsgfEl1axvfZhcyrs2qRzpi8eGQtxJ8RJoU3YPFV5W2awFky1XN034gv?=
 =?us-ascii?Q?HlISHZdritm+s/W8Y6hz9C8yyhWUxF8kdlGJOsjYZPECI5n5u/3tm0khjqLl?=
 =?us-ascii?Q?CGuUDc45QG4HQr/86uSJV4Hc9f/pQTnmoCXPCR1BxnvNkClY2sufOrkHJlBs?=
 =?us-ascii?Q?XYIIJFXNc5ZuG+0ZmtD0BObguFz5lkcWSZKTafwTRI8rRmknVWbdeHICH79n?=
 =?us-ascii?Q?xQ9Sk1Be21Idkbl2MKlanPOeb/cClpYx84DzcKh4lcqpKrEliSNdiWSU6tuZ?=
 =?us-ascii?Q?va7ufhGA+07InsLVTSqj8w59sAqnFMu87qxxTfswGxbKYL7HcWN90SidJ1Bk?=
 =?us-ascii?Q?dLTzAya1wNExc11nRv7NkWJ63zP0pK1JXRB8BBL8v9/IfeEegsxexH+2ioIz?=
 =?us-ascii?Q?s8scPsJLnq0FHvs3Y6kcYgkgYxKJbOvY7tDY6DNtrMtICoFMuGOw8QnH45Rc?=
 =?us-ascii?Q?gtvXboRgglVlhaNegM/hjGSYI+sbqqtAT215f3NT373/A9Se7KzMuKnfCSSM?=
 =?us-ascii?Q?+ARwEPvFRJjBGiBgtIh5s8v75aStEPAXeE/a/2GE9UR3M1CU1Yv5prTDYR6C?=
 =?us-ascii?Q?lcvLapojTHBnBGRYIDQQEuNuxzXHXMInPn868dV1JlBKvLlKtkV0X6/+JiOH?=
 =?us-ascii?Q?BKqJptQdIcEI7JJJ+H0bHHYnNmPcH6aAcy/3X6Hj17GLYD55pAF5JoidFCHv?=
 =?us-ascii?Q?u9P2uhOA7BelkFcyU+MbmqW8SujK7g18GX4sifFJTqwTyqiP8m/aCicOkH6r?=
 =?us-ascii?Q?S8w8l2n6E5vQGeFEMQeCH2VbDWRfdUIrEGZjm48UgtzJFrHD2ADig0Ystciz?=
 =?us-ascii?Q?L34/k3oJckymb7La8VQcaSglfE4OVFE=3D?=
X-Exchange-RoutingPolicyChecked:
	VLN5STmY565mEigGasNejXCaV2bFsFMKs/ozaUbbt46YC8sWC3M46yVXodVXC9Iy6EEM12B/rHGwZiruEu9ecXVrcWE3hfZIVOcR4c0iBPCdH4lBv8LsGzqvAOZE/Uuz4S+zN3DOkjzf32YpJ1QcLpto+i6dlQtn6FxQ8sEGympy6/HC38mpdscuAdD8SpKSDklF96IJ+O5CtZNwD7Mj4PKJro99Nfq1RQak5MIlU9z9ubRMuqmpH9m48Y7gjKky8UE989ytHdhxKZG8VQK5xUXNuy7NrIdjdVjpkjJLW7dMl9BKqStjL+W44z30poDZSEXmX+IS5dISaPyHdVQGgg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a55163c9-add0-4e33-f9ad-08dec2de7bfb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:15.3188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBOiGeE011ruXjTxhOUk+GPcga14NDBtuFp1DA9zYKymIs6mLyjFV+jLnMs1SZ5Z3l1Cfr6+J6B1HQ45WZiqXHQaTlZLSn7+Jpl3JTKBZhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Authority-Analysis: v=2.4 cv=Mq5iLWae c=1 sm=1 tr=0 ts=6a228c27 cx=c_pps
 a=fJIB0T+C2yAfE4P2TQxPqg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22
 a=64Cc0HZtAAAA:8 a=lRQu-zcQqA8t1JtojLkA:9
X-Proofpoint-ORIG-GUID: 71d3dX-hnXzId42pvqrIXUnrnf9rlFqt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MiBTYWx0ZWRfX36QUaI+gTYA5
 Rrupk5GOYJKLD789/nF6QeMcTkgf43XH+WiSEOl3e8qTaQS/qeIrq3WLVXCpzVIIysMTxz2UVml
 ATZ6/G+xUQIheLLveH/BLnmX3AjaSxuCESOwBdxiQIQMch7MFoKOnt3LWdsfN7FAqU5MrguDIT2
 rlzVw2XvcSRbzqVfPuE4msg0IVPOCO80vbamQXUwzDcD1/M2CxvMwZc+8iZUsyc87tgrZULwqUC
 mWVX/Okhzq1FkoNhtLeFiVHPAucrAtMhGL+8H4MS85fEiLy8HQMTPALF1zQKG3w5UzHsVfKD5ED
 4o6dtVs34MpLsck+4rSaapLG4CtJJsweDqh+crnpsxR63AFTJtKcpUmanOoAgWVwbNs5oqKli6I
 2WYCJyq8EBK0u8Vb2dF6fssY1D5pNFoaXuAy7uVVmygI1NjLzBCo1QNdkFgO8ar1eetSYNotlOO
 yzT/JhpKA7m5gW0aA7g==
X-Proofpoint-GUID: 71d3dX-hnXzId42pvqrIXUnrnf9rlFqt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce ARM_MODEL_PROP_COMP, a composite type model property.

It will act as an master "on"/"off" switch for a list of sub-properties.
For example (pauth=on, appropiately set APA/GPA/...) based on the named
model.

A composite entry in the named model will have a default value either
"on" or "off" and a list of sub properties. Which will be applied on
the cpu model when the composite is turned on.

Add find_model_prop_in_chain() to walk the parent model hierarchy and
resolve a property entry (child-first). Expose arm_cpu_get_composite_
subprop() so the property layer (in a later commit) can retrieve a
composite's sub-prop values given a CPU.

Refactor arm_apply_model_props() into public arm_apply_model_prop().

Hierarchical inheritance for composite properties sub-props is not
added to avoid complexities.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-models.c |  81 +++++++++++++++----
 target/arm/arm-cpu-models.h |  12 +++
 target/arm/arm-cpu-props.c  | 150 +++++++++++++++++++++++++++++++++++-
 target/arm/arm-cpu-props.h  |   7 +-
 4 files changed, 233 insertions(+), 17 deletions(-)

diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index 230768019c..4b19049205 100644
--- a/target/arm/arm-cpu-models.c
+++ b/target/arm/arm-cpu-models.c
@@ -39,6 +39,11 @@
     { .name = (_name), .type = ARM_MODEL_PROP_##_type, \
       .u.MODEL_PROP_FIELD_##_type = (_value) }
 
+#define MODEL_PROP_COMP(_name, _b, _sub_props) \
+    { .name = (_name), .type = ARM_MODEL_PROP_COMP, \
+      .u.comp.b = (_b), \
+      .u.comp.sub_props = (_sub_props) }
+
 #define MODEL_PROP_END  { .name = NULL }
 
 static const ArmModelPropValue kvm_base_v1_props[] = {
@@ -314,7 +319,7 @@ static const ArmNamedCpuModel arm_cpu_models[] = {
 };
 
 static ARMCPUInfo arm_named_cpu_infos[ARRAY_SIZE(arm_cpu_models)];
-static const ArmNamedCpuModel *arm_find_model(const char *name)
+const ArmNamedCpuModel *arm_find_model(const char *name)
 {
     size_t i;
     for (i = 0; i < ARRAY_SIZE(arm_cpu_models); i++) {
@@ -325,6 +330,64 @@ static const ArmNamedCpuModel *arm_find_model(const char *name)
     return NULL;
 }
 
+static const ArmModelPropValue *find_model_prop_in_chain(const char *model_name,
+                                                         const char *prop_name)
+{
+    const ArmNamedCpuModel *model = arm_find_model(model_name);
+    if (!model) {
+        return NULL;
+    }
+
+    for (const ArmModelPropValue *prop = model->props; prop->name; prop++) {
+        if (g_str_equal(prop->name, prop_name)) {
+            return prop;
+        }
+    }
+
+    if (model->parent) {
+        return find_model_prop_in_chain(model->parent, prop_name);
+    }
+    return NULL;
+}
+
+const ArmModelPropValue *arm_cpu_get_composite_subprop(ARMCPU *cpu,
+                                                       const char *comp)
+{
+    const char *model_name = ARM_CPU_GET_CLASS(cpu)->info->name;
+
+    const ArmModelPropValue *model_prop = find_model_prop_in_chain(model_name, comp);
+    if (!model_prop || model_prop->type != ARM_MODEL_PROP_COMP) {
+        return NULL;
+    }
+
+    return model_prop->u.comp.sub_props;
+}
+
+void arm_apply_model_prop(Object *obj, const ArmModelPropValue *prop, Error **errp)
+{
+    ERRP_GUARD();
+    switch (prop->type) {
+    case ARM_MODEL_PROP_STR:
+        object_property_set_str(obj, prop->name, prop->u.str, errp);
+        break;
+    case ARM_MODEL_PROP_BOOL:
+        object_property_set_bool(obj, prop->name, prop->u.b, errp);
+        break;
+    case ARM_MODEL_PROP_NUM:
+        object_property_set_uint(obj, prop->name, prop->u.num, errp);
+        break;
+    case ARM_MODEL_PROP_COMP:
+        object_property_set_bool(obj, prop->name, prop->u.comp.b, errp);
+        break;
+    default:
+        g_assert_not_reached();
+    }
+    if (*errp) {
+        error_prepend(errp, "property '%s': ", prop->name);
+        return;
+    }
+}
+
 static void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
                                   Error **errp)
 {
@@ -332,21 +395,8 @@ static void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
     ERRP_GUARD();
 
     for (pv = props; pv->name; pv++) {
-        switch (pv->type) {
-        case ARM_MODEL_PROP_STR:
-            object_property_set_str(obj, pv->name, pv->u.str, errp);
-            break;
-        case ARM_MODEL_PROP_BOOL:
-            object_property_set_bool(obj, pv->name, pv->u.b, errp);
-            break;
-        case ARM_MODEL_PROP_NUM:
-            object_property_set_uint(obj, pv->name, pv->u.num, errp);
-            break;
-        default:
-            g_assert_not_reached();
-        }
+        arm_apply_model_prop(obj, pv, errp);
         if (*errp) {
-            error_prepend(errp, "property '%s': ", pv->name);
             return;
         }
     }
@@ -413,6 +463,7 @@ static void arm_named_cpu_initfn(Object *obj)
     aarch64_add_sve_properties(obj);
     aarch64_add_pauth_properties(obj);
     arm_add_cpu_props(obj);
+    arm_add_composite_props(obj);
 
     arm_realize_model_chain(obj, model, &error_abort);
 }
diff --git a/target/arm/arm-cpu-models.h b/target/arm/arm-cpu-models.h
index 297926e167..3d4d805da8 100644
--- a/target/arm/arm-cpu-models.h
+++ b/target/arm/arm-cpu-models.h
@@ -7,11 +7,14 @@
 
 #include "qapi/error.h"
 #include "qom/object.h"
+#include "cpu.h"
+#include "qemu/typedefs.h"
 
 typedef enum ArmModelPropType {
     ARM_MODEL_PROP_STR,
     ARM_MODEL_PROP_BOOL,
     ARM_MODEL_PROP_NUM,
+    ARM_MODEL_PROP_COMP,
 } ArmModelPropType;
 
 typedef struct ArmModelPropValue {
@@ -21,6 +24,10 @@ typedef struct ArmModelPropValue {
         bool            b;
         uint64_t        num;
         const char      *str;
+        struct {
+            bool                b;
+            const struct ArmModelPropValue *sub_props;
+        } comp;
     } u;
 } ArmModelPropValue;
 
@@ -32,4 +39,9 @@ typedef struct ArmNamedCpuModel {
 
 void arm_register_named_cpu_models(void);
 
+const ArmNamedCpuModel *arm_find_model(const char *name);
+const ArmModelPropValue *arm_cpu_get_composite_subprop(ARMCPU *cpu, const char *comp);
+
+void arm_apply_model_prop(Object *obj, const ArmModelPropValue *prop, Error **errp);
+
 #endif /* ARM_CPU_MODELS_H */
diff --git a/target/arm/arm-cpu-props.c b/target/arm/arm-cpu-props.c
index 3a02079ff2..5e876aa768 100644
--- a/target/arm/arm-cpu-props.c
+++ b/target/arm/arm-cpu-props.c
@@ -9,10 +9,12 @@
 #include "qemu/osdep.h"
 #include "qapi/error.h"
 #include "qapi/visitor.h"
+#include "qemu/typedefs.h"
 #include "qom/object.h"
 #include "cpu.h"
 #include "arm-cpu-props.h"
-
+#include "cpu-idregs.h"
+#include "arm-cpu-models.h"
 
 #define ARM_SINGLE_FIELD_PROP(prop_name, _type, reg, fld) \
     { .name = (prop_name), .type = ARM_PROP_##_type, \
@@ -38,6 +40,17 @@
         .get = _get,                                                      \
         .set = _set }
 
+#define ARM_COMPOSITE_PROP(prop_name, sub_props, _get)                   \
+    { .name = (prop_name), .type = ARM_PROP_COMPOSITE,                   \
+      .u.comp_sub_props = sub_props,                                      \
+      .get = _get }
+
+#define ARM_COMPOSITE_PROP_GS(prop_name, sub_props, _get, _set)          \
+    { .name = (prop_name), .type = ARM_PROP_COMPOSITE,                   \
+      .u.comp_sub_props = sub_props,                                     \
+      .get = _get,                                                       \
+      .set = _set }
+
 const ArmFracVal csv2_frac_vals[] = {
     { "0.0", 0, 0 },
     { "1.0", 1, 0 },
@@ -255,6 +268,10 @@ const ArmCpuPropDesc arm_cpu_props[] = {
     { .name = NULL }
 };
 
+const ArmCpuPropDesc arm_composite_props[] = {
+    { .name = NULL }
+};
+
 static const ArmCpuPropDesc *arm_find_prop(const char *name)
 {
     const ArmCpuPropDesc *p;
@@ -263,6 +280,12 @@ static const ArmCpuPropDesc *arm_find_prop(const char *name)
             return p;
         }
     }
+
+    for (p = arm_composite_props; p->name; p++) {
+        if (g_str_equal(p->name, name)) {
+            return p;
+        }
+    }
     return NULL;
 }
 
@@ -350,6 +373,9 @@ static void arm_cpu_prop_get(Object *obj, Visitor *v, const char *name,
     case ARM_PROP_FRACTIONAL:
         arm_fractional_get(cpu, p, v, name, errp);
         break;
+    case ARM_PROP_COMPOSITE:
+        /* Composite features must have a custom getter */
+        g_assert_not_reached();
     }
 }
 
@@ -428,6 +454,104 @@ static void arm_fractional_set(ARMCPU *cpu, const ArmCpuPropDesc *p,
     g_free(str);
 }
 
+static void arm_prop_set_default(ARMCPU *cpu, const char *name, Error **errp)
+{
+    const ArmCpuPropDesc *p = arm_find_prop(name);
+
+    if (!p) {
+        /* Sub-property can be a already present cpu property like sve* */
+        if (object_property_find(OBJECT(cpu), name)) {
+            object_property_set_bool(OBJECT(cpu), name, false, errp);
+            return;
+        }
+
+        error_setg(errp, "Property '%s': unknown sub-property", name);
+        return;
+    }
+
+    switch (p->type) {
+    case ARM_PROP_STRING:
+    case ARM_PROP_BOOLEAN:
+    case ARM_PROP_NUMERIC:
+        arm_idreg_field_reset_to_default(cpu, p->u.field);
+        break;
+    case ARM_PROP_FRACTIONAL:
+        arm_idreg_field_reset_to_default(cpu, p->u.frac.base_field);
+        arm_idreg_field_reset_to_default(cpu, p->u.frac.frac_field);
+        break;
+    case ARM_PROP_COMPOSITE:
+        object_property_set_bool(OBJECT(cpu), p->name, false, errp);
+        break;
+    default:
+        g_assert_not_reached();
+    }
+}
+
+static const ArmModelPropValue *
+arm_model_prop_find_by_name(const ArmModelPropValue *props, const char *name)
+{
+    const ArmModelPropValue *pv;
+    for (pv = props; pv->name; pv++) {
+        if (g_str_equal(pv->name, name)) {
+            return pv;
+        }
+    }
+    return NULL;
+}
+
+static void arm_composite_set(ARMCPU *cpu, const ArmCpuPropDesc *p,
+                              Visitor *v, const char *name, Error **errp)
+{
+    bool val;
+    const ArmModelPropValue *model_sub_props;
+    const char **sub_props;
+    ERRP_GUARD();
+
+    model_sub_props = arm_cpu_get_composite_subprop(cpu, name);
+    if (!model_sub_props) {
+        error_setg(errp, "Property '%s': unknown composite feature", name);
+        return;
+    }
+
+    sub_props = p->u.comp_sub_props;
+    if (!visit_type_bool(v, name, &val, errp)) {
+        return;
+    }
+
+    if (val) {
+        for (const char **sub_prop = sub_props; *sub_prop; sub_prop++) {
+            const ArmCpuPropDesc *sub_prop_desc = arm_find_prop(*sub_prop);
+            const ArmModelPropValue *model_sub_prop =
+                    arm_model_prop_find_by_name(model_sub_props, *sub_prop);
+            if (!model_sub_prop) {
+                continue;
+            }
+            if (sub_prop_desc) {
+                assert(sub_prop_desc->type != ARM_PROP_COMPOSITE);
+            }
+
+            arm_apply_model_prop(OBJECT(cpu), model_sub_prop, errp);
+
+            if (*errp) {
+                return;
+            }
+        }
+    } else {
+        /* Disable all sub-properties */
+        for (const char **sub_prop = sub_props; *sub_prop; sub_prop++) {
+            const ArmCpuPropDesc *sub_prop_desc = arm_find_prop(*sub_prop);
+            if (sub_prop_desc) {
+                assert(sub_prop_desc->type != ARM_PROP_COMPOSITE);
+            }
+            arm_prop_set_default(cpu, *sub_prop, errp);
+
+            if (*errp) {
+                return;
+            }
+        }
+    }
+}
+
 static void arm_cpu_prop_set(Object *obj, Visitor *v, const char *name,
                              void *opaque, Error **errp)
 {
@@ -453,6 +577,9 @@ static void arm_cpu_prop_set(Object *obj, Visitor *v, const char *name,
     case ARM_PROP_FRACTIONAL:
         arm_fractional_set(cpu, p, v, name, errp);
         break;
+    case ARM_PROP_COMPOSITE:
+        arm_composite_set(cpu, p, v, name, errp);
+        break;
     }
 }
 
@@ -487,6 +614,27 @@ const ArmCpuPropDesc *get_arm_cpu_props(void)
     return arm_cpu_props;
 }
 
+void arm_add_composite_props(Object *obj)
+{
+    const ArmCpuPropDesc *p;
+    for (p = arm_composite_props; p->name; p++) {
+        assert(p->type == ARM_PROP_COMPOSITE);
+
+        /* Replace the QEMU bare props if present. */
+        if (object_property_find(obj, p->name)) {
+            object_property_del(obj, p->name);
+        }
+
+        object_property_add(obj, p->name, "bool",
+                            arm_cpu_prop_get, arm_cpu_prop_set, NULL, NULL);
+    }
+}
+
+const ArmCpuPropDesc *get_arm_composite_props(void)
+{
+    return arm_composite_props;
+}
+
 const ArmCpuPropDesc *arm_prop_for_field(ArmFieldIdx field)
 {
     for (const ArmCpuPropDesc *p = arm_cpu_props; p->name; p++) {
diff --git a/target/arm/arm-cpu-props.h b/target/arm/arm-cpu-props.h
index 36ca39d1a7..392a0391d6 100644
--- a/target/arm/arm-cpu-props.h
+++ b/target/arm/arm-cpu-props.h
@@ -19,6 +19,7 @@ typedef enum ArmCpuPropType {
     ARM_PROP_BOOLEAN,
     ARM_PROP_NUMERIC,
     ARM_PROP_FRACTIONAL,
+    ARM_PROP_COMPOSITE
 } ArmCpuPropType;
 
 typedef struct ArmFracVal {
@@ -37,14 +38,18 @@ typedef struct ArmCpuPropDesc {
             ArmFieldIdx frac_field;
             const ArmFracVal *vals;
         } frac;
+        const char **comp_sub_props;
     } u;
 
     void (*get)(ARMCPU *cpu, Visitor *v, const char *name, Error **errp);
     void (*set)(ARMCPU *cpu, Visitor *v, const char *name, Error **errp);
 } ArmCpuPropDesc;
-void arm_add_cpu_props(Object *obj);
 
 const ArmCpuPropDesc *get_arm_cpu_props(void);
+const ArmCpuPropDesc *get_arm_composite_props(void);
+
+void arm_add_cpu_props(Object *obj);
+void arm_add_composite_props(Object *obj);
 const ArmCpuPropDesc *arm_prop_for_field(ArmFieldIdx field);
 
 #endif
-- 
2.52.0

