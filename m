Received: from out-237.mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F69621
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 01:22:44 +0000 (UTC)
Date: Thu, 8 Dec 2022 00:27:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670459226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R8bdcc50wn8UsmiJI5n21HPc9V1IZkZNXUkx+5w7LeM=;
	b=LtxGLfgdz34RIqWijaQ+k2KPddTbVRBOnyMr/S2dcqR+op21TvVEcK8B4TysysD2vTkcPF
	FT17LaFAkwidPdPfNVkviHSMB5dnJRhtZG7UYRSq7lRDazE4GcDoNK0q+TP+8msYlFAq2L
	TRWNQfMlVL23nt6S/7a2W5rSHEhTt9c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: arm64: selftests: Align VA space allocator with
 TTBR0
Message-ID: <Y5EvVtAoDSHvIKie@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-4-oliver.upton@linux.dev>
 <Y5EtP5z6rxSK1VUe@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5EtP5z6rxSK1VUe@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221208002702.sZQv0GcUlMmBgD20qm5NtAahAYmMCZcJ__4KhBsPzu0@z>

On Thu, Dec 08, 2022 at 12:18:07AM +0000, Sean Christopherson wrote:

[...]

> Together, what about?  The #ifdef is a bit gross, especially around "hi_start",
> but it's less duplicate code.  And IMO, having things bundled in the same place
> makes it a lot easier for newbies (to arm64 or kernel coding in general) to
> understand what's going on and why arm64 is different.

I'd rather we not go this route. We really shouldn't make any attempt to
de-dupe something that is inherently architecture specific.

For example:

> +	/*
> +	 * All architectures supports splitting the virtual address space into
> +	 * a high and a low half.  Populate both halves, except for arm64 which
> +	 * currently uses only TTBR0_EL1 (arbitrary selftests "logic"), i.e.
> +	 * only has a valid low half.
> +	 */
> +	sparsebit_num_t nr_va_bits = (1ULL << (vm->va_bits - 1)) >> vm->page_shift;

This is still wrong for arm64. When we say the VA space is 48 bits, we
really do mean that TTBR0 is able to address a full 48 bits. So this
truncates the MSB for the addressing mode.

With the code living in the arm64 side of the shop, I can also tailor
the comment to directly match the architecture to provide breadcrumbs
tying it back to the Arm ARM.

--
Thanks,
Oliver
