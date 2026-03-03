Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011016.outbound.protection.outlook.com [40.107.130.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C1C38BF76
	for <kvmarm@lists.linux.dev>; Tue,  3 Mar 2026 09:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772529877; cv=fail; b=k9x1t6qjW7Pu4XuH2wsk0ZAC3CcXqHs/PQRx+Xf6bNqJw0jEt5jtzzsqoLB+Mpid7woiKNZVwrP53wSrI+xIR6rnH+ZD19Z5W0zH497OzqlHuqEYA5XYwcdNqMI8NB7W3Xo5bSQkhdF0N2h+alSVHiHD55+Fn9+JpIcqAYQvBNg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772529877; c=relaxed/simple;
	bh=ScZwUlfUV2um6orKugVj0484pvYLfyOFbHygrj9FltA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nYeKjpagHI04r8wtNnOOXc0kgHxtWXaKcbSh27CtgYK32m/SQ0WsYJe6lV4ObOSYj5AHneBURZBRakeZm+Omn1xjMJJ4/za5P9vAgPCvYVlObfhuITSYFIRzQzrls71QNuDszp9lnbUCvPQRJgv5IbbbPsXtkk7olmTExCI+17I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rMgEe1nO; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rMgEe1nO; arc=fail smtp.client-ip=40.107.130.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rMgEe1nO";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rMgEe1nO"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=H4QxGkY7oBL2+aPNXh2qN/Ue2VO+ftDkYUVMUY8VOoGTmBks1sA4GHq7+qH0jujiZZo/tBgJWUT/H4wiIDK4T6y8KlF/oBh4283Lf861eacA5fwi4qACoy9+Gl7tt91boZHPPi55sQS/RyYTkh9EuMk5Rh/iEaJjAHrlfVRAtQE2PMMvdLA1xKFrafEiVRLec6PRVJFLGyMOcBjh/QoqKAbuAU+5A4E5mTO4GMtX6oh5Y+ADmcvWY8jj1JcrU1gyG3vOsazSrcgIv9x0SNQqj85cMtruUQCmlTiosBDlE8Wjkj6jnH096rjBZ5G/+Aql3/u/Qfgvzw81ZMKyuYORQQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6u38KZcv9EUBpJ6khGF+YF6rSMSCB+gtD/FP1Izsv9U=;
 b=rc5rteyZfJemrTzvzoCC4KkmmFb80Ov41b+SA3NbuxJOoimkx+W/j25pUwEILGEYm8wrfvMpp6eY5Er4eggpWzwPtVNh0mbwSmjWFWw9Txa7mCyetcWPMt+bCHifAOJAqRjAf6YAj+UjUYIjIoOK5zuh0SIgK8VMuH2+TTH1FDZ4rrKU/Z5/8h6/byzJ69P0Q/UEBJLPOtqTNOxsgcKcxHPonD71P8PAqO46qlAL6F4oRGRiDgDDOrDgzy/EYxpCExmJZzO7d+5ywpkL9oGBzqZ8y0PfzKgCxan1GwfelEZqdiMedY8V3hAbHQ5cdD5NubzhTa8def/3t/G3d3Jofw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6u38KZcv9EUBpJ6khGF+YF6rSMSCB+gtD/FP1Izsv9U=;
 b=rMgEe1nOl+Kn2w89KLks1xjcEewZvqGoI0RBDg7QxDwLYAhfZAHIRN31Cj1pkHxs+5iDhJDqX/uL4SqHVcEf5vPNFjuMbV7Rcm46LeMtYEebpYR6Or+IIUONbRyCUflQwssIL5oPlZeE1YLLcOSSiIeVb3e4iAVDDCcj5ZvlCo8=
Received: from AS9PR05CA0073.eurprd05.prod.outlook.com (2603:10a6:20b:499::32)
 by AS8PR08MB9905.eurprd08.prod.outlook.com (2603:10a6:20b:565::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 09:24:29 +0000
Received: from AM3PEPF0000A795.eurprd04.prod.outlook.com
 (2603:10a6:20b:499:cafe::45) by AS9PR05CA0073.outlook.office365.com
 (2603:10a6:20b:499::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.20 via Frontend Transport; Tue,
 3 Mar 2026 09:24:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A795.mail.protection.outlook.com (10.167.16.100) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.16
 via Frontend Transport; Tue, 3 Mar 2026 09:24:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qtXigdROEb5Q6AenKkaih/HKN8IvHYDosy4UjBcLYkksVPV26fDfsdQ56RReAXV02WznSWCepODq0Ao/ig5aHA9vlNrWBRk9ItXLnhW+jYhwVTupPetSHEukkoubUr2hF8XCjAqUI3T/mjFm7zl8x7ZC4xehkNMf67TnbSSKpEsvrjHB1IF1ciHu+1r+4fGo0zoUCr3KxfUXgyEecklgdKPHJ46cME4mRTyBb2aFS0Ld9TvKC4L9aRxvcfzZS/vya5VHB+5rsHoP4znTP+OlJrHF8lHzU7i4L3i3V2UeMRCt4KQoTCpaCevF49Nw0s/pqpMNAMcK7/aw2YEpqEPhaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6u38KZcv9EUBpJ6khGF+YF6rSMSCB+gtD/FP1Izsv9U=;
 b=kw42DZWraoNi53BIGMxO6RTJW+vvtQUCBRe7TXzVNaekyyUO9lLOjU/C+jg3oS3j5TeaspwmvvDGUpQHixt4EgOYMJGLSJIPrTuaTyvKjCYnvRMZ6OlaKF2pht+lrNdMECJIXxwroqLPWBr3wD3Ha09hvO6PKHSd1I8Ow7gJaK1mQh+r5T+lFcF5iiAic3yq6H6f16d7+XjCrl1lrY7Gmqtq0HCmqfpXB00zNc/wN0B+hVy0JD6P6rMEGEgvXmmyLE2/bw2RyV320Lx6TzuZ7dzwpaM/3dmGFymRAySkTahvC5xRehob6CMaNTt8xqxAqJ1nGJMgs+Fs0ciSE/kpqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6u38KZcv9EUBpJ6khGF+YF6rSMSCB+gtD/FP1Izsv9U=;
 b=rMgEe1nOl+Kn2w89KLks1xjcEewZvqGoI0RBDg7QxDwLYAhfZAHIRN31Cj1pkHxs+5iDhJDqX/uL4SqHVcEf5vPNFjuMbV7Rcm46LeMtYEebpYR6Or+IIUONbRyCUflQwssIL5oPlZeE1YLLcOSSiIeVb3e4iAVDDCcj5ZvlCo8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by GVXPR08MB11640.eurprd08.prod.outlook.com (2603:10a6:150:323::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 09:23:25 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%6]) with mapi id 15.20.9654.020; Tue, 3 Mar 2026
 09:23:25 +0000
Message-ID: <c5736126-99d7-47e5-ac6c-802504894a46@arm.com>
Date: Tue, 3 Mar 2026 09:23:24 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] KVM: arm64: Disable TRBE Trace Buffer Unit when
 running in guest context
To: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
 Fuad Tabba <tabba@google.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Yabin Cui <yabinc@google.com>
References: <20260227212136.7660-1-will@kernel.org>
 <20260227212136.7660-2-will@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260227212136.7660-2-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0560.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::18) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|GVXPR08MB11640:EE_|AM3PEPF0000A795:EE_|AS8PR08MB9905:EE_
