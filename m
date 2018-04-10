From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Compiling KVM/ARM as a separate kernel module.
Date: Tue, 10 Apr 2018 15:29:58 +0100
Message-ID: <1eabed24-f456-7f33-5aaa-d4644f3d0306@arm.com>
References: <CAE3G1Z_HJqkWeGEESTVg+5yarWND7KR-QLOL1sRu_ey-xGZdKw@mail.gmail.com>
 <3503fcbb-5e80-0421-ec46-8f765c195243@arm.com>
 <CAE3G1Z_xu+AzfGA9tA0KohsRhkbFdOtmKDMSGEmQVP9PPFXU2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 370EE49FD6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 10:21:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5DNhPZzH-U4R for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Apr 2018 10:21:19 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78B0C49EAD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 10:21:19 -0400 (EDT)
In-Reply-To: <CAE3G1Z_xu+AzfGA9tA0KohsRhkbFdOtmKDMSGEmQVP9PPFXU2A@mail.gmail.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mike Bazov <mike@perception-point.io>, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mike,

On 10/04/18 14:19, Mike Bazov wrote:
> Greetings,
> 
> I'm developing a product based on KVM/ARM, in which i need to modify
> the code that is responsible for entering into guest mode(i.e. EL1?)
> and i don't really want to recompile the kernel and flash it again as
> part of my development. I need to run on baremetal(on the board
> itself) when testing my code.

Recompiling the kernel is par for the course. You're probably changing
fundamental structures in the kernel, and KVM is not exactly independent
of the rest of the code base.

> Any plans for supporting this in the near future? or any other
> suggestions on a less painful development process?

There are no plans to support this in general. As James pointed out, KVM
needs to directly map the kernel at EL2, and requires to be part of the
kernel text (see how kern_hyp_va works with respect to the kernel mappings).

We *could* make it modular if we only had VHE, but we want a single
kernel image a lot more than we'll ever want a modular KVM. So built in
it will stay for the foreseeable future.

As for a more civilized development model, you have two alternatives:

- Use a proper boot loader that will load the kernel from a file system,
- Use kexec to boot from one kernel to another.

I use both every day.

Hope this helps,

	M.
-- 
Jazz is not dead. It just smells funny...
