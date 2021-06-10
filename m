Return-Path: <SRS0=KFVQ=LE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FBDC47094
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 16:46:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ECE2960FDA
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 16:46:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECE2960FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 730014A500;
	Thu, 10 Jun 2021 12:46:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TSlOnQ763SRW; Thu, 10 Jun 2021 12:46:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FAE549E8C;
	Thu, 10 Jun 2021 12:46:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB17B407EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 12:46:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Otyz8PV9dtaB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 12:46:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AECA8401A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 12:46:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623343576;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pmjeoZP2Zk9cpGLWV8EkH2NTyjrRS5zlwXdTRFtjA7s=;
 b=KkFudj8GA6Yv2V4ViTqvD5s0uUTy1QDB8MMuFJcXJU1LJDswJrNjve1i+ygOQAw/ScaurI
 hzFAkWIfG2uylJy1jM6EMZCv8GH+PqF1pCadFj+2098WSKbn+Af9Znxj/GEtOBtlHcu6Jo
 T9AyHGhgFh6sdtZ3uP3RJSW+B+zX/vg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-4GcRKUO8OlepWBB-7G9T_g-1; Thu, 10 Jun 2021 12:46:13 -0400
X-MC-Unique: 4GcRKUO8OlepWBB-7G9T_g-1
Received: by mail-wm1-f70.google.com with SMTP id
 r4-20020a7bc0840000b02901b7cb5713ecso1443758wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 09:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=pmjeoZP2Zk9cpGLWV8EkH2NTyjrRS5zlwXdTRFtjA7s=;
 b=IwIAmdbIOLTclmn7uILrZE63N1pfowNKcvoXFY/QNmVFOsEBeW/yNvECQcM/TTynx1
 mwuxDO5fD/QpWhxAJZ2dCDZluNvFUp/k2KLXGphiSAUDvopZs0uFTxz/c+LlaGBTXFm3
 s174MPv2u/mvA5beyNmThcq8w5f11xy3n6vg/qo2+PfCalRnqRH4cdTP6+fqdPl0awOl
 f+R2SDTX+YZjOXtIbDvZsep7MsCX5HKMgoiyUNA4BmQgrBwiqTVvJ/xhJO529ihg1fi3
 rog+wNTHPhhqT2ewA7+ao25T2b55bGsediQknk56E6tAoVaEdGpY+pG+R5IkkYvnl8Kn
 yGLw==
X-Gm-Message-State: AOAM533phxZKpx1zkuMIrU0pGUJ3KL6N/RVYpMh/jYAMJJ9OOaXBk/1q
 uxfqDu0cuyN6EHtgdTjdhfRnRB4Odb51LMA9GI8+LuEYV1oSH2XYuIqYnpn51W2x/inwJlYgyOI
 wkiTLw1KOzexuxVBfSXMllKn5
X-Received: by 2002:adf:f1cb:: with SMTP id z11mr6611972wro.2.1623343571785;
 Thu, 10 Jun 2021 09:46:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUfMy73RUGQtVL6eMZ0HpF2pAlTGaxCKpwYBu5GL/GZakJJNUaPWWZRvrLtTVMobB7MLHKLQ==
X-Received: by 2002:adf:f1cb:: with SMTP id z11mr6611916wro.2.1623343571544;
 Thu, 10 Jun 2021 09:46:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a?
 ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
 by smtp.gmail.com with ESMTPSA id p6sm4266126wrf.51.2021.06.10.09.46.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 10 Jun 2021 09:46:11 -0700 (PDT)
