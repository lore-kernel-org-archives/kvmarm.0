Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F08C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 02:36:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA0374079D;
	Tue,  7 Dec 2021 21:36:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AomeHUVxR2XT; Tue,  7 Dec 2021 21:36:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B2184A49C;
	Tue,  7 Dec 2021 21:36:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51AAE4B105
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 21:36:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UNPrhpR-LIpY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 21:36:20 -0500 (EST)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DECBE40C88
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 21:36:19 -0500 (EST)
Received: by mail-pj1-f54.google.com with SMTP id
 np6-20020a17090b4c4600b001a90b011e06so946921pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 18:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VgCcQritJxHOUqDSS3wy0d4qnXbAMAnIh5SeZmixwqQ=;
 b=tes06FBZqKCo9Y7ju5kxQEzYa592EDnMj7damxBWpNcsQu3nSbI3vG3ldRMvDAxCHE
 p7cUs1oRgQN1OclVAGQFnEJf26ZQgBhbAqknHeOpdEEheabqz6h8/5IaBPkodoyPOBFL
 aEDFtKaCELj1WdbCuNJ4hzHPaQKdQhIGwGq7fhC8fTkITkS0oj3tE2emNaGVI+KJ61Zv
 0287MPnKFykVVeWRKrRXqE85oDvwreYADGjpRWHOFmwcRerIAkMcG6YnynQocn1fOTRZ
 lRsW3PeDH4RDz53399DOQ0ZHQju7992V2BPYfXjmDPXNCFQrVi8xW5FwpMv78vu2TUDO
 ewcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VgCcQritJxHOUqDSS3wy0d4qnXbAMAnIh5SeZmixwqQ=;
 b=xK+0sbxmXb4vNWcKvRgMniBhfqgwBt7w4AlBATMwurHs2OwUH8UbBl6a5QUolQ7bKH
 ZBajLxxYq7mISYBWXqaUGh8xGpyZWcnhaLN0MCOyo4/qWFOCG6SU4lKeFXny3VESVRSl
 NQXG62bx8cO9nPPkkXIpjPsjjpxovCjk7q4WZRVBsHX9LTk3x47ib5ysKzq8QOtR2gj8
 fw0E9F0sUXZkxuHWLoVRPzztJScm25z1jVUw3YKDgrCWuFrEW75m5YFmMAE9kgc9SgQi
 uI4Hj8IzE4lzBY2VYkS7aQlwoJRsNe4N9+lp/N91aoPXy4/L04YxZf/IICTogNBUNBhk
 4lFQ==
X-Gm-Message-State: AOAM533THcy4kezx7JXohr5faM6WBR6lrfOTm81KF5YT5NgC/dHfsz6c
 BTzyVphUsPDjKdo6KCsFQ7DqxYgsNu6hPMTypS1dxZg3MMYe6g==
X-Google-Smtp-Source: ABdhPJx2b97TnEido2HeJUfpDePFdMnFOly8LG56Ya2PMJa2bQZVgchdyqJvwHdNhWQvLVXGXpFEnV01IyiychXsx1c=
X-Received: by 2002:a17:90a:e506:: with SMTP id t6mr3670508pjy.9.1638930978813; 
 Tue, 07 Dec 2021 18:36:18 -0800 (PST)
MIME-Version: 1.0
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
In-Reply-To: <20211206170223.309789-1-alexandru.elisei@arm.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 7 Dec 2021 18:36:02 -0800
Message-ID: <CAAeT=FygprcS3YxbVaW+4yUjHBm8=MxZ+j4_iVjq7ie-ppRKRg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Improve PMU support on heterogeneous
 systems
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, mingo@redhat.com, tglx@linutronix.de, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Alex,

On Mon, Dec 6, 2021 at 9:02 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> (CC'ing Peter Maydell in case this might be of interest to qemu)
>
> The series can be found on a branch at [1], and the kvmtool support at [2].
> The kvmtool patches are also on the mailing list [3] and haven't changed
> since v1.
>
> Detailed explanation of the issue and symptoms that the patches attempt to
> correct can be found in the cover letter for v1 [4].
>
> A brief summary of the problem is that on heterogeneous systems KVM will
> always use the same PMU for creating the VCPU events for *all* VCPUs
> regardless of the physical CPU on which the VCPU is running, leading to
> events suddenly stopping and resuming in the guest as the VCPU thread gets
> migrated across different CPUs.
>
> This series proposes to fix this behaviour by allowing the user to specify
> which physical PMU is used when creating the VCPU events needed for guest
> PMU emulation. When the PMU is set, KVM will refuse to the VCPU on a
> physical which is not part of the supported CPUs for the specified PMU.

Just to confirm, this series provides an API for userspace to request
KVM to detect a wrong affinity setting due to a userspace bug so that
userspace can get an error at KVM_RUN instead of leading to events
suddenly stopping, correct ?


> The default behaviour stays the same - without userspace setting the PMU,
> events will stop counting if the VCPU is scheduled on the wrong CPU.

Can't we fix the default behavior (in addition to the current fix) ?
(Do we need to maintain the default behavior ??)
IMHO I feel it is better to prevent userspace from configuring PMU
for guests on such heterogeneous systems rather than leading to
events suddenly stopping even as the default behavior.

Thanks,
Reiji


>
> Changes since v1:
>
> - Rebased on top of v5.16-rc4
>
> - Implemented review comments: protect iterating through the list of PMUs
>   with a mutex, documentation changes, initialize vcpu-arch.supported_cpus
>   to cpu_possible_mask, changed vcpu->arch.cpu_not_supported to a VCPU
>   flag, set exit reason to KVM_EXIT_FAIL_ENTRY and populate fail_entry when
>   the VCPU is run on a CPU not in the PMU's supported cpumask. Many thanks
>   for the review!
>
> [1] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/pmu-big-little-fix-v2
> [2] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/pmu-big-little-fix-v1
> [3] https://www.spinics.net/lists/arm-kernel/msg933584.html
> [4] https://www.spinics.net/lists/arm-kernel/msg933579.html
>
> Alexandru Elisei (4):
>   perf: Fix wrong name in comment for struct perf_cpu_context
>   KVM: arm64: Keep a list of probed PMUs
>   KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
>   KVM: arm64: Refuse to run VCPU if the PMU doesn't match the physical
>     CPU
>
>  Documentation/virt/kvm/devices/vcpu.rst | 29 +++++++++++
>  arch/arm64/include/asm/kvm_host.h       | 12 +++++
>  arch/arm64/include/uapi/asm/kvm.h       |  4 ++
>  arch/arm64/kvm/arm.c                    | 19 ++++++++
>  arch/arm64/kvm/pmu-emul.c               | 64 +++++++++++++++++++++++--
>  include/kvm/arm_pmu.h                   |  6 +++
>  include/linux/perf_event.h              |  2 +-
>  tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
>  8 files changed, 132 insertions(+), 5 deletions(-)
>
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
