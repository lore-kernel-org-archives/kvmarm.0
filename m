Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A50C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 04:08:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F87D4B35A;
	Thu, 19 May 2022 00:08:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D5cMHTX-wYAF; Thu, 19 May 2022 00:08:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 658484B349;
	Thu, 19 May 2022 00:08:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 125EE4B30E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 00:08:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RyvyNdmMffoo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 00:08:05 -0400 (EDT)
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com
 [209.85.166.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7E014B2F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 00:08:05 -0400 (EDT)
Received: by mail-il1-f169.google.com with SMTP id b11so2880089ilr.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 21:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Nj5KQVd1OJhKMBpI3dKx9i9Ki3E8QExPEDMYs5rR530=;
 b=lIuNT0ZnKxDSdc8oh2ofVYr3MkW4rvDsYQ2WDauejIdhLe7yO/d8AaIqtn4aRLZhLT
 RnqEJnJ5s9Bq8QaMofige9b1LT6saZbZ+xWQIY1jwq2axFrj6ZYB3r+N//+PSCXAmVg2
 uzsxOEnpHwB/0eqwa9+5hlH1Hmbn1M1r8ZDmU7Awf7omJOn7Fjjcs7m+pwHGAn2xWOSX
 UlQPK9+Nuus4orOH/ICQG0W8SRRTowAprKCHu9QnNACI49grXur0wwC/l5N7l3hy2K6P
 VTBtMAR6NPs5Njsir7jgMQPMJLDN/6Vt2DxgDBMu6wvkBiUu58PBP6e/l2Y9CrhmQsFf
 mhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Nj5KQVd1OJhKMBpI3dKx9i9Ki3E8QExPEDMYs5rR530=;
 b=2wY2LskyTeNbC/AQWRn4SyS0pKB1HN63e+h+9eniA1ovDbYHql1mhEivBwb4Ca3fxA
 PIV4lNYjnOcokkwsDMXoU5j1Bcp/3XUIGG0X+lJfGP5fejdxfsrBUKm54UcnWbZldmqB
 H7R5mDB/vfYvJvuOuDbXe8t+xrb2f4dw2QbBogpTUBdSJ3qCPJcy5XGO+c/JhBsrVT8j
 ywaswTNwNOobxmfUCcAqK7hw2cvtSvNr3GAC2b8v0S82fl2XwppCcKw5nNcfpG7ytKS0
 pHdsmRHwhtdf/j6KZ2uZLdrlMNjivQZ7fKq5CKDmrIKBsZJ+W+amPhIF5ftOQ8Vdh7dI
 KdKg==
X-Gm-Message-State: AOAM532XAJBReW9eApgqxeZJsOS6mQ6d2jILJr8eyNi+s9ZzEyGuChin
 DD8Lo/5DerNYotsucqgvtkXNdQ==
X-Google-Smtp-Source: ABdhPJzIGKt84nooOm9oNb8M4+11sa6pQyYAJzvAey2phxzjoWvC1jbMONVKJmqypKPkNRwqm5VM7A==
X-Received: by 2002:a05:6e02:216a:b0:2d1:3b03:e77b with SMTP id
 s10-20020a056e02216a00b002d13b03e77bmr1675875ilv.148.1652933284839; 
 Wed, 18 May 2022 21:08:04 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 l7-20020a023907000000b0032e0851ea0fsm382180jaa.10.2022.05.18.21.08.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 21:08:04 -0700 (PDT)
Date: Thu, 19 May 2022 04:08:00 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 06/13] KVM: selftests: Add vm_mem_region_get_src_fd
 library function
Message-ID: <YoXCoGyg8Gje+FB5@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-7-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-7-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Apr 07, 2022 at 05:41:13PM -0700, Ricardo Koller wrote:
> Add a library function to get the backing source FD of a memslot.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 3a69b35e37cc..c8dce12a9a52 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -163,6 +163,7 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
>  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
>  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
>  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
> +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
>  void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
>  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 268ad3d75fe2..a0a9cd575fac 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -580,6 +580,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>  	return &region->region;
>  }
>  
> +/*
> + * KVM Userspace Memory Get Backing Source FD
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   memslot - KVM memory slot ID
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   Backing source file descriptor, -1 if the memslot is an anonymous region.
> + *
> + * Returns the backing source fd of a memslot, so tests can use it to punch
> + * holes, or to setup permissions.
> + */
> +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
> +{
> +	struct userspace_mem_region *region;
> +
> +	region = memslot2region(vm, memslot);
> +	return region->fd;
> +}
> +
>  /*
>   * VCPU Find
>   *
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
