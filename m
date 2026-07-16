Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42193C870E
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237998; cv=fail; b=ZQI3pVGyQ+Kus1EsxZsHzO6hRoK/zj1iRbm4xXwPNoJPbX4ypa4EdebBf+lXfRQDDE8vvDY81+g/cK0+4WOJ6Yu8hb4dgJRVmKUT3EDzSgzwyTeEFA1o+/wrTZRN0NdmeuitW+Tosl69DHQa6blZzyiNAihqSzkr+6VM4LTZCw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237998; c=relaxed/simple;
	bh=315dEOmel467aWffxtWzJzl6DEhah6l3/8W56t0aRMA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CnGPMM8m6sUm1hkN9K+aqdvjIJEXFzfDtfqhoiYjXJf1kWAWqmgPNqUfDH8YzTJ1bTHNTKQcqqmWoaGhxfRT4X04zrGkkOWLCxTODQSP6a1gUZd7p6t7eYR2HsXp6TekSsF+gvVi5G/nvwe1lelxorme7G3qdF+pVKOv5byPpWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=KzicOWhA; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=t2wVdTFE; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="KzicOWhA";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="t2wVdTFE"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZhj1763910;
	Thu, 16 Jul 2026 14:39:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=mHL3eFfjmyBtu
	27C6RDtGAtHlr20q9HN4zvksuC8GNg=; b=KzicOWhAvC6RMN1SdolRS3qSD/iVa
	DJwWf3Fv4FlOMVa0FBBq0W+h8Ib3auXo/Jk5edRBcprxlgmNecdCQ+0XSzfLH0iN
	mGAfdPa7/3SPvoiKmhi6EvdgblpK5l8XHDSNgkjWh3VsazcfsPnppnKKxo7HCgdA
	Kx0KrS1pr1O5iccGK+fiJ4pvRa4xRdYCLH63BhXKUTGMzbzsukXomrna5u+B0cCY
	omislLuGjkPi0qSA0VnvWmhrl/abCxrk4w43akkp3LdB8NAdWnr3N4Fc6nXv0ChX
	L1VCo1L4Pm2bMjFLeumD8IqioZGxvjAOwPDZ71U4zsNlLaOdGE7JaNY5Q==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VZFrWXarRF5Wdwpppk/sAVFB9b7UOH5jlUHYbNd99VKLmijT0cxW6xq7n37RxT2rs2MrSl98beN7lTiqhYp5YqNntsH3iBq+aNoYxKfNmqi2bcANvuLWyFmMC5hwagUuyGaSJEn2sTHMcJXxwabgWHkps7RLr6GOEmXY+SdI40DB7LUuIWVCpUMg0Lgkwlh9npGPVAQxOKqomX/Fpb45CL6bitGbQ/1RDY10VQJg7UzolaonSaoMnKM1M94GSJ5x1JbuBjrIh397gjZp8om0R09lgB91aSAI1EcFrFuBr3OGWaJUfVA54RcZtT6gPIzv7HPkf/v0BvFXjEmSvCH1PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHL3eFfjmyBtu27C6RDtGAtHlr20q9HN4zvksuC8GNg=;
 b=U2Gd29W5MWwJwFz4elUzYBMaacrdTIFShW3pfNsjIKXDc+Pz0+CCmb630XI5GwF14PB/KnpHacPpCxPkIdpMPNW4psS+gpi+jYPaVzi1/6AdvBBfY4kl/CJg/m93KTv4H8d5tuxXPaaKIaq3q8uU7LCTZ7vSufHOx37J1SfY/sbe8BLZ2a+8zE+kqPDtgWJi7E2WwUrQPgjBNo3/rQKgrT3WauGTBUTph3wYj2puaJeo0VcMHQQLiDtP9ylfzmAV1mBrfLVt2tjKIk3r7R1kR0OBGigqD25bkwQNa03xuCb9ai3lbzc76Ws4EmdHmmDWIHJVoKKZLvkirxsKODOdzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHL3eFfjmyBtu27C6RDtGAtHlr20q9HN4zvksuC8GNg=;
 b=t2wVdTFEKqLKsLvmeECWj2w5QH/kDfWbuH9KiU7A4ajEBMsnfOb2Q45t+M5rldPgkrlMiKfRj7xVpeFdUEef5tXS6ABuor3mh8NJWeZowUuhHe1FwvbrvRYSoQ/E26pAoWtRK/cAk4NGU+bH8WjH5FVMk7VXk5RKetTg9I3Ea3JzWk9Es6xvs70cicIJQdzWwhQutGYKVA4eqaZgIKwxzd7Sl3trQJcRUpcw3+WWjxyxH3xtelisTl3NfsVCBirDKAy6Pi4uLfC3aUb3NuYR79b8ArDhRqvllmDgm9W6aYm5xx6zpUdUYgE8wQD4lWJjzrWHifB4kO03R78FQ9TxAw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:27 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:26 +0000
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
Subject: [RFC PATCH v3 00/19] named CPU models for Arm64 on KVM
Date: Thu, 16 Jul 2026 21:38:39 +0000
Message-ID: <20260716213858.609699-1-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
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
X-MS-Office365-Filtering-Correlation-Id: 30ec41df-0f1d-4ec6-b112-08dee382b595
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|18002099003|5023799004|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	pfFQYhSgaTYHZt2MIxwYeFhJxUPJinmsS27qsDw+ep/BY8u0fyJQggDfRgMyzzaQdZeS8+vfPBOPclCYx9zzrtM91+uIajkKlo+dYBf+xz48VDH7n8/nK36iw9nfUaXCad1xDhPVAO5lQ6fv7jbka+e/ZhH9ke5fsq+VvfFAneYr68ZmwsRdBL/48DlpRW63EiVidUTAnsTqcz0m5GTFcTK0RlizSqyqDaFpgaKAsah6zruoOk/9+OtwXVPPm6t4cMsoxsj6pn4WkDL/hYWVMvzc4LmOnCvqJP//y5qlebNrpfW0/52tFJEtb5gjI4psElnd2hn1XifhMpMznOSOoPw+io/71h133hNw29ekwuR17R3JIwT3gHEo0o2NeyrErQ90iHNfA8aknJK8JkYwC9auWhqu1LPrNRMnjoCKkOiq0x7JkU87wVq+vppyYKuX6Gh3kkv+UIF0+9c21UWiEkqW42xlGjj+QXoS5RaXjdFVNUnQ6dp9wlG8L5/gUUOtY3VUPChRdH/bhfmNXDN8AP4YtVk7ayQjBzl9BJEHjiGn33g0GW80yhmgXFX9diBCmy09vBUJohOVZKRkQ7c7JfDM4aLr23mDvVfBaPQw4Gxq1u3lCOpHhxExPntLPEcFz1l9b0/jg0gDajwwDZNTYICRxXQP+8TorFJPCE/tRSk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(18002099003)(5023799004)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pdXUXPkbZ8q5vcit+hWM67skiE+aWC8e0PYV0R63fsMbFj9VxsdQt5gVKXpA?=
 =?us-ascii?Q?ThqKbToWNoZNel4iDd6rUJnN/qnPgjur37oPZ1+PIsxcJtVDPWSG7swh+xlG?=
 =?us-ascii?Q?jiWsBCCHLOEX4CqGbmIRM8N+dKYyOq7QARfzrmf0cfhArcqQUEMxY97CG9/c?=
 =?us-ascii?Q?rdVwfGQSmslenKDeEvECWCJKPqqxLXsVZZW/ggKJyAP4D7hni3FZAvxnBj3h?=
 =?us-ascii?Q?VE8ErKdxgmipuhBOimxj1jf29hXBzorqSGtH5LRWcTysvQb0LtkcHfmmYOU+?=
 =?us-ascii?Q?1cwmeo5+Zi36AK4bRWLwtrYS8Zhv3Q/sPJ+4CEGNX1a3oeMaCUuWGx0rJMbX?=
 =?us-ascii?Q?WB0GtPNzgyjv55tFabXcQSeSXHNtBvTOpBy1HGexvT6yPUGhFCXcCHEEM6Wv?=
 =?us-ascii?Q?rYcsMY/SrjdUJ8XvILKpWYeQGMvZ4M5OwahntZCcUCn4P9Lzaomp39bO4ecy?=
 =?us-ascii?Q?jpaioO80tOL0K8sLlR1ciNx7/xkuLy93nAwyKzgEDamtJvAeOtBJOTiLgYf4?=
 =?us-ascii?Q?7Cn5XQ491Rp6jdtzwV92NcaIQrFVkmAoyU1Rv6RRm0scsGT8XPIo55suZBLt?=
 =?us-ascii?Q?kiYJjJZZAqLmMbP4jbUgojxlOd3Nx2PjE1Z701mk4vdEcJjQ/Wpr5vflN06F?=
 =?us-ascii?Q?Ds2RmjNKihRAJsqwP8jbfbdeK9XydCJqiVdUu2D3z686UeZcYwsXitGblzax?=
 =?us-ascii?Q?OIVgiHr/Qv+TMNFvz7hVdxx8YgjsZZzp17AIAebgQdT+AY4GFH9+llMGb5YY?=
 =?us-ascii?Q?EAsyxXUPQvLNUzwStvemQZ3eGzMK32MkEMv0OYEOi3QQywNxR7viQuuERNwh?=
 =?us-ascii?Q?s0XOvvOCaxkGUxqe24/m8gnI1fwRPtcS6XYrQkO0y9onizS/68mEm58G3xd/?=
 =?us-ascii?Q?GzvJ36QBHp5TJc+mm6R797LppxVOY/P1anQGlyVeCL9PJuLpDb/lzwX/YXpV?=
 =?us-ascii?Q?u2i9et1B7rrCZQ6blIPOxkQ6/bu67f4Yjd/Vt9oHpPjFILC11CVlejPXar3h?=
 =?us-ascii?Q?VpeDqc9bGy/UJFDkVTTLjGqwTWtVmDi08x0LK3pbIrc2Ru/NTuvbLix30zvi?=
 =?us-ascii?Q?B93eaL0aIuScx1vWjS60EA7bTPjkcnI+QJC2YKBsqe3S4wTGOQDlQuoxhrgp?=
 =?us-ascii?Q?xd9wFaWfNhfLPaLvpQvufi2IZ9acjq6vv7Mz34xG8NjwUwKx0cFWfliqvgu6?=
 =?us-ascii?Q?cbyTr1NT6nS9Q6cIPERr5r4/7JDTOLaONztbBWwQ6O0TKHyRtKzxiQ2Rac+/?=
 =?us-ascii?Q?Shr5In6DZ5g1Pv+uU+eJr8wZCsY7KhpVElHQ5z6afQ9D4BEb1200Tk+SlfVZ?=
 =?us-ascii?Q?iJDJ9X6jOxMCVl1iEljfzvbHTPEiD9Rdv7YBsLzq+LH+EWnUIw0XjHkweSpC?=
 =?us-ascii?Q?Xx1ka8MFUoZSGSmIQa36erZVSgDri588a8IRN4rvBeCx9Sx6eOEVGQfEqTZO?=
 =?us-ascii?Q?ehg57Zk3mVx/7jLYvtoCvHejfbtdIaMCdBy7kEi57v/1s1wvfy1km8xInkJ0?=
 =?us-ascii?Q?/2oi38tzZITY/T2KOh93x1ttVLitEJpHEg6dSbehrVqD+C6bZfGbXi3VbWtg?=
 =?us-ascii?Q?6Vx9GXDpI2W0TNcGqQuNAYayhPJK9/42mqrNpKbSyJCq+5fcy73P5LZZfZmb?=
 =?us-ascii?Q?BQtRNHEouIdR9XNiJ5NSqr7WVockEoz6iC617ikY2OAs21siAbzkX1PtURC1?=
 =?us-ascii?Q?RKtH8S+YEpePXYP3n8LvHXvdibVIp3G29riGhue7ulyeKnq5A8xE89oF0F9f?=
 =?us-ascii?Q?ktpi1vD7zj/gSVzFCnZCje75h4kcDis=3D?=
