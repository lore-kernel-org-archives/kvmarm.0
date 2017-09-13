From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH 1/3] kvm: arm/arm64: vgic-vits: separate
 vgic_its_free_list() function
Date: Wed, 13 Sep 2017 12:13:36 -0700
Message-ID: <20170913191336.GG1631@lvm>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
 <1504703110-10744-2-git-send-email-wanghaibin.wang@huawei.com>
 <59B79FDA.7090901@huawei.com>
 <325be1c0-48cf-444f-8ca2-263cd8ee3b4f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25E7D49C19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 15:11:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xHvsAkG89HUz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Sep 2017 15:11:01 -0400 (EDT)
Received: from mail-pf0-f174.google.com (mail-pf0-f174.google.com
 [209.85.192.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02EAA40D25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 15:11:01 -0400 (EDT)
Received: by mail-pf0-f174.google.com with SMTP id e199so1641695pfh.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 12:13:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <325be1c0-48cf-444f-8ca2-263cd8ee3b4f@redhat.com>
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

On Tue, Sep 12, 2017 at 12:08:27PM +0200, Auger Eric wrote:
> Hi Wanghaibin,
> =

> On 12/09/2017 10:50, wanghaibin wrote:
> > On 2017/9/6 21:05, wanghaibin wrote:
> > =

> >> We slightly refactor vgic_its_destroy, separate vgic_its_free_list()
> >> function for later patch invoke.
> >>
> >> The patch also take a functional change. If the its->device_list.next
> >> is NULL, we still should free the its.
> > =

> > =

> > Hi, Eric
> > =

> > Does this its->device_list.next is NULL can happened ?
> =

> I don't get why we have this check.
> =

> The kvm device is removed by kvm_destroy_devices which loops on all
> devices added to kvm->devices. kvm_ioctl_create_device only adds the
> device to kvm_devices once the lists have been initialized (in
> vgic_create_its). So it looks safe to me without the check.
> =

> Andr=E9, do we miss something?

Eric, I think I agree with you, and even if we need to check for
initialization, we should have a separate flag instead of piggy-backing
on the list_head.

Thanks,
-Christoffer
