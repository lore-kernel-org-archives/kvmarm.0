Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CDDC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 09:28:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 924404A3A5;
	Thu, 17 Mar 2022 05:28:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uQ06skDXUWkw; Thu, 17 Mar 2022 05:28:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C80404A1D9;
	Thu, 17 Mar 2022 05:28:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13A85404B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 14:07:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oJ-RUtNYtUdU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 14:07:33 -0400 (EDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com
 [209.85.219.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 111DE402A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 14:07:33 -0400 (EDT)
Received: by mail-yb1-f178.google.com with SMTP id f38so5920508ybi.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 11:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PnmkVyhkE9O12y1T9viSC5Yt4nwOSPLkRDwt3vG/CDc=;
 b=LjuosIEEYYEzAVjUbeyd05n+XRZzzyXQNWGnpxPY2Xw5NcS8D/uvf0EdccSmRJXhKb
 VpxTrEcAMFfOx+DDZGxmQq5X9JqfajNjpZ5oh9YWlyb5XlHxa/e/rgKthm6WmIYj32eH
 mFwav9CCGijv6u7q9+Vsfemo5DDQ58bYM1D38UTdt+0Jv/K0UzeDfncjWD3T+NurGmRP
 KKmJ/jOKi+kl9wQaNhs75a998Db2r2mVDjCdyQkNxWPakeWljy3n5t0Cc9bE6cio7KZy
 BT7qh5hXsLc/8tcJopJD7VEVUlEbMUKZO7CGstjRGP7gfreFy2KLA5m30PoD+ocDI6FR
 FGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PnmkVyhkE9O12y1T9viSC5Yt4nwOSPLkRDwt3vG/CDc=;
 b=SdP98ua9+qLr3gAArYjqRFbL3okNPNATc32l68Js8lUzz0ShMoQOm9bB9uhV3bBO5B
 iJ1fmRHFVJ6OD61fRbwWNaaUFF61eUE5utoYiYAHqf2VNab7U4q9ojXW8NfJILWTW7y5
 8vIjck3NEG3fl8KUM6NpTwU1jfDIKcRJ+ZFDVIKmI26Db3TGAhwDeYShClJHfLk8Rspq
 I+/ifwpJdO5Lo07UkYjMKwcF38kvKYcdRuUmtCU+KOI2HGcvs6V64Y4zNc2B1SZFzV04
 vhTvTeTe9o1L3ah8Mf9uEoWvB1vM8YRis+4FqD9JYh0ITInCA8ZMb6iq2+BjO/WADZJQ
 MBMg==
X-Gm-Message-State: AOAM5327LLcRUrHYiZME4lX/AjFgpx4KYNme2ajkuDxpYXEdMcQPiMb7
 u3fUoph7AUPCVqRBtt9TCgsMvKqNQfOg+97B/bC/Ag==
X-Google-Smtp-Source: ABdhPJyyXFoQn1uerPs5goPnQmblKmVx5IKBTpH/PqBXtW4BaLiDyXA8LgJB5YBszNuVqJzUMU8TQOGvQDlBfaX/Z0A=
X-Received: by 2002:a25:d191:0:b0:628:79ad:1e61 with SMTP id
 i139-20020a25d191000000b0062879ad1e61mr1147185ybg.255.1647454052316; Wed, 16
 Mar 2022 11:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
 <20220311060207.2438667-5-ricarkol@google.com>
In-Reply-To: <20220311060207.2438667-5-ricarkol@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 16 Mar 2022 12:07:21 -0600
Message-ID: <CANgfPd8u_K3cOpaUPY8+rU+4RFehj8J61gdzuDyOZv4dSDZ+xQ@mail.gmail.com>
Subject: Re: [PATCH 04/11] KVM: selftests: Add vm_alloc_page_table_in_memslot
 library function
To: Ricardo Koller <ricarkol@google.com>
X-Mailman-Approved-At: Thu, 17 Mar 2022 05:28:50 -0400
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add a library function to allocate a page-table physical page in a
> particular memslot.  The default behavior is to create new page-table
> pages in memslot 0.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

This is very similar to one of the patches in the NX hugepages control
series I sent out last week, I guess we both had similar needs at the
same time.
Your solution introduces way less churn though, so it's probably
better. I might use this commit or wait for it to be merged before I
send out v2 of my NX control series.

In any case,
Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index d6acec0858c0..c8dce12a9a52 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -307,6 +307,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>                               vm_paddr_t paddr_min, uint32_t memslot);
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
>
>  /*
>   * Create a VM with reasonable defaults
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 64ef245b73de..ae21564241c8 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2409,9 +2409,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  /* Arbitrary minimum physical address used for virtual translation tables. */
>  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
>
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
> +{
> +       return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> +                       pt_memslot);
> +}
> +
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
>  {
> -       return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> +       return vm_alloc_page_table_in_memslot(vm, 0);
>  }
>
>  /*
> --
> 2.35.1.723.g4982287a31-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
