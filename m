Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1533172767
	for <kvmarm@lists.linux.dev>; Mon, 31 Mar 2025 06:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743404074; cv=none; b=HuVf42vxTjC3NS8l+i18xHW2obDkbbZ+wayE6qO3Urg8gBZyeGaytdi17GsbLWPseYdhLzsFfWp/S2gcJpNbW/crk/xY0ZRJ0gRsRHnFOQYsgYfi7Eo3L/5C1YIPhlibtn/xyzzLIO3RpbtpOBLPx9lTHQLcIod31hXsYJPailQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743404074; c=relaxed/simple;
	bh=YVZprOIJjhTejkn+2yrh+GejzKo3uE8v8jqzT2YetXI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I5qMgDCEW9hc0sGYBYNzUY5IkS1oSU+8603wIsCkdsEeXMO9LLyrDY8maun1aS+e2UstevaqvazniSLYLvBOwbubk4UGha1Tvgf7x15SvLy5EcVRrOYYqO+b3RE27Sb3GouMNp93i7aguWdFO57EHaIEfxrkp8CmhS0hlZBL6Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZR1x40ZN5z6M4hZ;
	Mon, 31 Mar 2025 14:50:48 +0800 (CST)
Received: from frapeml100007.china.huawei.com (unknown [7.182.85.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 8FD01140257;
	Mon, 31 Mar 2025 14:54:23 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100007.china.huawei.com (7.182.85.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 31 Mar 2025 08:54:23 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Mon, 31 Mar 2025 08:54:23 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Oliver Upton <oliver.upton@linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, "Lorenzo
 Pieralisi" <lpieralisi@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] smccc: kvm_guest: Align with DISCOVER_IMPL_CPUS ABI
Thread-Topic: [PATCH] smccc: kvm_guest: Align with DISCOVER_IMPL_CPUS ABI
Thread-Index: AQHbnzaiWLoM4Pr1N0ylxjrv88F9hLOM1NNw
Date: Mon, 31 Mar 2025 06:54:23 +0000
Message-ID: <e670c3778d794d82878d0b4cdd3d11d5@huawei.com>
References: <20250327163613.2516073-1-oliver.upton@linux.dev>
In-Reply-To: <20250327163613.2516073-1-oliver.upton@linux.dev>
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



> -----Original Message-----
> From: Oliver Upton <oliver.upton@linux.dev>
> Sent: Thursday, March 27, 2025 4:36 PM
> To: kvmarm@lists.linux.dev
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> Mark Rutland <mark.rutland@arm.com>; Lorenzo Pieralisi
> <lpieralisi@kernel.org>; Sudeep Holla <sudeep.holla@arm.com>; Catalin
> Marinas <catalin.marinas@arm.com>; Marc Zyngier <maz@kernel.org>;
> Oliver Upton <oliver.upton@linux.dev>; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> Subject: [PATCH] smccc: kvm_guest: Align with DISCOVER_IMPL_CPUS ABI
>=20
> The ABI of the hypercall requires that R2 and R3 are 0. Explicitly pass
> 0 for these parameters.
>=20
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Fixes: 86edf6bdcf05 ("smccc/kvm_guest: Enable errata based on
> implementation CPUs")
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

> ---
>  drivers/firmware/smccc/kvm_guest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/firmware/smccc/kvm_guest.c
> b/drivers/firmware/smccc/kvm_guest.c
> index 5767aed25cdc..ac2d3cf8a776 100644
> --- a/drivers/firmware/smccc/kvm_guest.c
> +++ b/drivers/firmware/smccc/kvm_guest.c
> @@ -95,7 +95,7 @@ void  __init kvm_arm_target_impl_cpu_init(void)
>=20
>  	for (i =3D 0; i < max_cpus; i++) {
>=20
> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_DISCOVE
> R_IMPL_CPUS_FUNC_ID,
> -				     i, &res);
> +				     i, 0, 0, &res);
>  		if (res.a0 !=3D SMCCC_RET_SUCCESS) {
>  			pr_warn("Discovering target implementation CPUs
> failed\n");
>  			goto mem_free;
>=20
> base-commit: 369c0122682c4468a69f2454614eded71c5348f3
> --
> 2.39.5

