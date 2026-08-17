Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BDD3E2ABA
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 22:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787004358; cv=fail; b=fPu70Id8gcE91X9bQv6KJoPpYuTu2c3DMyF5qfGGtKsmOqvESVz51P21pCzuznontB3uhoa7jtbfXUegWyUdpbBcJR8gU40QwCtKZ4Qr/d47FzQBewJXFnNrim6eadZQJQSLtqvp48TJ95IySvrDKfKXqTbrgIAQkuZp0Y3Hcng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787004358; c=relaxed/simple;
	bh=zpx2l1qeGCan06n+rkf/dbz6gDPXL1/RQIxtbla57yQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KKydSYfGqAuGf61aXh8M2Vbpb5/f0meL6ndNMbaZw/GPQg8Y9xDdf6mG2ukZ4a977/rOkkENBPfguq45ejsxTlk+KXmVuo2bZTF2FxRvYI0PBurJ66v25ofHTRH7PXNu1IALLpvap++w1hANGFJyrdghgYzqh4d9U51VCDOMF4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j3hu1HSQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IPBIFHk9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j3hu1HSQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IPBIFHk9"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HLMpmc1702903;
	Mon, 17 Aug 2026 22:04:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VLaXXY7oeWQjd20dbf0Hr/tyamFR3vOC0EAtNapU3Qo=; b=
	j3hu1HSQle17SgXkBBrrwJUMjXEMTgu3MS3rilBcSqv/CynUFVzIaDY19NVmhfna
	QGo6FfMeNKysxKw+182QhY83R4+V5oW5w/PTGFqM55JA1eP7XGkd5yWfVb1x8CLb
	4JESKPSKt7WAcpLaay+3arPnjAhGMRvURvlrsmZeEPKzmbYPlqXXPqt07R4pGH7H
	ZFbEbYAyNu+WWHkSQhgsfIyyTy/lnWAAEo5s1aNTdewHhPGMaSYMo29+1TYfjNlV
	pZlvKer2vWfFPlH4bcFbanAoseYNgt+Y2qiTghvNI2wqiqExdqIeG4KAVc5Rkh3W
	15E6BDuMcyYdsFJkdlk6AA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2g07k5ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 22:04:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67HM07Yl018995;
	Mon, 17 Aug 2026 22:04:31 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010041.outbound.protection.outlook.com [52.101.61.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejbsgv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 22:04:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u55UgcjUQ6otHqWupJS49Q2CKHPJADN11UOkTCz2CVXu/BFZCaihAiYGV3Gei5wb8i3Z+QlJw5bTq7n/iCVWz14Mvt/QcuihJ9jbZKdbSpnQ/K+r5jBEI1Octtzx4VHVo+CoZ3sbLQ5IvV2zqist+6kK47bhRDSj8Xe9Wf6gDcHvkrvBbVkZnZWZH+HSTKXAl5GtUrqDIzGDnwQ/77XtjKy/9JTJpapq6IdXUc+WXi5EbMcumKa1h+hBLyp/hgaKs1aNBkn25vrl9rrmAwxGpbej8YIY8f/WuNi+zJn0jKV+t/3Xc6rDjg1Y3hKvZVON6tX2abgz3gYwbqrEAvqE2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLaXXY7oeWQjd20dbf0Hr/tyamFR3vOC0EAtNapU3Qo=;
 b=WLZ9cSGnZbmrhgLecagsVUaMZkjPLunEGiNgz2N3vpRxRkYtCoeDZauP4uI2bC3dcVK1wHD/0wf49AVcEUBjgTOVqV2AZD4iJXNRRbItcFGy6uoNMKHu0n8UCCc002mx6c+zqvlh+nSQiPlfNTeIS0UXl/4yDuCA7VPw+nN7guSz/w5qHbiB8ncS2YZgyUcWdr3DfS9fl0dBmLo4ayMfmRA/uvq/mMk5rXp8mt7TOL7RN8Pv5xWgCqis5MSlwEOf5b3492J20C5MZdTROMXcsaWvxobdueqH93MqbY/3MkqvJD/eqRtsvgxO7jMRHPqHWGwTtt7Jy7cF6Jay+5LKWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLaXXY7oeWQjd20dbf0Hr/tyamFR3vOC0EAtNapU3Qo=;
 b=IPBIFHk9TrFgx79temRZv354mrkna/CJOI4MiZhDKTIHasI28Dl6+ppusG6AhAeBaO3E7KVYLv33YrapYX60Z9z+tQWho71qXhv7pHDHTNlfTaNVRVesVo8CJt6kO1V6Lvx8JzRKa6k5/NlLGu2kD5KqkDvfi6iOuzP7c0YIfaA=
Received: from CO1PR10MB5506.namprd10.prod.outlook.com (2603:10b6:303:161::7)
 by SAWPR10MB997852.namprd10.prod.outlook.com (2603:10b6:806:54c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 22:04:29 +0000
Received: from CO1PR10MB5506.namprd10.prod.outlook.com
 ([fe80::da72:a0a9:5f18:cda4]) by CO1PR10MB5506.namprd10.prod.outlook.com
 ([fe80::da72:a0a9:5f18:cda4%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 22:04:28 +0000
Message-ID: <f2f5065e-a6ea-4b90-9426-fc9ea7926cc5@oracle.com>
Date: Mon, 17 Aug 2026 15:04:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] KVM: Reset steal time accounting on vCPU pid change
 (x86 and arm64)
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kselftest@vger.kernel.org, seanjc@google.com,
        pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org,
        fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com, joe.jin@oracle.com
References: <b2843bdcbe1123945552e113b0c2727db51d9606.camel@infradead.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <b2843bdcbe1123945552e113b0c2727db51d9606.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8P220CA0061.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:2d9::12) To CO1PR10MB5506.namprd10.prod.outlook.com
 (2603:10b6:303:161::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB5506:EE_|SAWPR10MB997852:EE_
X-MS-Office365-Filtering-Correlation-Id: 316b3fe5-a2e4-4935-5da2-08defcab8236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cr8aNe6HjhV7x5xQrKEsDIVvVj45UiqeCVxVU3JQBqwGLUunY5JL3t+fwaMHCQyR8ODHzQlgJoqV9JQVPE71auLilmMza9zdAGTiNDKN60iSnvYKDxSY6JPaZbAswiaYHMAR5jv8LqWlKknb/2v0SfgLx00fX/BU33id4rxUtii7AE84cXBL+Cosj5eJaOEvIeUyadaDLaz2AjXt9UBpNQ4RDb0HRklXNNresE90jiR+ARqYgLuzMKMT0H+vgNjLbsWMIHM6D/GwxkbdhXakbQCA0D3A3Z8nTMIceBBF8jFytIlQs+0IkHsN19ojF498NXQeqoBhv+urAouDvdm9W6TZ5m1PdCxRSdmQQ0hu2eQbgqJcrUohvt0OYZsZVmKtFJwamCbXKJg6FLNPHoJ/b9uHKCkmwvGuYOggLpD4d56Z5nHs7l6dSppXhgxBqvk6PRI5n01cPKdXhUo6muDnTvDgXhrw8St4v3W/elHuUD7vs81ivGTsPTXa7xgm8CwSyN4rBpmGJRxJo7ZFbqtXvnEvmh2NYcLxJVYY6c33hHZHm2bhhCJGefo3pPDTB/OIX17lPbiqk76zx3WC3N0s3zE05050vDji/FyJUjSFZakMGh/x6Jp/GfWYnqdcPpuR1ZE2pFqlwT7YY6Ve14/lQlZucxxu0UNW57IJZ4lGrtM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB5506.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGhJdk8vMFZWTGw2dlU5VTdyYzYzSmUwYnU3dGYxQjJpVXUrWHZDVmFTNjR2?=
 =?utf-8?B?L0tMZHZhRExsMS9nYzFWa1R0TFBYb2xLWDl3QzlKa3orQmxwZnF5S3NsNHBT?=
 =?utf-8?B?eGg3ZUtjUG81WXltVllXL2h3NWZHQlRWVlFJa0J4QXRrOFpXdnhYenYwU1VE?=
 =?utf-8?B?YllHdXRBMVh0K2Y5aXpnU2pIRDV6c2NiVmN1Z2Nmd2lTOXFWOVpOa2o3MlpX?=
 =?utf-8?B?djFscnNMVkxZbkpJSnVzZXpMZFBleWNWS3pDc2lGdzJWMnAxTjFITUJ6QlZH?=
 =?utf-8?B?MkJkVlh6bDR4YXdxVHhtalFLd1h4N2U3eGZPRWJpZWZ4VVF2NS9idjhsc0Jl?=
 =?utf-8?B?RWxxbFBUWitOd3ppNFZYdWJoUUZiTCtTS3hBQ3hod0trSWl4N0o1WEVEVWJY?=
 =?utf-8?B?Tzl1eHVZQjB5ckpzSnhNVVRiaVlvRkdjTlNIdU13dUxuWVJGdURGVkJGazdT?=
 =?utf-8?B?V242Yis3eG5QVzg5aTVBK0xDK1c2MlhTMERHckl5UXo0NkhtdXcrUGNVSExF?=
 =?utf-8?B?L3FVVk5BeFJUb1J6TnMyc2VoV2wzVzJleEdkTVFSaUFXcWdlN1czdUF5dVNH?=
 =?utf-8?B?M3c4a0JsSTYxRmp0N2w0QlBBb0xReHBLT0FucG5iNzJlNkd6a3p0aUNITVoy?=
 =?utf-8?B?VzR0M080c2MwTXBkTmwwd3ZOMEhUZHJYV0xuU0ZORzgybHQxV3pZdEVLTVQw?=
 =?utf-8?B?Z0w5djh0S2J5ZjZ5amFJeFNRb1lmYUVIS3RibHFyNDJWMktMWU9zZ05qZVF0?=
 =?utf-8?B?a1dxazdKUG5zL2ZjS1BoeE9VQmMrU0xlWEdtNjh0cldaUHdYK09GZ1IxWDl1?=
 =?utf-8?B?aHFDcmlWRjlTVDZxRnZMeUlBSnZOb0RkdHd0Zm9EMTU3eHlPVllLZWNUTFJF?=
 =?utf-8?B?MHA0KzhETFlhejBEN2VFa2owRUpPUjN6alJMK2FyWC9CeEt5YTZycGFkdDNz?=
 =?utf-8?B?U29EcEo4VG9OZWlva3NqUTdNQVBBNXd4bmRGN3FTZmZVUEVRcTJqY2N4YTNo?=
 =?utf-8?B?UFRyMmExZHExRThaWjVxLzZFN09IVzJqUy9HMitsRXc3SnZkZU9UaE9PZElm?=
 =?utf-8?B?YXFvT2k3blE3b2VuRzJUbUNGaFZKamZybmdjNWRNSEU0SnpodnJzREplOGtE?=
 =?utf-8?B?Mjl2dDRwRmZSSjQ2TmcrTlJVSjh3Njdyd2ZoeGwvclZPWTJRTXRJcC92QjVM?=
 =?utf-8?B?TFl2MDF0K3NDYjFtR1o1MzVuUzlXOFdTRGdBeDBTTDFFRTVMYXphRkdLR0s1?=
 =?utf-8?B?WHNZSFJxc2dCeXVORWVQWmpQbzJqakRYYXhJcFNXc29nRCt1N2hla2kwT25r?=
 =?utf-8?B?MWxnVUVOdGdSSng4a0E5V3dyNjdEU3p2L1RZMzBtMnlVVVZCOUoweUZ3dUxD?=
 =?utf-8?B?ZHQ0OWFEZHRPMm5YU0dKVEZmeTBZY3YxSmVHZjR1TkRCa3VsT1BOREtqQVp0?=
 =?utf-8?B?QngxaUM4TE82c0NsaTA4Sm43UW9lYktkWlA0MTNSdWl1d1BTRXFyTTZxR2xM?=
 =?utf-8?B?cVE4ZjVqdGNOY1hocGw3aVg5R3hMZ0Q5Z3ROa2E3R285RWtUYlNWV3VPNXRR?=
 =?utf-8?B?d0RyVUZrOGhSdFZJZnk5WU1OcWVOTXA1Ym5CbFZ3QytkcFVSSnNhL1JkOCtr?=
 =?utf-8?B?Qk5nL3hHZUxUV09qNlNqYzVhNWxudUtFZTFwT2RLU3JkN0dPVXZpdWVwRytv?=
 =?utf-8?B?NjNYVXFrMnAxR0Y2cFNadkxVdDFQUlY4MFBUUjVWQjZkMHVyNmtEczJZNUhY?=
 =?utf-8?B?REo5ZHU2SzdRY3kxdzFwc0FVL21ScjRBcUpFemZsRlJwVEZYR1A1RFBQZVBu?=
 =?utf-8?B?TG0rdG1EamxRLzZTMnlzcEh1eldGVW92ZGhyc01ldUl2MHRxdXgvWW1zdXZL?=
 =?utf-8?B?RWVIYTVGMjFqdEx6M0Q0MG1yekh4aEM0cldwQktERTRIWENaZ3V1eGsvZndB?=
 =?utf-8?B?MTN5bzBHS25GT2MyeHBuM0hEbUFPS2w2cjZQcjZNSXczeXpacUtxWXJick1m?=
 =?utf-8?B?MFoxQUJBMjFRVkJDcElrN3FHaXZzSG11bVZ0ZThhTEpSMVVqdVJDQnJ3RjIv?=
 =?utf-8?B?akVIeU8rQkMvZ0pWKzJsVUJTYnBWZitpREk4Y0VtdGZ2VzZzcjNtYnJtVE9n?=
 =?utf-8?B?Nms5MUlmWEUzWVhPUzRUeDV0VGNGQ0YrZm1YdTFkdFBOMVFLQk1oVWR5QWlE?=
 =?utf-8?B?UWorNjh5VXkwdCt4WkswenZveUpub3BqajhldlBaOWhySE5GRzRHcDVIMGZZ?=
 =?utf-8?B?VUZaWStzQWwreXFLaE5xbGhKNXg2SHRNT2paRFZoQzZUMGQ3KzdMS01DYUwx?=
 =?utf-8?B?NEIrRVBLQmVYREo1SVJ3NnAxaFRxWE1jY0p2TzFwaDFNRWRUZzBtUT09?=
X-Exchange-RoutingPolicyChecked:
	EnK3IF/ufLZE180yP1tGb62/LGnCzun+dawiOMfEu4n6+o6CXLuuxLP8PhNN0220JmagTrdwSLpNb1uICYeHxmzZu7YMy7fD/PTTuhXH4AtK3NCcC/GQGW+0TdQ4l46+I7QKEBD+i8W4lC8+VFIXTp9Ph4KjH/HvcRHEUDdtmIWS/EWEyPbQNyZZ41RgWofFoqwfrAMJQ3oLXUCJF7+wpjlsMqSV8077KalZ3px8MO9qmZwxgjPmmtmy+jY1g92e8sFFy0ev6lI0Kc5GAk4vbF7eQukzg1L43SWBkPCCbWc1FvkFIDFQqiz01hXKZHi6p7+XwxE0DerLfFnLGIVP5w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s7Pl1X+/TZ7dv1Flou+84RkLlrBPgxzsPlhxAkskGduhcZdxozobK8c7sRAmizw/5aq0vT36JOt7mGSt/bCwGrcaxmAPKH2rPBJIHycxrekuBtf3EvOSrh7V5RgI+DfWCB1Vu/m3Vt8mEiDM+9VFW0imQ3dRnGZ9GYQLNffCFTRmAtenI+Ochf/U99dreP7qaeC+OshoLwF+sU9gm8NKpprcelJUSalLB+lzZLN/Zaagm61ZzCug0YKoXKyjxavER2iTskHXg3SpcBj8D2ck9O0MRW4OuhodX2IhJuZzyWsmQrooyKnI4c3Bd6tmb2s204313iDqswgtIoB1V86JkFOlrW8Tul92L9Qg6+0IeAjMQfxX+LC8EK0jvt9m15br7Vz3sq9fHfZ6Adv/COsb5Dh2eT4zz8MPlDENs83P7NhWKjG0N+/7w8VxNncVvM7CRuHQaSF1zHLMbq+3tx5S8gQv0hNq9qQV+1iK6vqowpXUuMwj9L5PbLh5tF2UP39Lql4RA3tRROWuoUKP7rBNumM9Vi2GAQJhD3uNGdy/8k3Yj4IClkC5Ms9qAXTugtYjJOFnL+gRfkiC54CNWeTPufRCE3sWOtNr9fZvvdqiLas=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 316b3fe5-a2e4-4935-5da2-08defcab8236
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB5506.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 22:04:28.8414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7MyVLn/0ZwFR6Wfb8wOWqqBVnNo9r0kxf82GMKb+oFCmmjPZoGq7HX7XaBDipksl8HbsAYsSQ3Sh/JzWMQ12ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR10MB997852
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608170168
X-Proofpoint-GUID: yOk41hG_hlkFUTL-nYlKWCHv-p1DVaWM
X-Authority-Analysis: v=2.4 cv=Hu9G3UTS c=1 sm=1 tr=0 ts=6a838570 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=JfrnYn6hAAAA:8 a=yDxSl-hJ56xZQzimD54A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE2OCBTYWx0ZWRfXyl4b6N7gJ9mL
 iw/2MaKrHUugxAZNXRSmYECVQ4Xn+4ctUxhrJtVUwhUBzQNCly9Ihd24fYz3oFeSWijnEuEssL5
 uu/E3iOwuNwAZtgqC+H7UcTTbOm4ReFHHJZhaIUPHAqrbyKo8+vO
X-Proofpoint-ORIG-GUID: yOk41hG_hlkFUTL-nYlKWCHv-p1DVaWM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE2OCBTYWx0ZWRfX0pf87Zpp3Tlu
 bCOffHCs3Jyzxftf9YI/ujokT3ANWQpTIvKs5KwQiGXMV6RToWfwmhaOtTTED5w05oJRqPRTCDB
 M5vA2yrN8FXk9jsPEHdv3EFOXj8+7HJ811l47dk8sUEmoMWFBY1AP+MIfO9ohKkKWonWlRRvvXK
 SiUUad1nLKfrp2o3ILJ9kMajR9blBrOOhFjts8NqHehaVYAwcPsQrHXP77K5nmTMXNoMX8arDiq
 pFNmO3kAdsZM/CyRfe3aqUcl6jf0TAQhNtxZ3E8vUcDC864MWoSCWdmNX+4dS1VwzumAZFYLKnn
 ua7b+FhRvgHOaGcPFnPj1VVgLycGk8aof8D4xYCAnZj0bTZlp+qcGQWmz43aCJ5FHye8pBlpecf
 0O1yn6yp0DS6yf0S8FSTFl+34//tvUcGhysZ1cy8aOUm8B4cmOVu8BKdwh0FNnIewo0r4H0iZ1z
 5mEn7a6agasXvc3lahQ==



On Mon, Aug 17, 2026 4:51:38AM -0700, David Woodhouse wrote:
> On Sat, 2026-08-15 at 22:33 -0700, Dongli Zhang wrote:
>> 3. Although David also suggested doing the same for Xen-on-KVM vCPUs, this
>> series does not reset last_steal for Xen vCPUs.
> 
> Hm, the more I look at this, the more I like the Xen-on-KVM approach of
> just letting userspace save/restore the values.
> 
> Migration Just Works™, as the runstate times are migrated along with
> the 'current' runstate being set to RUNSTATE_runnable, and the next
> catch-up attributes all the intervening time to steal time, correctly
> tracking the migration downtime.
> 
> For your vCPU hotplug case, a VMM hosting Xen guests can use the same
> API to set all the times to zero and the current runstate to
> RUNSTATE_offline.
> 
> Shouldn't we just add the same save/restore facility for the native KVM
> steal time too? It'd make live migration fully transparent, and a VMM
> could handle your vCPU hotplug case just the same way by setting it to
> zero (the ioctl would recapture last_steal on the current pid just like
> KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA does).

+1

I fully agree with this.

I agree that a save/restore for native KVM stealtime is the best approach so
far. Instead of only getting/setting last_steal, perhaps it should also include
the current vCPU kvm-clock value when the vCPU is preempted. In addition to live
migration and vCPU hotplug, I have recently identified more scenarios where
steal time can be problematic, which I can share in a separate thread.

That said, KVM steal time may need to be rearchitected.

However, I still think the current patchset is useful. It is small and can be
backported to stable kernels, where adding support for a new ioctl would not be
appropriate.

> 
> 
> On the *guest* side, is anything really needed once we fix the host not
> to expose nonsense values? You've given Marc the impression that we
> need guest-side changes to match the host-side changes in this thread,
> and that wasn't my understanding.
> 
> We *should* still fix the guests, of course, but I still prefer my
> approach to that, as discussed in 
> https://lore.kernel.org/all/f0535c47ea81a311efd5cade70543cdf7b25b15c.camel@infradead.org/


Regarding the guest side: yes, your approach avoids accounting an excessive
amount of steal time from bogus host values. But I still wonder whether it also
makes sense for the guest to reset its own baseline whenever it starts using the
feature.

For example, KVM paravirtualization initializes "kvm_sched_clock_offset" when
kvm-clock starts being used, and Xen paravirtualization uses
"xen_sched_clock_offset" for a similar purpose. So perhaps it is not a bad idea
to reset the baseline when enabling a paravirtual feature.

For x86 KVM steal time, that would mean resetting "rq->prev_steal_time" and
"rq->prev_steal_time_rq" before enabling MSR_KVM_STEAL_TIME.


Thank you very much!

Dongli Zhang
