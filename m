Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D38B4C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 15 Nov 2022 20:21:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32CFD4B8D9;
	Tue, 15 Nov 2022 15:21:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AfmV9pT-us-M; Tue, 15 Nov 2022 15:21:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E0174B8C6;
	Tue, 15 Nov 2022 15:21:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 750484B8B8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 15:21:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ES23f3cQGwuK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2022 15:21:05 -0500 (EST)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 640B04B890
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 15:21:05 -0500 (EST)
Received: by mail-pg1-f175.google.com with SMTP id 62so6025050pgb.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 12:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=XxrH205VSL6PuZxNZy5QSHBg1esXqApruwRLQHoD1FQ=;
 b=QoLsrppxCqrrm8Et/yxXiG7qWE0hiOrc+RLWkwKVvGYvEXTURW54Ct7G0aFnW7vDom
 O3WnXZWOxSKhgS+uv00LIKaFYAiY4w1O0HuVw0sHlWnVNkXyDKqsQfpccjPy0o//76Ot
 9HbC7sv+GYjRBhUyAvWsaFUrflZFb6BoKafnLIcIXy0vGyf6tKbOGR6vv68o6WUCslEQ
 BOT4pCgeSJnKExa2xfKvrZGwBZhzuokrCi6o4yMRfhSIGNbmSd/1S94WiYpeZI3RH1jS
 tMxrZXr8PoWD2Hx+ZMuaUIAmz2hZjOEiOFHGi/ELuekxNrIkmFIAeW4IyLdTJL7wajgf
 6FdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=XxrH205VSL6PuZxNZy5QSHBg1esXqApruwRLQHoD1FQ=;
 b=H6QMtgwi++hKy4NyIh/cw8whQJoA7wsW0DmmYbI3Qwo6Pm2ImYjswEriFVSBUbN/uK
 4i7iXClsRRdsakEL3fFdWILoyszb+nxqJK/8uCFHD1ol5QX5oWIk7LtZLFhc1e3d5Fyv
 3+Gu6TWPbp5ZNbU36R2Uv5EAdwFkVlL0byhbbhBQhNVzOSruUJQe0/Ccwxx7EotY6Tch
 dMGGAzEP1i+enKrLZU6Q7oC0ypYv0dSwKZbVyDuax0AelsVBx+Vl8IVCFPLjxRMSy6aQ
 xM0RaO7YOFoyu4hCB6Dq2wnHtDS0Pv7gg5vW6YWgAcYmD2R2uAHtAy305ZCbHjLdCna9
 gVBw==
X-Gm-Message-State: ANoB5plZRetnAlAeb4Y6iDBfjhGiDellFjxe2MOKTfW3gROe2pOtaK7T
 ELapzyLOcILkuqkoQnLucotNiQ==
X-Google-Smtp-Source: AA0mqf7I+HCT8JLUK2SnELicaIfj+5Xh/wdDfnKOa9DuiFN7rhFS7bzZLz9XVMfRQzvW4tmCjZQXQw==
X-Received: by 2002:aa7:9493:0:b0:56b:9ae8:ca05 with SMTP id
 z19-20020aa79493000000b0056b9ae8ca05mr19812088pfk.59.1668543664233; 
 Tue, 15 Nov 2022 12:21:04 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 o15-20020a170902d4cf00b001754fa42065sm10448477plg.143.2022.11.15.12.21.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Nov 2022 12:21:03 -0800 (PST)
Date: Tue, 15 Nov 2022 20:21:00 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
Message-ID: <Y3P0rAjywL1a7Pme@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-39-seanjc@google.com>
 <88e920944de70e7d69a98f74005b49c59b5aaa3b.camel@intel.com>
 <b198fe971cecd301f0c7c66028cfd71dd7ba7e62.camel@intel.com>
 <Y3PzhANShVlTXVg1@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y3PzhANShVlTXVg1@google.com>
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

On Tue, Nov 15, 2022, Sean Christopherson wrote:
> On Thu, Nov 10, 2022, Huang, Kai wrote:
> > On Thu, 2022-11-10 at 01:33 +0000, Huang, Kai wrote:
> > > > @@ -9283,7 +9283,13 @@ static int
> > > > kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
> > > > =A0	int cpu =3D smp_processor_id();
> > > > =A0	struct cpuinfo_x86 *c =3D &cpu_data(cpu);
> > > > =A0
> > > > -	WARN_ON(!irqs_disabled());
> > > > +	/*
> > > > +	 * Compatibility checks are done when loading KVM and when enabli=
ng
> > > > +	 * hardware, e.g. during CPU hotplug, to ensure all online CPUs a=
re
> > > > +	 * compatible, i.e. KVM should never perform a compatibility check
> > > > on
> > > > +	 * an offline CPU.
> > > > +	 */
> > > > +	WARN_ON(!irqs_disabled() && cpu_active(cpu));
> > > > =A0
> > > =

> > > Also, the logic of:
> > > =

> > > 	!irqs_disabled() && cpu_active(cpu)
> > > =

> > > is quite weird.
> > > =

> > > The original "WARN(!irqs_disabled())" is reasonable because in STARTI=
NG
> > > section
> > > the IRQ is indeed disabled.
> > > =

> > > But this doesn't make sense anymore after we move to ONLINE section, =
in which
> > > IRQ has already been enabled (see start_secondary()).=A0 IIUC the WAR=
N_ON()
> > > doesn't get exploded is purely because there's an additional cpu_acti=
ve(cpu)
> > > check.
> > > =

> > > So, a more reasonable check should be something like:
> > > =

> > > 	WARN_ON(irqs_disabled() || cpu_active(cpu) || !cpu_online(cpu));
> > > =

> > > Or we can simply do:
> > > =

> > > 	WARN_ON(!cpu_online(cpu) || cpu_active(cpu));
> > > =

> > > (because I don't know whether it's possible IRQ can somehow get disab=
led in
> > > ONLINE section).
> > > =

> > > Btw above is purely based on code analysis, but I haven't done any te=
st.
> > =

> > Hmm.. I wasn't thinking thoroughly.  I forgot CPU compatibility check a=
lso
> > happens on all online cpus when loading KVM.  For this case, IRQ is dis=
abled and
> > cpu_active() is true.  For the hotplug case, IRQ is enabled but  cpu_ac=
tive() is
> > false.
> =

> Actually, you're right (and wrong).  You're right in that the WARN is fla=
wed.  And
> the reason for that is because you're wrong about the hotplug case.  In t=
his version
> of things, the compatibility checks are routed through hardware enabling,=
 i.e. this
> flow is used only when loading KVM.  This helper should only be called vi=
a SMP function
> call, which means that IRQs should always be disabled.

Grr, but not routing through this helper is flawed in that KVM doesn't do t=
he
CR4 checks in the hardware enabling case.  Don't think that changes the WAR=
N, but
other patches in this series need tweaks.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
