Return-Path: <SRS0=SY/6=AE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E846C433E2
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jun 2020 09:42:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 013D420679
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jun 2020 09:42:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLG5dtpw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 013D420679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6112D4B0D8;
	Tue, 23 Jun 2020 05:42:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aZ6fcO1OQTDY; Tue, 23 Jun 2020 05:42:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38DB94B0BE;
	Tue, 23 Jun 2020 05:42:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD20A4B0BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2020 05:42:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G24I+nbUKdo1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jun 2020 05:42:46 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB4364B099
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2020 05:42:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1592905366;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QoBwKmjOvInG9MfmBsLrqKkfpaZqKCYNSmoYTUfOHHE=;
 b=ZLG5dtpwtkla4mBaG6iRidFYELlZHLyhe/p1NVi5lAT0wiv+Gmd3Gpq3DSWqkokcxObDjK
 5HC4fGF9K6YFQ6AejRE/azWMsUlHdAAbQOYiKKHITil85dPqBWig1MM7ugM2vpSXnRSoQ6
 7HCVBGjwdnIm/SaxpmCf1i40hMbeb1Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-dB0bY02gMF64OJ7gPSER7Q-1; Tue, 23 Jun 2020 05:42:42 -0400
X-MC-Unique: dB0bY02gMF64OJ7gPSER7Q-1
Received: by mail-wr1-f69.google.com with SMTP id i10so10734940wrn.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2020 02:42:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=QoBwKmjOvInG9MfmBsLrqKkfpaZqKCYNSmoYTUfOHHE=;
 b=DxqIP2HcrKQ7cg2LF5wiqvWC0TWiGQrdhqFdZNGtuKW6MLhj8ib475RzWtlg41NlC5
 W5kRLC2Lwhx8q9oSIuHjODy3S7x0d3pbfOUH6kTo2h/X4goNkwpxfJ4qoN+2J4tl5Pbx
 s7GsCHzp65mlhnl/fWfbi74u06OvvTeJhCo1mAu1vqZHL2G29t3Bj0OFpMtlE3quO5Hw
 BcgStZwZNa+BnCMrq1Wkkbp2WVGp5GJ8jZWqxTfMrw1OkS7ZcXXhdjGfCQ76v5npHLdU
 XdNG7eHNxNKuNGmziBhN2gzu8kZHYMd15/mS6hLllHEZBi8tcl3+hHdi4uGOTKPHZYCt
 +caQ==
X-Gm-Message-State: AOAM530Ai2yldqY+s/GDWegoG56ppXoit8Ux4OdpH2JOmrfXpPzc3est
 ClQqr+bn4xby62FKfrq13ogEe/u3FUd+wLFo2DaF3555s0iJlNoCGn7vWOkGimAsgvEqL6APtAv
 Sxysoz4KJazkeNgqZMg8ChcP7
X-Received: by 2002:adf:e908:: with SMTP id f8mr1064524wrm.3.1592905361579;
 Tue, 23 Jun 2020 02:42:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYpabjIXBcOB9eaiLhNkEzAaSPqokuBtil8iucj5gBxqX45bVu6WVMKG+2KSXPDnKUswgA9A==
X-Received: by 2002:adf:e908:: with SMTP id f8mr1064490wrm.3.1592905361326;
 Tue, 23 Jun 2020 02:42:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1?
 ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
 by smtp.gmail.com with ESMTPSA id 26sm1149131wmj.25.2020.06.23.02.42.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 23 Jun 2020 02:42:40 -0700 (PDT)
Subject: Re: [PATCH v4 0/7] clean up redundant 'kvm_run' parameters
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
 tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
 benh@kernel.crashing.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, cohuck@redhat.com, heiko.carstens@de.ibm.com,
 gor@linux.ibm.com, sean.j.christopherson@intel.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
 chenhuacai@gmail.com
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fe463233-d094-fca5-b4e9-c1d97124fd69@redhat.com>
Date: Tue, 23 Jun 2020 11:42:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu,
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