X-MS-Office365-Filtering-Correlation-Id: 29b0f86b-60f0-45eb-c029-08de7906abeb
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 to4fYUHb4Xi/juNgwP4G/tkoZY3X+UeF0aFNJ4XnGDPQYxRVHDRwXDUNs069NT1rY6c4H2DB5qSQN1c8SAjfgUKl54OV8sQP1GlTsB3LpsQnFlUJUJdXUaQl2YGVtd+yTlBEYLd7GaXgkWim+lc+r2DsbUTcaqNNsJApi5I933xa/s7Sbvcel3LM8DXxHoRv1nQwRNoVcPkdg5rhwjwejnjy8Q3wwbcRpP14Y48u7JOpM7bhVRnAH7FicSlQ6FIB1Wo8ZQusyDwxYRaHoqRGNUFMEMvKXHEf7auo7Y7UoOPps9swqoUmKsA+jHO5v5/jRxrcg4cF7WcE4uDwESENGTDIvlj9O0zvr80xx7gPJ9YoafkdlLNre5pcChRYAEnONsj8Ahn1igpMgsq1Q7j4KS/dp+UfA7lCJJDDlFP2U26ippuE7Nrz5EQKYzJ49mbHcrfPRnmLv3OW3zCcipWEOrQa5b8WTVEsiaH9owml5WxKhZ/ut1AUc3dZGW1IQzoGLUb0tLYGSU+mzWMlplVsvBgxbKHSl8WtE4ZTx0KBWXHeBxVbAJyOJzwKZpLTQ68m5g50dQDOaicFTXeSYtnu+rqE3jCGsP3iQ8RgrWC6KiEVVeUd3eANHoDEi0sKT5bWOwW4k8SgZBYxYCNY2896wggmcTxCm162VP8wGLiF8VBxI9Ft2f30Mx+oYsOip2WAySKp7vjdTO9Yxz18lwtFqwM2PxhRN+bdIUjvqgfTtXI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11640
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A795.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6e69c0e6-2b43-404e-d11e-08de790685b1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|14060799003|35042699022|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	vLiLP507ZLHYAs5h35ECri5dIVCL700WNIi7VCKTFQ0YPW/Rt6Dpk99JV1WZhuxHxOOa7hrHpu0syOE+a+MfCYI3zEMTow+9jr0KpCWT0L5u+9gCaULTbPg16nWw+NpxOK3S3RHOkaKRgY5lJP0S9rL3WARSBjnOk2b1KdOTvfLlAYSK96bMtN63MbNMNwgHDszvEYet9im2Pi2ZK0w6giNA8Xqm/qzENVNXm/VanK9odjTLvSkQcFdTmmqoOJzQwtl0RMzxAF1A3dB1kDZ63H0huFB8jAsw/vecz8t3t75mWIpFKLmMHhcngSIxXGvR/XdqKarCFLeizcFiL28f5TIcc/sv0hvPwL1gbeH/zAU/j2a+f/jjdEyMMnvKV5UzPNO9g8szgwsUwNohG9aPKAysVAbnkfxN76NM+csJJrB/2fxOQQ4imxFF12+p+OUi5iruHeDXEu8l8KgOFa1RmRSiSv9cQHdts5s0BeAaV6P0Sy4IP0ZHrgciGMmOjZ7lVdjmxwMxnCICT/ZKspwSwtzQ55xtQJdRRXmDUizp6s0FK84fJnBJeiI07eDJKdjde8lcptkNFHoaAbqFcp2vqi5zCrim0vxAs2tfK+yaFk5GsY0l+zLBRR3GJsK8aWp7yCbjCyOHTulgWQ1Pjx8xKoky7hNWClZTCtwV1OfU1kxta3fa2hYi/2xF/aCUJb90gABGc7sS33RA9F1nB9dka+x/OAsBm0Q/T5y//J0G3ORg+7e4UcJJRYlccapWa+HKvkNANw2z81E2Fr5efQncfKmAKXmVJYD9iCnSDDdupg2n62mLdk9GW/H9Z+AMNO2Wfj3yqDpwOG4wha86GG7a6A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(14060799003)(35042699022)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lCtHJVRpB8KOhDo/Z8nT+UlFZZTQR+f4/whdHe8yBJbR1EhujtJdnAW8G1LHCE2+dhjYjZJKyyEswjrm2pOnBSVAoguoMzcOAa/qlD+G6L5bXEU9TsxcDR8z2//6HLbPo7EPCd6FyVZvakjVA5G64IGvFq+QV0cqa4YtfC27bhaIeeihGatMD1jhTf5EULWBzH4OPToftsi84M05o0eaOvu7ws07JSWfxoAXKA+3oiu2YxiQMUrHJNIr9mO97Ca//EDD0cHoF+ccVc43mBU+/MLwJgBDPr/dFg6NDux8G6AjBVdFOul+1kDdIu+GU4k6f5SmIkitLTXmdehx9pPPq57XfJ65u0y1X5aU/tX5m8lSv5muJCjrXOnzlmG5tma7/o9N1faffmbtW4uj1LHhJW7XNbucrfrrNPP8txgOCm2BIZvO4HVURKanNRtLQLwt
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 09:24:29.3259
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b0f86b-60f0-45eb-c029-08de7906abeb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9905

