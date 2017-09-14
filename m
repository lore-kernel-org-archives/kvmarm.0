From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH 2/3] kvm: arm/arm64: vgic-vits: free its resource
 when vm reboot/reset
Date: Wed, 13 Sep 2017 22:34:06 -0700
Message-ID: <20170914053406.GN1631@lvm>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
 <1504703110-10744-3-git-send-email-wanghaibin.wang@huawei.com>
 <20170913193445.GJ1631@lvm>
 <cfab5e9e-c60b-9f41-988a-e3b31d8edcd3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADB234104E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 01:31:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7KFsNCgX2prT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Sep 2017 01:31:27 -0400 (EDT)
Received: from mail-pg0-f48.google.com (mail-pg0-f48.google.com [74.125.83.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7AA6040FAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 01:31:27 -0400 (EDT)
Received: by mail-pg0-f48.google.com with SMTP id d8so4511000pgt.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 22:34:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cfab5e9e-c60b-9f41-988a-e3b31d8edcd3@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 13, 2017 at 11:13:55PM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 13/09/2017 21:34, Christoffer Dall wrote:
> > Hi Wanghaibin,
> > 
> > On Wed, Sep 06, 2017 at 09:05:09PM +0800, wanghaibin wrote:
> >> This patch fix the migrate save tables failure.
> >>
> >> When the virtual machine is in booting and the devices haven't initialized,
> >> the all virtual dte/ite may be invalid. If migrate at this moment, the save
> >> tables interface traversal device list, and check the dte is valid or not.
> >> if not, it will return the -EINVAL.
> >>
> >> This patch try to free the its list resource when vm reboot or reset to avoid this.
> > 
> > I think the problem should be described the following way (feel free to
> > use this in a commit message).
> > 
> > When rebooting a VM, we currently don't have a way to reset the ITS.
> > This results in the booting a VM with a pre-programmed ITS with existing
> > cached state.  This can lead to all sorts of interesting problems.
> > 
> > One such problem is that if trying to migrate the VM after rebooting the
> > VM, we try to traverse the device tables in guest memory.  When using
> > indirect tables, and the guest has re-initialized the ITS device table
> > base register pointing to cleared memory, this results in trying to
> > access address 0 in the guest physical address space, which in turn
> > causes the ITS saving code to return an error to user space.
> > 
> > The correct fix is to introduce a reset function as a device attribute
> > for the ITS.
> ... or reset the list when the userspace writes GITS_BASERn with a valid
> bit set to 0.

But I can't tell if that in any way matches something mandated by the
architecture.  Would the ITS invalidate its caches because
BASERn is written with valid==0 ?

To me, it feels like the BASERn trick is trying to guess that we have
done a reset and we should probably do something, where what we really
want is the system (userspace) to tell us when to reset to a clean
state.


> 
> For GICv3 we don't have a specific IOCTL for reset. In QEMU there is a
> reset callback called whenever the guest is rebooted or reset and in the
> GICv3 callback we perform user space write access for all the relevant
> registers. I missed that when doing the ITS QEMU integration.

Oh, we let userspace drive reset of the redistributors via setting the
mmio registers currently.  I sort of think we should perhaps provide a
separate attribute for reset as well, but if what we have currently
works, why not.

> 
> Shall we use the same trick as for GICv3 or add another KVM device
> group/attribute?

I think we need a separate attribute, because I don't see that the
architecture provides a meaningful way to reset the internal ITS state
simply by writing some registers, so we would have to come up with
something specific for the user space mmio accessors anyway, and we
might as well expose a virtual reset pin to userspace.

Thanks,
-Christoffer
