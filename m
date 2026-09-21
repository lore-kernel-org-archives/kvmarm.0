Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BB53C4563
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 13:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995875; cv=fail; b=sAkW41lMLVUuagTp4FcsQzmV2qxDml0IHGj7WT0ZenQ3ouhwSrw6tCFcSvZlTrjW8NV7TuoeSZhttozc86RLZES5FyVis9zIIG2r4rG/jZu7D/Ut1BWRL0AEeUogiPWHZkBaPhLq/pgakROfJOf7ggyuiYhrLNakkc6UC9g9cyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995875; c=relaxed/simple;
	bh=5edzojfttnfxB/1dZ7Z+zLEfZ2iyKYj2zsbQqTKMMEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mzaDh0JLEgXvQ5Fwg3Hc3Ov3EA5tiX0M0L1Jl7m3y4dxsfcGVVB57SdfHHgIVWgSdTHQ7LQSZB0MaDyKW6bv7OZyerREpa9DGHKXk3K7U/up9xYd4ZD4GURPEHbzu2NuJYfpVEIYDSUut8FmJ5n2mWfnIV7bcQbD7b3CJfWqahY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=TcmxkqFa; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SVdKgjXg; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TcmxkqFa";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SVdKgjXg"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAflUG774316;
	Mon, 21 Sep 2026 05:33:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=108On4TGifilxBS3dCsewSVEjfked9itg+pM1qjq9
	x4=; b=TcmxkqFawSrY2AoQ8iLrQPgPGNsOcG81AHMwWCbqQ6PVWUW0xkoeZv7V/
	Z4WtkIUQJYLBUZcJn8d1dqgVJhkPtynBi/2qBjyu0dn2lwYX6pGNoJu5GPcbkUI3
	RR4IwPQuUFzZeXQzF/c7mJrx6San7JqU/+FLCaJJSd4B6qIdwg52Qbk7kXTacicl
	fZf9aZ5Cf1coiA5tpOg73yLzJc4JkemwdKCO6nGHYeSmkQ2E5rxRdiSbtsY99VJw
	4cjyrPVp7blPQpuh74oZe124tLweXcDKDXY2H1iy9858KBtgoDHg0Lh2Vw4QQLrQ
	/OjrXAMDsLDKK7lXLiQ9Q3rP0uvVw==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11021115.outbound.protection.outlook.com [52.101.57.115])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gsqx831cb-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=astshh8HayoWV6qkGj+Iufi2V3fa4cRXeg0vlCfNx+UvZqeb695gH+L/2GzrQEaelYmC/B7DVVVJQuJmZy0I19vkMiyfV0bq7IWQby3IT01zymG1aVw6HFJ2te/2V2ZR6GiYBOWIcpsVPotnRI27+TLNQpOW/RKqZdb0F6fnMdrRITxfrDP/a06rzGcVtpPQcsQtbdLiQ8M2E5Hghk6Gtt9mZvaJrKWGQ4K7vRAfRIKvrnfH5hLtHvn4PP+JtECRvvnaxb2EaYJvM8l/h5To7Is2TaPMcpDrEMpH2lcMIZziG8GznbNT81Iyvmvqhi3ptQ4SvjREnfWVTJqt7JfPtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=108On4TGifilxBS3dCsewSVEjfked9itg+pM1qjq9x4=;
 b=U7Pws5Qfk3/HXgSuG/tc41MRT+0zNvAqO+MZjb9u2EVl/3LqNgHxpAUiB22+TxDhKG+mJSehH/CnS14ham+SKjlqi14DfJhCL0AZI67pbfdlHCPxyWISvDCfMYQ5iZCI810Ns6tTJMC9bh1N4+lfEd4mUhRCvXOK5iNpFWYWrIBlxUYR4PfgtLmhXdIqv3R2DsQIaSxzH+EEVeE9jhVePZSKHxONOvWnZAbADThxuyBNK1Q+2VDeiqOppZ8zpplJuYpmq8+YoctBnCyZdBtX6/uukGgbfcIA8mbTno+gOCXNZamOh3mlvm+4knmXgzD4wSJD8WHOZi3UYvRItatbeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=108On4TGifilxBS3dCsewSVEjfked9itg+pM1qjq9x4=;
 b=SVdKgjXgY/hEMUGJpi4WiMV/bs4qyS6kP+DEHCA/hqbBBYPqWSiFcIDb2W3LYoIx0K0N0PAwU3tL1BXMtCLZQdb645IqewIQ4uBz74RF0NW2CTM6icz0iitQTxRvoZ1HWsjT9sIbYU/JWoRSMlRr0xPm0zp1JhgQvARr6Qq9zCknsswiWLr8T4uSHUzktYGHmG8qFBnkoLp10rooexgI9y6znDHijkB5Ll5lzs7LJ+5f8HCV+IIpzWV2hm/11GiBxv4IN5XANKec/Fjd1E+5IBG6MUZCqlk++K1TZ8/PBRGaDVyPsWY0qYQMuESLYHn4oqz/Id0Y3FXF7CKOJeaWwA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:29 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:29 +0000
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
Subject: [RFC PATCH v4 10/25] target/arm: fix SVE and PAuth finalize for named CPU models
Date: Mon, 21 Sep 2026 12:32:34 +0000
Message-ID: <20260921123249.1708067-11-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 373c99d7-67d1-4a54-a4b1-08df17dc8a75
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|3023799007|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	z5QVmbqorKrb0abHvUr3RARvsOblf98n2RAURd7MxvH9MJTVSkBjFiGdfY7W0AZ2IKcMws1BQnWNKFiFYKQ01Snc2+H+TwFJdY1OxWXba+qqqN9oF9Zqrhg1TC3XwTXtDRe/lgjY6LAGM0esu9w+ZTi0/UIpIAmbfZHn4zufd5sa6upjFIcQMGZOE+jxRffP2hgJUI0bk5/NuN600Y+f0+WZkSbJCsP421yTYt12jDCGzN7zjNylXRgMts+mA3IsEex9D3WEAm8s7si6gqd1GIRzp8+H7UKHPu1485+vf3Z+ProPx22PHmyOpBq8zHCbTzcKAwEvLRYRY9h/XKYPE2WVmZWSIuDUNNnqHCcqYRaBlvxJ4fi3ZM3Yz4pRFcU7pHgR/4dQMF2O5HBgmIjo9LPODuZRqt+3jKdeNGqCMUqOnX4VPFd6TlFaPp5TVdiQMvzy7xgDEIkBaPGTxNFLWXS9JGeEBwMzcC9g0zYtcZavUzPtUK+3pzp9m4LEMzRb4Btt3WN/CyyIMxHl7kT4vM68CgHpO1KW3n704vbXSKMsSE4FHUD+mURC5PasMM3/RATibFnuBFzCDgk77C/Dk15269yqex0PMEARvbicSKWvxmQCbYJrH7JUSnK4ldebg7flSDzFWDSl5ft5nfiUDsX5l9LbHS9ATe8JccOvGJs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(3023799007)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fCOx2aYADpbB3qEnWYkLtUxxV+Ph1ItUy6/Pl4YQUjxjYl/z33o7agHWQ+QC?=
 =?us-ascii?Q?iwypPhP6+NsbJozNCZYVkXBpIatBnd/F6Gj6YjiFXjGf/TIv2L4FIqAE1bp/?=
 =?us-ascii?Q?ofs2Pblbg1oNN31BgQ05gaxqBcOdRM9Oz7PrHViTC9svYgLeDb1pczB2GHwW?=
 =?us-ascii?Q?praqB6AEev26C/3/CeuueGdCdFGPhe592krDi8W62p43/aAXoA7YCtotag5f?=
 =?us-ascii?Q?/H9hypg9N+vGneG1SFnwnY//LdwpMzJbkbD2L0/fyg6+W15+vkAlSqLfMWxm?=
 =?us-ascii?Q?Mwi/vYd1D8Pk1wavD0S5IL0An13zJMrOapMdlymzMteHqIoE/x48y3vUrS8S?=
 =?us-ascii?Q?KlRzMM6J6RSms8wmYje3m6asbjHZrdj1yNZmejCih/escW0iCB7RP573pu45?=
 =?us-ascii?Q?QLNSWfHptoMfNxvR60XC6qU/X3cXWH9H/G527OuRoda9makrwMGgnFPpmKpN?=
 =?us-ascii?Q?LOgWuz+ztjG0oeP9hKxoAbXSrSzx+ZtEI6wLdODV8MW8k8YYKJJMh/fC/HRe?=
 =?us-ascii?Q?NdMzMoQGeEiRlzvhN4EXskUCn9vzPbXSDelMzTrAOuS8ywOJuuZPflYqwZBQ?=
 =?us-ascii?Q?yblLE2mkjaQkRFqNunb1CawiFgYKm45cCEOFWz3eAlY1qGC0ym347Y/3EaNg?=
 =?us-ascii?Q?EERC/RId50UR3g1P8cfs5AVQWnuCc1Dte5NFKrCReDYOFyk2ke2CAYE0GMSR?=
 =?us-ascii?Q?faVNrRYKLXFNSQoXecqGf3OQFxdkEHmv+BqoQzC+6mu8qfV3Ybhpy69b2ObG?=
 =?us-ascii?Q?i78BFbavGzV6CNWmpLxweomkQ0gA06PzM4jz7UR+iG35DMOAbKCqEjnMcyIo?=
 =?us-ascii?Q?M5DWKXEYj1hspjdNQO6mIDfT0j15olTF8nxvKwf0MQf6D+zADbikbyaXt4MJ?=
 =?us-ascii?Q?AoyWWRrEuhRVMHn8mtBz4yPQQFJL7aDN/NdArHHqrlyITolBEqJbUcf1Jj/y?=
 =?us-ascii?Q?NXWE9hQeMdGTMzHraV1kRhXbdJNgMsImlbJ+3z2At7uvE4/GPpm9bVAk8PsS?=
 =?us-ascii?Q?/qJ0j5rQeix6Bk8RMsJjejZu0XYVoFwL4XCbP2TpBqpi555Wg1b3o2XpLmFv?=
 =?us-ascii?Q?SeQZgvUXOA8vsd00Esn2D8zx8lyBLrTbMucXyuOoRIOvL2qPeW4iSbx6PXwQ?=
 =?us-ascii?Q?Qh3koQehpMCMoQcsF1ILWle3/SCppwZsIG2X3Ja35hTlKSNLGjdb04tud5kl?=
 =?us-ascii?Q?LyrWXvDmn6P9Wf/jhkXeIBBtQY7DPxUitE/uE3cLktZzMeXAGNYll07jwkrs?=
 =?us-ascii?Q?2x9kv2ouucQfFrd1Pr+p4dxLtHCHcwNZCkk8hRRZmbTFoP90J46n9f5PxBvc?=
 =?us-ascii?Q?agakugol8dT98qxtzlhapqfczLTS6pRXuHuCXCs3OGBWlVasUHzC3cFDCwsZ?=
 =?us-ascii?Q?gDU1KIXc+i+DhKHyIV45MMXm3HQWTRbEzi/D5ghTgEmrCQdKKYgcRVOWumxx?=
 =?us-ascii?Q?IeeLrluAxdP9OeYbbcDMxlKSVOfTK2BfzfxEiF0CsvUXPDZOrYhCy9FpD5ER?=
 =?us-ascii?Q?sBnVVIQIgOdNFtlhPyqHnImylnTDOL05S5CWffW5L1P6g/oKGDpEth6qp+9p?=
 =?us-ascii?Q?Epecvv1JkWDNFicA4hPq7QdjncGDiPxnJMMNHxo8wK7oRFfeu6wVadoiQAQl?=
 =?us-ascii?Q?LKSG2K8wpO92yVsjrJyoSFTgsqBdiNx428E6cUrStb2ZSDz1iLVpkUk8OObp?=
 =?us-ascii?Q?s/f+NmpoJSj+dGsXtaDASlsoYcazJg5GbOdwI0u5at1KKt06Upy6kxu1NB9z?=
 =?us-ascii?Q?+qJmZTbvVr3XHOaJbX86ZAkYxbeBMU0=3D?=
