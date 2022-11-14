Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BCD79FD
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 18:48:18 +0000 (UTC)
Date: Mon, 14 Nov 2022 18:48:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668451689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ql8zFw/DxEYIf4IQ7KYe8Xa1QN1s9FqjeGphu6RWQE0=;
	b=fZ0/Ii6j2iJMk+5Ifc1knRSHKvjiHHn3ogpu2jcYbK+f0t4CQJZkX/9gpvgZZYcdEMPy7v
	RCtRu/x1mWpxQxYTS19afbHKVMlExyhZrat4Ov8c4n1sLfOguH0PbCXbOEPfoRoILSq5Qf
	6AO6nic/6sRSOEy/ku4/33HGFBSVpEw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
	qperret@google.com, catalin.marinas@arm.com, andrew.jones@linux.dev,
	seanjc@google.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	ricarkol@gmail.com
Subject: Re: [RFC PATCH 02/12] KVM: arm64: Allow visiting block PTEs in
 post-order
Message-ID: <Y3KNZCLVqnFeg7hi@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-3-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112081714.2169495-3-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221114184804.OR94-bc_6kn0F2NU_GJxlG6Sg4-98rfOdEJUpgM8Tws@z>

On Sat, Nov 12, 2022 at 08:17:04AM +0000, Ricardo Koller wrote:
> The page table walker does not visit block PTEs in post-order. But there
> are some cases where doing so would be beneficial, for example: breaking a
> 1G block PTE into a full tree in post-order avoids visiting the new tree.
> 
> Allow post order visits of block PTEs. This will be used in a subsequent
> commit for eagerly breaking huge pages.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/setup.c      |  2 +-
>  arch/arm64/kvm/hyp/pgtable.c         | 25 ++++++++++++-------------
>  3 files changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index e2edeed462e8..d2e4a5032146 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -255,7 +255,7 @@ struct kvm_pgtable {
>   *					entries.
>   * @KVM_PGTABLE_WALK_TABLE_PRE:		Visit table entries before their
>   *					children.
> - * @KVM_PGTABLE_WALK_TABLE_POST:	Visit table entries after their
> + * @KVM_PGTABLE_WALK_POST:		Visit leaf or table entries after their
>   *					children.

It is not immediately obvious from this change alone that promoting the
post-order traversal of every walker to cover leaf + table PTEs is safe.

Have you considered using a flag for just leaf post-order visits?

--
Thanks,
Oliver
