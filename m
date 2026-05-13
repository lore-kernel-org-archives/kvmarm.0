Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD343F413E
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691454; cv=fail; b=WPTo3iI1Ns1wQ/JEkV2NvC58g47P4Moh8jLFUw6edQGE3KE6z0czl8ld/a3z2fGwNA+T9GOZ0SgVutZzASOc8ioFLNVOlY2fs/xNUAS6NXdKZmDxnORjH6PNfL763sxTEC1xIOn8bDArzlTIFFhgnS33MGMYaPvJvnjrsXZ7NYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691454; c=relaxed/simple;
	bh=lk9nfrQWc61E+hZncn5DXCyc/10x7UUGFXNAgUpTbDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tGOwu2PqIfQtAatxdfBq2cZRs5YSVX+KYGPkRxEHqIEpICI9J/jWEBosF6A/kUOnaW2wqDN7ZmL/Sfhcji4sUAAx51PTPJIEpxfZ5WU1rakIo90in4ajGcPdXd7jEpeJxjlG7gxiWhIZGW2fxFzIGu63p2rtw9oxajOCWjQJkj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ZStV4jxT; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=l6YWOb2S; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ZStV4jxT";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="l6YWOb2S"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGLHq84149088;
	Wed, 13 May 2026 09:34:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=2xtzwM/gRiSPkKPySRKL3ywLvvQP3T0S77jRRNPLY
	NQ=; b=ZStV4jxTNq4nqQKPYXRnnjXHV1wJ3Bjl/kcYDMNBkMi87Vgz9mtYXqJlA
	SW+5aPPoRggZ+6Z4resCyH8KWQkcbM7a0Dg4usAWmyYD3s4QwukwP4o3ZGrfLbLd
	w1fPmGdpkMncuR9RDFA5XZwRkOQyGVKRQnduQl16PUpODxFcEYmsTSqJKghqlJCs
	Ptf5WPXTcibmv4d/kDo9qSohZlmuR5GymNdQ9t4q0CYOkpZT5H4RuQqPP1vyKvic
	YHXdBhd+mDjhRk7Ah/g4QUX3PxdFFbZz9LIS7PAhf9FoApl7gOa3XHXIt0pe6Dne
	3l3bCUpkYuruI9dY5dvpM/syVRytg==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11021098.outbound.protection.outlook.com [52.101.52.98])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nva6757-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pT8M+qQ63ozM1TxKfLMFJGWecw6z3zYcEw7mhw70tSERG/SeM7BUD+0aRcxgFrBEiJUF5W6en3Lpl7ePXzsveQ9gg7rJEXDfB1V3DuvDIeN0ft06JV9aIMJEennfq+GicAq6/CZEz5OY1V+D9PGBucyAVGaJxf1XFhlbdAfD7slR2thEVUUFuRrVCOebnM7tm5IH393LA5YsasRnSJNeQtVdujUQ9OVKXCK5eV2R2NFjtaoUEv7hTat55V3aGouRVIkb7DDX3DDyPqhPICmxyP3q3CBTXPacWnx3A3Jh98am0WeEzfDuAo4WpPV5CHMfnevUvHLksjK2s0gsp1TSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2xtzwM/gRiSPkKPySRKL3ywLvvQP3T0S77jRRNPLYNQ=;
 b=hKTytzSyYAiacTkuNAsZVTuEtHeazc/EEMnzu8+D3urLgZggliymeCmFWkCjwrj52F4LYPSF0IUILq0rdLAvbpmWMAMiF4sAK8+joK2FjSOeqQ+PmfM7O8RLYJuMa/4oEzpBtigcdF2noCHmt6yYtH1HXlfdQ2h8YIX6I0Pa87NwqUfrjMwVkEHl95oEieJy5bsXo3tiqye8zIhx0jI+kok5KvK/i1DOEYxxBOKxT4BrUs5R2Bj/PxxKSdn+QTJhh//6YEYlfKbeQaOQIYEMvEUxDJ1AEPUOD+swW+jIBFcrCnhARxRr/5Ha6HlT9NVHgyvV6IyQGgt1ZerA5dHAcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xtzwM/gRiSPkKPySRKL3ywLvvQP3T0S77jRRNPLYNQ=;
 b=l6YWOb2S3Z/L0GtqmMDZ9Vx+fXwPGcvsFXDtwiiUdQdBbxvo8tW0NIS4puTb+Ms7lW9lgX3M7m7CkVwJMbbIFOU1W60hnUXRgBgeenInDkUoH460UlQze+4cm16079ygrn3UAWXmAR7+1HuDLKptG65sMdz6qj1rF8khZ0E9/vfQtaJ8270Weci7RD4McF4nmzOYFj/MkJ1iP4T3j60ugjnMFj3nvWYE4Seh1uFaFje5SHRMLliRKKae/OtocvgurF4px9C999eZcqVfx6uk8vHQ9CByaDY1cyI+EEd4g9ysiPscT9HPa+7YTpIXegMBRe86ft1SfZ8c1EibmJoIQQ==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by CH3PR02MB9564.namprd02.prod.outlook.com
 (2603:10b6:610:120::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Wed, 13 May
 2026 16:34:15 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:15 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 05/13] target/arm: named_cpu_model: replace FIELD macro with IDREG_FIELD