X-Exchange-RoutingPolicyChecked:
	Evwqzkye85vo1c05aUxPTQcVOuXTIjjqn8+/2jiu7/0TtcJSC2iDATUxMTWX9Em+YNHFJzVdoE16oOsR7rS6P97D3Db/rCKFS17F9RVR+ScJ1JKLejLQtQntd23mOmtvbKm8Fr1WWKtJr/YTirRqD3R58MRHGCU2B3f6D6GraoKiSEIVffoVDloWa5UYrvJp3Zt5r+QTo4CgeYTKDnwqq2UGY2pnVeAQmnFiDZYXCwJ+/hPA169Pys98DNYh62fIWSf7ER3hjL7lUMfa1+D5ud+PuBbz6iW1p5J/9x8LdNiB1H/KvmBS9yjcai9fCf+jIPVmQWHd2LDt0AHH+EAA6Q==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 373c99d7-67d1-4a54-a4b1-08df17dc8a75
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:29.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s0qEC0gP2se7Ogc0LadG34iN3ESTmTLTpOM13TXWlFpM0WaPGmjrwYNOYMZV4hrkGwu3QxfMaXSR0Q8oD9ygZiWU2OvA3vpAkIvSWcYat40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=KInPn1Fo c=1 sm=1 tr=0 ts=6ab12423 cx=c_pps
 a=jYOLmuRG9FCngycrw98U6Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22
 a=64Cc0HZtAAAA:8 a=eaKVySaVM5pmrxNhKe0A:9
