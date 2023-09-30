Received: from out-202.mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08802182DE
	for <kvmarm@lists.linux.dev>; Sat, 30 Sep 2023 18:12:58 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696097577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NobuwGoK/IfZYCAUHu+l3Ra9aadEGrlb36GWP9YgCKg=;
	b=eeTMEX7jx4g/oM9E4pE2PlyJUQHQkWgZ7FBfm42L2iH5P9365yWo3i+3WP9lL3A0fekqJI
	T0jftYIUzrw9zZLaMHhuVxhqg1oRtACaDzeA/pWJ2Flp1N/AD0EULy7xiQJtV50RoZlOB4
	URdfRNjH0XKRse9u9QF/WwmI/3u2V6w=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	stable@vger.kernel.org,
	Vipin Sharma <vipinsh@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH] KVM: arm64: Always invalidate TLB for stage-2 permission faults
Date: Sat, 30 Sep 2023 18:12:42 +0000
Message-ID: <169609738440.1610883.10121904970438248127.b4-ty@linux.dev>
In-Reply-To: <20230922223229.1608155-1-oliver.upton@linux.dev>
References: <20230922223229.1608155-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 22 Sep 2023 22:32:29 +0000, Oliver Upton wrote:
> It is possible for multiple vCPUs to fault on the same IPA and attempt
> to resolve the fault. One of the page table walks will actually update
> the PTE and the rest will return -EAGAIN per our race detection scheme.
> KVM elides the TLB invalidation on the racing threads as the return
> value is nonzero.
> 
> Before commit a12ab1378a88 ("KVM: arm64: Use local TLBI on permission
> relaxation") KVM always used broadcast TLB invalidations when handling
> permission faults, which had the convenient property of making the
> stage-2 updates visible to all CPUs in the system. However now we do a
> local invalidation, and TLBI elision leads to vCPUs getting stuck in a
> permission fault loop. Remember that the architecture permits the TLB to
> cache translations that precipitate a permission fault.
> 
> [...]

Applied to kvmarm/next, with the fixes and stable tag dropped.

[1/1] KVM: arm64: Always invalidate TLB for stage-2 permission faults
      https://git.kernel.org/kvmarm/kvmarm/c/5a6e594fc607

--
Best,
Oliver
