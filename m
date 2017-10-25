From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 04/10] KVM: arm/arm64: vgic-its: Check GITS_BASER Valid bit before saving tables
Date: Wed, 25 Oct 2017 10:47:38 +0100
Message-ID: <86tvyneeyt.fsf@arm.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
        <1508767709-15256-5-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1508767709-15256-5-git-send-email-eric.auger@redhat.com> (Eric
        Auger's message of "Mon, 23 Oct 2017 16:08:23 +0200")
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com, wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 23 2017 at  4:08:23 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> At the moment we don't properly check the GITS_BASER<n>.Valid
> bit before saving the collection and device tables.
>
> On vgic_its_save_collection_table() we use the GITS_BASER gpa
> field whereas the Valid bit should be used.
>
> On vgic_its_save_device_tables() there is no check. This can
> cause various bugs, among which a subsequent fault when accessing
> the table in guest memory.
>
> Let's systematically check the Valid bit before doing anything.
>
> We also uniformize the code between save and restore.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