X-Proofpoint-ORIG-GUID: fBIuCFV_Vm5TyrTQ9oGXvtmsrEWJovkQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX0mONpLKAzx9c
 6MmvlSSY3ptpHGZRE9cD4pUWcciQLfrRR83HJUgnNb3VQRH/1neJNg0u/Z5O9s9FDAtcKSZIbuX
 5PuarHcoX4w8c49vuBineI9QrfUZ6dg=
X-Proofpoint-GUID: fBIuCFV_Vm5TyrTQ9oGXvtmsrEWJovkQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX4Y2yjCO7jt8G
 PR5seMad1ytNp4ORcv/3pkPU28N+zS69LlLVisduIzYd2fySBIE/bxSM0lonbdB5ofe6YKPrRrR
 7s3dDX1k3O/Y2739R/sk4Z2gKIo+gf94/uOWQq+KZmQLzvsjVfkkXmAIYCyILWxu2E/lrsfqkZW
 NiojwRfnFQubDtIfCaW4WYxcKYmw3HFt6TzuUKB77Ct+lcLIkdCX4wKNuIMMawU95SVTQ1b7Jhk
 F82AOImQZiPFrV5Vi00FEG7COYTDIsBaes4hpNiZKBK/dIAJHXAXxfCkMzI+BttDz2kxAoXd3Qv
 V1zuxZQEVjPsQKZ+Mo16M3wp7rcqB5SI2mogrdJl6Zp7hfxJc0wD3134ymTg+drsC/9P/xezq+F
 GR5Xi3nOs1iicjyhz8m+cFg6smJ8ytWW4a8l+jsSPCNJ2AM7Ze07ZcODA1knwPYGsBCwTo0wPfV
 cqcU/cdC4qm9FRDGH0g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

