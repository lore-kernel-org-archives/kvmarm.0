Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE384107A2
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 16:49:34 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so2077594pji.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 08:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rPjVc+C4keVB9JNeySRKdiTbUPe13351AhOJe9TtZf8=;
        b=OOR4bwRUplBbyMMh2BEwu+86VP3qxijSJnezQ7clymoLz9HUcLonm3WyVFc88kB5fY
         O/E+L3vna3lCH6PwuGGALEpEbdqf//FCQPJXnQH0fruVZmuKpiXxpksMlHLNli5FBIVk
         yHcqF3ftlcFWSWpaRO18yKIRlZ4MLKYwLTrjNA/qL4cv528Rj8wkmrotYw4AfXaxmJus
         pcCX78Uh4a0+xqNPkY5yiRwsOaQfBATcwvX2XL8kq2aQkn5xXT0ESqE2s4sWnkM2XUP1
         lN0YUhWFEsDiU77d2rUZObTRDQeLPD96HT9QdyztVtB+kfc9jl7KnKnrsPBskzRSRVH/
         XRTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rPjVc+C4keVB9JNeySRKdiTbUPe13351AhOJe9TtZf8=;
        b=Jazd3h9OGvUl64KJ7OX+hWC1uIv4E/j6Rdp7P1+ijuj6GlKTw2ycs2gAcX6BTfgGk3
         x3K3mS4R0GjqtTIMME7aoR9ocsothmJ5AnZLoI+S1dyexlyMjvR1fFpqQDVAsJ7U3mpr
         eXyVRCc+Wk91QaHgdnn/BEBUiRaGhzvXplr1dMo8wP3OfnZxRN4qpDe/nDUNtADDe3/w
         lEo7ZEvfz71dk82SKRH/amC67zEUmf2wmL6q1NpRjkCX324x7gGLvi9VGKBiiTkjgC05
         QlcWzATegPp0L4Xn4iRNBJQ8WtS2V3ekTszKCYJszZxJLuWvIg+PWxhlNY4otzusPGDB
         iVYg==
X-Gm-Message-State: ACrzQf2AELBqsHc4gDP4K9Y/JaFe1apn9iUDnX53206r2bYP8eQu4MYX
	JSvBaHDNk6zK8XIs5ppJ5ttYNA==
X-Google-Smtp-Source: AMsMyM7nQN/gdgW0z481CkQ/WjHrrL4d++/kzaSXhuKO9UuGt09a3AowKSZBoBJ0HDICWxNrCbdrGA==
X-Received: by 2002:a17:902:d50c:b0:187:460:bf9c with SMTP id b12-20020a170902d50c00b001870460bf9cmr65545589plg.4.1668098974180;
        Thu, 10 Nov 2022 08:49:34 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c3-20020a17090a020300b00205d85cfb30sm3288107pjc.20.2022.11.10.08.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 08:49:33 -0800 (PST)
Date: Thu, 10 Nov 2022 16:49:29 +0000
From: Sean Christopherson <seanjc@google.com>
To: Robert Hoo <robert.hu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Atish Patra <atishp@atishpatra.org>,
	David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Fabiano Rosas <farosas@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 37/44] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <Y20rmaU14rZFFCZI@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-38-seanjc@google.com>
 <301a8a33a5cbe5b4fd3efe03b05bb8410a46e9f5.camel@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <301a8a33a5cbe5b4fd3efe03b05bb8410a46e9f5.camel@linux.intel.com>
Message-ID: <20221110164929.3_wbCMgq073Y0_vWWpCAC0DQrP4CSUagLBQFLRJdf3I@z>

On Thu, Nov 10, 2022, Robert Hoo wrote:
> > -static int kvm_starting_cpu(unsigned int cpu)
> > +static int kvm_online_cpu(unsigned int cpu)
> >  {
> > +	int ret = 0;
> > +
> >  	raw_spin_lock(&kvm_count_lock);
> > -	if (kvm_usage_count)
> > +	/*
> > +	 * Abort the CPU online process if hardware virtualization
> > cannot
> > +	 * be enabled. Otherwise running VMs would encounter
> > unrecoverable
> > +	 * errors when scheduled to this CPU.
> > +	 */
> > +	if (kvm_usage_count) {
> > +		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
> > +
> >  		hardware_enable_nolock(NULL);
> > +		if (atomic_read(&hardware_enable_failed)) {
> > +			atomic_set(&hardware_enable_failed, 0);
> 
> I see other places using this hardware_enable_failed with atomic_inc(),
> should here use atomic_dec() instead of straightly set to 0?

Meh, both options are flawed.  E.g. if hardware_enable_failed was left dangling
(the WARN above), then atomic_dec() won't remedy the problem and KVM will reject
onlining CPUs indefinitely.  Forcing the atomic back to '0' will remedy that
particular issue, but could lead to problems if there are other bugs.

> Though here is embraced by spin_lock, hardware_enable_nolock() can be
> invoked in other places in parallel?

Only because of a KVM bug, which gets fixed in the next patch:

  KVM: Disable CPU hotplug during hardware enabling
