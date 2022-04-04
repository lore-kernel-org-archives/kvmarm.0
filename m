Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E72C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 10:35:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E71D24B0CB;
	Mon,  4 Apr 2022 06:35:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id abFZF4kMRosQ; Mon,  4 Apr 2022 06:35:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9F554B1C7;
	Mon,  4 Apr 2022 06:35:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88FB94B0CB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 06:35:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vDktiT5XHJvl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 06:35:06 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A2604B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 06:35:06 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3EE4461518;
 Mon,  4 Apr 2022 10:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7EBC34110;
 Mon,  4 Apr 2022 10:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649068504;
 bh=LqfHmuaBRCiwD5kyMx395K7k1ZL3Fca+ZQHr5nGT0es=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=pviiuiH8etrE5llkIOGeA9Ea5VM1xQArmGE4Hh0ni9iQScMPmOLbn9UDi4W84bIKh
 8ahi8BgnLd/gNj37O8VU69EYW4n38fSMzDbHFm9MGrCliEU0FKSwz68AyNqcDzRtIV
 mbAQ4DOU5dkWkUH7yazGnxfzYkYp4p04YtgGYqyKIUQlllUIEX7fn6hIxZtGzDSUTd
 RBDkL/CeQy7FBEYnfWV0DcXkoXvyiF3Xq+QAgl0ZQ6gN0yx44MmhCEWBpM4I57LtB7
 7MvCMv8Hycx2Y7aGb5dULMOBUCf/uu56fDJ4tgNQ/h1Pa3iSXcWbjUsUyUBs93vbaH
 I6tXC8kWBFxsQ==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH kvmtool v1] Make --no-pvtime command argument arm specific
Date: Mon,  4 Apr 2022 11:34:56 +0100
Message-Id: <164906748276.1613477.6448075447690492653.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220324154304.2572891-1-sebastianene@google.com>
References: <20220324154304.2572891-1-sebastianene@google.com>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, catalin.marinas@arm.com, maz@kernel.org,
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

On Thu, 24 Mar 2022 15:43:05 +0000, Sebastian Ene wrote:
> The stolen time option is available only for aarch64 and is enabled by
> default. Move the option that disables stolen time functionality in the
> arch specific path.
> 
> 

Applied to kvmtool (master), thanks!

[1/1] Make --no-pvtime command argument arm specific
      https://git.kernel.org/will/kvmtool/c/ffa8654620b7

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
