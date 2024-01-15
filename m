Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555AA2C69D
	for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 12:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4TD9fr17kxz1V4Dq;
	Mon, 15 Jan 2024 19:59:32 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id DEB771400D4;
	Mon, 15 Jan 2024 20:01:08 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Jan 2024 20:01:07 +0800
Subject: Re: [PATCH 5/8] KVM: arm64: Fix typos
To: Bjorn Helgaas <helgaas@kernel.org>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>, Bjorn
 Helgaas <bhelgaas@google.com>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>
References: <20240103231605.1801364-1-helgaas@kernel.org>
 <20240103231605.1801364-6-helgaas@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <6dfccc7e-38bb-0aee-ff86-c4cfa047fb01@huawei.com>
Date: Mon, 15 Jan 2024 20:01:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240103231605.1801364-6-helgaas@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/1/4 7:16, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Fix typos, most reported by "codespell arch/arm64".  Only touches comments,
> no code changes.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks!
