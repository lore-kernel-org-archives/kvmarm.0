Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C58DC25B08
	for <kvmarm@archiver.kernel.org>; Wed, 17 Aug 2022 09:33:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A7F4C6AF;
	Wed, 17 Aug 2022 05:33:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F0NLo-27+-Cr; Wed, 17 Aug 2022 05:33:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25E394C6B6;
	Wed, 17 Aug 2022 05:33:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2B394D13E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2022 05:33:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WWY8LqtoYKZO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2022 05:33:48 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B33524D13C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2022 05:33:48 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 0C1F8CE1BF7;
 Wed, 17 Aug 2022 09:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688E5C433C1;
 Wed, 17 Aug 2022 09:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660728820;
 bh=8W05Vg11+71pYOZwxRs2Q2L01sgUXY8xwN75MdQxdGc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RJzGYJd2+sXYIfFvHeub6vQvr2peqvmgb6DV1+U7bLJwkecH3ijh5UoCdFQG26LRQ
 CZ7UuKymsXIzRtmo2Kzo282VaBd70F+DHybYbWwZdTI6EhHW/ahesX62V+neTMIho2
 /vJzgpbAbaW1RsYC0vB7//54nZ55miCb9/UzolDQpF4OFXcHdb7y+RIH2WPKG8ESdB
 rNY2gWvUcZgKLf5TfF4ohNM/uvuondmCUDPj9PWTgk9HXkOvfZkGDchMWnbvDT1z0+
 jICXADqBn9I4FlPuxYASSoVOpUqAtczW/mJRYfQOu8+jV4aah9QPcnvOq4MyDUOPW+
 dyl6NYqZMcsfw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oOFQg-003hCO-4U;
 Wed, 17 Aug 2022 10:33:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Uphold 64bit-only behavior on
 asymmetric systems
Date: Wed, 17 Aug 2022 10:33:35 +0100
Message-Id: <166072880531.274916.7682174772371767098.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816192554.1455559-1-oliver.upton@linux.dev>
References: <20220816192554.1455559-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oliver.upton@linux.dev,
 will@kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

On Tue, 16 Aug 2022 19:25:52 +0000, Oliver Upton wrote:
> Small series to fix a couple issues around when 64bit-only behavior is
> applied. As KVM is more restrictive than the kernel in terms of 32bit
> support (no asymmetry), we really needed our own predicate when the
> meaning of system_supports_32bit_el0() changed in commit 2122a833316f
> ("arm64: Allow mismatched 32-bit EL0 support").
> 
> Lightly tested as I do not have any asymmetric systems on hand at the
> moment. Attention on patch 2 would be appreciated as it affects ABI.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
      commit: f3c6efc72f3b20ec23566e768979802f0a398f04
[2/2] KVM: arm64: Reject 32bit user PSTATE on asymmetric systems
      commit: b10d86fb8e46cc812171728bcd326df2f34e9ed5

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
