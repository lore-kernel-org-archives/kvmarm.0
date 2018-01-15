From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by
 categorization
Date: Mon, 15 Jan 2018 09:33:35 +0100
Message-ID: <20180115083335.GC21403@cbox>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
 <5A0B1334.7060500@arm.com>
 <4af78739-99da-4056-4db1-f80bfe11081a@huawei.com>
 <5A283F26.3020507@arm.com>
 <4b37e86d-eee3-c51e-eceb-5d0c7ad12886@huawei.com>
 <506cd212-3d16-ba2a-518f-34982bc162fc@huawei.com>
 <5A58F8E3.5060002@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5A58F8E3.5060002@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: gengdongjiu <gengdongjiu@huawei.com>, marc.zyngier@arm.com, linux@armlinux.org.uk, bp@alien8.de, rjw@rjwysocki.net, pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com, wuquanming@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 12, 2018 at 06:05:23PM +0000, James Morse wrote:
> On 15/12/17 03:30, gengdongjiu wrote:
> > On 2017/12/7 14:37, gengdongjiu wrote:

[...]

> 
> (I recall someone saying migration is needed for any new KVM/cpu features, but I
> can't find the thread)
> 

I don't know of any hard set-in-stone rule for this, but I have
certainly argued that since migration is a popular technique in data
centers and often a key motivation behind using virtual machines as it
provides both load-balancing and high availability, we should think
about migration support for all features and state.  Further, experience
has shown that retroactively trying to support migration can result in
really complex interfaces for saving/restoring state (see the ITS
ordering requirements in
Documentation/virtual/kvm/devices/arm-vgic-its.txt as an example) so
thinking about this problem when introducing functionality is a good
idea.

Of course, if there are really good arguments for having some state that
simply cannot be migrated, then that's fine, and we should just make
sure that userspace (e.g. QEMU) and higher level components in the
stack (libvirt, openstack, etc.) can detect this state being used, and
ideally enable/disable it, so that it can predict that a particular VM
cannot be migrated off a particular host, or between a particular set of
two hosts.  As an example, migration is typically prohibited when using
VFIO direct device assignment, but userspace etc. are already aware of
this.

As a final note, if we add support for some architectural feature, which
may be present on some particular hardware and/or implementation, if the
KVM support for said feature is automatically enabled (and not
selectively from userspace), I would push back quite strongly on
something that doesn't support migration, because it would effectively
prevent migration of VMs on ARM.

Thanks,
-Christoffer
