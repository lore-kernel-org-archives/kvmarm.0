Return-Path: <SRS0=McOM=P3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E87C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 10:50:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5BDB16112D
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 10:50:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5BDB16112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF4424B16E;
	Mon,  8 Nov 2021 05:50:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ytL7FTKVX61o; Mon,  8 Nov 2021 05:50:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 966EE4B190;
	Mon,  8 Nov 2021 05:50:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6AD04B16E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 05:50:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tOsCobUFYZEd for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 05:50:41 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EEF84B120
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 05:50:41 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 97C20610A2;
 Mon,  8 Nov 2021 10:50:39 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mk2EX-00485M-AC; Mon, 08 Nov 2021 10:50:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: YueHaibing <yuehaibing@huawei.com>, catalin.marinas@arm.com,
 will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com
Subject: Re: [PATCH -next] KVM: arm64: change the return type of
 kvm_vcpu_preferred_target()
Date: Mon,  8 Nov 2021 10:50:31 +0000
Message-Id: <163636862371.2539804.18004750098496093510.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211105011500.16280-1-yuehaibing@huawei.com>
References: <20211105011500.16280-1-yuehaibing@huawei.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: yuehaibing@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On Fri, 5 Nov 2021 09:15:00 +0800, YueHaibing wrote:
> kvm_vcpu_preferred_target() always return 0 because kvm_target_cpu()
> never returns a negative error code.

Applied to next, thanks!

[1/1] KVM: arm64: change the return type of kvm_vcpu_preferred_target()
      commit: 08e873cb70f30e11e912a93390f1c0c4e65fae1c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