Date: Wed, 13 May 2026 16:33:48 +0000
Message-ID: <20260513163356.3033159-6-shaju.abraham@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 00293c69-2ac9-41da-d2db-08deb10d78d7
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|22082099003|921020|56012099003;
X-Microsoft-Antispam-Message-Info:
	y/4iP6HwN6RzIkz62arKXPM42MQbWSJb5RQF6TWnjuCeNbs5rwgoseX/kH71em36oDd9+vDwSJxqaRaXFzRXyzSkXl+2IiJcYNngdSk1igSAZYwzmK6Zcw30XEUu91e/HfvOZbguft83XrxVFl9kOIi05I3ZyJXiRc6fy3ljbMxkR6RHYb2Nan10hqRzbAiyxYgYt8+UwhKEMT4qTfXzJ6XeBXkus8IEgICecLdvLnOa36IUYvv2E18ldik3WakuKQrEcgltUIbIbkigk87iJti7/685xfNRPb37WtSQvjZImmOS8KptnV1bSGXzlYIzkvUxVBQnpnyP/fmIsMJhQkcvBrYSJjfUWaiMs2phaLzF+CZNZqMsHLlmNi2n/eVLzZE6VRWsAdHnkYLJ9vmSu+1UDZo8wT2PCUHCGvfPqRNS0kuUZgRLHZCigLioKNC51ql9ZeTcG+ay9UCAA/Iva8yvZzTVbianubftWIjYLux8WZbPycMzRbKcqtsWPPeMVg9JQkrYKNMkam37Ij3Q/8Ry6JLFUgt+xuJja2zqnz1zL9sNiy95rtWL42Um1IspSgczLo3a/od0tSd1rNw/mZ0LqRcyFEx/hH0cHN/WPuNqEgpKhMsGolM9g8DciKkXEgZJ4l4ccPQa0k+0PK0sF1Qje2Rm7HMIddoGzXSlGfZDr68mAX2X9wLg6smfcq5DnqHeyxbUqfMtPpA7QEu75bRHoGdYmhnlS710I6NOUiM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(921020)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YuGXMEkeGXGFskCTPncYnOieONs0hrZDoOChiNeauIyP8VpMyt2TvVKgi8/8?=
 =?us-ascii?Q?OIkh68haiizVGotuVfJqPSG/HvJ9jlJfsCScT28LFLzsh4/1q+85QVdCnaWH?=
 =?us-ascii?Q?HzzgxinjTHnQO3STFPS6zZahs4aKNk/067+78EpIhgoHOjQu6BYyaa02DdZ2?=
 =?us-ascii?Q?b1g2cAxs0KQ5iX0+sr2iXNKKe2A6e5kSvw7E59gVZGYWrq2UJJrAcTE78xX8?=
 =?us-ascii?Q?jj77SFsi+X5Ok3Mkk6Ybxh/QUdXQNlWZI3j4P3d3B90Vc16pJ840zNdib3uD?=
 =?us-ascii?Q?iZsb+7Ia9xdhcW6gz6ZJha9ZOYBeMHRhzCjHgxwe04tM5ESKixCSKWYzuJes?=
 =?us-ascii?Q?qbcG1U+Pz1GfXe7okdarpTAlynIV4v4gINk5/vRwzcEqpXM3xHY6X8hNm6NR?=
 =?us-ascii?Q?br7YoNoPYZOpSOD7wcjhP29ATKM/sWUmHvAZ4VPMeTjFPU3XJIX+XiYcFSqO?=
 =?us-ascii?Q?jOzXWQthvHR4Eg/xZNQHtjLBoVVfORTRNmZ/rCuRDp4Y1hPMqIQTDCMQpEJI?=
 =?us-ascii?Q?sf0JlVnGPaMOwUUgr6DLIFr5AbmQpA+xcTAvC3GSgDffAGGTdw/CgUfxGfGF?=
 =?us-ascii?Q?Sn2v6O9OMjcEFgsg2bgoklFtQM7Hk9Cs87JQ1gqFM1G3OeNxj/Ye92d0ijPS?=
 =?us-ascii?Q?7HBPQK+n3d9B56u6se92YPQgpgjiVs8wH9xUvWMUBqsPyY3vUCGRirpEf8wN?=
 =?us-ascii?Q?mH2RrwNQBodXAtpVmovm6c5rTUm6tE1D0obaUlF0gRxhbRXk7L7wVJewfAAz?=
 =?us-ascii?Q?6uIGqlRckRrVhPh6H6RKE0dD8ErlP+rVu21MNukPDD6PQakcboMwVSpaaev/?=
 =?us-ascii?Q?HxgjKET8Jc82jpVC7LQPWslTTnjF1SAhL6LpI1Yg1UtH3lP5q6R5ekl0KWjo?=
 =?us-ascii?Q?9ETaEmDihJvKaYdSzaMam0LA0Bd/uqpkyaaxxM0ji/EPGEKXF2hTYTLZzUY1?=
 =?us-ascii?Q?s3f9GSuagBqdRiphAqA+7Fm6Tk5LOxIrvWQ+80DAUFD5+r4oCT0KPAj/gbk6?=
 =?us-ascii?Q?ygex48kUFcbSA0IZ3OihGv0T2bafES68Ac2VKMUhQggK85qaYyzQ+Fz82MNd?=
 =?us-ascii?Q?7S2fDlX7ckmlFbohEOUM/bITC06hW5/aM1Qj0sl9R9UFdlCRonx7S1eeU1JN?=
 =?us-ascii?Q?yv1nlK2iWF2YpcGYWIQnG3zkgmgeHdDDNpSjflM99aP/kDGrwCpDPoUNzDlU?=
 =?us-ascii?Q?zRvJDSarKPlHNa9Dh5xg1uMwxO7z6jAODvoJMFVe3Y1XcDEvdwE1UwvZmN20?=
 =?us-ascii?Q?JDUbKY+8jzhRJthdzbeoKa8gCnql8bmSG90usbVT+HZbx17cFFMMmfY54K1a?=
 =?us-ascii?Q?2hyl2CtIbdbZ6hyYELLDTKKsYd0pJ4xdkV1U/5pdnbf95OWWVO3jpQoUGAOj?=
 =?us-ascii?Q?zpYnKLXi5tAz2ECOjG8qr08fvGU15iiXbunF75e9NR+c2WdZASLYh9vIjdcp?=
 =?us-ascii?Q?1nFfezYwNbgeywrD3z/kKZMICFErVDDeh4JV78lkpVxSgI9Zj58UoFIqubJu?=
 =?us-ascii?Q?vCl5FPFKUmVCml6E0gtId4MyfJKLhUYhi4srwol4ZDqlRfKRG8csJFt0G8+c?=
 =?us-ascii?Q?Omx9xbjrxhAVuWQI6YbkcGWWMgYFu+TD4icaJWsr2ek6hsja/mddiNH2OyNL?=
 =?us-ascii?Q?nQ7RcLZSK50FGTf4MvyKogPFsOLYnowagBrfuZps7RpJwCRy9Qe0/jztiJga?=
 =?us-ascii?Q?n2RgbIeEBGROMJAwSJr6sBBLImmpfelb3AHh/9Jl7uW82GrwLy620KhNvc4V?=
 =?us-ascii?Q?EtE6F+K4ijxdabnWCnX9ivu6gLOiNAE=3D?=
