Return-Path: <SRS0=q2PC=PU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F81C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  1 Nov 2021 17:41:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B977B60EB8
	for <kvmarm@archiver.kernel.org>; Mon,  1 Nov 2021 17:41:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B977B60EB8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E6184B1CF;
	Mon,  1 Nov 2021 13:41:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jOqBn1tBabbx; Mon,  1 Nov 2021 13:41:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 919944B1A2;
	Mon,  1 Nov 2021 13:41:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 492B94B162
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Nov 2021 13:41:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oMDa2TGIcD8g for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Nov 2021 13:41:34 -0400 (EDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D06DB4B15C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Nov 2021 13:41:34 -0400 (EDT)
Received: by mail-pj1-f47.google.com with SMTP id np3so2347947pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Nov 2021 10:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rtTqRA7823rLhhDHR/FeABtCXlD+vQwUZXFhSKbl7nw=;
 b=otcBvN/3IcuDrr15J0K5CvKDj9ic0jccTokbwB/sVPFst2f0LLD/XC7PPmPO9eJXRu
 P2OBNUe1RlpO0zOo26l/3DPAdKxfcfvQY3tyTT+VRt2u50F02VgF8OTA49ToznF2ILGt
 Yy6m85iKMGx1XCrOjugojlIHRrq3kXSGg8wFybO1VALqYGLus50IE17TDpBh8OqfqKK1
 AAKVEsJcdEBK8202Jfb1yydMhJbNy9mJ8dChJ1pRBEEAKk0vwWevUCT/VxYAjLKOhhmx
 ip94OeR4ZQJbCq2qfgBZUaSsgLQoBT6PDF+7fUOqfu8QIWy5qh2RFzJV0Hmhvl6+AMgp
 M0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rtTqRA7823rLhhDHR/FeABtCXlD+vQwUZXFhSKbl7nw=;
 b=Oq0Gv0RWraAeMBr9ccQsGyHeBX4Qmj9u6ADVkZnu7+sG9YULtmp1SNPDDd4s/VQEy2
 LfqNXigHp0whTaXaRftk5iROBkjnYPbRKdv9kSOjKFjz0KA9kgiQvPBUkbiCCfDHWDlL
 pYdtTXLBLdMoK677LHZ187G2BaVsr+oybAefWt8bNMMsjGU2kdVUacFkE4k/RBHblkso
 cdodnYrnTjnOUKMXQRgwwqJdDkfoGKU554IHZfXBpSj5pPNcrcZ24gjkB9m5gEK49QbI
 DDODl27WKjU/fRN0a5quMalBa76WpvZpIkKdqDTjMK88C2DR+jA+BAu+nxY6oN4cQOIU
 ALyQ==
X-Gm-Message-State: AOAM531MAR5i55xMxt6uGKvXeswasbEYABsL6uchesi+EKz8zjzUbfOs
 tIsfFu/SJovq1o7FE58dlMNjIg==
X-Google-Smtp-Source: ABdhPJyQ2rd8AtzfLKSk7pcRIWMkAF0QH30KhY5NHLgIkgccLRDTnxh33KsvfNWVKvhaR3vGZrvloQ==
X-Received: by 2002:a17:90b:3ec6:: with SMTP id
 rm6mr365778pjb.27.1635788493615; 
 Mon, 01 Nov 2021 10:41:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id cv1sm86275pjb.48.2021.11.01.10.41.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 01 Nov 2021 10:41:33 -0700 (PDT)
Date: Mon, 1 Nov 2021 17:41:29 +0000
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 26/43] KVM: VMX: Read Posted Interrupt "control"
 exactly once per loop iteration
Message-ID: <YYAmyUZhmcSntUza@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-27-seanjc@google.com>
 <b078cce30f86672d7d8f8eaa0adc47d24def24e2.camel@redhat.com>
 <YXrH/ZZBOHrWHz4j@google.com>
 <20a17d75855dfb9bd496466fcd9f14baab0b2bda.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20a17d75855dfb9bd496466fcd9f14baab0b2bda.camel@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Nov 01, 2021, Maxim Levitsky wrote:
> On Thu, 2021-10-28 at 15:55 +0000, Sean Christopherson wrote:
> > On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> > > On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > > I wish there was a way to mark fields in a struct, as requiring 'READ_ONCE' on them
> > > so that compiler would complain if this isn't done, or automatically use 'READ_ONCE'
> > > logic.
> > 
> > Hmm, I think you could make an argument that ON and thus the whole "control"
> > word should be volatile.  AFAICT, tagging just "on" as volatile actually works.
> > There's even in a clause in Documentation/process/volatile-considered-harmful.rst
> > that calls this out as a (potentially) legitimate use case.
> > 
> >   - Pointers to data structures in coherent memory which might be modified
> >     by I/O devices can, sometimes, legitimately be volatile.
> > 
> > That said, I think I actually prefer forcing the use of READ_ONCE.  The descriptor
> > requires more protections than what volatile provides, namely that all writes need
> > to be atomic.  So given that volatile alone isn't sufficient, I'd prefer to have
> > the code itself be more self-documenting.
> 
> I took a look at how READ_ONCE/WRITE_ONCE is implemented and indeed they use volatile
> (the comment above __READ_ONCE is worth gold...), so there is a bit of contradiction:
> 
> volatile-considered-harmful.rst states not to mark struct members volatile since
> you usually need more that than (very true often) and yet, I also heard that
> READ_ONCE/WRITE_ONCE is very encouraged to be used to fields that are used in lockless
> algorithms, even when not strictly needed,
> so why not to just mark the field and then use it normally? I guess that
> explicit READ_ONCE/WRITE_ONCE is much more readable/visible that a volatile
> in some header file.

Are you asking about this PI field in particular, or for any field in general?

In this particular case, visibility and documentation is really the only difference,
functionally the result is the same.  But that's also very much related to why this
case gets the exception listed above.  The "use it normally" part is also why I
don't want to tag the field volatile since writing the field absolutely cannot be
done "normally", it must be done atomically, and volatile doesn't capture that
detail.

If you're asking about fields in general, the "volatile is harmful" guideline is
to deter usage of volatile for cases where the field/variable in question is not
intrinsically volatile.  As the docs call out, using volatile in those cases often
leads to worse code generation because the compiler is disallowed from optimizing
accesses that are protected through other mechanisms.

A good example in x86 KVM is the READ_ONCE(sp->unsync) in mmu_try_to_unsync_pages() to
force the compiler to emit a load of sp->unsync after acquiring mmu_unsync_pages_lock.
Tagging "unsync" as volatile is unnecessary since the vast majority of its usage is
protected by holding a spinlock for write, and would prevent optimizing references in
kvm_mmu_get_page() and other flows that are protected by mmu_lock in the legacy MMU.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
