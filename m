Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60D2C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 19:56:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 560744B261;
	Thu, 28 Apr 2022 15:56:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DgdeJw7qIhR1; Thu, 28 Apr 2022 15:56:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EA644B222;
	Thu, 28 Apr 2022 15:56:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDDC84B1F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 15:56:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZRrfkUQ66OYQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 15:55:57 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1AEA4B1EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 15:55:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DF1C360E8F;
 Thu, 28 Apr 2022 19:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469DBC385AD;
 Thu, 28 Apr 2022 19:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651175756;
 bh=vRnZSRIcTqcHKCeWjmxMZBxVcLsxLI+m8lZ+XQEEza8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=fUaqFQwLZ+kPqathikKDuZJIaOcX/OYkWvMud/2Qz5gdLLidFxSkYPPZxr1PSU9Xs
 c3HxamY4IAekJMXwYztltninPRKr1Due435Q+1gTAeqOEGO35Dvd8KHySUb/wqeKiD
 IK54zoxiEFBA9GXosZaccafRQzweNNc3wtrm4JqcdipGg4AyDQmVq3UkOpae/5hyND
 QigfMuiwx+KbhsPWuT9bzpXHYrSSdSxSAGAZxkJn+KpUJ+Gt2HJud1ECcPhaXGhGY+
 ksgSWmA1pXiuFh9aEjlAyRxzBukftfVNPEVn2Wsu4ON/nt/IudxV9rB3v+1RA9TDEC
 FAfJpvgTgzSvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nkAEz-007l9y-Qp; Thu, 28 Apr 2022 20:55:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v8 0/6] KVM: arm64: Hypervisor stack enhancements
Date: Thu, 28 Apr 2022 20:55:50 +0100
Message-Id: <165117574186.3115452.6818682378273681624.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220420214317.3303360-1-kaleshsingh@google.com>
References: <20220420214317.3303360-1-kaleshsingh@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kaleshsingh@google.com, mark.rutland@arm.com,
 james.morse@arm.com, tabba@google.com, masahiroy@kernel.org, surenb@google.com,
 kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, ardb@kernel.org, will@kernel.org,
 qperret@google.com, linux-kernel@vger.kernel.org, alexandru.elisei@arm.com,
 yuzenghui@huawei.com, changbin.du@intel.com, kernel-team@android.com,
 nathan@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, will@kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org,
 Nathan Chancellor <nathan@kernel.org>, Changbin Du <changbin.du@intel.com>,
 linux-arm-kernel@lists.infradead.org, surenb@google.com,
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

On Wed, 20 Apr 2022 14:42:51 -0700, Kalesh Singh wrote:
> This is v8 of the nVHE hypervisor stack enhancements. This version is based
> on 5.18-rc3.
> 
> Previous versions can be found at:
> v7: https://lore.kernel.org/r/20220408200349.1529080-1-kaleshsingh@google.com/
> v6: https://lore.kernel.org/r/20220314200148.2695206-1-kaleshsingh@google.com/
> v5: https://lore.kernel.org/r/20220307184935.1704614-1-kaleshsingh@google.com/
> v4: https://lore.kernel.org/r/20220225033548.1912117-1-kaleshsingh@google.com/
> v3: https://lore.kernel.org/r/20220224051439.640768-1-kaleshsingh@google.com/
> v2: https://lore.kernel.org/r/20220222165212.2005066-1-kaleshsingh@google.com/
> v1: https://lore.kernel.org/r/20220210224220.4076151-1-kaleshsingh@google.com/
> 
> [...]

Applied to next, thanks!

[1/6] KVM: arm64: Introduce hyp_alloc_private_va_range()
      commit: 92abe0f81e1385afd8f1dc66206b5be9a514899b
[2/6] KVM: arm64: Introduce pkvm_alloc_private_va_range()
      commit: f922c13e778d6d5343d4576be785a8204c595113
[3/6] KVM: arm64: Add guard pages for KVM nVHE hypervisor stack
      commit: ce3354318a57875dc59f4bb841662e95bfba03db
[4/6] KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack
      commit: 1a919b17ef012ca0572bae759c27e5ea02bfb47f
[5/6] KVM: arm64: Detect and handle hypervisor stack overflows
      commit: 66de19fad9ef47c5376a99bb2b00661f1c788a94
[6/6] KVM: arm64: Symbolize the nVHE HYP addresses
      commit: 6ccf9cb557bd32073b0d68baed97f1bd8a40ff1d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