On 27/04/20 06:35, Tianjia Zhang wrote:
> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
> structure. For historical reasons, many kvm-related function parameters
> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
> patch does a unified cleanup of these remaining redundant parameters.
> 
> This series of patches has completely cleaned the architecture of
> arm64, mips, ppc, and s390 (no such redundant code on x86). Due to
> the large number of modified codes, a separate patch is made for each
> platform. On the ppc platform, there is also a redundant structure
> pointer of 'kvm_run' in 'vcpu_arch', which has also been cleaned
> separately.

Tianjia, can you please refresh the patches so that each architecture
maintainer can pick them up?  Thanks very much for this work!

Paolo

> 
> ---
> v4 change:
>   mips: fixes two errors in entry.c.
> 
> v3 change:
>   Keep the existing `vcpu->run` in the function body unchanged.
> 
> v2 change:
>   s390 retains the original variable name and minimizes modification.
> 
> Tianjia Zhang (7):
>   KVM: s390: clean up redundant 'kvm_run' parameters
>   KVM: arm64: clean up redundant 'kvm_run' parameters
>   KVM: PPC: Remove redundant kvm_run from vcpu_arch
>   KVM: PPC: clean up redundant 'kvm_run' parameters
>   KVM: PPC: clean up redundant kvm_run parameters in assembly
>   KVM: MIPS: clean up redundant 'kvm_run' parameters
>   KVM: MIPS: clean up redundant kvm_run parameters in assembly
> 
>  arch/arm64/include/asm/kvm_coproc.h      |  12 +--
>  arch/arm64/include/asm/kvm_host.h        |  11 +--
>  arch/arm64/include/asm/kvm_mmu.h         |   2 +-
>  arch/arm64/kvm/handle_exit.c             |  36 +++----
>  arch/arm64/kvm/sys_regs.c                |  13 ++-
>  arch/mips/include/asm/kvm_host.h         |  32 +------
>  arch/mips/kvm/emulate.c                  |  59 ++++--------
>  arch/mips/kvm/entry.c                    |  21 ++---
>  arch/mips/kvm/mips.c                     |  14 +--
>  arch/mips/kvm/trap_emul.c                | 114 ++++++++++-------------
>  arch/mips/kvm/vz.c                       |  26 ++----
>  arch/powerpc/include/asm/kvm_book3s.h    |  16 ++--
>  arch/powerpc/include/asm/kvm_host.h      |   1 -
>  arch/powerpc/include/asm/kvm_ppc.h       |  27 +++---
>  arch/powerpc/kvm/book3s.c                |   4 +-
>  arch/powerpc/kvm/book3s.h                |   2 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c      |  12 +--
>  arch/powerpc/kvm/book3s_64_mmu_radix.c   |   4 +-
>  arch/powerpc/kvm/book3s_emulate.c        |  10 +-
>  arch/powerpc/kvm/book3s_hv.c             |  64 ++++++-------
>  arch/powerpc/kvm/book3s_hv_nested.c      |  12 +--
>  arch/powerpc/kvm/book3s_interrupts.S     |  17 ++--
>  arch/powerpc/kvm/book3s_paired_singles.c |  72 +++++++-------
>  arch/powerpc/kvm/book3s_pr.c             |  33 ++++---
>  arch/powerpc/kvm/booke.c                 |  39 ++++----
>  arch/powerpc/kvm/booke.h                 |   8 +-
>  arch/powerpc/kvm/booke_emulate.c         |   2 +-
>  arch/powerpc/kvm/booke_interrupts.S      |   9 +-
>  arch/powerpc/kvm/bookehv_interrupts.S    |  10 +-
>  arch/powerpc/kvm/e500_emulate.c          |  15 ++-
>  arch/powerpc/kvm/emulate.c               |  10 +-
>  arch/powerpc/kvm/emulate_loadstore.c     |  32 +++----
>  arch/powerpc/kvm/powerpc.c               |  72 +++++++-------
>  arch/powerpc/kvm/trace_hv.h              |   6 +-
>  arch/s390/kvm/kvm-s390.c                 |  23 +++--
>  virt/kvm/arm/arm.c                       |   6 +-
>  virt/kvm/arm/mmio.c                      |  11 ++-
>  virt/kvm/arm/mmu.c                       |   5 +-
>  38 files changed, 392 insertions(+), 470 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
