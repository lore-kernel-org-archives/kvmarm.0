Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010032.outbound.protection.outlook.com [52.101.201.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726C53EBF19
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 11:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778154670; cv=fail; b=OZ7xQfkdMV1Gh/Ab/dJNgB4yVhBXaV4SQ01FFzQ4dw/1MTmZYZpEKGEXLP5+ar3QFgZeOhjd/pZ2Ipn+xNv0bBGhu1MZe1ZQTfiXhnsY+EctcRDNOWOzGwtPxUJTPsu59OjJnlapsCRUBVRxlXstfuEsj+N3ZVYswYFhHiqgIuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778154670; c=relaxed/simple;
	bh=L4izV1u/PIIAzucWAa2HZss3Y4bawBxyrZESqmq1gKQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=svf0YJuFtXmncgA0lXy9QQI6e1DMp5jTuydO3gysQHXArlv5haCewxJ/LPH2qCr2g56RI/AIRQH92BgTGImyjeT0/2pUXus8LUMJgVf79fgyYhraOFjKLEDpXxJaoLbnJWEKPAf4MN+5Nnhq1MrVMDSEFSWyWeeJnqdXHc76SDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QPi6aNdg; arc=fail smtp.client-ip=52.101.201.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QPi6aNdg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OkVXJSoJx5J9vNyGE9yodW1AsC2RP5FAfw6RF7ih9bns8F6uWHOip6R5eFP0cKZpT/qLoNN+maslnU/R+ASMpUUcsrkxuep44GoiIMDJy6rufuVrISARMtCCHzDH4cL09oaUrY9OXCYrmPVtB0dPPBGeKRqwDJuce8gN2Yn7SvlmKtK3cufUexWrONEN0jr6ArcFZkaVTRc69UpYEe6KLVBrq7Pws3O1AZiMsehoObtcf0Xi79mlPstsXhSeKt0rzTRs5TX0vLYIbsjdxb5lEIIQQtM+aCvirxP6OK5kEgBzkA9RW3PH2Cd4+iNp6YYjT+0ZRe7DujKDGREAycSKvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VEkYncv8oJub53rACAQzqz1nS+newePmWhpXEY2RMw=;
 b=aUsm2xZb3Mz6KJcKAeFykMx9/BoyHL52+LRKFWAlvWhiQwHroi4RU3otZPwtQexp3Jk5zLWC/rjvDyjXuaKxo8/imby7EGUuXSf++JmkeR4dJgTdQlaWjHuKUWllokfaIm/Ayzj7HviDseyIDOYshv0tms1wGte8v4aN2oLDN19taKZFqRgbrNAFQAHOCOWMlwjegn1TCmlYWncuPMB5C/W1fND7qqUuIdLtZAkvwgOdud2G7sCxyMnW9hshPTAUr+2U0adIui3bkxsifvgeEKtU63k3dEVjbmuTqDT2x0EJM8Soejxv2dOhOsdplvFDl9+uwNCy3sS50dt5gTacMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VEkYncv8oJub53rACAQzqz1nS+newePmWhpXEY2RMw=;
 b=QPi6aNdgl7xX3e/KAUNdUhscQyJWrOnumZAazD/st3neEb21HkyS8wub03Lh7pJpnJ34FAOkvAiRwVxzbxUoyDMRyrVqiFZM3q8Ji/MGmp1O3AXxLVbFk8TKB2mGi1NMqPtwcN1fljVasA1L2r1SINPFZJBnSOQw+LPX8zGR2w1xtSAGRN18DSKmyyK5WjnNlgyQ1byLBs7Yc9PDXFbt5unCt8uh63/cXzS7qgmP+5bxxzF5aD+9e9tMPPBN7+YhlBegjNjH3jVGPD/Fo6ovADENQgCBXU9HMT2EjGda/JEixfGiIv+QpGkawzaupxo+uGYXswtdVlNHpUvIEyS+DQ==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by DS5PPF2FA070BDF.namprd12.prod.outlook.com (2603:10b6:f:fc00::649) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Thu, 7 May
 2026 11:50:57 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.20.9891.017; Thu, 7 May 2026
 11:50:57 +0000
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
Subject: RE: [PATCH v4 10/17] arm/kvm: Allow reading all the writable ID
 registers
Thread-Topic: [PATCH v4 10/17] arm/kvm: Allow reading all the writable ID
 registers
Thread-Index: AQHc2s+h6qbOSNdMDEa7G4XmgseR1bYCeWHg
Date: Thu, 7 May 2026 11:50:57 +0000
Message-ID:
 <CH3PR12MB7548063DB7204E6D2FEC1167AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-11-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-11-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|DS5PPF2FA070BDF:EE_
x-ms-office365-filtering-correlation-id: 789f7a49-916b-481d-589e-08deac2ee6b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020|56012099003|22082099003|18002099003|3023799003|38070700021;
x-microsoft-antispam-message-info:
 2skm3n5pppkoLSbL8Hvt611noi5FSB+lV0kcttdNso5XK6tHgL1uuvxeyEN7cVoa9y85loCfALEt4lg6d8IZx9l/95pPwp1AwRxiGi2hf5I0PNuybaa9cQ2U5TIkJCUumgClzqp2NhpAA9R1Ou+wqSMaLxfm2HalDXhdFRChZqdFbPtB+UxDuKJqT+ZLVwEXrJ6v5zlKjrBKCiRRWWs7w9BSLY3vBunzZ6YKc1zq50vvlGcRenVYIsUAb58RfzSRvorf9yMu+TuoQG+el6ToAJj85aJ3+HSly20LRcCf4Tc3kW7pL2lVJr9r6M+RDkf//sD5JknTDWbOs5iTNou34WC+8ZpZPY0CE7cSB9wwnIbxSG/gruh9TU4tXBPUZvnM2L6bollxjFvloOzsPKZT0o60XXX/Gh5cVBIetL9psZmMTX1JNvzVOBPgRZcEXx2IXDZ38+XO0mR6fytMyOkvzfAzwRjhDeyUfD/EQj8WoyQGzfSVIhI30JHvQ2gMKyDUWx8Yvv9X6IstYj0bMULzITA8I9sWTg5n/DC2LPwTCYhq5qGbB2M1kNE5r2dZa9k/PqO25K3139R9r0uNkLFyRNW+z3InBcmbdY5jV9EYVw6pdDHUWU710nCAESwagQB+q4DjyGRnVL9hkQ6VcqAQskLpexO0FTcJLcNfmh3jj86/l6iNbograqgY4S0AaJg2uesF6mjpxhtP2MT4FooyKMcNPM9TkDlEsNuzxmxnwp2KHnUeR1wvfiNh8zvNeIGCQy3kZXS6T4+wXYHk9a98iw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020)(56012099003)(22082099003)(18002099003)(3023799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?GgzsmrfxN0BmBA2ZP5/ii6xoe2EvatWIH8SeH7/ZCyoP3z3HaqIt5j8wJujt?=
 =?us-ascii?Q?T4IKWYHL8a+DtXV2w2k6FOaisLzAlFUEJVytjWD/GuZ3/sPFSeG7xZTjcxbg?=
 =?us-ascii?Q?99g5gh0zxqBljuqZRPfmiAayj9oSw/RrhdoBCPY8GFXBTZ8zyiel+fcPnkz5?=
 =?us-ascii?Q?5LRW4BKU2uCuaN0l/V58l0CcwsoLnQjBpnax0YEVKfHD5q1bEgR3Yxz9XTdn?=
 =?us-ascii?Q?P3vGsNh8gcaDEhVcV0PL6fqgdHt2ACRqJp78vEREqaiTGEA3pnXfYQ4U9o5z?=
 =?us-ascii?Q?YKqVzD9ISr8Pq1XJfPBV9/iUnhi4FhvzyMEeTvEBHqsYspQZYmMEdsflAoRR?=
 =?us-ascii?Q?BYIABX3X5ER/vTD/LE+1NYy44TdBMd8xrAZzePxO/KFklEeLAjwXDRhJQ/nf?=
 =?us-ascii?Q?8AcoZwK/6h/0HQrYjP0V+ds1WpLE8EfR9Of65SP9WP1Ta1LLtdQjyn6IrzSS?=
 =?us-ascii?Q?Y5z8H7HAKvCmoo7OQnbvmC1w6ckzuWU6MZQaiIkDcOZe3RBRQlC8ctx4cID8?=
 =?us-ascii?Q?Ifn7fLpYTbpRdswxMaUtLMQxoUrMHjNiIZ9sCpv0LB9hCb/e9VaspczbHMY6?=
 =?us-ascii?Q?EDZcnfAMFACCyiEh3JOamAAdAx8YlG7KrDE2UlAEuzn+FHJmSuV74MmIL6/C?=
 =?us-ascii?Q?vQimMWyJUIMsMxUhISOGi2lVC+gyxxlAdmoIH3evYNSd/xsjuVVWZgjoWnf/?=
 =?us-ascii?Q?KVHMXk0JZ1jhvDu7pOC6XdCoNAdEXevZKA1IvIcLkWVk1E5LhYlya5Pw5zDO?=
 =?us-ascii?Q?oFe/4X7MQKEGrTHqKBSlrmjIAmYR6acbxu+gh2Lj0aDtIvGCMTKmcXy7DHu/?=
 =?us-ascii?Q?lUcMDydA/T9LzulEEORNOjpUMkXHq1cHtAHrsHEEnk4HLBWgrpw5tTrYg99t?=
 =?us-ascii?Q?Op7+Iqa/HooUtIW9SeimG7ysU9dHhGSPB8ujdrVjqXQiLc6DjZ3vqWXT/efQ?=
 =?us-ascii?Q?fesD3fN0JKSqVDCZXoyB8iQtelNqqtt11MxRzLwWnfzVUlUPFZazT+f0mbFH?=
 =?us-ascii?Q?+1B95GpP580n9nOm6UtL/5pN7PHSGwdIIrRX3tnC5MRUoCuWRyKdZRnxu51Z?=
 =?us-ascii?Q?bSFp0MNxA4p6D0keNdyxQb2qlanQXhStK7EqWhcqXC3nOdGlEjlUm5grjD6v?=
 =?us-ascii?Q?CGCI7e/qEV67pcMlQPBPjGBLeiSrwwaSaEa9GgsH1nVbdhyfxSgGnSHBhkng?=
 =?us-ascii?Q?QeSnqhkc+NxkUdLUWops8JjwCgKHihjSwX9JrfQ6DAzzTjSO+C5y8+aoReh4?=
 =?us-ascii?Q?uO0dM4CsaqLRYggqp17wwv90iyk+GrlPzjv4S8hsK5PHfYK43mJJGcTrYd1H?=
 =?us-ascii?Q?OYU3yH5OaJT/c6thPtPcFW/ZzQVG3Si6szOL2UFHic5LkuvczRqnHaNPU04+?=
 =?us-ascii?Q?+YQx36gRW+OFzsTEvmuMezsp8TDfCmrC+0h+x6shkiAS2x3qxLhYBzgqO+d5?=
 =?us-ascii?Q?xf25lNct++2iLK9X4mqfZJxwVrk8PGBT2yDi/V4UfDOnay1/fxJkqEMXGZvQ?=
 =?us-ascii?Q?Ll3dm90scMmFUjSMtCr878t9/2moiMkGJIc7qQoRUGDSwGIZaQ7s2+rUBnAe?=
 =?us-ascii?Q?OFcN9VgTeIzKzUmvw2ArbBPtfpRFfXcTGj8TDUmneWPa2FWPvgeCddh0y4iQ?=
 =?us-ascii?Q?sVWBTH62Fpqj2EyhlR7MTTDN49bqU9Mc1TVOuNDX8W/7Yj8q4UXJ7ecIWIIU?=
 =?us-ascii?Q?vsywwfW4uVgXyTOlUZcD0q0WJmeHQY8sAjMZi1+HES6kjIDixyixcY4vFIyZ?=
 =?us-ascii?Q?psKiZ8Z3UA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 789f7a49-916b-481d-589e-08deac2ee6b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2026 11:50:57.2080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y3nuef1NK5wt8vzfakY2cYPK/UiZCHc2PgNwoet1KDvVLnYZk1PUGJXZ5hEyVszFJ+TVpLfqckTwptIoiaJ+hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF2FA070BDF



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
> Subject: [PATCH v4 10/17] arm/kvm: Allow reading all the writable ID regi=
sters
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> At the moment kvm_arm_get_host_cpu_features() reads a subset of the
> ID regs. As we want to introduce properties for all writable ID reg
> fields, we want more genericity and read more default host register
> values.
>=20
> Introduce a new get_host_cpu_idregs() helper and add a new exhaustive
> boolean parameter to kvm_arm_get_host_cpu_features() and
> kvm_arm_set_cpu_features_from_host() to select the right behavior.
> The host cpu model will keep the legacy behavior unless the writable
> id register interface is available.
>=20
> A writable_map IdRegMap is introduced in the CPU object. A subsequent
> patch will populate it.
>=20
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu.h        |  3 ++
>  target/arm/cpu64.c      |  2 +-
>  target/arm/kvm-stub.c   |  3 +-
>  target/arm/kvm.c        | 77 +++++++++++++++++++++++++++++++++++++++--
>  target/arm/kvm_arm.h    |  6 +++-
>  target/arm/trace-events |  1 +
>  6 files changed, 86 insertions(+), 6 deletions(-)
>=20
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 0ac0fd13cf..87fb0047eb 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -1087,6 +1087,9 @@ struct ArchCPU {
>       */
>      ARMIdRegsState writable_id_regs_status;
>=20
> +    /* ID reg writable bitmask (KVM only) */
> +    IdRegMap *writable_map;
> +
>      /* QOM property to indicate we should use the back-compat CNTFRQ
> default */
>      bool backcompat_cntfrq;
>=20
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index b940842d9e..1b3d3fb245 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -862,7 +862,7 @@ static void aarch64_host_initfn(Object *obj)
>=20
>  #if defined(CONFIG_KVM)
>      kvm_arm_set_cpreg_mig_tolerances(cpu);
> -    kvm_arm_set_cpu_features_from_host(cpu);
> +    kvm_arm_set_cpu_features_from_host(cpu, false);
>      aarch64_add_sve_properties(obj);
>  #elif defined(CONFIG_HVF)
>      hvf_arm_set_cpu_features_from_host(cpu);
> diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
> index 88cbe8d85c..94478c5690 100644
> --- a/target/arm/kvm-stub.c
> +++ b/target/arm/kvm-stub.c
> @@ -45,7 +45,8 @@ bool kvm_arm_el2_supported(void)
>  /*
>   * These functions should never actually be called without KVM support.
>   */
> -void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
> +void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu,
> +                                        bool get_all_writable_id_regs)
>  {
>      g_assert_not_reached();
>  }
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index f06a60804d..1a9b91bf8a 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -42,6 +42,7 @@
>  #include "hw/acpi/ghes.h"
>  #include "target/arm/gtimer.h"
>  #include "migration/blocker.h"
> +#include "cpu-idregs.h"
>=20
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] =3D {
>      KVM_CAP_INFO(DEVICE_CTRL),
> @@ -274,7 +275,63 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
>      return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
>  }
>=20
> -static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
> +static int idregs_idx_to_kvm_feature_idx(ARMIDRegisterIdx idx)
> +{
> +    ARMSysRegs sysreg =3D id_register_sysreg[idx];
> +
> +    return KVM_ARM_FEATURE_ID_RANGE_IDX((sysreg &
> CP_REG_ARM64_SYSREG_OP0_MASK)
> +                                            >> CP_REG_ARM64_SYSREG_OP0_S=
HIFT,
> +                                        (sysreg & CP_REG_ARM64_SYSREG_OP=
1_MASK)
> +                                            >> CP_REG_ARM64_SYSREG_OP1_S=
HIFT,
> +                                        (sysreg & CP_REG_ARM64_SYSREG_CR=
N_MASK)
> +                                            >> CP_REG_ARM64_SYSREG_CRN_S=
HIFT,
> +                                        (sysreg & CP_REG_ARM64_SYSREG_CR=
M_MASK)
> +                                            >> CP_REG_ARM64_SYSREG_CRM_S=
HIFT,
> +                                        (sysreg & CP_REG_ARM64_SYSREG_OP=
2_MASK)
> +                                            >> CP_REG_ARM64_SYSREG_OP2_S=
HIFT);
> +}
> +
> +/*
> + * get_host_cpu_idregs: Read all the writable ID reg host values
> + *
> + * Need to be called once the writable mask has been populated
> + * Note we may want to read all the known id regs but some of them are n=
ot
> + * writable and return an error, hence the choice of reading only those =
which
> + * are writable. Those are also readable!
> + */
> +static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures
> *ahcf)
> +{
> +    int err =3D 0;
> +    int i;
> +
> +    for (i =3D 0; i < NUM_ID_IDX; i++) {
> +        ARM64SysReg *sysregdesc =3D &arm64_id_regs[i];
> +        ARMSysRegs sysreg =3D sysregdesc->sysreg;
> +        uint64_t writable_mask =3D
> +             cpu->writable_map->regs[idregs_idx_to_kvm_feature_idx(i)];

Nit: I can see writable_map  is always populated by the time it reaches
here, but may be good to have:=20
g_assert(cpu->writable_map);

Thanks,
Shameer

> +        uint64_t *reg;
> +        int ret;
> +
> +        if (!writable_mask) {
> +            continue;
> +        }
> +
> +        reg =3D &ahcf->isar.idregs[i];
> +        ret =3D read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg)=
);
> +        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
> +        if (ret) {
> +            error_report("%s error reading value of host %s register (%m=
)",
> +                         __func__, sysregdesc->name);
> +
> +            err =3D ret;
> +        }
> +    }
> +    return err;
> +}
> +
> +static bool
> +kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures
> *ahcf,
> +                              bool get_all_writable_id_regs)
>  {
>      /* Identify the feature bits corresponding to the host CPU, and
>       * fill out the ARMHostCPUClass fields accordingly. To do this
> @@ -401,6 +458,18 @@ static bool
> kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>          err |=3D get_host_cpu_reg(fd, ahcf, ID_DFR1_EL1_IDX);
>          err |=3D get_host_cpu_reg(fd, ahcf, ID_MMFR5_EL1_IDX);
>=20
> +        /* Make sure writable ID reg values are read */
> +        if (get_all_writable_id_regs) {
> +            err |=3D get_host_cpu_idregs(cpu, fd, ahcf);
> +        }
> +
> +        /*
> +         * temporarily override the CLIDR_EL1 value since host value doe=
s
> +         * not seem to be supported. Getting "Unified type is not implem=
ented
> +         * at level n" error in fdt_add_cpu_nodes()
> +         */
> +        SET_IDREG(&ahcf->isar, CLIDR, 0x0);
> +
>          /*
>           * DBGDIDR is a bit complicated because the kernel doesn't
>           * provide an accessor for it in 64-bit mode, which is what this
> @@ -477,13 +546,15 @@ static bool
> kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>      return true;
>  }
>=20
> -void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
> +void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu,
> +                                        bool get_all_writable_id_regs)
>  {
>      CPUARMState *env =3D &cpu->env;
>=20
>      if (!arm_host_cpu_features.dtb_compatible) {
>          if (!kvm_enabled() ||
> -            !kvm_arm_get_host_cpu_features(&arm_host_cpu_features)) {
> +            !kvm_arm_get_host_cpu_features(cpu, &arm_host_cpu_features,
> +                                           get_all_writable_id_regs)) {
>              /* We can't report this error yet, so flag that we need to
>               * in arm_cpu_realizefn().
>               */
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index b22a56fc17..91a7d5cc4b 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -127,11 +127,15 @@ void kvm_arm_destroy_scratch_host_vcpu(int
> *fdarray);
>  /**
>   * kvm_arm_set_cpu_features_from_host:
>   * @cpu: ARMCPU to set the features for
> + * @get_all_writable_id_regs: if true, get the contents of all writable =
ID
> + *                            registers as well
>   *
>   * Set up the ARMCPU struct fields up to match the information probed
>   * from the host CPU.
> + *
>   */
> -void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
> +void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu,
> +                                        bool get_all_writable_id_regs);
>=20
>  /**
>   * kvm_arm_add_vcpu_properties:
> diff --git a/target/arm/trace-events b/target/arm/trace-events
> index 8502fb3265..8c7faf57c7 100644
> --- a/target/arm/trace-events
> +++ b/target/arm/trace-events
> @@ -13,6 +13,7 @@ arm_gt_update_irq(int timer, int irqstate)
> "gt_update_irq: timer %d irqstate %d"
>=20
>  # kvm.c
>  kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova =3D
> 0x%"PRIx64" is translated into 0x%"PRIx64
> +get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host
> value for %s is 0x%"PRIx64
>=20
>  # cpu.c
>  arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
> --
> 2.53.0

