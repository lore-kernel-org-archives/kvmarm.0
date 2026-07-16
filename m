Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D25C3C4B88
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237994; cv=fail; b=eo+t381WlEisWSlcQv4JEvMdHFGsuuD11AIjwWCIDcwYpgF3hcaGd8Xfp4iiEJKPSCisl2W4UgQKKWn2iDsW+l27uCRBfvrZ5qRiDx8MNGbPvVohcy7y8230uWeTMJW7WeMZUaIRonTXrnta0i/uUPVsv9ZFEKdjXf+/dfKoCpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237994; c=relaxed/simple;
	bh=xyk0QSIcK8SHjjdWZCq6DilZ9oz9ubzO/aEJaaa50No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TwSh9c9EGMYrAE3PCT6DmO84w8L0q6hMJSXx0l3QEiL/q2rreeH/OFtL8YpK0QBTGEN5ITNvkJscpNiZ75/YRdjSrPIPaE3iNjBtmndJYU4f5nCqlmqfnJZj90EM36vj7P5+6JD/3YnMsV7bdd0zUUHNbpVtvDQY2BrA9aJAZWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=sSl99AQB; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HymHhXfz; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="sSl99AQB";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HymHhXfz"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrUwF1796534;
	Thu, 16 Jul 2026 14:39:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=BkGJKeBPe77hOHQTMgqHf+HajHaW6zy+KttHmwZLN
	cg=; b=sSl99AQBDw9i0QAJdAONMdFlSdwuSnQex/9k85P8a8fFcZihi3FbMnRkw
	LQ8gtdoy0Aj1+WFHiDhfqrNNZJ8Wz1IAuUiIzSkEJG/xeJlUtyqZHEvfdOQIQwT8
	M8OhAwIu+c+XzZ3GTCJUtVVaweXkEPNfnJRqGbn5f9zCVZFpBcX/LWv++Fuu+726
	4MDdPLR6Rm1rw6NWGAfl5C6PLNEoERAp9kbnNCPDREbtdCVf7XMwhKzIIWXAAfxe
	wX4YkBq1vZtBueCsOEroRdg1og7cQqvvVFaikSdX3+/fOImG49ipHsfkuVORpT7Y
	lEUMQjvRmkv0MohNwMt/cTZdKEqUg==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11022136.outbound.protection.outlook.com [52.101.53.136])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fejrfb79p-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kwoSBkkZDXIXloN0nMXeRysyw2G3lj6RzZpvkIO3lu+rR+EzwUfvP+sU7nUnb4Dzk443Jv2d+xBWUUrlGzWsmnuDQOCwsmYeLRIT6Bnfie1TfBlCYesPxcdbbZ2PxjT2Y+qRedA/+PmopDG6HWOohDrBzGv5o2JY2+460OHwEbU8rMDo+5r62BxY6qb1WZd5KHEFAGjAF54OWRLElvQyTn87kdO84rvNCXXGK3Wh/jBNLnz7YqryqQYp6/nDk7apwlhzWm7xw8F9sAfBoVzXN0WRxKCNIReBttEUDRbUsYV1dZ9kx0N1a+PyP5/b+q/oRXUOCNCMceurj9b3bsjd5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkGJKeBPe77hOHQTMgqHf+HajHaW6zy+KttHmwZLNcg=;
 b=FKZJi8OOMZ7VzcRW1r8m/iUXK4gPrOzkZuJ9KY3tauR0dRsTbjlLNaHxmLgP3r4thxCfXmrhuhWad7JCOepRlvhbawLMSYrQCNJEnx3jF5I/cWq41V7E33QU/9GaXprft01JXWeObJHGG8f43FT5tJJLbaCmM6MchjeCBgQCCStyWEXxj7TXSfXcYZAxoJB1qYEkOKoEDaCSJBH2B2C1nMrSVbrfMizwntvGQX03IwVOEsepAOFlBGLLwF49JFzxQoyVd7TS/Qb6/LaqfHe9RisoqFxM+IBEWEypOJkqeDTT4P42IluuAOFPqttk9MvqUgOsdUX/nRKy8sDtvvK0vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BkGJKeBPe77hOHQTMgqHf+HajHaW6zy+KttHmwZLNcg=;
 b=HymHhXfzFFZNVjKeKwAg3c/RuyIudD6olRn8WjDwN4VTXcIy1x39RRE+pVR0w2wpbei/uv7sWaf1BQ6SUPTan+tgLUYQX75NsE1+h+tXDWRwJaCMxn6eTT0oMrKpz07f4ywoH+9/iSsdGnzjNEGZDgTE5VZnRvhDrCsQjg+/LffUIfKwE5dnQGrs27Ocm/TxYcTJF9xMiRXkKEMG8ytKVIBENKrCJkl7LeN6NZi/D2eW8iy8xq/F7Kh2TRYB/h2/PUeXEva0EjuhdEnHXAvs9Olcbt/djwrRID/aYnnJWk49YRzzQw+a4ExDb1xSPUfKHY7GczO4/QSqsnVhR+W6dA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BN0PR02MB8255.namprd02.prod.outlook.com (2603:10b6:408:156::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:42 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:42 +0000
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
Subject: [RFC PATCH v3 19/19] target/arm/kvm: fix host model writeback when kernel supports EL2
Date: Thu, 16 Jul 2026 21:38:58 +0000
Message-ID: <20260716213858.609699-20-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4da8b3f5-9c92-47c5-ed58-08dee382bed3
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|3023799007|56012099006|6133799003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	+iV93I7HpI2BwMMvB8FPc48MTQujgm2z3Caou1G1IksKBQBiCNzZxXI2PPZjUGoSVTta276TecP3h5P4brN1jqgsk775d1YLTvm5NFYtWDawvNeOrMi4CQDmI3VnoF0uI7+KdHNfoZMvSj3Wv9+vo/NFnaoVYEIUH4pnDXsTacqPVj24obyY/Q/t19K+KGPtLgTDjRQ4JBQzpUCKIfIBPmbuso3k1Dz03BAVU5GTxpDZtyfG9gjeEau6qwS8q634mTNgn8qwXluyb/cXLw6kiR2eLfz2jqeKJddpgyspO/YWcs0SmGK5tuucEE9X0l/3mVbet6TPh7ag7YrKbFWYq/KxlApO3Qe7OhMMP3f7PTUIUpEwJAFceDHzzuqFDZnbgnfqsx7RVVOvr9QCRTbmy5JcA9HVlK3GxPHQWdEKHQ1tReMjZOm2ePRwvT72mwP+QtfTbfkqzW5v+4SdlRq///ft2xFh5dUB/7r1Qe/2OCbnnIio3yg6fARCI/Zba7DkTQAkprqHZSXqhNHkuLkJKzbiQOWuOGfS1gtIp8L7WjMWtcUSZW7etEsRTl8307pJej+x+2MUGf3+N0mFne3INq5WfpbDz/TAsDMKzfSDSnGE2hBaMOoRULQpCKaHgeGyI5mHjTIv/3j829BA+SYILRnOzAs9PVnL27cgIw3EzlI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(3023799007)(56012099006)(6133799003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?njGcGu+4ECz3FxtOMc2GQoEAjYtxFTeib5PHHXlvqtdVN3Fn8DUUJN1CaG69?=
 =?us-ascii?Q?uPrEwCycmB6XyE8GSQnbRYva+PFwmFWD29cJtyj2vNXtuJxwd7n/Tnn1Pwrb?=
 =?us-ascii?Q?elU/nhy0F36d2wF/JpW8T5hJJ0yGWIgTiiXyweRfh6ts09QRxuA0rNoCDqOO?=
 =?us-ascii?Q?Rl0K/paodOeSG6r2VcXXRqyvWtTDGtg8uXgDGq3gmhQ3krZhFuNawPM1ITao?=
 =?us-ascii?Q?U47TKyT55LZGsFQ41GZwN4QGJO7Dnq+LOTGiF7xcuuR7MU69CF5GKXcVDFm/?=
 =?us-ascii?Q?oPmjNYtj4BAYUpqpO7B+bTjfvpxzmAGjqp3roEWcV1/xuQyHLQYj4WIeFIZs?=
 =?us-ascii?Q?JkggId4nm4OhjE20V+YrV+rDxZTO4RK/dU37b/0PuhSDy9058tkX6lzT/mSJ?=
 =?us-ascii?Q?t5TAu4FHWnzvRHYDWu3LnVLjBMfHZU8dz704GE31Xu3bvyp5fl9mCJ3dQZv9?=
 =?us-ascii?Q?JYN2/1gce4TBwu/D1cv6vH+8DhT0PGFgqkwxrEvGIWGVrmmldlPAz6ls3kmy?=
 =?us-ascii?Q?Jbj9Gfai6ykwuTQF9r6bdz4cPqL5lYBCFnLhIK3EmLRzFsh3z4KUskAWYVEE?=
 =?us-ascii?Q?vT0LtzpR9CLHEjyvDcD1kpphESVALKsB20jyuMf8HxNuMuvrpSXlV0s8Tfle?=
 =?us-ascii?Q?rhWJgf6WqzMNHL6BshdjU8tEwsf2LKI5qo8/J5DXxxBt/9pqH+pisspMaRCy?=
 =?us-ascii?Q?zBw3zgPA0y9CQLDKyB+9Nd+ztNOhTrm15T7A0D/dJ8u4vrFn+Cni+w6/Dp6X?=
 =?us-ascii?Q?o0oB4IeOY8jkMpW4roJVnHyZiH5yv54CbQxudxWQdUOGvk8pPTC6AtWIkJvj?=
 =?us-ascii?Q?DkfcsV4pQEE+84Ys8OpOB++JIjX0yEf6+8tPtadk0KUmc1RXArhUhT+Cfvwl?=
 =?us-ascii?Q?xYZQiRmYepdBYJ2lEgE2+7j5xT84m9sOeIabApQQH99Bj9CL7neXCC9ZwUr2?=
 =?us-ascii?Q?n8FEe3650njM62sPi5wKX1OdNGO7IY7kzbkINJ4vefuOz81ZUACyw6IGC/9t?=
 =?us-ascii?Q?zJlilS76/xTluZ47GZBQ5x/C0yHsI/YhIYf7j5y40f4obmpLxzL+tJrNgYjJ?=
 =?us-ascii?Q?0WSX8OgeOajN1LSC1FOA3HcHy3dCCCSk33B7a8laoIaxQ5+qWVFOgsZmiFtL?=
 =?us-ascii?Q?7rHb+QJ2Uy1tBcHtb8UvO2hVFFpwoq/xb5GcSrVQWwCuqpqFWcYgVjx775xK?=
 =?us-ascii?Q?giPo+D1bRySkK/tSp7FDwCNu24b5rRIR7ignlHqr2YscjTlyx3nharMJfz6D?=
 =?us-ascii?Q?QzgtMcNWMF7PyVgKnq6bBgz7pxvBe6qknSAUjVW+XzAUrtxw4wlVSXTKm3Jh?=
 =?us-ascii?Q?fvoawbol1swNeWNFxaU9MWPwaYV59mDsfLqrgJLoTHZedx+mbvTCfPeU63aU?=
 =?us-ascii?Q?gqZnNn/zxy+ZeVQvZE6CRSRHKcamlTpNP7jPJ7UE9s5CTCoM+snlTuirIOli?=
 =?us-ascii?Q?RtoykNucjpXSB4eoSSuCIcBsSEvNO1/zg6ZTpzBsJA6Pf6Svz54NSaTQBDMQ?=
 =?us-ascii?Q?FKYGvzhnhu/YulfnUWNdFfcX8oIzPJL6uLB618c3VuSmpuVMRx7OB3NBlIa0?=
 =?us-ascii?Q?YQr/BYEbNCfuPsuWNVzetzH4iUbuOzKBiCdug9vBEnRfahAGOxqhm2W4zdf1?=
 =?us-ascii?Q?L2GUmqEaDE8dkiRyFYbypuIEBuyBHVDK9+fMDfk4OGuBOb1OuB0XrblUOHHY?=
 =?us-ascii?Q?QndiKiXRlN/GQTqlNNUahye7Ce3vCYY7K1Sbm3j5pb40MOlyUI3UiXUvmGZw?=
 =?us-ascii?Q?OLzlVwuRG6I957o0UKBxvAApuszwKt8=3D?=
X-Exchange-RoutingPolicyChecked:
	TLjRXztwETmUM1p4VReAJaFz4rY4h0F7qCLD16yJPYV4wg7pp1oPqbU2SMbl3NpUNl2t8sdaANzU0L4LoxMG9P1TeMbrXnXibaMWKeaKT4yMy7GizDIhejqEpOBOiqERyF//IKxCeKYq5OIi7cIThUMq0uI6YAzAJ3NGWT/jEyEhGgZGjb2Icjt2BYx2Bnv+QJFzJQnK5/oWriDgvjeiC6fdOmFORu6KGe9+tyWL0Qvo9EJt5rCF74+OSZgQj2pjpUWlM1yf2eGHqLeVEjHMshrTCoIptMgCthclawqA/GkIpxuWASKAIiY2esllCtjOrU8gl45zRZxkuq0RvslHvw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da8b3f5-9c92-47c5-ed58-08dee382bed3
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:42.1453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LikXo7npPOspxFqI0GqptsYuXQs5YK6sM7rxUxr773bGSQ3R8x3vQL1aBHG/OxXIbLGYu/BumrdLnwipIYcmtbC/jKBX/cfHOd2p99GYnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8255
X-Proofpoint-GUID: O3Yf3ZnPPrwJeepVM7Uq8VumKf7NrNWs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX306fMzUMXYLE
 uHWG5kavGMPjjDwXvlgQ8oplsgULNrTa4Za4fgDHO0mX4yHfaBeeqsIxyiOtRaeoekNHSFnhRgE
 wwEY5V3dtkVhGijPyrIkdJenUHXqUa1nReWMd+yme3TJcHC+rDt8KzZM6DmsB9tEm+XpXHThOCf
 enc7qr/5EoZqwkZp/2Fi/BjEDC6DP0OehZnTIcMENuw6QAFvKvTtMrpNNMvjXVkw6Y0UfxkMxKS
 G6yBgbRfBQ5IzB7/m4MrVxpny6CcAaOCqy/nWZCzOvhUVHwJYa/ZzjeMp3ozfmE1rw2plPCMRxJ
 QKEvyM+HqohAZCLNMcnzOq5GkUiMytTJ/EtvyoYWyG2Sr51kzYyrcuVIBNZuheC2mEzHyWeiBLv
 wJTlunU8XzGRK1+7uklVBPxN89leUF2Tuw/g1ECBlQ2EOB5c4MugnaE9d/UfiAyhfmoHw2akPfu
 r6PzCPJ3290vGzQ63gg==
X-Authority-Analysis: v=2.4 cv=d4HFDxjE c=1 sm=1 tr=0 ts=6a594f9f cx=c_pps
 a=wT4O3adra3cfqKKwvhZ7sQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22
 a=64Cc0HZtAAAA:8 a=SkqPq7xGtlfVTkEtxm0A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX3nu+vA1jc2gt
 gOFB0VhO0tBBb3zUOi0WYZEeQ+U5dxO1v3tKLlXZ/jmVSXFPsN4PpBPzJQY+VaTivZM/WYmQWpC
 LbozqDmsMOR0/By7o0DaJrIqTRsjB3c=
X-Proofpoint-ORIG-GUID: O3Yf3ZnPPrwJeepVM7Uq8VumKf7NrNWs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

kvm_arm_get_host_cpu_features() probes the host by spinning up a
scratch vCPU and reading its ID registers. When the host kernel
advertises nested virtualization, the scratch is created with
KVM_ARM_VCPU_HAS_EL2, which makes the kernel run limit_nv_id_reg()
on that vCPU and force several fields (e.g. ID_AA64MMFR4_EL1.NV_frac,
parts of ID_AA64DFR0_EL1) to values that match KVM's nested-virt
capabilities rather than the raw host.

If the actual vCPU is later created without EL2 (e.g. -machine
virt,virtualization=off), the EL2-on values cached above no longer
match what the kernel exposes for the real vCPU and ID-register
writeback fails.

Fix this by caching two host views, one probed with EL2 and one
without, and selecting the appropriate view at every use site.
For -cpu host (and -cpu max) without EL2 we additionally rebase
cpu->isar.idregs[] from the EL2-on view it was initialized with
onto the EL2-off view via kvm_arm_rebase_host_idregs(), so each
field that the user has not explicitly touched picks up the value
that the real vCPU will actually see.

Corner case: the rebase compares the post-init field value against
the EL2-on host value to decide whether the user set it. If the
user directly or indirectly set field X=i and the EL2-on view also
reports feat_X=i but the EL2-off view reports feat_X=j, the rebase
cannot distinguish "user asked for i" from "inherited i from host" and
will overwrite with j. This only affects -cpu host/max without EL2
on NV enabled kernels where the user-requested value happens to match
the EL2-on host view, so we avoid the complexity of user set values
tracking and accept the loss here.

Named models are not affected with the issue as they already start
with default-zeroed view.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-models.c | 14 +++++-
 target/arm/arm-qmp-cmds.c   |  2 +-
 target/arm/cpu64.c          |  2 +-
 target/arm/kvm-stub.c       |  4 +-
 target/arm/kvm.c            | 93 ++++++++++++++++++++++++++++++-------
 target/arm/kvm_arm.h        |  5 +-
 6 files changed, 94 insertions(+), 26 deletions(-)

diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index 44e7d3cfa2..a41f1f1169 100644
--- a/target/arm/arm-cpu-models.c
+++ b/target/arm/arm-cpu-models.c
@@ -459,7 +459,12 @@ static void arm_named_cpu_initfn(Object *obj)
         return;
     }
 
