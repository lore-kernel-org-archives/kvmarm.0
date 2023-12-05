Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9398361FD4
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 14:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from kwepemm600006.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Sl2dD5PsszWjCh;
	Tue,  5 Dec 2023 22:16:00 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm600006.china.huawei.com (7.193.23.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 22:16:53 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Tue, 5 Dec 2023 14:16:51 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
CC: "ankita@nvidia.com" <ankita@nvidia.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, yuzenghui
	<yuzenghui@huawei.com>, "will@kernel.org" <will@kernel.org>,
	"ardb@kernel.org" <ardb@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "gshan@redhat.com" <gshan@redhat.com>,
	"aniketa@nvidia.com" <aniketa@nvidia.com>, "cjia@nvidia.com"
	<cjia@nvidia.com>, "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	"targupta@nvidia.com" <targupta@nvidia.com>, "vsethi@nvidia.com"
	<vsethi@nvidia.com>, "acurrid@nvidia.com" <acurrid@nvidia.com>,
	"apopple@nvidia.com" <apopple@nvidia.com>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "danw@nvidia.com" <danw@nvidia.com>,
	"mochs@nvidia.com" <mochs@nvidia.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linyufeng (A)"
	<linyufeng3@huawei.com>
Subject: RE: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Thread-Topic: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Thread-Index: AQHaJyt5vUQXGRK0CEWl1So2KZfV67CaaoMAgAAm7ICAACpz4A==
Date: Tue, 5 Dec 2023 14:16:51 +0000
Message-ID: <296657c5b09f46a1ac6e4d993fbc0875@huawei.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org> <ZW8MP2tDt4_9ROBz@arm.com>
In-Reply-To: <ZW8MP2tDt4_9ROBz@arm.com>
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
X-CFilter-Loop: Reflected



> -----Original Message-----
> From: Catalin Marinas <catalin.marinas@arm.com>
> Sent: Tuesday, December 5, 2023 11:41 AM
> To: Marc Zyngier <maz@kernel.org>
> Cc: ankita@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; jgg@nvidia.com;
> oliver.upton@linux.dev; suzuki.poulose@arm.com; yuzenghui
> <yuzenghui@huawei.com>; will@kernel.org; ardb@kernel.org; akpm@linux-
> foundation.org; gshan@redhat.com; aniketa@nvidia.com; cjia@nvidia.com;
> kwankhede@nvidia.com; targupta@nvidia.com; vsethi@nvidia.com;
> acurrid@nvidia.com; apopple@nvidia.com; jhubbard@nvidia.com;
> danw@nvidia.com; mochs@nvidia.com; kvmarm@lists.linux.dev;
> kvm@vger.kernel.org; lpieralisi@kernel.org; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_*
> and NORMAL_NC for IO memory
>=20
> + Lorenzo, he really needs to be on this thread.
>=20
> On Tue, Dec 05, 2023 at 09:21:28AM +0000, Marc Zyngier wrote:
> > On Tue, 05 Dec 2023 03:30:15 +0000,
> > <ankita@nvidia.com> wrote:
> > > From: Ankit Agrawal <ankita@nvidia.com>
> > >
> > > Currently, KVM for ARM64 maps at stage 2 memory that is considered
> device
> > > (i.e. it is not RAM) with DEVICE_nGnRE memory attributes; this settin=
g
> > > overrides (as per the ARM architecture [1]) any device MMIO mapping
> > > present at stage 1, resulting in a set-up whereby a guest operating
> > > system cannot determine device MMIO mapping memory attributes on
> its
> > > own but it is always overridden by the KVM stage 2 default.
> [...]
> > Despite the considerable increase in the commit message length, a
> > number of questions are left unanswered:
> >
> > - Shameer reported a regression on non-FWB systems, breaking device
> >   assignment:
> >
> >
> https://lore.kernel.org/all/af13ed63dc9a4f26a6c958ebfa77d78a@huawei.co
> m/
>=20
> This referred to the first patch in the old series which was trying to
> make the Stage 2 cacheable based on the vma attributes. That patch has
> been dropped for now. It would be good if Shameer confirms this was the
> problem.
>

Yes, that was related to the first patch. We will soon test this on both FW=
B and
non-FWB platforms and report back.

Thanks,
Shameer

