Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840DB450904
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649043; cv=fail; b=Sd993CV5r5EtwHR/gHZ3ssy2Ufqsi9RVpjbkCsBWBkq0tM0ZYbIjdmNwbsoZbH/8PiAozF3jRobGrEVgjWSUIMRwrEBIGrLcA54rVkHfu4QPbGKd3lkx+2+XXF1NUkt21lzbYPTQFqxXEIU8tDN9I28xFaFPz25o7fUoqY7qpi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649043; c=relaxed/simple;
	bh=suEuZgpg/5W7I++EXbuZmIiBfwCIRzCwmiSJC/uSVqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UAyKIDdbQimCW+duwrEh5dvMVYoBeS+tmOoFkIGs/qNrVwgYbgqSjsBse2P0fLSuNv50ux6HjEk9YvFL+P3mlmXG0DaJ4M3XBoxYo+ECPWbM3gQ38rM1RdeKpq722jT8cZYv9ikP1HAD8+RfXdeLKqIdiN2NrdYGpPjVpMX3/rU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kuJM1r7V; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MojjiTyO; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kuJM1r7V";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MojjiTyO"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556MRUK1185382;
	Fri, 5 Jun 2026 01:43:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Bl1gX69df4ZB/iIlHCv3xsE1nTKhb51JIqHcxjzMK
	4E=; b=kuJM1r7VS5t6Kh/3yLvXmxdgKHyraqX/0Lhuglnp2NDl66iLKPjwGQMXN
	dQnp4yX3DKtEeL5hpsdRGLuXWI56P86gnklekMQoYHaXy1qAKJD2MgwVegkRatO9
	FQJ7/Lk1WaUSHKjCxqLyVmkRO5M8K56iTLMpcFRBSTVvytvvrxqWh13aZp69Ds6M
	YYVoHd05cykHmvg8a50f/xM5s9KdH4i/GhzkV5RKrgP3xeC80s15qwTB+bl7EUG3
	wEVSFPHd0CBtXGwKEKlYz8bvC67ULA3/iCj42AbCiaRF0XRO4cGm2S+uxmIjHoOd
	2FIKfSri7cz8+CDcajUa+HVAyYrLQ==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejuupcm1f-6
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PVb7ss1MPaS7HnVpZeTjnP5bzNQQrhe8Nmxkc4No6oCLD0HoaHWtcfeAgFrpcCbwuI4E/MGZ7wTKnh6TPaG7p9TaN4MKnn9vUm1KvJedkoX4JUPTmD5yrrai8eaiOmLte/NYl8Yiax5W6EhqUIsWNyPyj8SHnGRkgcPPZhXj+Z1FcB8wydMKJzirfUcnpoOrApxPRzjW67W0PoFF3zl2FZj0dilDAf0tZX3EIRP5zf2qAxlhoXG6xLnrAp2rqoes8H/9RBKy10N6P+ZhdE3W5DR7z+zUN0sI+kw6FAVHOanCtoKYGrPMO28NxpxEH9MH/x4lb5GMIJL98BrjMak6LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bl1gX69df4ZB/iIlHCv3xsE1nTKhb51JIqHcxjzMK4E=;
 b=c5eEumGscoZNV2M7BLJdnQ29fSQPxVP4vH6E+iTdhFZ839smSLwnN5ypiTcMNQRsdn5SNSucSyEgJkMEI6tefPM1gB/udxQFgoDnO0ASdyvy/fFbtyDT2a8OVqJheF3La45OMbqfpRI41PIew31e2xfUqVgEqzQrcpvvbgKa+M6vJEKE6Qz7FdXq0CQ3k2q8bMVUGgfmu6/7zkR/Lb6hKwB3VciHlv6GXc0vnECHH/MJptiY/AU1De5FuLUGxMTKuuBFNr95N5a+TGet74NiJ8tgmc5WNjtP635t5my1XPWlceb46yrajd6ooEmxmqmEnktFB5kx6m7ngzIFZA9H7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bl1gX69df4ZB/iIlHCv3xsE1nTKhb51JIqHcxjzMK4E=;
 b=MojjiTyOQWo6nLGfUp71fk+MMJ8w27hWQWkQaHgCWVI4/nYNlOZzrkAt9tlHelwOvb0E7NUjNShZpejbZUvgDV8L4+GPrrqB7j130W+0EmtdWL1ncQmL0I2PBCPmIhnvDkpq6GW1f8835fNj87MDCOgT0rQg6iiuneRUqkv0xw0/vNwFYjcH5UFx21H3sYMKBImczP5nk85JCEdQ5aQWzUOV0oCm69Ks7gmHVOEErvvDgV75e8swe5hau6gpolFTQzdP8jysio26p4LQC5UPmrOnJSDcGdUeeej/JawdQF6GheQboYcNYz8ANXHGzUqI2XXXLC3ostOm9SDLxMzEpA==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by MN6PR02MB10630.namprd02.prod.outlook.com (2603:10b6:208:4f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:18 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:18 +0000
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
Subject: [RFC PATCH v2 23/29] target/arm/qmp: add query-arm-cpu-props-info
Date: Fri,  5 Jun 2026 08:33:52 +0000
Message-ID: <20260605083358.1320563-24-khushit.shah@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|MN6PR02MB10630:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c717583-2664-4a92-768f-08dec2de7d5d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	osGfaB6YuP/iwapxPYanswy1oObvybG9Bfh/hvXmi9y8DtoCmaA3im18EmhnCJm5tQb4r5OIx4YSKNfHJy9Kw3pwxk5RgOLKfDsNv0Y4qxS2HtlITH0yekUQTdwL4IOUUHD0ex3Sra9Axq03UC6mqUJSFLpIR7rbqbEwIwbT4fxfvafvqf0lE+VGGz4bcse0KMHTUmFQMqMtpdHcL9+0RzKyeydYe3LQ4k+yq1V9sHVMv9WvKBk+i6f/SeQhqrNm+wRMTw+Q8GKlBVoJMDz8Yoycf2zp/JUij9gpPN7eaAK8iq9A7Kw6N2qnJBdbgz8CLLpqapLtofNJM6w3RT9Aaet43dSfktLZcPouXKSKzN8mK68Q72LLDTBmaA1mSv5+KG51r/mXdSosununZKIpnk7iLYetD14hjYTZ2EuFqBrnxGkD2vY3O+xyUGod6MfVXQ0x/h1ks2bXQMxR9NtfENnFFuYSA4fw5SG2xfmcCqrWzX2F/8iZVYggAsnjq44loXETiSJ1urRR/Co8HomazJZ0/e/yyI9FHeBhjfiqDD6YwgSKtANbLKXZ/L4V4vnRfeHyrj3cO5XI044qblYY/R69tNRKy+179OXqjpw6oLJEiAph0LFMV/BHNeEcYsRJhjr2WR4lH6MDYCPBRiPpFt8odLMk9GJIP7sfmF3OOwiaVcIgoqWJ7AdmNBzuQ8Tc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ab4oorDy2BXD1swKLERIleYQShYhJNUuxXmDK7I+LrUEtJfQpldYEU1Gou3f?=
 =?us-ascii?Q?fNpwGA1GViZEvX8mvkM8JjzYN5M7p118g0u2eBR9uuUsI4OIf3JMS/O/c5JH?=
 =?us-ascii?Q?dg8jxvxw5l+2AxdDlZT9mpj6vOZWpsZ0NBRnV7jZC0mS45yhTRDwndxDAaNH?=
 =?us-ascii?Q?pQ/Fa54TH2PJa7AeYkymiOlmX2vPA8V+DmW4GuYpskbaRdjLS3gSnrFaCVzS?=
 =?us-ascii?Q?HWrEIaFUsZhyrb7UdUaHD8TUGkTH/7dYoxbXqGlMSPIH2K4eWByeEcr1qw/A?=
 =?us-ascii?Q?AR/tVCAggVXMHb1yqufJgVkBZG8FfrV05cWW5PUZQZxo0bEaNAy/bTzcX82t?=
 =?us-ascii?Q?Tt2/d7lCWmccFEAXm9dz3liEEhYsEsRsfuR4LkfpVDkF+ncDDfAmu7b1ktvH?=
 =?us-ascii?Q?tupFdkY3S39dGDg8wDqjv4sIgxvboxV+GcwK6NEPqKk2ZhZYFbOfGLcngVQZ?=
 =?us-ascii?Q?WghUfY2RV1OUo0UgEVHO3hfJ0vOrbqJegDERzKZKaU4u4PJEgKMdt/lCHr5z?=
 =?us-ascii?Q?mSASZXCynW42vJpS0kwBMHxUiunOGfdcJ2m49absOkndebUPfmS9kC0IN3bn?=
 =?us-ascii?Q?9QSwamtkEWkj5PHqSX3muZ0MPcEV5YDgK2ImgrH2PFg0V8oTvFI4sI6hGub2?=
 =?us-ascii?Q?IPCzmv1S9/lO1igglUpmoEd3utWyLyleydi42AX433GIx1hyYY2GFrrqFCug?=
 =?us-ascii?Q?U8yzEQQjLtNdIVXXJmv5HXD7/QdoM0Al6n4dz5ua2wIPLXSCu93181neP/XR?=
 =?us-ascii?Q?LQq+lLHyj7J3bE7ZmkbbUHyB08pn+9t7cEMtrEgTWd26NAIHDqGKHBf1g1yc?=
 =?us-ascii?Q?OTjqu8fyy4O+Egvl68fsttJeqM+J9OxlZDifGEaKfJPG0sM8kzfPz82xHeHP?=
 =?us-ascii?Q?xedQ3X06R3+90E7daSrMQ9NqLu85M61Bwkj3yJfWqr9erEto2xceJnmSmW8k?=
 =?us-ascii?Q?H08XQ17TF0SiiuwW5WHeUQjWxsrisZwexmJWm+1qbLUOdJTyIqy5THnXY6uC?=
 =?us-ascii?Q?UAVg3d01H++vhPY78vHZgGydEdXRUnFY7KU8+4FLg9XxMHE2mGEJVM3hka6V?=
 =?us-ascii?Q?FR0BAr31s4Oh2nleloZRiB3pMGhoaakhg25z1j8kWfW31AWFLlbLaxo7prSR?=
 =?us-ascii?Q?AAve6ONgtWQ3Cz+PsfIAKHL60Re20MKV64pNzHC2SZJzwl/YxObhwRFZiW9C?=
 =?us-ascii?Q?BU3qLuQ4hcPunrSXgU0hc+Rt3BjNoRMCqY9I4Ny/MWPRVNAUs60uTv5rfbPu?=
 =?us-ascii?Q?ECs0M5lnZ7Jac93e+SKQn975bDOa66eTnJ+8OrYb8AE/ynNJL2E9sKPbj3Kx?=
 =?us-ascii?Q?M2oiDcQ4a9lJM32bFjV/6it/gj+jEC0A2SFS8eZ6apjLPIF7EMAHAnTXHWCH?=
 =?us-ascii?Q?7EHFe6URSKSQdTpQi6dXthBtjCTjy6rcXzD0cEnvYh8lzx7AJ/2lBPDmakG1?=
 =?us-ascii?Q?3v8tzW50jKX7mntYpCYWd2EIJe8oDjYhkdSatmrOehxKsqjZkCuI79u9v1Lk?=
 =?us-ascii?Q?GX3aX7JNLh4JJ+KDLH5NTaUK86V4/4txfwCWtV0H+zlEMbNwhN1RUixI7nhg?=
 =?us-ascii?Q?ybrn4Dx92nIW1F50eieTn7z1J6ebCCXZiH+m2OkF58icEI7l8dwAeLPSbC2E?=
 =?us-ascii?Q?/HBiDyta7njbVarkgxknfdNJkrFaWzW+KaVmWW45uTa99QXQ9X/6f0XCZS2+?=
 =?us-ascii?Q?0gvE+ol+nk3Lo6ps2N2GmpukcetCqQ77KMihtGsk2OKcbeWNbkiiHxSb7EFS?=
 =?us-ascii?Q?o9aYiMqjz2DpG2jbAAoEo/sA/bsS6RE=3D?=
X-Exchange-RoutingPolicyChecked:
	SGFYd15724APWsjKDDe5gtlIURPWEs8PdqQKGE8vAJ+vYcpxhWAg5/HAHH/0Tr5S/RepkZsXxmujXKgU6HAuyxqNBMR3QUs9jSZGY1FhdPw28S1u+jXJtkR3qR+nv9/IiTIPkHuNa8SlSjDN9ITkbEdxFuutOj73i2cFh3+Os1tUe/vf6HNBwcVzX8XLmMqTOe665/el2apZI1r5WdjW5FAhOc4pYiYHQS1hwROt4Pe6ObUYOimwnj/HV+symQWVW1UYCfoQE25FwRvDeNTf7Rg6O94+WTQKkFv00E5h/WYiJ4gJp2iASdXJrzyS/MqCaTfj7hEMQDUgcz2RDFMn0A==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c717583-2664-4a92-768f-08dec2de7d5d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:17.6352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 37GXTi229smBuqPzoy8O1eds8F90Za2lCaRXLqnDarTO8ZfVM3Hsazeo6zTYvWuizxxGG145szBbr096DxLtd4X51yFzjsz0gV+t/qhesPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfXxLdCvC6hmHlu
 Hu+FfpyvKuKFfYj+roJUEhKddEOeZGV76Q2gGYESqrIriU/k8z6cmJpnYV434ijQQVUXjRYD9bU
 SVxA5lqBjJBNLfFO2QaAgfo+wfujQqZm6hCira+WlOzMepBCrrZnhNZcwBrrERlg+MCoAt/5skM
 bAVFJYeeDKmKQHl4OtNSJywdX3CQbTos4raD/vF3OKUHOOOZC8RNdmdtFq1HV37tLWSXymclp0A
 NCcD50XyFl6LxXuRM8dN+FqUCDSBWsV3pIEmkG4u+DnX1v5AVPCOI7jzjsQcVa2Nhv3keoZ9Fb1
 lzQkfvu9gpJHlguze/nXoS5ZsPFrarw1LBGMSXQvp3UsmUBZnLxYQ76Zj6akkIii4yBw8z0WmWR
 h6IGShrdirQ9hmr3oqrVKWJZXysGIp2I3b9XxOSrGNkocH+3HQHkMGVkK55SpckLvchurveEdo4
 izWLbZ2iqaCQl2geflQ==
X-Proofpoint-ORIG-GUID: kdxogiOAZptr4RxW0CDiYBK4TXFoOd-A
X-Authority-Analysis: v=2.4 cv=V6FNF+ni c=1 sm=1 tr=0 ts=6a228c2b cx=c_pps
 a=h3Jk+6XEKCuoUZR+ZnWw9Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=lSHdJiwaTbx1X4x_e9YA:9
X-Proofpoint-GUID: kdxogiOAZptr4RxW0CDiYBK4TXFoOd-A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce 'query-arm-cpu-props-info' QMP command. This command returns
information about ARM CPU model properties, including their name, type,
supported values on the given host, and composite parent if any.

This provides management layer necessary information to determine
migration compatibility off a VM on different host.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 qapi/misc-arm.json              | 41 ++++++++++++++++
 stubs/qmp-arm-gic.c             |  6 +++
 target/arm/arm-cpu-props-stub.c | 13 +++++
 target/arm/arm-cpu-props.c      | 85 +++++++++++++++++++++++++++++++++
 target/arm/arm-cpu-props.h      |  5 ++
 target/arm/arm-qmp-cmds.c       | 44 +++++++++++++++++
 target/arm/cpu-idregs.c         | 71 +++++++++++++++++++++++++++
 target/arm/cpu-idregs.h         |  8 ++++
 8 files changed, 273 insertions(+)

diff --git a/qapi/misc-arm.json b/qapi/misc-arm.json
index 4dc66d00e5..1a3fb140c4 100644
--- a/qapi/misc-arm.json
+++ b/qapi/misc-arm.json
@@ -46,6 +46,47 @@
 ##
 { 'command': 'query-gic-capabilities', 'returns': ['GICCapability'] }
 
+##
+# @CpuPropInfo:
+#
+# Information about a specific ARM CPU model property.
+#
+# @name: the name of the property
+#
+# @type: the type of the property, any of ('string', 'boolean',
+#     'number').
+#
+# @supported-values: the set of values the host hardware supports
+#     for the property, a list of strings.
+#
+# @composite: name of the encapsulating composite property if any.
+#
+# Since: 11.1
+##
+{ 'struct': 'CpuPropInfo',
+  'data': { 'name': 'str',
+            'type': 'str',
+            'supported-values': 'any',
+            '*composite': 'str' } }
+
+##
+# @query-arm-cpu-props-info:
+#
+# Returns information about most of ARM CPU named model properties.
+# This does not include composite properties or properties already
+# defined by QEMU like (sveNNNN, pmu, etc), This only returns all
+# the newly defined properties like ('feat_*', 'hw_prop_*', etc).
+#
+# With this upper management layers can find out what property values
+# are supported on the given host.
+#
+# Requires KVM to be enabled.
+#
+# Since: 11.1
+##
+{ 'command': 'query-arm-cpu-props-info',
+  'returns': ['CpuPropInfo'] }
+
 ##
 # @SsidSizeMode:
 #
diff --git a/stubs/qmp-arm-gic.c b/stubs/qmp-arm-gic.c
index b3429243ef..1691401bf0 100644
--- a/stubs/qmp-arm-gic.c
+++ b/stubs/qmp-arm-gic.c
@@ -10,3 +10,9 @@ GICCapabilityList *qmp_query_gic_capabilities(Error **errp)
     error_setg(errp, "GIC hardware is not available on this target");
     return NULL;
 }
