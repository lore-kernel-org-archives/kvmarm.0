From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Fri, 16 Sep 2016 11:20:50 +0100
Message-ID: <57DBC782.7080305@arm.com>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1474007187-18673-1-git-send-email-agraf@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

On 16/09/16 07:26, Alexander Graf wrote:
> Some systems out there (well, one type in particular - the Raspberry Pi series)
> do have virtualization capabilities in the core, but no ARM GIC interrupt
> controller.
> 
> To run on these systems, the cleanest route is to just handle all
> interrupt delivery in user space and only deal with IRQ pins in the core
> side in KVM.
> 
> This works pretty well already, but breaks when the guest starts to use
> architected timers, as these are handled straight inside kernel space today.
> 
> This patch set allows user space to receive vtimer events as well as mask
> them, so that we can handle all vtimer related interrupt injection from user
> space, enabling us to use architected timer with user space gic emulation.

I have already voiced my concerns in the past, including face to face,
and I'm going to repeat it: I not keen at all on adding a new userspace
interface that is going to bitrot extremely quickly.

Let's face it, this new ABI will have a single user, with a limited
shelf life. I understand that the RPi is a popular product, but it looks
fairly obvious that this kind of sub-standard HW will eventually
disappear. We'll then be left with a userspace ABI that will break at
every single release, given that nobody in the RPi community actually
uses a mainline kernel.

And breaking this ABI will introduce userspace exploitable bugs, like
the one you've already shown. If anything, I would have loved to
completely kill the whole userspace GIC, because nobody cares. Yes, I
understand it is fun to have KVM running on the RPi. But the maintenance
costs far outweigh the fun aspect already.

You could still run KVM with an external emulated timer (not the arch
timer). No need for a new ABI for that.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