X-Exchange-RoutingPolicyChecked:
	GjgP9ywUguEihonC7JrfqPDQJZjNl5+36QqkurAHUzmNdXUp2YJPPq7Uh1vVJawyGRS/hPBCCBrWA3mOofqHLFaM29EyLHCkFpoPPmaSoc8QpRbuXuStBq5mFU6M+R5gFSp1q+rC2KYoadQVZl2uyyoaLlOku9RQewRUQRWBH0ZU5yOgx7ByH6o9x6yXXpDoadfmDe1/ug9TUCk0EqxOjK+ziC1YgyyiPKGy7nQHerI+f9jIsoWrGbp5MxFyOJ5BfJ9W3uTDUBlGwwDnyCE6ttYZ9jjo/hsjqxlcDsqiWrOpJpMiWaHQmho6l1TmxpPdUUpPiHdkxJvKcDENklFTpQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00293c69-2ac9-41da-d2db-08deb10d78d7
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:15.6638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zz1qMtdVo3YAwP+guBLDjumXopEBBMon7nBgPUlV20MzZiAf5EEutpHfpQNW9r2oeqnyh03JCXL1bofUBObip0DggmcZRrL3gp1DxUXvytw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9564
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfXw6rky+499oGk
 TtW8V7I0KEEZsAz8bmchwsYZCJeZv/GhS59aH8hGZG1JhZeIlEZkNucicRdCU+I0Jdf0U/0LSI7
 tfUkEZZuajWKsMLH0Cw75zcZoLSaQRT6B8tVAL96rSMWQkQwb8y6VvvqwbfI6qhXLvy+b7Cceoo
 Snt1ASSsG5187LZBwvBGVkX3Tg8fe5+2JN3WWcVlSBr+dDb6qGc1qIdHElqUEf4VelVGLY5wjvK
 lE65iPvXS3mjARbJfBl6mluMQe2XDffiDnXba2bB2pYRjQ1OFLoMdQAJ3NuevVYdk7qq5i1ncqb
 0ltKnABRXitmSPBIpKqWYR8s0zSI/JztKGA/O2WTP8kZHGbklZSFBwmfkQapiLEYU4jbt3+R+ES
 kf9zsLtx9xti23WytGZnyHgByGu8/QMA9hCTIJ0Upwz6JoxJlvpj94f11Pfu5zMzkrHn+HB9nps
 P76/Dg85HUKtKy4Ff5A==
