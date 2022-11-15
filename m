Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B305C43219
	for <kvmarm@archiver.kernel.org>; Tue, 15 Nov 2022 20:16:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B426E4B890;
	Tue, 15 Nov 2022 15:16:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6ARDQMkGdTP3; Tue, 15 Nov 2022 15:16:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7865E4B8BA;
	Tue, 15 Nov 2022 15:16:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 817A14B8B8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 15:16:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RiawIdSxApWI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2022 15:16:09 -0500 (EST)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 498724B890
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 15:16:09 -0500 (EST)
Received: by mail-pl1-f180.google.com with SMTP id c2so14148678plz.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 12:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=T7LP3RGpmdXiMN5KPTn9/IO+rih2AglOTsvbEdRvS1Q=;
 b=CuhvpEh+MwcQ8DdyO2LHPKc75+Mh4Tt/SrTxun8SjsbCLbKA/uujVn75/hrSWRbq3P
 pp681Bo0ABWoVlpW4KZ12uslMC8XMyFowDj24K4rvmpM/9YujrW27P9Vv5MLxt+ZIfOV
 Jm6zqwFB/7ZHai0ByGJfyD247/5LpCxHhMpkaFu377RaNtmMs+gPLXFcf0G1yQbvs+Rs
 EYu+becUwCm5WaK54RGM6rYBIysavORuhi+fV9JxKIFpQITo1Jz1JNtjUgO7b5R2U1/e
 xEGMqJLbi5RxqShnMYvwl9BbYi//M2ZHV0GVHxnWgbMAYD9A/uq/G/wppECfL4cNv6ol
 hTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=T7LP3RGpmdXiMN5KPTn9/IO+rih2AglOTsvbEdRvS1Q=;
 b=3XyLmzI69rwfL5iGP4PYEIrVg6qDSO2YjAQmKoeo8UkGO9i63OeZHXv7QDIbTyAZ9h
 +pvDOFYlf61de9nSA8LzWX2RLyOQQ2Q9YigJt3kzNFt1XWwssbec2MxslmspGFELfPuG
 tmDJSs8Ljf+XUGS+mK/RiACJfdyDP+T7IZpGsUX9ge4NStBo+vNpXxEU3bAKemiF5jm7
 u8yEhmgMcAHAM7IK9OOVJUTRDJHVHEWZkNSi3xI0l6ik1+rnFRyZahP8ww2GZsfVswKC
 CgxdjuhQ8NY4eIHWTd08Nlxr/dMfQg8IOpjeK/Gz39LG1q6WBtLgyAMWJzCm/pWVQVGx
 QmiA==
X-Gm-Message-State: ANoB5pkMnOOAaE+VM18dkSHVh/IZRbZlqpKHZOy/dUxQ+zTpxEFz1vjZ
 dZs8FM2K+vz/RxoeQOIKTbZJGw==
X-Google-Smtp-Source: AA0mqf58/qb3pHX8jXG9rQwsI0kWr5CgUXW3YysHviPdV0VVEN3OAELl4gQs2//98Y2csv6jhLKLCw==
X-Received: by 2002:a17:902:e8d5:b0:181:6c64:6dd3 with SMTP id
 v21-20020a170902e8d500b001816c646dd3mr5671131plg.123.1668543368117; 
 Tue, 15 Nov 2022 12:16:08 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 d62-20020a623641000000b0056c08c87196sm9173979pfa.48.2022.11.15.12.16.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Nov 2022 12:16:07 -0800 (PST)
Date: Tue, 15 Nov 2022 20:16:04 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
Message-ID: <Y3PzhANShVlTXVg1@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-39-seanjc@google.com>
 <88e920944de70e7d69a98f74005b49c59b5aaa3b.camel@intel.com>
 <b198fe971cecd301f0c7c66028cfd71dd7ba7e62.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b198fe971cecd301f0c7c66028cfd71dd7ba7e62.camel@intel.com>
Cc: "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
 "david@redhat.com" <david@redhat.com>, "Yao, Yuan" <yuan.yao@intel.com>,
 "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "Gao,
 Chao" <chao.gao@intel.com>, "farman@linux.ibm.com" <farman@linux.ibm.com>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "atishp@atishpatra.org" <atishp@atishpatra.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "vkuznets@redhat.com" <vkuznets@redhat.com>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Nov 10, 2022, Huang, Kai wrote:
> On Thu, 2022-11-10 at 01:33 +0000, Huang, Kai wrote:
> > > @@ -9283,7 +9283,13 @@ static int
> > > kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
> > > =A0	int cpu =3D smp_processor_id();
> > > =A0	struct cpuinfo_x86 *c =3D &cpu_data(cpu);
> > > =A0
> > > -	WARN_ON(!irqs_disabled());
> > > +	/*
> > > +	 * Compatibility checks are done when loading KVM and when enabling
> > > +	 * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
> > > +	 * compatible, i.e. KVM should never perform a compatibility check
> > > on
> > > +	 * an offline CPU.
> > > +	 */
> > > +	WARN_ON(!irqs_disabled() && cpu_active(cpu));
> > > =A0
> > =

> > Also, the logic of:
> > =

> > 	!irqs_disabled() && cpu_active(cpu)
> > =

> > is quite weird.
> > =

> > The original "WARN(!irqs_disabled())" is reasonable because in STARTING
> > section
> > the IRQ is indeed disabled.
> > =

> > But this doesn't make sense anymore after we move to ONLINE section, in=
 which
> > IRQ has already been enabled (see start_secondary()).=A0 IIUC the WARN_=
ON()
> > doesn't get exploded is purely because there's an additional cpu_active=
(cpu)
> > check.
> > =

> > So, a more reasonable check should be something like:
> > =

> > 	WARN_ON(irqs_disabled() || cpu_active(cpu) || !cpu_online(cpu));
> > =

> > Or we can simply do:
> > =

> > 	WARN_ON(!cpu_online(cpu) || cpu_active(cpu));
> > =

> > (because I don't know whether it's possible IRQ can somehow get disable=
d in
> > ONLINE section).
> > =

> > Btw above is purely based on code analysis, but I haven't done any test.
> =

> Hmm.. I wasn't thinking thoroughly.  I forgot CPU compatibility check also
> happens on all online cpus when loading KVM.  For this case, IRQ is disab=
led and
> cpu_active() is true.  For the hotplug case, IRQ is enabled but  cpu_acti=
ve() is
> false.

Actually, you're right (and wrong).  You're right in that the WARN is flawe=
d.  And
the reason for that is because you're wrong about the hotplug case.  In thi=
s version
of things, the compatibility checks are routed through hardware enabling, i=
.e. this
flow is used only when loading KVM.  This helper should only be called via =
SMP function
call, which means that IRQs should always be disabled.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
