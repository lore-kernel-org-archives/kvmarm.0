Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011066.outbound.protection.outlook.com [40.107.74.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A227488D95
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 09:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792402758; cv=fail; b=WBbZJ0bigPIY+JnxEHT28s4Rftz5Ki3No3D2bQxS9E+5HyMjQYOHU4b5+XX9d/tjBh5gcMf/OV4sJuMtyzR3XyO19z4M5nrF8n5bbH+1ONr7wIhUYAaUNV2ifgA6dl0jhaZxuwU0WgUAjbqA04g7LToU1rzlCf94EuM46M4fBCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792402758; c=relaxed/simple;
	bh=ZbvfMwmPqnAhxXZzahfvMTqTM/V4JDkxsqjz0XrTS8A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HQ7gvlO8s7cZu+YHOYXZQxttPmOleti0ULtjMqVvZvtMrU0yQFYoaMSzClJVFm/hB1T52pliCYLWv60lvUJar1eGGyNPgI2U8vYn8aaANjNcUukLJoGP47F7ZmG+s+jo7VfKcm964V2kOJNMyh6YxEt1Mzn0neJX7FblCX5uqBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=NGxGOXeo; arc=fail smtp.client-ip=40.107.74.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="NGxGOXeo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n5pJGGifgQEADiSaAbDC9CLSiElRLUfd1Q89wphNriO1bIcXXU/ufM5RLyN/DVUN4NkYV97nbdvhJZy7DxBUNVJsCJ5VmP9zwayouxleXQ740UiMW9wBwRCecEYswyHunlOYsruGFw5OYR4B0xfhX3LwIHmUiTxzuEdwzktiaWhvxTEYfXUTao0YKVEVdB3blfU/bTbm+i/yt+nmwaQM/jXXLorZIDNThm8F2+pJYV/t+MVmwrlzbdCIrMQ9MkcSUCPSxsumtmbs13gQBskhiXnRkY3zwA+xlrdt2/lJMlk9ungZKdEaQPK5MlqkMDKQsCzAoRVTeiqYPTKcpHJBzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbvfMwmPqnAhxXZzahfvMTqTM/V4JDkxsqjz0XrTS8A=;
 b=QOlFlaYVmJT5G0wwBoEjfbKig/gcNY659Gnt+qDgRMU1598uCYeLVDuTqG1+zjFw6lBLUc8aCt2gdrHiGkOp0Y7nWorBAnIQ4Im8APGjLdxaKOCIxv7MEXV7ns0lHkodRue/qERhwRMR4ru35iWO6YiMMDez4N/thGbwHs7xkohGKqkyrUcSLTU5d/TVSg5ShiE70xHxKYn/a4S/PMFRB0MX5ak3qT5/ilOJ9vwRhsnrmmD/VVZreglJm7lUBmbqaE8nv8NPFqJvW1gMSsZ28100kqw5g9dZOpxyLmp21rlYhaCzaqUau00/NLmHr+yrN584MV6lJg/ABnqKT3e/vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbvfMwmPqnAhxXZzahfvMTqTM/V4JDkxsqjz0XrTS8A=;
 b=NGxGOXeo2v8W22ZkU/ulg0ROA4fFfWIBfBvHCOr4BezDSEGg/tOaAmirXfeiP5RoGVg+zVrhMva67D672842JOkZvMXMrl8AHej4zTXorg9d5nMXF9apo76beHwSo4eM1Kvq2t1Mqv254H2HLlBElDqzKG/cRiiBArFYlCNswWwFDxnhIiuyFkSgq8uIZOkGk5NngQLZH5txmeW2lQaL9CFf05AvW3vOyzLmgIpZermIpxAnFybgYgPDlVDa/Ecm0HJh4MSP0qVaC0uxCuW9ru9tKXWsBC5P7TmVBET2OH0Z4y0N5xEcnljSp1WIkKBq9BtYNfHmcC3bER4zq/80Ow==
Received: from TY7PR01MB15746.jpnprd01.prod.outlook.com (2603:1096:405:290::6)
 by TYYPR01MB14118.jpnprd01.prod.outlook.com (2603:1096:405:214::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 09:39:11 +0000
Received: from TY7PR01MB15746.jpnprd01.prod.outlook.com
 ([fe80::bc79:d427:b0a9:a793]) by TY7PR01MB15746.jpnprd01.prod.outlook.com
 ([fe80::bc79:d427:b0a9:a793%5]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 09:39:11 +0000
From: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To: 'Vladimir Murzin' <vladimir.murzin@arm.com>
CC: "Kohei Enju (Fujitsu)" <enju.kohei@fujitsu.com>,
	"'linux-arm-kernel@lists.infradead.org'"
	<linux-arm-kernel@lists.infradead.org>, "'linux-kernel@vger.kernel.org'"
	<linux-kernel@vger.kernel.org>, "'linux-doc@vger.kernel.org'"
	<linux-doc@vger.kernel.org>, "'linux-perf-users@vger.kernel.org'"
	<linux-perf-users@vger.kernel.org>, "'kvmarm@lists.linux.dev'"
	<kvmarm@lists.linux.dev>, 'Catalin Marinas' <catalin.marinas@arm.com>, 'Will
 Deacon' <will@kernel.org>, 'Mark Rutland' <mark.rutland@arm.com>, 'Jonathan
 Corbet' <corbet@lwn.net>, 'Shuah Khan' <skhan@linuxfoundation.org>, 'Randy
 Dunlap' <rdunlap@infradead.org>, 'Marc Zyngier' <maz@kernel.org>, 'Thomas
 Gleixner' <tglx@kernel.org>, 'Radu Rendec' <radu@rendec.net>, 'Oliver Upton'
	<oupton@kernel.org>, 'Fuad Tabba' <fuad.tabba@linux.dev>, 'Joey Gouly'
	<joey.gouly@arm.com>, 'Steffen Eiden' <seiden@linux.ibm.com>, 'Suzuki K
 Poulose' <suzuki.poulose@arm.com>, 'Zenghui Yu' <yuzenghui@huawei.com>
Subject: RE: [PATCH v2 2/4] arm64: tlb: Add tlbi workaround for FUJITSU-MONAKA
 Erratum E#030001
Thread-Topic: [PATCH v2 2/4] arm64: tlb: Add tlbi workaround for
 FUJITSU-MONAKA Erratum E#030001
Thread-Index: AQHdXVVYZhIvVbstSUigINbLGWcO0LcEnD6AgAABRgA=
Date: Mon, 19 Oct 2026 09:38:43 +0000
Deferred-Delivery: Mon, 19 Oct 2026 09:37:56 +0000
Message-ID:
 <TY7PR01MB15746741F908990ADCCDB4712E5982@TY7PR01MB15746.jpnprd01.prod.outlook.com>
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
 <20261016-monaka-fix-for-upstream-v2-2-fc7ede7f9f48@fujitsu.com>
 <494fd8b9-b7cc-43ef-af0a-218c6afe0fed@arm.com>
In-Reply-To: <494fd8b9-b7cc-43ef-af0a-218c6afe0fed@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5Njgw?=
 =?utf-8?B?MmZfQWN0aW9uSWQ9M2ZkNTFiZDgtNWJiNC00YWNhLWJiOGMtZTI0YTg3ZTY4?=
 =?utf-8?B?MzlhO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMz?=
 =?utf-8?B?OTY4MDJmX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQx?=
 =?utf-8?B?LTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX01ldGhv?=
 =?utf-8?B?ZD1Qcml2aWxlZ2VkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFk?=
 =?utf-8?B?NTUtNDZkZTMzOTY4MDJmX05hbWU9RlVKSVRTVS1QVUJMSUPigIs7TVNJUF9M?=
 =?utf-8?B?YWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfU2V0?=
 =?utf-8?B?RGF0ZT0yMDI2LTEwLTE5VDA5OjM3OjIzWjtNU0lQX0xhYmVsXzFlOTJlZjcz?=
 =?utf-8?B?LTBhZDEtNDBjNS1hZDU1LTQ2ZGUzMzk2ODAyZl9TaXRlSWQ9YTE5ZjEyMWQt?=
 =?utf-8?B?ODFlMS00ODU4LWE5ZDgtNzM2ZTI2N2ZkNGM3O01TSVBfTGFiZWxfMWU5MmVm?=
 =?utf-8?B?NzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX1RhZz0xMCwgMCwgMSwg?=
 =?utf-8?Q?1;?=
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY7PR01MB15746:EE_|TYYPR01MB14118:EE_
x-ms-office365-filtering-correlation-id: 44a3d59c-3806-439f-152f-08df2dc4d470
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|38070700021|11063799006|4143699003|56012099006|261009223027099003|10067099003|22082099003|18002099003|1580799027;
x-microsoft-antispam-message-info:
 FdVvuD9tpWJse02kGmLwM/ww+fnmNPNgsruy3XY0c9F3rqoVNCzCdPT6/6Xd7DILJ8wX05NHhINnMScOGGgyyNuadHLoUmvIOdbU765MZGGrHH3HrxMlsW2Q6TvYNsQZYcv+IjCmAxrIc3khi1oCAmubXVDobN9A1tY5Z3sx8lW+AnXGVS/1b7SX1oFTxt+0KzdU5nlij1+t+ocmbxLkLXwQMKagk5YeKerBrgXX/s38APfvipuymTkuKXSFdgwi6N0fWMyR/T4r8gjXSc6zPTAoG5H2udSaTE/UVhC4CUvGK9iXCn/SZVWIPs4QyuA8XPC9KyvuHJP+uwwWDM1/75HLGF6I6/q183DqemCumWPHxgIrdgQyaDgRGJoPyMfgaCLA+IFZYo0qwrn8tof3226I9ba9LwzwxCGBEw9qGTZR+AsknsG3tpHJzixBOLcLfX8wUH4tZmigFZJ2LCDtCC6eckRw2D+KgBZcH+FZTYuq8vbmBgjCyqGdfsGxmtUKa+lre9/UczCLFBEYEYycc6Mq5NbWmGB2z5cGyYTa5UMZF0468fAhbnxY8qAeHLNRpNOPEa8VJjU8Y+ZIakY2ZbzmDXfILvcVHVPz9+2wwAZX5FgM+ck7xL9p0rpVQGmaJwRwtJdqA2HmPAS+JHoQDPKnqIBQrDEXBrDMj71d6bzipY4tZuy5eiQjd3AcJE1qfTeByhGFnA2agTLFplKldzRnER7WTlz449dgu9Z9x0uRXWwM8s0VxOlPi+Yv972L
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY7PR01MB15746.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(38070700021)(11063799006)(4143699003)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y3p0eE5tZTU4Sms3NXNiVDdOeGl3ZWhLSGo3cTZ5TmY1UCtMNnBLZkl3L293?=
 =?utf-8?B?aE9BTXB6S1pOVWpYSjhUbGE1K2RuR2swR2ZhakJzSG5tVTNJOS9SamptdHYw?=
 =?utf-8?B?bjdjOFY0RXRFRXJzL1FCWURFZE9QRENJeW9vdjJhTTRkN1JVZ0xIcEY4SXpR?=
 =?utf-8?B?V3lCWFZsZ25NZ1dIT1R5bzR0REtKZjdDbS9pRWcycUQ5UDZMTUxOZFkxc25Q?=
 =?utf-8?B?aEZBd3FqRDBheUxabXZTZUF3alBucVpmck81eWxjN1dIZzZkQkMrdDlPRXV6?=
 =?utf-8?B?REpwVW0yWFpTQlJyVFVLVS9ISUYrT3BheGhFcVQ4TDZxejBkbnFiQzRYeWxQ?=
 =?utf-8?B?d1pXek1laUwvNU5DYlFYeHF5aTlpNjVpTWVOd1BrRERQalNrU2dmWWxBNDdC?=
 =?utf-8?B?WiszemtOaDVLd1ltd09lSFFyZ2lOWWxTWmI1V1p1QkRHakVzRzFCR2ZTUVdj?=
 =?utf-8?B?UkJtTHcrTVBqSVZCM1c0bXNXTWlndXllQU85MUk3WFRpckdCOWxGeGFndWt1?=
 =?utf-8?B?VHIyZnFsMzlHMU9La1dFZWpqUllvR1JSK1ZiZFRtbWMrTGV2VXEyM2dSM2hw?=
 =?utf-8?B?cDNBZVRjd3h0b3doMVlSUWlERDNCZjFZaFZXVW5oQ1VHNk53N09KUGtnR0R2?=
 =?utf-8?B?VTcxYWFlN3VEUG9QM0lYN2ZFZFJ2NFhpQTVmb1FIaXovV1dBc2poRWtJWHpG?=
 =?utf-8?B?cGlEZkRDT3laUGxubklrY1JWcllJTU51N0tnTy9STlVVQURLWDZadHJ6NTdu?=
 =?utf-8?B?a01jQVFLNlcrNWppZXlzcmN5cW45L3lzNmtWb256MHBPQm96cVVOOHNORGMr?=
 =?utf-8?B?VmdRc2ZmSGQyT3hYMlJqaE9YMVpDTlpkNE5PQUxGTDVwNDVscFRnVDZqazN5?=
 =?utf-8?B?R2FtaHVJVHZ4SHNObHNuWStmVnhJbGV0MlpkMmJ6YnE3SnRCQ2JyMnhSRVEr?=
 =?utf-8?B?d1RwMFhrVWhERjZBaEZ0QUR2WlA0eFZoMmt6YjVrb3BsNlFMYk5mWUwyQ05K?=
 =?utf-8?B?OWpEVU95VHM1OW8vMFZpdG9kNENWWDNuejR5NjFEK1JoTS9lbzVtb1Qzc3U4?=
 =?utf-8?B?OE1BbWN5RlJCUGF3NDBTb085ZFF1eUdaTWhONURuMmN1OSt1RFBCN3NSaE9n?=
 =?utf-8?B?TE1OUW9wd3dYNDFaZlFONFNvRUFxYWtTczZsVzQ5a3FSSWc5QzdBYjBKNlVV?=
 =?utf-8?B?YVEwS3ZCb25Vc1pWQUtjVkRJeHFsMVFLS2ZYUXI4UU1IVUJvSlVlcmp5RVhD?=
 =?utf-8?B?bUl3azZnTG8wNW9GOERqNGFSOFFmdHZGY1d5RnZEQWVmbkN5aHRRK1M3YmN0?=
 =?utf-8?B?U3hBdW1HWjdDaXY1Nm1ockE1QmFFUmJNR2RyTjNuQUJpZGJ6aFZ5Sm5BUVdj?=
 =?utf-8?B?TEExTG0zTjdMdVZqVkdwSDhvTDQxc2ZFUmU1UzdVMzNMSE43aGJKL1lSZzhX?=
 =?utf-8?B?Wk5OQ2thSWk0UjNYR3Q0cC9nVnBqNUkyZVN4RjlUc2hra0dyU1FubjNCeG9J?=
 =?utf-8?B?Kys5ZlNjdWhBcW5hSWZ1YXM3c212Z00wbGNiVGVvVjJ1MmVzMHVMbVhTaEp5?=
 =?utf-8?B?cFJzUFlva08xci9Lc1Y0UGRtV2dTNnVveDhxanBFcTI1QXhOZUszc3dPQmRs?=
 =?utf-8?B?ekZtZDBBeDRjNXNnNGREODFSN3l2ZUtaMW9JbWVvaDB0QWgrQXFLU1hFd05R?=
 =?utf-8?B?bWt1UGh4VnZ4TVNKQ1dYUXZrOEY4cVhyaHRpQmNJSXRWam9OcytSZmpjNTF3?=
 =?utf-8?B?M0cxTDFEcGhJb0phTGw0RVlaOGRzQ09Eekw1QUtWQ2VxYVVsUXdpeitkTkZn?=
 =?utf-8?B?VHQrU2tkeGZVWHZzTzNLNEp2alFTd05Od2x4RXhVc0JKU0JNNThnSFMvVDFQ?=
 =?utf-8?B?Z3JYMkdnMERwUzJSZU9DckRLbjRXTm1QZGxhRmJhSzEvSWw1Tkk2WlE0QldM?=
 =?utf-8?B?VmNlMG5xRmJQZ0laSm5PZVFvR01CL3hYdXJBNDZuVTRqWk9IRlpiSmVwaSsx?=
 =?utf-8?B?enJmd0VIM3liU0dvL0J3ZjlJbzlLZ0llV1BnV3lzZjcycEJ0ZURUaUczMUc2?=
 =?utf-8?B?Y1hHblBVcFBTcVEyMUthN2NmeFhrMk4xQ0ZYU2ZVYXpRTjFOajBHUWgvUEJv?=
 =?utf-8?B?WUJ5NzFSNHdySmpYNU1UbG8rV3g0MUlWeWdTMVdkejRKaEhpWWUrdFNxZVlM?=
 =?utf-8?B?a1BRTzcxdU9KcngvYzFkN1FocExsbWhqRXdXaEJ2dmdoRUVISVZ5RWpTdW9B?=
 =?utf-8?B?dWR4aEN0U3l6d2taZXV0c3lNRVFVaUlkSDY5UURzY3VScHo1Qll4WTQvcG56?=
 =?utf-8?B?Z2t5eWtYNHhiL2JCNWZDUnNXVWpJQW1MTUU1R2EwTFhJS3U5RlhyWUNXdldK?=
 =?utf-8?Q?FD71qynW4d4Kq5kI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	PC9146FXpn9H51wHpCJJn9Mn1xV+huqrvQDmRLPKzxyT0l8pQWkiG0tgTmjNXNqoG9ObwOdTefV8uiXKfXWvtZnJmRDRgEStuBkUrNF+VywE68qXTXcEmaXWPb3ZE0qS7O23N3sxLEa1OlDd8N5svrNkupGb0NY/aT4uqIW7IOXWGTkp25KReEbqBSvkD24+kAvlRFd5UJ2HVRFcSwYhtEVvAScFqvS9zCv8WEgFHC4VJYoffKrJwa3BKuoWNDGolmyOTajq8UBkq93QeV75wh6itOPBgq4X5aMX0saq4T3sCakb0HVlMsnfszoX3zszSAsXI9Bbhrh8gLRjeWISRA==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY7PR01MB15746.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44a3d59c-3806-439f-152f-08df2dc4d470
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 09:39:11.0313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: exbK47vFLgiNkvpK0bLFeA8YsuSS7BpyVFpaT/AdoOnmlmuZcekJmXHa2IuNMlWf8stzNZ/0kSaFqlTdAyeKp2vQoGYDImBA8h1WmtDdTzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB14118

SGkgVmxhZGltaXIsDQoNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAyLzRdIGFybTY0OiB0bGI6
IEFkZCB0bGJpIHdvcmthcm91bmQgZm9yIEZVSklUU1UtTU9OQUtBIEVycmF0dW0gRSMwMzAwMDEN
Cj4gDQo+IEhpLA0KPiANCj4gT24gMTAvMTYvMjYgMTE6MDAsIFRvbW9oaXJvIE1pc29ubyB3cm90
ZToNCj4gPiArI2lmZGVmIENPTkZJR19GVUpJVFNVX0VSUkFUVU1fMDMwMDAxDQo+ID4gKwl7DQo+
ID4gKwkJLmRlc2MgPSAiRlVKSVRTVS1NT05BS0EgRXJyYXR1bSBFIzAzMDAwMSIsDQo+ID4gKwkJ
LmNhcGFiaWxpdHkgPSBBUk02NF9XT1JLQVJPVU5EX0ZVSklUU1VfMDMwMDAxLA0KPiA+ICsJCUVS
UkFUQV9NSURSX1JBTkdFX0xJU1QoKChjb25zdCBzdHJ1Y3QgbWlkcl9yYW5nZVtdKSB7DQo+ID4g
KwkJCQkJTUlEUl9BTExfVkVSU0lPTlMoTUlEUl9GVUpJVFNVX01PTkFLQSksDQo+ID4gKwkJCQkJ
e30NCj4gPiArCQkJCX0pKSwNCj4gSSByZWNrb24gdGhhdCBjYW4gYmUgc2ltcGxpZmllZCB0bw0K
PiANCj4gKwlFUlJBVEFfTUlEUl9BTExfVkVSU0lPTlMoTUlEUl9GVUpJVFNVX01PTkFLQSksDQoN
ClRoYW5rcyBmb3IgdGhlIHJldmlld3MuDQpTaW5jZSBhbGwgTU9OQUtBIHZlcnNpb25zIGFyZSBh
ZmZlY3RlZCwgSSB3aWxsIHVwZGF0ZSB0aGUgTUlEUiBoYW5kbGluZw0Kb2YgcGF0Y2ggMiYzIGlu
IHYzIGFzIHN1Z2dlc3RlZC4NCg0KQmVzdCBSZWdhcmRzLA0KVG9tb2hpcm8gTWlzb25vDQoNCj4g
DQo+IENoZWVycw0KPiBWbGFkaW1pcg0KPiANCg0K
