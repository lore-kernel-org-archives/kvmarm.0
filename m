Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D29248F027
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994673; cv=fail; b=Di+vp+k1gQIPrJw7abyIBaTMwusm8jrtmvuZnz5y+0zCmbyz3SvYNIRxSM+sW2iVayBNfMr9PlaeCzF+qfIMjM0zGFRZqQtSQ9XjB2iblBm9xoyNFM9AFLQtsZSj3ay8xKwrUQ7edIi66LQK+lFJDgwqfibvhG8LPzRn4xx6U18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994673; c=relaxed/simple;
	bh=mJOAv01vSkV96I5EVxnrNL7wy5k2Oxor/IgZQpffbAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ce0NLMe+BgLNS7oe2sWUOtEWbt6G9A2wVlNrRn10RrJCysDTvABe6Kpv9kvRwFYywrZPmw5zLOEZrlFVSn9oSSSrgAm35s8zjQHz7LnpkmrBhwCSlieRq2Jm6zb42Sj9G59a4UvQ5azqVCmGW0xM9fu+5S3vXjDNR0PRFXtxhJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=2uKVMXA8; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QpB/7rMx; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="2uKVMXA8";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QpB/7rMx"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAfNtr3340875;
	Mon, 21 Sep 2026 05:33:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=+EUcr9YpDJ2dwgGqkDAfKhKUtc7P/qvdLc+cBTcPV
	6k=; b=2uKVMXA8ZpgcDgwAO3pukgHxW8yS2FdWnuyPsaBcTDb+UkWq6av6hARSn
	fb05DbVt94G8KQk4JsPMF8FfVhYe6J+53BctE7L9LGrwv1VatnAgGMbGDSK6uGuZ
	fbplS+2UQy0fBpRjJSUjlzV6C48MHpDw+P/hykScSWb1uHk129q6pAd5VJVL6VOW
	KNVf35ErYwhQbwiRyAjyOhZQqOYHsHo959/cNwwev+20s5ZzeiDpIO3HzKlSqkIc
	Id8aZFxSB0cnsmPlk014aKKnFzBixrBwOwQL4ajJOmWKwk9CB0gdvBz+QSEKcxzz
	xhXZ2cF+CQO1+FW8NC9mPYwTp6gjA==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022134.outbound.protection.outlook.com [52.101.48.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gssqa2y0v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZfieIQtGyp9nISSHrFk4urR1n20iwpTjrdF9zbHdP+uf1uPzVf/0EtCuvbTjLqGYJ+fFA6JmPm3FY+YiRMmQqjEMB7MoI7OpirJmVP2RYnd9NN93XGXvCUvciMjueQDuJ1RuexajTfU1b2smUgQq0zMlKJHTQp/bXeqPdYMinjEQvkVOQoEGBmr2H20j2ANZdNLDn6LcuFiNA/erFGCnrIKkUmM4s58/YNu2dCqW4faaEOTuFliMmNfGNIi/6VZ+SOXtTdlzbr+M6TZFJNRFN4RSW+EpdPXwE59MoJUj12rtmm6BtnlWJrx4HSpfCKzrpKwwC7xn+1tcnGt19RLjzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+EUcr9YpDJ2dwgGqkDAfKhKUtc7P/qvdLc+cBTcPV6k=;
 b=PligAcpFYeT217fnxrj2PW4IkWwSmGVXWoeVZJesY0V9kIZas0eFbUxdEDQWkjqJa/IxW24I1v6+p+syYNns/5Mw8oPBrp8yrq+dmg1lwzjCuvYS6IT1FGWrTQ1HCTIQDjUD3VtwDLdnjOK7p/GL5i3XerMUPxwZs1LGTkycMy3uzyfYH3OcAk56UpNG4GStWwekLI7aQx6efSS3Id8o4U6MLcxO9Ooe6OJnWgUrH2gqvDQbQ4UZiufQtLxsPGgxUZqe6aZKPiTH2ZMY+iOcO8HELjWAtSDJMpP0SEUJMoE8l1So0O88PWUgnJaUj9ov9j7wEYrIgf8hSC5tzAgF5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EUcr9YpDJ2dwgGqkDAfKhKUtc7P/qvdLc+cBTcPV6k=;
 b=QpB/7rMxeybvVXvZtK8leIUA28E5gHOuj+54q817Fl2CxNfG4kz+bPvF0NP21DYOjB0Pqa8pj57bD/Rw7mPhc3hnvNd7b0C30G9EkQ15QfjK2nT4+V6OppfQdE4vkwJ8QlT1SsaUS4rzpDaNNFTdBsQadDV85kA6ioa5EOUIgO/BgQSqlJovLl9+4YFUB6GBaSFJ7CpwQK1fOdCg8DbuHKn1xgTbCwjMgQY2vZ7ZTuAXv75teC12M2njjmzTTkZqToskloqmUlJ7jnNqt7DJW8PF9nBpwzD9bUntDFKf5Mm0pJoBALSSivgRsZwiQ2Cgh+uhIzwvAqbWZx33ljeriA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6868.namprd02.prod.outlook.com (2603:10b6:a03:234::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:33:39 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:39 +0000
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
Subject: [RFC PATCH v4 21/25] target/arm: report 0 as supported for ID fields gated by vCPU init flags
Date: Mon, 21 Sep 2026 12:32:45 +0000
Message-ID: <20260921123249.1708067-22-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 82eebe63-d637-4163-a7ea-08df17dc9059
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	f27DNR1fvyr6ZdLtqMRc/k1Hdbd93CYWrG6r5B/++zrq48xtIfu4ADWrqUtP5UVums2cdmw0nWlL+YOW2QJuNXowJpZrApXods04u9G+VdNcwIWp5ZxMpUQE2SeiMIioQ5lQQ7SGmrSYLZMvGFycwkvpOFYwvten8vz7ZIBehNnfS7GGD2mD31ebluo5SCKgnaIWRUQfIza8jkg6xoG71j7tcCKGGbnFf1uqvy09atWO6TFubDOa+MpmfzXmgEXNDrwTrUIQeX62C053eL/yq8/5qMr3vWHg0JK49wRbGyBDkzYMWzx5Ybl6pNwxFRR04tOtkQMLHoyHOgIk+W2/ZTBomlJXgod5hc5Xg60LufRUA9ik1Qz8MQ2aCXsYksKaFSWs2aH+YnRcTLAa0D+s953BjzMPxFY+C56l1jXGqId2Akpygt+R27off1trgnOfGyzoof8BXAFX7NFQoG6SdeRhtIW38Cb17yowy8pqXgRnqeBE7Y4tMP34eImJDSB2PFJ3h6wbT2PBoTCfc2g+vkvLXWkILQlo0jLQWGm61NfBo/P5DUibGS65KXq/wuud3KyO+hjBuKssleBb4nmUonnQwaDBrHubHYnqbzVC7BYJbNwZRXHOimf106kbPdGbiGubg6ZjaC/UtZcoDZ9/m4p3HvA/Ac5wdygrfO9EzzQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JmIO1UXq6ia4fSQZ2D2eGmUQURKRiPiRXa9lFdzhfdl+JYKsK/glMe9T8yQF?=
 =?us-ascii?Q?CRS54KAtQZIlUMnr4uzkAYK7sodTQiIr0BHNYPXFh3nRWRbKAeF0U9RkjHUg?=
 =?us-ascii?Q?YDVLeywHLNwjt+8CHzMKCyltxh3VQpwy6rAAXu1SfqDSPpmAYmXNnal37PIk?=
 =?us-ascii?Q?VbZHBmylTl6j9fHujcrKsyk1Cpz1w+WeQiM72RPamYjspCWHJ6/EvLO3OZRD?=
 =?us-ascii?Q?OdAYBrd1gJQ1wW0VVCL5AZgX4wovUOFwUz2RHLNookmknt/BLo43Coy/Hdx0?=
 =?us-ascii?Q?huPurdrmQ96crKMcKSxP3ZGqAl/RhMQeQibBZ5tlHXdW2x9PFMEYuNH7b3mq?=
 =?us-ascii?Q?hE19uw5J8OtNdEPaE7ewrN0bIHMmy5w8iTOZo9qox1LX3XHUpAUJkEs1fTQ5?=
 =?us-ascii?Q?zf9nFlsLZACEMLfSJWw/9NjGOmT8WYc5GnN/zFU03W5jV3hRvCgwlrc/pxgB?=
 =?us-ascii?Q?oUFHaPwpsWNFiWwSKqUPBqtToQ0oRCKY4VFBRkLGCBICC3ag58bK/w95uyVZ?=
 =?us-ascii?Q?mEtnb1tuugvvRCDnZGuJD90MNrDiOA7ieomWhkw6F9EcM50qbeCEDffs07z/?=
 =?us-ascii?Q?/8/xS4/TMA5rYJoVf4lgm/2SGs6Gfo0WQve3gOmcWBDWUhEn8Kkx4MafR0Xe?=
 =?us-ascii?Q?LMk0+wN2n0SsPS4aMpM7FFUVVbsUd8O50P93nFsL2vC/nbMCdmNsOBBKf75p?=
 =?us-ascii?Q?p9vigQb9LVVZpoVWiH4qYSgC51jO5IpfMJWZKDPqFBWqe70qUyXyWpM2nfp+?=
 =?us-ascii?Q?ULMC5PQOASlBdmhEhKq5VbY49Gc1PYuz2V84JgdjvAj4UbVHD5dmL9ycznbd?=
 =?us-ascii?Q?qbv/Plqa6ELk2hB4bIlxeM+V04t6K5PRJdvlpyTCkd1AE0XjzRRLx9+blw1H?=
 =?us-ascii?Q?Ca+wB21DfnL2UWsWJMq7erez8G0ymFEEKnTFPHtnQohsSd6mmv4SGSs+e7NA?=
 =?us-ascii?Q?xH6nrekJK/LNgzUAnPxeAx0mj3C+h0ZKW+UUDE8zl54f6TZnuinnjLB3e+RB?=
 =?us-ascii?Q?lBObLMhp55dqNpfJ2LZ/ziXh9ztUPz5tIGpxBQX+SFYbB4Ns+1x6dH+I+3XH?=
 =?us-ascii?Q?JNtgVP3g626KKV9xmqNXTTe8sCC/fEtFuNiv49CJ0ohoEgQsBGYu5z8CwMrq?=
 =?us-ascii?Q?IxaZrZ73ZiYnkS0hRFnvsm0UtoBZQCJerTyvUx8SrUxpnsuyy4oTH4DJjgHB?=
 =?us-ascii?Q?acYCJMSTaIYAeW+8vWi5LbXzTn5ZJ1mTRjhdC7vzNLn3cBTMVk3rOe7R+dWp?=
 =?us-ascii?Q?PJmGxdJkAcEy8rXohtcBnRTiE/PQTyO8z0hpzemn6sfkvv5kdT4u622WvStz?=
 =?us-ascii?Q?3ZbyU5nXMiiCxX+c2Xa66xd9NrMIyBuZz5lGgCcV8nrpoyvPNfOWZTH5/3Dt?=
 =?us-ascii?Q?o/dQ3Hs0Pa/RVdjj2kI2FYYcVyWtvGouPFDlZBCSysl0axwldR7HCSSr6qcy?=
 =?us-ascii?Q?0lW5qrx4xtnC7VVFYAoqSjcPf5cJ69d2sIiheAOafaa3o1a4YngYOhUxxwpQ?=
 =?us-ascii?Q?mHz9RoWHogv8Li6ALnZD8xxHx26YzX4t+wt4DD5l+jva5aXmAicdsxoB/RIr?=
 =?us-ascii?Q?fYmbierpR8rDGrKVKk5GQq82ZyxQEADv8osk/1D6MuU905vhmmiUwiJuOR6k?=
 =?us-ascii?Q?B6w1HvltTk1sTzAl4TgukilwKo6qqlptUPZDkjUkhmNjjsVyVMt0fB4VeQ7D?=
 =?us-ascii?Q?aSf9EsplLeTFqy24OhkHxtMmMqvxV5LAhsMjajJ0ih3BBs1VGtaRpxazE1Wg?=
 =?us-ascii?Q?06N39GX5s9iYiswF2fX6eemg4HS8ZYs=3D?=
X-Exchange-RoutingPolicyChecked:
	Etk2iNSygfJnD8Hvc+nPX/C3R0L1WfH74baCr5HcvwWLRAlsHukAGmi/zWziyFDaagTmKBQjKGUWrzm1XS1LpJOPVu0w7B24O/HQpp6Nh/na3DAdfa7HJxA8IUnZJ2YhCAW2I+v/lwPwuAJUOgs7wy04fgmTt8p2ePW6342teq9ZFmIagFn36VXnv1zig/voQ/L9eHWwiEgxvqwabbVtLwAZz2FhkYaNdJ2PjZOWy+3pDba/Nj4tQnHYR23EJ515uJS9VPZiuDYkPr7XSwaoFX4Bu+QrJQy1FIyrsx2ryjRUclTqLyTLZPlUEnYUKYkS5bLCJFsfUW7FO3Ut7Ve4IA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82eebe63-d637-4163-a7ea-08df17dc9059
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:39.3305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5yRlX2MtcBvp2w5WK5jOpCLbRA4DR5+16wVFexpnx0bdJ76B80TsC2pZuSbzqugI+sTgs8OvClEX2wDPqFz32U2MjRb+Kw6fxkou2y2d6rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6868
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfXx9fZs2qEij59
 PxIKUbl0rg44TluitoQRGKzcY0+jrePAcHQqL6SAl0O8bNZcXbk7NKqP8U7DJ5+JBGNBhljUsM2
 sJgtu4HpGJ1gpJRVvHJsuqzjERRT9B6O5Osfby1A0kk/D1PDkWIEHNLGXbiIoZ8lOOjtBxlqXbn
 MCfuS5cGvkS2n3qAnCClnLu5na4lU6mT3B1/VM+osVjv02tUbC2zlFGPcRP6CgiijVyxQGqMY/m
 FMep8xEDHfaIsFi97+ay7ZMLaEqa2n40T21r7uM/PrJDmHxdn9SJa1A5nBc+qWXArRS9RjZRfUI
 OWIl3yHbDfVoVqinRYS6BYl6Gt7u2uuJ8j/Rm+UPr1sjxoS5XE5GZ0swQ6ZRJlRM3D3O7Y/YOfX
 dLZqmMYoZ7+G5Fb0ydT0oAfKUV+kHAcc9Hg1pz6aTeHOi4/+zaVrioIUn89nilgCRiHOw5Yi8W3
 v4k0puR6mdR9Ms7zRMQ==
X-Authority-Analysis: v=2.4 cv=DfeCOftW c=1 sm=1 tr=0 ts=6ab12426 cx=c_pps
 a=xo3zWrN9qLO3Lphhql2lSw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22
 a=64Cc0HZtAAAA:8 a=AgFlfPbjf6SEF9yYaDIA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX10KtP0M6n+fC
 tiP3rW70UQtPVa4Xfo6vaFnt16NCXcPP7CzxWPRtAaI/yg+VZxEgDnsvSLdjNsMOA7d64Fdel9D
 ilcKkzzF3nrF9nCyzpqVqF/CGKg5yb0=
X-Proofpoint-GUID: iUzoY1eT9dWTeicMvtog9eN5ZbFF6YH-
X-Proofpoint-ORIG-GUID: iUzoY1eT9dWTeicMvtog9eN5ZbFF6YH-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

When QEMU queries the host ISAR via KVM, it uses a scratch vCPU
initialized with all host-supported features (like SVE and PAuth).

KVM exposes the corresponding ID register fields (e.g.,
ID_AA64ISAR1_EL1.APA) as read-only. The supported-values list only
shows the enabled host value (e.g., 5). This falsely flags a model as
blocked, even though the features can be masked by omitting those flags
during vCPU initialization. For these fields, even if KVM reports them as
non-writable, we explicitly append "0" to the list of supported values
if the host value is non-zero.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/kvm.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 77b1bcdf55..0b5fb49dff 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1346,6 +1346,24 @@ static void ranges_add(GArray *ranges, uint64_t min, uint64_t max)
     g_array_append_val(ranges, r);
 }
 
+/*
+ * Some fields are reported as non-writable by KVM but can still be
+ * disabled by not requesting the corresponding vCPU init feature flag
+ * (SVE, pauth). The supported values are derived from a scratch vCPU
+ * whose init flags may differ from the real vCPU, so for these fields
+ * "off" (0) is a supported value in addition to the host value.
+ */
+static bool kvm_arm_field_off_via_vcpu_flags(const ARM64SysRegField *field)
+{
+    return field_matches(field, ID_AA64PFR0_EL1_IDX, "SVE")   ||
+           field_matches(field, ID_AA64ISAR1_EL1_IDX, "APA")  ||
+           field_matches(field, ID_AA64ISAR1_EL1_IDX, "API")  ||
+           field_matches(field, ID_AA64ISAR1_EL1_IDX, "GPA")  ||
+           field_matches(field, ID_AA64ISAR1_EL1_IDX, "GPI")  ||
+           field_matches(field, ID_AA64ISAR2_EL1_IDX, "APA3") ||
+           field_matches(field, ID_AA64ISAR2_EL1_IDX, "GPA3");
+}
+
 void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
                                         const ARMISARegisters *host_isar,
                                         ArmFieldValueSet **value_set)
@@ -1358,6 +1376,13 @@ void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
     /* A non-writable field can only ever hold the host value. */
     if (!arm_field_is_writable(field)) {
         ranges_add(ranges, host, host);
+        /*
+         * ...unless it is one of the fields that can still be turned off
+         * via vCPU init flags, in which case "off" (0) is also supported.
+         */
+        if (host != 0 && kvm_arm_field_off_via_vcpu_flags(field)) {
+            ranges_add(ranges, 0, 0);
+        }
         goto done;
     }
 
-- 
2.52.0

