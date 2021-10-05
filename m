Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF64C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 12:04:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D7DBF61502
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 12:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D7DBF61502
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 879EA4B2DA;
	Tue,  5 Oct 2021 08:04:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IIggNCoRM19q; Tue,  5 Oct 2021 08:04:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 764954B2DE;
	Tue,  5 Oct 2021 08:04:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 590884B2DA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 08:04:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1+gDc7b1m-gV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 08:04:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 399304B2D9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 08:04:07 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 33FF4613D5;
 Tue,  5 Oct 2021 12:04:06 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mXjAy-00Erv4-3G; Tue, 05 Oct 2021 13:04:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>, David Brazdil <dbrazdil@google.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 0/2] A couple of EL2 refcounts fixes
Date: Tue,  5 Oct 2021 13:03:57 +0100
Message-Id: <163343543062.3848981.1421083280351176528.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211005090155.734578-4-qperret@google.com>
References: <20211005090155.734578-1-qperret@google.com>
 <20211005090155.734578-4-qperret@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qperret@google.com, dbrazdil@google.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 linux-kernel@vger.kernel.org, tabba@google.com, catalin.marinas@arm.com,
 alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

On Tue, 5 Oct 2021 10:01:40 +0100, Quentin Perret wrote:
> This is v2 of the series previously posted here:
> 
> https://lore.kernel.org/kvmarm/20211004090328.540941-1-qperret@google.com/
> 
> This addresses a couple of issues Will has found with the refcounting of
> page-tables at EL2. Patch 01 fixes a nasty bug, and probably wants to go
> in -stable. Patch 02 fixes a small inconsistency which made it harder to
> find refcount-related bugs at EL2.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Fix host stage-2 PGD refcount
      commit: 1d58a17ef54599506d44c45ac95be27273a4d2b1
[2/2] KVM: arm64: Report corrupted refcount at EL2
      commit: 7615c2a514788559c6684234b8fc27f3a843c2c6

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
