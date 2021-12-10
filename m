Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D893AC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 15:08:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74FE64B1CF;
	Fri, 10 Dec 2021 10:08:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oiIrExhUSFyo; Fri, 10 Dec 2021 10:08:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EF724B1E4;
	Fri, 10 Dec 2021 10:08:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 151AB4B1CF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 10:08:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1qKyOhxkblee for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 10:08:47 -0500 (EST)
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com
 [209.85.166.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96CDE4B1C8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 10:08:47 -0500 (EST)
Received: by mail-il1-f179.google.com with SMTP id s11so8712523ilv.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 07:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=IqGfMFMGzZuu2Hv/uD9rOzDxJvikzGWBAyGek2h55DE=;
 b=lW1C+rDjLspw7SVQAt0vSMM28+yVbcX5DDOIAMj81eboyg8FUcvBswACi9kzsCZ1H9
 5LYkmAl+ripLpLeA1JYjDfRVYOfnjhZ6POVxyIYR4Lum49RLzZ5RWdIcix2V6olLEP/9
 gzbS+aFMeFov/O7/Ut1NTNm3Ha9UNky/dDQ9C4caEsTOP7NocNO5oh3X+wrXcgjMnJZQ
 T81e6QY9941LqW4DIbK2SAlUbGXIxVpWGWtuWKb/QIycyTmpcjNGtegCxvoq4MRi7lL+
 cGcQirooM0N9R5XJPxNK6aimO3w+ibnOuRqK/8HTRPz7XKrzXhGUhqnTxmOH+0yVdhsE
 Nd4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=IqGfMFMGzZuu2Hv/uD9rOzDxJvikzGWBAyGek2h55DE=;
 b=NTfS+pyr7nBma2rBWnpzLQqghrwlr7OYElYBy8ICu84BZzVuL69UVosEdpz9t2uDOV
 RU0m1tXQaPv3hTW/jUH+lNHz1TuI91IX/6bQs5pz8Yr3udHJKTmF554glg5lU2kX5uYy
 GXiqGhBfFgUMx9fTQoe9PyJU/XVPwScjNhDrDbWyasWobcpPo3BsUuCCjAKrYH9il464
 zaH+Mtxd1fquOo/Is2q/1u18oSaDKUWQRNPQBQFy5228MYONWHqjCsngPUIyzskvbvtY
 KA0Itz7OvcKEiyHLo5cXsmqOxpmzxNG1u5QFk4RxSTERbwkvx0WhcKj+2d+6jxJEU8aL
 u2GA==
X-Gm-Message-State: AOAM533oZiAtsOAIMV/ogbOn/5Qs5WY/bHdsY8VlYKlMwUJ2BHowXMv/
 xYFzTiR3xh5PKDZtotX3iN27PUTViAEGu+5DU7di7A==
X-Google-Smtp-Source: ABdhPJzVz6WZmrdfRJ0Qz3kVSX2BxRgBQX2vMBYg/p29dzxXYwaz2Oo90oQFzDWBPjHZ1KZSzvLtG/aQF2JhEXs/8M4=
X-Received: by 2002:a05:6e02:1a2c:: with SMTP id
 g12mr23925538ile.22.1639148926706; 
 Fri, 10 Dec 2021 07:08:46 -0800 (PST)
MIME-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-14-qperret@google.com>
In-Reply-To: <20211201170411.1561936-14-qperret@google.com>
From: Andrew Walbran <qwandor@google.com>
Date: Fri, 10 Dec 2021 15:08:31 +0000
Message-ID: <CA+_y_2F0KF6WH+uTa4k3p72mCqeDuN1uzPKTx2u2E4bGUGaPJA@mail.gmail.com>
Subject: Re: [PATCH v3 13/15] KVM: arm64: Implement do_unshare() helper for
 unsharing memory
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


On Wed, 1 Dec 2021 at 17:05, 'Quentin Perret' via kernel-team
<kernel-team@android.com> wrote:
>
> From: Will Deacon <will@kernel.org>
>
> Tearing down a previously shared memory region results in the borrower
> losing access to the underlying pages and returning them to the "owned"
> state in the owner.
>
> Implement a do_unshare() helper, along the same lines as do_share(), to
> provide this functionality for the host-to-hyp case.
>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 115 ++++++++++++++++++++++++++
>  1 file changed, 115 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 1282cbd6b9b3..43b25e2de780 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -485,6 +485,16 @@ static int host_request_owned_transition(u64 *completer_addr,
>         return __host_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
>  }
>
> +static int host_request_unshare(u64 *completer_addr,
> +                               const struct pkvm_mem_transition *tx)
> +{
> +       u64 size = tx->nr_pages * PAGE_SIZE;
> +       u64 addr = tx->initiator.addr;
> +
> +       *completer_addr = tx->initiator.host.completer_addr;
> +       return __host_check_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
> +}
> +
>  static int host_initiate_share(u64 *completer_addr,
>                                const struct pkvm_mem_transition *tx)
>  {
> @@ -495,6 +505,16 @@ static int host_initiate_share(u64 *completer_addr,
>         return __host_set_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
>  }
>
> +static int host_initiate_unshare(u64 *completer_addr,
> +                                const struct pkvm_mem_transition *tx)
> +{
> +       u64 size = tx->nr_pages * PAGE_SIZE;
> +       u64 addr = tx->initiator.addr;
> +
> +       *completer_addr = tx->initiator.host.completer_addr;
> +       return __host_set_page_state_range(addr, size, PKVM_PAGE_OWNED);
> +}
> +
>  static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
>  {
>         if (!kvm_pte_valid(pte))
> @@ -535,6 +555,17 @@ static int hyp_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
>         return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
>  }
>
> +static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
> +{
> +       u64 size = tx->nr_pages * PAGE_SIZE;
> +
> +       if (__hyp_ack_skip_pgtable_check(tx))
> +               return 0;
> +
> +       return __hyp_check_page_state_range(addr, size,
> +                                           PKVM_PAGE_SHARED_BORROWED);
> +}
> +
>  static int hyp_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
>                               enum kvm_pgtable_prot perms)
>  {
> @@ -545,6 +576,14 @@ static int hyp_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
>         return pkvm_create_mappings_locked(start, end, prot);
>  }
>
> +static int hyp_complete_unshare(u64 addr, const struct pkvm_mem_transition *tx)
> +{
> +       u64 size = tx->nr_pages * PAGE_SIZE;
> +       int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, addr, size);
> +
> +       return (ret != size) ? -EFAULT : 0;
> +}
> +
>  static int check_share(struct pkvm_mem_share *share)
>  {
>         const struct pkvm_mem_transition *tx = &share->tx;
> @@ -621,6 +660,82 @@ static int do_share(struct pkvm_mem_share *share)
>         return WARN_ON(__do_share(share));
>  }
>
> +static int check_unshare(struct pkvm_mem_share *share)
> +{
> +       const struct pkvm_mem_transition *tx = &share->tx;
> +       u64 completer_addr;
> +       int ret;
> +
> +       switch (tx->initiator.id) {
> +       case PKVM_ID_HOST:
> +               ret = host_request_unshare(&completer_addr, tx);
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
> +               ret = hyp_ack_unshare(completer_addr, tx);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       return ret;
> +}
> +
> +static int __do_unshare(struct pkvm_mem_share *share)
> +{
> +       const struct pkvm_mem_transition *tx = &share->tx;
> +       u64 completer_addr;
> +       int ret;
> +
> +       switch (tx->initiator.id) {
> +       case PKVM_ID_HOST:
> +               ret = host_initiate_unshare(&completer_addr, tx);
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
> +               ret = hyp_complete_unshare(completer_addr, tx);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       return ret;
> +}
> +
> +/*
> + * do_unshare():
> + *
> + * The page owner revokes access from another component for a range of
> + * pages which were previously shared using do_share().
> + *
> + * Initiator: SHARED_OWNED     => OWNED
> + * Completer: SHARED_BORROWED  => NOPAGE
> + */
> +static int do_unshare(struct pkvm_mem_share *share)
> +{
> +       int ret;
> +
> +       ret = check_unshare(share);
> +       if (ret)
> +               return ret;
> +
> +       return WARN_ON(__do_unshare(share));
> +}
> +
>  int __pkvm_host_share_hyp(u64 pfn)
>  {
>         int ret;
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
