Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB45C256D
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 23:32:36 +0000 (UTC)
Date: Thu, 3 Nov 2022 23:32:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1667518348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AkuOT4cCm8lWPlDD69OJU/NZeThANLz0iL3yJQqkzEM=;
	b=eakihLoa2JvOPxYFnYcGM0hY1jxnCOWluKCc1dZ0RkPrPRsMNBjJQzuhHHYe1QxPaAk064
	34n10Zy7oa+KLbGIc+AGP1eXp4xdGGlsFO9mmFVIDrkbj/c9/Rwh894OV92TW3AklfSEko
	xHEBvMLeSuNFrx8AghKRUwx3bqpS86M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
	catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
	pbonzini@redhat.com, peterx@redhat.com, seanjc@google.com,
	james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2RPhwIUsGLQ2cz/@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031003621.164306-5-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221103233223.KcnqqE6vRAiPee3k6TrI9GZFpi_OuL7YlYQisdwYalg@z>

On Mon, Oct 31, 2022 at 08:36:16AM +0800, Gavin Shan wrote:
> ARM64 needs to dirty memory outside of a VCPU context when VGIC/ITS is
> enabled. It's conflicting with that ring-based dirty page tracking always
> requires a running VCPU context.
> 
> Introduce a new flavor of dirty ring that requires the use of both VCPU
> dirty rings and a dirty bitmap. The expectation is that for non-VCPU
> sources of dirty memory (such as the VGIC/ITS on arm64), KVM writes to
> the dirty bitmap. Userspace should scan the dirty bitmap before migrating
> the VM to the target.
> 
> Use an additional capability to advertise this behavior. The newly added
> capability (KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP) can't be enabled before
> KVM_CAP_DIRTY_LOG_RING_ACQ_REL on ARM64. In this way, the newly added
> capability is treated as an extension of KVM_CAP_DIRTY_LOG_RING_ACQ_REL.

Whatever ordering requirements we settle on between these capabilities
needs to be documented as well.

[...]

> @@ -4588,6 +4594,13 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  			return -EINVAL;
>  
>  		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> +		    !kvm->dirty_ring_size)

I believe this ordering requirement is problematic, as it piles on top
of an existing problem w.r.t. KVM_CAP_DIRTY_LOG_RING v. memslot
creation.

Example:
 - Enable KVM_CAP_DIRTY_LOG_RING
 - Create some memslots w/ dirty logging enabled (note that the bitmap
   is _not_ allocated)
 - Enable KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
 - Save ITS tables and get a NULL dereference in
   mark_page_dirty_in_slot():

                if (vcpu && kvm->dirty_ring_size)
                        kvm_dirty_ring_push(&vcpu->dirty_ring,
                                            slot, rel_gfn);
                else
------->		set_bit_le(rel_gfn, memslot->dirty_bitmap);

Similarly, KVM may unnecessarily allocate bitmaps if dirty logging is
enabled on memslots before KVM_CAP_DIRTY_LOG_RING is enabled.

You could paper over this issue by disallowing DIRTY_RING_WITH_BITMAP if
DIRTY_LOG_RING has already been enabled, but the better approach would
be to explicitly check kvm_memslots_empty() such that the real
dependency is obvious. Peter, hadn't you mentioned something about
checking against memslots in an earlier revision?

--
Thanks,
Oliver
