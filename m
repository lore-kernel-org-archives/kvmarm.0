Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53521A601
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 16:59:01 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id h14so2017650pjv.4
        for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 08:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=++qaNnNL5OJX09F4SmymJbSNGTe4YNGKf8knlNeZLIM=;
        b=LnpIznW50UbJYIR0PEtWeJYNJ+5rH6MIlZozMzFMTwSQvTcP33ucW9c9lQSevvLDXI
         QyB5+yXhMZUDNlkwdSbDFjM7JR9S8ttOodJeLQApsp/g1X2g7iaiRMpztbbtLirGmHXP
         Ok5MPlCZ4tZXNzdoN/5EaAFNU5i/kMEU+Pj6UbsvHwVNko95a9bIdjWXiNhQrkyCMZcF
         1gbXxHeTac5BLcvPalQHTWFwjbFrO0re69/ZDM4/c7ATiGknmYZEnSteDE0eFOsuiUGv
         o02wNWrUZNQBtGle02WgOsPhE6Inb5/XeEtyenAcor9m9bnEppDYL8UdqJt6p1agDB2o
         ED2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++qaNnNL5OJX09F4SmymJbSNGTe4YNGKf8knlNeZLIM=;
        b=a8ejWX/lb/3VXsCabIOkVFnfZxfqxx4eQFhY6DjE5Yg6GS9RHWamnKqsGFtxMLgk2h
         L/lRle6/lPXJk7p5Nhw3ap2fXP40UZcj8f097l9qPGPpBonwbHvH4yIQe5mFvQqJ5jAj
         TSZm3fpb8zlxcniwlOyaa2SApKf68o3L/gjSElcjuvhRmuxZ/e/9CYbscH0mwUwoG5Hc
         WOwH5/LYPYbXNYJrUA8ZFiu31uZY+Csjz1Qr8apHbJc0fFVqLMUp1u5owh/16kJrBX5s
         Dc6auYGdzH4bADHlt6rJc54vb7zBUIV3HqcVGn+SApdGLKRMTmmkVdeJb9UAViU1q9w8
         Y5HQ==
X-Gm-Message-State: ANoB5pks7kTg/dNgk3dMMOeYE9+vk4dyEvAUgskSN+yKHu0hA6tIBiBE
	EkuiJckZ8Kr3No+uS0U9Dwg5VA==
X-Google-Smtp-Source: AA0mqf4HLI0425WgRwXjVOczy7lGJ1ZoFRhJMikRvyU6kmBBe6o5W1MVmVmeziJeqm75+QzM+47Lew==
X-Received: by 2002:a17:902:6aca:b0:188:736c:befa with SMTP id i10-20020a1709026aca00b00188736cbefamr1100928plt.8.1668099540938;
        Thu, 10 Nov 2022 08:59:00 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a5ac500b00200461cfa99sm3302123pji.11.2022.11.10.08.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 08:59:00 -0800 (PST)
Date: Thu, 10 Nov 2022 16:58:56 +0000
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
Message-ID: <Y20t0AMNqvtyOwp2@google.com>
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
Message-ID: <20221110165856.RmjL5sdrcPuFdjPxLKKwLlAso3qSEVQNtJ-pi2QlbEs@z>

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
> 
> So WARN_ON(!irqs_disabled() && cpu_active(cpu)) looks reasonable.  Sorry for the
> noise.  Just needed some time to connect the comment with the code.

No worries, more than once while working through this code, I've considered setting
up one of those evidence boards from the movies with string and push pins to help
connect all the dots.
