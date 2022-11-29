Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CF0C46467
	for <kvmarm@archiver.kernel.org>; Tue, 29 Nov 2022 09:34:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD7C44B3DA;
	Tue, 29 Nov 2022 04:34:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XGr9aDoh3cUZ; Tue, 29 Nov 2022 04:34:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4ACE4B2A3;
	Tue, 29 Nov 2022 04:34:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD7B240ECC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 04:33:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rIYN7TTr2ods for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2022 04:33:58 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B7D940D74
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 04:33:58 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7D2DE615F9;
 Tue, 29 Nov 2022 09:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7284C433B5;
 Tue, 29 Nov 2022 09:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1669714436;
 bh=ytWdPWoB0JLE0rRUZJi+OM1M3Tzfp92cT1vL1sIg8v8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Y6JH88oo4vC9v6ACmJS+9+NyoNhLVThp44OSn2zWEDbHiPU3tjy1NGI88c8Dik4+s
 e4LJ+fJz5twYy0FB0LwIDXO6T8xb5xDJHIBMcReDOSfTVwWYO8kc4czV9/2MH8MF4c
 8d3gi8ruxhHrgakpzA2JlUCDxGOTd7c9IO1DBJri9COdFMeTLh1Z+8+LmPFprlZxcR
 NR2+RynL7ufl+FiGNkikBmb1GYoqydCm/hfbe2kct7f+fk8e4xOf6W/xqlBTo8mbrx
 HYqaCIxCDd3Rv+6ltHolWJc9bOv09NJa9IP3Wo/Fw86SBdIRXkeILgagnYbAJOZqec
 mi7n0Ux4LNybg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ozwzy-009Jpu-AB;
 Tue, 29 Nov 2022 09:33:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: Peter Collingbourne <pcc@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v5 0/8] KVM: arm64: permit MAP_SHARED mappings with MTE
 enabled
Date: Tue, 29 Nov 2022 09:33:51 +0000
Message-Id: <166971432264.1905185.15808052624158484529.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
References: <20221104011041.290951-1-pcc@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pcc@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, steven.price@arm.com,
 catalin.marinas@arm.com, eugenis@google.com, cohuck@redhat.com,
 kvm@vger.kernel.org, vincenzo.frascino@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Cornelia Huck <cohuck@redhat.com>, Steven Price <steven.price@arm.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 Evgenii Stepanov <eugenis@google.com>
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

On Thu, 3 Nov 2022 18:10:33 -0700, Peter Collingbourne wrote:
> This patch series allows VMMs to use shared mappings in MTE enabled
> guests. The first five patches were taken from Catalin's tree [1] which
> addressed some review feedback from when they were previously sent out
> as v3 of this series. The first patch from Catalin's tree makes room
> for an additional PG_arch_3 flag by making the newer PG_arch_* flags
> arch-dependent. The next four patches are based on a series that
> Catalin sent out prior to v3, whose cover letter [2] I quote from below:
> 
> [...]

No feedback has been received, so this code is obviously perfect.

Applied to next, thanks!

[1/8] mm: Do not enable PG_arch_2 for all 64-bit architectures
      commit: b0284cd29a957e62d60c2886fd663be93c56f9c0
[2/8] arm64: mte: Fix/clarify the PG_mte_tagged semantics
      commit: e059853d14ca4ed0f6a190d7109487918a22a976
[3/8] KVM: arm64: Simplify the sanitise_mte_tags() logic
      commit: 2dbf12ae132cc78048615cfa19c9be64baaf0ced
[4/8] mm: Add PG_arch_3 page flag
      commit: ef6458b1b6ca3fdb991ce4182e981a88d4c58c0f
[5/8] arm64: mte: Lock a page for MTE tag initialisation
      commit: d77e59a8fccde7fb5dd8c57594ed147b4291c970
[6/8] KVM: arm64: unify the tests for VMAs in memslots when MTE is enabled
      commit: d89585fbb30869011b326ef26c94c3137d228df9
[7/8] KVM: arm64: permit all VM_MTE_ALLOWED mappings with MTE enabled
      commit: c911f0d4687947915f04024aa01803247fcf7f1a
[8/8] Documentation: document the ABI changes for KVM_CAP_ARM_MTE
      commit: a4baf8d2639f24d4d31983ff67c01878e7a5393f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
