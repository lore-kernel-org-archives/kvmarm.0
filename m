Return-Path: <SRS0=/ONs=GQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF633C433E6
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 14:23:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B501233FB
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 14:23:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B501233FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E23E4B1C7;
	Wed, 13 Jan 2021 09:23:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FoSlo9Eu6Yc3; Wed, 13 Jan 2021 09:23:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A65E4B1B4;
	Wed, 13 Jan 2021 09:23:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60A604B169
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 09:23:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H4W5NhsYpoCd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2021 09:23:10 -0500 (EST)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
 [209.85.128.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 493624B0CF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 09:23:10 -0500 (EST)
Received: by mail-wm1-f41.google.com with SMTP id 3so1770156wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 06:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ilU2a0/z2icSlVjikMlVFb2BH/BMW95h/+2IlgK09tA=;
 b=mb6J8KGfPGz18jwtpgubLMkATb8/Rkvwe7SvvMpjP59phRqNVcLtJhjhzs6OXZjb6o
 EtLISbBA9zn1CuHoxX08fV9CbHbHyVIYuzR1+qWBbquftXlJkGGcsZoc9ooIxnKxZb6O
 AtcwIwSsZ/OL/jjPQLdmBbO869kuB+hFoVPEeqYTn8AM6A7Z70iojhRX6bB6rT/iqk6m
 KRXaZMpxZO8S7ddTasPh+LF9H+C31ikwzVAuPMBXFZxltyQCk+j41+VrZ73h6K9v3jVK
 XjJjKhlVvoPBD2z05uCwrAIveAcWR1miyJcm2jFf/chrmST7NPzdHnXr9lJ+YtF9UhQI
 o5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ilU2a0/z2icSlVjikMlVFb2BH/BMW95h/+2IlgK09tA=;
 b=eAVUaHFKFsoQCzuSSATDYmAaw1IvUOI0MIJwLbT1ucjg8GJixxTBQapb2qypbjlaSy
 mno+OeC6ItV77I9/EExN/TAaKOJwB87/jW/fNlB++KXXHJ1WOf8NPhZKZ8mKHHWwD8YS
 FO0yaV+ZciehyVgFtKvjfSmwGiA0qdOlCewI0XtxATr1rD/cwTKaqw4CGhMlVe9oAjLu
 m+caiXS1j35lU3t7t6/vW+AgTTCReNRRnPpbh5ym5amHPZ7j3k9ax091l3JLKPVO5ngv
 LrOJmKLTimu8VmpNdTH+dTumG8tBsggpIu2gZCZJ6IJRfY7KkCurMLQ7piL0SZ0PkIEk
 9LqA==
X-Gm-Message-State: AOAM530oxuVmCK84vfKVwOcnS5/wlpywZNlI5sXAeqFrrkd/qLbaY7hC
 IuRYrVMvBD8Q+/qzxcJLIETSXQ==
X-Google-Smtp-Source: ABdhPJwYEfPsoLZ1uDpkgIvVI6ossxrBaWbG9yG2QlOmRPbJjc1rM9tB77wRTJPoRpB2XSFVf/bkkA==
X-Received: by 2002:a1c:bc41:: with SMTP id m62mr2484423wmf.46.1610547789081; 
 Wed, 13 Jan 2021 06:23:09 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id a62sm2936823wmf.7.2021.01.13.06.23.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 13 Jan 2021 06:23:08 -0800 (PST)
Date: Wed, 13 Jan 2021 14:23:03 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH v2 13/26] KVM: arm64: Enable access to sanitized CPU
 features at EL2
Message-ID: <X/8CR5eXGGccFjaL@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-14-qperret@google.com>
 <d55643ea391f73a2297f499f3219ba8a@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d55643ea391f73a2297f499f3219ba8a@kernel.org>
Cc: devicetree@vger.kernel.org, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Hey Marc,

On Wednesday 13 Jan 2021 at 11:33:13 (+0000), Marc Zyngier wrote:
> > +#undef KVM_HYP_CPU_FTR_REG
> > +#define KVM_HYP_CPU_FTR_REG(id, name) \
> > +	{ .sys_id = id, .dst = (struct arm64_ftr_reg *)&kvm_nvhe_sym(name) },
> > +static const struct __ftr_reg_copy_entry {
> > +	u32			sys_id;
> > +	struct arm64_ftr_reg	*dst;
> 
> Why do we need the whole data structure? Can't we just live with sys_val?

I don't have a use-case for anything else than sys_val, so yes I think I
should be able to simplify. I'll try that for v3.

> 
> > +} hyp_ftr_regs[] = {
> > +	#include <asm/kvm_cpufeature.h>
> > +};
> 
> Can't this be made __initdata?

Good point, that would be nice indeed. Can I use that from outside an
__init function? If not, I'll need to rework the code a bit more, but
that should be simple enough either way.

> > +
> > +static int copy_cpu_ftr_regs(void)
> > +{
> > +	int i, ret;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(hyp_ftr_regs); i++) {
> > +		ret = copy_ftr_reg(hyp_ftr_regs[i].sys_id, hyp_ftr_regs[i].dst);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /**
> >   * Inits Hyp-mode on all online CPUs
> >   */
> > @@ -1705,6 +1729,13 @@ static int init_hyp_mode(void)
> >  	int cpu;
> >  	int err = 0;
> > 
> > +	/*
> > +	 * Copy the required CPU feature register in their EL2 counterpart
> > +	 */
> > +	err = copy_cpu_ftr_regs();
> > +	if (err)
> > +		return err;
> > +
> 
> Just to keep things together, please move any sysreg manipulation into
> sys_regs.c, most probably into kvm_sys_reg_table_init().

Will do.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
