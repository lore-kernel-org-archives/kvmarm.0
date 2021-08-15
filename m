Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0623C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 07:50:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1808F610E7
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 07:50:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1808F610E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 542F74B0B9;
	Sun, 15 Aug 2021 03:50:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VpzOv3gfKGQx; Sun, 15 Aug 2021 03:50:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 658164B08A;
	Sun, 15 Aug 2021 03:50:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07B824B08A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 03:50:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8ICwcoMkkKQl for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 03:50:21 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEFF04B086
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 03:50:21 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id n17so28149807lft.13
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 00:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=AeOo2/NJjjRZYAUfR03mnALs9Q9w0Q9REEH1kqJO00E=;
 b=TTisQC8k2XZPlvQzmZ2PypsNzh4fKcVGQecrhsZTm8I5mYnu9OEoFUxpfcfGmVEgT0
 oFQVCy2noSHCf0NiWo9oKoMHOWWxBSghDOOQEB1aTBF1eW5SMMzli2h1a71UXuWNN9Ro
 /GlJ3Jun1lsbhCKcSJtjBBoNDi+4kgce+P0wVDtPSRZ3lGAod+4Lo53P4JluPdOuLoeE
 /Sg95KVEy45JHH+yG/mAuMCvsyiBhlqluH2/E0diCzUutcLj2VsqugSNEZ95RftY7Hen
 dpLdQ84kgo55aqPP/JTejkYde7MwWUJf1JMuB4iQo8yBm+SP/PmFmoEGt+jQSyW6zhGq
 c1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=AeOo2/NJjjRZYAUfR03mnALs9Q9w0Q9REEH1kqJO00E=;
 b=CI240aOyB+TugOkSIfYyn+5vY8AUjEOjPFRwFJR4x+ILZRZrpGXBsa3R6SdJIgPHIA
 pbNa2gLWJPTZanorPECUVBknxjpF483biK0Rm0lgNvxIfs+KM+E1NCK39680t5TOsm2g
 WNuYqFX7h9DHbjf8x4I1Z8yPPOLarLgfDFRulQFVEJPnMbeSzAbxhHtTNN27416lx63q
 MC5lQxGD5X4msI+tHa8oS98xSG2vjK/oz2xcRjQHgfwdXPKZLYFcQenEFZXZqeVg9vuO
 f2yviuvP8kIocSFh5VbDOsBsw9LC7WH3pgNo07spkfpWSww9eqelNf8JSE1kbg2DTDvZ
 bUvA==
X-Gm-Message-State: AOAM533JUvR1DboqZTmFdcmDJkNE19uQJTH2yY1eokraqpTdjfcUDHnt
 kD9f9ecO1bslT1PlHEDrZf+McQDvtKDBwIkIeE/1kNfGhQY=
X-Google-Smtp-Source: ABdhPJwUAMiV1AVeFvyV3z1ePGBOkI+wFqGIWViv3msIS8RjqYqp89UQNSmQ6cy5OtC99JXIbfoUD2ygtROWcboUyrM=
X-Received: by 2002:a05:6512:3608:: with SMTP id
 f8mr7346112lfs.57.1629013819926; 
 Sun, 15 Aug 2021 00:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210802192809.1851010-1-oupton@google.com>
In-Reply-To: <20210802192809.1851010-1-oupton@google.com>
From: Oliver Upton <oupton@google.com>
Date: Sun, 15 Aug 2021 00:50:09 -0700
Message-ID: <CAOQ_Qsj0UH=3FQNP3NTjX-rcU68s0hm6k5g7i_rwqKc4b84DZA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: arm64: Use generic guest entry infrastructure
To: kvmarm@lists.cs.columbia.edu
Cc: Shakeel Butt <shakeelb@google.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Guangyu Shi <guangyus@google.com>, Will Deacon <will@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org
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

Friendly ping :)

--
Thanks,
Oliver

On Mon, Aug 2, 2021 at 12:28 PM Oliver Upton <oupton@google.com> wrote:
>
> The arm64 kernel doesn't yet support the full generic entry
> infrastructure. That being said, KVM/arm64 doesn't properly handle
> TIF_NOTIFY_RESUME and could pick this up by switching to the generic
> guest entry infrasturture.
>
> Patch 1 adds a missing vCPU stat to ARM64 to record the number of signal
> exits to userspace.
>
> Patch 2 unhitches entry-kvm from entry-generic, as ARM64 doesn't
> currently support the generic infrastructure.
>
> Patch 3 replaces the open-coded entry handling with the generic xfer
> function.
>
> This series was tested on an Ampere Mt. Jade reference system. The
> series cleanly applies to kvm/queue (note that this is deliberate as the
> generic kvm stats patches have not yet propagated to kvm-arm/queue) at
> the following commit:
>
> 8ad5e63649ff ("KVM: Don't take mmu_lock for range invalidation unless necessary")
>
> v1 -> v2:
>  - Address Jing's comment
>  - Carry Jing's r-b tag
>
> v2 -> v3:
>  - Roll all exit conditions into kvm_vcpu_exit_request() (Marc)
>  - Avoid needlessly checking for work twice (Marc)
>
> v1: http://lore.kernel.org/r/20210729195632.489978-1-oupton@google.com
> v2: http://lore.kernel.org/r/20210729220916.1672875-1-oupton@google.com
>
> Oliver Upton (3):
>   KVM: arm64: Record number of signal exits as a vCPU stat
>   entry: KVM: Allow use of generic KVM entry w/o full generic support
>   KVM: arm64: Use generic KVM xfer to guest work function
>
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/Kconfig            |  1 +
>  arch/arm64/kvm/arm.c              | 71 +++++++++++++++++++------------
>  arch/arm64/kvm/guest.c            |  1 +
>  include/linux/entry-kvm.h         |  6 ++-
>  5 files changed, 52 insertions(+), 28 deletions(-)
>
> --
> 2.32.0.554.ge1b32706d8-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
