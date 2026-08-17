Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A666E233944;
	Mon, 17 Aug 2026 20:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786998106; cv=fail; b=dRgG1ZG5LZCAPsTzKnacHEmMXGnY6ZqBiZmscXztM5ag7yCEtCG1+l+ThJfFJHZ85bKAUdL4YNBtIUtXRM+szDA6fzWQfIHOhxnrQFmmuvKEMFyxDDMADsG6nppdDq9sAFft/M8nwRaJ4Vyvvf3kGrHpO6Vm+aQaFzlTEMGCOhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786998106; c=relaxed/simple;
	bh=y1TNnsqri+/7+/eZTi4dyVEQx7aXMCqMk/B1bN9Fb/Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 MIME-Version:Content-Type; b=T9tVEtlAHyICgA88UCe+TkAbBxgDfxpsWzZT6wak8j42pYJmPY/zrWAeyIMrAjXxxDTfoCVnqqbb2LG2Wy1ptF97dRQKM55rHd6LWz/zdL+WyedZSNfke5G1Zd3oSwV7Etvn2DZNPrwU84v9N8+AQUbRZsW3iJiqEWxJJJ+EJpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bvspKzHB; dkim=fail (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=skQ5mObt reason="signature verification failed"; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bvspKzHB";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="skQ5mObt"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HFe6As2038427;
	Mon, 17 Aug 2026 20:21:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aPs0cU/GaOhrarQJKg9SdpPEo9Zj2NQ8lAxou6O5dtw=; b=
	bvspKzHBmFbQTfO8vrcz0qZwPBDSefHn8g/5TxLKAqiCmN+bLYmYG3vt89mvo+8L
	3i7GodUTUYNkDzdk/X23abqmhEJ6fCsGwgBfVXIzc4oCFOiOO71QFcOeV/TbdOKX
	9tRnCIvA6b+o0B3FpcNnmHlxzZ6hGTFxIqC9CiVMLjfn8/kJEqmu/cQBB0BHaoK6
	/OxkgqmuHm/spzvY7Yq3JAvbXBV0xuq0w3Z7Drh7SiS9Ovvu+o82sYgaMtWTHoVD
	FHq/Esk+wybfxcHfjRgkYmZ2PQ4Cs3HRtOfzc7AY8kychTV1mFBvtrzA+UW3lCEW
	rxpH2NS2EJ2ON67taRZcBg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2g5cb3jj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 20:21:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67HKFfxZ038832;
	Mon, 17 Aug 2026 20:21:41 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011047.outbound.protection.outlook.com [40.93.194.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejpuks6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 20:21:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZQpvv/Pfd1IJ5lzl/M7KFscH1u5a9TKIX3CQisxLRzUTzykBHcLBeL7RcjCzbXxFkXL4kIR2AZ+cDbZK+B+875AnJz8+o7Z5Z5HTfNM2d5j5gepTQgjzMEL9bVL9OhAjfv6OmwlNYBoPRgUVGbhA7Fg9HWGAcBpYAcrBDdCI9biJW3opEc6rVSVn+fUNtGYqj9j5Y7ksgYwtDTH+O93gU4blefvA5X38V/gLykc83qYuESIgBmlhROP/SMHe4GiaBWWFYPPpwHHPuvO5jnUdo74c04X0/rBKb4CbcsVk+7WpAoVXcHmSovy1LC3aaCo0Rkp5vULmWI+87GZCk1wOAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8oBrcZvLqiZlmIWdDqjcyD9E31yMfPnVAW11c5cJTA=;
 b=ITX7Q3Ly0mxWFDK9CiUHYG0cZLLeGvcBsRTybvUPo9zepkoWJQp5A7Qi4tdONTbFeThhlwr7gCJbMAWRzKwhfZcpi9vggffQkE3N4uS4sTjqSZpmRFCbNXdPs483QMFy7kw5BgSSax7KyiF1MSkqhUmCH9VC6cDkYSSwSn8Fc64ezf1jrm3+LbVlB33dtfK6PTqClPR2A5QWdD4/PWeyoJjC4FE4evXkbIjS9McAk/IANPKiQvWsMU/KUqtqdW5yROcdU6UuHwVcGQM1RW0pKpYbULK5fMMDrG8lBOma61JJffopV6d8431uUpu/YrDlHsutxICSdwSDH6VYNP4ccQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8oBrcZvLqiZlmIWdDqjcyD9E31yMfPnVAW11c5cJTA=;
 b=skQ5mObt8lxhaArE1d+AqyQQI2PKKjJYzeygzVnyMGLLztczWKwkNKzogYD2tx9hdcM+vOEkAtAWZIW9cbuHCq2QL1BZDYBLANUOIoi2Pn3qFIfIuDlij1je9VQn2zlq9kPomhIQZwRG2FTNTLtvIG5wsWbombmx98xVl//HXD8=
Received: from CO1PR10MB5506.namprd10.prod.outlook.com (2603:10b6:303:161::7)
 by LV3PR10MB8179.namprd10.prod.outlook.com (2603:10b6:408:28a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 20:21:38 +0000
Received: from CO1PR10MB5506.namprd10.prod.outlook.com
 ([fe80::da72:a0a9:5f18:cda4]) by CO1PR10MB5506.namprd10.prod.outlook.com
 ([fe80::da72:a0a9:5f18:cda4%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 20:21:37 +0000
Message-ID: <427a5d9c-7641-48c5-8a51-2f78688de4f0@oracle.com>
Date: Mon, 17 Aug 2026 13:21:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] KVM: x86: Reset last_steal on vCPU pid change
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20260816053630.527528-1-dongli.zhang@oracle.com>
 <20260816053630.527528-2-dongli.zhang@oracle.com>
 <20260816055525.A41D61F000E9@smtp.kernel.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20260816055525.A41D61F000E9@smtp.kernel.org>
X-ClientProxiedBy: PH7P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:32a::35) To CO1PR10MB5506.namprd10.prod.outlook.com
 (2603:10b6:303:161::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB5506:EE_|LV3PR10MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: c4fcd485-06ff-4b3b-a5e3-08defc9d23fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|22082099003|18002099003|56012099006|4133799003|6133799003|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	UoxcdSxPnguGia5nBPgrnefHI+5CEH7EhyGD76vGhFUJbMob7XD2u7pyVM8MXshsig1BsSOLIiIk3GQABnvPxX182/g7LGzcrt3wTD7r0goozP5rqfFETCXqjmIKSPB6AH2APJz9XSHCjybh+EvCsMQOF6s+iutzMJueP8YoXnM846KtmF9fwFLegHHAfWUK1EbzM7vu4GgV7flk8GI7CL2BqssY2e6MWaHmCbQyzlm7Bn74xkRGvS1P6twqpehGlyJj0J1Ho179XUNFOtod4djO1PEXdKaZjSBRQKm36OuSdQjrTG4DOXoiuyuGAP1YVjgyvYAIeF4UJgYBlw1IMGAYCrCTewort7cpWDDwr6XRhcs6r+ek38ylYG1gtIit6LaarNfKasUEnP3xOCpPwSQcTI/ED42s1Jp3Rr0oAc+9hAJRyuMMdihqGbNxwl61enBy277BL60ah+v+vEOtS1SG7HJrK6vJZMABVqL5vfK3C95b35g2ijSEn6lRoP1zMtfC+ONHUvQ9JKaQnOw33XcqUcMeLg4WmSz1yWDEkXZBHS9BirsqeJg0xz7dz+zZcphS2kd9uyU/nO6O63mAXNO3yJu5ohYglje/NYgGj8f796XKvxY3hoNBXVat+1oJY7T701WTHesXNcRIJD9wCED212wMlB03/dk5yJ/421U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB5506.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(4133799003)(6133799003)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2dKc2xra0I2ZkNiY1V2cXJNWVYxcklkZ1dZQVdheEZJUVY5RllXMm4rRnZU?=
 =?utf-8?B?ODdtL0k5Q25vRDRZenNYcTg1dTFuVEtCMDFYNkFoRVQreUZxMzluQVJMTGZv?=
 =?utf-8?B?enVGOXI4OEVkZjFOaUZrVkwyUTRPWUtsUFRYclZDS3ZpeHhLMmFwbDRNQmJV?=
 =?utf-8?B?eG1uRXhuU2JHTFlqRS82ZWk1Umt0QTZrY0MrOStZQkYrSXNmYjkyY1dheUsx?=
 =?utf-8?B?ZWxpV0tZNVVzZ0lSMzVuUEg5Uk5PRnRuaUFoZHVENWF4clMrOHhpcWtvZHE1?=
 =?utf-8?B?SGxITjRrYkhFbE9jOFFjb0xweklYY1Fyc3pjWWdPdmZzT2lUc1l1MVFvRnNG?=
 =?utf-8?B?VnNoSWlNWS9PMjR3Z2pveEdKY2F4UDlDeGxBNTJEVHJOVVZ3anFIZGttVHRo?=
 =?utf-8?B?V3UrNW9Gc1FmTmVCZXpvNDdheXVBazFDczZBVm9IZ054UlRnek9nS2c4VUxH?=
 =?utf-8?B?dDR3MnR1SWo1OFkxOEVrZlhZd3M3c0kxVVJrWlhPbnlwQmVGUitJOHdyaTlJ?=
 =?utf-8?B?bE9UTDZhK2xIWmhEV0pMWGxSR3FtRGZzSCtxaS9wZVI0aFgyR09UNEZlOWtI?=
 =?utf-8?B?Y2NXZ0NoRjJPMTJlei9GYnNDOVdGSjBjYU16anI3Z2FTMmVyWWtndVJNR1Ns?=
 =?utf-8?B?WVB2QmM4YzRQOG1aaURrMm5IT1FqaUZFakZCSlpuREY0YnJ0UWx1Qno0Tmt5?=
 =?utf-8?B?S2MrVzgvdDJjUk9rSTB1cnRDSnRDV0tTWlkyZUJGbGZKaVVVZWJJL1dVR1Zm?=
 =?utf-8?B?U09VZnJYMHp6OUxqbmJFNEhhM1FyVWN4Y2Z4UVFnUWg4eURONW1vcE42RjhI?=
 =?utf-8?B?NG1nVEFqa1Y1ODdsTjBYNmtRK0xGb1lKZHpPZEErYmsvdDZ0enE3VkowVElk?=
 =?utf-8?B?OElnVyt6WFdMMDhoZkRFbjlaRGdpWjRmZDM2UWxUdGRWek80c0RRUkRleFA4?=
 =?utf-8?B?THpPenExT1Vic3huell4bnNpU0JqQTRLTmFjOUVJTGszaDIvNS95UjF3WDFU?=
 =?utf-8?B?bVZQQ2ZqdGl3YWM5czdVVnp3azRXQTdldEVidVJPOFBYejRrQWFJSDBoNk52?=
 =?utf-8?B?dzQ3TFltV29KUlRPRmJNSUllZGRHa0dFem04UVVETTJNVGczQWJkUmVGUmYy?=
 =?utf-8?B?cEtWVDVjQ1lCU0Y5dkcwYmxocGM5UjdrUXhyODYrWWdnOFhsMGVBMm1GS1lS?=
 =?utf-8?B?TlpsY09hRTJ6dkxWOFpaS3c0bXBIWHlvSWh5b1VneGdLeXN5Y3Mva2wrV3Nu?=
 =?utf-8?B?d3NCc1NsTDhwSzZmaE15elhibGFMV2FXM0RHNVVNWml4ZEFqZVp0VER4Qk54?=
 =?utf-8?B?Y3B0bUp3VWhJcWNNZVltNmdzeWxaUTUyTGdqMHRHdmc3Z0J3RForNDd1KzZK?=
 =?utf-8?B?VkZLK0dSQ3kwUGNtR0QzSU1oREpDcXpsRisyamZrU0I1WG9ad05ML0ZEV0Yw?=
 =?utf-8?B?N2NaNHVDSmRQSTZqaXMreWI1cUR2U3cvQnFvZ2tFTG5IdXRLM1QreTZoRTI2?=
 =?utf-8?B?dGZtNXBOc1JDbTFDb1BjODVWYkJ0SmQxeTFNWTlzVXdOODY4S1dVVGJGWWFo?=
 =?utf-8?B?dkNhUDBtb2QyL0dBRzRKS0NSZTI1TUVMeWhUanMvOXpPeWJqOHR1eFN0SnQw?=
 =?utf-8?B?ZThrR0VhNXlJbXJXOFZjL2kzdi9pRmNFdzkzM2Z1YjlPc1hFOUEzaXhXS0NU?=
 =?utf-8?B?YXpCWUNuTmVhVVNCR2djS25tRlVEeDFvaHpVc1c1akRrcjV6eENEZng1RmZz?=
 =?utf-8?B?UHkvT3lyOGE0WHMwVlNaeTcraDJWRVA5bHVZUFhrK2pyWGZXRUxyWWpka0hO?=
 =?utf-8?B?cFhXNW1QSlZ1c0c3T0JwWFUvdHRCVzhyR2JldzBobUdMTVUwSXhFRThMQ1M1?=
 =?utf-8?B?Y0FwNzBERHdybEZWRHZFWmZRQTF2ekl3OGd5V1B3MWJoZTB4RW1lOWJKQzFC?=
 =?utf-8?B?ZlZaWGEvUThTRGZsMTlBdklneVVRSGRzTmlCRkNyYTJxL1lkQWlYeEtEZmJ6?=
 =?utf-8?B?MXBaVksrV05zZkxXZ1NYRnZ6eXZVSDFYeUY1eG51dHh5MEsvVWM5d1BwMllq?=
 =?utf-8?B?Z28zS05FdWpsTmR0S213NWVoNEEwalYxdExYRHhXSzZ0cDRNSmlCRHVhM1Iw?=
 =?utf-8?B?cjZESnljRjRnREY2L0ZsaDY1SXlxalVvSDRZRDNKclBXRTFMenA1OHpSRVpr?=
 =?utf-8?B?TWVydDNVSjVWQkxESjk2YUIrVzIrZWZWdXhGcnVnSEd5Z2I5dzEwZ3VSZG9u?=
 =?utf-8?B?SGVOV3B6ZkNadkVsdVdkNUZrbXR5VjU1Z0lyYUlmSFhWMHBTc1JDdFlIRzFv?=
 =?utf-8?B?d0lYd1lJMTBSaWM1ZUFTRmszTkVRSHRPK0x6RHZuUjcrbkVxZm5Tdz09?=
X-Exchange-RoutingPolicyChecked:
	G68FlZQL7DL0YF5GYbbLXRR/EqMd6L4fUQ57JCLCh4D1VzQyHw7JHKm9a1XZia6ZLQ5/NW6o4vXPmYZfmiW8Pv1Hy+0J4hWs9cEbEMPVYmqi46MZCfaRubtZHmkLBApBUBwday949sMaWZHc4QZiqqtFCMZcwaSBgY373gEiUkmuZNhltXIsVl7GWRSG2Ol4gbkIgxRASAQNKszQEpznj4yoPaixqLc/kn9GWegTyvLVOwcclarsGTZHCSUqfs83Bgc24KXGyM6z6NpQdDQUlJ75qUIxQGYtX6tSmrnn2I788wupv3K6runEsuhdF0nV0pTxHEzne9H67b4CKdDaDw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z/5FiHrHt8giXymRzV06ydkd6d53ReGjWeX82uU4pVfamjh5T+vqzWIjEoJwIbCUheUI9qZsjIfroC3f31kpQnoQviiyKK72C9r8m36xjaqPZgqMQ8N6AivVkPTz1iBUhBLAiXVJbKIOIR6HejoxBDCHDZjzvd9+t+ul4yD7cdAxwNT4CmqLqhH7Qx7gJcl/8bK5aZplq1GNRkquMytaKLUMxKh13wgcNDWObcbJSiwkqgvbqx29bpyyCu9AaehQdbIYpuzRbUeBeALGGo83n/8T7JteGapMECWuSwzjo+WzN6SFIj7olo8Y/FkJS/V47W0BmHQLdG0MFuFxGzZkM8UOb6vnoQEqKi5ndqLBqcB8MUe6OpCt59WXr31sf/IcUEaTWCq6lBpz/JwNLGjIeGXBNG3gutL+lNskEb5AyYrKSOY7vD2AJBSIW3hV7/AffGBwOl7EE1CdgRPSSLLZmjhUJOlE4yx3mtXZisZMawBGIcE6Oq3AlK83SF5egU9ugLzRKJrjTIcy83IZsTm84K5Vphdi96rcRlIzCKtwS/wAanccRXnruUmlpuolLXaCoQEyNq2Vre/e4rx1GHMgM9IXNQntjtg0ppup7iM/YNg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4fcd485-06ff-4b3b-a5e3-08defc9d23fb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB5506.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 20:21:37.9126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PUHoKFli1m33kXkND0VceO9gpvJillfCmpvmPO47V7z+a/Uv/J37pALvS9xSrufQxuS4TkgFK16FERauPqwbtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_03,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608170155
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=INoyzAvG c=1 sm=1 tr=0 ts=6a836d55 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=RpNjiQI2AAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=7zmLKWujpiwBXzZTv4YA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12098
X-Proofpoint-GUID: ERLOP2jP2Yb6UqyWesZ5c1qYlb2HyXDS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE1NSBTYWx0ZWRfX3OhOzs8FN2Hf
 /oPC3uS2Yxt2/0su9yLiRv7yXy/RzPpy0PBmtpP/AqSiYmPU9NPT4TTn+E8vIuzGlW9tWpX9ckH
 pA9b6uk5a3960Q6Xj8rsUgiZoP+CwRdj8WwIv8ThBvrS/nRgvWA75k5hvSxLZGTu4HZ59ynTQ7R
 /9LeY/2XaWUOdfcoQIipVX7mIkLaspr8PJRulAbXE5J8TS8zbp1gxsABlQXsuvnvvuY6XPrppf3
 /PF/HAk2nraAPhAmuawnWpzKMD1DUNk+dXs0NESkV3xwFBI2giIREyZYwIgVuc7bqIEkGIRbguU
 Lk5f9ELzWKvWcaQS7g2Tj5vyoR/qcNwBm4RjbdhFFhj2hhAm466hda3ocYl+NfD857lWrgTrpVw
 JgZu/9FOJszYfLcKXv8/WSxfhiHN1nt+5oo0wuZ3ZcFtdkwQnkwZiade9gl9mB4hUtlZW807C/M
 teNj+O4CAImL18ggFNzL9LDCgkBvtNpguvKmdQX8=
X-Proofpoint-ORIG-GUID: ERLOP2jP2Yb6UqyWesZ5c1qYlb2HyXDS
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE1NSBTYWx0ZWRfX3NfvwqckIChf
 Rd9QQKyZAfjXUQxinzKJVuoi4kT9myfStK+jdJKahuAxWqEgjWd8PKBEzQEEIk7hhluvXuF/ehI
 +Q2ln60ZYutrFFlD6RA7wDP+tLZwH9ED0c1vHf4rp1P95YUsqQOJ



On Sat, Aug 15, 2026 10:55:25PM -0700, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to
> consider: Pre-existing issues: - [High] The patch addresses the steal time
> corruption on vCPU PID change for x86 KVM PV but completely misses the
> equivalent KVM
>=20
>=20
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>=20
> Pre-existing issues:
> - [High] The patch addresses the steal time corruption on vCPU PID change=
 for x86 KVM PV but completely misses the equivalent KVM Xen steal time (`v=
cpu->arch.xen.last_steal`), leaving it exposed to the identical integer und=
erflow.
> - [High] The identical vCPU thread migration bug exists in ARM64, RISC-V,=
 and LoongArch steal time accounting, but the patch only implements the fix=
 for x86.
> --
>=20
> --- Patch [1]: [PATCH 1/4] KVM: x86: Reset last_steal on vCPU pid change =
---
> commit d7367ba78784ba11d9b540abce98359a8e902828
> Author: Dongli Zhang <dongli.zhang@oracle.com>
>=20
> KVM: x86: Reset last_steal on vCPU pid change
>=20
> KVM does not reset last_steal on vCPU re-creation/hotplug, causing a bogus
> large steal time due to run_delay starting from zero. This patch fixes it=
 by
> resetting vcpu->arch.st.last_steal in kvm_arch_vcpu_run_pid_change on x86.
>=20
>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>> index 801bf9e520db3..b7cb2ceda6d9a 100644
>> --- a/arch/x86/kvm/Kconfig
>> +++ b/arch/x86/kvm/Kconfig
>> @@ -40,6 +40,7 @@ config KVM_X86
>>  	select HAVE_KVM_MSI
>>  	select HAVE_KVM_CPU_RELAX_INTERCEPT
>>  	select HAVE_KVM_NO_POLL
>> +	select HAVE_KVM_VCPU_RUN_PID_CHANGE
>=20
> [Severity: High]
> This is a pre-existing issue, but does this same integer underflow bug ex=
ist
> on other architectures?
>=20
> Looking at ARM64, RISC-V, and LoongArch, they all track steal time using
> current->sched_info.run_delay and subtract the old last_steal value, which
> appears identically vulnerable to underflow on vCPU thread recreation.
>=20
> For example, on ARM64:
>=20
> arch/arm64/kvm/pvtime.c:kvm_update_stolen_time() {
>     ...
>     steal +=3D vcpu->arch.steal.last_steal - last_steal;
>     ...
> }
>=20
> (Note that arm64's kvm_arch_vcpu_run_pid_change() returns early if
> vcpu_has_run_once(vcpu) is true, skipping the opportunity to update last_=
steal.)
>=20
> Are there plans to address this on the other architectures?

Patch 2 addresses the arm64 case.

risc-v and loongarch may need similar handling, but I didn't include them in
this series because I only have x86 and arm64 KVM test environments availab=
le to
validate the fix. I don't currently have a risc-v or loongarch setup for KVM
testing.

>=20
>>  	select VIRT_XFER_TO_GUEST_WORK
>>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>>  	select KVM_VFIO
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 47cb9eba113b1..33be45eec32bc 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
> [ ... ]
>> @@ -3717,6 +3717,13 @@ void kvm_service_local_tlb_flush_requests(struct =
kvm_vcpu *vcpu)
>>  }
>>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_service_local_tlb_flush_requests);
>> =20
>> +int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
>> +
>=20
> [Severity: High]
> This isn't a bug introduced by this patch, but should this function also
> reset vcpu->arch.xen.last_steal?
>=20
> Looking at kvm_xen_update_runstate() in arch/x86/kvm/xen.c, the stolen ti=
me
> for Xen runstate is calculated similarly:
>=20
> arch/x86/kvm/xen.c:kvm_xen_update_runstate() {
>     ...
>     u64 steal_ns =3D run_delay - vx->last_steal;
>     delta_ns -=3D steal_ns;
>     vx->runstate_times[RUNSTATE_runnable] +=3D steal_ns;
>     ...
>     vx->last_steal =3D run_delay;
> }
>=20
> If the thread changes and run_delay resets to 0, wouldn't vx->last_steal
> also cause an identical integer underflow?
>=20
As explained in the cover letter, "Although David also suggested doing the =
same
for Xen-on-KVM vCPUs, this series does not reset last_steal for Xen vCPUs. =
That
change itself would not be difficult, but Xen uses a different mechanism to
account downtime, including runnable time and offline time when a vCPU is n=
ot
running. It may therefore need no additional ioctl, or a smaller ioctl
extension, to account run_delay left over from the previous PID. For now, t=
his
series changes only regular x86 steal time and arm64 PV time."

Dongli Zhang
