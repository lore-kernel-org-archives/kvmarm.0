Return-Path: <SRS0=VGwd=LQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19DBC2B9F4
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 10:57:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53C0961351
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 10:57:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53C0961351
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C58CC40413;
	Tue, 22 Jun 2021 06:57:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TuuJn7pP36xy; Tue, 22 Jun 2021 06:57:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FD5540573;
	Tue, 22 Jun 2021 06:57:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1494402C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 06:57:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DGT4X9xcjYkb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jun 2021 06:57:14 -0400 (EDT)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com
 [209.85.167.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C79240191
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 06:57:14 -0400 (EDT)
Received: by mail-oi1-f170.google.com with SMTP id u11so23281531oiv.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 03:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=HnUuefF6pQt/5KIq6n+0n8uuy3Ij0ViBdDnbo/wnUBQ=;
 b=v2iGUHfXJmUEDSMyQJPjBTsxpCniaCK4XEaVIHbLtw0MOLxkmtcrwd8Nf8TGNr9eU3
 yKo3eLVqj7x3+LuDTbPN7oJTYuje3aTHLcu2MOsCoZvrrTZKh6WkGYsGp2deZuzNs5Dl
 D+S6Gn6stNcXDegcJlErLCyQIn0UT8GI7vtF3KekwYwrmoi7pJvgh7TNSVfHdSbNhdXI
 qFjpbB2N6hNqWwXzXReTFa87IHkQrfTy73f91u7HNx0r6UGEfI4ikszxmmBH37mvhvV/
 5KzQO/6J5WpjlQ6SmjokgnG4vV7aw8mEytCI9ifoflnOyk1tMqgFIy0QNJ9UKjd3ZbEc
 HhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=HnUuefF6pQt/5KIq6n+0n8uuy3Ij0ViBdDnbo/wnUBQ=;
 b=l6CEglVIxdKYD7b14tNpVEU6H6Co9x8gD9rSZyUfNA4TX0KcT+DKaJTFPtK1h+I8q6
 RcpM0nY7Y5cCvab9Di76PzmqublAc05KPBKp+DTPpNvkvGkL6+fQhPF3ZkaT1aUTvQFn
 JQnnOxImRO7e2vZnPRB9u1ozGd1iMt+XiyyhczYRIR5x2PIWdqbYLMjG4kmF/KDJbe2r
 1PdKKhwjxh1QnqM4oNNzZ5tJsE0nJyc/oxrgxKmpEZ1dx6CAs+JSyE9zI9xNRuBWTY/4
 ufN/1k2ItaXrWNPK4xkCJaD3nllX+LZuQtFRCh8VCz31K4Tdqc/Nog40M14/FCOFV1Ng
 12fw==
X-Gm-Message-State: AOAM532mDgu3fyvkgTFzSPCDtMTcmKqOgk8e5ujSbEn/jCVDg21HjsIZ
 ld4ixiuaKZFNuqHrcBJsrCWxiA12iKn+HeQTJ7IYBg==
X-Google-Smtp-Source: ABdhPJzDc1X7iIOGSMjc4ltvXLq3EcfZ4hStQ7IHZaNwCEuG3WuoK0wf2exQLr0OAvu+BjQIixbqJmuByA8fdy/G8qQ=
X-Received: by 2002:aca:de07:: with SMTP id v7mr2542559oig.8.1624359433329;
 Tue, 22 Jun 2021 03:57:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210621111716.37157-1-steven.price@arm.com>
 <20210621111716.37157-6-steven.price@arm.com>
 <CA+EHjTx7_atkNMqrUkHr0mM2xDbzBafip3s0JhGrGzsX9N08XQ@mail.gmail.com>
 <875yy6ci20.wl-maz@kernel.org>
In-Reply-To: <875yy6ci20.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jun 2021 11:56:37 +0100
Message-ID: <CA+EHjTx18kLHLjZ0Zd2gpR35N5q0oENkbEtnnzdWxZZF-gMy4w@mail.gmail.com>
Subject: Re: [PATCH v17 5/6] KVM: arm64: ioctl to fetch/store tags in a guest
To: Marc Zyngier <maz@kernel.org>
Cc: Juan Quintela <quintela@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
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

Hi Marc,

On Tue, Jun 22, 2021 at 11:25 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Tue, 22 Jun 2021 09:56:22 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi,
> >
> >
> > On Mon, Jun 21, 2021 at 12:18 PM Steven Price <steven.price@arm.com> wrote:
> > >
> > > The VMM may not wish to have it's own mapping of guest memory mapped
> > > with PROT_MTE because this causes problems if the VMM has tag checking
> > > enabled (the guest controls the tags in physical RAM and it's unlikely
> > > the tags are correct for the VMM).
> > >
> > > Instead add a new ioctl which allows the VMM to easily read/write the
> > > tags from guest memory, allowing the VMM's mapping to be non-PROT_MTE
> > > while the VMM can still read/write the tags for the purpose of
> > > migration.
> > >
> > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h |  3 ++
> > >  arch/arm64/include/asm/mte-def.h  |  1 +
> > >  arch/arm64/include/uapi/asm/kvm.h | 11 +++++
> > >  arch/arm64/kvm/arm.c              |  7 +++
> > >  arch/arm64/kvm/guest.c            | 82 +++++++++++++++++++++++++++++++
> > >  include/uapi/linux/kvm.h          |  1 +
> > >  6 files changed, 105 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 309e36cc1b42..6a2ac4636d42 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -729,6 +729,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> > >  int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
> > >                                struct kvm_device_attr *attr);
> > >
> > > +long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> > > +                               struct kvm_arm_copy_mte_tags *copy_tags);
> > > +
> > >  /* Guest/host FPSIMD coordination helpers */
> > >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> > >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > > diff --git a/arch/arm64/include/asm/mte-def.h b/arch/arm64/include/asm/mte-def.h
> > > index cf241b0f0a42..626d359b396e 100644
> > > --- a/arch/arm64/include/asm/mte-def.h
> > > +++ b/arch/arm64/include/asm/mte-def.h
> > > @@ -7,6 +7,7 @@
> > >
> > >  #define MTE_GRANULE_SIZE       UL(16)
> > >  #define MTE_GRANULE_MASK       (~(MTE_GRANULE_SIZE - 1))
> > > +#define MTE_GRANULES_PER_PAGE  (PAGE_SIZE / MTE_GRANULE_SIZE)
> > >  #define MTE_TAG_SHIFT          56
> > >  #define MTE_TAG_SIZE           4
> > >  #define MTE_TAG_MASK           GENMASK((MTE_TAG_SHIFT + (MTE_TAG_SIZE - 1)), MTE_TAG_SHIFT)
> > > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > > index 24223adae150..b3edde68bc3e 100644
> > > --- a/arch/arm64/include/uapi/asm/kvm.h
> > > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > > @@ -184,6 +184,17 @@ struct kvm_vcpu_events {
> > >         __u32 reserved[12];
> > >  };
> > >
> > > +struct kvm_arm_copy_mte_tags {
> > > +       __u64 guest_ipa;
> > > +       __u64 length;
> > > +       void __user *addr;
> > > +       __u64 flags;
> > > +       __u64 reserved[2];
> > > +};
> > > +
> > > +#define KVM_ARM_TAGS_TO_GUEST          0
> > > +#define KVM_ARM_TAGS_FROM_GUEST                1
> > > +
> > >  /* If you need to interpret the index values, here is the key: */
> > >  #define KVM_REG_ARM_COPROC_MASK                0x000000000FFF0000
> > >  #define KVM_REG_ARM_COPROC_SHIFT       16
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 28ce26a68f09..511f3716fe33 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -1359,6 +1359,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
> > >
> > >                 return 0;
> > >         }
> > > +       case KVM_ARM_MTE_COPY_TAGS: {
> > > +               struct kvm_arm_copy_mte_tags copy_tags;
> > > +
> > > +               if (copy_from_user(&copy_tags, argp, sizeof(copy_tags)))
> > > +                       return -EFAULT;
> > > +               return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
> > > +       }
> > >         default:
> > >                 return -EINVAL;
> > >         }
> > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > index 5cb4a1cd5603..4ddb20017b2f 100644
> > > --- a/arch/arm64/kvm/guest.c
> > > +++ b/arch/arm64/kvm/guest.c
> > > @@ -995,3 +995,85 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
> > >
> > >         return ret;
> > >  }
> > > +
> > > +long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> > > +                               struct kvm_arm_copy_mte_tags *copy_tags)
> > > +{
> > > +       gpa_t guest_ipa = copy_tags->guest_ipa;
> > > +       size_t length = copy_tags->length;
> > > +       void __user *tags = copy_tags->addr;
> > > +       gpa_t gfn;
> > > +       bool write = !(copy_tags->flags & KVM_ARM_TAGS_FROM_GUEST);
> > > +       int ret = 0;
> > > +
> > > +       if (!kvm_has_mte(kvm))
> > > +               return -EINVAL;
> > > +
> > > +       if (copy_tags->reserved[0] || copy_tags->reserved[1])
> > > +               return -EINVAL;
> > > +
> > > +       if (copy_tags->flags & ~KVM_ARM_TAGS_FROM_GUEST)
> > > +               return -EINVAL;
> > > +
> > > +       if (length & ~PAGE_MASK || guest_ipa & ~PAGE_MASK)
> > > +               return -EINVAL;
> > > +
> > > +       gfn = gpa_to_gfn(guest_ipa);
> > > +
> > > +       mutex_lock(&kvm->slots_lock);
> > > +
> > > +       while (length > 0) {
> > > +               kvm_pfn_t pfn = gfn_to_pfn_prot(kvm, gfn, write, NULL);
> > > +               void *maddr;
> > > +               unsigned long num_tags;
> > > +               struct page *page;
> > > +
> > > +               if (is_error_noslot_pfn(pfn)) {
> > > +                       ret = -EFAULT;
> > > +                       goto out;
> > > +               }
> > > +
> > > +               page = pfn_to_online_page(pfn);
> > > +               if (!page) {
> > > +                       /* Reject ZONE_DEVICE memory */
> > > +                       ret = -EFAULT;
> > > +                       goto out;
> > > +               }
> > > +               maddr = page_address(page);
> > > +
> > > +               if (!write) {
> > > +                       if (test_bit(PG_mte_tagged, &page->flags))
> > > +                               num_tags = mte_copy_tags_to_user(tags, maddr,
> > > +                                                       MTE_GRANULES_PER_PAGE);
> > > +                       else
> > > +                               /* No tags in memory, so write zeros */
> > > +                               num_tags = MTE_GRANULES_PER_PAGE -
> > > +                                       clear_user(tags, MTE_GRANULES_PER_PAGE);
> > > +                       kvm_release_pfn_clean(pfn);
> > > +               } else {
> > > +                       num_tags = mte_copy_tags_from_user(maddr, tags,
> > > +                                                       MTE_GRANULES_PER_PAGE);
> > > +                       kvm_release_pfn_dirty(pfn);
> > > +               }
> > > +
> > > +               if (num_tags != MTE_GRANULES_PER_PAGE) {
> > > +                       ret = -EFAULT;
> > > +                       goto out;
> > > +               }
> > > +
> > > +               /* Set the flag after checking the write completed fully */
> > > +               if (write)
> > > +                       set_bit(PG_mte_tagged, &page->flags);
> > > +
> > > +               gfn++;
> > > +               tags += num_tags;
> > > +               length -= PAGE_SIZE;
> > > +       }
> > > +
> > > +out:
> > > +       mutex_unlock(&kvm->slots_lock);
> > > +       /* If some data has been copied report the number of bytes copied */
> > > +       if (length != copy_tags->length)
> > > +               return copy_tags->length - length;
> >
> > I'm not sure if this is actually an issue, but a couple of comments on
> > the return value if there is an error after a partial copy has been
> > done. If mte_copy_tags_to_user or mte_copy_tags_from_user don't return
> > MTE_GRANULES_PER_PAGE, then the check for num_tags would fail, but
> > some of the tags would have been copied, which wouldn't be reflected
> > in length. That said, on a write the tagged bit wouldn't be set, and
> > on read then the return value would be conservative, but not
> > incorrect.
> >
> > That said, even though it is described that way in the documentation
> > (rather deep in the description though), it might be confusing to
> > return a non-negative value on an error. The other kvm ioctl I could
> > find that does something similar, KVM_S390_GET_IRQ_STATE, seems to
> > always return a -ERROR on error, rather than the number of bytes
> > copied.
>
> My mental analogy for this ioctl is the read()/write() syscalls, which
> return the number of bytes that have been transferred in either
> direction.
>
> I agree that there are some corner cases (a tag copy that fails
> because of a faulty page adjacent to a valid page will still report
> some degree of success), but it is also important to report what has
> actually been done in either direction.

read()/write() return an error (-1) and not the amount copied if there
is an actual error I believe:

https://man7.org/linux/man-pages/man2/read.2.html

> It is not an error if this number is smaller than the number of
> bytes requested; this may happen for example because fewer bytes
> are actually available right now (maybe because we were close to
> end-of-file, or because we are reading from a pipe, or from a
> terminal), or because read() was interrupted by a signal.
>
> On error, -1 is returned, and errno is set to indicate the error.
> In this case, it is left unspecified whether the file position
> (if any) changes.

I think that for the current return value, then it would be good for
the documentation in patch 6/6 to be more explicit. There it says:

> :Returns: number of bytes copied, < 0 on error (-EINVAL for incorrect
>           arguments, -EFAULT if memory cannot be accessed).

Later on it does state that if an error happens after some copying has
been done, it returns the number copied. But that's at the end of the
section. I think it would be less confusing to have it in the summary
(with the "Returns").

Thanks,
/fuad






> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
