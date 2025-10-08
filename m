Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A66E4437A
	for <kvmarm@lists.linux.dev>; Wed,  8 Oct 2025 09:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.86.201.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759916773; cv=fail; b=dRpgQahpGQw9Ue8+3Psbz/qgQoTGUp97hmVgjxQvHcYrqc57hf2UUQW9h4FrTpCCE4LclHLvSsNwE1dHIndopHkxD9Is1Z3PO3+UWKLEAZwzfnjM2Yb5++pWSvhGA9CRehEgBxqm8Q+rgHA3uxWbC+ZFnBekXshWG4jximIoF/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759916773; c=relaxed/simple;
	bh=h/VZ3XIKMAaZ4vA0zAuVRW84aWrNY2tdUaonJrB+srk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KcOSWVQQSYaXO89/bnrnKh0gL6hq7+4e/gCZOyByoeTDMERlaBi1TfAyC80Vx+ktC4imTETkWu7Zl4FVVocY1fKDcXNHBn09JpiYaxyV3BS3lY9NmOmVrD8+iPYt6436GRQR+/LuHvAl49CzbrkEYTEgezZWfGZNVhRGUNbikOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=N0ka3OD/; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=fdCZaJ4f; arc=fail smtp.client-ip=208.86.201.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="N0ka3OD/";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="fdCZaJ4f"
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
	by mx0b-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5982mKjd004777;
	Wed, 8 Oct 2025 02:45:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=h/VZ3XIKMAaZ4vA0zAuVRW84aWrNY2tdUaonJrB+srk=; b=N
	0ka3OD/lLaaba1N1j/xSDTYgLbRpZVEh97yCNb+MbSB/jetGxrwHUl+wY5YswBDW
	PBSsq3pdKQ4nb5ZQqO9Vu36113uFx0UNImvvTuNiOPsE3PyZxd7n6x/+5pFurAxJ
	7yaAvC6DbP/YUPPxrMHwo9rvaj8XgB3vH2DgUxvnTOhddtP4K3xfsLp3fnehZy+a
	g8ja2A8B46PdTOB2JDiPvE1KhNRYyKrpAO+WCznrE143C9Sxzc8Xem+r/Qzb//jf
	Qji4i/1TKWLLbIl3cq4OxCBKfVkQuWfviraeNWFE1CT8PafcoftTaRCuo4K9JUHm
	P2kL700JlqlCAhZCeONTA==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021126.outbound.protection.outlook.com [40.93.194.126])
	by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 49m986vp59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 02:45:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=djOtI9/jF+xyFBayh5whij55xY2hw/PON8Cx7mnalu4Aoktb0/n0i92uc4eR3yca6ohYUSYa+fL0v172LfanUtUmjs3F45Bt0rislwAO8eZZDyx5MIl/oJMNDb3huoiwpaRNBTh92Wj3QsNXRugn622gOzn+Smy3JtkbI3AdNsUFQ8W/Znn5/ecvM+y1MUzhCtRlqvXKzBuhni7+ehoE0MAENtyra943nxZO/N1aMF82lZIQwIvGDUxts/As99Vf8zZ3edXtmKBCgK8KJE4wzSRhWwCsniumU/bVpuYkyRIufSSFt+NISIZIT+7rbofnKcfQBQgV4obB60xFLWSguQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/VZ3XIKMAaZ4vA0zAuVRW84aWrNY2tdUaonJrB+srk=;
 b=F6mkMRjP97hFhjldMcEC/CBiM706f1EmIGuZA8ae3b7YUJ4O8gWpecMOS5xtO8UI6PxOC8me9IqaBxbT6jwpSFAmj7ms1LDNeyBst4I3WURZNo1/q6a2EBXI1iUowvm/YQRIaVy6fqtsvrCoL3pSyURJ3wJ4sAW23/E2avHuEsj1a6PLxKT6gkLTq4JxMDAg1sGrRMuJwTw0lrhQ+Xsf2/gE6eWw2cunHUO6T2q2JqO8Hl4gI1A5OlSHjypj7d7GyVPU5iuAL5l/TDwPRKrHidjLEYDFiCthxYUl+xYsGhhnSIdRtPGdf3bDSLrS5WSb93gfMvKc0c2LjojnimDi1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/VZ3XIKMAaZ4vA0zAuVRW84aWrNY2tdUaonJrB+srk=;
 b=fdCZaJ4fQIBLU6TMfXQe90ikntZ4iS5lGedZSwBB+eBfYxk7nYifbfhAS/TkaeQYugUpJTE8Os2oxYGEaSJHzKtbxPrphgBIsdvQ/wBjQKfar6/c1Y4kNaF4XOSGKrbIVVzhr+6LQ1eRHtw3cyEiSMIJD3wuP+GY3lNiKZEo30w=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by CO1PR07MB9019.namprd07.prod.outlook.com (2603:10b6:303:162::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Wed, 8 Oct
 2025 09:45:51 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 09:45:51 +0000
From: Jan Kotas <jank@cadence.com>
To: Marc Zyngier <maz@kernel.org>
CC: Jan Kotas <jank@cadence.com>, Oliver Upton <oliver.upton@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: KVM NV + SVE host OS warning
Thread-Topic: KVM NV + SVE host OS warning
Thread-Index:
 AQHcLiUKR+wB9cgAPkys8N+jKyIMXLSj98IAgAAI7YCAAAb+gIAAeJmAgBIZ7gCAAM0NAIAAdwsAgAAP94CAACEnAIAABOgA
Date: Wed, 8 Oct 2025 09:45:51 +0000
Message-ID: <677A529C-B3D7-4BD1-BEED-D8414D961BBD@global.cadence.com>
References: <799DD5E5-8BC2-47B3-A919-33429D3FB2F1@global.cadence.com>
 <865xd61tt5.wl-maz@kernel.org>
 <F9556C9F-2671-4EF6-A725-D080C3793A34@global.cadence.com>
 <864isq1r66.wl-maz@kernel.org> <aNXGW8C_S1TbFR9-@linux.dev>
 <25C5E00D-62BC-4188-8642-21913446B32C@global.cadence.com>
 <aOWhlvC1kROWfMSv@linux.dev>
 <1271032F-41BB-4896-AAED-8660D5459E7D@global.cadence.com>
 <E2FD1CD0-AE1F-4F9C-86FF-D576C212832B@global.cadence.com>
 <864is9zqs9.wl-maz@kernel.org>
In-Reply-To: <864is9zqs9.wl-maz@kernel.org>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|CO1PR07MB9019:EE_
x-ms-office365-filtering-correlation-id: 5d767efd-bdb2-4966-01a9-08de064f77c4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eWVHbkowbC9qWThLVU9CVnRId3ROLzkxY1pwbzROcFQ4enE4ekEzeVdjV2k4?=
 =?utf-8?B?NC9CY0JZOFpLeE1rYThyR3U0enNUOGdoVks5YXczZFZNUDk0TERKTzZzSU4w?=
 =?utf-8?B?eHRrKzU5VzFsVXhoRUVvamNhMjdrNFprNzBGdkp4TjJJTnV4NGg0ZlBkaVgx?=
 =?utf-8?B?L0V5QUQ5SGhoUVJPSTdvZm81OFJxVnhHcTlVZkplVzZtaFFSelVITzdWeGEx?=
 =?utf-8?B?K0x4LzNBMmdaRFZGbG1PQU1xL1ZsM1pzLzBHcFU5Tm0xMDdvTmk4bWk3REVx?=
 =?utf-8?B?WFpROXl3NGg2ekNUWkEzN0dKOXlsc2RPbkcrZDluaTN2MFphTHBQV1Vtb0xp?=
 =?utf-8?B?bFpvMFV4b1RReG5ZeXJYejd4MER6ZjNlSnBlWEZQSXIrY3hSQlhaZTJVSlVi?=
 =?utf-8?B?eGdJZGFOb25KNFJQUHRQTDQ4V1JiNTlSYThpaHQrZEs0czZNZDFxOE9oMDYv?=
 =?utf-8?B?YytBNDVHM3lieUFRS3h2QTNnUm5XZUdCd3d3VUVPRUpsWWJQdkk5dHZMMGpH?=
 =?utf-8?B?MUdBeExCOUNlL0g5UnM4dEgveHBGZ1czb2x1V0UwNFJjbXI0eDZnTmEwKzVh?=
 =?utf-8?B?Q0Y3ZXVwRXhBZ0VFWnRUZUtOTHhHamlrL3I5bDJFcm9VdGMweHQrdUxSNGxH?=
 =?utf-8?B?bkNEUmxJSE43NlY4QUNUYkNjNmRJa1JzTjBlZTZHNllqTytIdkNXU3RZaEpX?=
 =?utf-8?B?OXFVNFErL1doWnRHQ3h4dm9sTGRySEY4MVFlTHU0N0RWYjNCZzFqUWRRTCtR?=
 =?utf-8?B?Wmd5REFPa3pHczlBU3d2c1JWR3NWbXRTL0d2ZzBCaTk3SHUyKzgxVUtNbThT?=
 =?utf-8?B?Qk9FRnZJdk1YV2k4bU52UGpQOXhtLzk0akR2ZjVnTTc2TmpVN2VQVmY0K2Uw?=
 =?utf-8?B?bm9pVVc5eXMxMGY3S2MvWUlPRjkzL2grVkNUMzdpSjFlQkhrNXRmdG5Gakc5?=
 =?utf-8?B?aEZrQUF1S1NqWVZBR0lER0Nad0dBNm5yZlBrMyszQm9EVDVlRmVDQW85UEZI?=
 =?utf-8?B?WDdxdEFOZXhycEpJNEdYalMyZUNkSldLMDhlRzBBWHlJeUt4dDZkdXpZb2pv?=
 =?utf-8?B?dHpTMi96M2E2N1JXNFMyR2JUY3FiZExzNG8zRnUvdlNtaU9xRnJaOGV3UUM0?=
 =?utf-8?B?YlF0WHo5eEpyV2xIQi8wRFNZVU5UQURrYk9TU0czamV5VnMxeE9Ob3k3VTNO?=
 =?utf-8?B?V3k3U1A3Z2R3V3RmTHZtQWgyMmN5TGZQcEZYczhsd2JySmlZYys0b012a0RL?=
 =?utf-8?B?dHFpaFIxUTBTOUZpbFMrdTI4N2EwOFZxY0RNOVEyb2Uwc0xYZHRjSmtrUDZS?=
 =?utf-8?B?L2lQRHAxejM1RVNDRjl3QmlLN0I5aStmMElIWENFemZkTXNjL1A0Q0pPeDBG?=
 =?utf-8?B?bHF5Yk9vT3preGJ4WXVobCs4WUZ4M3ZSN1psSzJBSmMrRmtKL0s3WnE0Z3hv?=
 =?utf-8?B?OTgzL2JEdXJidFJBT0NxL0JTVVYzeUhFb3Nzek9FRkloL0tOMituN01JZDlL?=
 =?utf-8?B?MUVyeU1meGFLMWppR2NpZE1ic0tVREttK1pvN0pNU05kb0U1Z08zd2ppdjVn?=
 =?utf-8?B?Uk9XeWlMZnVWWW1OeXVEbzNVT0pXdFczYzlGSE05YzEvaHByTGMwTTNvTmQ4?=
 =?utf-8?B?cGwyc2RzRnFnMm00ZHloUVpaRVZ3RnJDQUY5ZWZpWDk4QWpDMG9lbFFYbzJt?=
 =?utf-8?B?Q0daQkhCYjJDTlI3bFZsbVNNNWMycGk2QVBFK2RxZDZ3SmovSUVoWFIvb3c5?=
 =?utf-8?B?MHJPUlJ6ZkE3MFhhYmN1SjU1dVBtU1BQTGxuMmltaytBUURNS3pQaGVnODFG?=
 =?utf-8?B?UkR6bnNKRUJrTStvQmtpOU43RWZER2loV0pVaDVSc0VyYWNzemxaTjQ4TUJq?=
 =?utf-8?B?Unh6dWJDS0VDMjFqRC9SWDJoMFNjRVFiOTY5TFhTVUpmcGUzUHJtSGYxd2lh?=
 =?utf-8?B?eHZEM0FiNyt1Sjc2ZTNBNnAvajdHWU52bUVaL2JUbFpxWlNzUk9zUHRoQlVW?=
 =?utf-8?B?RWoremZZWTlTT0FMcXZsVk9CYWhYa2M1cWFQZFp6WGpYb1BTMkgvazVBWkxL?=
 =?utf-8?Q?+HBNva?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T1BUbTVtT3QyQU04M0FzcGhPa3FlQjNjalpHbTFBZ3lIVUJaRDIyYTVxSzlW?=
 =?utf-8?B?NG9xNUNhT0ZMbCtleDlCVUhGZG8yMVV5a1M2WFFWeUN0SE1ocXViR1kzZnV4?=
 =?utf-8?B?bmJjWEtQTXFtUHU1WHZ1R1I1aTM4QktuL0ZvK3pTeHhmUzVsWnUvUnNTUE52?=
 =?utf-8?B?N2RDT1BYVnZQVVdOV0NxSDJ3a1Rab1FuY1dBeEhIOEUrNDk5R3BXVmZzSmNk?=
 =?utf-8?B?NXF6eEkrTm8xTjFMZmN3TytTMm52cFdjN0NjZkdTOUNqMTN2ZEJpa1g5K01a?=
 =?utf-8?B?N3kxd0dpZDVlTTVPTHpOdlV5MjRHVy90NHVoOVJOVUhtcTNPWmc5V1NlaTBa?=
 =?utf-8?B?NDNDMEpFZG9OV1I2Sm51QVFLNzBhcm1SdWdxTjM4OG9Qd3VHTnVFY1BjbGFW?=
 =?utf-8?B?RHJIa3E3ek9IajRQckpVMURycEpxbEkzVjJEWDd2UFRMMWJhWlFVQ3E5enpN?=
 =?utf-8?B?YUVzMzhMbE1hVmxPNUJOeXRRRlp1endHK0lzbGlTVHNBdXdvWkQxYTlEN2h0?=
 =?utf-8?B?WjhFSEpQanZRU2lqczhPb0pqTmJZYnoyN3dtNDRlZ0gzM3U1WTdoKzBYTy9R?=
 =?utf-8?B?ZG1QUlgxOS93UFVrQ0tIeTFjcDFCWk5SdG9WTjNTcDhGYnhJakVvZTRWYkZI?=
 =?utf-8?B?eHhMa3p0VkJEeUpqck0vY0NVYUVnblpKcWtoajRTeDJGUnRHcjVjL0k3K213?=
 =?utf-8?B?VWpFYjBlN1RCcEVQczFkSkpGTEg2QVAxdkl4WFNGcHZBb1hkVTlBdU0zTHkz?=
 =?utf-8?B?R2NUT3RYWmNhVTMvSE5JRTYzTXlzeTE2dVFiWllzdlJTMnM1NW1EcGVnWEox?=
 =?utf-8?B?L2dycWFVTU9qc3Z2ZnRYWXdpOXJqM3k2Nmd3STRrSmpGeUdlQzFFSW1Scm8y?=
 =?utf-8?B?TEU5dVArVk1uZE01VlVyYWVDU2JTdUUxZDg5eDlXMGNuUTNPTG84RjdUY3R5?=
 =?utf-8?B?b2x2cTdyNHZ4S3pIczJaYVRGQmQvR1greVBqcXdoNTVTc2VLVzJTQVY4aWFO?=
 =?utf-8?B?ZmxJL2dzY1M0NS9OdVQ4K3RoL0xKeDZvL1VlSXo5M2Q2NEJjYm1UcXRQdFlJ?=
 =?utf-8?B?RkVxLzNYWVpqM3BmQ2JiUDh4UWRWMjJ3NHJmRTFFd2gvTjZjTHhldzVZTzY4?=
 =?utf-8?B?d2JxQzVtSlVoSzdiUzEwOC9EUWtYY0RDYU9EZ0s0aDlIeWd1YlZaNU5YSDF0?=
 =?utf-8?B?OWdJaU9xcktHYkJPT3ZHenVGdnd3UE1qUUgzV21VV1lUU1IrbnVJd0EzNFJo?=
 =?utf-8?B?ZFBSWGVoZXdrK3l6c0drRnFTVitGU1JILzFGWVo1QzlIbGt4enF5VmpKbVc2?=
 =?utf-8?B?YmVORFh5TTVSNFQzbnVHeWFyaVltYlNidDJ4YkNpbHlqTXZSMUVScklFNmhS?=
 =?utf-8?B?TUlWRDBIbkYydit6UUxPcXFaaG00VXVPdHRrcjNVM0RjT2c1RjVkcDVQVGMx?=
 =?utf-8?B?ZkRmczNuOGFnWk1DeEREWS9RNGhRSG9SRjY2ZlkxNnhHY000YnEwYjdwSGN5?=
 =?utf-8?B?VFhOWkdKcUg5YytPTzhRdFRKemtTUGZ3d29UODZHMlNmUlJySTN4NlhKajV6?=
 =?utf-8?B?bW1RUmcxbWJEWHE2bEhVZWpGNEZiWGU3QTdTRVRNQVRlUHRSYVJJZnBvZzNi?=
 =?utf-8?B?QUl0TjBSRFhHdzhkK2tzQUpMdEZLenVrcCtaOTNnUVZDQVp3dko4cXpzVHdU?=
 =?utf-8?B?VnBEZGQxT0JEMW8rN1ZtWStYcUFsSUFldEx6Tk5UQXpDREVEQ2NQc0V3SGNO?=
 =?utf-8?B?dDEwSW93UXh4WkpBT21zakphNU1NcjJOaHVDVVIzZEd5MWR6Y2JKaHhGR1NV?=
 =?utf-8?B?bnlkV0grWUpDRDkwU1VWS3ZreVFxdTM2dVIyMUVDVjZGdjI5VHRCMGlpbHVj?=
 =?utf-8?B?MzFwaURodkNBSVMxQzdOMkhiT3BVbjRHT3lhNnFwcEI4MEkvckJSVkl0VUg0?=
 =?utf-8?B?dlJSOFhYV3JCcWRkYmZnMmdwRTVVZDVzNWNqNkc3ZDFZRm9YamxSc2RhM1NK?=
 =?utf-8?B?VHVUOG5sVUs4RFc3dUpGdHE3L01GelZxMFVhVTFKTTdMTElCMEpQUUd5LytO?=
 =?utf-8?B?ekwzUE83aWVWUlkrZmxHWWFWQTZZRWw3c2dFcFppN1UvaC9BTnV5WThtd1cz?=
 =?utf-8?B?YmRxMjV6Y3JLRExwREpITWhQSXgrc2hLS3BYKzdNQjRtSW1aYmZhWFFGVmtK?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FFEC6B2B717CA4CA6A3BAD91CACDF0B@namprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR07MB9604.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d767efd-bdb2-4966-01a9-08de064f77c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2025 09:45:51.4239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gffVoNqsB5e0LumjfbdSt+EwPOJwSZosqoClQhCD3r72euLhMN88pFaI8sqNjlxYu8ZA2nGjLvFU5OQMWADWow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR07MB9019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDA1NiBTYWx0ZWRfX2hk2JoS++N8q
 YA7Q39TtioUmgzKPMeG+JEaAwB1Ex7XxZxNnuLYl2bmYe7tgblbMifIAXdfIWweefY9IUAN4MAs
 nie/1SMoapJ+mdXHfhHvrG+ZDHqMrf3gGL0Wra6ocsrsTUk0LgGAIkswIYbPq01R+aewSpzPKXy
 QRUlh0TjzY8wvZFNkxSpNBbBLtLCYDCH+pcMkNN3fAQItYUAPVQRP3vtSj7b4xtGIFrlVswOW5y
 a0fBOrmvd9FrRDFSj8Nqes87qjxYxlF2faK1GPIXXgbkBDydvGErW1WbWsaq/a5peUC0NXsdynH
 lS5NhYymZ9riFyN0+KDDs7Z23K7xa42f0jOx5DSM2/YfkzVkQxdUUKA2oXfW+w2vaPkRgd+28NV
 /oI8HJhnyDfcvr2h6Y0NP+ZpfpcaVA==
X-Authority-Analysis: v=2.4 cv=P9A3RyAu c=1 sm=1 tr=0 ts=68e632d6 cx=c_pps
 a=JUKW06bhoGHkwkYQWyoyLA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=VwQbUJbxAAAA:8 a=Br2UW1UjAAAA:8
 a=IJAzxQ5Bm4PmdPnQT9wA:9 a=QEXdDO2ut3YA:10 a=WmXOPjafLNExVIMTj843:22
 a=HhbK4dLum7pmb74im6QT:22
X-Proofpoint-GUID: BmTfNczSWuMBiHrAJq_2upKDDygNqQFT
X-Proofpoint-ORIG-GUID: BmTfNczSWuMBiHrAJq_2upKDDygNqQFT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510060056

SGkgTWFyYywNCg0KVGhhbmtzIGZvciBsb29raW5nIGludG8gdGhpcy4NCg0KDQo+IE9uIDggT2N0
IDIwMjUsIGF0IDExOjI4LCBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPiB3cm90ZToNCj4g
DQo+IEVYVEVSTkFMIE1BSUwNCj4gDQo+IA0KPiBPbiBXZWQsIDA4IE9jdCAyMDI1IDA4OjI5OjM4
ICswMTAwLA0KPiBKYW4gS290YXMgPGphbmtAY2FkZW5jZS5jb20+IHdyb3RlOg0KPj4gDQo+PiAN
Cj4+IA0KPj4+IA0KPj4+IE9uIDggT2N0IDIwMjUsIGF0IDA4OjMyLCBKYW4gS290YXMgPGphbmtA
Y2FkZW5jZS5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IEhpIE9saXZlciwNCj4+PiANCj4+Pj4gT24g
OCBPY3QgMjAyNSwgYXQgMDE6MjYsIE9saXZlciBVcHRvbiA8b2xpdmVyLnVwdG9uQGxpbnV4LmRl
dj4gd3JvdGU6DQo+Pj4+IA0KPj4+PiBFWFRFUk5BTCBNQUlMDQo+Pj4+IA0KPj4+PiANCj4+Pj4g
T24gVHVlLCBPY3QgMDcsIDIwMjUgYXQgMTE6MTI6MzFBTSArMDAwMCwgSmFuIEtvdGFzIHdyb3Rl
Og0KPj4+Pj4gSGVsbG8sDQo+Pj4+PiANCj4+Pj4+IEkgd2FzIGZpbmFsbHkgYWJsZSB0byBkbyBz
b21lIHZhbGlkYXRpb24sIHNvcnJ5IGZvciBhIGxvbmcgZGVsYXkuDQo+Pj4+IA0KPj4+PiBObyB3
b3JyaWVzLCB0aGFua3MgZm9yIHRlc3RpbmcuDQo+Pj4+IA0KPj4+Pj4gRmlyc3QgSSBhcHBsaWVk
IHRoZSAiRG9uJ3QgYWR2YW5jZSBQQyIgcGF0Y2ggb24gdG9wIG9mIDYuMTYuOS4NCj4+Pj4+IEl0
IGZpeGVkIHRoZSBlcnJvciBtZXNzYWdlLCBidXQgdGhlIEd1ZXN0IGRpZG7igJl0IGJvb3QuDQo+
Pj4+PiBJIGRpZG7igJl0IGRlYnVnIGl0IGZ1cnRoZXIuDQo+Pj4+PiANCj4+Pj4+IFRoZW4gSSBh
cHBsaWVkIGl0IG9uIHRvcCBvZiA2LjE3IGFsb25nIHdpdGggT2xpdmVy4oCZcyBzZWNvbmQgcGF0
Y2guDQo+Pj4+PiBHdWVzdCBPUyBzdG9wcyBib290aW5nIGJlY2F1c2Ugb2YgYW4gZXhjZXB0aW9u
LCB3aGVuIGFjY2Vzc2luZyBaQ1JfRUwyLg0KPj4+Pj4gDQo+Pj4+PiBJIGNoZWNrZWQgdGhlIEVT
Ul9FTDIgcmVnaXN0ZXIgYW5kIGl0IGhhcyAweDY2MDAwMDAwOg0KPj4+Pj4gDQo+Pj4+PiBBY2Nl
c3MgdG8gU1ZFIGZ1bmN0aW9uYWxpdHkgdHJhcHBlZCBhcyBhIHJlc3VsdCBvZiBDUEFDUl9FTDEu
WkVOLA0KPj4+Pj4gQ1BUUl9FTDIuWkVOLCBDUFRSX0VMMi5UWiwgb3IgQ1BUUl9FTDMuRVoNCj4+
Pj4+IA0KPj4+Pj4gSeKAmWxsIGNvbnRpbnVlIHRoZSBkZWJ1ZyB0byBtYWtlIHN1cmUgdGhlIGlz
c3VlIGlzIG5vdCBvbiBvdXIgZW5kLg0KPj4+PiANCj4+Pj4gQ291bGQgeW91IHBsZWFzZSBzaGFy
ZSB0aGUgcmVwcm8gc3RlcHM/IEFsc28sIGlzIHRoZSBndWVzdCBrZXJuZWwNCj4+Pj4gdW5tb2Rp
ZmllZD8gRldJVywgSSB0ZXN0ZWQga3ZtYXJtL25leHQgYXMgdGhlIGtlcm5lbCBhdCBhbGwgbGV2
ZWxzLA0KPj4+PiBrdm10b29sIGFzIHRoZSBWTU0gYW5kIEUySD1SRVMxLg0KPj4+IA0KPj4+IEni
gJltIHJ1bm5pbmcgYSBtaW5pbWFsLCB1bm1vZGlmaWVkIExpbnV4IDYuMTYuMCwgZm9yIG15IGlu
dGVncmF0aW9uIHRlc3RzLg0KPj4+IEl0IG9ubHkgaGFzIGEgQ1BVLCBhIEdJQywgYSBmZXcgVUFS
VHMsIGFuZCB1c2VzIGluaXRyYW1mcy4NCj4+PiANCj4+PiBJbiBteSBWTU0gSSBvbmx5IHNldCBL
Vk1fQVJNX1ZDUFVfSEFTX0VMMiwgd2l0aG91dCBIQVNfRUwyX0UySDAuDQo+Pj4gVG8gc3RhcnQg
dGhlIGtlcm5lbCBJIHNldCB0aGUgWDAtWDMgcmVnaXN0ZXJzLg0KPj4+IEl0IHdvcmtlZCBmaW5l
LCBzbyBmYXIsIGZvciBhbGwgb3RoZXIgY2FzZXMgdGhhbiBTVkUgJiYgTlYuDQo+Pj4gDQo+Pj4+
IFdoaWxlIHRoZSB0cmFwIHRvIEwwIGlzIHVuYXZvaWRhYmxlLCByZWluamVjdGluZyB0aGUgU1ZF
IHRyYXAgZGVwZW5kcyBvbg0KPj4+PiB0aGUgTDAgdmlldyBvZiBDUFRSX0VMMiB3aGljaCBvcmln
aW5hdGVzIGZyb20gdGhlIGluLW1lbW9yeSB2YWx1ZS4NCj4+Pj4gVW5sZXNzIHRoZXJlJ3MgYSBi
dWcgbHVya2luZyB0aGlzIHNob3VsZCBhbHdheXMgYmUgaW4gYWdyZWVtZW50IHdpdGggdGhlDQo+
Pj4+IGVmZmVjdGl2ZSB2YWx1ZSBwcm9ncmFtbWVkIGluIENQQUNSX0VMMS4NCj4+PiANCj4+PiBJ
IGNoZWNrZWQgdGhlIHBsYWNlLCB3aGVyZSBpdOKAmXMgZmFpbGluZy4NCj4+PiBJdCBsb29rcyBs
aWtlIEd1ZXN0IGNsZWFycyBDUFRSX0VMMiBmcm9tIDB4MzNmZiB0byAwLg0KPj4+IENQQUNSX0VM
MSBpcyAwIGF0IHRoaXMgcG9pbnQuIFRoaXMgZG9lc27igJl0IHNlZW0gdG8gYmUgY29ycmVjdC4N
Cj4+PiANCj4+PiA4MDYyMTkyYzogICBtcnMgICAgIHgwLCBjcHRyX2VsMg0KPj4+IDgwNjIxOTMw
OiAgIGFuZCAgICAgeDAsIHgwLCAjMHhmZmZmZmZmZmZmZmZmZWZmDQo+Pj4gODA2MjE5MzQ6ICAg
bXNyICAgICBjcHRyX2VsMiwgeDANCj4+PiA4MDYyMTkzODogICBpc2INCj4+PiANCj4+PiBBbmQg
YWNjZXNzaW5nIFpDUl9FTDIgaXMgdHJhcHBlZCwgYW5kIGNhdXNlcyBhbiBleGNlcHRpb24uDQo+
Pj4gODA2MjE5M2M6ICAgbW92ICAgICB4MSwgIzB4Zg0KPj4+IDgwNjIxOTQwOiAgIG1zciAgICAg
emNyX2VsMiwgeDENCj4+PiANCj4+PiBMb29rcyBsaWtlIHRoZSBHdWVzdCBPUyBleGVjdXRlcw0K
Pj4+IC5MY3B0cl9udmhlX1xAOiAvLyBuVkhFIGNhc2UNCj4+PiBmcm9tIGVsMl9zZXR1cC5oLg0K
Pj4gDQo+PiBJIGRpZCBzb21lIG1vcmUgZGVidWdnaW5nLg0KPj4gSSBjaGVja2VkIF9fY2hlY2tf
aHZoZSBhbmQgaXQgbG9va3MgbGlrZSBpdCBqdW1wcyB0byBmYWlsLg0KPj4gSENSX0VMMiBoYXMg
MHgxMDAwMzAwODAwMDAwMDAuDQo+PiBFMkggaXMgc2V0IHRvIDAsIGV2ZW4gdGhvdWdoIGl0IHNo
b3VsZCBiZSBSRVMxPw0KPiANCj4gVGhlIHZhbHVlIGl0c2VsZiBkb2Vzbid0IG1hdHRlciBmb3Ig
S1ZNLiBIb3dldmVyLCB0aGUgZ3Vlc3QgY2FuIHdyaXRlDQo+IGFueXRoaW5nIGl0IHdhbnRzLCBh
bmQgdGhhdCB2YWx1ZSB3aWxsIGhvbGQgKmluIHRoZSByZWdpc3RlciouDQo+IA0KPj4gSSBjaGFu
Z2VkIHRoZSB2YWx1ZSB1c2luZyBhIGRlYnVnZ2VyLCBzbyB0aGUgY2hlY2sgcGFzc2VkLg0KPj4g
VGhlIGNvZGUgdG9vayBhIGRpZmZlcmVudCBicmFuY2ggYW5kIGl0IHNlZW1zIHRoZSBTVkUgaW5p
dCBwYXNzZWQuDQo+IA0KPiBPaCBjcmFwLiBZb3UgYXJlIG9uIFYyLCB3aGljaCBkb2Vzbid0IGhh
dmUgRkdULCBzbyBJRF9BQTY0TU1GUjRfRUwxDQo+IGRvZXNuJ3QgdHJhcCwgYW5kIHRoZSBrZXJu
ZWwgZW5kLXVwIGFzc3VtaW5nIHRoYXQgdGhlIENQVSBpcyBuVkhFDQo+IGNhcGFibGUuIE5vdGhp
bmcgd29ya3MgYWZ0ZXIgdGhhdC4NCj4gDQo+IEknbSBhZnJhaWQgdGhlcmUgaXMgbm8gcmVhbCBm
aXggZm9yIHRoaXMsIG9ubHkgaGFja3MuLi4NCg0KSXMgaXQgcG9zc2libGUgdG8gdHJhcC9lbXVs
YXRlIEhDUl9FTDIsIGFuZCBtYWtlIHN1cmUgRTJIIGlzIGFsd2F5cyAxLA0KaW4gY2FzZXMgd2hl
biBvbmx5IEtWTV9BUk1fVkNQVV9IQVNfRUwyIGlzIHNldD8NCldvdWxkIHRoYXQgaGVscD8NCg0K
QXMgYSB0ZXN0LCBJIHRyaWVkIGZvcmNpbmcgdGhpcyBiaXQgYmVmb3JlIHJ1bm5pbmcgVkNQVXMs
DQpidXQgcmVhZGluZyBpdCB2aWEgTVJTIGdvdCBhIHZhbHVlIHdpdGhvdXQgaXQgYmVpbmcgc2V0
Lg0KDQoNCj4gDQo+IE0uDQo+IA0KPiAtLSANCj4gV2l0aG91dCBkZXZpYXRpb24gZnJvbSB0aGUg
bm9ybSwgcHJvZ3Jlc3MgaXMgbm90IHBvc3NpYmxlLg0KDQpSZWdhcmRzLA0KSmFuDQoNCg==
