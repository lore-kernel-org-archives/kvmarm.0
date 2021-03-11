Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C168C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 07:03:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A452764FC1
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 07:03:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A452764FC1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13BDF4B306;
	Thu, 11 Mar 2021 02:03:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Fbx4qxCwT8L; Thu, 11 Mar 2021 02:03:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B892C4B238;
	Thu, 11 Mar 2021 02:03:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6CF14B1C9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 02:03:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zYKah32cPBJ0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 02:03:48 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0FA34B1B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 02:03:47 -0500 (EST)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dx0Gt3QxszmVqH;
 Thu, 11 Mar 2021 15:01:26 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 15:03:32 +0800
Subject: Re: [PATCH v3 0/4] KVM: arm64: Add VLPI migration support on GICv4.1
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Will
 Deacon" <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
References: <20210127121337.1092-1-lushenming@huawei.com>
 <4c2fdcc3-4189-6515-3a68-7bdf26e31973@huawei.com>
Message-ID: <ba9511e7-a23f-f644-e310-f0bf1bce835a@huawei.com>
Date: Thu, 11 Mar 2021 15:03:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <4c2fdcc3-4189-6515-3a68-7bdf26e31973@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

Sorry to bother again, I am really hoping a response for this series. :-)

Thanks,
Shenming

On 2021/2/26 16:58, Shenming Lu wrote:
> Hi Marc,
> 
> Gentle ping. Does this series need any further modification? Wish you can pick it up. :-)
> 
> Thanks,
> Shenming
> 
> On 2021/1/27 20:13, Shenming Lu wrote:
>> Hi Marc, sorry for the late commit.
>>
>> In GICv4.1, migration has been supported except for (directly-injected)
>> VLPI. And GICv4.1 Spec explicitly gives a way to get the VLPI's pending
>> state (which was crucially missing in GICv4.0). So we make VLPI migration
>> capable on GICv4.1 in this patch set.
>>
>> In order to support VLPI migration, we need to save and restore all
>> required configuration information and pending states of VLPIs. But
>> in fact, the configuration information of VLPIs has already been saved
>> (or will be reallocated on the dst host...) in vgic(kvm) migration.
>> So we only have to migrate the pending states of VLPIs specially.
>>
>> Below is the related workflow in migration.
>>
>> On the save path:
>> 	In migration completion:
>> 		pause all vCPUs
>> 				|
>> 		call each VM state change handler:
>> 			pause other devices (just keep from sending interrupts, and
>> 			such as VFIO migration protocol has already realized it [1])
>> 					|
>> 			flush ITS tables into guest RAM
>> 					|
>> 			flush RDIST pending tables (also flush VLPI state here)
>> 				|
>> 		...
>> On the resume path:
>> 	load each device's state:
>> 		restore ITS tables (include pending tables) from guest RAM
>> 				|
>> 		for other (PCI) devices (paused), if configured to have VLPIs,
>> 		establish the forwarding paths of their VLPIs (and transfer
>> 		the pending states from kvm's vgic to VPT here)
>>
>> We have tested this series in VFIO migration, and found some related
>> issues in QEMU [2].
>>
>> Links:
>> [1] vfio: UAPI for migration interface for device state:
>>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a8a24f3f6e38103b77cf399c38eb54e1219d00d6
>> [2] vfio: Some fixes and optimizations for VFIO migration:
>>     https://patchwork.ozlabs.org/cover/1413263/
>>
>> History:
>>
>> v2 -> v3
>>  - Add the vgic initialized check to ensure that the allocation and enabling
>>    of the doorbells have already been done before unmapping the vPEs.
>>  - Check all get_vlpi_state related conditions in save_pending_tables in one place.
>>  - Nit fixes.
>>
>> v1 -> v2:
>>  - Get the VLPI state from the KVM side.
>>  - Nit fixes.
>>
>> Thanks,
>> Shenming
>>
>>
>> Shenming Lu (3):
>>   KVM: arm64: GICv4.1: Add function to get VLPI state
>>   KVM: arm64: GICv4.1: Try to save hw pending state in
>>     save_pending_tables
>>   KVM: arm64: GICv4.1: Give a chance to save VLPI's pending state
>>
>> Zenghui Yu (1):
>>   KVM: arm64: GICv4.1: Restore VLPI's pending state to physical side
>>
>>  .../virt/kvm/devices/arm-vgic-its.rst         |  2 +-
>>  arch/arm64/kvm/vgic/vgic-its.c                |  6 +-
>>  arch/arm64/kvm/vgic/vgic-v3.c                 | 61 +++++++++++++++++--
>>  arch/arm64/kvm/vgic/vgic-v4.c                 | 33 ++++++++++
>>  arch/arm64/kvm/vgic/vgic.h                    |  1 +
>>  5 files changed, 93 insertions(+), 10 deletions(-)
>>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
