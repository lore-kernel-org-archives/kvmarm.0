Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 951C5C47247
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 17:53:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C814208D6
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 17:53:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="TnzHy6V0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C814208D6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84F6A4B3D2;
	Thu, 30 Apr 2020 13:53:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xUNE4x8Kk8x7; Thu, 30 Apr 2020 13:53:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3862E4B3CE;
	Thu, 30 Apr 2020 13:53:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4192D4B3B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 13:53:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lvzLiVRmxAUr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 13:53:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 074344B3B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 13:53:50 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C9B7F20836;
 Thu, 30 Apr 2020 17:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588269228;
 bh=4Xo8/1e7qaJmuQQltLTfB4vjVZPdGrjTFYT8oEPKWno=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=TnzHy6V0ZH7paWMDm5JrkAHnp/DaOr3pZvhvI0vYr1381WdBJTPVhmepyRnBUiLba
 o8thxzN3rCxTBpDBvcLfBQetKd7K7qWM3ZeU1eXq82INA7n961BxRiD4T+u1HNYwcZ
 dpNJGdEFn0SyLaoq3c7EWRsANA/N5cp3TcBUyYss=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jUDNb-0088YE-6h; Thu, 30 Apr 2020 18:53:47 +0100
MIME-Version: 1.0
Date: Thu, 30 Apr 2020 18:53:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH 00/15] Split off nVHE hyp code
In-Reply-To: <20200430144831.59194-1-dbrazdil@google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <73efca41e7b955db4963ff182624107d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, catalin.marinas@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
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

Hi David,

Thanks for posting this, looks quite interesting!

On 2020-04-30 15:48, David Brazdil wrote:
> Refactor files in arch/arm64/kvm/hyp to compile all code which runs in 
> EL2
> under nVHE into separate object files from the rest of KVM. This is 
> done in
> preparation for being able to unmap .hyp.text from EL1 but has other 
> benefits,
> notably:
>  * safe use of KASAN/UBSAN/GCOV instrumentation on VHE code,
>  * cleaner HVC API,
>  * no need for __hyp_text annotations.
> 
> nVHE-specific code is moved to hyp/nvhe and compiled with custom build 
> rules
> similar to those used by EFI stub. Shared source files are compiled 
> under both
> VHE and nVHE build rules. Where a source file contained both VHE and 
> nVHE code,
> it is split into a shared header file and two C source files. This is 
> done one
> file per commit to make review easier.

Do you have any figure on how much bigger the final kernel becomes once 
this
is applied? I guess I can find out pretty easily, but this is the kind 
of thing
that would be useful to make part of your cover letter.

I'll try to review this shortly.

Thanks,

         M.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
