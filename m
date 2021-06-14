Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3016DC48BE8
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 08:09:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 91164613C5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 08:09:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91164613C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C31D49FE6;
	Mon, 14 Jun 2021 04:09:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gdaXp7isLEtB; Mon, 14 Jun 2021 04:09:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12F5349E72;
	Mon, 14 Jun 2021 04:09:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 857B6404F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 04:09:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Svei7qmW1VIn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 04:09:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89B1F40212
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 04:09:09 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 825F26138C;
 Mon, 14 Jun 2021 08:09:08 +0000 (UTC)
Received: from [185.219.108.64] (helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lsheX-007NgD-Go; Mon, 14 Jun 2021 09:09:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v4 0/6] KVM: selftests: arm64 exception handling and debug
 test
Date: Mon, 14 Jun 2021 09:08:57 +0100
Message-Id: <162365813003.2322930.1320580916892571900.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ricarkol@google.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, vkuznets@redhat.com, pbonzini@redhat.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com, drjones@redhat.com,
 yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pbonzini@redhat.com, vkuznets@redhat.com
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

On Thu, 10 Jun 2021 18:10:14 -0700, Ricardo Koller wrote:
> These patches add a debug exception test in aarch64 KVM selftests while
> also adding basic exception handling support.
> 
> The structure of the exception handling is based on its x86 counterpart.
> Tests use the same calls to initialize exception handling and both
> architectures allow tests to override the handler for a particular
> vector, or (vector, ec) for synchronous exceptions in the arm64 case.
> 
> [...]

Applied to next, thanks!

[1/6] KVM: selftests: Rename vm_handle_exception
      commit: b78f4a596692f6805e796a4c13f2d921b8a95166
[2/6] KVM: selftests: Complete x86_64/sync_regs_test ucall
      commit: b7326c01122683b88e273a0cc826cd4c01234470
[3/6] KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector reporting
      commit: 75275d7fbef47805b77e8af81a4d51e2d92db70f
[4/6] KVM: selftests: Move GUEST_ASSERT_EQ to utils header
      commit: 67f709f52bf0b5c19f24d1234163123cbb6af545
[5/6] KVM: selftests: Add exception handling support for aarch64
      commit: e3db7579ef355a0b2bfef4448b84d9ac882c8f2c
[6/6] KVM: selftests: Add aarch64/debug-exceptions test
      commit: 4f05223acaeaabe0a1a188e25fab334735d85c5e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
