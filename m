Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09772C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7BB04A0FE;
	Wed, 23 Mar 2022 05:57:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bwa1vAM1yiPS; Wed, 23 Mar 2022 05:57:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BFC24B08E;
	Wed, 23 Mar 2022 05:57:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33AEB49F19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:30:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wXeb6rjqcPfI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 18:30:42 -0400 (EDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com
 [209.85.208.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C91849EE1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:30:41 -0400 (EDT)
Received: by mail-lj1-f179.google.com with SMTP id h11so25920065ljb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 15:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6C0VjdCibQefdFArpO2DUnsXQA3a5kOhFYGWARoK0ng=;
 b=MtxBqgU4fKDJGR32yDNgrmZJHVZ9bb2nYLZL1tpRrFZwetiJIn2bt+LK4GS5a9FE5z
 VSPQClN4wmv6t2ZS3+SThHgq+PTzoGZq9WwphTds4WaaDJdV9wLjRQpgZHXFo04LFK45
 DbaKwmn1MdC1W7oub9gJLVmt5D8P4MEz1fP9/LgQ/6jSqje2aE9tMYh2pUN8eBLuP7qB
 udL4gP5YkOBOuV/Q88HWPp0T5BcfMPOLoR6L4dUQPfvZn57wp9e+uFder/QNBPdTndt+
 VeiKQCAW7TVguWPR+wPjehqbqxcuqPr3qQWGhkmcTKwqPIpCQL2ZKGEShVUUNvzQVTAa
 ri3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6C0VjdCibQefdFArpO2DUnsXQA3a5kOhFYGWARoK0ng=;
 b=YvPLo5fAqzMa192esbx5kLta6jScN34ZrVvLggUXKb2rkj23DHBMHmPMawCXFS+ObD
 hJrcRSnb+ZCjeIbGMg20KBmoR3vRfdU8GWBjRzfm93Tqjd5SgujnNaL9mEeuRdygZ253
 G1M/D4PvaJmdeGYhkOzDzqUYQ/U1mY3uGC9j+QcBfnsS6jQ+0hwf2mzo1sCjmgVn3a9e
 +93KlvN9Q/x+dr4uGSs4TmXKeCfq2QCKyZQLLg0OysQiSmbGRgZSX481kskfor4+pNz5
 LIXahHGWRiyQtUy7mY28/zKjMb26PWDJJKaAQ7nihnrGofRjQel2BOoxpFFuevyeId27
 pDTw==
X-Gm-Message-State: AOAM5323qLnsgOLm1v/DTtX6iIQU+8zjEe4tMd9zWHW0bjn5dFcX0B7q
 q+M3XHlqjEfDtvKONqC5Y5vr7yuuUAAaEWLssJUGlQ==
X-Google-Smtp-Source: ABdhPJzVn7Ue1RCjw9fF5Wh1a2QmXc4MY9QvN0TqD0+X9MMkibqMAaH0yMU5CoBRsExNt7Oq9j3MqODGm4HDDa8jxEw=
X-Received: by 2002:a2e:9119:0:b0:247:e306:1379 with SMTP id
 m25-20020a2e9119000000b00247e3061379mr20387823ljg.361.1647988240437; Tue, 22
 Mar 2022 15:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-9-dmatlack@google.com>
 <YjBkm8mYKNc5sdpU@xz-m1.local>
In-Reply-To: <YjBkm8mYKNc5sdpU@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 15:30:14 -0700
Message-ID: <CALzav=d82wAqcLQdGOfS7r95SSG3g=yKcY1hRc3fziZfNSHpzg@mail.gmail.com>
Subject: Re: [PATCH v2 08/26] KVM: x86/mmu: Link spt to sp during allocation
To: Peter Xu <peterx@redhat.com>
X-Mailman-Approved-At: Wed, 23 Mar 2022 05:57:13 -0400
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
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
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

On Tue, Mar 15, 2022 at 3:04 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:10AM +0000, David Matlack wrote:
> > Link the shadow page table to the sp (via set_page_private()) during
> > allocation rather than initialization. This is a more logical place to
> > do it because allocation time is also where we do the reverse link
> > (setting sp->spt).
> >
> > This creates one extra call to set_page_private(), but having multiple
> > calls to set_page_private() is unavoidable anyway. We either do
> > set_page_private() during allocation, which requires 1 per allocation
> > function, or we do it during initialization, which requires 1 per
> > initialization function.
> >
> > No functional change intended.
> >
> > Suggested-by: Ben Gardon <bgardon@google.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Ah I should have read one more patch before commenting in previous one..
>
> Personally I (a little bit) like the other way around, since if with this
> in mind ideally we should also keep the use_mmu_page accounting in
> allocation helper:
>
>   kvm_mod_used_mmu_pages(vcpu->kvm, 1);

The TDP MMU doesn't call kvm_mod_used_mmu_pages() when it allocates
SPs. So that would prevent sharing kvm_mmu_alloc_shadow_page() with
the TDP MMU in patch 11.

Ben pointed out that we link the the page to sp->spt during
allocation, so it makes sense to do the reverse link at the same time.
Also, the set_page_private() call is common between the TDP MMU and
shadow MMU, so it makes sense to do it in the SP allocation code since
the allocation functions are shared between the two MMUs.





>
> But then we dup yet another line to all elsewheres as long as sp allocated.
>
> IOW, in my opinion the helpers should service 1st on code deduplications
> rather than else.  No strong opinion though..



>
> Thanks,
>
> --
> Peter Xu
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
