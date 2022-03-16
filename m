Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1699C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Mar 2022 08:49:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 615CA40B6C;
	Wed, 16 Mar 2022 04:49:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vZJvaKV+x8sv; Wed, 16 Mar 2022 04:49:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2665349DF6;
	Wed, 16 Mar 2022 04:49:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1229A49E35
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 04:49:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uxlPqwls8MdZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 04:49:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8E4949DF6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 04:49:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647420582;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=4icPmxzgJzoNfLGIPEaiu3EGs4DB/AfIqWIUwU4iOPM=;
 b=Sq4CeFH7dboTS4xLn78pzUBEGzIOPN7eQAF81MQ5LviDsPcFmG/ejGVF9cZ/uDH3ST7Ict
 rGgpG8prBmhxHN3wM8G18QeWeWhWqkYREaXTgIGMYPiC0Y7rhh+eEf6JjtE6k3+jNdF9nD
 un5b85Lym7KK/+6Ri2nIShXu7Kt9pMM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-6alNffugMBKVPPfeX8IqEg-1; Wed, 16 Mar 2022 04:49:41 -0400
X-MC-Unique: 6alNffugMBKVPPfeX8IqEg-1
Received: by mail-pj1-f72.google.com with SMTP id
 q9-20020a17090a7a8900b001bf0a7d9dfdso1319439pjf.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 01:49:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4icPmxzgJzoNfLGIPEaiu3EGs4DB/AfIqWIUwU4iOPM=;
 b=OGBGd54iU7PeJ0A51LIvcIOjAvMojh38ZKWA/pau/r9qVX3fMmfttiG9dX9QO13G96
 MJrj0hULFSN4fAiRkBr4zziEXoXeqM/WULs2ZBzegNLrsNTy1IMTLXmSKrSJDsoq8SvW
 rqgk9dqSluwajdukEAyy6PCtbH1/1+q0MX4O99YZfM9x8wi7CkqI8S9fiJUSl18bO+gX
 X1d+aaQ2OylvPevSSb0qJC67qVtR1F/UiJqJFwKPoA/xJNZ94/RHlRfXn41+560WskB/
 5tCIdtaoANikls+AXJslk8ny8JIuV4H5cRzgoXcFxiZH1gSRCynMQppC+a0UOLXp02za
 pAzg==
X-Gm-Message-State: AOAM533EGQdKz0H/zQkopCC7CmUak8pcFiUUKyNNizSFjJemdp0gYJoR
 z4jOGknEJvFSWuTp+j7i8Pfa2DnwvH6YevJKoxJm7gPFMcMNOvrGNPlqkYZJFw2LY7sRN4nQPBD
 gdDzKWLYMIdRIv0q8nEe20dt5
X-Received: by 2002:a17:90a:6903:b0:1c6:492:7cad with SMTP id
 r3-20020a17090a690300b001c604927cadmr8971459pjj.241.1647420579957; 
 Wed, 16 Mar 2022 01:49:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfu8xjnOwLJ2DUAYIdjwL8+oeBFXOUhILAgGJ8izXd1dK+cnJhjNgDsFw8fcJAqon+h3ZuZQ==
X-Received: by 2002:a17:90a:6903:b0:1c6:492:7cad with SMTP id
 r3-20020a17090a690300b001c604927cadmr8971439pjj.241.1647420579692; 
 Wed, 16 Mar 2022 01:49:39 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.128])
 by smtp.gmail.com with ESMTPSA id
 ca9-20020a17090af30900b001c658fd7b47sm1716181pjb.36.2022.03.16.01.49.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Mar 2022 01:49:39 -0700 (PDT)
Date: Wed, 16 Mar 2022 16:49:31 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 18/26] KVM: x86/mmu: Zap collapsible SPTEs at all
 levels in the shadow MMU
Message-ID: <YjGkmwBIwe64TjqA@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-19-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-19-dmatlack@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=peterx@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Fri, Mar 11, 2022 at 12:25:20AM +0000, David Matlack wrote:
> Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU (i.e.
> in the rmap). This is fine for now KVM never creates intermediate huge
> pages during dirty logging, i.e. a 1GiB page is never partially split to
> a 2MiB page.
> 
> However, this will stop being true once the shadow MMU participates in
> eager page splitting, which can in fact leave behind partially split
> huge pages. In preparation for that change, change the shadow MMU to
> iterate over all necessary levels when zapping collapsible SPTEs.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 89a7a8d7a632..2032be3edd71 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6142,18 +6142,30 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  	return need_tlb_flush;
>  }
>  
> +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> +					   const struct kvm_memory_slot *slot)
> +{
> +	bool flush;
> +
> +	/*
> +	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
> +	 * pages that are already mapped at the maximum possible level.
> +	 */
> +	flush = slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> +				  PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
> +				  true);
> +
> +	if (flush)
> +		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +
> +}

Reviewed-by: Peter Xu <peterx@redhat.com>

IMHO it looks cleaner to write it in the old way (drop the flush var).
Maybe even unwrap the helper?

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
