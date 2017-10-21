From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 01/11] KVM: arm/arm64: vgic-its: fix return value for
 device table restore
Date: Sat, 21 Oct 2017 17:42:03 +0200
Message-ID: <20171021154203.GH12618@cbox>
References: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
 <1508224209-15366-2-git-send-email-eric.auger@redhat.com>
 <20171017214030.GA8326@lvm>
 <39442c3f-5c71-ccd5-a976-db3c2830e2c9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <39442c3f-5c71-ccd5-a976-db3c2830e2c9@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com, wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Oct 21, 2017 at 04:40:00PM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 17/10/2017 23:40, Christoffer Dall wrote:
> > On Tue, Oct 17, 2017 at 09:09:59AM +0200, Eric Auger wrote:
> >> AT the moment if ITT only contains invalid entries,
> >> vgic_its_restore_itt returns 1 and this is considered as
> >> an an error in vgic_its_restore_dte.
> >>
> >> Also in case the device table only contains invalid entries,
> >> the table restore fails and this is not correct.
> >>
> >> This patch fully revisits the errror handling while fixing those
> >> 2 bugs.
> >>
> >> - entry_fn_t now takes a valid output paraleter
> > 
> >                                         parameter
> > 
> >> - scan_its_table() now returns <= 0 values and output 2 booleans,
> >                                                  outputs
> >>   valid and last.
> >> - vgic_its_restore_itt() now returns <= 0 values.
> >> - vgic_its_restore_device_tables() also returns <= 0 values.
> >>
> >> With that patch we are able to properly handle the case where
> >> all data are invalid but we still are able to detect the case
> >> where a next entry was referenced by some valid entry and
> >> never found.
> >>
> >> Fixes: 57a9a117154c93 (KVM: arm64: vgic-its: Device table save/restore)
> >> Fixes: eff484e0298da5 (KVM: arm64: vgic-its: ITT save and restore)
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> Reported-by: wanghaibin <wanghaibin.wang@huawei.com>
> >>
> >> ---
> >>
> >> need to CC stable
> >>
> >> v3 -> v4:
> >> - set *valid at beginning of handle_l1_dte
> >>
> >> v2 -> v3:
> >> - add comments
> >> - added valid parameter
> >> - vgic_its_restore_itt don't return +1 anymore
> >> - reword the commit message
> >>
> >> v1 -> v2:
> >> - if (ret > 0) ret = 0
> >> ---

[...]

> 
> Given the number of changes this rework will produce I guess this patch
> wouldn't be candidate for cc'ed stable. Then shouldn't we consider to
> first apply the fix proposed by Wanghaibin (cc'ed stable) and then apply
> the rework in a second and subsequent patch?
> 

Yes, probably, let's keep the fix small and obviously correct and get
that in for v4.14 ASAP.

Then we can do rework for v4.15 or later, to clean things up.

Thanks,
-Christoffer
