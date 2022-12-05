Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94D2C4708C
	for <kvmarm@archiver.kernel.org>; Mon,  5 Dec 2022 21:12:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C3EE4B3CA;
	Mon,  5 Dec 2022 16:12:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y1AtCFokQ8S9; Mon,  5 Dec 2022 16:12:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06D2440E76;
	Mon,  5 Dec 2022 16:12:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0F3D40E76
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 16:12:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b+EyS0OpVdw1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2022 16:12:44 -0500 (EST)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC5F040AEB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 16:12:44 -0500 (EST)
Received: by mail-pg1-f173.google.com with SMTP id 6so11589060pgm.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Dec 2022 13:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=9BS9+Fk77r2sqEaU7XwhOF5T7uvKSgLeTZbiEXUGcMo=;
 b=Ujio/I//LxFB/K3sVL9gmNsGJ2wTNbSjKjPUCByX11FEgdEzOgOqiXg/gRqfeGF7s+
 BRBVYIHZsjiCW+mopZZqJtOFx8R72OQ+lxd1rMhvvBVaCHky62qMT42W7ann/KH4QVEi
 7RDo5VhBRC8pzm08UnWL1v8bR/cRgCAMAHzAeJOZ77ZAJGj5jTiVT2fPdcmD7+sDDe5A
 MCK85CoektbMIOfXCT03EXGqxDh77jznAXbuGFlYRgsEHGnbyTN0uldNNg+81eLCMpdy
 485zxEh+YV7agkZEO9zh/Zlc6/uD1mmvMxm2NZPEwpELq6RwwxuABQO2pRIN5lh3pL9X
 0pWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=9BS9+Fk77r2sqEaU7XwhOF5T7uvKSgLeTZbiEXUGcMo=;
 b=rBE9WOBymC7tCm84Eeg338zpS9LPlSt022JXIaR8DLMlhtZK+IoQH1fdj7f2TZwkic
 4s+bdGtdm+EX9e6ATZvDO1egBs9eS8VU2DO07K3KN+7NvlzBGAfdETPvouOw9HneNNLx
 aCihmvfcs9cEDUByc6P1jJ4w1HDeYx9NxCAftCSOqGPaxgRD8RX9Su0tgqTrdZyAPGsy
 xXhzeBXvRZUpT2/aqecZ3sePRra1ZgnCmlFbB85/XpDZ+I0GEf1vcSuseVju9gYX3cz+
 YzfN2WjjMd4PRrS3dJ9Ymt2isuzrjpJwXAA26oCMYW9o0BtRcn/q7MSonVXM2JKp1+Yt
 f6zA==
X-Gm-Message-State: ANoB5pntnedOjns9aVAVYFFJoZSfSuGhfFgaSg+c994BWcPC9FRkXcIC
 tlsOdifWIBs0AjCblmxThNb3qw==
X-Google-Smtp-Source: AA0mqf7NtaiQFi9maqoCvGoM6sFH0HgJLUnKLXrzCG7pSHOZoyGtCDF0ZU4oxE1QMNHHmHHaqhNDEw==
X-Received: by 2002:aa7:91d6:0:b0:574:c543:f804 with SMTP id
 z22-20020aa791d6000000b00574c543f804mr49454104pfa.51.1670274763510; 
 Mon, 05 Dec 2022 13:12:43 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 nn6-20020a17090b38c600b00219f8eb271fsm131413pjb.5.2022.12.05.13.12.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 05 Dec 2022 13:12:43 -0800 (PST)
Date: Mon, 5 Dec 2022 21:12:39 +0000
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 31/50] KVM: x86: Do CPU compatibility checks in x86 code
Message-ID: <Y45ex/CyTY7jYa5D@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-32-seanjc@google.com>
 <20221205205246.GA3630770@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221205205246.GA3630770@ls.amr.corp.intel.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>, Paul Durrant <paul@xen.org>,
 Yuan Yao <yuan.yao@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Michael Ellerman <mpe@ellerman.id.au>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>
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

On Mon, Dec 05, 2022, Isaku Yamahata wrote:
> On Wed, Nov 30, 2022 at 11:09:15PM +0000,
> > index 66f16458aa97..3571bc968cf8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9277,10 +9277,36 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
> >  	kvm_pmu_ops_update(ops->pmu_ops);
> >  }
> >  
> > +struct kvm_cpu_compat_check {
> > +	struct kvm_x86_init_ops *ops;
> > +	int *ret;
> 
> minor nitpick: just int ret. I don't see the necessity of the pointer.
> Anyway overall it looks good to me.

...

> > @@ -9360,6 +9386,14 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> >  	if (r != 0)
> >  		goto out_mmu_exit;
> >  
> > +	c.ret = &r;
> > +	c.ops = ops;
> > +	for_each_online_cpu(cpu) {
> > +		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &c, 1);
> > +		if (r < 0)
> 
> Here it can be "c.ret < 0".

No, because the below goto leads to "return r", i.e. "c.ret" needs to be propagated
to "r".  That's why the code does the admittedly funky "int *ret" thing.

FWIW, this gets cleanup in the end.  "struct kvm_cpu_compat_check" goes away and
"&r" is passed directly to kvm_x86_check_cpu_compat.

> > +			goto out_hardware_unsetup;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
