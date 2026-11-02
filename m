Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793631267;
	b=Ro4Cj/fN5MryF1gjI1S/QD2ln33+kfpxuXsR9khd4Y1aj+Gs+pieXxFUat0JeT9oSBnt
	 XnTvh9okUmBXItgJRyVuok71h9DTVBobIM+q5Ky5PbBwnEoZiuIlgEyx6eU1eYky1/StE
	 EjT4LjYDP4BvH0LV01LI5Ee0ejISP6k7SpRsAVjxn/buBani1uCy34P29U7agME6aWhNC
	 YzJrWKhoexqcmDvyCJzGmmnV8Sqc/zwsKvAS2ONuSJ8NsJVo7a3Qs1YMc6jDeLo4kV1qc
	 OJaO5DSdyckblgLC+VQn/DQsbfEG2sJ1y9r/xnGr4KzF+evfXOJ14KDBXr/qYB1h6DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793631267;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=3nu4A7upnl5Om0m7LZNGnD5TdTBPU65hBgFN+c/tzUc=;
	b=enNsAOgkOSZTPW5TM+zTLjqXPIOibB15IpqwKzEOz+LR63R+AaK4QvG0bZYcFkELB2rv
	 w6pr/j1G6pwE+/k2zJdNHv9XLMq9llQ+jHLD/cpiTMlRb1T0dsXm7TLhjIxwA/jWc9A+V
	 qz0dDiSm/d2bcuNZkEVVEYmN2giZwlbb4aMpuQwm1ukq7VBxs7a0w1lGb+yn4zxBfk4qL
	 9+mCL/QWuh8YqqmOjt2ImbqNXVFwuCYvF64NR1kFSQLPSgrCMq77vp/XyF7E2DOyssAmb
	 4fdyc3Xc8dNkO7wZNmB3JwjfI66eIGITlEe0rvOmq3EAe/F4a2GklnxEi2aiQhNp/0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NtQSE6Hg;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2EF607B450
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 14:54:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B2EF607B450
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NtQSE6Hg
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E35B1576;
	Mon,  2 Nov 2026 06:54:22 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E92D63F871;
	Mon,  2 Nov 2026 06:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793631265; bh=pe+eF55ZtCt9EK50Q3JeMHIuu3r98fGvy4S7dN+6afo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtQSE6Hg4NZPFXQ1EiNFOU1PmKa4H+Hf6xPJvfcB7KdwuZLbI457GZl+8mrCNBtNo
	 2PyrOqZhuMSPZNmfOZxZdtkgpZkjgebncw8Do9WE4zg2AeHLkFeYCskOC/ovLTR/p3
	 5sUzDS++27WFhdVSSUC8oDy0ouhPtxEMyn5zal3U=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 11/15] KVM: arm64: Reserve dirty ring space for the HDBSS buffer
Date: Mon,  2 Nov 2026 14:54:19 +0000
Message-ID: <auikG0clmr19sAjh@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260929103655.85107-12-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-12-zhengtian10@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 29, 2026 at 06:36:51PM +0800, Tian Zheng wrote:
> The dirty ring reserves room for CPU-side dirty buffers via
> kvm_cpu_dirty_log_size(). Report the HDBSS buffer entry count
> through it, so a full buffer flush always fits in the ring.
> 
> Pin the HDBSS buffer size to PAGE_SIZE when dirty-ring is enabled,
> via kvm_arch_dirty_ring_size_updated(): a larger buffer only
> shrinks the soft_limit and forces more frequent userspace drains.
> 
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/kvm/arm.c | 8 ++++++++
>  arch/arm64/kvm/mmu.c | 8 ++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9d7bdece149a..5a7046acb62e 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -215,6 +215,14 @@ static int kvm_arm_default_max_vcpus(void)
>  	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>  }
> 
> +void kvm_arch_dirty_ring_size_updated(struct kvm *kvm)
> +{
> +	if (!system_supports_hdbss())
> +		return;
> +
> +	kvm->arch.hdbss_buffer_size = KVM_ARM_HDBSS_DEFAULT_SIZE;
> +}
> +

On the same subject as a previous patch:
I don't think this is the best approach, on top of adding a new weak 
function to take care.

Maybe during the dirty-ring allocation, on vcpu creation, we could take 
into account the requested dirty-ring size, and just allocate the HDBSS 
buffer taking that into account. That would make it simpler, don't you 
agree?

Thanks!
Leo
