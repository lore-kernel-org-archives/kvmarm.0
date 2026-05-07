Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010020.outbound.protection.outlook.com [52.101.56.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B7130C372
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 10:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778148466; cv=fail; b=sVEMif/Ia33galogrcJMDJ7A61sh49FjIMc56nTXfH1rLD4+luTMtCenIW96luBe3Yhn2PrW5FrWnNS51EeNabcHd18HePK4z1N9UAVIGGYwMOnas8/E/hv6BWAj+X1wfWRGQBsA0xI1HnPt4AaF5003nL0TvX0RGxxK5YXC6Ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778148466; c=relaxed/simple;
	bh=U8xgqz1kAafWkXhfm9YZhD2EA5SdFq9oonitk+SZ3NI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=is005VIHovlQElFdq2aVvTjOrzTlUGaDXZd96XzZSc0Fs09kVlu7yXO1yxEVTcphtTLN93kwqvKr21Vp5N1IYPSGtoFNEtXp4TGVWSfO/uJU9DWOYoOQvIlGQ95Mm52Lt5GRGN467eQw3MvXX76d7tjWDQbAvvUCI88KryTmLiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DKzyWblh; arc=fail smtp.client-ip=52.101.56.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DKzyWblh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twj0k+zT37PJALaLAmuK33dm4zECcRayeiOtJESErzXHbQFGvDWJ52qFQUXcFVELZ6YYyvCiwii/wuONEMsgq41AD8+MwHiB9xPG8fgvdsfuldTeL4JYqrdbCT9f1rDZtobfyLXT2FVII03q+1AvG0W5CMN6MBU/HUZiwJ14QLQM62hZDfIjOkE9J702HcrL/H8LIkhtR9UIaiVqi4ayNrOX+2VJRJRWknx40m2KLUvlWuxOjdXTzTVMca/XFU2iVkafFkX+96WyH9UUXFe7cFDzWHSYVm/PflplDRR2ffgGReVsqCKObLejuC8G7CTl37SvoqI88bCZNut1OGiCQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idGzSL63QJV+Xaqp0bZQp9KHQEDw6HVunmTSGGO4/N8=;
 b=QAcDwSr/d7pF5BleBWtmPnrKq9Z7F/5wMCc+GDNSA7aaHZaxHAv22+5zAlh63sm7hj8dL7/40tP7eBW8Max9n2phLTUUGudDrf2eSavCiRMRy+17u0e5TcmbI3iu2iVMMsnFgpIh/SIm0wqG+6NYZAIzkxs7Vl7lS9Ekyvq4snSAXoT4ojMK77HNhOKgLYWQ0peo7Y51vIB1v9HcB4/962031J2klwykKlx+HgRGNCSaiqLNuHniLgs1bu1XIsVFK5dW7lJTQjy9yspKk7ul0wq0yOGnhG/VHiW21udYpxBVv/aTeyFJbODqvoU6hAPr8v0XRpk+27WHi/HK7U6HxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idGzSL63QJV+Xaqp0bZQp9KHQEDw6HVunmTSGGO4/N8=;
 b=DKzyWblhzPAF+uX0D0/kMC+XjFQZaBpsblnqMXsfToB3L6c65/f002CAS/VG6weAm3WbZ79KtTTd1acE1vtZPIkpJyOVtT6il3ytHIcxj9LTbFUkDfxZrgzPlSuy7BHjkfyDlMUMPhIXSNtuRK4zjIY2zrQyTiTe4NoblCDXTauiWpFOA9P0WTJqpYiLyMqvvLwRnfsDtVqnEIsU6/70hq3NhcwG/b7aCeBVuYJx1wT6ZmgVRvcuEX88E0FF9DcJMW6MmSCY9CRC/4jj8UmO7KIAMrrAa+7Kk5ZyZ8KW+WOCn/cyPyk+LOnC4RKluUtMZe7ZFWJMye3FLD00TGVOUg==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by SA1PR12MB6824.namprd12.prod.outlook.com (2603:10b6:806:25f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 10:07:33 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.20.9891.017; Thu, 7 May 2026
 10:07:33 +0000
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
Subject: RE: [PATCH v4 08/17] target/arm/kvm: Introduce
 kvm_get_writable_id_regs
Thread-Topic: [PATCH v4 08/17] target/arm/kvm: Introduce
 kvm_get_writable_id_regs
Thread-Index: AQHc2s+ZXUsdhdzNhkmk5nd+llDsZrYCXGDg
Date: Thu, 7 May 2026 10:07:33 +0000
Message-ID:
 <CH3PR12MB75488AAC8601BD74D6095FA6AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-9-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-9-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|SA1PR12MB6824:EE_
x-ms-office365-filtering-correlation-id: 2cfd9b79-cfb4-401e-06c8-08deac2074df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700021|3023799003|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 YdPGmZGI39RP5zVKCO/MhG+cLRV9D7r855MVuAqHLZPC8bZpzGfbriewZAiKMars5WYYm2UAOtzY62kPqipHo1keXKxg1uJiHK1uapLNf0ODQ3uNhwRuYYAKPzpG/Ad1/7thiJMuWeEZ39VhAG3w6KfsneKEqZjcslLpW7HA6w/Dz0e+NzG6v3qJPC5Sfw6JAbga+etZbcyuy/q47syXHt0FoCo2dSlJJ35PWO6acVNm0blCa0agSlqq7f2wFAxAmYy4CU7eyfFgeCl1aD9I15qGgZO8u9U35x4/Zpb2IIz0KfPKc/di1e0q+P+DqtQ0bQvZAGHbJ8mUH3PfUyG27kZjzjKufSnpsYifqGTW9301sdZ/Z/ObmPmD4cKkroQNMAirPoLKAhUUkKVlvqcHnkdguf9RCAcpiXX8RGI0IYVY0hSH3UBvu64JMj85OnuruxYuwZHkWuxAkL/XazYRUCNOnZVX30AMipHmy4wSzoGY0R9WdlVHQrZiuvSNFyjBCpNLju+u1Z9FzVaL+kzbnpXoml1XJk6DCiRot6QZyYkGJNJTqgHznZlU7lOpLcJRKGiqJ+3WGNDO5Tx75a4W7ce5ZCYIqSnA1/JPtg7KT/+t2bTxlJShHLQy4N6hoqrp+pR8WypdzcXnTNLag6znHvOM444wtKYpYYesHyTX7n0KSTVX9R5BPBSvPdxqxY0Ti7dn3vmRrzNxBmTOL7e8Z0l+B/pc2INbBzqjIq/jJAWBoQMFJyqUQEHWT7wf/Lwl3SVkLXelUjnpzEx9RAknzA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700021)(3023799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qvWOWYM3pA+LUrwYzBD///8NS/LhMgXIyBnO22WWlc9uMPyHLNy99v4vsz0T?=
 =?us-ascii?Q?tZ0ttCPV/jWOUrlnLHmDcxa8YOEYs5nnPi07P+Kx0Nj2Ks/jHrXiBQeLoIhs?=
 =?us-ascii?Q?OTwiZ/pTOfrG/ck2vXIPpTg8z4ZsxQK2XmHnY4LJ7x7TrreIHpgfi1oJr3cp?=
 =?us-ascii?Q?bG5+MFBWy6W2N9dh23/VDKSkFsh6N6NULRMb+0wjh7INbyCX1Pe59KY+jWwy?=
 =?us-ascii?Q?QE9aMPeBDZjypwLDkcPTwGsJmyqIZraHVB1wp4uPUwsf623pbjmei3b7m3bw?=
 =?us-ascii?Q?5sRe8VnG7nemWt/iPwPXRSB0tN/v865MJ/cc/istnbSqgms6CTvsr5OY6K/O?=
 =?us-ascii?Q?N/P1+TX19+ze6KlMiSYJJFTYVcof+F5sD90gk8u9zbI6Dt1kcQcGoCPA8mLx?=
 =?us-ascii?Q?46FuPLWi74FnrLgnT6YCR3RhC/m01BskaqofIb2Qa5Q+9kqql2GAHeWGHyp5?=
 =?us-ascii?Q?JJVXXSNE063upjghsiScnGtVk3nBoA8OZgV85lXpYRs9R5P5wRG3zzkdpXep?=
 =?us-ascii?Q?nE0u+ixE14auISmujDhbrhZkXPePFvRT/SuNvWpdMdFHCsr8mLQaHk4Y5avI?=
 =?us-ascii?Q?4a7WTjb+vzgQRMw1BuGxhlLzoTkfDYrNjgK8yk5sWBUPerf/M1JM5Yrv7R0N?=
 =?us-ascii?Q?vvPUL8R9nZlyKz3pJC05yvub+/7fjR5LngSdQOvTj/MdUV49J8AAfXjuhTNN?=
 =?us-ascii?Q?Jw+V6/i+7tZiZEKaMObK7Zm7OLKko4cysrHQ77BkPkbeQwk+LJ1U+J8qS6oW?=
 =?us-ascii?Q?hHCMeRZvbHfo8y5pcUTaqYGK82jmpEdD0g3nd/Z8as2bXnyDurUnJzjU3Ebz?=
 =?us-ascii?Q?V8TXykGyUTaHLyYzPCz9xaQwaxt2qI5Y1UILaztJ7aSiFSsnuY500Hgmfg/j?=
 =?us-ascii?Q?fmYt3vIOO0JEYRHyv6zAyrAqiCqwI+zQXePplTW67uiq3D5Wz050bPWQjq8D?=
 =?us-ascii?Q?1wfPfk4v/hYps6jf1pDG8MP2IvS8exyxAXBOJP+gZ6fsYV2NOYJ8XMj/UnrV?=
 =?us-ascii?Q?uP3JWiHyVSDO37CsIPkLPYVzJ7st3qL6ZtFWvNPmV6xnnU/XQP5xH0QWX4WH?=
 =?us-ascii?Q?GvYOG8t5RIhSH+/Kcfmhiya4Nj8a46pWgRQnzGl8ZtO10X7TvLR1B5qa7frc?=
 =?us-ascii?Q?wJQjI1ph1a2JQjacAED8mzw+8xNSHKmUfEKGLpZhmhNMOH1G5xXb0FPbvOm6?=
 =?us-ascii?Q?zRw/44fMyrEHOsrxsUdqx4zFNvuoAENJ0o8LlEwOmiJBt5F/YIYZzIF9VjlN?=
 =?us-ascii?Q?jhTpLrxij0AG+NC3oIELoAtFZFzTirm9aRUoYUhj9R+Ld28ykVFQC2UGlgzd?=
 =?us-ascii?Q?ggqM6CrmSoOf4gjLciQjUf8YeAOoFWZCfqCSXg2egpx3vWQHWUPe5l6sTkRU?=
 =?us-ascii?Q?SQSc0KDi4mbHLKwr5xqd68j77rL9ljdqiPbiVIefgTAR/Y/ei+fOIAOTtqQg?=
 =?us-ascii?Q?m95xWZ7rdPxBexMvEsazmZXQUxYC3flNoAl2GGJXRFauU/RwCs2vJxI0Ba0x?=
 =?us-ascii?Q?Xl2JbVc9AAa+QtayzaD45m3QjhWFc5u9LMjVWcY5lEBRKE1bVFhhvUAhMIJM?=
 =?us-ascii?Q?4EmL2E5hN0yvoX1g6x6KxvWU+ipEw+QlFZNdXtFMahwU1UTcbrRcYi1ul+5b?=
 =?us-ascii?Q?oHRHDP2DwLQcPJJyRtAVgNj+JwBjQvcXtBTn1EZjPlCfijb9JPS2XBgbg0e4?=
 =?us-ascii?Q?XXp08C/y6uXgOpq2LF8eaWQZqoezwwjAoSGgYG4/BSH1Qu1Ra9cnQsxdn778?=
 =?us-ascii?Q?UOb9WNRbhQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cfd9b79-cfb4-401e-06c8-08deac2074df
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2026 10:07:33.2300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1EwFoW3wq079hXSzqqkge/hn6gVzzvQFsX8exB+Gsxo5t0iIc3TPkeqH2fp8g00pWbjHA2qMCNeOq1RejX8SIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6824



> -----Original Message-----
> From: Eric Auger <eric.auger@redhat.com>
> Sent: 03 May 2026 08:33
> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
> peter.maydell@linaro.org; richard.henderson@linaro.org;
> cohuck@redhat.com; sebott@redhat.com; Shameer Kolothum Thodi
> <skolothumtho@nvidia.com>; philmd@linaro.org
> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
> jdenemar@redhat.com
> Subject: [PATCH v4 08/17] target/arm/kvm: Introduce
> kvm_get_writable_id_regs
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> From: Cornelia Huck <cohuck@redhat.com>
>=20
> Add an helper to retrieve the writable id reg bitmask. The
> status of the query is stored in the CPU struct so that an
> an error, if any, can be reported on vcpu realize().
>=20
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu.h     | 26 ++++++++++++++++++++++++++
>  target/arm/kvm.c     | 32 ++++++++++++++++++++++++++++++++
>  target/arm/kvm_arm.h |  3 +++
>  3 files changed, 61 insertions(+)
>=20
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index be14a47c35..2aa22360d2 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -866,6 +866,26 @@ typedef struct {
>      uint32_t map, init, supported;
>  } ARMVQMap;
>=20
> +typedef enum ARMIdRegsState {
> +    WRITABLE_ID_REGS_UNKNOWN,
> +    WRITABLE_ID_REGS_NOT_DISCOVERABLE,
> +    WRITABLE_ID_REGS_FAILED,
> +    WRITABLE_ID_REGS_AVAIL,
> +} ARMIdRegsState;
> +
> +/*
> + * The following structures are for the purpose of mapping the output of
> + * KVM_ARM_GET_REG_WRITABLE_MASKS that also may cover id registers
> we do
> + * not support in QEMU
> + * ID registers in op0=3D=3D3, op1=3D=3D{0,1,3}, crn=3D0, crm=3D=3D{0-7}=
, op2=3D=3D{0-7},
> + * as used by the KVM_ARM_GET_REG_WRITABLE_MASKS ioctl call.
> + */
> +#define NR_ID_REG_MASKS (3 * 8 * 8)

Probably can re-use KVM_ARM_FEATURE_ID_RANGE_SIZE here.
Looks like used for the same purpose in:
tools/testing/selftests/kvm/arm64/set_id_regs.c

Thanks,
Shameer
> +
> +typedef struct IdRegMap {
> +    uint64_t regs[NR_ID_REG_MASKS]; /* writable masks for registers */
> +} IdRegMap;
> +
>  /* REG is ID_XXX */
>  #define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       =
\
>      ({                                                                  =
\
> @@ -1054,6 +1074,12 @@ struct ArchCPU {
>       */
>      bool host_cpu_probe_failed;
>=20
> +    /*
> +     * state of writable id regs query used to report an error, if any,
> +     * on vcpu model realize
> +     */
> +    ARMIdRegsState writable_id_regs_status;
> +
>      /* QOM property to indicate we should use the back-compat CNTFRQ
> default */
>      bool backcompat_cntfrq;
>=20
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index d4a68874b8..f06a60804d 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -51,6 +51,7 @@ const KVMCapabilityInfo
> kvm_arch_required_capabilities[] =3D {
>  static bool cap_has_mp_state;
>  static bool cap_has_inject_serror_esr;
>  static bool cap_has_inject_ext_dabt;
> +static int cap_writable_id_regs;
>=20
>  /**
>   * ARMHostCPUFeatures: information about the host CPU (identified
> @@ -499,6 +500,37 @@ void
> kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
>      env->features =3D arm_host_cpu_features.features;
>  }
>=20
> +int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap)
> +{
> +    struct reg_mask_range range =3D {
> +        .range =3D 0, /* up to now only a single range is supported */
> +        .addr =3D (uint64_t)idregmap,
> +    };
> +    int ret;
> +
> +    if (!kvm_enabled()) {
> +        cpu->writable_id_regs_status =3D
> WRITABLE_ID_REGS_NOT_DISCOVERABLE;
> +        return -ENOSYS;
> +    }
> +
> +    cap_writable_id_regs =3D
> +        kvm_check_extension(kvm_state,
> KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
> +
> +    if (!cap_writable_id_regs ||
> +        !(cap_writable_id_regs & (1 << KVM_ARM_FEATURE_ID_RANGE))) {
> +        cpu->writable_id_regs_status =3D
> WRITABLE_ID_REGS_NOT_DISCOVERABLE;
> +        return -ENOSYS;
> +    }
> +
> +    ret =3D kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS,
> &range);
> +    if (ret) {
> +        cpu->writable_id_regs_status =3D WRITABLE_ID_REGS_FAILED;
> +        return ret;
> +     }
> +    cpu->writable_id_regs_status =3D WRITABLE_ID_REGS_AVAIL;
> +    return ret;
> +}
> +
>  static bool kvm_no_adjvtime_get(Object *obj, Error **errp)
>  {
>      return !ARM_CPU(obj)->kvm_adjvtime;
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index e7c40fb003..b22a56fc17 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -240,4 +240,7 @@ void arm_gic_cap_kvm_probe(GICCapability *v2,
> GICCapability *v3);
>   */
>  char *kvm_print_register_name(uint64_t regidx);
>=20
> +typedef struct IdRegMap IdRegMap;
> +int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap);
> +
>  #endif
> --
> 2.53.0

