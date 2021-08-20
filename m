Return-Path: <SRS0=8enQ=NL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B936EC4338F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Aug 2021 10:34:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 348BE61130
	for <kvmarm@archiver.kernel.org>; Fri, 20 Aug 2021 10:34:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 348BE61130
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBED04AEE2;
	Fri, 20 Aug 2021 06:34:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cOY1BfhcomaJ; Fri, 20 Aug 2021 06:34:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCC4C4B0C2;
	Fri, 20 Aug 2021 06:34:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1343C4AEE2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Aug 2021 06:34:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HztvQZWMne-o for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Aug 2021 06:34:29 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 267E04A1B0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Aug 2021 06:34:29 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8481861106;
 Fri, 20 Aug 2021 10:34:26 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mH1qy-006AHg-Bb; Fri, 20 Aug 2021 11:34:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 00/15] KVM: arm64: Fixed features for protected VMs
Date: Fri, 20 Aug 2021 11:34:20 +0100
Message-Id: <162945557041.2025988.6137048861111259637.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
References: <20210817081134.2918285-1-tabba@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, tabba@google.com,
 oupton@google.com, james.morse@arm.com, drjones@redhat.com,
 mark.rutland@arm.com, alexandru.elisei@arm.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 suzuki.poulose@arm.com, will@kernel.org, pbonzini@redhat.com,
 christoffer.dall@arm.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, will@kernel.org,
 pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
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

On Tue, 17 Aug 2021 09:11:19 +0100, Fuad Tabba wrote:
> Changes since v3 [1]:
> - Redid calculating restricted values of feature register fields, ensuring that
>   the code distinguishes between unsigned and (potentially in the future)
>   signed fields (Will)
> - Refactoring and fixes (Drew, Will)
> - More documentation and comments (Oliver, Will)
> - Dropped patch "Restrict protected VM capabilities", since it should come with
>   or after the user ABI series for pKVM (Will)
> - Carried Will's acks
> 
> [...]

I've taken the first 10 patches of this series in order to
progress it. I also stashed a fixlet on top to address the
tracepoint issue.

Hopefully we can resolve the rest of the issues quickly.

[01/15] KVM: arm64: placeholder to check if VM is protected
        commit: 2ea7f655800b00b109951f22539fe2025add210b
[02/15] KVM: arm64: Remove trailing whitespace in comment
        commit: e6bc555c96990046d680ff92c8e2e7b6b43b509f
[03/15] KVM: arm64: MDCR_EL2 is a 64-bit register
        commit: d6c850dd6ce9ce4b410142a600d8c34dc041d860
[04/15] KVM: arm64: Fix names of config register fields
        commit: dabb1667d8573302712a75530cccfee8f3ffff84
[05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
        commit: f76f89e2f73d93720cfcad7fb7b24d022b2846bf
[06/15] KVM: arm64: Restore mdcr_el2 from vcpu
        commit: 1460b4b25fde52cbee746c11a4b1d3185f2e2847
[07/15] KVM: arm64: Keep mdcr_el2's value as set by __init_el2_debug
        commit: 12849badc6d2456f15f8f2c93037628d5176810b
[08/15] KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
        commit: cd496228fd8de2e82b6636d3d89105631ea2b69c
[09/15] KVM: arm64: Add feature register flag definitions
        commit: 95b54c3e4c92b9185b15c83e8baab9ba312195f6
[10/15] KVM: arm64: Add config register bit definitions
        commit: 2d701243b9f231b5d7f9a8cb81870650d3eb32bc

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
