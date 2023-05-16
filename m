Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D36171BF
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 11:11:35 +0000 (UTC)
Received: from lhrpeml100005.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QLD603RYRz67b1p;
	Tue, 16 May 2023 19:09:44 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100005.china.huawei.com (7.191.160.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 12:11:31 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Tue, 16 May 2023 12:11:31 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Marc Zyngier <maz@kernel.org>
CC: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>, KVMARM
	<kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, "Alexandru
 Elisei" <alexandru.elisei@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, Reiji Watanabe
	<reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Subject: RE: [PATCH v8 0/6] Support writable CPU ID registers from userspace
Thread-Topic: [PATCH v8 0/6] Support writable CPU ID registers from userspace
Thread-Index: AQHZfeMKF5dz+QbHTkGBOtd/Pa2Gla9cxFkw///6lICAABESsA==
Date: Tue, 16 May 2023 11:11:31 +0000
Message-ID: <1a96a72e87684e2fb3f8c77e32516d04@huawei.com>
References: <20230503171618.2020461-1-jingzhangos@google.com>
	<2ef9208dabe44f5db445a1061a0d5918@huawei.com> <868rdomtfo.wl-maz@kernel.org>
In-Reply-To: <868rdomtfo.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected



> -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: 16 May 2023 12:01
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Jing Zhang <jingzhangos@google.com>; KVM <kvm@vger.kernel.org>;
> KVMARM <kvmarm@lists.linux.dev>; ARMLinux
> <linux-arm-kernel@lists.infradead.org>; Oliver Upton <oupton@google.com>;
> Will Deacon <will@kernel.org>; Paolo Bonzini <pbonzini@redhat.com>;
> James Morse <james.morse@arm.com>; Alexandru Elisei
> <alexandru.elisei@arm.com>; Suzuki K Poulose <suzuki.poulose@arm.com>;
> Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.com>;
> Raghavendra Rao Ananta <rananta@google.com>
> Subject: Re: [PATCH v8 0/6] Support writable CPU ID registers from
> userspace
>=20
> On Tue, 16 May 2023 11:37:20 +0100,
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> wrote:
> >
> > > -----Original Message-----
> > > From: Jing Zhang [mailto:jingzhangos@google.com]
> > > Sent: 03 May 2023 18:16
> > > To: KVM <kvm@vger.kernel.org>; KVMARM <kvmarm@lists.linux.dev>;
> > > ARMLinux <linux-arm-kernel@lists.infradead.org>; Marc Zyngier
> > > <maz@kernel.org>; Oliver Upton <oupton@google.com>
> > > Cc: Will Deacon <will@kernel.org>; Paolo Bonzini
> <pbonzini@redhat.com>;
> > > James Morse <james.morse@arm.com>; Alexandru Elisei
> > > <alexandru.elisei@arm.com>; Suzuki K Poulose
> <suzuki.poulose@arm.com>;
> > > Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.com>;
> > > Raghavendra Rao Ananta <rananta@google.com>; Jing Zhang
> > > <jingzhangos@google.com>
> > > Subject: [PATCH v8 0/6] Support writable CPU ID registers from
> userspace
> > >
> > > This patchset refactors/adds code to support writable per guest CPU I=
D
> > > feature
> > > registers. Part of the code/ideas are from
> > >
> https://lore.kernel.org/all/20220419065544.3616948-1-reijiw@google.com
> >
> > Hi Jing/Reiji,
> >
> > Just to check the status on the above mentioned series "KVM: arm64: Mak=
e
> CPU
> > ID registers writable by userspace". Is there any plan to respin that o=
ne
> soon?
> > (Sorry, not sure there is any other series in progress for that support
> currently)
>=20
> I think this still is the latest, which I'm about to review again. I'd
> appreciate if you could have a look to!

Thanks Marc for confirming. Will go through. We do have some requirement to
add support for Qemu CPU models/migration between different hosts.

Thanks,
Shameer
=20
>=20
> Thanks,
>=20
> 	M.
>=20
> --
> Without deviation from the norm, progress is not possible.
