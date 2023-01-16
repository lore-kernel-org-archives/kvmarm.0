Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019271108
	for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 05:12:56 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NwKPr2L8RzRr0x;
	Mon, 16 Jan 2023 12:52:16 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 16 Jan 2023 12:54:04 +0800
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
 <c974528c-17c2-b24e-d975-c0d82377b2b0@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <e25199d6-ba40-ae71-41e5-d266b2747aa3@huawei.com>
Date: Mon, 16 Jan 2023 12:54:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c974528c-17c2-b24e-d975-c0d82377b2b0@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

On 2023/1/16 12:09, Gavin Shan wrote:
> Please try the following series to see if the unexpected warning message 
> disappears
> or not.
> 
> https://lore.kernel.org/kvmarm/20230116040405.260935-1-gshan@redhat.com/T/#t

Ah, I will have a look. Thanks Gavin for the quick fixes!
