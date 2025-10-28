Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022073.outbound.protection.outlook.com [52.101.48.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B0922339
	for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 06:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761631347; cv=fail; b=iWQ6nRJv/pFJtvqGPcPGvdQWYLWPKif6nV41Bwaq5oMClIWi4oYVOKuWwF9biWsdnzIVmGnb2aTDMXklG2H5FCyYCGx/DC2YppMvJJiYpAmw12Rs3D400j33LPVgkYXBMKWhYowhxfu5yUhKlyZTkPY23p7/bUC/wlr7vq9TvV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761631347; c=relaxed/simple;
	bh=HJLP+gR8QIxZ/NSK/ZAsISyBhfqV2Z3kl6EIxd5gNZU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ONKjDnotUaOMv2It8EUrYnv+w3wOV4/F9Yq6moKqKobzrvIqsiko1VLu9jYyZCP5nkByGJkoSMgir5axkJkg7T/fWCV/AOzIYCzVAnraP1UrWtW/zG7IX5kvnSuuwC8tjnwvWAR2vGRU8JzL1jR3ySFut8lQVwTmXWPCTDBKSN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=ZAbOiItd; arc=fail smtp.client-ip=52.101.48.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="ZAbOiItd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I4b1TomGAfLRcgQcKNpJGc35cdpeFVcD989nKnzr+Jyt4f3jVMax/vOqEz2Y+jiXCkMWXTpso1gkZMM9+NVSpfbQCHiLZx9roOyF1CQqFtw2qQ8yxD0Z13sNeQ4dZ7cr4YSatKCcFaO35EIEZ751Ef+7mAJOpWYQV4L4Us+fk7XEu+DX/dM3SpyODNRKCASJ4aZNceBJfAAcqLq572Tw+BpAJfM0XlAfHlaAs/Ds6MCEVeucFHEnBmP29EJL7vrP/sQ+RAjOeTD9ZsfpvhIzyhACa4I4C7H1shnme15wj165hgTlGrRGCBtylvp2YJyjXXQpWo9Z9uDWADmcywIQIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ers8kR9eRPCvZsN30kgyxdxdh3V0IJ72AtdW7sjKxTQ=;
 b=ahh4IScS/cp29WNNH5udwW/It3LsHeaIHC3LW+RTOc014kUKh0rFXFBscIDQP3n/KW6+E0Q1/uoPHO779UUtkEJXiBu8wCz0rVHLPVk/Xyi5WfCeNOjh9dQ3t4ZdTo1D0dNqkfmNkQhAR+Qhza8vkWQnYUz41ZfZ02566MuBTp9hVyxE1PZGcDeXmfKvXV/AmjWXvvWK8WYl4jcQWvMNMRWj5Ag9dUjHYgTqkca30ItL2oNxySdja6s1ViLVAJxyqJEIO0oqNWDFAsLSh8VG7v+eIcakWPlAl8LA9vTuNsmri2hM03rVSm3F931TVMUR/STi83JLGdRBmYl6fkOLbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ers8kR9eRPCvZsN30kgyxdxdh3V0IJ72AtdW7sjKxTQ=;
 b=ZAbOiItdgIu/BBVxno4cIWJ+ZC3Od7IInODgeaCEsxLPgwl2V4M4g+5SnnBFetYVKGUw0UEf2ZWih1KG8Qqer6jwu0+oa6VEZ6vXsGLX4uRRNEuP9e6mo5lMJfCuWIg4bT1tFVL9f8lsZg+fhAZKsFUtn+f3SX2f1p4hdySo8jQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 BY3PR01MB6722.prod.exchangelabs.com (2603:10b6:a03:367::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.18; Tue, 28 Oct 2025 06:02:21 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 06:02:21 +0000
Message-ID: <060fe820-85b8-4476-be95-a0d37e53fa12@os.amperecomputing.com>
Date: Tue, 28 Oct 2025 11:32:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: arm64: nv: Optimize unmapping of shadow S2-MMU
 tables
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev, will@kernel.org,
 catalin.marinas@arm.com, suzuki.poulose@arm.com, joey.gouly@arm.com,
 yuzenghui@huawei.com, darren@os.amperecomputing.com, cl@gentwo.org,
 scott@os.amperecomputing.com, gklkml16@gmail.com
References: <20251013065125.767779-1-gankulkarni@os.amperecomputing.com>
 <0345c510-5db4-462f-95fb-591e71468aca@os.amperecomputing.com>
 <87v7k53cud.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87v7k53cud.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5P287CA0174.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1af::8) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|BY3PR01MB6722:EE_
X-MS-Office365-Filtering-Correlation-Id: 02c66939-2482-4a29-4da7-08de15e78ee3
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXJZRnpGT3VreDEzWXlGY2xZVCtPQjJHZ01ZTHM3NTYxdzhQRWhwUjZQdUt3?=
 =?utf-8?B?SjA5YlV6a3loZnJJTlFrYzZINXM3TVFDQTVWdGc4YVpISm80ZnhPeVcxbDQ5?=
 =?utf-8?B?Mkh0Z3pNUE13S0dGVHlXbEZnTGR2QmRaTHduMlc2cXV2K09VR0w1V0ttS1Rv?=
 =?utf-8?B?b1g4OHIvSnhLVm1ObExSK0Q4czdZdVJQdS9BcFoyZVFQeWduMitXRXdOWjBC?=
 =?utf-8?B?ckFzUlJvb254VTBxYkhXT2gwcWxadldXdWN0KzBWOHZJNFpiTzZLWWxyRDZ4?=
 =?utf-8?B?eVh1UmhjY21RRlk1VFkxV21kNjNld2FCdXE0ZzJBRWV0dmhkalJjRVkvTVFB?=
 =?utf-8?B?V05VdXVMNFFHWUtuNGZ6S05taVJKUmpmR1E1blhoU2x6T01FZTkvWmFxRUJr?=
 =?utf-8?B?d3BOcWpFeVBmOGFIVWV1VnJyRmNZaTQvdmpzSVFXa3NnM0VwQlc4c25BNm9u?=
 =?utf-8?B?ajhiWWU5VHBCNjJhVll2VFFZN0lQNHptN0NJTkJuZTdJRHNVbERva1NDWjR2?=
 =?utf-8?B?UTFKOWZPZG9jdngyMDl4amd4ZmUvRWFrTXRHNUhCYURDQlVWNjdvTmVxZFNH?=
 =?utf-8?B?VXJlajRXMG5DVmF0ZjMvMUQzWWNyNm9NZFN6ZXBiTThhVkVqVUNIK3NOUnU0?=
 =?utf-8?B?ZVVvcXBtcER1Z2wwTzVvVGE0M2NhR2FSWkkyY1NhUUVRQzVNMDJTeTR3a2tZ?=
 =?utf-8?B?dHljS1NwSmhJeGp2OHY3ZnhCNG50WFpxa0x3dU9GeTZGb2FIbFdoUzRrelNx?=
 =?utf-8?B?cXNERk1sSVY4M3hOdTI5RWhGVmFmZWpPaGt6UEpmNmlmK0l0TEtKOTNYY0Zo?=
 =?utf-8?B?VFhaa1c5Q3RTN2k5UXRpRkt2MC92czA1VU4zUlg0TktMb2w3cHFkUE9HN3Ir?=
 =?utf-8?B?QTFWM1RSOW93c3VQcit1aWNYcnJjbzdscEFSWXFrWVY5RUduNEVLYTVwNjJY?=
 =?utf-8?B?dEVIdFpLNDB3UlpsMWgweWEwSmRINXNxUXo3WGZVUFlCcktUZzZiWVk1Vnly?=
 =?utf-8?B?Z29xb1ZWUWwveDlrbFRJcml0MjVmRzdWRE5UZ245Ry9SWm1xSU43SkkxRm10?=
 =?utf-8?B?MHozV3A5R1Rkb3ArcFJGeCtwTEcvRWtHVmZKWW90cG1naUtQcjF5T2VUQzVh?=
 =?utf-8?B?M1JVcDJ0NlZ6YWNsSjlDeHdZYi9tZVJUWUliSzBnNzA3QVZ2L0d2anpWek5o?=
 =?utf-8?B?M2pkQTdyenNHWGFSUkUySDcvOHBtall3YkMyOHZWMmdwYlVNYnJEd0JuR2hI?=
 =?utf-8?B?MVVjTnNwaVN0aVRRU2xsN1RiVmNSbHFwMmZDaWptNXJHQkZpbFpTdGJUbjgy?=
 =?utf-8?B?MHRVbHpCaU85M0s3akRoY2M5d1FabVhIdFA4cm9xTjZuRy9KM2xPWkY4bE8v?=
 =?utf-8?B?NGltY2FTWTU1b05CZ3NheEppdkdITjJOOE9uLzF4ZFNySW9SQmprZndlY1lY?=
 =?utf-8?B?RG9pdk5mMm9haU5qTldCd1ErbUl3V2NycGhiQXZvcmxUemtLMTlNYWhvSStq?=
 =?utf-8?B?YWJtMnZaSXBDMXUzT0Zsakh3YUhJYjRtYWpwT2J6S0MxeGVtZ2xSRFFzYlZ6?=
 =?utf-8?B?OU96bDFFRTVGN0F6MGE4RGUxVGNGalc0V1dOSkdJaFZvR0NUbmYzV3NWR0xo?=
 =?utf-8?B?L3ZxdndJVmNmamFzdEJGRnBiSS9vWjNLM0U5alp3VnIvVkZoQXVPT05LRTV6?=
 =?utf-8?B?bGhhWmQvOGp4Sk9NRVBPejl4UnduLzREeW5DcFMvMkVzOXRsVmRKRUZvMGlT?=
 =?utf-8?B?VDBhWHJHZUtjUU00UVliOVZEMnBVTTNQNVNyT0pXczAwYmJSY2l6aFFsN3lM?=
 =?utf-8?B?dXpXcFkxMS9ZaTlkWnhMS2JsbmUxdzE4VlJORWd2cU00eTdtR1JlV3ZaSjhw?=
 =?utf-8?B?OHd4ZjBQOVZBYVlibnpSSEFrUWV5SGJ6Uklyb2Uwamc4MHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDJMSEpnNEVBLys5NEZrQmltSW5hTGdvNkt2UU9JL2duN1BxVmhEY0tQLzhw?=
 =?utf-8?B?VXo5UEI5VjlkODdtcGt5RnRXRVhHSHZnSStQSGVJY1ZBL29xYTc4aFhVNkFj?=
 =?utf-8?B?UXlYd0FPKy8xYVRuZ2lnN29qVW5SMWYwN0RkbDRhWnZEekNrTTdzQW5uL0NZ?=
 =?utf-8?B?TllxVEk5dE5nb1c5VkJDZk5VVHRUYnBoaHNRV1A3RHRudmJUZ2N6VVMxTVl6?=
 =?utf-8?B?T0IrU0tKV0hMaUVVSDZnQVpESm1nYmN5R0VjRk1HZ2RJWG5xdXpLL0hPRjd1?=
 =?utf-8?B?Z0Vlb1NDZkFzM2N4SE1MZXg0OFEwNlQwMENINytSTFVwODBRWklTZ1MzdHBJ?=
 =?utf-8?B?OUZWcEEzYVhlckJGU1lZV2k0N3FTVFI0OGlyWlMxcmlkZzFCRlZZZGJOTU03?=
 =?utf-8?B?OU5sQ0FZSFhkdm1XT2dmbVVpYnFpWEtPWHFTQ2NkRGFFbHVHejJWU1R2cmJp?=
 =?utf-8?B?cXQvdThoMjc3V2JjT3ZxdHNSd2p5TW5OKzA0NUREK1NEazBUTmh6bDBOenZ1?=
 =?utf-8?B?TUdoME04cFowSW5jbnl4ajBCVlJ0bG9nS2FWY2VLMGJjZFlPN2krcWtKVjhW?=
 =?utf-8?B?bG5NUm02Znh2NFBtejF5RUlCN0pmQUlCd2ZPNG01VmZEWkxLUFcrTkhhdktC?=
 =?utf-8?B?dzY1VDUvdWJ2VVBJaG9mYkdjT2JLNmNVR1F1K1QwRStZalFpekVITDVFUHZH?=
 =?utf-8?B?NnZtajFBeDVYMGRyeEJNTXo4angwTkdySC9sY2tCUEJCOHY1bWtOZERaUWM5?=
 =?utf-8?B?WW5jc09vTWNNOW56cHk4M3lIK0VZTlFhUUgvakw0S2N3aHNLUy9YTWtaWm01?=
 =?utf-8?B?cGJwbWR6MWxiVWtKQ1pMRDdTQm9IcFZNQUNBaHZtUGJnN2Y5WGxXNGxZUXBq?=
 =?utf-8?B?Nkd5WHJWWjltRGJESStuSFhYV1FKdlZDcVdUcXArV05wL2UwMDhlMlhSVVYz?=
 =?utf-8?B?VWp2UlBVbGtZbVA1MUhEemNOaXE4eUZTd0Fxb1FQdHplZzZReTZ3cExQeHFV?=
 =?utf-8?B?Ym9vdURzbmtTUjNkZ2IwbkhoZFF2QUMzcllMTkNTdmJwR3RSNnNNSXkrUGpr?=
 =?utf-8?B?Z21CVjV0blZ1RHJLRGhDUFdCTXViRFZaOWVmcTQ2bm45RFYyWUNkelFCSnhw?=
 =?utf-8?B?K2VldjJtWDdtNm1GSmhudTh4VFdzYjZYWEVMUXdOR2hmUWRYTXRQU0JEMUZC?=
 =?utf-8?B?Mkt1aDNaSkU1RkYyZXlzTXRXM2JONkVJaDJZTWFKbWd1TlRLeW93OEd0ZlRv?=
 =?utf-8?B?VG9yODkyWEt1M0Nja3UxTnk1R1JJdWxjejljL2puQnhVdG1qcXJGNDA3RVlI?=
 =?utf-8?B?V3N0RU9LWWpvRmhHc1NYVTl5SUZqeWZjaS9KY09jS3d1Ui9yWGVEVFRlbGVj?=
 =?utf-8?B?eUkvelY4ek0yZXJxazJDaW9MaTlYWTJWSlFLQkR0VFkzTlJtUEltdTBZU2Qw?=
 =?utf-8?B?bDBSdmVBOUpkZWFraDZLTHZhM0pxd3V0L20yMU5SK0VsWHVnQ1JuVVFVc0Fn?=
 =?utf-8?B?bmpxZzBWTkh1Nm5OaXpJTlhLNTlJSDR1dFEwMG5PRkNDVGpLbWlkWXk2L1Rv?=
 =?utf-8?B?dUJ0UDk0WXBDNHBpelZBdjgzb2hTRFlHQ091NGVIQjRlSUxLb2RaVmEwT1dF?=
 =?utf-8?B?Wm1FSUl0dm5uODJYaW9qVVFuc01lUWV1QkJQRXZUL1lvY3NmNkZDQnZQVDZa?=
 =?utf-8?B?VWx0bkJjSVBKZXhaSmNyU2w1QkVFMkxZMlROSmdlNUVHKzBJSktrUFcrNkFy?=
 =?utf-8?B?NzY2Sk9ocGRsQkoyOHM1dlpRUHc4WG1iMTg3N0tOaVJZRmZwRVVJVGl4UkRK?=
 =?utf-8?B?WDR6dlVFa2c3bCtIUFBaTmRIVEFGZ1JuWVVmZVcrd0lRdmpSUUN5UzNtSGhu?=
 =?utf-8?B?dTVkQnpvUXZaUkF5SHd2Vjd1Um5BZUtkMHloajZybGFQTG1vY3BjRHhvMHQr?=
 =?utf-8?B?WGlPVklRVzRQRGg5NWxvMkNacmxPc1kwWFhPSExwcnYxdEdPRFFZVng0V1lG?=
 =?utf-8?B?NDY3V09QZFI1aXQyV3p3NHFlVHdFQlBoZHpkdldjQmZrd0RyUWhZaVBiVWFL?=
 =?utf-8?B?M21JelE0ckU1WEZkNkowUGg3bTUvWTF2eEZzUHdKaVlBVEx3YVp4dUFCWVZ6?=
 =?utf-8?B?N0k2aHhwZjBBZHV6WGt2QUZMbzFsdHBmTm94WkZ6bjh4NVNqYUZsRThVN245?=
 =?utf-8?Q?2Gp1ae33nHces7maUeib5JU=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c66939-2482-4a29-4da7-08de15e78ee3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 06:02:21.3454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgKU8hydRv2/MVTwfzEs69CCLpCo1znIO7XE+lghHFL14fvUaO2KZK1aPcAhvZqV+7xdOzDXqEYmLBsWITC0AsgeCj2/9Vj/SLdt1cFyxBIurxJBmoAoYQPE6gnCYv2B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR01MB6722

On 10/23/2025 8:05 PM, Marc Zyngier wrote:
> On Thu, 23 Oct 2025 12:11:42 +0100,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>> Hi Marc, Oliver,
>>
>> On 10/13/2025 12:21 PM, Ganapatrao Kulkarni wrote:
>>> As of commit ec14c272408a ("KVM: arm64: nv: Unmap/flush shadow
>>> stage 2 page tables"), an unmap of a canonical IPA range mapped at L1
>>> triggers invalidation in L1 S2-MMU and in all active shadow (L2) S2-MMU
>>> tables. Because there is no direct mapping to locate the corresponding
>>> shadow IPAs, the code falls back to a full S2-MMU page-table walk and
>>> invalidation across the entire L1 address space.
>>>
>>> For 4K pages this causes roughly 256K loop iterations (about 8M for
>>> 64K pages) per unmap, which can severely impact performance on large
>>> systems and even cause soft lockups during NV (L1/L2) boots with many
>>> CPUs and large memory. It also causes long delays during L1 reboot.
>>>
>>> This patch adds a maple-tree-based lookup that records canonical-IPA to
>>> shadow-IPA mappings whenever a page is mapped into any shadow (L2)
>>> table. On unmap, the lookup is used to target only those shadow IPAs
>>> which are fully or partially mapped in shadow S2-MMU tables, avoiding
>>> a full-address-space walk and unnecessary unmap/flush operations.
>>>
>>> The lookup is updated on map/unmap operations so entries remain
>>> consistent with shadow table state. Use it during unmap to invalidate
>>> only affected shadow IPAs, avoiding unnecessary CPU work and reducing
>>> latency when shadow mappings are sparse.
>>>
>>> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
>>> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
>>> ---
>>>
>>> Changes since v1:
>>> 		Rebased to 6.18-rc1.
>>> 		Fixed alignment issue while adding the shadow ipa range
>>> 		to lookup.	
>>>
>>> Changes since RFC v1:
>>> 		Added maple tree based lookup and updated with review
>>> 		comments from [1].
>>>
>>> [1] https://lkml.indiana.edu/2403.0/03801.html
>>>
>>>    arch/arm64/include/asm/kvm_host.h   |   3 +
>>>    arch/arm64/include/asm/kvm_nested.h |   9 +++
>>>    arch/arm64/kvm/mmu.c                |  17 ++--
>>>    arch/arm64/kvm/nested.c             | 120 ++++++++++++++++++++++++++--
>>>    4 files changed, 138 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index b763293281c8..e774681c6ba4 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -227,6 +227,9 @@ struct kvm_s2_mmu {
>>>    	 * >0: Somebody is actively using this.
>>>    	 */
>>>    	atomic_t refcnt;
>>> +
>>> +	/* For IPA to shadow IPA lookup */
>>> +	struct maple_tree nested_mmu_mt;
>>>    };
>>>      struct kvm_arch_memory_slot {
>>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>>> index f7c06a840963..5b7c4e7ed18f 100644
>>> --- a/arch/arm64/include/asm/kvm_nested.h
>>> +++ b/arch/arm64/include/asm/kvm_nested.h
>>> @@ -69,6 +69,8 @@ extern void kvm_init_nested(struct kvm *kvm);
>>>    extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
>>>    extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
>>>    extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
>>> +extern int add_to_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 shadow_ipa, u64 ipa,
>>> +		u64 size);
>>>      union tlbi_info;
>>>    @@ -95,6 +97,12 @@ struct kvm_s2_trans {
>>>    	u64 desc;
>>>    };
>>>    +struct shadow_ipa_map {
>>> +	u64 shadow_ipa;
>>> +	u64 ipa;
>>> +	u64 size;
>>> +};
>>> +
>>>    static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
>>>    {
>>>    	return trans->output;
>>> @@ -132,6 +140,7 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
>>>    extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
>>>    extern void kvm_nested_s2_wp(struct kvm *kvm);
>>>    extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
>>> +extern void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, u64 size, bool may_block);
>>>    extern void kvm_nested_s2_flush(struct kvm *kvm);
>>>      unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu,
>>> u64 val);
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 7cc964af8d30..27c120556e1b 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -1872,6 +1872,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>    		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
>>>    					     __pfn_to_phys(pfn), prot,
>>>    					     memcache, flags);
>>> +
>>> +		/* Add to lookup, if canonical IPA range mapped to shadow mmu */
>>> +		if (nested)
>>> +			add_to_shadow_ipa_lookup(pgt, fault_ipa, ipa, vma_pagesize);
>>>    	}
>>>      out_unlock:
>>> @@ -2094,14 +2098,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>>      bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range
>>> *range)
>>>    {
>>> +	gpa_t start = range->start << PAGE_SHIFT;
>>> +	gpa_t end = (range->end - range->start) << PAGE_SHIFT;
>>> +	bool may_block = range->may_block;
>>> +
>>>    	if (!kvm->arch.mmu.pgt)
>>>    		return false;
>>>    -	__unmap_stage2_range(&kvm->arch.mmu, range->start <<
>>> PAGE_SHIFT,
>>> -			     (range->end - range->start) << PAGE_SHIFT,
>>> -			     range->may_block);
>>> -
>>> -	kvm_nested_s2_unmap(kvm, range->may_block);
>>> +	__unmap_stage2_range(&kvm->arch.mmu, start, end, may_block);
>>> +	kvm_nested_s2_unmap_range(kvm, start, end, may_block);
>>>    	return false;
>>>    }
>>>    @@ -2386,7 +2391,7 @@ void kvm_arch_flush_shadow_memslot(struct
>>> kvm *kvm,
>>>      	write_lock(&kvm->mmu_lock);
>>>    	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
>>> -	kvm_nested_s2_unmap(kvm, true);
>>> +	kvm_nested_s2_unmap_range(kvm, gpa, size, true);
>>>    	write_unlock(&kvm->mmu_lock);
>>>    }
>>>    diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>> index 7a045cad6bdf..3a7035e7526a 100644
>>> --- a/arch/arm64/kvm/nested.c
>>> +++ b/arch/arm64/kvm/nested.c
>>> @@ -7,6 +7,7 @@
>>>    #include <linux/bitfield.h>
>>>    #include <linux/kvm.h>
>>>    #include <linux/kvm_host.h>
>>> +#include <linux/maple_tree.h>
>>>      #include <asm/fixmap.h>
>>>    #include <asm/kvm_arm.h>
>>> @@ -725,6 +726,7 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
>>>    	mmu->tlb_vttbr = VTTBR_CNP_BIT;
>>>    	mmu->nested_stage2_enabled = false;
>>>    	atomic_set(&mmu->refcnt, 0);
>>> +	mt_init_flags(&mmu->nested_mmu_mt, MM_MT_FLAGS);
>>>    }
>>>      void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>>> @@ -1067,6 +1069,99 @@ void kvm_nested_s2_wp(struct kvm *kvm)
>>>    	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
>>>    }
>>>    +/*
>>> + * Store range of canonical IPA mapped to a nested stage 2 mmu table.
>>> + * Canonical IPA used as pivot in maple tree for the lookup later
>>> + * while IPA unmap/flush.
>>> + */
>>> +int add_to_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 shadow_ipa,
>>> +		u64 ipa, u64 size)
>>> +{
>>> +	struct kvm_s2_mmu *mmu;
>>> +	struct shadow_ipa_map *entry;
>>> +	unsigned long start, end;
>>> +	int ret;
>>> +
>>> +	start = ALIGN_DOWN(ipa, size);
>>> +	end = start + size;
>>> +	mmu = pgt->mmu;
>>> +
>>> +	entry = kzalloc(sizeof(struct shadow_ipa_map), GFP_KERNEL_ACCOUNT);
>>> +
>>> +	if (!entry)
>>> +		return -ENOMEM;
>>> +
>>> +	entry->ipa = start;
>>> +	entry->shadow_ipa = ALIGN_DOWN(shadow_ipa, size);
>>> +	entry->size = size;
>>> +	ret = mtree_store_range(&mmu->nested_mmu_mt, start, end - 1, entry,
>>> +			  GFP_KERNEL_ACCOUNT);
>>> +	if (ret) {
>>> +		kfree(entry);
>>> +		WARN_ON(ret);
>>> +	}
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static void nested_mtree_erase(struct maple_tree *mt, unsigned long start,
>>> +		unsigned long size)
>>> +{
>>> +	void *entry = NULL;
>>> +
>>> +	MA_STATE(mas, mt, start, start + size - 1);
>>> +
>>> +	mtree_lock(mt);
>>> +	entry = mas_erase(&mas);
>>> +	mtree_unlock(mt);
>>> +	kfree(entry);
>>> +}
>>> +
>>> +static void nested_mtree_erase_and_unmap_all(struct kvm_s2_mmu *mmu,
>>> +		unsigned long start, unsigned long end, bool may_block)
>>> +{
>>> +	struct shadow_ipa_map *entry;
>>> +
>>> +	mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu)) {
>>> +		kvm_stage2_unmap_range(mmu, entry->shadow_ipa, entry->size,
>>> +				may_block);
>>> +		kfree(entry);
>>> +	}
>>> +
>>> +	mtree_destroy(&mmu->nested_mmu_mt);
>>> +	mt_init_flags(&mmu->nested_mmu_mt, MM_MT_FLAGS);
>>> +}
>>> +
>>> +void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, u64 size,
>>> +		bool may_block)
>>> +{
>>> +	int i;
>>> +	struct shadow_ipa_map *entry;
>>> +
>>> +	lockdep_assert_held_write(&kvm->mmu_lock);
>>> +
>>> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>> +		unsigned long start = ipa;
>>> +		unsigned long end = ipa + size;
>>> +
>>> +		if (!kvm_s2_mmu_valid(mmu))
>>> +			continue;
>>> +
>>> +		do {
>>> +			entry = mt_find(&mmu->nested_mmu_mt, &start, end - 1);
>>> +			if (!entry)
>>> +				break;
>>> +
>>> +			kvm_stage2_unmap_range(mmu, entry->shadow_ipa,
>>> +							entry->size, may_block);
>>> +			start = entry->ipa + entry->size;
>>> +			nested_mtree_erase(&mmu->nested_mmu_mt, entry->ipa,
>>> +							entry->size);
>>> +		} while (start < end);
>>> +	}
>>> +}
>>> +
>>>    void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>>>    {
>>>    	int i;
>>> @@ -1076,8 +1171,10 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>>>    	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>    		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>>    -		if (kvm_s2_mmu_valid(mmu))
>>> -			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
>>> +		if (!kvm_s2_mmu_valid(mmu))
>>> +			continue;
>>> +
>>> +		nested_mtree_erase_and_unmap_all(mmu, 0, kvm_phys_size(mmu), may_block);
>>>    	}
>>>      	kvm_invalidate_vncr_ipa(kvm, 0,
>>> BIT(kvm->arch.mmu.pgt->ia_bits));
>>> @@ -1091,9 +1188,14 @@ void kvm_nested_s2_flush(struct kvm *kvm)
>>>      	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>    		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>> +		struct shadow_ipa_map *entry;
>>> +		unsigned long start = 0;
>>>    -		if (kvm_s2_mmu_valid(mmu))
>>> -			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(mmu));
>>> +		if (!kvm_s2_mmu_valid(mmu))
>>> +			continue;
>>> +
>>> +		mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu))
>>> +			kvm_stage2_flush_range(mmu, entry->shadow_ipa, entry->size);
>>>    	}
>>>    }
>>>    @@ -1104,8 +1206,16 @@ void kvm_arch_flush_shadow_all(struct kvm
>>> *kvm)
>>>    	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>    		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>>    -		if (!WARN_ON(atomic_read(&mmu->refcnt)))
>>> +		if (!WARN_ON(atomic_read(&mmu->refcnt))) {
>>> +			struct shadow_ipa_map *entry;
>>> +			unsigned long start = 0;
>>> +
>>>    			kvm_free_stage2_pgd(mmu);
>>> +
>>> +			mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu))
>>> +				kfree(entry);
>>> +			mtree_destroy(&mmu->nested_mmu_mt);
>>> +		}
>>>    	}
>>>    	kvfree(kvm->arch.nested_mmus);
>>>    	kvm->arch.nested_mmus = NULL;
>>
>> Any review comments or suggestions for this patch?
> 
> None. This patch is obviously lacking the basic requirements that such
> an "optimisation" should handle, such as dealing with multiple
> mappings to the same IPA in the shadow S2, hence will happily fail to
> correctly unmap stuff. There is no documentation, and no test.
> 
Thanks for the comment.
How about adding list of multiple mappings ranges to the maple tree entry/node while adding to the lookup and later unmapping every range present in that list?

I tested this patch on an AmpereOne system (2 NUMA nodes, 96 CPUs per node, numa balance enabled) with large vCPU counts and large memory to L1 and L2.
The current full-address-space walk caused very large unmap/flush work and significant delays (exacerbated by NUMA balancing / page migration activity).
The targeted unmap using the list per node removes only the affected mappings and reduces the unmap latency substantially in our workloads.

I booted multiple L1s, each hosting several L2s, and observed no panics or failures related to missing support for multiple‑IPA mappings.
If you have any test cases or scenarios that would validate support for multiple IPA mappings, could you please share them?


-- 
Thanks,
Gk
