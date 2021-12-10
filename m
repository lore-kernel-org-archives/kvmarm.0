Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC6FC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 15:19:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73E714B1B2;
	Fri, 10 Dec 2021 10:19:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x4i9LDwlB9WS; Fri, 10 Dec 2021 10:19:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8512B4B1C5;
	Fri, 10 Dec 2021 10:19:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB2D34B1C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 10:19:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3QW2pd-XwFBq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 10:19:02 -0500 (EST)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com
 [209.85.166.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 510144B1B2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 10:19:02 -0500 (EST)
Received: by mail-il1-f173.google.com with SMTP id 15so8740588ilq.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 07:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=hEmjbMo0ZsJ3TjBk5kcSaZtBAj1+iwJQz9LpuHVA9P8=;
 b=adjHU3j7rH8I3KZ7nA9tqZjFgCdOCuNz8zU1VrxrHl/Dw0n5x3fQTFQk1Hn2IHGHv6
 VU0/pYHuBm8zCiPP61OLvv8YobfjZo3g9FzZNOztHOuHY0HAiOBWQd1eskYf6PYC3rJm
 p3CfbfsVfXevd7OFsjWr7SL29ZbjFW8u14n+TGlEUKk51l2Z53WO1oC3BVW3hQkOkyrr
 0A+T50X0a60nlpG73r3zaUYIJ+MSOzm8IgDfJiH2JSb+3R7ZVIlS1PUuveKw19oGbEgY
 FRie4WYQYA55XOW2dhggRoaKJYzGmctKKqplAQzgMHVffM62jgpvk6S3dzWHMpTmVSmP
 E1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=hEmjbMo0ZsJ3TjBk5kcSaZtBAj1+iwJQz9LpuHVA9P8=;
 b=O3g9lJnQvCr54F2mK65Y8ZksY9KJRXfWIU34itpF3/MAnkadMIPWdiYt854M/fLEGz
 mhcUlTocLq47uEj0+JcbxbIVOXL8AeNjt/gDepRaxXMA8JBMpvH3BdV0rBz92aS6VnUv
 /AJtgb/MP06WICeN0GimUDHqjYk/S9DHBOXTC7W0CoeEPFCKIkU3cxBI+QyKgU3tvL0L
 rXJbjqZK8eMsNGujSiaiZCHOWWEXvl8e2babeCVK/lf86Z0XffmMclcOK6FBQ3LGxvah
 4Zxv8qITAKm5cdR68AFY1Jc7b0aBoI7dk/Cpp7Zhcpao0yg8CbA1YYMkRkZavhcXjmZh
 G99g==
X-Gm-Message-State: AOAM5331h7MFgkplbMXFXTP3B3Ox7N8gEsMhDkgGuN4bTmN5BCFhyvA/
 kFpuDrivWX31bzZTja/er7PHf32oGr0pHlhg5Xty4w==
X-Google-Smtp-Source: ABdhPJzfs0RYsbtxr+hNbrS5EFgoPyGeyMd247aeDfYO1cdIpTQebvlNzQ3dtI+jNUaj2c61s2HVOL8MndEGlGtfLxE=
X-Received: by 2002:a92:cd8e:: with SMTP id r14mr19222736ilb.277.1639149541371; 
 Fri, 10 Dec 2021 07:19:01 -0800 (PST)
MIME-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-12-qperret@google.com>
In-Reply-To: <20211201170411.1561936-12-qperret@google.com>
From: Andrew Walbran <qwandor@google.com>
Date: Fri, 10 Dec 2021 15:18:50 +0000
Message-ID: <CA+_y_2FMrc=XqAPK-WVtb5No9xYXOXmaLbVE+AEGZL668YhKGQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/15] KVM: arm64: Implement do_share() helper for
 sharing memory
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Reviewed-by: Andrew Walbran <qwandor@google.com>

