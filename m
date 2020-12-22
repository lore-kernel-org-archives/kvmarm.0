Return-Path: <SRS0=fzzv=F2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D811C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 22 Dec 2020 16:06:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2105523105
	for <kvmarm@archiver.kernel.org>; Tue, 22 Dec 2020 16:06:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2105523105
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73A094B1BF;
	Tue, 22 Dec 2020 11:06:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ex1mhciPAhsE; Tue, 22 Dec 2020 11:06:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 609614B19C;
	Tue, 22 Dec 2020 11:06:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6C544B132
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2020 11:06:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mOLjiN5+leLC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Dec 2020 11:06:54 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1B4C4B12E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2020 11:06:54 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AD36422955;
 Tue, 22 Dec 2020 16:06:53 +0000 (UTC)
Received: from 91-161-240-24.subs.proxad.net ([91.161.240.24]
 helo=localhost.localdomain)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1krkBX-0037LH-K0; Tue, 22 Dec 2020 16:06:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 0/6] Fixes and cleanups of PSCI relay for kvmarm/next
Date: Tue, 22 Dec 2020 16:06:33 +0000
Message-Id: <160865317053.248882.14763900616940105510.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201208142452.87237-1-dbrazdil@google.com>
References: <20201208142452.87237-1-dbrazdil@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 91.161.240.24
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
 Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
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

On Tue, 8 Dec 2020 14:24:46 +0000, David Brazdil wrote:
> Small batch of improvements for the 'Opt-in always-on nVHE hypervisor'
> series, now merged in kvmarm/next.
> 
> Patch #1 fixes potential use of invalid v0.1 functions IDs reported
> by Mark Rutland, patch #2 fixes a warning reported by Qian Cai.
> Patch #3 avoids a code path not used in VHE, can be dropped if any
> concerns arise. The remaining patches are minor cleanups from review.
> 
> [...]

Applied to next, thanks!

[1/6] kvm: arm64: Prevent use of invalid PSCI v0.1 function IDs
      commit: ff367fe473a9857160c17827931375a899076394
[2/6] kvm: arm64: Use lm_alias in nVHE-only VA conversion
      commit: 7a96a0687b80a1870c689418d7b72012c8bdd53d
[3/6] kvm: arm64: Skip computing hyp VA layout for VHE
      commit: c3e181aec96f6ada84df1cb72a72be8970f8b284
[4/6] kvm: arm64: Minor cleanup of hyp variables used in host
      commit: 61fe0c37af57ac35472a870581a7d0bb5ac2f63a
[5/6] kvm: arm64: Remove unused includes in psci-relay.c
      commit: e6829e0384a49efe68537298132230bebd8bd1b3
[6/6] kvm: arm64: Move skip_host_instruction to adjust_pc.h
      commit: 860a4c3d1e04a3c3e62bacbbba64417bf49768e2

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
