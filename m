Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7D748EC8F
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 13:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995748; cv=fail; b=RcsfWqSt2U8Si2avFBRorfQ8mN3+om9FvfWINcJTt6egmOcKU2wLaUdIRYMyOOEnyq6f3+fiAAEB3hq82vuo340raGS6RelV6yFYX846UgL2Nveps/Q9Gd/28s6QS1cmNt+VV/cuYSXLbu5AAJmd4yIJplwhPnVpRt6227ZBjGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995748; c=relaxed/simple;
	bh=VhQzB+Cm4Mj4RlQ2UdUV6k1hJMD+71wLVeQkcReZMDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IpRRljmgl6X7AUvEsy0QoeKVTjN+3hTCzSTjMggeK17FUNeZKgJNHmPEawn161MGcqqkU91wuEZTxr5q6tUx7Zf5udnalHzOR70NzPz4qwWrxa99lMvigORvsIjpikiytwyHZ+ZPZi8WcV9r/QKPWohOMJTuwcK7tcHT/zMUXy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ncPmbJDd; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=dmlh+mcV; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ncPmbJDd";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="dmlh+mcV"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAflUE774316;
	Mon, 21 Sep 2026 05:33:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=bEwf85cLdgg/8fSzwCvjaNjstIyJ4mCyPz9i6LIJD
	Io=; b=ncPmbJDdr4tDv84UU3Taan+X+m+9F2x+wo8cXaArZZM2l0/Yoh0ovwSwY
	qcbc/uAwKQiEJ6ox3DGrCuIRKqOMGGoWOwtQMyXQaKvnGOkaglXUYqaZS1vHojrW
	5ZefFhT6EUXBKykdRD+zmMfmRadJM+TOJH2FuY0a2og9Z3FimbG/zbL11mAso014
	7df3kUjwb8bNJ7fCxCe326y8gBZyeJsvvqZSI+ubaZpZD11knCEmRng9tH+8YH5y
	76tueVbJl6D2CsF62zzSg/kL2BCzGrfkwNLk/Y1Si5+hgs/AhrzZIz3cG4TLq25i
	5Me0js6eU8fADn1EASW7/bl+NjxJw==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11021115.outbound.protection.outlook.com [52.101.57.115])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gsqx831cb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vq76R/AJAidAKlO7kpzPr2mEGq7dlkDo2KqEQoqa8HYlduMAnJlPjAiToJMrjoQc87npWPGAUH0pl6yw7Ea2WEggPU8UkVcxsytczoSrNQH6gx50n0bpdxuDXLrerKdwHJV8F7T0i2qZIjj00rheAh/vU1yWHEaDRGcVTemJq/8EqIZeRdKjWkTayOrcT1N1Bc1Kukgs25fmr6RPpldnVN9M88hceLbzKyGYiCb7n6ByWqcIYNWGnTYIP4VR1crem4MNRcsEmcwa1wQ+hG5w3gElO5Ku3PxooV19uPkhFdLomnydkqW+57Bp+D0rKQGLkjcIKJRoz14kOu68e0nWlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEwf85cLdgg/8fSzwCvjaNjstIyJ4mCyPz9i6LIJDIo=;
 b=l3Y+8W/P62AMU3IjJW4Ru4WapxvGkgExwygUBkqgBZzoA/wq5KDizb29xqUrm1Uf3t8sD7I1jE9jrCH+jiJkv2wyrcak6HlFDZRty4nW8YkxunhyTmP8GsgVUmVaNCQDSepxHwufSq57woF6Af3J46ZMoZmt26Xq/XKLLxYMqIwWw6nngzuiqW1u7RvxrFtTWYNnbXSP6RqvYoKNVOqGR1xEd6p1XxTIsCtgUT+sN7804P4YYjKZ6zMujphOv4oQkpRzsevA1Hu830M9Kac64+BQQIyazo2DhBe5La8dIW9O1S+UtjStfJFGOSxT0J67qU6pS/LE53a65XiRDh1G7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEwf85cLdgg/8fSzwCvjaNjstIyJ4mCyPz9i6LIJDIo=;
 b=dmlh+mcV+53fTA8BZsFiZF9b1Ph5wWftLaXHrHGSUN647o0XTCQL9/wn4K5huQYlRHEGSfo7i2W6GyLQ+AKTTOo1z4j/mXQGC6Z4PYg0LQCAffOimI41PweR2DYXrDRchBFvOzUSAnuAfeDre15VIxwgyYQSa4g712UwmMd6Pw3sOOSz17qPj59izWjQ62IvJdwTVg5snEQ+crKOA6lDk+A6NrSwJydacAzDFvVNKeyM9dLmiXLAirRTKZgKvEVbdwV3n6pOAum0aJZ8ql+2I5w/vSWjzt0zKLNbXIbkqrGGdLHGCmnUKvkiQ1Y+7TiCiqsTlS1ne6ufEtLNtRP87g==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:28 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:28 +0000
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
Subject: [RFC PATCH v4 08/25] target/arm/kvm: handle writeback for special ID register fields
Date: Mon, 21 Sep 2026 12:32:32 +0000
Message-ID: <20260921123249.1708067-9-khushit.shah@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SJ0PR02MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: d0b50886-48c2-4e13-d705-08df17dc897a
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	gfo0x9GqntiN+E6i5j3wqNTj1Du2JbqAJvggHGLUKNMDmpy2s6e9kLXdmCjH7tOpL5hPE7Lb15lq6xjMGDXhiMFz/he442UYiniM68Bugdy29K751VCA2X11uDYYnJrbtyoyA5C9DVmovAEi1xiR0dIHPVj9vl4Nv9Lv933+n96bE6TB9woUzYdzf0vn550qOn/z3egXIhJ6Bz5rycWxcCmbHMRJwFkNT06Ra+IZY4SFQBRHJqp50Wacd2c/15j/eDIIz8AJApznmkY1S4uQat9O2d8OpUkpSfLUwDS8CQc8sgMtf/LIoRZBamhpYCb/qjDQyqjs6QE3Bj8aUliBhw7JNr9RgEwgOS4X9ZIRfnod/vgFJcMv1pfUaUeMFuZiqPQUBsOdGNvwwy3D51XlLa6m81tBU40rChQ1I7z66Qcg9DqQxPYAWYlmssB9YN6o5MVjXYb4OMnNwzUP1MSiBf/2IzM4cWPnP/+XlMl3RIQHg1h5OFXArVwnqZjMGjBh/zSbfaCmpa/naCF2nYTNV320wsYi0i7eZ+kGopuWsVH47iZcbql1XuoO50Fmb6e26DjuxysEao/8TWkWKbpHN+TlTMIzcM9PYcjYR5EWouzB3F9oqeg7YL77UXQd2PY7zzkkmQMK+FgyoMLWkXPMgmzqilxlLK9ujliXgapG0vw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oN12NpMDx3jN1+0ayOV8JuoJUoGfFeCPXOOaA02iWrEwdsHRbiWKHE561EsL?=
 =?us-ascii?Q?CdT+gW7rDyzVL0fw0Ey1J0wntZuSMbBellNTvdLRDUJBEJ0lhfXxzTOKye0p?=
 =?us-ascii?Q?LZ2ZNMv+zmoFeWXugDlMFth81ivCOYLQ5wSV9IizVr7ef3R78p0NBX6J/A/2?=
 =?us-ascii?Q?oiZG/yah1L/+yT2rY186eTJlEJh2tIgkmIxIliUP/ai9Zs/x/yWWRYe4AliS?=
 =?us-ascii?Q?IYYezyPfZVDzgUy6wMRN+avZG7QGdDZPe8cQCcoTYGN4F7xWhaHnCnnmO4nm?=
 =?us-ascii?Q?MUAj/EQLc1ho6IYapSHWTgorbjrZZaxwRxVobMGebTkdvrcaffiHWqXj7CGD?=
 =?us-ascii?Q?nW//zQbRsdOlGF9t88tPmMO0mKrMAK/hgfUo+lQzvqBojIXRDklt/djRWK5j?=
 =?us-ascii?Q?+aEMJao+XUBREuJe1iDWgW92jr3N8buyd5f6o1sym7A3xCk3VgpbJN0ze++4?=
 =?us-ascii?Q?X/GpOo4sr7w+gvDKY3eSwX8Qhm0dBzNAgo+VfJDmou3nR2pYgRrPWLr8kljz?=
 =?us-ascii?Q?IDHER+S3lQP+nKrsbthqPLMOnzE50Ux01mQK9qVtdQbgJ5Kk92caNDWNfelQ?=
 =?us-ascii?Q?//oadsJhu1ORHhzxGNrW91htUejI46fiKfHoLZm36/sB/tff/3XnJqnRhWf2?=
 =?us-ascii?Q?rXhaYQbfsCKZNW079lyNozwuD/CtMnNLF84wZ9E8kDBPADn8jym6eChkUBf4?=
 =?us-ascii?Q?3wdtUiBEAxSbDr4bZsispCTsv8fNV6x49M5U6uYCOuwGkr6JJSQMSHoKGqnQ?=
 =?us-ascii?Q?XYtNrzwh2LOw5kSn/itw0oepuhCser+bJPe+HxOmIoVYFOmBEHMXcERH+vIa?=
 =?us-ascii?Q?K1J0B0X+nP4kmcFWtCIdTtTiluGd5OnHDPfgV3GsI71qcvR7y3lzgR+LvYCa?=
 =?us-ascii?Q?jU4u1ckSMdFS91mJKK+19pmcqQ9/WWMt6dbZ+yp+Jr2yqvmt2Yj/M80Mx0jO?=
 =?us-ascii?Q?Ydria6r/lhf4SBAX/oGK1OgdvsF0wkGKPIhJPcO05kM5l2D8QFw2xxSmFkSN?=
 =?us-ascii?Q?0VSpmOKmHKGQyFrhKe9CdgJXp2fvJYh3emKkPEJ4Q/IdzPjEUOnWq7kYYKAk?=
 =?us-ascii?Q?/dZN2V5M0gzb5I96zPIOJUzjQIaXaaCQv0lghrGO9PgbMqUHIx45YpzKKU5F?=
 =?us-ascii?Q?oZkxPmm6M/cBMJEZMAHLJAqq1F//ik/VR8gRixRs+k41O+SJZA7b5exmIot7?=
 =?us-ascii?Q?16cZQLr/QXGGsIaDsisi+e2GekSn/JYVNtSsqmwk/OVM7qzGchgmMgIpBUEE?=
 =?us-ascii?Q?B0DKjWHZQVPEM+S+MckXTiVkgh50FpHmmqwES20V/6txLZJBF+uMs1daOKrQ?=
 =?us-ascii?Q?YDdHuKH7GAM9FJOzhMat/ErCw70+L2ckC1lIwM7npsBCL33+vTb1jU/tfM92?=
 =?us-ascii?Q?Ikxm3UX/Rn0KLjbDT13rs/cL2eW+XMWsundckxNrDnPhfCQMRSMMOUYW280z?=
 =?us-ascii?Q?3dDK0uY9UI8hcTbvgEUdCxN5O/iXR+DVQ6TWebN3pVvAtCO9RmzabKum++Ko?=
 =?us-ascii?Q?ENsdEQ0+CPJkBoRMqTalbwWXVgVablTPK0itc3b2mlPS3soIECQyc5SrlbVi?=
 =?us-ascii?Q?8KWFt/HVZghTFvV+x8UgN6gu8ADkTUxurPpwKZw77Akz0PRXa0MZw0F9967s?=
 =?us-ascii?Q?l2ZDqoGF7Mm/LvvT45il76fSOOHwhwgwTY2EIxsUv2DThzUW0Dr8A9Zjjn/o?=
 =?us-ascii?Q?br0yaHbTZtsy6YY9YnLgcxkcxe73mz16ypit8qGhHgyamRLMHH2ZFwmz4GcD?=
 =?us-ascii?Q?81dNhYEdD2H2Lvq4R8g8ymw+eutZ8cc=3D?=