X-Exchange-RoutingPolicyChecked:
	VxVEp1WzmGddfGBNsvVCFdrZM8uIpF8CPWb2jxxScVlcMa6CMh9d4U4ChtZw0fkCqSmpeYWV+XmIgJEEkO3cUsZvOVFnkZQPrrPWTyyteFZsg5g89qcrLbYOtOnPkz8bW+YirvNi9BonlTHoxaZVc2emDRxZ2De5efeFlmgKojDxSkIIE8FCDR1ixx/16QZO4cpZFJBjliz5r3ZpEYw1JbnbDcj+EhDVuzyM/tpac3mpXHhWmb9hSt53blMPzfvFGsz6chO97Q1/C3IOxLTsWGbZObCZz09NJHxd/9pwwFuvdjEykbnFPV5A5sXhK8drzK36duxA3at65XsklnVwsg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ec41df-0f1d-4ec6-b112-08dee382b595
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:26.6892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RFm+Bq3Ysz+wEZ0Kbxs3tFJYp/mhHQU6d2Z2Mfzclt7E/bwOrMihVVBbMOwWKmQ7R1IafHkOHxJM+x5jzmILCO6L+SOCTPnyo28CEq+9K8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfXwJ6j3KKwKjgR
 EMpENswJcogSGfoDwePKXd+tBnlX28DLg6Fa3VuDFF9YXw8fXeQOOZz/0Eh+hhlu2jq/LWC/fSe
 i8RDa/Z6uIU6PVh0Bzf/ZXhiV6nNxuWzZBU24UPjqnA34iQXVFvnBoegc9xkNrlo7p6oJl4gDUS
 hQ8Q9oJma5yb3XuojEeV76edN3W6Tq7mRzo7Lj+hVXNZcyebqi87haLT06hDWBjt51AD+UaEWS7
 70+8l3a89HJcrYpq16CvI5cMB1EKEh1DUWCTmb6Ojl2DPsH2+jEq2VNqKum5FzknBdaYJmE89Zs
 KlwxVMbjij7nQHLZpGQW3UbtheecgaCz97VuxZ19Nf9vsg2HBskx+3MxQJm8RW8KonlTQmGvuCv
 NG7XgP9TjaN4hu4OgOpLc8HLVQFj7U58QlbJv291ksFdWWoCtoVkNDQAdfqLWF4kJaVqT/TZ09k
 FyY/Zdzb54dKw+EdBDg==
