Return-Path: <SRS0=jAo2=DJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73A4C47427
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 08:20:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 697D620738
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 08:20:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXKaI54w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 697D620738
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D6FC4B5F0;
	Fri,  2 Oct 2020 04:20:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l8lO8PHIVZk2; Fri,  2 Oct 2020 04:20:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 741FB4B5E5;
	Fri,  2 Oct 2020 04:20:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A67094B5AC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 04:20:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ponOqupf7dfe for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2020 04:20:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 732BB4B594
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 04:20:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3F15920708;
 Fri,  2 Oct 2020 08:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601626811;
 bh=gXixh2XdZm6GKYQlcD19rmjISbAZZR60Gs3FiRhDfqo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=QXKaI54w+2nx6aQTzWFzXQ2IKJ4b0x+El7lpBPLHqN5Tcv7be3QG/6yshc87ymC0k
 2dYnsybxkPSt34J7ZFak/IzqLyufkh9bwuUV6WvHfEo2Z6wnB7jPOxu4KZUuhMrZnb
 CmDKB3/awriaYna0eOzuF+rpPxWn2+3WRuJSGSJc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kOGIT-00GeG7-9F; Fri, 02 Oct 2020 09:20:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v4 00/10] Independent per-CPU data section for nVHE
Date: Fri,  2 Oct 2020 09:19:58 +0100
Message-Id: <160162675379.1930042.11075043461338207978.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922204910.7265-1-dbrazdil@google.com>
References: <20200922204910.7265-1-dbrazdil@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, dbrazdil@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 dennis@kernel.org, catalin.marinas@arm.com, will@kernel.org, tj@kernel.org,
 kernel-team@android.com, cl@linux.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On Tue, 22 Sep 2020 21:49:00 +0100, David Brazdil wrote:
> Introduce '.hyp.data..percpu' as part of ongoing effort to make nVHE
> hyp code self-contained and independent of the rest of the kernel.
> 
> Main benefits:
>  * independent nVHE per-CPU data section that can be unmapped from host,
>  * more robust linking of nVHE hyp code,
>  * no need for hyp-specific macros to access per-CPU variables.
> 
> [...]

Applied to next, thanks!

[01/10] kvm: arm64: Partially link nVHE hyp code, simplify HYPCOPY
        commit: ab25464bdabd45f283cc1194e332040f89071106
[02/10] kvm: arm64: Move nVHE hyp namespace macros to hyp_image.h
        commit: ce492a16ffb8814d9651c3fdafc363bfa1b01189
[03/10] kvm: arm64: Only define __kvm_ex_table for CONFIG_KVM
        commit: 3471ee06e33e413d7fa73c1aa3092e6e794b9e05
[04/10] kvm: arm64: Remove __hyp_this_cpu_read
        commit: 717cf94adb54095d14a6674baea73123188f2901
[05/10] kvm: arm64: Remove hyp_adr/ldr_this_cpu
        commit: ea391027d35546d9155f1350123b5af8bddec706
[06/10] kvm: arm64: Add helpers for accessing nVHE hyp per-cpu vars
        commit: 572494995bc3d282336bfd8162741929402910b9
[07/10] kvm: arm64: Duplicate arm64_ssbd_callback_required for nVHE hyp
        commit: df4c8214a18d202fa0ec221a001f640e020f7e44
[08/10] kvm: arm64: Create separate instances of kvm_host_data for VHE/nVHE
        commit: 2a1198c9b436402582f7beed57028044b819329c
[09/10] kvm: arm64: Set up hyp percpu data for nVHE
        commit: 30c953911c4370bfb622ee1c2fcc7e78c84df800
[10/10] kvm: arm64: Remove unnecessary hyp mappings
        commit: a3bb9c3a00551726590137e3974495ce6cf6b758

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
