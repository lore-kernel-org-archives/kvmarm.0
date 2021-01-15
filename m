Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08980C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 13:32:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 742C422583
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 13:32:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 742C422583
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C45874B0CA;
	Fri, 15 Jan 2021 08:32:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w6kQvrNFpgDC; Fri, 15 Jan 2021 08:32:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9367C4B0E7;
	Fri, 15 Jan 2021 08:32:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CFFF4B0D5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 08:32:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vFOmleapTdSg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 08:32:05 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6461B4B0CA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 08:32:05 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610717525;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5HCnbtOR2YZKl8SmO/vRRs2V1v5j3Fbmpdg9s5YGS+w=;
 b=JD3fW7iDh3ucO2G6NBFfFufXHyqYqvrNwWnTmP1HdlDI+awtN3YrDEWHLafI2RCh6sF9c+
 d8iyBqDhc8XOS5DyD9lfg9xtlANxFTPUk4lJn3cJVsk7fsP0o+F9yiYMYbYAI50hb/Ra9O
 /u/gKNrTE//bQ76lZqhV6AEIUo5VEJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-2yivXdr3MJ-qMGIkSdE-3g-1; Fri, 15 Jan 2021 08:32:03 -0500
X-MC-Unique: 2yivXdr3MJ-qMGIkSdE-3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 593BA195D560;
 Fri, 15 Jan 2021 13:32:01 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 058D6608BA;
 Fri, 15 Jan 2021 13:31:58 +0000 (UTC)
Subject: Re: [PATCH 4/6] KVM: arm64: Refactor filtering of ID registers
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20210114105633.2558739-1-maz@kernel.org>
 <20210114105633.2558739-5-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <143efd5f-0641-8ed1-f055-df6e1d5216d8@redhat.com>
Date: Fri, 15 Jan 2021 14:31:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210114105633.2558739-5-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: kernel-team@android.com
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

Hi Marc,

On 1/14/21 11:56 AM, Marc Zyngier wrote:
> Our current ID register filtering is starting to be a mess of if()
> statements, and isn't going to get any saner.
> 
> Let's turn it into a switch(), which has a chance of being more
> readable, and introduce a FEATURE() macro that allows easy generation
> of feature masks.
> 
> No functionnal change intended.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>


> ---
>  arch/arm64/kvm/sys_regs.c | 51 +++++++++++++++++++++------------------
>  1 file changed, 28 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2bea0494b81d..dda16d60197b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -9,6 +9,7 @@
>   *          Christoffer Dall <c.dall@virtualopensystems.com>
>   */
>  
> +#include <linux/bitfield.h>
>  #include <linux/bsearch.h>
>  #include <linux/kvm_host.h>
>  #include <linux/mm.h>
> @@ -1016,6 +1017,8 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
> @@ -1024,36 +1027,38 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
>  	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
>  
> -	if (id == SYS_ID_AA64PFR0_EL1) {
> +	switch (id) {
> +	case SYS_ID_AA64PFR0_EL1:
>  		if (!vcpu_has_sve(vcpu))
> -			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> -		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
> -		val &= ~(0xfUL << ID_AA64PFR0_CSV2_SHIFT);
> -		val |= ((u64)vcpu->kvm->arch.pfr0_csv2 << ID_AA64PFR0_CSV2_SHIFT);
> -		val &= ~(0xfUL << ID_AA64PFR0_CSV3_SHIFT);
> -		val |= ((u64)vcpu->kvm->arch.pfr0_csv3 << ID_AA64PFR0_CSV3_SHIFT);
> -	} else if (id == SYS_ID_AA64PFR1_EL1) {
> -		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
> -	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> -		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
> -	} else if (id == SYS_ID_AA64DFR0_EL1) {
> -		u64 cap = 0;
> -
> +			val &= ~FEATURE(ID_AA64PFR0_SVE);
> +		val &= ~FEATURE(ID_AA64PFR0_AMU);
> +		val &= ~FEATURE(ID_AA64PFR0_CSV2);
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
> +		val &= ~FEATURE(ID_AA64PFR0_CSV3);
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
> +		break;
> +	case SYS_ID_AA64PFR1_EL1:
> +		val &= ~FEATURE(ID_AA64PFR1_MTE);
> +		break;
> +	case SYS_ID_AA64ISAR1_EL1:
> +		if (!vcpu_has_ptrauth(vcpu))
> +			val &= ~(FEATURE(ID_AA64ISAR1_APA) |
> +				 FEATURE(ID_AA64ISAR1_API) |
> +				 FEATURE(ID_AA64ISAR1_GPA) |
> +				 FEATURE(ID_AA64ISAR1_GPI));
> +		break;
> +	case SYS_ID_AA64DFR0_EL1:
>  		/* Limit guests to PMUv3 for ARMv8.1 */
> -		if (kvm_vcpu_has_pmu(vcpu))
> -			cap = ID_AA64DFR0_PMUVER_8_1;
> -
>  		val = cpuid_feature_cap_perfmon_field(val,
> -						ID_AA64DFR0_PMUVER_SHIFT,
> -						cap);
so you did the change evoked in my previous comment here.
> -	} else if (id == SYS_ID_DFR0_EL1) {
> +						      ID_AA64DFR0_PMUVER_SHIFT,
> +						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_1 : 0);
> +		break;
> +	case SYS_ID_DFR0_EL1:
>  		/* Limit guests to PMUv3 for ARMv8.1 */
>  		val = cpuid_feature_cap_perfmon_field(val,
>  						      ID_DFR0_PERFMON_SHIFT,
>  						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_1 : 0);
> +		break;
>  	}
>  
>  	return val;
> 
Looks indeed more readable

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
