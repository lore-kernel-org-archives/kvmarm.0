Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43C23264E9
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691056; cv=fail; b=llAvEZErICSqQ+NjRdiNfF0TF9Ecxd/xQBrF7OccBszF7c1B29tXl5hixT91EYZD6Hj+3HLSSPhD5zIMNQPCPYz1v/cF3hNl/Qd81EZnnj6ZzSXQXaZwz0uQYhFHBgTqEmVZuyw0Azh705fN+Azi5327WTcFoOoQ9g4sInwDYxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691056; c=relaxed/simple;
	bh=P50a9kbIFf7idWA53994KKkTiHkmSmvCnyjW62GhCeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tyAifM+r/FEnS5ICdCh45JrMGMTtCC9h23kaXleXRlHkkoTZbdaAYo94dPm1htLSoC7YXCBrDnm65vm0Q5bhIRHJBBWaa1XTUpRBBiJsc696e/rAEiyBvCEi39+T1zuy9jsNLIyh8EgKWmF+KRJwKNP0SplUKvaXj0Qrk1uaXwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=YsiK1ruw; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HEWS1fhM; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="YsiK1ruw";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HEWS1fhM"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGKfem738992;
	Wed, 13 May 2026 09:34:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=MNinJibHwoWXGXhfMhUkYF30JTL8RYpn8K2IodxM6
	/Y=; b=YsiK1ruwfSpXNEoo5M0uKcNVZI7+UeAhhFEc1K1JWql2ZGPfQy2jKk1ZN
	YhlHj6g1hfCuBY2X/dOqRFaDjcCUlr2xVx0op5KGSTRBr6Nb6/0wEg3Hw6yypw/P
	SkgnILZ8Q1EjPNYpHsBnyF32wj2Xu2tiZsSwRngXt7ApQBDEbKpemH8wO9z20Ji3
	eD9OxLZOUzJhF2Z89qoiJ2Fj3uAAqu03eGyodfUTN0QQOObtx+VFERIumLS3flcd
	32cijh0AWOucEqHJyFWwZc9paoJpr5zs2qsDXdpNjfy7r9BpbhO8mdmdat2eKPCL
	+SHdQFoxMaD8256iQKWDyN7ghwK+A==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020086.outbound.protection.outlook.com [52.101.193.86])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nvap78e-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g8+xhwOQe+ToKw+T1c9IPkL3sJemGRpYXsAoSzTu4ghUe8nlEOJzx6Pmqx96+WYPxVvtrodWbYck+xlbBYqz53zF7O+V4sK2cdZrfNcyzQvPtNRLAq9ZXlhQO5rfiUc3+HzSN1JQbX2cXjkDqYqVePDh75HzuvJATNQO123R4FB4ynqKQD1U2MogeCyShDigcSm0F5SeXsdovsa3QNRA7YwId0Nt+I/M/FGDuFUH9BnQCuU9uKFvhfiQiiHOHMZnbp5hnojS/L3ZwwrX2+D4HF+odRQF2rizjYYWbgZjco2CAP3k6GNha5caOzGauL0ZAo+4fWOZ+V4bzDK3Hu9gJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNinJibHwoWXGXhfMhUkYF30JTL8RYpn8K2IodxM6/Y=;
 b=XydovDjkgMxOcKhfQYGCWl/n1eEd6X+CChLHa0rwvJVz4c0BgzhHrzndI5flG2FkNNOLWRyvQUkjgixpz4gRZPqJ6eiAhCzqnMy7k1LnwT3W+7zpSwgZM2YHqJWnvQoqcsRC1mec4acyKmlWW9eWOLCUqyl2/1APLm0AO1lSiOStnr5fOXCmneC6aQqdyjhg6BWxLdksRhRPcev0BkT0IP/DfLYdNiN1X20kK7gKZEWgBU04NAkRlTB2SGSIw+e+zvU710T71Pi0ZtlVI2w7emMI8Y9qlo0+i3aEh+Ychg46OIwOh3nNqKC+wX+vQvMihbfRUYF/fOEUsRg4orqQNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNinJibHwoWXGXhfMhUkYF30JTL8RYpn8K2IodxM6/Y=;
 b=HEWS1fhMMy5ZUIeUSheSh+z66rA7qSEXtVpinn/soru5ba7gEx6O/pyPeMCtcYgnb7UifP4YGQj8rrKP84lsUYDgosQqyUdaCv/ybj3iTczV0Mj7h1qtPhlmNLVXpW6toqrjGEZA8lKrBd2E6j+7T3J306Jg9YfZC56Vrf+GYrruI8+fFomWIJt0YTOQpc0AZiwF8ykgE39cr3avlDfFlYDCf3cqoR2n13FN71u715PyfxWFBarCFsozGu6tVwHARJrvaElbkTpSIVEvsEhlmzJTkZ5GAp9Xb29nJ23oJBmf1Uw4s90Rg5Z5CPE24YuLsndWiycTLqhA6zh4o4Kf9g==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by CH3PR02MB9564.namprd02.prod.outlook.com
 (2603:10b6:610:120::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Wed, 13 May
 2026 16:34:13 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:13 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 04/13] target/arm: named_cpu_model: generate tables for Arm64 ID registers and fields