X-Proofpoint-GUID: AkKZ_1vvC35zVyq8AmEH7cJeXqr51d7f
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfXwhvPA11I/wqP
 FSozYUzfauUjPAvY/dlQy2s999BilkLqBRJaTThkALp+fxz6mqjmhqRhyJV80bnCmaky99FOzsf
 Gz0Gl9SvUyS+JDfz72KtniQf20xlOrc=
X-Proofpoint-ORIG-GUID: AkKZ_1vvC35zVyq8AmEH7cJeXqr51d7f
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f92 cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=voFN5b6mtPBfHzA5n9MA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Hi All,

This is v3 of the RFC adding named CPU model support for Arm64 in QEMU.
The main change in this revision is that the series is now rebased on top
of Eric Auger's "customizable host model" series [1], and adopts its
per-field SYSREG_<REG>_<FIELD>=<u64> property convention. v3 also scales
back a lot from v2 in terms of added "stuff", removing the concept of
"composites" and the support for exposing cache information to the guest.

Background:
=============================================================
Currently QEMU only supports -cpu host/max for KVM on Arm64. This blocks
live migration of VMs between hosts that differ in CPU features.

This RFC proposes hierarchical named models for Arm64 under KVM. A named
model is a strict contract of the CPU features exposed to the guest, so
the same model resolves to the same guest-visible ID registers on any
capable host. Models can be customized further by overriding individual
ID-register fields (e.g. SYSREG_ID_AA64ISAR0_EL1_SHA1=0).

