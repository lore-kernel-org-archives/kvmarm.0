Return-Path: <SRS0=w8eh=K3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9928BC4708F
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 09:35:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 07CB26136E
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 09:35:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07CB26136E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D5C640808;
	Tue,  1 Jun 2021 05:35:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VjLIWZ72RLNL; Tue,  1 Jun 2021 05:35:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47E6F40839;
	Tue,  1 Jun 2021 05:35:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDB1840839
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 05:35:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OxDw66hhO4qO for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Jun 2021 05:35:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9129401A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 05:35:05 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8A78A60FE5;
 Tue,  1 Jun 2021 09:35:04 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lo0ne-004mgj-HR; Tue, 01 Jun 2021 10:35:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: Ricardo Koller <ricarkol@google.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/5] KVM: selftests: arm64 exception handling and debug
 test
Date: Tue,  1 Jun 2021 10:34:57 +0100
Message-Id: <162254008305.3715765.2263457388442707736.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210513002802.3671838-1-ricarkol@google.com>
References: <20210513002802.3671838-1-ricarkol@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: ricarkol@google.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pbonzini@redhat.com
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

On Wed, 12 May 2021 17:27:57 -0700, Ricardo Koller wrote:
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

[1/5] KVM: selftests: Rename vm_handle_exception
      commit: a2bad6a990a4a7493cf5cae2f91e6b8643d2ed84
[2/5] KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector reporting
      commit: 8c4680c968180739e3facd9a65e8f7939a3bdc6d
[3/5] KVM: selftests: Move GUEST_ASSERT_EQ to utils header
      commit: 124d7bb43462d1b4eaee2463fcbc7e9e41cac20f
[4/5] KVM: selftests: Add exception handling support for aarch64
      commit: cc968fa1dd8212557c588f348d37d907008117e8
[5/5] KVM: selftests: Add aarch64/debug-exceptions test
      commit: 9c066f39c5fb96bad7533de7e96a85040c7a00a0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