+
+CpuPropInfoList *qmp_query_arm_cpu_props_info(Error **errp)
+{
+    error_setg(errp, "ARM CPU properties are not available on this target");
+    return NULL;
+}
diff --git a/target/arm/arm-cpu-props-stub.c b/target/arm/arm-cpu-props-stub.c
index abac29ae50..1d0a3f676c 100644
--- a/target/arm/arm-cpu-props-stub.c
+++ b/target/arm/arm-cpu-props-stub.c
@@ -11,6 +11,19 @@ const ArmCpuPropDesc *arm_find_prop(const char *name)
     return NULL;
 }
 
+void arm_prop_append_supported_values(const ArmCpuPropDesc *prop,
+    const ARMISARegisters *host_isar,
+    QList *out)
+{
+        return;
+
+}
+
+const ArmCpuPropDesc *arm_prop_get_composite_of(const ArmCpuPropDesc *prop)
+{
+    return NULL;
+}
+
 static const ArmCpuPropDesc empty_props[] = { {.name = NULL} };
 const ArmCpuPropDesc *get_arm_cpu_props(void)
 {
diff --git a/target/arm/arm-cpu-props.c b/target/arm/arm-cpu-props.c
index 94672040c5..dab7786622 100644
--- a/target/arm/arm-cpu-props.c
+++ b/target/arm/arm-cpu-props.c
@@ -15,6 +15,8 @@
 #include "arm-cpu-props.h"
 #include "cpu-idregs.h"
 #include "arm-cpu-models.h"
+#include "qobject/qlist.h"
+
 
 #define ARM_SINGLE_FIELD_PROP(prop_name, _type, reg, fld) \
     { .name = (prop_name), .type = ARM_PROP_##_type, \
@@ -735,3 +737,86 @@ const ArmCpuPropDesc *arm_prop_for_field(ArmFieldIdx field)
     }
     return NULL;
 }