X-Exchange-RoutingPolicyChecked:
	Fu5Jt1ZjfEBCWWr+MOg+iBTHgyWh5yVqbjg+J6eD20l1IW9BAzWtc04X5JUKF+g1rIYpudrV51lGfBdETvZoHHVHEdPRpzwq9PzmyFkOLBwKRh3OckNIp87+5j0eJgFeaBotlXluSVDlHQloJi+YldJZa0l/hjL2oJZGgIKbcqqMoJcxwdkj+SbfQ+FDmJrMfnUTtQQ5zlkWI2qS5XuQ5jdvzV2OGQqmHwIIfy14jfsgwg/ouPlCFHxez9WU6A2h9U1qjW1rF6V9vw0VrTtzLHV/FNzqK/hbpFYQcX/olDV7iyYg0sfJXrmrdLdxy0BwlrctSBkF0S+7QXTGSubrFg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b50886-48c2-4e13-d705-08df17dc897a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:27.7840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rMoh8RZ2ya7HQhDGX3pC+HtCRaXGWwdFAMJStdJz/JEnTFi7Mraj/cjhOpPSFZ47ETv6Y3tGvHNj4upflbyMTRmEPbRg+djkVliPzTRB6Mc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=KInPn1Fo c=1 sm=1 tr=0 ts=6ab12422 cx=c_pps
 a=jYOLmuRG9FCngycrw98U6Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22
 a=64Cc0HZtAAAA:8 a=NWnzACZMv7LnZDDXeWAA:9
