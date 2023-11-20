Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CCF1CAA1
	for <kvmarm@lists.linux.dev>; Mon, 20 Nov 2023 14:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4SYqZb6Lx1z1P7T0;
	Mon, 20 Nov 2023 22:26:47 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 20 Nov 2023 22:30:13 +0800
Subject: Re: [PATCH v3] KVM: arm64: GICv4: Do not perform a map to a mapped
 vLPI
To: Kunkun Jiang <jiangkunkun@huawei.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, <eric.auger@redhat.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>
References: <20231120131210.2039-1-jiangkunkun@huawei.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <8e92fc63-1399-eaa0-ba05-63f292efc8d3@huawei.com>
Date: Mon, 20 Nov 2023 22:30:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231120131210.2039-1-jiangkunkun@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

On 2023/11/20 21:12, Kunkun Jiang wrote:
> Before performing a map, let's check whether the vLPI has been
> mapped.
> 
> Fixes: 196b136498b3 ("KVM: arm/arm64: GICv4: Wire mapping/unmapping of VLPIs in VFIO irq bypass")
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> Acked-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
