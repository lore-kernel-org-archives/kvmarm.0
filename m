Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F39C3DA7EC
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649040; cv=fail; b=Xv4WDg7wL98kNydfZXbYZcgIeE+vOvxnH6Z0bKBGK6m7aVkT9cnqoXYebDr1HCMXmyeJNDw2qxMcojBDN87/zTbfiOIOCSy/gRkY/dRWigY6dY55iDp4ElOKOFbgV9XkL36QxybOi4SOqehKoHD5Xug1FEsCKQDUf+O5jsZxksY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649040; c=relaxed/simple;
	bh=kRhq0vfKBCqughBTa+auhveCrR3hjaMdzjyYPl6OqSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J/WuGFmXUgeMehqkXpuD1m3WveWrBDZYDT8fwPzvhTusgyB7pON/+EKNoVSz0epGIdDNDn+feK7tDfKXUlXdsdCnybdMWtn+S9I0odyS9uMU5ZrCotiphbCBGhuvQWe1AoLNvxhftRUsf511yd1m1fMfLUfVrBN2LSpcgWwwZ30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=TAJDgy5C; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Bpuc6QZX; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TAJDgy5C";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Bpuc6QZX"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLU854749;
	Fri, 5 Jun 2026 01:43:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=XxWZDcbV2/n9deluDF/vXPbQh56+g294QkACTaKVS
	2g=; b=TAJDgy5C4yoJmYaK0Z1Wa1NbEjHWZ1jv/PhYOqJLd3BuylqE2SvDs9F/4
	y2IuGkOSmrmg+QxjZSuhPXk9gtqaSryYzQHjQu9x1wO+ELdrSx/LK+F8Tx9nIk1z
	kyxcKLXuXWt5r0zNqRNsOgcG/ETSffaTuo0ZJuu/oglciSDz65/w7ubB8tSFoL8Z
	ptkFOgRd8C47BXcvwnvWNWb/Hd2XTZBpP9X0YRzKJBeUZZkPXD7I+X9pEkgC2yF7
	o885dAjoImynje+jC2mZm410OETNMmzoVFRUY7QonS8o8SqyupMrnNqFnwzeUORY
	/RiACnn+mgkK6MRA+J9K1ZcQkU3wg==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-11
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bjy5gA+DKzmmSJO91IeBEDF/bOOFDA8CFbJqbDmMKP5cVIcWFxaiNfkfkrA8eYS7BM//WUTEB5xvFTfn91UxcKrPyivnDs3flNU/jc49yECI+yBEX7HLCFTk/B9BSFcZgylGDLmTwnduMh1ecHAtl0GUQxbmAM1FF8kDn/oZGjuWdqFZS4W154ujhkmG0fjR7xv3v8KVMJh/ZY3GWnKl8TnZlkEeWh/MwNNzj90ON2ek61NmwLhlPLP+hlVruCK4/R2HjDLgIoiWnjzLegDUyLVgYk5wkE+PhA53Gmp0Hxy8fvXNhWu4SJAlgcd+Y//nhDWav/ckJJdIFwUkbzHy/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxWZDcbV2/n9deluDF/vXPbQh56+g294QkACTaKVS2g=;
 b=UOFR0J2huP5n4HZRg8vhzy58LD5Osjn8gpcRabwBq41bNjJwihzboT2yR+bKEpNkRqoCRRriIeYRzi7A3SpQ1ZvRPybm56oxvFl78y0sLEg/n8NBuK7afd4fL11onKpzbbrViJ0u9moTC7pA4/yVpk1GwhM+JjIsavmHGfIGpZcw7Lfv0ZbXAo5UCg4fX8ednF13dSVo1AnEiGgv0YiLYeFmCUJnF/nuOBsYYg0+TD7yD8C5Om5sHkYooFBEvOsFBx5P/N1gVnTafcIV9WhWSEC7TAm1q7V+G8dYGXqv6trrkYOIW+M3q93lukLuh6aD5Mp+BzprKVYcNvXEU+B/Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxWZDcbV2/n9deluDF/vXPbQh56+g294QkACTaKVS2g=;
 b=Bpuc6QZX4LivIH8c5a875hN5ZYFZ/kLVmdTdvTrx5d6WkVsYbleEA6bQJY75976VH65GKHk5AJL9dvZtHLVmgUwbKrirVx4m7zPqPvdtf9/NmV87GQlPtsJPQz5FVTGw9Bs5B1lAqjJWKFgizjr5eTzkR8YSTMYDEhPO4p9ONA5dy+souPmLd2HxVxEMwmqBFwq68lAUJRUX74HZKZqbGC3Ab/3NZoINUIqZadm7zjecxJXYOxB2MrYDGca/c3Ct8vxxDZEmBXTvcAYUpm5tsApkg/nRD1V4bztMoIIDdWzg+bcchxsVPkNm6EFJv6zBYOLHxvfGxuu8+lMXeK/kvw==
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
Subject: [RFC PATCH v2 11/29] target/arm: Add Nvidia Grace named model
Date: Fri,  5 Jun 2026 08:33:40 +0000
Message-ID: <20260605083358.1320563-12-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 91203486-b91c-42c1-c03b-08dec2de7a87
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	URmWVTFeSFq8BU58UYJDwM+JzY7m1bI/4dGlsXSPyLnxvmdl3Ex05uhw9D07zQ/F3Up1196IoZuwYrqnb21Yne7Jgnd7ZsbszRoWpjhoPkyGddkF5E+cvDQpSnF1skTQ3YAsNAlzRtZZMmxPrsFFOkZN8VDXYvIUJEHfIyxfuv1VxTkGNouAfMWxNmEx4gnpOOrK7XC7sqvL9RF5Xx4ifQXeDt9M4JWcB68pnI/yxZF82tvODMLXm6hRmZb12eWuGZwX5dC4E/Cko3tBG5bzvV/tRFfZEhyfD3ZTIKoUUls0Qk7WllUxJ0Y5PMqA43SjNpUyWqbLbgQV2ETBPbbA2uW+8kH1JZ4qTpoCR/83TYWRLc5XmMn2x5emYrklJ6kWBNZvOGkFlwxTjUDm5o1iDyDgRhkkhRiS/ansakUR7Ic3xlzUay7X38euVGvSS81ZTSgTVleop+g4VJCfGlupurv7G94rpYjtk8IWTa6tDGA00S/fehNt3VYANw0u4EZqQ2nng4mB7dQo2vYRzBEBfq/LcxwZy7MPad+nsiuNtZDJGo2WZJKlkvnaXd3TmIz3bTLm7cveSedSOM9LLCa9iAA0WnO3kvikDToAa7i8/jTYVM5uGoSsC8cqavMrBub4A9pLDMdNBN7m7yqNOL9ZZAvZppJkniTtyMa96VP2JD+lrQJx+u2B4Kvwjo3BQJBx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3AfAhLzsECQep7iw0IGfHDd1vG9OCDpcIrtV2hxCtvF0y099njtMOdYz/K1c?=
 =?us-ascii?Q?eZr0UA3Fx4Kc41IvG9zgai5AA8IhWeW+5iOmEGE5JUMDA4lh12piU3uC0K7X?=
 =?us-ascii?Q?4mv6dZ1tZve03AEFM9Ia8Fkk34hqFFCt/ImVeumP+JU3NaLx5n0ISIBqXn8o?=
 =?us-ascii?Q?fTAe8MGNtoPDrqP/oKStq1vDF57qQlTSk2fVmSLFxDpQopuUNfMpLQOVXQCj?=
 =?us-ascii?Q?Ecb9ioS9mydpZFYdGsdXLAMT8ry1cJx0qa+J3bqoqvN2/KuZ9JxvbDpEUC0y?=
 =?us-ascii?Q?2MiQhUoBlG0mcj5kFUrw2EmWe++uTcdjvtOclq+HoGwEO3NjldCPPPJWPkcr?=
 =?us-ascii?Q?v/A3cNXh5ULAaOaLsKlU1Y8Xqg2zQYozlwXiIFjvfvmUMgaGRitRHPYX18G2?=
 =?us-ascii?Q?3kKOdTPawAab99jJo1YeTZZialESz7F2XCMJnvOrvyKtpcfvk3YOoepJaJNS?=
 =?us-ascii?Q?o6PlfAZXzhf0r+uoLIDs9aaAp6UP7cSjr5qeCvHKCsOoMG69jAMoBHjHPSWT?=
 =?us-ascii?Q?Vbqrc94Ld3YoHq8lmCfOwC9oBrCkbV1SK8EF2aO2sj5de7Masr2aYkMdztf+?=
 =?us-ascii?Q?gJHvgq5WqiV8YfyGgkbC6hNMPjpKJukj2wOtw1gQrduWIsKTzREufqln+jE2?=
 =?us-ascii?Q?2nJJYSAiVkABkBTxQ1gR9wlRUoE/4x0DQy+nKr0M7nujk3SPGXGAIXeUWQ04?=
 =?us-ascii?Q?BE2mSMR5WBW64XiU4lshVm15wBC/ksaaZNCpXUIccXp2WEE2tpLXFj6hcI1M?=
 =?us-ascii?Q?cMP9oGKj0r1HKIPTAzTqnXOHT24zsx4WPyWyY1GmGnjvE2Eh/1Rl1ZkmdTzT?=
 =?us-ascii?Q?bKBvqVu9RGLSUEtxc0H+TVNfMGadPLZCLRxORofznAMbwLshO8lK5QI5+6om?=
 =?us-ascii?Q?CLYzfGRaX8Ny6TuXJZwpD6gp1qMvB+OB1Z/mKpJELrSzxzZWD5dWLX3L8Xq6?=
 =?us-ascii?Q?a1eeGdsag0jClRMJgWY0YyjJdO5vrQkweF6PoRYvDGh04TR+lxCplkanXUdE?=
 =?us-ascii?Q?/UTp9gnQmZCN2xqt6K7+9jXXKaFqSWs7BwGHxOSRLgNaXlELxRuChL4xoi+7?=
 =?us-ascii?Q?jUuZXyxDKeIaUd92IVb6ZD1mCumpfmYWXmvuZjTM7VFZ6amZyWaP+6Eb9wPu?=
 =?us-ascii?Q?FLuxMM3KXARup5C2Nz7KhWsYwVm8D2C2WHKdYCFHU3d/KSIG71/D2Bg3I0QW?=
 =?us-ascii?Q?z13v0v15igOgGkEqw5Lm/KjrntPiNcWqueGsTd5onjMhSWsP/uF8ANU1NiXU?=
 =?us-ascii?Q?qLfvm8v9EaOjGhBTXOifgD698pGOv5I4lp12lXieAsOkExApycrGqPh2vHhY?=
 =?us-ascii?Q?h4nc7ewi18GBQJNS05x+L8Sj+ES7cx9T4zpkzsaRNjSYY19Bl6CRdC+jqaE+?=
 =?us-ascii?Q?MoguuB0OMhTJ8O7p2gzoaT+V4mojcjRPdvitU+HbMFy0/2pmWBYC4OZrj7hR?=
 =?us-ascii?Q?rp8R8oZpjjXMYmlLl4DljbVXxxTxnUbtr7gUUtCfm6xBrMfjETRdMh3YWs0j?=
 =?us-ascii?Q?wXNKsboPgm5ACag6SV8sohWieeVls+UMTE2wstzonvxbUmmCqvTbYiKAVlql?=
 =?us-ascii?Q?bFiekTN4guzI1PoRAg9JMPh9oe1BF0nhU6GYS08ttwv1L+65W1McgvqDtWGZ?=
 =?us-ascii?Q?3BMTfsn2TDsGd4J0uLSCmc7s1tZdc4UBH2C2owYIqNZsy01H6zH+o9KUDJzP?=
 =?us-ascii?Q?UQPFRj2nQ5ijpQw1VNwTDWep5y39TKuKLqk+hMzoXZZuVkIukNtYDGhj2QAR?=
 =?us-ascii?Q?M3Nl61ZwLHhknPXXxnZPD6zZWKcO4L8=3D?=
