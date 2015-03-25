From: Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [Xen-devel] ARM: KVM/XEN: how should we support virt-what?
Date: Wed, 25 Mar 2015 11:08:56 +0000
Message-ID: <1427281736.10784.63.camel@citrix.com>
References: <20150325094440.GB3163@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150325094440.GB3163@hawk.usersys.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, stefano.stabellini@eu.citrix.com, tim@xen.org, wei@redhat.com, kvm@vger.kernel.org, rjones@redhat.com, xen-devel@lists.xen.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 2015-03-25 at 10:44 +0100, Andrew Jones wrote:
> Hello ARM virt maintainers,
> 
> I'd like to start a discussion about supporting virt-what[1]. virt-what
> allows userspace to determine if the system it's running on is running
> in a guest, and of what type (KVM, Xen, etc.). Despite it being a best
> effort tool, see the Caveat emptor in [1], it has become quite a useful
> tool, and is showing up in different places, such as OpenStack. If you
> look at the code[2], specifically [3], then you'll see how it works on
> x86, which is to use the dedicated hypervisor cpuid leaves. I'm
> wondering what equivalent we have, or can develop, for arm.
> Here are some thoughts;
> 0) there's already something we can use, and I just need to be told
>    about it.
> 1) be as similar as possible to x86 by dedicating some currently
>    undefined sysreg bits. This would take buy-in from lots of parties,
>    so is not likely the way to go.
> 2) create a specific DT node that will get exposed through sysfs, or
>    somewhere.
> 3) same as (2), but just use the nodes currently in mach-virt's DT
>    as the indication we're a guest. This would just be a heuristic,
>    i.e. "have virtio mmio" && psci.method == hvc, or something,
>    and we'd still need a way to know if we're kvm vs. xen vs. ??.

FWIW Xen has a specific node,
https://git.kernel.org/cgit/linux/kernel/git/devicetree/devicetree-rebasing.git/tree/Bindings/arm/xen.txt

Doesn't help you with ACPI systems though. IIRC there will be a Xen
table of some sort.

Ian.

