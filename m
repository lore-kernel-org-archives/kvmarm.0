Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E983C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 16:49:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F6DE4BAE3;
	Thu, 10 Nov 2022 11:49:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ResVHBizSPjZ; Thu, 10 Nov 2022 11:49:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92E3E4BAA3;
	Thu, 10 Nov 2022 11:49:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB7974BA83
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 11:49:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hkQxpas+EXLT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 11:49:35 -0500 (EST)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 758FB4BA82
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 11:49:35 -0500 (EST)
Received: by mail-pj1-f45.google.com with SMTP id
 q1-20020a17090a750100b002139ec1e999so2055041pjk.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 08:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=YFJ3+ExWaH1S1gL0QTWKmsYNBPJ8OxWoCpDiJ96bF1FeTcDjjBcGqR97JYOeOflXLs
 L4Twe8czu+KmAED60+ZTkwn6+iCicRtfmrgmg73GjzsMh01s7NyAMK8xknddpCP9m5IR
 u5lrZahfhADplbXRzcDpOkzfJjT3IuPyoGQ2fXHcE6H54iAe8gMoKiAJvDTvUp+I1KnG
 9iUSL5wTLmJBsqLvlpsam1JQsoEdFo24uhkYtE5aNOg23NfYfuUPjFNSvvPm4hAo2xQ0
 WZqoC4GrqJmUrZh0oXX0le3im0bfRYkfUlTJhTI2ScgQlc/kct6ZGm+q76FzzDGSOwEu
 MPRQ==
X-Gm-Message-State: ACrzQf1R6Fb1jxVJLmhlhW7Vv+Em7Jf1OQCoh0mjO1TwQaI8Z9eOu/J3
 hZr+cluQQ0KP0gTyqLUnvVt0MQ==
X-Google-Smtp-Source: AMsMyM7nQN/gdgW0z481CkQ/WjHrrL4d++/kzaSXhuKO9UuGt09a3AowKSZBoBJ0HDICWxNrCbdrGA==
X-Received: by 2002:a17:902:d50c:b0:187:460:bf9c with SMTP id
 b12-20020a170902d50c00b001870460bf9cmr65545589plg.4.1668098974180; 
 Thu, 10 Nov 2022 08:49:34 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 c3-20020a17090a020300b00205d85cfb30sm3288107pjc.20.2022.11.10.08.49.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 10 Nov 2022 08:49:33 -0800 (PST)
Date: Thu, 10 Nov 2022 16:49:29 +0000
From: Sean Christopherson <seanjc@google.com>
To: Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH 37/44] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <Y20rmaU14rZFFCZI@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-38-seanjc@google.com>
 <301a8a33a5cbe5b4fd3efe03b05bb8410a46e9f5.camel@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <301a8a33a5cbe5b4fd3efe03b05bb8410a46e9f5.camel@linux.intel.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
