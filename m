Return-Path: <SRS0=ILOk=AQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1CBC433E0
	for <kvmarm@archiver.kernel.org>; Sun,  5 Jul 2020 21:10:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A6A2720739
	for <kvmarm@archiver.kernel.org>; Sun,  5 Jul 2020 21:10:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="w+2bsAyt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6A2720739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30D3F4B24F;
	Sun,  5 Jul 2020 17:10:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X1GbnxKxjTZV; Sun,  5 Jul 2020 17:10:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 308FB4B1EE;
	Sun,  5 Jul 2020 17:10:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1425F4B1EE
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2020 17:10:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ufvBrICC3wbm for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Jul 2020 17:10:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFCFB4B143
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2020 17:10:26 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A82E420739;
 Sun,  5 Jul 2020 21:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593983425;
 bh=setNPtTCAGJjI1QyLGqEBASB3tKCWwjer9bzycFaow8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=w+2bsAytjo8K3ht9YDCgQEjaq4t2xmE3LBuvL7LEdWXkWIqe0oYV7SqUDHEuT/h5r
 BCgwdvciCs/cYZxY5N2WqL+Dvrl9M/h5AsneNKsluJgnbZ5ke7DA9fWNoXhaRM5qjW
 MMPfstNN5nQxnNh694Q6J9xdkaLifnG7mov0vPLQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jsBu4-009G2i-31; Sun, 05 Jul 2020 22:10:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2] kvm/arm64: Rename HSR to ESR
Date: Sun,  5 Jul 2020 22:10:02 +0100
Message-Id: <159398334879.259909.8373182881998045936.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200630015705.103366-1-gshan@redhat.com>
References: <20200630015705.103366-1-gshan@redhat.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: gshan@redhat.com, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

On Tue, 30 Jun 2020 11:57:05 +1000, Gavin Shan wrote:
> kvm/arm32 isn't supported since commit 541ad0150ca4 ("arm: Remove
> 32bit KVM host support"). So HSR isn't meaningful since then. This
> renames HSR to ESR accordingly. This shouldn't cause any functional
> changes:
> 
>    * Rename kvm_vcpu_get_hsr() to kvm_vcpu_get_esr() to make the
>      function names self-explanatory.
>    * Rename variables from @hsr to @esr to make them self-explanatory.
> 
> [...]

Applied to kvm-arm64/next-5.9, thanks!

[1/1] KVM: arm64: Rename HSR to ESR
      commit: 3a949f4c93548751a377691b2a208063da05e369

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
