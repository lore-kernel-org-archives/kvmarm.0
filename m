Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFB3C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  6 May 2022 10:16:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EB234B227;
	Fri,  6 May 2022 06:16:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5AL1OE2J5did; Fri,  6 May 2022 06:16:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3184B202;
	Fri,  6 May 2022 06:16:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF1424B1C4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 06:15:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YTI2Ha2gjHO3 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 06:15:57 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A71D94B1C3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 06:15:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 60DE5B834B0;
 Fri,  6 May 2022 10:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDB7C385A8;
 Fri,  6 May 2022 10:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651832155;
 bh=y+tzwSruYnvQIpYknRPqekd7aZKY74EWIenjQ/h/TdA=;
 h=From:To:Subject:Date:In-Reply-To:References:From;
 b=qukciAp8LJmqFc0w4m8O2tOCaWx46VLUu+PL+EYb2peLXdZ8C8Y0SjQCgSIaxSBwb
 QZYaBD4hc2PjdwQB0RWACuAVKEquym51+XFfN05YQZBBEv5kd8d10Zs64CxEYrkS5i
 3dUnD9DUIX+u+YbRKCeIUvSWd8zS/gvR7HhxdKbzJrDimiYCrla9jfqQ6tg4WSutKL
 Qgsk8uq9e512sDioRQUsQwnOp9LwpbBchtaK38FfM011X7UAoNvxEVZnTPA3RcAqWd
 1GjSZHb5a1hVJBdsqLVEoeOzyPFyU7H3tQm/HlHNcWeokBDZF9kQuP7C2uweqhqJtx
 agEErDfxqUmVQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nmv04-009QtE-HR; Fri, 06 May 2022 11:15:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>, dbrazdil@google.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] arm64: kvm: avoid unnecessary absolute addressing via
 literals
Date: Fri,  6 May 2022 11:15:49 +0100
Message-Id: <165183214093.192117.6423497073962335554.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220428140350.3303481-1-ardb@kernel.org>
References: <20220428140350.3303481-1-ardb@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ardb@kernel.org, dbrazdil@google.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

On Thu, 28 Apr 2022 16:03:50 +0200, Ard Biesheuvel wrote:
> There are a few cases in the nVHE code where we take the absolute
> address of a symbol via a literal pool entry, and subsequently translate
> it to another address space (PA, kimg VA, kernel linear VA, etc).
> Originally, this literal was needed because we relied on a different
> translation for absolute references, but this is no longer the case, so
> we can simply use relative addressing instead. This removes a couple of
> RELA entries pointing into the .text segment.

Applied to next, thanks!

[1/1] arm64: kvm: avoid unnecessary absolute addressing via literals
      commit: 7ee74cc7ad7ef526e4383a3a3294b7039622eb37

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
