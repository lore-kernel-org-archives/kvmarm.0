Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2120.outbound.protection.outlook.com [40.107.212.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACEC21D008
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 12:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733747149; cv=fail; b=ZtMKYkljt/Ml8MPjtpJXr1zpaCzhep+aEMv6afN//EsqHEIO/BZAdU39kyvZvcc0nQgUM7ue8kccJOdygJWzGqQvx5Wh/E8atluTBdBqVTg1CgynTiKNbezkFmjcf4SE2OTo0gf0vgWB0N9N3vENj+jMn+pZ/5PSRfP6OCoi/yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733747149; c=relaxed/simple;
	bh=8o312ZOK8KIVs0jLHUImFeGVMJHDAB2/NEwBXf+S634=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IQK6e3Xfz2B23sIL9n7a2Cc1WuF8Jl5O59NpPlk2M2rSe+hYwjNIn9fHsjmtOBGfNmhDKNnJ0F02uEMF1kNnxSgQMZ7hfveoWQH6djTiXYk4vUAVrp2/nH87G5jCk5ZGdn+UkR6gbQHYoBjZjGL66bSFNzygadw6r5pK/G3xQYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=iNlhRJvK; arc=fail smtp.client-ip=40.107.212.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="iNlhRJvK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cuzVZTVfzUQsb3TvjA38jDx9mjwu2CFuz7jQOIl53711SXTI/2uoHXt8p5d0oiZ3ZajE+44LiLqMUk4nW0XikrX+U/gyyctfY7tGbejOZdkUsc8qh0g/dnCV2mOYUdfbzOVmAICcYVLfiQ4RZJGpxrhPczL/LzU/mvr3GSrj7T/hXwtqd5bHNRqc4CZGvc4YJqF0UeNzq3s3PIdTELu2b1T/2RP+komFyzAcgtCpcDbKW4WWMizg1hKmEDE/CBBp6/npmDXEdM6esNetk+981v3RUrk6O+AQ9EfUXZ9q+/ed8fyJDpF2xbyhmTLH+cnGLgRId8db/8blcrz0XxBZaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAvOX41cUqcgAZKkpNmOArAIjiNnKnrkVnAZzwcYUpY=;
 b=OKchjuXMIkrw5gIA2fa7LeNrq0fBCet8WMOaxWAa8z2WZJreUn7VWI1zpmSjHwaEWNfCizXk4JhamEkmQrsLyKUcNHDiXxb17B2R8NH/ETGYmXoqshbFcWoQHON9GuR5BtQSSgPeyhOnJz+TMo5xnTyskexuTo8zdyNomC921SiitGhzcQq0xPpmSW/++hZDicpGYwfaZbYejGZNmSPgdJK94EeushWWNqlyq+Tv+TFasMdPcz9FggCXwCfgu9IId0fAJOlbGOcbu34hi4gA+0nVU4queNzhcCs4bIpZWn9dJNX552LwR23di9U9WW1suKd0+NpDzIMVqICtiJREaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CAvOX41cUqcgAZKkpNmOArAIjiNnKnrkVnAZzwcYUpY=;
 b=iNlhRJvKtAf3W0O/Ij4F6PptUPE/m1BwuzsUY9gzGOgWHAa7VegVJjxSlbs1olRrAy95QllWokHgoiE/bTLlJYlW5UapZNfifDqDpr7fxgj48sVDTIwa7xHcxQzL0XwbfKzpDBXmbQpPkRsyEWLofZYfvT+C9sb5DykGtZS34II=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 BL3PR01MB7193.prod.exchangelabs.com (2603:10b6:208:344::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.12; Mon, 9 Dec 2024 12:25:43 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%5]) with mapi id 15.20.8251.008; Mon, 9 Dec 2024
 12:25:43 +0000
