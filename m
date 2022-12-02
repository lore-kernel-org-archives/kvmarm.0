Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97854C4321E
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 16:31:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0095F4B1B7;
	Fri,  2 Dec 2022 11:31:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9tbTSsJ+932y; Fri,  2 Dec 2022 11:31:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D5849E34;
	Fri,  2 Dec 2022 11:31:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F5CB411C7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 11:31:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8PuSQtuDECT4 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 11:31:23 -0500 (EST)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C4CF40E00
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 11:31:23 -0500 (EST)
Received: by mail-pg1-f181.google.com with SMTP id 136so4801593pga.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Dec 2022 08:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=RsaZyzKJOuyFVoAfYZw39HCTNem7JcJUeEd5tgG0e8Y=;
 b=JuBGytq8t5tr5SVnzdgiUWfOnnv3YoaxJ/EPOkhREUxf0Lu7Q36UoNdircCDscdJe1
 Ne3pPvJP46804SbaTNQC7CD0nyOf+6DUf7RttT6MnjeqYf2tKeLulPmMzXN6C0vzpI5a
 kmqZ1b2nEnQBpLkucgI+K9CNuj0M6idXU9Z/tpGiUmJvFfSAKZUEJ0tYDDD5QTm1XgZh
 KUg4c1fCmmWL1AfPqQe/Q+7M8gt59bLLwzR5wrgb2mkyqnFKW9rqK8zn1jiKosWg6tGN
 xvGvpF7x1Z6otoY0Ddi4ibaMdJj9vaSCpFDZW9nFUZDm9ecAOG+G1OAJWfl9eXVsVqrU
 2Qew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=RsaZyzKJOuyFVoAfYZw39HCTNem7JcJUeEd5tgG0e8Y=;
 b=WIqnIXg+W1pEnTCVj7azZKtEDM6EWdSqEK0KTh2oWHJL7FAiARSEaw3c3OjCfMlK4b
 QB3I/TSexSkpGwzqZQ6eUQcRQEf780D3by+D07mEncnRlXoDoP2S+WA0DrBwehWcYNLz
 QVes/DrYnlVZ1MLP3KfBbq5hjo6EXeL2L8iBHO9ncKbGj71eyqTxN7p8Z5Gez3PBJDcl
 R8rPybkEHDxoCEehWQi1pZPfuBx70rG2scLDVThhGVZKOdbw4VcEH4sDaJgEAnMzgFrf
 QNH6jNtlhJ9Ie8TeHJ/5MCstiMWF1mWFCyyRhOwCC6vPdyOGrctmhFdPBe5exBHnx1mq
 dYWQ==
X-Gm-Message-State: ANoB5plW1Ctw9UVpDLmoyz19wF9gs2ISyo9rOTHE/hqQhcAxJXilrhti
 XJwxtEoSgVJGLeDfcKKaxeP/KQ==
X-Google-Smtp-Source: AA0mqf5YDkgE2z83Sno75+zaFki0bhnK0sTw98u0yDu/SzUnzr69GggIhlhUBJVYlhlyDIQeZ9Y6nA==
X-Received: by 2002:a65:5601:0:b0:43c:4eef:bac7 with SMTP id
 l1-20020a655601000000b0043c4eefbac7mr46619641pgs.356.1669998682344; 
 Fri, 02 Dec 2022 08:31:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 g204-20020a6252d5000000b005756a67e227sm5438977pfb.90.2022.12.02.08.31.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 02 Dec 2022 08:31:21 -0800 (PST)
Date: Fri, 2 Dec 2022 16:31:18 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [PATCH v2 42/50] KVM: Disable CPU hotplug during hardware
 enabling/disabling
Message-ID: <Y4ooVrDTkscy68vg@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-43-seanjc@google.com>
 <8b1053781e859aa95a08c10b0e8a06912a2b42a2.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8b1053781e859aa95a08c10b0e8a06912a2b42a2.camel@intel.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Dec 02, 2022, Huang, Kai wrote:
