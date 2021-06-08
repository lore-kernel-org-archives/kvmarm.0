Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEE4C4743E
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 15:07:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC46D6128E
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 15:07:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC46D6128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43AC340762;
	Tue,  8 Jun 2021 11:07:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rPxy37S0a7lT; Tue,  8 Jun 2021 11:07:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA2D74079A;
	Tue,  8 Jun 2021 11:07:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D49D406E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 11:07:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K2e-aVaat8nZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 11:07:48 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86435406AD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 11:07:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623164868;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=8oEC6CaaT/gHb7RKpF7zDNUqX2rhoUKcZ31i04rDTCw=;
 b=cuHT8aUXTpwJbJdqDztrszZkYsiLIK+23sZkOKA5UmOeT1XJp3yHSfU4Ta3lGhwVqwjjue
 nCrBrVW92xTUV7hnxmHIdwrqPXzQtNm91vEIdEoDqWpnviQ7DZjifpXA6fAa/97sMHsabj
 F3PP785ztuuFGvgNwGcNsWwSjKt92EI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-VqykaiP2NW6EtNDHVjQ6Xg-1; Tue, 08 Jun 2021 11:07:44 -0400
X-MC-Unique: VqykaiP2NW6EtNDHVjQ6Xg-1
Received: by mail-wm1-f71.google.com with SMTP id
 j6-20020a05600c1906b029019e9c982271so1373435wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 08:07:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8oEC6CaaT/gHb7RKpF7zDNUqX2rhoUKcZ31i04rDTCw=;
 b=m9qFBaQH3toFf5o7DqoGBrl8WVm8xhe6Xl2wa+rPD3v1FVjKkQWW+YJrdFUNf/eD4x
 OzvJlItNmfXK7jGftwWuBUabS3+vIPWPLJR2xuHPVPeFndbgkXO9Jb7hNxsCISrLCthM
 B0YOmgxoaPdMkjCQnEpxvJW5Hu3Al9PNH2Zh5wjdHrXzEni6r7n5VP83VOfwh/piT1xd
 yHdr7cgCsmaO1FmHGtTzYG4NiBRbour8cm1qxBNZxeVtMmc6pBL8RIK58V4WWxrRk9TV
 6zOLUH4mnQKp8wf4b665GsTq3sirz63abqkEZ/p0kka06p00Av3gGQPcDyaByHd1VDqu
 x2AQ==
X-Gm-Message-State: AOAM5302Nd0FYHDgRdo9gZHrVZL0Eh4x4deLpnx0WT5uUUataZfHXRO/
 RK5LFW1JxJlG157nBjE3WQRUQ0dJJK0OuS4mLjEmroIgDslfUqJkxJUCiqMTgjRyDN8hq4TYICV
 u/w3ebAxOgkNmFZ564KJ63q5Q
X-Received: by 2002:a1c:9dcd:: with SMTP id g196mr4843711wme.135.1623164863490; 
 Tue, 08 Jun 2021 08:07:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKDtNOesB1A4Sct7Gz5HSXh1eFBM+EnmhLeEvmHG0eAj+H0vieU7hbUe51VQ8Q4K+A899ZEQ==
X-Received: by 2002:a1c:9dcd:: with SMTP id g196mr4843685wme.135.1623164863293; 
 Tue, 08 Jun 2021 08:07:43 -0700 (PDT)
Received: from gator (93-137-73-123.adsl.net.t-com.hr. [93.137.73.123])
 by smtp.gmail.com with ESMTPSA id h15sm2054583wrq.88.2021.06.08.08.07.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Jun 2021 08:07:42 -0700 (PDT)
