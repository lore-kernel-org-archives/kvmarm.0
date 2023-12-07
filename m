Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6290F37D14
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 11:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SmBXc19dHzrVTj;
	Thu,  7 Dec 2023 19:16:00 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 19:19:48 +0800
Subject: Re: [PATCH 2/5] KVM: selftests: aarch64: Remove redundant newlines
To: Andrew Jones <ajones@ventanamicro.com>
CC: <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
	<kvm-riscv@lists.infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<maz@kernel.org>, <oliver.upton@linux.dev>, <anup@brainfault.org>,
	<borntraeger@linux.ibm.com>, <frankja@linux.ibm.com>,
	<imbrenda@linux.ibm.com>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
 <20231206170241.82801-9-ajones@ventanamicro.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3af8d9f4-96f6-568b-32f7-114c8346b199@huawei.com>
Date: Thu, 7 Dec 2023 19:19:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231206170241.82801-9-ajones@ventanamicro.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

On 2023/12/7 1:02, Andrew Jones wrote:
> TEST_* functions append their own newline. Remove newlines from
> TEST_* callsites to avoid extra newlines in output.
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

Acked-by: Zenghui Yu <yuzenghui@huawei.com>
