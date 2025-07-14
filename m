Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32CE27470;
	Mon, 14 Jul 2025 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752511905; cv=fail; b=oGONNMf16GCG+u8ED7tstdmywCK1jI3mYoexcvzTyxZyvcEB5FFYe7M5At1xcnJLRJwyiH8tpyIn/fXdC1Plx6dFgXZD8PdYHHu/pndIsdXKYt/TUnkJWzFtStgGvT9NqjJ0BL0a28ZLR57PbcwZKPh7GZT5HgxHIAM4CEFjKEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752511905; c=relaxed/simple;
	bh=k40fKoscmSbwrRbNlySwzjvBzkhI7rnVHP+BqpOOvHM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G0iaTiMyGfkOD9wOo8io+URdzAcqRawbkc2fJo8Y7jRaRY7iNioZ0fENWbyC+GfzFRhdWhMS+HMIPLMWQ0p6BjOllq/w5yhEBVUJfUPm8JY7iKEspfPf93BJuY8u9fmJt/yDQuB8T+flSWeVPTl36+q/oAiL5tY+DXH4aLhp/Eg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n1RfoYwd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Lcf2bYFi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n1RfoYwd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Lcf2bYFi"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56E9Z6nY001418;
	Mon, 14 Jul 2025 16:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=l9seBB7Pa8Q2MZRyOJoe5F302n1BuLNuyqTr5h46w6E=; b=
	n1RfoYwdwAEv5JLo9wqhYhMwsE7p07VL2BS/zK6Chf+ZRe6bo6VsRA4briy7xIp0
	m7fTUXPLS0bJwiVo+zWIGkymzaacYlZOdH3cH4HbVZpDYdxck6YjzduGs9GhX2mS
	R1LN0WUACDybsrZ+A4lP4hiOpHF9UU0iEz4aBjBMfxJWYZZZLw+7WAbhV1m2HbRw
	5ge87qFW01h/Ey1DP0JQrCLWXBF2pnXkcJvZUlJr5soekm9YqUyhZLWTzoG1JDXx
	tqWgSE21v6w+WWmQaOQt4KM4CTreY6yfo5NrgyW8qdyzGAml6nMzLVGS0jRS7gOW
	SM/EYJLwlRPeVmH1pTZrIg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk8fvnyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 16:51:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGoQq2029669;
	Mon, 14 Jul 2025 16:51:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58hch2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 16:51:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eEuAP7CMux7VW95Y5gio3CkuLnm/NwRdEQOgLxpMA6REhSC5XLKk4K1dbX9VvaVGUxjXlkRHGdAiNisjlYcpwl4kMiKh5BEMrTDuXp3csO19AkrPQJ+7tHPBZx976IpT/Q7KbSqFcDTZ+seLblpt7UJ6TC8LqObcNVNoSKEn6Aji3/ILuignKGWE6ZlxeICrhuGsYxZZtJrdmbTz+kDAAcxrpIZjWUmjbevcy1fM9Ar94WrX5oc59ZcaOYWfQxYYQyM/WwcMj3J/IrcHYppxeH92A0QNXoF8Y78CTu7mHBrKZzdHLDOCvkrICZgmzJOrYBs/6P/cwMTSaYZUt1Wgsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9seBB7Pa8Q2MZRyOJoe5F302n1BuLNuyqTr5h46w6E=;
 b=D1NbsQGAZvOw5g2TsifQYxcv0wgwsqBR/LVKk1UpiiWsLSodrur1KPBz21JG1eNPxp+6aMDqcwfgUBpfRn2jpGKH4DFwUjlaofbHUF3C/rp2VbTUABK+cDkPvUk2TkWIIHUwCCraDTDrt5ydZWr2rk/nGoSng6pj8i1wSf54iomFOuRTyJH348Uf3htuETd87KXW8487anWWDDgR5D+pjKJ/pt7c5AxALCwYkKOIMtkIbsspcELwNPwFfJR0y/EJm+dyRQvU6ICn9Z1zu5AzbTYmf3/vnSYZAsNr901OCrYyWYWE4WEunHYVCIzGYNBzHnSOEoxjnIfSET9ZfNqdow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9seBB7Pa8Q2MZRyOJoe5F302n1BuLNuyqTr5h46w6E=;
 b=Lcf2bYFiK+0mXZ96/eAv47QxoXhBqWNPb+WDQUeqTkkoQdy7vfPMm41WuFXB0Kc4VpsVQYwC5Wx8cgw9q/MNhTN1GkbABS2G6uEdArLj10ySRMWww5063xDJ7ktmNDWMVubui6I1uE2YzVGXLgrFgI/3iiTvcLe8upXCgnh0Qcg=
