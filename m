Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013017.outbound.protection.outlook.com [52.101.72.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED659215043
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510425; cv=fail; b=hTHCjrHSBfDzCUjyHT1m08L8nJA4FakD+0fdRjTQFpcLlT2+zgfgeWi8Nvoz5amD2uRysyJgp0W+sUe1RoXF0YRVz1MR5bqQ6E/mWiLkj+mdk80rjrEuZz6VyS7XSpoxR77xQflB6B4oyrP1Q3Bm+fA091OGGUO062Gab2wRgYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510425; c=relaxed/simple;
	bh=1ryrhyy51V6gcxbTbBe6yk7rrv2yCXc2ZSLmK3bO0mo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rpZHELqvN3+YIAvdApmNHoC0RAEqos5x36qZKT/zLEdQmfMN9eJhy/4ck1kMO7CPj7E7063Jskf0pfqfVbvl/Xn26t9rCSx5vgTK2m5e2rcSqbXvXfdR0Z6x72Y+zBJKcm74W1w81jPIUEG90A0PHHf4DOchPGb3qw1arqM+oOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=KZw2qOvl; arc=fail smtp.client-ip=52.101.72.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="KZw2qOvl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4/UiUfsi3bdC2iuSu8KALZ0rTVt2TbBOONhIdk/O92aY3OltMoOmfcUus5X7Z08o9IOspk3kwY3SdnZTyt/5at19tYfRQ8dSfFAqDSkWvlU1NpDnyMpfq6xVh2cZcIdAmJDQsnRB4Vl9CpMKIi21zI++Iye0HNk5B65HhGIi90itArT65vdi+m/6AogEE0RWXe2DXzjXFsExHn68kc0rg7uEvah8BXymer2O50n8y2wun6TJzZSWjvLY6WVqBo0BCNUcdN7qwEzl4fuj73KddbduM8GHV2jgs1xWOtZuUz8xo2DV0swQN5aDd95Et9f2OrGyDLJc6Z5ILAi/xbHWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8XbF3ou2JUfMvOUftmmvc1qi+T3keML607+SozwcFA=;
 b=f4R5ZpsdaqF7bPlxi0aYlchejKJ+P559knfVuLkVy4zIo2KHChmyxatBSkOsyg+h2C3STGZdNzI5QTvLK6pQ2NPaQsvyUkePv8/X0fTpJ3OL0HvlO7deXfHD4L2RRhh3FKrwQx2p0nyIoaSEVWRKVEo4BtP8mgV7kR0FCgWQBJvmDQIsNnewbJYmuNhTsh2kweUwsyjeGEiTFnVdhOURKdqsd1WKQg4ZKZsvudsCta4GtH/dWt0cbvBUNfc+7tH7rs5+YIoR18ztTor7dMk6+o/x9MUx2sqDIxadCei4CbI1mN+DSXqJDKpjT3/M8f54OM7BzQAl1YB14a41BYfUMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8XbF3ou2JUfMvOUftmmvc1qi+T3keML607+SozwcFA=;
 b=KZw2qOvlSjaE7Tzo8k2jEAa3d2letK611pp7zL7qq0pCzE0Q57foR94COErW196JiXLYrQlF6+/WRZYSH9qfZEmyqxp25Z3I7J6VjH7njJpIzEDaGyetbBP7otEKeFhcAeBivFLMvwXa4Qdcz9X9T4o60ik7V6LuEBV+nZ2WB9CjeL+5d25caVxXu8FVxQs/UGz9toB+h8HkUraxKG9+phprEdDXYOTTrt7SsvOXqGeaxDUfyzSk49Ab6J0sjhbo69BxUbe/6vhMa6YI9G846h35MXFK0TCUfLYKWvHZLo0/6Te7GCVvfRWoba3fHVXx6EuOoqcbQuZxReZx5rspYQ==
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 (2603:10a6:150:16a::21) by PR3PR03MB6361.eurprd03.prod.outlook.com
 (2603:10a6:102:7d::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Wed, 6 Aug
 2025 20:00:17 +0000
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e]) by GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 20:00:17 +0000
From: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
To: Marc Zyngier <maz@kernel.org>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Joey
 Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 2/2] KVM: arm64: nv: update CPU register PAR_EL1 after
 'at s*'
