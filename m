Return-Path: <SRS0=Fui2=GB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDBCDC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 29 Dec 2020 22:11:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B5EC221F8
	for <kvmarm@archiver.kernel.org>; Tue, 29 Dec 2020 22:11:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B5EC221F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D7064B315;
	Tue, 29 Dec 2020 17:11:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Psw8sxxhZHhl; Tue, 29 Dec 2020 17:11:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 819004B30D;
	Tue, 29 Dec 2020 17:11:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5CCB4B30A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 17:11:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J17MB3gk0YZj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Dec 2020 17:11:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B1804B1E0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 17:11:10 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 78D3020825;
 Tue, 29 Dec 2020 22:11:09 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kuNCt-004Ti1-6E; Tue, 29 Dec 2020 22:11:07 +0000
MIME-Version: 1.0
Date: Tue, 29 Dec 2020 22:11:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix section mismatches around
 hyp_cpu_pm_{init,exit}
In-Reply-To: <20201229214336.4098955-1-natechancellor@gmail.com>
References: <20201229214336.4098955-1-natechancellor@gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <49e9d2e2e7103c49882b54c18c567667@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: natechancellor@gmail.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, clang-built-linux@googlegroups.com,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 clang-built-linux@googlegroups.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-12-29 21:43, Nathan Chancellor wrote:
> Commit fa8c3d65538a ("KVM: arm64: Keep nVHE EL2 vector installed")
> inadvertently changed clang's inlining decisions around
> hyp_cpu_pm_{init,exit}, causing the following section mismatch 
> warnings:
> 
> WARNING: modpost: vmlinux.o(.text+0x95c6c): Section mismatch in
> reference from the function kvm_arch_init() to the function
> .init.text:hyp_cpu_pm_exit()
> The function kvm_arch_init() references
> the function __init hyp_cpu_pm_exit().
> This is often because kvm_arch_init lacks a __init
> annotation or the annotation of hyp_cpu_pm_exit is wrong.
> 
> WARNING: modpost: vmlinux.o(.text+0x97054): Section mismatch in
> reference from the function init_subsystems() to the function
> .init.text:hyp_cpu_pm_init()
> The function init_subsystems() references
> the function __init hyp_cpu_pm_init().
> This is often because init_subsystems lacks a __init
> annotation or the annotation of hyp_cpu_pm_init is wrong.
> 
> Remove the __init annotation so that there are no warnings regardless 
> of
> how functions are inlined.
> 
> Fixes: 1fcf7ce0c602 ("arm: kvm: implement CPU PM notifier")
> Fixes: 06a71a24bae5 ("arm64: KVM: unregister notifiers in hyp mode
> teardown path")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1230
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Hi Nathan,

Already posted[1] last week.

Thanks,

         M.

[1] htps://lore.kernel.org/r/20201223120854.255347-1-maz@kernel.org
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
