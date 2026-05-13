Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9300A38D3F7
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691105; cv=fail; b=HxXOZEd0U1+IW4dqQnUhPqiAYGfa8vyFHLAyID5Q1VUTNuMq6nbwqnS5ufaMbbQJMtaoEgWenr0OdBRrY4gmq+tHJ6Bnkch+oT9SwVJ7fPZN/u/Ee2MScQhU+ZksMBCLeK1WHbEn/A7tT2OWU3z4o51CJPVcbUDPZ8nrN83+WkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691105; c=relaxed/simple;
	bh=k/flzJre9FqQ/ASU2j/CiJHB6ahzuLAtmJbK5baC1lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oQaKxLuooUs4Ewjm6QbMrr9RBowE6MammnjjzhMikPl/R8feFjOtqhvGmRZb7gFmCJPaf2G/oAWHgmCyJQEdgSqIglM1IGKBIt32AN/nCVwW/Q2GSy9pcQF6dvM9ibvqAvwLuXj6fogc08qd2aiZkyOaSi/zya2AYQ3MrHy1Jcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=v7f7slzq; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=aEKATPYA; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="v7f7slzq";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="aEKATPYA"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGKven2443069;
	Wed, 13 May 2026 09:34:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=toKZkTdlFKzUeQhHNwineIKgENlXHE5kh7nsj1m1d
	so=; b=v7f7slzqqFaQVRtp9yh2XIN5nq5TXqJ41LURXCLYp893lPuupoG07oWsh
	EFTaHuXDoDNdmixWVpmm6Fb2z6zWs1Gk8RWWWheqcjEasn1Zo2VFLKKIVDxFZYDU
	yn26uly/vrikjMGuYfQ+QO0qSBlYdVJu1j2JetCzZ5Y57XRHXUIqehtrD/K17XCd
	iw22j4r3QD84CUB4YfZS+sYMxfxW0AtFp5mcUcNxwxUGBfC3DuF8W4EQiiqyF3NJ
	PZAl5BhEFWQpousXNpj33oCOGrV8ZPK/3JzjvCA/Wt2dXbN61DQIVFCEaUYzU/3S
	wy99cmlRNJ7fHyI5S7i4gXPL9t4ow==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020114.outbound.protection.outlook.com [52.101.193.114])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nv6x8ys-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zU/rtaKuW51iAepWR8ka9WrsoSk3A0uKIae9AlGS8itZjXGOuehl9NL1tLJi5KZAmzUitK9VY0SvL21r8AQoUO6zxH8K/96c97hVg2KbmP7gV3x29HtKzqJRTGj+/YEgVnh7QSqhT/NlayaD1CXR8IlY+YOzwU2U+hak/Yh7asmaLNKqE4Rkqt8sUnHQhj8qhi1QS82ykNn6Tl6ldpM4GYoJ4jDRDkV+EKLFc0PfY6TyKs6UymOhqT3DNc55cOJyIp8SBrDKFaR2pqIMfzkLB8YzOFzxOT+hXvx5GcaHRkWQRTim0VzT4ZvyJv7G6Y478b7E4cZ5gpqm7xtq3CoHlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toKZkTdlFKzUeQhHNwineIKgENlXHE5kh7nsj1m1dso=;
 b=FNSN5049B6HOlNFWpcl7SrQ2x6MTUYl1Y0YJFNxsa6nAQsssw7uDoyuv0zuFCtPOESHD36FqcYBNOBg/2O/jS32YsCc1ZrJ02JrckHR+kA3cQUob7Yo6W7vv5iAKBScUIOg1ikEoA9ecmIR+bhy0DAYuPT8QVADeLcVQkOTGAxAN1lIcMDbBoKisf1b/irTpMUqNEqnvs2pTR4h131CzlG6BMgbCAR3KBgkMdPi/wvR3A2hdKlhkaCQsJbZSZkqt9bBZxwBKP4ztcPnEM6baWmDYKf/lsDq2RAf1VFCUfEeCF8B/cx+y4/0QZC5L7b1N2LOKQ0kL7wQJjnfaov0ATQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toKZkTdlFKzUeQhHNwineIKgENlXHE5kh7nsj1m1dso=;
 b=aEKATPYAzWfcB+I3Ov3lxhPZojal7eU0xpYkQib8xv3e87z0JTA/xmFcww8R7F1fXdEcxM4gp0GvV0p7k6CuJqq50UWR3ycfyS3+SUkGAdF2i0rKW1F2msSYk9NDU8A6FDLqooCfX/BpRIgmMoxmPSXGJnWrVXv7WC6kNjl5YpheRb1omlEohiqwK+nb1/Xi6AsDmBoff5zbzCkK52IAzoq4CfTvMdD4TlAArm+G9E/ytvJq7Hbw7TP0KSNEx7XhpkLyAouI2FlO8WIYhG5rzMWAlhS0avqo7wanyecR/MewPa3fXyU34UsYd1V5tr80HCw3iddYraWk2QAN4bIDrA==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by CH3PR02MB9564.namprd02.prod.outlook.com
 (2603:10b6:610:120::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Wed, 13 May
 2026 16:34:11 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:11 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 03/13] target/arm: named_cpu_model: initialise additional sysregs