-    kvm_arm_set_cpu_features_from_host(cpu);
+    /*
+     * Start with the host view without EL2.
+     * If nested virt is needed user must provide values for all the
+     * blockers.
+     */
+    kvm_arm_set_cpu_features_from_host(cpu, false);
     if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         return;
     }
@@ -481,10 +486,15 @@ void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
     Object *obj = object_new_with_class(OBJECT_CLASS(acc));
     ARMCPU *cpu = ARM_CPU(obj);
 
+    const ARMISARegisters *host_isar;
+
     if (!kvm_enabled() || !arm_find_model(acc->info->name)) {
         goto out;
     }
 
+    /* Use the host view without EL2 to calculate blockers. */
+    host_isar = kvm_arm_get_host_isar(false);
+
     if (cpu_isar_feature(aa64_sve, cpu)) {
         arm_cpu_sve_finalize(cpu, &err);
         if (err) {
@@ -505,7 +515,7 @@ void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
         }
     }
 
-    aarch64_idregs_get_blockers(cpu, kvm_arm_get_host_isar(), blockers);
+    aarch64_idregs_get_blockers(cpu, host_isar, blockers);
 out:
     object_unref(obj);
 }
diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 6f11681c87..8dcff6c22c 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -102,7 +102,7 @@ CpuPropertyInfoList *qmp_query_cpu_props_info(Error **errp)
         return NULL;
     }
 
