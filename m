Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE00AC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 20 Dec 2021 14:05:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A6584B492;
	Mon, 20 Dec 2021 09:05:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AqmO2A18pErM; Mon, 20 Dec 2021 09:05:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E26254B4BC;
	Mon, 20 Dec 2021 09:05:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C1BD4B4A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Dec 2021 09:05:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id idPq7QwOlnor for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Dec 2021 09:05:32 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 393564B4A4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Dec 2021 09:05:32 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 02AAACE10BC;
 Mon, 20 Dec 2021 14:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529F4C36AE8;
 Mon, 20 Dec 2021 14:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1640009127;
 bh=9VRUl4FJfRpZHqrKSlPjE8oCwWBPY/FwfePdrDsomSM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bhS098BlwZF/uiwz3sJBk2LR26BG6KdhvIImsyMI2HnYcxkXnJlhgsgpGg2lts3n1
 KZtX9BqSf1uHtLAyOAyDe9hk+03v7OG9CyW/EAKQIyFvklEQD78763gZnEJBzTpXLU
 8LiiRWbHdlYV8DcLVSLHmBGTaxCAp6MTpv50VnViMJHX2Gx3ESg5SjAYR6rs4HV3SE
 YaTf1PHjXUZUbeNBHBh7VzpHG8ckUVI84yE919iGl5JDYUY2m06x6fDlQBWTgMBCXi
 sUG9uhwChA3NnvKPYIErNMH9pFbnwmZmQOucsy85/gsBVqr7u6VqtH1IHkf/YR6IAP
 FZidyu5FCKAHw==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mzJI5-00DId5-DC; Mon, 20 Dec 2021 14:05:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 0/2] KVM: arm64: Fix documentation for PSCI related
 functions
Date: Mon, 20 Dec 2021 14:05:21 +0000
Message-Id: <164000911219.1759644.5028158034572789181.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208193257.667613-1-tabba@google.com>
References: <20211208193257.667613-1-tabba@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: tabba@google.com, kvmarm@lists.cs.columbia.edu,
 kernel-team@android.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, kernel-team@android.com
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

On Wed, 8 Dec 2021 19:32:55 +0000, Fuad Tabba wrote:
> This patch series fixes a couple of comments relating to PSCI and the reset
> state that are either typos, or refer to an earlier version of the code.
> 
> Thanks,
> /fuad
> 
> Fuad Tabba (2):
>   KVM: arm64: Fix comment for kvm_reset_vcpu()
>   KVM: arm64: Fix comment on barrier in kvm_psci_vcpu_on()
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Fix comment for kvm_reset_vcpu()
      commit: a080e323be8d66415944ad862fcf750825f871e7
[2/2] KVM: arm64: Fix comment on barrier in kvm_psci_vcpu_on()
      commit: dda0190d7ff7f26c221f9ab1659a73d4517920e7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
