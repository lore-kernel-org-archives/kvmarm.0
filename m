Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EA88BE0
	for <kvmarm@lists.linux.dev>; Thu,  6 Apr 2023 15:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85E1C4339B;
	Thu,  6 Apr 2023 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680796325;
	bh=K3nKlwtLW4ov+c1tQtsAtihdZk18gxkUszK5KsfK0nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuQpaykZID2uYzqXxVEB8vKhzVAIsIIYdZDCOKztxJqWWR8DoLqGXDp+heC4FTQ6I
	 w+eBIQk2ijM7AKvhNKzW4SjRwOP1c4zi8Bl4/i1WGgIIXmqo8QJcNQxj1sdZvRYgAa
	 KjfiN6dJbF3/2fef2spdBWCmre/0VhVdzPZCdmyUYCqBeRpb76lWe6HK57jtT/2fCn
	 fGHiK+kODIHCgdldh1JgHOsEFOP173Y0Bv6UMWA9MQVP+/6li2ie2OTdPGjbH1iME1
	 LUFyxd0QTd129ku8H4eEPuW3aSTaSVEv018rTBSLj/hoLo/AAqCusx3B4zl24cLJ4i
	 Wwlr8Aq7r1YMg==
From: Will Deacon <will@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH] arm: Do not add padding alignment for hugetlbfs backed memory
Date: Thu,  6 Apr 2023 16:51:51 +0100
Message-Id: <168079121966.329537.16952736151329909027.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230405110905.669217-1-suzuki.poulose@arm.com>
References: <20230405110905.669217-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 5 Apr 2023 12:09:05 +0100, Suzuki K Poulose wrote:
> The arm code tries to align the memory allocation size to 2M to potentially
> make use of the transparent hugepages. But this would be problematic if we
> try to allocate from the hugetlbfs, where the allocation size could be more than
> 2M. Given we support upto 1G, let use leave it to the user to align the
> requested memory when hugetlbfs is used.
> 
> Without the patch:
>  $ echo 1 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
>  $ mount -t hugetlbfs -o pagesize=1G none /root/hugemem/
>  $  lkvm run -m 1024 --hugetlbfs /root/hugemem/  ...
>    # lkvm run -k ...  -m 1024 -c 6
>    Fatal: Can't ftruncate for mem mapping size 1075838976
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] arm: Do not add padding alignment for hugetlbfs backed memory
      https://git.kernel.org/will/kvmtool/c/77b108c6a6f1

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
