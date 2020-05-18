Return-Path: <SRS0=o21O=7A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73171C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 08:42:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED3CC20787
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 08:42:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED3CC20787
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DB424B0F5;
	Mon, 18 May 2020 04:42:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 02JkA4ot+Pgx; Mon, 18 May 2020 04:42:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75AA94B104;
	Mon, 18 May 2020 04:42:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A139E4B0EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 04:42:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6eyICTRoyRiu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2020 04:42:49 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 964F24B0E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 04:42:49 -0400 (EDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11]
 helo=nanos.tec.linutronix.de)
 by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
 (Exim 4.80) (envelope-from <tglx@linutronix.de>)
 id 1jabM0-0005IY-I1; Mon, 18 May 2020 10:42:32 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
 id 026F6100606; Mon, 18 May 2020 10:42:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Anastassios Nanos <ananos@nubificus.co.uk>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
In-Reply-To: <cover.1589784221.git.ananos@nubificus.co.uk>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
Date: Mon, 18 May 2020 10:42:31 +0200
Message-ID: <87y2ppy6q0.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required, ALL_TRUSTED=-1,
 SHORTCIRCUIT=-0.0001
Cc: Wanpeng Li <wanpengli@tencent.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Will Deacon <will@kernel.org>,
 Jim Mattson <jmattson@google.com>
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

Anastassios Nanos <ananos@nubificus.co.uk> writes:
> To spawn KVM-enabled Virtual Machines on Linux systems, one has to use
> QEMU, or some other kind of VM monitor in user-space to host the vCPU
> threads, I/O threads and various other book-keeping/management mechanisms.
> This is perfectly fine for a large number of reasons and use cases: for
> instance, running generic VMs, running general purpose Operating systems
> that need some kind of emulation for legacy boot/hardware etc.
>
> What if we wanted to execute a small piece of code as a guest instance,
> without the involvement of user-space? The KVM functions are already doing
> what they should: VM and vCPU setup is already part of the kernel, the only
> missing piece is memory handling.
>
> With these series, (a) we expose to the Linux Kernel the bare minimum KVM
> API functions in order to spawn a guest instance without the intervention
> of user-space; and (b) we tweak the memory handling code of KVM-related
> functions to account for another kind of guest, spawned in kernel-space.
>
> PATCH #1 exposes the needed stub functions, whereas PATCH #2 introduces the
> changes in the KVM memory handling code for x86_64 and aarch64.
>
> An example of use is provided based on kvmtest.c
> [https://lwn.net/Articles/658512/] at

And this shows clearly how simple the user space is which is required to
do that. So why on earth would we want to have all of that in the
kernel?

Thanks,

        tglx
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