Subject: Re: [PATCH v7 0/4] KVM statistics data fd-based binary interface
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxMIPS
 <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>,
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210603211426.790093-1-jingzhangos@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <873a0398-09fc-0278-3f0c-884b73dad3aa@redhat.com>
Date: Thu, 10 Jun 2021 18:46:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210603211426.790093-1-jingzhangos@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 03/06/21 23:14, Jing Zhang wrote:
> This patchset provides a file descriptor for every VM and VCPU to read
> KVM statistics data in binary format.
> It is meant to provide a lightweight, flexible, scalable and efficient
> lock-free solution for user space telemetry applications to pull the
> statistics data periodically for large scale systems. The pulling
> frequency could be as high as a few times per second.
> In this patchset, every statistics data are treated to have some
> attributes as below:
>    * architecture dependent or generic
>    * VM statistics data or VCPU statistics data
>    * type: cumulative, instantaneous,
>    * unit: none for simple counter, nanosecond, microsecond,
>      millisecond, second, Byte, KiByte, MiByte, GiByte. Clock Cycles
> Since no lock/synchronization is used, the consistency between all
> the statistics data is not guaranteed. That means not all statistics
> data are read out at the exact same time, since the statistics date
> are still being updated by KVM subsystems while they are read out.
> 
> ---
> 
> * v6 -> v7
>    - Improve file descriptor allocation function by Krish suggestion
>    - Use "generic stats" instead of "common stats" as Krish suggested
>    - Addressed some other nits from Krish and David Matlack
> 
> * v5 -> v6
>    - Use designated initializers for STATS_DESC
>    - Change KVM_STATS_SCALE... to KVM_STATS_BASE...
>    - Use a common function for kvm_[vm|vcpu]_stats_read
>    - Fix some documentation errors/missings
>    - Use TEST_ASSERT in selftest
>    - Use a common function for [vm|vcpu]_stats_test in selftest
> 
> * v4 -> v5
>    - Rebase to kvm/queue, commit a4345a7cecfb ("Merge tag
>      'kvmarm-fixes-5.13-1'")
>    - Change maximum stats name length to 48
>    - Replace VM_STATS_COMMON/VCPU_STATS_COMMON macros with stats
>      descriptor definition macros.
>    - Fixed some errors/warnings reported by checkpatch.pl
> 
> * v3 -> v4
>    - Rebase to kvm/queue, commit 9f242010c3b4 ("KVM: avoid "deadlock"
>      between install_new_memslots and MMU notifier")
>    - Use C-stype comments in the whole patch
>    - Fix wrong count for x86 VCPU stats descriptors
>    - Fix KVM stats data size counting and validity check in selftest
> 
> * v2 -> v3
>    - Rebase to kvm/queue, commit edf408f5257b ("KVM: avoid "deadlock"
>      between install_new_memslots and MMU notifier")
>    - Resolve some nitpicks about format
> 
> * v1 -> v2
>    - Use ARRAY_SIZE to count the number of stats descriptors
>    - Fix missing `size` field initialization in macro STATS_DESC
> 
> [1] https://lore.kernel.org/kvm/20210402224359.2297157-1-jingzhangos@google.com
> [2] https://lore.kernel.org/kvm/20210415151741.1607806-1-jingzhangos@google.com
> [3] https://lore.kernel.org/kvm/20210423181727.596466-1-jingzhangos@google.com
> [4] https://lore.kernel.org/kvm/20210429203740.1935629-1-jingzhangos@google.com
> [5] https://lore.kernel.org/kvm/20210517145314.157626-1-jingzhangos@google.com
> [6] https://lore.kernel.org/kvm/20210524151828.4113777-1-jingzhangos@google.com
> 
> ---
> 
> Jing Zhang (4):
>    KVM: stats: Separate generic stats from architecture specific ones
>    KVM: stats: Add fd-based API to read binary stats data
>    KVM: stats: Add documentation for statistics data binary interface
>    KVM: selftests: Add selftest for KVM statistics data binary interface
> 
>   Documentation/virt/kvm/api.rst                | 180 +++++++++++++++
>   arch/arm64/include/asm/kvm_host.h             |   9 +-
>   arch/arm64/kvm/guest.c                        |  38 +++-
>   arch/mips/include/asm/kvm_host.h              |   9 +-
>   arch/mips/kvm/mips.c                          |  64 +++++-
>   arch/powerpc/include/asm/kvm_host.h           |   9 +-
>   arch/powerpc/kvm/book3s.c                     |  64 +++++-
>   arch/powerpc/kvm/book3s_hv.c                  |  12 +-
>   arch/powerpc/kvm/book3s_pr.c                  |   2 +-
>   arch/powerpc/kvm/book3s_pr_papr.c             |   2 +-
>   arch/powerpc/kvm/booke.c                      |  59 ++++-
>   arch/s390/include/asm/kvm_host.h              |   9 +-
>   arch/s390/kvm/kvm-s390.c                      | 129 ++++++++++-
>   arch/x86/include/asm/kvm_host.h               |   9 +-
>   arch/x86/kvm/x86.c                            |  67 +++++-
>   include/linux/kvm_host.h                      | 141 +++++++++++-
>   include/linux/kvm_types.h                     |  12 +
>   include/uapi/linux/kvm.h                      |  50 ++++
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   3 +
>   .../testing/selftests/kvm/include/kvm_util.h  |   3 +
>   .../selftests/kvm/kvm_binary_stats_test.c     | 215 ++++++++++++++++++
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +
>   virt/kvm/kvm_main.c                           | 169 +++++++++++++-
>   24 files changed, 1178 insertions(+), 90 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/kvm_binary_stats_test.c
> 
> 
> base-commit: a4345a7cecfb91ae78cd43d26b0c6a956420761a
> 

I had a few remarks, but it looks very nice overall.

Thanks!

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