-    host_isar = kvm_arm_get_host_isar();
+    host_isar = kvm_arm_get_host_isar(false);
 
     /*
      * Spin up a scratch "host" vCPU object and walk its QOM properties.
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index f41bcf2e81..c7556bfd52 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -1050,7 +1050,7 @@ static void aarch64_host_initfn(Object *obj)
 
 #if defined(CONFIG_KVM)
     kvm_arm_set_cpreg_mig_tolerances(cpu);
-    kvm_arm_set_cpu_features_from_host(cpu);
+    kvm_arm_set_cpu_features_from_host(cpu, true);
     aarch64_add_sve_properties(obj);
 
 #ifndef CONFIG_USER_ONLY
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index eb8fdda236..1a713cb904 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -45,7 +45,7 @@ bool kvm_arm_el2_supported(void)
 /*
  * These functions should never actually be called without KVM support.
  */
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool with_el2)
 {
     g_assert_not_reached();
 }
@@ -120,7 +120,7 @@ char *kvm_print_register_name(uint64_t regidx)
     g_assert_not_reached();
 }
 
-const ARMISARegisters *kvm_arm_get_host_isar(void)
+const ARMISARegisters *kvm_arm_get_host_isar(bool with_el2)
 {
     return NULL;
 }
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b909a11dfd..f2635980eb 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -67,7 +67,7 @@ typedef struct ARMHostCPUFeatures {
     const char *dtb_compatible;
 } ARMHostCPUFeatures;
 