Date: Wed, 13 May 2026 16:33:47 +0000
Message-ID: <20260513163356.3033159-5-shaju.abraham@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 824193c0-f4fa-4bb4-c23a-08deb10d77be
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|22082099003|921020|56012099003;
X-Microsoft-Antispam-Message-Info:
	0Cz5yeqIey/hBlFuQiwZeBmHgRuzOfMEvYTsvaQJYPnjR4S6Ya44+pOCNsxFkM23kH0Gx/k0Oq+R8jo1fsQehY9S8XSpdZMzlWYD9dvfkZ0Ng8RZauhwxlQEed+bZ7tGLHKXht+KczQIgyXUmNgQOjzSVInREYgsSLpuBRU6ey7nYbh5Kvx075NjWalNGlyCwTRqv0bcJAX1WOzHb1mqgIkmVFAf+eLGRRqk92PtJjUWJClks8b+eoVHGNqfkeaRxfDvTnlxU73wjRzeHPvnGwLWhewMJTDt7fcWybKgaAkGZtDFlXyPcBgMfEVQY4YJe1qQn4eBySYulbcZjSaMQq907TXc9wMfUgg+6WxDywTXelz1jtvCHC/ro3mvJHKoP8iUvna3+MkZAHwPELKyYX87knEX2kSPVlry8JtPwvSH20Zz/UC385Tx0LmS82+LO1tRS7EGH3HmxkiehAmWmWNwssJlmSPtf2y+cYe0HYO5ty2DJoxHO9kPS4tVInM1AFKpS/QRYE0pYVXxw70dddwoeN17TCkkZI3LRS+h1yfwOyXdumS5KBl0GRP53pXR4uaqCKyUSMpV47oF5AXQ8BhJGAiw2cnyYqtolzCoHeZztJ0TSy5OAMf/pVvMLRWMYWGAqZveEWRf98W67sMc+7lCnUcoAx4vH4/uy2aJLcvgS3YX2feWAkxeVKXuj4KNLGjw22U5xH7pTbQRpCoMv1hdQgFuNLjBKC9oHT1R5Ko=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(921020)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7stOUQ1bTMcu+8GA4KD/ii0Nx5GLUiii+xIOHyrFNItNDSbuKuHk/qPlcv3G?=
 =?us-ascii?Q?1ypWx9acuWkOXR34aDOPTG0fTvkl4CWwFsrdTBku+U6wcOt+q6ruGDqGf+La?=
 =?us-ascii?Q?zsJ9VzTNKLZGcSIqAB/FSEVQrUACVVIzQrz3f3HkZnvn5IXHNBVwLDqpgMeM?=
 =?us-ascii?Q?ayygMtWPyWVAliOw2xb1tKO65mfODbHDRg7/ZO3v9Ich/4hdUG5mJyPx12GA?=
 =?us-ascii?Q?1yDoFWdDl8K78+klIygDQAq6j47WUC1PqHmQAYuiSBOiMn/82qrOkk0gOg+v?=
 =?us-ascii?Q?D/P8qMZcGE7eN2jgKAmdfTEXHRNfZYZ39dBYHDAnlrIQ7SgJIcflIt58+NMK?=
 =?us-ascii?Q?O2wl2ZUCd6kOE/vKPe1gZdlFfpm0tjjtcYJJsx8LPuvcx7fyZSOJBEqo2K8j?=
 =?us-ascii?Q?lHx03RUWbLwL6LJpGdqoPsbvgwaj73eAUCweJ3rGs1FZBOEjk0zCn6P7S+5m?=
 =?us-ascii?Q?b/OXUHIzK6leykGiiChKf95D6T4V+Dpek8s/lAehkr8IhQ9CiOStJfPKDti3?=
 =?us-ascii?Q?ISM5Fg0ZwBtTyVk8+VFmuOBQfpn99QeD3aKtRGGcwB0eotVs281/nCCm4wqy?=
 =?us-ascii?Q?+P9jPsOGznkg3DVHYjB3r4WJyB8PlClzAUlwpMV6pfuY3XKWY5z8bGbovZP/?=
 =?us-ascii?Q?zmwL5jUWjiP8quyjpanhSYPqfgTVJN0qVxzOR1ZYMu7m/KqRUzri2cKX1/XI?=
 =?us-ascii?Q?n6h1596gSDtiXiVouBVv2YTvIr2JMnNNyirjoymZleXCXBNdK2P6A+JViHiX?=
 =?us-ascii?Q?rCnOCBNOI2gjoJERVBkDwfvUMVKL81CcIPjxWDjiO7vPBVRNHy4ZXA7G3FY9?=
 =?us-ascii?Q?LxusOsziEIC8GA9CtB+7dNzZy1dq0vw48oYt6fiG9UkmIbDK0/S9shuXY5Dl?=
 =?us-ascii?Q?kX6lpaYOwMaLJJVHavQ/g+X/nnBJv37RjGQuarmY7Cewza6ZGd9aVJyWHAwb?=
 =?us-ascii?Q?8clVGW1f0+ELf6MNokPPMIKTfem3nEE2QSljHxLAwf8qRnZXGTe7qQLJxbaB?=
 =?us-ascii?Q?fX+IRBDkqFVL6MLDrvFNxstHauIBMFblJ5GFj4pnc0xCF1SLM5c9InemYYbU?=
 =?us-ascii?Q?lL0mvJnCJLaCPzDEmMJ+1wHZ0+G/0sFS3O6Pco3trzMln1Ll0k6B/n4wGSPT?=
 =?us-ascii?Q?ZxwzvOTfPla9NpU9qQhULszoULgn9xRU2oa2/q1BjKhT8BMAjVQQ+iX6xT34?=
 =?us-ascii?Q?Hwrdt1BlAWWAc0t+ZSWxMEx7kMyYR+K+ydzAbcXwLuZwoSjMWXJbrsbxGhvC?=
 =?us-ascii?Q?dEN+YCd9SZRbDdx53ZERtaAf4RfX73f+YaczSbyZqD7RshB48a6l304Rnh7d?=
 =?us-ascii?Q?mc3T0U4HoQgfERkpS5GduX8xBBtSG4dG3v+9Y4zXGEgigDRar45IKngd1sQt?=
 =?us-ascii?Q?NmNnXPuIGlrVTRSdAL8m5mK7XOuRAnTlyLfQwAadgJH7bQPJYR70FHJkWQha?=
 =?us-ascii?Q?8HzafBRP2PhESU1QkNeG945iE8QKcWVXUunzjsdo9vE8xXaAAJovWfkFxcgO?=
 =?us-ascii?Q?wrDbm4rrRGz5f/oeBozo82KIJl8OV4RsxgWi5yKu3s5GmpLUWB5FHp1+I44L?=
 =?us-ascii?Q?PeJSEmvhvHDdE3Em2UgLq3tmu7U3Lk5HnzhNjLG+bTgjBxMWXecQvRdOPXpN?=
 =?us-ascii?Q?cgmWknVxIf5O8LNHIWZ0isVRNtFMCFbMQY5yXJULqCznh53BZKNMZi5nlXwg?=
 =?us-ascii?Q?6JKHERNut8m9dqIjIcgKntT0xRARtWsZjJQ8Qhda8Nget6+JhBxKyNxmbIFN?=
 =?us-ascii?Q?0AmlA/7jGosqEcCnM7UNKcFHqAc0WdE=3D?=
