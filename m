Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04DCC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 09:47:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AD1C4B15E;
	Thu,  7 Apr 2022 05:47:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YvHjNKKKTiAS; Thu,  7 Apr 2022 05:47:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 674694B0BA;
	Thu,  7 Apr 2022 05:47:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E094E4B0FC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 05:47:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6e8TvDPlrRkM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 05:47:33 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B305B4B093
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 05:47:33 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 520F1B826BA;
 Thu,  7 Apr 2022 09:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E15C385A4;
 Thu,  7 Apr 2022 09:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649324851;
 bh=ov8hUREiFkfx9WQR6MbrdhRmIn5JuS4ippBd4nbLP+4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=AKaERjZOBt/VaP+NDZ5pTDV+osWGjYPbYCeqD37+VNkzZ8Yts8lLxRnVhR7O5UtVt
 LYoi8mv+Q9vqf9ucoqfI+WE2DdqCzvKMAsaZ0kR3gNSuOCWQtCn2Zi+59vhsbcXasi
 lt6hd+4aYEm+hv14GoWcGa2j+XrRRt0DpuzivVaP9t3fvo9G63Z+B5jzzotawM0MDS
 MkyiMkzwbhMMRj/vLdhDb1uE9+S7FevRVt9o8+oIsfHPEJTHhLGKHiKocDrKdrhMyg
 xrWu8UHTTRck6fRn/32e0jmljZoBnn/WdZNdhol82VS/EnFUCu7oWBuIwITFzywDUY
 sJKDt/Rx4Syfw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1ncOjg-002RDv-LA; Thu, 07 Apr 2022 10:47:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 0/3] KVM: Fix use-after-free in debugfs
Date: Thu,  7 Apr 2022 10:47:25 +0100
Message-Id: <164932482949.4015708.14856763096234436640.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220406235615.1447180-1-oupton@google.com>
References: <20220406235615.1447180-1-oupton@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com,
 reijiw@google.com, seanjc@google.com, alexandru.elisei@arm.com,
 ricarkol@google.com, linux-arm-kernel@lists.infradead.org, pshier@google.com,
 suzuki.poulose@arm.com, pbonzini@redhat.com, james.morse@arm.com,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

On Wed, 6 Apr 2022 23:56:12 +0000, Oliver Upton wrote:
> Funny enough, dirty_log_perf_test on arm64 highlights some issues around
> the use of debugfs in KVM. The test leaks a GIC FD across test
> iterations, and as such the associated VM is never destroyed.
> Nonetheless, the VM FD is reused for the next VM, which collides with
> the old debugfs directory.
> 
> Where things get off is when the vgic-state debugfs file is created. KVM
> does not check if the VM directory exists before creating the file,
> which results in the file being added to the root of debugfs when the
> aforementioned collision occurs.
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: Don't create VM debugfs files outside of the VM directory
      commit: a44a4cc1c969afec97dbb2aedaf6f38eaa6253bb
[2/3] selftests: KVM: Don't leak GIC FD across dirty log test iterations
      commit: 386ba265a8197716076a88853244f4437b92b167
[3/3] selftests: KVM: Free the GIC FD when cleaning up in arch_timer
      commit: 21db83846683d3987666505a3ec38f367708199a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