-static ARMHostCPUFeatures arm_host_cpu_features;
+static ARMHostCPUFeatures arm_host_cpu_features[2];
 
 /**
  * kvm_arm_vcpu_init:
@@ -363,8 +363,7 @@ static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
 }
 
 
-static void
-kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
+static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf, bool with_el2)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -404,7 +403,7 @@ kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
      * Ask for EL2 if supported.
      */
     el2_supported = kvm_arm_el2_supported();
-    if (el2_supported) {
+    if (el2_supported && with_el2) {
         init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
     }
 
@@ -553,7 +552,7 @@ kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
             err |= get_host_cpu_reg(fd, ahcf, ID_AA64ZFR0_EL1_IDX);
 
             /* Read the set of supported vector lengths. */
-            arm_host_cpu_features.sve_vq_supported = kvm_arm_sve_get_vls(fd);
+            ahcf->sve_vq_supported = kvm_arm_sve_get_vls(fd);
         }
     }
 
@@ -604,7 +603,7 @@ static int kvm_arm_get_writable_id_regs(uint64_t *idregmap)
     return 0;
 }
 
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool with_el2)
 {
     CPUARMState *env = &cpu->env;
     uint64_t *writable_map;
@@ -629,11 +628,11 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
     }
     g_free(writable_map);
 