X-Exchange-RoutingPolicyChecked:
	DHO3kEKaU7tbs9mtx2F6K0XYJPi8ewHxxUqWCGhxYs8OPrQmQbOh6I2qdOGTRANbVp7pF/F7XqqrGE2aqL8WjbvnxCdKAB8akEATAKzoA7UC9i4t6pnfvWMnSOPmx/sA/S8PiT4cVI3Niui78PU6MTAcreaN+TfxbXnPHffcO59jIvtTmDi5vYTv2dcrnWgTwc/OYKE5v5OSCqxujGjz1owdM938TknqCf3HayWxzEeMaUqSz1AXwOmsWccNS7iYDQ63kxZAWAVZ4/tKyoNSK+pcxbK4YNTqdw92pjIPgDtBUbEZNfFfCqXmgOuUnQQGNZgz5MH8k0XtJoafjms5Eg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 824193c0-f4fa-4bb4-c23a-08deb10d77be
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:13.6572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LPXEZWtZ/lseOWXsJY9O1x+Ife5F2dqswdbwicgBVzz1RkKCAD7jRzK4InDBZ4WRCWuBLCtQ+Dede8XDoQgE0SCZXZa+mwsO/mp9ggnIHSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9564
X-Proofpoint-GUID: WcYQlPoPtYk2FBTq5u6Kvj31mw5Tn9QL
X-Proofpoint-ORIG-GUID: WcYQlPoPtYk2FBTq5u6Kvj31mw5Tn9QL
X-Authority-Analysis: v=2.4 cv=apaCzyZV c=1 sm=1 tr=0 ts=6a04a807 cx=c_pps
 a=Ju9Zey7g8YyQpP5MZaDBLg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22
 a=64Cc0HZtAAAA:8 a=PaGUs5NhgPxOKxUa52MA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfX3em7pHyv0TDu
 xkpRGfWT4Bmo8HOV2hVKiO5x+9Oa40JB1M94DAPyVuWO9CeTy2Rn7L8IRZ48a5lBMmFYHDcQ8Tv
 DYuYlNoGY14qdgn92cz7Vc5NBUvqxECn+8flGBeUpqm+TGMQHm6dMTeX9q4lbG5nbRFSFSkaUI8
 pYXRF6FQ6V3o+SBpISnmzokg//+zAbdvSzGZaL6vlhP3RaMo+QQdofE3QBA8qOfPrOOuo77vCqD
 g2DYVGwHwUAK4066kTvVM+nVrQrTLVdh77rBjWFVyvT4jui39wLVQC3Rm2ptHg15M3cLMCk5zbs
 DNuEeZwaQMOrklhThpbW69diO9kUaEOpw/e8+VgNrgvPQOTR3V9wZJIFYLBq5H8+A27BLKnrIpj
 Fz0LqdFT85BfsUA5Lv2XMuN1+d8377zONqtsLOseEbTLwtNR4cPJTjkCInnxmrbMbKme7pqGhxt
 9euaR1SCz/UN3E05BJg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Include cpu-idregs.h.inc multiple times with different definitions for the
