Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCDE1108
	for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 04:51:48 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NwKMJ3YMlz16Mpv;
	Mon, 16 Jan 2023 12:50:04 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 16 Jan 2023 12:51:44 +0800
Subject: Re: [PATCH v10 4/7] KVM: arm64: Enable ring-based dirty memory
 tracking
To: Gavin Shan <gshan@redhat.com>
CC: <kvmarm@lists.linux.dev>, <kvmarm@lists.cs.columbia.edu>,
	<kvm@vger.kernel.org>, <maz@kernel.org>, <seanjc@google.com>,
	<shuah@kernel.org>, <catalin.marinas@arm.com>, <andrew.jones@linux.dev>,
	<ajones@ventanamicro.com>, <bgardon@google.com>, <dmatlack@google.com>,
	<will@kernel.org>, <suzuki.poulose@arm.com>, <alexandru.elisei@arm.com>,
	<pbonzini@redhat.com>, <peterx@redhat.com>, <oliver.upton@linux.dev>,
	<zhenyzha@redhat.com>, <shan.gavin@gmail.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-5-gshan@redhat.com>
 <e28ede67-1bc4-fb1e-9bea-60cc9bd85190@huawei.com>
 <e3414ca2-c4a6-07b5-df41-9999fdb2445a@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <c2f051de-910b-2a56-3d68-a08bf9964dd0@huawei.com>
Date: Mon, 16 Jan 2023 12:51:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <e3414ca2-c4a6-07b5-df41-9999fdb2445a@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

On 2023/1/15 19:56, Gavin Shan wrote:
> It's a new case we never noticed. Could you please share the QEMU 
> command lines
> to start the guest? I need to reproduce the issue on my side firstly.

I execute it under the kvm-unit-tests directory:

QEMU=/path/to/qemu-system-aarch64 ACCEL=kvm arch=arm64 ./run_tests.sh

and the QEMU command and the verbose messages are recorded in
logs/its-pending-migration.log. The key to reproduce is there should be
at least one pending LPI when we handle
KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES (which can be achieved by the
its-pending-migration test).
