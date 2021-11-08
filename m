Return-Path: <SRS0=McOM=P3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4B1C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 10:46:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01D5F61360
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 10:46:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 01D5F61360
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 838494B120;
	Mon,  8 Nov 2021 05:46:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7ehH+wrw-Idd; Mon,  8 Nov 2021 05:46:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8FF64B125;
	Mon,  8 Nov 2021 05:46:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 089074B0BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 05:46:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fjBQqpSudUwU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 05:45:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDE754B0B4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 05:45:58 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DD98361360;
 Mon,  8 Nov 2021 10:45:57 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mk29z-00482K-Ns; Mon, 08 Nov 2021 10:45:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-kernel@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] arm64: kvm/hyp/nvhe: fix a non-kernel-doc comment
Date: Mon,  8 Nov 2021 10:45:52 +0000
Message-Id: <163636833368.2539547.13494193613344382138.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211106032529.15057-1-rdunlap@infradead.org>
References: <20211106032529.15057-1-rdunlap@infradead.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, rdunlap@infradead.org,
 kvmarm@lists.cs.columbia.edu, lkp@intel.com,
 linux-arm-kernel@lists.infradead.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel test robot <lkp@intel.com>
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

On Fri, 5 Nov 2021 20:25:29 -0700, Randy Dunlap wrote:
> Do not use kernel-doc "/**" notation when the comment is not in
> kernel-doc format.
> 
> Fixes this docs build warning:
> 
> arch/arm64/kvm/hyp/nvhe/sys_regs.c:478: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>     * Handler for protected VM restricted exceptions.

Applied to next, thanks!

[1/1] arm64: kvm/hyp/nvhe: fix a non-kernel-doc comment
      commit: deacd669e18a51cb2085450c56d851aef72b3256

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
