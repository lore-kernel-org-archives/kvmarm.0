Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0362DC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 08:23:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69DD660EFE
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 08:23:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 69DD660EFE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 028CC49DE3;
	Mon, 11 Oct 2021 04:23:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Uv-4gB6pqeqt; Mon, 11 Oct 2021 04:23:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E2E44ACC9;
	Mon, 11 Oct 2021 04:23:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5F9249DE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 04:23:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jNM3Koj-u0bU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 04:23:13 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA3BB407ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 04:23:13 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 364C060231;
 Mon, 11 Oct 2021 08:23:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mZqaS-00FxaF-Uu; Mon, 11 Oct 2021 09:23:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 0/6] KVM: arm64: Restrict host hypercalls when pKVM is
 enabled
Date: Mon, 11 Oct 2021 09:23:03 +0100
Message-Id: <163394056714.532004.7796153574955915700.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211008135839.1193-1-will@kernel.org>
References: <20211008135839.1193-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, will@kernel.org,
 catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, 8 Oct 2021 14:58:33 +0100, Will Deacon wrote:
> This is version three of the patches I previously posted here:
> 
>   v1: https://lore.kernel.org/r/20210923112256.15767-1-will@kernel.org
>   v2: https://lore.kernel.org/r/20211005113721.29441-1-will@kernel.org
> 
> Changes since v3 are:
> 
> [...]

Applied to next, thanks!

[1/6] KVM: arm64: Turn __KVM_HOST_SMCCC_FUNC_* into an enum (mostly)
      commit: a78738ed1d9bf40d09109599b884508c69d188b8
[2/6] arm64: Prevent kexec and hibernation if is_protected_kvm_enabled()
      commit: 8f4566f18db5d1257fc2d5442e16274424a529c1
[3/6] KVM: arm64: Reject stub hypercalls after pKVM has been initialised
      commit: 8579a185bacaa64c65e43e251ceede2f7600f7e2
[4/6] KVM: arm64: Propagate errors from __pkvm_prot_finalize hypercall
      commit: 2f2e1a5069679491d18cf9021da19b40c56a17f3
[5/6] KVM: arm64: Prevent re-finalisation of pKVM for a given CPU
      commit: 07036cffe17ec07e8fb630d86f8ea21832d9e57d
[6/6] KVM: arm64: Disable privileged hypercalls after pKVM finalisation
      commit: 057bed206f70d624c2eacb43ec56551950a26832

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
