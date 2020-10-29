Return-Path: <SRS0=BReL=EE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA28C4742C
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 21:09:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5FF820809
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 21:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IsYLpf76"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5FF820809
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81AC34B692;
	Thu, 29 Oct 2020 17:09:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id svRwzmFdcfHI; Thu, 29 Oct 2020 17:09:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70A474B696;
	Thu, 29 Oct 2020 17:09:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AA174B688
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 17:09:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kxG9gzLbj4Ql for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Oct 2020 17:09:30 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 464C44B4A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 17:09:30 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2E50020790;
 Thu, 29 Oct 2020 21:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604005768;
 bh=eJNmaxxN3bpRjg/8DkkzFyp4/7A6NSEBbr9xR4ejjE8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=IsYLpf76qsMNEqFoOKshdSo4uaeuSbwQmfqFl9ir6v9gNLijgXteca4AX2b/Knh8c
 n8bTR+8mtT/1eIEtYD5yYp/LNS2bUoWcBPYzf0TiJTK0yJ5+LEFDUlXw3Fri5/Lqmd
 Njr0fvtOotvzhVPV9WeCEpAAmVsL7YyE+B1gjqEs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kYFAk-005YNy-Az; Thu, 29 Oct 2020 21:09:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, Gavin Shan <gshan@redhat.com>,
 Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix masks in stage2_pte_cacheable()
Date: Thu, 29 Oct 2020 21:09:18 +0000
Message-Id: <160400571841.9348.3202358449739872177.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029144716.30476-1-will@kernel.org>
References: <20201029144716.30476-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, gshan@redhat.com,
 will@kernel.org, shan.gavin@gmail.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com
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

On Thu, 29 Oct 2020 14:47:16 +0000, Will Deacon wrote:
> stage2_pte_cacheable() tries to figure out whether the mapping installed
> in its 'pte' parameter is cacheable or not. Unfortunately, it fails
> miserably because it extracts the memory attributes from the entry using
> FIELD_GET(), which returns the attributes shifted down to bit 0, but then
> compares this with the unshifted value generated by the PAGE_S2_MEMATTR()
> macro.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix masks in stage2_pte_cacheable()
      commit: e2fc6a9f686d037cbd9b08b9fb657685b4a722d3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