-    if (!arm_host_cpu_features.dtb_compatible) {
-        kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
+    if (!arm_host_cpu_features[with_el2].dtb_compatible) {
+        kvm_arm_get_host_cpu_features(&arm_host_cpu_features[with_el2], with_el2);
     }
 
-    cpu->kvm_target = arm_host_cpu_features.target;
+    cpu->kvm_target = arm_host_cpu_features[with_el2].target;
 
     if (cpu->kvm_target == QEMU_KVM_ARM_TARGET_NONE) {
         /*
@@ -644,18 +643,18 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
         return;
     }
 
-    cpu->dtb_compatible = arm_host_cpu_features.dtb_compatible;
-    cpu->isar = arm_host_cpu_features.isar;
-    cpu->sve_vq.supported = arm_host_cpu_features.sve_vq_supported;
-    env->features = arm_host_cpu_features.features;
+    cpu->dtb_compatible = arm_host_cpu_features[with_el2].dtb_compatible;
+    cpu->isar = arm_host_cpu_features[with_el2].isar;
+    cpu->sve_vq.supported = arm_host_cpu_features[with_el2].sve_vq_supported;
+    env->features = arm_host_cpu_features[with_el2].features;
 }
 
-const ARMISARegisters *kvm_arm_get_host_isar(void)
+const ARMISARegisters *kvm_arm_get_host_isar(bool with_el2)
 {
-    if (!arm_host_cpu_features.dtb_compatible) {
-        kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
+    if (!arm_host_cpu_features[with_el2].dtb_compatible) {
+        kvm_arm_get_host_cpu_features(&arm_host_cpu_features[with_el2], with_el2);
     }
-    return &arm_host_cpu_features.isar;
+    return &arm_host_cpu_features[with_el2].isar;
 }
 
 static bool kvm_no_adjvtime_get(Object *obj, Error **errp)
@@ -1438,6 +1437,7 @@ static int kvm_arm_write_idregs_to_cpreg_list(ARMCPU *cpu)
         uint64_t writable_mask = sysregdesc->writable_mask;
         uint64_t desired = cpu->isar.idregs[i];
         uint64_t previous, updated;
+        bool has_el2 = cpu->has_el2;
         uint64_t *cpreg;
 
         cpreg = kvm_arm_find_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
@@ -1447,7 +1447,7 @@ static int kvm_arm_write_idregs_to_cpreg_list(ARMCPU *cpu)
          * snapshotted at probe time as the reference to check the vCPU ID
          * regs have the same value.
          */
-        previous = cpreg ? *cpreg : arm_host_cpu_features.isar.idregs[i];
+        previous = cpreg ? *cpreg : kvm_arm_get_host_isar(has_el2)->idregs[i];
 
         if (previous == desired) {
             continue;
@@ -2332,6 +2332,50 @@ bool kvm_arm_mte_supported(void)
     return kvm_check_extension(kvm_state, KVM_CAP_ARM_MTE);
 }
 
+/*
+ * Rebase cpu->isar.idregs[] on top of new_isar given the initial_isar.
+ *
+ * For fields in cpu->isar.idregs[] that are same as initial_isar, update
+ * the field with the new_isar values.
+ */
+static void kvm_arm_rebase_host_idregs(ARMCPU *cpu,
+                                       const ARMISARegisters *new_isar,
+                                       const ARMISARegisters *initial_isar)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        ARM64SysReg *sysregdesc = &arm64_id_regs[i];
+
+        for (int j = 0; j < sysregdesc->fields_count; j++) {
+            const ARM64SysRegField *field = &sysregdesc->fields[j];
+            uint64_t idreg_val = extract64(cpu->isar.idregs[i],
+                                           field->shift, field->length);
+            uint64_t initial_val = extract64(initial_isar->idregs[i],
+                                             field->shift, field->length);
+            uint64_t new_val = extract64(new_isar->idregs[i],
+                                         field->shift, field->length);
+
+            if (idreg_val == initial_val && new_val != idreg_val) {
+                /*
+                 * The cpu->isar.idregs[]'s field val is same as
+                 * initial_isar.idregs[]'s field val, which was used to
+                 * initialise it. Hence, override it with the new_isar[]
+                 * value. User might have explicitly asked for some value
+                 * which matched the host value without EL2 in this case,
+                 * that value is lost. As rebase is needed in very specific
+                 * case, we avoid that complication.
+                 */
+                cpu->isar.idregs[i] = deposit64(cpu->isar.idregs[i],
+                                                field->shift, field->length,
+                                                new_val);
+
+                warn_report("KVM ID %s.%s value changed from 0x%016"
+                             PRIx64 " to 0x%016" PRIx64,
+                             sysregdesc->name, field->name, idreg_val, new_val);
+            }
+        }
+    }
+}
+
 QEMU_BUILD_BUG_ON(KVM_ARM64_SVE_VQ_MIN != 1);
 
 static int kvm_arm_sve_set_vls(ARMCPU *cpu)
