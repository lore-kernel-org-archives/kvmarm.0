Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4551B2F24;
	Tue, 26 Sep 2023 13:16:45 +0000 (UTC)
Received: from lhrpeml500002.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Rw0bh0SMmz6K7vG;
	Tue, 26 Sep 2023 21:15:28 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml500002.china.huawei.com (7.191.160.78) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 26 Sep 2023 14:16:41 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.031;
 Tue, 26 Sep 2023 14:16:41 +0100
From: Salil Mehta <salil.mehta@huawei.com>
To: James Morse <james.morse@arm.com>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-arch@vger.kernel.org"
	<linux-arch@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
CC: "x86@kernel.org" <x86@kernel.org>, Russell King <linux@armlinux.org.uk>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, "jianyong.wu@arm.com"
	<jianyong.wu@arm.com>, "justin.he@arm.com" <justin.he@arm.com>
Subject: RE: [RFC PATCH v2 00/35] ACPI/arm64: add support for virtual
 cpuhotplug
Thread-Topic: [RFC PATCH v2 00/35] ACPI/arm64: add support for virtual
 cpuhotplug
Thread-Index: AQHZ5mDIR7JMF2KEeEGQTVeJuAX/8LAtKYMg
Date: Tue, 26 Sep 2023 13:16:41 +0000
Message-ID: <622a39bda12a4b75a6da84f4566b4238@huawei.com>
References: <20230913163823.7880-1-james.morse@arm.com>
In-Reply-To: <20230913163823.7880-1-james.morse@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.126.174.16]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected

> From: James Morse <james.morse@arm.com>
> Sent: Wednesday, September 13, 2023 5:38 PM

[...]

>=20
> Hello!
>=20
> Changes since RFC-v1:
>  * riscv is new, ia64 is gone
>  * The KVM support is different, and upstream - no need to patch the host=
.
>=20
> ---
>=20
> This series adds what looks like cpuhotplug support to arm64 for use in
> virtual machines. It does this by moving the cpu_register() calls for
> architectures that support ACPI out of the arch code by using
> GENERIC_CPU_DEVICES, then into the ACPI processor driver.
>=20
> The kubernetes folk really want to be able to add CPUs to an existing VM,
> in exactly the same way they do on x86. The use-case is pre-booting guest=
s
> with one CPU, then adding the number that were actually needed when the
> workload is provisioned.
>=20

[...]

>=20
> I had a go at switching the remaining architectures over to
> GENERIC_CPU_DEVICES,
> so that the Kconfig symbol can be removed, but I got stuck with powerpc
> and s390.
>=20
> I've only build tested Loongarch and riscv. I've removed the ia64 specifi=
c
> patches, but left the changes in other patches to make git-grep review of
> renames easier.
>=20
> If folk want to play along at home, you'll need a copy of Qemu that
> supports this.
> https://github.com/salil-mehta/qemu.git salil/virt-cpuhp-armv8/rfc-v2-rc6


Please use the latest pushed RFC V2 instead:
https://lore.kernel.org/qemu-devel/20230926100436.28284-1-salil.mehta@huawe=
i.com/T/#m523b37819c4811c7827333982004e07a1ef03879

Repository:
https://github.com/salil-mehta/qemu.git  virt-cpuhp-armv8/rfc-v2


Thanks
Salil.


[...]

> Why is this still an RFC? I'm still looking for confirmation from the
> kubernetes/kata folk that this works for them. Because of this I've culle=
d
> the CC list...
>=20
>=20
> This series is based on v6.6-rc1, and can be retrieved from:
> https://git.kernel.org/pub/scm/linux/kernel/git/morse/linux.git/virtual_c=
pu_hotplug/rfc/v2
