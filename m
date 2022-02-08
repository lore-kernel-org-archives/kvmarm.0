Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6503C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 17:37:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C9234B130;
	Tue,  8 Feb 2022 12:37:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lgx3skYsc9Je; Tue,  8 Feb 2022 12:37:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C035A4B104;
	Tue,  8 Feb 2022 12:37:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 035594B0F7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id umut+X-jeNGk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 12:37:28 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29C344B13D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:28 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 460CFB81CB5;
 Tue,  8 Feb 2022 17:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6A6C004E1;
 Tue,  8 Feb 2022 17:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644341846;
 bh=JKHJOojfS8FhAcMS7Z7icwQjWdHq6AqagfXL8gLr5mU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qvPl4OJE0SWbYT+h1FCKcs9L3sweRhol6J8IlsNyzxIQAcVKENRdjs40Ol+cw7Ugj
 XPNKznAn/1sMoGcCy0dwM455kw539o1CjlqTpfbppkIO5KYHze2quRjOW8vWm2T/Uw
 2sg+8jGAV71xfUwbQvanGAeexxRDqyNK3sRM34jH/ZzaHdhSg+NlNXGT6yWDScxmcB
 iRjopie42c8n3AZg/6lOwzmBSblZDkqL+yyyV5EkYRuWcfytEALbcgNrLoq8zmbcCd
 4MguBk5AiIE5oXFhr7Fy+hyO5ZQ3EXArBuXC01XctRtEUM5f2TNjUUGXGf4Q0PoIDj
 Lnq0G0eLbgOAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nHUQd-006KsJ-FJ; Tue, 08 Feb 2022 17:37:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Oliver Upton <oupton@google.com>
Subject: Re: [PATCH] KVM: arm64: Drop unused param from kvm_psci_version()
Date: Tue,  8 Feb 2022 17:37:22 +0000
Message-Id: <164434147328.3931943.5227606914668090468.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220208012705.640444-1-oupton@google.com>
References: <20220208012705.640444-1-oupton@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org
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

On Tue, 8 Feb 2022 01:27:05 +0000, Oliver Upton wrote:
> kvm_psci_version() consumes a pointer to struct kvm in addition to a
> vcpu pointer. Drop the kvm pointer as it is unused. While the comment
> suggests the explicit kvm pointer was useful for calling from hyp, there
> exist no such callsite in hyp.

Applied to next, thanks!

[1/1] KVM: arm64: Drop unused param from kvm_psci_version()
      commit: dfefa04a90cf9a20090cfa096153d64f95b7e33f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
