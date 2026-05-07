Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012011.outbound.protection.outlook.com [40.93.195.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD7135CB7F
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 19:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778183083; cv=fail; b=kHNo3o+zCk2XQN3lxXpmV3TGn6cpQUSXf7MB508T0SIJ+JibyNRih4BZDJhGYGgaEzs/XjIXvULpW59nyOzhs0/5Jo9RqcZ7OvqBDJWW3U7XxuHoBIKor3YZXFrE2PGPyE89EaWnAcbtrn2J7mxUjh0aH+VGD/qrPobeKr4e1aI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778183083; c=relaxed/simple;
	bh=LOSQQ3A5btFfMkscswR77YnTY9SmmN3KW/FSYL92V54=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Oe5ljPG7PRP4xX9Tl+9lBzwh7ssT172O4vWdD6HAqGYBx5WY6hNeDPSxAYPilrNYl5qoMYMmRD2oNZpDCV6mccXPnZqS1Ggmkfx13R01WEh1yXHAyF4zSXOJf0NV6OlwzfHiNZ3ALJBscjN5sY/DztjmB9uyi8Kzmm8E1re9pTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uCqGq7H8; arc=fail smtp.client-ip=40.93.195.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uCqGq7H8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mkk5JM168C4N83rzO7tNh+rIMevsjiHlGeIOiet7G32NjwHorOfSNGVz/t+TTNFHWaIvCll67F4PAR5SVSmNtZzMhoUeZxgu7kDBnyak1640Desk/1rBcoNXg1j7Eb3/bfbgH0hhfQo6e4QV3ddBdXEVwZp9sMjTiDqrZSI+wxzCyun8SDQ3+mhj428eYCSF3WSZtZYbTq8AkLN57tELKu17SKP0hrAiJYVdZ69V9JxFu+5oUJWBc1BdoJTIl+vgNp6XWRHKD7C+He5sVlChxaOnC7K7vRX+FioGD+2lmAD7ziSjL+tB9Dr/x86MrEaA6edSGVa/dtc1jTmDV+uV3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJcexBkkj0+o0lFC5i6hujne5xoo81Sxct9ZMJyQU88=;
 b=sTYoxPhNkWmI7DzMACbel5SWI+LsJ7/kT+APQZhRj5OI+nvj6dKe2rzNle4SV5ZDd8sD0c/Z3GbJL3K/idmIssIEzboktR+QMRy1C0eAHx2katK7Xvundcdl2yXa9IIPSW74HgcdusHKufBjupOO22kHojmAcQhNR56ZOWaNvAijAGfWUeITC1kou32PDN3mcdfbBrFifLqy21ynvUQdKjB7Ni0AIBDzQ+yC1ySoDZKNqzXFHz700TytDYV8QNgmkNI3xo6JeHOvhvvYkjk0bKcjKdiy+voF94CSbLV0VCdZb4YZ98FIV7g799YEoQ4I0oh4vsNzpfGXDW4vf6zHLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJcexBkkj0+o0lFC5i6hujne5xoo81Sxct9ZMJyQU88=;
 b=uCqGq7H8hs990xVv5tTu3cRqvc0tX4QKq/AKUEimgnLdANTjyd8CxPNoDGRwlCecqtQnMpSH35ufkLP6UjnYg35IwhB+uSY+MTV+JRvTCBkEH3ptHabbMYIIKH/TvlEetYaNWGpBg3VJn6TE8UxeuHRv2lydx5YfHZDC9a9vc8S3C9oprjIIL4hsBEjFdae5maGFFcro1ef+rfrQU+VdCok6C2nm+lE9nI9EXwPDWkdHtDj7fzthtu4fBdw/VyhUlo1QWaU4rbI171wIJnVu2vv3B0aUfhc/7jZ+kBYKCPKGNdZfA5bsmajRUq2VHHiMIlOqik0BJfWHlARwXNSEQw==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by CYYPR12MB8939.namprd12.prod.outlook.com (2603:10b6:930:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Thu, 7 May
 2026 19:44:36 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.20.9891.017; Thu, 7 May 2026
 19:44:36 +0000
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
Subject: RE: [PATCH v4 17/17] arm/cpu-features: document ID reg properties
Thread-Topic: [PATCH v4 17/17] arm/cpu-features: document ID reg properties
Thread-Index: AQHc2s+53rPwsDHdIkCu5+H94U9RRLYC+KUA
Date: Thu, 7 May 2026 19:44:35 +0000
Message-ID:
 <CH3PR12MB7548322D7A29C8EC3EA0E49BAB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-18-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-18-eric.auger@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|CYYPR12MB8939:EE_
x-ms-office365-filtering-correlation-id: 751622ad-9474-46cf-b2ba-08deac7111a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014|921020|38070700021|22082099003|56012099003|18002099003;
x-microsoft-antispam-message-info:
 sacEGfh6HSKs75gDGw+4JcM+hod3FsSl9Khw7bWbHDOABcBZSAxY56s4VB5n4yJgIx2OQNkr8HCoUCHv9JNMx+5ba7yvZGoniL8ghpKaRxG/SqVHbWmNzfjklVhl4uEO4ZMX3rvsqzdhNXQCmTzEd2MiO07OQpiSK0jbITz+9RWWWfuvd8ZTqMXSVP02Jq3T6IlnACILbB6h2OaB4L0A1LJPcos5OmqEzbSFVr48P7LrwK51MhncVzapwS9LOn0Tdx0ItQs9x4FZcNl4Y7NlYcYUoQKzHuunZscgRnhVfdElq2FQhCJBVOMfa3xmU093cm7dDVNuzgawLdFbLc04bh8XoriYZGaGt1bvrHTwdFZCxo+nwusL8BydLEA9LhFvRuoV0OJiSaWu70yj1CI2YnRIL/7kc15NSblc+tI2Mxoe0t4rvgLzCpPpFOnnRrbISVbOQ78K02Z8H/RwjT0aXJKuHyone6zPGxoO7J+WhJL0wA7e8mq7s6yfHRYW9pQrmNWkeuYqqManKqXcfcMYGZ78TRLavdsOmKJkAD/kzKOf34ypo6G+xv2NpkPjwPR7buNRsgPbTDZmSOTuZXB0HphkzPhKPuy3FBuee+iTO9vsVvzeDRpGKKlD9ed4XlRVDoYkSd+gbrCb1ChTJ9q4sUn8X8ujUOyPk2sPsexEsSLDT4SVadCgCLhPlTH3wPyo4Dc+U/hbd9GJEDi8l925aj2kv9XLLwbKjEkuB8xlM4u76IHVWwe1FLs7UIhfqrCPenKRycMPMX3BgjjeuwBg3w==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(921020)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?h3ErZIzs6Sfl/DZBJy591lG/A0oNnFyQvR1Yqxz8AuNjXtC6Scfejpiy5bgK?=
 =?us-ascii?Q?yyfmWZKmO5Pc5FtaSawyiDid7j5d6OAqyr5QuKuy/ap8upet6cbwBleB8SVr?=
 =?us-ascii?Q?3tUNYS4YCd0RruWJR0uKTwQ/LnhHFF23hpWmGRHLwKcWTh+GntCE/V58xJdz?=
 =?us-ascii?Q?c9E9TA3C5K0lL2zGtjZbSgY+H11QA296oUCpRo6sav+0SIen4wgr4Bgl92sX?=
 =?us-ascii?Q?t2mf6fDRmIS8nBbqoEPjkhZm4IQpdvLdSP+AE9f/UtqmIYO/kE6glYav/vQo?=
 =?us-ascii?Q?m9EwrLvm1yvCjoONhxF+LxcbnzuacjQc3SZMJqefbpjEDbohFO11WuJ6TQcc?=
 =?us-ascii?Q?S0trDHHI05DUT/shKSb5d25yp5agCr5Fe4GoYqkM78bLzejhYo4Zdt4QlFVz?=
 =?us-ascii?Q?tK9NTnqXSFoLtK1qp3xLHzyeFbTo+HlkMK6MdfXE+fEpojv3t3DM4Ap3MHc9?=
 =?us-ascii?Q?ILdqjE5VXzM1m/h3a1CRnEdiCSuZ20LmjfBo9RdBRKAz+Idy2OUnzMr/B8Ra?=
 =?us-ascii?Q?Z+GQukdlwZU061fmFSUVEUPXE5jLTN9hLiiVcsAbIOiLkqXM275Ba1PWHByg?=
 =?us-ascii?Q?YQrjnd4lRikQvS+z0AmWeEfuWcAr/tK3j8UEBq3ldosfQFQnrgNcPjZCqrAV?=
 =?us-ascii?Q?E7osy6CITYlgRtVKHKanKTlqa+5gueslgRUrh+hvDzukS61Nk2E/oRSHL2V5?=
 =?us-ascii?Q?YiS6Ec0J/wwYenXg/CCw11YkPBA+gY5ytigOoAJ1+loH3xzlGLG8kW2F9eXB?=
 =?us-ascii?Q?8W+JbQ0VkpZg6ly2ODuklYe0kUCNSi5gxvBzxFA9MhAJRaA8iClyrC8bETXf?=
 =?us-ascii?Q?0sSChuMxZ3bQw42iT3dWilvJ5ty+lpeszjpUjEPnnC1lYF5TwmHFFGuGbfhl?=
 =?us-ascii?Q?OhEUGHXFHmLN82SClAZQVu0/KG9WxYiyzTbR/1JI7VAxY+dm6/kt0CXpoS+w?=
 =?us-ascii?Q?JU9UWVGa1kI+h7P4RNF/k6nu2Jg+W+4k3AP3hNts74fSTR9ylVvBqQW78A8z?=
 =?us-ascii?Q?0itDR1gneyIWICINHwZvqEHyPRReKgh55wjHfz/Mglo8hwAVuhSXokKd3gvJ?=
 =?us-ascii?Q?V3iUP7/Hn4li2A+q3RaQpcjlk3vocZ24UD0JeYwpQ19R3r6EQxTNQLIrNH+d?=
 =?us-ascii?Q?xniBNZvajCUHdd2Mq6lnuKxXQSf+MOxUi7RLXJURXmiAY3JAt5u8dCwMiyJp?=
 =?us-ascii?Q?6ZHLmkpcBoksltuBRQeoT1R529zgEMIOdB+6fIVTKTDcBeYAYQZZ3yU3vskL?=
 =?us-ascii?Q?mqpE7+lfM2YkNejvFMM85IzSBYQp+/r2T6DD7/hG9GfJeiVJ3uONC/4bSq2E?=
 =?us-ascii?Q?d81z95nuDnZpg0rmaH4FM2tnpcgGtfh/ZvMCNsV46DkVc7GWiLJrEGxouoEg?=
 =?us-ascii?Q?NPj/TJ+BCbvyQV4jqXDPBF00DRF+aDiVzH1QWBRc1COWsQGh0+m0gwIHF87s?=
 =?us-ascii?Q?Kj2oGJYTZIvLfS+9mCKC48JnCkYrUQBKvsqlx4AOG4VHE+P/u3/dbmkZsRIR?=
 =?us-ascii?Q?VJLNB8X70kM5f6jGotb1cPVp96DqOJnLnrvGIfEgEso6NIsRz1z5DdmF2Lg8?=
 =?us-ascii?Q?T3tDQGrO+1fPpXqd5kO88a2kMys3FkYbnK05hj/F6/3GMoCqiTg4/kA43qII?=
 =?us-ascii?Q?7kO9mz3oMswlSCe1KAoQ853X9LmaZW/S/Hw3bIhWjda2F4nL4d5qe+WxASgl?=
 =?us-ascii?Q?DjwpqZ/4a65RwWiNAOPUXzTTYMpGvdykCOlxmJ6zNsYe2nxkHXgmF/6CDaPR?=
 =?us-ascii?Q?OjqtCw+ZSA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 751622ad-9474-46cf-b2ba-08deac7111a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2026 19:44:35.9953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: naedk5zbE0xaL5oHeovN7nxOY1ewow+7OhvdLz9BioB85cycznxOK3HuHnot0DHPE9B1QdfoUwnuZ8cSKlYFUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8939



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
> Subject: [PATCH v4 17/17] arm/cpu-features: document ID reg properties
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> From: Cornelia Huck <cohuck@redhat.com>
>=20
> Add some documentation for how individual ID registers can be
> configured with the host cpu model.
>=20
> [CH: adapt to removal of the 'custom' model, added some more
>  explanations about using the ID register props]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst | 104
> ++++++++++++++++++++++++++++---
>  1 file changed, 96 insertions(+), 8 deletions(-)
>=20
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-
> features.rst
> index 10b0eff27e..22f671b15d 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -2,7 +2,10 @@ Arm CPU Features
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>  CPU features are optional features that a CPU of supporting type may
> -choose to implement or not.  In QEMU, optional CPU features have
> +choose to implement or not.  QEMU provides two different mechanisms
> +to configure those features:
> +
> +1. For most CPU models, optional CPU features may have
>  corresponding boolean CPU proprieties that, when enabled, indicate
>  that the feature is implemented, and, conversely, when disabled,
>  indicate that it is not implemented. An example of an Arm CPU feature
> @@ -31,6 +34,16 @@ running guests in AArch32.
>  CPU features that are inherently specific to KVM are
>  prefixed with "kvm-" and are described in "KVM VCPU Features".
>=20
> +2. Additionally, the ``host`` CPU model on KVM allows to configure optio=
nal
> +CPU features via the corresponding ID registers. The host kernel allows
> +to write a subset of ID register fields. The host model exposes
> +properties for each writable ID register field. Those options are named
> +SYSREG_<IDREG>_<FIELD>. IDREG and FIELD names are those used in the
> +ARM ARM Reference Manual. They can also be found in the Linux
> +arch/arm64/tool/sysreg file which is used to automatically generate the

arch/arm64/tools/sysreg

Anyway, I think this needs update as the scripts now uses Registers.json
from AARCHMRS, right?

> +description for those registers and fields. This currently only has been
> +implemented for KVM.
> +
>  CPU Feature Probing
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> @@ -126,13 +139,20 @@ A note about CPU models and KVM
>=20
>  Named CPU models generally do not work with KVM.  There are a few cases
>  that do work, e.g. using the named CPU model ``cortex-a57`` with KVM on =
a
> -seattle host, but mostly if KVM is enabled the ``host`` CPU type must be
> -used.  This means the guest is provided all the same CPU features as the
> -host CPU type has.  And, for this reason, the ``host`` CPU type should
> -enable all CPU features that the host has by default.  Indeed it's even
> -a bit strange to allow disabling CPU features that the host has when usi=
ng
> -the ``host`` CPU type, but in the absence of CPU models it's the best we=
 can
> -do if we want to launch guests without all the host's CPU features enabl=
ed.
> +seattle host, but mostly if KVM is enabled, the ``host`` CPU model must =
be
> +used.
> +
> +Using the ``host`` type means the guest is provided all the same CPU
> +features as the host CPU type has.  And, for this reason, the ``host``
> +CPU type should enable all CPU features that the host has by default.
> +
> +In case some features need to be hidden to the guest, and the host kerne=
l

s/hidden to the guest/hidden from the guest/

> +supports it, the ``host`` model can be instructed to disable individual
> +ID register values. This is especially useful for migration purposes.
> +However, this interface will not allow configuring an arbitrary set of
> +features; the ID registers must describe a subset of the host's features=
,
> +and all differences to the host's configuration must actually be support=
ed
> +by the kernel to be deconfigured.
>=20
>  Enabling KVM also affects the ``query-cpu-model-expansion`` QMP
> command.  The
>  affect is not only limited to specific features, as pointed out in examp=
le
> @@ -169,6 +189,13 @@ disabling many SVE vector lengths would be quite
> verbose, the ``sve<N>`` CPU
>  properties have special semantics (see "SVE CPU Property Parsing
>  Semantics").
>=20
> +Additionally, if supported by KVM on the host kernel, the ``host`` CPU m=
odel
> +may be configured via individual ID register field properties, for examp=
le::
> +
> +  $ qemu-system-aarch64 -M virt -cpu
> host,SYSREG_ID_AA64ISAR0_EL1_DP=3D0x0
> +
> +This forces ID_AA64ISAR0_EL1 DP field to 0.
> +
>  KVM VCPU Features
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> @@ -495,3 +522,64 @@ Legal values for ``S`` are 30, 34, 36, and 39; the
> default is 30.
>=20
>  As with ``x-rme``, the ``x-l0gptsz`` property may be renamed or
>  removed in some future QEMU release.
> +
> +Configuring CPU features via ID register fields
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Note that this is currently only supported under KVM, and with the
> +``host`` CPU model.
> +
> +Querying available ID register fields
> +-------------------------------------
> +
> +QEMU will create properties for all ID register fields that are
> +reported as being writable by the kernel, and that are known to the
> +QEMU instance. Therefore, the same QEMU binary may expose different
> +properties when run under a different kernel.
> +
> +To find out all available writable ID register fields, use the
> +``query-cpu-model-expansion`` QMP command::
> +
> +  (QEMU) query-cpu-model-expansion type=3Dfull model=3D{"name":"host"}
> +  {"return": {
> +   "model": {"name": "host", "props": {
> +   "SYSREG_ID_AA64PFR0_EL1_EL3": 1,
> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0,
> +   "SYSREG_CTR_EL0_L1Ip": 3, "SYSREG_CTR_EL0_DminLine": 4,
> +   "SYSREG_ID_AA64MMFR0_EL1_BIGEND": 1,
> "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0,
> +   "SYSREG_ID_AA64MMFR2_EL1_CnP": 1,
> "SYSREG_ID_DFR0_EL1_PerfMon": 4,
> +   "SYSREG_ID_AA64PFR0_EL1_DIT": 0,
> "SYSREG_ID_AA64MMFR1_EL1_HAFDBS": 2,
> +   "SYSREG_ID_AA64ISAR0_EL1_FHM": 0,
> "SYSREG_ID_AA64ISAR2_EL1_CSSC": 0,
> +   "SYSREG_ID_AA64ISAR0_EL1_DP": 1, (...)
> +   }}}}
> +
> +If a certain field in an ID register does not show up in this list, it
> +is not writable with the specific host kernel.
> +
> +A note on compatibility
> +-----------------------
> +
> +A common use case for providing a defined set of ID register values is
> +to be able to present a fixed set of features to a guest, often referred
> +to as "stable guest ABI". This may take the form of ironing out differen=
ces
> +between two similar CPUs with the intention of being able to migrate
> +between machines with those CPUs, or providing the same CPU across Linux
> +kernel updates on the host.
> +
> +Over the course of time, the Linux kernel is changing the set of ID regi=
ster
> +fields that are writable by userspace. Newly introduced writable ID
> +registers should be initialized to 0 to ensure compatibility. However, I=
D
> +registers that have already been introduced that undergo a change as to
> +which fields are writable may introduce incompatibities that need to be

s/incompatibities/incompatibilities/

Thanks,
Shameer

> +addressed on a case-by-case basis for the systems that you wish to migra=
te
> +inbetween.
> +
> +A note on Arm CPU features (FEAT_xxx)
> +-------------------------------------
> +
> +Configuring CPUs is done on a feature level on other architectures, and =
this
> +would imply configuring FEAT_xxx values on Arm. However, differences
> between
> +CPUs may not map to FEAT_xxx, but to differences in other registers in t=
he
> +ID register range; for example, differences in the cache architecture ex=
posed
> +via ``CTR_EL0``. We therefore cannot rely on configuration via FEAT_xxx.=
 A
> +feature-based interface more similar to other architectures may be
> implemented
> +on top of the ID register interface in the future.
> --
> 2.53.0

