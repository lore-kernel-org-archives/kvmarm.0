Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011039.outbound.protection.outlook.com [52.101.57.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1942A3DB322
	for <kvmarm@lists.linux.dev>; Mon,  1 Jun 2026 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780327622; cv=fail; b=I14dDpGW5rJp/3rDap/iHO5wUtEPhopahgymDNVH4hFhOt47+Wy9QZE1xjd99rrEwX6NfKJoYCFEEWeBRIpJ/9UsS8gFBRvyTpeWaQMCAzIZCjmAGi8N6VCj/VHdSG3+1OnXepKEaJGx4HawYfQK1Jw8Y9Lde2JHu5k+xaEL10U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780327622; c=relaxed/simple;
	bh=zfPZvy4QrmmdHBAmgbMnAoEK6Ju270hynseImbnP3YI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mAmju5SlnjMb46UsdmpO19JnDEzJLBHuK/QMEQr6jAmvwGOEWmTVapK5eVwSe3XEW6fZ6qc5DWpFGZIa2W6cPZzKBdTL2FaiuZUJ4SMeGW7QstanqudCDQf8h/VxG6Qtg43y+Zx+cbCwZDcxgbN9NcJ3m9Q/3KSK4FobrTfGGfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SgfQdVNF; arc=fail smtp.client-ip=52.101.57.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SgfQdVNF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gt0bWa4td3UtHNcYzht82I7a307bdsihZuae+V1Xz6Jp14+SKLO760YzEF2DoiQNrEILuVphwjJrfIvOpgM64O7kk7X5hqeT1gLbGAkwFo59XVvoPybHZe4RFcn+cxpALJvpHcfuqlwIn0Iqe4fZPLB9rGecxOai+xQKzfM2cRDrAFJClOI2SU5PU6b4giottZQgSdnQTD9r9lXsVIFqHX8AbdyvVksdhbJfyctJrgM+STfJg1ZQsJL+cvhPlVDQqNJY6+LryfRPqDspizN3XFXgEK4Ron6rZlatXAAV3L167CGOnysTQ1WJbl4WknTrvYd7oVA9AA0EcSDNXHWy6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s2uXg75Wxk1Nf5QKn+FxRUYs+bqymL6msGKQS8TAjZQ=;
 b=mtca9KdLUROHA9kx+1oOZKwcoJbNOWR2bGQXRGah9ZzGIF/NMi63SIhHOWuyKa/akHO5dKJBTUi5FjMnpowXZHMkrtasOKdsShKb6p5jOWetkcG4EE5khrC0WchE2glO8vb2Ibjbv/gyujMrD3U5xCC5cxRHIE/T1o2er7Hve5RiVazJJEfhD4cFPKr6+9Eux/MT0JDnbHlnkA8cOt2YqR1+njAEzX7B3SOJjNn3inW2GqPcQbkHeR00L5mRa8kqDA44P7vdJ0z7YZZaEzLLled0H6N3BZRPAb1XeWI5IjyFVHZymQwwROgf1hN4bX2uhTXnAMmlI8HdziSMpV6eBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2uXg75Wxk1Nf5QKn+FxRUYs+bqymL6msGKQS8TAjZQ=;
 b=SgfQdVNFR1wR5Y8GfRb89Y8T+HcKm++b0oVhKs/dNmunqYuYYXj6gKbVd4tQ96r6F478ssjLp8chYXyYm90PGG7njWSOQsgcj/iq6+vVklKui3tuNg4T1QBIXNzjM1M7nvtg/t5UowY6WB0jiAeXJp8zm0XaMep6+IxUVejtaQ0iPRE5jQ361uA6vIZu7X3F8KRsaymIKA0HS9bZXNPgi+bZBZ0whp5V0IWwLSOj/9S1DN/dV1PgzlR2m8nX+BAZAZOktUmvDuQEj5PyGnNSfZt0SY6zs2UyJi9MHeOxsqpvbrA6OWE47G36Pz/UK4u61r71j8/J8FdP+WgGzGRmug==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by MN0PR12MB6197.namprd12.prod.outlook.com (2603:10b6:208:3c6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Mon, 1 Jun 2026
 15:26:46 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 15:26:46 +0000
From: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
To: Eric Auger <eric.auger@redhat.com>, "eric.auger.pro@gmail.com"
	<eric.auger.pro@gmail.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"qemu-arm@nongnu.org" <qemu-arm@nongnu.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "shaju.abraham@nutanix.com"
	<shaju.abraham@nutanix.com>, "khushit.shah@nutanix.com"
	<khushit.shah@nutanix.com>, "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>, "cohuck@redhat.com" <cohuck@redhat.com>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>,
	"sebott@redhat.com" <sebott@redhat.com>, "philmd@linaro.org"
	<philmd@linaro.org>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"armbru@redhat.com" <armbru@redhat.com>, "berrange@redhat.com"
	<berrange@redhat.com>, "abologna@redhat.com" <abologna@redhat.com>,
	"jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: RE: [PATCH v5 09/18] target/arm/kvm: Introduce
 kvm_get_writable_id_regs
Thread-Topic: [PATCH v5 09/18] target/arm/kvm: Introduce
 kvm_get_writable_id_regs
Thread-Index: AQHc55OmmG1EZz6IvU+saqlCwZjBQ7Yp5jBA
Date: Mon, 1 Jun 2026 15:26:46 +0000
Message-ID:
 <CH3PR12MB75486B98CDFBA297999F9DEAAB152@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-10-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-10-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|MN0PR12MB6197:EE_
x-ms-office365-filtering-correlation-id: e2705273-f7d3-4c01-8de0-08debff2313f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|22082099003|11063799006|4143699003|56012099006|921020|38070700021;
x-microsoft-antispam-message-info:
 wJhNZxZ1pOu5cbrxh2jM7NLhRo3GU5ltR8jIAucJxy8I7OsEeY4rGa+j4ZfjbwHMwWWj5wAwJb1/RGoCFpnuWJElQXPEE8Z2R3Ik+MiHPuTgduy7aC8X8mgAez186W3cA/ziWFVRxuT55fabdT5snoQP1oNEEcXTy9aJC9t1bLskBZVblJ1CUzuFgpu7JjCpbQlTuTWZrdOhcPb/zK420a6XUzYDcc5pP9enhMB0pEKjQWFdzL8RushTNq7W5EIBV/I2rEtLT1TqcZYhzj/p/FB6dYpBetzGpv6JmTuFoeo03ylm9Q1yuCo+FmpJiZn9JoEBPs8qyYl3x0qDFjfB8XI/wsabxU6d7bSKazIDuhU3DZ3C/78IXxFZtvN8qS5kERl+VROHMjFeMcVYX32iIdUvCgnaPumVQL+pTuGRGHh2+hKl+cTvU9/E0/9ergDTN5ptr/9Q4zaFQXrJqjMtQakL3vnG6N4UcsdlRssvGnptHppKc6Moa4fbEXu41kXGJ9lo+wABBe5QZ01kSc9BCRK/gDj82XVyDHx1VUXez1FAcvQjc0GCfOB4bSJlaeheL3Sz4VffJGxmdOWDC/yY3o5Q4LnJe2UYCV7dx9uheOY9lHLs0AWY60xlCXZ85mfhRv2fWfByOtDrNqt+7rNZEFgSiCz6XbYHJh4jJkXOl6yxY0S3W7WKHFOGa+qp8zp8LQzrqUlosse4k3sY2h1Jr7zfdcnO5gNjR1QG4J1L4ggQwF6Tes6N0kOV+zTby72r+B8FcxQrQ2BLxhqbP6VHTQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/Tb0edUFAxlsE7EPokEfwHFr3XTcd5f6X/jdY1koGDHV280WbJUq8bT7hKRE?=
 =?us-ascii?Q?1P2Ku75dcnyAadnfeXzck19s45rhfZ3EQfm4uk30ntsT0mZutdyW5HrB5qRN?=
 =?us-ascii?Q?f8ZCj2Lg0M5+3Y7OX3SRT0uTF48y/GrEK2ni29XvS1x2QOXNirIY8P5sty5l?=
 =?us-ascii?Q?eaJTsjrezyKoDs7k94Ui/DkdqPTvJ+rriQou5jAZFDtXs2Ru9gONfrgyt2yR?=
 =?us-ascii?Q?uri8xScXhut0ZaVmz/5XhVV5IrsMePyEiGhJzxEjetbWO7XbPPN3udEL7+Lg?=
 =?us-ascii?Q?t1DygWzmPFksjooQEEXvXZasDHaG4LHyEadoRtEYCBIEVqGesIrTBG6rKEg5?=
 =?us-ascii?Q?pc22iHbQkU5b9pOZpLlurDePKqCnolVCDm8Q52cjH8pcfrFt0NcpK2J3aEYZ?=
 =?us-ascii?Q?KGKmN6/GnmsnZQeo8/dAxmctpftovaLRS1PE0MdCG5iglc8mYIaJXjv+heGr?=
 =?us-ascii?Q?1U83X8FBg+4C3iFEMqCP4U9QvqRlIXfjFcA1klNcuPSHuz52pX6LdFS4AbDY?=
 =?us-ascii?Q?bQhZpN86ZvZWP/jt7goZ67ENBI0EvCX7FXGLUVVWjxNJTPn4jI229Z8zTd49?=
 =?us-ascii?Q?NBmhLZT89BdN3JkISQXn6BAERauZffH9u3n9DB6Dpe3xGtirGXPFj+DF/DL6?=
 =?us-ascii?Q?SLj3mc3pnnxEC91nffiZsrHtdy4L6evb4U7Mdtu8sYmfb9a490ut+8qUy31i?=
 =?us-ascii?Q?3T7oiSwrjxhWS3dZm1g0WyX2OnmtWrjiFwU9Ym+Xwji9yZma7VidHqFsfiYW?=
 =?us-ascii?Q?h/fewSlUMX3wJnZwjCNYdSibbMmp+XNduuzCMo7cidWahMZkBwLxYgwTw8Q5?=
 =?us-ascii?Q?grW6HG6mbAL89BXzaVaWnFWKqWgqk8N/OidpGVOejfjT4NZD8eltsmRZUqJC?=
 =?us-ascii?Q?s95lioRlIwh5T/dlt78w7IFD1Cc54hkMOHHD5BJ1umgDSDaFVKszx+WhFZ0A?=
 =?us-ascii?Q?gg2YZi79FNDcsV9RDloEsUd0ZDCAfpidfoTygmqBI2U+aUWilOg4cVBGAn8m?=
 =?us-ascii?Q?RwyL8G43Ame+irYBT9cIbU63bpesRWFh19PXTLDinhngnsd4YDJS1BrtLXtT?=
 =?us-ascii?Q?uPyfiRepWBsPSxiC0YhxEYfvrYWXylTP5s4Y2bRdqulFXPw4lrkqfPG8oTQR?=
 =?us-ascii?Q?w61A1eHDsdE1Lq4DqChAvjLrhcBhNVc5ESZNWz0WyE6axbeqPvKO/mkDwlHN?=
 =?us-ascii?Q?Fn9c82LR4HZ7jc4g/CDCZXXQcyxPMg+j16lIMqBux7eCdmGfA6furqfq1/8K?=
 =?us-ascii?Q?tzp4kj/ChoOHcz/itOAnO4hrCX285XLi+cORJuUP/x0f7lJV17+v+p2B0HCO?=
 =?us-ascii?Q?GX9FBIi+iu9fHZkCoR9MIT6seRqkJZbvD50/Jvqi15TGIA2Gs9P0cWmdCX4G?=
 =?us-ascii?Q?cVavvAsQc8iQqABWuEg+nR4finfImmaZ7yP3u5OIhEBbUG+okpQCqHbhZinz?=
 =?us-ascii?Q?s92gZzJI3Dfm25BPWiy6fnxQ3qDM3NHJXUnQTbRJKLUzZBKhsihPN0PbMOg+?=
 =?us-ascii?Q?KId+1tboCqHiOAupkj4AqA0X/D9nkJ4c4dPIbPQf/jNd08JIzomnwrmzdto2?=
 =?us-ascii?Q?5LY1NzvR0ZGo8tG8pMQepYTEJDUPNs2fPRV0DhJlmccUdGKlRX90jSErbdpm?=
 =?us-ascii?Q?jarPaua8oN5SzRyKHwjRk6HIl5ZAfys0O6PIh8JwCPQoDG72NZxJtmuRbYsQ?=
 =?us-ascii?Q?SmDk84kz7OhhptbrmzEC7Z3vkxws1lcpGamS1b0YeFAwsapitVBA3MWnchZQ?=
 =?us-ascii?Q?8Js/tydyTg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e2705273-f7d3-4c01-8de0-08debff2313f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2026 15:26:46.2336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7hRJIwe1j6OxzszMh2M9IzKOzUQBHFRjmxKQS+2SEavgNM8gcc8H6fHzylTr8IaI57VAOFM9njv48TTIIL+A5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6197



> -----Original Message-----
> From: Eric Auger <eric.auger@redhat.com>
> Sent: 19 May 2026 14:27
> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
> peter.maydell@linaro.org; shaju.abraham@nutanix.com;
> khushit.shah@nutanix.com; yangjinqian1@huawei.com;
> cohuck@redhat.com; richard.henderson@linaro.org; sebott@redhat.com;
> Shameer Kolothum Thodi <skolothumtho@nvidia.com>; philmd@linaro.org
> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
> jdenemar@redhat.com
> Subject: [PATCH v5 09/18] target/arm/kvm: Introduce
> kvm_get_writable_id_regs
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> From: Cornelia Huck <cohuck@redhat.com>
>=20
> Add an helper to retrieve the writable id reg bitmask.
>=20
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>=20
> v4 -> v5:
> - get rid of IdRegMap datatype
> - do not store the status of the query in cpu anymore, just
>   return the error in case the retrieval failed
> - add implementation in kvm-stub.c
> ---
>  target/arm/kvm-stub.c |  5 +++++
>  target/arm/kvm.c      | 21 +++++++++++++++++++++
>  target/arm/kvm_arm.h  |  2 ++
>  3 files changed, 28 insertions(+)
>=20
> diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c index
> 88cbe8d85c..cd88eb741a 100644
> --- a/target/arm/kvm-stub.c
> +++ b/target/arm/kvm-stub.c
> @@ -119,3 +119,8 @@ char *kvm_print_register_name(uint64_t regidx)  {
>      g_assert_not_reached();
>  }
> +
> +int kvm_arm_get_writable_id_regs(uint64_t *idregmap) {
> +    g_assert_not_reached();
> +}
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c index
> 7d194ea112..4adfd20050 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -505,6 +505,27 @@ void
> kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
>      env->features =3D arm_host_cpu_features.features;  }
>=20
> +int kvm_arm_get_writable_id_regs(uint64_t *idregmap) {

Nit: Subject has kvm_get_writable_id_regs

> +    int cap_writable_id_regs;
> +    struct reg_mask_range range =3D {
> +        .range =3D 0, /* up to now only a single range is supported */
> +        .addr =3D (uint64_t)idregmap,
> +    };
> +    int ret;
> +
> +    cap_writable_id_regs =3D
> +        kvm_check_extension(kvm_state,
> + KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
> +
> +    if (!cap_writable_id_regs ||
> +        !(cap_writable_id_regs & (1 << KVM_ARM_FEATURE_ID_RANGE))) {
> +        return -ENOSYS;
> +    }
> +
> +    ret =3D kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS,
> &range);
> +    return ret;
Nit:
return kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);

Besides:
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>

Thanks,
Shameer
