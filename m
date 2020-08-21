Return-Path: <SRS0=jF9t=B7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2295CC433E1
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 18:15:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97FFE2076E
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 18:15:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97FFE2076E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11ADE4C5B3;
	Fri, 21 Aug 2020 14:15:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P6WFTZTVDUyR; Fri, 21 Aug 2020 14:15:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D0C04C5B8;
	Fri, 21 Aug 2020 14:15:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3EEC4C5B4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 14:15:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WK0yJHNbz5My for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Aug 2020 14:15:08 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 872AB4C5B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 14:15:08 -0400 (EDT)
Received: from localhost.localdomain (unknown [95.146.230.145])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4022A20791;
 Fri, 21 Aug 2020 18:15:05 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 0/3] Cortex-A77 erratum 1508412 workaround
Date: Fri, 21 Aug 2020 19:15:00 +0100
Message-Id: <159803353178.13439.2281554739729386553.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200803193127.3012242-1-robh@kernel.org>
References: <20200803193127.3012242-1-robh@kernel.org>
MIME-Version: 1.0
Cc: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
 Stephen Boyd <swboyd@chromium.org>, dianders@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, 3 Aug 2020 13:31:24 -0600, Rob Herring wrote:
> This series implements the work-around for Cortex-A77 erratum 1508412.
> KVM guests which don't implement the workaround can still deadlock the
> system. This is also the case with the existing Cortex-A57 erratum 832075,
> so we add a warning message if an erratum can cause deadlock.
> 
> Changes detailed in patches.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/3] KVM: arm64: Print warning when cpu erratum can cause guests to deadlock
      https://git.kernel.org/arm64/c/abf532cceaca

-- 
Catalin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
