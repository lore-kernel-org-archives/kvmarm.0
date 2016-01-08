From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Fri, 8 Jan 2016 16:20:28 +0100
Message-ID: <20160108152028.GD3458@hawk.localdomain>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
 <20160107201859.GI6199@hawk.localdomain>
 <568F248F.7020602@huawei.com>
 <20160108112213.GA3458@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38123497BD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2016 10:16:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id woTbjQD+jTJ5 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2016 10:16:47 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09ADD49786
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2016 10:16:46 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20160108112213.GA3458@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, shannon.zhao@linaro.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 08, 2016 at 12:22:13PM +0100, Andrew Jones wrote:
> When we want more than 256 vcpus we'll need a new kvm-irq-line ioctl,
> but, as for the arm devices, we could avoid the problem completely by
> extending the SET/GET_DEVICE_ATTR ioctl to also be a vcpu ioctl.

Replying to myself on this comment. The arm-gic device is fine as is, as
it really is a vm device. However I'm convincing myself more and more
(and with the help of Radim Krcmar being my sounding board) that using
the device api for the pmu is wrong (at least as a per-vm device). The
pmu is a per-vcpu device.

I think we should consider adding KVM_CREATE_DEVICE, KVM_SET/GET_DEVICE_ATTR
to the vcpu ioctl to allow per-vcpu devices. Then, instead of looping vcpus
in the kernel to init the pmu per vcpu on the call to KVM_CREATE_DEVICE,
we'd have the more natural looping in userspace. Also, the set-attr for the
irq would be part of that loop, and no longer need a vcpu-index parameter.

Thanks,
drew
