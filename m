Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413D8C433E2
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE11F20812
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="QyyXrmeK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE11F20812
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A768F4B219;
	Thu, 11 Jun 2020 03:22:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rtSojG1VEH5E; Thu, 11 Jun 2020 03:22:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B20D64B1EE;
	Thu, 11 Jun 2020 03:22:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E1904B1D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 18:20:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1ndA5UA3xMLO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 18:20:34 -0400 (EDT)
Received: from mail-vs1-f68.google.com (mail-vs1-f68.google.com
 [209.85.217.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97A944B1D1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 18:20:34 -0400 (EDT)
Received: by mail-vs1-f68.google.com with SMTP id y123so2266801vsb.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 15:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gbYrwjkRNzZs52wtNe5b9ymrBledc5fgJdW/7CYMczg=;
 b=QyyXrmeKJSKKc54VOXRhBA48lstvw0q3ctLwmRUmYvuniF6MaKqprw76G6WKeXgKXB
 r/jbdUg8yJ7iw34oE1OWz0dWyMIlim7iHYcQtD67/ivBRy+I7B838Bxvx4JWOVUAxYN3
 POzPLtPUSvRylefwwyiJnNCwZ28r+eFHCfQTlfjzukPMl52cDhRE0H8vA3A5R5qZ//vK
 hyVJruxV9jjEt3XKZbDLdCyH9tLqObhgWfqQJpRCLqqkFBHz8EB0eQ7avKhqHHK0zYzj
 RESHvTrXTKtZufFfvsuK5nk/vVANKcnKj1isrCHWI7ENKEYpAZgFY60ZfqvyNfgEDVAL
 29Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gbYrwjkRNzZs52wtNe5b9ymrBledc5fgJdW/7CYMczg=;
 b=BdOptmnqr5rHZtnPRzTckao9nHco55SwTe9tVNb3HiEBRrS9hRPqpaT/lptT+FwUi3
 gX8MRkAX3conJsFE6ZKqk85KVEehuf2tMS6Au2cYiZdiYVNFChpxP9hyvt/sCDf75YyV
 0urDWLhljAVJr4LvWfDNLU2VwbjjykU6vekjkH6CgZxR+gwGGCkXlwRghu1uIaBNrfvR
 C/6rSp66OmQ3Zv/ZuZxBzIquYtutu/lrfKTITYf8CvCcnJKp5HkTEy2n+TJvP10mTn27
 vg93b5UupWX/1cUR7gJdWxMDc858WQR805UuFIdKAJ9qZ3e6qrDcJR0/pmo1/GSzKDP2
 WC1Q==
X-Gm-Message-State: AOAM530mYPBdwZKVY1KDzk0AJRhFKioP8/eR57mRF2jP0PbZTNazOXUk
 kewKPlyG3DP9WTMxeMpw7p/Rw4UFFScupN9ug9kMaA==
X-Google-Smtp-Source: ABdhPJzOjvq/kbEr1iPy17gDm6Y5SxC/Oi9n4y5NbS27Re14ZbRVe9raYSH+GiU0z+vIPd8N4LFp9am07TBNHW7Kx80=
X-Received: by 2002:a67:d287:: with SMTP id z7mr4666597vsi.2.1591827633895;
 Wed, 10 Jun 2020 15:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-9-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-9-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 10 Jun 2020 15:20:19 -0700
Message-ID: <CANgfPd-19pam9sujfsk1pdrp8YhVft1+JAmSS=xgUULqXRyUDg@mail.gmail.com>
Subject: Re: [PATCH 08/21] KVM: x86/mmu: Clean up the gorilla math in
 mmu_topup_memory_caches()
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Thu, 11 Jun 2020 03:22:32 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Peter Feiner <pfeiner@google.com>
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

On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Clean up the minimums in mmu_topup_memory_caches() to document the
> driving mechanisms behind the minimums.  Now that encountering an empty
> cache is unlikely to trigger BUG_ON(), it is less dangerous to be more
> precise when defining the minimums.
>
> For rmaps, the logic is 1 parent PTE per level, plus a single rmap, and
> prefetched rmaps.  The extra objects in the current '8 + PREFETCH'
> minimum came about due to an abundance of paranoia in commit
> c41ef344de212 ("KVM: MMU: increase per-vcpu rmap cache alloc size"),
> i.e. it could have increased the minimum to 2 rmaps.  Furthermore, the
> unexpected extra rmap case was killed off entirely by commits
> f759e2b4c728c ("KVM: MMU: avoid pte_list_desc running out in
> kvm_mmu_pte_write") and f5a1e9f89504f ("KVM: MMU: remove call to
> kvm_mmu_pte_write from walk_addr").
>
> For the so called page cache, replace '8' with 2*PT64_ROOT_MAX_LEVEL.
> The 2x multiplier is needed because the cache is used for both shadow
> pages and gfn arrays for indirect MMUs.
>
> And finally, for page headers, replace '4' with PT64_ROOT_MAX_LEVEL.
>
> Note, KVM now supports 5-level paging, i.e. the old minimums that used a
> baseline derived from 4-level paging were technically wrong.  But, KVM
> always allocates roots in a separate flow, e.g. it's impossible in the
> current implementation to actually need 5 new shadow pages in a single
> flow.  Use PT64_ROOT_MAX_LEVEL unmodified instead of subtracting 1, as
> the direct usage is likely more intuitive to uninformed readers, and the
> inflated minimum is unlikely to affect functionality in practice.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4b4c3234d623..451e0365e5dd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1103,14 +1103,17 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
>  {
>         int r;
>
> +       /* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
>         r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> -                                  8 + PTE_PREFETCH_NUM);
> +                                  1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>         if (r)
>                 return r;
> -       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache, 8);
> +       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
> +                                  2 * PT64_ROOT_MAX_LEVEL);
>         if (r)
>                 return r;
> -       return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
> +       return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> +                                     PT64_ROOT_MAX_LEVEL);
>  }
>
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