On Wed, 1 Dec 2021 at 17:04, 'Quentin Perret' via kernel-team
<kernel-team@android.com> wrote:
>
> From: Will Deacon <will@kernel.org>
>
> By default, protected KVM isolates memory pages so that they are
> accessible only to their owner: be it the host kernel, the hypervisor
> at EL2 or (in future) the guest. Establishing shared-memory regions
> between these components therefore involves a transition for each page
> so that the owner can share memory with a borrower under a certain set
> of permissions.
>
> Introduce a do_share() helper for safely sharing a memory region between
> two components. Currently, only host-to-hyp sharing is implemented, but
> the code is easily extended to handle other combinations and the
> permission checks for each component are reusable.
>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 237 ++++++++++++++++++++++++++
>  1 file changed, 237 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 757dfefe3aeb..74ca4043b08a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -471,3 +471,240 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>         ret = host_stage2_idmap(addr);
>         BUG_ON(ret && ret != -EAGAIN);
>  }
> +
> +/* This corresponds to locking order */
> +enum pkvm_component_id {
> +       PKVM_ID_HOST,
> +       PKVM_ID_HYP,
> +};
> +
> +struct pkvm_mem_transition {
> +       u64                             nr_pages;
> +
> +       struct {
> +               enum pkvm_component_id  id;
> +               /* Address in the initiator's address space */
> +               u64                     addr;
> +
> +               union {
> +                       struct {
> +                               /* Address in the completer's address space */
> +                               u64     completer_addr;
> +                       } host;
> +               };
> +       } initiator;
> +
> +       struct {
> +               enum pkvm_component_id  id;
> +       } completer;
> +};
> +
> +struct pkvm_mem_share {
> +       const struct pkvm_mem_transition        tx;
> +       const enum kvm_pgtable_prot             prot;
It would be helpful to add a comment documenting what this is used for
(i.e. whether it is for the initiator or completer). Or even rename it
to something like completer_prot to make that clear.

> +};
> +
> +struct check_walk_data {
> +       enum pkvm_page_state    desired;
> +       enum pkvm_page_state    (*get_page_state)(kvm_pte_t pte);
> +};
> +
> +static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
> +                                     kvm_pte_t *ptep,
> +                                     enum kvm_pgtable_walk_flags flag,
> +                                     void * const arg)
> +{
> +       struct check_walk_data *d = arg;
> +       kvm_pte_t pte = *ptep;
> +
> +       if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
> +               return -EINVAL;
> +
> +       return d->get_page_state(pte) == d->desired ? 0 : -EPERM;
> +}
> +
> +static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +                                 struct check_walk_data *data)
> +{
> +       struct kvm_pgtable_walker walker = {
> +               .cb     = __check_page_state_visitor,
> +               .arg    = data,
> +               .flags  = KVM_PGTABLE_WALK_LEAF,
> +       };
> +
> +       return kvm_pgtable_walk(pgt, addr, size, &walker);
> +}
> +
> +static enum pkvm_page_state host_get_page_state(kvm_pte_t pte)
> +{
> +       if (!kvm_pte_valid(pte) && pte)
> +               return PKVM_NOPAGE;
> +
> +       return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
> +}
> +
> +static int __host_check_page_state_range(u64 addr, u64 size,
> +                                        enum pkvm_page_state state)
> +{
> +       struct check_walk_data d = {
> +               .desired        = state,
> +               .get_page_state = host_get_page_state,
> +       };
> +
> +       hyp_assert_lock_held(&host_kvm.lock);
> +       return check_page_state_range(&host_kvm.pgt, addr, size, &d);
> +}
> +
> +static int __host_set_page_state_range(u64 addr, u64 size,
> +                                      enum pkvm_page_state state)
> +{
> +       enum kvm_pgtable_prot prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, state);
> +
> +       return host_stage2_idmap_locked(addr, size, prot);
> +}
> +
> +static int host_request_owned_transition(u64 *completer_addr,
> +                                        const struct pkvm_mem_transition *tx)
> +{
> +       u64 size = tx->nr_pages * PAGE_SIZE;
> +       u64 addr = tx->initiator.addr;
> +
> +       *completer_addr = tx->initiator.host.completer_addr;
> +       return __host_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
> +}
> +
> +static int host_initiate_share(u64 *completer_addr,
> +                              const struct pkvm_mem_transition *tx)
> +{
> +       u64 size = tx->nr_pages * PAGE_SIZE;
> +       u64 addr = tx->initiator.addr;
> +
> +       *completer_addr = tx->initiator.host.completer_addr;
> +       return __host_set_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
> +}
> +
> +static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
> +{
> +       if (!kvm_pte_valid(pte))
> +               return PKVM_NOPAGE;
> +
> +       return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
> +}
> +
> +static int __hyp_check_page_state_range(u64 addr, u64 size,
> +                                       enum pkvm_page_state state)
> +{
> +       struct check_walk_data d = {
> +               .desired        = state,
> +               .get_page_state = hyp_get_page_state,
> +       };
> +
> +       hyp_assert_lock_held(&pkvm_pgd_lock);
> +       return check_page_state_range(&pkvm_pgtable, addr, size, &d);
> +}
> +
> +static bool __hyp_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
> +{
> +       return !(IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) ||
> +                tx->initiator.id != PKVM_ID_HOST);
> +}
> +
> +static int hyp_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
> +                        enum kvm_pgtable_prot perms)
> +{
> +       u64 size = tx->nr_pages * PAGE_SIZE;
> +
> +       if (perms != PAGE_HYP)
> +               return -EPERM;
> +
> +       if (__hyp_ack_skip_pgtable_check(tx))
> +               return 0;
> +
> +       return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
> +}
> +
> +static int hyp_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
> +                             enum kvm_pgtable_prot perms)
> +{
> +       void *start = (void *)addr, *end = start + (tx->nr_pages * PAGE_SIZE);
> +       enum kvm_pgtable_prot prot;
> +
> +       prot = pkvm_mkstate(perms, PKVM_PAGE_SHARED_BORROWED);
> +       return pkvm_create_mappings_locked(start, end, prot);
> +}
> +
> +static int check_share(struct pkvm_mem_share *share)
> +{
> +       const struct pkvm_mem_transition *tx = &share->tx;
> +       u64 completer_addr;
> +       int ret;
> +
> +       switch (tx->initiator.id) {
> +       case PKVM_ID_HOST:
> +               ret = host_request_owned_transition(&completer_addr, tx);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       if (ret)
> +               return ret;
> +
> +       switch (tx->completer.id) {
> +       case PKVM_ID_HYP:
> +               ret = hyp_ack_share(completer_addr, tx, share->prot);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       return ret;
> +}
> +
> +static int __do_share(struct pkvm_mem_share *share)
> +{
> +       const struct pkvm_mem_transition *tx = &share->tx;
> +       u64 completer_addr;
> +       int ret;
> +
> +       switch (tx->initiator.id) {
> +       case PKVM_ID_HOST:
> +               ret = host_initiate_share(&completer_addr, tx);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       if (ret)
> +               return ret;
> +
> +       switch (tx->completer.id) {
> +       case PKVM_ID_HYP:
> +               ret = hyp_complete_share(completer_addr, tx, share->prot);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       return ret;
> +}
> +
> +/*
> + * do_share():
> + *
> + * The page owner grants access to another component with a given set
> + * of permissions.
> + *
> + * Initiator: OWNED    => SHARED_OWNED
> + * Completer: NOPAGE   => SHARED_BORROWED
> + */
> +static int do_share(struct pkvm_mem_share *share)
> +{
> +       int ret;
> +
> +       ret = check_share(share);
> +       if (ret)
> +               return ret;
> +
> +       return WARN_ON(__do_share(share));
> +}
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
