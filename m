Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7778934CD9
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 13:44:43 +0000 (UTC)
Received: from lhrpeml500001.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QLHWc6fdWz686w8;
	Tue, 16 May 2023 21:43:40 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500001.china.huawei.com (7.191.163.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 14:44:40 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Tue, 16 May 2023 14:44:40 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Cornelia Huck <cohuck@redhat.com>
CC: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>, KVMARM
	<kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, "Alexandru
 Elisei" <alexandru.elisei@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, Reiji Watanabe
	<reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Subject: RE: [PATCH v8 0/6] Support writable CPU ID registers from userspace
Thread-Topic: [PATCH v8 0/6] Support writable CPU ID registers from userspace
Thread-Index: AQHZfeMKF5dz+QbHTkGBOtd/Pa2Gla9cxFkw///6lICAABESsP///gMAgAAVTwCAABcHYA==
Date: Tue, 16 May 2023 13:44:40 +0000
Message-ID: <bb1e038f0bf04d62beda15d0830920ee@huawei.com>
References: <20230503171618.2020461-1-jingzhangos@google.com>
	<2ef9208dabe44f5db445a1061a0d5918@huawei.com>	<868rdomtfo.wl-maz@kernel.org>
	<1a96a72e87684e2fb3f8c77e32516d04@huawei.com>	<87cz30h4nx.fsf@redhat.com>
 <867ct8mnel.wl-maz@kernel.org>
In-Reply-To: <867ct8mnel.wl-maz@kernel.org>
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
> Sent: 16 May 2023 14:12
> To: Cornelia Huck <cohuck@redhat.com>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> Jing Zhang <jingzhangos@google.com>; KVM <kvm@vger.kernel.org>;
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
> On Tue, 16 May 2023 12:55:14 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
> >
> > Do you have more concrete ideas for QEMU CPU models already? Asking
> > because I wanted to talk about this at KVM Forum, so collecting what
> > others would like to do seems like a good idea :)
>=20
> I'm not being asked, but I'll share my thoughts anyway! ;-)
>=20
> I don't think CPU models are necessarily the most important thing.
> Specially when you look at the diversity of the ecosystem (and even
> the same CPU can be configured in different ways at integration
> time). Case in point, Neoverse N1 which can have its I/D caches made
> coherent or not. And the guest really wants to know which one it is
> (you can only lie in one direction).
>=20
> But being able to control the feature set exposed to the guest from
> userspace is a huge benefit in terms of migration.

Yes, this is what we also need and was thinking of adding a named CPU with
common min feature set exposed to Guest. There were some previous
attempts to add the basic support in Qemu here,

https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg00087.html

> Now, this is only half of the problem (and we're back to the CPU
> model): most of these CPUs have various degrees of brokenness. Most of
> the workarounds have to be implemented by the guest, and are keyed on
> the MIDR values. So somehow, you need to be able to expose *all* the
> possible MIDR values that a guest can observe in its lifetime.

Ok. This will be a problem and I am not sure this has an impact on our=20
platforms or not.

Thanks,
Shameer

> I have a vague prototype for that that I'd need to dust off and
> finish, because that's also needed for this very silly construct
> called big-little...
>=20
> Thanks,
>=20
> 	M.
>=20
> --
> Without deviation from the norm, progress is not possible.

