From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 07/10] KVM: arm/arm64: vgic-its: New helper functions to free the caches
Date: Wed, 25 Oct 2017 11:31:36 +0100
Message-ID: <86d15becxj.fsf@arm.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
        <1508767709-15256-8-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1508767709-15256-8-git-send-email-eric.auger@redhat.com> (Eric
        Auger's message of "Mon, 23 Oct 2017 16:08:26 +0200")
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com, wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 23 2017 at  4:08:26 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> From: wanghaibin <wanghaibin.wang@huawei.com>
>
> We create two new functions that free the device and
> collection lists. They are currently called by vgic_its_destroy()
> and other callers will be added in subsequent patches.
>
> We also remove the check on its->device_list.next.
> Lists are initialized in vgic_create_its() and the device
> is added to the device list only if this latter succeeds.
>
> vgic_its_destroy is the device destroy ops. This latter is called
> by kvm_destroy_devices() which loops on all created devices. So
> at this point the list is initialized.
>
> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
