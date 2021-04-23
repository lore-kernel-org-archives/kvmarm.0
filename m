Return-Path: <SRS0=8Q7i=JU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B57C433ED
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 11:42:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4703B61360
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 11:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4703B61360
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B185B4B501;
	Fri, 23 Apr 2021 07:42:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NuXb-WzO-67I; Fri, 23 Apr 2021 07:42:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAA6C4B323;
	Fri, 23 Apr 2021 07:42:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA5B4B4F8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 07:42:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h6WsBn0gt42l for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Apr 2021 07:42:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD014B4F7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 07:42:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619178144;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9y9s0/kIze+PBfxeAr2Wlk2a9Cc6XmYQ3nYI9o69Vvs=;
 b=RX8UOk1uuhDcwXRu2VaK/zIBfq+enoHt1+gRlZyQqCgsWG1cpvi1Svfp83+fLfYtTbx7Ow
 T0oX9twStwC2S38uZpLi9mZqZPfys2JYG1wVE0SvNtVTTPfjTnAzI1ji3ZhUcFAJnZe2oS
 s85XWwhu/lEm7L4IwaAGJ9a6fEmlnoE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-rEv17vyXM-G-3aDw_nS52A-1; Fri, 23 Apr 2021 07:42:21 -0400
X-MC-Unique: rEv17vyXM-G-3aDw_nS52A-1
Received: by mail-ed1-f70.google.com with SMTP id
 cz7-20020a0564021ca7b02903853d41d8adso9175339edb.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 04:42:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=9y9s0/kIze+PBfxeAr2Wlk2a9Cc6XmYQ3nYI9o69Vvs=;
 b=Z1Ddr+Hjq29oi0rA179ZJ3K9hQrNO+VahlrX7JKogzyx0j8S+E/IHu2CXPkGSw6MD5
 HZdUalYwOh7hz4BJBA9EZiXoJO3eVh50RMB+xXMZgYqmFlxK2GBJg8SyPFMCWlPcPNuy
 bC4TjfHpX88s0hTCYmlTmx/d/CWn0bxWiNb5w/8HE9kqqc6NYf+R0YQB/l/PuYIqPY6b
 KZqgpX66NZyu8L5HyMnUjg0NBpdBLGau3hmV24TpOH0kRCm4vw772I6nrRaxB0DkTqXD
 WVa9wsjDu1n7Uo1eNVsRxU6PhNbJCDckYkZ2Ff19QRLqBGfFAE5u10kvMhZTiYDRn9ur
 E56A==
X-Gm-Message-State: AOAM533iOcoJXjgBEntyqQZTIlGwoH0/5aR9Bp69M1WlUFQwZtXuxtAc
 bjQi3oumq5NWh1g9NRFkHz1sll07BgsVrCwX0mCQc7pTi8QBNQe5ezqzBdsiuXd1iGXOLVafq0A
 s/9g2RqW14Su/d7HtXNxMTHBs
X-Received: by 2002:a05:6402:17f7:: with SMTP id
 t23mr3906187edy.76.1619178139839; 
 Fri, 23 Apr 2021 04:42:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBfHY9x5uI25KyLzJnMErvi2TcOxlActSLc1rHMWmirnwSXgnyyyUx7JJ5G5g3y8SssDpCRA==
X-Received: by 2002:a05:6402:17f7:: with SMTP id
 t23mr3906157edy.76.1619178139508; 
 Fri, 23 Apr 2021 04:42:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id jt20sm3756190ejb.79.2021.04.23.04.42.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 23 Apr 2021 04:42:18 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.13
To: Marc Zyngier <maz@kernel.org>
References: <20210423113544.1726204-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <04ffb298-430d-c1fe-b1cd-8670cac5e888@redhat.com>
Date: Fri, 23 Apr 2021 13:42:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210423113544.1726204-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Xu Jia <xujia39@huawei.com>, Daniel Kiss <daniel.kiss@arm.com>,
 Will Deacon <will@kernel.org>, Jon Hunter <jonathanh@nvidia.com>,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Richard Cochran <richardcochran@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Mathieu Poirier <mathieu.poirier@linaro.org>, linux-kernel@vger.kernel.org,
 Shenming Lu <lushenming@huawei.com>
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

