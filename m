Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBE5C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 09:28:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3F9A49F58;
	Thu, 17 Mar 2022 05:28:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nUxhd7w386Wr; Thu, 17 Mar 2022 05:28:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E61514A417;
	Thu, 17 Mar 2022 05:28:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FD2A404B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 14:08:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2l2wWeWMbBSx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 14:08:35 -0400 (EDT)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com
 [209.85.128.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22A9C402A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 14:08:34 -0400 (EDT)
Received: by mail-yw1-f178.google.com with SMTP id
 00721157ae682-2d07ae0b1c4so32455287b3.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 11:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=3CDjfOL4XFTPKtqkiMbluAfDpGLLRX/OLiG6A0cIlYo=;
 b=hExUsyci03m5zCmQTtzwqNbi3CA3fC0gMNnhcGQdonXMlNIbl4bgAgKnIUpYUrjCc7
 xIbiBH+T4/jr8APBvlkTpLWt0hBd7IjhkDZQSOM3GL0AEHXWOw7xfr/iCAk10ANXl4mO
 sorBYvHdq3G+xzlYmVaoVyE3LCLUN2q0mn/3CCUl9eddB+QwsGD8mIgGhCRlpilm9Nj1
 8cNvAuKoTKvKldjxZgITbTtauRs5g+pLfgDLrwU7OqeeuptXG1/m04e3+yS24y7cQ3X4
 eHV1ISKFEac0LgYamNGi83NBHcYRi0oGLWrbmINJV2Xk5Di24z2B2tj95dldAyeAz/Jf
 +oLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3CDjfOL4XFTPKtqkiMbluAfDpGLLRX/OLiG6A0cIlYo=;
 b=GF1mp5T/NmwrtnwMzeBB6GBy60vbH6t15+7XQ454U76AViOX60hWJjf9UBeni4h/hI
 Pstpo89fPVi0MuHlNqoMC5is6UNUQ0HsblSGJ/Kdw4ae2EOU3jflBE8X72iXHvxF2uVB
 Ic7NZJrpULjoGkRwc7rYlnyPRsTGyVLkBpCBzr3ezWGGrGN2V5pzeQqWasXI8EJ0UnH5
 7Jo1CD4VzGqb6Gc+Ur1wjHfxqAjckVbj4F8scrGCF5Pm6lu615wJBxD3MRiaypbDgg5Q
 3LeeSJ6dFOF09O1Y5MIAkKnrk48xd9N8vYF/6BNklzAhjBnQIPtOWSqBjWtKllvOxWy0
 039A==
X-Gm-Message-State: AOAM533LhKHKaiohl56XlnaWeeBNsKVHRnxXVQc/3DEt/JbyNfSzbxJs
 nxkJP2hp8EpN8soR56jB+JuaAml4Tfvb7MMz0WGCFw==
X-Google-Smtp-Source: ABdhPJyDTOAGXwtrebGZcXucTwsLsj1Q/imZHVIr0HVDQ+3kr7CTR5NCgMAPcperilieXGykzEPRF8KMiwEtvNQRIpE=
X-Received: by 2002:a81:53c2:0:b0:2dc:3600:7db3 with SMTP id
 h185-20020a8153c2000000b002dc36007db3mr1455805ywb.23.1647454114295; Wed, 16
 Mar 2022 11:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
 <20220311060207.2438667-3-ricarkol@google.com>
In-Reply-To: <20220311060207.2438667-3-ricarkol@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 16 Mar 2022 12:08:23 -0600
Message-ID: <CANgfPd_iRBDX=mtBy80G0R9U-BfukLV0H3SyrBr+jvK1e8BRvA@mail.gmail.com>
Subject: Re: [PATCH 02/11] KVM: selftests: Add vm_mem_region_get_src_fd
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
> Add a library function to get the backing source FD of a memslot.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

This appears to be dead code as of this commit, would recommend
merging it into the commit in which it's actually used.

> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
>  2 files changed, 24 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 4ed6aa049a91..d6acec0858c0 100644
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
> index d8cf851ab119..64ef245b73de 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -580,6 +580,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>         return &region->region;
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
> +       struct userspace_mem_region *region;
> +
> +       region = memslot2region(vm, memslot);
> +       return region->fd;
> +}
> +
>  /*
>   * VCPU Find
>   *
> --
> 2.35.1.723.g4982287a31-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