X-Authority-Analysis: v=2.4 cv=evLvCIpX c=1 sm=1 tr=0 ts=6a04a809 cx=c_pps
 a=1GsU8nEb0rXVac2zXnn+jQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=qagGDh9ZKt14fccB-tAA:9
X-Proofpoint-ORIG-GUID: FjtCFhkx0ORZRYFOrFQ9DBhQXR4sq06G
X-Proofpoint-GUID: FjtCFhkx0ORZRYFOrFQ9DBhQXR4sq06G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Replace the existing FIELD() macro with the newly introduced IDREG_FIELD()
macro to remove deduplication. All definitions for TCG remains the same.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
---
 target/arm/cpu-features.h | 232 +++-----------------------------------
 1 file changed, 18 insertions(+), 214 deletions(-)

diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 4e44245a8b..782850ccec 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -50,14 +50,6 @@ FIELD(CCSIDR_EL1, LINESIZE, 0, 3)
 FIELD(CCSIDR_EL1, ASSOCIATIVITY, 3, 10)
 FIELD(CCSIDR_EL1, NUMSETS, 13, 15)
 
-FIELD(CTR_EL0,  IMINLINE, 0, 4)
-FIELD(CTR_EL0,  L1IP, 14, 2)
-FIELD(CTR_EL0,  DMINLINE, 16, 4)
-FIELD(CTR_EL0,  ERG, 20, 4)
-FIELD(CTR_EL0,  CWG, 24, 4)
-FIELD(CTR_EL0,  IDC, 28, 1)
-FIELD(CTR_EL0,  DIC, 29, 1)
-FIELD(CTR_EL0,  TMINLINE, 32, 6)
 
 FIELD(MIDR_EL1, REVISION, 0, 4)
 FIELD(MIDR_EL1, PARTNUM, 4, 12)