On 27/02/2026 21:21, Will Deacon wrote:
> The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
> generation in guest context when self-hosted TRBE is in use by the host.
> 
> Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
> TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
> per R_YCHKJ the Trace Buffer Unit will still be enabled if
> TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
> Trace Buffer Unit can perform address translation for the "owning
> exception level" even when it is out of context.
> 
> Consequently, we can end up in a state where TRBE performs speculative
> page-table walks for a host VA/IPA in guest/hypervisor context depending
> on the value of MDCR_EL2.E2TB, which changes over world-switch. The
> potential result appears to be a heady mixture of SErrors, data
> corruption and hardware lockups.
> 
> Extend the TRBE world-switch code to clear TRBLIMITR_EL1.E after
> draining the buffer, restoring the register on return to the host. This
> unfortunately means we need to tackle CPU errata #2064142 and #2038923
> which add additional synchronisation requirements around manipulations
> of the limit register. Hopefully this doesn't need to be fast.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Fixes: a1319260bf62 ("arm64: KVM: Enable access to TRBE support for host")
> Signed-off-by: Will Deacon <will@kernel.org>

Thanks for fixing this. Looks correct to me,

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>



> ---
>   arch/arm64/include/asm/kvm_host.h  |  1 +
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c | 73 ++++++++++++++++++++++++++----
>   arch/arm64/kvm/hyp/nvhe/switch.c   |  2 +-
>   3 files changed, 66 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5d5a3bbdb95e..1532ad2b2ec2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -770,6 +770,7 @@ struct kvm_host_data {
>   		u64 pmscr_el1;
>   		/* Self-hosted trace */
>   		u64 trfcr_el1;
> +		u64 trblimitr_el1;
>   		/* Values of trap registers for the host before guest entry. */
>   		u64 mdcr_el2;
>   		u64 brbcr_el1;
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 2a1c0f49792b..3dbdee1148d3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -57,12 +57,56 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>   	write_sysreg_el1(new_trfcr, SYS_TRFCR);
>   }
>   
> -static bool __trace_needs_drain(void)
> +static void __trace_drain_and_disable(void)
>   {
> -	if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
> -		return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
> +	u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
>   
> -	return host_data_test_flag(TRBE_ENABLED);
> +	*trblimitr_el1 = 0;
> +
> +	if (is_protected_kvm_enabled()) {
> +		if (!host_data_test_flag(HAS_TRBE))
> +			return;
> +	} else {
> +		if (!host_data_test_flag(TRBE_ENABLED))
> +			return;
> +	}
> +
> +	*trblimitr_el1 = read_sysreg_s(SYS_TRBLIMITR_EL1);
> +	if (*trblimitr_el1 & TRBLIMITR_EL1_E) {
> +		/*
> +		 * The host has enabled the Trace Buffer Unit so we have
> +		 * to beat the CPU with a stick until it stops accessing
> +		 * memory.
> +		 */
> +
> +		/* First, ensure that our prior write to TRFCR has stuck. */
> +		isb();
> +
> +		/* Now synchronise with the trace and drain the buffer. */
> +		tsb_csync();
> +		dsb(nsh);
> +
> +		/*
> +		 * With no more trace being generated, we can disable the
> +		 * Trace Buffer Unit.
> +		 */
> +		write_sysreg_s(0, SYS_TRBLIMITR_EL1);
> +		if (cpus_have_final_cap(ARM64_WORKAROUND_2064142)) {
> +			/*
> +			 * Some CPUs are so good, we have to drain 'em
> +			 * twice.
> +			 */
> +			tsb_csync();
> +			dsb(nsh);
> +		}
> +
> +		/*
> +		 * Ensure that the Trace Buffer Unit is disabled before
> +		 * we start mucking with the stage-2 and trap
> +		 * configuration.
> +		 */
> +		isb();
> +	}
>   }
>   
>   static bool __trace_needs_switch(void)
> @@ -79,15 +123,26 @@ static void __trace_switch_to_guest(void)
>   
>   	__trace_do_switch(host_data_ptr(host_debug_state.trfcr_el1),
>   			  *host_data_ptr(trfcr_while_in_guest));
> -
> -	if (__trace_needs_drain()) {
> -		isb();
> -		tsb_csync();
> -	}
> +	__trace_drain_and_disable();
>   }
>   
>   static void __trace_switch_to_host(void)
>   {
> +	u64 trblimitr_el1 = *host_data_ptr(host_debug_state.trblimitr_el1);
> +
> +	if (trblimitr_el1 & TRBLIMITR_EL1_E) {
> +		/* Re-enable the Trace Buffer Unit for the host. */
> +		write_sysreg_s(trblimitr_el1, SYS_TRBLIMITR_EL1);
> +		isb();
> +		if (cpus_have_final_cap(ARM64_WORKAROUND_2038923)) {
> +			/*
> +			 * Make sure the unit is re-enabled before we
> +			 * poke TRFCR.
> +			 */
> +			isb();
> +		}
> +	}
> +
>   	__trace_do_switch(host_data_ptr(trfcr_while_in_guest),
>   			  *host_data_ptr(host_debug_state.trfcr_el1));
>   }
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 779089e42681..f00688e69d88 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -278,7 +278,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>   	 * We're about to restore some new MMU state. Make sure
>   	 * ongoing page-table walks that have started before we
>   	 * trapped to EL2 have completed. This also synchronises the
> -	 * above disabling of BRBE, SPE and TRBE.
> +	 * above disabling of BRBE and SPE.
>   	 *
>   	 * See DDI0487I.a D8.1.5 "Out-of-context translation regimes",
>   	 * rule R_LFHQG and subsequent information statements.

