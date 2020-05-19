Return-Path: <SRS0=JN4F=7B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 452A7C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 19 May 2020 16:47:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B15512081A
	for <kvmarm@archiver.kernel.org>; Tue, 19 May 2020 16:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1OSFzGd2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B15512081A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 376BA4B288;
	Tue, 19 May 2020 12:47:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f4ZO33KZBOu1; Tue, 19 May 2020 12:47:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE0974B277;
	Tue, 19 May 2020 12:47:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC7694B230
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2020 12:47:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a-isSuPpw8tK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 May 2020 12:47:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D94B44B07F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2020 12:47:07 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7EFB020842;
 Tue, 19 May 2020 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1589906826;
 bh=Ltv/jh2GtI2b5nJnqo8Jl/8YtfEYU5Wy+ivuZx1vTlI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=1OSFzGd2kZRfKoKZD2a0EzGfDTi4WDgnIP5bry7jiaQ8fUQEx4XX4MHFmaY7d2uOa
 A02ZSYfsm0yUi0hAEsLdUbvcuwXa1F1VJFKFJSA+V/S5FFQGQ20vHB5+y7OjIhepA1
 V0ZBm0AkVukpkhVcPVwMirKD2wOqS9B1d1ljalvY=
From: Will Deacon <will@kernel.org>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
 Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool] rtc: Generate fdt node for the real-time clock
Date: Tue, 19 May 2020 17:46:58 +0100
Message-Id: <158990595902.1665.1735005226213648378.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514094553.135663-1-andre.przywara@arm.com>
References: <20200514094553.135663-1-andre.przywara@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com,
 Sami Mujawar <sami.mujawar@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Thu, 14 May 2020 10:45:53 +0100, Andre Przywara wrote:
> On arm and arm64 we expose the Motorola RTC emulation to the guest,
> but never advertised this in the device tree.
> 
> EDK-2 seems to rely on this device, but on its hardcoded address. To
> make this more future-proof, add a DT node with the address in it.
> EDK-2 can then read the proper address from there, and we can change
> this address later (with the flexible memory layout).
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] rtc: Generate fdt node for the real-time clock
      https://git.kernel.org/will/kvmtool/c/5a3a5c07dd87

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