Thread-Topic: [PATCH v1 2/2] KVM: arm64: nv: update CPU register PAR_EL1 after
 'at s*'
Thread-Index: AQHcBtznfZx1EzPMhEmSJJRNthoKUw==
Date: Wed, 6 Aug 2025 20:00:17 +0000
Message-ID: <87tt2kfcfy.fsf@epam.com>
References: <20250806141707.3479194-1-volodymyr_babchuk@epam.com>
	<20250806141707.3479194-3-volodymyr_babchuk@epam.com>
	<865xf09t3i.wl-maz@kernel.org>
In-Reply-To: <865xf09t3i.wl-maz@kernel.org> (Marc Zyngier's message of "Wed,
	06 Aug 2025 19:56:49 +0100")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR03MB10456:EE_|PR3PR03MB6361:EE_
x-ms-office365-filtering-correlation-id: 344abad5-54bd-4e23-341f-08ddd523dd94
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|42112799006|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?FVaY8Rfc0ntRVzQ8bDQj4BqMq9/TOnXcWZHqao9yXtfF0to85S3ZBq/0bR?=
 =?iso-8859-1?Q?LXAdjV9hiNVTeU71YhkvMNajcgv6UhDQi1Qd68/jNdx1iHjWQLsczWaBHs?=
 =?iso-8859-1?Q?Dw6Bz+7AxVJT6AcZMAiRfGP1cDhZ/W+kiAGITxcmcE96N2k3y1ggZiXE7i?=
 =?iso-8859-1?Q?9sfGDnIr4P7VtPE08E1AwVVKmtl2o77r+HqQIvZhtMJYlXtuIQIqgecmg4?=
 =?iso-8859-1?Q?Q8WQyHdf9NrPf5XJEcc0NTpMXmhLPQtipqEUw/TnR05sid2//vm0UqO4pS?=
 =?iso-8859-1?Q?Le1L4lRaan5N8KdiNqHrPCSL8KlUEfu14GkGe9XAdPre6ctFYSVtD17NSH?=
 =?iso-8859-1?Q?NmBPEcm8EHkiRwbPa3EVV1bqMBk3Fuyls7ahD9QI3x1u24veNJVa2Bsyow?=
 =?iso-8859-1?Q?Eo8t3oEfa3q3P8o8EGvAH36d1Ebvx7UEwasnIzkQwKgy42E2l3aWNQIhek?=
 =?iso-8859-1?Q?/Pjh2OR7MA1U1JTmWonIu8upYEhTC8u3DcfR89wi5ueJQjFYbJ/25LrLSI?=
 =?iso-8859-1?Q?T0Da57OfaV5kSTdmtSNZErKjayTk5YWmQASNwDTR9f5dbVfMS7F117M3mq?=
 =?iso-8859-1?Q?6q7MKANSalKa2iYTBONkCA4gLuADWrkgqIXL6xL7wB1DyZwJSalgOyeO90?=
 =?iso-8859-1?Q?w8GpvFX0Vc1nEGqR4FTvk2IKbdOH0ZtOu3uSK6hmoEiC1UUtRFQG5FZSV/?=
 =?iso-8859-1?Q?vLxHMYAsZDj/rmTkjOyYmz3zf28ct4oOKFylgCwaq+zg+Uy4sn/V64rfWP?=
 =?iso-8859-1?Q?hwJLCRyOXlkv5qBbKz9KoErs4UMQ214bxkAp/eIxZ/89qr0XKaQ+bZvNkX?=
 =?iso-8859-1?Q?tfXRgqIs1ovzXTQRKBPqWjK75x0/Mp+pUuoo3vmDIXdGnY39ZkgsqZSmre?=
 =?iso-8859-1?Q?o04u2hZ6xOMh1Awh6N6wgyUT8pG2vqw8ZuxNwEj3NMGhX2Dkgrd5oaJ5GR?=
 =?iso-8859-1?Q?hrYUnG+09FlMFdSOW4Unklzp+Smb4ZUM5bWiNaa+D34fgoN9BnTurnA3lY?=
 =?iso-8859-1?Q?ueAgWAVwEBzPQOaVxEpFeBtC/+3ZhXO8T+YGbNjGDgmVh7xYbY0HhOakaP?=
 =?iso-8859-1?Q?IJCIrO+0iKo4s887ozpyZZA5YVO+uaRNIvyUgE4mpOBCO1qSvbQOwZIdsd?=
 =?iso-8859-1?Q?plP7S5TdIsk22PbG38zOnvOTZbY1PxfzwepP1fDXsBE1HCkeWwUfUb719L?=
 =?iso-8859-1?Q?qTgh96sdxVXfv334euG0s5wRTjeVHk07sTHQzHCdrbnUsnmgx/K3BlKUAy?=
 =?iso-8859-1?Q?aXcpl5SDDqd/4T24pVe3Dts3U7T5RQcGbYuKvCkGq+TorKSnjF5btybksR?=
 =?iso-8859-1?Q?8pyKOK1E0Q4ennjQrJrbqirBo26XLNXlA7XyPrPefo28VW65OYJR3yYiDQ?=
 =?iso-8859-1?Q?029WkhCF/HzgFlgjW4LnzxTZB5ZwYeZPR4TZJ0eh3eXn6BITMKPIxh/n1B?=
 =?iso-8859-1?Q?1so9WNCAOJlslJQ17NGeU6ujUukPhJKZFIldXIvKKsfXJZ/0i/xATFxdkK?=
 =?iso-8859-1?Q?jTkeU2gKwplHSq0ZjSiAydQnbyLa9+YQDcu+qqQOE4lg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR03MB10456.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(42112799006)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?jyfRhsOXIRsQpskw8a8/qU8mrntX8H4VSenNug4dX5z8lYg9zXyT3ssyXS?=
 =?iso-8859-1?Q?xo++idGijOajhixVco7OCz/fCQkUV3Mx1883EFqniOcPI16rgP3UBYmmAS?=
 =?iso-8859-1?Q?hn0+wITPO6FLK4lIg9LdHGaIV5NJK73Ye7DBvY4REPF35cHWR3w/hB20lZ?=
 =?iso-8859-1?Q?75omDFdVzMoTSL3A33JCNA+dzA+RG550q716swZvb9inLQHseaHAWADOWQ?=
 =?iso-8859-1?Q?zDX1rjAlokU5kElMqsfzt0Y/S3IVoQi1RfwG0OeHgRTyckQfTF8jYxu0EH?=
 =?iso-8859-1?Q?L9XmjQ/Y52QPKhVOgB3gi5vrUR83ZT0TC0npmmgC37Av/wo7SFEiJLsI2i?=
 =?iso-8859-1?Q?Oimb6RFw7e0aissloRDUS2wJBjYkiIctx5+TV5MFzGGJcsN5ImCYe/t7m9?=
 =?iso-8859-1?Q?7eIJXU5J/ppB0faHKPJMbN7fWm8mtB8u5nawSc11z4e2g+y0VHb8dGpI8e?=
 =?iso-8859-1?Q?fHN6mceYnMpr339hxbaCtZQU1S2Q0sZt281+cCaORPgCnNWSyEfSbwG4NR?=
 =?iso-8859-1?Q?dMD47inh/49u8+8GIxLbdSwlSbhszNNALp5ANMTL3Vf4gcErzppbniO9Y3?=
 =?iso-8859-1?Q?SnEpoxCbsKZqFwn6ej3DjE4g3k6bCo+eSb+jt0gh6IuNOho0b+7JiZLquD?=
 =?iso-8859-1?Q?0n37ahEPZAIfZjBjijbZuuJfsxAFitEUUgqvX3uhEZIhOL8SqjpwxbokVO?=
 =?iso-8859-1?Q?RdEN07/WYjGXFpxRPPBvYCODn9QK3/2EYXYWtcrynIIhw5ikprLD0Z3Enr?=
 =?iso-8859-1?Q?XthBpOgZs/9nXu3NhZZwVax3WUnJIho0GK+QjCLV0vAhz73BozynTQRg7v?=
 =?iso-8859-1?Q?qif2AASI6KNVNkBrPKZWdzwgVImfY4fii/lMNNL8924o//JAthOOtei8dV?=
 =?iso-8859-1?Q?O0df6fEmIFA368LwLVuxYzkcfh1f7mTYO4aGrJ9MThVSAUwfmr3kEbs7B0?=
 =?iso-8859-1?Q?8QKTa4UwHLyFvqXvIyKjTPfQSW5a/VA/BoWqB9ELKmvxbbROM0kJ6ipvfJ?=
 =?iso-8859-1?Q?P/1HXU0EIzm0lMrchPXxxxrxnvMtLb55U96NAEssKyUoCXXVE5/M6XZnf6?=
 =?iso-8859-1?Q?wPNTue1ia37IavDqVTSUmACfuhdXgdh0S02i3bB1B+jmQz6h5+uR3pzF7O?=
 =?iso-8859-1?Q?Y0qb0X3XDYHr4Az9TnlHYJfCb7VsDgISUpKQgQi0xoma2sElSKYvsBGm4l?=
 =?iso-8859-1?Q?RIfwnf40xjSobSLP4xzC6EyfBQqkXhZ2UpcASIgPaJWV+BjOLLM357J83N?=
 =?iso-8859-1?Q?EZpNzhQbH6QKmdBwIKkdbS4Lx3eR/qpaBBbX1xPNumaGwpBpiaayNf6XBS?=
 =?iso-8859-1?Q?qvT/9nPuoQ6NTY24Uz8JBfVc1v1eKnLmpB3OB5nYcg/gd71lOwTDYtXJsq?=
 =?iso-8859-1?Q?O8UVV8Vm3ruaPYY5RJGmX3Skch2Roxqur6tVLeIlqPINjwQG/3bWzQkPlg?=
 =?iso-8859-1?Q?4Eiga8iFjs5/mFkhHZj+v3huJchRnDYs99NSyG9Dk73uv6HANiyibxL+S3?=
 =?iso-8859-1?Q?xsdcwt6c08Pcm+PsSQWrQvprc1vdFS6Oa0VLjyVrx5RyFwYvBD+L44SxoL?=
 =?iso-8859-1?Q?76XCaS7A+3mSDiBJahwVYR+78MQv426ZF7OHFoEtAnq3DKxPfOTWXS3kUb?=
 =?iso-8859-1?Q?TfFGxu0Lqg56071c6dEtNWS/pCUkSD2u6TaFCA25HZQ+mPb/6mpKvWMw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 344abad5-54bd-4e23-341f-08ddd523dd94
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2025 20:00:17.4432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p2j3VXbAZYmMYaonP8JTm28wsYx6y3EdjcykiC3avNgytSNovduLkC841d5R2BnrZNTCQdK3gqp5UT1in9WgWFSevsrNjGK9BaGhPsGfcac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6361


Hi Marc,

Marc Zyngier <maz@kernel.org> writes:

> On Wed, 06 Aug 2025 15:17:55 +0100,
> Volodymyr Babchuk <Volodymyr_Babchuk@epam.com> wrote:
>>=20
>> Previously this code update only vCPU's in-memory value, which is good,
>> but not enough, as there will be no context switch after exiting
>> exception handler, so in-memory value will not get into actual
>> register.
>>=20
>> It worked good enough for VHE guests because KVM code tried fast path,
>> which of course updated real PAR_EL1.
>
> Nothing to do with VHE, I'm afraid. We can take the slow path for any
> odd reason, even on VHE.

Yeah, I just didn't conveyed my idea well. As VHE guest does not require
S2 translation, calling real "at s1*" was enough to get correct value in
PAR_EL1 in that case. That would hide that issue if using VHE
guests. Also, I believe that most hypervisors will try to do own
software pagewalk if "at s1" fails...

Anyways, I'll rewrite commit message to make this more clear.

> This is more of a structural problem, see
> below.
>
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
> This looks like the wrong fix, as it papers over another issue.
>
> The core problem is vcpu_write_sys_reg() (resp. read) does the wrong
> thing with registers such as PAR_EL1, which are not translated between
> EL1 and EL2, and therefore are always live, no matter what.
>
> Can you please try the hack below? I don't like it, but at least it
> shows where the actual problem lies.

It does no work, see below.

Also, what do you think about Oliver's approach? I'll try it next.

>
> Thanks,
>
> 	M.
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ad25484772574..167f0d411a708 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -95,7 +95,13 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
>  		return true;						\
>  	}
> =20
> -static bool get_el2_to_el1_mapping(unsigned int reg,
> +#define COMMON_SYSREG(r)						\
> +	case r: {							\
> +		 *el1r =3D __INVALID_SYSREG__;
> \
This didn't worked right away, as code in vcpu_read_sys_reg()
will do just __vcpu_read_sys_reg_from_cpu(el1r, &val);

(the same true for write counterpart of course)

I tried to put  *el1r =3D r, here, but this didn't worked also, because of
this check:

		/*
		 * If this register does not have an EL1 counterpart,
		 * then read the stored EL2 version.
		 */
		if (reg =3D=3D el1r)
			goto memory_read;

So, either we need to add one more check, like

if (el1r =3D=3D INVALID_REG)
    __vcpu_read_sys_reg_from_cpu(reg, &val);

Or use Oliver's approach.


> +		 return is_hyp_ctxt(vcpu);					\
> +	}
> +
> +static bool get_el2_to_el1_mapping(const struct kvm_vcpu *vcpu, unsigned=
 int reg,
>  				   unsigned int *el1r, u64 (**xlate)(u64))
>  {
>  	switch (reg) {
> @@ -119,6 +125,7 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
>  		PURE_EL2_SYSREG(  HAFGRTR_EL2	);
>  		PURE_EL2_SYSREG(  CNTVOFF_EL2	);
>  		PURE_EL2_SYSREG(  CNTHCTL_EL2	);
> +		COMMON_SYSREG(	  PAR_EL1	);
>  		MAPPED_EL2_SYSREG(SCTLR_EL2,   SCTLR_EL1,
>  				  translate_sctlr_el2_to_sctlr_el1	     );
>  		MAPPED_EL2_SYSREG(CPTR_EL2,    CPACR_EL1,
> @@ -158,7 +165,7 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, in=
t reg)
>  	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
>  		goto memory_read;
> =20
> -	if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
> +	if (unlikely(get_el2_to_el1_mapping(vcpu, reg, &el1r, &xlate))) {
>  		if (!is_hyp_ctxt(vcpu))
>  			goto memory_read;
> =20
> @@ -219,7 +226,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 va=
l, int reg)
>  	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
>  		goto memory_write;
> =20
> -	if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
> +	if (unlikely(get_el2_to_el1_mapping(vcpu, reg, &el1r, &xlate))) {
>  		if (!is_hyp_ctxt(vcpu))
>  			goto memory_write;

--=20
WBR, Volodymyr=