+
+static void append_str_to_qlist(const char *name, uint64_t value, void *opaque)
+{
+    QList *list = opaque;
+    qlist_append_str(list, name);
+}
+
+void arm_prop_append_supported_values(const ArmCpuPropDesc *prop,
+                                      const ARMISARegisters *host_isar,
+                                      QList *out)
+{
+    switch (prop->type) {
+    case ARM_PROP_STRING:
+        arm_field_foreach_supported_arch_val(prop->u.field, host_isar,
+                                             append_str_to_qlist, out);
+        break;
+
+    case ARM_PROP_BOOLEAN: {
+        uint64_t host_val;
+        arm_idreg_field_read(host_isar, prop->u.field, &host_val);
+
+        if (!arm_field_is_writable(prop->u.field)) {
+            qlist_append_str(out, host_val ? "on" : "off");
+        } else {
+            if (arm_field_check_val_safe(prop->u.field, 0, host_isar)) {
+                qlist_append_str(out, "off");
+            }
+            if (arm_field_check_val_safe(prop->u.field, 1, host_isar)) {
+                qlist_append_str(out, "on");
+            }
+        }
+        break;
+    }
+
+    case ARM_PROP_NUMERIC: {
+        g_autofree char *range =
+            arm_field_supported_numeric_range(prop->u.field, host_isar);
+        qlist_append_str(out, range);
+        break;
+    }
+
+    case ARM_PROP_FRACTIONAL: {
+        const ArmFracVal *fv;
+        uint64_t host_base_val;
+        uint64_t host_frac_val;
+
+        arm_idreg_field_read(host_isar, prop->u.frac.base_field,
+                             &host_base_val);
+        arm_idreg_field_read(host_isar, prop->u.frac.frac_field,
+                             &host_frac_val);
+
+        for (fv = prop->u.frac.vals; fv->name; fv++) {
+            if (arm_field_check_val_safe(prop->u.frac.base_field,
+                                            fv->base_val, host_isar) &&
+                arm_field_check_val_safe(prop->u.frac.frac_field,
+                                            fv->frac_val, host_isar) &&
+                (arm_field_is_writable(prop->u.frac.base_field) ||
+                 fv->base_val == host_base_val) &&
+                (arm_field_is_writable(prop->u.frac.frac_field) ||
+                 fv->frac_val == host_frac_val)) {
+                qlist_append_str(out, fv->name);
+            }
+        }
+        break;
+    }
+
+    default:
+        g_assert_not_reached();
+    }
+}
+
+const ArmCpuPropDesc *arm_prop_get_composite_of(const ArmCpuPropDesc *prop)
+{
+    for (const ArmCpuPropDesc *p = arm_composite_props; p->name; p++) {
+        for (const char **sub_prop = p->u.comp_sub_props; *sub_prop; sub_prop++) {
+            if (g_str_equal(*sub_prop, prop->name)) {
+                return p;
+            }
+        }
+    }
+
+    return NULL;
+}
diff --git a/target/arm/arm-cpu-props.h b/target/arm/arm-cpu-props.h
index a108dee1a4..264a8a71de 100644
--- a/target/arm/arm-cpu-props.h
+++ b/target/arm/arm-cpu-props.h
@@ -13,6 +13,7 @@
 #include "cpu-idregs.h"
 #include "cpu.h"
 #include "qemu/typedefs.h"
