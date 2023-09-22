Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681081EA9A
	for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 15:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE9AC433C8;
	Fri, 22 Sep 2023 15:40:19 +0000 (UTC)
Date: Fri, 22 Sep 2023 16:40:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	will@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, zhukeqian1@huawei.com,
	jonathan.cameron@huawei.com, linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 4/8] KVM: arm64: Set DBM for previously writeable
 pages
Message-ID: <ZQ21YYGqcAhOq/UO@arm.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-5-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230825093528.1637-5-shameerali.kolothum.thodi@huawei.com>

On Fri, Aug 25, 2023 at 10:35:24AM +0100, Shameer Kolothum wrote:
> We only set DBM if the page is writeable (S2AP[1] == 1). But once migration
> starts, CLEAR_LOG path will write protect the pages (S2AP[1] = 0) and there
> isn't an easy way to differentiate the writeable pages that gets write
> protected from read-only pages as we only have S2AP[1] bit to check.

Don't we have enough bits without an additional one?

writeable: DBM == 1 || S2AP[1] == 1
  clean: S2AP[1] == 0
  dirty: S2AP[1] == 1 (irrespective of DBM)

read-only: DBM == 0 && S2AP[1] == 0

For S1 we use a software dirty bit as well to track read-only dirty
mappings but I don't think it is necessary for S2 since KVM unmaps the
PTE when changing the VMM permission.

-- 
Catalin