@@ -189,217 +181,29 @@ FIELD(ID_PFR1, VIRTUALIZATION, 12, 4)
 FIELD(ID_PFR1, GENTIMER, 16, 4)
 FIELD(ID_PFR1, SEC_FRAC, 20, 4)
 FIELD(ID_PFR1, VIRT_FRAC, 24, 4)
-FIELD(ID_PFR1, GIC, 28, 4)
 
 FIELD(ID_PFR2, CSV3, 0, 4)
 FIELD(ID_PFR2, SSBS, 4, 4)
 FIELD(ID_PFR2, RAS_FRAC, 8, 4)
 
-FIELD(ID_AA64ISAR0, AES, 4, 4)
-FIELD(ID_AA64ISAR0, SHA1, 8, 4)
-FIELD(ID_AA64ISAR0, SHA2, 12, 4)
-FIELD(ID_AA64ISAR0, CRC32, 16, 4)
-FIELD(ID_AA64ISAR0, ATOMIC, 20, 4)
-FIELD(ID_AA64ISAR0, TME, 24, 4)
-FIELD(ID_AA64ISAR0, RDM, 28, 4)
-FIELD(ID_AA64ISAR0, SHA3, 32, 4)
-FIELD(ID_AA64ISAR0, SM3, 36, 4)
-FIELD(ID_AA64ISAR0, SM4, 40, 4)
-FIELD(ID_AA64ISAR0, DP, 44, 4)
-FIELD(ID_AA64ISAR0, FHM, 48, 4)
-FIELD(ID_AA64ISAR0, TS, 52, 4)
-FIELD(ID_AA64ISAR0, TLB, 56, 4)
-FIELD(ID_AA64ISAR0, RNDR, 60, 4)
-
-FIELD(ID_AA64ISAR1, DPB, 0, 4)
-FIELD(ID_AA64ISAR1, APA, 4, 4)
-FIELD(ID_AA64ISAR1, API, 8, 4)
-FIELD(ID_AA64ISAR1, JSCVT, 12, 4)
-FIELD(ID_AA64ISAR1, FCMA, 16, 4)
-FIELD(ID_AA64ISAR1, LRCPC, 20, 4)
-FIELD(ID_AA64ISAR1, GPA, 24, 4)
-FIELD(ID_AA64ISAR1, GPI, 28, 4)
-FIELD(ID_AA64ISAR1, FRINTTS, 32, 4)
-FIELD(ID_AA64ISAR1, SB, 36, 4)
-FIELD(ID_AA64ISAR1, SPECRES, 40, 4)
-FIELD(ID_AA64ISAR1, BF16, 44, 4)
-FIELD(ID_AA64ISAR1, DGH, 48, 4)
-FIELD(ID_AA64ISAR1, I8MM, 52, 4)
-FIELD(ID_AA64ISAR1, XS, 56, 4)
-FIELD(ID_AA64ISAR1, LS64, 60, 4)
-
-FIELD(ID_AA64ISAR2, WFXT, 0, 4)
-FIELD(ID_AA64ISAR2, RPRES, 4, 4)
-FIELD(ID_AA64ISAR2, GPA3, 8, 4)
-FIELD(ID_AA64ISAR2, APA3, 12, 4)
-FIELD(ID_AA64ISAR2, MOPS, 16, 4)
-FIELD(ID_AA64ISAR2, BC, 20, 4)
-FIELD(ID_AA64ISAR2, PAC_FRAC, 24, 4)
-FIELD(ID_AA64ISAR2, CLRBHB, 28, 4)
-FIELD(ID_AA64ISAR2, SYSREG_128, 32, 4)
-FIELD(ID_AA64ISAR2, SYSINSTR_128, 36, 4)
-FIELD(ID_AA64ISAR2, PRFMSLC, 40, 4)
-FIELD(ID_AA64ISAR2, RPRFM, 48, 4)
-FIELD(ID_AA64ISAR2, CSSC, 52, 4)
-FIELD(ID_AA64ISAR2, LUT, 56, 4)
-FIELD(ID_AA64ISAR2, ATS1A, 60, 4)
-
-FIELD(ID_AA64PFR0, EL0, 0, 4)
-FIELD(ID_AA64PFR0, EL1, 4, 4)
-FIELD(ID_AA64PFR0, EL2, 8, 4)
-FIELD(ID_AA64PFR0, EL3, 12, 4)
-FIELD(ID_AA64PFR0, FP, 16, 4)
-FIELD(ID_AA64PFR0, ADVSIMD, 20, 4)
-FIELD(ID_AA64PFR0, GIC, 24, 4)
-FIELD(ID_AA64PFR0, RAS, 28, 4)
-FIELD(ID_AA64PFR0, SVE, 32, 4)
-FIELD(ID_AA64PFR0, SEL2, 36, 4)
-FIELD(ID_AA64PFR0, MPAM, 40, 4)
-FIELD(ID_AA64PFR0, AMU, 44, 4)
-FIELD(ID_AA64PFR0, DIT, 48, 4)
-FIELD(ID_AA64PFR0, RME, 52, 4)
-FIELD(ID_AA64PFR0, CSV2, 56, 4)
-FIELD(ID_AA64PFR0, CSV3, 60, 4)
-
-FIELD(ID_AA64PFR1, BT, 0, 4)
-FIELD(ID_AA64PFR1, SSBS, 4, 4)
-FIELD(ID_AA64PFR1, MTE, 8, 4)
-FIELD(ID_AA64PFR1, RAS_FRAC, 12, 4)
-FIELD(ID_AA64PFR1, MPAM_FRAC, 16, 4)
-FIELD(ID_AA64PFR1, SME, 24, 4)
-FIELD(ID_AA64PFR1, RNDR_TRAP, 28, 4)
-FIELD(ID_AA64PFR1, CSV2_FRAC, 32, 4)
-FIELD(ID_AA64PFR1, NMI, 36, 4)
-FIELD(ID_AA64PFR1, MTE_FRAC, 40, 4)
-FIELD(ID_AA64PFR1, GCS, 44, 4)
-FIELD(ID_AA64PFR1, THE, 48, 4)
-FIELD(ID_AA64PFR1, MTEX, 52, 4)
-FIELD(ID_AA64PFR1, DF2, 56, 4)
-FIELD(ID_AA64PFR1, PFAR, 60, 4)
-
-FIELD(ID_AA64PFR2, MTEPERM, 0, 4)
-FIELD(ID_AA64PFR2, MTESTOREONLY, 4, 4)
-FIELD(ID_AA64PFR2, MTEFAR, 8, 4)
-FIELD(ID_AA64PFR2, GCIE, 12, 4)
-FIELD(ID_AA64PFR2, FPMR, 32, 4)
-
-FIELD(ID_AA64MMFR0, PARANGE, 0, 4)
-FIELD(ID_AA64MMFR0, ASIDBITS, 4, 4)
-FIELD(ID_AA64MMFR0, BIGEND, 8, 4)
-FIELD(ID_AA64MMFR0, SNSMEM, 12, 4)
-FIELD(ID_AA64MMFR0, BIGENDEL0, 16, 4)
-FIELD(ID_AA64MMFR0, TGRAN16, 20, 4)
-FIELD(ID_AA64MMFR0, TGRAN64, 24, 4)
-FIELD(ID_AA64MMFR0, TGRAN4, 28, 4)
-FIELD(ID_AA64MMFR0, TGRAN16_2, 32, 4)
-FIELD(ID_AA64MMFR0, TGRAN64_2, 36, 4)
-FIELD(ID_AA64MMFR0, TGRAN4_2, 40, 4)
-FIELD(ID_AA64MMFR0, EXS, 44, 4)
-FIELD(ID_AA64MMFR0, FGT, 56, 4)
-FIELD(ID_AA64MMFR0, ECV, 60, 4)
-
-FIELD(ID_AA64MMFR1, HAFDBS, 0, 4)
-FIELD(ID_AA64MMFR1, VMIDBITS, 4, 4)
-FIELD(ID_AA64MMFR1, VH, 8, 4)
-FIELD(ID_AA64MMFR1, HPDS, 12, 4)
-FIELD(ID_AA64MMFR1, LO, 16, 4)
-FIELD(ID_AA64MMFR1, PAN, 20, 4)
-FIELD(ID_AA64MMFR1, SPECSEI, 24, 4)
-FIELD(ID_AA64MMFR1, XNX, 28, 4)
-FIELD(ID_AA64MMFR1, TWED, 32, 4)
-FIELD(ID_AA64MMFR1, ETS, 36, 4)
-FIELD(ID_AA64MMFR1, HCX, 40, 4)
-FIELD(ID_AA64MMFR1, AFP, 44, 4)
-FIELD(ID_AA64MMFR1, NTLBPA, 48, 4)
-FIELD(ID_AA64MMFR1, TIDCP1, 52, 4)
-FIELD(ID_AA64MMFR1, CMOW, 56, 4)
-FIELD(ID_AA64MMFR1, ECBHB, 60, 4)
-
-FIELD(ID_AA64MMFR2, CNP, 0, 4)
-FIELD(ID_AA64MMFR2, UAO, 4, 4)
-FIELD(ID_AA64MMFR2, LSM, 8, 4)
-FIELD(ID_AA64MMFR2, IESB, 12, 4)
-FIELD(ID_AA64MMFR2, VARANGE, 16, 4)
-FIELD(ID_AA64MMFR2, CCIDX, 20, 4)
-FIELD(ID_AA64MMFR2, NV, 24, 4)
-FIELD(ID_AA64MMFR2, ST, 28, 4)
-FIELD(ID_AA64MMFR2, AT, 32, 4)
-FIELD(ID_AA64MMFR2, IDS, 36, 4)
-FIELD(ID_AA64MMFR2, FWB, 40, 4)
-FIELD(ID_AA64MMFR2, TTL, 48, 4)
-FIELD(ID_AA64MMFR2, BBM, 52, 4)
-FIELD(ID_AA64MMFR2, EVT, 56, 4)
-FIELD(ID_AA64MMFR2, E0PD, 60, 4)
-
-FIELD(ID_AA64MMFR3, TCRX, 0, 4)
-FIELD(ID_AA64MMFR3, SCTLRX, 4, 4)
-FIELD(ID_AA64MMFR3, S1PIE, 8, 4)
-FIELD(ID_AA64MMFR3, S2PIE, 12, 4)
-FIELD(ID_AA64MMFR3, S1POE, 16, 4)
-FIELD(ID_AA64MMFR3, S2POE, 20, 4)
-FIELD(ID_AA64MMFR3, AIE, 24, 4)
-FIELD(ID_AA64MMFR3, MEC, 28, 4)
-FIELD(ID_AA64MMFR3, D128, 32, 4)
-FIELD(ID_AA64MMFR3, D128_2, 36, 4)
-FIELD(ID_AA64MMFR3, SNERR, 40, 4)
-FIELD(ID_AA64MMFR3, ANERR, 44, 4)
-FIELD(ID_AA64MMFR3, SDERR, 52, 4)
-FIELD(ID_AA64MMFR3, ADERR, 56, 4)
-FIELD(ID_AA64MMFR3, SPEC_FPACC, 60, 4)
-
-FIELD(ID_AA64MMFR4, POPS, 0, 4)
-FIELD(ID_AA64MMFR4, EIESB, 4, 4)
-FIELD(ID_AA64MMFR4, ASID2, 8, 4)
-FIELD(ID_AA64MMFR4, HACDBS, 12, 4)
-FIELD(ID_AA64MMFR4, FGWTE3, 16, 4)
-FIELD(ID_AA64MMFR4, NV_FRAC, 20, 4)
-FIELD(ID_AA64MMFR4, E2H0, 24, 4)
-FIELD(ID_AA64MMFR4, RMEGDI, 28, 4)
-FIELD(ID_AA64MMFR4, E3DSE, 36, 4)
-FIELD(ID_AA64MMFR4, SRMASK, 44, 4)
-
-FIELD(ID_AA64DFR0, DEBUGVER, 0, 4)
-FIELD(ID_AA64DFR0, TRACEVER, 4, 4)
-FIELD(ID_AA64DFR0, PMUVER, 8, 4)
-FIELD(ID_AA64DFR0, BRPS, 12, 4)
-FIELD(ID_AA64DFR0, PMSS, 16, 4)
-FIELD(ID_AA64DFR0, WRPS, 20, 4)
-FIELD(ID_AA64DFR0, SEBEP, 24, 4)
-FIELD(ID_AA64DFR0, CTX_CMPS, 28, 4)
-FIELD(ID_AA64DFR0, PMSVER, 32, 4)
-FIELD(ID_AA64DFR0, DOUBLELOCK, 36, 4)
-FIELD(ID_AA64DFR0, TRACEFILT, 40, 4)
-FIELD(ID_AA64DFR0, TRACEBUFFER, 44, 4)
-FIELD(ID_AA64DFR0, MTPMU, 48, 4)
-FIELD(ID_AA64DFR0, BRBE, 52, 4)
-FIELD(ID_AA64DFR0, EXTTRCBUFF, 56, 4)
-FIELD(ID_AA64DFR0, HPMN0, 60, 4)
-
-FIELD(ID_AA64ZFR0, SVEVER, 0, 4)
-FIELD(ID_AA64ZFR0, AES, 4, 4)
-FIELD(ID_AA64ZFR0, ELTPERM, 12, 4)
-FIELD(ID_AA64ZFR0, BITPERM, 16, 4)
-FIELD(ID_AA64ZFR0, BFLOAT16, 20, 4)
-FIELD(ID_AA64ZFR0, B16B16, 24, 4)
-FIELD(ID_AA64ZFR0, SHA3, 32, 4)
-FIELD(ID_AA64ZFR0, SM4, 40, 4)
-FIELD(ID_AA64ZFR0, I8MM, 44, 4)
-FIELD(ID_AA64ZFR0, F16MM, 48, 4)
-FIELD(ID_AA64ZFR0, F32MM, 52, 4)
-FIELD(ID_AA64ZFR0, F64MM, 56, 4)
-
-FIELD(ID_AA64SMFR0, F32F32, 32, 1)
-FIELD(ID_AA64SMFR0, BI32I32, 33, 1)
-FIELD(ID_AA64SMFR0, B16F32, 34, 1)
-FIELD(ID_AA64SMFR0, F16F32, 35, 1)
-FIELD(ID_AA64SMFR0, I8I32, 36, 4)
-FIELD(ID_AA64SMFR0, F16F16, 42, 1)
-FIELD(ID_AA64SMFR0, B16B16, 43, 1)
-FIELD(ID_AA64SMFR0, I16I32, 44, 4)
-FIELD(ID_AA64SMFR0, F64F64, 48, 1)
-FIELD(ID_AA64SMFR0, I16I64, 52, 4)
-FIELD(ID_AA64SMFR0, SMEVER, 56, 4)
-FIELD(ID_AA64SMFR0, FA64, 63, 1)
+/*
+ * Expand FIELD() declarations for every ID register field listed in
+ * cpu-idregs.h.inc .
+ */
+#define IDREG_START(reg)
+#define IDREG_END(reg)
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+#define IDREG_FIELD_START(reg, field, _shift, _length, safe, defval) \
+    FIELD(reg, field, _shift, _length)
+#include "cpu-idregs.h.inc"
+#undef IDREG_FIELD_START
+#undef IDREG_FIELD_END
+#undef IDREG_FIELD_ARCH_VAL_ANY
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_END
+#undef IDREG_START
 
 FIELD(ID_DFR0, COPDBG, 0, 4)
 FIELD(ID_DFR0, COPSDBG, 4, 4)
-- 
2.52.0

