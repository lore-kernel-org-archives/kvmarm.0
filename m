Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D990C43217
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 15:16:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBCFA4B6C5;
	Thu, 17 Nov 2022 10:16:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qPb3u-Ns70YZ; Thu, 17 Nov 2022 10:16:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 721394B81F;
	Thu, 17 Nov 2022 10:16:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E13D34B822
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 10:16:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U5v7xq-GpQna for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2022 10:16:20 -0500 (EST)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 985F74B6C5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 10:16:20 -0500 (EST)
Received: by mail-pj1-f42.google.com with SMTP id
 l22-20020a17090a3f1600b00212fbbcfb78so5680815pjc.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 07:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=Geqy1MGLbG4CNNhTg6ig5gMw4IRIu2ApDkqg8kUu6fE=;
 b=im3ECY8irru0d2J3PmRkK1oS6XMYGDmkKrSKiLpQr6kggh65U519LacoANhp99/wDs
 yHeOZt/b6IK2ihlol7f0Ba2me3bs0cr3TxYhTcQThAifpYqs8dB3p/8NK2dEXBDay90O
 bW6pXrP7B14I1MNWa+NfggtZKbyTz1rnHhMsVYBCQiIPWqcakktYyuja6CoTLxQtkpfs
 JsqTKBMeEN72FgBWe/ihbCXP9h1x9TEb9ulziUgPn3ZIyNK23YQtGzg65j8/As9Xyk7K
 3+HVs34s1miAiKC8ZfgoVMv73WwF3DJWJcQDYskZpYkejUuTFt6cPMAw/xSDBCQyvpM1
 B6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Geqy1MGLbG4CNNhTg6ig5gMw4IRIu2ApDkqg8kUu6fE=;
 b=QjUXNjBBGBeJKkR9PZhBmdt/fJjeRBn8u85PvVkVwcLjxne5dWbhsCrXrSecpatFbh
 k7QmMFcZiVH33CL2pnamGFtlTwhch0sHOQtpjY29NweWs3z5k4/x2hNdfzKKOYi9r+Xl
 +hdSR3l/kqV7JXFWFgG85VwJX45mPMZiJ2kQeZnHvMInjBrzzhsmTtyDsnP99fRlTqLa
 pDUCeZyrswt/+PIIj39wRnc/0xBZVS0F9eH1/aaId8E2C5ZjnUiq73mPBdkRD+zaULD6
 ZnZ/wGQrFhcjscv0oCeVZHkIpuSL9+OG4rn3IrBnR2LCRr6AzkEbnS3aYsJk2pPnP6/o
 FltQ==
X-Gm-Message-State: ANoB5pkDAWwjihk8QwlRd2wQnjF8Xz/RQVK+lzRdgVNWBvbOIGMVXAdH
 7zX1yagYI9UvVgVcQx2Hq46cSw==
X-Google-Smtp-Source: AA0mqf5Drbj5GGUy8zNXmPljMG8UuEFTPTHf+YuwVXyWlSocFeljs1OjIQ+Ab7mWXZMNXetmsxdGbQ==
X-Received: by 2002:a17:90a:6b84:b0:20a:cbb0:3c9b with SMTP id
 w4-20020a17090a6b8400b0020acbb03c9bmr3280802pjj.81.1668698179289; 
 Thu, 17 Nov 2022 07:16:19 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 r12-20020a63e50c000000b00476dc914262sm1135777pgh.1.2022.11.17.07.16.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 17 Nov 2022 07:16:18 -0800 (PST)
Date: Thu, 17 Nov 2022 15:16:15 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
Message-ID: <Y3ZQP3C1f8pk199t@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-39-seanjc@google.com>
 <88e920944de70e7d69a98f74005b49c59b5aaa3b.camel@intel.com>
 <b198fe971cecd301f0c7c66028cfd71dd7ba7e62.camel@intel.com>
 <Y3PzhANShVlTXVg1@google.com>
 <95ca433349eca601bdd2b16d70f59ba8e56d8e3f.camel@intel.com>
 <Y3UZtoIidMyE8qVz@google.com>
 <7fb66c497b6c41049167b05c63267cbc301b1c20.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7fb66c497b6c41049167b05c63267cbc301b1c20.camel@intel.com>
Cc: "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
 "david@redhat.com" <david@redhat.com>,
 "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "Gao,
 Chao" <chao.gao@intel.com>, "farman@linux.ibm.com" <farman@linux.ibm.com>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "Yao,
 Yuan" <yuan.yao@intel.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "frankja@linux.ibm.com" <frankja@linux.ibm.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>,
 "atishp@atishpatra.org" <atishp@atishpatra.org>,
 "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 "maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Nov 17, 2022, Huang, Kai wrote:
> On Wed, 2022-11-16 at 17:11 +0000, Sean Christopherson wrote:
> > static int kvm_x86_check_processor_compatibility(void)
> > {
> >         int cpu = smp_processor_id();
> >         struct cpuinfo_x86 *c = &cpu_data(cpu);
> > 
> >         /*
> >          * Compatibility checks are done when loading KVM and when enabling
> >          * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
> >          * compatible, i.e. KVM should never perform a compatibility check on
> >          * an offline CPU.
> >          */
> >         WARN_ON(!cpu_online(cpu));
> 
> Looks good to me.  Perhaps this also can be removed, though.

Hmm, it's a bit superfluous, but I think it could fire if KVM messed up CPU
hotplug again, e.g. if the for_each_online_cpu() => IPI raced with CPU unplug.

> And IMHO the removing of WARN_ON(!irq_disabled()) should be folded to the patch
> "[PATCH 37/44] KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section". 
> Because moving from STARTING section to ONLINE section changes the IRQ status
> when the compatibility check is called.

Yep, that's what I have coded up, just smushed it all together here.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