On top of the models, this series adds the QMP introspection support on
Arm that the management layer already depends on for x86:
`query-cpu-definitions` lists the models a host can run and reports
blockers for the ones it cannot, `query-cpu-model-expansion` resolves a
model to its full set of properties, and the new `query-cpu-props-info`
reports the values the host supports for each property. The aim is feature
parity with x86 so existing tooling can consume Arm named models with
little change.

TL;DR examples:
=============================================================
  # Boot a named model
  qemu-system-aarch64 -cpu grace-v1 -machine virt,accel=kvm ...

  # Named model with ID-register field override
  qemu-system-aarch64 -cpu grace-v1,SYSREG_ID_AA64ISAR0_EL1_SHA1=0 ...

  # -cpu host with ID-register field override
  qemu-system-aarch64 -cpu host,SYSREG_ID_AA64ISAR0_EL1_AES=1 ...

  # query-cpu-model-expansion
        "model": {
            "name": "graviton3-v1",
            "props": {
                "SYSREG_ID_AA64ISAR0_EL1_AES": 2,
                "SYSREG_ID_AA64ISAR0_EL1_SHA1": 1,
                "SYSREG_ID_AA64ISAR0_EL1_SHA2": 2,
                "SYSREG_ID_AA64ISAR1_EL1_APA": 3,
                "SYSREG_ID_AA64PFR0_EL1_SVE": 1,
                "sve": true,
                "sve128": true,
                ...
            }
        }

  # query-cpu-definitions: blockers reporting
        {
            "name": "graviton3-v1",
            "typename": "graviton3-v1-arm-cpu",
            "unavailable-features": [
                "SYSREG_ID_AA64MMFR0_EL1_TGran16_2",
                "SYSREG_ID_AA64MMFR0_EL1_TGran64_2",
                "SYSREG_ID_AA64MMFR0_EL1_TGran4_2",
                "SYSREG_ID_AA64ISAR1_EL1_APA",
                "SYSREG_ID_AA64ISAR0_EL1_SM3",
                "SYSREG_ID_AA64ISAR0_EL1_SM4"
            ],
            "static": false,
            "deprecated": false
        }

  # new query-cpu-props-info: supported values per property
        {
            "name": "SYSREG_ID_AA64ISAR0_EL1_AES",
            "supported-values": [
                { "min": 2, "max": 2 },
                { "min": 1, "max": 1 },
                { "min": 0, "max": 0 }
            ],
            "type": "number"
        },
        {
            "name": "sve",
            "supported-values": [ true, false ],
            "type": "boolean"
        }

