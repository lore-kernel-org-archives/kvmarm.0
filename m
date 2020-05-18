Return-Path: <SRS0=o21O=7A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3072EC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 07:50:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5204207ED
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 07:50:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnqTXJ6X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5204207ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 580174B167;
	Mon, 18 May 2020 03:50:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hlk+A-RO1eWB; Mon, 18 May 2020 03:50:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213AB4B18D;
	Mon, 18 May 2020 03:50:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FC0E4B16F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 03:50:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TTnjxEkLH6Oj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2020 03:50:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C9524B167
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 03:50:46 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E5D6C20787;
 Mon, 18 May 2020 07:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1589788245;
 bh=lqHej4TeaH/h0N1U2FkK0BZnCpJw7cuBwYsE1+Z+y/U=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=LnqTXJ6Xz9beUnIik6bXpG/2hpaTRmYbocdh91cTI0NjQ6MO3VllE9fT0qW/g6uLS
 xtGr1V+cqVk3tN/5qbWYSM6UOuOiSZ0xliYoUeLXOGX4VG3eSOVWBveH5ouY1UhxBF
 6AgF/Wen5TNtdYHkLq6rn987ul1SmmgIrE4jCP0I=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jaaXr-00DBDP-48; Mon, 18 May 2020 08:50:43 +0100
MIME-Version: 1.0
Date: Mon, 18 May 2020 08:50:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: Anastassios Nanos <ananos@nubificus.co.uk>
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
In-Reply-To: <cover.1589784221.git.ananos@nubificus.co.uk>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <c1124c27293769f8e4836fb8fdbd5adf@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ananos@nubificus.co.uk, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com,
 sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
 jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Thomas Gleixner <tglx@linutronix.de>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On 2020-05-18 07:58, Anastassios Nanos wrote:
> To spawn KVM-enabled Virtual Machines on Linux systems, one has to use
> QEMU, or some other kind of VM monitor in user-space to host the vCPU
> threads, I/O threads and various other book-keeping/management 
> mechanisms.
> This is perfectly fine for a large number of reasons and use cases: for
> instance, running generic VMs, running general purpose Operating 
> systems
> that need some kind of emulation for legacy boot/hardware etc.
> 
> What if we wanted to execute a small piece of code as a guest instance,
> without the involvement of user-space? The KVM functions are already 
> doing
> what they should: VM and vCPU setup is already part of the kernel, the 
> only
> missing piece is memory handling.
> 
> With these series, (a) we expose to the Linux Kernel the bare minimum 
> KVM
> API functions in order to spawn a guest instance without the 
> intervention
> of user-space; and (b) we tweak the memory handling code of KVM-related
> functions to account for another kind of guest, spawned in 
> kernel-space.
> 
> PATCH #1 exposes the needed stub functions, whereas PATCH #2 introduces 
> the
> changes in the KVM memory handling code for x86_64 and aarch64.
> 
> An example of use is provided based on kvmtest.c
> [https://lwn.net/Articles/658512/] at
> https://github.com/cloudkernels/kvmmtest

You don't explain *why* we would want this. What is the overhead of 
having
a userspace if your guest doesn't need any userspace handling? The 
kvmtest
example indeed shows that the KVM userspace API is usable  without any 
form
of emulation, hence has almost no cost.

Without a clear description of the advantages of your solution, as well
as a full featured in-tree use case, I find it pretty hard to support 
this.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
