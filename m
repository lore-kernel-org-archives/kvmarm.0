From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 54/55] KVM: arm/arm64: Adjust virtual offset considering
 nesting
Date: Wed, 22 Feb 2017 20:28:38 +0100
Message-ID: <20170222192838.GY26976@cbox>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-55-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E96340C44
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 14:27:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fw4m1YeU3W9w for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Feb 2017 14:27:54 -0500 (EST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C02940C2F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 14:27:54 -0500 (EST)
Received: by mail-wm0-f43.google.com with SMTP id v186so150123696wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 11:28:53 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1483943091-1364-55-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, shihwei@cs.columbia.edu, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, andre.przywara@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jintack,

On Mon, Jan 09, 2017 at 01:24:50AM -0500, Jintack Lim wrote:
> The guest hypervisor sets cntvoff_el2 for its VM (i.e. nested VM).  Note
> that physical/virtual counter value in the guest hypervisor's point of
> view is already offsetted by the virtual offset set by the host
> hypervisor.  Therefore, the correct offset we need to write to the
> cntvoff_el2 is the sum of offset the host hypervisor initially has for
> the VM and virtual offset the guest hypervisor sets for the nested VM.

This appears to be the only timer patch in the series.  Should we not
also expose the EL2 timer to the VM and emulate that in software?

Thanks,
-Christoffer
