Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CA039C
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 05:36:04 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686116162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=USrFGEg2q1AHZBNLT0/M2P/V3pLpAJEE6bgtAh84aZA=;
	b=GODTtmvTIMPGvkH9OWlj63dg2SpeNUImI8Sy6A8HFxMAHPvB1YfheYv6kGomvnxtwyaNj1
	+d7OQYqSYQr2h9h2K8WU47krTpHNXNaHzosCmN7rFLpkuV075GClNi2uwYHmb+wqF9Th9Z
	UMJC7cbsCfYUEYh5MsMMQ1tR70xXwgA=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	kernel-team@android.com,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 00/10] KVM: arm64: FF-A proxy for pKVM
Date: Wed,  7 Jun 2023 05:35:12 +0000
Message-ID: <168611608139.777371.2190834678777367651.b4-ty@linux.dev>
In-Reply-To: <20230523101828.7328-1-will@kernel.org>
References: <20230523101828.7328-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 23 May 2023 11:18:17 +0100, Will Deacon wrote:
> This is version three of the pKVM FF-A proxy series previously posted
> here:
> 
> v1: https://lore.kernel.org/r/20221116170335.2341003-1-qperret@google.com
> v2: https://lore.kernel.org/r/20230419122051.1341-1-will@kernel.org
> 
> Changes since v2 include:
> 
> [...]

Applied to kvmarm/next, thanks!

[01/10] KVM: arm64: Block unsafe FF-A calls from the host
        https://git.kernel.org/kvmarm/kvmarm/c/048be5fea43d
[02/10] KVM: arm64: Probe FF-A version and host/hyp partition ID during init
        https://git.kernel.org/kvmarm/kvmarm/c/12bdce4f4119
[03/10] KVM: arm64: Allocate pages for hypervisor FF-A mailboxes
        https://git.kernel.org/kvmarm/kvmarm/c/bc3888a0f4e9
[04/10] KVM: arm64: Handle FFA_RXTX_MAP and FFA_RXTX_UNMAP calls from the host
        https://git.kernel.org/kvmarm/kvmarm/c/9d0c6a9af9e3
[05/10] KVM: arm64: Add FF-A helpers to share/unshare memory with secure world
        https://git.kernel.org/kvmarm/kvmarm/c/f9112eade788
[06/10] KVM: arm64: Handle FFA_MEM_SHARE calls from the host
        https://git.kernel.org/kvmarm/kvmarm/c/436090001776
[07/10] KVM: arm64: Handle FFA_MEM_RECLAIM calls from the host
        https://git.kernel.org/kvmarm/kvmarm/c/0e3bcb49c135
[08/10] KVM: arm64: Handle FFA_MEM_LEND calls from the host
        https://git.kernel.org/kvmarm/kvmarm/c/634d90cf0ac6
[09/10] KVM: arm64: Handle FFA_FEATURES call from the host
        https://git.kernel.org/kvmarm/kvmarm/c/20936cd11479
[10/10] KVM: arm64: pkvm: Add support for fragmented FF-A descriptors
        https://git.kernel.org/kvmarm/kvmarm/c/0a9f15fd5674

--
Best,
Oliver
