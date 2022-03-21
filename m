Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C636C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Mar 2022 19:33:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD438405C6;
	Mon, 21 Mar 2022 15:33:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0OL68yBXK6Sc; Mon, 21 Mar 2022 15:33:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C84A49E49;
	Mon, 21 Mar 2022 15:33:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C3C341173
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 13:01:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OR3xlMhQwu-y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2022 13:01:51 -0400 (EDT)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com
 [209.85.128.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68872411BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 13:01:51 -0400 (EDT)
Received: by mail-yw1-f180.google.com with SMTP id
 00721157ae682-2e612af95e3so51478367b3.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 10:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6+wORUoNfICBtxmGPwtdgPTUaJLcSyMgmBDuQ2HCAno=;
 b=IeyG5ExpMtTqyaIwUHCF/IOH7aYaWYNAr1yot4O1eNYRTzjb0lkspVlKTsPwL8phzi
 606KemObIc7ChoYqhUL65J3/Y9r7y1h4k5p4lK4SxACbwwpL5J/ES2jZbiSTC8zjYxw3
 EjJHOoWPC+LkY8cjfj1HUTqloG6/ygcXnnSvc7+tYlJLuAR9aKDBt6QxDUN7rJsKzBkA
 V7GAGPUS1zBcgASkBCxxTWbXgtTgAzvFW7ylslsR2P3nMwzlolgI3cONVlIyZR9eK4OU
 Zmh2xfrYm+cPLFWBAGWW/TkKsGtop8E0wyCImRneAZEvwYbd4sIcXnEGv0YgIYNYuCOj
 /ppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6+wORUoNfICBtxmGPwtdgPTUaJLcSyMgmBDuQ2HCAno=;
 b=2pBNmgPJmKasODAnxDNjYH9Gqey3dMXym0ETsOzVHEIwwsph8uS3V2+GhwnZfdICgY
 NzZ2fMGDiIXsyhWpPvA1CxtuPQ8aFWnLfaXT5UBfkpF0qI56x/NgQ7TBdrVuJ00CvT5y
 9jaaY9LGpjjadleYvUVg0IeW9RbypGq0lNWcGOS6JlQHQNZrEUkY3K50OyfR6VRlfEg1
 tVpvnyK0XgWNSY674FI58T8JXuBHplwSxUBtcdkJNfbrwR88LJOr+Q+/fuDhv3FbwKRt
 GgVvCQFgy4Nj+qpgq9ZkSN8dAJ6vrfxXvO12Qmh4mr/NXDPg59OGOQytaiF8IZcKy2HA
 F/vw==
X-Gm-Message-State: AOAM533rQYvboIvgMj9Mq11XOCURFhLEnX7XmCFrXGN775SiZg4RuCXF
 C2qW8HRURx1VmHiwMIGxdneP1FsfhkBbk4IjxTsLiA==
X-Google-Smtp-Source: ABdhPJy5WiSeEDwjtsW7VTh7ar42L2Iwd9KZtr8ajbdqynfYg2O5DFVnLDKH95thDtcrPtTUuOYSD5sxkur7ut9Ijts=
X-Received: by 2002:a81:15ce:0:b0:2e5:e189:7366 with SMTP id
 197-20020a8115ce000000b002e5e1897366mr16268503ywv.188.1647882110705; Mon, 21
 Mar 2022 10:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
 <20220311060207.2438667-3-ricarkol@google.com>
 <CANgfPd_iRBDX=mtBy80G0R9U-BfukLV0H3SyrBr+jvK1e8BRvA@mail.gmail.com>
 <YjTrz40SD3HmebBh@google.com>
In-Reply-To: <YjTrz40SD3HmebBh@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Mon, 21 Mar 2022 10:01:39 -0700
Message-ID: <CANgfPd9kbyfkOoBasqMtDuC4SD=j99Y0fMReC8hOHDOYhv5AQQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] KVM: selftests: Add vm_mem_region_get_src_fd
 library function
To: Ricardo Koller <ricarkol@google.com>
X-Mailman-Approved-At: Mon, 21 Mar 2022 15:33:40 -0400
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

On Fri, Mar 18, 2022 at 1:30 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Mar 16, 2022 at 12:08:23PM -0600, Ben Gardon wrote:
> > On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
> > >
> > > Add a library function to get the backing source FD of a memslot.
> > >
> > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> >
> > This appears to be dead code as of this commit, would recommend
> > merging it into the commit in which it's actually used.
>
> I was trying to separate lib changes (which are mostly arch independent)
> with the actual test. Would move the commit to be right before the one
> that uses be better? and maybe add a commit comment mentioning how it's
> going to be used.

Ah, that makes sense, I can see why you'd want to separate them.
Moving it right before the commit where it's used sounds fine to me.
Thanks!

>
>
> >
> > > ---
> > >  .../selftests/kvm/include/kvm_util_base.h     |  1 +
> > >  tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
> > >  2 files changed, 24 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > index 4ed6aa049a91..d6acec0858c0 100644
> > > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > @@ -163,6 +163,7 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
> > >  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
> > >  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
> > >  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
> > > +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
> > >  void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
> > >  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
> > >  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
> > > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > index d8cf851ab119..64ef245b73de 100644
> > > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > @@ -580,6 +580,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
> > >         return &region->region;
> > >  }
> > >
> > > +/*
> > > + * KVM Userspace Memory Get Backing Source FD
> > > + *
> > > + * Input Args:
> > > + *   vm - Virtual Machine
> > > + *   memslot - KVM memory slot ID
> > > + *
> > > + * Output Args: None
> > > + *
> > > + * Return:
> > > + *   Backing source file descriptor, -1 if the memslot is an anonymous region.
> > > + *
> > > + * Returns the backing source fd of a memslot, so tests can use it to punch
> > > + * holes, or to setup permissions.
> > > + */
> > > +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
> > > +{
> > > +       struct userspace_mem_region *region;
> > > +
> > > +       region = memslot2region(vm, memslot);
> > > +       return region->fd;
> > > +}
> > > +
> > >  /*
> > >   * VCPU Find
> > >   *
> > > --
> > > 2.35.1.723.g4982287a31-goog
> > >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
