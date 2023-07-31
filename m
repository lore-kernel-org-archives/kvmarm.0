Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F3C18B07
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 14:27:35 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RF0sB5YdRzVjgP;
	Mon, 31 Jul 2023 22:25:50 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 22:27:31 +0800
Subject: Re: [PATCH v2 05/26] arm64: Add AT operation encodings
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
 <20230728082952.959212-6-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <22347d90-3326-994f-ceb8-212893fec870@huawei.com>
Date: Mon, 31 Jul 2023 22:27:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230728082952.959212-6-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

On 2023/7/28 16:29, Marc Zyngier wrote:
> Add the encodings for the AT operation that are usable from NS.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
