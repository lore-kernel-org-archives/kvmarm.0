From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] arm64: KVM: remove fpsimd save/restore from the world
 switch
Date: Fri, 10 Apr 2015 11:08:38 +0100
Message-ID: <5527A126.6080202@arm.com>
References: <1428598439-5217-1-git-send-email-marc.zyngier@arm.com>
 <55278CAD.70302@redhat.com> <552793CF.8050904@arm.com>
 <CAFEAcA8J-kDHjkg9uFbHHAEu=zSSv+CB1Vmy1JBh==SmeiWL1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F744C061
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 06:01:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OWMIgxdxpCjV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 06:01:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A8EE4C05C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 06:01:01 -0400 (EDT)
In-Reply-To: <CAFEAcA8J-kDHjkg9uFbHHAEu=zSSv+CB1Vmy1JBh==SmeiWL1Q@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/04/15 11:01, Peter Maydell wrote:
> On 10 April 2015 at 10:11, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> I did some experimentations on arm64 a long while ago (see the
>> kvm-arm64/lazy-fp branch in my tree), and it wasn't that great,
>> apparently because aarch64 userspace tends to be much more FP happy than
>> aarch32, but I'm not completely sure about it.
> 
> Was that with the buggy version of the toolchain that had
> incorrect costs and so was much more inclined to spill
> integer values into the FPU than it should have been?
> It might be worth retesting with a freshly compiled
> userspace some day...

It definitely was with a very old toolchain and an even older userspace.
I'll respin the branch when I get some thime.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
