Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F60E1FDA84
	for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 13:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737984964; cv=none; b=Sj3/4CpmTWj/9GhALEl62uNrEPS7nvLyRc/B2oGlJS8fjgM3L9QLUf7CMDkvEW1+/Xg506eh1wwEHtArFhbJLUOfIZkm875YCcVFDqDAKHuYDp4Tq/3KulcvCAn/ZLyfjAHv4US7+NYM0TWnLCcBzv3xG1JPDjNh03Pcov6ra+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737984964; c=relaxed/simple;
	bh=1Qmcxt25T4fLNnwbkzhQ23TYAdcBJCBF8sOcyYbtQKg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WarXHmguyGOMf0X4xmJ3C/QwF+cJ1KcYFGh6esVG3zMKTpJ50nolK4EdJw6Mg4+xjeFIgJoeVceB9fGIhoYGizZcrjKmcNpvQnLyxc6i1Kh6XO/cloR6ZFZJtPPHxKsVuYEymPY2M7XGzYK00mSMVFovxb+zQrbVOPRVxIYqMV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YhTs96bcrz6L50S;
	Mon, 27 Jan 2025 21:33:49 +0800 (CST)
Received: from frapeml500006.china.huawei.com (unknown [7.182.85.219])
	by mail.maildlp.com (Postfix) with ESMTPS id 4D5F91400C8;
	Mon, 27 Jan 2025 21:35:59 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500006.china.huawei.com (7.182.85.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 27 Jan 2025 14:35:59 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Mon, 27 Jan 2025 14:35:59 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Cornelia Huck <cohuck@redhat.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "sebott@redhat.com"
	<sebott@redhat.com>, yuzenghui <yuzenghui@huawei.com>, "Wangzhou (B)"
	<wangzhou1@hisilicon.com>, jiangkunkun <jiangkunkun@huawei.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>, Anthony Jebson
	<anthony.jebson@huawei.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH v5 3/4] KVM: arm64: Report all the KVM/arm64-specific
 hypercalls
Thread-Topic: [PATCH v5 3/4] KVM: arm64: Report all the KVM/arm64-specific
 hypercalls
Thread-Index: AQHbbnQf1mRnk6lqN0urqeTQZlYYF7MqhYyAgAAeQ9A=
Date: Mon, 27 Jan 2025 13:35:58 +0000
Message-ID: <337c614b99cc48cbbc9168f20a7e40df@huawei.com>
References: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com>
	<20250124151732.6072-4-shameerali.kolothum.thodi@huawei.com>
 <8734h48lus.fsf@redhat.com>
In-Reply-To: <8734h48lus.fsf@redhat.com>
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
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Monday, January 27, 2025 12:47 PM
> To: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; kvmarm@lists.linux.dev;
> maz@kernel.org; oliver.upton@linux.dev
> Cc: catalin.marinas@arm.com; will@kernel.org; mark.rutland@arm.com;
> eric.auger@redhat.com; sebott@redhat.com; yuzenghui
> <yuzenghui@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>;
> jiangkunkun <jiangkunkun@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Anthony Jebson
> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
> Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH v5 3/4] KVM: arm64: Report all the KVM/arm64-specific
> hypercalls
>=20
> On Fri, Jan 24 2025, Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com> wrote:
>=20
> > Currently ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID returns
> the
> > bitmap corresponding to KVM_REG_ARM_VENDOR_HYP_BMAP and it
> only
> > returns _KVM_FEATURES_FUNC_ID and _KVM_PTP_FUNC_ID. Change that
> > to return all the KVM/arm64-specific hypercalls exposed by
> > KVM/arm64 to guest operating systems.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  arch/arm64/kvm/hypercalls.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 27ce4cb44904..6132cb542200 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -359,7 +359,11 @@ int kvm_smccc_call_handler(struct kvm_vcpu
> *vcpu)
> >  		val[3] =3D ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
> >  		break;
> >  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > -		val[0] =3D smccc_feat->vendor_hyp_bmap;
> > +		val[0] =3D GENMASK(ARM_SMCCC_KVM_FUNC_MMIO_GUARD,
> > +				 ARM_SMCCC_KVM_FUNC_FEATURES);
>=20
> Don't you need to exclude the reserved ids 5 and 6?

Oops...I overlooked it. Will correct.

Thanks,
Shameer
