Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2CAC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 12:26:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2BE8964FE2
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 12:26:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BE8964FE2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E2E54B684;
	Thu, 11 Mar 2021 07:26:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i1vX0igrFj5a; Thu, 11 Mar 2021 07:26:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6195F4B656;
	Thu, 11 Mar 2021 07:26:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E58F84B656
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 07:26:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Y8DgPceCPy1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 07:26:50 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D94A74B615
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 07:26:49 -0500 (EST)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dx7SB0fTgz17Jh9;
 Thu, 11 Mar 2021 20:24:58 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 20:26:38 +0800
Subject: Re: [PATCH v3 1/4] KVM: arm64: GICv4.1: Add function to get VLPI state
To: Marc Zyngier <maz@kernel.org>
References: <20210127121337.1092-1-lushenming@huawei.com>
 <20210127121337.1092-2-lushenming@huawei.com> <87wnuef4oj.wl-maz@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <fc7dc4ec-e223-91ae-536f-1aa52c8a5739@huawei.com>
Date: Thu, 11 Mar 2021 20:26:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <87wnuef4oj.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2021/3/11 16:57, Marc Zyngier wrote:
> On Wed, 27 Jan 2021 12:13:34 +0000,
> Shenming Lu <lushenming@huawei.com> wrote:
>>
>> With GICv4.1 and the vPE unmapped, which indicates the invalidation
>> of any VPT caches associated with the vPE, we can get the VLPI state
>> by peeking at the VPT. So we add a function for this.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v4.c | 19 +++++++++++++++++++
>>  arch/arm64/kvm/vgic/vgic.h    |  1 +
>>  2 files changed, 20 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
>> index 66508b03094f..ac029ba3d337 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>> @@ -203,6 +203,25 @@ void vgic_v4_configure_vsgis(struct kvm *kvm)
>>  	kvm_arm_resume_guest(kvm);
>>  }
>>  
>> +/*
>> + * Must be called with GICv4.1 and the vPE unmapped, which
>> + * indicates the invalidation of any VPT caches associated
>> + * with the vPE, thus we can get the VLPI state by peeking
>> + * at the VPT.
>> + */
>> +void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val)
>> +{
>> +	struct its_vpe *vpe = &irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>> +	int mask = BIT(irq->intid % BITS_PER_BYTE);
>> +	void *va;
>> +	u8 *ptr;
>> +
>> +	va = page_address(vpe->vpt_page);
>> +	ptr = va + irq->intid / BITS_PER_BYTE;
>> +
>> +	*val = !!(*ptr & mask);
> 
> What guarantees that you can actually read anything valid? Yes, the
> VPT caches are clean. But that doesn't make them coherent with CPU
> caches.
> 
> You need some level of cache maintenance here.

Yeah, and you have come up with some codes for this in v2:

diff --git a/drivers/irqchip/irq-gic-v3-its.c
b/drivers/irqchip/irq-gic-v3-its.c
index 7db602434ac5..2dbef127ca15 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4552,6 +4552,10 @@ static void its_vpe_irq_domain_deactivate(struct
irq_domain *domain,

  		its_send_vmapp(its, vpe, false);
  	}
+
+	if (find_4_1_its() && !atomic_read(vpe->vmapp_count))
+		gic_flush_dcache_to_poc(page_address(vpe->vpt_page),
+					LPI_PENDBASE_SZ);
  }

  static const struct irq_domain_ops its_vpe_domain_ops = {

Could I add it to this series? :-)

Thanks,
Shenming

> 
> Thanks,
> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
