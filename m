Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA87FC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 16:28:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FC214B21A;
	Mon,  7 Mar 2022 11:28:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bJ2PCNKhQ+W5; Mon,  7 Mar 2022 11:28:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FF804B1CB;
	Mon,  7 Mar 2022 11:28:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAA394B1CB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 11:28:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0bl+34S2ndTE for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 11:28:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C41624B19D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 11:28:22 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63DE0153B;
 Mon,  7 Mar 2022 08:28:22 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50A483FA45;
 Mon,  7 Mar 2022 08:28:19 -0800 (PST)
Date: Mon, 7 Mar 2022 16:28:44 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 43/64] KVM: arm64: nv: arch_timer: Support hyp timer
 emulation
Message-ID: <YiYyqvwp3xkieF6S@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-44-maz@kernel.org>
 <YiYcLIhdo5fQFbSA@monolith.localdoman>
 <c084f234eff61b0ab8da5716879745e2@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c084f234eff61b0ab8da5716879745e2@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org
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

Hi,

On Mon, Mar 07, 2022 at 03:48:19PM +0000, Marc Zyngier wrote:
> On 2022-03-07 14:52, Alexandru Elisei wrote:
> > Hi,
> > 
> > I was under the impression that KVM's nested virtualization doesn't
> > support
> > AArch32 in the guest, why is the subject about hyp mode aarch32 timers?
> 
> Where did you see *ANY* mention of AArch32?

I saw an implicit mention of aarch32 when the commit message used the term
"hyp", which is the name of an aarch32 execution mode.

> 
> Or is that a very roundabout way to object to the 'hyp' name?

Bingo.

> If that's the case, just apply a mental 's/hyp/el2/' substitution.

I'm a bit confused about that. Is that something that anyone reading the patch
should apply mentally when reading the patch, or is it something that you plan
to change in the commit subject?

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
