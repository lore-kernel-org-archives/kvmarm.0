Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EFE171C0
	for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 16:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FCAC433C8;
	Fri, 22 Sep 2023 16:00:42 +0000 (UTC)
Date: Fri, 22 Sep 2023 17:00:40 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	will@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, zhukeqian1@huawei.com,
	jonathan.cameron@huawei.com, linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 6/8] KVM: arm64: Only write protect selected PTE
Message-ID: <ZQ26KE2bzEFYUpMc@arm.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-7-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825093528.1637-7-shameerali.kolothum.thodi@huawei.com>

On Fri, Aug 25, 2023 at 10:35:26AM +0100, Shameer Kolothum wrote:
> From: Keqian Zhu <zhukeqian1@huawei.com>
> 
> This function write protects all PTEs between the ffs and fls of mask.
> There may be unset bits between this range. It works well under pure
> software dirty log, as software dirty log is not working during this
> process.
> 
> But it will unexpectly clear dirty status of PTE when hardware dirty
> log is enabled. So change it to only write protect selected PTE.

Ah, I did wonder about losing the dirty status. The equivalent to S1
would be for kvm_pgtable_stage2_wrprotect() to set a software dirty bit.

I'm only superficially familiar with how KVM does dirty tracking for
live migration. Does it need to first write-protect the pages and
disable DBM? Is DBM re-enabled later? Or does stage2_wp_range() with
your patches leave the DBM on? If the latter, the 'wp' aspect is a bit
confusing since DBM basically means writeable (and maybe clean). So
better to have something like stage2_clean_range().

-- 
Catalin
