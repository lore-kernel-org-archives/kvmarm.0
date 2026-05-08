Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011031.outbound.protection.outlook.com [40.93.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0069E33D511
	for <kvmarm@lists.linux.dev>; Fri,  8 May 2026 13:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778245402; cv=fail; b=efwzGNIOeexRReQrmNkyMzmsd5mzfntkkzJ+Q43iBeV1kILQw7KsL3EpGO/dwhMSr2nDPc0WsMDoRqwbFCU6SYknuK3kvqD22oyUDb6xs0XhPeqttu+HAiPWmkUl0x1c2XLzwoAAPZ+SJ04Bxm7qBc/+VBC6EvSI96PtYkLYYI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778245402; c=relaxed/simple;
	bh=Vt//aCbOklmsD1he274YeRtPDic7A/lkenD5kT6dCwQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WCzkKcgjT4p5NyGG+I5cS/WbDTJ5KZR8gBE2BqPOCfd2Q+R+HTs0Q3aUNkdl1QjzK3Fz/YZmuehU2rgPviHQX+8mzZgY24Cu4tjoNhO3JIOk6BWcCYZ2vjIeMCBCpeEgZoQAGAT9h7L4mg7xBptFZ9UNB2s3X3kNgtOzCwP45sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r3+nCFTd; arc=fail smtp.client-ip=40.93.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r3+nCFTd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SgwXfBslH96y9mdBRfq6hWasJv8t+u0//pUISBnQdM2ub8ILD41LhI1LB7avTMc6hkqlJtZ0hJ0sHSkkSHNxePf50VuIki8J5GS+MyvNGchTlPgPubCwCRbT+Upn/gmBOiVY6UiQDyrCdsN1Cgsag06Vb9sYPlvo91+F4qO28UDo9386MDFhgySpVGUK3DaNrkGDnJ69p3vlnfqDuSJFlSCGbydYh4CLDyFqHHr81zq1mUfN9fjv4gcZk534IqztjYfJ38IaCmKGadQdD1zsGFJNlSxLDDIOoM+pwiJb6A+uB2y+92n7lMUJR7ZVnDHUv3JU0Xz/vm7RZLTpiAB+Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+a09WvV058PeBkYIQIpy83CLVkuzrH21/sVLfqV4o8=;
 b=EWIG7sJ+a6cXPQ7Aie+JQiZP67qfVRKZVNwb11zlbGR+2NCnwoE0GLdaXjd/ISfy0mokCge0NMzmRVsT9oo+6U0IX90i4GVeOflyx5FyZ8CuKLIyxlIrEEpFIFV3pcergdpbfmPhJh/RVRyFKrAw+60Aj043oyHevHme5L3P4mPZa63kDAxC8vIc7h9Eze7DHpkeU72F/eRrl13p8PabQWWYfw9b5gM/zIvjNzWy1gG1+zbov62tnyx8h4FWfiElOpb9DxD4gSMw3deeSRm1mJRs4Jq7oEuX2MSgLoD4Ne5721YSVIbAdoQ3gF1SNnVcQqWPHGhNfI+FljPcLgU6Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+a09WvV058PeBkYIQIpy83CLVkuzrH21/sVLfqV4o8=;
 b=r3+nCFTduAS4SQ7bUiPg61gcCcaRxddVMS3XCgNR0o5JcCrnnp7+ePAzZSZ48a1I8WyLu1qUIbO9qC/I6pSQF757NHfeBApBH2S9wzgJwmo39TzTCQFqACNKVVWbEx8WNA5u1kUf/8nzIzt3EIBQCEMo7El25HqKXi5C2pX+oJ9LK3XyRV4qOX9dWXzgip0Hsi99cBaJmKnShCs4IkUtnij7bjX5ju9sfw83v565swXmckskXzCyOOQ+DmgXlK1NZb4UKvB4WX8OyDnp90voTuwsXDCIjSeOJ8eRtpkprVAPdc8QUoTllQFssoUt0i4NPjBFbVFSRSn53HD+Tzr4Qw==
Received: from IA0PR12MB7555.namprd12.prod.outlook.com (2603:10b6:208:43d::5)
 by CY5PR12MB6622.namprd12.prod.outlook.com (2603:10b6:930:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Fri, 8 May
 2026 13:03:09 +0000
Received: from IA0PR12MB7555.namprd12.prod.outlook.com
 ([fe80::5a27:a8d9:43b7:3b8d]) by IA0PR12MB7555.namprd12.prod.outlook.com
 ([fe80::5a27:a8d9:43b7:3b8d%3]) with mapi id 15.20.9891.019; Fri, 8 May 2026
 13:03:09 +0000
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
Subject: RE: [PATCH v4 11/17] arm/kvm: write back modified ID regs to KVM
Thread-Topic: [PATCH v4 11/17] arm/kvm: write back modified ID regs to KVM
Thread-Index: AQHc2s+lMbTKReJJn0uN5USSIMu6fbYEH0BQ
Date: Fri, 8 May 2026 13:03:08 +0000
Message-ID:
 <IA0PR12MB75555B2C69AC473011333C72AB3D2@IA0PR12MB7555.namprd12.prod.outlook.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-12-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-12-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR12MB7555:EE_|CY5PR12MB6622:EE_
x-ms-office365-filtering-correlation-id: 97a50f21-5299-49f9-9d5c-08dead022712
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700021|18002099003|56012099003|22082099003|3023799003;
x-microsoft-antispam-message-info:
 5/XBqmFVnc1z+Fo0kCWTgxa3F1E5fbJ4wyIkQVWHOiry25oF+AQIglxRzVNhM1zf5jQa6hWhDj1AqzC6KsX9Ze4IkIxyRtmAkzq+5zFzmLzsXgm7lyf4wn9vxzD7QEbtjSNzJFIWV0vZxaoO0ouUc75ClqzCi/wXIRbASipI79EaNqGarrtEmR6HTAT/e/2W9vyLj49MNWo0rLP2+Lq0Q9LJM6E4rMszPcGzs2kX/+4yV8iPRcLp7ZpYbovgcj2/Ud5DSlddyvcGXYII6q771cZCKmjWJeMzkELxowFBj25uFnagm3gpsFsMAO7EbPK0QyrzNRK+jvKgAgxrCI1LH5MqCuw7CkRpBmez96ZHjZ2a5zELTdTldvtG0l7BgbVMWktWi4x9mpG34/f+Q+OtbY7EIftds/xvwutZUmC+saX1JmuYM6++uWH99DJx2WmCiYUnLNBvD/326SJV7q7INYyVvcLnurO7tH1d54RLZakxNh4Zr+CxqNX0jBkCIavVHdLR/gBY+LiWl4ufGST58pQrNYbDZmAaSR/QOJ7nLETMC7lYHK20J++VlyIt5f0yjUzRmkkn7NBZ7Z2zNhd2vGakw1XCRuDc/bb0PgXrZkUsSKxEYef6jXQUquG3di7KgfkVtZ06JjbBiy+S8tNL7F+SNdHp/pKRHVCAEVJH0j0/LJjSk7hTGWAZUnyU9yqjIDU3TqmWpBS0iThjbLKNG55fRTM+44TQnx+taEKuLFhgptRDyXlWQwDvjXBJd/6QUb2meopb4Y+h7RUeMpbQsQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB7555.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700021)(18002099003)(56012099003)(22082099003)(3023799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?M4nfSrF4wEafROtEQoHgFtnElR0fGo+SZc2XMaiwfUEwz9FAoqWr97saZdOj?=
 =?us-ascii?Q?D5y+yzoDctag/IRGGw6VPEvTWgwbTsQVePGSsSbXCrg9atV0Uhr0v1KjhxVi?=
 =?us-ascii?Q?PsRRSpObbDzLkNn0wPN3X6cUzYV0GUkomTRNSDsmrXXorZG1n0kt0MWwZZ6s?=
 =?us-ascii?Q?N7IDuwmc6zs1Lo5kXq0QbSUMu1T1LaWINY0mF9Yfkz0RDSYeB4wKnl2XyEJw?=
 =?us-ascii?Q?qp7v+nfouNvgtGiH2eOM6lZ6kIJ3Z3oG1hIWanaEQlOFeO0//rsTO4BkocxM?=
 =?us-ascii?Q?1Z4zYIe2yluGLhy923kuo3ts+kJA5mngOAL+B+RB2e7bTDXN8YrdrPrNv66L?=
 =?us-ascii?Q?jMlT6khrf9QDIcILhKBBNrXtqnHJbE0wrAt8M2iTTq4BydPUXt6uwZdLI1kE?=
 =?us-ascii?Q?dtjq/mAeiS6Nl4lCYprxWdz27E0vr/FBOvVnNOPbVBjmqZWtb/ZK0obQnYch?=
 =?us-ascii?Q?HPXG+9zWasVrXHagJePs72XhhWt8W7cD7CShCkXLpN6YnAdjzyOv7SCEJIPu?=
 =?us-ascii?Q?KbPwi7VoNJZ2RpQMzj5KDgEITExhfWKEt9Evkzgw/C4k3yfbnpXHWHzQ09i6?=
 =?us-ascii?Q?v7nAUPPNrLOavGtIFYvs7Ms3M6ZEebIi3L0woI6MQRGCFnw+gf5wu02/FTF2?=
 =?us-ascii?Q?gR5gNZWFHXe2pEdM4D4eDfdspisahB1gf4YMf2Vka53oT9QMdjWgtXh6/pc1?=
 =?us-ascii?Q?v3TzDCiUtmHnGhVO6q5CW0VQ6yAKBUEDOMTpdpcWL0sOspPLbm068i/vmeFs?=
 =?us-ascii?Q?Y50UlrNyjQHONOOq6gBdyeGEotqpvYtLSCX4TIWhyc6VgXejJ8Q8GlWmNSiv?=
 =?us-ascii?Q?FlgipaeM+gmJXFveyeMRz9UJClymrMm1TPbfBcG3EhH3IF8n2I/vErAtjNJy?=
 =?us-ascii?Q?aZxWBMFJN+YM5WZaSQjRIYLDOnAeXvf42NU7716F52wg7jUyQPtDlAMpE3yx?=
 =?us-ascii?Q?T95kBlS3Jsxi8XtW68OVwE55m4gVbTCltARjxRLsvtIdKyPXbgaW3ZRjNePw?=
 =?us-ascii?Q?jw/G1gyALe9UpEra7jN7BbtCXNqAWXtzudJRQrDFoDyQNbqRlEE53AUQ/q7q?=
 =?us-ascii?Q?MLxPNepp72kNikx8bGmAGeNt43s1zRJ8k4LHTfwEvvMxNE3quc11ozg0+CbM?=
 =?us-ascii?Q?m6qXvlwrPLiZ/HKMknvlLoapVmjOnFF2u8DzcfdBmEtn6fSwAowYILbgPZAc?=
 =?us-ascii?Q?p23eaV3l7s7t+Un2R1qinI3rykHNWS2FEUpatRmbykaloOZpSwhU2nm/h5St?=
 =?us-ascii?Q?bvZPaFZ1+Y8pfmt7/375UMxeHfs5Ot+8/acczbyaW8UavetNCXPaOYymdX/L?=
 =?us-ascii?Q?XOu19nVZQsERurCz6oomldbc4eZ0E2qRnvoL1Ntw5ZxKMmoc2f9Hk2VrH2vw?=
 =?us-ascii?Q?2rLHBv868R0CpLmPckC3X3cFIMDv53Y/N8sJcShYLoqSP6cYJKzFwInp2nX8?=
 =?us-ascii?Q?ZKndE0b+YUuqNxCYJGJS4E3aWRj3eAOH5LzfpqVrd5pWkXPFB6zFrfwUGgSa?=
 =?us-ascii?Q?xUL7Hvlqpsbz0stgmysEHsxvcNpB4SS+SbMDGuYzzluRgnVxgyLSIzLfJFkx?=
 =?us-ascii?Q?49pHJ3ZD+qvYGPJtI1NBajEakTfkiqYy6YhvlyTo/0oHN5m3jTO2HlCD1zhW?=
 =?us-ascii?Q?PDchFSwhMAB8waLgIjVq0lhODQojOKVcXWWFYO4BGF8+cYNddRnSBE1P9Bbl?=
 =?us-ascii?Q?NetWG9Tp3A51KHzvCvX0CG75cyVzKhnzmcR3Tgdl7SGAr/yRtTP/U4aEsnDZ?=
 =?us-ascii?Q?dN/H2D7zWw=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB7555.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a50f21-5299-49f9-9d5c-08dead022712
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2026 13:03:09.0224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hKHPGW+Pr7J5EzXyS8BXAOjTT4YMjcofWM7qyVBmWFKZIXwNeXZqbQyDfuZV4euBfRtsHxZ6TbA2xze5l/OoeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6622

Hi Eric,

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
> Subject: [PATCH v4 11/17] arm/kvm: write back modified ID regs to KVM
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> We want to give a chance to override the value of host ID regs.
> In a previous patch we made sure all their values could be fetched
> through kvm_get_one_reg() calls before their modification. After
> their potential modification we need to make sure we write back
> the values through kvm_set_one_reg() calls.
>=20
> Make sure the cpreg_list is modified with updated values and
> transfer those values back to kvm.
>=20
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/kvm.c        | 59
> ++++++++++++++++++++++++++++++++++++++++-
>  target/arm/trace-events |  1 +
>  2 files changed, 59 insertions(+), 1 deletion(-)
>=20
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 1a9b91bf8a..ca9a7d9439 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -275,6 +275,21 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
>      return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
>  }
>=20
> +static int kvm_feature_idx_to_idregs_idx(int kidx)
> +{
> +    int op1, crm, op2;
> +    ARMSysRegs sysreg;
> +
> +    op1 =3D kidx / 64;
> +    if (op1 =3D=3D 2) {
> +        op1 =3D 3;
> +    }
> +    crm =3D (kidx % 64) / 8;
> +    op2 =3D kidx % 8;
> +    sysreg =3D ENCODE_ID_REG(3, op1, 0, crm, op2);
> +    return get_sysreg_idx(sysreg);
> +}
> +
>  static int idregs_idx_to_kvm_feature_idx(ARMIDRegisterIdx idx)
>  {
>      ARMSysRegs sysreg =3D id_register_sysreg[idx];
> @@ -1197,6 +1212,39 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
>      return true;
>  }
>=20
> +static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
> +{
> +    if (!cpu->writable_map) {
> +        return;
> +    }
> +    for (int i =3D 0; i < NR_ID_REG_MASKS; i++) {
> +        uint64_t writable_mask =3D cpu->writable_map->regs[i];
> +        uint64_t *cpreg;
> +
> +        if (writable_mask) {
> +            uint64_t previous, new;
> +            int idx =3D kvm_feature_idx_to_idregs_idx(i);
> +            ARM64SysReg *sysregdesc;
> +            uint32_t sysreg;
> +
> +            if (idx =3D=3D -1) {
> +                /* sysreg writable, but we don't know it */
> +                continue;
> +            }
> +            sysregdesc =3D &arm64_id_regs[idx];
> +            sysreg =3D sysregdesc->sysreg;
> +            cpreg =3D kvm_arm_get_cpreg_ptr(cpu,
> idregs_sysreg_to_kvm_reg(sysreg));
> +            previous =3D *cpreg;
> +            new =3D cpu->isar.idregs[idx];
> +            if (previous !=3D new) {
> +                *cpreg =3D new;
> +                trace_kvm_arm_writable_idregs_to_cpreg_list(sysregdesc->=
name,
> +                                                            previous, ne=
w);
> +            }
> +        }
> +    }
> +}
> +
>  void kvm_arm_reset_vcpu(ARMCPU *cpu)
>  {
>      int ret;
> @@ -2148,7 +2196,16 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      }
>      cpu->mp_affinity =3D mpidr & ARM64_AFFINITY_MASK;
>=20
> -    return kvm_arm_init_cpreg_list(cpu);
> +    ret =3D kvm_arm_init_cpreg_list(cpu);
> +    if (ret) {
> +        return ret;
> +    }
> +    /* overwrite writable ID regs with their updated property values */
> +    kvm_arm_writable_idregs_to_cpreg_list(cpu);
> +
> +    write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);

KVM may hide registers based on ID register fields when features
are disabled. Updating writable ID registers after KVM_GET_REG_LIST
can result in a mismatched register list and failures when setting
registers.

This was reported on v3:
https://lore.kernel.org/qemu-devel/ae3f4d26-7a1a-418c-b303-2ed1d9ced4ba@hua=
wei.com/

Is this fixed someway in this series? I am not sure. I have faced the
same issue on NV platforms as well.

Thanks,
Shameer

