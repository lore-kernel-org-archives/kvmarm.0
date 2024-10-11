Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7AD197A8B
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 15:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728661902; cv=none; b=AHA+i8c+JIaRPeLbFMQTOTaqIU3D16xSOdt/Yvu6/Nptw+eh/3F/cGAMF/rIdQI/LBfgo2YyUZ/6gHaBPhhkUtiCIYkhJmtvYPyOeMOfcyXyA9nclDKeqa0kVIowiFJMeidouesuai/jNtTLMTuBBQjRD03GOhOGK+FNuhqh/TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728661902; c=relaxed/simple;
	bh=dVSGMaabtxeiyWXxC+gnVwJ53o0lvZzazV4L92tnX0o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P++uGuLONNrSF7HeJnlDOZm0KKDSyPyg50K/ULAVbPQag5gabvCNM+alkbXYMLWjuFjeRGZv4yr5AKCTciFlfHl8EOgAatYaECkmkyN3wfqky6fxwKKYlVLDaIecTmI1CNiAbl2NJbV4foDJa7SCALcU2k2bnLGaKZcA/s7LdiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XQ9wz3CSwz6GFV5;
	Fri, 11 Oct 2024 23:47:15 +0800 (CST)
Received: from frapeml100005.china.huawei.com (unknown [7.182.85.132])
	by mail.maildlp.com (Postfix) with ESMTPS id DAB1F1400CB;
	Fri, 11 Oct 2024 23:51:37 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100005.china.huawei.com (7.182.85.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 17:51:37 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Fri, 11 Oct 2024 17:51:37 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"cohuck@redhat.com" <cohuck@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, yuzenghui <yuzenghui@huawei.com>, "Wangzhou (B)"
	<wangzhou1@hisilicon.com>, jiangkunkun <jiangkunkun@huawei.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>, Anthony Jebson
	<anthony.jebson@huawei.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
Thread-Topic: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
Thread-Index: AQHbG7LLpfYBbF3MrkilC6zl/kSmBLKBOjEAgAAlJID//+1RAIAAOgeAgAArJEA=
Date: Fri, 11 Oct 2024 15:51:37 +0000
Message-ID: <08261a41b9644f5ab49063824e4060c3@huawei.com>
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
 <86jzef53iz.wl-maz@kernel.org> <3f4469c49625413f9ab2c224d0d3fbea@huawei.com>
 <86ikty6f1b.wl-maz@kernel.org> <ZwlADbp-HjkijElX@linux.dev>
In-Reply-To: <ZwlADbp-HjkijElX@linux.dev>
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
> Sent: Friday, October 11, 2024 4:11 PM
> To: Marc Zyngier <maz@kernel.org>
> Cc: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; kvmarm@lists.linux.dev;
> catalin.marinas@arm.com; will@kernel.org; mark.rutland@arm.com;
> cohuck@redhat.com; eric.auger@redhat.com; yuzenghui
> <yuzenghui@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>;
> jiangkunkun <jiangkunkun@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Anthony Jebson
> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
> Linuxarm <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
> migration
>=20
> On Fri, Oct 11, 2024 at 12:43:28PM +0100, Marc Zyngier wrote:
> > On Fri, 11 Oct 2024 11:57:10 +0100, Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com> wrote:
> > > > >
> > > > > Please take a look and let me know your thoughts.
> > > >
> > > > Having eyeballed this very superficially, I think we can do somethi=
ng
> > > > simpler, and maybe more future-proof:
> > >
> > > Thanks Marc for taking a look and the quick feedback.
> >
> > No worries, that's the least I could do given that you put the effort
> > implementing my silly ideas! ;-)
> >
> > > > - I don't think KVM should be concerned about the description of th=
e
> > > >   target CPUs. The hypercall you defined is the right thing to do,
> > > >   but the VMM should completely handle it. That's an implementation
> > > >   detail, but it would make things much simpler.
> > >
> > > Ok. So does that mean the hypercall will use some sort of shared
> memory
> > > to retrieve the list of target CPUs from VMM?
> >
> > Two possibilities:
> >
> > - either shared memory, in which case the hypercall would require the
> >   guest to give an IPA and size for the VMM to write its stuff into
> >   the guest memory,
> >
> > - or more simply return the data as an MIDR/REVIDR pair in registers,
> >   the guest requesting an index, and getting an error when out of
> >   range, leaving it with the freedom to organise the storage.
> >
> > The second option is a bit slower, but way simpler, and it only
> > happens once per guest boot, so it would probably be my preferred
> > option unless this is proved to be impractical.
>=20
> Also worth noting there's existing UAPI [*] for allowing userspace to
> register range(s) of hypercalls that it services directly. It's a bit
> weird that we'd allow userspace to do stuff in KVM's own hypercall
> range, but I don't think it really matters at this point since this is
> all prototyping.
>=20
> [*]: https://docs.kernel.org/virt/kvm/devices/vm.html#attribute-kvm-arm-
> vm-smccc-filter-w-o

Thanks. Yes and there are attempts to add that handling in Qemu[*] in the c=
ontext
of vCPU hotplug support(PSCI related ones though).  Will take a look.

Thanks,
Shameer
[1] https://lore.kernel.org/qemu-devel/20241009033704.250287-1-salil.mehta@=
huawei.com/

