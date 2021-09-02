Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E44EC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 21:01:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B894660FDC
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 21:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B894660FDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BEBA4B14C;
	Thu,  2 Sep 2021 17:01:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AbjNU9fdheCJ; Thu,  2 Sep 2021 17:01:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CE424B131;
	Thu,  2 Sep 2021 17:01:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78F344B10A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 15:23:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pRR2-Hz5MfvA for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 15:23:43 -0400 (EDT)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4217B4A524
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 15:23:43 -0400 (EDT)
Received: by mail-pf1-f173.google.com with SMTP id u6so2473770pfi.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 12:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=bdRaYL9hM7jiSCUixVQ5zx2AOjhox/HWm2JZjrik6sU=;
 b=P6U3y4+NDgkwLnM7k8tfRmmQNz3FbNimiCjNiDzg2c4/b7cnIMnSgSLYgren5AfpBQ
 FZjBRxEBn/G+JsgTKmLNhBdQ3PtvRchAl+Cd29xQTm+I7A1i4NZ7Izvqp8JwhPR2pQRZ
 Pe8En2Gn2SzcvcfwBCnUDGnLJRsYhSfO3EESmVQl+nTrENWKUYTOG/2PuU/7vl0YaJ09
 V4pmW7LbA0lUJAXT8HrSCOSTkZfuLfCqwmGZE4pVqzcVE1cI6tu3Njp2a0dTpa1LrXfm
 G2uSzRx/JfYiBUtlBJISj6kjnMu9P3OqSnzIN8uEKwvwm9ZnWSwh+yto/yk3zDWuYh+j
 SxBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bdRaYL9hM7jiSCUixVQ5zx2AOjhox/HWm2JZjrik6sU=;
 b=HOlcUlBwKfH9e2fLV2IoOvKtOmaIk84o68cBEBiWlM9SBw5C4f+7gvtTl20d8uur2V
 B0fdMawRwdmN68L0jo7gSCCIK6P3NUb4Fl5I0vTMOhaaxI3EsN34XQ84v4ltRLz0s0Qx
 mlDimmjIL7WhWTiWfDCI396pm0F/6lF61aALMHtHS0GCQy1AGvUhlgc9KycP0V9cJb6x
 31Yp5vZI4uRnhozKgr1ElUWMTyXGfeMur8t0xUaCaIber0SV6R0XdzffoU57TWp3kxLC
 wq2CxtTz0T2KJpPkj054r2ZJgTaEANIeJqdGUeFpXzFGJedphUM7ApUS4UdPoC3Ik93O
 QFMw==
X-Gm-Message-State: AOAM532MMJPrSXIUPTfGM+XcneOZ3/KBT+DGf3u56tQ1O+Ivq4cKJM/s
 ffUGWc+BRHrgT0rC8yRSYJh3+g==
X-Google-Smtp-Source: ABdhPJzBzFjoSYZppoJqGPeszZnPa1tw+Regznd0m+yvwVLEvAxR/W5mnHB1AAD6LnodpA7epZnM1g==
X-Received: by 2002:a63:1a64:: with SMTP id a36mr4666097pgm.225.1630610622242; 
 Thu, 02 Sep 2021 12:23:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id s83sm3183628pfc.204.2021.09.02.12.23.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Sep 2021 12:23:41 -0700 (PDT)
Date: Thu, 2 Sep 2021 19:23:37 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v7 0/6] KVM: x86: Add idempotent controls for migrating
 system counter state
Message-ID: <YTEkuXQ1cNhPoqP1@google.com>
References: <20210816001130.3059564-1-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210816001130.3059564-1-oupton@google.com>
X-Mailman-Approved-At: Thu, 02 Sep 2021 17:01:18 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Mon, Aug 16, 2021, Oliver Upton wrote:
> Applies cleanly to kvm/queue.
> 
> Parent commit: a3e0b8bd99ab ("KVM: MMU: change tracepoints arguments to kvm_page_fault")

This needs a rebase, patch 2 and presumably patch 3 conflict with commit
77fcbe823f00 ("KVM: x86: Prevent 'hv_clock->system_time' from going negative in
kvm_guest_time_update()").

> v6: https://lore.kernel.org/r/20210804085819.846610-1-oupton@google.com
> 
> v6 -> v7:
>  - Separated x86, arm64, and selftests into different series
>  - Rebased on top of kvm/queue
> 
> Oliver Upton (6):
>   KVM: x86: Fix potential race in KVM_GET_CLOCK
>   KVM: x86: Create helper methods for KVM_{GET,SET}_CLOCK ioctls
>   KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
>   KVM: x86: Take the pvclock sync lock behind the tsc_write_lock
>   KVM: x86: Refactor tsc synchronization code
>   KVM: x86: Expose TSC offset controls to userspace
> 
>  Documentation/virt/kvm/api.rst          |  42 ++-
>  Documentation/virt/kvm/devices/vcpu.rst |  57 ++++
>  Documentation/virt/kvm/locking.rst      |  11 +
>  arch/x86/include/asm/kvm_host.h         |   4 +
>  arch/x86/include/uapi/asm/kvm.h         |   4 +
>  arch/x86/kvm/x86.c                      | 362 +++++++++++++++++-------
>  include/uapi/linux/kvm.h                |   7 +-
>  7 files changed, 378 insertions(+), 109 deletions(-)
> 
> -- 
> 2.33.0.rc1.237.g0d66db33f3-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
