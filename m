Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D0AC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:26:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A8EA49E49;
	Wed, 23 Mar 2022 05:26:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ni3ONUiVkaT2; Wed, 23 Mar 2022 05:26:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23AB449EF8;
	Wed, 23 Mar 2022 05:26:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2D5649EEF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 05:26:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x-GwHS+jwKyF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 05:26:09 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B37F749E49
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 05:26:09 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 82067617AC;
 Wed, 23 Mar 2022 09:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8EEC340E8;
 Wed, 23 Mar 2022 09:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1648027567;
 bh=6o8eSL9XfXN3YyWF8WOf0UgeocTfb9Qxb/lKmNgQD3k=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=TFK9YzhcOSM+7+DW03OfGZ6iv4ZXu8m+2lyggptU4cD5cN+dAqP54VpzFohtjD2W3
 Jk8zJZaf7iP8YyfFpWU9jNzxFJsZHNOobxbqodw6pTt7XD7e7P2EWskhbvt41TvLR4
 kdOd7fNlSKnHaBjLkJPY+SZf2nyneZpk/QR/FgChqDC5ugUODivxijDFUpBdxl9sow
 JfC6jtEkuyWzUYBROPdFF0fkVcPe6tFk+6mxuzlWYJpeG0uICd6TknefMz70rdHrjm
 W0HK/R3Y3cgCp5gYT7bkpcrSX5i8IUu3Fpeh5F1lfi7ir18s2bZj8XdjDh5y2jXT1U
 GqPxjryM9Nm2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nWxFl-00GSfx-Eq; Wed, 23 Mar 2022 09:26:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fixes for SMC64 SYSTEM_RESET2 calls
Date: Wed, 23 Mar 2022 09:26:02 +0000
Message-Id: <164802753806.768438.14771552683123752395.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220322183538.2757758-1-oupton@google.com>
References: <20220322183538.2757758-1-oupton@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com,
 ricarkol@google.com, pshier@google.com, reijiw@google.com,
 suzuki.poulose@arm.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, pbonzini@redhat.com,
 alexandru.elisei@arm.com, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

On Tue, 22 Mar 2022 18:35:35 +0000, Oliver Upton wrote:
> This series addresses a couple of issues with how KVM exposes SMC64
> calls to its guest. It is currently possible for an AArch32 guest to
> discover the SMC64 SYSTEM_RESET2 function (via
> PSCI_1_0_FN_PSCI_FEATURES) and even make a call to it. SMCCC does not
> allow for 64 bit calls to be made from a 32 bit state.
> 
> Patch 1 cleans up the way we filter SMC64 calls in PSCI. Using a switch
> with case statements for each possibly-filtered function is asking for
> trouble. Instead, pivot off of the bit that indicates the desired
> calling convention. This plugs the PSCI_FEATURES hole for SYSTEM_RESET2.
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: Generally disallow SMC64 for AArch32 guests
      commit: 905ec3226f8150f73838a36cb79ba79e1d789e8e
[2/3] KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32
      commit: 3e1b3dbad320e1532fdf09e5b80e35d62a0fd82b
[3/3] KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler
      commit: 8872d9b3e35a0ecb80d6413bba403d4aaf49af63

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
