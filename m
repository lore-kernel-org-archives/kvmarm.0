From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 1/3] arm64: kvm: support user space to detect RAS
 extension feature
Date: Tue, 4 Jul 2017 10:40:57 +0200
Message-ID: <20170704084057.GL4066@cbox>
References: <1498481143-23183-1-git-send-email-gengdongjiu@huawei.com>
 <20170703082126.GC4066@cbox>
 <dd9cf101-2ca9-f349-292e-f48204abe929@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dd9cf101-2ca9-f349-292e-f48204abe929@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: marc.zyngier@arm.com, james.morse@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, wuquanming@huawei.com, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, linux@armlinux.org.uk, will.deacon@arm.com, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu,

On Tue, Jul 04, 2017 at 03:04:54PM +0800, gengdongjiu wrote:
> Hi Christoffer,
> 
> On 2017/7/3 16:21, Christoffer Dall wrote:
> > On Mon, Jun 26, 2017 at 08:45:43PM +0800, Dongjiu Geng wrote:
> >> Handle userspace's detection for RAS extension, because sometimes
> >> the userspace needs to know the CPU's capacity
> > 
> > Why?  Can you please provide some more rationale.
> 
> userspace mainly want to know whether CPU has RAS extension capability to decide whether need to specify the syndrome value.
> if have, userspace specify the syndrome value. otherwise, not specify the value.
> 
> James ever suggest not want userspace to know the capability, and let KVM to judge the RAS extension capability.
> 
> but I consider it again, userspace know the RAS extension capability may be better, which can avoid KVM return error if
> CPU does not support RAS extension.

So first of all, while I appreciate your efforts to explain your
rationale here, I am also asking you to provide a more comprehensive
commit message for the next version of the patch.

> 
> could you give me some suggestion that whether let userspace to know the RAS extension capability?
> 

I haven't thought much about it, but there are unanswered questions to
me.  For example, does the type and capabilities of the guest in any way
affect whether or not this features should be available?  Are there any
concerns with respect to migration?

And then the point I raised below, which is that this KVM-specific ioctl
is returning a hardware property of the CPU (the one the ioctl happens
to run on - what happens on a heterogeneous system?), but not really
what KVM can and cannot do.  At the very least this should be based on
a more generic in-kernel functionality, which reports the capabilities
of a system to KVM, and KVM could then tell userspace if it has a
certain capability.

Hope this helps,
-Christoffer
