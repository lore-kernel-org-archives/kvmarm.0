Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8143919F137
	for <kvmarm@lists.linux.dev>; Wed,  8 Oct 2025 07:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.84.65.235
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759908599; cv=fail; b=N+WCpl3Re6kopZLD012Vy1byK9AAKL919JAQIGZh3X4wFsMQb1dcC5uhLJ9et7rxncDkYdQlAdyGsMz2qTC0W+v2w2Ek22dxuCtkSp2V7Ag7e8Hpws5Y8XQC/AeJ2Fg7jhS1cFc+ee8+9+rwmAOH6kUy3SvhgjaAREIOtHW1o/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759908599; c=relaxed/simple;
	bh=XPsBAENAumDnaQlSOQUKTeHs2Bh2R+d1DoDoe+2rLbs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pq0TAt/z12uCBGNcwhJac2g2QZ6bbY1NpDS/ZD5EKTK5sAXkeU7xBCJmtBHKo9fJlRY5CF5mQG5jcNb+RiQIFK3SKp6wtfNFZS7adBjID5XGHLEAnZJyM3AkGhRErJjCiN1fIPPTqYsh2pC24mgvt4qEbVLz0sT+U9EY7jOAv24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=HobtmtzT; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=VFWssrAI; arc=fail smtp.client-ip=208.84.65.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="HobtmtzT";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="VFWssrAI"
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
	by mx0a-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5985rsYG003312;
	Wed, 8 Oct 2025 00:29:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=XPsBAENAumDnaQlSOQUKTeHs2Bh2R+d1DoDoe+2rLbs=; b=H
	obtmtzTMYiGkt7cL0M1CT4Yxij4TU7ClL1dwbeMORiKoWE9LIFcIYfQUNpnqkPi1
	06AGV/4O87UGLwR1OTWBtn0xzfwTw5flAMySUZ6688Moxf4X1dZVwBG5q0sO6AEL
	lFdoM/yJ/B5t2p8lkvCLrigK12n741nJFV70ufmXNQQTN1XgHTNZEHZhhJkd4iWV
	zIVU6/8vplr200mZSnd3NjAd04bWnovdMOsML52FpKuybXw4+HQhl58RrdFcbenJ
	NpMFnI/+DDMnGlri/R1eFxCKEi8H6FY3XW3M4ZWPiZKiXNytarpiW3gCIwFDkJZT
	SwOJmNkW9C1iEwgYlzuwQ==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023081.outbound.protection.outlook.com [40.107.201.81])
	by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 49m920vcrw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 00:29:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LK4gTM9CH6ntYDQOBqfNU4ve/FsnnSB2liyyA3Y0Cu6V47Pw+u5ny7KfhtoLDjmjl6wrdZMZMncZur++CzTBXOcRDxLFkyyGZMoc5mZgSA05/1K3yWwhXbNlwzt9AOmB2/f9qPUuDuX3gSn3slwUbH2pzIW1exsF+8pvoFRBjrR45vMClUf3wOOIEuDnAhMj4MNqP2ZKQ5VBwg9qaeofEFVNgJh31t3balkAQEaLfp/7K+UjUniwkDMHDvo9HBtufP3UYrnY6arLtQaLfUYWEKdDMPq6bOJokqoZOwPZm9bs1il1K3NDQ2eBuA7oGXIFXpnKyEeT5rx4cNyEKra45Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPsBAENAumDnaQlSOQUKTeHs2Bh2R+d1DoDoe+2rLbs=;
 b=NH/kpaFhXC8Ge47kCeCY+5pfCUaNUtg1m5HJxwcBd5nRxQyDhVG+Xvojd+13F+xtg5dNE0jo1BDRelvPhQz98o7DkIxOtkpFuKWsKJ8g1kIHeGzYFDBRlSk+wDiSjpptyQpOP0T22rTP5E4/DtVsjmLa8ZpQeWn9YsspwxWAmHp+bUfWlGLqS1KTuyPM7hkqntTB8yBGYqLg2CJYnFFY639FcMR+zyGGMYrRBLUXBH44tzf2SxDOyxaREu2Ab+Rkg0eac2olBZKAYrpuIAZmTUdV6Cbgtzjl7qxXV4oVNfsx9Wio5CeGGWx+jNV+si/MNm5UQijn1jJvwrSXMnE5Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPsBAENAumDnaQlSOQUKTeHs2Bh2R+d1DoDoe+2rLbs=;
 b=VFWssrAIOd/53u017N4XUZCOd9+qUCSJnHKp+uyfN5Ji320hYkyug2O4fA9IypgxkYFoYv9KQOwdqeoTDNAcCAvMLawBIM3fk6LhNYHgkOquS7yaq7r62t3JvLHKwa4TP82Tawc0IR71+NrP/UX3GfgDjaPa+6hA6nliFOgQl3s=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by CH4PR07MB11041.namprd07.prod.outlook.com (2603:10b6:610:242::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Wed, 8 Oct
 2025 07:29:39 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 07:29:38 +0000
From: Jan Kotas <jank@cadence.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        Jan Kotas
	<jank@cadence.com>
Subject: Re: KVM NV + SVE host OS warning
Thread-Topic: KVM NV + SVE host OS warning
Thread-Index:
 AQHcLiUKR+wB9cgAPkys8N+jKyIMXLSj98IAgAAI7YCAAAb+gIAAeJmAgBIZ7gCAAM0NAIAAdwsAgAAP94A=
Date: Wed, 8 Oct 2025 07:29:38 +0000
Message-ID: <E2FD1CD0-AE1F-4F9C-86FF-D576C212832B@global.cadence.com>
References: <799DD5E5-8BC2-47B3-A919-33429D3FB2F1@global.cadence.com>
 <865xd61tt5.wl-maz@kernel.org>
 <F9556C9F-2671-4EF6-A725-D080C3793A34@global.cadence.com>
 <864isq1r66.wl-maz@kernel.org> <aNXGW8C_S1TbFR9-@linux.dev>
 <25C5E00D-62BC-4188-8642-21913446B32C@global.cadence.com>
 <aOWhlvC1kROWfMSv@linux.dev>
 <1271032F-41BB-4896-AAED-8660D5459E7D@global.cadence.com>
In-Reply-To: <1271032F-41BB-4896-AAED-8660D5459E7D@global.cadence.com>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|CH4PR07MB11041:EE_
x-ms-office365-filtering-correlation-id: 76857f60-8010-4541-d4b5-08de063c7070
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?THFWUFErTDFzeUlWZnM4RkVKa3VBRXlGajlIQ0tqZnFoWGgya3NmTVg5bWFS?=
 =?utf-8?B?ZEQzNkFYMDNxUGd3UG1OYysvT0pscnhlcHRpdytTdUxGL0NRbll3UmtGVVJa?=
 =?utf-8?B?S2dqTWtOWlBpMVc1VzMra0V2YmZRZ0hhc041RmtjTDAyVmgrU203Nm4vWGRR?=
 =?utf-8?B?UXFzQzVRdlgyazRsN3ZRR0Y0cVNJWTFtMmZSeERVbHRhbUV1cktUQkpDaE5D?=
 =?utf-8?B?RnZNVXBSMXRxYjdvSWFTVVZqT21Xd0ZyVFVvK1hLUDFyUjQzTUYwUzhyR2hF?=
 =?utf-8?B?WjNPK2VrdVZuYmdKNFV6Y09qTzkva3JxaUg0NVgrSXRFci9ZaEF6amFBY3Fn?=
 =?utf-8?B?Wm5aQVoyYU5FV1NvOTJmZS8wRWNKaU5NNEFZRmxOWGYwb0xvSGRLdmJ3OVBj?=
 =?utf-8?B?SDRZMlFtZ0U0RlRnTkpzK1pPK3laWSt4TjZudUtpL1dTZXBOd3M0dnY5T0w4?=
 =?utf-8?B?aFVGL2FWMW9FNFFFZk1vMGVLMnB4aW9QQ0toaXFCVFdwOWNkeWpwLzhnZlFS?=
 =?utf-8?B?c3J0YjN4U2NRY3JOU3l2NUVNSmQxMmRhdDdQWU9QNnpMby9QTUFKZEcyMWtS?=
 =?utf-8?B?QVhHd01RUVlVTkkvb3d1MnBQZ3V0ZFppa0RVNUZqMEwxNHNJZklJNEpxRjBs?=
 =?utf-8?B?bFloKysrOHZKU29wSllxQmM5aTZwSDFjYTFBRXV5QU1SSHlIMi9tRy92Unoy?=
 =?utf-8?B?T2QxTkY3S0ZSSW94WjNpMFdQYzVtTGR6R21ydWxCWXlOUUlTNEY5ZHQ3QkFm?=
 =?utf-8?B?SDRkVFJWTHdaRnZ3Z09lM1ZReCtjS00wakthYWtZdFVZcFNSNk91V3IwcFpl?=
 =?utf-8?B?OXp0ajkrV2ZUK21PenNMMUxDRXpLZHBYRGlQNEMxR1J3NlNEUVVSei8ydTdQ?=
 =?utf-8?B?MjZRbzMrMnljdGtjSC9aU1E5a2JOVi92ZkF3YmtidDF1czRxa0pMaHlYdDR3?=
 =?utf-8?B?UDhmbU9HTmRRajAvWnlWcmxzUExwTHMxaFV6Z2VBcU0wM1Y2bU1WZGxKQ0li?=
 =?utf-8?B?cUxxeHA1eXVrM20xNnBYMDgzclhwY2VTUHk0Umw1TmR2eTdMSGlKSTRFeDJM?=
 =?utf-8?B?MzViRjdoVDJ2eXhHQXp2OE16clUrT0FIZ1JXejJzTVRhck95YS9FRGZWQnRi?=
 =?utf-8?B?VndGODFOblNuZi9aVHJIZnhEZ0NtRFpENEYrcTBSbStxMW5hRXZrb1Ftc1lM?=
 =?utf-8?B?TEtCaEJoVDV0eTYrcHZFUU5oVi9xRGgrK2VrWDgyYjRvLy9pTlJSblJSYWlX?=
 =?utf-8?B?YlYyZ2FaTmRMMHluVnRoclFMbnBpTzM4TjFZWG9aSUVOelR2WnZxZFVxZVBD?=
 =?utf-8?B?eW11aXBlYjIyeXV1RzQrb0dQYzlYbjBpRWZVZHArWWJXdjhXNXlldEoxdEdJ?=
 =?utf-8?B?WFA2WmFZaElLaCtpK3FSaVZUK0xreW5jV0hPRldMRkI5Q1R3Q0M4dlN4K3Iz?=
 =?utf-8?B?SHRCbm1JaFFZMzRVajUyc2lJdEdMUXlpS3pFWUozV1AvNlk5RitDNCtVanVX?=
 =?utf-8?B?MW80RWorcEp0Y3ZvdmRFSFBSTWs0aS9WNGpmQk9kS21jdzNXL1ZwZjBGdVMy?=
 =?utf-8?B?ZGpFRjErNnQxcEdNZytYK2lrcjlybnl5ZFZkTVZLZjdFT1c1a3N4N1FqV1pW?=
 =?utf-8?B?UXYrSkZCY3pXTGxDRzNuR2J5VytXUHYrNk1aWFJ1dWFPYzhEZWNjbHFZa2xM?=
 =?utf-8?B?a2lRWG5sMnpSM3pMZHV0R2daQlFYN3ZTUzJja0dBRStUYUhlRlluQ2JsT3o2?=
 =?utf-8?B?cjl3Y05lM09CQlh2NW9RZUM3b0JvWTV4TCtQNGhjdGNrZFJPcVFld1lzNWlZ?=
 =?utf-8?B?YlloaXc1TWlvSmtJdnNEdDkrcmlCRHRKb1FVanhndVZnR2oyYkVqQmFudUQ0?=
 =?utf-8?B?N201UFlvenBueC9BUzc3TjRqVXZHNkhFUE1uMGhvRGhOVnBvdzlxbVFrWGZw?=
 =?utf-8?B?TGliaXdZa3BKblJ0UXVFQmc0eUNPM1ZUaUdvU2lWY3ROMGRWWXZZOUp6Q2g3?=
 =?utf-8?B?amdkdXRrZmRSYklUT2J3d2lKdS9pODh4UWV4Nm1lVFJyQzdadGQwM3Jyamt1?=
 =?utf-8?Q?rnbBTp?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TitMMTE2cUF1M1FpQ3VJT0FmRFhwb1dBL3o1UldIdDJ4am1xY05oUFVQeVRr?=
 =?utf-8?B?azFyTnZBUWhXdTJxaHpiUHZCdmk5bS9mNCttMUxLV3NxcUFsK09RRmVLbDlP?=
 =?utf-8?B?dHA3bkNaNEV3VjVFOSs3cE5idTBwbUp4TlZNb1FuTTZseHZOWGVubURRV0ZP?=
 =?utf-8?B?WldYLzNZdlBsTWF5Mzl3VERPM0hTcno3RXNObWx1WldjK212Y0VZZzJER3Fa?=
 =?utf-8?B?ZXFrMFZVVkdxTXdOLzRPVzJGSk00Z2lObjNRUTM1WXJvT0JMcDN1QTJvSjBW?=
 =?utf-8?B?ZmJ1VnR3VGZNNUZ5SFNpZlVEeFgrUmNaZmxiY2RjKzlIazRsdGxwclBmdTNX?=
 =?utf-8?B?dUNnRnlCOW1RRFdESjFqRWpCTXovRVkvYm11UW9MSE1vZkkwdmFQOXdHNjNu?=
 =?utf-8?B?RjBhckRqTUk0K1Z2cVJaeUZqNEZFOTl6T2lkNmpzY3I5MkpNN0ZMY1NaLzBt?=
 =?utf-8?B?eWJ1dEtMUThIM0ZFRUdjakxROEN3anpZeXhiNlNiVDJWM1E2djNwempoSzZZ?=
 =?utf-8?B?bzBuVHVOQ3NrT01LU0ptdEgyNHl5OWdoNHQwakVQMUlMVEpEMjY4VGpHZm1x?=
 =?utf-8?B?SlNvbGVDMTZvaVdWbENIazZtOWZaTkhMVXFDYXlSeHUzUSttRVhjOTJscmc2?=
 =?utf-8?B?Q0M2UnJBWkkyd2NseWFGQXhLeE80Zm51U0plUzJNV3ZUTER0L2hVbGgwQlhI?=
 =?utf-8?B?RndvSWp6NWpHN2NGT1ZqM1lZZUQ5N3RMWURzQUZHNHZicElUV3VEZmZPWEtP?=
 =?utf-8?B?a1JBM3lOc0txNjdHaDJiQlJXTGg2ODQ5elAzUWpFbG42VWhlNEhacUFNZ2lw?=
 =?utf-8?B?clFkVkRhbUZkcEVUZWJaSjRxelRxMmVRdW9FVlYrRThvVTNQNGN1M3E1NFBJ?=
 =?utf-8?B?K3lrL3V0a09PclFZM1VSa01SNzRyS282SjEzMkk2QlNLSUNReDNaZHpxK0NN?=
 =?utf-8?B?VGRGbkFxVnROUFJCSlRVVHI1RW5UT090TzBRQ2tjOHVuS3hqZXhHaGJrYnBn?=
 =?utf-8?B?OHFnVkdQMnIrU01yVDBjMTlPcUkzMXdjR25BYmpsQkYzNGFwdU1DOUdoZ2Jj?=
 =?utf-8?B?alNsaVRiM1prejNMWEFtalU5Nkh5YlkrMjlPUWozUE1wZ2Z4RFUzLy9ZZU1a?=
 =?utf-8?B?OHAyK2J5dW9uU0tETkFHRk9XUTRWNmxsMVczU05jRlhmVHRlMlNNL25QL2kr?=
 =?utf-8?B?ZFJWYWkwelpKWE9Jbld4cEwwbUZxR3dVa1YvOGl3VEl3K0RzTFl0aG1KbE9C?=
 =?utf-8?B?WHAwZU02NitmVlA5SnBWSU5wS21GM1FyRVJTOWdONWpONG8rYUZwdlMyYWZE?=
 =?utf-8?B?L3VESzU3UDJ6M0tMbnZkTHNJTDYyTEMvYm9mT204TUViakxOVVk5Q0RrYjM3?=
 =?utf-8?B?dHQ3aXpTb0lNRlZDV2w2UXpMbzRJbXo2VHRsWkJYbU1jZXFYdE5CQjFTRXIx?=
 =?utf-8?B?OTZOTEtYTlhYa0I1YkczV1RJa013N1hZdTlxcGdEYVNiK1F6eEhDSElwZGlW?=
 =?utf-8?B?Z1Z4U0xJTXhsanVCYzFOQWVzTzVXTVZNWDdPeE4yeFpwWGgrRy9qL0wzTUhZ?=
 =?utf-8?B?aGlQbitRUjFhYjAyNW5KblZWd01mTzFMMXg3RGJtTTJDRCtHYW9RMVk3TllM?=
 =?utf-8?B?enNBSXVvZWR2SzR2MjhGaFBNVDVvR2lxRkhER0l6M3c4eHhYT3AwYlUxWkw1?=
 =?utf-8?B?NTlwL3lhN1Z3M3oydkRLSlNiWE9XR3N3cnhjTWpsNUs4NWJwcVF2RkZCV0JU?=
 =?utf-8?B?a1RPellMODhxZEw4MWxqa3JPR25UTkg3dHgxWER6KytuMHhqbEx2R2FDZitL?=
 =?utf-8?B?eHVQYVEzd2dIQ2YrOXV5bFdGRUkzWkdETHpKZk9vdVM0Uml6Wnp2MVMxdEFz?=
 =?utf-8?B?NkF4bW1aTzhuWGhxeUlDYzNNejUwUm5kbU1nYStrT09yMDFXVkJLeE9KVGRN?=
 =?utf-8?B?djdlUnQxenAzWklPVlEwZktrb3ZySmZmeTdVRnZvdUtzRHF1bWpJbDA5bkhJ?=
 =?utf-8?B?b2RPUTRkOEdqV1VPYS9NM0JGQ2xJR2xFZzh3OHQ3ckRrNjd1b0V2aU1PbVY4?=
 =?utf-8?B?ajFYOGVGMHVURnlUL3l2T1F6djVubmdqUytBa056SHc4ZE5VNWhWemtheHRB?=
 =?utf-8?B?UEY4UUJTUXZrTUVLNlRBM2hVOGozMUU2aStKYzgyTWVkcmtVZXIva2pGdzAx?=
 =?utf-8?B?M0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D9D83F1A508E54A8CF438ABACB8F329@namprd07.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 76857f60-8010-4541-d4b5-08de063c7070
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2025 07:29:38.7301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: thAEIRgbXhWgoVJgL7Wey4dYVZZ/b+kKC3vdzTRSeUoGCxuWg6BTP+b8s0Tenl0rFYlXfkya6vaXz4+j3VBM7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR07MB11041
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDA1NCBTYWx0ZWRfXwou5Fsa5x0TL
 F/EyE2i6avF9rnMFwzq/bilEEXtkk16WHG84AZ7Lc0PMt1V9urVnZjCR0vfdQkWd0Zzu/637X5w
 hnPARvtgs23OAhjcTfB0Pv84WlNieGCPMrGTl03OesyImPW1VRp5Mz/UzguXxYqDlj+xqbchZjW
 BhLI/zRctUh4c9UzyKDp3qZn25ijFFPTsLSo1oqmRIgCgtexj8qwFhJ/crtFquOnTMJKCOO5X4u
 CuvdWKI4vQdJWiF6Hb2MX9EpmlHkCW3bHAi2838vNCAOndRdgY/2ttETFJ5GTZIYA/nO4vUF7kC
 +MNR/FoQVAUWSA8EE4C0i0/Drt43DC/wpv+RCXOl819Qi+WynRlT2V2Yhkrv126bp09PCKsJ6FB
 baROoZfFJ9O/rwZ9Jxhx8u0IDsVsoQ==
X-Proofpoint-ORIG-GUID: HQxUqD7a1VjRSn2iNNqKNEVxyU9J0dj0
X-Proofpoint-GUID: HQxUqD7a1VjRSn2iNNqKNEVxyU9J0dj0
X-Authority-Analysis: v=2.4 cv=TIZIilla c=1 sm=1 tr=0 ts=68e612e9 cx=c_pps
 a=JH6A4+CB+OQWszY4mUuf5w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=Br2UW1UjAAAA:8 a=eJRfknrYVA9GsBB3pOgA:9
 a=QEXdDO2ut3YA:10 a=WmXOPjafLNExVIMTj843:22 a=HhbK4dLum7pmb74im6QT:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 lowpriorityscore=0 clxscore=1015 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2510060054

DQoNCj4gDQo+IE9uIDggT2N0IDIwMjUsIGF0IDA4OjMyLCBKYW4gS290YXMgPGphbmtAY2FkZW5j
ZS5jb20+IHdyb3RlOg0KPiANCj4gSGkgT2xpdmVyLA0KPiANCj4+IE9uIDggT2N0IDIwMjUsIGF0
IDAxOjI2LCBPbGl2ZXIgVXB0b24gPG9saXZlci51cHRvbkBsaW51eC5kZXY+IHdyb3RlOg0KPj4g
DQo+PiBFWFRFUk5BTCBNQUlMDQo+PiANCj4+IA0KPj4gT24gVHVlLCBPY3QgMDcsIDIwMjUgYXQg
MTE6MTI6MzFBTSArMDAwMCwgSmFuIEtvdGFzIHdyb3RlOg0KPj4+IEhlbGxvLA0KPj4+IA0KPj4+
IEkgd2FzIGZpbmFsbHkgYWJsZSB0byBkbyBzb21lIHZhbGlkYXRpb24sIHNvcnJ5IGZvciBhIGxv
bmcgZGVsYXkuDQo+PiANCj4+IE5vIHdvcnJpZXMsIHRoYW5rcyBmb3IgdGVzdGluZy4NCj4+IA0K
Pj4+IEZpcnN0IEkgYXBwbGllZCB0aGUgIkRvbid0IGFkdmFuY2UgUEMiIHBhdGNoIG9uIHRvcCBv
ZiA2LjE2LjkuDQo+Pj4gSXQgZml4ZWQgdGhlIGVycm9yIG1lc3NhZ2UsIGJ1dCB0aGUgR3Vlc3Qg
ZGlkbuKAmXQgYm9vdC4NCj4+PiBJIGRpZG7igJl0IGRlYnVnIGl0IGZ1cnRoZXIuDQo+Pj4gDQo+
Pj4gVGhlbiBJIGFwcGxpZWQgaXQgb24gdG9wIG9mIDYuMTcgYWxvbmcgd2l0aCBPbGl2ZXLigJlz
IHNlY29uZCBwYXRjaC4NCj4+PiBHdWVzdCBPUyBzdG9wcyBib290aW5nIGJlY2F1c2Ugb2YgYW4g
ZXhjZXB0aW9uLCB3aGVuIGFjY2Vzc2luZyBaQ1JfRUwyLg0KPj4+IA0KPj4+IEkgY2hlY2tlZCB0
aGUgRVNSX0VMMiByZWdpc3RlciBhbmQgaXQgaGFzIDB4NjYwMDAwMDA6DQo+Pj4gDQo+Pj4gQWNj
ZXNzIHRvIFNWRSBmdW5jdGlvbmFsaXR5IHRyYXBwZWQgYXMgYSByZXN1bHQgb2YgQ1BBQ1JfRUwx
LlpFTiwNCj4+PiBDUFRSX0VMMi5aRU4sIENQVFJfRUwyLlRaLCBvciBDUFRSX0VMMy5FWg0KPj4+
IA0KPj4+IEnigJlsbCBjb250aW51ZSB0aGUgZGVidWcgdG8gbWFrZSBzdXJlIHRoZSBpc3N1ZSBp
cyBub3Qgb24gb3VyIGVuZC4NCj4+IA0KPj4gQ291bGQgeW91IHBsZWFzZSBzaGFyZSB0aGUgcmVw
cm8gc3RlcHM/IEFsc28sIGlzIHRoZSBndWVzdCBrZXJuZWwNCj4+IHVubW9kaWZpZWQ/IEZXSVcs
IEkgdGVzdGVkIGt2bWFybS9uZXh0IGFzIHRoZSBrZXJuZWwgYXQgYWxsIGxldmVscywNCj4+IGt2
bXRvb2wgYXMgdGhlIFZNTSBhbmQgRTJIPVJFUzEuDQo+IA0KPiBJ4oCZbSBydW5uaW5nIGEgbWlu
aW1hbCwgdW5tb2RpZmllZCBMaW51eCA2LjE2LjAsIGZvciBteSBpbnRlZ3JhdGlvbiB0ZXN0cy4N
Cj4gSXQgb25seSBoYXMgYSBDUFUsIGEgR0lDLCBhIGZldyBVQVJUcywgYW5kIHVzZXMgaW5pdHJh
bWZzLg0KPiANCj4gSW4gbXkgVk1NIEkgb25seSBzZXQgS1ZNX0FSTV9WQ1BVX0hBU19FTDIsIHdp
dGhvdXQgSEFTX0VMMl9FMkgwLg0KPiBUbyBzdGFydCB0aGUga2VybmVsIEkgc2V0IHRoZSBYMC1Y
MyByZWdpc3RlcnMuDQo+IEl0IHdvcmtlZCBmaW5lLCBzbyBmYXIsIGZvciBhbGwgb3RoZXIgY2Fz
ZXMgdGhhbiBTVkUgJiYgTlYuDQo+IA0KPj4gV2hpbGUgdGhlIHRyYXAgdG8gTDAgaXMgdW5hdm9p
ZGFibGUsIHJlaW5qZWN0aW5nIHRoZSBTVkUgdHJhcCBkZXBlbmRzIG9uDQo+PiB0aGUgTDAgdmll
dyBvZiBDUFRSX0VMMiB3aGljaCBvcmlnaW5hdGVzIGZyb20gdGhlIGluLW1lbW9yeSB2YWx1ZS4N
Cj4+IFVubGVzcyB0aGVyZSdzIGEgYnVnIGx1cmtpbmcgdGhpcyBzaG91bGQgYWx3YXlzIGJlIGlu
IGFncmVlbWVudCB3aXRoIHRoZQ0KPj4gZWZmZWN0aXZlIHZhbHVlIHByb2dyYW1tZWQgaW4gQ1BB
Q1JfRUwxLg0KPiANCj4gSSBjaGVja2VkIHRoZSBwbGFjZSwgd2hlcmUgaXTigJlzIGZhaWxpbmcu
DQo+IEl0IGxvb2tzIGxpa2UgR3Vlc3QgY2xlYXJzIENQVFJfRUwyIGZyb20gMHgzM2ZmIHRvIDAu
DQo+IENQQUNSX0VMMSBpcyAwIGF0IHRoaXMgcG9pbnQuIFRoaXMgZG9lc27igJl0IHNlZW0gdG8g
YmUgY29ycmVjdC4NCj4gDQo+IDgwNjIxOTJjOiAgIG1ycyAgICAgeDAsIGNwdHJfZWwyDQo+IDgw
NjIxOTMwOiAgIGFuZCAgICAgeDAsIHgwLCAjMHhmZmZmZmZmZmZmZmZmZWZmDQo+IDgwNjIxOTM0
OiAgIG1zciAgICAgY3B0cl9lbDIsIHgwDQo+IDgwNjIxOTM4OiAgIGlzYg0KPiANCj4gQW5kIGFj
Y2Vzc2luZyBaQ1JfRUwyIGlzIHRyYXBwZWQsIGFuZCBjYXVzZXMgYW4gZXhjZXB0aW9uLg0KPiA4
MDYyMTkzYzogICBtb3YgICAgIHgxLCAjMHhmDQo+IDgwNjIxOTQwOiAgIG1zciAgICAgemNyX2Vs
MiwgeDENCj4gDQo+IExvb2tzIGxpa2UgdGhlIEd1ZXN0IE9TIGV4ZWN1dGVzDQo+IC5MY3B0cl9u
dmhlX1xAOiAvLyBuVkhFIGNhc2UNCj4gZnJvbSBlbDJfc2V0dXAuaC4NCg0KSSBkaWQgc29tZSBt
b3JlIGRlYnVnZ2luZy4NCkkgY2hlY2tlZCBfX2NoZWNrX2h2aGUgYW5kIGl0IGxvb2tzIGxpa2Ug
aXQganVtcHMgdG8gZmFpbC4NCkhDUl9FTDIgaGFzIDB4MTAwMDMwMDgwMDAwMDAwLg0KRTJIIGlz
IHNldCB0byAwLCBldmVuIHRob3VnaCBpdCBzaG91bGQgYmUgUkVTMT8NCkkgY2hhbmdlZCB0aGUg
dmFsdWUgdXNpbmcgYSBkZWJ1Z2dlciwgc28gdGhlIGNoZWNrIHBhc3NlZC4NClRoZSBjb2RlIHRv
b2sgYSBkaWZmZXJlbnQgYnJhbmNoIGFuZCBpdCBzZWVtcyB0aGUgU1ZFIGluaXQgcGFzc2VkLg0K
DQoNCj4+IFRoYW5rcywNCj4+IE9saXZlcg0KPiANCj4gUmVnYXJkcywNCj4gSmFuDQoNCg0K
