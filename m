Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83801C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 15:00:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26A894BA7F;
	Fri, 25 Feb 2022 10:00:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V+tr5FukQrVC; Fri, 25 Feb 2022 10:00:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2F6E4BAE8;
	Fri, 25 Feb 2022 09:59:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 030354BC04
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:59:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6POZycxjzpwJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 22:59:15 -0500 (EST)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
 [209.85.128.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 681714BBE4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:59:15 -0500 (EST)
Received: by mail-wm1-f41.google.com with SMTP id i19so936413wmq.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 19:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
 bh=tA/ZSMp3IJuiKY/7Y5ZTiqONzRTKyArYwt1620XaDiA=;
 b=sXDDJLdAAfXghdOOJT1NTFmyMgF4A1MxnC0N/zJlHVfaF4UVezKfvquQ3pwgrQREGW
 2xRnNrTpFW8KoCYoygN3JMMdc58so0KA/Fl/Hf8NDSFk/pTUofSBNyXj6tGOIrEcFC10
 zhYBqS2ZKH/nZTCBVx54UL4sfRFBVski8OH8vpu2PhcYijOD7CwRymud+rkMRSLKjofw
 cv9EcoElc4Wvx0snfN+JSxifzyuywGXJHL0Ocj1YAKkGAKnx3/jeiAKKVnnf4p8qYmYz
 mPgFw6+NIEZdemZu06JpfXDZSsJykMpnd5v0SwsfCORA4aUJcDnS3VcQL7YCbeEh9PjS
 Dbig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:cc;
 bh=tA/ZSMp3IJuiKY/7Y5ZTiqONzRTKyArYwt1620XaDiA=;
 b=IA0Bmf0PxkNP2E+cvnfCPpNIH0TF7QiQwzVkN7iaHrYykcWADi3S7clRixrrsjCgkL
 0KXSOkIScjIZFinOIsIy+72doBnMtrUZNDVXOsFLXlnr5Cxh486OdsGflQ03EUPtaKGC
 NnDVCJ6RXZ++fh8S3eagwpNhgO/1xByfIkvk4uWr1rcUhcppyvC+HRU+/xwGh0aVx5yF
 Ox8PKzhiGbY3vcF4vyUYyRs1uHozld1biyby7c4I3am2bgL5Q2W5PJM0UTa2FXNKF4uN
 +aMVwwVm52FOfCDnjHAd9PjunZxyy1l7DWZM0LujUi/KWQaQDmBSGRvo0cp9Ga6NeYcv
 590g==
X-Gm-Message-State: AOAM531qff9RT+b4zd+dtZ8nvAPUCQhl+YxDT4dIvB2Ae6kaMpLxaO20
 M+UZHo6nNjmlEwrjf2V/wLROHfL60YiN2GaGQG8RLA==
X-Received: by 2002:a05:600c:218d:b0:37f:a920:9705 with SMTP id
 e13-20020a05600c218d00b0037fa9209705mt419055wme.86.1645761554185; Thu, 24 Feb
 2022 19:59:14 -0800 (PST)
MIME-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
In-Reply-To: <20220224051439.640768-1-kaleshsingh@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 24 Feb 2022 19:59:03 -0800
Message-ID: <CAC_TJvfjGHN95UaVK92s_BovJWb0HyfXKD8r=7fkzcG5avuU-A@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] KVM: arm64: Hypervisor stack enhancements
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>, Andrew Walbran <qwandor@google.com>,
 Marc Zyngier <maz@kernel.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Suren Baghdasaryan <surenb@google.com>, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
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

On Wed, Feb 23, 2022 at 9:15 PM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Hi all,
>
> This is v3 of the nVHE hypervisor stack enhancements.

Please find the latest version v4, posted at:
https://lore.kernel.org/r/20220225033548.1912117-1-kaleshsingh@google.com/

Thanks,
Kalesh

