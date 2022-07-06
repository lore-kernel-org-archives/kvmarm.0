Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5DD3C43334
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 19:17:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 161D84BEB5;
	Wed,  6 Jul 2022 15:17:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z70qvfHttTDV; Wed,  6 Jul 2022 15:17:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B67544BE60;
	Wed,  6 Jul 2022 15:17:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6AC4BE4A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 15:17:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zhnTwIMYxVMy for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 15:17:35 -0400 (EDT)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56E9B4BE3B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 15:17:35 -0400 (EDT)
Received: by mail-pl1-f172.google.com with SMTP id 5so8548068plk.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Jul 2022 12:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ZjEGOm6kee36npEJu+b6kQDUwPzHaM9d3/gdsO10A3o=;
 b=JBmKOjwv6JurVrCp1jbxVixSqXLF0Sb1dFg8JNOdJ+fwNcPBzQlQn3tn4npjxXVIAV
 SMXfrIYC1s7mVn2dvjhB0eIRyJFsLPDfTeECp8Xoz9OOif2Tbx6LEY3/uV80I/w2EUfp
 2PymuDBaHeeyOy65/N0JZu+CiLRMYUtd4Sv9WWbw3CeYIDJwm2kJS68xyNtkvt0wBEJV
 vbNNi60hCxI9Sc5sH3Wo2sGB4T2Rdw9dv/k+tl95h8UctppFSCBE4DP1IFA/qJ7WWw8W
 ASrzo6LZ49VRz1A3Vlp+dUXvviM466LA8jFo5XqC13HA8mIP7rD0HR1kq5kwUmKgaAaT
 AwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ZjEGOm6kee36npEJu+b6kQDUwPzHaM9d3/gdsO10A3o=;
 b=xMyaBA1O7xfySZmIRGBlH3uMbfrZErXDfOwWXWa6Z2ZoKvQ0Zw/aLK236KWDvd2i67
 6p7jKo5TgMdljajOclzwCWOoxNjPJ8tgSiRpYME5kZs0CX+Kkyr/MBNqqmuhTZt5LxvR
 sdDPW185WtWMfWQBn9jzTplnLjI/XG3GLJ9ShQRyKfmQh+A3+57sVOEdxo9i37BfLvbb
 6Q6WzSbBh8w9KJUgoWDiOMz/4SsfuXXtFBzXYFZKgohSLcin3vkoAxWZAa2ykKgRjLTK
 VPgCxpVQJJHSqXxhFfeC5+E8hEEp24Jiy3R1lUK9ZsKKL3Dx5OfpIqJLm0ffJ+qre1nO
 2B3w==
X-Gm-Message-State: AJIora/6cvpWNq+VA7ecNQaws24FVncpeN002QRksJT1GziVuApe0s+q
 SjBsHrNKuGU3SA2hYSUCOFKMPg==
X-Google-Smtp-Source: AGRyM1vOOz2sO95rdkMXCWcipyRGk4AXIxqT4D+nvbdPOQ8Tgsc6ZH6eLd494oQu0sAcs8gpAmxTDg==
X-Received: by 2002:a17:902:d292:b0:16b:e6a4:5768 with SMTP id
 t18-20020a170902d29200b0016be6a45768mr16270752plc.128.1657135054004; 
 Wed, 06 Jul 2022 12:17:34 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 mz5-20020a17090b378500b001ef88c30fbbsm7163752pjb.49.2022.07.06.12.17.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Jul 2022 12:17:33 -0700 (PDT)
Date: Wed, 6 Jul 2022 19:17:29 +0000
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 00/24] KVM: arm64: Introduce pKVM shadow state at EL2
Message-ID: <YsXfyVp6sg5XRVAp@google.com>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Andy Lutomirski <luto@amacapital.net>,
 linux-arm-kernel@lists.infradead.org, Michael Roth <michael.roth@amd.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 30, 2022, Will Deacon wrote:
> Hi everyone,
> 
> This series has been extracted from the pKVM base support series (aka
> "pKVM mega-patch") previously posted here:
> 
>   https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
> 
> Unlike that more comprehensive series, this one is fairly fundamental
> and does not introduce any new ABI commitments, leaving questions
> involving the management of guest private memory and the creation of
> protected VMs for future work. Instead, this series extends the pKVM EL2
> code so that it can dynamically instantiate and manage VM shadow
> structures without the host being able to access them directly. These
> shadow structures consist of a shadow VM, a set of shadow vCPUs and the
> stage-2 page-table and the pages used to hold them are returned to the
> host when the VM is destroyed.
> 
> The last patch is marked as RFC because, although it plumbs in the
> shadow state, it is woefully inefficient and copies to/from the host
> state on every vCPU run. Without the last patch, the new structures are
> unused but we move considerably closer to isolating guests from the
> host.

...

>  arch/arm64/include/asm/kvm_asm.h              |   6 +-
>  arch/arm64/include/asm/kvm_host.h             |  65 +++
>  arch/arm64/include/asm/kvm_hyp.h              |   3 +
>  arch/arm64/include/asm/kvm_pgtable.h          |   8 +
>  arch/arm64/include/asm/kvm_pkvm.h             |  38 ++
>  arch/arm64/kernel/image-vars.h                |  15 -
>  arch/arm64/kvm/arm.c                          |  40 +-
>  arch/arm64/kvm/hyp/hyp-constants.c            |   3 +
>  arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  19 +-
>  arch/arm64/kvm/hyp/include/nvhe/memory.h      |  26 +-
>  arch/arm64/kvm/hyp/include/nvhe/mm.h          |  18 +-
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  70 +++
>  arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  10 +-
>  arch/arm64/kvm/hyp/nvhe/cache.S               |  11 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 105 +++-
>  arch/arm64/kvm/hyp/nvhe/hyp-smp.c             |   2 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 456 +++++++++++++++++-
>  arch/arm64/kvm/hyp/nvhe/mm.c                  | 136 +++++-
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  42 +-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                | 438 +++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c               |  96 ++--
>  arch/arm64/kvm/hyp/pgtable.c                  |   9 +
>  arch/arm64/kvm/mmu.c                          |  26 +
>  arch/arm64/kvm/pkvm.c                         | 121 ++++-
>  25 files changed, 1625 insertions(+), 144 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h

The lack of documentation and the rather terse changelogs make this really hard
to review for folks that aren't intimately familiar with pKVM.  I have a decent
idea of the end goal of "shadowing", but that's mostly because of my involvement in
similar x86 projects.  Nothing in the changelogs ever explains _why_ pKVM uses
shadows.

I put "shadowing" in quotes because if the unstrusted host is aware that the VM
and vCPU it is manipulating aren't the "real" VMs/vCPUs, and there is an explicit API
between the untrusted host and pKVM for creating/destroying VMs/vCPUs, then I would
argue that it's not truly shadowing, especially if pKVM uses data/values verbatim
and only verifies correctness/safety.  It's definitely a nit, but for future readers
I think overloading "shadowing" could be confusing.

And beyond the basics, IMO pKVM needs a more formal definition of exactly what
guest state is protected/hidden from the untrusted host.  Peeking at the mega series,
there are a huge pile of patches that result in "gradual reduction of EL2 trust in
host data", but I couldn't any documentation that defines what that end result is.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
