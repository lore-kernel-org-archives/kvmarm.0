From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/2] ARM: hyp-stub: improve ABI
Date: Mon, 9 Jan 2017 14:28:06 +0000
Message-ID: <20170109142806.GB7593@e104818-lin.cambridge.arm.com>
References: <20161213113044.GC19985@leverpostej>
 <E1cH74w-0003ke-Qp@rmk-PC.armlinux.org.uk>
 <72f93940-cf87-fd91-90f2-760b7ff050fb@arm.com>
 <20170109125431.GY14217@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C2740421
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 09:26:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C+c0r9rVqTe7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 09:26:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 487F440419
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 09:26:28 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170109125431.GY14217@n2100.armlinux.org.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 12:54:31PM +0000, Russell King - ARM Linux wrote:
> So, we need KVM's stub to be (a) better documented so this stuff is
> obvious, and (b) updated so that kdump stands a chance of working even
> if the KVM stub is still in place at the point the host kernel panics.
> 
> Another reason why documentation is important here is that we need to
> make it clear to alternative hypervisors that the host kernel may issue
> a HVC call at any moment due to a crash with particular arguments, and
> that the host kernel expects a certain behaviour in that case, and that
> the hypervisor does not crash.

The only hypervisor (apart from the hyp-stub) built and deployed
together with the kernel is KVM. On ARM, to be able to enable KVM, the
host kernel must be booted in Hyp mode and install the stub before
dropping to SVC.

With Xen (or a different Type-1 hypervisor), the "host" kernel (dom0 for
Xen, a.k.a. control domain) is booted in SVC mode directly, so hyp-stub
is not installed and is_hyp_mode_available() returns false.

> For example, how will Xen behave - is introducing these changes going
> to cause a regression with Xen?  Does anyone even know the answer to
> that?  From what I can see, it seems we'll end up calling Xen's
> hypervisor with a random r12 value (which it uses as a reason code)
> but without the 0xea1 immediate constant in the HVC instruction.
> Beyond that, I've no idea.

Any HVC calls from the control domain kernel must comply with the ABI
offered by the corresponding hypervisor and has nothing to do with the
hyp-stub ABI. Routing hyp-stub ABI HVC calls to an unaware hypervisor
like Xen as part of kdump/kexec is a kernel bug and would probably
result in the kernel being killed. I haven't tried but kexec in a host
kernel under Xen should work just like kexec in any other guest kernel.

-- 
Catalin