Date: Wed, 13 May 2026 16:33:46 +0000
Message-ID: <20260513163356.3033159-4-shaju.abraham@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: c23177e9-e40e-46db-bed2-08deb10d7698
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|22082099003|921020|56012099003;
X-Microsoft-Antispam-Message-Info:
	5kiD2AeboJLTPl/w2UhLxETbQCpfWXXo32qI25GrY6JW62toozpjxD9bleIdT9DcHHy7zEtX7fuRS8iholPshUuJEXfV9X22i6jhG2Bo5Z8S3606ZZCLia/l/e989OJOcFf90ZwyZzqSG/XXYZpRNPu/eIT60xH3Awsc6F5YdGCPAhfWhlAr7RKSmSuXT2/N4+eAoAty++5GTpmNaH12bCJSpp5HSAbWWeIEP5WVrB3WX9r7wLW2Q6DXhvLH67X3w9Xs26WY8nab42phI0ct0yt5isq0+a9ttwadUmqJ74e+zFpaGX28+jMHdII945m5z2FNx641BX13bWOqowYaGApXLwIEVb7uXYmmMz5qDd4P1jd99s7UdGSZ5ZyZ3gwtXJ+NS54uLuOsQK0kQpb86ac9el+LpZT2ORGYoDaeH2yq084c7cMvUhREcctRaeIweapv6IIccI225mAKL3MNPwHeBqBDaL6rQs5g7KU0Q85xnC38J4mVguDgrg30BeRDX+PEGhh5dEH2oUJWnpVgjZZ39Bkf5OTFX1H5A4kaaeUeUWPuw1Jx640TKI3Er7G4cnpP4kH0OhMDWl03UHvCZtRKMBLPlc0ogBVgu99kucV4htFhi2BxO+zy66nhTIeB+7EIDj0KkAGChJXzJ6gZo8ZvFhc6fSgNN93oa4k1hJ3EaBoqCEVoVSGimqmdsMd7Nsx2kgUNqVHf0SuEAuE5tpu9mccRWvZkRgJW90CWCdQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(921020)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TajNwYgezD+g8cR6QcAZ/n5SEFXWFc3M+B4DOrfjSPbnjbuwmMOa9DrchF51?=
 =?us-ascii?Q?3V0Xd9d2zAH5mFa6f9ZbiSkLe2bTZvukoepGfDRebRko3CcI5AnQQh6t0pZM?=
 =?us-ascii?Q?hJ4sEjcVUATwHc3+LjTgrRkXAasqrpvZjj4tXkQLZdX+VeD38HoUr2VcHiq3?=
 =?us-ascii?Q?GlguBxZETlz0yw8V/gWLcPRZcTv4pqkluioDQqEFiytTBQy0HJetCPEtRv4M?=
 =?us-ascii?Q?GpkkNrSl6g5qjzfU8g+TNjwZhmwEAbk7i6sb5f12zgmBUQgQiyhlWUgJ3CWK?=
 =?us-ascii?Q?zApH2iqwb9wBpR80TZi8AsisNrsVZq9B924n3BxjTDTauDaajk6R0i9aGX96?=
 =?us-ascii?Q?D6Im0XkAIBKTRxtqJLoVud8abBswfC92McyyoJ+lSQZrpLVjiwVEuhXB0Dez?=
 =?us-ascii?Q?Q0MCBH5KlTXoHPiz4GIHVq66kQWwJ5jyeyC+t9T0ZcbE0bZ+XrlzmwCCe0E3?=
 =?us-ascii?Q?6LtO/0wzxh5OcN1v+rtWZdW+VbZyDjG/KrDCe+OqVBES+GKba0Gn0ChaylYI?=
 =?us-ascii?Q?eX9o+yn4taSRku7d1HaznUpffHT1ESIHgtfNQImqC0a3lgqxGmAiM1BTpsZH?=
 =?us-ascii?Q?iw0zTfZR+MMGuhCC5rqHCFZGA8lW9C1ni7rQm1oQATmkfpsRzAOZbUuKJCM5?=
 =?us-ascii?Q?Tm4nvPBK10Jh3pSTU3/fsiX1+Y8audqexjrZoT/kvEuIld4uzoxH3bPEqNwf?=
 =?us-ascii?Q?FNd9pAfj0q+sVvpxLs8C2Z1OZHhqHwj8a9ilnsld46BBpajIezP8+uk8L2Al?=
 =?us-ascii?Q?WJJwH/k3jXHmufb26kDMRdMTL7j04hMn+L+piY0MAmCQCdxibpcJ12uVrB2g?=
 =?us-ascii?Q?cL1KyoSsdwBahhOTEV3541Dwwf7vvl064CXICv/1b2R7TETK3+8VVWCyffC9?=
 =?us-ascii?Q?M++3f4v1YFaNOF5EPq5zxEjR9UGQqnZgytjP3xNwegMfhJd18x9ZzFHtVHyx?=
 =?us-ascii?Q?qOwdI8rlTZIrS5EGNvEEnxOeMKK0RT9Ov7QrQ6lW2ung82WGw/77xLSRMUpY?=
 =?us-ascii?Q?m9cIwnsWl+nTdzUkaSAIpmHQhaFzrRMbNm+F0i/2H17RHiZhHXkIoiqfmg9l?=
 =?us-ascii?Q?nkqFi81o82V9QSYxGV2M5kAH4iBdgDmtuIDs68Suw7WHOEM088vgfYLqq5rK?=
 =?us-ascii?Q?IlWdJsWTTScFaleNOYzzKZG/Qp3JkYSgiKZvElsW8IaYa2O16tor7ydHqTMh?=
 =?us-ascii?Q?Kf2zium8uNPdBiMbvL9kRtl2GdL68FxQy/beNbo+88yplnauR9aeRjgJmaMY?=
 =?us-ascii?Q?IaBXQS2bGmfYaszSt5kZ/ttAPAjwaGN9bxagaQj2nzyew2WZB5hQf6ww18g3?=
 =?us-ascii?Q?BlI7J/3arNZt/jBhc0Pk2Y38PYTZR4YvW9RdhWfCi/cShRDfiCtPWWNn+PVA?=
 =?us-ascii?Q?6FgJyUcDP7xJ+S+AaXAu1XmMfr1POLiErLIPN4ogW29401AGHqEbOpmVJW+I?=
 =?us-ascii?Q?mJ7rwY8gR9rnnzK3cY6u4Pu/UNg3YmCuNSR0bnxQHN+VTgokgpjT0Q4HZmd3?=
 =?us-ascii?Q?1Y9xyFB/iofqxkhTzQ7IQUpjoRmWk+AlL5S5e/oLuc496572V6DMOHXDLAJI?=
 =?us-ascii?Q?9hFuAGplCJN0SNL8AQtNHEgxwjnPIhZmWTmGHnejIwFQ9IZ4L05kqv1U2Kgv?=
 =?us-ascii?Q?87GMuPRB32YKHAiZwD1+GED9tTFyUDrlaCrN6WJnBnnAYSAQ/vU0hWyBigUB?=
 =?us-ascii?Q?e4DXPXydwwSoip/GMXm7R1q8w0c2ifd4d9wiawdZQxaMNyL3M/uFXMZjc8+J?=
 =?us-ascii?Q?PLMbC2Psu786sRdRJAdlmqks/w6Nmlc=3D?=