X-Proofpoint-ORIG-GUID: rS0XlGshGD7nbYllEcKsoVHGh8jVFVPP
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX5ELvkGtiZG1x
 nUmxoPxmTCsy6s4SM9KRh8qJHpJDmmgfOH1jSwJFB34dNAIgmhKn7h5CLJeVgeRAkvvhMXLzqdw
 Nvu/g+mhAW+JjHcuJgjDzGMOd/DUmuU=
X-Proofpoint-GUID: rS0XlGshGD7nbYllEcKsoVHGh8jVFVPP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX9FsVAr+I2Loe
 /wxbGULs3bxd2DIVEaUxT1XyrTVfq6pB96SQ/cAaOPAcjQySAbxUqeJtNcx/JJmw80fqsUJLKaZ
 KxqiB0vtqY0abAofUS3kOalYanDeZnjUF+NrF5AQPVg9XxjPAslUJfq6pdHXl4GcI07OKELa0P6
 qDXY3D39KXzRdlwqI3U0bR93GU9KXHcX5Al5/i9lDhNj0RLPJUYazCxB0I97JLNu41i/UhcTChU
 3IO2EezSkvOgqxF0kh9inWW+rkG9HaYDmc+3uZUWQjzzmsWOYPxcCZjNuRJPTax2izBGh9oEYAc
 ASQ2u3+Vk5e6CNLr1/+n3RcC2W1UE4X6AOqrfzc7V47McfnctVQu/U0zXh1joGapzhK+tFVMlwh
 nWq+n99yksdC3cTfAutz24TxSk6ew1d7yru2ygIjF0LBFXgelISYlKBO7x6iPsRWtf/JXcMATh2
 xWBmXkSsVttPVX/GvNA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Some fields should not be written back to KVM for various reasons:
 - ID_AA64PFR0_EL1.GIC / ID_PFR1_EL1.GIC are fabricated by KVM based on
   the gic-version property.
 - KVM does not allow writing 0 to ID_DFR0_EL1.CopDbg, which breaks
   booting an AArch64-only guest on a host that also supports AArch32.
 - ID_DFR0_EL1.PerfMon is populated by KVM even for AArch64-only guests
   but is not writable there.
 - MPIDR_EL1 is managed by KVM based on vCPU index.
 - Hold off writing back CLIDR_EL1 until we properly support exposing
   cache topology to a KVM guest.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-idregs.c |  6 ++++++
 target/arm/cpu-idregs.h |  2 ++
 target/arm/kvm.c        | 40 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index d58b8ed063..1f7ebfe9bb 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -107,3 +107,9 @@ bool arm_field_is_writable(const ARM64SysRegField *field)
     return (arm64_id_regs[field->index].writable_mask & field_mask)
            == field_mask;
 }