On 23/04/21 13:35, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the rather large pull request for 5.13. Changes are all over
> the map, but the big ticket items are the S2 host isolation when
> running in protected mode, the save/restore support for GICv4.1 and
> guest SVE support in nVHE mode. Plenty of fixes too.
> 
> Note that this pull request drags a number of branches from other
> trees in order to avoid conflicts and make people's life easier:
> 
> - the Coresight ETE/TRBE branch, as it is intertwined with the KVM
>    tracing support
> 
> - the arm64 vhe-only branch that deals with broken CPUs such as the
>    Apple M1
> 
> - the arm64 neon-softirqs-disabled that improves the support for
>    FP processing
> 
> You will still get a couple of conflicts with the KVM tree, but these
> are absolutely trivial to resolve.

Great, thanks.  I've pulled, it and will send the pull request to Linus 
around mid week to let these go in first.

Paolo

> Please pull,
> 
> 	M.
> 
> The following changes since commit 1e28eed17697bcf343c6743f0028cc3b5dd88bf0:
> 
>    Linux 5.12-rc3 (2021-03-14 14:41:02 -0700)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.13
> 
> for you to fetch changes up to 9a8aae605b80fc0a830cdce747eed48e11acc067:
> 
>    Merge branch 'kvm-arm64/kill_oprofile_dependency' into kvmarm-master/next (2021-04-22 13:41:49 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 updates for Linux 5.13
> 
> New features:
> 
> - Stage-2 isolation for the host kernel when running in protected mode
> - Guest SVE support when running in nVHE mode
> - Force W^X hypervisor mappings in nVHE mode
> - ITS save/restore for guests using direct injection with GICv4.1
> - nVHE panics now produce readable backtraces
> - Guest support for PTP using the ptp_kvm driver
> - Performance improvements in the S2 fault handler
> - Alexandru is now a reviewer (not really a new feature...)
> 
> Fixes:
> - Proper emulation of the GICR_TYPER register
> - Handle the complete set of relocation in the nVHE EL2 object
> - Get rid of the oprofile dependency in the PMU code (and of the
>    oprofile body parts at the same time)
> - Debug and SPE fixes
> - Fix vcpu reset
> 
> ----------------------------------------------------------------
> Alexandru Elisei (4):
>        Documentation: KVM: Document KVM_GUESTDBG_USE_HW control flag for arm64
>        KVM: arm64: Initialize VCPU mdcr_el2 before loading it
>        KVM: arm64: Don't print warning when trapping SPE registers
>        KVM: arm64: Don't advertise FEAT_SPE to guests
> 
> Andrew Scull (5):
>        bug: Remove redundant condition check in report_bug
>        bug: Factor out a getter for a bug's file line
>        bug: Assign values once in bug_get_file_line()
>        KVM: arm64: Use BUG and BUG_ON in nVHE hyp
>        KVM: arm64: Log source when panicking from nVHE hyp
> 
> Anshuman Khandual (5):
>        arm64: Add TRBE definitions
>        coresight: core: Add support for dedicated percpu sinks
>        coresight: sink: Add TRBE driver
>        Documentation: coresight: trbe: Sysfs ABI description
>        Documentation: trace: Add documentation for TRBE
> 
> Ard Biesheuvel (3):
>        arm64: assembler: remove conditional NEON yield macros
>        arm64: assembler: introduce wxN aliases for wN registers
>        arm64: fpsimd: run kernel mode NEON with softirqs disabled
> 
> Daniel Kiss (1):
>        KVM: arm64: Enable SVE support for nVHE
> 
> David Brazdil (1):
>        KVM: arm64: Support PREL/PLT relocs in EL2 code
> 
> Eric Auger (11):
>        KVM: arm64: vgic-v3: Fix some error codes when setting RDIST base
>        KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read
>        KVM: arm64: vgic-v3: Fix error handling in vgic_v3_set_redist_base()
>        KVM: arm/arm64: vgic: Reset base address on kvm_vgic_dist_destroy()
>        docs: kvm: devices/arm-vgic-v3: enhance KVM_DEV_ARM_VGIC_CTRL_INIT doc
>        KVM: arm64: Simplify argument passing to vgic_uaccess_[read|write]
>        kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_region()
>        KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for userspace
>        KVM: selftests: aarch64/vgic-v3 init sequence tests
>        KVM: selftests: vgic_init kvm selftests fixup
>        KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
> 
> Gavin Shan (3):
>        KVM: arm64: Hide kvm_mmu_wp_memory_region()
>        KVM: arm64: Use find_vma_intersection()
>        KVM: arm64: Don't retrieve memory slot again in page fault handler
> 
> Jianyong Wu (4):
>        ptp: Reorganize ptp_kvm.c to make it arch-independent
>        clocksource: Add clocksource id for arm arch counter
>        KVM: arm64: Add support for the KVM PTP service
>        ptp: arm/arm64: Enable ptp_kvm for arm/arm64
> 
> Jon Hunter (1):
>        ptp: Don't print an error if ptp_kvm is not supported
> 
> Marc Zyngier (50):
>        KVM: arm64: Provide KVM's own save/restore SVE primitives
>        KVM: arm64: Use {read,write}_sysreg_el1 to access ZCR_EL1
>        KVM: arm64: Let vcpu_sve_pffr() handle HYP VAs
>        KVM: arm64: Introduce vcpu_sve_vq() helper
>        arm64: sve: Provide a conditional update accessor for ZCR_ELx
>        KVM: arm64: Rework SVE host-save/guest-restore
>        KVM: arm64: Map SVE context at EL2 when available
>        KVM: arm64: Save guest's ZCR_EL1 before saving the FPSIMD state
>        KVM: arm64: Trap host SVE accesses when the FPSIMD state is dirty
>        KVM: arm64: Save/restore SVE state for nVHE
>        arm64: Use INIT_SCTLR_EL1_MMU_OFF to disable the MMU on CPU restart
>        KVM: arm64: Use INIT_SCTLR_EL2_MMU_OFF to disable the MMU on KVM teardown
>        KVM: arm64: Turn SCTLR_ELx_FLAGS into INIT_SCTLR_EL2_MMU_ON
>        KVM: arm64: Force SCTLR_EL2.WXN when running nVHE
>        KVM: arm64: Fix host's ZCR_EL2 restore on nVHE
>        Merge tag 'v5.12-rc3' into kvm-arm64/host-stage2
>        irqchip/gic-v3-its: Add a cache invalidation right after vPE unmapping
>        KVM: arm64: Generate final CTR_EL0 value when running in Protected mode
>        KVM: arm64: Drop the CPU_FTR_REG_HYP_COPY infrastructure
>        KVM: arm64: Elect Alexandru as a replacement for Julien as a reviewer
>        KVM: arm64: Mark the kvmarm ML as moderated for non-subscribers
>        KVM: arm64: Fix table format for PTP documentation
>        Merge remote-tracking branch 'coresight/next-ETE-TRBE' into kvmarm-master/next
>        arm64: cpufeature: Allow early filtering of feature override
>        arm64: Cope with CPUs stuck in VHE mode
>        arm64: Get rid of CONFIG_ARM64_VHE
>        KVM: arm64: Clarify vcpu reset behaviour
>        KVM: arm64: Fully zero the vcpu state on reset
>        Merge branch 'kvm-arm64/debug-5.13' into kvmarm-master/next
>        Merge branch 'kvm-arm64/host-stage2' into kvmarm-master/next
>        Merge branch 'kvm-arm64/memslot-fixes' into kvmarm-master/next
>        Merge branch 'kvm-arm64/misc-5.13' into kvmarm-master/next
>        Merge branch 'kvm-arm64/nvhe-panic-info' into kvmarm-master/next
>        Merge branch 'kvm-arm64/nvhe-sve' into kvmarm-master/next
>        Merge branch 'kvm-arm64/nvhe-wxn' into kvmarm-master/next
>        Merge branch 'kvm-arm64/ptp' into kvmarm-master/next
>        Merge branch 'kvm-arm64/vgic-5.13' into kvmarm-master/next
>        Merge branch 'kvm-arm64/vlpi-save-restore' into kvmarm-master/next
>        Merge remote-tracking branch 'arm64/for-next/vhe-only' into kvmarm-master/next
>        Merge remote-tracking branch 'arm64/for-next/neon-softirqs-disabled' into kvmarm-master/next
>        Merge remote-tracking branch 'coresight/next-ETE-TRBE' into kvmarm-master/next
>        bug: Provide dummy version of bug_get_file_line() when !GENERIC_BUG
>        Merge branch 'kvm-arm64/nvhe-panic-info' into kvmarm-master/next
>        Merge branch 'kvm-arm64/ptp' into kvmarm-master/next
>        KVM: arm64: Divorce the perf code from oprofile helpers
>        arm64: Get rid of oprofile leftovers
>        s390: Get rid of oprofile leftovers
>        sh: Get rid of oprofile leftovers
>        perf: Get rid of oprofile leftovers
>        Merge branch 'kvm-arm64/kill_oprofile_dependency' into kvmarm-master/next
> 
> Quentin Perret (35):
>        KVM: arm64: Initialize kvm_nvhe_init_params early
>        KVM: arm64: Avoid free_page() in page-table allocator
>        KVM: arm64: Factor memory allocation out of pgtable.c
>        KVM: arm64: Introduce a BSS section for use at Hyp
>        KVM: arm64: Make kvm_call_hyp() a function call at Hyp
>        KVM: arm64: Allow using kvm_nvhe_sym() in hyp code
>        KVM: arm64: Introduce an early Hyp page allocator
>        KVM: arm64: Stub CONFIG_DEBUG_LIST at Hyp
>        KVM: arm64: Introduce a Hyp buddy page allocator
>        KVM: arm64: Enable access to sanitized CPU features at EL2
>        KVM: arm64: Provide __flush_dcache_area at EL2
>        KVM: arm64: Factor out vector address calculation
>        arm64: asm: Provide set_sctlr_el2 macro
>        KVM: arm64: Prepare the creation of s1 mappings at EL2
>        KVM: arm64: Elevate hypervisor mappings creation at EL2
>        KVM: arm64: Use kvm_arch for stage 2 pgtable
>        KVM: arm64: Use kvm_arch in kvm_s2_mmu
>        KVM: arm64: Set host stage 2 using kvm_nvhe_init_params
>        KVM: arm64: Refactor kvm_arm_setup_stage2()
>        KVM: arm64: Refactor __load_guest_stage2()
>        KVM: arm64: Refactor __populate_fault_info()
>        KVM: arm64: Make memcache anonymous in pgtable allocator
>        KVM: arm64: Reserve memory for host stage 2
>        KVM: arm64: Sort the hypervisor memblocks
>        KVM: arm64: Always zero invalid PTEs
>        KVM: arm64: Use page-table to track page ownership
>        KVM: arm64: Refactor the *_map_set_prot_attr() helpers
>        KVM: arm64: Add kvm_pgtable_stage2_find_range()
>        KVM: arm64: Introduce KVM_PGTABLE_S2_NOFWB stage 2 flag
>        KVM: arm64: Introduce KVM_PGTABLE_S2_IDMAP stage 2 flag
>        KVM: arm64: Provide sanitized mmfr* registers at EL2
>        KVM: arm64: Wrap the host with a stage 2
>        KVM: arm64: Page-align the .hyp sections
>        KVM: arm64: Disable PMU support in protected mode
>        KVM: arm64: Protect the .hyp sections from the host
> 
> Shenming Lu (4):
>        irqchip/gic-v3-its: Drop the setting of PTZ altogether
>        KVM: arm64: GICv4.1: Add function to get VLPI state
>        KVM: arm64: GICv4.1: Try to save VLPI state in save_pending_tables
>        KVM: arm64: GICv4.1: Give a chance to save VLPI state
> 
> Suzuki K Poulose (17):
>        KVM: arm64: Hide system instruction access to Trace registers
>        KVM: arm64: Disable guest access to trace filter controls
>        perf: aux: Add flags for the buffer format
>        perf: aux: Add CoreSight PMU buffer formats
>        arm64: Add support for trace synchronization barrier
>        KVM: arm64: Handle access to TRFCR_EL1
>        KVM: arm64: Move SPE availability check to VCPU load
>        arm64: KVM: Enable access to TRBE support for host
>        coresight: etm4x: Move ETM to prohibited region for disable
>        coresight: etm-perf: Allow an event to use different sinks
>        coresight: Do not scan for graph if none is present
>        coresight: etm4x: Add support for PE OS lock
>        coresight: ete: Add support for ETE sysreg access
>        coresight: ete: Add support for ETE tracing
>        dts: bindings: Document device tree bindings for ETE
>        coresight: etm-perf: Handle stale output handles
>        dts: bindings: Document device tree bindings for Arm TRBE
> 
> Thomas Gleixner (1):
>        time: Add mechanism to recognize clocksource in time_get_snapshot
> 
> Wang Wensheng (1):
>        KVM: arm64: Fix error return code in init_hyp_mode()
> 
> Wei Yongjun (2):
>        coresight: core: Make symbol 'csdev_sink' static
>        coresight: trbe: Fix return value check in arm_trbe_register_coresight_cpu()
> 
> Will Deacon (5):
>        arm64: lib: Annotate {clear, copy}_page() as position-independent
>        KVM: arm64: Link position-independent string routines into .hyp.text
>        arm64: kvm: Add standalone ticket spinlock implementation for use at hyp
>        arm/arm64: Probe for the presence of KVM hypervisor
>        KVM: arm64: Advertise KVM UID to guests via SMCCC
> 
> Xiaofei Tan (1):
>        arm64: sve: Provide sve_cond_update_zcr_vq fallback when !ARM64_SVE
> 
> Xu Jia (1):
>        KVM: arm64: Make symbol '_kvm_host_prot_finalize' static
> 
> Zenghui Yu (2):
>        KVM: arm64: GICv4.1: Restore VLPI pending state to physical side
>        KVM: arm64: Fix Function ID typo for PTP_KVM service
> 
>   .../ABI/testing/sysfs-bus-coresight-devices-trbe   |   14 +
>   Documentation/admin-guide/kernel-parameters.txt    |    3 +-
>   Documentation/devicetree/bindings/arm/ete.yaml     |   75 ++
>   Documentation/devicetree/bindings/arm/trbe.yaml    |   49 +
>   Documentation/trace/coresight/coresight-trbe.rst   |   38 +
>   Documentation/virt/kvm/api.rst                     |   25 +-
>   Documentation/virt/kvm/arm/index.rst               |    1 +
>   Documentation/virt/kvm/arm/ptp_kvm.rst             |   25 +
>   Documentation/virt/kvm/devices/arm-vgic-its.rst    |    2 +-
>   Documentation/virt/kvm/devices/arm-vgic-v3.rst     |    2 +-
>   MAINTAINERS                                        |    6 +-
>   arch/arm/include/asm/hypervisor.h                  |    3 +
>   arch/arm64/Kconfig                                 |   20 -
>   arch/arm64/crypto/aes-modes.S                      |    2 +-
>   arch/arm64/crypto/sha1-ce-core.S                   |    2 +-
>   arch/arm64/crypto/sha2-ce-core.S                   |    2 +-
>   arch/arm64/crypto/sha3-ce-core.S                   |    4 +-
>   arch/arm64/crypto/sha512-ce-core.S                 |    2 +-
>   arch/arm64/include/asm/assembler.h                 |  129 +--
>   arch/arm64/include/asm/barrier.h                   |    1 +
>   arch/arm64/include/asm/cpufeature.h                |   17 +
>   arch/arm64/include/asm/el2_setup.h                 |   13 +
>   arch/arm64/include/asm/fpsimd.h                    |   11 +
>   arch/arm64/include/asm/fpsimdmacros.h              |   10 +-
>   arch/arm64/include/asm/hyp_image.h                 |    7 +
>   arch/arm64/include/asm/hypervisor.h                |    3 +
>   arch/arm64/include/asm/kvm_arm.h                   |    3 +
>   arch/arm64/include/asm/kvm_asm.h                   |    9 +
>   arch/arm64/include/asm/kvm_host.h                  |   46 +-
>   arch/arm64/include/asm/kvm_hyp.h                   |   14 +-
>   arch/arm64/include/asm/kvm_mmu.h                   |   25 +-
>   arch/arm64/include/asm/kvm_pgtable.h               |  164 ++-
>   arch/arm64/include/asm/pgtable-prot.h              |    4 +-
>   arch/arm64/include/asm/sections.h                  |    1 +
>   arch/arm64/include/asm/sysreg.h                    |   59 +-
>   arch/arm64/kernel/asm-offsets.c                    |    5 +
>   arch/arm64/kernel/cpu-reset.S                      |    5 +-
>   arch/arm64/kernel/cpufeature.c                     |   11 +-
>   arch/arm64/kernel/fpsimd.c                         |    4 +-
>   arch/arm64/kernel/head.S                           |   39 +-
>   arch/arm64/kernel/hyp-stub.S                       |   13 +-
>   arch/arm64/kernel/idreg-override.c                 |   26 +-
>   arch/arm64/kernel/image-vars.h                     |   34 +-
>   arch/arm64/kernel/vmlinux.lds.S                    |   74 +-
>   arch/arm64/kvm/arm.c                               |  216 +++-
>   arch/arm64/kvm/debug.c                             |  116 +-
>   arch/arm64/kvm/fpsimd.c                            |   26 +-
>   arch/arm64/kvm/guest.c                             |    6 +-
>   arch/arm64/kvm/handle_exit.c                       |   45 +
>   arch/arm64/kvm/hyp/Makefile                        |    2 +-
>   arch/arm64/kvm/hyp/fpsimd.S                        |   10 +
>   arch/arm64/kvm/hyp/include/hyp/switch.h            |  107 +-
>   arch/arm64/kvm/hyp/include/nvhe/early_alloc.h      |   14 +
>   arch/arm64/kvm/hyp/include/nvhe/gfp.h              |   68 ++
>   arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |   36 +
>   arch/arm64/kvm/hyp/include/nvhe/memory.h           |   51 +
>   arch/arm64/kvm/hyp/include/nvhe/mm.h               |   96 ++
>   arch/arm64/kvm/hyp/include/nvhe/spinlock.h         |   92 ++
>   arch/arm64/kvm/hyp/nvhe/Makefile                   |    9 +-
>   arch/arm64/kvm/hyp/nvhe/cache.S                    |   13 +
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |   56 +-
>   arch/arm64/kvm/hyp/nvhe/early_alloc.c              |   54 +
>   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c               |   18 +
>   arch/arm64/kvm/hyp/nvhe/host.S                     |   18 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |   54 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   75 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-smp.c                  |    6 +-
>   arch/arm64/kvm/hyp/nvhe/hyp.lds.S                  |    1 +
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  279 +++++
>   arch/arm64/kvm/hyp/nvhe/mm.c                       |  173 +++
>   arch/arm64/kvm/hyp/nvhe/page_alloc.c               |  195 ++++
>   arch/arm64/kvm/hyp/nvhe/psci-relay.c               |    4 +-
>   arch/arm64/kvm/hyp/nvhe/setup.c                    |  214 ++++
>   arch/arm64/kvm/hyp/nvhe/stub.c                     |   22 +
>   arch/arm64/kvm/hyp/nvhe/switch.c                   |   26 +-
>   arch/arm64/kvm/hyp/nvhe/tlb.c                      |    4 +-
>   arch/arm64/kvm/hyp/pgtable.c                       |  410 +++++--
>   arch/arm64/kvm/hyp/reserved_mem.c                  |  113 ++
>   arch/arm64/kvm/hyp/vhe/switch.c                    |    4 +-
>   arch/arm64/kvm/hypercalls.c                        |   80 +-
>   arch/arm64/kvm/mmu.c                               |  136 ++-
>   arch/arm64/kvm/perf.c                              |    7 +-
>   arch/arm64/kvm/pmu-emul.c                          |    2 +-
>   arch/arm64/kvm/pmu.c                               |    8 +-
>   arch/arm64/kvm/reset.c                             |   51 +-
>   arch/arm64/kvm/sys_regs.c                          |   16 +
>   arch/arm64/kvm/va_layout.c                         |    7 +
>   arch/arm64/kvm/vgic/vgic-init.c                    |   12 +-
>   arch/arm64/kvm/vgic/vgic-its.c                     |    6 +-
>   arch/arm64/kvm/vgic/vgic-kvm-device.c              |    7 +-
>   arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   81 +-
>   arch/arm64/kvm/vgic/vgic-mmio.c                    |   10 +-
>   arch/arm64/kvm/vgic/vgic-v3.c                      |   66 +-
>   arch/arm64/kvm/vgic/vgic-v4.c                      |   38 +
>   arch/arm64/kvm/vgic/vgic.h                         |    2 +
>   arch/arm64/lib/clear_page.S                        |    4 +-
>   arch/arm64/lib/copy_page.S                         |    4 +-
>   arch/arm64/mm/init.c                               |    3 +
>   arch/s390/kernel/perf_event.c                      |   21 -
>   arch/sh/kernel/perf_event.c                        |   18 -
>   drivers/clocksource/arm_arch_timer.c               |   36 +
>   drivers/firmware/psci/psci.c                       |    2 +
>   drivers/firmware/smccc/Makefile                    |    2 +-
>   drivers/firmware/smccc/kvm_guest.c                 |   50 +
>   drivers/firmware/smccc/smccc.c                     |    1 +
>   drivers/hwtracing/coresight/Kconfig                |   24 +-
>   drivers/hwtracing/coresight/Makefile               |    1 +
>   drivers/hwtracing/coresight/coresight-core.c       |   29 +-
>   drivers/hwtracing/coresight/coresight-etm-perf.c   |  119 +-
>   drivers/hwtracing/coresight/coresight-etm4x-core.c |  161 ++-
>   .../hwtracing/coresight/coresight-etm4x-sysfs.c    |   19 +-
>   drivers/hwtracing/coresight/coresight-etm4x.h      |   83 +-
>   drivers/hwtracing/coresight/coresight-platform.c   |    6 +
>   drivers/hwtracing/coresight/coresight-priv.h       |    3 +
>   drivers/hwtracing/coresight/coresight-trbe.c       | 1157 ++++++++++++++++++++
>   drivers/hwtracing/coresight/coresight-trbe.h       |  152 +++
>   drivers/irqchip/irq-gic-v3-its.c                   |   18 +-
>   drivers/perf/arm_pmu.c                             |   30 -
>   drivers/ptp/Kconfig                                |    2 +-
>   drivers/ptp/Makefile                               |    2 +
>   drivers/ptp/ptp_kvm_arm.c                          |   28 +
>   drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c}        |   85 +-
>   drivers/ptp/ptp_kvm_x86.c                          |   97 ++
>   include/kvm/arm_pmu.h                              |    4 +
>   include/kvm/arm_vgic.h                             |    1 +
>   include/linux/arm-smccc.h                          |   41 +
>   include/linux/bug.h                                |   10 +
>   include/linux/clocksource.h                        |    6 +
>   include/linux/clocksource_ids.h                    |   12 +
>   include/linux/coresight.h                          |   13 +
>   include/linux/perf_event.h                         |    2 -
>   include/linux/ptp_kvm.h                            |   19 +
>   include/linux/timekeeping.h                        |   12 +-
>   include/uapi/linux/kvm.h                           |    1 +
>   include/uapi/linux/perf_event.h                    |   13 +-
>   kernel/events/core.c                               |    5 -
>   kernel/time/clocksource.c                          |    2 +
>   kernel/time/timekeeping.c                          |    1 +
>   lib/bug.c                                          |   54 +-
>   tools/testing/selftests/kvm/.gitignore             |    1 +
>   tools/testing/selftests/kvm/Makefile               |    1 +
>   tools/testing/selftests/kvm/aarch64/vgic_init.c    |  551 ++++++++++
>   tools/testing/selftests/kvm/include/kvm_util.h     |    9 +
>   tools/testing/selftests/kvm/lib/kvm_util.c         |   75 ++
>   144 files changed, 6298 insertions(+), 856 deletions(-)
>   create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-trbe
>   create mode 100644 Documentation/devicetree/bindings/arm/ete.yaml
>   create mode 100644 Documentation/devicetree/bindings/arm/trbe.yaml
>   create mode 100644 Documentation/trace/coresight/coresight-trbe.rst
>   create mode 100644 Documentation/virt/kvm/arm/ptp_kvm.rst
>   create mode 100644 arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
>   create mode 100644 arch/arm64/kvm/hyp/include/nvhe/gfp.h
>   create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
>   create mode 100644 arch/arm64/kvm/hyp/include/nvhe/memory.h
>   create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mm.h
>   create mode 100644 arch/arm64/kvm/hyp/include/nvhe/spinlock.h
>   create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S
>   create mode 100644 arch/arm64/kvm/hyp/nvhe/early_alloc.c
>   create mode 100644 arch/arm64/kvm/hyp/nvhe/mem_protect.c
>   create mode 100644 arch/arm64/kvm/hyp/nvhe/mm.c
>   create mode 100644 arch/arm64/kvm/hyp/nvhe/page_alloc.c
>   create mode 100644 arch/arm64/kvm/hyp/nvhe/setup.c
>   create mode 100644 arch/arm64/kvm/hyp/nvhe/stub.c
>   create mode 100644 arch/arm64/kvm/hyp/reserved_mem.c
>   create mode 100644 drivers/firmware/smccc/kvm_guest.c
>   create mode 100644 drivers/hwtracing/coresight/coresight-trbe.c
>   create mode 100644 drivers/hwtracing/coresight/coresight-trbe.h
>   create mode 100644 drivers/ptp/ptp_kvm_arm.c
>   rename drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (60%)
>   create mode 100644 drivers/ptp/ptp_kvm_x86.c
>   create mode 100644 include/linux/clocksource_ids.h
>   create mode 100644 include/linux/ptp_kvm.h
>   create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_init.c
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
