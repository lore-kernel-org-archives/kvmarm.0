Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2B0CCA473
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 11:44:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 412424BF50;
	Wed,  6 Jul 2022 07:44:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YEqtdgyiyCyW; Wed,  6 Jul 2022 07:44:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F41934BA82;
	Wed,  6 Jul 2022 07:44:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EDCF4BDDA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 07:32:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yVSTsqiyCcC7 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 07:32:53 -0400 (EDT)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFC3C4BB12
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 07:32:53 -0400 (EDT)
Received: by mail-pj1-f44.google.com with SMTP id
 89-20020a17090a09e200b001ef7638e536so11818598pjo.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Jul 2022 04:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version;
 bh=djsBeJZau7lSlteYS5ExIsD/YzkbqOh5CqDcrItHqWo=;
 b=q2UJC5/Cnpc58uqNx0FCca8xGpc66+6rq2Xm8KGHbhU2M7vYmIRYGWLWgUdl5xYfVV
 fe10NqBZ5OARcmDRhDM5BORiXY7rYLbgJ8fF5EPIXa+n/Q+Xk6IweCvRJFlrsheIL6MM
 HtrPv11Up7KEulqIw7br/sztHfIiI/eN9oA27f3enPkpoizepbsKphwrxLu1dRR8F/QX
 k6DdPrexx7eo/gdavDTn7XZBzYMHheDXu5Ej/2JnWLFKyujh4uU5F0ATGn//VMnpEmHQ
 KoieRZjlTw3xngmhn36FxsZDfDu3xrOkWgBpL1YM11ZVHvUbHTDymrBKmvciUbEa6Mjs
 Bg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version;
 bh=djsBeJZau7lSlteYS5ExIsD/YzkbqOh5CqDcrItHqWo=;
 b=wvtV6rFFQtBhIxq5kVenOVWgsVNNeuct+4GuK4joN0FzgFfiCqA7BdaZ84+EH/peCV
 yajNI1Z+T6BlNWzBMYmfAnltD6bUteUf44xm1g9qey35peCUq1/Vz4TGbtBK0TbjC+bP
 IkJiF/qrquo2iH9LMJc3s4LhXg342s4Q0mVPmmsm5wv5/QC+/CwYFwVBlu+MgqaHEbv1
 ynCAGXskaElPLgzh4Pfm9qOlpMmw1saDI7vcVwaMEb/rV8HzXUlDTdXbSpv4BItPrBpt
 SaUM/ap1LKMXQtS6vqxQHcKXnVnIMKAyd/rk6jCOsNwW76Gnuk3ObmUAQ/CgtYOWjhRs
 JhLA==
X-Gm-Message-State: AJIora++xsygCVkyP7RiF14O2ZClQsk9rNachFGLqmcVZTdjA+MHibg6
 KkKHsSOASVV5j4OiIfj9GMc=
X-Google-Smtp-Source: AGRyM1tJvjoUduIGT5ixeVfZRRRPGpZ0t27INoMLuNKZT9DE21cIpoQrKzOjWiSXuzhcKSrrFCR0XA==
X-Received: by 2002:a17:90a:4e05:b0:1ec:8de4:1dd5 with SMTP id
 n5-20020a17090a4e0500b001ec8de41dd5mr47976415pjh.242.1657107172707; 
 Wed, 06 Jul 2022 04:32:52 -0700 (PDT)
Received: from MBP ([39.170.101.209]) by smtp.gmail.com with ESMTPSA id
 b21-20020a170902b61500b0016b81679c2asm19849405pls.214.2022.07.06.04.32.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Jul 2022 04:32:52 -0700 (PDT)
References: <20220630161220.53449-1-schspa@gmail.com>
 <87mtdu15ok.wl-maz@kernel.org> <m2bkua148a.fsf@gmail.com>
 <a5ca4db3db9ef101258cab94d6b7e045@kernel.org> <m2sfnlvwup.fsf@gmail.com>
 <87letd0wqm.wl-maz@kernel.org> <m2h740zz1i.fsf@gmail.com>
 <87edyyn2a5.wl-maz@kernel.org>
User-agent: mu4e 1.6.10; emacs 27.2
From: Schspa Shi <schspa@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix 64 bit mmio handle
Date: Wed, 06 Jul 2022 19:29:58 +0800
In-reply-to: <87edyyn2a5.wl-maz@kernel.org>
Message-ID: <m25ykawk7f.fsf@gmail.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 06 Jul 2022 07:44:11 -0400
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

> On Fri, 01 Jul 2022 15:22:51 +0100,
> Schspa Shi <schspa@gmail.com> wrote:
>> 
>> 
>> Marc Zyngier <maz@kernel.org> writes:
>> 
>> >> 
>> >> I have running some static code analysis software upon 
>> >> Kernel code.
>> >> Seeing there is possible overflow.
>> >> 
>> >> maks << 1U << ((len * 8) -1);
>> >> 
>> >> The AI don't know, len is only the value of 1, 2, 4, and 
>> >> make this
>> >> a warnings
>> >> 
>> >> I tring to analysis this, but didn't realize the real 
>> >> scenario of
>> >> sign extension, and finally sent this problematic patch.
>> >> 
>> >> I do see some uninitialized memory reads (the values are not 
>> >> used
>> >> in the end, just as temporary space for API execution),
>> >> do we need to fix these?
>> > 
>> > You need to be more descriptive here. What uninitialised 
>> > reads? In
>> > general, pointing at the code and providing a full 
>> > description of
>> > what
>> > you think is incorrect would really help...
>> > 
>> > 	M.
>> One example is
>> int vgic_v3_has_attr_regs(struct kvm_device *dev, struct
>> kvm_device_attr *attr)
>> {
>> 	...
>>    case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
>> 		u64 reg, id;
>> 
>> 		id = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
>> 		return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, id, &reg);
>> 	}
>> 
>> }
>> 
>> The funcion vgic_v3_has_cpu_sysregs_attr will read reg's value 
>> to
>> params without initialization. There should have no problems,
>> because the register value never used.
>
> Thanks for pointing this out.
>
> I spent some time looking at this, and this is only the tip of 
> the
> iceberg. The whole userspace interaction with the GIC sysregs is 
> ugly
> (at best), and needs some love.
>
> I've written a small series[1] cleaning things up, which needs 
> testing
> (I've just checked that it was compiling correctly). I'd 
> appreciate
> you running your tool on it.
>

I have run static code analysis software upon this branch, and the
warnings have gone.

> 	M.
>
> [1] 
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/sysreg-cleanup-5.20


-- 
BRs
Schspa Shi
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
