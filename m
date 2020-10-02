Return-Path: <SRS0=jAo2=DJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2168C47426
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 08:20:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B05B20708
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 08:20:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHUZwUne"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B05B20708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2A494B5E6;
	Fri,  2 Oct 2020 04:20:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zkhAEifr0IQD; Fri,  2 Oct 2020 04:20:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5D0A4B5E3;
	Fri,  2 Oct 2020 04:20:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32A604B5DF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 04:20:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aYbK7FLo+57G for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2020 04:20:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C4794B5AC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 04:20:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1828420874;
 Fri,  2 Oct 2020 08:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601626813;
 bh=LS7DFHMHv0QPOMTFevqOW9pSAWbSairLgB3n2smSWD0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=WHUZwUneIoI7aUQYvSja1w4RxVE0zQfW5/p+Eat/EIPPFD+err6otFee0OmvXa4sI
 bLP6Y28udzsgeFuv2SaMCV50HiqEaNussiGfzRM+QiiAvXGjj1xHcKzGT196YtWkpQ
 Itk2J5kNp+RBdS0cNa1pXXXYp36kpt6LCljTpT3w=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kOGIV-00GeG7-H4; Fri, 02 Oct 2020 09:20:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, David Brazdil <dbrazdil@google.com>,
 Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Ensure user_mem_abort() return value is
 initialised
Date: Fri,  2 Oct 2020 09:20:00 +0100
Message-Id: <160162675379.1930042.16468950598631893927.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930102442.16142-1-will@kernel.org>
References: <20200930102442.16142-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, dbrazdil@google.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, dennis@kernel.org, catalin.marinas@arm.com,
 tj@kernel.org, kernel-team@android.com, cl@linux.com, lkp@intel.com,
 willdeacon@google.com, dan.carpenter@oracle.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel test robot <lkp@intel.com>, Will Deacon <willdeacon@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Dan Carpenter <dan.carpenter@oracle.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

On Wed, 30 Sep 2020 11:24:42 +0100, Will Deacon wrote:
> If a change in the MMU notifier sequence number forces user_mem_abort()
> to return early when attempting to handle a stage-2 fault, we return
> uninitialised stack to kvm_handle_guest_abort(), which could potentially
> result in the injection of an external abort into the guest or a spurious
> return to userspace. Neither or these are what we want to do.
> 
> Initialise 'ret' to 0 in user_mem_abort() so that bailing due to a
> change in the MMU notrifier sequence number is treated as though the
> fault was handled.

Applied to next, thanks!

[1/1] KVM: arm64: Ensure user_mem_abort() return value is initialised
      commit: 84cd7df693f07df94d617049773f7c757a2b7847

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
