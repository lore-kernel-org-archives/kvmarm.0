Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B843DC4361A
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 19:23:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B95522203
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 19:23:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B95522203
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19DCD4B1E9;
	Thu,  3 Dec 2020 14:23:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UBC0Nh2Vz8pI; Thu,  3 Dec 2020 14:23:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF8C14B1E8;
	Thu,  3 Dec 2020 14:23:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 307854B198
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 14:23:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YZXOIYOO3U08 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 14:23:30 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04F8E4B186
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 14:23:29 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A7E73221EC;
 Thu,  3 Dec 2020 19:23:28 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kkuCM-00Flnv-BO; Thu, 03 Dec 2020 19:23:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v4 00/26] Opt-in always-on nVHE hypervisor
Date: Thu,  3 Dec 2020 19:23:19 +0000
Message-Id: <160702322202.1501317.9696987088711766533.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202184122.26046-1-dbrazdil@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, dbrazdil@google.com,
 catalin.marinas@arm.com, lorenzo.pieralisi@arm.com,
 linux-kernel@vger.kernel.org, will@kernel.org, tj@kernel.org,
 dennis@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org, cl@linux.com,
 sudeep.holla@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-doc@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
 Christoph Lameter <cl@linux.com>, linux-arm-kernel@lists.infradead.org
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

On Wed, 2 Dec 2020 18:40:56 +0000, David Brazdil wrote:
> As we progress towards being able to keep guest state private to the
> host running nVHE hypervisor, this series allows the hypervisor to
> install itself on newly booted CPUs before the host is allowed to run
> on them.
> 
> All functionality described below is opt-in, guarded by an early param
> 'kvm-arm.mode=protected'. Future patches specific to the new protected
> mode should be hidden behind the same param.
> 
> [...]

Applied to kvm-arm64/psci-relay, thanks!

Note that although I pushed it to -next, I still need people to
eyeball it and give it some Acks. The commit-IDs below will
thus change as I apply tags, if any.

[01/26] KVM: arm64: Add kvm-arm.mode early kernel parameter
        commit: 2d4b0ce5c9b62398522b4b078cfd2cc0fa3fb604
[02/26] KVM: arm64: Add ARM64_KVM_PROTECTED_MODE CPU capability
        commit: 44e88d43c442adcebebec5b9e23f260a03a25120
[03/26] psci: Support psci_ops.get_version for v0.1
        commit: 47e4000e4f6ea4496accf7e3e68c29f38ca4e179
[04/26] psci: Split functions to v0.1 and v0.2+ variants
        commit: 1fbb7db86fb5f1cd7a2c9ec9c477acb67ac986a7
[05/26] psci: Replace psci_function_id array with a struct
        commit: c801a91084f382ab8f9707bd33e6ccb7012e1e50
[06/26] psci: Add accessor for psci_0_1_function_ids
        commit: 26c9988c7330b2225ba39cae9de43b0bfff57e2a
[07/26] arm64: Make cpu_logical_map() take unsigned int
        commit: 2346f8b8ea0bb140d67ba6f06b67aec06e238dde
[08/26] arm64: Extract parts of el2_setup into a macro
        commit: 9c322020286c60fbdd97f6a8c41362be5f4f8bb9
[09/26] KVM: arm64: Remove vector_ptr param of hyp-init
        commit: 1db5bd14716029c8859551e9c38fe76818959b7b
[10/26] KVM: arm64: Move hyp-init params to a per-CPU struct
        commit: 4a836c1e69dbeb14f69d554e1fe36d2e619d94fc
[11/26] KVM: arm64: Init MAIR/TCR_EL2 from params struct
        commit: 5e664b8539c396dbceaccb6bef2a9ed48964906a
[12/26] KVM: arm64: Add .hyp.data..ro_after_init ELF section
        commit: 89f3705ca070900a127f181ce724aa6c1e9c9479
[13/26] KVM: arm64: Support per_cpu_ptr in nVHE hyp code
        commit: 2091f4271a400169d8fa8004bf743aa815c3c5d4
[14/26] KVM: arm64: Create nVHE copy of cpu_logical_map
        commit: 626aa81e14f9d723fe91fdb5c1030f73f929d0ad
[15/26] KVM: arm64: Add SMC handler in nVHE EL2
        commit: 0ec63d737071f483ab6fc63e2d9b59d0d4cc59fd
[16/26] KVM: arm64: Bootstrap PSCI SMC handler in nVHE EL2
        commit: 5988416e2234db36b80c510c1ae99a6de0c1431d
[17/26] KVM: arm64: Add offset for hyp VA <-> PA conversion
        commit: bf9dc203286ce42de948dbb0d3fdaea51e2ab37f
[18/26] KVM: arm64: Forward safe PSCI SMCs coming from host
        commit: 0e11d688605f1772098add3a755503688db2d06f
[19/26] KVM: arm64: Extract __do_hyp_init into a helper function
        commit: 294f71ad53625f75531dd43d775efc3507cd9b0a
[20/26] KVM: arm64: Add function to enter host from KVM nVHE hyp code
        commit: cb9773719fc405e8cc2041cd457fcd8655863a78
[21/26] KVM: arm64: Intercept host's CPU_ON SMCs
        commit: 6ed1b8bd3c623d4e0e4441a2a73dbda162e3ebe7
[22/26] KVM: arm64: Intercept host's CPU_SUSPEND PSCI SMCs
        commit: 5f51e7f65258cea36833c793625f4fb6d0e38426
[23/26] KVM: arm64: Intercept host's SYSTEM_SUSPEND PSCI SMCs
        commit: dfa751cfd54b3f9ac1d89050cf0ad6c6bc3a9dc5
[24/26] KVM: arm64: Keep nVHE EL2 vector installed
        commit: 0c8078f56aa99ab4350d9ae3dabd3504d2f11fbd
[25/26] KVM: arm64: Trap host SMCs in protected mode
        commit: 4e3e6c3acb741a9692e0b772e92368fee85dced8
[26/26] KVM: arm64: Fix EL2 mode availability checks
        commit: 5e7953174eb1966d4cdc70caf3708afc8c4dd5f9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
