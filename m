Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C619BC433DF
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78F622075F
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="UevvpOts"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78F622075F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3138D4B1C9;
	Thu, 11 Jun 2020 03:22:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2oQS8GK0hjY2; Thu, 11 Jun 2020 03:22:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7CEA4B1F2;
	Thu, 11 Jun 2020 03:22:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 917094B1D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 18:34:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UVyLiru9fusI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 18:34:39 -0400 (EDT)
Received: from mail-vs1-f66.google.com (mail-vs1-f66.google.com
 [209.85.217.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 974634B15B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 18:34:39 -0400 (EDT)
Received: by mail-vs1-f66.google.com with SMTP id y123so2284931vsb.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 15:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=C9LYQ8aclMkdwfJP4cdhxWD4N8cMJMuN6znPHlB3Rsc=;
 b=UevvpOtsXUfdMcqvIgRfPVVQSDyZs6oXq/Xnj/8uJDFNeQBZ7vzloiU32xzvK6mFCu
 cGGLwNrdnw/Q0on5lLXJlkuu8D4VI6gjZehfPhGO6t/torNaJ6NxHMQ2JuDgO8FwHc4P
 o8FP7KzD9QWU8u7G49I5aLDbEK8X8zhTnPGPK+25pdCKJLn9W7w1iBlkb84D2LADSGpc
 tCqhhzfq26VpCG0se8b1WZwp4CCFSusJSn+larn2+KMSi4aCsCQRQ/S3A4qsfTfUDCpT
 JYfiX91/2CIDQozv8ZBX3SClrislUPBF+zqSWJE7quvH7sEsU2MJoNuxaq5T13FcVb0X
 ExAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=C9LYQ8aclMkdwfJP4cdhxWD4N8cMJMuN6znPHlB3Rsc=;
 b=tHYY7BDB39AeICuE7LzpN5/wc3eya4ju5G3JBzM6mAylyvCzDARCuOEPxc8WsMlWCb
 I8jn37Yp0WaeCyK52rh2r2zI64Y7s46N6zrA6DY/VEnw40rV/zyilGyEAWm9CKkNlwvx
 rCHODvzv14GS8lNddPQ6JFO+Lz5yRINOBjYxX6CgXrfKxopok1qw4V74QoAGPqvCDGcM
 Tb6evBheSBIeGEkQ0qEuPl+kezo51eZdRZrN1XUYd8Y+VQ6KHC09urNo56L0Dcn+iq+N
 L1ksr1Lf3PP7OlkPGH6foMgNA8IK1V32Nlm8Sx6uTILYPBP8MHnN0pUaR8da4khlvN/u
 iR0A==
X-Gm-Message-State: AOAM533YEKh/V1wZ9PfdEcF7MPV1oUCo6Xz9uOdU+wuaNT67PYkDXQod
 ZURWgz8s/75Bp29SVgWo5rREdcpt1CS0I29zBgj2QQ==
X-Google-Smtp-Source: ABdhPJzdt1t5lYhNZNFDbxTCIee/fOpBW2dvkZTK5r9pH/LqHC+MVWmHSuu/UxjSaFUQydIW/izqWRJz+CsXZPttueA=
X-Received: by 2002:a67:79ce:: with SMTP id u197mr4725019vsc.17.1591828478904; 
 Wed, 10 Jun 2020 15:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-8-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-8-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 10 Jun 2020 15:34:28 -0700
Message-ID: <CANgfPd9UH01vO1SYJ3vrKq4H_DXcJ3OL_VaeY2TV8_ZH9cR1GQ@mail.gmail.com>
Subject: Re: [PATCH 07/21] KVM: x86/mmu: Topup memory caches after walking
 GVA->GPA
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
> Topup memory caches after walking the GVA->GPA translation during a
> shadow page fault, there is no need to ensure the caches are full when
> walking the GVA.  As of commit f5a1e9f89504f ("KVM: MMU: remove call
> to kvm_mmu_pte_write from walk_addr"), the FNAME(walk_addr) flow no
> longer add rmaps via kvm_mmu_pte_write().
>
> This avoids allocating memory in the case that the GVA is unmapped in
> the guest, and also provides a paper trail of why/when the memory caches
> need to be filled.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 38c576495048..3de32122f601 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -791,10 +791,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>
>         pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
>
> -       r = mmu_topup_memory_caches(vcpu);
> -       if (r)
> -               return r;
> -
>         /*
>          * If PFEC.RSVD is set, this is a shadow page fault.
>          * The bit needs to be cleared before walking guest page tables.
> @@ -822,6 +818,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>                 return RET_PF_EMULATE;
>         }
>
> +       r = mmu_topup_memory_caches(vcpu);
> +       if (r)
> +               return r;
> +
>         vcpu->arch.write_fault_to_shadow_pgtable = false;
>
>         is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