>
> Previous versions can be found at:
> v2: https://lore.kernel.org/r/20220222165212.2005066-1-kaleshsingh@google.com/
> v1: https://lore.kernel.org/r/20220210224220.4076151-1-kaleshsingh@google.com/
>
> The main update in this version is that the unwinder now uses the core logic
> from the regular kernel stack unwinder to avoid duplicate code, per Mark; along
> with fixes for the other issues identified in v2.
>
> The previous cover letter (with updated call trace) has been copied below.
>
> Thanks,
> Kalesh
>
> -----
>
> This series is based on 5.17-rc5 and adds the following stack features to
> the KVM nVHE hypervisor:
>
> == Hyp Stack Guard Pages ==
>
> Based on the technique used by arm64 VMAP_STACK to detect overflow.
> i.e. the stack is aligned to twice its size which ensure that the
> 'stack shift' bit of any valid SP is 0. The 'stack shift' bit can be
> tested in the exception entry to detect overflow without corrupting GPRs.
>
> == Hyp Stack Unwinder ==
>
> Based on the arm64 kernel stack unwinder
> (See: arch/arm64/kernel/stacktrace.c)
>
> The unwinding and dumping of the hyp stack is not enabled by default and
> depends on CONFIG_NVHE_EL2_DEBUG to avoid potential information leaks.
>
> When CONFIG_NVHE_EL2_DEBUG is enabled the host stage 2 protection is
> disabled, allowing the host to read the hypervisor stack pages and unwind
> the stack from EL1. This allows us to print the hypervisor stacktrace
> before panicking the host; as shown below.
>
> Example call trace:
>
> [   98.916444][  T426] kvm [426]: nVHE hyp panic at: [<ffffffc0096156fc>] __kvm_nvhe_overflow_stack+0x8/0x34!
> [   98.918360][  T426] nVHE HYP call trace:
> [   98.918692][  T426] kvm [426]: [<ffffffc009615aac>] __kvm_nvhe_cpu_prepare_nvhe_panic_info+0x4c/0x68
> [   98.919545][  T426] kvm [426]: [<ffffffc0096159a4>] __kvm_nvhe_hyp_panic+0x2c/0xe8
> [   98.920107][  T426] kvm [426]: [<ffffffc009615ad8>] __kvm_nvhe_hyp_panic_bad_stack+0x10/0x10
> [   98.920665][  T426] kvm [426]: [<ffffffc009610a4c>] __kvm_nvhe___kvm_hyp_host_vector+0x24c/0x794
> [   98.921292][  T426] kvm [426]: [<ffffffc009615718>] __kvm_nvhe_overflow_stack+0x24/0x34
> . . .
>
> [   98.973382][  T426] kvm [426]: [<ffffffc009615718>] __kvm_nvhe_overflow_stack+0x24/0x34
> [   98.973816][  T426] kvm [426]: [<ffffffc0096152f4>] __kvm_nvhe___kvm_vcpu_run+0x38/0x438
> [   98.974255][  T426] kvm [426]: [<ffffffc009616f80>] __kvm_nvhe_handle___kvm_vcpu_run+0x1c4/0x364
> [   98.974719][  T426] kvm [426]: [<ffffffc009616928>] __kvm_nvhe_handle_trap+0xa8/0x130
> [   98.975152][  T426] kvm [426]: [<ffffffc009610064>] __kvm_nvhe___host_exit+0x64/0x64
> [   98.975588][  T426] ---- end of nVHE HYP call trace ----
>
>
> Kalesh Singh (8):
>   KVM: arm64: Introduce hyp_alloc_private_va_range()
>   KVM: arm64: Introduce pkvm_alloc_private_va_range()
>   KVM: arm64: Add guard pages for KVM nVHE hypervisor stack
>   KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack
>   KVM: arm64: Detect and handle hypervisor stack overflows
>   KVM: arm64: Add hypervisor overflow stack
>   KVM: arm64: Unwind and dump nVHE HYP stacktrace
>   KVM: arm64: Symbolize the nVHE HYP backtrace
>
>  arch/arm64/include/asm/kvm_asm.h     |  20 +++
>  arch/arm64/include/asm/kvm_mmu.h     |   4 +
>  arch/arm64/include/asm/stacktrace.h  |  12 ++
>  arch/arm64/kernel/stacktrace.c       | 210 ++++++++++++++++++++++++---
>  arch/arm64/kvm/Kconfig               |   5 +-
>  arch/arm64/kvm/arm.c                 |  34 ++++-
>  arch/arm64/kvm/handle_exit.c         |  16 +-
>  arch/arm64/kvm/hyp/include/nvhe/mm.h |   3 +-
>  arch/arm64/kvm/hyp/nvhe/host.S       |  29 ++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c   |   5 +-
>  arch/arm64/kvm/hyp/nvhe/mm.c         |  51 ++++---
>  arch/arm64/kvm/hyp/nvhe/setup.c      |  25 +++-
>  arch/arm64/kvm/hyp/nvhe/switch.c     |  30 +++-
>  arch/arm64/kvm/mmu.c                 |  62 +++++---
>  scripts/kallsyms.c                   |   2 +-
>  15 files changed, 422 insertions(+), 86 deletions(-)
>
>
> base-commit: cfb92440ee71adcc2105b0890bb01ac3cddb8507
> --
> 2.35.1.473.g83b2b277ed-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
