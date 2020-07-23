Return-Path: <SRS0=bqG1=BC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69799C433E1
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 08:17:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA88D2086A
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 08:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTHqP7lL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA88D2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E4234B32F;
	Thu, 23 Jul 2020 04:17:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A43QrcJfsVE7; Thu, 23 Jul 2020 04:17:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7168F4B331;
	Thu, 23 Jul 2020 04:17:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E57BA4B32F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 04:17:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2BZCYZebJm9i for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jul 2020 04:17:17 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B39034B328
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 04:17:17 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 972BD2086A;
 Thu, 23 Jul 2020 08:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595492236;
 bh=kgavO6LARHrOsiohXcR0b/r+PArNmIu2z3PsvONh/5U=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ZTHqP7lLhUkaZNW51k7H1hutdSuROAs44/5hLigNvWjpSwYWTE6ML8boordmj+vkQ
 AJSKeJ3cQyH/DVOUcASFHosJgjVL/GsQj5r7yp/kFQvPctiu5NDFVQuYJdSs6Ui9Ex
 TJWafT0zGrsseMmYEC1yCTVc/bqu2xXgkACBFj6A=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jyWPj-00ECtD-2X; Thu, 23 Jul 2020 09:17:15 +0100
MIME-Version: 1.0
Date: Thu, 23 Jul 2020 09:17:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL
 functions
In-Reply-To: <20200723025142.GA361584@ubuntu-n2-xlarge-x86>
References: <20200722162231.3689767-1-maz@kernel.org>
 <20200723025142.GA361584@ubuntu-n2-xlarge-x86>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <0fab73670fa24d1c08711991133e4255@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: natechancellor@gmail.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org,
 kernel-team@android.com, ndesaulniers@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Nick Desaulniers <ndesaulniers@google.com>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Hi Nathan,

On 2020-07-23 03:51, Nathan Chancellor wrote:
> On Wed, Jul 22, 2020 at 05:22:31PM +0100, Marc Zyngier wrote:
>> So far, vcpu_has_ptrauth() is implemented in terms of 
>> system_supports_*_auth()
>> calls, which are declared "inline". In some specific conditions (clang
>> and SCS), the "inline" very much turns into an "out of line", which
>> leads to a fireworks when this predicate is evaluated on a non-VHE
>> system (right at the beginning of __hyp_handle_ptrauth).
>> 
>> Instead, make sure vcpu_has_ptrauth gets expanded inline by directly
>> using the cpus_have_final_cap() helpers, which are __always_inline,
>> generate much better code, and are the only thing that make sense when
>> running at EL2 on a nVHE system.
>> 
>> Fixes: 29eb5a3c57f7 ("KVM: arm64: Handle PtrAuth traps early")
>> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
>> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Thank you for the quick fix! I have booted a mainline kernel with this
> patch with Shadow Call Stack enabled and verified that using KVM no
> longer causes a panic.

Great! I'll try and ferry this to mainline  as quickly as possible.

> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> For the future, is there an easy way to tell which type of system I am
> using (nVHE or VHE)? I am new to the arm64 KVM world but it is 
> something
> that I am going to continue to test with various clang technologies now
> that I have actual hardware capable of it that can run a mainline
> kernel.

ARMv8.0 CPUs are only capable of running non-VHE. So if you have
something based on older ARM CPUs (such as A57, A72, A53, A73, A35...),
or licensee CPUs (ThunderX, XGene, EMag...), this will only run
non-VHE (the host kernel runs at EL1, while the hypervisor runs at
EL2.

 From ARMv8.1 onward, VHE is normally present, and the host kernel
can run at EL2 directly. ARM CPUs include A55, A65, A75, A76, A77,
N1, while licensee CPUs include TX2, Kunpeng 920, and probably some
more.

As pointed out by Zenghui in another email, KVM shows which mode
it is using. Even without KVM, the kernel prints very early on:

[    0.000000] CPU features: detected: Virtualization Host Extensions

Note that this is only a performance difference, and that most
features that are supported by the CPU can be used by KVM in either
mode.

Thanks again,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
