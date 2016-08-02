From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v1] arm/arm64: vgic-new: Create dist and redist
 iodevs earlier
Date: Tue, 2 Aug 2016 16:04:21 +0200
Message-ID: <20160802140421.GK32244@cbox>
References: <1467731491-6458-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C47849B1A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2016 09:56:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sisfpd5lUK3K for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Aug 2016 09:55:56 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5F5F411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2016 09:55:56 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id f65so410624007wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Aug 2016 07:02:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1467731491-6458-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com
Cc: Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Vijaya,

On Tue, Jul 05, 2016 at 08:41:31PM +0530, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <vijayak@caviumnetworks.com>
> 
> The dist and redist regions are created and registered in
> vgic_register_dist_iodevs() and vgic_v3_init_redist_iodev()
> calls for distributor and redistributor respectively when
> vgic_v3_map_resources() is called. This mapping of resources
> is done when vcpu run ioctl is called.
> 
> Below is the call stack of the same.
> 
> [<ffff0000080b2e8c>] vgic_register_redist_iodevs+0x94/0x27c
> [<ffff0000080b0fd8>] vgic_v3_map_resources+0x138/0x188
> [<ffff0000080affa4>] kvm_vgic_map_resources+0xb0/0xb8
> [<ffff0000080a3888>] kvm_arch_vcpu_ioctl_run+0x4a8/0x550
> [<ffff00000809c218>] kvm_vcpu_ioctl+0x304/0x74c
> [<ffff000008232cac>] do_vfs_ioctl+0xc0/0x754
> [<ffff0000082333d0>] SyS_ioctl+0x90/0xa4
> [<ffff000008084af0>] el0_svc_naked+0x24/0x28
> 
> During live migration, the destination VM first restores the all the
> GIC registers(dist, rdist and cpuif registers) using ioctl's before
> resuming the VM.So no vcpu run ioctl is called untill complete
> GIC context is restored.
> 
> Hence, In case of live migration, when ioctls are called to write
> dist/rdist registers the ioctls fails as
> vcpu->kvm->arch.vgic.dist_iodev andkvm->arch.vgic.redist_iodevs
> are NULL.
> 

Is this for GICv3 only?  Can you give me a more specific pointer to the
place where this fails or a traceback?

Definitely the approach of registering things early doesn't work,
because it breaks all sorts of other things.

So the trick is to make sure userspace accesses can work without a
registers kvm iodev.  I will have a look at this, but some more conceret
info as requested above will be helpful.

Thanks,
-Christoffer
