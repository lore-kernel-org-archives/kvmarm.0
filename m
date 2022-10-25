Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B92C38A2D
	for <kvmarm@archiver.kernel.org>; Tue, 25 Oct 2022 15:31:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB0C64B642;
	Tue, 25 Oct 2022 11:31:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UxtJgx9ajozT; Tue, 25 Oct 2022 11:31:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 837604B422;
	Tue, 25 Oct 2022 11:31:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EA9C4B2B7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2022 11:31:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ep-80lz6Owlo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Oct 2022 11:30:59 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B37714B256
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2022 11:30:59 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 32E7EB81D99;
 Tue, 25 Oct 2022 15:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B91C433C1;
 Tue, 25 Oct 2022 15:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666711856;
 bh=3YeEg2Oa90timi1XZ3PvEOat7cXoDLZyE/kx8ALR0fI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=k2yihkhMF0oKJomV48MeRvLFVsSnru0KmNrFtpW16uRT6BiJY9OhgvKDH10K7CTZQ
 xMBfgpF5/h6qwvzmOzDvlkZtpT6g53Bv0xdDRxNPfzUkP0tGGeUsKniHkUPXo6pDQl
 pC6Hm8II/0RR1F1GXlTU/VpCV81j3ZRedzb7pRczs2cfvLLn19HL8bZ9EoFO2BoKjd
 v7RFJ+0MzlqzfLPoXjtIz/KlHn0N1gXMBIJnl+yXygMtZE1CxqD9myABnczTMeWi+w
 dIa3Ka3SkhxFjRqmqSyBTzQyaKv136UemXswzie2idwwq316NWsVHZqYVcxDTYrVYS
 G3Sa9uMhWGL5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1onLtG-001ZDz-L9;
 Tue, 25 Oct 2022 16:30:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Quentin Perret <qperret@google.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: Use correct accessor to parse stage-1 PTEs
Date: Tue, 25 Oct 2022 16:30:50 +0100
Message-Id: <166671184422.541929.12583367055859537857.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221025145156.855308-1-qperret@google.com>
References: <20221025145156.855308-1-qperret@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, oliver.upton@linux.dev,
 qperret@google.com, suzuki.poulose@arm.com, will@kernel.org,
 catalin.marinas@arm.com, james.morse@arm.com, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Tue, 25 Oct 2022 14:51:56 +0000, Quentin Perret wrote:
> hyp_get_page_state() is used with pKVM to retrieve metadata about a page
> by parsing a hypervisor stage-1 PTE. However, it incorrectly uses a
> helper which parses *stage-2* mappings. Ouch.
> 
> Luckily, pkvm_getstate() only looks at the software bits, which happen
> to be in the same place for stage-1 and stage-2 PTEs, and this all ends
> up working correctly by accident. But clearly, we should do better.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Use correct accessor to parse stage-1 PTEs
      commit: 6853a71726b6f5930b4450889faf02e8f1cfe35c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
