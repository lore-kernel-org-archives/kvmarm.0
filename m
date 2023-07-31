Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878D918B09
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 14:27:40 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.55])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RF0r933TnzLp00;
	Mon, 31 Jul 2023 22:24:57 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 22:27:36 +0800
Subject: Re: [PATCH v2 09/26] arm64: Add feature detection for fine grained
 traps
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Eric Auger <eric.auger@redhat.com>, Mark Brown
	<broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon
	<will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, Andre
 Przywara <andre.przywara@arm.com>, Chase Conklin <chase.conklin@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Darren Hart
	<darren@os.amperecomputing.com>, Miguel Luis <miguel.luis@oracle.com>, James
 Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-10-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <31dfcc8e-3917-0d1f-983d-169387f1f10f@huawei.com>
Date: Mon, 31 Jul 2023 22:27:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230728082952.959212-10-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

On 2023/7/28 16:29, Marc Zyngier wrote:
> From: Mark Brown <broonie@kernel.org>
> 
> In order to allow us to have shared code for managing fine grained traps
> for KVM guests add it as a detected feature rather than relying on it
> being a dependency of other features.
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> [maz: converted to ARM64_CPUID_FIELDS()]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20230301-kvm-arm64-fgt-v4-1-1bf8d235ac1f@kernel.org
> ---
>  arch/arm64/kernel/cpufeature.c | 7 +++++++
>  arch/arm64/tools/cpucaps       | 1 +
>  2 files changed, 8 insertions(+)

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
