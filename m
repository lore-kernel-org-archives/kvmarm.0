Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D321C4332B
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 11:08:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B4FE120781
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 11:08:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mkqtchy0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4FE120781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 394534A5A0;
	Mon, 23 Mar 2020 07:08:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FPl-A6zEfXWu; Mon, 23 Mar 2020 07:08:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FF6F4A4FC;
	Mon, 23 Mar 2020 07:08:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E95F4A531
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 06:43:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2sl-4yO-QJ0j for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 06:43:15 -0400 (EDT)
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com
 [209.85.167.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5066F4A418
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 06:43:15 -0400 (EDT)
Received: by mail-oi1-f193.google.com with SMTP id k9so1628058oia.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 03:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=0QRTakxDjt17+QbOfoF/nJLB5wa9CfWEqfeO6UL7A9Q=;
 b=Mkqtchy0zxJninQWfll89zOOjsYmBoc3rZCZBjn7fUqZuuqSehGKryfcmVCQiZ57oR
 UuURLphNu0OxHWTJoJHgMrJhE6UQMwZZULwp9CSo50LLGz6pq+3n/BB9awfgt/EQK1TU
 6C2aYRAWStATz7k3OH1ioEa1jhrm1b3/OYz4vzR0Guy1RomC+SAAGuY6sIF674//xis0
 ptSmsvnq+qh6D7n8N2WrJrvZptMfDGf7KPRijv9yHC09PMgy9pwDmAPnmSj2Cjx7BNCe
 qOFyNGQNuOSjiKDnNlPE+/1YjB9ABQb4SNVEWWtyx/b8RpnZJNw49gZFtL8dhd92hMLE
 fO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=0QRTakxDjt17+QbOfoF/nJLB5wa9CfWEqfeO6UL7A9Q=;
 b=KZqBs8C6e2n6hH0m489mnjjGM8ZaAFtJPlZK5/67fLLJovZU8PPbufdaNsyjsvZAI2
 SPg2CEDuwcbzQn72lMUMEPK9gQTWmv2aTJzHiWWzgGifcgtjku9fYWbjShwfCTfx5S69
 3J/y7Wd66JsswV44HVnpCY/mRc+Wxzfk1s9pawrzyhynwzWVjexUXgEBfMA3TH2FV6N+
 kSUBRn6C5lFAt6wzGe3Ri0tLgL4v7n9/FSQ7Gb02Xt4ZD/eAr1xZyGiX4kMkZpvFjTGe
 rJV5jSFNwzIK+uqecdNOlwp3YOEXYCpgJ4fXck4LfKwugf5Hep4eYyaeh9xL/5AkB8yk
 pbUg==
X-Gm-Message-State: ANhLgQ2XeKhY8Rsgv1H9rzk8X/QwvF872327zAoMokv+Eo8kFvSZ1SE2
 KVGbNYx6BcfnA9AlH+Iqrqc=
X-Google-Smtp-Source: ADFU+vusQ0bIDosF3d8XW0u+epiuBZKDMJ1VEy7spDyO83bgoMIk+zuc0Riukv54RfoXOjcDlCHGkw==
X-Received: by 2002:a05:6808:8cd:: with SMTP id
 k13mr17210009oij.34.1584960194658; 
 Mon, 23 Mar 2020 03:43:14 -0700 (PDT)
Received: from ewr1-t1.small.x86-01 ([2604:1380:0:7b00::1])
 by smtp.gmail.com with ESMTPSA id 1sm1288804otd.31.2020.03.23.03.43.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Mar 2020 03:43:13 -0700 (PDT)
Date: Mon, 23 Mar 2020 10:43:11 +0000
From: Lev Aronsky <aronsky@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Add support for IDSR exits to userspace
Message-ID: <20200323104311.GA1948@ewr1-t1.small.x86-01>
References: <20200322093650.50621-1-aronsky@gmail.com>
 <61ae80130b47dc23d00d5010eccee0b2@kernel.org>
 <20200322142010.GA3337@ewr1-t1.small.x86-01>
 <d19c6aad8de7bfa182b7872ebeec57b5@kernel.org>
 <20200323082217.GA1509@ewr1-t1.small.x86-01>
 <d2c184326523ffe5b2e700b25b07b6a8@kernel.org>
 <20200323094127.GA1013@ewr1-t1.small.x86-01>
 <194c542d3d7941661f3042e6336f94d8@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <194c542d3d7941661f3042e6336f94d8@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailman-Approved-At: Mon, 23 Mar 2020 07:08:17 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Mar 23, 2020 at 10:26:18AM +0000, Marc Zyngier wrote:
> On 2020-03-23 09:41, Lev Aronsky wrote:
> > On Mon, Mar 23, 2020 at 09:07:12AM +0000, Marc Zyngier wrote:
> > > On 2020-03-23 08:22, Lev Aronsky wrote:

[...]

> > > 
> > > I'm pretty sure this wouldn't work with HW virtualization. I suspect
> > > this would UNDEF directly on the CPU, leading to an exception being
> > > taken
> > > at EL1 without intervention of the hypervisor. Which makes sense as
> > > you'd
> > > be executing an instruction that the CPU really doesn't implement.
> > 
> > Yes, that seems to be what's happening. We'll have to think of a
> > different mechanism for trapping access from user-mode straight to the
> > hypervisor - or, alternatively, move our custom code into the kernel. I
> > know it's a bit off-topic, but thank you for your advice!
> 
> One possibility would be trap accesses to a special page (magic device?),
> but that requires cooperation from the OS kernel as well. There is hardly
> anything else that would guarantee a trap directly from EL0 to EL2 (EL1
> can always get in the way).

These are the times I miss the simplicity of CPUID and VMCALL/VMMCALL on
x86... A special page might work - we are already doing some minor
patches in the kernel, adding a single EL0-accessible page might be
the way to go. Thanks.

> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
