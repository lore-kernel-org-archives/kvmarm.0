Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15D3471D13
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 21:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787002194; cv=fail; b=XtYzqV2lYQNhuWbha7FTwWYfjDB9DIsjkl2vV/0rVAroJlENBdZcebKBbC4joZC58WOUVFvOk0lT6tWD2HfSDyk0f1Eyzbrlbq0mkfU1jIgIpi3RHTgPfU6Aw22rEqpTz4GgIJkeMNIDaFGhBbZYvp0XpFz/MKcMEmizx/W3pvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787002194; c=relaxed/simple;
	bh=fSV/VMQ8I3s/vnuUwUblMU290UCxnW/cJX6wcM6GRlk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eVi39+SxqCjn8pWDV2GJMpq7ZgeZBSHoVEmJAbqKnQcym5fQmPm/p4oxO4XXq6XjJz80ZiJshz9V914Os/2oyU6XLe1HTNeiDCdaHyDm2VLOCU3ixuLkvlqyAwPGCdLvXj1lzQZgnwEpEWv0Y2Eamdj3pA3p9+SO1vzhmX94DdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JftrUsyI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qLgcpylk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JftrUsyI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qLgcpylk"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HLN5l81404084;
	Mon, 17 Aug 2026 21:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=voH0d0v8dkl/kF/wV1nw6a6skaQ5Bpuw3E40wR1TbKA=; b=
	JftrUsyI6TVWA8YaIUWCx6LWHSUr3RHbRVTAJskbcMntwPFxAZj3wa9O6nC/VXi+
	6T13zgsJRaNnmUcTsal0fA38trQyrCL35coJp/1VJVFTAcr854hYwglIBHxgolaq
	SrGWTvHfC5GdbnVxZz9+Z6Wlvbeb/e8G7qLeJwFKq/FNDSkgi5iLMF7aYzMf2quS
	mWrYamkciFCogDd7FRVWO4fPGuU9gnXlVjD4RfPbhdhY8f2S3pzPci0f0trt0U1f
	AFs2EbiS5ZKC04hEVXI5r5WhIyqAx1vaBHjSifFCO3B9tEaccDZFNTQdvZtOYDjR
	tSqT5mrx1SQpkk3xjrwQeQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2ew538gm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 21:29:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67HLKePV034645;
	Mon, 17 Aug 2026 21:29:30 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012012.outbound.protection.outlook.com [52.101.48.12])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejpw8y3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 21:29:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UqO7d9jOqnFxQsGlSJHbI4AwXq2KpupOVClYG5crWEeA9UFm645nQh0uiP3kQP5cmuQ5EE6yrVHQS8pd+ci/A9/qiWaqp5o1/Ab5tv/IfKtH7HxN6SM2w4M1gajk8fxFwedjkYZW5/j4htTun0rYnzY6SnK+2HA1YYEvQF7vDUZFxwH3h5lDvh98UVdnDOz8leowqZ4HUA+EjRNrwAbu5e04rYH00lEI1NaVpA/jteymyNmRbDtEX2sKc4GL1SzEnRr0mQLOUw/tr4vdVGxqmYdutLqQ+OFlLqTtcIX72KEuxUML5SFpHXRHha1qfahCShmWlkIpPCaEdEcsrgwGGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=voH0d0v8dkl/kF/wV1nw6a6skaQ5Bpuw3E40wR1TbKA=;
 b=X6/jskweJoTf661BUhBxN3moE/w/ua5qsgxMZkRFqg4aa1mtB5KVI1PkDKAfXwovHyjELydGjOSsA/OHyOEOW7HZ+mZr5h+0hePKwDs4HE1Rf9gsFWZJwldOXISBQv8oMY2qR7oRBdk1WLCcXoQOs/GOtrcwiDKKiWQ7QngojAbs/qlgpqRskEUwpxkgNBBgHm2Y7XQVazAlZXfA+0TAaU+pGIEP+Pe9tynF/v6PA3XrVcYjCrzTGFBe9uBIQdJjbcEdxj8VGR4ohtQApTsy4xKN5NQL6dgcnTnKmJr+DJxYijwVKsnI8yERHcbJQXSN/4rM6ntZ9xaFicoLP0IXfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voH0d0v8dkl/kF/wV1nw6a6skaQ5Bpuw3E40wR1TbKA=;
 b=qLgcpylk+Mu2SsGU0X6a1lCHWUwQ5xt0Ma/h2VoQRAS5UKboJidnn7LNV3R3QeR1y3PQRTLqfo5rFliOhSXHTPqH5syOlU935U4/IBjTCI2ASmY+rkVqzbI82QsaYd+MWz/7C+tZ/mN5waMbLSOEQPWO3ZWa4k9EjJEddhItp0g=
