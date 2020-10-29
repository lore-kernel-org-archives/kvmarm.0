Return-Path: <SRS0=BReL=EE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F04C4363A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 15:27:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A38A20759
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 15:27:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="romTUC4K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A38A20759
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73F1D4B233;
	Thu, 29 Oct 2020 11:27:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mxIRXnTknXWC; Thu, 29 Oct 2020 11:27:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CA6A4B53B;
	Thu, 29 Oct 2020 11:27:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 275504B27F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 11:27:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AcAEXoKKnlP6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Oct 2020 11:27:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1654C4B233
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 11:27:12 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5FED020759;
 Thu, 29 Oct 2020 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603985230;
 bh=dHOwPIbu8adLWeK2264PAC3Cqkc4KzVueApZwXwuyiQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=romTUC4KfCDrK+Pyt2kasR5dQnxJiB7Fwz/PL6qsJcV7ZXxhj4ZBloFG/L76Q1xc4
 bgNQjzmFHF+91/TnvTj2uxeK6k8ioRP8S1I50XrLezds9B9qlVVf02dzAPxx5djzFw
 M82YDXJI0n0n/rxlT1u5E8YuKdEH4q00IoQDRcJA=
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Rob Herring <robh@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 1/2] arm64: Add part number for Arm Cortex-A77
Date: Thu, 29 Oct 2020 15:27:03 +0000
Message-Id: <160397616208.746530.13318825625774881470.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201028182839.166037-1-robh@kernel.org>
References: <20201028182839.166037-1-robh@kernel.org>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, 28 Oct 2020 13:28:38 -0500, Rob Herring wrote:
> Add the MIDR part number info for the Arm Cortex-A77.

Applied to arm64 (for-next/fixes), thanks!

[1/2] arm64: Add part number for Arm Cortex-A77
      https://git.kernel.org/arm64/c/8a6b88e66233
[2/2] arm64: Add workaround for Arm Cortex-A77 erratum 1508412
      https://git.kernel.org/arm64/c/96d389ca1011

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
