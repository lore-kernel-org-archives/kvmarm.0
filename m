Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48916C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 20:30:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B35B349E08;
	Fri, 18 Mar 2022 16:30:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eGA5lh2Wwww8; Fri, 18 Mar 2022 16:30:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F06949E22;
	Fri, 18 Mar 2022 16:30:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E725D41021
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 16:30:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 68dspCL6zvPE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 16:30:12 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D54CA40FD8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 16:30:12 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id
 mr5-20020a17090b238500b001c67366ae93so6789025pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 13:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=FVCHk1zWp8eim4nBsqqeQ8iwNhZBw4mfvm+aRrnbvoA=;
 b=iqJUrhPvONHqeiD0TBwXhkitap6OTovnZpAfQnfp6kB5hRpeTIelZGlr4XPv2BSaDe
 F91q+xGy7zfxGupIh8ZlD9PgT0UoPa9vStN4hS3tqGZ2PtMxXxrtD6l14WfES41GQaPs
 in7Rk0MKkvD47TDUKXc2cERmULhBGrC0kc4hXCucq6dU/qShK3dq9RPvq986fjtGFK49
 6IkwDMe6sY/xERF0y5ZTBB49FAhaXTuVzWZaDE5rqtJjQwLPsod+X6fPCiz32u1/8k2W
 DPmxigueJtLWe08qUNe9VFVuTFDpxPLTBN7r7tr4FsUwApgh+pC2vrBwFrd0/OYtNQoT
 fTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=FVCHk1zWp8eim4nBsqqeQ8iwNhZBw4mfvm+aRrnbvoA=;
 b=U19WK9bLsMIfRpaAV1pTtDAFSLjyN8xCjrXeHsm31eughed7C1z4oMyekx+ghPsTLN
 FSp0PzDbjKy+QQgVM8KucLnD2dQHNuDXoPM0wHTG4wI6LPLsXaK8J3RWWIoOrZxGZwQi
 sEWfcfUmk22e+uVEhFUEWn3L2cz1al9OTVEVMUC5V6Jd5sSkA5LXqqkSG/BLRMr6TYXM
 3/tWHYZG+E26V8VFzJP5zWs0O2xUvtkBl7aczfw24Sr5KpbKBBalRMCPPBNsteNG2oRg
 2SPuRp3ST+2CngOGVjIVC7B/+zXYq51veTc2aTkzNxDWdFqzIo3VvDM9X+j9HM6YXhV7
 rkCQ==
X-Gm-Message-State: AOAM530xvN8TRGavl0F0mCyXkxvSXGpYv8cf3uP40/02dDGGQYEwvY7r
 AGZBIFMrtcckCNSo+laLJ2DQUw==
X-Google-Smtp-Source: ABdhPJzcO6Xwud7tPt4mS4MdVcpJlHQFaYSkJVhqhN/l8RGRASuCh9nddyYC3yiPE7Ss3+zKbGuK9Q==
X-Received: by 2002:a17:90b:3b50:b0:1c6:66d3:94d9 with SMTP id
 ot16-20020a17090b3b5000b001c666d394d9mr13183319pjb.140.1647635411717; 
 Fri, 18 Mar 2022 13:30:11 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 m7-20020a056a00080700b004f6ff260c9dsm11016119pfk.154.2022.03.18.13.30.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 13:30:11 -0700 (PDT)
Date: Fri, 18 Mar 2022 13:30:07 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 02/11] KVM: selftests: Add vm_mem_region_get_src_fd
 library function
Message-ID: <YjTrz40SD3HmebBh@google.com>
References: <20220311060207.2438667-1-ricarkol@google.com>
 <20220311060207.2438667-3-ricarkol@google.com>
 <CANgfPd_iRBDX=mtBy80G0R9U-BfukLV0H3SyrBr+jvK1e8BRvA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd_iRBDX=mtBy80G0R9U-BfukLV0H3SyrBr+jvK1e8BRvA@mail.gmail.com>
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

On Wed, Mar 16, 2022 at 12:08:23PM -0600, Ben Gardon wrote:
> On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add a library function to get the backing source FD of a memslot.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> 
> This appears to be dead code as of this commit, would recommend
> merging it into the commit in which it's actually used.

I was trying to separate lib changes (which are mostly arch independent)
with the actual test. Would move the commit to be right before the one
that uses be better? and maybe add a commit comment mentioning how it's
going to be used.

> 
> > ---
> >  .../selftests/kvm/include/kvm_util_base.h     |  1 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
> >  2 files changed, 24 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 4ed6aa049a91..d6acec0858c0 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -163,6 +163,7 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
> >  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
> >  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
> >  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
> > +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
> >  void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
> >  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
> >  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index d8cf851ab119..64ef245b73de 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -580,6 +580,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
> >         return &region->region;
> >  }
> >
> > +/*
> > + * KVM Userspace Memory Get Backing Source FD
> > + *
> > + * Input Args:
> > + *   vm - Virtual Machine
> > + *   memslot - KVM memory slot ID
> > + *
> > + * Output Args: None
> > + *
> > + * Return:
> > + *   Backing source file descriptor, -1 if the memslot is an anonymous region.
> > + *
> > + * Returns the backing source fd of a memslot, so tests can use it to punch
> > + * holes, or to setup permissions.
> > + */
> > +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
> > +{
> > +       struct userspace_mem_region *region;
> > +
> > +       region = memslot2region(vm, memslot);
> > +       return region->fd;
> > +}
> > +
> >  /*
> >   * VCPU Find
> >   *
> > --
> > 2.35.1.723.g4982287a31-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
