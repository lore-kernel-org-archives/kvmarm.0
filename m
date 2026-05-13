Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405D748A2CE
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691246; cv=fail; b=tu6bjEbT5vUuXcp1aXLEP55J76cabfwRqFzYJ5/8p3o7FsIBL8FFI+5ImPa/APmNYKPA3rIzKTemZ3CFk6ESWm/wbts0FUbSMs2NNGMlrQTLYi9QH23Nqz96UY2IFczODa9gVPaxyetLiw2rprxjlNR4/0IQlbk2hTe2SUpCovs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691246; c=relaxed/simple;
	bh=eDNZXvZtIQBURwjJUJ38PHGVVaGcUq1HzlM4GpFfXkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P/+mErW15poMLvsKhl3cXFOe93x6yr+flOpYsWcmL5gTPGy3LGO1KHa08AYqzsQtuNLBUok2VCyvoDtOYX6jnnNEYQrjlvkMFGifbO0YxwPV6LeqZ0gLbE2BQd8k5G8F8gU3z8Tev3Au/0gyWH1Uj4Hn0lfWHjyZR/upYxpVc/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=p0G8URFX; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PIdsxRkd; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="p0G8URFX";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PIdsxRkd"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGLKTn4149398;
	Wed, 13 May 2026 09:34:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=cvUzVq5os+U/Y3Wb81SC3XIp5miUUCaIolEld9owm
	QE=; b=p0G8URFXmHMosWYzvGEid99RYCQ0dwsRG/K0IuVARyupUONSYRVtc+W4a
	WDopOIpbP9ii6HwqansdSMEeuje7kSOmUF1eP1Jr26wEjYTmmPgQY6uC0xlOgAUu
	FdbId7bkmuN+dWCp+/6V741tzM+z0CV+QlDDlU1e3hxsOy56H4QI6dFwj4tQlrDg
	bFFzfb8byQXZVfaLFYOEuG7hZ1CQr5d7lIYSZJpSkNj7n6YIamlPCJ/BNm//vX6u
	rNq4460AEVmhicnKut1Eb/+0hQguw9sEtDE+EqoUwRXtAz3Nqt/27eTcsgoYraNo
	DyueUILKWrLG0nOIYngXVIir8eqfA==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021113.outbound.protection.outlook.com [40.93.194.113])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nva675w-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EbroLbfzmgkfUQgp7QQxJOXR1z1pDEgS0jXc9MfshsT/H0/Rkj7cVJKQCPygtdPzbVEbU1Cblr7Zx3kDi3N97qvFBxxa+CdjNDvsdCMw2P+4QWfIDEY5TMKMSzEbIxiS9hB8p3OTfG9T4jV0R8YOjpPaLjJtXsQiX6mIjK4TK2yBvhVdZGkWvNlJWvFGcwr9dR49xh1g2OTjYv5qg4HB+uPpyClxkz3FeRZO3Rx+gMPSGHpikwBBwDH5wfcLWmMNfIwckOHCNc1h+yzrqy1HbJ4nQOwnAyyRYTdA1ta55ReDXQgG1ggzldGANJ4E7wz0zrWAAXMEzKxORkRFAZfNiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvUzVq5os+U/Y3Wb81SC3XIp5miUUCaIolEld9owmQE=;
 b=IfhBJN5tHnxVZe13vIBPpNesIj431wxIdjqEaEj/I9NbQHQpMRlKmqeA0Q+2kuTdBDry5rk8IOb+KRPyDEwpuDd51S1MPgGRyRkX8yrUvkoNktxmumGWmZGW0MKdmVVdykqTctqIZmT0Mjpa+ivvj1xu4EXiZGA5AmUBabzbB+gymoARE6yxWtpdj2bUSjLVSejAPkdqlIdWpB1nEl+1k0yk7npVpOPWm1ACpX9zh0LFsEPSBRfvZNLwg1SR4Y4sUuHbntXas9BaiVDTwUqcuFb6yE+DFLBczljNxhNkDWIJvNYGU/kRpP18jy8G6qgP8vZCwbeY5OIMY0h4MZkIUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvUzVq5os+U/Y3Wb81SC3XIp5miUUCaIolEld9owmQE=;
 b=PIdsxRkd5drikAoIj1ldENujRggAxWM8Z5jsZjDZ+NsM1zYFdLVrpawWUMG+xfcoRpP4hgw45sKRiRT5VXgXGwGV1+5LntCWcLYtPv4uPgDA0Sa3eKpwPgXmiJ3LFVV2EdEgLFEdwXNmbzwDplQ+fE1g9MBiipa4eYzQ6laJjYF4RzdyLulPpMMzcHdqnXxz6ry/kcoiHwQYFMY+PgFByW5B/n4Vs8R9xJdcZ/swx4HwUxl3ieKlSexMGirg3dF51I2whdxFrJyVuNW/xoeQoJh6eZoVY/h3RuBJRgZ+MNDGM+BRrVlpQmwAet7DXY6YGii54BqJ8HSpHTsXtS3Vbg==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by SJ0PR02MB8813.namprd02.prod.outlook.com
 (2603:10b6:a03:3d6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 16:34:26 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:26 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 10/13] target/arm: named_cpu_model: Register Arm64 properties for host model
