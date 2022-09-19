Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28963C54EE9
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 10:04:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A07A74B6E2;
	Mon, 19 Sep 2022 06:04:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0d-Kv89JkW1Z; Mon, 19 Sep 2022 06:04:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8546D4B64E;
	Mon, 19 Sep 2022 06:04:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C202D4B285
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 06:04:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z2INZYB1wfKW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 06:04:08 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7988D4B13D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 06:04:08 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7D96360E9C;
 Mon, 19 Sep 2022 10:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17A1C433C1;
 Mon, 19 Sep 2022 10:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663581846;
 bh=vv5edDA3DSeWqg/CbFNAolrHqtgw8wIZzdfQbXSqnyc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=mDWaFwrGS+TF3aqhtbdma4NfFSruPnIYtIGi6LC3Jh4o3Inw0+q+cte/Jvw0VplZq
 6P2+7Hap/2gqsDXoyrxqSGG6MuJglxt7cZQ3bn5dRIvq/0EDX4QiHmxKzJQ/mzaH7B
 64uRNaa5jNE5rMiCpUjxdzqldF/NdYaE1UTkSYnz7tuFZXP1EOJxYo/ddJiI6/E9+j
 i6Gph6PYhzlIgGewjJzUM1IY7mIA7ppfK2H0b7P7V46MDGrN9f3boFqo/ePRaPOxq6
 thn6MwFN/qmD+o/7bRsRk+ayqVIJWKFp2s7UJPz+j4fWsyprllFMuW4OyAZLdt7Tr2
 OsyvzwjuI3E8A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oaDdE-00B4JL-VQ;
 Mon, 19 Sep 2022 11:04:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Fix bugs of single-step execution
 enabled by userspace
Date: Mon, 19 Sep 2022 11:04:01 +0100
Message-Id: <166358182480.2829822.10216167209295970084.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220917010600.532642-1-reijiw@google.com>
References: <20220917010600.532642-1-reijiw@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, reijiw@google.com,
 linux-arm-kernel@lists.infradead.org, ricarkol@google.com,
 jingzhangos@google.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 suzuki.poulose@arm.com, pbonzini@redhat.com, james.morse@arm.com,
 rananta@google.com, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

On Fri, 16 Sep 2022 18:05:56 -0700, Reiji Watanabe wrote:
> This series fixes two bugs of single-step execution enabled by
> userspace, and add a test case for KVM_GUESTDBG_SINGLESTEP to
> the debug-exception test to verify the single-step behavior.
> 
> Patch 1 fixes a bug that KVM might unintentionally change PSTATE.SS
> for the guest when single-step execution is enabled for the vCPU by
> userspace.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Preserve PSTATE.SS for the guest while single-step is enabled
      commit: 34fbdee086cfcc20fe889d2b83afddfbe2ac3096
[2/4] KVM: arm64: Clear PSTATE.SS when the Software Step state was Active-pending
      commit: 370531d1e95be57c62fdf065fb04fd8db7ade8f9
[3/4] KVM: arm64: selftests: Refactor debug-exceptions to make it amenable to new test cases
      commit: ff00e737090e0f015059e59829aaa58565b16321
[4/4] KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP
      commit: b18e4d4aebdddd05810ceb2f73d7f72afcd11b41

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
