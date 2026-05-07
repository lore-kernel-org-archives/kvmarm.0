Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010024.outbound.protection.outlook.com [52.101.85.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31B047CC80
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 19:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778181765; cv=fail; b=bLdvkYYEhDOFrVeVyDyJazD3mCmyfy98lX77iHg+CFz194TX/gcpxRATVV29YsIJ60ODylaHkVk0cX9dN6yJkbyr6O5ojd9MSVSqrgc4q6NQwgdXDvIHf7UcZ/2H/kfr+CrccrkZ1PuB2tWTsJI7DxI2CnPiXhMw4sNcW5gthcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778181765; c=relaxed/simple;
	bh=vvn/AjbLWqhusHDnz9hd2VfzSkoEeX+pbAJ+ox32nic=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YyuWWx+oDSaetCqHtKMCjnqf5WZbA1cxIOIar8U4p9VVIL9yxBlZUOhpKEjx4o+TP94a4UUPueXtQqdK1Xs7AtNh8c97cc0du+O4kM8lBFhIq02Ttfnc0et9SHFaJr5uC5vxW8wiwSNWXoHyq3fuAmeCq8bfMzRMEf9MWBrKpAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S3EAKQRc; arc=fail smtp.client-ip=52.101.85.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S3EAKQRc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G5sUqAZoX7GFpjA2OM4H2IAc5sgFvpAlRFG8GDXwsojku7ScAlPXAfo7/aH1XYz9czFrVs3aGR9CZKPP+8SVZOhslv2sbCo9+2Z5HHD5PSHcrj7Bi6pa6zERRsQv7fQxsOYuE6uK4KxNPiHJt0DMiMhtsZxxaPqRhXOdPSbC6UXUj8QcKNhJ82IUgNNBKyYCLpuuomm1n2RmhHuFS8Gkp5PxiROepPI6873+5L81UBS7kQzzxG9HlUFqwd+N/3ULODxocrKDThzAAHcUK00f5mp6jxC+VEPyxhbLMBkrc49A1w4DX12KB4TCo8D2Kugbgcd657epsDRnnyf4Azf7eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2ja+3thqGD97Qd3otyKP4QhVcbUPBeOa37BJ3xXJQE=;
 b=Vgwlcx6V1kr5InPjP34+nyoBvCVpBtvfUV6OxCC1EGYXp1x5ozePcS6/WbLb36SVoacsAbKm5aaoivMn8wJ5YFI277MJVmw2dMeZ6IbQb9hdCP18fStTPkVuix+1afaZdB+ekQMtWlT0XqodFY1zL8L15i1hAtqWxyeqzfEt7KLlbNcgorulgEXwRUcER7vUuOeSnZnMT7xohyLOQ7znMtJyC4Hg/jnm+1Mwi48Uk3K5/6l4gZItpz7ofGOvittYF8Znp2vDbI9he7qyd2D/0sguTiSWNXKxFtWsGPakQEubfSqpLyMF9Rq+PUSd831KiRm01CaGntlNQ0T66UkJcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2ja+3thqGD97Qd3otyKP4QhVcbUPBeOa37BJ3xXJQE=;
 b=S3EAKQRcPbBqYFI49CDcxz9d9d345FXae9twog6hP5CCsHDp/hiw2CCn2WF0vZkwcBq3dXe1TvABMlPpmKRW3s4Zor3AedrpuAtsoY6FQCGTuqB4ld40CsT4YZuOHJXjZ4mYBuJG3iWH4IibWU4yHngDQGbfZDIH6zyNHIaVoeiCRSwak2cEr4YrxgBeiZh3vw1sDJfAFfmvfEYmbZ0nR2//FI9vFvfqC1lHpGVvRbJarKYdN7oCEi6WDZLzEkud8scBAouAaip47Om1d+DcN2gz//vpaoJWMDbNVpVPHhBdZm2VfuxJ+XpE/at4JQj2s1Fy+jYxf+YUaonOcjnqlw==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by LV8PR12MB9452.namprd12.prod.outlook.com (2603:10b6:408:200::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 19:22:38 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.20.9891.017; Thu, 7 May 2026
 19:22:37 +0000
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
Subject: RE: [PATCH v4 15/17] arm/cpu: Expose writable ID reg field properties
 on the kvm host vcpu model
Thread-Topic: [PATCH v4 15/17] arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
Thread-Index: AQHc2s+xRZw+5L8EoUSk70vndHElRLYC9owg
Date: Thu, 7 May 2026 19:22:36 +0000
Message-ID:
 <CH3PR12MB7548D4829306C3B8E9612FD9AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-16-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-16-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|LV8PR12MB9452:EE_
x-ms-office365-filtering-correlation-id: e1b7a877-dd4a-4a11-24ac-08deac6dff6f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|921020|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 6mN/s8ppjF3ZiKZh2aoRBjuAZHaSwHT0c2T9zpS4t3Tj8ALE0TsyxGnt5YKlqrDtYbrccbyPziR8v2Qizf1TxbnyAX27lD1gSLocCeNrPMFymHfQHCAAXHbH1FFDFSYobQFBaH7uRH1+oDQc0mbHbaAHl68W443jM/B5D842oYvkvMzmvE2N9c40DEznLJxDdSJZun4FqO8WYz5mggNxdoo8wTOg4GaWq1kdouwASx3QjSK6rb8593dyRD+vZsK9ifDyMtIwx0WoPwxnlaRRe/HlrqC43bc/AdMH8u5gQ1x7vAlqN4N5QiKeX7uBBXuZoI9B/9e8VPAnaidZOPJzjanRrac+YejYQW0gi1II0mnOwN1uQ+8DJ/Ik3jRYqPIbayFokeVdfpC6qosCb7kPOTLRpSfxJPj7xtGPCoN+/RiI30KGdIk8nMMM76pBzqDQQsANBnaL64f1okcnCwPUh4GZVjCJ4+xqCw/WsfILKQU8yTJSTPvydmxUtLcnJST93+Z9CRaUc9xLckPjK/D4zkk+YHKGIbSM1zI/eEVPtvQy/poDs5J5/fWHQmFPUlBIrg76rW5/++34Xaq2G0A0Gf3yMcYAq3fjSIlOS1e6zbmeDiOOjYoSRZF8T+3nBU7LmsQUJORiG3ev/ETKoEJDV5pRSLy8tIDo58Cnze5RIgZ6eqTPFJchrN9x2PdXxYIg4ja5OlTxEtWOj45k+1WP00PHcw8v1UfXTgHa69mrv0LmT8Kaurtwt0IfMKqRlpzOXaKsAjIZm5Ebg9sarlcFVQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zHMzaVQsFebvM1Pyjvq8VnTfbvtbmAHbmm3h48cGxZdl63hHctTDubtIQoRj?=
 =?us-ascii?Q?L/48EsuF8dfpSf6BIVZX+WBqZHNzZcZEHApE5FvxP4gS2fYYXh7+0hW7PeQO?=
 =?us-ascii?Q?MN7JJSJ8I/FDXEJRtTePBtr5K550DTIn4vdKGrrVaCydagrechpUqDDSG/62?=
 =?us-ascii?Q?g+AL4B/IOswPj6BVgo0iMNVET4RP/gIKfe1ptvRkN91+OpzhTMTcb82FwY9z?=
 =?us-ascii?Q?xXmE41LLU2wSk013W34gbRTHPk7YSrn2vgGb1xrg0vk+wepvq2sEB7TvpX/K?=
 =?us-ascii?Q?hs6s2KWSdvjaNIclsmojgqWBuujraumkfkKI5nbLqiA66lhgCbdPFFUb7vEO?=
 =?us-ascii?Q?QBLBAzI2o90EeDdwjObRoY3V0iYVIwXJWZXE5S3nPBPb4ARypH1NwQxy49Xa?=
 =?us-ascii?Q?hdDWoCzPIFHVGvNe25JqQHTXkgpg/2b+3LMKEaBA6w568f5CDV+3QuIDbLoS?=
 =?us-ascii?Q?CrMRRxkdX9jLp44nvf7kviPj3XaNivoNkTnAUsBuKNAUN/pMQArpSlHp7wKM?=
 =?us-ascii?Q?3N69bj+ZxPNAfPCUvf24AlI0AMPTCHVCDVlRDNeC6YP05M47vI8s3mE0dHXv?=
 =?us-ascii?Q?UnD3gYHQIEIZNM7lLpKn1++EWMkKhXz08VUbbfmYtV16KesFjr5+hBA44l5G?=
 =?us-ascii?Q?BMaPwq+ODsCpsDM9W1VT/H3AdZ+t8VOjnbPuu0V4lqTwmmyb2s6V+v15cVg4?=
 =?us-ascii?Q?I+s7jrnqeJpEDNDrn8xgCHhoF4EGEdMdj6BdtVIb50tYRhyo4+q/z8KNWbHL?=
 =?us-ascii?Q?hCEMnEOMpi8lWvA9Nqv5lFy6rVKJg24i6U8N7Pnez7w/fR2An9Da2EGlLQ7r?=
 =?us-ascii?Q?/IQgPOuVru///ZQgsYwQGk3jojdXYpZH3fMBnl4hKqB4onnxZE8Q7TonPEQz?=
 =?us-ascii?Q?CilPOIQ3WvtD2ACE1b5CBE6/WDd2ra2Aa75sNKkMJ8nV2CoreJaGGLVAeWCU?=
 =?us-ascii?Q?NcXXbroLfJNuADimRdmvgBrpd65azADC5Td16nQskNd04mjhd9OR2bM4KMGs?=
 =?us-ascii?Q?MWPZtFbE1VRsXwxeLqH+mcVAL8x09lNP2kjPUPdwashgdqlrV/cT0Jp8/qvW?=
 =?us-ascii?Q?8FGjIHQFprt3Oi+etQkQuoDHBw09AzSAmzY0Ik/kN2W4SmD0LKqSIl/xSHnZ?=
 =?us-ascii?Q?YEQuV8D3zhCYiEY9WoWAkX952G9Z2DA+VhJolkby17F99NPO/6YhAoBgLFZI?=
 =?us-ascii?Q?UZ+BfCrOBY8u8RdVNKzYEnyqG11Tu+2cWM0XKGtcNiBZEso1v8Kr0pLmsZLk?=
 =?us-ascii?Q?T3WjoXkJMg46Wi2xug194ak5SUC2gLVN/F6DFZXNWPnZblm4AcOffPTgK7qF?=
 =?us-ascii?Q?+UtGQm7W1WaSqF3nsAc73etQMqeOcRSuz9UZEMsXkAF5cTYjy2DjLUn1G/9e?=
 =?us-ascii?Q?pA2m0BVQqtfQH3oXCOUU+Dm3fBsiIY+Kf7mT9Y1LmisbGSd4z3Fy8YmomX2W?=
 =?us-ascii?Q?OCyQ0ZrjCKBPgcLpN4KpoMsaJcYD8mY5EJWCHas5ULPPaC4bsd3WFCnUaPw1?=
 =?us-ascii?Q?v+YcbqiBeJYS1boAmKrx866f5wMKB9O76hwRPeH1QTIAOwMF8OqPF+x7vEMu?=
 =?us-ascii?Q?IMkVO6dh2uIoxMtHNRf4v6Q/iiQenKpLXebmV5de1T4gEUqWLBCeX84KgA+I?=
 =?us-ascii?Q?OkuVR+eteL4uqPzXq9MPJO/0UGcPO6pD98Bfkj23aCW+ptM//wZ0KX4kxFmX?=
 =?us-ascii?Q?hU+usRdMftrmZW1bS10lUozuWmW++0P5Rutb5OfH0mxJ7LU+SBResO8UUeun?=
 =?us-ascii?Q?mphfz+2fUw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b7a877-dd4a-4a11-24ac-08deac6dff6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2026 19:22:36.9823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +NraaEZYXrAA9F4YEKS4skFVIp3wv0GtgrO9qjf4H/0I+4HbE9Gmv6iglw97fp1LZkoTtgFoAEg14hzPso8GCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9452



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
> Subject: [PATCH v4 15/17] arm/cpu: Expose writable ID reg field propertie=
s on
> the kvm host vcpu model
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> If the host supports KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES and
> KVM_ARM_GET_REG_WRITABLE_MASKS ioctl successfully retrieved the mask
> of writable fields for all ID regs, expose uint64 SYSREG properties
> for all the writable ID reg fields exposed by the host kernel which
> can be matched in target/arm/cpu-sysreg-properties.c.
>=20
> Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
> being those used in linux arch/arm64/tools/sysreg or in the AARCHMRS
> Registers.json.
>=20
> This is achieved by matching the writable fields retrieved from the
> host kernel against the generated description of ID regs and their
> fields in target/arm/cpu-sysreg-properties.c.
>=20
> An example of invocation is:
> -cpu host,SYSREG_ID_AA64ISAR0_EL1_DP=3D0x0
> which sets DP field of ID_AA64ISAR0_EL1 to 0.
>=20
> [CH: add properties to the host model instead of introducing a new
> "custom" model]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu.c   | 12 ++++++++++++
>  target/arm/cpu64.c | 23 ++++++++++++++++++++++-
>  2 files changed, 34 insertions(+), 1 deletion(-)
>=20
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 10feb639c4..10ce4eb0cb 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1824,6 +1824,18 @@ static void arm_cpu_realizefn(DeviceState *dev,
> Error **errp)
>          return;
>      }
>=20
> +    /*
> +     * If we failed to retrieve the set of writable ID registers for the=
 "host"
> +     * CPU model, report it here. No error if the interface for discover=
ing
> +     * writable ID registers is not available.
> +     * In case we did get the set of writable ID registers, set the feat=
ures to
> +     * the configured values here and perform some sanity checks.
> +     */
> +    if (cpu->writable_id_regs_status =3D=3D WRITABLE_ID_REGS_FAILED) {
> +        error_setg(errp, "Failed to discover writable id registers");
> +        return;
> +    }
> +
>      if (!cpu->gt_cntfrq_hz) {
>          /*
>           * 0 means "the board didn't set a value, use the default". (We =
also
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index 1b3d3fb245..d66cb00a21 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -852,6 +852,8 @@ static void
> kvm_arm_set_cpreg_mig_tolerances(ARMCPU *cpu)
>  static void aarch64_host_initfn(Object *obj)
>  {
>      ARMCPU *cpu =3D ARM_CPU(obj);
> +    bool expose_id_regs =3D true;
> +    int ret;

The above will be unused for non KVM builds.

>=20
>  #if defined(CONFIG_NITRO)
>      if (nitro_enabled()) {
> @@ -862,8 +864,27 @@ static void aarch64_host_initfn(Object *obj)
>=20
>  #if defined(CONFIG_KVM)
>      kvm_arm_set_cpreg_mig_tolerances(cpu);
> -    kvm_arm_set_cpu_features_from_host(cpu, false);
> +
> +    cpu->writable_map =3D g_malloc(sizeof(IdRegMap));

Does kernel clear the buffer before setting writable mask?

> +    /* discover via KVM_ARM_GET_REG_WRITABLE_MASKS */
> +    ret =3D kvm_arm_get_writable_id_regs(cpu, cpu->writable_map);
> +    if (ret =3D=3D -ENOSYS) {
> +        /* legacy: continue without writable id regs */
> +        expose_id_regs =3D false;
> +    } else if (ret) {
> +        /* function will have marked an error */
> +        return;
> +    }

Should free and NULL writable_map for both error paths above.

Thanks,
Shameer

> +
> +    kvm_arm_set_cpu_features_from_host(cpu, expose_id_regs);
>      aarch64_add_sve_properties(obj);
> +
> +    if (expose_id_regs) {
> +        /* generate SYSREG properties according to writable masks */
> +        kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
> +    }
> +
>  #elif defined(CONFIG_HVF)
>      hvf_arm_set_cpu_features_from_host(cpu);
>  #elif defined(CONFIG_WHPX)
> --
> 2.53.0

