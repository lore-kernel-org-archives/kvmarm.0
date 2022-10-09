Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1312C433FE
	for <kvmarm@archiver.kernel.org>; Sun,  9 Oct 2022 01:37:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C35449F55;
	Sat,  8 Oct 2022 21:37:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cTC7I-cTtjcp; Sat,  8 Oct 2022 21:37:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 639404A49C;
	Sat,  8 Oct 2022 21:37:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92FE94A1D9
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Oct 2022 21:37:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zwhOCKYGKGAP for <kvmarm@lists.cs.columbia.edu>;
 Sat,  8 Oct 2022 21:37:00 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45EC540159
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Oct 2022 21:37:00 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C35D2B80C72;
 Sun,  9 Oct 2022 01:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C74EC433C1;
 Sun,  9 Oct 2022 01:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1665279417;
 bh=HGJvbxw2MJ35hMazorht+KBKpy2FAeCse4OJqWityt8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=aR30/763frgO+vBid7LTGeYm+ND9XQJkz46/DA51ViZ4gXaDskcjfFLltR5iHNtw/
 bgv6FWRxBLkcJpk4GitRRpVzpJwiXDTO6CAWe1mDlpz+zxFZ8jPPIWHbg0DfmJGjSL
 /fR3dPxfAP6f/mo7IAsXpSmtvQZMvbeaTzsh9+5VgwnQXTQgp/R/VrGETsL3caoxBk
 1Vje6eWjnV3est3j0AByvLHVNwjrYwCKvEVZNfbPmnBKRb2oT3a9H8QVUyz2Q4kUtL
 0zg3LhkBXaxpNeXpZo9x8AJrOFXY0R7W9SbNe07fFMaOlqVNoyouONMPdS+IzG5Tdo
 t/HrXEOu2wpeg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ohLFP-00FKtd-98;
 Sun, 09 Oct 2022 02:36:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 0/2] KVM: arm64: Limit stage2_apply_range() batch size
 to largest block
Date: Sun,  9 Oct 2022 02:36:43 +0100
Message-Id: <166527939508.254377.2666573949746347209.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221007234151.461779-1-oliver.upton@linux.dev>
References: <20221007234151.461779-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, james.morse@arm.com,
 oliver.upton@linux.dev, kvm@vger.kernel.org, ricarkol@google.com,
 dmatlack@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Fri, 7 Oct 2022 23:41:49 +0000, Oliver Upton wrote:
> Continuing with MMU patches to post, a small series fixing some soft
> lockups caused by stage2_apply_range(). Depending on the paging setup,
> we could walk a very large amount of memory before dropping the lock and
> rescheduling.
> 
> Applies to kvmarm-6.1. Tested with KVM selftests and kvm-unit-tests with
> all supported page sizes (4K, 16K, 64K). Additionally, I no longer saw
> soft lockups with the following:
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Work out supported block level at compile time
      commit: 3b5c082bbfa20d9a57924edd655bbe63fe98ab06
[2/2] KVM: arm64: Limit stage2_apply_range() batch size to largest block
      commit: 5994bc9e05c2f8811f233aa434e391cd2783f0f5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
