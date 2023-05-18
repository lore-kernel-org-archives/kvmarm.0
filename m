Received: from out-49.mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8CE182B8
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 17:46:03 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684431961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3KNIEHbT6ULtrRp710z/V7h41NICMsq9ZMt8Y3JG+/4=;
	b=vN8+uS5oQ0ItDKQTiAd8lOtzkr3RMAp/USuwUXWRf3dQW49PFPco10my3Wgh2jJfyomlsU
	t9VUSBtUq5LEsSTCJUK9mYFEP9bAZz3BSj71mIl3u0Zw2mKb9DHK3f0DQikHjs+fti3Udi
	AQH3LqHx+d8foxLgPPIkJjooOu+1dgM=
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Will Deacon <will@kernel.org>,
	Arnd Bergmann <arnd@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Arnd Bergmann <arnd@arndb.de>,
	kvmarm@lists.linux.dev,
	Cornelia Huck <cohuck@redhat.com>,
	linux-kernel@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: kvm: avoid overflow in integer division
Date: Thu, 18 May 2023 17:45:47 +0000
Message-ID: <168443190240.3857986.13123115778800174028.b4-ty@linux.dev>
In-Reply-To: <20230517202352.793673-1-arnd@kernel.org>
References: <20230517202352.793673-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 17 May 2023 22:23:39 +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The newly added kvm_mmu_split_nr_page_tables() function uses DIV_ROUND_DOWN_ULL()
> to divide 64-bit addresses, but this requires a 32-bit divisior, and PUD_SIZE
> may exceed that when 64KB pages are used:
> 
> arch/arm64/kvm/mmu.c: In function 'kvm_mmu_split_nr_page_tables':
> include/linux/math.h:42:64: error: conversion from 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from '68719476736' to '0' [-Werror=overflow]
>    42 |         DIV_ROUND_DOWN_ULL((unsigned long long)(ll) + (d) - 1, (d))
>       |                                                                ^~~
> include/linux/math.h:39:47: note: in definition of macro 'DIV_ROUND_DOWN_ULL'
>    39 | #define DIV_ROUND_DOWN_ULL(ll, d) div_u64(ll, d)
>       |                                               ^
> arch/arm64/kvm/mmu.c:95:22: note: in expansion of macro 'DIV_ROUND_UP_ULL'
>    95 |                 n += DIV_ROUND_UP_ULL(range, PUD_SIZE);
>       |                      ^~~~~~~~~~~~~~~~
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] arm64: kvm: avoid overflow in integer division
      https://git.kernel.org/kvmarm/kvmarm/c/14c3555f055d

--
Best,
Oliver
