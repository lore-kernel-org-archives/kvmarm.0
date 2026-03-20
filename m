Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F77283FE3
	for <kvmarm@lists.linux.dev>; Fri, 20 Mar 2026 10:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774002462; cv=none; b=aH8ja4Vr1FuNPGfwZ5XFfwYH8K6L75mVN206TBc7MOpbcf1rJD9u1oBEo8b+H4+RnaMttyYT/36Rqv5HtywjdXuyGhaCg/b9zMFJlFsFgENcJdAx7XCBYed8fVDINRx/sYv5VJxjvQ3VTJc/swUeEDAnnx0YrKHeWJVIGcc+cT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774002462; c=relaxed/simple;
	bh=muaYL7889rOqt5BCy4lvNcMWdqCnxsgxxgGpjJAV1+c=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJMn0iFW+Q313QuGv6cmNxolOqL5aGujANVydZkqMSn1bSB325CPl8Bru93kQR+3zyVrl5xWYhrJuC88HtHy/1t0LFaynp040PopehxD4YaN2YKd9zAHLnT2a/nYgWAqcFDMWUxJ5lUaPcf0rd8rqj+6M6M+Y69OoE0/cOfvEjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=l1qkdEPs; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="l1qkdEPs"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lmN3Nn5+/2+wlJPdb9UE+9BhxULvNRbP8Duc4E3NT8w=;
	b=l1qkdEPsha5VnNg/yiR/r0yZnfB6EtFX1UfDqnJBi7o45zR7Vs5LnRd5Lhz2KMksWEvlsxBgg
	JhyGcZRro6H0711oMRtBYj8NeK4WVZ+C/UwA3JvTC2ANEyy8ebk4wQnuvFI5ox14hSd0OB/7yNc
	Pg4/E2BDq5KN81n27MzIJBA=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fcdtW4886zMpPn;
	Fri, 20 Mar 2026 18:22:59 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fcdyd5MdkzJ46f6;
	Fri, 20 Mar 2026 18:26:33 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 98A594056F;
	Fri, 20 Mar 2026 18:27:34 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 20 Mar
 2026 10:27:33 +0000
Date: Fri, 20 Mar 2026 10:27:32 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, "Suzuki
 Poulose" <Suzuki.Poulose@arm.com>, nd <nd@arm.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v6 01/39] KVM: arm64: vgic-v3: Drop userspace write
 sanitization for ID_AA64PFR0.GIC on GICv5
Message-ID: <20260320102732.000062da@huawei.com>
In-Reply-To: <88437fc1251f775d51e42d4b5e8318cd7031fa81.camel@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
	<20260317113949.2548118-2-sascha.bischoff@arm.com>
	<20260319100256.00004de2@huawei.com>
	<88437fc1251f775d51e42d4b5e8318cd7031fa81.camel@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Thu, 19 Mar 2026 11:35:32 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> On Thu, 2026-03-19 at 10:02 +0000, Jonathan Cameron wrote:
> > On Tue, 17 Mar 2026 11:40:13 +0000
> > Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
> >  =20
> > > Drop a check that blocked userspace writes to ID_AA64PFR0_EL1 for
> > > writes that set the GIC field to 0 (NI) on GICv5 hosts. There is no
> > > such check for GICv3 native systems, and having inconsistent
> > > behaviour
> > > both complicates the logic and risks breaking existing userspace
> > > software that expects to be able to write the register.
> > >=20
> > > This means that userspace is now able to create a GICv3 guest on
> > > GICv5
> > > hosts, and disable the guest from seeing that it has a GICv3. This =20
> >=20
> > Just to clarify this is removing a check on a nonsensical setup?
> > I'm not against it if that simplifies things but I couldn't quite
> > parse the description. =20
>=20
> Effectively, we were being more strict when running with GICv3 on a
> GICv5 host than when running natively on a GICv3 host. This by itself
> wasn't too big an issue, but it can cause existing software break if it
> relies on being able to hide GICv3 this way (for whatever reason...),
> and somewhat breaks the portability story.
>=20
> Moreover, we test these sorts of things in the selftests. If a virtual
> GICv3 is created but then userspace comes along and zeros the feature
> bits (so, hides the feature), we expect the FGU infrastructure to take
> over to undef registers/instructions related to that feature. So, in
> this case, rather than letting userspace hide the virtual GICv3 from
> the guest, we instead stopped it from hiding it.
>=20
You have me at self tests of the infrastructure.  That bit I get :)

> Does that make some sort of sense?
>=20
> Thanks,
> Sascha
>=20
> >  =20
> > > matches the already existing behaviour for GICv3-native VMs.
> > >=20
> > > Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> > > ---
> > > =A0arch/arm64/kvm/sys_regs.c | 8 --------
> > > =A01 file changed, 8 deletions(-)
> > >=20
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 1b4cacb6e918a..4b9f4e5d946b1 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -2177,14 +2177,6 @@ static int set_id_aa64pfr0_el1(struct
> > > kvm_vcpu *vcpu,
> > > =A0	=A0=A0=A0 (vcpu_has_nv(vcpu) && !FIELD_GET(ID_AA64PFR0_EL1_EL2,
> > > user_val)))
> > > =A0		return -EINVAL;
> > > =A0
> > > -	/*
> > > -	 * If we are running on a GICv5 host and support
> > > FEAT_GCIE_LEGACY, then
> > > -	 * we support GICv3. Fail attempts to do anything but set
> > > that to IMP.
> > > -	 */
> > > -	if (vgic_is_v3_compat(vcpu->kvm) &&
> > > -	=A0=A0=A0 FIELD_GET(ID_AA64PFR0_EL1_GIC_MASK, user_val) !=3D
> > > ID_AA64PFR0_EL1_GIC_IMP)
> > > -		return -EINVAL;
> > > -
> > > =A0	return set_id_reg(vcpu, rd, user_val);
> > > =A0}
> > > =A0 =20
> >  =20
>=20

