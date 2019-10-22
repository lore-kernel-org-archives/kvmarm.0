Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1821CA9EB7
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 13:59:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 719C921872
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 13:59:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 719C921872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6E294A95D;
	Tue, 22 Oct 2019 09:59:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o2baxMGCJlcK; Tue, 22 Oct 2019 09:59:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83C044A987;
	Tue, 22 Oct 2019 09:59:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 996484A981
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 09:59:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sIDIryZfp1lI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 09:59:28 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60D0B4A95D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 09:59:28 -0400 (EDT)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 4FF92C057F20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 13:59:27 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id z5so4486683wma.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 06:59:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Dlx0qR6qGoizUuI3jCS47jEOZVwYOv8dJ62/TjyH9Xs=;
 b=VzhoNOZ5S54KQgwmRC3dU2aMKeyjeMo9GH/WaLk6dVc1YotepGpGGE41X7mZxtU+6k
 sxCPWhd2AGw55w+l1A+Al3j8RIUXJ6QwfgdhOhrK7AeERX7hAfFA4ivary0rNiCHNvY6
 /Sc8RZCHTj2+5oLwnSQeiy4gbtCi+tlZUwvJA+5AvY1gKMZYN+0MIcA4Xco533kHM4ys
 E2V6l0fk2wh98gsD/ZFqDepYdyWpbIL26Aoean86cRHje5pixT4N7zQyoajZvc/Vrjg0
 E5kqLVoT2Z0UK9psrUGX10Qm77bsJew7/G8SWHNutswV0EbJyg4s6BXO127RfuiFnq5E
 zy9g==
X-Gm-Message-State: APjAAAV+EM3PKwgbhsJ/+rYBVcRA1KSgx07E/gRcX4y7RI5MTAxqgpCj
 ydNSwEbONsdE0ZFWJtVODGHl3eOEuHsNV2gygyZssrTsNF/Vvp88Poxc3Opuk5Db1we7miymeym
 obfE+z8svu7Xes8RucTg7n4rR
X-Received: by 2002:adf:9ec7:: with SMTP id b7mr3690745wrf.221.1571752765741; 
 Tue, 22 Oct 2019 06:59:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzzdoYw58nkYxoG/VDS1/LYhdqcebVxQ/IRP7wL/K4uxfwmYmVxn6Yd5KXoTPuPOxmY6ROAMw==
X-Received: by 2002:adf:9ec7:: with SMTP id b7mr3690694wrf.221.1571752765319; 
 Tue, 22 Oct 2019 06:59:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19?
 ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
 by smtp.gmail.com with ESMTPSA id l14sm2833445wrr.37.2019.10.22.06.59.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Oct 2019 06:59:24 -0700 (PDT)
Subject: Re: [PATCH v2 00/15] KVM: Dynamically size memslot arrays
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <15624ac3-6a43-29c8-8d07-23779454f9e6@redhat.com>
Date: Tue, 22 Oct 2019 15:59:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022003537.13013-1-sean.j.christopherson@intel.com>
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On 22/10/19 02:35, Sean Christopherson wrote:
> The end goal of this series is to dynamically size the memslot array so
> that KVM allocates memory based on the number of memslots in use, as
> opposed to unconditionally allocating memory for the maximum number of
> memslots.  On x86, each memslot consumes 88 bytes, and so with 2 address
> spaces of 512 memslots, each VM consumes ~90k bytes for the memslots.
> E.g. given a VM that uses a total of 30 memslots, dynamic sizing reduces
> the memory footprint from 90k to ~2.6k bytes.
> 
> The changes required to support dynamic sizing are relatively small,
> e.g. are essentially contained in patches 12/13 and 13/13.  Patches 1-11
> clean up the memslot code, which has gotten quite crusy, especially
> __kvm_set_memory_region().  The clean up is likely not strictly necessary
> to switch to dynamic sizing, but I didn't have a remotely reasonable
> level of confidence in the correctness of the dynamic sizing without first
> doing the clean up.
> 
> Testing, especially non-x86 platforms, would be greatly appreciated.  The
> non-x86 changes are for all intents and purposes untested, e.g. I compile
> tested pieces of the code by copying them into x86, but that's it.  In
> theory, the vast majority of the functional changes are arch agnostic, in
> theory...
> 
> v2:
>   - Split "Drop kvm_arch_create_memslot()" into three patches to move
>     minor functional changes to standalone patches [Janosch].
>   - Rebase to latest kvm/queue (f0574a1cea5b, "KVM: x86: fix ...")
>   - Collect an Acked-by and a Reviewed-by
> 
> Sean Christopherson (15):
>   KVM: Reinstall old memslots if arch preparation fails
>   KVM: Don't free new memslot if allocation of said memslot fails
>   KVM: PPC: Move memslot memory allocation into prepare_memory_region()
>   KVM: x86: Allocate memslot resources during prepare_memory_region()
>   KVM: Drop kvm_arch_create_memslot()
>   KVM: Explicitly free allocated-but-unused dirty bitmap
>   KVM: Refactor error handling for setting memory region
>   KVM: Move setting of memslot into helper routine
>   KVM: Move memslot deletion to helper function
>   KVM: Simplify kvm_free_memslot() and all its descendents
>   KVM: Clean up local variable usage in __kvm_set_memory_region()
>   KVM: Provide common implementation for generic dirty log functions
>   KVM: Ensure validity of memslot with respect to kvm_get_dirty_log()
>   KVM: Terminate memslot walks via used_slots
>   KVM: Dynamically size memslot array based on number of used slots
> 
>  arch/mips/include/asm/kvm_host.h      |   2 +-
>  arch/mips/kvm/mips.c                  |  68 +---
>  arch/powerpc/include/asm/kvm_ppc.h    |  14 +-
>  arch/powerpc/kvm/book3s.c             |  22 +-
>  arch/powerpc/kvm/book3s_hv.c          |  36 +-
>  arch/powerpc/kvm/book3s_pr.c          |  20 +-
>  arch/powerpc/kvm/booke.c              |  17 +-
>  arch/powerpc/kvm/powerpc.c            |  13 +-
>  arch/s390/include/asm/kvm_host.h      |   2 +-
>  arch/s390/kvm/kvm-s390.c              |  21 +-
>  arch/x86/include/asm/kvm_page_track.h |   3 +-
>  arch/x86/kvm/page_track.c             |  15 +-
>  arch/x86/kvm/x86.c                    | 100 ++---
>  include/linux/kvm_host.h              |  48 +--
>  virt/kvm/arm/arm.c                    |  47 +--
>  virt/kvm/arm/mmu.c                    |  18 +-
>  virt/kvm/kvm_main.c                   | 546 ++++++++++++++++----------
>  17 files changed, 467 insertions(+), 525 deletions(-)
> 

Christian, Marc, Paul, can you help testing patches 1-13?

Thanks,
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
