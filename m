Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020128.outbound.protection.outlook.com [52.101.85.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8AD2D063E
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.128
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763399846; cv=fail; b=ZIc4kw5k4rx2fXWpWlwnJ5W0Lr9DeXw7/TdtyGTPuciUcMUW6bzH4ZGxjAcP5wIkUlLdMd8ORtdOloq91gC7WcMj/Hz9KzSBYSOb6NSOn+o281gxJ3f+hKz3UQdE3QIMAUp3GN8mwtJc0+149Qxo4u9ozg0RvbrGg7EBdTuhpD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763399846; c=relaxed/simple;
	bh=aK561mb+rlD9GMp9g/L0C4N9Tqct6kmpgCKvXDqJuxY=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=eAh7F1DTYGWzvGXqBN6loarexQJSAE0KnVn8O01dgH1Ruo7WYn7/3s19sli9ruEGRkFLPZObW7ZvwCZ5xoUymuw9mNcKMZhmdw64U1p32rIRUshV+g893i4SfPTiCWig8NKf+oK9Q7w0BIwV/BYbMiuGyzjr95frC2jCU47qJ7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=m8N8mFj+; arc=fail smtp.client-ip=52.101.85.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="m8N8mFj+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r9X5SFW3wOevlexizsgx304XlhTO8I809wD30D74FfOIJ7BljgHXzxTE8iyj8dt3RJuf8825p/x9sy4nqjnMAgkEGuTb+cb0TnI6+vyP0JL18MFgAKYMOdkpA40amL78M7k+9SH9TUu3QY+0lJ+9oRam8cjZkx101RVh+E2kaSdiR1lQrw3kAG9Ae1a4lBWVlxQCNZhFSGS6gmh7eR05HJpDb/bfC1enEjEGbxNJLlDXJVb7djkV9SclgSsbGrN8UVYXcKBJmqJvzzjR2GmU7PTrYM78y21wnFnajJsZlK8rTM3LqwTCyTbmnCPS3MGIuwHp4i4gED3KfTCkruwrXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFvMfj3k58/0neyP/RksIYQz+jG/67M4nI4GBBkeZHg=;
 b=CQXFD1M7FVsR8163FPdFs7n35NEUURs/ReHBVPfywj4uW6Um0GbouLGcirw/GOw4jV2nYnJwrf8ME5b62cTcML62P+Stw5SohTpsNblZcFVBMbOchI8uCXSkdE6rZyPjgR+y+2q/qu+4gnlk3rovQZdlBUdTJ0QGk4joM0FUVQuNYcnjHLG6mdHvUjMjFBVzyACqqL5TX0kDkuEDDGJMyl6xvSEE1rCSb9hicsoYHdF68T56kd8rzboP7QAFcQVRBcxApF8W8q5HCA7WdNCregC1NKBCUyZH+sPEGuWmgSHfaF3rM/H9R2lknmEd196i/GqGIKI9emZoasjz3uAjwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFvMfj3k58/0neyP/RksIYQz+jG/67M4nI4GBBkeZHg=;
 b=m8N8mFj+ivZuF/+tRIp8Ytfcb8fcr6q5A3wrDyq4da+EdRPMf9DCPGQlNXhPIPI3TR5mswQayZXFP8bUYG3pqbXjgH7l4qAGk7crWgqEOihogCYA9/yJHyjD2gpUEqnMOru2jj5t3e7pG+pXTbKHDopm6nG6qj3t4t+PY5Xr3UE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 CYYPR01MB8262.prod.exchangelabs.com (2603:10b6:930:c8::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.21; Mon, 17 Nov 2025 17:17:20 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 17:17:20 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Jaikiran Pai <jai.forums2013@gmail.com>, Catalin Marinas
 <catalin.marinas@arm.com>, James Clark <james.clark@linaro.org>, James
 Morse <james.morse@arm.com>, Joey Gouly <joey.gouly@arm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Marc Zyngier <maz@kernel.org>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Oliver Upton
 <oliver.upton@linux.dev>, "Rob Herring (Arm)" <robh@kernel.org>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Shiqi Liu
 <shiqiliu@hust.edu.cn>, Will Deacon <will@kernel.org>, Yicong Yang
 <yangyicong@hisilicon.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] arm64: errata: Work around AmpereOne's erratum
 AC04_CPU_23
In-Reply-To: <456bba04-07b7-4c27-96fc-9bf226b12fd9@gmail.com>
References: <20250513184514.2678288-1-scott@os.amperecomputing.com>
 <456bba04-07b7-4c27-96fc-9bf226b12fd9@gmail.com>
Date: Mon, 17 Nov 2025 09:17:14 -0800
Message-ID: <86bjl0o9yd.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0333.namprd04.prod.outlook.com
 (2603:10b6:303:8a::8) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|CYYPR01MB8262:EE_
X-MS-Office365-Filtering-Correlation-Id: 5935b2d9-aa77-4ea3-4b53-08de25fd2a2b
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|1800799024|366016|921020|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XDUnTmtQvAwP/1KV/UuPeAlSrb5Ym/qzGD0xf7SqU3jnEbFDsLArogLOiYvV?=
 =?us-ascii?Q?r4+2BoG1M/WdSeBClK3AVUPeTl9HZU4CTSifftUCl1a/ic2yKKdMzyra0dyi?=
 =?us-ascii?Q?g3+VT286VoyOM1e94ygrEKSNTQK1nbx94wlvBlDDP6XpsknGFWWvpw3IffC8?=
 =?us-ascii?Q?AQm3bmm2ffG+fCV2Fu0Ns12zH2Ydw1SesvfpUoDf+K/9a8Yrm1QxFFH4eWm7?=
 =?us-ascii?Q?a+FOIbqXu8S0iZX/44rz5vVI2Yjev2k7itzHRo/8Xl8roCHsc6/5X800IZgT?=
 =?us-ascii?Q?+7bB9pAn+ha/u4/bhFgh5krG3TIFHP6uGB3dArGe+T1cG/zlJtemL7LL6/V9?=
 =?us-ascii?Q?KPSHz2uKYJVZ9devqqGpmVx8SvwnjDSMTyu+ynB0y5SMTDCQmils2KSqpfUx?=
 =?us-ascii?Q?9fD/yCPrpBoj82Lvot0H0G0+JqgQjDwzSRiwNWfs5DipqTwhbTJC58Nmlu3x?=
 =?us-ascii?Q?fWN7YHKh8Mo3TA+QSH2CENVhEGJgvPvB9+1SeuUb1BXb5hNNwbvDEp6YBi/C?=
 =?us-ascii?Q?q8PNmCZnyQyXyZ9GskgFwfzfGB4hchJtF6YpI/ke0YZFccoytN7mGNUVVEWL?=
 =?us-ascii?Q?nqgrCemtHyK1cdLsKUIYrk/myvzIZg3r106yamX0TIEI3pXfMnFlLbdAMVGw?=
 =?us-ascii?Q?ek5OyKx26r5c/PcoF36BpLBpgFMSKq8QELVbkQJz0ajcwJjviCtqFuUw9wTD?=
 =?us-ascii?Q?1YoPCloM1Z2H92+hT6EYVSwE+VaR54mzZjOzUJ3hP+eZ4EB8OuE6FVcsi2hN?=
 =?us-ascii?Q?GH6jgN8ZNzjDLHVDzVICbP6GVHOiKXQcG3dCQSXiXatoQgbeNUdc5kyHdTfp?=
 =?us-ascii?Q?rKkKGpPxpZn8LfIptSkKpRfi3RIr1eR8K4qAj3YR0LU+ZRG6dlg8Cq56hgMV?=
 =?us-ascii?Q?DGbOc0elE9NeI8SFFMwVAJZinA9Sw0MnzbO1o0z0Y2r0ONKJb7YiKjjUM9Kd?=
 =?us-ascii?Q?+BhX24d2M49wrJVzC1izn8lkOU73E+6w74RJRL5Dwgyd6Vv4ks0fIVq9eA8d?=
 =?us-ascii?Q?irRARwyX5BAmr5ZVYPWbsE38ftd+idO8JqzcLQxIQpw4MnCYCrcXLG1z56bn?=
 =?us-ascii?Q?sgTt4Js5dPi5vdUBMfUBP3h9m8M6ODZANz+XAacckO3kteUr9fY9pzr7SH6x?=
 =?us-ascii?Q?Ii2qBIquM7NPSoCIUGcqzJT/6gMCFGN9DOYsoDhTEzV+UiBWiOu0UVUXIERD?=
 =?us-ascii?Q?SwPur1dYDcpVuG014Ubtup+HMbZHUtUFJCHkwVrsSjOZDOIrmH7yNNNcRDph?=
 =?us-ascii?Q?QsOxdJ9mBMAFenAix+Q/OsSwL3RWNp1+pnT+KxBCTtXe+j3kxt5PY1XjsETc?=
 =?us-ascii?Q?IBDgw7mziwM0CRKehG1EqbmPWfUlKuyh0txn10jOlzlfOfGYTpl/G0YqKTV8?=
 =?us-ascii?Q?Hh2Fc3k4/AUsBRAPeVfvKV4as+QcuepuZ6SmMi+AccFQknWldEr5/o961udY?=
 =?us-ascii?Q?bufIzWcTYSKS2nWTZYDiv2YVgqNvgf9x3kLsBOfHDbIy6V4lKW6l9C/LNZem?=
 =?us-ascii?Q?Zf8n2HuLJ1Bk9MqVEhQy28mQsHSr8GXhwnAUA6EebUzRj3DxHIjvaqKxMw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(1800799024)(366016)(921020)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?247wiHT0eRQvaIoRAcM7N9Gn6nwC429D/fuXXZfIJJTM4ynzd4xHOpiIUBDe?=
 =?us-ascii?Q?rAJXPnw0EijoVEEfR20SEv6KQbSw8dYlqhhtSD2dckEgJT1w1o6ZYaHZD794?=
 =?us-ascii?Q?k+Zoi14NgwCTyJ12GEPPsWESWOtFrVH6nCPSjpB51BxgmwyyUx8T6LnlBSM+?=
 =?us-ascii?Q?B9DF7Kc971wVPgA5cjX9xKty6w3WVAH52GXVwd3TeqJTbMAbe8y8dKzct0IV?=
 =?us-ascii?Q?cXpRsrlps6hxXhArExYwaES/R+OjSFhMRuAoJNT97jD5RP64FtasPwzyxdiL?=
 =?us-ascii?Q?WsvnQsAqBifTwZnR9Py3AgLYKei2pX9HEvIZ8nUtcZNYB3nSEVa8UI7MLnRJ?=
 =?us-ascii?Q?Lb7PUWoCR/8CIKTJqgWcUqqRGhXN713uvf6C/bMbX//8FVQ285Ce0ZCEnhfM?=
 =?us-ascii?Q?iG7/uyHXVIIWEDDbLaCisNnXX/nf6/hQgT8akpVo+oBn2tlPxrwLeUoqsZ55?=
 =?us-ascii?Q?zCtcL4DukP8Eh768KfV9YwUDmMU7uy8yCJDZlu0jF172zb0tSGPOYO8lDkV6?=
 =?us-ascii?Q?+mlaNDAr0pE2Td5zir+Ihlnn3TKVtudnKXtTkh2SB0g5zti3C5XvNFPt7Kz7?=
 =?us-ascii?Q?4MCDttYWk6YlXuYBASLPMt3ZmE8ENNbqEJ8k02U7IK9wZ8b5gONZpI1KBKlb?=
 =?us-ascii?Q?7wfxrtILh2JrKiQqrGF1VcbwiInU/lWqWQkiBWywLAVJZg+yvVr6QwrqFbMK?=
 =?us-ascii?Q?Vu2QJCNS9WOqM4yUyRShsuaV1eoWb5wktYT+SvJSNTdD2bU6aWRRTrsQ0aEO?=
 =?us-ascii?Q?2kXCCScP7xOi+4qMdkbbchzev0bh9JNrKYhDNdetE/uSIojjnCT90d76WTQy?=
 =?us-ascii?Q?zzBozpuClMwiRR/ISs0S7byHMgZL/HDl1a3yiTS6ohq2Y7JvMGXEzvMh95Cb?=
 =?us-ascii?Q?P68AtA464d8DjefuW8zLysKrZ1uSDkiWCCuyn3H51J9c6kMjFR3Pqbp56Pqe?=
 =?us-ascii?Q?qzxngab4WUjgJvkhiVN9sBnR34FFlnbh467Ww1kyJoOdNXhc3qBW+uZhDfAp?=
 =?us-ascii?Q?O2U36JxhgNuhwRWS9v6vYkM4hArsg3qhM4+OvGPlxhEGoewl1RAoTs3jkKNL?=
 =?us-ascii?Q?eggw7EZ2zGc52tiEKWCof2pg3VJ1bsaX1axPHTP/ycbbm9+g/t28Gym7IV9s?=
 =?us-ascii?Q?puiKl7aqsLGmw8RWRsB9/vyyqpziI7YScoV5Q+5y8AxEh/sUYxieIbEw1Ou6?=
 =?us-ascii?Q?8ud8Vsd0Rduakvf0Np1cikALjl+pFLN8zbUszjV0CIF8c/1ohvXJ3exs0xXE?=
 =?us-ascii?Q?kgivov6uEpp+ANkadcyUOFimlVoh62uyhr6ieIiqfa4/1E3vhT/qRpTi5EQE?=
 =?us-ascii?Q?pJ9buF2DeETXqdINoEVvg+SiCLYSotv+62Ky4f1GVxHxBJ2E35Oid7njSggl?=
 =?us-ascii?Q?sa0gfqKrDa7/wI/++xxbgfvS0bBmJorTU7ISvkF1wRBqlPJQrfKkhpdyXBmL?=
 =?us-ascii?Q?gSGg5kbdTqKcm7cf7A1jS2+tthrHtBLHlCzO6Ef1kzDR/cW24NOjyEmwW6zL?=
 =?us-ascii?Q?4hhPoZ3/dptfHZb4BSlsXPb0Rf59eX2YvCF7oLRUBiytDfCxKyZu7xtEsCWm?=
 =?us-ascii?Q?1lAWPh3+pZX5tIgIRs1gK6l8og/ZfeMKE8zdZLVI9ozpbfp30Z97lcEPc61H?=
 =?us-ascii?Q?epWA5c5r5LlkNk+dBefMd3I=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5935b2d9-aa77-4ea3-4b53-08de25fd2a2b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 17:17:20.0767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDjBv+rWoUjzHO6yHMn3CDACmkfYA1zOFo5nB/QHHsdF1hC+LlW+nN1zAnw6H3s1POnfb/dwqk/5OfhyAdKitokBlgIOP5dnLIihtpxzsPrNJZkMrh/phZ2R40IPTXyl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR01MB8262

Jaikiran Pai <jai.forums2013@gmail.com> writes:

> Hello Scott,
>
> On 14/05/25 12:15 am, D Scott Phillips wrote:
>> On AmpereOne AC04, updates to HCR_EL2 can rarely corrupt simultaneous
>> translations for data addresses initiated by load/store instructions.
>> Only instruction initiated translations are vulnerable, not translations
>> from prefetches for example. A DSB before the store to HCR_EL2 is
>> sufficient to prevent older instructions from hitting the window for
>> corruption, and an ISB after is sufficient to prevent younger
>> instructions from hitting the window for corruption.
>
> I see that this patch enables the workaround only for AmpereOne AC04 
> systems. Do you happen to know if the underlying issue for which this 
> patch was introduced, impacts (or can impact) AmpereOne AC03 systems too:

Hi Jaikiran, this issue impacts ac04 only, it is not present on ac03.
