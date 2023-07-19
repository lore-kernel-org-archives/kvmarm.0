Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAFE15A5;
	Wed, 19 Jul 2023 02:35:28 +0000 (UTC)
Received: from lhrpeml500006.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4R5Kc000Dtz67QB0;
	Wed, 19 Jul 2023 10:32:47 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 19 Jul 2023 03:35:20 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.027;
 Wed, 19 Jul 2023 03:35:20 +0100
From: Salil Mehta <salil.mehta@huawei.com>
To: "steven.price@arm.com" <steven.price@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	"james.morse@arm.com" <james.morse@arm.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
CC: Catalin Marinas <catalin.marinas@arm.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Marc Zyngier <maz@kernel.org>, Will Deacon
	<will@kernel.org>, "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Salil
 Mehta" <salil.mehta@opnsrc.net>, "andrew.jones@linux.dev"
	<andrew.jones@linux.dev>, yuzenghui <yuzenghui@huawei.com>,
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world might
 require ARM spec change?
Thread-Topic: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world
 might require ARM spec change?
Thread-Index: Adm55YYLPryt1tEKR0alBn01xBiFBw==
Date: Wed, 19 Jul 2023 02:35:19 +0000
Message-ID: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.48.147.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected

[Reposting it here from Linaro Open Discussion List for more eyes to look a=
t]

Hello,
I have recently started to dabble with ARM CCA stuff and check if our
recent changes to support vCPU Hotplug in ARM64 can work in the realm
world. I have realized that in the RMM specification[1] PSCI_CPU_ON
command(B5.3.3) does not handles the PSCI_DENIED return code(B5.4.2),
from the host. This might be required to support vCPU Hotplug feature
in the realm world in future. vCPU Hotplug is an important feature to
support kata-containers in realm world as it reduces the VM boot time
and facilitates dynamic adjustment of vCPUs (which I think should be
true even with Realm world as current implementation only makes use
of the PSCI_ON/OFF to realize the Hotplug look-like effect?)


As per our recent changes [2], [3] related to support vCPU Hotplug on
ARM64, we handle the guest exits due to SMC/HVC Hypercall in the
user-space i.e. VMM/Qemu. In realm world, REC Exits to host due to
PSCI_CPU_ON should undergo similar policy checks and I think,

1. Host should *deny* to online the target vCPUs which are NOT plugged
2. This means target REC should be denied by host. Can host call
   RMI_PSCI_COMPETE in such s case?=20
3. The *return* value (B5.3.3.1.3 Output values) should be PSCI_DENIED
4. Failure condition (B5.3.3.2) should be amended with
   runnable pre: target_rec.flags.runnable =3D=3D NOT_RUNNABLE (?)
            post: result =3D=3D PSCI_DENIED (?)
5. Change would also be required in the flow (D1.4 PSCI flows) depicting=20
   PSCI_CPU_ON flow (D1.4.1)
 =20

I do understand that ARM CCA support is in its infancy stage and
discussing about vCPU Hotplug in realm world seem to be a far-fetched
idea right now. But specification changes require lot of time and if
this change is really required then it should be further discussed
within ARM.=20

Many thanks!


Bes regards
Salil


References:

[1] https://developer.arm.com/documentation/den0137/latest/
[2] https://github.com/salil-mehta/qemu.git virt-cpuhp-armv8/rfc-v1-port110=
52023.dev-1
[3] https://git.gitlab.arm.com/linux-arm/linux-jm.git virtual_cpu_hotplug/r=
fc/v2

