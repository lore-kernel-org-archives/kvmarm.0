Received: from CY4PR02CU008.outbound.protection.outlook.com (mail-westcentralusazon11021086.outbound.protection.outlook.com [40.93.199.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078741DF962
	for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 06:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.199.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740031860; cv=fail; b=ZKuoMonRx0ppGVkFhywpxLcbU0ecip36J58JDGp/RTUqVQXxoXizIHn3EpAIdm/rEkfQexu8OffgdI7HC7ddSt0vFgqKMivvVYS4yGMUtTlpeXUQu1UBqGD6DIxoNk9OVsXVXvGeUoAmK4YyDS6NOn8+Y8ClPSZrbGoLQViTWrU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740031860; c=relaxed/simple;
	bh=g46jY0jsrkToCA2uTJQkAh3Ejxp2a9a9RX1sV9symxs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cP9X+IIDSEPeGsyJPNu1quMLY4kqixvN4/TOAlAHXOyc11jfWEpKGJdG1h8T6nf8y0UnTwen9vDzjjBeeYN1A4j8lHZxkNVMj2ro9ET3RVA1YyEl4QIWIJnFGYBI5MNya7326SveCzJfmj6wHmfgC7/R4vungI5u7MyivgQkbfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=ccEfhsX0; arc=fail smtp.client-ip=40.93.199.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="ccEfhsX0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DxrYp7mxJ1q4ElR+VtQOCypEe0eBIezXLYB6FNSvvpuxJMK4Pc/GyN7Zyzr75GMYDDWlv4MqbC+05blCuIWbe9qj+uoejtSXMkt/myfWyIo8y8TxHa0EtmsJzs+fNBc5kifRRP3uejySrmUpwO7AvmGzL3kRuvFDf8ElYLW3XRRGQMOV9+koCNByI7Y3/cIW6vL4DDbdI6Db+5gHsGVLRv0CGVQoyBcrAuhlms0EqWKtFvIfdfphtOHneBmgW0vaFORKpzLRkTcDRPx/NDOLKz87hOJCA2xIYv/N4nN+KNoT1IPVfSkks5wU/WfCNgecs2tng8KBRxvNVv6xnuS+OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ErE6Fm9Tq7WfqA0yDZhIim2Ty5kbEQRoC9mMJKrZPiM=;
 b=NYUSMptYb2nMtiX6ikrw/BzdRXwQGAdS7wMrL7h54TEU8pZdb63yhqWW6jge549wbPZ81hcjpCz9aASCdJaTzugGd2cdJ1HJn6X3CoXgz31Ta3yPHdJNmZDtq2U3DrGm0bTnqeTZP9QSR1fS3cC1IjT7NbBe50Kw2nudWh0doLqlQHkKKQqoxCeVpFqVv2hP1qpjXVi7l8L+VuNbNQTnHTKRjgMRCVN2mGF7g7O7tii5wkACHR5n3zpsduQI9vH2eS4ePGNzsFwvjTVht/ns3CAoC7fOuW0utA+eZzPJ6O6aBFoCdLyNlXrVuAzAOT8kPwmlq2ihQw5h292+N+py/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErE6Fm9Tq7WfqA0yDZhIim2Ty5kbEQRoC9mMJKrZPiM=;
 b=ccEfhsX01d5+yyiXM5DcX7ZFijaQjQtJGieQA5y8qcLg3WFcKsNzBjB8oaloeawwwEDDkFwJylbq6yNk3MCs8aBIg2jhpM+XubjeSyYmB3ALQi5J5F7PVD5wTnWLCuBV7q1stJvgm52wXytyeBwZR7oUE5FOJBXEH3l/HXvoJaA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 BL3PR01MB6980.prod.exchangelabs.com (2603:10b6:208:35b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.14; Thu, 20 Feb 2025 06:10:55 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.8466.009; Thu, 20 Feb 2025
 06:10:53 +0000
Message-ID: <746924ed-2842-4aed-afd8-39d5192d1299@os.amperecomputing.com>
Date: Thu, 20 Feb 2025 11:40:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Set ISTATUS for emulated timers, If timer
 expired
To: Marc Zyngier <maz@kernel.org>
Cc: Eric Auger <eauger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>,
 kvmarm <kvmarm@lists.linux.dev>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, christoffer.dall@arm.com,
 suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com,
 coltonlewis@google.com, joey.gouly@arm.com, yuzenghui@huawei.com,
 darren@os.amperecomputing.com, vishnu@os.amperecomputing.com
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
 <1a19dacc-72ca-4631-bce8-7426b3de0b47@os.amperecomputing.com>
 <86cyffrlof.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86cyffrlof.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0065.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::9) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|BL3PR01MB6980:EE_
X-MS-Office365-Filtering-Correlation-Id: 8630ab2c-3e40-404c-029e-08dd5175548d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUZaL0JLOEtjZXppUWxwWVlOZ2t0ZXR2MG5Edk5mU2Y4bi9IRHFqTnVpYVRk?=
 =?utf-8?B?WU44TUJUQ2FxaE84UWhTRmJpUVZWV3d2LzU3RllKaVpBZXltY0NBSTlCRWJB?=
 =?utf-8?B?ajRubGwwTndLc0JRNHJlMkpVUlgyRTVjVitUUW9GYktXSm1wSFhzYWkwZ0xv?=
 =?utf-8?B?YUJ5U2ZBL3lxbm55b0x1YWlsZ1R2ZWZLcmVOSWJWSitkd2dsNDROaDJ0dlBV?=
 =?utf-8?B?YWkyZkdUVG1IdG1wRllUREpodCtvTjFiYU50enlzd1lRYkljL3FjR1V3RHlD?=
 =?utf-8?B?MW1SN2NuTTBaRTZnTHJhdWNtRE1uT29BVThUUVd1NzBLNHQ4QjZBRWUxVWQx?=
 =?utf-8?B?RGN2b0xqVmZkM20zWWFyQkgzTXAxYnFvNXpFMVBXUTFLZEhTemZSMnZBdUV2?=
 =?utf-8?B?S05XdnpDdUpQSnBTOVZtVlpsWHBrZ3oyVGpuYTNlcE16c05jbEtpdGFGMzZn?=
 =?utf-8?B?RVBISXBqc3krbWdMK1U0Wkk3MGdEZmZzVisyRk1ScjdBNzkvdHFhUlFIWVRG?=
 =?utf-8?B?UWd0VWFZZFFQaVhxdmg1MUJsZGlMeFF5YmVlUlp2Z2RFTGxNSFdKNU1FbkpE?=
 =?utf-8?B?ZUk4V2FSTndUczdCTDBMTHN1ZEtBOUtKVTNPWWVjUjQ4WUJKZW1ISmZyb3Yv?=
 =?utf-8?B?ZWdOOW1jSWtQVVRFdzBNN004dys1YlNoMnl5UjFJMVRENytIVVNnZzlyZUZa?=
 =?utf-8?B?MG41TzJjY1hmQWoxcW5ybmhCdllUY3B2UkREOXBJMUhEclA4R0gwMm53WFBT?=
 =?utf-8?B?bWtSK1R2YXhhWHV1UlBQSTBocFpxYUovL0N2cHJicFpVRGN3SDBwUU01R0NB?=
 =?utf-8?B?TG1pL2lic0xENHdXS3ZnTGxwVm43Yno1NnJrSk9ERUhCNUdRWnZrVUh1UWo0?=
 =?utf-8?B?M0FZUFdUaXNheUY4NC9IKzk0TEJCV3IydVAvWitCU3BRNHdKcmwrcWl2enJK?=
 =?utf-8?B?RFViQXFaZXlIN2JLK0ZMN0kzZS9nNTRIaFdxU2hXVUJHaDRLUkd0blJnSXlp?=
 =?utf-8?B?c3Z3eDJUTGJPMzlPS3AyL1IrWVNyR00zS1htbUl6bGRMTG9jSmZtVFkyTWtX?=
 =?utf-8?B?ek44dDFvT1dGY3QrZXF5bzB6MzQ4Z2tjc3JYRjdqM3F5VnlQNW9UeTZVM2pi?=
 =?utf-8?B?RDFENzNpNEgwRjJYUHRQMmVob0VoN0E2Vldqd29yNDU1ekRjem9LdkN4cmlF?=
 =?utf-8?B?Z1JYTVFGZWNyQkk5NGgzWmpZM0pTcjR4ZVBXVTVZeW8vVURQN25zaHN6Y0dR?=
 =?utf-8?B?R1BwWGJ0QWpheUZlOTUvdlllMUxDOTZwUGtZUnFqaTltN1VoaGZvYi9wcVVP?=
 =?utf-8?B?Z1B2SzJPR2tqVExaeVJVcTJqaEU5aFN2b1cyM2V0K0ZuZUNCaWhxeHA1aUVW?=
 =?utf-8?B?cFRKTGJPbjJDaFFndnFsWEU2bDYrMjVhUHBQMVdUbURrbHppTTZvaUJFZmFM?=
 =?utf-8?B?MjZXVG9RcWRMMTc0a2xHb0x5blFmMUJTL2VRRmhnWGVieDVmQjVaS0FwSTAz?=
 =?utf-8?B?Nll6MnpwSlQ2aHRFTkZPUHE1U0ttaWhPMnlTYzIwT0pPREpXckVURERYbGU0?=
 =?utf-8?B?bkJEV0h1MFVVWHR4Smt3MW40cnRpbDQzcVZYSzNOcUtLY1kzY0xwQkl3bEE4?=
 =?utf-8?B?M1gyZ0RHelR2cFNVTFBVM0UxNVJXMHhwQ0FxU0JDRUYrRGplR2JkR1NDSEdx?=
 =?utf-8?B?MEkvNlRVdzdmRWhkcHhwVDRRUFQvbVdMWS81KzR5bWNxZGRDUE54cTQvTllL?=
 =?utf-8?B?Q2VuRUhqa2NVL3EvdVZFK3JOajUyVWk2R255YW1oM0puc0RreStKT1JVSkRw?=
 =?utf-8?B?ZXJHdmVacXRLV1NQenhMblRJV3RLMlMzWnI4eXIrc3BJU1lEVFh2M3VRRXBv?=
 =?utf-8?Q?TUVb2P7uYZRDf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3J3bzh2dUNaOTUyOXZWUGR5Ymt4bUtENXN4emtURG03NWtZdzZiZmhlQ1hD?=
 =?utf-8?B?bnlqcno2YjZwM2lQT0k2dEk0ajVtRGp3MjA3bmRrUnMzMW16MEJGbExoUStt?=
 =?utf-8?B?bHJPVnJiZndyc2hHRFljWUpUV2J3VXIwb2ZSU1hUWnFkOWxod0RmR1BWUHJS?=
 =?utf-8?B?dzhJQ0VqaUFSWHVoUDJuTkRrNDg4M05SNmY2Z3Z3QmZDN3hRaFJZb3oxY2Ji?=
 =?utf-8?B?Qm1KM3RYeTdvMHZEQWNmQzhnSE1GVFBqOHZ5Mzd5TFVGRks0OXc3c0NwTFNs?=
 =?utf-8?B?TVRhejYwa1p4YzljQWNLL0UwUnRYSXVuT05zTW9ucnZCL2JDZXhzUlo3QkY2?=
 =?utf-8?B?d1diR2wrNkdja3hkYjdYN2FxcXB5Ry9ybU12V2YzMFdpOGRFOEdlb3g4anlD?=
 =?utf-8?B?VWFpZHlpK2gwd2t1SkpQdGRla0xxSEtHR0U3cWxpUzVDMU5yUjZKKzhKUUgv?=
 =?utf-8?B?aDJuaUxucDg2NUVENzdITStkOERSeHNkeEN4WlQrTGJZVjJSeFZjd3VUUzJ6?=
 =?utf-8?B?M0o5ZHBWS3M4QjJrOVJJTnE1UDZWbElmMzlqeHBKRTZidFFwZnFTRk9mMldZ?=
 =?utf-8?B?Q25tajdJSGNMQXVvR0oxeFY3RUdPb2ZCUFpseHJidWVSdEhQL3JDd0dDM3Zl?=
 =?utf-8?B?cDFxcXVlUld6ejhndkpwbUNOYzd5UnRUWXloZHkvWW5ORkpBSzZobXJOTXdG?=
 =?utf-8?B?cjA1Ukg1WmNvVlh4ZThadktQWWpRMFBWaXUvMHlrdWpEWlR1YzlGcTFSUU43?=
 =?utf-8?B?NHRBVitSYXo0UWRqQ3lQYjF2NUtRbXZsRlp4Wmd0ZjZINjlKY3gvYXcrWmlx?=
 =?utf-8?B?MFo1TkhqSmIwblljVzNwc09oM3pJa0kxVzZRRy9kbWd5WnJ4Vk9JTDVWNmw2?=
 =?utf-8?B?MStucExCRS9ldjRYMHZ5L3NMdDZGTWlVMlFpM0lTLzMyaFRjNVkralBUdjE5?=
 =?utf-8?B?aTBaNmtlazVReUl2WUN6UjVYRVkzYXJmMTdNcnVBMG5CWjd4QXVlMHJ4UE12?=
 =?utf-8?B?WmJ5MFdJb3g2ZXAyU2ZYaEhiWEc1cG8zTUZPV0VhdXN1cEVjazl1NjdWVFZk?=
 =?utf-8?B?aU5wbmozQzF0dlVhOVczSllTQTRHNkdoVmVQdUFBeXB4TnF0RmVvZ2YvZk5S?=
 =?utf-8?B?ZGxqd29FUnYwT0dabVlmV3dKanNxdVhPRUY5SlkxMVh0QmJ5bVIvR3ZyVDgz?=
 =?utf-8?B?VlIycW5LYU9DOUMwOFEzRVdIRDVWdU5yc3ArejNPZFBVOGdZbHkvVUsvOEpG?=
 =?utf-8?B?bldEZ3FsbjdNaHpDZWFQeFJtcDNMUDMyOFJFQVZpWmVVQjlTWm9hdjNEMEtT?=
 =?utf-8?B?RUpLcHlsaEwyQXJyUEdmcGI3NUxRVGUwcGs2YXRPMUc4RkwzdWMrTE1lZmk2?=
 =?utf-8?B?MDFVbFlEOU16QnF1eGNOZktqRVdQMHQ3UDEwSmRnek1zRnAwRmdmTHdaT0Vv?=
 =?utf-8?B?N3AvNXlmNElGOTJPakk0cmR1elQ3NnN6UzBKekdvZ0JCOWlYdGI2a3dJejdu?=
 =?utf-8?B?R2hsa2xyb1R5dEhEZzBVMlRlSWV0RmdnMzBJTUFUSWJwcDhVT1VodUloQjRR?=
 =?utf-8?B?WkI3Mkgzb3VsVThSeGFhTC9BVDQrSmlFeFJ1dDY4SFQ4d0xPcVJYNHpueFVq?=
 =?utf-8?B?aVJmd0RPdnFDYlRWNFVPWVNqd0tndzJMT3JLT2hVRENlVkJPSm5iQXVLZ054?=
 =?utf-8?B?T3YrWU0xY2pDbk5FbTRMMGlHZWtubWJCSVpTOVdVV2NlRXlsU1g4WVUvcEdp?=
 =?utf-8?B?K1BTbEtJVFhybU13OVRHZzkrWmp0a0psMEpoMTBzUTFMaHNpK2ZHdlV0RStJ?=
 =?utf-8?B?cnM4K0EwSVprMEgwU2hnbzBsSDFnWWRzUDNjNFpFM3hET3VVb0wrK2lZa01O?=
 =?utf-8?B?UFpQWW9HZkU2ZEJhWDNMUHVCd2E2L3BvSGZBOGVjdkM0RDVINGlyQTV6cWVh?=
 =?utf-8?B?dXVZdzBLMzdISGlqVWpVeklOeG4xaW9YL3BuTGxMN3JoN3JsVU1McUFsZ3No?=
 =?utf-8?B?anZoOFVNeFNOcFFQMUQ4NzhtRHdRNFRoNTlKYnZMQzhZRjNsYmRvWEJJSnlz?=
 =?utf-8?B?SjduczN1N3ZoWWJOdzNiMGFqSHhmNHRFRTArYjd4TmtwZ2Zwa2xKSEllc3Fj?=
 =?utf-8?B?bjBRd3ViNHpjd0xGL2IyR0s3MzB2VTVocXYwMm1BTGI2M1ZSMXljNnQ3NDhM?=
 =?utf-8?Q?Jel7XuoYuqadkh7BEgR/eqc=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8630ab2c-3e40-404c-029e-08dd5175548d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 06:10:53.0997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cUVzbFlaHw8S/xwsnDErMoxqODCkIRGJ/eYT0x8HrzVqfmf2eBjrwOZe4Huh/mF/k8LzNb5HGcN+Lx3MyGCKzC+N5rniLPQh40y+E/YRa4sykBSXAtQj/qYly3K0fA/8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB6980



On 19-02-2025 02:54 am, Marc Zyngier wrote:
> On Tue, 18 Feb 2025 07:33:11 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>> Hi Marc,
>>
>> On 15-02-2025 11:20 pm, Marc Zyngier wrote:
>>> On Mon, 10 Feb 2025 18:26:48 +0000,
>>> Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> On 2/7/25 7:38 PM, Marc Zyngier wrote:
>>>>> On Fri, 07 Feb 2025 18:09:58 +0000,
>>>>> Oliver Upton <oliver.upton@linux.dev> wrote:
>>>>>>
>>>>>> Hey,
>>>>>>
>>>>>> On Fri, Feb 07, 2025 at 05:45:33PM +0000, Marc Zyngier wrote:
>>>>>>> I found at least one issue that could fail the migration. Before the
>>>>>>> VM starts running, we limit the feature set to the subset we actually
>>>>>>> support with NV.
>>>>>>>
>>>>>>> By doing this, we also change the value of IDreg fields that are not
>>>>>>> writable, because they describe features that we don't support.
>>>>>>> Obviously, that fails on restore.
>>>>>>>
>>>>>>> I need to have a think...
>>>>>>
>>>>>> We spoke about this a while ago (and I forgot til now), but I was
>>>>>> wondering if we could use vCPU feature flags to describe NV, including
>>>>>> the selection between FEAT_E2H0 and FEAT_VHE.
>>>>>>
>>>>>> I think this might match userspace expectations a bit more closely where
>>>>>> the state of the ID registers after init gives the actual feature set
>>>>>> supported by the VM.
>>>>>
>>>>> I'm not sure that's enough. Let me give you an example:
>>>>>
>>>>> My host has FEAT_XNX, described in ID_AA64MMFR1_EL1.XNX. For whatever
>>>>> reason, we don't allow this field to be written to, even out of NV
>>>>> context. This is odd, because for an EL1 VM, this field means nothing
>>>>> at all.
>>>> So the curprit fields for me look like
>>>>
>>>> - ID_AA64MMFR1_EL1.XNX
>>>> - ID_AA64DFR0_EL1.DoubleLock
>>>> - ID_AA64PFR0_EL1.RAS
>>>>
>>>> This is still based on your nv-next branch from Jan 9
>>>> https://github.com/eauger/linux/tree/nv_next_jan9_2025
>>>
>>> I have now pushed out a new nv-next branch with the new and improved
>>> UAPI. I expect migration to work a bit better, or at least not to
>>> explode on ID register restore. You will notice that things have
>>> changed a bit (extra flag and cap for FEAT_E2H0), but nothing really
>>> major.
>>>
>>
>> Tried nv-next branch and it is breaking(kernel Oops) for normal VM
>> boot itself with qemu. Looks like this is happening since qemu is
>> trying to write to ID_UNALLOCATED mapped registers as part of
>> save-restore of registers.
> 
> My take on this problem ends up being more consolidation, and make
> sure that the individual macros only override the default callbacks
> for idregs.
> 
> Additionally, ID_UNALLOCATED gets a name matching the architectural
> encoding.
> 

Thanks, having name helps future debugging.
While I was debugging, the register name was showing as null and I have 
to map id to encodings.

I have rebased to nv-next and looks all good!.

-- 
Thanks,
Ganapat/GK

