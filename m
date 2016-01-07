From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PULL] KVM/ARM updates for 4.5
Date: Thu, 7 Jan 2016 11:07:41 +0100
Message-ID: <568E38ED.2080904@redhat.com>
References: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4440F49723
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 05:04:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8qMyc+-9ixuQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2016 05:04:09 -0500 (EST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DC594970A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 05:04:09 -0500 (EST)
Received: by mail-wm0-f43.google.com with SMTP id u188so91692095wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Jan 2016 02:07:52 -0800 (PST)
In-Reply-To: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Jisheng Zhang <jszhang@marvell.com>, kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, David Binderman <dcb314@hotmail.com>, Fengguang Wu <fengguang.wu@intel.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 24/12/2015 12:12, Marc Zyngier wrote:
> Hi Paolo,
> 
> THis is the first pull request for the 4.5 merge window. Not much in
> terms of features, but a rewrite of our 64bit world switch, making it
> a lot nicer, maintainable, and much more likely to cope with things
> like VHE. Also support 16bit VMIDs for systems that need to run that
> many VMs concurrently.
> 
> I was really hoping that the PMU code would make it this time around,
> but it got slightly delayed, and the holiday season didn't help. If
> we're lucky enough (read: if all known issues have been addressed), I
> may send you another pull request early in the new year.
> 
> In the mean time, please pull!

Pulled, thanks.

Paolo