Received: from CO1PR10MB5506.namprd10.prod.outlook.com (2603:10b6:303:161::7)
 by IA1PR10MB6805.namprd10.prod.outlook.com (2603:10b6:208:42b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 21:29:26 +0000
Received: from CO1PR10MB5506.namprd10.prod.outlook.com
 ([fe80::da72:a0a9:5f18:cda4]) by CO1PR10MB5506.namprd10.prod.outlook.com
 ([fe80::da72:a0a9:5f18:cda4%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 21:29:26 +0000
Message-ID: <77baeb6c-1efa-45fb-8a86-46a6c76b5873@oracle.com>
Date: Mon, 17 Aug 2026 14:29:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] KVM: arm64: Reset last_steal on vCPU pid change
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kselftest@vger.kernel.org, seanjc@google.com,
        pbonzini@redhat.com, oupton@kernel.org, fuad.tabba@linux.dev,
        joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
        yuzenghui@huawei.com, dwmw2@infradead.org, joe.jin@oracle.com
References: <20260816053630.527528-1-dongli.zhang@oracle.com>
 <20260816053630.527528-3-dongli.zhang@oracle.com>
 <86se4dyw7n.wl-maz@kernel.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <86se4dyw7n.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:510:323::23) To CO1PR10MB5506.namprd10.prod.outlook.com
 (2603:10b6:303:161::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB5506:EE_|IA1PR10MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: ed2ff479-2e98-464a-fc8c-08defca69cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	LHsv/FWhamcS7eZGoc5yISgd1fU8IER26Qp8NqrjE32xy0UEdTaQZFN8B1c18VK40zzZA0AmkJbYeMG1JtUojXQZwDITLov8ZP6zS8NgS6cVAi7YTpF2o0X+YAgT/ZH9/FOwJagaVJi0BpNWDNk/CXZSLqlZR83F6S3iwbnkAuvtfuCgL80WMjPe+mSQUiI+dsDC/mweDBKkqqyeYjRuUSiFoPF5F8kPKzTQuoaSzzWLzOOi5I1mrXwAT16k4UT+lv+vSAHaAJLA0ZZEhjDzsQbjTlJ24rrYM9e42sKuI3w7fqprqXRyIF7BCWHEmZvHC0Vt01gtoNApNpm0uFLJ4xJk9hhWJEaSSjoVa5BTlD6vNJGebMzHPmQOLwj3nimqYPGgUL645mPo3rN4G4UCHtT2mJuwGzyC6LDGAu1nxPBIHksEANtFiLDStBJD+ymLavYs9xGgEkCJPvG25tYQ8z3S7anmeULiQkV3b5YLplZjpSf0hyy9ca3TtEs+9e66Y2AnPMkY02SKBCiGO4VOMUYvGgl90H/ZKezJPgDbK3qW66/dQg5qi3XcD+oqdUgkLaqiFbbLTxyuHhEDA5TdfOOx2JbrYnlVmcWuDs9H5XKv5QtMPkgMgeyCXlsqKJAhrs86rqx3GTIUycWRxiVdVpM4Lh4/AyPGlRdNtkiKbms=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB5506.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVhFcThvdUJSeWNkMm1LNXJFTzltajBHWmNRZG9QY2R1SkUvYkN1ZTAyWVF0?=
 =?utf-8?B?bDJSYTVQQzJESkVmMEZTc1pPNzFxYVBoakpjN1hzQ0RrQmttNmE5V1lRaVVh?=
 =?utf-8?B?OGx6ZVhpVWVzWGdEMnVLZHRPc1RsWVkwbzA2RHFwbW5YQTBQb240Yk1SS0Rt?=
 =?utf-8?B?YnFTQmd5V0RsYXpyc3M4dXRnVUJTbC9RakRkODB2NUxRKzJZMHlVK3grd3RO?=
 =?utf-8?B?QzI0ZlpUYWJVUE1LYjZpU0VZN2EzQ3dxdGp4RndRNk5pS1VOay9zUzJNS3NR?=
 =?utf-8?B?M21uZzFnRWZld2hSM2dnQXpFeFdZTmRDSkJUQkRNU0dEajhMZXdjVGtZNlMx?=
 =?utf-8?B?dUJKcmNWU0lGOHBqVldHWUI3L05CL3B2eSs0VFFKY1hOLzF0WTk4K2FyQnZQ?=
 =?utf-8?B?eWYwaWpVcElxOUVSRzk0NzY4Z1grL0EzZWYvOGxhRm5BVjZFMFhNN25CWDh3?=
 =?utf-8?B?YmhDcEJYRHp2UWxSc1MxbjBTY1FNYmIwcDVQaUpFQUY0WnJyeG5mYjdrZity?=
 =?utf-8?B?ZXFuVkkzdEpUUkh5UG00RHBZVmVHRmZxeXBFZ2Uvc1RQc21oWmlIVXJNbEtC?=
 =?utf-8?B?YnRSUjk1T0tiS2x3VUVEZFdNdnIrdis2WHVoSDVvbkZaNjFOV0NSaG5rU2FS?=
 =?utf-8?B?R2svZWlLeDBtcVNvT1l3TmNteTdWSDZNSWNNeXM5WGZ1Y0ozc0dUT1FBYk1u?=
 =?utf-8?B?anVYdEhjZmZ5NnVML0paZHVyRVc2aE8wZHh0emJnVzFOYmtCZWVrK1JYRTVI?=
 =?utf-8?B?M3MwTEh3NC83TEUrUnJxK1FjZkpqQ3RVNFhzcTBMbnp1c2dhb1g3YUVhZGlH?=
 =?utf-8?B?SEsxdzNobjVzemxLdk85ZFVYUCtsem5jMjNJNmUyNjRjdTN2aTVPcnFnWlox?=
 =?utf-8?B?WFZBbnlwSjBQVHpPMEN1T25JVFhvTnM0YWFmUVhhZ2pUYVc3cjQyaHBPWDVu?=
 =?utf-8?B?MDRqdWZYbE5vc2U2VUE1V0NyL1pzb1NXaEdUcWlSMDNlSTNJcGtFYS83c3V4?=
 =?utf-8?B?WmFxUCtiS0V5ZTJzZytvRGRqL3J3bHoyeXNwRElEMmNRYnNNWEhNOWRZN1Y1?=
 =?utf-8?B?aytSekxHYWhCTzBwc0tRRmUySDZiL1EvZVpNdGhDeTBtaThlTDBBTG5KVmpF?=
 =?utf-8?B?aHh0MVRQOTNGdHY4cE9kRTFLdVNjYWRjdGFXL204WkNhUExmd1BheHp5SHdr?=
 =?utf-8?B?ekI1QTFSaEtVOTU3Z0YwbCtubGora3lldkMwZEN5TVhYR2I1eElCS1Q3VHhZ?=
 =?utf-8?B?VkJLQ3k3bHJGaktva3lSYUd3eXF5MERaS283c2hWNXYvQ1NhVFo2OEpMcWxk?=
 =?utf-8?B?Nkx1NWJJWjdpVzBpSlAxTHZRR0VNOXRRVVdMeGVCU1BrZTJNeThHc0tmREFX?=
 =?utf-8?B?WjhUNGUreUs2cjVQNmZKeDVDa2wwaDk3bW1Da0NVbGZFNDJ3akJ5WnBiUkEz?=
 =?utf-8?B?RW1sTkEvV3pVUE9kWVBYa0ZpSnV3R1lCeVhjK0RPNHV3d3Y2aTJ1ZVRaRG5v?=
 =?utf-8?B?M3R3ZHVrNEpBUlNnSXpOL0RhUDQzbVpUN0NwWDBXQ2ROZmNqVEx4YkgrZTZv?=
 =?utf-8?B?SElDUVV4a0JWV0JWTnZyR1BRWG9xUjl4dnRySzczUTlGZ096MHNJTzlsQ0Jp?=
 =?utf-8?B?eFZsZ0dVU2tTTkhIYWp4cndaQTRBZGVSLzJxalE0K2sreFNEOUFhejJkSWlj?=
 =?utf-8?B?OFBjZ0tuenkxZzNCMHFON3Q5WFBJNGxCbms5WWFaTFJCQ2oyZVdzb3VJRWZr?=
 =?utf-8?B?MGw3d3VYa2RkRzBaUSs1ZXdBMVFwL3ZucFMvRWx3SldEZ1pyWW9PSUw2VURO?=
 =?utf-8?B?dzF3dXFZUDdQR1VZbGVoclpDVUdZbU1acEk0Vm1NT0ViejVTWFJqa3Q2eGRV?=
 =?utf-8?B?M0dpWTVDcWRCM2EzcTlrMExPdXVjY2M5czBZRU11ZHJWWHUxSjFHWG9zYXVx?=
 =?utf-8?B?cXFJcVZQdHdYM2dlT2NGRGFaZUxOeks5L1g1TzdMN2dJZ2FqdmlFRE9vREpl?=
 =?utf-8?B?MUpLNnNlb3dycU5rNmd5UjhyNzlYZU1SNEw1dUdRMkljZEVoYWk2MFhZckRQ?=
 =?utf-8?B?RlRBdC9FUFlkZ3U5dXBXRXc2cTZpYXFhSmRzQ3U0NjJEZHVTbEdPc2xjYzNT?=
 =?utf-8?B?Y3ZzS3Jtb0RvSTFndGhlWFU2c2FUYnZGYXBhYk1JQ0MvSEVSM1hzT1JRMGFr?=
 =?utf-8?B?ZG5LY2xVYVJJRkV4SnpaVWhoZys2djY0TDFrdjJqSWhUUGt0MlpRWmJnMThs?=
 =?utf-8?B?NjI4QnkwUk1haXNKR0MrU1hPTWJZZkFyVForbGwzR05RMDhnNEpsend0VGxk?=
 =?utf-8?B?UExicVllQ292SXFXMmtKWUdzMW42ODFOYmtBUWxGQjNRTzFURjF1QT09?=
X-Exchange-RoutingPolicyChecked:
	AfmZjJgzLm7pJlFLT46vkFjRkDCGbkHadN5B8C+Lrr5+ZTe7Hf6/IivMUX6mO7eXnnJ8N+7T23vlaoooU2y7bZeEQvPKVwIGmh4AW8aw1yuxbfJ98ZGZWdsvbEb9cu7fJ+d3EzTCggB2z7GFphXFnVmclvQJ/VMyaTttxYkLROUVvrIZnna+JUG+ywyeGjw72k05ZzYpeASUg1SzCk8Z7fOpHlxvTfamp5T7BuaACBvI8YXq2awR79Q5nhFAMBoybf25AVG5LRaMeNYPIwW/jqKXYS63ogH5XQWxxFZFiw/IG0RpilGkCbjomaRdIC64nLXlZK5cGttiGva55k4Ixg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bqzy9CNhwyNzdZQxIK5HcaQ8VeeUHxgUtZXXFSNjgEGRvTVm2QMfvpp42RVHaypTdQgMQACeHRxMvN310MHBcfqTsEp5IWV5knvmLVigU8S0XlMpmKFi3EefpL7GGA7dhfJwCt/ehZU46cOsgZxWYEjX1eZfYOs2VRxZ62k8CuiKzkCdulId9AB2zRSUASIq7JVnc9T5aKfHr+T9f2LaCzIsP26EKkKEfhOjSNEkhk6oWEgxFKPzC5xlXQEOnU+G3a5SRqW176pKzXXKKCBWOdVvKKLeYNVD/QwOg1dqhq2tMBWx1xfj2PZgPSM+ctIaNqhmdX5ZjF6gnQplYpgpHjjsXH4W+Iu34EtHAy8hUe5fNstSJCuZdKf8W49R09ph//ZOnWP7vLA3mBwDAoYz0dPpZNgAGTV+aUOZtBrisfMg6LTWjfBLHvKykbq7nzp1x+PHYNAGR/h4G60EaVG+JqAm2hxUFRvNUKs3ufuBM2HgVENboMgYaA064yldcvTGnulx+9YTDTFiYOCgCjiXyrABR2h6Spz1vbhYWRB3S1YvlCa/C6+ipAPJses0fh1TU96Vw4HXIhJAqvDyJ6RTLc0iHkZRZO+NQITeZiIwQ+s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed2ff479-2e98-464a-fc8c-08defca69cda
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB5506.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 21:29:26.0869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oHAdV7mXY3bXgJ2aSPrclU88JqhkdRos89Rwc3+KdEtqcT57Px+06aIpsJ/tsMFZNRqm6YfaPVqYU7uPnyFfdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6805
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_03,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608170163
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE2NCBTYWx0ZWRfX0pD36059JW+I
 qgtAbJ1ncmFWykQPML+m0d9cu7L0bIBOH/9QUl+vURfALi15cqiZGdEgqtoFEigBqTE2F3tckO0
 F7x3c6qpZWf2PAoq8INIGF5fdQ9G7xm240wclQLTmQZw+ZKAZ96FUNqC9A2AMYhjY6P5BWrvrQf
 4vJqn/SdndLIArhrVaQlrThI+UncuT3rQRiUbMIhe1E74b0Q4X+T6IYySaHVODF4bTbvSOfbjPh
 EL89ny/4gagL6AXrh8BzHInKlkoASTcxmH6l7eARlQtQEwHUtr/vy9XV/OAFitHnlJnHyPLf5ES
 0KHOAIXxfDI3BivtJBgW7gbDz/tV3AxK9TBmJ7+sZBX/rS+jCuGoiPZxPa2ewJ/Pguw6ieW1r+S
 lrmc2MYoMQZWbelsnpQya3ccBmCoUO/7U27cvChJc78PYUY9lchLylEKV4dw0LjnMfOvmbXclds
 NGC1PLKeYwST4KL1f0AzfN2fhKTVAfB9aZRpH+Ow=
X-Proofpoint-GUID: h--3s_ZA5mX27whWCqQ969gT6T-2s5vt
X-Authority-Analysis: v=2.4 cv=cYbiaHDM c=1 sm=1 tr=0 ts=6a837d3b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8
 a=pijo3iWIGsKQvjKm3A0A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12098
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE2NCBTYWx0ZWRfX03T24vh7LaNw
 QArlX0GwWsd7+YV64V/dmUoovhb5GstT0ENpCXT3y8x2tOk/sgJh2BnrU1qZ6GydJMtUobng0Q6
 KIxAZmKewdVcY+8QSeBHoUiAnY+e3XuIUwncjQfd/I0YoEoih2d0
X-Proofpoint-ORIG-GUID: h--3s_ZA5mX27whWCqQ969gT6T-2s5vt



On Mon, Aug 17, 2026 1:42:20AM -0700, Marc Zyngier wrote:
> On Sun, 16 Aug 2026 06:33:03 +0100,
> Dongli Zhang <dongli.zhang@oracle.com> wrote:
>>
>> The previous commit resets x86 steal time accounting when the vCPU PID is
>> changed. Do the same for arm64.
> 
> Drop this statement, it really doesn't provide any information.

Sure.

> 
>>
>> KVM keeps a vCPU fd alive when userspace hot-unplugs a vCPU. If the fd is
>> later reused from a new vCPU thread, vcpu->arch.steal.last_steal still
>> reflects the old task's run_delay, while current->sched_info.run_delay
>> belongs to the new task.
>>
>> Reset vcpu->arch.steal.last_steal from kvm_arch_vcpu_run_pid_change()
>> unconditionally so the next stolen time update computes its delta against
>> the new task's run_delay.
>>
>> Assisted-by: Codex:GPT-5.5
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>  arch/arm64/include/asm/kvm_host.h | 1 +
>>  arch/arm64/kvm/arm.c              | 2 ++
>>  arch/arm64/kvm/pvtime.c           | 5 +++++
>>  3 files changed, 8 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index bae2c4f92ef5..4607f956e787 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -1339,6 +1339,7 @@ static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
>>  long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
>>  gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
>>  void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
>> +void kvm_reset_stolen_time(struct kvm_vcpu *vcpu);
>>  
>>  bool kvm_arm_pvtime_supported(void);
>>  int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 9a6c72a18672..0f6e63eace21 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -929,6 +929,8 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>>  	if (!kvm_arm_vcpu_is_finalized(vcpu))
>>  		return -EPERM;
>>  
>> +	kvm_reset_stolen_time(vcpu);
>> +
>>  	if (likely(vcpu_has_run_once(vcpu)))
>>  		return 0;
>>  
>> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
>> index 4ceabaa4c30b..000bf49cc0fd 100644
>> --- a/arch/arm64/kvm/pvtime.c
>> +++ b/arch/arm64/kvm/pvtime.c
>> @@ -32,6 +32,11 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
>>  	srcu_read_unlock(&kvm->srcu, idx);
>>  }
>>  
>> +void kvm_reset_stolen_time(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
>> +}
>> +
>>  long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>>  {
>>  	u32 feature = smccc_get_arg1(vcpu);
> 
> Why isn't this common code? I really don't see the point in making
> this arch-specific code. I'd expect something like this (untested):
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ace5801a592f..3fb77360af01 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -950,6 +950,8 @@ struct kvm_vcpu_arch {
>  	pid_t pid;
>  };
>  
> +#define kvm_arch_vcpu_last_steal(v)	(v)->arch.steal.last_steal
> +
>  /*
>   * Each 'flag' is composed of a comma-separated triplet:
>   *
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 45e784462ec6..117aeb49231a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4459,6 +4459,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  			if (r)
>  				break;
>  
> +			if (IS_ENABLED(CONFIG_HAVE_PV_STEAL_CLOCK_GEN))
> +				kvm_arch_vcpu_last_steal(vcpu) = current->sched_info.run_delay;
> +
>  			newpid = get_task_pid(current, PIDTYPE_PID);
>  			write_lock(&vcpu->pid_lock);
>  			vcpu->pid = newpid;
> 
> where each architecture that implements steal time provides an
> accessor, and the core code is in charge of the adjustment.
> 
> It also makes sure that we don't leave any architecture behind.
> 
Or how about making it something like below?

if (IS_ENABLED(CONFIG_HAVE_PV_STEAL_CLOCK_GEN))
	kvm_arch_vcpu_reset_last_steal(vcpu);

That would still move the policy to common KVM code, while leaving the exact
arch state to the architecture implementation.

For x86, the hook can reset vcpu->arch.st.last_steal for regular KVM steal time.
If we also decide to cover Xen runstate in this series, the same x86 hook can
additionally reset vcpu->arch.xen.last_steal.

Thank you very much!

Dongli Zhang
