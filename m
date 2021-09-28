Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3EDC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 15:21:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C363E61266
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 15:20:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C363E61266
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3387C4B10B;
	Tue, 28 Sep 2021 11:20:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i-PSgFiPnAcn; Tue, 28 Sep 2021 11:20:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E19AF4B0C5;
	Tue, 28 Sep 2021 11:20:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 826B04A98B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:20:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id edmzu4CjqPxl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 11:20:56 -0400 (EDT)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
 [209.85.215.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 477CE4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:20:56 -0400 (EDT)
Received: by mail-pg1-f176.google.com with SMTP id y186so10188469pgd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 08:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=lwHAIgEq4+Z86k7pIcyJFqJO0ELIjKqg924eVGRn0Ew=;
 b=qDDhUYAovjPxp+JLVPciXG9blp4tRpcL+sFvS6yk4ykWNN1ycgApfJOM2eUcyGR8ej
 ZUHR+UYQ4TfkIQDebIVV3yr5GjT4xd3oshBdb3wjh3orDNI823t+/Y0A5UP1JP2D00Ho
 2t+hMTei3vkoBBDQ2nSDUR+465eyz1ZrNtzKDXAwOAIxixDedIpgnWZE93viQk+4Lj3d
 V6oV3JW1bninbp4XUmP8kNZwFR3Pr1MIx9+qlbXf1f5SYGM6I1JRBxjtQfrqTQFZObMi
 jNbtV65dMX1T11yXFW65Mtr9/UPdl9BMEYV/YEnuR3cOqAbxPexPIFPSBUsKeEMci+u/
 zA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=lwHAIgEq4+Z86k7pIcyJFqJO0ELIjKqg924eVGRn0Ew=;
 b=Snpnff02PJ9nWWX+InJwO3q+JRbrzY1iRhU90ooa+ZBLmVliODm/0TA/yae8sqPpNn
 rs6arRQhNp5gMnTXgeRU9ZrSZrAUTdUaSxekzwJXsLGXEvFWiyN86u39CBsNVZJFuhm0
 bZgH2GFT5+q8KgtwHp8tb92pvfW22fK1GXNSiN20u7IlWz5t9H7s0O93BG9oR5OZAMs1
 RUJofCOb5DDo9LUXRAuGgLZcl6cABGXn/UDBa8uo73aXB8NSEepjtG5elBWppi14hsah
 TzG+cCTt6o8wyWpVlxTxeEBJ3Vfap2fkAntmZ3i1DNUhrj2chDqbQcoxglB0FyjdAOB2
 NOsA==
X-Gm-Message-State: AOAM532ThXjEO0ST0gIj6GecwubBGDAts14IhCJM9bxzASU3ivPoRsKC
 k6eEWFk8NJOewoC3nHQ8kK9I8Q==
X-Google-Smtp-Source: ABdhPJz1+8rpvALog3DRUjd5Q8aGHAUZp7aj1oTqoH/EzuELbFpRF0kFQuRE4VMFljkB69MSIOoyug==
X-Received: by 2002:aa7:953d:0:b0:438:c168:df09 with SMTP id
 c29-20020aa7953d000000b00438c168df09mr5827013pfp.59.1632842454723; 
 Tue, 28 Sep 2021 08:20:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id q11sm2975189pjf.14.2021.09.28.08.20.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 08:20:54 -0700 (PDT)
Date: Tue, 28 Sep 2021 15:20:50 +0000
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
Message-ID: <YVMy0uzfSNrUo+Ur@google.com>
References: <20210923220033.4172362-1-oupton@google.com>
 <YU0XIoeYpfm1Oy0j@google.com>
 <20210924064732.xqv2xjya3pxgmwr2@gator.home>
 <YVIj+gExrHrjlQEm@google.com>
 <20210928072409.ks6b6u3rs7qngije@gator.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210928072409.ks6b6u3rs7qngije@gator.home>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Tue, Sep 28, 2021, Andrew Jones wrote:
> On Mon, Sep 27, 2021 at 08:05:14PM +0000, Sean Christopherson wrote:
> > My vote would be to rework arm64's ucall_init() as a prep patch and drop the param
> > in the process.  There are zero tests that provide a non-NULL value, but that's
> > likely because tests that care deliberately defer ucall_init() until after memory
> > regions and page tables have been configured.
> > 
> > IMO, arm64's approach is unnecessarily complex (that's a common theme for KVM's
> > selftests...).  The code attempts to avoid magic numbers by not hardcoding the MMIO
> > range, but in doing so makes the end result even more magical, e.g. starting at
> > 5/8ths of min(MAX_PA, MAX_VA).
> > 
> > E.g. why not put the ucall MMIO range immediately after the so called "default"
> > memory region added at the end of vm_create()?  That way the location of the ucall
> > range is completely predictable, and while still arbitrary, less magical.
> >
> 
> While we do hardcode zero as the guest physical base address, we don't
> require tests to use DEFAULT_GUEST_PHY_PAGES for slot0. They only get
> that if they use vm_create_default* to create the vm. While trying to
> keep the framework flexible for the unit tests does lead to complexity,
> I think the ucall mmio address really needs to be something that can move.

Rats, I had contradicting information in my reply.  Ignore the part about dropping
the param.  My intended suggestion was to dynamically place the ucall range after
the default region, i.e. it would float around, but the relative location is fixed.

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..0ec2de586bf7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -315,6 +315,8 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
                vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
                                            0, 0, phy_pages, 0);

+       ucall_init(0 + <size of default region>);
+
        return vm;
 }

> It's not part of the test setup, i.e. whatever the unit test wants to
> test, it's just part of the framework. It needs to stay out of the way.

Sort of.  In this specific case, I think it's the tests' responsibility to not
stomp over the ucall region as much as it's the framework's responsibility to not
select a conflicting range.  Arch-agnostic tests _can't_ care about absolute
addresses, and we done messed up if we pick a ucall range that is at all
interesting/unique on arm64.

The problem with the current approach is that it's unnecessarily difficult for
either side to do the right thing.  The framework should not have to search
memory regions, and test writers should be given simple (and documented!) rules
for what memory regions are reserved by the framework.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
