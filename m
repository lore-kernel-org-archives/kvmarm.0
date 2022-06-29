Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398A7C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jun 2022 09:55:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5E754B5A9;
	Wed, 29 Jun 2022 05:55:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7blCM1s01Oa1; Wed, 29 Jun 2022 05:55:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB3134B3FC;
	Wed, 29 Jun 2022 05:55:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C922C4B3C9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2022 05:55:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a0+-ygQuEGg3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2022 05:55:39 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C96E44B37C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2022 05:55:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 1CBB5B8219E;
 Wed, 29 Jun 2022 09:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCE1C34114;
 Wed, 29 Jun 2022 09:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656496536;
 bh=gDkvwgproFA++tZEnwIYUsM00Ubsr2qR4KYSkQ7n7c4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=EknSvZOmZ9tLvQOHhXyIgyZtM9T3cLB4zKu9eCyyK0Xxmymjb9HO48pr1JqnVNSfQ
 M1DTHAOG+djPDKjXKcdfhqfX5li4UKcK+UUWy6l+8SWkN0547bLvX/OvvBu2h6bjkf
 /lWAHiF9SUn3OswLwH7w6QqSAMFz9Tw7+na6Z+8BEa7p3VoO/fFaXm6PZctK6B+rQV
 YEZM/HWEpjWkp6Db6xjjoNDx4ro8WkTgi7ANUZI9zIIMNxxQBG6xB9TmPBm5oLy34a
 7fycrKO1VYnCnMQZlggksgES2nijRN6cqsT49B/Rfa7nF1ODkspw2O8exWlQB4jRf2
 K/JmTAIHbdKZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o6UQ2-0041wx-Bs;
 Wed, 29 Jun 2022 10:55:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Masahiro Yamada <masahiroy@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: nvhe: rename confusing obj-y
Date: Wed, 29 Jun 2022 10:55:31 +0100
Message-Id: <165649651581.296235.5516198259738952242.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220613092026.1705630-1-masahiroy@kernel.org>
References: <20220613092026.1705630-1-masahiroy@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 alexandru.elisei@arm.com, masahiroy@kernel.org, kvmarm@lists.cs.columbia.edu,
 suzuki.poulose@arm.com, wangkefeng.wang@huawei.com, will@kernel.org,
 catalin.marinas@arm.com, yuzenghui@huawei.com, linux-kernel@vger.kernel.org,
 keirf@google.com, drjones@redhat.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Andrew Jones <drjones@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>
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

On Mon, 13 Jun 2022 18:20:25 +0900, Masahiro Yamada wrote:
> This Makefile appends several objects to obj-y from line 15, but none
> of them is linked to vmlinux in an ordinary way.
> 
> obj-y is overwritten at line 30:
> 
>   obj-y := kvm_nvhe.o
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: nvhe: rename confusing obj-y
      commit: 3d5697f95e492899d0bf813cbab2af03dde77fa2
[2/2] KVM: arm64: nvhe: add intermediates to 'targets' instead of extra-y
      commit: 40c56bd8e1aea7929a09f1d4d68ac3221bb142c4

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
