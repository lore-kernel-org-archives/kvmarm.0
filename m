Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136E831E106
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 16:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790959171; cv=none; b=ARqAAJHCGqo8pIlKr1vJ7YJUTcJx1FmDNIBjq+g/MmA41DkxYcmqVtctezpWR+np/HeYSeZrMHOgLaBnhuwvOGIw7XAnn5XBN0fqnB7mEcbVRXFUH3j7SojBiYXih13zbnmDk7vq0KWPRWB14ngWW5JGidLaq8M/smcSVpfGDD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790959171; c=relaxed/simple;
	bh=CtdOKPzEHl0Qa+wT3t3zkXvKUi0qlkEFrTlHOIDVMQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJcSekKuBTY9kIc2jZFqyDaqZJIsh4M6gNZo1jn92/F5pu4qESm6mQJJ7RKZ1vVgKEovjElf/5FWLgFukzFtZ/pU1047I36mCjQ3JGagRPt0XBcFwdv8QTXSAqnNRv0lA0e0KLOPX6M9x8WWqJ93rXotyGnXxeds9AawD6QZMBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uc8dO1B3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uc8dO1B3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A417F1F000FF;
	Fri,  2 Oct 2026 16:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790959169;
	bh=/h7ekfcUzkwWndjKu/7hfrYgYkkTMuuqiAzvSgcH6Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uc8dO1B3O9glJr+RUsdeAOa/YLv34PmWvMrv0DGAN2HBiDKhpI5AuGOLSaA0iC6A5
	 WvPWTaYu991MHubFOle+7f6JTk5LZEE8yolD0XE5229cNXr7Ovra7bX/bvd3Y1x62O
	 mph/WqMZs6RvTOictszgsCnCylgDHGVi/MfvpEFfWIDqOphWz4HHMjwa7m9vZ3APP2
	 gXMk63k16GtrsZzknJQKuhWEIPIaLQ8euqDhNmHQzGpuFkKFJOu1PmVfYvHksIZ1LU
	 2bsZHOLMI7y3lbrR9K4YFvzJ9E992vvEBUcXjNCu4tbI7M2IRaHYY3yfGzaCuJuesw
	 zxLZeqP4CS/QQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xCgIB-0000000GJD9-1nt7;
	Fri, 02 Oct 2026 16:39:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	fuad.tabba@linux.dev
Subject: Re: [PATCH v6 00/18] KVM: arm64: Introduce pKVM hypervisor heap allocator
Date: Fri,  2 Oct 2026 17:39:24 +0100
Message-ID: <179095910311.551935.11321675736723021176.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
References: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 01 Oct 2026 15:28:31 +0100, Vincent Donnefort wrote:
> pKVM historically lacked a dynamic memory allocator: all hypervisor-side
> VM and VCPU structures had to be sized on the host, allocated as
> contiguous pages and donated to the hypervisor.
> 
> This design tightly coupled the hypervisor's memory footprint to
> host-side constraints, complicated memory reclaim, and severely
> restricted VM scalability.
> 
> [...]

Applied to next, thanks!

[01/18] KVM: arm64: Add pkvm_private_va_range_pa
        commit: 4b66a1941718ef1c945b32ab28e91330e4394de2
[02/18] KVM: arm64: Add pkvm_remove_mappings
        commit: 64a89873e0c60fd8a22ebacab6bc723415eeb4b2
[03/18] KVM: arm64: Add pkvm_map_private_va_range
        commit: 06b705e789ed1a118331bc77f477a9b46c52dcfe
[04/18] KVM: arm64: Add a heap allocator for the pKVM hyp
        commit: c8d7834c9c219a9a0e3969986e90c5c444b9d98d
[05/18] KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
        commit: 11a59e2959e63546dd75c347d552193c38aeb37e
[06/18] KVM: arm64: Add pkvm_hyp_req infrastructure
        commit: e868b8c35268a8cb786091c63f538c960b8807e5
[07/18] KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request
        commit: 7bf265fe68af9e1ef3af083d444a72bd3ce3d3e3
[08/18] KVM: arm64: Add reclaim interface for the pKVM heap alloc
        commit: 43759e3c9631ffcec55e4b7396864af4a5b98f30
[09/18] KVM: arm64: Add selftests for the pKVM heap allocator
        commit: bd93068340e9d770d6282ab425b686bef2042394
[10/18] KVM: arm64: Add a shrinker for pKVM
        commit: 909e70fd13567db8247c3850f27b65aaea2c9ad0
[11/18] KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
        commit: 0b27ba187dde3170a312904f18595f3ba266bcae
[12/18] KVM: arm64: Move hyp_vm refcount into the structure
        commit: 85406921dc81ea7ccfb78c92cf79b0a4bcd2439c
[13/18] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
        commit: 324397c85d1dde38e5d4805d8b79bfc549af4252
[14/18] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
        commit: e188a901e4bc585a170ee4235c6b55ebcf07b592
[15/18] KVM: arm64: Rename vCPU pkvm_memcache to stage2_mc
        commit: 197dac8a9060c17988414086293aa8ed4c82c185
[16/18] KVM: arm64: Reject hyp trace descriptors with fewer CPUs than hyp_nr_cpus
        commit: cf9cf059b8f30ffca78c16e6a51c905c95da47a8
[17/18] KVM: arm64: Reject hyp trace descriptors with fewer than 3 pages
        commit: 086f86286b5e060904bd372ad96edd04c366885a
[18/18] KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator
        commit: 35dc2dd00334555eb02428cff2302a1cfe60c15f

Std disclaimer: conflict-central even with the rebase, please check
the result.

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


