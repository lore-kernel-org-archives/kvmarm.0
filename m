From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 1/3] KVM: promote KVM_MEMSLOT_INCOHERENT to uapi
Date: Mon, 20 Apr 2015 17:26:32 +0200
Message-ID: <20150420152632.GK6186@cbox>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
 <1426705833-2679-1-git-send-email-drjones@redhat.com>
 <1426705833-2679-2-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E8E54DFCC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2015 11:18:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UYFvFmA0jiri for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Apr 2015 11:18:11 -0400 (EDT)
Received: from mail-la0-f50.google.com (mail-la0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2EE704CC88
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2015 11:18:10 -0400 (EDT)
Received: by laat2 with SMTP id t2so129619750laa.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2015 08:26:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1426705833-2679-2-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, qemu-devel@nongnu.org, pbonzini@redhat.com, lersek@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 18, 2015 at 03:10:31PM -0400, Andrew Jones wrote:
> Also rename to KVM_MEM_UNCACHED.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  Documentation/virtual/kvm/api.txt | 16 ++++++++++------
>  arch/arm/include/uapi/asm/kvm.h   |  1 +
>  arch/arm/kvm/arm.c                |  1 +
>  arch/arm/kvm/mmu.c                |  4 ++--
>  arch/arm64/include/uapi/asm/kvm.h |  1 +
>  include/linux/kvm_host.h          |  1 -
>  include/uapi/linux/kvm.h          |  2 ++
>  virt/kvm/kvm_main.c               |  7 ++++++-
>  8 files changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 0007fef4ed814..a5a51403a7937 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -902,6 +902,7 @@ struct kvm_userspace_memory_region {
>  /* for kvm_memory_region::flags */
>  #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>  #define KVM_MEM_READONLY	(1UL << 1)
> +#define KVM_MEM_UNCACHED	(1UL << 2)
>  
>  This ioctl allows the user to create or modify a guest physical memory
>  slot.  When changing an existing slot, it may be moved in the guest
> @@ -917,12 +918,15 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
>  be identical.  This allows large pages in the guest to be backed by large
>  pages in the host.
>  
> -The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
> -KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
> -writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
> -use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
> -to make a new slot read-only.  In this case, writes to this memory will be
> -posted to userspace as KVM_EXIT_MMIO exits.
> +The flags field supports three flags: KVM_MEM_LOG_DIRTY_PAGES,
> +KVM_MEM_READONLY, and KVM_MEM_UNCACHED.  The first can be set to instruct
> +KVM to keep track of writes to memory within the slot.  See KVM_GET_DIRTY_LOG
> +ioctl to know how to use it.  The second can be set, if KVM_CAP_READONLY_MEM
> +capability allows it, to make a new slot read-only.  In this case, writes to
> +this memory will be posted to userspace as KVM_EXIT_MMIO exits. The third can
> +be set, if the KVM_CAP_UNCACHED_MEM capability allows it. This remaps the
> +memory as uncached, i.e. userspace will always directly read/write RAM for
> +this memory region.

I would repeat the definition of the flag in the text here instead of
referring to the 'first', 'second', and 'third' here; it's too hard to
follow.

Also, which combination of these flags are allowed?  Can they all be set
in combination or are they mutually exclusive or a bit of everything?

Thanks,
-Christoffer
