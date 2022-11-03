Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5E7C43219
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 23:32:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5FEB4038C;
	Thu,  3 Nov 2022 19:32:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ylga0uVQ5Iyj; Thu,  3 Nov 2022 19:32:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76A1D402AF;
	Thu,  3 Nov 2022 19:32:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A8E2402AF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 19:32:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vMGwwpCXXtg8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 19:32:30 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1DFFE4018D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 19:32:30 -0400 (EDT)
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2RPhwIUsGLQ2cz/@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221031003621.164306-5-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
Cc: shuah@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org,
 maz@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