Date: Tue, 8 Jun 2021 17:07:39 +0200
From: Andrew Jones <drjones@redhat.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v1 00/13] KVM: arm64: Fixed features for protected VMs
Message-ID: <20210608150739.7ztstw52ynxh6m5p@gator>
References: <20210608141141.997398-1-tabba@google.com>
MIME-Version: 1.0
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Tue, Jun 08, 2021 at 03:11:28PM +0100, Fuad Tabba wrote:
> Hi,
> 
> This patch series adds support for restricting CPU features for protected VMs
> in KVM [1].
> 
> Various feature configurations are allowed in KVM/arm64. Supporting all
> these features in pKVM is difficult, as it either involves moving much of
> the handling code to EL2, which adds bloat and results in a less verifiable
> trusted code base. Or it involves leaving the code handling at EL1, which
> risks having an untrusted host kernel feeding wrong information to the EL2
> and to the protected guests.
> 
> This series attempts to mitigate this by reducing the configuration space,
> providing a reduced amount of feature support at EL2 with the least amount of
> compromise of protected guests' capabilities.
> 
> This is done by restricting CPU features exposed to protected guests through
> feature registers. These restrictions are enforced by trapping register
> accesses as well as instructions associated with these features, and injecting
> an undefined exception into the guest if it attempts to use a restricted
> feature.
> 
> The features being restricted (only for protected VMs in protected mode) are
> the following:
> - Debug, Trace, and DoubleLock
> - Performance Monitoring (PMU)
> - Statistical Profiling (SPE)
> - Scalable Vector Extension (SVE)
> - Memory Partitioning and Monitoring (MPAM)
> - Activity Monitoring (AMU)
> - Memory Tagging (MTE)
> - Limited Ordering Regions (LOR)
> - AArch32 State
> - Generic Interrupt Controller (GIC) (depending on rVIC support)
> - Nested Virtualization (NV)
> - Reliability, Availability, and Serviceability (RAS) above V1
> - Implementation-defined Features

Hi Fuad,

I see this series takes the approach we currently have in KVM of masking
features we don't want to expose to the guest. This approach adds yet
another "reject list" to be maintained as hardware evolves. I'd rather see
that we first change KVM to using an accept list, i.e. mask everything and
then only set what we want to enable. Mimicking that new accept list in
pKVM, where much less would be enabled, would reduce the amount of
maintenance needed.

Thanks,
drew

> 
> This series is based on kvmarm/next and Will's patches for an Initial pKVM user
> ABI [1]. You can find the applied series here [2].
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
> 
> For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
> https://www.youtube.com/watch?v=edqJSzsDRxk
> 
> [2] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v1
> 
> To: kvmarm@lists.cs.columbia.edu
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Quentin Perret <qperret@google.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kernel-team@android.com
> 
> Fuad Tabba (13):
>   KVM: arm64: Remove trailing whitespace in comments
>   KVM: arm64: MDCR_EL2 is a 64-bit register
>   KVM: arm64: Fix name of HCR_TACR to match the spec
>   KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
>   KVM: arm64: Restore mdcr_el2 from vcpu
>   KVM: arm64: Add feature register flag definitions
>   KVM: arm64: Add config register bit definitions
>   KVM: arm64: Guest exit handlers for nVHE hyp
>   KVM: arm64: Add trap handlers for protected VMs
>   KVM: arm64: Move sanitized copies of CPU features
>   KVM: arm64: Trap access to pVM restricted features
>   KVM: arm64: Handle protected guests at 32 bits
>   KVM: arm64: Check vcpu features at pVM creation
> 
>  arch/arm64/include/asm/kvm_arm.h        |  34 +-
>  arch/arm64/include/asm/kvm_asm.h        |   2 +-
>  arch/arm64/include/asm/kvm_host.h       |   2 +-
>  arch/arm64/include/asm/kvm_hyp.h        |   4 +
>  arch/arm64/include/asm/sysreg.h         |   6 +
>  arch/arm64/kvm/arm.c                    |   4 +
>  arch/arm64/kvm/debug.c                  |   5 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  42 ++
>  arch/arm64/kvm/hyp/nvhe/Makefile        |   2 +-
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c      |   2 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c   |   6 -
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 114 +++++-
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c      | 501 ++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/debug-sr.c       |   2 +-
>  arch/arm64/kvm/pkvm.c                   |  31 ++
>  arch/arm64/kvm/sys_regs.c               |  62 +--
>  arch/arm64/kvm/sys_regs.h               |  35 ++
>  17 files changed, 782 insertions(+), 72 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
> 
> 
> base-commit: 35b256a5eebe3ac715b4ea6234aa4236a10d1a88
> -- 
> 2.32.0.rc1.229.g3e70b5a671-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
