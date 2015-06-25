From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: should KVM or userspace be the one which decides
 what MIPIDR/affinity values to assign to vcpus?
Date: Thu, 25 Jun 2015 14:41:13 +0200
Message-ID: <20150625124113.GF28244@cbox>
References: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
	<5576C559.2000902@arm.com>
	<CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>
	<20150625080014.GC28244@cbox>
	<CAFEAcA_cDT7r-LrX+4vYD5DSK6wTYbDTqoDm2B9gaS3ftJTqJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA_cDT7r-LrX+4vYD5DSK6wTYbDTqoDm2B9gaS3ftJTqJg@mail.gmail.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shlomo Pongratz <shlomo.pongratz@huawei.com>, Shlomo Pongratz <shlomopongratz@gmail.com>, Pavel Fedin <p.fedin@samsung.com>, QEMU Developers <qemu-devel@nongnu.org>, Shannon Zhao <shannon.zhao@linaro.org>, Ashok Kumar <ashoks@broadcom.com>, Igor Mammedov <imammedo@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 25, 2015 at 10:06:20AM +0100, Peter Maydell wrote:
> On 25 June 2015 at 09:00, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > Of course, KVM can deny an unsupported configuration, but I am wondering
> > if we really think anybody will care about the 'model such specific
> > hardware' aspect with KVM, or if we should only consider the 'I want a
> > VM with x VCPUs' scenario, in which case the second option below seems
> > simpler to me.
> 
> I agree it's not very likely anybody cares about the specific cluster
> topology. However if we don't want to support arbitrary topologies
> then QEMU is going to end up in the business of editing the user
> supplied device tree blob to make its cpu definitions match up with
> whatever the kernel provides, which could be pretty tedious.
> 
I see, then you can't easily contruct a machine and a DT in one go
before talking to KVM.

Oh well, I don't feel strongly one way or the other.

-Christoffer
