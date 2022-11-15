Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BE48AAD
	for <kvmarm@lists.linux.dev>; Tue, 15 Nov 2022 20:16:08 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id io19so14162414plb.8
        for <kvmarm@lists.linux.dev>; Tue, 15 Nov 2022 12:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=b6X6ULbAZU7R9rTt9zrFZ+BR40QyRrcM0cmynJx3G9q415qSgq9tJixA69NmrufPzB
         cXytpGjhutcxs8EEE3aAS22qWNsHcRO11MgqLQg3k1gfsHEe6ExQ0kDdepEeKVheC0ue
         r18IIWsOfQ9JtCG+Ue55rZvJ5b9Te18vXgvJu7S3cx1pJeoSVeSspB1K9SaL/mvARl6c
         J+ipWrlCgbCU44M9fw8nEKuRXBoCP9UQXh746zYzp0zf+2RhZ+xfoYR/dDgHZ+vs9xUt
         pAgbqlHjQ5nwIXjTE8H6gq6oedMIssxhDBFoToCHfAXm+QDrwvBgTnQkwSWZ2H2ES+hV
         57vw==
X-Gm-Message-State: ANoB5plk0eGyc2ByYpe02SQ2QeajgmgkoMWLWa8Yv69PO6QlnOkymgxE
	NUJ6kD/WJBHdm3SqxLbnGviMLw==
X-Google-Smtp-Source: AA0mqf58/qb3pHX8jXG9rQwsI0kWr5CgUXW3YysHviPdV0VVEN3OAELl4gQs2//98Y2csv6jhLKLCw==
X-Received: by 2002:a17:902:e8d5:b0:181:6c64:6dd3 with SMTP id v21-20020a170902e8d500b001816c646dd3mr5671131plg.123.1668543368117;
        Tue, 15 Nov 2022 12:16:08 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d62-20020a623641000000b0056c08c87196sm9173979pfa.48.2022.11.15.12.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 12:16:07 -0800 (PST)
Date: Tue, 15 Nov 2022 20:16:04 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "farman@linux.ibm.com" <farman@linux.ibm.com>,
	"frankja@linux.ibm.com" <frankja@linux.ibm.com>,
	"mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"anup@brainfault.org" <anup@brainfault.org>,
	"imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"atishp@atishpatra.org" <atishp@atishpatra.org>,
	"farosas@linux.ibm.com" <farosas@linux.ibm.com>,
	"david@redhat.com" <david@redhat.com>,
	"Yao, Yuan" <yuan.yao@intel.com>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	"Gao, Chao" <chao.gao@intel.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
Message-ID: <Y3PzhANShVlTXVg1@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-39-seanjc@google.com>
 <88e920944de70e7d69a98f74005b49c59b5aaa3b.camel@intel.com>
 <b198fe971cecd301f0c7c66028cfd71dd7ba7e62.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b198fe971cecd301f0c7c66028cfd71dd7ba7e62.camel@intel.com>
Message-ID: <20221115201604.LlNak4B6HIUVbbkMtAs_S6Mdnp3rMc-4SBadDn8KssE@z>

On Thu, Nov 10, 2022, Huang, Kai wrote:
> On Thu, 2022-11-10 at 01:33 +0000, Huang, Kai wrote:
> > > @@ -9283,7 +9283,13 @@ static int
> > > kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
> > >  	int cpu = smp_processor_id();
> > >  	struct cpuinfo_x86 *c = &cpu_data(cpu);
> > >  
> > > -	WARN_ON(!irqs_disabled());
> > > +	/*
> > > +	 * Compatibility checks are done when loading KVM and when enabling
> > > +	 * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
> > > +	 * compatible, i.e. KVM should never perform a compatibility check
> > > on
> > > +	 * an offline CPU.
> > > +	 */
> > > +	WARN_ON(!irqs_disabled() && cpu_active(cpu));
> > >  
> > 
> > Also, the logic of:
> > 
> > 	!irqs_disabled() && cpu_active(cpu)
> > 
> > is quite weird.
> > 
> > The original "WARN(!irqs_disabled())" is reasonable because in STARTING
> > section
> > the IRQ is indeed disabled.
> > 
> > But this doesn't make sense anymore after we move to ONLINE section, in which
> > IRQ has already been enabled (see start_secondary()).  IIUC the WARN_ON()
> > doesn't get exploded is purely because there's an additional cpu_active(cpu)
> > check.
> > 
> > So, a more reasonable check should be something like:
> > 
> > 	WARN_ON(irqs_disabled() || cpu_active(cpu) || !cpu_online(cpu));
> > 
> > Or we can simply do:
> > 
> > 	WARN_ON(!cpu_online(cpu) || cpu_active(cpu));
> > 
> > (because I don't know whether it's possible IRQ can somehow get disabled in
> > ONLINE section).
> > 
> > Btw above is purely based on code analysis, but I haven't done any test.
> 
> Hmm.. I wasn't thinking thoroughly.  I forgot CPU compatibility check also
> happens on all online cpus when loading KVM.  For this case, IRQ is disabled and
> cpu_active() is true.  For the hotplug case, IRQ is enabled but  cpu_active() is
> false.

Actually, you're right (and wrong).  You're right in that the WARN is flawed.  And
the reason for that is because you're wrong about the hotplug case.  In this version
of things, the compatibility checks are routed through hardware enabling, i.e. this
flow is used only when loading KVM.  This helper should only be called via SMP function
call, which means that IRQs should always be disabled.