Date: Wed, 13 May 2026 16:33:53 +0000
Message-ID: <20260513163356.3033159-11-shaju.abraham@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: PH7PR02MB10160:EE_|SJ0PR02MB8813:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e168396-f713-455a-61b5-08deb10d7f1d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	fPxdIwAsDijviSm6lRhqY2MhKbjlaYSKpwz7FIXSe78lClbdouiou36iUz6fr8Rncy1qr88x8SL9ewDvwzsSRS+lrY57peqsUjm9cURWBSysiXHebVe/rp8VGDm605LG+M89t52qBi5z4FwGiYU2zQ72acLtLY56Dbo6MKkwWYRwV2cJ5FSViR6DCVUUJQj0Gdx8bjZERV7M5qU1rJDoeHC6tEjyRX1Q0G72L2iV5AdmKbInzhpBnSRiPRJ1FDiMXdLGFh7iUGJzkzXsvV/mFfXkqiUxrASKFAbiXVZxtpV8eEesBxMlQTNTnJefyMTksdPZo8+JTEfa4F77wrlxxCKk4fLmnsiMMP+Ag/Mby9fGH9bGzjxECeFDtiCtimlt0dLe2F2Sr0FxQG9oXiwyxzuFg2BcUXcdjqFEqL77E5YKt0lT5b/ICKdzVsID7je9lskqN1XKx3+es1vX6vOQ0VhWFg1ZsGyqwpGjp1GKD9HePzYgR9CJ0XUHANI8N1FZKMuionnf3Bgr2wVtX5A8RGQDDfaINPU2UcfzXUS9OmdujYAFMHGEYxIRoB+MkTDX9xYMoSSmEl9a31GpPJCauC7Iyw4S8sJ6xhclLjws2dSPT/U/XRTc6IoklfEEuQ6+FTPJrsYCpW+ix0fa3gnxFJ8SpYG4E3+9fKz04Q/1IEsFQ/Cf+BRWbKy+ysUvPG8xxuH70aQLIk/zc5FlpDQUcuJWnQJV3Hxee6t9svWVog0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k6MxTUjH+HhqWiREWsVTdjxADZV0v4SNZGZrN4d3OfCneMiUoe8rl+9a6ySb?=
 =?us-ascii?Q?g/U4kAZHetgtyjL/z396cjTCRle1TXwwWGiQdaeIFWUYbbarDkcnBTqaDln/?=
 =?us-ascii?Q?VucOs3pQ5fmZCqgo6Mqoc41fWjOmbXmLp3F7SYyEFr/IFZ11UBJihRdW+p44?=
 =?us-ascii?Q?1JBE8cpwiyFEPEGRzry33ZiRoqaYjDgFvfL2aTindNeZBujgroS423g0qfPZ?=
 =?us-ascii?Q?Qm72T1gHgCRA/5srLu4bkt70Uc8J89pUwCFaJwMPE8zrzE2+HyMIYV5eGbVt?=
 =?us-ascii?Q?VUPvj5qsyFAwF6BIgztagZIj7/UkwecdmpQTRDb++gDqgGwqf5Dnj1upEYoq?=
 =?us-ascii?Q?HwaAb395gr+M80dB4HYKgK4c1YdNbty4wxx8ThzVjpfr0djSyuIa7t9uYh65?=
 =?us-ascii?Q?FMMeHoRJT+imee+gPeQRPCIN2VlAfYY7xbSpuc43bNgz8CXgPzZUbSYtjFgi?=
 =?us-ascii?Q?3b0DHiuHCP4nPJJ9kAMGzT+ETh3Q7zeUKrflzHWuHO87V7wIAyRYDtmC3Al5?=
 =?us-ascii?Q?6heo5HRtgjM9kG9QW5WMygXgxP5UzSDTx52nNPD5izKL+YOLP44WHrdiap6j?=
 =?us-ascii?Q?TtLdLM5hrj+lJXhozvAC5ppKynBTUxgkU0y8PGPVcoe+JW1CoD5ymizHYWUN?=
 =?us-ascii?Q?zCCCvkhnomBA+bagNPw451akmXwsp7OvndtD0/DvLMUNXUxzwHK0a1xgRsH2?=
 =?us-ascii?Q?piOds/GV9DySEujgAFiOoaSfDIoiR1rYOQyZ7Y5oYW3zxeYRCbI2cZrohke/?=
 =?us-ascii?Q?aPgHm+K6H54D4zDwFXvyC6ZiGsfdYPIx3tqSXGEbpjmZDx5GSGivlyjyDZsY?=
 =?us-ascii?Q?JQJgIA1TKEjaz2dytps62Y6FM9W6Laigwt536t4/bvXI/Ee49P+wP39dizYF?=
 =?us-ascii?Q?Ok92434XBIokpzMyr7FrQLPmu2WHCvS8jp0+c5Kr8226t8Sm6im5l5vDMDXB?=
 =?us-ascii?Q?sDYY0+zhh51Bypo4dICA6MLfr5jbjH4em1np/82g9l8P5Ht0yUzex9RZP8wO?=
 =?us-ascii?Q?ZtzfqlawunaTpjRrshRDw4Y4wWCQLSZQXg5xhPfMU/Sta9S3kQo1HQRoAFY6?=
 =?us-ascii?Q?DhYm8W8aGF1DZHsLcwVMEITB9GvcoKAfYh470M/9efdvwmc6pnswRmZmo9D6?=
 =?us-ascii?Q?KjN98QMPtieIDNQD5/x4+Ha/d3fMglExxO5kdH55UBGxSgOQsm3UwaVIOOwz?=
 =?us-ascii?Q?djsH4y8A3svw7nLjDO5VJJb4NwDFVb+sg2uRzgK6/xrpD8GmDLxRIrKm4PM0?=
 =?us-ascii?Q?BPZHqzTYChRYYvxPmI6skGe1PvQ9ep2mf1olF7nqQW/YGd41Z7qXFz8T6gAk?=
 =?us-ascii?Q?mGeUI4C8MR6drxdcKDwkVFBN0ilIiLdF8pm4BUxhBT0vuprPjyNWCBH6Y26a?=
 =?us-ascii?Q?S4wKGq6d9+f7EJzD2cb5toAFStO9Y+kVsRSzQ2nzBwgUcqTCuXbp/lTFNK9P?=
 =?us-ascii?Q?kDo+KvWIYzYb7q2+MLTlUrW0tu4uxXRYdhDamle6eErBi1ykXl1TjjJdNvIK?=
 =?us-ascii?Q?mzA4YLhehklQxeHj7Ol6oP9YV2MASVs+vEovqeMk2u1iyw3GO4VpGx7RACi2?=
 =?us-ascii?Q?Nr609LhNgcZDbH/iZf8hpyBWHcc2XrFU60CiX/Y41ChIoT8JHqOiJdrrjcBp?=
 =?us-ascii?Q?Lsr2QHDf/pmR/407iYtByl7Hm8XYxU31w5oc/gUpSNgEgyXmFn3kgUoCPK1S?=
 =?us-ascii?Q?DnBzfTyLldy0UN1YLPlZhzcW0ca523/cm5M1PhJNCvF/nhtbW14JbBeONgOY?=
 =?us-ascii?Q?t5q7VFfPZs3DpOse6HQNdrNBV5PL1K8=3D?=
