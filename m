Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C93C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:28:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 23ACF61054
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:28:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 23ACF61054
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A36BD4B0EC;
	Wed,  1 Sep 2021 17:28:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 950fz5JBu7xa; Wed,  1 Sep 2021 17:28:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5E084B11C;
	Wed,  1 Sep 2021 17:28:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 397464B0FC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:28:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a83qdYl9m99V for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 17:28:33 -0400 (EDT)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com
 [209.85.166.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21C4F4B0EC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:28:33 -0400 (EDT)
Received: by mail-il1-f172.google.com with SMTP id s16so722274ilo.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 14:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=3+fQjcpnHNJkqOcBZgMNk/OB4ownjP+XnDHYqaehO9M=;
 b=B7N1+QDUbmAfLhhac7/CGzREYbLmaoWc2UO3Uwmy+f8N/Tf61TlXo0vB1T3IdPludk
 wssgaP7caejDQvt9MIh2u18lv5UelfS+beMnCiaRISTiUV/mDFka9UC/Z+oEXM3LmahT
 Kl3e8+8LI7SDihRD8M47czPSScJ3e7pDYvJFqmuFsaZy8vherdtKtNnBydHONNsAr93U
 H5PtAQieR0RlLOSVqno4mYeT2S/Ew9TdOTO6pXS/MIdqt2tSaBtsO/L7TQ5r8QeItLZa
 iN2aw+Ib2M8/mMMqv3UG6CyVgvLC3eFZrLDf7dNPxP/Uk5lkpr9HMp9w2dWC5MSErVgX
 p71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=3+fQjcpnHNJkqOcBZgMNk/OB4ownjP+XnDHYqaehO9M=;
 b=IdgM4zjkOLgGDDKSqp4ZXBeIkK5MmBgDqSKBrRRDWuXTRSlAnefkNgIMGu/XZ4SU/2
 vMocDl9d0fv56na3H4mVB1WBuoLJbUNCnJlR7E8CtwWSxnoRvGBMqPzKakMTOM5f4mm6
 GYcISQITsK4Cjt81QRihHHkqJetk1WcxquASEC/586ZUjkn9rIJIDlTJU4Iwq79hTu46
 fv5xqaCGzyaq//8mRq/Snxt/+zWy6w3uf0fMxJ/27zwHHzDMf9eWEfjSnOgbNLeYIeOr
 x/CyIX/GENEVq+/56+TLYr43NzmuKC6IC3xr+15YVjUavon2y9DhQv4+Xm3DkxIGwqFy
 NiUw==
X-Gm-Message-State: AOAM531yD8tC2NYo6HcEVgLB3CXZR1z9MCLtGQQ/q0fo8ooQuYWM4Rgs
 jHQKYiPNNzGL1oTgb7l1FmOcOA==
X-Google-Smtp-Source: ABdhPJwcjOd7yA5KEboXCvNkf3GIALGCyQJLoG6CXjyw8BUk2rI03Z+9XHa7gQw/Jp1e1Rt2HSPjcA==
X-Received: by 2002:a92:8747:: with SMTP id d7mr1084202ilm.173.1630531712121; 
 Wed, 01 Sep 2021 14:28:32 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id 7sm425362ilx.16.2021.09.01.14.28.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Sep 2021 14:28:31 -0700 (PDT)
Date: Wed, 1 Sep 2021 21:28:28 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 02/12] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
Message-ID: <YS/wfBTnCJWn05Kn@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-3-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-3-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Sep 01, 2021 at 09:14:02PM +0000, Raghavendra Rao Ananta wrote:
> For register names that are unsupported by the assembler or the ones
> without architectural names, add the macros write_sysreg_s and
> read_sysreg_s to support them.
> 
> The functionality is derived from kvm-unit-tests and kernel's
> arch/arm64/include/asm/sysreg.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Would it be possible to just include <asm/sysreg.h>? See
tools/arch/arm64/include/asm/sysreg.h

> ---
>  .../selftests/kvm/include/aarch64/processor.h | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 3cbaf5c1e26b..082cc97ad8d3 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -118,6 +118,67 @@ void vm_install_exception_handler(struct kvm_vm *vm,
>  void vm_install_sync_handler(struct kvm_vm *vm,
>  		int vector, int ec, handler_fn handler);
>  
> +/*
> + * ARMv8 ARM reserves the following encoding for system registers:
> + * (Ref: ARMv8 ARM, Section: "System instruction class encoding overview",
> + *  C5.2, version:ARM DDI 0487A.f)
> + *	[20-19] : Op0
> + *	[18-16] : Op1
> + *	[15-12] : CRn
> + *	[11-8]  : CRm
> + *	[7-5]   : Op2
> + */
> +#define Op0_shift	19
> +#define Op0_mask	0x3
> +#define Op1_shift	16
> +#define Op1_mask	0x7
> +#define CRn_shift	12
> +#define CRn_mask	0xf
> +#define CRm_shift	8
> +#define CRm_mask	0xf
> +#define Op2_shift	5
> +#define Op2_mask	0x7
> +
> +/*
> + * When accessed from guests, the ARM64_SYS_REG() doesn't work since it
> + * generates a different encoding for additional KVM processing, and is
> + * only suitable for userspace to access the register via ioctls.
> + * Hence, define a 'pure' sys_reg() here to generate the encodings as per spec.
> + */
> +#define sys_reg(op0, op1, crn, crm, op2) \
> +	(((op0) << Op0_shift) | ((op1) << Op1_shift) | \
> +	 ((crn) << CRn_shift) | ((crm) << CRm_shift) | \
> +	 ((op2) << Op2_shift))
> +
> +asm(
> +"	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
> +"	.equ	.L__reg_num_x\\num, \\num\n"
> +"	.endr\n"
> +"	.equ	.L__reg_num_xzr, 31\n"
> +"\n"
> +"	.macro	mrs_s, rt, sreg\n"
> +"	.inst	0xd5200000|(\\sreg)|(.L__reg_num_\\rt)\n"
> +"	.endm\n"
> +"\n"
> +"	.macro	msr_s, sreg, rt\n"
> +"	.inst	0xd5000000|(\\sreg)|(.L__reg_num_\\rt)\n"
> +"	.endm\n"
> +);
> +
> +/*
> + * read_sysreg_s() and write_sysreg_s()'s 'reg' has to be encoded via sys_reg()
> + */
> +#define read_sysreg_s(reg) ({						\
> +	u64 __val;							\
> +	asm volatile("mrs_s %0, "__stringify(reg) : "=r" (__val));	\
> +	__val;								\
> +})
> +
> +#define write_sysreg_s(reg, val) do {					\
> +	u64 __val = (u64)val;						\
> +	asm volatile("msr_s "__stringify(reg) ", %x0" : : "rZ" (__val));\
> +} while (0)
> +
>  #define write_sysreg(reg, val)						  \
>  ({									  \
>  	u64 __val = (u64)(val);						  \
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
