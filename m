Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA699C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Mar 2022 14:29:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CD8D49E2A;
	Mon, 21 Mar 2022 10:29:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W8SdqE025Soe; Mon, 21 Mar 2022 10:29:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A3DB49E57;
	Mon, 21 Mar 2022 10:29:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F81F49E44
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 10:29:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VIQcgD-E2zqH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2022 10:29:26 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 408EC40C52
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 10:29:26 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 52DBE609EE;
 Mon, 21 Mar 2022 14:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7DFC340F3;
 Mon, 21 Mar 2022 14:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1647872965;
 bh=9mxvzfFWtwfQLECDMiS80V8FJcePBS2XkbDd8KDSM+k=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=lnlZmG035UNg/wUBwsfHuA+FG11MDnCCSyE4QbLtZyMbQKsBy0ozovwbulJRIKrzL
 DJxTRRuh6GKrSdWI9BrPe4UuuXwgNy8cfcq96/dDnVMTHx5Z4m5V58xuhI0si67zqJ
 d9lXvq7xOV5jz5BokdAEVb08JhJuX8LsquN7J4PrtJAxf6B7JNGENpfO9vYQwW/aJ6
 478bbvXq4jx835dFass3aCEQVzDS3k0UNJrBFECBmWJiUashwKEDXR6vzeJhLlvA9O
 38TgjuKi1tlgaDbV0L39sKqalluyd91XeG1kpthLF6sX09kLKYF7Hv4UOhxYUsfPr1
 LkqtsH6nvp9pA==
Date: Mon, 21 Mar 2022 14:29:19 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fixes for SMC64 SYSTEM_RESET2 calls
Message-ID: <20220321142918.GA11145@willie-the-truck>
References: <20220318193831.482349-1-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220318193831.482349-1-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Fri, Mar 18, 2022 at 07:38:29PM +0000, Oliver Upton wrote:
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
> Patch 2 adds a check to the PSCI v1.x call handler in KVM, bailing out
> early if the guest is not allowed to use a particular function. This
> closes the door on calls to 64-bit SYSTEM_RESET2 from AArch32.
> 
> My first crack at this [1] was missing the fix for direct calls to
> SYSTEM_RESET2. Taking the patch out of that series and sending
> separately.
> 
> Applies on top of today's kvmarm pull, commit:
> 
>   21ea45784275 ("KVM: arm64: fix typos in comments")
> 
> [1]: https://patchwork.kernel.org/project/kvm/patch/20220311174001.605719-3-oupton@google.com/
> 
> Oliver Upton (2):
>   KVM: arm64: Generally disallow SMC64 for AArch32 guests
>   KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32
> 
>  arch/arm64/kvm/psci.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)

For both patches:

Acked-by: Will Deacon <will@kernel.org>

Thanks for fixing this!

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
