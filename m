Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3EB4436A
	for <kvmarm@lists.linux.dev>; Fri, 28 Jun 2024 08:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719562246; cv=none; b=PzM6hPbAA7W7QmtMYYNvxmuZYbDbH5rmE+bXVUUpGDkekK+rTXxblHpXQsf35TvAzydNYEDfoNFLeNIeKl71wkDDspWGMOkQOK1gfO78ptO4RzOC3hpNmsc+taKQ/XBfwDKsVTg7sFU43JCGHTNJuvP2XpUKXHmeZbY8nMe0lBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719562246; c=relaxed/simple;
	bh=Yt5vNGVix0yKmXCbLIw92RFLblnVAHd1sqawgxijrx4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pifbay2vdmN1/SsZKZVVG0aNA+1vdmpXX3yflSmENAgwiJoU1EQ7TSsrEig8QC1/nPc38m7wdicVjSNOTgHbnBgVap+X2uqljt3zXu3f8GBXJR7RXBTpncyTYBHWwsk6gRqM/utMZlE3vmP+y4B8pEIg6O/eGkm5frwYhABdzZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4W9Skg4fR8zdfPf;
	Fri, 28 Jun 2024 16:08:59 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (unknown [7.221.188.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 6860218009B;
	Fri, 28 Jun 2024 16:10:34 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemd500012.china.huawei.com (7.221.188.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 28 Jun 2024 16:10:33 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Fri, 28 Jun 2024 09:10:31 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, yuzenghui <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Jing Zhang <jingzhangos@google.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v3 4/6] KVM: arm64: Disable MPAM visibility by default and
 ignore VMM writes
Thread-Topic: [PATCH v3 4/6] KVM: arm64: Disable MPAM visibility by default
 and ignore VMM writes
Thread-Index: AQHae7EcWBfUhFLWfESLuHqxbBJIrbHdahYA
Date: Fri, 28 Jun 2024 08:10:31 +0000
Message-ID: <e22f30c045b64f3da68fb0aa6c0b4e2c@huawei.com>
References: <20240321165728.31907-1-james.morse@arm.com>
 <20240321165728.31907-5-james.morse@arm.com>
In-Reply-To: <20240321165728.31907-5-james.morse@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hi James,

> -----Original Message-----
> From: linux-arm-kernel <linux-arm-kernel-bounces@lists.infradead.org> On
> Behalf Of James Morse
> Sent: Thursday, March 21, 2024 4:57 PM
> To: linux-arm-kernel@lists.infradead.org; kvmarm@lists.linux.dev
> Cc: Marc Zyngier <maz@kernel.org>; Oliver Upton <oliver.upton@linux.dev>;
> Suzuki K Poulose <suzuki.poulose@arm.com>; yuzenghui
> <yuzenghui@huawei.com>; Catalin Marinas <catalin.marinas@arm.com>; Will
> Deacon <will@kernel.org>; Jing Zhang <jingzhangos@google.com>; James
> Morse <james.morse@arm.com>
> Subject: [PATCH v3 4/6] KVM: arm64: Disable MPAM visibility by default an=
d
> ignore VMM writes
>=20
> commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
> ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
> but didn't add trap handling. A previous patch supplied the missing trap
> handling.
>=20
> Existing VMs that have the MPAM field of ID_AA64PFR0_EL1 set need to
> be migratable, but there is little point enabling the MPAM CPU
> interface on new VMs until there is something a guest can do with it.
>=20
> Clear the MPAM field from the guest's ID_AA64PFR0_EL1 and on hardware
> that supports MPAM, politely ignore the VMMs attempts to set this bit.
>=20
> Guests expossed to this bug have the sanitised value of the MPAM field,
> so only the correct value needs to be ignored. This means the field
> can continue to be used to block migration to incompatible hardware
> (between MPAM=3D1 and MPAM=3D5), and the VMM can't rely on the field
> being ignored.
>=20
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d6afb21849de..56d70a90c965 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1685,6 +1685,13 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct
> kvm_vcpu *vcpu,
>=20
>  	val &=3D ~ID_AA64PFR0_EL1_AMU_MASK;
>=20
> +	/*
> +	 * MPAM is disabled by default as KVM also needs a set of PARTID to
> +	 * program the MPAMVPMx_EL2 PARTID remapping registers with. But
> some
> +	 * older kernels let the guest see the ID bit.
> +	 */
> +	val &=3D ~ID_AA64PFR0_EL1_MPAM_MASK;
> +
>  	return val;
>  }
>=20
> @@ -1795,6 +1802,29 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  	return set_id_reg(vcpu, rd, val);
>  }
>=20
> +static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> +			       const struct sys_reg_desc *rd, u64 user_val)
> +{
> +	u64 hw_val =3D read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +	u64 mpam_mask =3D ID_AA64PFR0_EL1_MPAM_MASK;
> +
> +	/*
> +	 * Commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature
> bits
> +	 * in ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1
> to
> +	 * guests, but didn't add trap handling. KVM doesn't support MPAM and
> +	 * always returns an UNDEF for these registers. The guest must see 0
> +	 * for this field.
> +	 *
> +	 * But KVM must also accept values from user-space that were provided
> +	 * by KVM. On CPUs that support MPAM, permit user-space to write
> +	 * the santisied value to ID_AA64PFR0_EL1.MPAM, but ignore this field.
> +	 */
> +	if ((hw_val & mpam_mask) =3D=3D (user_val & mpam_mask))
> +		user_val &=3D ~ID_AA64PFR0_EL1_MPAM_MASK;
> +
> +	return set_id_reg(vcpu, rd, user_val);
> +}

Commit 14e270fa5c4c(arm64/cpufeature: Add remaining feature bits in ID_AA64=
PFR1 register")
exposes the MPAMFRAC filed in in AA64PFR1_EL1. Don't we need a similar hand=
ling for that=20
as well to handle the FEAT_MPAMv0p1 case?=20

Also any chance you plan to respin this series soon? We do have hardware th=
at benefits from this
series.

Thanks,
Shameer

