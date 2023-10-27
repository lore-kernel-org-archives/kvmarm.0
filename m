Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023AD125AC
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 08:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SGw186RG3zrTrv;
	Fri, 27 Oct 2023 15:54:36 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 27 Oct 2023 15:57:31 +0800
Subject: Re: [PATCH v2] KVM: arm64: Add tracepoint for MMIO accesses where
 ISV==0
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, Marc Zyngier
	<maz@kernel.org>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>
References: <20231026205306.3045075-1-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <bea04979-01d3-fa30-bb81-ea67119a9612@huawei.com>
Date: Fri, 27 Oct 2023 15:57:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026205306.3045075-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

On 2023/10/27 4:53, Oliver Upton wrote:
> It is a pretty well known fact that KVM does not support MMIO emulation
> without valid instruction syndrome information (ESR_EL2.ISV == 0). The
> current kvm_pr_unimpl() is pretty useless, as it contains zero context
> to relate the event to a vCPU.
> 
> Replace it with a precise tracepoint that dumps the relevant context
> so the user can make sense of what the guest is doing.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Acked-by: Zenghui Yu <yuzenghui@huawei.com>
