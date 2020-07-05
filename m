Return-Path: <SRS0=ILOk=AQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473E6C433E0
	for <kvmarm@archiver.kernel.org>; Sun,  5 Jul 2020 17:17:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE2C8206B7
	for <kvmarm@archiver.kernel.org>; Sun,  5 Jul 2020 17:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="U10GYN+T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE2C8206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D8054B0B5;
	Sun,  5 Jul 2020 13:17:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ROcuy-q+cBcy; Sun,  5 Jul 2020 13:17:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A3C24B080;
	Sun,  5 Jul 2020 13:17:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9C984B080
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2020 13:17:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5IVZb6ifkZkf for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Jul 2020 13:17:24 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B79DF4B07F
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2020 13:17:24 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 657DD206B7;
 Sun,  5 Jul 2020 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593969443;
 bh=d7CxIFbR9PjqU7uaul6PCzWr3qAvUzYOsNUr357wPcQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=U10GYN+TmXHfYJYIE6oBt7yYpNwspWBfmS37Yn7zhTg85DEOgadbIdBgWDyaQFfNp
 8Y6bHeOkQi4oYvreyN/qOPELIZIc79SPUbbOOLfNvnT7HlbX32RARgjavILURnb2pI
 brG1jsUjGj8ZgjOL8AdvXC4pO+BP96yS+OskK9Xw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1js8GX-009DEB-LA; Sun, 05 Jul 2020 18:17:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Scull <ascull@google.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] arm64: kvm: Remove kern_hyp_va from get_vcpu_ptr
Date: Sun,  5 Jul 2020 18:17:07 +0100
Message-Id: <159396935735.249189.17492989703239636430.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618093616.164413-1-ascull@google.com>
References: <20200618093616.164413-1-ascull@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: ascull@google.com, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, kernel-team@android.com
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

On Thu, 18 Jun 2020 10:36:16 +0100, Andrew Scull wrote:
> get_vcpu_ptr is an assembly accessor for the percpu value
> kvm_host_data->host_ctxt.__hyp_running_vcpu. kern_hyp_va only applies to
> nVHE however __hyp_running_vcpu is always assigned a pointer that has
> already had kern_hyp_va applied in __kvm_vcpu_run_nvhe.
> 
> kern_hyp_va is currently idempotent as it just masks and inserts the
> tag, but this could change in future and the second application is
> unnecessary.

Applied, thanks!

[1/1] arm64: kvm: Remove kern_hyp_va from get_vcpu_ptr
      commit: 2da3ffa6e840b9f8fc65a71326c43b716992861d

Best regards,
-- 
Without deviation from the norm, progress is not possible.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
