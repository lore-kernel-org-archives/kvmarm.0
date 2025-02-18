Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11022116.outbound.protection.outlook.com [40.93.200.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734177482
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 07:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.200.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739864005; cv=fail; b=s55ZT3SUQ1FFNl+dLSa2fBzVelp75fwgfVopBicqAm1yCx94RsjNvb1cY2b+b9nXrhNW5c4MyMCqptFfNTIYrjvgV7Mcx3Hf38jBU9aPKg3FU0zKdhQIYWnn54C5V7BTG2AtvLCEMv7HRtpNoZeClD/Qv9IUqjmP0OQ14+bzNWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739864005; c=relaxed/simple;
	bh=dHP1ieoyg3tR9ITvQV5TfI5GxW2Nb3+jSc4fk+/5H3g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aoOhG1e1g90rChxgp1vmc1j5XTO7vzaWnRTuzahg/D4uEak84yrafQkUY/oHUjVcIv+3hwv5ZHNplvqY1CpK0bSDxw41rZ2HIWP1+Kx9BC6xue28+wcDbUUkN0waTuMdYJmJ5H4ClfGDOd5jjOrvglT4MPB6PnHHE4ABTDJdDm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=fAfDUAVp; arc=fail smtp.client-ip=40.93.200.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="fAfDUAVp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yvb2gMP8bsAgzsTu4aHzsHES5O3wolGQd0xHhqUi+lt7ksjMigKZ66FY5f0Q0nysz2SJlG2FcHd2IBJaFraZKB2/DeS+5zZG+oFJaJiTeVKWTEUL54k/mKUvIkajWyDUaE7ZOGoa2r3W6j6WKkIdPIwf63K5CeJolTmIiwDIcPizlWmlc9WRoup7cy4N0kqhAIglu8sHIsvGiKv+vLtIQtXzPas1x6ZpaPqfSK+nx4RTrn4vz/gE5L6xSa6GptAVX44oJpkYVju/9xGhL16cH7y9YPKmaMzNhuq3P3lzjMdK6wFXW8G3tSrK2bw8eU6uYN5TQxUIeUZ43LZcu3+ggg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRTdd63DZojsle06J/km5l4CKCltyTRkFE5twqVHWTo=;
 b=DIqYxjIKrXtXhJd7ts2IyfTLqELGr6LMp0aFCo8VAsnlIdUyWstg33Rw/vPhAUNXz+K5wGYWo4Cf/XURd7xE0CCiFrJccDg6F5P3qQu+0jzf6E+eqivqiK3qJTDaIlPujVJBIDZQc1fUe+x9AzUIXpfFY46a848jBH84SCcvdMQzBi5pwMYOMjD5+RAYIoMYwgpGxeVnL8VWNJCVaEzpNEEN7BNc1m+xudR17vS5MezTEArKyDIS/xfn2wvshB7K9eHI0Mg4FrgI+/0p0fsW26mbYQrXv2VVRrzLzubExhqFgrq8NROVtGGNLCiKe0MlFgUEKXIgbJu8o2D2qxvzgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRTdd63DZojsle06J/km5l4CKCltyTRkFE5twqVHWTo=;
 b=fAfDUAVpj3StsmXjek4GpvouhgSZ/Ex94e1FsdAufNLUrwZDYHPnHTz2iir87LBGqMjRAMqh6cmC6vH9f8Fjlo4OPjmCF2gPlz2hX0V0JFBBNeyvDwv5FAX5HkPX0eP0XBK4tdmvcfqdn7EnlbiNlr+n2oW8lKxs8m3KvLIqhG8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 IA0PR01MB8330.prod.exchangelabs.com (2603:10b6:208:480::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.8; Tue, 18 Feb 2025 07:33:20 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.8445.008; Tue, 18 Feb 2025
 07:33:20 +0000
Message-ID: <1a19dacc-72ca-4631-bce8-7426b3de0b47@os.amperecomputing.com>
Date: Tue, 18 Feb 2025 13:03:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Set ISTATUS for emulated timers, If timer
 expired
To: Marc Zyngier <maz@kernel.org>, Eric Auger <eauger@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm <kvmarm@lists.linux.dev>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 christoffer.dall@arm.com, suzuki.poulose@arm.com, will@kernel.org,
 catalin.marinas@arm.com, coltonlewis@google.com, joey.gouly@arm.com,
 yuzenghui@huawei.com, darren@os.amperecomputing.com,
 vishnu@os.amperecomputing.com
References: <bcb4289b-507c-4ea1-afc7-6febd34d88db@redhat.com>
 <86y10osr19.wl-maz@kernel.org>
 <4d443db1-85b1-4071-acd5-3187deb9cb17@redhat.com>
 <2f6b2cb1-3d32-480a-9801-9b993ae74e2d@os.amperecomputing.com>
 <152d262e-641d-4bb1-9656-a13e049d62c4@redhat.com>
 <86h661wje4.wl-maz@kernel.org>
 <4a9fbdd9-ad23-44bc-8ba5-399f08068db4@redhat.com>
 <86cygpwfy0.wl-maz@kernel.org>
 <b22d5916-8b55-43bc-a256-2136d66ad25f@redhat.com>
 <86frkptzr6.wl-maz@kernel.org> <Z6ZMdv8jJUvYwQzT@linux.dev>
 <86bjvdtxb5.wl-maz@kernel.org>
 <8da22249-eedb-477b-98d8-f50dee56f1f7@redhat.com>
 <87tt8v14j2.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87tt8v14j2.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1P287CA0021.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:35::29) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|IA0PR01MB8330:EE_
X-MS-Office365-Filtering-Correlation-Id: f043212b-480d-4a75-feff-08dd4fee8459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dy9EVW84NVAvQTE0YUdIQ1ZWR2svWFlPRHd2Nk5pT1Irb0dpamlRMTY1SWNP?=
 =?utf-8?B?cFo3ZXpocHQ0OWV0T21xWGpXblJ6M1YwNXpoTnVYN01rcW1Ka0JlTnQ5eVZm?=
 =?utf-8?B?TlYvaHJyb2pmZEd6UGVlM0pEVTN2YlIvbk1FQkwxVWhUZkFDcTlQVzhkZWMy?=
 =?utf-8?B?QktEVU82amhWeVFFTGQ2dWRETGJvc1pWalliM0dWMkJ3UGkyMFdzczN3SVhl?=
 =?utf-8?B?Z3AwZGhwSlNDUUZZcTRETlBFMW9SRWtndmRsbklXM2VpV1BpS1FiOGRqUW56?=
 =?utf-8?B?dWprWm9PN1RZRkpOV05zWll5T3gvY3d6by84bEZJQ3c5L1NyWnpsdTljSzBT?=
 =?utf-8?B?UGNhY0R0VGlhb1JoOEJSYUx3RW52STdjY0FwZ2FrbU90SXVMaEZJUFJRQUM5?=
 =?utf-8?B?UEJVcU03b1lTa2Znc2lhNkNZQWFtZzZ2cWZaRlRHTzVPaWwzSmltaHFENkRM?=
 =?utf-8?B?cU5rRW1PK0lWeURzUnJ4eGo5R2dCdEhQQ0MrSDZjR3BtNDJRNWQvSmFSMVlS?=
 =?utf-8?B?eDJ4Q1pzVm14am95K0lvOGF0aDFrTzdJbTloQ1U2S2FiTXVWU3VmaGpEVnRW?=
 =?utf-8?B?bXBUTmZaMEVicHZLR3V4d3VHclJSSCtxU1NSQms4VStITm56ZFN2aGhCSThY?=
 =?utf-8?B?WlhwZWY1VENxN3F2aGdiaGwwdXY1QlVBei94YWFXMlFuNThFc1NXNFhHMXF5?=
 =?utf-8?B?d2ZQNFMrbmhFd2tyZHFQbnpBempySHRhRXlOY1A0dkhLQVkrZkJJNVMzLzYr?=
 =?utf-8?B?d3VoMW5LWk4vV2ptM1lIUE1JbUFiK3BKa1ExcVJpcGhZZTV2bzV1c3JrWFF0?=
 =?utf-8?B?TzdaUXVyUkprR0RQOUdtRGlhVVNGK09WTi9TUWZNL0VMVGpZT2xLZU9NM1hs?=
 =?utf-8?B?RXBNOWd5eXg0YVFMdFdYUGhOSkF2SGxJdjcyaGhqUmRHdlFmMjhVMDhLa1lu?=
 =?utf-8?B?eHdsT3A5bFhZN2oxQVpBRXB6bEZrSVh4L0E4Wm5FcWFRZ1hpem5uZ3o0SXNU?=
 =?utf-8?B?c0wzbEpLKzhSUEpwT292ZGd5YlZuYXQ3Yk1DRklXenkwZnFBR1F6aTNxV2Nw?=
 =?utf-8?B?WEJlakMrM0plRytTalZSek5LSHA4NjNOeWlyMW1sNCtsT2tlRzNENUNNTkg2?=
 =?utf-8?B?N2ZWV0Uwdlo1Vktmd1BNeDkzSVNLNXI3U2VJelV0TkpVQ3VUMEFieUErT2Y3?=
 =?utf-8?B?SGg3VU92eUJaT21CdW15RjdCSTNJQlIyOUhiYlVGQzB4ZlZWV3BEUTd5OUdI?=
 =?utf-8?B?S0QzU1F3STFDVG9WUCtjbC9JYzZyM0Npd1JYUTF5ZGxpMVNZRnc2eEZPbExI?=
 =?utf-8?B?aW5OWC9WeUdQRk5XcEFrMzNMU2RkSFUwekdsZC9WcTNZeG9nVlVQUm1obzdE?=
 =?utf-8?B?bnhQSGVNKzhadE1qT1VsZk9oN2l4RE5rQmlEWFpCa2dFb1pUaG5jVzh5L3hU?=
 =?utf-8?B?RmVHbjFHZzd3OC95bXNVYXBWempXMnp2NlRyZjdwaHRrQUFDaWNJYjd4cTBn?=
 =?utf-8?B?U2xHeUV3RlF5U2ovMHh3M1J3RFFudWJrZDYzVUk2RTVaRTBjYmlSMFkraml6?=
 =?utf-8?B?MU5zYmZoQWJtLzgyL3VEVFV3bWR4RG8xRnNhdUdjbTMxNC91aUlUMnRFbWFP?=
 =?utf-8?B?R0FwY3hzalRDUkpZRFhuaGlTWUFyeWNVbGtRekM1cXdJRG5leG5OWi9aamlo?=
 =?utf-8?B?czZNZkFqYitmY0NaUlRzOEQrWWFlcjhnRm5jWExiMDN2OGE3Z1JrY2tFRlFs?=
 =?utf-8?B?WXJZSW1sdEZJRFVYN1dMNlJzaG40clRMMGxOTnFWWkszR25FZ0xXTUZ0TG5J?=
 =?utf-8?B?aDlXVC9DdmwxSE5OYTJmY0FZV0NmQU84UzNENEJCOTU0c3N2VU1BRm04UzFj?=
 =?utf-8?Q?TEjfnr2Cn48PN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjhFZXVLYUczTjBwSTkreUN0RERtQ3NvYWZudG15aFFnTzFnMkhLMHRJUDho?=
 =?utf-8?B?RlY2L3M4Y1puNXNDTS9sd2VpNWEyMkc0SWJuZjhWcityNzlsWUhmZ2cwZGhh?=
 =?utf-8?B?UnhYOHFsQWNwbGdaOVd6RVpBZkFuOCtTVTdCVC9BenY0VnpWL1lWSDlLY2FD?=
 =?utf-8?B?YkpkSWJtUm85Qi9STHliZEJ4cFRVWXVsMDZHVktaL2FTdlhGai9jWTFvT0ZX?=
 =?utf-8?B?VU5GYVZwT1B3MGVuM3Y3MXcwaUVBeSs0TlJNdS9NTU5UTXVpMVpZSXBxd2Vq?=
 =?utf-8?B?UkJVaEd5c1N1cjc3L0thaFZ0eDBGZFptRTZ1d3Z1TnoyTGovZWhzWjY2NnlY?=
 =?utf-8?B?cmlrVHlJanhCRFVLTU9hZm1ZNldXZHNYNzlwTTE3Y2VPVDVpOGRmOUcyekRI?=
 =?utf-8?B?aHlELzhGcDVPZlZCbVowL1pjL3NValV3UUVXT2pibXA4TzJVandVZVNDeTZB?=
 =?utf-8?B?QzVNY0t6dG5HTnlEWURMNjVadWNIb3dOY01WWGsycmFxUG9hVG02Y2ZkSGxP?=
 =?utf-8?B?WFEyUGdSbkFsM2hhUVlaVjV4VFp1QUJxQlRDZXV1OHFCUk5rT0JVdUFIK011?=
 =?utf-8?B?Ylg0WFY4MmxsRzlPQUNZRklsQUFMcjJIRDNycXR3ZGpSRUhiY01laVo4SFBX?=
 =?utf-8?B?ZmdBbjk0dG9CT2IyMWRoSHdSYVNjdmtSamkrbytzT2gvUVF5NGxBY05BSzJU?=
 =?utf-8?B?eGJrNTU5aTgxQ09tVDJiQnkweWd4ZXlzV3AyMGtGckwycVIwMDZ0ZlJCZFdo?=
 =?utf-8?B?RUVTYlMwQ3Zqb0FVQlR0NGJNUXRCdERiMjIwQlNZN0NTTU1lczdBdThqOURX?=
 =?utf-8?B?YXZEZFh5SUFwUXBEQU1Ma0ZucDh2SGJITlIwbnlIZ2VhTGlyNXpnWUtDcDB6?=
 =?utf-8?B?enFJOWZvVlhGZC9oRTlnVWl0bzhhVUcyMVVGbFBnblRhOHJpeVVNY0pDc3E3?=
 =?utf-8?B?ZFJKenNrRzRNallRcFByNS9weTlHUjNYU2pHVWVqcCtKMVRkTHMwZnRtMkIr?=
 =?utf-8?B?U3c2dEZCc2hwYjlUMUhHSUpYVCtWMjgrZ2lwaHFtWGc5TmpRYk5ia0pwd0w3?=
 =?utf-8?B?RWgxMllvRmVVVHBxUWhTU3RQU29kTGhGUmNaOXpzb29qZjRjUmJBbGV6Tzg2?=
 =?utf-8?B?dVZvN2pVRDRqcUNjRnI4bzY3VkRKZkxPMFdTNGNZUm9WdjhGVXVPcWhOUmFs?=
 =?utf-8?B?V3RLUVdqNE51cGlwWGljbzBjaW51OWZPUFJIY3RtZ1BaM1J1WVowYytLNSt3?=
 =?utf-8?B?VDVwM0hldU1hc3VGNXB1L2FLSzV6Ylc1OTZQcXczOEVKdDJRNUgxTWp6ZW96?=
 =?utf-8?B?T25RclMwUERTMGdIZVgvbG5kQkNzTmI2Vmk2VFBBMlhWd3NuejQyZHpNb1BR?=
 =?utf-8?B?VkRrL2YvUkF3KzFEcVZwb09HaVhSOFZRWW01TjU5OHFLbUR1STNPZWVpMHo1?=
 =?utf-8?B?QnJhelh0eFNUZFZtVkE0d3pJVWhPZ01hdC9RRnRsVjYvYVA1VkhreHBqTCsy?=
 =?utf-8?B?Und2KzNKRmUxNzlDek53VXZRUWl3U2xQVE9na2ZObk5VU3RlOCt1MEVwNmgz?=
 =?utf-8?B?UTIzU3NYemZoOU1oeGdUMmZUOHdOY3BBTHNMaGoyRnptb2t6TkZKb3NoeVdJ?=
 =?utf-8?B?Ry93QjIraXVzMkhVZWRKYndzWEcyZ2dhZzk1aEFsL3JxQmVzOHM3ZEpRRWY4?=
 =?utf-8?B?MHR1WEVNLy9Jc0tsbCtDTzZScmxjWldua3k4aWZoeFNSTHdhampZRVduelRw?=
 =?utf-8?B?a2N1R2s4K21uWkFpTW9jeVVaNGpzK0F5cFRyVit2THU5T1NzditrdDNVOWZ1?=
 =?utf-8?B?QUhYdTE5cXB6b21aeG1FQWg5WG1rYUl1RWRFQk9BeUVlcGUvbUZNSVg2UUc5?=
 =?utf-8?B?dG4vTisrK0JZVTRmUzBldHAxMUg2b3htS0JlVjdIR3VveENyZkFScEIyZWpI?=
 =?utf-8?B?QlY5MzN1ZzV1UURuV0NXZmszY3FDU2NjaDNCaU1RWmQvL1E4U2Z0S0N1bDFi?=
 =?utf-8?B?bll0cGFKc0JyVzd3RHVzMDIrdzZXSVk3R3JDSFlLOW1uS2pKQW1ubHJYMmIz?=
 =?utf-8?B?VVRCeUZNZmNsMVJ3OFVNQjlTUEtHMWxXMVFWckl4Yk1rS3dGbEh6U0FzQVlO?=
 =?utf-8?B?OWMvWVU2dlphL0N3RFFvVk12MUs3dnBlck8rR01pOFVPbDRRcDdLUEhtVldt?=
 =?utf-8?Q?bncAUa/1znFnwfpZM3yq6kc=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f043212b-480d-4a75-feff-08dd4fee8459
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 07:33:20.1217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vLMbkIYGuNd1Di8WZX+NjiN9sdZDhw8y6IFNRnewAVyt1DJ0kIodmK6CovtdwZi5vD/rhpIq2vcOpJFMfaIORca+3LR7GtYH0usYnNwTKnIGa802iQWHLbdBQK5NIvzK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR01MB8330


Hi Marc,

On 15-02-2025 11:20 pm, Marc Zyngier wrote:
> On Mon, 10 Feb 2025 18:26:48 +0000,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>>
>> On 2/7/25 7:38 PM, Marc Zyngier wrote:
>>> On Fri, 07 Feb 2025 18:09:58 +0000,
>>> Oliver Upton <oliver.upton@linux.dev> wrote:
>>>>
>>>> Hey,
>>>>
>>>> On Fri, Feb 07, 2025 at 05:45:33PM +0000, Marc Zyngier wrote:
>>>>> I found at least one issue that could fail the migration. Before the
>>>>> VM starts running, we limit the feature set to the subset we actually
>>>>> support with NV.
>>>>>
>>>>> By doing this, we also change the value of IDreg fields that are not
>>>>> writable, because they describe features that we don't support.
>>>>> Obviously, that fails on restore.
>>>>>
>>>>> I need to have a think...
>>>>
>>>> We spoke about this a while ago (and I forgot til now), but I was
>>>> wondering if we could use vCPU feature flags to describe NV, including
>>>> the selection between FEAT_E2H0 and FEAT_VHE.
>>>>
>>>> I think this might match userspace expectations a bit more closely where
>>>> the state of the ID registers after init gives the actual feature set
>>>> supported by the VM.
>>>
>>> I'm not sure that's enough. Let me give you an example:
>>>
>>> My host has FEAT_XNX, described in ID_AA64MMFR1_EL1.XNX. For whatever
>>> reason, we don't allow this field to be written to, even out of NV
>>> context. This is odd, because for an EL1 VM, this field means nothing
>>> at all.
>> So the curprit fields for me look like
>>
>> - ID_AA64MMFR1_EL1.XNX
>> - ID_AA64DFR0_EL1.DoubleLock
>> - ID_AA64PFR0_EL1.RAS
>>
>> This is still based on your nv-next branch from Jan 9
>> https://github.com/eauger/linux/tree/nv_next_jan9_2025
> 
> I have now pushed out a new nv-next branch with the new and improved
> UAPI. I expect migration to work a bit better, or at least not to
> explode on ID register restore. You will notice that things have
> changed a bit (extra flag and cap for FEAT_E2H0), but nothing really
> major.
> 

Tried nv-next branch and it is breaking(kernel Oops) for normal VM boot 
itself with qemu. Looks like this is happening since qemu is trying to 
write to ID_UNALLOCATED mapped registers as part of save-restore of 
registers.

Below diff fixes the issue,

[root@sut08sys-r112 arm-platforms]# git diff arch/arm64/kvm/sys_regs.c
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e6f4599dca48..9459d25d4902 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2310,6 +2310,7 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
         .get_user = get_id_reg,                         \
         .set_user = set_id_reg,                         \
         .visibility = raz_visibility,                   \
+       .reset = kvm_read_sanitised_id_reg,             \
         .val = 0,                                       \
  }

#define ID_UNALLOCATED(crm, op2) {                      \
         Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
         .access = access_id_reg,                        \
         .get_user = get_id_reg,                         \
         .set_user = set_id_reg,                         \
         .visibility = raz_visibility,                   \
         .reset = kvm_read_sanitised_id_reg,             \
         .val = 0,                                       \
}


-- 
Thanks,
Ganapat/GK

