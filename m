From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Fri, 16 Sep 2016 14:25:01 +0200
Message-ID: <060ADA14-786E-400E-9B11-61C34B7081B5@suse.de>
References: <1474007187-18673-1-git-send-email-agraf@suse.de> <57DBC782.7080305@arm.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <57DBC782.7080305@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu


> On 16 Sep 2016, at 12:20, Marc Zyngier <marc.zyngier@arm.com> wrote:
> 
> Hi Alex,
> 
> On 16/09/16 07:26, Alexander Graf wrote:
>> Some systems out there (well, one type in particular - the Raspberry Pi series)
>> do have virtualization capabilities in the core, but no ARM GIC interrupt
>> controller.
>> 
>> To run on these systems, the cleanest route is to just handle all
>> interrupt delivery in user space and only deal with IRQ pins in the core
>> side in KVM.
>> 
>> This works pretty well already, but breaks when the guest starts to use
>> architected timers, as these are handled straight inside kernel space today.
>> 
>> This patch set allows user space to receive vtimer events as well as mask
>> them, so that we can handle all vtimer related interrupt injection from user
>> space, enabling us to use architected timer with user space gic emulation.
> 
> I have already voiced my concerns in the past, including face to face,
> and I'm going to repeat it: I not keen at all on adding a new userspace
> interface that is going to bitrot extremely quickly.
> 
> Let's face it, this new ABI will have a single user, with a limited
> shelf life. I understand that the RPi is a popular product, but it looks
> fairly obvious that this kind of sub-standard HW will eventually
> disappear. We'll then be left with a userspace ABI that will break at

I’m not 100% convinced that this is the case. Emulating the GIC in user space can have other interesting use cases. For example, it might come in handy for nesting. It may be useful for migrating a gicv2 VM to a gicv3 host without gicv2 emulation as well.

> every single release, given that nobody in the RPi community actually
> uses a mainline kernel.

I actually verified all of this patch on 4.8-rc5 upstream, which is the only 64bit kernel you can find for the RPi. So I’d expect the situation to change with 64bit.

> And breaking this ABI will introduce userspace exploitable bugs, like
> the one you've already shown. If anything, I would have loved to
> completely kill the whole userspace GIC, because nobody cares. Yes, I
> understand it is fun to have KVM running on the RPi. But the maintenance
> costs far outweigh the fun aspect already.

Having CPU pins accessible is very useful for use cases of KVM that are beyond your traditional VM.

> You could still run KVM with an external emulated timer (not the arch
> timer). No need for a new ABI for that.

That’s what I thought too, but turns out that it’s not quite as simple as I hoped ;). Also, I much rather at least have a common notion of “arch timers are always available on arm64” than “kvm always uses the vgic”. The former has much more impact and much more reach.


Alex

