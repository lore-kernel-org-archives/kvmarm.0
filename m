Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B31C4321E
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 16:04:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89CCC4120D;
	Fri,  2 Dec 2022 11:04:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s9mai4bjLS85; Fri,  2 Dec 2022 11:04:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 524374B133;
	Fri,  2 Dec 2022 11:04:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C9C0411C7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 11:04:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wqBDaLGK2Jjp for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 11:04:15 -0500 (EST)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 46FFA410E6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 11:04:15 -0500 (EST)
Received: by mail-pl1-f179.google.com with SMTP id b21so5007492plc.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Dec 2022 08:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=b2GsRYGpugbtZSHFD2RurCZ4JW4xZuzTsOfxXrCkfT8=;
 b=NpcRjd8PL93RDmu18EFPPR+cTZLP3kvCDAEAva9wUQzgEtv6dhPvDs1R9Q9+h2mN7N
 H42dGaT+sl8xeMuYK2rfUD+midQutKuG+T3MUl21HeEIW4MolVpdsUIo9SmBbkggNx39
 8eN3yXePSJelVozj19wEaq9z6VDhzvEr0ForIWyEXE5qa5rozQa3WxAYewh7SubIBKmO
 02PPePyseXuLiMMtCMvFiCLdBEv6hZUEsP/WY2KPh2svytXFAqt8tvoUSmd0DdfZmIR5
 sLez1JP4ikgagdRRPh2k9RbfsucGTq+KVdolkDHLvc/Uk58Zr0iw+nxpff3e47GDmBB4
 X4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=b2GsRYGpugbtZSHFD2RurCZ4JW4xZuzTsOfxXrCkfT8=;
 b=hARYbKIb1K3Av/XzshZ1NSTurTKurqrhxn0tf1GdjfG4zdoiO+3G+JDuXNhquOWWzE
 9MPOxuZv+u2tMl2NMo3OTIK5R25ebCFWc/0PJkSiQJMDGhLnGt0Gx286OrNhaPj64fwU
 8rxUxeMjCk8eWH3dF+1OLtE/lSMKjccpP4cAGk+cjsxH0UddEG4hOvC9ds0UVNyVlgzu
 ONfJO+zHJT8p3eWJtlnaUeih4+kMIdS2zwQexmuO1760YuwewCQnW5dujTF3UuYbPftJ
 mEHtgqHoeoNNWHCY4uDbOD6FbE6Y9ozvLbYQXkEkzAiLdPKGqIi3bKz7bSg0U9GvbEeE
 jRGg==
X-Gm-Message-State: ANoB5pndUKZ021fDqNFfPosXxNnroreC7l/IDJWUdW+EJZIz/iEUkwTW
 2NCaiGCDxtjIUHIqgB/SMwUIPg==
X-Google-Smtp-Source: AA0mqf7w0TN/IsoZof5JEkNGBQ8Yd2Zjjhh4wCVFAlaPO07IGqPcQWl6OiCMwNp3DG6Q8B9rQJAiYA==
X-Received: by 2002:a17:90a:9a98:b0:219:2f90:4fb3 with SMTP id
 e24-20020a17090a9a9800b002192f904fb3mr28837193pjp.109.1669997053879; 
 Fri, 02 Dec 2022 08:04:13 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 q42-20020a17090a1b2d00b00219752c8ea5sm3349337pjq.37.2022.12.02.08.04.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 02 Dec 2022 08:04:13 -0800 (PST)
Date: Fri, 2 Dec 2022 16:04:09 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [PATCH v2 40/50] KVM: x86: Do compatibility checks when onlining
 CPU
Message-ID: <Y4oh+XsbifA2BSj9@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-41-seanjc@google.com>
 <cf755389c21c73e8367d8162cabc83629d3f9a74.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cf755389c21c73e8367d8162cabc83629d3f9a74.camel@intel.com>
Cc: "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
 "paul@xen.org" <paul@xen.org>, "Yao, Yuan" <yuan.yao@intel.com>,
 "david@redhat.com" <david@redhat.com>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "atishp@atishpatra.org" <atishp@atishpatra.org>,
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
 "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "vkuznets@redhat.com" <vkuznets@redhat.com>,
 "dwmw2@infradead.org" <dwmw2@infradead.org>
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

On Fri, Dec 02, 2022, Huang, Kai wrote:
> On Wed, 2022-11-30 at 23:09 +0000, Sean Christopherson wrote:
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11967,6 +11967,11 @@ int kvm_arch_hardware_enable(void)
> > =A0	bool stable, backwards_tsc =3D false;
> > =A0
> > =A0	kvm_user_return_msr_cpu_online();
> > +
> > +	ret =3D kvm_x86_check_processor_compatibility();
> > +	if (ret)
> > +		return ret;
> > +
> > =A0	ret =3D static_call(kvm_x86_hardware_enable)();
> > =A0	if (ret !=3D 0)
> > =A0		return ret;
> =

> Thinking more, AFAICT, kvm_x86_vendor_init() so far still does the compat=
ibility
> check on all online cpus.  Since now kvm_arch_hardware_enable() also does=
 the
> compatibility check, IIUC the compatibility check will be done twice -- o=
ne in
> kvm_x86_vendor_init() and one in hardware_enable_all() when creating the =
first
> VM.
> =

> Do you think it's still worth to do compatibility check in vm_x86_vendor_=
init()?
> =

> The behaviour difference should be "KVM module fail to load" vs "failing =
to
> create the first VM" IIUC.  I don't know whether the former is better tha=
n the
> better, but it seems duplicated compatibility checking isn't needed?

It's not strictly needed, but I think it's worth keeping.  The duplicate ch=
ecking
annoys me too, and I considered removing it multiple times when creating th=
is
series.  But, if there is a hardware incompatibility for whatever reason, f=
ailing
to load and thus not instantiating /dev/kvm is friendlier to userspace, e.g.
userspace can immediately flag the platform as potentially flaky, whereas
detecting the likely hardware issue when VM creation fails would essentialy=
 require
scraping the kernel logs.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
