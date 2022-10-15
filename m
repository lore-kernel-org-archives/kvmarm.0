Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCCCC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 15 Oct 2022 14:43:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B4184B657;
	Sat, 15 Oct 2022 10:43:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L2fOlHfkXj40; Sat, 15 Oct 2022 10:43:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E43CB4B6C5;
	Sat, 15 Oct 2022 10:43:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EC244B656
 for <kvmarm@lists.cs.columbia.edu>; Sat, 15 Oct 2022 10:43:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JrZgyD6B-kNp for <kvmarm@lists.cs.columbia.edu>;
 Sat, 15 Oct 2022 10:43:43 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 327FA4B62E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 15 Oct 2022 10:43:43 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 5F8A4B8098E;
 Sat, 15 Oct 2022 14:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06375C433D6;
 Sat, 15 Oct 2022 14:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1665845020;
 bh=hdmj9Rrf0S29adC3/oPTPWmoQRbCjFPUJreRyWhIkoc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=iv6Jbp/tQQdOBX0ztsMIHMr4ABO9zC6EvMwNP2EinhCT/hV0FFdGZ15FUS7ka9tdn
 c2h3v+tAIJaf+RB5Y+xArLwBwilnQVwIh+PesGFzQBJifZ5zgapWRwQIpQ09pd/3M2
 0gGnSZKBb8KQYsclTVcs2xDJfjEdqN8ffcSAs36eVwOf9niYXPW08izYt49AM2aEE2
 1KS/s1bpl0d2S1yxYtryj1t57EqZXaF0K9ExrLpiQA3srVwXtHBURKfxCsxApoIZVC
 9dA6uN22nSz0RU8WkaLDRo0EKADe5HoqotOxMmBb0TGaXMVxRvCQr+9G+REYSLUe1F
 2oKuTUL6lw18g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ojiO1-00GhUt-L6;
 Sat, 15 Oct 2022 15:43:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>, Denis Nikitin <denik@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3] KVM: arm64: nvhe: Fix build with profile optimization
Date: Sat, 15 Oct 2022 15:43:33 +0100
Message-Id: <166584499561.1372561.8808338756381167639.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221014184532.3153551-1-denik@chromium.org>
References: <20221014184532.3153551-1-denik@chromium.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.org, denik@chromium.org, catalin.marinas@arm.com,
 kvmarm@lists.linux.dev, james.morse@arm.com, alexandru.elisei@arm.com,
 dbrazdil@google.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ndesaulniers@google.com,
 manojgupta@google.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Manoj Gupta <manojgupta@google.com>, kvmarm@lists.linux.dev,
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

On Fri, 14 Oct 2022 11:45:32 -0700, Denis Nikitin wrote:
> Kernel build with clang and KCFLAGS=-fprofile-sample-use=<profile> fails with:
> 
> error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: Unexpected SHT_REL
> section ".rel.llvm.call-graph-profile"
> 
> Starting from 13.0.0 llvm can generate SHT_REL section, see
> https://reviews.llvm.org/rGca3bdb57fa1ac98b711a735de048c12b5fdd8086.
> gen-hyprel does not support SHT_REL relocation section.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: nvhe: Fix build with profile optimization
      commit: bde971a83bbff78561458ded236605a365411b87

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
