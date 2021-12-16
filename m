Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B209CC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 16 Dec 2021 13:07:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18FE24B267;
	Thu, 16 Dec 2021 08:07:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qu3tyIhYL7iE; Thu, 16 Dec 2021 08:07:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CD544B25A;
	Thu, 16 Dec 2021 08:07:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0082D4B252
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 08:07:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TrF4LcXK6aQu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Dec 2021 08:07:53 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC7C04B250
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 08:07:53 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 6C35561D85;
 Thu, 16 Dec 2021 13:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5438C36AE0;
 Thu, 16 Dec 2021 13:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639660071;
 bh=tVxJs3qFlFqEz+NpongiLGAAImVHztVGXRZ9WOX/eaw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=AJX2I9B9OPdfRadrxGrh10XCoEWrJmzSgXk2fBpYpES7RPeP0RoENWPlOZGtqlgnh
 9gIMIUmB0jkRy1XBNQKeSeuDlljC2CSjyqzFqSyrAZVpoGsXUMIesLPubAV+uyh02l
 UGbGO9DKzeD4jbIRvWd/gpCLH/bcjKks3NCHDmeBknYbcoNUIfrDy/qraMToaymknR
 zfC0iB3QNK26yDJK2IHFE9EFIsSfjEa/MFijqqWb6PlKTayqzODTPSXIejXqSSufBr
 XJHwqNhzvXSZypr+MdmQOTZK0ankTPx9lEmL66LaskGbfRhPm6IcEMTlB0j67ztPFq
 sIcoJKNuKnASQ==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mxqU9-00CWrF-PT; Thu, 16 Dec 2021 13:07:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Will Deacon <will@kernel.org>,
 Quentin Perret <qperret@google.com>, James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 00/14] KVM: arm64: Introduce kvm_{un}share_hyp()
Date: Thu, 16 Dec 2021 13:07:47 +0000
Message-Id: <163966005889.1498341.15615109686112796585.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215161232.1480836-1-qperret@google.com>
References: <20211215161232.1480836-1-qperret@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, catalin.marinas@arm.com,
 alexandru.elisei@arm.com, will@kernel.org, qperret@google.com,
 james.morse@arm.com, linux-kernel@vger.kernel.org, qwandor@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org, qwandor@google.com, kvmarm@lists.cs.columbia.edu
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

On Wed, 15 Dec 2021 16:12:17 +0000, Quentin Perret wrote:
> This is v4 of the series previously posted here:
> 
>   https://lore.kernel.org/kvmarm/20211201170411.1561936-1-qperret@google.com/
> 
> This series implements an unshare hypercall at EL2 in nVHE protected
> mode, and makes use of it to unmmap guest-specific data-structures from
> EL2 stage-1 during guest tear-down. Crucially, the implementation of the
> share and unshare routines use page refcounts in the host kernel to
> avoid accidentally unmapping data-structures that overlap a common page.
> 
> [...]

Applied to next, thanks!

[01/14] KVM: arm64: Provide {get,put}_page() stubs for early hyp allocator
        commit: 1fac3cfb9cc60d71b66ee5127b2bc5b5f9f79df8
[02/14] KVM: arm64: Refcount hyp stage-1 pgtable pages
        commit: 2ea2ff91e82293909d4879b0b4c6c94b02d52b7e
[03/14] KVM: arm64: Fixup hyp stage-1 refcount
        commit: d6b4bd3f4897f3b60ac9e8c9e2f0300e739b3392
[04/14] KVM: arm64: Hook up ->page_count() for hypervisor stage-1 page-table
        commit: 34ec7cbf1ee0c45e66a0c24311bcd5b83b7109f5
[05/14] KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2
        commit: 82bb02445de57bb3072052705f6f5dea9465592e
[06/14] KVM: arm64: Introduce kvm_share_hyp()
        commit: 3f868e142c0bb052a1c15fd3ceca1391604e2e69
[07/14] KVM: arm64: pkvm: Refcount the pages shared with EL2
        commit: a83e2191b7f1894dd0b4b3816ceb9caf4e0cd7e5
[08/14] KVM: arm64: Extend pkvm_page_state enumeration to handle absent pages
        commit: 3d467f7b8c0a179a10aa4e9f17cd2d3c3b7e5403
[09/14] KVM: arm64: Introduce wrappers for host and hyp spin lock accessors
        commit: 61d99e33e757a21b47b8b130e49dcbdfaa5d2b1c
[10/14] KVM: arm64: Implement do_share() helper for sharing memory
        commit: e82edcc75c4e2389a3d7223c4ef1737bd9a07e5d
[11/14] KVM: arm64: Implement __pkvm_host_share_hyp() using do_share()
        commit: 1ee32109fd78720259f7431740897d37ebcd84f6
[12/14] KVM: arm64: Implement do_unshare() helper for unsharing memory
        commit: 376a240f037959c2b9a2486e53bcd8d388cbec17
[13/14] KVM: arm64: Expose unshare hypercall to the host
        commit: b8cc6eb5bded7078f796b2ebf548f79850281eb6
[14/14] KVM: arm64: pkvm: Unshare guest structs during teardown
        commit: 52b28657ebd7cd20e931ce71190f235d0fa018a6

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
