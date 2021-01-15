Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BFEC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 14:15:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 70585224F9
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 14:15:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70585224F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12A414B19C;
	Fri, 15 Jan 2021 09:15:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tY7-h2MVNBrT; Fri, 15 Jan 2021 09:15:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9F4B4B1AF;
	Fri, 15 Jan 2021 09:15:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2D1B4B19C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:15:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tDUmQL67M3gp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 09:15:24 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3DA24B15B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:15:23 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D4E1022473;
 Fri, 15 Jan 2021 14:15:22 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l0Psm-007mPC-RH; Fri, 15 Jan 2021 14:15:20 +0000
MIME-Version: 1.0
Date: Fri, 15 Jan 2021 14:15:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Workaround firmware wrongly
 advertising GICv2-on-v3 compatibility
In-Reply-To: <CAMj1kXHEMpypq54Vxr+JgL9b_zoj_y2azK3mgAhXhnXO6Bhygw@mail.gmail.com>
References: <20210115140323.2682634-1-maz@kernel.org>
 <20210115140323.2682634-3-maz@kernel.org>
 <CAMj1kXHEMpypq54Vxr+JgL9b_zoj_y2azK3mgAhXhnXO6Bhygw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <67c2f61a5dd33731cf52b6e26095ed51@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ardb@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, shameerali.kolothum.thodi@huawei.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-15 14:08, Ard Biesheuvel wrote:
> On Fri, 15 Jan 2021 at 15:03, Marc Zyngier <maz@kernel.org> wrote:

[...]

>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c 
>> b/arch/arm64/kvm/vgic/vgic-v3.c
>> index 8e7bf3151057..67b27b47312b 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>> @@ -584,8 +584,10 @@ early_param("kvm-arm.vgic_v4_enable", 
>> early_gicv4_enable);
>>  int vgic_v3_probe(const struct gic_kvm_info *info)
>>  {
>>         u64 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config);
>> +       bool has_v2;
>>         int ret;
>> 
>> +       has_v2 = ich_vtr_el2 >> 63;
>>         ich_vtr_el2 = (u32)ich_vtr_el2;
>> 
>>         /*
>> @@ -605,13 +607,15 @@ int vgic_v3_probe(const struct gic_kvm_info 
>> *info)
>>                          gicv4_enable ? "en" : "dis");
>>         }
>> 
>> +       kvm_vgic_global_state.vcpu_base = 0;
>> +
>>         if (!info->vcpu.start) {
>>                 kvm_info("GICv3: no GICV resource entry\n");
>> -               kvm_vgic_global_state.vcpu_base = 0;
>> +       } else if (!has_v2) {
>> +               pr_warn("CPU interface incapable of MMIO access\n");
> 
> Could we include FW_BUG here to stress that this is a firmware problem?

Absolutely! That's what it now looks like:

[    2.648452] kvm [1]: IPA Size Limit: 40 bits
[    2.649259] [Firmware Bug]: CPU interface incapable of MMIO access
[    2.649620] kvm [1]: disabling GICv2 emulation
[    2.650227] kvm [1]: GIC system register CPU interface enabled
[    2.652004] kvm [1]: vgic interrupt IRQ9
[    2.655623] kvm [1]: VHE mode initialized successfully

Updated version pushed out.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
