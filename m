From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Access CNTHCTL_EL2 bit fields correctly
Date: Tue, 29 Nov 2016 16:53:25 +0000
Message-ID: <ee2dacff-691c-7548-ff71-3a992f399333@arm.com>
References: <1480351570-11648-1-git-send-email-jintack@cs.columbia.edu>
 <d04fd17e-9157-07fe-4daa-9dbab149b5e6@arm.com>
 <799d03f5-a929-9547-1ae7-94026b76f116@arm.com>
 <CAHyh4xhXoFWsbnNNePthWp2-ZAOtCuUVmLn-JKRe4sc=nqrYNw@mail.gmail.com>
 <0a475329-6f50-42ae-3244-f0767c56ce09@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 054A740430
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 11:52:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id leallL174-pU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2016 11:52:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFE3340420
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 11:52:41 -0500 (EST)
In-Reply-To: <0a475329-6f50-42ae-3244-f0767c56ce09@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Jintack Lim <jintack@cs.columbia.edu>
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux@armlinux.org.uk, andre.przywara@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 29/11/16 09:36, Marc Zyngier wrote:
> On 29/11/16 03:28, Jintack Lim wrote:
>> On Mon, Nov 28, 2016 at 1:39 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> On 28/11/16 17:43, Marc Zyngier wrote:
>> This looks much cleaner than my patch.
>> While we are at it, is it worth to consider that we just need to set
>> those bits once for VHE case, not for every world switch as an
>> optimization?
>
> Ah! That's a much better idea indeed! And we could stop messing with
> cntvoff_el2 as well, as it doesn't need to be restored to zero on exit.
> Could you try and respin something along those lines?
>

fyi, we have a static_key based cpus_have_const_cap() for Constant cap
checking (like this case) available in linux-next. May be you could make use
of that instead of alternatives.


Cheers
Suzuki
