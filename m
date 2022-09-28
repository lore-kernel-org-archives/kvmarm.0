Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EE0C32771
	for <kvmarm@archiver.kernel.org>; Wed, 28 Sep 2022 15:53:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCD574B630;
	Wed, 28 Sep 2022 11:53:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id osQj6tc-epAe; Wed, 28 Sep 2022 11:53:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6E0D4B638;
	Wed, 28 Sep 2022 11:53:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 110F94B62F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2022 11:53:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6OveWR7NJDyb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Sep 2022 11:53:54 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF6074B629
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2022 11:53:53 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 15D5961F0C;
 Wed, 28 Sep 2022 15:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBAFC433C1;
 Wed, 28 Sep 2022 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1664380432;
 bh=nBPunl5TlQZD8jgaoQw53yxRscbk/pyS0FZr8ut3NwU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=BkP2ThbW79wrrZlsNPqDWK6C5y0ON+cYFY7t1veHGr+vAuwHnB2g5G2fM0ur9yVma
 TNyzihtbiLsBAdUAPDNvmf5Qe7IVktW+eqecxOIkhGnjrlMu1632Hu5qB4UQBP/xVk
 h91daEoeyxbLJKDBU6BcYTqPUtYRnJSJ9yKawAFi6F7d31AkRyInHo2nWtaonYhfHo
 Cq2i9WqXVDeuZwG19toxnPU7xbZxFE3voxOcDOOSMeMBbGmjEMLNcOqpYndfT6TXrQ
 9O9q85rkhlv/W9ry9/maKNZDzGtcIGylq2cCYTwErBs766kPdBUJxAAv1b45K6pJtI
 CH6BY1C7LqMeQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1odZNe-00DK8u-4K;
 Wed, 28 Sep 2022 16:53:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Shuah Khan <shuah@kernel.org>
Subject: Re: [RESEND PATCH] KVM: selftests: Update top-of-file comment in
 psci_test
Date: Wed, 28 Sep 2022 16:53:46 +0100
Message-Id: <166438042059.3795682.3522181061739798083.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819162100.213854-1-oliver.upton@linux.dev>
References: <20220819162100.213854-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, james.morse@arm.com,
 suzuki.poulose@arm.com, pbonzini@redhat.com, alexandru.elisei@arm.com,
 shuah@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On Fri, 19 Aug 2022 16:21:00 +0000, Oliver Upton wrote:
> Fix the comment to accurately describe the test and recently added
> SYSTEM_SUSPEND test case.
> 
> What was once psci_cpu_on_test was renamed and extended to squeeze in a
> test case for PSCI SYSTEM_SUSPEND. Nonetheless, the author of those
> changes (whoever they may be...) failed to update the file comment to
> reflect what had changed.

Applied to next, thanks!

[1/1] KVM: selftests: Update top-of-file comment in psci_test
      commit: 448e711693e48d03f7933ab3673334701b0c3f41

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
