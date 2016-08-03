From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: ITS: move ITS registration into first VCPU run
Date: Wed, 3 Aug 2016 19:13:52 +0200
Message-ID: <20160803171352.GZ32244@cbox>
References: <20160803145745.7556-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6B9E49B32
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 13:05:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wk8BXMUQOUXF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Aug 2016 13:05:22 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D96EF49B2C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 13:05:21 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id o80so346024526wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Aug 2016 10:12:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160803145745.7556-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 03, 2016 at 03:57:45PM +0100, Andre Przywara wrote:
> Currently we register ITS devices upon userland issuing the CTRL_INIT
> ioctl to mark initialization of the ITS as done.
> This deviates from the initialization sequence of the existing GIC
> devices and does not play well with the way QEMU handles things.
> To be more in line with what we are used to, register the ITS(es) just
> before the first VCPU is about to run, so in the map_resources() call.
> This involves iterating through the list of KVM devices and handle each
> ITS that we find.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Hi,
> 
> this is based upon next-20160728 plus Christoffer's kvm_device locking

Since my fix was horribly broken, I suggest you just base this on next
and let it be similarly broken to the vfio-device that we already have
in the kernel.

That way, we get the userspace ABI right and we fix KVM in general for -rc2.

Paolo/Radim, are you ok with this?

Thanks,
-Christoffer