As named CPU models define their feature set explicitly, their SVE
vector lengths and PAuth fields must not be derived from the host.

When SVE is enabled without an sve<N> setting, require the named model
to specify its supported vector lengths rather than inheriting them from
the host.

Named models set PAuth ID register fields directly through SYSREG_
properties. Preserve these values in PAuth finalization.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu64.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 7487b48cc9..a0114b0fa2 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -38,6 +38,7 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "cpu-idregs.h"
+#include "cpu-models.h"
 #include "trace.h"
 
 /* convert between <register>_IDX and SYS_<register> */
@@ -134,6 +135,21 @@ void aarch64_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
             return;
         }
 
+#ifndef CONFIG_USER_ONLY
+        /*
+         * If SVE is enabled but no vector lengths are specified, we must not
+         * default to the host's supported lengths for named CPU models.
+         */
+        {
+            ARMCPUClass *acc = ARM_CPU_GET_CLASS(cpu);
+            if (acc->info && arm_find_model(acc->info->name)) {
+                error_setg(errp,
+                           "Named CPU models with SVE must set vector lengths");
+                return;
+            }
+        }
+#endif
+
         if (kvm_enabled()) {
             /* Disabling a supported length disables all larger lengths. */
             tmp = vq_init & vq_supported;
@@ -556,6 +572,23 @@ void aarch64_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
     ARMISARegisters *isar = &cpu->isar;
     uint64_t isar1, isar2;
 
+#ifndef CONFIG_USER_ONLY
+    /*
+     * For named CPU models the model props write the authoritative
+     * APA/API/APA3/GPA/GPI/GPA3 values directly into cpu->isar through
+     * SYSREG_ properties, so do not override them here. Since other code
+     * relies on cpu->prop_pauth, mirror the resulting pauth state into
+     * cpu->prop_pauth.
+     */
+    {
+        ARMCPUClass *acc = ARM_CPU_GET_CLASS(cpu);
+        if (acc->info && arm_find_model(acc->info->name)) {
+            cpu->prop_pauth = cpu_isar_feature(aa64_pauth, cpu);
+            return;
+        }
+    }
+#endif
+
     /*
      * These properties enable or disable Pauth as a whole, or change
      * the pauth algorithm, but do not change the set of features that
-- 
2.52.0

