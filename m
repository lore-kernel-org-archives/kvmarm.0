Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F82C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 19:07:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3AE34BAEC;
	Thu, 10 Nov 2022 14:07:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0fWuBGvmdelE; Thu, 10 Nov 2022 14:07:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 858214BAF3;
	Thu, 10 Nov 2022 14:07:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 621594BACF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 14:07:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5tChLLjkftQL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 14:07:16 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54EF54BAC9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 14:07:16 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 74B3661E12;
 Thu, 10 Nov 2022 19:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25B6C433C1;
 Thu, 10 Nov 2022 19:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668107234;
 bh=n5RqcH+r3Pr3N5MvLY5kNdjJD72G1QSkvwLCwqb/nxQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=lBykAl5QAR54gfFIPccn7LHfRTgCamAGEYwjYWRe99h9pr9hJBMuKXAQTbm4qr8nA
 GhmRzgSM5NA2kPRZp1WGGJVsF7uyH4UMKn1z3KSvTxVzBkf7TisBdL14TOevSTs5fy
 z1k3NirXzDdk5+6Qo1smXykdSxv9IuG1aue2RHTi1oJ1f4LWtMB9hvL8kvrOy9CBfj
 BLmAvzxQQS2aaRN6r6Kuokvc1pacDImbWb8mZpRAif/runUTi30aE/+dCbAgQ0K7S8
 wNF6E0DFjpnVo07UPaQ0T3AWEmoECANJNGM/mZAsEenu4cKRcQDRL3b7c7rAFerBBg
 hNXA81mwOjjSg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1otCtM-005Ecq-E2;
 Thu, 10 Nov 2022 19:07:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 0/9] KVM: arm64: selftests: Test linked {break,
 watch}points
Date: Thu, 10 Nov 2022 19:07:05 +0000
Message-Id: <166810721166.3361564.3176052818843423972.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
References: <20221020054202.2119018-1-reijiw@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, reijiw@google.com,
 andrew.jones@linux.dev, pbonzini@redhat.com, kvm@vger.kernel.org,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, jingzhangos@google.com,
 ricarkol@google.com, linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 oliver.upton@linux.dev, rananta@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

On Wed, 19 Oct 2022 22:41:53 -0700, Reiji Watanabe wrote:
> This series adds test cases for linked {break,watch}points to the
> debug-exceptions test, and expands {break,watch}point tests to
> use non-zero {break,watch}points (the current test always uses
> {break,watch}point#0).
> 
> Patches 1-6 add some helpers or do minor refactoring for
> preparation of adding test cases in subsequent patches.
> Patches 7-8 add test cases for a linked {break,watch}point.
> Patch 9 expands {break,watch}point test cases to use non-zero
> {break,watch}points.
> 
> [...]

Applied to next, thanks!

[1/9] KVM: arm64: selftests: Use FIELD_GET() to extract ID register fields
      commit: 1a6182033f2d5c481aec1f8c1c26ebc649693d57
[2/9] KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r helpers in debug-exceptions
      commit: f6d02aa28ae21161d64300bac62b2dde85584004
[3/9] KVM: arm64: selftests: Remove the hard-coded {b,w}pn#0 from debug-exceptions
      commit: 700b8860e02cbaa7dd1181a914ff38e0fae18bf0
[4/9] KVM: arm64: selftests: Add helpers to enable debug exceptions
      commit: 152880d8edf5ad6df5b4b4915a4d9f9085ab8fef
[5/9] KVM: arm64: selftests: Stop unnecessary test stage tracking of debug-exceptions
      commit: 948f439c9d0080972ec937f4aefbe51229546510
[6/9] KVM: arm64: selftests: Change debug_version() to take ID_AA64DFR0_EL1
      commit: 5dd544e882d96d43b363c5ef64683281f2a386d9
[7/9] KVM: arm64: selftests: Add a test case for a linked breakpoint
      commit: 142365932f5f296df593dd653d79194ff5457722
[8/9] KVM: arm64: selftests: Add a test case for a linked watchpoint
      commit: 5ced4e533b676b1a582d89aba5328e4b316957e0
[9/9] KVM: arm64: selftests: Test with every breakpoint/watchpoint
      commit: ebb8cc10316de3040efc4cfb40030f374cbbaa3b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