+
+bool field_matches(const ARM64SysRegField *field, ARMIDRegisterIdx index,
+                   const char *name)
+{
+    return field->index == index && !strcmp(field->name, name);
+}
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index aab1a79db1..8ef3f9350e 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -35,4 +35,6 @@ extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
 
 uint64_t arm_get_field_mask(const ARM64SysRegField *field);
 bool arm_field_is_writable(const ARM64SysRegField *field);
+bool field_matches(const ARM64SysRegField *field, ARMIDRegisterIdx index,
+                   const char *name);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 2d94b3a884..70d9a07580 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1317,10 +1317,40 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
     return true;
 }
 
+static bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
+{
+    /*
+     * GIC is controlled by the gic-version property and fabricated by KVM
+     * when the vGIC device is created, so a named CPU model must not touch
+     * it. KVM also rejects writing 0 to ID_DFR0_EL1.CopDbg, which breaks
+     * booting a model that lacks AArch32 support on a host that supports
+     * it. MPIDR_EL1 is managed by KVM based on vCPU index, skip writing it
+     * back. Similarly, skip writing back CLIDR_EL1 till we properly
+     * support exposing cache for KVM guest.
+     */
+    return field_matches(field, ID_AA64PFR0_EL1_IDX, "GIC")
+        || field_matches(field, ID_PFR1_EL1_IDX, "GIC")
+        || field_matches(field, ID_DFR0_EL1_IDX, "CopDbg")
+        || field->index == MPIDR_EL1_IDX
+        || field->index == CLIDR_EL1_IDX;
+}
+
+static bool
+arm_field_skip_writeback_if_not_writable(const ARM64SysRegField *field)
+{
+    /*
+     * KVM populates ID_DFR0_EL1.PerfMon even for AArch64-only guests but
+     * does not expose it as writable there, so skip it when it is not
+     * writable.
+     */
+    return field_matches(field, ID_DFR0_EL1_IDX, "PerfMon");
+}
+
 /*
  * Copy writable ID reg fields from isar.idregs[] into the KVM cpreg list,
  * so the subsequent write_list_to_kvmstate() pushes them to KVM.
- * Only writable fields are copied.
+ * Only writable fields are copied; fields that must not be written back
+ * (see arm_field_skip_writeback_*) are skipped.
  * Returns -1 if any vCPU's ID reg value differs from the host value and the
  * field is not writable.
  */
@@ -1357,6 +1387,14 @@ static int kvm_arm_write_idregs_to_cpreg_list(ARMCPU *cpu)
                 continue;
             }
 
+            if (arm_field_skip_writeback_always(field) ||
+                (!arm_field_is_writable(field) &&
+                 arm_field_skip_writeback_if_not_writable(field))) {
+                /* Never write this field back; keep KVM's value. */
+                writable_mask &= ~field_mask;
+                continue;
+            }
+
             if (!arm_field_is_writable(field)) {
                 error_report("%s.%s is not writable: host=0x%" PRIx64
                              ", requested=0x%" PRIx64,
-- 
2.52.0

