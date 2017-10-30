From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 9/9] KVM: arm/arm64: vgic-its: Implement KVM_DEV_ARM_ITS_CTRL_RESET
Date: Mon, 30 Oct 2017 03:22:59 +0000
Message-ID: <861sll720c.fsf@arm.com>
References: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
        <1509031391-4407-10-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509031391-4407-10-git-send-email-eric.auger@redhat.com> (Eric
        Auger's message of "Thu, 26 Oct 2017 17:23:11 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com, wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 26 2017 at  6:23:11 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> On reset we clear the valid bits of GITS_CBASER and GITS_BASER<n>.
> We also clear command queue registers and free the cache (device,
> collection, and lpi lists).
>
> As we need to take the same locks as save/restore functions, we
> create a vgic_its_ctrl() wrapper that handles KVM_DEV_ARM_VGIC_GRP_CTRL
> group functions.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