Received: from IA1PR10MB7447.namprd10.prod.outlook.com (2603:10b6:208:44c::10)
 by SJ0PR10MB5632.namprd10.prod.outlook.com (2603:10b6:a03:3df::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Mon, 14 Jul
 2025 16:51:20 +0000
Received: from IA1PR10MB7447.namprd10.prod.outlook.com
 ([fe80::f2fe:d6c6:70c4:4572]) by IA1PR10MB7447.namprd10.prod.outlook.com
 ([fe80::f2fe:d6c6:70c4:4572%3]) with mapi id 15.20.8901.028; Mon, 14 Jul 2025
 16:51:20 +0000
Message-ID: <6f7b0581-e44b-4f07-bc7c-9d0a7c12140d@oracle.com>
Date: Mon, 14 Jul 2025 12:51:22 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: preserve pending during kvm_irqfd_deassign
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <1751467297-201441-1-git-send-email-steven.sistare@oracle.com>
 <aGVN8_hmeSKdHGfG@linux.dev>
Content-Language: en-US
From: Steven Sistare <steven.sistare@oracle.com>
In-Reply-To: <aGVN8_hmeSKdHGfG@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::30) To IA1PR10MB7447.namprd10.prod.outlook.com
 (2603:10b6:208:44c::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR10MB7447:EE_|SJ0PR10MB5632:EE_
X-MS-Office365-Filtering-Correlation-Id: f0a17ac3-6a22-49b4-03fb-08ddc2f6a874
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGJraHMyNno1WUZzQVlpRkZUZVhQbWlTR0hNZVIzU1F0Wk90aDFsQVdEK3N3?=
 =?utf-8?B?aFRCWTlkR21KdlVXeWxYSXJ0ZHUxN3FOKy9qb2JiSjdwVS9IeS9kT3FWVXBr?=
 =?utf-8?B?VUxHejZINENrTHFrUHFwcXB0T080MjhjQ3p4UWF4RHJOWCs0V2JraG1MMnJs?=
 =?utf-8?B?Vkpqd2ZTaUJjcDU5K2RYakE2OUd1T0N1QmtycWpJdGhPa0MreTF4WjF4Slps?=
 =?utf-8?B?cmpBV0k3RTBRTUxBWlp2ME1PMWZmWE9PSlhOMklFWUxZNjBXbTJNNGtmTnl3?=
 =?utf-8?B?Um9XTzBzMWZtcnBIQ2k2Tmo0MFdEWmhnQ2RJbk5QWFUwL293SzdUSHgxZDZG?=
 =?utf-8?B?OXBWWUFOVHM1b3g0QXpEMGxZdlFWN2I2Q0xpSTRrNU1OcHczNDRQejZvNmZ3?=
 =?utf-8?B?Y0VyUTRaY25iWHZGaHBkMDRSTzRpRjVpSVBEekJmVmxIYm1xSWVTWmdoUi9T?=
 =?utf-8?B?OEluVW05TGM3ckd1TERUdjR0bEdHTmhaWU1KZWg3dGM1QjlSYnpBZ2NsdjlU?=
 =?utf-8?B?VVd0NHUzOFJjVmc0UWF2SjdsMVJuLzRtZE1GcTRIYUl4SCtQRVJWVWU0NUZL?=
 =?utf-8?B?WU96bi9zdU05ckgyajBnTlRuM05iZ0JVOHVnai82UjQ3aXgwQVdEZ0lJT0RF?=
 =?utf-8?B?K2s5bzlPK0w4WlhROGh6SG1aVE15d2dPbHk2Q3RWb0lORjB1YkVkSzBoUDFH?=
 =?utf-8?B?bFQwUUlOcUN4RkQxNTZLNmFzdHBSaTE0M3ZxZXZzeGFZNXA1VWhqNWQ3VVhI?=
 =?utf-8?B?WS9DRkQ0azZ2UFlTd21ka0NnOXNpRDBaeFBHS0o0bFNFQmUwN2Z1NDFmYmJa?=
 =?utf-8?B?cnBJYkJKKzVmVXljd0d3V05jb2V1MEdQK3cvMnNqYzJsMEl4Zk8wdi9Yb0Qr?=
 =?utf-8?B?dWViWXk0QkNDaXVCd0NhMVpGRzQrTE9KZGo2RzJDcjErVldUdFhhejZSMnUx?=
 =?utf-8?B?OGJxKzlCQkFIVlcxQWlqN0xWUjkweFVDeElTZVlNK3hpMFgxaG8yZ0pYS3Q2?=
 =?utf-8?B?Mm1kWjAyWlFiMkZRaTZBM0Nkc2tpL0lYVjdMWEtmTGhIOUN2UEZXcWU1WmlU?=
 =?utf-8?B?SFR0a1ZwYTJWblc3NkE4Z0ZyTlJtRE9TSFVmK2lEaUdxaU1BK1F0RVNkV0NW?=
 =?utf-8?B?V1dKdGpTdnFSTXZ6aXZPMWxka3kwSDV3QUREUHA4WjQ0dncxMWtmVlVaVk9W?=
 =?utf-8?B?Rkl1RnpLdXR0S1E2VUxyUWVhYWUvS011K1NXMUlveTZlUC9kcHBYZEhwS0p1?=
 =?utf-8?B?bk0xK0dscUVlS2ZiTmFmQWNEL0xkeThUR3AzRlRYU0NyemdiK2tOMjNLOGhI?=
 =?utf-8?B?REJ6TTZwM1Z5aWJ0UjJucDJDeCtueEtuSi80MW1vNEJYOEx6YythTDFVRG03?=
 =?utf-8?B?UldWNW1aVC9aMHRCK3lOcjREbFZaTzJlQk5UUFVlNVpCZDM1ekRHMWRYZm90?=
 =?utf-8?B?aXBMVXQzaFFPY2N3cEZsVFp3aG43YVdBWnp0UmlCaDdPcnRyaUlDQktZUElh?=
 =?utf-8?B?TGMxV3JmaVJZTmtBV0VRaFRVSmo0dWF5Yzk2Q1ZmZGs3bE11K0IwUmRJZ1ls?=
 =?utf-8?B?K0FBRWQvV3Vvb2RDSHpFNUkreE1uVm9QZUtIcGVMR1QrU3paSEdUU01kWllk?=
 =?utf-8?B?TXlxUTJQVnh2R3kzMGRoMWlSVG92UDlaVGJCWUJEbnlFOXFhVE54K0ZTVUhl?=
 =?utf-8?B?LzVaVCtEQUFETWxvOC9TcWFmY3ZQOHdiOExPdUR1MnR5YUtPUWlNenNuSWYr?=
 =?utf-8?B?VVIxZGQxOWtGbzA3bmhjbmp1QzJwWlJaYTYwODdOcWV2UExoMWJ2TllrSEdC?=
 =?utf-8?B?WnFyNTF1bW81T2JsZ1NhYnpmQ0ZBMHZjQW1XSExFNEhSZW81N3RvL3pBd1c1?=
 =?utf-8?B?bDZxM2piL2x0WlRZS0hrTVBSSHNjdk56SXJRQ3IybVVLT0d3THdpWXNPVlBm?=
 =?utf-8?Q?XF2wePyZzIM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB7447.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHRHTW5PVGlldW5TY3JNUDBMREhLS2RON3VmSFZwa2lvSFM2YzlrRHppVmYv?=
 =?utf-8?B?UFVpdDN5TFFydmw4N3pYMnNhcWhOUjhDNkhFTEtNa2daV3d5N0tuc05DVGo2?=
 =?utf-8?B?ekYzcmk4YjF6N1krc3ExVHZkL1FpWEg2bStodUMwajRyUWFVYk9Pa3ZPbnpH?=
 =?utf-8?B?UVhIZWhESGYxUmJGUVBsOUVQSy9tSlBNYnp6TXRvc0I5UFdvT3JIYlhza2cr?=
 =?utf-8?B?aUR3dlFHbmFSL0EyL2pDMlV0Z21qNTRlSE9nZWNhblRxb2pKcFV1eG5xb3dL?=
 =?utf-8?B?eW9oTnUzbW80WUx5RkRFTnlWY2JqVjZ0TnlLbTdONEd6NzYzRFIyT1dwaGJa?=
 =?utf-8?B?ZG9FcDdBWStzUEhOZGJ4UHlzamh2MkFLSitCbFVLL3VPUDl4WWxQcXgvVnNw?=
 =?utf-8?B?bWEwSDk4NUpLaVFtdzNRMnBZcVRjeEU3czVhb3hLK1FqUFM0eEVIWm1udk5M?=
 =?utf-8?B?d2FYQkprN3BDRWI3S1JPbkRHZmVyM21pQnFxRkx5K3NIMjRvR1czYjRMYkpz?=
 =?utf-8?B?aEoxeXEzUjU3MFk3V0R2K0FHOU5FaXdLSzNaN1NocTUrbklZWlhzcGRMOXZS?=
 =?utf-8?B?WThDbFpqRkdRSUxTc0xxaWI4TXZiVEtodk53Y0p4bmhHeDNkRm5GMHd1THhZ?=
 =?utf-8?B?L1Y5MW82WHErL1RhdVZ6TU9WcWxVU1hKb2tqcGdhSHFhclJNSys1ZmJKN1ZP?=
 =?utf-8?B?MDNoRmg5cDRjKzRsS0wxTkpyMncyR2dtZlF2S0IvRTRrZnFDT3FCYU5PTFNi?=
 =?utf-8?B?V29XZFd0YkptVVk0UzZyWGlIQUNlRkdxRkFnNGtMckhDS1R4RmpQcTV6TE1j?=
 =?utf-8?B?MlViNm8rTDV0NDdUUzJPb1BkMzB0d2JUN1NBQlM0aFNCSE5lQThUVDMrWm9P?=
 =?utf-8?B?TUZjWkQrQkN5UlpZWFcvYXJxNlZnUFV1WUQ4SlF4RnBpazRFeUNzci90aWd1?=
 =?utf-8?B?RjdqazRVUzJ4YjBEc2JYR09CMUdWR0NxNkQwdFFucWg0TVZkSEEvODlZQmhj?=
 =?utf-8?B?RkRvaCtWd3VsdEJXVmMrT2dTbmxDeG8yeXZyREZkM0haa25FK0ZZU2UvZ1Vn?=
 =?utf-8?B?UFNjcnZyRWJ5MTh3bCtJRVBXS1hML2x2T2huNSszaFkyKzdEdjNkV1o4R3lE?=
 =?utf-8?B?TjlNcVFvc3pRU3RFS0RhaUxlcUg4TDFidlBMK1hRSS9HZW92SGNXYU1IT3N2?=
 =?utf-8?B?bXB5aGdDcDFDUUVEQ2pzT2NWblJqRTZidDF4TnhyMXNXYnFISHBBVkZIMkYy?=
 =?utf-8?B?UVlwdXAyQ0J2MGR5aGpJMTFCTUR6YWVxQ1BYOWFVL0I5Z2RhSi9hRjdpbkkw?=
 =?utf-8?B?ZS9oWm9MclhsMXRuTytKNzc2Nks3azcwanM2cFhaU1ZLQVFwb2RmSzVFQUZC?=
 =?utf-8?B?YVN0blMxdDNRbnBDcjAxeXloWms1SzZJUCttL1RlSkVOZXN1ajRtQ0g0dGxV?=
 =?utf-8?B?V2JZVmkwRnNRdzZuWDVHK1FPSFNiOFUrRVI3S1k5YVdEWDJ2MzByeU5xTEpZ?=
 =?utf-8?B?TnpNWWlWVDFSRmh0TUszdHIxY2Q1REY4TVVVazRCUkE1Ukw5c2dVUnVMZVE4?=
 =?utf-8?B?VkdZVzRMMXI1N3J3aWV2K2NPVXNCdnpEN0ZQM3luUTV5K0llbjRMcHFNNFNl?=
 =?utf-8?B?STRmdU94ZVRFV2hsbjVnVXd5ZnI1VEdHdXh1UVc2ajVYc2FJYVZaZGRXUVFj?=
 =?utf-8?B?NStMNCtwbHdkN0dxT1drN1ViT1c3aDhIc3o2RDlZdUFjYlJ6UTIzaHN6T1Fx?=
 =?utf-8?B?MXM3RmRJdWtTSXVjdlZxUFBwODEybWFva1F4TXduWXBzYWo2Y0M3UVhYaEp0?=
 =?utf-8?B?NnlJYUwxVXN0dnVYWERGUU1MZG9xWjdRbjMvRVF6L0FaU1d6UEJrUG5GNWhW?=
 =?utf-8?B?SkROTk5sN3J0NDd5MCtEbkFUQzZVNThuUExRZWJwa1Rqd3dRQU5ZYUFuZGk5?=
 =?utf-8?B?VkNUN210b2VmekFvNUhvS2ZVcTd6bWpNSmtESVZobHozbUhGc3pvVzhzRC9s?=
 =?utf-8?B?UFo1NEorQ2FmcW9XMTNWd0xvSnFLd0ZmTUpQVmVvNTlCNkRqNnJMaWFaZ1g5?=
 =?utf-8?B?MjlhVDU5UWFxclFZN1B6aVB5UkE0YnlyUnlWOUlNUlkwK2J0eHQ3cE5wbU5Y?=
 =?utf-8?B?S2NxRzRzT0VETjl1L0ovTXBEaU01WEFzRGdaYkJYaFUwdGVrWVJ2YXpzWFI3?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tP4eC2a41Ttwbt+nFXNFgRCNNC9IpoS+ZRHKjofPDYORqBZQ/g5U08JPTL86Po7ogVLnSuvJLqGqhO17ixD0OzTo4K7rAxI9BcBadP24WTkRGDq1mfMayBqDnc69RfHer7v/QInVV6QYYTG9vaAhqPYUsnz3QYXZ5LLSAsHah2s++NaYYqFuXYMSp0/YpzBzbTHFrXPjmrlSFfoyvbFOJDmFwmaVFtrqUiPuYvhVeheVV0rtdzf2JCqQRaClHPnlmV3p9cs0XqmNYdVB6sxU2nRh3LyRmuLw8NUz3yf4hs5BhFo/dEB/G19MiOqQ4phEI3RSOYsHwDTDQ09pwt353Kv6oN5ABUPYXJwE3nL1F+ohW1/4Hj//9Gy7jVywn/2us9XA/OxEXkt8ZCVDuMtY3BZXedfE2OKGS/et2tXe5TGPCiqz3JnD/uCWq/AWBJyfdsvw/yi5XXR6g06gESXhZSMAKcgaIIe4eH7Eyut87HlTC3r31ZBGnc9wBfu+6JkdFbZuq70jNsDNUDA+oACibtdwI76+hJZa4i/FWZzlC+0pSOgQqBTSnXXMyDfVktO9USK7THZHUNYPN6zT/pVCyn9GBS2te/l8Lbm5koqJDTw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a17ac3-6a22-49b4-03fb-08ddc2f6a874
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB7447.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 16:51:20.3371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0FD1OaMqKy8KpANRbLL52VzI5ZYp1aiJGDYqpOxJ+hODTCdzmEE3YgVSLlrVr9SumF2Fo0k5GlCX8/AGur+d2AHjgCI7NfYxKtwE/ozoQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5632
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140104
X-Proofpoint-ORIG-GUID: LLv66cv_FE7y2uBJj5dg20ng_M4xVVxa
X-Authority-Analysis: v=2.4 cv=Of+YDgTY c=1 sm=1 tr=0 ts=68753592 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=Je24I9W20XTlM0MTOr0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: LLv66cv_FE7y2uBJj5dg20ng_M4xVVxa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDEwNCBTYWx0ZWRfX6upKue2nu+vx i/oBTP/RH5FX6+wkPWCOZ1It0avf4uMpCzfo90h4OxofQbE9C6mBiXvD7AhnYLNmFrajB0rDwLP l3G+yE50vCUtphaZ8dNTqvBaUfZkEfxS/fKPM3LmFDsh0bz3mZ72sKNhzVsDDL/TTeZvc3WjGbk
 7Shuvi0carTRI0dLrT9Ykk0+/zyVlRlGgwiSjUo/PWq4MRYoHA/o6u1izhA1kTRml1n79dH5HzF kctqSRBe2PKb1tPRvkWztU/FFHvMq30uiiUsM3ve5JzBQtJcFrIaSq3hXvMDNsB21yBQOnYN+vl EDauatacCFQ0JoV2uPSRb5pTm7f3RXJjzqDk4dx6uemqYiie3vSvWy8p9MFVQ8mxmCd54qcUxiG
 6Z/6Rn9NgFPrPO+/kYOLn2b4F/vnxFvZCfH+k2sMX4eIqTd6znFCWc9OUxQ0ATeLiuwQeKWd

On 7/2/2025 11:19 AM, Oliver Upton wrote:
> On Wed, Jul 02, 2025 at 07:41:37AM -0700, Steve Sistare wrote:
>> When kvm_irqfd_deassign ... -> kvm_vgic_v4_unset_forwarding is called,
>> if an interrupt is pending in irq->pending_latch, then transfer it to
>> the producer's eventfd.  This way, if the KVM instance is subsequently
>> destroyed, the interrupt is preserved in producer state.  If the irqfd
>> is re-created in a new KVM instance, kvm_irqfd_assign finds the producer,
>> polls the eventfd, finds the interrupt, and injects it into KVM.
>>
>> QEMU live update does that: it passes the VFIO device descriptors to the
>> new process, but destroys and recreates the KVM instance, without
>> quiescing VFIO interrupts.
> 
> This *does not work*. Updates to the ITS mapping are non-atomic and a
> poorly timed MSI will get dropped on the floor. Or generate an SError if
> your system implementer has a sense of humor.
> 
> KVM already provides the SAVE_PENDING_TABLES ioctl for saving the
> pending state of LPIs to memory which also retrieves the pending state
> of vLPIs from hardware. The expectation for this ioctl is that userspace
> has already quiesced the interrupt generator.

Thank you Oliver for reviewing this and suggesting SAVE_PENDING_TABLES.
I have added it to the QEMU live update sequence, after calling
kvm_irqfd_deassign, and it does the trick.

- Steve

> If userspace can't honor that I don't see a reason for KVM to go out of
> the way to forward the pending state, especially considering the fact
> that the architecture doesn't support this behavior.
> 
> A spurious interrupt doesn't seem that bad here.
> 
>> -int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
>> +int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq, bool *pending)
>>   {
>>   	struct vgic_irq *irq;
>>   	unsigned long flags;
>>   	int ret = 0;
>> +	bool direct_msi = vgic_supports_direct_msis(kvm);
>>   
>> -	if (!vgic_supports_direct_msis(kvm))
>> +	if (!pending && !direct_msi)
>>   		return 0;
> 
> You've broken the early return in case hardware doesn't support GICv4...
> 
>>   	irq = __vgic_host_irq_get_vlpi(kvm, host_irq);
>> @@ -542,7 +543,13 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
>>   
>>   	raw_spin_lock_irqsave(&irq->irq_lock, flags);
>>   	WARN_ON(irq->hw && irq->host_irq != host_irq);
>> -	if (irq->hw) {
>> +
>> +	if (pending) {
>> +		*pending = irq->pending_latch;
>> +		irq->pending_latch = false;
>> +	}
>> +
> 
> So this "works" for software-injected LPIs (notice that this function is
> for handling *vLPIs*) as KVM's pending state is always the source of
> truth. Is that why you're allowing GICv3 to get here now?
> 
> This (importantly) doesn't work for hardware vLPIs, as the pending state
> is maintained in the vLPI pending table for the vPE.
> 
> Overall, I'm not convinced KVM needs to do anything here. We have state
> save/restore mechanisms readily available, if userspace wants to go
> off-label then it's up to userspace to figure that out.
> 
> Thanks,
> Oliver

