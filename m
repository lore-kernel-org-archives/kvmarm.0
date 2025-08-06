Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012069.outbound.protection.outlook.com [52.101.66.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764B6202F87
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 20:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754512226; cv=fail; b=GaCZj+2iERaAVc/aQ0nd1PC52xOJU6mlgV+oigWyIXtoZuSLghnim4SVXLaWW6vIfUGCd4U3tP4oe0dmW7xvuTddSKG+oam4WKl8yNhqJhGWJW8/0Ab50QyBnG5y83v6T5MGJX/hDjM4k6sUHRi8ELAiXNV4peZuXZc5C3is7I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754512226; c=relaxed/simple;
	bh=wIXF044wOcuXo9aJbj9bSjEbUfBUbDGN6f/YqAQuzZo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VYdUb3onOKOUrxV7p4yvsqrf/tUWeutXR4PIRA2qw0VdFs6T4+yZrSwa0zAcTr72D8i77bDx1trHPG62QLOd21dh8n6iNsAGE1DbaYi5MOWxc6HULazr0paswl4pKZLVBBSqfmVjNlXQTvdyKxyii7wrhNBejTYZ/Z9kLnY6PeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=ifQi1JOT; arc=fail smtp.client-ip=52.101.66.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="ifQi1JOT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pSe49j5XlSCKvombrAV32yMQzsvBsFSLfImefoxqmItIPuAWe7JJm+KmwVMwmQfD9GLgclxDMtypjOwL4d/1QqvSsihPy2dVqJGeXiThe88Ybh77Khl83juoRWPOEX6BUw0BDLGk4LWgsSaUVrq1j6hAqX20Oha/4c8MgGt1LwD04UMrUlPnwOwGAVeYBiqY3MxaSDs0Hk7eHIun26LeI4wKT+f8mu+AnYslxxFns5d0h0lX28y+DJEjBaNB7U59aLXwQ/WDfOWQE5d1ewd/8XtsJJwTdNzYem/Zd6uU2WzuDhp6IO4/7jeQQdSBmS+DTR9wc+YOR3wlfA64UdcT/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oyPELrYiRcHqMBEopSVX2pu3JHB/KfdDhddqMMzwfcg=;
 b=leicA6Oat6gMtVoNY/89pwCbfncqsUFnVOrf+yLgAe4jNlk1swMuNhurzD2jMhoYo92G3mY3mRUA7Cnf0ZlM9T3z3si9gg0U2P1JV0vbzjVUVMxIB/4J1h7CvVP31DjyofbITOV4enISIqQUFZR6j1v/mzR4J5dKnfGdnaUx6e6d4ah1WJgM9XAzMIzzhG74+iUjGScpi2KkhMLXUDVkXH3IjlAQ5ae1adB6C7LjezLqTh+/uEAct8R8456F9raw86v1pMx4hE3tH1N/Oc2SQUA0M+68msYhxBF5f16vd7i75Et9JuFWx9Nxpgf8t1yuCTutA5lG+EtfrJPaclGNCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyPELrYiRcHqMBEopSVX2pu3JHB/KfdDhddqMMzwfcg=;
 b=ifQi1JOTl95GJFtYhlnbu+YEMyeWi5HDBYUQzhh/75HqGXExFEtfEDFiP7nl/qlWA4JN2KXW07s+aF5zwh8Btx1SzidlVbESpbuqDl2k00MIzSh7zrUgPMJjYcyHMHiMts7AL6F/OICupflNYryjwAeMxUo7H8aUv3cuYtJRKBEcg3BJKKosmfVORbPMRTWNp37Mw6IAUOMJI0akazxQrxi867sVD3WAENH0ovxun4ei8MX5wmfUez4MA2b4vgvHKdf2gYoLrbgxVSILiC1yvTQOVtlB3miTKE/rX1DSFPwgWMO3O2zd4p56yZzEKGThjGVIDAQCfCt0BGWYtm4hHA==
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 (2603:10a6:150:16a::21) by AM9PR03MB7107.eurprd03.prod.outlook.com
 (2603:10a6:20b:280::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 20:30:20 +0000
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e]) by GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 20:30:20 +0000
From: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>
Subject: Re: [PATCH v1 2/2] KVM: arm64: nv: update CPU register PAR_EL1 after
 'at s*'
