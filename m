Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012010.outbound.protection.outlook.com [40.107.209.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014173A759E
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 19:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778181056; cv=fail; b=NFldMznCDducivONeNknbpg2DeNITQvUlMpA9B7ZLaftywxZM/iDuWVu+Uv0X2YlF8ENhOfmr448N+fJEYo3LJIeEWg1fBQEl6gWcYfjtX50xnxX1SfSzNYCi4Q4wlLR3wHkfrrvFL5p3AjGhc8NYRHNX91ozy2X/4qC8NqzhHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778181056; c=relaxed/simple;
	bh=3JQqGOr63lZBVunKt70lUJvIQyuFLKfpKGpojPTDGiA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XI6O+qO3NlZP0pUP2f6neJ1LdseGeG6tKZZjkxBF+45W2j//mDf8cphNWanmgZFMuZ9wiNMS29iRr1TdePaMK8N2HuoO3Rl6hUQTacljPxS5GKckqxCczUMwSu2IOzzstH4Y/Tz5foTwrP4Da+HgNn1FvQTKqz0h3zgB28pNVZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZCWkxsHV; arc=fail smtp.client-ip=40.107.209.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZCWkxsHV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ECXWh4UzVQeFQ9kD2SstV6iCm5bpsn6+x2lYHdhpEMbWVsNCp1MrCdzkYpHJGqWfxyT5LqD0TJMHE9ntH+LHjGrcr/EtDJpTV4zDcJL/+pXQ1RifPE/UyWCS82hDmRKerswbA/Go3EN6gz7Z9kuBa4c/BB8bv/p4BQxZW0y+F2sz3kVnF1yyYYTDiAaodgFvY9LuX/W2DAhbatvAure1ar57hvkTYGpwGLDbB48D5vB7QpkgMkKTyRWWUBVgrEtugxDQqSjLefX6XTMOZplYE50NDeqZEaF9fJTtNCogb68ws5eKnYuxU7dNhrqllIoadn7EUiZZAysNWZn1Dl/DIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GgJyKfsEEmbT9P01u8sfdY9i5XoMZMoK16tWdv0/xrs=;
 b=V+DDeaeqcwf4mGkEZqoEhUqZb+dg22VB3t6Jx9Kt7m0txb0iUwMrBxMH/5VoTW2dObkL5wMszJ6eD15zPq5U3kXCmgxQ1u4LF8i6eiBmMFSXCtfa/b7xZbdmtNV6j7mwYO9LMn1DnXx0pXhGcNLKffMD6JYJzHKHy6Ti03F8Mcpt6hoGoAw7i2Sn+I4j7TNrBe5NA8dqVYkIMKPuqZReavkk9pO4CoRP1831G6AqvPC0yE6X+c0Rj0wVyBv7klbR+HtQK15dVpfO6ssRz2mJr02PKWbG9LZlVOUe23pSgoPlJhQvYpvGC43/p3E23o4oitAayyJAHOTVnocqXgo2cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgJyKfsEEmbT9P01u8sfdY9i5XoMZMoK16tWdv0/xrs=;
 b=ZCWkxsHV7G/E+Vw5G37cXq++HhXDO66hhO0Z4rLbF3yS9JgaJJ/8hEbQTBP8pq9tq+00cLz4JLuRDHGBylCByb2avY8EIRo6kXc5w/7IAKq15CTdVNjVm3nJu/npIhgKoOY2wnP6A3Qb+n9WdGLehJ+km9N7Bm7UsbnnguswRFAIoHshGNitGNjp6LiQDb4DplDWEfDuX/H6zZkfnm64Po5unbPAiFiFAWkUCeN1zOQ1sNo2bbPjd0ud80pTCdcggAEDdnBZulLZE1GvUrigP15RnMLj23fEJWx+ycfDiU7RH5iKhIWtVXrcQ8pFR8JjbYi8ReLi/4BDWZY501XDSQ==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by PH0PR12MB5646.namprd12.prod.outlook.com (2603:10b6:510:143::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.18; Thu, 7 May
 2026 19:10:51 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.20.9891.017; Thu, 7 May 2026
 19:10:51 +0000
From: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
To: Eric Auger <eric.auger@redhat.com>, "eric.auger.pro@gmail.com"
	<eric.auger.pro@gmail.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"qemu-arm@nongnu.org" <qemu-arm@nongnu.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>, "cohuck@redhat.com" <cohuck@redhat.com>,
	"sebott@redhat.com" <sebott@redhat.com>, "philmd@linaro.org"
	<philmd@linaro.org>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"armbru@redhat.com" <armbru@redhat.com>, "berrange@redhat.com"
	<berrange@redhat.com>, "abologna@redhat.com" <abologna@redhat.com>,
	"jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: RE: [PATCH v4 12/17] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
Thread-Topic: [PATCH v4 12/17] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
Thread-Index: AQHc2s+m3tgW1Q4bDEKRpZKrxzdGnLYC8Zkg
Date: Thu, 7 May 2026 19:10:51 +0000
Message-ID:
 <CH3PR12MB75488E874766B26AC78AB399AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-13-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-13-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|PH0PR12MB5646:EE_
x-ms-office365-filtering-correlation-id: cae164a6-fd1b-4856-69d4-08deac6c5ab9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 yAR1qbFUM9wGFO+EGAbRkuxPmAYtZXrH1MMT5vVaDIorZOP9/X6wGUaFP+bjYbFwgp6PWsZxan7s/1v+HDkzQmZa1loKHFEJTZrj+kpfTy/qwLBIx7LfBg0SM0bMskr72CiKkwp2WBrj3lYbh/NziSTxRCrmK/JWE01BHhXQStlew9fdVMM161Lt3GSYN9r46EoPktS1bn4OS8PCFnhSPNK7Fjxt6/5ZFFzl+VLuyf+HRwU7P6fUbp12c/hcT2TbR0LXUInOMkH6GXgqXn9XKgp5O0UIjTjBLg+OaWUYKk4YQgTQmYTTe7/3BZyEhIjoEbwoWdL5Q+/jksmBGdjfXZbz89ATEPw6AVJNVY3/55dCVTkRLK8v5SLwrV/j6907HXji4hi/LsSX5R6F4SEkuMQcEcEyejjtnP/BrsVabAW1clnjMsf6CWmGPhyvCcffFMVTNRWYkYOeanNIFdv9Y/sjBbOM5dfPd0+pacgnd5l5ZMTtBuZc3Sz5cMEkQ3aDNTKeQaM3WkIYcFTextgPW3rL733uSGei7WdUXBHZTGvP66odt3B8cECP8Nu59zT8fj67F4mnqCuANYlbrNt8/C9mexKwKrQYyq0/ssqn/uERT9BqT22OZL//xnVKo+wlHcNlgjJzaeac7ESzwqebpkEVQkn/8oHLPuwHc+v5VHMadM79t/wgSpd8gZUUQpPG/dbcXvrAjo+3Yn+ZA3lmLkoWSzF8dVCtx/p41rBTPyH4P4PXm3GFdNRcipjQWpUcM6zVtbQxIb28Pd/qsky9ig==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?FVwKaaXW99zGb0viOK/cg5vRpZCF4J1JuRDo/ojl63OKiDidQcanugh+uQP4?=
 =?us-ascii?Q?SC9YUJy9hqnAq/1a8tMKU4Msn4P64uj1LrEt9NBNrGSQ3/HowTY/fp5fQ0c5?=
 =?us-ascii?Q?mpsOBuofFqBEufKPxrSY45nQaeedbv+4uDr3CEHOgqLb7TxTkti+jXieZvHJ?=
 =?us-ascii?Q?iTItyMNwyI/fVJAmubEaPkO4oGEDhSXn+LH1SLuBlhbT+XvcU9Gobn5gPctD?=
 =?us-ascii?Q?v5uVCjjVeDSyRl6Wjvrkc3eUysAivXXeWKcVVOXvFBjHj43mPUqmeiAxGAJb?=
 =?us-ascii?Q?PuEu2dxkuzzEWwsOfQhWUkvIAekD/jaaMC6gRXk8iICKYo7rX1xlzOaAxrXK?=
 =?us-ascii?Q?kAeYpLC5k0SMAhqxRGSna13vrx+kDVwq3Lf6OVmUOR8UHk0c5a9yBq3beENZ?=
 =?us-ascii?Q?EYt6nZW21364nEyunegC56aBVEtAWvylZcNME9cQ1n7qwm2pH+dloCnYAMaz?=
 =?us-ascii?Q?prVrpxBeidQLuUBiDdQyj9HYKml6LvYt1GVCJizKjI8jBgS76TP4fFCv7kc8?=
 =?us-ascii?Q?Xjc4GAbFEoJZK2kZzozEaTgqDx5BQx1X6gV6+4pm/0db95ewBCHEV0I4WVNS?=
 =?us-ascii?Q?mRHd5bx7XpzALqaSqV/AVceYL9LY1we9Og2uIjoPx35BoqMXa60rjKSkiCKh?=
 =?us-ascii?Q?LT0CciURzZ98djeNrNflTlMOAAB5KS+R6RPuhmHe/rZeamOEy7bM6OmqQY3r?=
 =?us-ascii?Q?bo7jXubnGe6adlcrY5o/VYfmNPxDTVjcqoDul8tToXjUG/0MQv/5vTfDHlMi?=
 =?us-ascii?Q?AdFh0MZeOuL4l/j0Eukj/XtvDxLcsnheorHzy3irx+A6q3sJvIAV5gTYCMYI?=
 =?us-ascii?Q?tQt/F3jQUsj5xHyramfYfKfHsEqyUilo1bqpIi5sgHdba9AT+uoNmD5rqUl8?=
 =?us-ascii?Q?TQqH0p8RyIIsB4WFFz4ysw6V5sin/nsnDr5btvecpOUDL0Oz+83XzgTgA2lw?=
 =?us-ascii?Q?cd3IQTbUkxVFMcaOvTdvc5NbIAU0kw8suFlVmEaOq07KyJgaVLBxv76aDJ+q?=
 =?us-ascii?Q?t3Nchpxd0j2bedfLlc0UNt0fED0zGOeu8QQwVjYYlhUFTgm8aaNBUvsjqbx/?=
 =?us-ascii?Q?br8T7IsRlYGCtfUtcCmaTVq5mf5oxJvijdwbWYrbb1Dx1MbFi6iALn2ykpzu?=
 =?us-ascii?Q?YkfbPISCYD1YE4vMJHmz8tSIUgTqrHRIc/EpkXXsyCqndcNupG+agRu2/lNp?=
 =?us-ascii?Q?hvRZRPrjA58TJ/MGbg4Q27PNnD7FQy4eN+k/skOmopu2jcLlHt7oFoDXFU/Q?=
 =?us-ascii?Q?eIxoLUcDspFqScYqMPBNYL52v0hSQW99M0fYZkQ2QWGbKOsw2X7gtWepkKY0?=
 =?us-ascii?Q?xbiuCF670pSoShsHe3rfYRcd1ADQFe0kovTMrYeszDZ7lrhghCIlUT5dHGwZ?=
 =?us-ascii?Q?UVgjjIOVPElNe7IM1VTqrGfgu7bCsnekNCBt/vet9P3JNYieTxiJTNei0Fay?=
 =?us-ascii?Q?67JrjwNAGcjBwXiReV5WM72ktbCO004YFLzpULmVCr4qMdZtepBEC90Wv9Nr?=
 =?us-ascii?Q?SyZNrXr/PcOztiHEuDUFFeA58Ki8luhybiMPtoAmS4zEh0sYFpU3jJ05dOVG?=
 =?us-ascii?Q?Sr3uW0uH+nJcsvIyOiWhrxl6o5sSXI9oIRWBxozzNoEkRU95e/+lCpiVBkAq?=
 =?us-ascii?Q?HOZr9wOdJkSu6uKAmmUPJ+/GOeVVcEslf+wtd9LP92Uoh04PDew4pAw0O8au?=
 =?us-ascii?Q?PG882D4I7WRsC96HqwLI230soeItT8zw4QlKHCd6kEwua3ZP7kBIjBDiw9nQ?=
 =?us-ascii?Q?MaMeo0NhuQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cae164a6-fd1b-4856-69d4-08deac6c5ab9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2026 19:10:51.1548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zx6hlLotN1LfM4CEQyxfd97c9y8wyibGpEoozpIoR9d+oWQAZMc2Teb+zyDzFxNiwiMOzlvVWnvyQ/k3TP541w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5646



> -----Original Message-----
> From: Eric Auger <eric.auger@redhat.com>
> Sent: 03 May 2026 08:34
> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
> peter.maydell@linaro.org; richard.henderson@linaro.org;
> cohuck@redhat.com; sebott@redhat.com; Shameer Kolothum Thodi
> <skolothumtho@nvidia.com>; philmd@linaro.org
> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
> jdenemar@redhat.com
> Subject: [PATCH v4 12/17] target/arm/kvm: Introduce
> kvm_arm_expose_idreg_properties
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> This helper decode the ID reg writable mask, matches it against
> ID reg fields defined in target/arm/cpu-sysreg-properties.c and
> for each writable named field, generates a uint64 property.
>=20
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  target/arm/kvm.c        | 134
> ++++++++++++++++++++++++++++++++++++++++
>  target/arm/kvm_arm.h    |  10 +++
>  target/arm/trace-events |   4 ++
>  3 files changed, 148 insertions(+)
>=20
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index ca9a7d9439..d9bf1ec039 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -344,6 +344,140 @@ static int get_host_cpu_idregs(ARMCPU *cpu, int
> fd, ARMHostCPUFeatures *ahcf)
>      return err;
>  }
>=20
> +static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
> +{
> +    GList *l;
> +
> +    for (l =3D reg->fields; l; l =3D l->next) {
> +        ARM64SysRegField *field =3D (ARM64SysRegField *)l->data;
> +
> +        if (i >=3D field->lower && i <=3D field->upper) {
> +            return field;
> +        }
> +    }
> +    return NULL;
> +}
> +
> +static void set_sysreg_prop(Object *obj, Visitor *v,
> +                            const char *name, void *opaque,
> +                            Error **errp)
> +{
> +    ARM64SysRegField *field =3D (ARM64SysRegField *)opaque;
> +    ARMCPU *cpu =3D ARM_CPU(obj);
> +    uint64_t *idregs =3D cpu->isar.idregs;
> +    uint64_t old, value, mask;
> +    int lower =3D field->lower;
> +    int upper =3D field->upper;
> +    int length =3D upper - lower + 1;
> +    int index =3D field->index;
> +
> +    if (!visit_type_uint64(v, name, &value, errp)) {
> +        return;
> +    }
> +
> +    if (length < 64 && value > ((1 << length) - 1)) {
> +        error_setg(errp,
> +                   "idreg %s set value (0x%lx) exceeds length of field (=
%d)!",
> +                   name, value, length);
> +        return;
> +    }
> +
> +    mask =3D MAKE_64BIT_MASK(lower, length);
> +    value =3D value << lower;
> +    old =3D idregs[index];
> +    idregs[index] =3D old & ~mask;
> +    idregs[index] |=3D value;
> +    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
> +}
> +
> +static void get_sysreg_prop(Object *obj, Visitor *v,
> +                            const char *name, void *opaque,
> +                            Error **errp)
> +{
> +    ARM64SysRegField *field =3D (ARM64SysRegField *)opaque;
> +    ARMCPU *cpu =3D ARM_CPU(obj);
> +    uint64_t *idregs =3D cpu->isar.idregs;
> +    uint64_t value, mask;
> +    int lower =3D field->lower;
> +    int upper =3D field->upper;
> +    int length =3D upper - lower + 1;
> +    int index =3D field->index;
> +
> +    mask =3D MAKE_64BIT_MASK(lower, length);
> +    value =3D (idregs[index] & mask) >> lower;
> +    visit_type_uint64(v, name, &value, errp);
> +    trace_get_sysreg_prop(name, value);
> +}
> +
> +/*
> + * decode_idreg_writemap: Generate props for writable fields
> + *
> + * @obj: CPU object
> + * @index: index of the sysreg
> + * @map: writable map for the sysreg
> + * @reg: description of the sysreg
> + */
> +static int
> +decode_idreg_writemap(Object *obj, int index, uint64_t map, ARM64SysReg
> *reg)
> +{
> +    int i =3D ctz64(map);
> +    int nb_sysreg_props =3D 0;
> +
> +    while (map) {
> +        ARM64SysRegField *field =3D get_field(i, reg);
> +        int lower, upper;
> +        uint64_t mask;
> +        char *prop_name;
> +
> +        if (!field) {
> +            warn_report("%s bit %d of %s is writable but no named field =
"
> +                        "in target/arm/cpu-sysreg-properties.c",
> +                        __func__, i, reg->name);
> +            warn_report("%s is target/arm/cpu-sysreg-properties.c up to =
date?",
> __func__);
> +            map =3D  map & ~BIT_ULL(i);
> +            i =3D ctz64(map);
> +            continue;
> +        }
> +        lower =3D field->lower;
> +        upper =3D field->upper;
> +        prop_name =3D g_strdup_printf("SYSREG_%s_%s", reg->name, field-
> >name);
> +        trace_decode_idreg_writemap(field->name, lower, upper, prop_name=
);
> +        object_property_add(obj, prop_name, "uint64",
> +                            get_sysreg_prop, set_sysreg_prop, NULL, fiel=
d);
> +        nb_sysreg_props++;

g_free(prop_name) ? Or may be use g_autofree.
          =20

> +
> +        mask =3D MAKE_64BIT_MASK(lower, upper - lower + 1);
> +        map =3D map & ~mask;
> +        i =3D ctz64(map);
> +    }
> +    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
> +    return 0;
> +}
> +
> +/* analyze the writable mask and generate properties for writable fields=
 */