X-Exchange-RoutingPolicyChecked:
	GUqnHGh8tigGMR3KL3XF+8thBzeRrYnFJ4PQIf8KTahgo3acsAXizA/J/BWegFuVisTHOFVWJi84llkVY0laaKiYzK4tbu+QtiqoT+Qr7ctIPad6CVUBCpqKb1y9BGsz6BH/IRwGXqsy/D5JPnbzFafLl4V60uPVgR6uReFfxMUucbLH4qH6kPLSRnUc4L4oZf9DSOThIdVxHr81ChzVtG1pnySd5zZevMpYcq0I81fdrUEGe3tIUXIa9zGKg8Gulrzf7MCNVc1ap7IuGL3Af1o5G9MBXhShQAlIdfmDZ5/4ETGjha49Y3XLsVEUrCEslcXw6s+d/jIpdHc9Uf6oGA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e168396-f713-455a-61b5-08deb10d7f1d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:26.0746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBDZQ1LfRRLc0LlZJO9ERNyW30k3VssJQCtqPr1pYLCJXw98eeyBIIbly9ZsUZ276R7LV08dUQUrDK2KK/8U6BeWnPepipcB1UxTIIIR2e4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8813
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfXzCGICApIilXE
 SuJ3bnip2GDfaA1X8zjurBtqAiC28HMc0bIOy38TdP4sT0afgVxTexRIGZUkXivnC9oL0jgG/1l
 kPmg4kNMRA/yBxLpp5N8YTJRIeoyTmJ2tROP420biv7i2BTV7XwWeZZQWSrplfeolCblx6f/FD6
 5HqWjjsWBoSZd6mqwvbj+G/XT7D5Q4c7fRlxDcTrYuyngkwEe1dh5s9h0CTe9BeLToyyhMI/c9v
 JvXtIt8UDjCX4alZVqimgvecFtJzJrDibbFLlUMqFKh9YxQoRuUVKQoa5hzCgkBVmAo+0G7E5DB
 vOby3W4nzl24f6trndpBvtqxf9Bt6oLTXa22Ox7trNuA/JLJCansQW7iKv8Eem8tvUOt+/Hoop5
 vBVBQ68Jk9cV5s8xzqPYsachmpFkd6qmV55jMYD9TGYQBrf5quaABqZBe/jllrVtOBT2w2RcnX0
 n+9nAvjgJIhTq1i+auQ==
