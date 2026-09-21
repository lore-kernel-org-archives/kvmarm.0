Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC6E498937
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994040; cv=fail; b=VEZBp8hKXkHB8tB6WO+PfTU03NxJafcZuoYuYTKJJGJ76hJBn4jtQm6jXvnrLAFixwrvc8tEsxqGWZfeF7xcNfLjSoc6knMA109hghWq0M1gybsg7W7hWeraGQfqzxAWi/SlnDpGOD7skI7F8DGyakQY/C3SdaBzb6lykB3LpD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994040; c=relaxed/simple;
	bh=aPGn22tf/nOAzpig/4QP+gX9qvu4gk1Xh5+b0F33V/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lZTWZIA9Bdlny8Z1/BV3u6ym6xPhPoZ5f/ZfUfs4aFKUWpPYqkubq+xyaKhWcmH1QRziZZJw109YWuUnWV9V1l/JRoWkC+v+yJdQRdonj8kO5CFVNLehOyoeJlOp+LPCBbEUP6Z994tRsTwSSAo7QHBbt5W3hCvJzDke9l2MNpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=duux+pFn; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kuLT4+Qy; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="duux+pFn";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kuLT4+Qy"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAiHki520340;
	Mon, 21 Sep 2026 05:33:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=0DMr3VD86uGL8Af5mb4qLwbOFZicxlFcJowyyXVEf
	UU=; b=duux+pFn9vJniJq/JFCVyDDRAoi13VbaH3MrtqXis4H6eFraxUCcS3eVC
	ghT4rzQgWeffBvkXgd2BvMOopmv0iW62f3c6zGaBM76+dhvdfxHgTey2CRUwQ8vK
	haNpqk8Y42/nnRk53DfvC6BsTVxsZKF3YSQ9/QJJPeW05FXngeFhSRwhDjy4RBV7
	VrgpKPENAx0DOGSUKK3a9h7OO54qf0kIQzWXmPeFds3WQQoeUnpTcPfU/bI9fxJ3
	hTmdz62haDSxBC2H0aBmQ/OV5phJj2EGa5wekC2ecbsyAgEosPPm8jU+cUu5QvW+
	LiKmXtgI62Ege4Co6TrQFwlab0Dtg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022131.outbound.protection.outlook.com [52.101.43.131])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspqsbhps-6
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n3MHxbJ4r4NJyuE+p9990O+B7Lv2vELB8IOA0ZmFIQ69cvKq5vj6fImLrQk/X1/pymd+XeS3zWDb8hxKB1zZYW2xxkIAhF1CL2KDOCKeqRHT416jSwUPostijFLSbmgdHs46zGXKfmmHZ6x0L+tXTGxbLCdz/OvfoH2ZhFBnoyiclbLZSpWZBrSCinniBwr320CIoLKsP7EZO8hgfsFRAqBGoRlmgEIcwhDdsrJX26txZV4YjliUVNIKY+jxHFQWOeUxt6t9FMiQO193zyFOdLwKdHG/fye06B3gKELX/LnVJBBSv8Ka6dd4sF2wGIQr7QcZbbx4+cuPAgv2vxGg2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0DMr3VD86uGL8Af5mb4qLwbOFZicxlFcJowyyXVEfUU=;
 b=HfTWJW7P8WQNrSrHUaW7BpjgXgBbyhYSzbmrn58E3wGEYt1IZjNnc89DWxaMwWvIWMfnuifJc4kvCiW5Lo2aMXMjf5lc3CuqNhTYKGPlQODUnM6tMwWPc4zLjvZr8W/M1xBkbMYR7/BWEMbIK9RRa5F0sPbM4sQ06ZUekZCeut3+Qu1QWrkkQ1Ss2TVprhdpBSlD7RRJ8T5Xo00qUn7L1RDLs8gAcJ9IUhl6KwnwN/w5vc8DEt/OS2Hv4Tz+mIxkbr/eHWjGyCVsD6o7aDd8LUhgZWusERD+vecB9vpekiwYKvbDEgdww8w8iFGSLqlYwyRwHBY7m/w2Cjc6HpY32g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0DMr3VD86uGL8Af5mb4qLwbOFZicxlFcJowyyXVEfUU=;
 b=kuLT4+Qyz7cf62gr1Da1Baiu7/CfV76SXa7ODQUk9SUjoPhlfog41ubwDXDS8X6LI5vpwDeHzbJfHW5snU6zGedkPnSAvkYp+yhCYz7fDsfSerMXXrfZgqFePcNiNK75CZ4VREm6dDg4KNxLpKAy+TgginoZB/pj4MZKgsOo7pPxgPOTGZDQcKLBW3rBHaJ5ByPyPQNDl1rdACbltf/XgWHAYNzUFoFkov/C/503BaYL3GOPr44NEf6PLKCyzb6d/gyTMd+YIpQy9vrH1xcgSkJQXApVsFywTvjCxoZ4hQnMT0zsnHoHa/jXBZRXtMuLRFIzAZGgjgenSfdIlL9INw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6868.namprd02.prod.outlook.com (2603:10b6:a03:234::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:33:37 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:37 +0000
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
Subject: [RFC PATCH v4 19/25] target/arm/qmp: allow named CPU models on cpu-model-expansion
Date: Mon, 21 Sep 2026 12:32:43 +0000
Message-ID: <20260921123249.1708067-20-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: d771fe24-633a-4a7c-e9e6-08df17dc8f5e
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	f7zh/qHu4Vj4v/XpMlFHxseqSMAdX4jAv98HBhOHbPcl3Qsa8h25/pmti7t/7Rhpd7bmrB/BSNqU4LBlSMTrv8guYwlMMnfaJKn6M86eZt87UoM61TF6YFs3BS8wVC77PPMXv76dIs7qMeNUoNr96dfWS0GLoc5nRtZNMXWYcuMuvbdHOpw5kinVuzJWbyfYeAHg0zBtE7HzTLth+W3EgBokqOxnT77NQVUvOoOw980RVsksp/SDL/DiOqoFqti1F3cmbDMwsmjJ0X0wieJNGzfGE3ZfYRumvPUTGeA5GBvenq4pK3Ein+sm3ITqZvrt1eIX65h4z1c4EYM+DJ+RY2KFsaVG6g6U/VB0NSzgz4nKTvtcjSTBX0hVgxNUYszIDuhpuV/IB1QRDPMHmkX7UVDNlzWrZ/6CxHgOTLTpxOSQqdsmdrReVYuJ582C66UwZxqyF8pXRcP7B5LXI0iclmRiVt3LhtocvCbmwh/5p3PEIYdGD4CbquElL3xEOyZBhhiuf1Jye5LFXzPYx8OlW2IFLInKjxHxrkJK89qMI7Yuuxf+oHA8oicte/LyeOfFWwVvGtOBdz/H8IaLdn8zYFAKFC7Bq3fsHkHW17PpDajWz+Pvg06tXonWzwDfMNs+02iDOprG+zQOXOxTDUi7xmIOqXn3dkxc9bByLci7POM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HY8daQJSNfRTg7mSUFa9gF0K6AU+lTi0+nC+CJBk8YhtVsctzWaBYoDPSpng?=
 =?us-ascii?Q?F6MTRsc5/mD1xYpE4i9GzOFSJh6WrQJO2s6GotHlZdamV3UmV3yAFZeKmire?=
 =?us-ascii?Q?CmtOx9cvzbWoJzIQLo4/FlYnxzsouHCXMKTqCke5tXz2SpGgNLHpIiNwc6eF?=
 =?us-ascii?Q?+PVXV8+TVI1euXpDvZPI+wsuS8jusEMXuECV/oWEYR+59qCBERTjk1Zik+Fo?=
 =?us-ascii?Q?aC3OhYwPPwt3rgVEHYxJ5xOclgggZQOeK+ubLdg+X1KkZMc1aTJ7qgXQKUP/?=
 =?us-ascii?Q?xvKpaGOtBKgY+r1mUrNNwW+L3PPpYHCcfLIiIYBTOHu1lsM/qz96zpXw6QGj?=
 =?us-ascii?Q?LPkhFaWPmmY9uuZ9WE3YnYkPf5dMguy+BXnG2p4sPetaRLHwm+4fIe4aPlr8?=
 =?us-ascii?Q?WOfdgKZDhBSQpTjdxWtF5QECheYtGYex73P13ifEc6xTyBXc/zomZlJaxyuk?=
 =?us-ascii?Q?44gcVVQGM477FcsCJBD7HjVORDfW884Ile2qke171G8NNL1n/HopxY/mARYc?=
 =?us-ascii?Q?jnEiFoXY0Q2He2vCZCWrX3wcSGAhYhnAivEjwPxKQGKcNyKQck5bofIW3tHd?=
 =?us-ascii?Q?fS2Z96vHYos6sQdMuqBWITkC2R0kTUvr1clV37jgUFIGQtAP8hH4DioWSiEu?=
 =?us-ascii?Q?j6H0hpQR47uC4FhW+5EOUEkxBwU+QMwCVMXiy/zAlQW0wlS8iSGaAzS3ef8g?=
 =?us-ascii?Q?kaA/u/L+FHJ4WAkJZoQg/wzG5hvVMEzyob9HGFHjH2txyYYHaXfwx3e26yBC?=
 =?us-ascii?Q?2bHoXH1ldiV7uGxiZ7pu6UYn5bMrstr3yJ4I0cFefmsPefbvFNp6cS3E4Pbv?=
 =?us-ascii?Q?WAtYq+IQkShUmaVTJscffbS/MyTM0jPoRin/tH5nxuTGgfDyQKztxZLUngHy?=
 =?us-ascii?Q?WGTuCKz3apY1tT4iilGc9wgS1/mfxS5lfuLWCTLaCmswru4hQcNb0XIIXb64?=
 =?us-ascii?Q?DrBP4Ea1l+t3Z3FpogW/c2DC4jHXYqw4yIuA0Nw7xW5uUiEJrFxb/oESyPKA?=
 =?us-ascii?Q?sELO3nJsVeoDLKUvigCWT5MjIxLz/yH3F+hMs+frcRdVdwEILK/I7MGQhD3s?=
 =?us-ascii?Q?v/IH2gKK9xXC5FiACqMvcyOXiGueHIG0ozu9Roa67DC2V1Dm+aRflj0PKywN?=
 =?us-ascii?Q?3B14Th/SO6yePoxv1oq3D6uKoVMAZzF30KoMOJLPpF7eYl0POVeZ5hVkyXc2?=
 =?us-ascii?Q?kdLKE6+BiNzaFTXrw4+Bfiq3FOZybotPIcvPVQssBrOb9PYMkl1dJCBuCGxu?=
 =?us-ascii?Q?8cyDu1o1t1O9tMUTRcJQ9vG4uov7qDcR6rr97DV2/jJWlNvHPM33tyFveUaV?=
 =?us-ascii?Q?GjcVMJ4BDFyKvt9K2jAbBuKiTfKqwCGY92SVsfckC9O9JeuYaTlefHoFLBIt?=
 =?us-ascii?Q?1HKG9eqGVfLqskdT74OsJnpnSobsczHms8Y+z26pU8eL5zW0yQxr7vwjzjkL?=
 =?us-ascii?Q?0BGrjNGclry2+9ykfCwg1gnIP1WDQKoNNa1H4+Hz/2gkLL2PMs1LPRQeje1D?=
 =?us-ascii?Q?ZvdIzaDYR67svYaSHqyJbYqb+qYQpjIIFZtLYok+x/DDYIRbrLLeFfbXyIO7?=
 =?us-ascii?Q?kx5XdwCok3PbE35AB4C7/mWDrDcnjay8zkHgQVJhfyMzb2lDNPZXeExq2HOI?=
 =?us-ascii?Q?xwDRxwxlMcaipgpWcBb1EENHLnHepFEUXoCDlPLslIrtZfiPcgv13FyFDuCq?=
 =?us-ascii?Q?12bSMjVLlU5uCt6YoXr/5ucYAQ7jPgKdflw1xGpnn9r96md63FCH85WQ3Cqa?=
 =?us-ascii?Q?FlT/JA/f0EhHG62gU7k0rYJCyFgaLnE=3D?=
X-Exchange-RoutingPolicyChecked:
	WQX9cPJ4QzJ0emNLMh/yv8cYW5Kl8NvTbsHq4XtWtQk/a8AWtfG7WkVBXg1iHWQT0EmIxYwzqj0pOLUVFyelJRD8RqM1HWSexj5zMjzC60xgVjZnEBFuyU1muwlr4Q6OIwVGO/wluGSIK1DHtS8Ui94Fi7msBOp0jswny3Icb5ZtP3ioblfV3XvabqeS713/D1Rxsbnc9JqfPSU5GMjHAq23JC6cMHfr8OiDVV705OKALXGzg2QQs+X+PqwDqVHAYv1inJoXkWEAXr1CqMk05BmmC+0+bthXspSnOlsUaocN/CHxC0kcXpYwQSVUtnpiDlbh/f4wz8Rdil02v9oTWw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d771fe24-633a-4a7c-e9e6-08df17dc8f5e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:37.6654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQhYbLUn6qPZkN50IATNH+umeDyOxv53WNB2fevNyY3OmkNtiIKicXmH1GpCmRHaaagwefiAWgG1uuO6MBkqUQUb6jKap3do7MSuqd0cxHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6868
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX+GtAD/dVXP5m
 xCDfmORfNY3JCs2IDXfwX+71S3uINEToLYOHX4nzL1LAeQTYAvdX6zOGd9kSVGI6w54BmKvEx5f
 XyMuAtRhQ+CS1hi3iILYWEvQO9GYzMNZGez+PQoUuqjW6w7j5lhZZ3+Rc4BPdwwn2YIeEOUwRRa
 YQ56G6zPQWwH6VDjhN0Iu34iG3ixq5ItOm7a7u+8CYYu+8bvuc8vjU/twPqqvJhlYQi+AGr8WvM
 EV+NiV2SQB2+LTXVmZA2FPOp+1SyHmCNkN0GY6+38sVZ9+w4GrEnBJdz/ICzdvkf5Vq4Tke2ycO
 ctQL2e2kpKS26Jq6oU4TORJTFEMc0fxO2+TLx1AGpH/pVdsYiTBY1fzDoYRYRru3XaKRKcBYT0d
 KiUa0QtQUWaaHrrV7ZPJRK6jre+Z3EH/aBYxNV+ipn3Spw5MBSSNur0cFDHc+cM6QoKarqT5B/c
 KZKADvVWyk/7MzPX8bg==
X-Authority-Analysis: v=2.4 cv=E9BYNqdl c=1 sm=1 tr=0 ts=6ab12422 cx=c_pps
 a=WiodiXt0wH02q4ozJLtFAw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22
 a=64Cc0HZtAAAA:8 a=vnAHZ3QMiFH_N7o83AsA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX1bxyVt9O1p1K
 qfHocBRdi3YiaxeihEnTu5lXYehoAxh4CmSl+3BXbOPEf9RwlFV3naIRp3sknQTBdHH2IS3C73v
 zmGFTS78AIVSPm+rvnqZDZ9KE8metTY=
X-Proofpoint-GUID: MTbNo1Cg1d1qZcqbnJC6pib2JdBarSPq
X-Proofpoint-ORIG-GUID: MTbNo1Cg1d1qZcqbnJC6pib2JdBarSPq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Allow expansion of the new KVM-only named CPU models through the
cpu-model-expansion QMP query.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-qmp-cmds.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 5fbdca3253..0940285af1 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -36,6 +36,7 @@
 #include <linux/kvm.h>
 #include "system/kvm.h"
 #include "cpu.h"
+#include "cpu-models.h"
 
 static GICCapability *gic_cap_new(int version)
 {
@@ -96,6 +97,7 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
     Object *obj;
     const char *name;
     int fdarray[3];
+    bool named_model = (arm_find_model(model->name) != NULL);
     int i;
 
     if (type != CPU_MODEL_EXPANSION_TYPE_FULL) {
@@ -108,6 +110,11 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         return NULL;
     }
 
+    if (!kvm_enabled() && named_model) {
+        error_setg(errp, "The CPU type '%s' requires KVM", model->name);
+        return NULL;
+    }
+
     oc = cpu_class_by_name(TYPE_ARM_CPU, model->name);
     if (!oc) {
         error_setg(errp, "The CPU type '%s' is not a recognized ARM CPU type",
@@ -121,6 +128,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         if (!strcmp(model->name, "host") || !strcmp(model->name, "max")) {
             /* These are kvmarm's recommended cpu types */
             supported = true;
+        } else if (named_model) {
+            supported = true;
         } else if (current_machine->cpu_type) {
             const char *cpu_type = current_machine->cpu_type;
             int len = strlen(cpu_type) - strlen(ARM_CPU_TYPE_SUFFIX);
-- 
2.52.0

