Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010003.outbound.protection.outlook.com [52.101.85.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B01322A1C
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 18:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778180026; cv=fail; b=XOtsXqAtQBxCLes+rC0s86cTzZKHb9hi/prUzwVQBajKOCiisS+cu1Xsj4SSD/tYpAT3ebgwCHeBwzNcq2rxmOe0TUzP7sZREyJUsf6u7FzgoixtZQgB8+hZfaMGbKYN+bT/dz9T7NTLwNv90UFTrceuZ7x7i8bdviswnHzrBas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778180026; c=relaxed/simple;
	bh=3N7jknYLO8rKsRtG83qsukVLfRJSIDtJSoG78LQUtEU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sCQZianaJ8cQs7ihr0wBKDUslzw6+Su/JjI+dcNj/KTGJv8ILtM+r+DNR6P0FuBs40F8QmJNeAihnvTe9dId+bs2vfetjn3hpPJtwXCaxM+Hx168KfMnYCGir+S717JP1pgSjCdHz68nFkpljdSzHW9++/JLNA6mL4B8AnVNRck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ajBLLRzU; arc=fail smtp.client-ip=52.101.85.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ajBLLRzU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OSFrevWuTRAfKNO4kk+Duu45J99xsnHb96oqqtaLkT+4CNdG+e385fUSjLxrhCvkSRLw+ehaF7cgfqg6+0DIo5mT1wJ2qKPXMkFTHmv8J9gkPquqa5mKn/2zY/BssbaTJrvY8dLf9AMDynBINP4HhIZSj4NCB7TMBVwWp6dkIHxksGi/4cMex0i5fnZsIBZQSYauBJdCqEWbT+uIvnpL+XDPCDwyxBj4uxLtqNRNXbHi/uF1awMzHV1SODmyFj/XbGtAqo+6MnCo+JkHHTKPHQD+bTYKPoB0HotJUNpOdZW5dTtZ6ST2yfFwiePajk03qPh4gHDBGVY/o2SSemhTHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kalou5lHOivAguLWzRmtREQaKQvHmoxeINsKT2qiBs0=;
 b=I+xw0PHu1VBy/iQOosteigotCd8tPQnkAHvRyjQqaTViC9zAIlPdZGuVfVk/7wpRhcQRz18GbiomvVKaHKP8om6AIob/qlljcQPyGKmRvIm14ZBFJjCZxQOgNOOchTDfR5fIbKHLi1QJImgBOTIOeTZCY9lshIrhH6kLLAbPLw+NPhPsppfuizAodqgl3+7r1yHreONu8YgoTBlNKVUML6CUK5gkhREm6sYqE10fZ/f0XNRgXiEVa/fszyeO6ZVqNIctxu9f+/eBh/ITPx5DXXGYe66mvnQ7evURdGBaItiT/M9Yp0ax/Km3wb17Sh5BJgghxxNA0wjQXeW/H24RTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kalou5lHOivAguLWzRmtREQaKQvHmoxeINsKT2qiBs0=;
 b=ajBLLRzU/2TurR0PgtPQoAtego0UhDoJ8J/GCU1hluACdREPqiGE6oEOyM0u9C/hyWoeC5dTDqaor5o/ArpA/tOnJs2G+/LOUaS7zs/5PTXZ/oPEtU9pHhWfka5p+gI4C/ltpEhzMAPUXpE0RHnLQ60Cc6CDtOO8oJecSD5Y4TJK52fkJIrgHr8erEnupFDKSAooS3CQYac/p+EIiMRHD2/C9/CMfCgX0zaBGR5jx/Ljm8nX3dXvt6KZi57JEh6Ejytf5HrdQroAz/UTlw9r+kB4VDK2g8LVLFv2xrN9228wXWN6eIanNlGNEPBgOL3c73RkhrLrABJ0x1LAQWJHMA==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by DM4PR12MB6011.namprd12.prod.outlook.com (2603:10b6:8:6b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 18:53:25 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.20.9891.017; Thu, 7 May 2026
 18:53:24 +0000
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
Thread-Index: AQHc2s+lMbTKReJJn0uN5USSIMu6fbYC63EQ
Date: Thu, 7 May 2026 18:53:24 +0000
Message-ID:
 <CH3PR12MB75485CF3FBF68E8E60E5B005AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
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
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|DM4PR12MB6011:EE_
x-ms-office365-filtering-correlation-id: 9c76870c-6285-48af-e0a3-08deac69eb09
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003|921020|38070700021|3023799003;
x-microsoft-antispam-message-info:
 65Zd00W3P9V8zdyxyaqpJfKjSF915ApoR67nSYm0be0pkNzNlfopqog5xm0iobk4BqNvs9oAjJwL+TKv+d8r0EHhFniP1mJ4VnL5Z9dudIeuRjBxRsmjvnGKDZ+JjEim1E93vB3xwxZsjzmzcWO+C73QYdASoi425+xZe0F5aomcqc5G2L4b8JhPmk5mm2h0SpKezdGA1x/4PZPbE8SZtIETLHL+IhGy94CHx/n6aajh57M18KhWnBAFeCMBlkS2Iv5nEafJuQ37RgFxjErpZsmTrVzckt80nbObUDOpYIcz1bCSp7raPd5tO0+at90CV6Aiq1+3VNJByryS7QoMPFjM4mTfnfNg+tDc0/fZt++pomp2d0DmbwXyLDmAJWTTLclslDvucQxaZMqk2whJ5vcvBubiNnMiY47B3BTPNZWz1+wApyKfovHaCn7JiL4ATsMsCt5APxHsDJTwoksgy12MPHj1DkF45OlaeeIvc7jTgjk5pbGaQUobWaQ+ASrq9xsJqLuaIeIHP7UIFbNPfA4D1+vMVxHoVihBb9xpcieicMMjJDaSRACKb4uEWjmQGbL+YFTXIHKCV9IkcTaHwJJXavgE+wVR3TbRbmBtBoKwXV66d/r2HG92zhf3UF/finNueTKT22OB+euJ980wmuFjR7NY7/zpF7ttCtcGHjW0h7CC9E8pnv2Vjih1B7Hx2WzPzPm7eI0L67S+0VftVqvfpI20/CVhnyDNt4RTiAIiBfS0Ik1exUZvlsfibDgOznJDlMlNcjPYviGDMBeQfw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003)(921020)(38070700021)(3023799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?r7CLu1qPjDf2SkQqM/6OLVn+PhCNQPIhN3mappbQaHQEeuGVxJQbOfZ9r4AT?=
 =?us-ascii?Q?mMhnrzwiHgKjnRWmTOrkYHt/XtREo7mfrjg/UZudQrlsKruYGNXdRVedj6/J?=
 =?us-ascii?Q?BR+lhdb1PSc5nldV1SnyrxfMThpH+NnMZHT+bXLeuvq1gOLEFuZLCW+YlQ8E?=
 =?us-ascii?Q?n9/MvYOMyTuasNkMkJNqMu0jRbuLHL6uEHSgrr1n+Q+zCtuoQgJljC5ast/T?=
 =?us-ascii?Q?zyLl9Z9FRjmJeCCd++2qBmd7X+DRecSHa4AvcoEsQC6YogjSKvqFiIRVSIeE?=
 =?us-ascii?Q?ngvqqi6AVy7ktJzLTCWDzGMhKIbc9OZZM7MAeQc8AcPLOfFTSUU+BeLjU0wU?=
 =?us-ascii?Q?iqwslaQzwVKDhoeMcwLd+UO2Ej70Vxj2nAwVwODIiusj3btR+4HMowGH3OLH?=
 =?us-ascii?Q?pjUEmJMxvSIoRJ1Sad41LhgPFLgbXVACEP2PNnjLwoak8CPm7TIBCvQLMSMO?=
 =?us-ascii?Q?w82WhFR1y1N7OB+GTujHqzHRSCGZMYw+PxCBAgoaxUbMwsYEAE22/MFw7kqF?=
 =?us-ascii?Q?f56Sz0ZG/L9ylYSSQXyMpzHN262GB/CM/cTNPlThXIRdNOQb1VG8eUnhDsoh?=
 =?us-ascii?Q?5XYcyZ/bw/4nX+XaTrYW8sRlULXFh7h0MhY48+8uEKoxDSe85WE0hByp8Qg1?=
 =?us-ascii?Q?6vxCwW1Yp+90qVVs1IS6mz/xvbUFlhQe8xLpqTFgWX+YT4/WHw6ICknNolsf?=
 =?us-ascii?Q?DSugjHJvsvGVBgFKkh07NOi72IFXKHqivhjEFmI8Ed3PbSAlCV6PnapjpkrG?=
 =?us-ascii?Q?w/KmF/HDcZ1jzLVioAiFEEmRmDSvkpwn34Dp5IHEbEfGCjNQQbfAG8orppVi?=
 =?us-ascii?Q?2BJA+8P6CqC1YQA7uogI75mAGUDNCrUgQXuYSPGsuMXp07264cNoKUXMNo6r?=
 =?us-ascii?Q?Ucy3TZoMkaBfHv91qAGOYwkDlT52CWgGrDnILasrF481ZqwObZYymNNGaw7U?=
 =?us-ascii?Q?9y8phS2qJHcQdw5bhqkfmlHUoFeP5wa52Oj5on2AQJbwdvxgAf/cShW9W7pF?=
 =?us-ascii?Q?j8qH+4c2SNXZ0jhQ/6PxSRFfjwU8AN/g1cvz3tFphEgjiluyl0MsXxYXkB7s?=
 =?us-ascii?Q?0VrJvP3m3InOu8fv365yF6HMtDdrPcy3McUggNTDDxB4Io1GJIb+Cmm5g05+?=
 =?us-ascii?Q?J0njcKb2I6qENWPMwwkMMu6Gn+5sDpSh0yPQICIAfGI9d9y6DJWdwoZtPdi1?=
 =?us-ascii?Q?HetKgSeCSQ2/Ts+4lfmyBvUAiKaB+Xudy0iOHr5/I4vC4OSPmCLjcDihyAFv?=
 =?us-ascii?Q?80voDWezdSrN1Yo3WrcaS01Sccp7c9fFeOpvX+Tsgp6PdfJBmYPB6tBrmL8N?=
 =?us-ascii?Q?z/Fn1Z8+qHTgH695+nQP6H+L07HwYPQ/bLlCy7e/9s9AT8ezTRvXrcF+Eaa5?=
 =?us-ascii?Q?gC89YYD1urZ78I+ICT+SXI88fiG3Qq4gU//XYdo15tje55RBm5mdOPiPeHpl?=
 =?us-ascii?Q?xliXJdiyXILKpHdIM5DUK+ZgSnRjPj4Nmqefyx1+lbVa3/sTn/34rglwFMiR?=
 =?us-ascii?Q?dnoeujM8CTSUwjtk7fg0hve925lGeq1pnCTuWhbY/S+0jUXrZZs23IKPw/2e?=
 =?us-ascii?Q?1GQ116bLpswu4CDvfRprXSwHKijA8q/wNwbJEKDNVeXDAQ0AKhLxyKDlrL6g?=
 =?us-ascii?Q?ZnKgOoppAAUH56UJQIW+bCBS7dWfEv92LpbxEbhJMgd/Pc4as7xlzmVtEyrf?=
 =?us-ascii?Q?j+4Kdn+2JhVMX8hiOYlpX6X0vzzAqHMalRM6IN5C42gR3pN3AI89Z9Y6wtiK?=
 =?us-ascii?Q?bckVonexuQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c76870c-6285-48af-e0a3-08deac69eb09
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2026 18:53:24.7923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bGzH39JI3R3hfNCvMX4KByGe/Fqm95MXW8JVPPUruGEJ4mJsdo3tDiv8Jtqf8hmatrQDlBvOM7WpwtKAjeYVzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6011



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
>  target/arm/kvm.c        | 59 ++++++++++++++++++++++++++++++++++++++++-
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

kvm_arm_writable_idregs_to_cpreg_list() does nothing if writable_map=20
is NULL. But we unconditionally call write_list_to_kvmstate() .
No harm, but still, I think better, return a bool indicating any updates an=
d call
write_list_to_kvmstate() accordingly.

Also, please check return value of write_list_to_kvmstate()

Thanks,
Shameer

> +
> +    return 0;
>  }
>=20
>  int kvm_arch_destroy_vcpu(CPUState *cs)
> diff --git a/target/arm/trace-events b/target/arm/trace-events
> index 8c7faf57c7..c25d2a1191 100644
> --- a/target/arm/trace-events
> +++ b/target/arm/trace-events
> @@ -14,6 +14,7 @@ arm_gt_update_irq(int timer, int irqstate)
> "gt_update_irq: timer %d irqstate %d"
>  # kvm.c
>  kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova =3D
> 0x%"PRIx64" is translated into 0x%"PRIx64
>  get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host
> value for %s is 0x%"PRIx64
> +kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t
> previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
>=20
>  # cpu.c
>  arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
> --
> 2.53.0

