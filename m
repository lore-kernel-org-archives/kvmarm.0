Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2227C8B4E1
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 12:40:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 50CD820855
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 12:40:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+oCIIJG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50CD820855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A27934BF7E;
	Mon, 16 Nov 2020 07:40:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q1e2yiBWeFLZ; Mon, 16 Nov 2020 07:40:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C87C4B81A;
	Mon, 16 Nov 2020 07:40:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A2AC4B718
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 07:40:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UiKgX0ik749s for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 07:40:38 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F0534B6DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 07:40:38 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D0D1020855;
 Mon, 16 Nov 2020 12:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605530437;
 bh=bnRBIAdk2TK++2iHRYZosXliTCu3OhJv4rdoa2NVmfc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=C+oCIIJGqLI68KPl/ac6T0nLWv4BxqB2Qz8BM1c0poeVLdfo9EQ45dutdqrK6+SEW
 PcGUDLNaPuo5rzZfBnu89Gj8a0GA6dDFBXUezlABZ318hrbzUg5UwJurDquQrfeagG
 IHXngfRu+tLaihN9baJrEjNYH+UZjNZ6J+rWOHUg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kedoA-00B0ja-Od; Mon, 16 Nov 2020 12:40:34 +0000
MIME-Version: 1.0
Date: Mon, 16 Nov 2020 12:40:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v1 13/24] kvm: arm64: Add CPU entry point in nVHE hyp
In-Reply-To: <20201116114952.ybj24wx44lofqs25@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-14-dbrazdil@google.com>
 <7b8f9dec846f172c2919e1d3f3c65245@kernel.org>
 <20201116114952.ybj24wx44lofqs25@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <549d918182c28d88550d27c068b772be@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, qwandor@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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

On 2020-11-16 11:49, David Brazdil wrote:
>> >  #ifdef CONFIG_CPU_PM
>> >    DEFINE(CPU_CTX_SP,		offsetof(struct cpu_suspend_ctx, sp));
>> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> > b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> > index 1697d25756e9..f999a35b2c8c 100644
>> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> > @@ -6,6 +6,7 @@
>> >
>> >  #include <linux/arm-smccc.h>
>> >  #include <linux/linkage.h>
>> > +#include <linux/irqchip/arm-gic-v3.h>
>> 
>> This should probably be included from the file that provides 
>> init_el2_state.
> 
> Agreed. This is a workaround for the fact that the arm-gic* headers 
> don't play
> nice with each other (define the same constants).

Ah, that...

> Including arm-gic-v3.h in
> kvm_asm.h will trigger macro redefine warnings in vgic*-v2.c because 
> they
> include arm-gic.h.

Boo.

> Another option is to create a header just for el2 init. Would that be
> preferable? Other ideas?

Having an asm/el2_setup.h file feels like a better option. After all, it
is in no way KVM specific, and having the macros hanging around in
asm/kvm_asm.h feels odd.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