Planned Items for v4:
 - Strict forward compatibility: Right now a model is only safe against a
   newer host if QEMU happens to know the new ID registers. We can close
   that gap: the fields we care about live in the Feature ID space
   (ID_AA64PFR0_EL1 and friends), and the architecture already guarantees
   unallocated encodings there RES0 - "Direct reads [...] behave
   as Reserved, RES0 [...] if the encodings are used for ID registers in
   the future" (DDI 0487M.a, D23.3). So any feature ID register that QEMU
   does not know about must be "0" or enforced to "0" if writable by KVM.

 - Special-case handling for CNTFRQ_EL0: make sure heterogeneous migration
   does not happen between hosts with different CNTFRQ_EL0 values.

 - Remove RESx properties.

 - Both series struggle with how SYSREG_ properties interact with
   already-defined QEMU properties like pauth/sve/pmu etc. We can solve
   this by verifying that the cmdline property values match the
   user-given values after we finalize the properties (something like
   `enforce` in x86?).

Khushit Shah (18):
  target/arm/sysreg: regenerate cpu-sysregs.h.inc
  scripts: bug fixes in update-aarch64-cpu-sysreg-properties
  target/arm: regenerate cpu-idregs.h.inc
  target/arm: expose all ID regs fields as properties
  target/arm/kvm: enable writable implementation ID registers
  target/arm/kvm: Read all ID registers from KVM
  target/arm/kvm: handle special ID registers cases when reading from
    KVM
  target/arm/kvm: Handle writeback for special ID register fields
  target/arm: Add Nvidia Grace named model
  target/arm: fix sve and pauth finalize for named cpu models
  target/arm: Introduce stub files required for qmp support
  target/arm/qmp: add named models and properties to cpu-model-expansion
  target/arm/kvm: compute supported values for ID register fields
  target/arm/kvm: introduce kvm_arm_get_host_isar helper
  qmp: add query-cpu-props-info command
  target/arm: Report 0 as supported for ID fields gated by vCPU init
    flags
  target/arm/qmp: hook blockers in query-cpu-definitions
  target/arm/kvm: fix host model writeback when kernel supports EL2

Shaju Abraham (1):
  target/arm: Add named cpu model infra + graviton3 named model

 hw/arm/virt.c                                 |   8 +
 qapi/machine.json                             |  87 +++
 .../update-aarch64-cpu-sysreg-properties.py   |  67 ++-
 stubs/meson.build                             |   1 +
 stubs/qmp-cpu-props-info.c                    |  12 +
 target/arm/arm-cpu-models-stub.c              |  18 +
 target/arm/arm-cpu-models.c                   | 533 +++++++++++++++++
 target/arm/arm-cpu-models.h                   |  37 ++
 target/arm/arm-qmp-cmds.c                     | 111 ++++
 target/arm/cpu-idregs.c                       |  19 +
 target/arm/cpu-idregs.h                       |   4 +
 target/arm/cpu-idregs.h.inc                   | 165 +++---
 target/arm/cpu-sysregs.h.inc                  |   1 +
 target/arm/cpu64.c                            | 198 ++++++-
 target/arm/internals.h                        |   6 +
 target/arm/kvm-stub.c                         |  24 +-
 target/arm/kvm.c                              | 560 ++++++++++++------
 target/arm/kvm_arm.h                          |  52 +-
 target/arm/meson.build                        |   8 +-
 target/arm/trace-events                       |   6 +-
 20 files changed, 1594 insertions(+), 323 deletions(-)
 mode change 100644 => 100755 scripts/update-aarch64-cpu-sysreg-properties.py
 create mode 100644 stubs/qmp-cpu-props-info.c
 create mode 100644 target/arm/arm-cpu-models-stub.c
 create mode 100644 target/arm/arm-cpu-models.c
 create mode 100644 target/arm/arm-cpu-models.h

-- 
2.52.0