@@ -2450,11 +2494,24 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (ret) {
         return ret;
     }
+
+    /* For -cpu host/max, rebase the idregs[] on top of cpregs[] */
+    if ((object_dynamic_cast(OBJECT(cpu), TYPE_ARM_HOST_CPU)
+        || object_dynamic_cast(OBJECT(cpu), TYPE_ARM_MAX_CPU))
+        && !cpu->has_el2
+        && kvm_arm_el2_supported()) {
+        /* scratch vCPU is created with EL2-enabled for -cpu host */
+        kvm_arm_rebase_host_idregs(cpu,
+                          kvm_arm_get_host_isar(false),
+                      kvm_arm_get_host_isar(true));
+    }
+
     /* overwrite ID reg fields with their updated property values */
     ret = kvm_arm_write_idregs_to_cpreg_list(cpu);
     if (ret) {
         return ret;
     }
+
     ret = write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
     if (!ret) {
         return -1;
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 6409bec735..847efb1c8d 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -129,11 +129,12 @@ void kvm_arm_destroy_scratch_host_vcpu(int *fdarray);
 /**
  * kvm_arm_set_cpu_features_from_host:
  * @cpu: ARMCPU to set the features for
+ * @with_el2: probe the host with the EL2-enabled scratch vCPU view
  *
  * Set up the ARMCPU struct fields up to match the information probed
  * from the host CPU.
  */
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool with_el2);
 
 /**
  * kvm_arm_add_vcpu_properties:
@@ -276,7 +277,7 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
 
 void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level);
 
-const ARMISARegisters *kvm_arm_get_host_isar(void);
+const ARMISARegisters *kvm_arm_get_host_isar(bool with_el2);
 
 void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3);
 
-- 
2.52.0

