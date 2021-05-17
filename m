Return-Path: <SRS0=zR8f=KM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBE7C433B4
	for <kvmarm@archiver.kernel.org>; Mon, 17 May 2021 14:55:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF10E60FE8
	for <kvmarm@archiver.kernel.org>; Mon, 17 May 2021 14:55:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF10E60FE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E39C4B23E;
	Mon, 17 May 2021 10:55:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oAc02BNvyBkE; Mon, 17 May 2021 10:55:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD7E94B16D;
	Mon, 17 May 2021 10:55:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DADBA4B16D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 May 2021 10:55:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vdL5DJhVjdd3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 May 2021 10:55:38 -0400 (EDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com
 [209.85.208.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63E514B124
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 May 2021 10:55:38 -0400 (EDT)
Received: by mail-lj1-f171.google.com with SMTP id 131so7623904ljj.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 May 2021 07:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
 bh=QUe8DOeGFSdZ193LBrJppmyu5E2kuzgS0SpFBXrhdow=;
 b=U7wtNIdm28GJ8gwv7rj2npD297B+CJPksgybK+hTA7W8lHEhapKJxMIG5HQ3HNjXTg
 rWb17bnmwUibfb6rDGPoRpsUcTBKgheHmdEsYQPVx7KYwyYWUJ/UNRkKfjb9d5ibFSFt
 v0Ow6tYwRBxOkRkqYu/DG4+zFO+zy6inj96rgHrhP8QNsj4HQXzBUbFw/rjoY9+IIM+C
 OhujAr86N4O2dvGqUDJI0zXBe8E1N459vTzNZ6MB6PKR1p/o3iIaEdbHCI2e1Ze+ICqd
 +af/XXK+6g5EVl721j8io2s5td6Cu6Uh4DS/OUMJSH13vFDYn9PvexXNAac5d0rx2akL
 Bijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to;
 bh=QUe8DOeGFSdZ193LBrJppmyu5E2kuzgS0SpFBXrhdow=;
 b=kiOrAh1LbCF2STCj1sFFo6/d8CbNEPgeN9YJoaLok2612wtcGhbWazluzMy7YEGdBQ
 q6XONZ2j7NpyJM4Z/34lvnQvNVZyDZe5M7zYZTMn3K3pFr1g+yfzTMgHsM/DEMx7NNB+
 3OnPxfQjgm51urj6SwTYzG1NwEK6A6Tyh5OHt0LwCxq+VYG5jiScjwqo28/wF76mfkvc
 9/DyDNK/HDKaNxYQYa7d32VWs/IDANZAwJf3Nl2IcL1euCk7x6HXwn6bwDkvdrxxl+YN
 YYvzfijb5wny7tR3+TvtIzb75qrdkVuDBXCtYhoLu8fY+JCihzUPHV8s6h3l7cwtQjlX
 k0zg==
X-Gm-Message-State: AOAM531uHHiFlu2bJRAXf6HNyamwrJrQv0GwMFDsubwxdvml9sZJpEDo
 jo7pyurUTA2jYvjIJPiNNlfMEV789iTpHYlqSiTlPA==
X-Google-Smtp-Source: ABdhPJyyt3vMBNkKRAxRLZE9D6Z3kkpMMjxSYVr0MStibqeH5eOvyHWZ8uTTaM8cQ8iiN2h4w0DZq9BBNo0X0WVeHiI=
X-Received: by 2002:a05:651c:1251:: with SMTP id
 h17mr50489673ljh.215.1621263336866; 
 Mon, 17 May 2021 07:55:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210517145314.157626-1-jingzhangos@google.com>
In-Reply-To: <20210517145314.157626-1-jingzhangos@google.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 17 May 2021 09:55:25 -0500
Message-ID: <CAAdAUtixWdpFvY1Vq5e+VqoFjZ9xoTyb0gi4MD9=u8rMj4NEJQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] KVM statistics data fd-based binary interface
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 LinuxMIPS <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>, 
 LinuxS390 <linux-s390@vger.kernel.org>, 
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>, 
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>
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

Hi Paolo,

On Mon, May 17, 2021 at 9:53 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> This patchset provides a file descriptor for every VM and VCPU to read
> KVM statistics data in binary format.
> It is meant to provide a lightweight, flexible, scalable and efficient
> lock-free solution for user space telemetry applications to pull the
> statistics data periodically for large scale systems. The pulling
> frequency could be as high as a few times per second.
> In this patchset, every statistics data are treated to have some
> attributes as below:
>   * architecture dependent or common
>   * VM statistics data or VCPU statistics data
>   * type: cumulative, instantaneous,
>   * unit: none for simple counter, nanosecond, microsecond,
>     millisecond, second, Byte, KiByte, MiByte, GiByte. Clock Cycles
> Since no lock/synchronization is used, the consistency between all
> the statistics data is not guaranteed. That means not all statistics
> data are read out at the exact same time, since the statistics date
> are still being updated by KVM subsystems while they are read out.
>
> ---
>
> * v4 -> v5
>   - Rebase to kvm/queue, commit a4345a7cecfb ("Merge tag
>     'kvmarm-fixes-5.13-1'")
>   - Change maximum stats name length to 48
>   - Replace VM_STATS_COMMON/VCPU_STATS_COMMON macros with stats
>     descriptor definition macros.
>   - Fixed some errors/warnings reported by checkpatch.pl
>
> * v3 -> v4
>   - Rebase to kvm/queue, commit 9f242010c3b4 ("KVM: avoid "deadlock"
>     between install_new_memslots and MMU notifier")
>   - Use C-stype comments in the whole patch
>   - Fix wrong count for x86 VCPU stats descriptors
>   - Fix KVM stats data size counting and validity check in selftest
>
> * v2 -> v3
>   - Rebase to kvm/queue, commit edf408f5257b ("KVM: avoid "deadlock"
>     between install_new_memslots and MMU notifier")
>   - Resolve some nitpicks about format
>
> * v1 -> v2
>   - Use ARRAY_SIZE to count the number of stats descriptors
>   - Fix missing `size` field initialization in macro STATS_DESC
>
> [1] https://lore.kernel.org/kvm/20210402224359.2297157-1-jingzhangos@google.com
> [2] https://lore.kernel.org/kvm/20210415151741.1607806-1-jingzhangos@google.com
> [3] https://lore.kernel.org/kvm/20210423181727.596466-1-jingzhangos@google.com
> [4] https://lore.kernel.org/kvm/20210429203740.1935629-1-jingzhangos@google.com
>
> ---
>
> Jing Zhang (4):
>   KVM: stats: Separate common stats from architecture specific ones
>   KVM: stats: Add fd-based API to read binary stats data
>   KVM: stats: Add documentation for statistics data binary interface
>   KVM: selftests: Add selftest for KVM statistics data binary interface
>
>  Documentation/virt/kvm/api.rst                | 171 ++++++++
>  arch/arm64/include/asm/kvm_host.h             |   9 +-
>  arch/arm64/kvm/guest.c                        |  38 +-
>  arch/mips/include/asm/kvm_host.h              |   9 +-
>  arch/mips/kvm/mips.c                          |  64 ++-
>  arch/powerpc/include/asm/kvm_host.h           |   9 +-
>  arch/powerpc/kvm/book3s.c                     |  64 ++-
>  arch/powerpc/kvm/book3s_hv.c                  |  12 +-
>  arch/powerpc/kvm/book3s_pr.c                  |   2 +-
>  arch/powerpc/kvm/book3s_pr_papr.c             |   2 +-
>  arch/powerpc/kvm/booke.c                      |  59 ++-
>  arch/s390/include/asm/kvm_host.h              |   9 +-
>  arch/s390/kvm/kvm-s390.c                      | 129 +++++-
>  arch/x86/include/asm/kvm_host.h               |   9 +-
>  arch/x86/kvm/x86.c                            |  67 +++-
>  include/linux/kvm_host.h                      | 136 ++++++-
>  include/linux/kvm_types.h                     |  12 +
>  include/uapi/linux/kvm.h                      |  50 +++
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   3 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   3 +
>  .../selftests/kvm/kvm_bin_form_stats.c        | 379 ++++++++++++++++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +
>  virt/kvm/kvm_main.c                           | 237 ++++++++++-
>  24 files changed, 1396 insertions(+), 90 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/kvm_bin_form_stats.c
>
>
> base-commit: a4345a7cecfb91ae78cd43d26b0c6a956420761a
> --
> 2.31.1.751.gd2f1c929bd-goog
>
Please use this patchset which has some nontrivial changes and improvements.

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
