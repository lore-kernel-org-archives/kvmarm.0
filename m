Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504273D76
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 15:14:45 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4R06tS1p14zLnd8;
	Mon, 10 Jul 2023 23:12:16 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 23:14:33 +0800
Subject: Re: [PATCH 1/4] KVM: arm64: Delete pointless switch statement in
 kvm_reset_vcpu()
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Jing Zhang
	<jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>
References: <20230623194258.2648987-1-oliver.upton@linux.dev>
 <20230623194258.2648987-2-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <a92fb881-8d7b-5ef4-8ec2-d959ed0ca61e@huawei.com>
Date: Mon, 10 Jul 2023 23:14:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230623194258.2648987-2-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

On 2023/6/24 3:42, Oliver Upton wrote:
> The vCPU target hasn't mattered for quite a long time now. Delete the
> useless switch statement in kvm_reset_vcpu(), which hilariously only had
> a default case in it.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