> +void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg
> *regs)
> +{
> +    int i, idx;
> +    IdRegMap *map =3D cpu->writable_map;

I think better we check writable_map before proceeding.

Thanks,
Shameer

> +    Object *obj =3D OBJECT(cpu);
> +
> +    for (i =3D 0; i < NR_ID_REG_MASKS; i++) {
> +        uint64_t mask =3D map->regs[i];
> +
> +        if (mask) {
> +            /* reg @i has some writable fields, decode them */
> +            idx =3D kvm_feature_idx_to_idregs_idx(i);
> +            if (idx < 0) {
> +                /* no matching reg? */
> +                warn_report("%s: reg %d writable, but not in list of idr=
egs?",
> +                            __func__, i);
> +            } else {
> +                decode_idreg_writemap(obj, i, mask, &regs[idx]);
> +            }
> +        }
> +    }
> +}
> +
>  static bool
>  kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures
> *ahcf,
>                                bool get_all_writable_id_regs)
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 91a7d5cc4b..a3034f264b 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -146,6 +146,16 @@ void
> kvm_arm_set_cpu_features_from_host(ARMCPU *cpu,
>   */
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
>=20
> +typedef struct ARM64SysReg ARM64SysReg;
> +/**
> + * kvm_arm_expose_idreg_properties:
> + * @cpu: The CPU object to generate the properties for
> + * @reg: registers from the host
> + *
> + * analyze the writable mask and generate properties for writable fields
> + */
> +void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg
> *regs);
> +
>  /**
>   * kvm_arm_steal_time_finalize:
>   * @cpu: ARMCPU for which to finalize kvm-steal-time
> diff --git a/target/arm/trace-events b/target/arm/trace-events
> index c25d2a1191..d72ad6b671 100644
> --- a/target/arm/trace-events
> +++ b/target/arm/trace-events
> @@ -15,6 +15,10 @@ arm_gt_update_irq(int timer, int irqstate)
> "gt_update_irq: timer %d irqstate %d"
>  kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova =3D
> 0x%"PRIx64" is translated into 0x%"PRIx64
>  get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host
> value for %s is 0x%"PRIx64
>  kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t
> previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
> +decode_idreg_writemap(const char* name, int lower, int upper, char
> *prop_name) "%s [%d:%d] is writable (prop %s)"
> +get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
> +set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t
> field_value, uint64_t new) "%s old reg value=3D0x%"PRIx64" mask=3D0x%"PRI=
x64"
> new field value=3D0x%"PRIx64" new reg value=3D0x%"PRIx64
> +nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
>=20
>  # cpu.c
>  arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
> --
> 2.53.0