X-Exchange-RoutingPolicyChecked:
	a9DN1hEaWIyMgWnh/bIeDojYXMkbS06+jLczrrLZTNa835K/ARZfJ/AL4krHP18c6AkApN7cnFAYiBWB/4uScctCvnSZZH3eWzQN2n8ZEQG6L3A9fT9TIcIM9ihMhhbxPEQZkKupTZWfqSeUB0KXWJYjCmEptM+NkqijJDT31Q5xWdFnBswSb0mSloMUlxCYQbI0Y/v9T2xyEL1sUC04Q+gwttmfE45lyROoJG83uRze2vsWXG3KSnIXrZu2ucBcKnxZ9yh3Xpbu8GDTjhWMkGYIFdedzkfrRjPrv8lmx9seGSZSDFlNRZPZvjb5BV2a3yorKkfO7qPgh+sQTtePYA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91203486-b91c-42c1-c03b-08dec2de7a87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:12.8764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lr7ZsgyEyf/YJLMM6P0I7RGLS1Gng1q0arcgwEY7LdlA8kyZu9d8BbFUt6vIIt76ytTnzuBDcgOCvEA0g6p4TUnCgABMauIij9ePFLctHdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: 0J-_GDmHD5c84JkWmZBjZfj4vKW6YvjS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX+RZeY/NflEAh
 /CvTLiH1ujqhehzGK/3LmEudvMUNFccGGizrRueV7tfqsViTe3YxyaoFxojI324naZJFNG1tKgF
 jbUZtrxB54oSx5pl8Hs3zXaXVYwyj4bspUUFxyRBVg7J9ZsGAjrdk5xKk2WDpw3wyErL68IjcTx
 WQRPHdNQZA4WlzdbQFZrvp7++U/lLd3GIXxjPOA0DC9+s9Y4r1NDHQvhSJkzKuVgsAYA0r5gOES
 lVHfqnCHWS/gdCJyDfhIDOCpIkWPEv71Z/ym1dFHWlltHnls4NeJkP/MmQKoC62YNE9yfnIVexF
 luOKv30X/aKEhrWUBkZIbS2m76yQmo8duNcBdeQQ539FeosxGDUmwqWKSkRZhYvRAVYs7xlPF+L
 SiN9XXT2Kkk4Qvc+tC7VenfjlHW3940KmOxAUMD2m1k5SXPHacioyxu3zht82xclR7+qnU7guH8
 fW3FAO1ZHzf3c8cgU+Q==
