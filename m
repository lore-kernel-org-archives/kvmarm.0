Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6068BE8
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 09:14:16 +0000 (UTC)
Received: from kwepemm000006.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QMNwd0cZkz18LgT;
	Thu, 18 May 2023 16:50:41 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 kwepemm000006.china.huawei.com (7.193.23.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 16:55:01 +0800
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.023;
 Thu, 18 May 2023 09:54:59 +0100
From: Salil Mehta <salil.mehta@huawei.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: Marc Zyngier <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, "Suzuki K
 Poulose" <suzuki.poulose@arm.com>, yuzenghui <yuzenghui@huawei.com>, "Sean
 Christopherson" <seanjc@google.com>
Subject: RE: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Thread-Topic: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Thread-Index: AQHZZwvyoTfThYxWf0yKNVt4c9uQr68cQ2uAgABJ1QCAQm5ckIAAAwIAgAD6+2A=
Date: Thu, 18 May 2023 08:54:59 +0000
Message-ID: <d04f46d250df46579d640f7e052283fb@huawei.com>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
 <20230404154050.2270077-9-oliver.upton@linux.dev>
 <87o7o26aty.wl-maz@kernel.org> <86pm8iv8tj.wl-maz@kernel.org>
 <fd9aee7022ea47e29cbff3120764c2c6@huawei.com> <ZGUfFn0jai9n4eSF@linux.dev>
In-Reply-To: <ZGUfFn0jai9n4eSF@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.48.154.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected

Hi Oliver,

> From: Oliver Upton <oliver.upton@linux.dev>
> Sent: Wednesday, May 17, 2023 7:38 PM
> To: Salil Mehta <salil.mehta@huawei.com>
> Cc: Marc Zyngier <maz@kernel.org>; kvmarm@lists.linux.dev;
> kvm@vger.kernel.org; Paolo Bonzini <pbonzini@redhat.com>; James Morse
> <james.morse@arm.com>; Suzuki K Poulose <suzuki.poulose@arm.com>; yuzengh=
ui
> <yuzenghui@huawei.com>; Sean Christopherson <seanjc@google.com>
> Subject: Re: [PATCH v3 08/13] KVM: arm64: Add support for
> KVM_EXIT_HYPERCALL
>=20
> Hi Salil,
>=20
> On Wed, May 17, 2023 at 06:00:18PM +0000, Salil Mehta wrote:
>=20
> [...]
>=20
> > > > Should we expose the ESR, or at least ESR_EL2.IL as an additional
> > > > flag?
> >
> >
> > I think we would need "Immediate value" of the ESR_EL2 register in the
> > user-space/VMM to be able to construct the syndrome value. I cannot see
> > where it is being sent?
>=20
> The immediate value is not exposed to userspace, although by definition
> the immediate value must be zero. The SMCCC spec requires all compliant
> calls to use an immediate of zero (DEN0028E 2.9).

Sure. I do understand this.

> Is there a legitimate use case for hypercalls with a nonzero immediate?


To be frank I was not sure of this either and therefore I thought it would
be safe to keep the handling in user-space/Qemu generic as it is now by
constructing a syndrome value depending upon immediate value and other
accompanying parameters from the KVM.=20

Also, I am not sure what it could break or what platforms it could break.
I think we need some Qemu folks to pitch-in and comment on this.


> They would no longer be considered SMCCC calls at that point, so they
> wouldn't work with the new UAPI.

True. So should we do this change now?


Thanks
Salil