Message-ID: <c5b1c3d7-56ca-4afc-a831-045dba4beffa@os.amperecomputing.com>
Date: Mon, 9 Dec 2024 17:55:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Set ISTATUS for emulated timers, If timer
 expired
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm <kvmarm@lists.linux.dev>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev,
 christoffer.dall@arm.com, suzuki.poulose@arm.com, will@kernel.org,
 catalin.marinas@arm.com, coltonlewis@google.com, joey.gouly@arm.com,
 yuzenghui@huawei.com, darren@os.amperecomputing.com,
 vishnu@os.amperecomputing.com
References: <20241209053201.339939-1-gankulkarni@os.amperecomputing.com>
 <867c89tc4q.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <867c89tc4q.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0156.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::26) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|BL3PR01MB7193:EE_
X-MS-Office365-Filtering-Correlation-Id: 5514d98b-0d73-4c87-3187-08dd184c99c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1RQcGg4ZUhrWTdicDFPT2htYWQ3djRJaWs4VG0vbFR5RXphMjZkUXZPZ0JF?=
 =?utf-8?B?VTdPVDkzcVpkSlloUXc5WkNud3pBRlZOZENtMWgvN3dPZHFFcVVTN2VQWU1V?=
 =?utf-8?B?eHdGSVQrZ0lobUhvOUxKR2VtRkE1VmhMVjFxd2pkL2NvS21YSklUR041QlM1?=
 =?utf-8?B?cENpSnoxRzVvSGE4Y1RBS0JZbzNrZ3Njai9vb2paeExnZFZkSDVWWGFYKzVX?=
 =?utf-8?B?Q2tsSSt3UGNWRENjcTgzelFhN2hIZzZJM1F1RFIwRWxnNjJwZGIrdVpuWUpJ?=
 =?utf-8?B?NVZwUUZsRkpnVkU5Q0NSNlZVUDBGY3Z5S2ZBZnphNVZGOUVnRnNZbG8yN0Vu?=
 =?utf-8?B?MmhDMU1veE92bzV1UjNacjhqRWtWWVZadkRidHFjUUg0RnZKM2IzK0pQcHc0?=
 =?utf-8?B?YUttcFRBWE0xdjk4aW9KK21wRGRRdmJ0TGNPdGFvMFhEOWlqVWM0WE4ySnc0?=
 =?utf-8?B?N2RUNUVQc3ZadjJtckM0SlovTS9PYUlpRnNOUDdDajVzRlVUeXdHbFhMWE1S?=
 =?utf-8?B?SmlzRGU4Sk1teFhXUWNBQlorOUZVclBMbUpVeXZMVDF5cTJyNmRIUWpQdjRu?=
 =?utf-8?B?aDRZLzVQNzhhazZlUEt2cHhObW1QZ2Vpd21abHlFdkxHZzBhcGdxcWFxdmo4?=
 =?utf-8?B?WG5ZKzdJWlhyQTlGeEwxRm5URC9lMUJKL3FZeHFTNEluZFVYYXQ3WEdmdnA1?=
 =?utf-8?B?VGM5S0dGNXBmSVNCVENUTkZodXZaTEhKdmtlQ1RXSGJ6dDlGcU1Vc0ZaT3BO?=
 =?utf-8?B?a1h6L3dVQjk4TDEzUW4vVWtKU0tlWG1zb3ZtMFoxeXQ2RmF4bW9obFJkVkpK?=
 =?utf-8?B?TlZyVHJpcDEyTzUrc0JlTnVyaC9SU1VSb0c1Mm1KY0NwdmZ1LzQ4V1F3MXUv?=
 =?utf-8?B?REk0cmdNMDIyc2NEUGlicTMzcFpreFcxVUdtQ3FkSXczMW5ucjNiT0xaWFNF?=
 =?utf-8?B?V1M3cU90eDlUT2IzVGwzOW1nZTBxbDdTeG9qOVRMd3FEUU5KR2hFbXhPU1Nn?=
 =?utf-8?B?My81dVRLa3lCZlZCaXRSOG10SEllSUR6czRtL1F2WThDY29uVGF2UlVRcUEx?=
 =?utf-8?B?VllUOUx1NGxiWkVua3F6QlIrc0hodm5VUGcyeFhRektReVNOU0x2T3VaVkEr?=
 =?utf-8?B?b3pjSUtxVU1nOXhHYlZ0MCt2RUZucTVvYzNmWHE0YWorTmQyVWhOTVNCdzBM?=
 =?utf-8?B?Qkk5WHZ5V3BKd2pTRU5JbFEyeGFIU3FCSlVpSjMyT3lBSzNPbXdjWTVkd2Jo?=
 =?utf-8?B?M0Q4T09FM2Z4NjZFQ2gyRStsRjRKWFZ2ZzE3UHFRbHdGbS95QlFjVmlLbkI2?=
 =?utf-8?B?U05KY3drOG45eTN0R29hS1h6LzNLSDJVZmtBNjRZQnJqU2hsL0FPT0hJcXVZ?=
 =?utf-8?B?b1pSRVZxNE5SVUFjVk1zdHhHNmo5YnBxMFROSU1ESlJzUDZ1bXlZdFNhZFJV?=
 =?utf-8?B?TGRYN2loVDFwYVhLdGNLekdsanhudlRxRUN1ejZ2WTBldkpxb2syU3hxMVhu?=
 =?utf-8?B?NFhOcTZScXpQeFZOZEwvb3JTeGdHMGFyK3V6Y3A4L2FIeDVlQXJFZjNVUlBM?=
 =?utf-8?B?TE1QdUFOQU1jYk85NVloT1gzVGZ3c2I3Wi9ZRXgzdnltdFpIRG1Nem5mVklt?=
 =?utf-8?B?K28xeGZNQlNLZkVxNjI0UXJUS29TNUgrZDRMYm41TFdWTnEyTVY1NjMxYnVY?=
 =?utf-8?B?TGtxNXluNCtadGJEa1NBUVZ1akYva04xejBjSmpsV1lMSVpaSyswZlpuM2dx?=
 =?utf-8?B?S3o4bnZrRVJDWnVwenFhTHg5aEhiVXFaME5MK3JLWFFtb3J4NWlCREJJNGtD?=
 =?utf-8?B?ejJDQTVrNWdiSzhzZUpyZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXlodUk2SzBHU0lSL0g3ZzdvMStmYmNWSVc1L2xhd05MNmx5NGhqNDgwQ242?=
 =?utf-8?B?ZGczVGR6eGdNUVhFb1o5bXpYdVNuRzZ5M3prY1dBekZvMDBLRjN0UE9mbExI?=
 =?utf-8?B?a1JpYzRmOG5ST0d5Q2xNTHhQTSt4VVFuL1YwbkVLdjNLQVVHYWVyanpteDJ6?=
 =?utf-8?B?bGVlMW8rbUhQZmVtcGRVUi9lY2Z1ZjJRWTcyZWFiUnBJbk1hYjJ1MDJKdm5m?=
 =?utf-8?B?bE9oc01TQk9FVXNRRzg2dnFGcXJhdjN3VW1BUExyeWR1V25JTk9nQ0l1MWFo?=
 =?utf-8?B?Zi9kczhvV1FpbU02T2R3cU9yODlScE1LMmpYQlVZSk81bzJWZ3lSbllVckp4?=
 =?utf-8?B?YW9nZStvUWFsUmtUOXdScUU0ZGxiWU84amRJYUZTL3Z1RTYvbjdCMG1nejc0?=
 =?utf-8?B?eStGcE83UGdTLzYyWlBwRFkrNmF0RjdLUlBwU1lzM2I5aTNON0VESjhRYnl2?=
 =?utf-8?B?ODRRanJpOFdRK0VVR0lhQS9LTjBaaDdneTN1Ly8wMEhBNkRGRHlSbFE3b2VE?=
 =?utf-8?B?bU80Ulk4bldQcHVEcW1XZC9tOUZ0WkhydlN5MGg1cnZZSEVWM2MzRTRUbWx6?=
 =?utf-8?B?a3V6RFZRS1NvUWQwcU1RN2o0M1ZyT2w4RzhsTWtiSGdiSi9JTmN5KzhCVnhL?=
 =?utf-8?B?RnBXZlp5VWJGcnAraDZZd3NvYy95Unh0MU9RS3A0M2p2TU1UV3JDa2F0R1Zh?=
 =?utf-8?B?YnludEpSeDA2ZDVvdE5rcGkwdm8wbFN2UFNXQjJNaHZJYThqYkVoTVcvdHNu?=
 =?utf-8?B?THg4NGFCWFE2aXpjR1Zlb3EyUi9CUnNSUnNXRlhrd3oxZHdZQWNycnZwL1FN?=
 =?utf-8?B?cEpPMlZ5VkJtblA3NTFmem5vQjh1UEhETnpuSCs5WUtENXlYNlZYYitNdUlv?=
 =?utf-8?B?UThkdFJVNjlZWlYwUm1pd2E2eUt0WkQvWFcvbGFFL2xGSU5WRVZNd2VkQ1Fu?=
 =?utf-8?B?TXhHaGwyelNSaHJFMUs4c1Vtd2FMeDEyWCthR2tJWmd1K1RmRUR2QmZEZXFj?=
 =?utf-8?B?ak83WGRrRnpEVTdmMnRoODAwY0hOY0VyTWh1TjdoelQwbjBpb3BYMkpRbDRX?=
 =?utf-8?B?WmFrZnJZemNrY1NRTE5GUGlZY0ZaZHNjdmFIaFU2WEh6T1hkT1NQY1VYQ05p?=
 =?utf-8?B?eWlHU1JJVi9uK0lyWEU2K3VxeUt3QmJsRHJQbisrbW9Dejdia0ZRdXpCd2Q4?=
 =?utf-8?B?Ym1Jakx4emJvVEx2WjlJL1RsTTN5eUdzeGhBdUh3SjAramp6aHV3VVJXeWNH?=
 =?utf-8?B?RlFTdzVSZzdlYW56d1BZSStWU0YwOUxpUEprNExDOURINXEwZ0VHN3ozTE5Z?=
 =?utf-8?B?Y2lETFc1bFBFc0djUWEzRFBmVGVJTkM2MCsvS0tKTzFTZTd3L3dvZllFOGdr?=
 =?utf-8?B?QVB5QnpFbERLa2QvdC9sMEk1blFKaW1CNytqWW5BSzN0SERzVUNKQnYrcEpV?=
 =?utf-8?B?ZlBwQXBiekozSkxvamxjcE1QODg3NUtabmUza21DVHBWOFFRMXJtbWhPR3pL?=
 =?utf-8?B?dndhRzRqY05zemxHTXY3cFpZM011cFFmelZ4VmJhZEZxWTh2UW9EMzduNVFo?=
 =?utf-8?B?QzZtMTk2QzRFYklPSUUwTk03VW9sSit2MlJDTk1VdzdORTVzT0kwTDVSMHhP?=
 =?utf-8?B?dzA0TzhqY2J1dG1IZUYrT3VKc0hVSm9vWG9zWE1zMDRHdHZzd0pBTnU5S2E3?=
 =?utf-8?B?cFhoWHFyZi9IUzdLZzVRWFdlcDFZMUswQzA0enM2a3BqT2k0WmZCYWFZYnRa?=
 =?utf-8?B?ZThsS1JDRzhOcitNaWRtejErbDlzSVRVaXcyTUxJc3M3bjJSSzZ0dXhQS2Jj?=
 =?utf-8?B?QlJMbk9sT2dYUFFXRk81andOTE9tNHJKMVlzTUZLWFFOM2UrL3NuY3hDYmh2?=
 =?utf-8?B?V3h1YVpsYW5XUEtmb1liWWgxQXNQYy95SS9CUEkvSWxhT3kvMDRZeFQ2ZkY4?=
 =?utf-8?B?aFV0ekpKV0JrWGdQR2JRaXdjekdsWXVtVHhoQjlvMnVpZUJIMnlhQ0pqNEJ2?=
 =?utf-8?B?MTNuWFBQMEd5V2pwVHVXQ0FFdmdiVGNVTy9NVklhSFdBUDFFTENRT0Z2RjNJ?=
 =?utf-8?B?Nmd6RENNQlMvSmJXV2pHZENoUjVnZnFIcENxd1JVQUFuTnVXaWpXcTUzaUVy?=
 =?utf-8?B?dFQwT05rV04xaFpzRlA4bUwwUTQySGJOaWlQc1AreGlWd0NQZFFoc3VydTJH?=
 =?utf-8?Q?nDzKLY/wHdTzlxwixfk/p3SM8o1ZB2bNTwsYjLsWa7Ha?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5514d98b-0d73-4c87-3187-08dd184c99c4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 12:25:43.4181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+4zOcgwK19UjP1TCpJd/tCGyJJSzA1+BH6/VyZq4YqhA6eJsn+L5aBERw/U+W10JZ+FbRLwEFXRs6LbaLPs1amK3jHurgguiGGnDnyRhDG0aBMu6CUzaWzFT126GR4Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB7193