X-Exchange-RoutingPolicyChecked:
	DTY0sTo4PSzjGy5ZNmXHI2BOWOnl6FfxRrCzzt4TYLPCR9CbSn9PP9IJ7RgkiBs/gxAuQRNkAMLZTAYaax44IPYDGdOMhx2Zmw7mXo5KV8/BSqnOMRtZ3az/8nmBXRftvVhakTC7S2wU5hWz+2nicnDX0ba/dLoxGUrkXqXXOaGXjlTHlkHZx1KuV+w2RmTQ4E8dkG3lx+FpL6abHPTFiu8bp8Iur46YEuR/6H7WYz8Lu0iLaHSZ04Qn8M2rbZwDkMfSRv2q/PAeahYS2ZmDsjEvbuQSPZc2fzutTiHfCSPflDquJhsyq40gaQyYA05ry0EUSEjOwHIZVMLxLIG9xw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c23177e9-e40e-46db-bed2-08deb10d7698
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:11.8124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74c1TANgQ3BiW4CIsuytBGPMK5qOclWCSaFPpc37Qs05YpU/27x1sbO5qDKdFEursTAyMBa4NvdUYjKyWOs3vH66A1tqopgEMzkjRaRUBkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9564
X-Proofpoint-ORIG-GUID: dq9LCJXwTm5UeeOxirtv_P3mmOdVOCcI
X-Authority-Analysis: v=2.4 cv=P7QKQCAu c=1 sm=1 tr=0 ts=6a04a805 cx=c_pps
 a=rbgWxcc9iAUYZcdwGxTk+A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22
 a=64Cc0HZtAAAA:8 a=RqjlFkL8uL1O1Lsoah8A:9