Thread-Topic: [PATCH v1 2/2] KVM: arm64: nv: update CPU register PAR_EL1 after
 'at s*'
Thread-Index: AQHcBtznfZx1EzPMhEmSJJRNthoKUw==
Date: Wed, 6 Aug 2025 20:30:20 +0000
Message-ID: <87ldnwfb1g.fsf@epam.com>
References: <20250806141707.3479194-1-volodymyr_babchuk@epam.com>
	<20250806141707.3479194-3-volodymyr_babchuk@epam.com>
	<aJOhnHCUR0Af4XJt@linux.dev>
In-Reply-To: <aJOhnHCUR0Af4XJt@linux.dev> (Oliver Upton's message of "Wed, 6
	Aug 2025 11:40:28 -0700")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR03MB10456:EE_|AM9PR03MB7107:EE_
x-ms-office365-filtering-correlation-id: 8dd6900c-157a-43a8-3ccb-08ddd5281029
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|42112799006|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?2Y73DLBB0YtuVhFos0QOVStWPPK8pSWCiCA9Tl44krUK7yLojCaWmRrCVH?=
 =?iso-8859-1?Q?kXuILxooWTJRdy5oX3QilznM8cKv14yR7JYM668LoOQF+fKobhB2AKJd/s?=
 =?iso-8859-1?Q?6ptKfJB9iUewyz/MvSuIDfwRMGjyydrluZgRPtbx2b372BGiH8lvDJR89y?=
 =?iso-8859-1?Q?k+eggKpuFFXxXw9tjcmH5kLF5JYPkQLxnU/BMCzYhS8Zwca1YXRIXQPnq4?=
 =?iso-8859-1?Q?ALQ72VZw3rf7PN1DT3iW0KI1+8bvEwPcLwyl5CAU7NR0/vWAz+RVIkRrrg?=
 =?iso-8859-1?Q?5c3qpRx7wAWQAARjKv64tmHKh8azjTPZvkMlR/dKji/w192B5iXi/c4KmH?=
 =?iso-8859-1?Q?Fry5zBWs/9nnVtXkHKEE4mjNm2F9aRUdRPuVZDTuPKMMANoLPM2qyv8jc3?=
 =?iso-8859-1?Q?zNIMYfIsx/SKPbq5WLNBgyjvlk6Oz6xLcL4mHG6xCzqlOYWSYgYa8Lgd4b?=
 =?iso-8859-1?Q?b7ThsmynTySbw8lD5+EYPmOt40aDHLm7avy2DdXIr9uD3YrUKfteQP6xjB?=
 =?iso-8859-1?Q?TuBd/3ZC1wg7STyD721rEeXpcmo6pAS7kDol1KXdHplcV3uyvyMdlI+I+K?=
 =?iso-8859-1?Q?vGq+cecJGJi2Dc3xoVGSPMUB2pvJdchuaeXmpGcTosUMghBh3/teEsR9aM?=
 =?iso-8859-1?Q?wFpwZ9HPEDTNAhCst7w1tunM/t2zp0cohhh4dvLngzDPFQztoWbzyCm6wJ?=
 =?iso-8859-1?Q?CtBwVBfBcvYer1pUlCJrqCuS4kACdLYP7iJOtsA3kgMDF0gEdAgxpzdUer?=
 =?iso-8859-1?Q?VpijwRwKFD9jSUQ7mSGxKbxQk3kg0G8x2LBImi0Bd4oobR0HgG6go/2sOG?=
 =?iso-8859-1?Q?Hj6/Wjr0fxfIqL16F1rAZPkmNxJVXdTTinNxAkSsEOkvFvQC/M9Imvnatx?=
 =?iso-8859-1?Q?3/2xLc6oi4wHPAVGorD5WFg+hROr9dxADFOLEo6HwaNgqKgC6R73pXHZoi?=
 =?iso-8859-1?Q?diK2mt7nQc0VG1AAKvBjmRNMz8HbDfYtg4Lcvxb34hkZo/BErdb1AVIH0o?=
 =?iso-8859-1?Q?pjthngYsWPSS8XAHFVpTreu+EFoggwLZSfTDi8qi7dsJc57TxzOakgt3GI?=
 =?iso-8859-1?Q?OOLN+nVI0HUBIafLC0cFSAPE3vfQK8Gi9WsVktBZAPgec8y3NzFX8LYSxq?=
 =?iso-8859-1?Q?T+lrbOHwhrb3uFaqXSplbtDD9ZdBvKOkOH2MHvm/DDgMzvvkOSpPtt02GC?=
 =?iso-8859-1?Q?IXlyuolsOiaOSIBL3Kde6tYfDmDiQjJG0UmzwMRWR6DleuKycl+/2Ujmqy?=
 =?iso-8859-1?Q?fOlw2oPLJdE89fc4VYMEK9NpwyvLjNLjcGD6RMczZU1us9rpYRyIAyC3bf?=
 =?iso-8859-1?Q?muMF7l3F7wHx5PwpZYbH4JwKLPqzJpuEy4TkYAgwucvkLpqRgfRfNBB5d+?=
 =?iso-8859-1?Q?2rXJdz05t7fKgSYjUV7ZT6EQnbPsoLMVgolgbpEawSB7etAE4w/2lPUr44?=
 =?iso-8859-1?Q?hUFmw7yLMmpeBlUueNDkfBQKbggEfn2IggO6tfH6tqPJgVxCm2UMvzNeHU?=
 =?iso-8859-1?Q?n5fm4fS0v3DC+jn5CIy82P7EjM+Am0wKLyMoXwjCYBPg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR03MB10456.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(42112799006)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?6V3heE1YjMhQr1WCPwoNwUwfdU+PR8iIepMw3UCaQ/6Rg+3glQzg9z923s?=
 =?iso-8859-1?Q?NK+1PtKhLwV40IsYNqJbznnx/zLcNMHmmNgOTj9MmHDcvIkFxOCLvh/N0G?=
 =?iso-8859-1?Q?NERr+BaUqSHod5YnyxKJHfd4wsvZ7E48XoTx9RNoWlUfCJ6lr+Lcim45Vw?=
 =?iso-8859-1?Q?h019VW5FfUseyB3SoBxhMD1vPLrH8UpNBLqN1DHsQJyrr+GUBMqXNgdfjK?=
 =?iso-8859-1?Q?co0Up53HUYZB8ql6Jz+7UA/iC2bFxEe/fxEOYbw8/nStb3ys8lYcarVES3?=
 =?iso-8859-1?Q?Q/E+uKwq61kIU0nfYfdQQMNZTcRflVfSBW8knopMD1YgD25ZoXoXqByI7F?=
 =?iso-8859-1?Q?FRAK6PSoEH2eC7WUDrt2lwoHu8VUuH5CpDi4CtBO+bOAbwyioYE34WUmdU?=
 =?iso-8859-1?Q?LWEIMgmZJkpfde+5m4PBG4aWkBwlMlg3PML1Nwlt2lU9Np8p7gOwqxq10f?=
 =?iso-8859-1?Q?eY3MHevciyPqTKIrkD6U0dUiLSHyNJAibI+IaAya5uK3FrWQZbYtLV2aN2?=
 =?iso-8859-1?Q?nlt4ibkpT200Tl3ArGpsxYyv6T3Xm5LAVt9U8Z1Js28iWxw8IP+JrfLRkI?=
 =?iso-8859-1?Q?wOuGqzifE+QF90gxHQbfPTcCucMc3AEk5m92Qcv0mRAkRo87ulNje8zatA?=
 =?iso-8859-1?Q?Sr9begst+/L9VAlHoTBajjP5vHqNrBrQIIVTcYjjBhXr/IhkuXKjtlK+J4?=
 =?iso-8859-1?Q?PCGCGBmrksdJiLrn6dDgIf0OQFqWEc2w6KdoVlrfvGxG65MMWi6lC8K/ir?=
 =?iso-8859-1?Q?Wq6iVrN113MVv9WA4T01dSrwUIa6n3BKdZzKfQxQcZMa5pRvvBaSigV/hb?=
 =?iso-8859-1?Q?gfY6r2R61fR4WSI/Xg4l813uYVDv3j/A9aMkvauS51mn0K5WqeUCAbYPcj?=
 =?iso-8859-1?Q?7vV2tfXbd2JTMoIgm2CrtiUj/D3Q5JzgjPk9hqQoKMSxurp9pQLHG1g0eJ?=
 =?iso-8859-1?Q?DrgTImeHFp6rmQJ+A8aLeCPfdhxSomkV+j8ME7ZMSmjfuivlE8zr4AFUk6?=
 =?iso-8859-1?Q?bmto+rrLHI+tCPM0wVvRzfQQz40oA2rWdkvIcMrtJqaPb2t17oVV/XvBOC?=
 =?iso-8859-1?Q?qp0fHCI/C7fgMeqwj6IfMr9OeuCcYNQ99GafW6IWrbz6IdPOzavMf505yZ?=
 =?iso-8859-1?Q?N0KXIzgTZg6gBgXjbW/4/AdlFk0FJAKGIozIVEETYqbApVo+9RV2OQBBwh?=
 =?iso-8859-1?Q?MajTgkvhp5DUbz5jhWTLlOIrkg7yZye/ilqsK2wrsEMiNis75298Zrp6Xu?=
 =?iso-8859-1?Q?lFUwwm/BaWKqRNp0tpsXj9IiitiYoc4hSZf7Acem/KMcVBXrcPgIqZdrsj?=
 =?iso-8859-1?Q?RHx4lSQHH59NXRakRZgAEsq67ecH5OKqhFnDfid9XKmALLAm1h+4tn32l6?=
 =?iso-8859-1?Q?zU/WSmgv79VYhhTB+J3YCzITEXyiEmT7bIHp+RMx3uCa04XWupITeHbyDz?=
 =?iso-8859-1?Q?eosvwlNt/FBoAN/I6lQLaRXZ5NQnFIHecBlKzSR6aiXZqAsq4CHuhSTJik?=
 =?iso-8859-1?Q?0j1D5SmggCVh5Z+4cqJOnbgenXyb2nlTFyRcoFSfri4jeSQ6vJgpmjlKr8?=
 =?iso-8859-1?Q?33o9kF8HhgQsUMbZIG9qa3c3x4yKrPaSwi+qaS4qw3InfkVyIIWG+Fx0CL?=
 =?iso-8859-1?Q?z992x5rgdI1wuCjNp4bxv70QOflUR/nCLZjRnLlLwzCaoeeGJbmeQ6Ww?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR03MB10456.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd6900c-157a-43a8-3ccb-08ddd5281029
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2025 20:30:20.2914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pHjC9thHKoMwWWpaFY36bz8QECUktdd1Aaw6L590iqlGZ0aivOWb7h/stAjRqSZjFB/xCefuvhYjC8xc6rEoihfk3nD94TbEsDsi5O7T/jE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7107


Hi Oliver,

Oliver Upton <oliver.upton@linux.dev> writes:

> On Wed, Aug 06, 2025 at 02:17:55PM +0000, Volodymyr Babchuk wrote:
>> Previously this code update only vCPU's in-memory value, which is good,
>> but not enough, as there will be no context switch after exiting
>> exception handler, so in-memory value will not get into actual
>> register.
>>=20
>> It worked good enough for VHE guests because KVM code tried fast path,
>> which of course updated real PAR_EL1.
>>=20
>> Signed-off-by: Volodymyr Babchuk <volodymyr_babchuk@epam.com>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>=20
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 7b8a0a6f26468..ab2b5e261d312 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -3463,6 +3463,9 @@ static bool handle_at_s1e2(struct kvm_vcpu *vcpu, =
struct sys_reg_params *p,
>> =20
>>  	__kvm_at_s1e2(vcpu, op, p->regval);
>> =20
>> +	/* No context switch happened, so we need to update PAR_EL1 manually *=
/
>> +	write_sysreg(vcpu_read_sys_reg(vcpu, PAR_EL1), par_el1);
>> +
>
> Ok, this had me thoroughly confused for a moment. The bug is actually in
> kvm_write_sys_reg() which is supposed to update the sysreg value when
> things are loaded on the CPU. __kvm_at_s1e2() is doing the right thing
> by calling this accessor.
>
> For registers like PAR_EL1 that don't have an EL2->EL1 mapping we assume
> they belong to the EL1 context and thus are in-memory when in a hyp
> context. TPIDR(RO)_EL0 is similarly affected.
>
> This is a bit of an ugly hack, but something like the following should
> get things working if you're able to test it:

Yep, it is working pretty good. Will you send the patch? I'll add my
Tested-by.

Or will you prefer that I'll send the patch with your Suggested-by: ?

[...]

--=20
WBR, Volodymyr=