Hi Marc,

On 09-12-2024 03:24 pm, Marc Zyngier wrote:
> Ganapatrao,
> 
> Did you notice that the Columbia list was killed over two years ago,
> as per ac107abef1976 ("KVM: arm64: Advertise new kvmarm mailing
> list")? Consider that script/get_maintainer.pl is your friend.

My bad, copy paste issue!.
> 
> Cc'ing the correct list instead,

Thanks.
> 
> On Mon, 09 Dec 2024 05:32:01 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> During automated testing of Nested Virtualization using avocado-vt,
> 
> Which is not merged upstream. So what branch are you using? Based on
> what kernel version? On what HW? With which virtualisation features?
> 

Testing is done on Ampere's AmpereOne platform using 6.10 based kernel 
with NV patches from your repo.

>> it has been observed that during some boot test iterations,
>> the Guest-Hypervisor boot was getting crashed with a
>> synchronous exception while it is still booting EDK2.
>>
>> The test is launching Multiple instances of Guest-Hypervisor boot
> 
> Is the multiple instance aspect really relevant to the reproduction of
> the problem?

Not really, but it requires multiple attempts/iterations to hit the 
issue. Even with automated test, it was seen at some iteration out of 10 
to 15 iterations.

> 
>> and while booting, QEMU monitor issued the command "info register"
>> at regular intervals to take a register dump. To execute this
>> command, QEMU stops the run and does the register read of various
>> registers. While resuming the run, the function kvm_arm_timer_write()
>> writes back the saved CNTV_CTL_EL0 register with ISTATUS cleared always
> 
> It is userspace that causes this write-back, right? AFAICT, KVM never
> does that on its own.
> 
>> and resulting in the loss of pending interrupt for emulated timers.
> 
> How does a missing interrupt result in a synchronous exception in
> EDK2? In my experience, EDK2 panics if it sees spurious interrupts,
> not when it is missing interrupts (it just locks up, which is
> expected).

Not sure, why it is hitting exception, rather than hang at EDK2.
However, EDK2 timer handler code is ignoring the interrupt since ISTATUS 
is not set and not moving CVAL forward.

> 
>> In hardware based timers, ISTATUS is a RO/WI bit and gets set by the
>> h/w, if the condition is still met. However, in Nested-Virtualization
>> case, the Guest-Hypervisor's EDK2 is using an emulated virtual timer
>> and losing ISTATUS state and the interrupt forever.
> 
> Why is this specific to NV? Can't the same thing happen to the
> physical timer in a non-VHE configuration?
> 

You mean, emulated v-timer in non-VHE boot?
It might impact non-VHE case as well, not tried though.

>>
>> Adding fix in kvm_arm_timer_write to set ISTATUS for emulated
>> timers, if the timer expired already.
>>
>> Fixes: 81dc9504a700 ("KVM: arm64: nv: timers: Support hyp timer emulation")
> 
> Where is this coming from? This patch doesn't touch the code you are
> changing, so how can it be the source of your problems? As far as I
> can tell, this has been the case since 5c5196da4e966 ("KVM: arm/arm64:
> Support EL1 phys timer register access in set/get reg").

Thanks, 5c5196da4e966 seems more relevant!.

>> Co-developed-by: Vishnu Pajjuri <vishnu@os.amperecomputing.com>
>> Signed-off-by: Vishnu Pajjuri <vishnu@os.amperecomputing.com>
>> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
>> ---
>>   arch/arm64/kvm/arch_timer.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> index 1215df590418..aca58113d790 100644
>> --- a/arch/arm64/kvm/arch_timer.c
>> +++ b/arch/arm64/kvm/arch_timer.c
>> @@ -1199,7 +1199,16 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
>>   		break;
>>   
>>   	case TIMER_REG_CTL:
>> -		timer_set_ctl(timer, val & ~ARCH_TIMER_CTRL_IT_STAT);
>> +		struct timer_map map;
>> +
>> +		val &= ~ARCH_TIMER_CTRL_IT_STAT;
>> +		get_timer_map(vcpu, &map);
>> +		/* Set ISTATUS bit for emulated timers, if timer expired. */
>> +		if (timer == map.emul_vtimer || timer == map.emul_ptimer) {
>> +			if (!kvm_timer_compute_delta(timer))
>> +				val |= ARCH_TIMER_CTRL_IT_STAT;
>> +		}
>> +		timer_set_ctl(timer, val);
>>   		break;
> 
> This really looks awfully complicated, when it is only a matter of
> recomputing the interrupt state, something that is at the core of the
> timer emulation. Why can't the following work:

Added check to handle ISTATUS for emulated timers only, since it is RO 
for hardware timers, thought it might confuse others(non-nv case).
Otherwise below diff from you should work as well. I will try it out.

> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 895f09658ef83..bd6efafbe7109 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1298,13 +1298,17 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
>   				enum kvm_arch_timer_regs treg,
>   				u64 val)
>   {
> +	unsigned long tmp = val;
> +
>   	switch (treg) {
>   	case TIMER_REG_TVAL:
>   		timer_set_cval(timer, kvm_phys_timer_read() - timer_get_offset(timer) + (s32)val);
>   		break;
>   
>   	case TIMER_REG_CTL:
> -		timer_set_ctl(timer, val & ~ARCH_TIMER_CTRL_IT_STAT);
> +		__assign_bit(__ffs(ARCH_TIMER_CTRL_IT_STAT), &tmp,
> +			     kvm_timer_should_fire(timer));
> +		timer_set_ctl(timer, tmp);
>   		break;
>   
>   	case TIMER_REG_CVAL:
> 
> But overall, this very much looks like it is only papering over the
> real issue, which is that the *emulation* should regenerate the
> pending bit, and not rely on the userspace interface.
> 
> As far as I can tell, we already correctly compute the status bit on
> read (read_timer_ctl()), so the guest should always observe something
> consistent when it traps. We also *never* use the status bit as an
> input to the emulation, and always recompute it from scratch (it is
> only there for the benefit of the guest or userspace).
> 

For emulated timers, we are not asserting again by calling 
kvm_timer_update_irq in timer_emulate() until the level is down and 
ready for trigger again. This was done to fix high rate of spurious 
interrupts getting generated to V-Timer. Hence we are not able to 
recover, if once ISTATUS is lost.

> So I can't see how upstream is broken in at the moment, and you need
> to explain how this actually triggers. Ideally, with a standalone
> reproducer or a selftest.

We could reproduce the issue with the simple test/script.
On one shell, launch L1 using qemu with add-on option

"-monitor unix:gh_monitor,server,nowait

On another shell, while L1 boots and still in UEFI, run repeatedly the 
command (or put in a while 1 loop script)

"echo "info registers" | socat - unix-connect:gh_monitor > 
/tmp/info_registers"

With above steps we were able to hit the issue within few attempts.

-- 
Thanks,
Ganapat/GK

