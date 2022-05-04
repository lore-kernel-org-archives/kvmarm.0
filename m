Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CEAC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 12:01:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAD444B11A;
	Wed,  4 May 2022 08:01:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0k-8PtxqrNV3; Wed,  4 May 2022 08:01:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 917FD4B11C;
	Wed,  4 May 2022 08:01:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B33A34B11C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 08:01:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iivBNxkgdgn0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 08:01:39 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 845004B134
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 08:01:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7849D616BE;
 Wed,  4 May 2022 12:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C5EC385A5;
 Wed,  4 May 2022 12:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651665698;
 bh=f4hC2KhYd/3nrH7HJufsZ3yV+queO1t2VtGxafx1XMA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Ko9JTTVBW9yoeXypyEb4JFJE3B1qHylz3xFpeypBr1hBZ5b3qbmHQ1Pgvo4WYYShj
 ymPwWQHqIRwwvU/24xUKuUJva0Ytt0htk/gk5jjnvkeHgwItytW2hEpdjt/2zgCq+u
 cb7XRw8fcoxhNA5BYZsGI1yj/TW8c2lf4b3z2OPr7jPqFc4rQOEk8uFtEI7PV7GCsW
 8012b31rG8Tfja3h9EEqJhi0sn5OlXy0emmoB0HkVH1lNf1rfjMEz/dNzYahPPt44I
 hjVq+qY+dYaKg6jDHYeq2tfCkDMGFgkdjkzSxPftq5SDg/C0HdEo3SdIlVOFEtU7Wh
 rRgQ+6Mn3FMjw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nmDhH-008tMH-UH; Wed, 04 May 2022 13:01:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@google.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v6 00/12] KVM: arm64: PSCI SYSTEM_SUSPEND support
Date: Wed,  4 May 2022 13:01:33 +0100
Message-Id: <165166565256.3774994.10199439605875188884.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
References: <20220504032446.4133305-1-oupton@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com, kvm@vger.kernel.org,
 alexandru.elisei@arm.com, reijiw@google.com, ricarkol@google.com,
 linux-kernel@vger.kernel.org, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
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

On Wed, 4 May 2022 03:24:34 +0000, Oliver Upton wrote:
> The PSCI v1.0 specification describes a call, SYSTEM_SUSPEND, which
> allows software to request that the system be placed into the lowest
> possible power state and await a wakeup event. This call is optional
> in v1.0 and v1.1. KVM does not currently support this optional call.
> 
> This series adds support for the PSCI SYSTEM_SUSPEND call to KVM/arm64.
> For reasons best described in patch 8, it is infeasible to correctly
> implement PSCI SYSTEM_SUSPEND (or any system-wide event for that matter)
> in a split design between kernel/userspace. As such, this series cheaply
> exits to userspace so it can decide what to do with the call. This
> series also gives userspace some help to emulate suspension with a new
> MP state that awaits an unmasked pending interrupt.
> 
> [...]

Applied to next, thanks!

[01/12] KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
        commit: 5bc2cb95ad03d866422d7b3f19ec42a6720f3262
[02/12] KVM: arm64: Dedupe vCPU power off helpers
        commit: 1e5794295c5dbfcc31cf5de840c9e095ae50efb7
[03/12] KVM: arm64: Track vCPU power state using MP state values
        commit: b171f9bbb130cb323f2101edd32da2a25d43ebfa
[04/12] KVM: arm64: Rename the KVM_REQ_SLEEP handler
        commit: 1c6219e3faf12e58d520b3b2cdfa8cd5e1efc9a5
[05/12] KVM: arm64: Return a value from check_vcpu_requests()
        commit: 3fdd04592d38bb31a0bea567d9a66672b484bed3
[06/12] KVM: arm64: Add support for userspace to suspend a vCPU
        commit: 7b33a09d036ffd9a04506122840629c7e870cf08
[07/12] KVM: arm64: Implement PSCI SYSTEM_SUSPEND
        commit: bfbab44568779e1682bc6f63688bb9c965f0e74a
[08/12] selftests: KVM: Rename psci_cpu_on_test to psci_test
        commit: bf08515d39cb843c81f991ee67ff543eecdba0c3
[09/12] selftests: KVM: Create helper for making SMCCC calls
        commit: e918e2bc52c8ac1cccd6ef822ac23eded41761b6
[10/12] selftests: KVM: Use KVM_SET_MP_STATE to power off vCPU in psci_test
        commit: d135399a97cc3e27716a8e468a5fd1a209346831
[11/12] selftests: KVM: Refactor psci_test to make it amenable to new tests
        commit: 67a36a821312e9c0d2a2f7e6c2225204500cc01c
[12/12] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
        commit: b26dafc8a9e74254a390e8f21ff028a2573ee4fc

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