+#include "qobject/qlist.h"
 
 typedef enum ArmCpuPropType {
     ARM_PROP_STRING,
@@ -50,8 +51,12 @@ const ArmCpuPropDesc *get_arm_composite_props(void);
 
 const ArmCpuPropDesc *arm_find_prop(const char *name);
 
+const ArmCpuPropDesc *arm_prop_get_composite_of(const ArmCpuPropDesc *prop);
 void arm_add_cpu_props(Object *obj);
 void arm_add_composite_props(Object *obj);
 const ArmCpuPropDesc *arm_prop_for_field(ArmFieldIdx field);
+void arm_prop_append_supported_values(const ArmCpuPropDesc *prop,
+                                      const ARMISARegisters *host_isar,
+                                      QList *out);
 
 #endif
diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 7cb74b4b8d..9bdf85885f 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -34,6 +34,7 @@
 #include "cpu.h"
 #include "arm-cpu-props.h"
 #include "arm-cpu-models.h"
+#include "qobject/qlist.h"
 
 static GICCapability *gic_cap_new(int version)
 {
@@ -63,6 +64,49 @@ GICCapabilityList *qmp_query_gic_capabilities(Error **errp)
     return head;
 }
 
+CpuPropInfoList *qmp_query_arm_cpu_props_info(Error **errp)
+{
+    CpuPropInfoList *info = NULL;
+    CpuPropInfo *prop_info;
+    QList *sv;
+    int i;
+    const ArmCpuPropDesc *props = get_arm_cpu_props();
+
+    if (!kvm_enabled()) {
+        error_setg(errp, "query-arm-cpu-props-info requires KVM");
+        return NULL;
+    }
+
+    for (i = 0; props[i].name; i++) {
+        const ArmCpuPropDesc *pdesc = &props[i];
+        const ArmCpuPropDesc *composite_of = arm_prop_get_composite_of(pdesc);
+
+        prop_info = g_new0(CpuPropInfo, 1);
+        prop_info->name = g_strdup(pdesc->name);
+        prop_info->type = g_strdup(pdesc->type == ARM_PROP_STRING ? "string" :
+                                   pdesc->type == ARM_PROP_BOOLEAN ? "boolean" :
+                                   pdesc->type == ARM_PROP_NUMERIC ? "number" :
+                                   pdesc->type == ARM_PROP_FRACTIONAL ? "string" :
+                                   "unknown");
+
+        sv = qlist_new();
+        arm_prop_append_supported_values(pdesc,
+                                         kvm_arm_get_host_isar(),
+                                         sv);
+
+        prop_info->supported_values = QOBJECT(sv);
+        prop_info->composite = NULL;
+
+        if (composite_of) {
+            prop_info->composite = g_strdup(composite_of->name);
+        }
+
+        QAPI_LIST_PREPEND(info, prop_info);
+    }
+
+    return info;
+}
+
 QEMU_BUILD_BUG_ON(ARM_MAX_VQ > 16);
 
 /*
diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index 91bb899571..7671925869 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -354,3 +354,74 @@ uint64_t arm_get_field_mask(ArmFieldIdx field)
     }
     return field_mask;
 }
+
+void arm_field_foreach_supported_arch_val(ArmFieldIdx field,
+                                          const ARMISARegisters *host_isar,
+                                          ArmFieldValVisitor fn, void *opaque)
+{
+    const ArmIdRegField *f = arm_get_field_desc(field);
+    uint64_t host_val;
+
+    assert(!arm_field_is_idreg_any(field));
+
+    arm_idreg_field_read(host_isar, field, &host_val);
+
+    if (!arm_field_is_writable(field)) {
+        const char *name = arm_arch_val_name(field, host_val);
+        if (name) {
+            fn(name, host_val, opaque);
+        }
+        return;
+    }
+
+    for (uint32_t i = 0; i < f->arch_vals_count; i++) {
+        if (f->arch_vals[i].name &&
+            arm_field_check_val_safe(f->idx, f->arch_vals[i].value, host_isar)) {
+            fn(f->arch_vals[i].name, f->arch_vals[i].value, opaque);
+        }
+    }
+}
+
+char *arm_field_supported_numeric_range(ArmFieldIdx field,
+                                        const ARMISARegisters *host_isar)
+{
+    const ArmIdRegField *f = arm_get_field_desc(field);
+    uint64_t host_val;
+    uint64_t max;
+
+    if (f->length == 64) {
+        max = UINT64_MAX;
+    } else {
+        max = (1ULL << f->length) - 1;
+    }
+
+    arm_idreg_field_read(host_isar, field, &host_val);
+
+    if (!arm_field_is_writable(field)) {
+        return g_strdup_printf("%" PRIu64, host_val);
+    }
+
+    switch (f->safe_rule) {
+    case IDREG_SAFE_LOWER:
+        return g_strdup_printf("0-%" PRIu64, host_val);
+    case IDREG_SAFE_HIGHER:
+        return g_strdup_printf("%" PRIu64 "-%" PRIu64, host_val, max);
+    case IDREG_SAFE_HIGHER_OR_ZERO:
+        if (host_val <= 1) {
+            return g_strdup_printf("0-%" PRIu64, max);
+        }
+        return g_strdup_printf("0,%" PRIu64 "-%" PRIu64, host_val, max);
+    case IDREG_SAFE_SIGNED_LOWER:
+        g_assert_not_reached();
+    case IDREG_SAFE_EXACT:
+        if (f->default_val != host_val) {
+            return g_strdup_printf("%" PRIu64 ",%" PRIu64,
+                                   f->default_val, host_val);
+        }
+        return g_strdup_printf("%" PRIu64, host_val);
+    case IDREG_SAFE_ANY:
+        return g_strdup_printf("0-%" PRIu64, max);
+    default:
+        return g_strdup_printf("%" PRIu64, host_val);
+    }
+}
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index 51cc5ec341..171e03eece 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -104,4 +104,12 @@ bool arm_field_skip_writeback_if_not_writable(ArmFieldIdx field);
 
 uint64_t arm_get_field_mask(ArmFieldIdx field);
 
+typedef void (*ArmFieldValVisitor)(const char *name, uint64_t value,
+                                    void *opaque);
+void arm_field_foreach_supported_arch_val(ArmFieldIdx field,
+           const ARMISARegisters *host_isar,
+           ArmFieldValVisitor fn, void *opaque);
+char *arm_field_supported_numeric_range(ArmFieldIdx field,
+           const ARMISARegisters *host_isar);
+
 #endif /* CPU_IDREGS_H */
-- 
2.52.0