> On Wed, 2022-11-30 at 23:09 +0000, Sean Christopherson wrote:
> > From: Chao Gao <chao.gao@intel.com>
> > 
> > Disable CPU hotplug when enabling/disabling hardware to prevent the
> > corner case where if the following sequence occurs:
> > 
> >   1. A hotplugged CPU marks itself online in cpu_online_mask
> >   2. The hotplugged CPU enables interrupt before invoking KVM's ONLINE
> >      callback
> >   3  hardware_{en,dis}able_all() is invoked on another CPU
> > 
> > the hotplugged CPU will be included in on_each_cpu() and thus get sent
> > through hardware_{en,dis}able_nolock() before kvm_online_cpu() is called.
> 
> Should we explicitly call out what is the consequence of such case, otherwise
> it's hard to tell whether this truly is an issue?
>
> IIUC, since now the compatibility check has already been moved to
> kvm_arch_hardware_enable(), the consequence is hardware_enable_all() will fail
> if the now online cpu isn't compatible, which will results in failing to create
> the first VM.  This isn't ideal since the incompatible cpu should be rejected to
> go online instead.

Actually, in that specific scenario, KVM should not reject the CPU.  E.g. if KVM
is autoloaded (common with systemd and/or qemu-kvm installed), but not used by
userspace, then KVM is overstepping by rejecting the incompatible CPU since the
user likely cares more about onlining a CPU than they do about KVM.

> > KVM currently fudges around this race by keeping track of which CPUs have
> > done hardware enabling (see commit 1b6c016818a5 "KVM: Keep track of which
> > cpus have virtualization enabled"), but that's an inefficient, convoluted,
> > and hacky solution.

...

> > +	/*
> > +	 * Compatibility checks are done when loading KVM and when enabling
> > +	 * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
> > +	 * compatible, i.e. KVM should never perform a compatibility check on
> > +	 * an offline CPU.
> > +	 */
> > +	WARN_ON(!cpu_online(cpu));
> 
> IMHO this chunk logically should belong to previous patch.  IIUC disabling CPU
> hotplug during hardware_enable_all() doesn't have relationship to this WARN().

Hmm, yeah, I agree.  I'll move it.

> >  static int hardware_enable_all(void)
> >  {
> >  	int r = 0;
> >  
> > +	/*
> > +	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
> > +	 * is called, and so on_each_cpu() between them includes the CPU that
> > +	 * is being onlined.  As a result, hardware_enable_nolock() may get
> > +	 * invoked before kvm_online_cpu(), which also enables hardware if the
> > +	 * usage count is non-zero.  Disable CPU hotplug to avoid attempting to
> > +	 * enable hardware multiple times.
> 
> It won't enable hardware multiple times, right?  Since hardware_enable_nolock()
> has below check:
> 
>         if (cpumask_test_cpu(cpu, cpus_hardware_enabled))                      
>                 return;                                                        
>                                                                                                                                                    
>         cpumask_set_cpu(cpu, cpus_hardware_enabled);     
> 
> IIUC the only issue is the one that I replied in the changelog.
> 
> Or perhaps I am missing something?

You're not missing anything in terms of code.  What the comment means by "attempting"
in this case is calling hardware_enable_nolock().  As called out in the changelog,
guarding against this race with cpus_hardware_enabled is a hack, i.e. KVM should
not have to rely on a per-CPU flag.

 : KVM currently fudges around this race by keeping track of which CPUs have
 : done hardware enabling (see commit 1b6c016818a5 "KVM: Keep track of which
 : cpus have virtualization enabled"), but that's an inefficient, convoluted,
 : and hacky solution.

I actually considered removing the per-CPU flag, but decided not to because it's
simpler to blast

	on_each_cpu(hardware_disable_nolock, ...)

in kvm_reboot() and if enabling hardware fails on one or more CPUs, and taking a
#UD on VMXOFF in the latter case is really unnecessary, i.e. the flag is nice to
have for other reasons.

That said, after this patch, KVM should be able to WARN in the enable path.  I'll
test that and do a more thorough audit; unless I'm missing something, I'll add a
patch to do:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b8c6bfb46066..ee896fa2f196 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5027,7 +5027,7 @@ static int kvm_usage_count;
 
 static int __hardware_enable_nolock(void)
 {
-       if (__this_cpu_read(hardware_enabled))
+       if (WARN_ON_ONCE(__this_cpu_read(hardware_enabled)))
                return 0;
 
        if (kvm_arch_hardware_enable()) {

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