X-Proofpoint-GUID: dq9LCJXwTm5UeeOxirtv_P3mmOdVOCcI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfX4zCtDG/OLCqN
 sDiv3EL3We7R1tQILvQwq9jV2fsMkpXlNQ9EvlTuJo+Nur6073VgA/fmMAg8EiVjCAbIT2CF7x/
 L8rurRAiDFcTInkbiPMy4GQEW0WIIC7sldfurbTWyszh7gnu0EPMi7fWSIgbcJoo6InDSOSELha
 Uu1dAXbsPh2tKBLjeUdCcC6HtJlZkSrfHwSe6Tv8uOJ44cMEI2KksuwJ+cpfLfLxwf0HwWc7iu/
 AK+FRLlCxoC0ozNRRH8rluPX9vvZPg7KH0dt5aFbYZXuRoKGD0MhP/GcTNjznbz1sBtaTNZrSV8
 D8UrARZzCBK1oh0wm4MwtkUrmtn6aaiU/lQaFQceRFWzSPidcUHIX1/nixK89W/kv3/D8h5t2g/
 dDYrAcU4HpD/kirCnN6el7d402Nveg/ebh9WntJb062sKrjZdSJuM5XQeX3WR5+uRko8FcEZMFq
 Qqf3cHALyH4EDYHZC3w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add entries for sysregs MIDR_EL1, REVIDR_EL1, AIDR_EL1, ID_AA64PFR0_EL1,
and ID_AA64ISAR3_EL1 to cpu-sysregs.h.inc.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
---
 target/arm/cpu-sysregs.h.inc | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index 3d1ed40f04..82a83d9d5c 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -41,3 +41,8 @@ DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
 DEF(ID_AA64ZFR0_EL1, 3, 0, 0, 4, 4)
 DEF(CTR_EL0, 3, 3, 0, 0, 1)
 DEF(DCZID_EL0, 3, 3, 0, 0, 7)
+DEF(MIDR_EL1, 3, 0, 0, 0, 0)
+DEF(REVIDR_EL1, 3, 0, 0, 0, 6)
+DEF(AIDR_EL1, 3, 1, 0, 0, 7)
+DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
+DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
-- 
2.52.0

