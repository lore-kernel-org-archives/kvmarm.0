Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF40C43334
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 07:21:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF35A4C04F;
	Wed,  6 Jul 2022 03:21:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hBFEEm50he8N; Wed,  6 Jul 2022 03:21:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B92EE4C05B;
	Wed,  6 Jul 2022 03:21:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB18F4B5AE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 10:30:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6PHJmxJvCi23 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jul 2022 10:29:59 -0400 (EDT)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
 [209.85.166.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF6674B5AD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 10:29:59 -0400 (EDT)
Received: by mail-io1-f48.google.com with SMTP id d3so2403675ioi.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Jul 2022 07:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version;
 bh=9cF5IqYxYj2InYMRmfggjddnYppc9EzlqbpJtswCFOc=;
 b=HODcUQLIo0DHm2SWxvgselcLa4dqArEO92qCD/gdLMJVimUVw0vou6BSTzhmjWwMYF
 1E+buAnE4rtwp0FAJX85qZ+3o2LqSI6tChHU9pxyTtzYtmhBpSp7owpv82dDVMtUeoYZ
 sta4ytKhLwiQHRKRr4g0NyOUcuF6AebROFB/JemgbaMZ7IxhFV0eoXHhscnThyXgxm7u
 eWXLEO4OiZIpuOIFJxbs1xuVlE15lZ1DdPobHLI+vafxbu0XsqKQjOZLH7Nl5FIyDwD6
 DvjVXFKvIJpLg/tYtsORHUsApO76DV7qn3AJuU1/7gtrOOQLACHhxYvOhUOXCKWBZtJn
 FOAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version;
 bh=9cF5IqYxYj2InYMRmfggjddnYppc9EzlqbpJtswCFOc=;
 b=a1aZW5axzMTS2L/+LfWRyO7Aa6DL8OqFevYXPERWz4dLjxpgVcdUkX9sRKEDWEMEI0
 CqesPvZVhV0wepdcBbAfjORSFDcMLxdskCBFkuY65OGRFJgeIP497ntGTAzRmV8LLCji
 TmFg3amLGUikAQ9TT+kCGs0WlVL2a3KmKVYlZnUcmhQvcaOiGeJM5GQwTbhCF5FvWvMC
 XGucwYa8XXs7UOj2D5u9yZhQjNMj/TF8J3a4coBVAIpNqVva3NMkYei4KZoS7VVbA4se
 t3O7z6w3hlw3tu7W0SdG1mE1wiDu6vnIs6H1KoKNZ0Fj1eL1uV2vscCHVimyx9rcelSp
 0STA==
X-Gm-Message-State: AJIora9Wp+s1GcNcjHQNbU+c0F+GmhD9rdZQYEkJakaNtvYqXRvEBQzh
 WcgohvzlLcvZP+YUUpixZVs=
X-Google-Smtp-Source: AGRyM1sRv34EaaWYc7DQ/cybSSP4tt+pHpLB0OquCLm3mDR/BmnZSy7nB06i+Pl5+EtSLGZ2Xxh7qA==
X-Received: by 2002:a05:6638:d86:b0:33c:cb7f:4ecc with SMTP id
 l6-20020a0566380d8600b0033ccb7f4eccmr8907108jaj.28.1656685799208; 
 Fri, 01 Jul 2022 07:29:59 -0700 (PDT)
Received: from ArchLinux ([240e:390:a20:ece0:3ad5:47ff:feb5:73b2])
 by smtp.gmail.com with ESMTPSA id
 b15-20020a056602218f00b00669b2ffad32sm10288981iob.54.2022.07.01.07.29.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Jul 2022 07:29:58 -0700 (PDT)
References: <20220630161220.53449-1-schspa@gmail.com>
 <87mtdu15ok.wl-maz@kernel.org> <m2bkua148a.fsf@gmail.com>
 <a5ca4db3db9ef101258cab94d6b7e045@kernel.org> <m2sfnlvwup.fsf@gmail.com>
 <87letd0wqm.wl-maz@kernel.org>
User-agent: mu4e 1.7.5; emacs 28.1
From: Schspa Shi <schspa@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix 64 bit mmio handle
Date: Fri, 01 Jul 2022 22:22:51 +0800
In-reply-to: <87letd0wqm.wl-maz@kernel.org>
Message-ID: <m2h740zz1i.fsf@gmail.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 06 Jul 2022 03:21:23 -0400
Cc: will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


Marc Zyngier <maz@kernel.org> writes:

>> 
>> I have running some static code analysis software upon Kernel 
>> code.
>> Seeing there is possible overflow.
>> 
>> maks << 1U << ((len * 8) -1);
>> 
>> The AI don't know, len is only the value of 1, 2, 4, and make 
>> this
>> a warnings
>> 
>> I tring to analysis this, but didn't realize the real scenario 
>> of
>> sign extension, and finally sent this problematic patch.
>> 
>> I do see some uninitialized memory reads (the values are not 
>> used
>> in the end, just as temporary space for API execution),
>> do we need to fix these?
>
> You need to be more descriptive here. What uninitialised reads? 
> In
> general, pointing at the code and providing a full description 
> of what
> you think is incorrect would really help...
>
> 	M.
One example is
int vgic_v3_has_attr_regs(struct kvm_device *dev, struct 
kvm_device_attr *attr)
{
	...
    case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
		u64 reg, id;

		id = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
		return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, id, &reg);
	}

}

The funcion vgic_v3_has_cpu_sysregs_attr will read reg's value to
params without initialization. There should have no problems,
because the register value never used.

-- 
BRs
Schspa Shi
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
