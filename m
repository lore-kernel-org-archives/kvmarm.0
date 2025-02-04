Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2085.outbound.protection.outlook.com [40.107.105.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC20182B4
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738678519; cv=fail; b=LyP2vdAd/jYB99J7qL1IwHvPpG6P2VVnO067r+xayoLjdPaV4GiUOPvpSgDG5KNeapq925DKwX8nIunlPKJtaEdk0jlh1kRZ1W0CdSjml7Pfp2TuXzEfhcPnolM/VdH0D2kI6LVuPk8i8nC/WQkTmVMN7WQeARBkWtI0UsyVGSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738678519; c=relaxed/simple;
	bh=61O+zvirLlmFDgKg68nhI+MdAWlkd25utZvjjWwu8DA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rfid8i+oQPy/uB3NzR1wCT1OpzbanYTAOUgOFM16yC3FrWMpuJtAmT+HIi6lbtujEO9EIM8ChlpSfZW1pqtlmLvKvh4zrdWWJpsFu20oj9L9oeSyk9YdumkM+rC2Y20f93HBZSc4V1LtA058Dlk8hT3uE4RrM2l1TucKTKuvDvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=fAmSeapg; arc=fail smtp.client-ip=40.107.105.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="fAmSeapg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=obKSU+NXW0ujJ+wX5SHHffSjnCMh/B/iTdG3YpIuicdh7RSnMA7kmRF8WTVCmGOVgfq/A20kXaOjzz4LYHa+LVcVZ+Y6M6GPKBADMmYyXPuOD8EIIp0V74acVVCnpJ78/fYo2+oBo2TQjtb07Bq8dPisSIsMKKmx1lhCtgMxH74WsksH9jYLlFdcYUUjzEBSxu+OEF+tPXclbFfmXDSqNWicPXYCONKB9gSyK6S56Xq09A2O3maa0kVX/uD/tPe6JzHEYZsXq5N48j0cfRfsGBlBlKcf8tKpQBap53CwPyvXTO1PenWMCnxmILlCrUb0nDFqKZV8e7KvKLiXcnIzeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61O+zvirLlmFDgKg68nhI+MdAWlkd25utZvjjWwu8DA=;
 b=mRsPKjH/GM9ezMBffgKALTJUoF6Z3RpyY//63sHXmKsCR8+F30osfX40ZRv25UaAitLj9/ifFsoeBalRY7WGitgTVmXkfTHlMwTlKx8pxLDlLyfAi5hBdghuNss9xAjJ7dq91r3QbTVNl5IvBHTqIarTLW1VyW+MSTl2ftciYU3sxLaSvz2g5MhqgzlxrIVyGHWg7AuPzIOVSynUfET8FJAU0UZLT607eKAHCjHvte9NsLdBLwLgPMObAmUepALuigi6KR3yOcWunwxBQkYZ1mU9zun2o9eB/mBxllh1pShf83Q2FVAh2D2gRkHbkIIPoFA2NLLxnpPDJpAgV307og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61O+zvirLlmFDgKg68nhI+MdAWlkd25utZvjjWwu8DA=;
 b=fAmSeapgmszxwjhGEvOoOxw0xfaUji4tYegHBZ+hizvNRYTCnJgwNyt3uHB6R28/wG97OLF++bk/Dq7BA17swKbmRzKkzEZzvBrjZoqahQ0nke8V3N86OUhMdXbtVtjVWj/vqa+nayKk1ejhnsQcNSWUOAg1l0cn7ScHtXqfq9GYjnjtuVpCr3e8go4tedqek5a2Bx+SpG8G/Yph4pN2tcuQ/NpsBEAmlFPh1Lc+MSdvPMp5afDl9NQkVEttC6IWpYzYraj3GJmvdJXNK0xMAq3CeI5H8XyGUdpaYEUJ2WMx0e7cYakIITiVXC+7CaOCFDS2+jeM4e2P83VgTE+30w==
Received: from AS8PR03MB9438.eurprd03.prod.outlook.com (2603:10a6:20b:5a2::12)
 by GV2PR03MB9572.eurprd03.prod.outlook.com (2603:10a6:150:da::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Tue, 4 Feb
 2025 14:15:13 +0000
Received: from AS8PR03MB9438.eurprd03.prod.outlook.com
 ([fe80::f90f:b790:a00:6803]) by AS8PR03MB9438.eurprd03.prod.outlook.com
 ([fe80::f90f:b790:a00:6803%4]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 14:15:13 +0000
From: Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>
To: Marc Zyngier <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
CC: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Volodymyr Babchuk
	<Volodymyr_Babchuk@epam.com>, Joey Gouly <joey.gouly@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/3] KVM: arm64: timer: Consolidate NV configuration of
 virtual timers
Thread-Topic: [PATCH 3/3] KVM: arm64: timer: Consolidate NV configuration of
 virtual timers
Thread-Index: AQHbcaAmVMg/TrxhSkGfvKE9yc7NQbM3OycA
Date: Tue, 4 Feb 2025 14:15:13 +0000
Message-ID: <180174bd-e6dc-4cf3-ba62-12e69dca13d6@epam.com>
References: <20250128161721.3279927-1-maz@kernel.org>
 <20250128161721.3279927-4-maz@kernel.org>
In-Reply-To: <20250128161721.3279927-4-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR03MB9438:EE_|GV2PR03MB9572:EE_
x-ms-office365-filtering-correlation-id: d9cf818d-a83b-4460-c845-08dd452657ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dkhXeXdnK2JCSThhWkszTDVRN2pWNk9TSTgvc2tpWVlObmc1Z3cxREJqZGVq?=
 =?utf-8?B?MURrMlF5MEVmNlVUNFZtQ3BsOENSWWZFU2F5L0VJTFE3QjdNOXBZbEZRYlZy?=
 =?utf-8?B?U0tLMVExUDlMWkl1Yjk0dFUyb29LNDI5NjFEbjJmc3dMK1ZPSUVBSXBtSnJJ?=
 =?utf-8?B?VG5TVG5VdUlhSzlBczE2K1ZEeDAvRHFXVHVYelVQeEhlT2NMNEE2eWIxQTg0?=
 =?utf-8?B?SnhBKy81OHkrYTBYa3Q2UlNoWDMyc2RMZjFmUUdjT1RiMFlMd0d6RTh1bUpm?=
 =?utf-8?B?bVRDdi9qOEVHMWZscmRqeG9ucTdpb3ZDZTkvcVVkNktwV3VWKytiaHlWZnRY?=
 =?utf-8?B?UkpvWUdzQzk5UHJSdVRQSkNRZG5uZG5URGFsT3ZGZStodUJidmpvOUltWXlH?=
 =?utf-8?B?SjB3V3NqakhKNzQ5aVRxQjI4ZXRRbUdVUWVvYjFhVlNQNzcwd2d6S2tyWnV0?=
 =?utf-8?B?WUdYV1gzRkVpVG02V0s1MjFEeldoZ28wU3RESXlSa3hjMlJ3MUg4R1FqVm94?=
 =?utf-8?B?ajgrMitvbVBzUDUxRVBjZnAyYkRrMDBTa1V6bUtOQVJaTk0yZzh6NjZwcCtW?=
 =?utf-8?B?M0x2bEMrVEswVkZnNmIzL1lNRytnTmxManJSZnBUNGNtZktENU8xeGFnVGM4?=
 =?utf-8?B?WEpJQllnV2FGb3Z1SERHZm9KU3Z4c1V3YTk5UWwwL1ZMK2h4cHFSNmkxZU9j?=
 =?utf-8?B?c1Uwc0hEQnlVcHZObGNaT0ZxSGtTUVZwczNnSS82VHJtMmtmZFFLSU51cmZ0?=
 =?utf-8?B?cFJ4a0FGUFRYMDgwb2M0Qi9YV1dpRVVmRU5nZS85cXdNOGU2SGZHYUZFekdU?=
 =?utf-8?B?cnN6K0NpU2Y5UWRCc25kRURCckdOcmg3aGthOGsvUHNyS0M0V2l4VUs3eUYz?=
 =?utf-8?B?MW5QU1JVSGlGNzltc1J2K0Y2WnBJdWo3QnF6am10WVpTUzdvNTlOV3BuTkJp?=
 =?utf-8?B?dGhNMXZqbFRiaTRMUWlacHZUMnQ1dG83TmhXODhjT3N2MFVSRTRhY2d3am1Q?=
 =?utf-8?B?VjlvSXUyOFI3UFdNcWh0bEpJelYreTgwOGI2MzBhMjlKczNRem1lN0ZJSFVH?=
 =?utf-8?B?dXBmQkZGYUo4Z0tGNW02NjR4TWhUMjVKY1Y0RWRqUXRGcEx6RzVIYytMK2Rj?=
 =?utf-8?B?V05aNWxSLzdiVUVoMjk5dFdBTzV1UEN1Wm1ndGJ5bXRQWVR1c1E4RkpUajhq?=
 =?utf-8?B?RDdwY2lpd0lpUnBKM2pCUjBxMkhwblRYU0hreWFNNlpTdHVKSk5XU0FRajdw?=
 =?utf-8?B?N25ReFkxdVBwNmpLNnVIVFFkN0FzOHZiSjdmMDJLUlo3QzJLc2NJbGpkODRE?=
 =?utf-8?B?dkFWdm1hVW0zQnhCRTdsSXNJS2dKQWF3NFR1YVdJV0E3eDFMc2JEWDJxNFk0?=
 =?utf-8?B?ckdiM1V2Uk91K0JWdzRtcjNxdENzYUxIbXF4R1BtQXJNUU5CL2I0VmZqd3Rr?=
 =?utf-8?B?bkVlS014N0FLc2ZHZ05tbGRwdWEvTGhzRXFMQTh1SklCZ0I0aHN0K3JHNlZE?=
 =?utf-8?B?U2I0RUl0TlBVTUV5cnA2QUR4NldMT0hUK2JLTkNSTnpVbXJrQm9wM20yUXEy?=
 =?utf-8?B?RHM0Z0lja2wzcmZqdURwK2JEMzZsTE96cFYyS1ZXZzMrU2gyeENWdmluYU1t?=
 =?utf-8?B?WFdDNHBYcHQ3akxHcExFbW9pOVE2R1NFc0x0aTljbXJtOVBraDd0RzR1dzZh?=
 =?utf-8?B?UjRSOW1QUGxHUkI1MmJvTGg0bFBEdjh1VXpIcldNNmZYSndHSHhBYTIrYzlx?=
 =?utf-8?B?Z2ExVGVhbUtEVVNZdENFUmxteFJaS3hEdWVtWGZoNFFwbkIzNFppV2NXcFR1?=
 =?utf-8?B?L0xMcE9oQ1A4SFlnRmowallTWFF1R2NDQ0dGRmtMazVwejlDSmk4amtrdzZz?=
 =?utf-8?B?UFVDNER6amJGZU9iMlRLanhkUUdoM25LOWNkbExsS0t2SDRiV0FLRnJJRjlJ?=
 =?utf-8?Q?fe7UfO/XG1JndUEJ/7fHczUS8W7nLVDr?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR03MB9438.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N1NOVUwrRGhJUFNNK2ZDcEFkMnJpNXhzdTdSY3JVMG1NK09JL3Z2K1B4ODhQ?=
 =?utf-8?B?RGhHQU4vWUJDNENHeUVTaFF2K0ZpTG5TOVJJd25LWnQ2ZXlrVFlRbVQ4Kzdu?=
 =?utf-8?B?QVU1OGJ4Z0pFaUUrdlVZVkRtSUs0SUtDcGhMQk5MbU54MmZSZzJyTm1lMTkw?=
 =?utf-8?B?TkRUZnZoVHlZTXRLZ0l0Q0JIc0d6NmNkWnM3MkNIdzQ3MDQ3LzJ2U3RZR2xo?=
 =?utf-8?B?eThSZDhDVTlQZnZNRGJVWTJUa1JzamdGY3VlMmlYbFhiditXTCtRY1g2MmZI?=
 =?utf-8?B?MzZlOHp2VUhWalJKTWRTR0l5M0p6NUEyMFBaTEF3M3dNNkVSTDRzNS8rMzVt?=
 =?utf-8?B?cExpWGQrbDhsV0JKMkNOTnV3Mk5YY1pSM0IwZElzVkhUV20wM0NXRkVZL053?=
 =?utf-8?B?MmZUZ1NYV1JlQW13cTBSd242alU1Y0pWZXNiSVkybW1YMk43T2gyYWw1RFlB?=
 =?utf-8?B?dmxuM3ZFS0dSQnZSVGMwK1J1RVNzTGhNSDdTeVVLZFhrVHB6RHRGSnJOUDFj?=
 =?utf-8?B?bEd3MmR4WnkyZUhYNnQxcFE1dm4zQmVpa3oya1RHYmRqZnFpYmlObFd3aHBa?=
 =?utf-8?B?YW9kaDlralpRZXFNclZMQzBqd2FwZEZXWE5QYm1PeDBoWmQwd1JYKzE1QjJR?=
 =?utf-8?B?YWVDK1VnWjhHa09ZMERmNlVlN0d6aGgzZFFYeWI3M2xTemw5S3N4aUFBTEVW?=
 =?utf-8?B?SDM4bzdsWXA3bUY4dUJaMHdpYXFQVURCTkhTNnY1NzgrT2w3Y1VTdVAzWlpr?=
 =?utf-8?B?VFpQN3RtWlY3SnZlVG1pTDJraWl6NGUwQzEvVGxRQ21SZHZWNEo2YmlBRklx?=
 =?utf-8?B?MGE4M1ZVR1N0TGprZHNIMm5rMkVvaXZ1Q0Mxa3ovOXFmMWtuMHI2YXM1OUZC?=
 =?utf-8?B?RkdPUjZTWCtGUEtBN2hLRnQ5b0RydzFXaDlKLzJaWndDeG81RHY4Q0RRVng3?=
 =?utf-8?B?bm9FUVQ5UmlnWkVmNjA0UzMzeXZuNWpJYzdnSEZoZzIzUkF0WDRDVkpFVUds?=
 =?utf-8?B?WWk3TFFSMzkraFN4VUJTOE93dEhROUowc3gvNmNUbnBFRFY4d2tSNHl1Zkpj?=
 =?utf-8?B?K2RjVENUMHR4M3huZkRxQ01oVmIxTEppVFFNcFJtOW9IUUUwTGJpVUhxRURq?=
 =?utf-8?B?cnlYU2NucmhaYlB2ako3L1BGTEE4Zmd1a0d4R2FOOStLTmlITG0vdk8zYzd5?=
 =?utf-8?B?ZWprTVIrQ0ZCa3N5THZQekY0LzlZZVZqSGt1UTFOc050TjBWU2I3Z3R1SUho?=
 =?utf-8?B?TlFadWVRbVVTbVIzQ1F3cENwTE5ERzJTcmZnWkJ5Y3JjMGVZK1lVRmtvSUJT?=
 =?utf-8?B?cDMvU0hNQlBnbElBYjBmSTcvMmVrMDNjUGpmczEwM01vUEZ1YmhwdkRlaU9J?=
 =?utf-8?B?TEdrUkJXU1cxUTZQSkZLb1lwSkdGSmVBTjZ3ZmVhRVlZTC9vWVhBR3ZqUjlZ?=
 =?utf-8?B?WHYydC9pdE5Gcy8rVFpjNVI4UHlVNGxtQWhmUE5xUS9ZN0pkMTlacDBITEQ3?=
 =?utf-8?B?WkpJTE5uT3pvQ21zZG5yVUprY1lER1FGMERoNXNnelVjREJoZ21kR1kwMGlY?=
 =?utf-8?B?ZU5sT3gvcU93bkxHTW5GM2JvY01lZWhSSEVQRkNpWHYyRTI4M3oyd1NFMUxz?=
 =?utf-8?B?Rm5Cd2kzTFJtWVFudFFsTGtKc3VYaFVzY1MzUklGc2hCbkVlQmVsKy9kUVo2?=
 =?utf-8?B?dFRIcTlmWW92MkJhVFRId1BJOHlvOXhuR2UyeUJJQWlwSVQ3MHdyMTlWWHdR?=
 =?utf-8?B?UU1EeG9Xa09nWFJOQjFHTFpCQnN6SkhHZStwZXNYQmVlN1pQVDhaaksxQjhs?=
 =?utf-8?B?L003eE1aK3FYUkJQZU9STnpVaHRNWVMrKzg3bkpzeGx1ZlBKMGNLRkRoM0Zj?=
 =?utf-8?B?dm1sTE9IL2ZYTlpXMC9vUEVvN1RUYUppNEdqcUlDN2NtYkdSbFRsQWp2Qm0z?=
 =?utf-8?B?NWY3c0lUZThDYjBIckpPVFRxbW00MVpMTWdLTUowUEljbXdvUjNVUUs4b1BE?=
 =?utf-8?B?bGFMK2FVUjBKNkdncWxjckNaYTh0elFLYmhmbEZzQklCWVZHZlhZVzRiRW9J?=
 =?utf-8?B?Szd0ZGFFNVdMT3BsWlVJWnEwV1FLR0wvYU43ZUZkbUJBTVhqNzVwRHlSOXhx?=
 =?utf-8?B?VzY0TnBZcERYNDAxMnZOS2JZUXQ0SDBQVWhNdDEwQWM0TFd5RG9XTEYxREpB?=
 =?utf-8?B?T2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B1B657F76C21B4ABCCE46BF290F07E9@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR03MB9438.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9cf818d-a83b-4460-c845-08dd452657ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2025 14:15:13.8188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zw6X9Vs9fV6j3wQDy4PYpSYv5wz4Pmfx1iWdEPm5bzQwxuB2kuyczG74MfWav5BddaGO25Qy/Z4qOhabt21QGFiN1z/Nt5ZpckuxGg4ZTVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB9572

SGVsbG8sIE1hcmMuDQoNCk9uIDEvMjgvMjUgMTg6MTcsIE1hcmMgWnluZ2llciB3cm90ZToNCj4g
VGhlIHdheSB3ZSBjb25maWd1cmUgdGhlIHZpcnR1YWwgdGltZXJzIHdpdGggTlYgaXMgcmF0aGVy
IG9kZDoNCj4NCj4gLSB0aGUgRUwxIHZpcnR1YWwgdGltZXIgZ2V0cyBzZXR1cCBpbiBrdm1fdGlt
ZXJfdmNwdV9yZXNldCgpLiBXaHkgbm90Pw0KPg0KPiAtIHRoZSBFTDIgdmlydHVhbCB0aW1lciBn
ZXRzIHNldHVwIGF0IHZjcHVfbG9hZCB0aW1lLCB3aGljaCBpcyByZWFsbHkNCj4gICAgYml6YXJy
ZSwgYmVjYXVzZSB0aGlzIHJlYWxseSBzaG91bGQgYmUgYSBvbmUtb2ZmLg0KPg0KPiBUaGUgcmVh
c29uIGZvciB0aGUgc2Vjb25kIHBvaW50IGlzIHRoYXQgdGhpcyBzZXR1cCBpcyBjb25kaXRpb25u
ZWQNCj4gb24gSENSX0VMMi5FMkgsIGFzIGl0IGRlY2lkZXMgd2hldGhlciBDTlRWT0ZGX0VMMiBh
cHBsaWVzIHRvIHRoZQ0KPiBFTDIgdmlydHVhbCBjb3VudGVyIG9yIG5vdC4gQW5kIG9mIGNvdXJz
ZSwgdGhpcyBpcyBub3Qga25vd24gYXQNCj4gdGhlIHBvaW50IHdoZXJlIHdlIHJlc2V0IHRoZSB0
aW1lci4gSHVoLg0KPg0KPiBTb2x2ZSB0aGlzIGJ5IGludHJvZHVjaW5nIGEgTlYtc3BlY2lmaWMg
aW5pdCBmb3IgdGhlIHRpbWVycywNCj4gbWF0Y2hpbmcgd2hhdCB3ZSBkbyBmb3IgdGhlIG90aGVy
IHN1YnN5c3RlbXMsIHRoYXQgZ2V0cyBjYWxsZWQNCj4gb25jZSB3ZSBrbm93IGZvciBzdXJlIHRo
YXQgdGhlIGNvbmZpZ3VyYXRpb24gaXMgZmluYWwgKG9uIGZpcnN0DQo+IHZjcHUgcnVuLCBlZmZl
Y3RpdmVseSkuDQo+DQo+IFRoaXMgbWFrZXMga3ZtX3RpbWVyX3ZjcHVfbG9hZF9uZXN0ZWRfc3dp
dGNoKCkgc2xpZ2h0bHkgc2ltcGxlci4NCj4NCj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVy
IDxtYXpAa2VybmVsLm9yZz4NCg0KDQpUZXN0ZWQtYnk6IERteXRybyBUZXJsZXRza3lpIDxkbXl0
cm9fdGVybGV0c2t5aUBlcGFtLmNvbT4NCg0KDQo+IC0tLQ0KPiAgIGFyY2gvYXJtNjQva3ZtL2Fy
Y2hfdGltZXIuYyAgfCA0OCArKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4g
ICBhcmNoL2FybTY0L2t2bS9hcm0uYyAgICAgICAgIHwgIDMgKysrDQo+ICAgaW5jbHVkZS9rdm0v
YXJtX2FyY2hfdGltZXIuaCB8ICAxICsNCj4gICAzIGZpbGVzIGNoYW5nZWQsIDI1IGluc2VydGlv
bnMoKyksIDI3IGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0v
YXJjaF90aW1lci5jIGIvYXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jDQo+IGluZGV4IGU1OTgz
NmUwMjYwY2YuLjQzMTA5Mjc3MjgxYTcgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2Fy
Y2hfdGltZXIuYw0KPiArKysgYi9hcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMNCj4gQEAgLTc1
OSwyMSArNzU5LDYgQEAgc3RhdGljIHZvaWQga3ZtX3RpbWVyX3ZjcHVfbG9hZF9uZXN0ZWRfc3dp
dGNoKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gICAJCQkJCSAgICB0aW1lcl9pcnEobWFwLT5k
aXJlY3RfcHRpbWVyKSwNCj4gICAJCQkJCSAgICAmYXJjaF90aW1lcl9pcnFfb3BzKTsNCj4gICAJ
CVdBUk5fT05fT05DRShyZXQpOw0KPiAtDQo+IC0JCS8qDQo+IC0JCSAqIFRoZSB2aXJ0dWFsIG9m
ZnNldCBiZWhhdmlvdXIgaXMgImludGVyZXN0aW5nIiwgYXMgaXQNCj4gLQkJICogYWx3YXlzIGFw
cGxpZXMgd2hlbiBIQ1JfRUwyLkUySD09MCwgYnV0IG9ubHkgd2hlbg0KPiAtCQkgKiBhY2Nlc3Nl
ZCBmcm9tIEVMMSB3aGVuIEhDUl9FTDIuRTJIPT0xLiBTbyBtYWtlIHN1cmUgd2UNCj4gLQkJICog
dHJhY2sgRTJIIHdoZW4gcHV0dGluZyB0aGUgSFYgdGltZXIgaW4gImRpcmVjdCIgbW9kZS4NCj4g
LQkJICovDQo+IC0JCWlmIChtYXAtPmRpcmVjdF92dGltZXIgPT0gdmNwdV9odnRpbWVyKHZjcHUp
KSB7DQo+IC0JCQlzdHJ1Y3QgYXJjaF90aW1lcl9vZmZzZXQgKm9mZnMgPSAmbWFwLT5kaXJlY3Rf
dnRpbWVyLT5vZmZzZXQ7DQo+IC0NCj4gLQkJCWlmICh2Y3B1X2VsMl9lMmhfaXNfc2V0KHZjcHUp
KQ0KPiAtCQkJCW9mZnMtPnZjcHVfb2Zmc2V0ID0gTlVMTDsNCj4gLQkJCWVsc2UNCj4gLQkJCQlv
ZmZzLT52Y3B1X29mZnNldCA9ICZfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBDTlRWT0ZGX0VMMik7DQo+
IC0JCX0NCj4gICAJfQ0KPiAgIH0NCj4gICANCj4gQEAgLTEwNDUsMTggKzEwMzAsNiBAQCB2b2lk
IGt2bV90aW1lcl92Y3B1X3Jlc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gICAJZm9yIChp
bnQgaSA9IDA7IGkgPCBucl90aW1lcnModmNwdSk7IGkrKykNCj4gICAJCXRpbWVyX3NldF9jdGwo
dmNwdV9nZXRfdGltZXIodmNwdSwgaSksIDApOw0KPiAgIA0KPiAtCS8qDQo+IC0JICogQSB2Y3B1
IHJ1bm5pbmcgYXQgRUwyIGlzIGluIGNoYXJnZSBvZiB0aGUgb2Zmc2V0IGFwcGxpZWQgdG8NCj4g
LQkgKiB0aGUgdmlydHVhbCB0aW1lciwgc28gdXNlIHRoZSBwaHlzaWNhbCBWTSBvZmZzZXQsIGFu
ZCBwb2ludA0KPiAtCSAqIHRoZSB2Y3B1IG9mZnNldCB0byBDTlRWT0ZGX0VMMi4NCj4gLQkgKi8N
Cj4gLQlpZiAodmNwdV9oYXNfbnYodmNwdSkpIHsNCj4gLQkJc3RydWN0IGFyY2hfdGltZXJfb2Zm
c2V0ICpvZmZzID0gJnZjcHVfdnRpbWVyKHZjcHUpLT5vZmZzZXQ7DQo+IC0NCj4gLQkJb2Zmcy0+
dmNwdV9vZmZzZXQgPSAmX192Y3B1X3N5c19yZWcodmNwdSwgQ05UVk9GRl9FTDIpOw0KPiAtCQlv
ZmZzLT52bV9vZmZzZXQgPSAmdmNwdS0+a3ZtLT5hcmNoLnRpbWVyX2RhdGEucG9mZnNldDsNCj4g
LQl9DQo+IC0NCj4gICAJaWYgKHRpbWVyLT5lbmFibGVkKSB7DQo+ICAgCQlmb3IgKGludCBpID0g
MDsgaSA8IG5yX3RpbWVycyh2Y3B1KTsgaSsrKQ0KPiAgIAkJCWt2bV90aW1lcl91cGRhdGVfaXJx
KHZjcHUsIGZhbHNlLA0KPiBAQCAtMTEwMiw2ICsxMDc1LDI3IEBAIHN0YXRpYyB2b2lkIHRpbWVy
X2NvbnRleHRfaW5pdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGludCB0aW1lcmlkKQ0KPiAgIAl9
DQo+ICAgfQ0KPiAgIA0KPiArdm9pZCBrdm1fdGltZXJfdmNwdV9udl9pbml0KHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkNCj4gK3sNCj4gKwkvKg0KPiArCSAqIEEgdmNwdSBydW5uaW5nIGF0IEVMMiBp
cyBpbiBjaGFyZ2Ugb2YgdGhlIG9mZnNldCBhcHBsaWVkIHRvDQo+ICsJICogdGhlIHZpcnR1YWwg
dGltZXIsIHNvIHVzZSB0aGUgcGh5c2ljYWwgVk0gb2Zmc2V0LCBhbmQgcG9pbnQNCj4gKwkgKiB0
aGUgdmNwdSBvZmZzZXQgdG8gQ05UVk9GRl9FTDIuDQo+ICsJICoNCj4gKwkgKiBUaGUgdmlydHVh
bCBvZmZzZXQgYmVoYXZpb3VyIGlzICJpbnRlcmVzdGluZyIsIGFzIGl0IGFsd2F5cw0KPiArCSAq
IGFwcGxpZXMgd2hlbiBIQ1JfRUwyLkUySD09MCwgYnV0IG9ubHkgd2hlbiBhY2Nlc3NlZCBmcm9t
IEVMMSB3aGVuDQo+ICsJICogSENSX0VMMi5FMkg9PTEuIEFwcGx5IGl0IHRvIHRoZSBIViB0aW1l
ciB3aGVuIEUySD09MC4NCj4gKwkgKi8NCj4gKwlzdHJ1Y3QgYXJjaF90aW1lcl9vZmZzZXQgKm9m
ZnMgPSAmdmNwdV92dGltZXIodmNwdSktPm9mZnNldDsNCj4gKwl1NjQgKnZvZmYgPSBfX2N0eHRf
c3lzX3JlZygmdmNwdS0+YXJjaC5jdHh0LCBDTlRWT0ZGX0VMMik7DQo+ICsNCj4gKwlvZmZzLT52
Y3B1X29mZnNldCA9IHZvZmY7DQo+ICsJb2Zmcy0+dm1fb2Zmc2V0ID0gJnZjcHUtPmt2bS0+YXJj
aC50aW1lcl9kYXRhLnBvZmZzZXQ7DQo+ICsNCj4gKwlpZiAoIXZjcHVfZWwyX2UyaF9pc19zZXQo
dmNwdSkpDQo+ICsJCXZjcHVfaHZ0aW1lcih2Y3B1KS0+b2Zmc2V0LnZjcHVfb2Zmc2V0ID0gdm9m
ZjsNCj4gK30NCj4gKw0KPiAgIHZvaWQga3ZtX3RpbWVyX3ZjcHVfaW5pdChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpDQo+ICAgew0KPiAgIAlzdHJ1Y3QgYXJjaF90aW1lcl9jcHUgKnRpbWVyID0gdmNw
dV90aW1lcih2Y3B1KTsNCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FybS5jIGIvYXJj
aC9hcm02NC9rdm0vYXJtLmMNCj4gaW5kZXggMDcyNWEwYjUwYTNlOS4uZGViNzRhYjU3NzVhYSAx
MDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vYXJtLmMNCj4gKysrIGIvYXJjaC9hcm02NC9r
dm0vYXJtLmMNCj4gQEAgLTgxNSw2ICs4MTUsOSBAQCBpbnQga3ZtX2FyY2hfdmNwdV9ydW5fcGlk
X2NoYW5nZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICAgCWlmIChyZXQpDQo+ICAgCQlyZXR1
cm4gcmV0Ow0KPiAgIA0KPiArCWlmICh2Y3B1X2hhc19udih2Y3B1KSkNCj4gKwkJa3ZtX3RpbWVy
X3ZjcHVfbnZfaW5pdCh2Y3B1KTsNCj4gKw0KPiAgIAkvKg0KPiAgIAkgKiBUaGlzIG5lZWRzIHRv
IGhhcHBlbiBhZnRlciBhbnkgcmVzdHJpY3Rpb24gaGFzIGJlZW4gYXBwbGllZA0KPiAgIAkgKiB0
byB0aGUgZmVhdHVyZSBzZXQuDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2t2bS9hcm1fYXJjaF90
aW1lci5oIGIvaW5jbHVkZS9rdm0vYXJtX2FyY2hfdGltZXIuaA0KPiBpbmRleCA2ODFjZjBjOGI5
ZGY0Li4zNTE4MTMxMzNhZWY2IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2t2bS9hcm1fYXJjaF90
aW1lci5oDQo+ICsrKyBiL2luY2x1ZGUva3ZtL2FybV9hcmNoX3RpbWVyLmgNCj4gQEAgLTk4LDYg
Kzk4LDcgQEAgaW50IF9faW5pdCBrdm1fdGltZXJfaHlwX2luaXQoYm9vbCBoYXNfZ2ljKTsNCj4g
ICBpbnQga3ZtX3RpbWVyX2VuYWJsZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiAgIHZvaWQg
a3ZtX3RpbWVyX3ZjcHVfcmVzZXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4gICB2b2lkIGt2
bV90aW1lcl92Y3B1X2luaXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4gK3ZvaWQga3ZtX3Rp
bWVyX3ZjcHVfbnZfaW5pdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiAgIHZvaWQga3ZtX3Rp
bWVyX3N5bmNfbmVzdGVkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ICAgdm9pZCBrdm1fdGlt
ZXJfc3luY191c2VyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ICAgYm9vbCBrdm1fdGltZXJf
c2hvdWxkX25vdGlmeV91c2VyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7
