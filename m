Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022124.outbound.protection.outlook.com [52.101.43.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBB530C63C
	for <kvmarm@lists.linux.dev>; Thu, 23 Oct 2025 11:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761217917; cv=fail; b=RHX7ELGWlgTT3DlQNmOZvM99QxeNYxG4QJZdbj4riAi2iF8U7gLsWzqp8A+JJP4dpaUf0eavdLCgSx7kpfIdFgG7iaNa4Es7V8xZWiyMmt2LVLoKsbpxATZJgi532cMxvHIe2vBYszfX7Ba+uw0SI7zCKKuymaQrC9cV0XGEUuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761217917; c=relaxed/simple;
	bh=wGiQBkI4yAeHNQBa0NGnGi1d01b74c6boT4y04guIGE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H94OPzjyvTxQjg/c2HBgP2VCNaLyCf12N+19iMFexPfkGWAdf7iOq76r+R7weRXvjXOwUN0/HIMBDlDwCcJ37U2VSA93iEzS3k6Y227jjWzVKfE/63xHBzbkPkbCCwxwbIRBXDUl2CxnLk9XIX0TTS2KzmTQ97FikxwMETEodzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=KjEwFBkU; arc=fail smtp.client-ip=52.101.43.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="KjEwFBkU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/l4nAdaELaMgCc5UavSVmXBecHRtWqj4EMopmlGGd+OX1lyUy2ulV/79dJKm2liWR/yKr3Y9rG+D3ltFWlH76SfxJO/E95cGHe8okAH+5qmORNzhclnUhvBJNfOfFFEyzyoS5GTyTKtWoWKDJ+Bmr+El3hqRWVISbK+68QfC6D5ZCJSkZXX8Pdex705aGLoVgop9KxncZUHBBHz5Sp/1r4qaLCOLPIZd0PWbzBf/Lx588i99P+I+PXn6a03EacB6SnTrfva6QnaaK3AUjBxty/4Zzxxyuo8mJdt2wxnzZ8zg5BTApft6aNaFrD6f/LJrH17Xk9cVZAtTqVsUOFYfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xq8Od45bF7Ud3kqk78W/hrv2u2droGHah+paXYW4w/Y=;
 b=PRRdbEAQgQcEnaDyid1uh6zv3sW9wRY9vTSokYDCTBmaWb1MOdtjm0TBq6ocxNF66J8enQoSakjzujP+l46zO88+tG4C40zAQljCRBSYPKDBaowwu5pimGGqf6lP5mGV14W+Px7a4k4Cqnw70/0S/Mmg4ZCGRXx941sPNUDVSKNnkb5b7boRlElKt909LkKxdcSnYeYlTZYUD/w4qQjToJaDB0GTi+HNalsXtoHbDJyU2JQSUbfCFtHo6Kz/h6hjrnuwOvvb+p/KpUx9cNj78wMzQdobh5CMLptq4BNk6ZQxGhxu7UFJaOyuBgUwA8ig4Amj+Svlr2JTCviIW0qPpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xq8Od45bF7Ud3kqk78W/hrv2u2droGHah+paXYW4w/Y=;
 b=KjEwFBkUpMnoH43BaKot85KqTRpGQ8O4cMr0HOwIS0QedR5XAzqvNqAs8rYjSYgR77rwiNXIR+GvcqI6IQ0T2s7vtYvUIotKhkItfrj5QF5WDaqHtVvT7K91RxL/8NNBebh0CsgiCKuGpAh7C3MqtZHHlh/B9skjcweiuSL6C9Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SA0PR01MB6492.prod.exchangelabs.com (2603:10b6:806:ee::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.17; Thu, 23 Oct 2025 11:11:50 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 11:11:50 +0000
Message-ID: <0345c510-5db4-462f-95fb-591e71468aca@os.amperecomputing.com>
Date: Thu, 23 Oct 2025 16:41:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: arm64: nv: Optimize unmapping of shadow S2-MMU
 tables
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
 catalin.marinas@arm.com, suzuki.poulose@arm.com, joey.gouly@arm.com,
 yuzenghui@huawei.com, darren@os.amperecomputing.com, cl@gentwo.org,
 scott@os.amperecomputing.com, gklkml16@gmail.com
References: <20251013065125.767779-1-gankulkarni@os.amperecomputing.com>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20251013065125.767779-1-gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0166.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1ba::9) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SA0PR01MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: ce931376-a73c-4c98-729d-08de1224f6ea
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmhVeWd4TTJWTW1rOTNzSkNMTzlGN3lxZ3dZT1ZNcWM0N0tQTVpTQWhFc3U5?=
 =?utf-8?B?Smo2b1Jyd2d6NytWN2kybGdHNHhYUVVLeklTejl0L2FxZXVCd1ovWEhKUTBk?=
 =?utf-8?B?UVR3VEJXejVKMUZ2V1o5QVAreVZXZkpRalh3UHlmeGd3NFBaa012S1ZqWlIw?=
 =?utf-8?B?WlJhMCszcHNQUlpjVHNDMlQxazVJTFhzRU05alpvVGovOVgrcjhMY2VnOXh2?=
 =?utf-8?B?ZTQyZ2orWHd1T1M5dWF1ZFJEYVRRdnJDMTFxZnpCL0k1cnZCNmZ6cG95Wi9S?=
 =?utf-8?B?cy9PV0RRUmhIcm5wUThrV0VzYnFDZjFKVVhoc2FVbUNmSGdrTFlMUFFYNEhr?=
 =?utf-8?B?SjF1ZHpuV1ZvOEVpRFVYbEpIaDkxVVFJa2puOWJiZGw5Ukk3R1MrQ1lSTy94?=
 =?utf-8?B?N0J4TzRIMjVWREVqMWl3RzZXSDlJSThsSVJQN0tzRzBFRkk3b3NFVEFIbHFs?=
 =?utf-8?B?ajlTcGk3d1ptdFVwQk5sMnNRb2FBR09GUy90aGFscXpDOUpGK0o0cW4zVTQ3?=
 =?utf-8?B?blVZZkVxUzI4OXY3ZHltNi83UGVtUVB5UUpTcXFnL280L0FKRFRPaTBOMTJh?=
 =?utf-8?B?YzdjWjJ2b1BMckdlRUVQQzI3QTAwQWs0dEh2cUxzelpPd3JEYXEwOGU0TmRr?=
 =?utf-8?B?K25DeUJYTm1QT1Z0K1RGNC8yMjJwYXJTbGpTL0dKdFUrTmJha25FUE5OWjVN?=
 =?utf-8?B?elhOcGtXemJsOENySWFtV2pMTTFWcHV1dFVvSzVkWU9SaTZLQnVGb3pvSncw?=
 =?utf-8?B?dXhXTGlxQkRvS1VuSXM2d1k4OHpycFhKZlhJcC9ydmo0QzZqblFFZU9Iajlq?=
 =?utf-8?B?djI4aXdkQSt3ZDdIMGlzcVhVM21ZcWh3YjVPZzU3eUFLaWVYOElBc2FoSW5V?=
 =?utf-8?B?SWNtVkNrdldTN3owTjNzMmFGc1JOeUFFVzVLWTZyelBlOGxqdE5RZklFNDZt?=
 =?utf-8?B?NHV2Mys2SWR4cUl1R1hEQnhZZlVjODMzTlQ3dGNMNVhaa1lVb3lvbWZ4RUg3?=
 =?utf-8?B?cEFCV3VJR3c1eXBBZXdCOVl6QXZEUnFKUmFzTmtRa1NrNzUvL2xQbitlZE1o?=
 =?utf-8?B?ekZWR1NDWWxPdXJxSXRWWlJlR0lSVlhpYVpwV1lzVjlIMmNYcm5tOXdXdmZX?=
 =?utf-8?B?OU5ja2M1RGx0Nlo2VVI5YWZJRWJSRld1ajZvQlpKU0padFFUY0lnSTlZN0po?=
 =?utf-8?B?ZGlWS2JqbkhSNUZ6aEZhdmtibnVJdFhpZHIzczBmOGxEc0Q5b1psOWtqQlds?=
 =?utf-8?B?c1RMdGp3UWFjd1ZTakZBLzhxT08zUDFZaTRSN0hXTE9ORC9zNXRnWXd6VHRR?=
 =?utf-8?B?OHRBT1I4dDkzQllxTUM0ejlveXVGNVdYZUZEU1NWQnV2Q0JYbjh5VmFEU2hO?=
 =?utf-8?B?T0JITGJvTld0Q1BNdDl3VGdlQkdjOUgyVXRWUWZHYWZVMDhYTURHeXo5WWxV?=
 =?utf-8?B?Q044NTllSzBvSW0vWmw2UU5uM0tsYWt4MXJJdlQ0b3dnVkhucFc3MlZiM043?=
 =?utf-8?B?aUdEUTBHSlN5K2diSzNoeDVWOEkwNENvYWxKRnYybW1uaHEvNlM3TmYrWDhm?=
 =?utf-8?B?aG1pTTFzdUhRbE96RW1TUGwrc3Nyajg5R2Q1aEpzdC85S21mQ1N1QTNrS0RV?=
 =?utf-8?B?TkM1VnM5dkd0cTVNcXM3L0VLUCt5c01yM09uazdBQldxN0pYMUs3OG0wcVJN?=
 =?utf-8?B?Z0F5OUpNVjZsdmpuektSODc1NnhCUElyaGlscFRaMENzbUJtajJrdjA0cFY3?=
 =?utf-8?B?Q0RlU2haUVYrOUJQV29JMGUxWTRkbXhob0RVNkF3WU1ndEdlRGtLRUcwUmNl?=
 =?utf-8?B?S29CaTdUcG5aRlprOUMzdmJkS0EvcGdiY28xbkswRVg1OTBCbmJqR0ROYU54?=
 =?utf-8?B?WE9qN0R4VG90Ty9TZ1ZBNk9ERVJBOUFqNElVMkVneXhQdmkxOElSSkJPSmw2?=
 =?utf-8?B?VGhVRVA3ZHArci9zWWlXVU04WnNldzg4Q09xMmUxdlhsaDdvN0dON3RaOXpM?=
 =?utf-8?B?aU92WkVMbCtRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzZwSnFWdCtXSFNHZTJ0ZnJuQi9PRVpQOHE1STNBblFzYmNXZlE4aEVLNldW?=
 =?utf-8?B?d251Y25OQ0h6ckVjTjhWYzV6Wlg1MUpJUi8xeHA2RWV5SEFDeVV5RVQ2cmJ6?=
 =?utf-8?B?c3hGUFBwWmtLYU0rdTUzTWR2NDFmWU1iNGNmdzBQbUxPWkdJTDFZTER4TFht?=
 =?utf-8?B?NUl6bDZuQ0txbG5ibndrVFpuaU9YclJKYi9yTWpNckhjTlJRQTYzcytlYjZ4?=
 =?utf-8?B?c3NhMVBoVXZnVWZEVER4L1IycTVHU1dLeTdMSkVYY1dRemtYKzF4djJ1UDN4?=
 =?utf-8?B?cFYyTGs4dE05UEF5alBBVytDQzBMaWtZMGtLYkFBVVNFRXhBNVJ0Y3BDL2gr?=
 =?utf-8?B?NjhvaGtHdWczTjYxOCs2d08rKzhsMDdFN1JZZ25GVWsvMGJDMUsrMXB5UktB?=
 =?utf-8?B?Yzh6NWdJaGVsdEp6ZFQ4K2NVTk1QK1lqallRMUY3NysxM0ppek1iaXFhMUZZ?=
 =?utf-8?B?QkZyVXcxN2hoWGdlNlh3bWlaOUUxTk1BQVlFVkN4bms2dWVoME5Wbi8wMjlM?=
 =?utf-8?B?RzJHYWFLR3pzTTZ2UVpkZm8xV3JHN3pGTVZjTnNtdVJ6alZUZzRZWTQvcGlw?=
 =?utf-8?B?cS9zNVdnUTFCL0NzYmJDOFY1bUZjM0FvUXpVSnltVm5QUVBpZjY5V2JRT2dK?=
 =?utf-8?B?MDFlajZtU1VEK0E4cUdvaVZFNkQwNnpRSU5VallwMGVacGpIeFJZRi9ma2NW?=
 =?utf-8?B?dGU2Z2hHUnN1TXpzTjV3cGNlZFd5cFRWb1pnUi96ZjdZU25pVk53SDYwUmNJ?=
 =?utf-8?B?a0tNUDBNVGo3RGpIcGQxVlpwbDhnOXlMZmJPaENBR2N6elJuMEFkOStuYVRC?=
 =?utf-8?B?QldHSldMZTNWYTAxV3JTeVFXUWl2VzBRV3hnbXYxbXZLVVFEemt0WFpWRGhN?=
 =?utf-8?B?cDZWVmt0RlNmWXBtcytKOVgwNUlVRjRuUXh6LzJQM3ZmWFU4VVpaTUxNSHRG?=
 =?utf-8?B?L3B5ZjJid1dGZG1IYWduZ29IK1FwelhIUDUwWEJsTVVsc3BTdjI2UDF3cGVO?=
 =?utf-8?B?Z01RYUFXaTNvTGcyRk1BM1c1bkl6Wjd3WHptOHY2VXNOT3ozQXJrdE9uWjZw?=
 =?utf-8?B?NlRuYktSRHMwb0UxUEMrK3J2Z1pPNXZjNXFTY1I2a2d0V2xnbDR4TmZEM3h1?=
 =?utf-8?B?cVlTOFROM01ULzlCU0FWSTVkWVBDVFBzT201bWZ2OTlpZmI0NElzYlJkbUpB?=
 =?utf-8?B?WFdBS3Z6ZWlSdHNBT1RMV2M0cDJZcnF0RDA2SEtZeHB5TDFBb2NaL3FJRk5B?=
 =?utf-8?B?c3UxLzdJK0FjLzZLbVg0eGpjSHl5VG50OU9zT3RPc29Ea09oN1VaR2JTaC92?=
 =?utf-8?B?aUcrR1ZsR2ZhYjFYcUVNU0gvSDZqL0NaY21HbXdFZ25BMStTZU52QitlZHJR?=
 =?utf-8?B?aDIwVi9OVlR2alQ5bEpJQzQwSWMvaElvOHFTMVhyWEdnNmJyUmwxS1dkc1RN?=
 =?utf-8?B?eC9ocU5lQkozWHcvcDBHWjltU2MvNlplUnBYWjZXRUxuUTIzSENoZy9FSzU2?=
 =?utf-8?B?VHBYNVZYRmcxQTVkR2x1MUp2OHRqRXlCYWsrWS83SU9zVC9IVkw5MVFZT253?=
 =?utf-8?B?RXh5ZHh1VVlPTTVHclBKcU9sR3kzM1A1dEYyK2l0SUF6enVZWEF3LzNkbmlk?=
 =?utf-8?B?aUR1dVpJckNHd00vSXB1YU1IRlhCdEMxdkxHamJPaDNLTlJIclRWYjVLcldx?=
 =?utf-8?B?R2xCOHlqdDZwZFozeUw0YWFNdFQwUnJsb0ZXSjA1SjlQc0FTQndYaEVaSS9m?=
 =?utf-8?B?ZnJXaWU3NHpHcUp0Ylk5ZEp2T0hLRHVFWVZDMXMzcXBVNzc0Z1o3MkdhekdJ?=
 =?utf-8?B?ak9PQ3lqbDd0c3ZzM2s3MVhVUUl0L0UzM0JVNUgvbFVZWi80ZmhtVVkzTHNj?=
 =?utf-8?B?QkdrSFhHemF1RGQzOXR4TktDZFZmL1k3QVZqaGNRa3J2SjhwK2NaUXhFcFhE?=
 =?utf-8?B?K0o1aElGNW4zaWoyd1dzYjFaZzhJYXJxa0FFNFdNNzJtMkJyN05sT09WSm5m?=
 =?utf-8?B?akZvZzU2MnpBc3dRTTk3Z0R3VmpZRHVhemNZeXFqT05ZR3dabFBFTStCTzZI?=
 =?utf-8?B?bkhDMXVSeFN6NEtjT3Z2K1lidkZlVTQ1dm81K0xLU0VVOUIzOWJtNWdrZ2Ns?=
 =?utf-8?B?c3grN243ZDBmVElHSEh3VTFueHpXTEdvQlcrZEtLM1RqanQ5R3FaZzNFMHlE?=
 =?utf-8?Q?CNt5LrL4mITyhp4MH9WPcDA=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce931376-a73c-4c98-729d-08de1224f6ea
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 11:11:50.7297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDby0TTSnG0I7+N44BBZmCgMaGG23Xf7L1NNOIzXPShm+fJYOpHxPOWMh0Dia4Fzrisf/GeY5jHBKFDcyh0FCjJLkCSM4EDZkCNw7TsXvEV8EX5QYQNWUXRR7wKJgIIn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6492


Hi Marc, Oliver,

On 10/13/2025 12:21 PM, Ganapatrao Kulkarni wrote:
> As of commit ec14c272408a ("KVM: arm64: nv: Unmap/flush shadow
> stage 2 page tables"), an unmap of a canonical IPA range mapped at L1
> triggers invalidation in L1 S2-MMU and in all active shadow (L2) S2-MMU
> tables. Because there is no direct mapping to locate the corresponding
> shadow IPAs, the code falls back to a full S2-MMU page-table walk and
> invalidation across the entire L1 address space.
> 
> For 4K pages this causes roughly 256K loop iterations (about 8M for
> 64K pages) per unmap, which can severely impact performance on large
> systems and even cause soft lockups during NV (L1/L2) boots with many
> CPUs and large memory. It also causes long delays during L1 reboot.
> 
> This patch adds a maple-tree-based lookup that records canonical-IPA to
> shadow-IPA mappings whenever a page is mapped into any shadow (L2)
> table. On unmap, the lookup is used to target only those shadow IPAs
> which are fully or partially mapped in shadow S2-MMU tables, avoiding
> a full-address-space walk and unnecessary unmap/flush operations.
> 
> The lookup is updated on map/unmap operations so entries remain
> consistent with shadow table state. Use it during unmap to invalidate
> only affected shadow IPAs, avoiding unnecessary CPU work and reducing
> latency when shadow mappings are sparse.
> 
> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
> ---
> 
> Changes since v1:
> 		Rebased to 6.18-rc1.
> 		Fixed alignment issue while adding the shadow ipa range
> 		to lookup.	
> 
> Changes since RFC v1:
> 		Added maple tree based lookup and updated with review
> 		comments from [1].
> 
> [1] https://lkml.indiana.edu/2403.0/03801.html
> 
>   arch/arm64/include/asm/kvm_host.h   |   3 +
>   arch/arm64/include/asm/kvm_nested.h |   9 +++
>   arch/arm64/kvm/mmu.c                |  17 ++--
>   arch/arm64/kvm/nested.c             | 120 ++++++++++++++++++++++++++--
>   4 files changed, 138 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b763293281c8..e774681c6ba4 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -227,6 +227,9 @@ struct kvm_s2_mmu {
>   	 * >0: Somebody is actively using this.
>   	 */
>   	atomic_t refcnt;
> +
> +	/* For IPA to shadow IPA lookup */
> +	struct maple_tree nested_mmu_mt;
>   };
>   
>   struct kvm_arch_memory_slot {
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index f7c06a840963..5b7c4e7ed18f 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -69,6 +69,8 @@ extern void kvm_init_nested(struct kvm *kvm);
>   extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
>   extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
>   extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
> +extern int add_to_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 shadow_ipa, u64 ipa,
> +		u64 size);
>   
>   union tlbi_info;
>   
> @@ -95,6 +97,12 @@ struct kvm_s2_trans {
>   	u64 desc;
>   };
>   
> +struct shadow_ipa_map {
> +	u64 shadow_ipa;
> +	u64 ipa;
> +	u64 size;
> +};
> +
>   static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
>   {
>   	return trans->output;
> @@ -132,6 +140,7 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
>   extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
>   extern void kvm_nested_s2_wp(struct kvm *kvm);
>   extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
> +extern void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, u64 size, bool may_block);
>   extern void kvm_nested_s2_flush(struct kvm *kvm);
>   
>   unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7cc964af8d30..27c120556e1b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1872,6 +1872,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
>   					     __pfn_to_phys(pfn), prot,
>   					     memcache, flags);
> +
> +		/* Add to lookup, if canonical IPA range mapped to shadow mmu */
> +		if (nested)
> +			add_to_shadow_ipa_lookup(pgt, fault_ipa, ipa, vma_pagesize);
>   	}
>   
>   out_unlock:
> @@ -2094,14 +2098,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   
>   bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> +	gpa_t start = range->start << PAGE_SHIFT;
> +	gpa_t end = (range->end - range->start) << PAGE_SHIFT;
> +	bool may_block = range->may_block;
> +
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> -	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
> -			     (range->end - range->start) << PAGE_SHIFT,
> -			     range->may_block);
> -
> -	kvm_nested_s2_unmap(kvm, range->may_block);
> +	__unmap_stage2_range(&kvm->arch.mmu, start, end, may_block);
> +	kvm_nested_s2_unmap_range(kvm, start, end, may_block);
>   	return false;
>   }
>   
> @@ -2386,7 +2391,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   
>   	write_lock(&kvm->mmu_lock);
>   	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
> -	kvm_nested_s2_unmap(kvm, true);
> +	kvm_nested_s2_unmap_range(kvm, gpa, size, true);
>   	write_unlock(&kvm->mmu_lock);
>   }
>   
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 7a045cad6bdf..3a7035e7526a 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -7,6 +7,7 @@
>   #include <linux/bitfield.h>
>   #include <linux/kvm.h>
>   #include <linux/kvm_host.h>
> +#include <linux/maple_tree.h>
>   
>   #include <asm/fixmap.h>
>   #include <asm/kvm_arm.h>
> @@ -725,6 +726,7 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
>   	mmu->tlb_vttbr = VTTBR_CNP_BIT;
>   	mmu->nested_stage2_enabled = false;
>   	atomic_set(&mmu->refcnt, 0);
> +	mt_init_flags(&mmu->nested_mmu_mt, MM_MT_FLAGS);
>   }
>   
>   void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
> @@ -1067,6 +1069,99 @@ void kvm_nested_s2_wp(struct kvm *kvm)
>   	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
>   }
>   
> +/*
> + * Store range of canonical IPA mapped to a nested stage 2 mmu table.
> + * Canonical IPA used as pivot in maple tree for the lookup later
> + * while IPA unmap/flush.
> + */
> +int add_to_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 shadow_ipa,
> +		u64 ipa, u64 size)
> +{
> +	struct kvm_s2_mmu *mmu;
> +	struct shadow_ipa_map *entry;
> +	unsigned long start, end;
> +	int ret;
> +
> +	start = ALIGN_DOWN(ipa, size);
> +	end = start + size;
> +	mmu = pgt->mmu;
> +
> +	entry = kzalloc(sizeof(struct shadow_ipa_map), GFP_KERNEL_ACCOUNT);
> +
> +	if (!entry)
> +		return -ENOMEM;
> +
> +	entry->ipa = start;
> +	entry->shadow_ipa = ALIGN_DOWN(shadow_ipa, size);
> +	entry->size = size;
> +	ret = mtree_store_range(&mmu->nested_mmu_mt, start, end - 1, entry,
> +			  GFP_KERNEL_ACCOUNT);
> +	if (ret) {
> +		kfree(entry);
> +		WARN_ON(ret);
> +	}
> +
> +	return ret;
> +}
> +
> +static void nested_mtree_erase(struct maple_tree *mt, unsigned long start,
> +		unsigned long size)
> +{
> +	void *entry = NULL;
> +
> +	MA_STATE(mas, mt, start, start + size - 1);
> +
> +	mtree_lock(mt);
> +	entry = mas_erase(&mas);
> +	mtree_unlock(mt);
> +	kfree(entry);
> +}
> +
> +static void nested_mtree_erase_and_unmap_all(struct kvm_s2_mmu *mmu,
> +		unsigned long start, unsigned long end, bool may_block)
> +{
> +	struct shadow_ipa_map *entry;
> +
> +	mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu)) {
> +		kvm_stage2_unmap_range(mmu, entry->shadow_ipa, entry->size,
> +				may_block);
> +		kfree(entry);
> +	}
> +
> +	mtree_destroy(&mmu->nested_mmu_mt);
> +	mt_init_flags(&mmu->nested_mmu_mt, MM_MT_FLAGS);
> +}
> +
> +void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, u64 size,
> +		bool may_block)
> +{
> +	int i;
> +	struct shadow_ipa_map *entry;
> +
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +		unsigned long start = ipa;
> +		unsigned long end = ipa + size;
> +
> +		if (!kvm_s2_mmu_valid(mmu))
> +			continue;
> +
> +		do {
> +			entry = mt_find(&mmu->nested_mmu_mt, &start, end - 1);
> +			if (!entry)
> +				break;
> +
> +			kvm_stage2_unmap_range(mmu, entry->shadow_ipa,
> +							entry->size, may_block);
> +			start = entry->ipa + entry->size;
> +			nested_mtree_erase(&mmu->nested_mmu_mt, entry->ipa,
> +							entry->size);
> +		} while (start < end);
> +	}
> +}
> +
>   void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>   {
>   	int i;
> @@ -1076,8 +1171,10 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>   	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>   		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>   
> -		if (kvm_s2_mmu_valid(mmu))
> -			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
> +		if (!kvm_s2_mmu_valid(mmu))
> +			continue;
> +
> +		nested_mtree_erase_and_unmap_all(mmu, 0, kvm_phys_size(mmu), may_block);
>   	}
>   
>   	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> @@ -1091,9 +1188,14 @@ void kvm_nested_s2_flush(struct kvm *kvm)
>   
>   	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>   		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +		struct shadow_ipa_map *entry;
> +		unsigned long start = 0;
>   
> -		if (kvm_s2_mmu_valid(mmu))
> -			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(mmu));
> +		if (!kvm_s2_mmu_valid(mmu))
> +			continue;
> +
> +		mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu))
> +			kvm_stage2_flush_range(mmu, entry->shadow_ipa, entry->size);
>   	}
>   }
>   
> @@ -1104,8 +1206,16 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>   		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>   
> -		if (!WARN_ON(atomic_read(&mmu->refcnt)))
> +		if (!WARN_ON(atomic_read(&mmu->refcnt))) {
> +			struct shadow_ipa_map *entry;
> +			unsigned long start = 0;
> +
>   			kvm_free_stage2_pgd(mmu);
> +
> +			mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu))
> +				kfree(entry);
> +			mtree_destroy(&mmu->nested_mmu_mt);
> +		}
>   	}
>   	kvfree(kvm->arch.nested_mmus);
>   	kvm->arch.nested_mmus = NULL;

Any review comments or suggestions for this patch?

-- 
Thanks,
Gk
