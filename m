Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9330FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 13:23:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3337149E21;
	Tue, 25 Jan 2022 08:23:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y-ZYWbxJSDeL; Tue, 25 Jan 2022 08:23:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AC4949E27;
	Tue, 25 Jan 2022 08:23:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DC7949E1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 08:23:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vig7oQUwdFrz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 08:23:09 -0500 (EST)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com
 [209.85.167.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F9B14083E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 08:23:09 -0500 (EST)
Received: by mail-oi1-f179.google.com with SMTP id u129so4843650oib.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 05:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=7GmwAVl/MoxtO21S2PDRJaYdqihfLh9OC3HwysJFbw0=;
 b=WlVq3jDd1sN/talTN+PjHAE+iRB0VKvmAISPQE8rRe8S37YJTh0RBYt2JieQifeCAa
 HWv5PZwPzrkyEsY1Q5njf0BKKhGXHs2Q2tT9HFx09ExgnzFzolHuQduy3ZLF5U060d2h
 sHe4T7l3Y3ZMOmXZWTQEcvOnyglrCtYSQ1xk2+WjQ668yJLw09UQe+PYRo2l7vQlvBhU
 Pbl0XB821KS7qZwRVUGHc/buyteH8GAGtiwGDw7zI7fkj+YsBplB1tIcNuFSIxh/Pa2z
 t2PxfZoqMqHwVz0NYrvV5jEKqI8OKrLSR9NohBlBL9Lp3hF0ahOGGPj7FFwQtXG1iA6g
 wB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=7GmwAVl/MoxtO21S2PDRJaYdqihfLh9OC3HwysJFbw0=;
 b=59xqc6CMkQZ4JgauEqv41vGXTq0uD/egWgKCCebXXjvqK9QDwT2kz8aF1WAN5Xr8m1
 F3lBjdWyARmst5QJsyDU/868KYe5IH6+/JukurwQYGzsSk7JNhrGaQ2/9mWE2QBCdDFw
 lf/IxPktw7H8R4NpaAlyLSmwi4i7vZ7guu0GC0PIZDA9Pb74//OdlROWproCM4xB+oTX
 Ad+XR+pWlV2SH3qukI9BplVgHmwDIE/MTTxr2paVgraaqDEWdU+UPEgO+hh9JXBhbTBX
 8mlThr9zGoTWGKiDn8uhX1HGtJt9UlNjcCueIU5PK8cO3lBV4XVRJLPM0yioKYqdVdPi
 GyPQ==
X-Gm-Message-State: AOAM532TGen9/cuvg2wjVWUvcxgyCnEEBf15UzpCQ7MG5b9yawSRzJzR
 mvkpn5SJ82vqITPfVGwnErJvwmiBLyDzDHmY06wTVw==
X-Google-Smtp-Source: ABdhPJyX4G2P+ppGXnVoStTwSV/jbXl0nhjknnUmS2sg5MuTnj6ZZQ/wkq5DHRJ1r54+4zVWfcdBl0EMyblcLO6pZLA=
X-Received: by 2002:a05:6808:ec2:: with SMTP id
 q2mr621256oiv.124.1643116988604; 
 Tue, 25 Jan 2022 05:23:08 -0800 (PST)
MIME-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com>
 <20220118015703.3630552-3-jingzhangos@google.com>
In-Reply-To: <20220118015703.3630552-3-jingzhangos@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 25 Jan 2022 13:22:32 +0000
Message-ID: <CA+EHjTwskGDoZyh4zJR56feKSCfgsGe3eh3_N1r7BPoVyyrg6Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Add fast path to handle permission
 relaxation during dirty logging
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>
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

Hi Jing,

On Tue, Jan 18, 2022 at 1:57 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> To reduce MMU lock contention during dirty logging, all permission
> relaxation operations would be performed under read lock.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index cafd5813c949..10df5d855d54 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1080,6 +1080,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         gfn_t gfn;
>         kvm_pfn_t pfn;
>         bool logging_active = memslot_is_logging(memslot);
> +       bool logging_perm_fault = false;
>         unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
>         unsigned long vma_pagesize, fault_granule;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> @@ -1114,6 +1115,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (logging_active) {
>                 force_pte = true;
>                 vma_shift = PAGE_SHIFT;
> +               logging_perm_fault = (fault_status == FSC_PERM && write_fault);
>         } else {
>                 vma_shift = get_vma_page_shift(vma, hva);
>         }
> @@ -1212,7 +1214,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (exec_fault && device)
>                 return -ENOEXEC;
>
> -       write_lock(&kvm->mmu_lock);
> +       /*
> +        * To reduce MMU contentions and enhance concurrency during dirty
> +        * logging dirty logging, only acquire read lock for permission
> +        * relaxation.
> +        */

A couple of nits:
"dirty logging" is repeated twice
s/contentions/contention

Other than that,

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad






> +       if (logging_perm_fault)
> +               read_lock(&kvm->mmu_lock);
> +       else
> +               write_lock(&kvm->mmu_lock);
>         pgt = vcpu->arch.hw_mmu->pgt;
>         if (mmu_notifier_retry(kvm, mmu_seq))
>                 goto out_unlock;
> @@ -1271,7 +1281,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         }
>
>  out_unlock:
> -       write_unlock(&kvm->mmu_lock);
> +       if (logging_perm_fault)
> +               read_unlock(&kvm->mmu_lock);
> +       else
> +               write_unlock(&kvm->mmu_lock);
>         kvm_set_pfn_accessed(pfn);
>         kvm_release_pfn_clean(pfn);
>         return ret != -EAGAIN ? ret : 0;
> --
> 2.34.1.703.g22d0c6ccf7-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
