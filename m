Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72145C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  6 Dec 2021 08:42:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D43DA4079A;
	Mon,  6 Dec 2021 03:42:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e2X5khuB-t+k; Mon,  6 Dec 2021 03:42:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85B3B4B08E;
	Mon,  6 Dec 2021 03:42:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 493C54079A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 03:42:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wpfKOuWa82pC for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Dec 2021 03:42:00 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FB324048A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 03:42:00 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9AA22B8103B;
 Mon,  6 Dec 2021 08:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56370C341C1;
 Mon,  6 Dec 2021 08:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638780117;
 bh=4wWOVe2lwPaaXoppKsoOmUrakURNFayKUJcMUbva6IU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=E505Cjk/H9JyXpn8eSTt0M7VxC9n2ELL9SuTlBogzn7URcEyR2MmwrOz42w09QquA
 tQlTtLyH2/0D79pdvuwpep4oIjcgzBMz/x+nM89DHtCWXNkxPlMWw17clnKlVxv6/1
 BHd04Whjmp1YMA4wEP36ocwSkB7dYEhrJ8jax875Sp3jrrjcDDSQnWvoRFlS3iVMTi
 NwfHyBU4QFPeU2tpSz20ogc7P0X4QRxZ7r/Kx12hHJn8GvLRcTCD6zGwCj0prMBpbv
 9JNfwsFydYUFJwOkMNda02byobWWsth3LQoRl6/jTW7pj7qjEzTp1kdnaQy0g8WjqS
 dSJPixHPhpRwg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mu9ZL-00A7wb-Am; Mon, 06 Dec 2021 08:41:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: Rikard Falkeborn <rikard.falkeborn@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Constify kvm_io_gic_ops
Date: Mon,  6 Dec 2021 08:41:52 +0000
Message-Id: <163878010586.1389753.7080973991720885525.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211204213518.83642-1-rikard.falkeborn@gmail.com>
References: <20211204213518.83642-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: rikard.falkeborn@gmail.com, suzuki.poulose@arm.com,
 james.morse@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Sat, 4 Dec 2021 22:35:18 +0100, Rikard Falkeborn wrote:
> The only usage of kvm_io_gic_ops is to make a comparison with its
> address and to pass its address to kvm_iodevice_init() which takes a
> pointer to const kvm_io_device_ops as input. Make it const to allow the
> compiler to put it in read-only memory.

Applied to next, thanks!

[1/1] KVM: arm64: Constify kvm_io_gic_ops
      commit: 636dcd0204599f94680f8f87b46cef7c66034ac0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
