Received: from out-55.mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E7953B7
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 12:37:57 +0000 (UTC)
Date: Thu, 15 Jun 2023 12:37:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686832675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FDeNKX3N1AgGPqiR/rCePuztYVFhTKf9vPqEop9TYmM=;
	b=b0Ps3XLAuqak82d/BomWL9V7tcPr2dg7JKi3t2FNudmZQ0oZq3HFyEjINu6FbnSozDAumE
	Ts7eQowx8hOTJu/fCF+k+6/Ouy2WzOO2h4l0pFdMeAgfnV8P2l8U0w+Im3w7l+iEG/oHx8
	BCcLOkPsr6m2lywBO0JtZo9IR6ZLYKM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	seanjc@google.com, mtosatti@redhat.com, maz@kernel.org,
	will@kernel.org, c.dall@virtualopensystems.com, peterx@redhat.com,
	david@redhat.com, aarcange@redhat.com, shahuang@redhat.com,
	hshuai@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v3] KVM: Avoid illegal stage2 mapping on invalid memory
 slot
Message-ID: <ZIsGHSNWtty4Yg0p@linux.dev>
References: <20230615054259.14911-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615054259.14911-1-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 15, 2023 at 03:42:59PM +1000, Gavin Shan wrote:
> We run into guest hang in edk2 firmware when KSM is kept as running on
> the host. The edk2 firmware is waiting for status 0x80 from QEMU's pflash
> device (TYPE_PFLASH_CFI01) during the operation of sector erasing or
> buffered write. The status is returned by reading the memory region of
> the pflash device and the read request should have been forwarded to QEMU
> and emulated by it. Unfortunately, the read request is covered by an
> illegal stage2 mapping when the guest hang issue occurs. The read request
> is completed with QEMU bypassed and wrong status is fetched. The edk2
> firmware runs into an infinite loop with the wrong status.

[...]

> Fix the issue by skipping the invalid memory slot at (C) to avoid the
> illegal stage2 mapping so that the read request for the pflash's status
> is forwarded to QEMU and emulated by it. In this way, the correct pflash's
> status can be returned from QEMU to break the infinite loop in the edk2
> firmware.
> 
> We tried a git-bisect and the first problematic commit is cd4c71835228 ("
> KVM: arm64: Convert to the gfn-based MMU notifier callbacks"). With this,
> clean_dcache_guest_page() is called after the memory slots are iterated
> in kvm_mmu_notifier_change_pte(). clean_dcache_guest_page() is called
> before the iteration on the memory slots before this commit. This change
> literally enlarges the racy window between kvm_mmu_notifier_change_pte()
> and memory slot removal so that we're able to reproduce the issue in a
> practical test case. However, the issue exists since commit d5d8184d35c9
> ("KVM: ARM: Memory virtualization setup").
> 
> Cc: stable@vger.kernel.org # v3.9+
> Fixes: d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
> Reported-by: Shuai Hu <hshuai@redhat.com>
> Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Thanks for fixing this Gavin. I'm more than happy to take this through
the kvmarm tree since we got burned, but it'd probably be best if Paolo
got it.

Paolo, if you wind up grabbing it:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
> v3: Skip the invalid memory slots in change_pte() MMU notifier only,
>     suggested by Sean. Improved changelog to describe how the fixes
>     tag is given.
> ---
>  virt/kvm/kvm_main.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 479802a892d4..65f94f592ff8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -686,6 +686,24 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
>  
>  	return __kvm_handle_hva_range(kvm, &range);
>  }
> +
> +static bool kvm_change_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> +{
> +	/*
> +	 * Skipping invalid memslots is correct if and only change_pte() is

nit: I think there's a typo here: s/if and only/if and only if/

This is tiny, and can be fixed up when the patch is applied.

-- 
Thanks,
Oliver