X-Authority-Analysis: v=2.4 cv=evLvCIpX c=1 sm=1 tr=0 ts=6a04a815 cx=c_pps
 a=+jjOclGHkOGhuepu6R0Llw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=wZ7dmE2_5clyT-bJU3wA:9
X-Proofpoint-ORIG-GUID: m2j_JzDUZkGZFhLRUFiJiPf6kM7rWV5y
X-Proofpoint-GUID: m2j_JzDUZkGZFhLRUFiJiPf6kM7rWV5y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Register all the defined Arm properties to the host model if CONFIG_KVM is
enabled. Add property finder, getter/setter functions, and wire up the
property registration in the CPU initialization path.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
---
 target/arm/arm-cpu-props.c | 216 +++++++++++++++++++++++++++++++++++++
 target/arm/arm-cpu-props.h |   2 +-
 target/arm/cpu64.c         |   3 +-
 3 files changed, 219 insertions(+), 2 deletions(-)

diff --git a/target/arm/arm-cpu-props.c b/target/arm/arm-cpu-props.c
index f22fe7f08b..1a34428c00 100644
--- a/target/arm/arm-cpu-props.c
+++ b/target/arm/arm-cpu-props.c
@@ -41,3 +41,219 @@ const ArmCpuPropDesc arm_cpu_props[] = {
 #include "arm-cpu-props.inc.h"
     { .name = NULL },
 };