X-macros. This will generate tables for all Arm64 ID registers and their
fields. Additionally, initialize the tables with all architecturally defined
values. These tables will be consumed by the property layer in future
patches.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
---
 target/arm/cpu-idregs.c | 124 ++++++++++++++++++++++++++++++++++++++++
 target/arm/cpu-idregs.h |  81 ++++++++++++++++++++++++++
 target/arm/meson.build  |   1 +
 3 files changed, 206 insertions(+)
 create mode 100644 target/arm/cpu-idregs.c

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
new file mode 100644
index 0000000000..8fced7d8d7
--- /dev/null
+++ b/target/arm/cpu-idregs.c
@@ -0,0 +1,124 @@
+/*
+ *   ARM ID register field table.
+ *
+ *   Builds the per-id-register field descriptor arrays and the global
+ *   arm_idregs[] table.
+ *
+ *  SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "qapi/error.h"
+#include "cpu.h"
+#include "cpu-idregs.h"
+
+/* generate an array of architecturely defined values for bitfields
+ * in arch-value format*/
+#define IDREG_START(reg)
+#define IDREG_END(reg)
+#define IDREG_FIELD_START(reg, field, shift, length, safe, defval) \
+    static const ArmIdRegArchVal reg##_##field##_arch_vals[] = {
+#define IDREG_FIELD_ARCH_VAL(v, n) { (v), (n) },
+#define IDREG_FIELD_ARCH_VAL_ANY   { 0xffffffffUL, NULL },
+#define IDREG_FIELD_END(reg, field) \
+    };
+#include "cpu-idregs.h.inc"
+#undef IDREG_START
+#undef IDREG_END
+#undef IDREG_FIELD_START
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_ARCH_VAL_ANY
+#undef IDREG_FIELD_END
+/* generate an array of per-register ArmIdRegField[] descriptors */
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+#define IDREG_START(reg) \
+    static ArmIdRegField reg##_fields[] = {
+
+#define IDREG_END(reg) \
+    };
+
+#define IDREG_FIELD_START(reg, field, _shift, _length, safe, defval) \
+    { \
+        .name = #field, \
+        .shift = (_shift), \
+        .length = (_length), \
+        .safe_rule = IDREG_SAFE_##safe, \
+        .default_val = (defval), \
+        .arch_vals = (ArmIdRegArchVal *)reg##_##field##_arch_vals, \
+        .arch_vals_count = ARRAY_SIZE(reg##_##field##_arch_vals), \
+    },
+#include "cpu-idregs.h.inc"
+#undef IDREG_START
+#undef IDREG_END
+#undef IDREG_FIELD_START
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_END
+
+/* generate an array of top level ID registers */
+#define IDREG_END(reg)
+#define IDREG_FIELD_START(reg, field, shift, length, safe, defval)
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+
+#define IDREG_START(reg) \
+    [reg##_IDX] = { \
+        .name = #reg, \
+        .fields = reg##_fields, \
+        .fields_count = ARRAY_SIZE(reg##_fields), \
+    },
+
+ArmIdReg arm_idregs[NUM_ID_IDX] = {
+#include "cpu-idregs.h.inc"
+};
+#undef IDREG_START
+#undef IDREG_END
+#undef IDREG_FIELD_START
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_END
+
+
+/* Per-register field position enums (0..N-1 inside each register). */
+#define IDREG_START(reg) enum {
+#define IDREG_END(reg)   reg##_FIELD_POS__MAX };
+#define IDREG_FIELD_START(reg, field, shift, length, safe, defval) \
+    reg##_FIELD_POS_##field,
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+
+#include "cpu-idregs.h.inc"
+
+#undef IDREG_FIELD_END
+#undef IDREG_FIELD_ARCH_VAL_ANY
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_START
+#undef IDREG_END
+#undef IDREG_START
+
+/* Flat ArmFieldIdx -> {reg, field slot, shift, length}. */
+#define IDREG_START(reg)
+#define IDREG_END(reg)
+#define IDREG_FIELD_START(reg, field, _shift, _length, safe, defval) \
+    [ARM_FIELD_##reg##_##field] = {                                \
+        .reg_idx = reg##_IDX,                                  \
+        .field_idx = reg##_FIELD_POS_##field,                      \
+        .shift = (_shift),                                          \
+        .length = (_length),                                        \
+    },
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+
+const ArmIdRegFieldLoc arm_field_locs[ARM_FIELD__MAX] = {
+#include "cpu-idregs.h.inc"
+};
+
+#undef IDREG_FIELD_END
+#undef IDREG_FIELD_ARCH_VAL_ANY
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_START
+#undef IDREG_END
+#undef IDREG_START
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index 403190cbd7..4e568e877d 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -7,6 +7,8 @@
 #ifndef CPU_IDREGS_H
 #define CPU_IDREGS_H
 
+#include "cpu-sysregs.h"
+
 typedef enum ArmIdRegSafeRule {
     IDREG_SAFE_LOWER,
     IDREG_SAFE_HIGHER,
@@ -37,5 +39,84 @@ typedef struct ArmIdReg {
     uint32_t fields_count;
 } ArmIdReg;
 
+/* Map short register names to canonical _EL1/_EL0 IDX values */
+#define ID_AA64ISAR0_IDX  ID_AA64ISAR0_EL1_IDX
+#define ID_AA64ISAR1_IDX  ID_AA64ISAR1_EL1_IDX
+#define ID_AA64ISAR2_IDX  ID_AA64ISAR2_EL1_IDX
+#define ID_AA64ISAR3_IDX  ID_AA64ISAR3_EL1_IDX
+#define ID_AA64PFR0_IDX   ID_AA64PFR0_EL1_IDX
+#define ID_AA64PFR1_IDX   ID_AA64PFR1_EL1_IDX
+#define ID_AA64PFR2_IDX   ID_AA64PFR2_EL1_IDX
+#define ID_AA64MMFR0_IDX  ID_AA64MMFR0_EL1_IDX
+#define ID_AA64MMFR1_IDX  ID_AA64MMFR1_EL1_IDX
+#define ID_AA64MMFR2_IDX  ID_AA64MMFR2_EL1_IDX
+#define ID_AA64MMFR3_IDX  ID_AA64MMFR3_EL1_IDX
+#define ID_AA64MMFR4_IDX  ID_AA64MMFR4_EL1_IDX
+#define ID_AA64DFR0_IDX   ID_AA64DFR0_EL1_IDX
+#define ID_AA64DFR1_IDX   ID_AA64DFR1_EL1_IDX
+#define ID_AA64ZFR0_IDX   ID_AA64ZFR0_EL1_IDX
+#define ID_AA64SMFR0_IDX  ID_AA64SMFR0_EL1_IDX
+#define ID_AA64AFR0_IDX   ID_AA64AFR0_EL1_IDX
+#define ID_AA64AFR1_IDX   ID_AA64AFR1_EL1_IDX
+#define ID_AA64FPFR0_IDX  ID_AA64FPFR0_EL1_IDX
+#define ID_PFR0_IDX       ID_PFR0_EL1_IDX
+#define ID_PFR1_IDX       ID_PFR1_EL1_IDX
+#define ID_PFR2_IDX       ID_PFR2_EL1_IDX
+#define ID_DFR0_IDX       ID_DFR0_EL1_IDX
+#define ID_DFR1_IDX       ID_DFR1_EL1_IDX
+#define ID_AFR0_IDX       ID_AFR0_EL1_IDX
+#define ID_MMFR0_IDX      ID_MMFR0_EL1_IDX
+#define ID_MMFR1_IDX      ID_MMFR1_EL1_IDX
+#define ID_MMFR2_IDX      ID_MMFR2_EL1_IDX
+#define ID_MMFR3_IDX      ID_MMFR3_EL1_IDX
+#define ID_MMFR4_IDX      ID_MMFR4_EL1_IDX
+#define ID_MMFR5_IDX      ID_MMFR5_EL1_IDX
+#define ID_ISAR0_IDX      ID_ISAR0_EL1_IDX
+#define ID_ISAR1_IDX      ID_ISAR1_EL1_IDX
+#define ID_ISAR2_IDX      ID_ISAR2_EL1_IDX
+#define ID_ISAR3_IDX      ID_ISAR3_EL1_IDX
+#define ID_ISAR4_IDX      ID_ISAR4_EL1_IDX
+#define ID_ISAR5_IDX      ID_ISAR5_EL1_IDX
+#define ID_ISAR6_IDX      ID_ISAR6_EL1_IDX
+#define MVFR0_IDX         MVFR0_EL1_IDX
+#define MVFR1_IDX         MVFR1_EL1_IDX
+#define MVFR2_IDX         MVFR2_EL1_IDX
+#define MIDR_IDX          MIDR_EL1_IDX
+#define REVIDR_IDX        REVIDR_EL1_IDX
+#define AIDR_IDX          AIDR_EL1_IDX
+#define DCZID_IDX         DCZID_EL0_IDX
+
+/* ArmFieldIdx: per-field enum generated from cpu-idregs.h.inc */
+#define IDREG_START(reg)
+#define IDREG_END(reg)
+#define IDREG_FIELD_START(reg, field, shift, length, safe, defval) \
+    ARM_FIELD_##reg##_##field,
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+typedef enum ArmFieldIdx {
+#include "cpu-idregs.h.inc"
+    ARM_FIELD__MAX,
+} ArmFieldIdx;
+#undef IDREG_FIELD_END
+#undef IDREG_FIELD_ARCH_VAL_ANY
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_START
+#undef IDREG_END
+#undef IDREG_START
+
+typedef struct ArmIdRegFieldLoc {
+    ARMIDRegisterIdx reg_idx;
+    uint16_t field_idx;
+    uint8_t shift;
+    uint8_t length;
+} ArmIdRegFieldLoc;
+extern const ArmIdRegFieldLoc arm_field_locs[ARM_FIELD__MAX];
+#define ARM_FIELD_REG(idx)       (arm_field_locs[(idx)].reg_idx)
+#define ARM_FIELD_REG_FIELD(idx) (arm_field_locs[(idx)].field_idx)
+#define ARM_FIELD_SHIFT(idx)     (arm_field_locs[(idx)].shift)
+#define ARM_FIELD_LENGTH(idx)    (arm_field_locs[(idx)].length)
+#define ARM_FIELD_IDX(reg, field) ARM_FIELD_##reg##_##field
 
+extern ArmIdReg arm_idregs[NUM_ID_IDX];
 #endif /* CPU_IDREGS_H */
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 4723f9f170..64d1ec63ab 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -19,6 +19,7 @@ arm_common_ss.add(files(
 
 arm_common_system_ss.add(files(
   'arm-qmp-cmds.c',
+  'cpu-idregs.c',
 ))
 arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
-- 
2.52.0