X-Proofpoint-GUID: 0J-_GDmHD5c84JkWmZBjZfj4vKW6YvjS
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c24 cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=iv8FjvXuBy_B0R5LKVcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add Nvidia Grace named model alongside its hierarchy (neoverse-v2,
armv9-a)

Field values were derived from the ID register view that KVM exposes to
QEMU with -cpu host on an Nvidia Grace system.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/arm/virt.c               |   3 +
 target/arm/arm-cpu-models.c | 132 +++++++++++++++++++++++++++++++++++-
 2 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index b8695b9286..117033115d 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -4073,6 +4073,9 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v8_4-a-v1")));
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v1-v1")));
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("graviton3-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v9_0-a-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("grace-v1")));
     }
     g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("max")));
 
diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index 61d45619ba..230768019c 100644
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
 
@@ -160,6 +162,119 @@ static const ArmModelPropValue graviton3_v1_props[] = {
     MODEL_PROP_END,
 };
 
+static const ArmModelPropValue armv9_0_a_v1_props[] = {
+    MODEL_PROP("feat_BT", STR, "on"),
+    MODEL_PROP("feat_CSV2", STR, "1.0"),
+    MODEL_PROP("feat_CSV3", STR, "on"),
+    MODEL_PROP("feat_DPB", STR, "dpb2"),
+    MODEL_PROP("feat_E0PD", STR, "on"),
+    MODEL_PROP("feat_SB", STR, "on"),
+    MODEL_PROP("feat_SPECRES", STR, "on"),
+    MODEL_PROP("feat_SSBS", STR, "ssbs2"),
+
+    MODEL_PROP("feat_DoubleLock", STR, "off"),
+    MODEL_PROP("feat_FP", STR, "on"),
+    MODEL_PROP("feat_AdvSIMD", STR, "on"),
+    MODEL_PROP("feat_TS", STR, "flagm2"),
+    MODEL_PROP("feat_FRINTTS", STR, "on"),
+    MODEL_PROP("feat_RDM", STR, "on"),
+    MODEL_PROP("feat_DP", STR, "on"),
+    MODEL_PROP("feat_FHM", STR, "on"),
+    MODEL_PROP("feat_FCMA", STR, "on"),
+    MODEL_PROP("feat_JSCVT", STR, "on"),
+
+    MODEL_PROP("feat_SVE", STR, "on"),
+    MODEL_PROP("feat_SEL2", STR, "on"),
+    MODEL_PROP("feat_VH", STR, "on"),
+    MODEL_PROP("feat_XNX", STR, "on"),
+
+    MODEL_PROP_END,
+};
+
+
+static const ArmModelPropValue neoverse_v2_v1_props[] = {
+    MODEL_PROP("cpu_implementer", NUM, 0x41),
+    MODEL_PROP("cpu_variant", NUM, 0x0),
+    MODEL_PROP("cpu_architecture", NUM, 0xF),
+    MODEL_PROP("cpu_partnum", NUM, 0xD4F),
+    MODEL_PROP("cpu_revision", NUM, 0x2),
+
+    MODEL_PROP("hw_prop_BRPS", NUM, 0x5),
+    MODEL_PROP("hw_prop_WRPs", NUM, 0x3),
+    MODEL_PROP("hw_prop_CTX_CMPs", NUM, 0x1),
+    MODEL_PROP("feat_PMU", STR, "v3p5"),
+
+    MODEL_PROP("feat_TLB", STR, "range"),
+
+    MODEL_PROP("feat_BF16", STR, "on"),
+    MODEL_PROP("feat_DGH", STR, "on"),
+    MODEL_PROP("feat_I8MM", STR, "on"),
+
+    MODEL_PROP("feat_FP", STR, "fp16"),
+    MODEL_PROP("feat_AdvSIMD", STR, "fp16"),
+    MODEL_PROP("feat_RAS", STR, "1.1_base"),
+
+    /*
+     * V2 silicon may report CSV2=2 (FEAT_CSV2_2) per TRM page 392, but
+     * KVM clamps the guest-visible limit to 1.
+     */
+    MODEL_PROP("feat_CSV2", STR, "1.0"),
+
+    MODEL_PROP("hw_prop_PARANGE", STR, "48"),
+    MODEL_PROP("hw_prop_ASIDBITS", STR, "16"),
+    MODEL_PROP("feat_BIGEND", STR, "on"),
+    MODEL_PROP("feat_SNSMEM", STR, "on"),
+    MODEL_PROP("hw_prop_TGRAN16", STR, "on"),
+    MODEL_PROP("hw_prop_TGRAN64", STR, "on"),
+    MODEL_PROP("hw_prop_TGRAN4", STR, "on"),
+    MODEL_PROP("hw_prop_TGRAN16_2", STR, "on"),
+    MODEL_PROP("hw_prop_TGRAN64_2", STR, "on"),
+    MODEL_PROP("hw_prop_TGRAN4_2", STR, "on"),
+
+    MODEL_PROP("feat_HAFDBS", STR, "dbm"),
+    MODEL_PROP("hw_prop_VMIDBITS", STR, "16"),
+    MODEL_PROP("feat_HPDS", STR, "hpds2"),
+    MODEL_PROP("feat_PAN", STR, "pan3"),
+    MODEL_PROP("feat_ECBHB", STR, "off"),
+    MODEL_PROP("feat_SpecSEI", STR, "off"),
+
+    MODEL_PROP("hw_prop_FWB", STR, "on"),
+    MODEL_PROP("hw_prop_ST", STR, "48_47"),
+    MODEL_PROP("feat_TTL", STR, "on"),
+    MODEL_PROP("feat_BBM", STR, "2"),
+    MODEL_PROP("feat_EVT", STR, "ttlbxs"),
+    MODEL_PROP("feat_E2H0", STR, "on"),
+
+    MODEL_PROP("hw_prop_IMInline", NUM, 4),
+    MODEL_PROP("hw_prop_L1IP", STR, "pipt"),
+    MODEL_PROP("hw_prop_DMInline", NUM, 4),
+    MODEL_PROP("hw_prop_ERG", NUM, 4),
+    MODEL_PROP("hw_prop_CWG", NUM, 4),
+
+    MODEL_PROP("hw_prop_BS", NUM, 0x4),
+
+    MODEL_PROP_END,
+};
+
+
+static const ArmModelPropValue grace_v1_props[] = {
+    MODEL_PROP("cpu_revision", NUM, 0x0),
+
+    MODEL_PROP("feat_AES", STR, "pmull"),
+    MODEL_PROP("feat_SHA1", STR, "on"),
+    MODEL_PROP("feat_SHA2", STR, "sha512"),
+    MODEL_PROP("feat_SHA3", STR, "on"),
+    MODEL_PROP("feat_SM3", STR, "on"),
+    MODEL_PROP("feat_SM4", STR, "on"),
+
+    MODEL_PROP("hw_prop_IDC", BOOL, true),
+    MODEL_PROP("hw_prop_DIC", BOOL, true),
+
+    MODEL_PROP("cpu_revidr", NUM, 1),
+
+    MODEL_PROP_END,
+};
+
 static const ArmNamedCpuModel arm_cpu_models[] = {
     {
         .name   = "kvm-base-v1",
@@ -181,6 +296,21 @@ static const ArmNamedCpuModel arm_cpu_models[] = {
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