+
+static const ArmCpuPropDesc *arm_find_prop(const char *name)
+{
+    const ArmCpuPropDesc *p;
+    for (p = arm_cpu_props; p->name; p++) {
+        if (g_str_equal(p->name, name)) {
+            return p;
+        }
+    }
+    return NULL;
+}
+
+static void arm_single_field_get(ARMCPU *cpu, const ArmCpuPropDesc *p,
+                                 Visitor *v, const char *name, Error **errp)
+{
+    uint64_t value;
+    char *s;
+    bool b;
+
+    arm_idreg_field_read(cpu, p->base_field, &value);
+
+    switch (p->type) {
+    case ARM_PROP_STRING: {
+        s = g_strdup(arm_arch_val_name(p->base_field, value));
+
+        if (!s) {
+            error_setg(errp, "Property '%s': unknown value %" PRIu64,
+                       name, value);
+            return;
+        }
+        visit_type_str(v, name, &s, errp);
+        g_free(s);
+        break;
+    }
+    case ARM_PROP_BOOLEAN: {
+        b = value != 0;
+        visit_type_bool(v, name, &b, errp);
+        break;
+    }
+    case ARM_PROP_NUMERIC:
+        visit_type_uint64(v, name, &value, errp);
+        break;
+    default:
+        g_assert_not_reached();
+    }
+}
+
+static void arm_fractional_get(ARMCPU *cpu, const ArmCpuPropDesc *p,
+                               Visitor *v, const char *name, Error **errp)
+{
+    uint64_t base_val, frac_val;
+    const ArmFracVal *val;
+    char *s;
+
+    arm_idreg_field_read(cpu, p->base_field, &base_val);
+    arm_idreg_field_read(cpu, p->frac_field, &frac_val);
+
+    for (val = p->vals; val->name; val++) {
+        if (val->base_val == base_val && val->frac_val == frac_val) {
+            s = g_strdup(val->name);
+            visit_type_str(v, name, &s, errp);
+            g_free(s);
+            return;
+        }
+    }
+
+    error_setg(errp,
+               "Property '%s': unknown fractional value %" PRIu64
+               ".%" PRIu64, name, base_val, frac_val);
+}
+
+static void arm_cpu_prop_get(Object *obj, Visitor *v, const char *name,
+                             void *opaque, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    const ArmCpuPropDesc *p = arm_find_prop(name);
+
+    if (!p) {
+        error_setg(errp, "Property %s not found", name);
+        return;
+    }
+
+    switch (p->type) {
+    case ARM_PROP_STRING:
+    case ARM_PROP_BOOLEAN:
+    case ARM_PROP_NUMERIC:
+        arm_single_field_get(cpu, p, v, name, errp);
+        break;
+    case ARM_PROP_FRACTIONAL:
+        arm_fractional_get(cpu, p, v, name, errp);
+        break;
+    }
+}
+
+static void arm_single_field_set(ARMCPU *cpu, const ArmCpuPropDesc *p,
+                                 Visitor *v, const char *name, Error **errp)
+{
+    uint64_t value;
+    char *str = NULL;
+    bool b;
+
+    switch (p->type) {
+    case ARM_PROP_STRING: {
+
+        if (!visit_type_str(v, name, &str, errp)) {
+            return;
+        }
+        if (!arm_arch_val_from_name(p->base_field, str, &value)) {
+            error_setg(errp, "Property '%s': invalid value '%s'", name, str);
+            g_free(str);
+            return;
+        }
+        g_free(str);
+        break;
+    }
+    case ARM_PROP_BOOLEAN: {
+
+        if (!visit_type_bool(v, name, &b, errp)) {
+            return;
+        }
+        value = b ? 1 : 0;
+        break;
+    }
+    case ARM_PROP_NUMERIC:
+        if (!visit_type_uint64(v, name, &value, errp)) {
+            return;
+        }
+        break;
+    default:
+        g_assert_not_reached();
+    }
+
+    if (!arm_idreg_field_write(cpu, p->base_field, value, errp)) {
+        error_prepend(errp, "Property '%s': ", name);
+    }
+}
+
+static void arm_fractional_set(ARMCPU *cpu, const ArmCpuPropDesc *p,
+                               Visitor *v, const char *name, Error **errp)
+{
+    char *str = NULL;
+    const ArmFracVal *val;
+
+    if (!visit_type_str(v, name, &str, errp)) {
+        return;
+    }
+
+    for (val = p->vals; val->name; val++) {
+        if (g_str_equal(val->name, str)) {
+            if (!arm_idreg_field_write(cpu, p->base_field,
+                                       val->base_val, errp)) {
+                error_prepend(errp, "Property '%s': ", name);
+                g_free(str);
+                return;
+            }
+            if (!arm_idreg_field_write(cpu, p->frac_field,
+                                       val->frac_val, errp)) {
+                error_prepend(errp, "Property '%s': ", name);
+            }
+            g_free(str);
+            return;
+        }
+    }
+
+    error_setg(errp, "Property '%s': invalid fractional value '%s'",
+               name, str);
+    g_free(str);
+}
+
+static void arm_cpu_prop_set(Object *obj, Visitor *v, const char *name,
+                             void *opaque, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    const ArmCpuPropDesc *p = arm_find_prop(name);
+
+    if (!p) {
+        error_setg(errp, "Property %s not found", name);
+        return;
+    }
+
+    switch (p->type) {
+    case ARM_PROP_STRING:
+    case ARM_PROP_BOOLEAN:
+    case ARM_PROP_NUMERIC:
+        arm_single_field_set(cpu, p, v, name, errp);
+        break;
+    case ARM_PROP_FRACTIONAL:
+        arm_fractional_set(cpu, p, v, name, errp);
+        break;
+    }
+}
+
+void arm_add_cpu_props(Object *obj)
+{
+    const char *type;
+    const ArmCpuPropDesc *p;
+
+    for (p = arm_cpu_props; p->name; p++) {
+        switch (p->type) {
+        case ARM_PROP_STRING:
+        case ARM_PROP_FRACTIONAL:
+            type = "string";
+            break;
+        case ARM_PROP_BOOLEAN:
+            type = "bool";
+            break;
+        case ARM_PROP_NUMERIC:
+            type = "number";
+            break;
+        default:
+            g_assert_not_reached();
+        }
+        object_property_add(obj, p->name, type,
+                            arm_cpu_prop_get, arm_cpu_prop_set, NULL, NULL);
+    }
+}
diff --git a/target/arm/arm-cpu-props.h b/target/arm/arm-cpu-props.h
index 1dc3786ea9..48f9c46ccb 100644
--- a/target/arm/arm-cpu-props.h
+++ b/target/arm/arm-cpu-props.h
@@ -32,5 +32,5 @@ typedef struct ArmCpuPropDesc {
     ArmFieldIdx frac_field;
     const ArmFracVal *vals;
 } ArmCpuPropDesc;
-
+void arm_add_cpu_props(Object *obj);
 #endif
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index a93ad2da5a..0300f8677f 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -37,7 +37,7 @@
 #include "hw/core/qdev-properties.h"
 #include "internals.h"
 #include "cpu-features.h"
-
+#include "arm-cpu-props.h"
 /* convert between <register>_IDX and SYS_<register> */
 #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
     [NAME##_IDX] = SYS_##NAME,
@@ -863,6 +863,7 @@ static void aarch64_host_initfn(Object *obj)
     kvm_arm_set_cpreg_mig_tolerances(cpu);
     kvm_arm_set_cpu_features_from_host(cpu);
     aarch64_add_sve_properties(obj);
+    arm_add_cpu_props(obj);
 #elif defined(CONFIG_HVF)
     hvf_arm_set_cpu_features_from_host(cpu);
 #elif defined(CONFIG_WHPX)
-- 
2.52.0

