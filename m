Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52752CA4A
	for <kvmarm@lists.linux.dev>; Thu, 16 Nov 2023 14:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from lhrpeml500003.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4SWMC54dvMz6GDCc;
	Thu, 16 Nov 2023 22:01:21 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 16 Nov 2023 14:06:03 +0000
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.031;
 Thu, 16 Nov 2023 14:06:03 +0000
From: Salil Mehta <salil.mehta@huawei.com>
To: Cornelia Huck <cohuck@redhat.com>, Jianyong Wu <jianyong.wu@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, "james.morse@arm.com"
	<james.morse@arm.com>, "will@kernel.org" <will@kernel.org>
CC: "rmk@armlinux.org.uk" <rmk@armlinux.org.uk>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "justin.he@arm.com" <justin.he@arm.com>,
	"jianyong.wu@arm.com" <jianyong.wu@arm.com>
Subject: RE: [PATCH] arm64/kvm: Introduce feature extension for SMCCC filter
Thread-Topic: [PATCH] arm64/kvm: Introduce feature extension for SMCCC filter
Thread-Index: AQHaGIJSPxqmEiVqkkOrXIqhoEeoZ7B86xkAgAAOImA=
Date: Thu, 16 Nov 2023 14:06:03 +0000
Message-ID: <2ea495b04a7d484aa570059298e20862@huawei.com>
References: <20231116114152.912344-1-jianyong.wu@arm.com>
 <877cmhq1zp.fsf@redhat.com>
In-Reply-To: <877cmhq1zp.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.48.150.188]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected

> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Thursday, November 16, 2023 1:09 PM
> To: Jianyong Wu <jianyong.wu@arm.com>; maz@kernel.org; james.morse@arm.co=
m;
> will@kernel.org
>=20
> On Thu, Nov 16 2023, Jianyong Wu <jianyong.wu@arm.com> wrote:
>=20
> > 821d935c87b introduces support for userspace SMCCC filtering, but lack
> > of a way to tell userspace if we have this feature. Add a corresponding
> > feature extension can resolve this issue.
> >
> > For example, the incoming feature Vcpu Hotplug needs the SMCCC filter.
> > As there is no way to check this feature, VMM will run into error when
> > it calls this feature on an old kernel. It's bad for backward compatibl=
e.
>=20
> Can't you simply query via KVM_HAS_DEVICE_ATTR whether the SMCCC
> filtering controls exist?


Agreed. In fact, this is what I had earlier intended to do but deferred thi=
s
change. As of now, RFC V2 of vCPU Hotplug series does not have this check y=
et
while installing the SMCCC filters in KVM Host.

Thanks

> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 3 ++-
> >  arch/arm64/kvm/arm.c           | 1 +
> >  include/uapi/linux/kvm.h       | 1 +
> >  3 files changed, 4 insertions(+), 1 deletion(-)
> >

