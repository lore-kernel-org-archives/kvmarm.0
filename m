Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF2FC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 15:40:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B552C40EEF;
	Fri,  4 Nov 2022 11:40:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2NhRuVAST4da; Fri,  4 Nov 2022 11:40:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 984B140762;
	Fri,  4 Nov 2022 11:40:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 570A0403AD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:40:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12t8hnBYutku for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 11:40:41 -0400 (EDT)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 134E0402ED
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:40:40 -0400 (EDT)
Received: by mail-pf1-f180.google.com with SMTP id d10so4833513pfh.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 08:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=aFlTeUJ4nQplolWHip6FrS/j8TYR0+QbDmRZAFvu7G8=;
 b=slnKaxTVWka5uyvV8ksftk1iXtqkYG7wonGPtAtNy/P6RP4ZnWhdbZSV/6seXnMCof
 dnF6JUiRfV2oVCETco2jEIOQzRouLfUDiH7vxFD2orQpNLxCcfMVtLr6ntSOZeUo+8A4
 1WMtzeSAIQ00ZBggEzItHUadG+pi52a6RW5LTbSCWNWQHjLySk/BPh9TembQq8ly6ISW
 XBS14fXfAOCGbRuWccsHUKA4no5JdNrqlAYc2mDDTkISHx1kXdJjDDClXTXp09r2HKHF
 4YYshPvOotdfKVbVnw4u/+IsxQ4NAMvmIrkrc7+c9m8NGZEp/7DC/KTLI5ge39pksAS0
 M2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=aFlTeUJ4nQplolWHip6FrS/j8TYR0+QbDmRZAFvu7G8=;
 b=1k9+wL1S7FEqLLDSITVmFpoMbxCsQB3nmGkaJktDxaBeLsqX1Bxn/8U/0lo0Nw2d0i
 9JBuQJA6TSnimRFk3szc8jnSbXfdQVUx8kAg+2Rt/Z9iaXbOIvmtrHyNBc/84o4R5XTV
 GpbE/PiqRevzfByZui/B9KsL1WciHVLiWMg0KzJhm5P4+65M7Wlg9KioNjvOEk0oUv07
 GAUhoihigAMsRwlsia/c9MiTmO2agedEXqrIO/E/zBFK78/WcWG7cUdd+F+jX222/T2s
 luxzkBUxY7ni84QuDB2inUmbT0IfEIeDSw+sivZxdGDmibV5siWdwrRysxGMbR+bsOId
 FxFQ==
X-Gm-Message-State: ACrzQf1sEC3XtSI7xIuPEyfzcUHQ6KashDzh7T+G4CsvUXsvG0+LDY6J
 rM9SCHizs0WZtmY50YFucR537A==
X-Google-Smtp-Source: AMsMyM5MdI5VKNUr37j2LDfWFXfSalVZ70lqDfROHdw5vEhrWbzDEJP2xBkjkN31VBShKB5D+mx4vA==
X-Received: by 2002:a62:1a8d:0:b0:544:1309:19f3 with SMTP id
 a135-20020a621a8d000000b00544130919f3mr36549720pfa.37.1667576439875; 
 Fri, 04 Nov 2022 08:40:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 y133-20020a62ce8b000000b00565cbad9616sm2905778pfg.6.2022.11.04.08.40.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 08:40:39 -0700 (PDT)
Date: Fri, 4 Nov 2022 15:40:36 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 33/44] KVM: x86: Do VMX/SVM support checks directly in
 vendor code
Message-ID: <Y2UydNBFR3e2DAe7@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-34-seanjc@google.com>
 <bfa98587-3b36-3834-a4b9-585a0e0aa56a@redhat.com>
 <Y2QJ2TuyZImbFFvi@google.com>
 <c29e7d40-ddb9-def0-f944-a921a05a4bb2@redhat.com>
 <Y2QPSK1/6esl61wQ@google.com>
 <6c71fcca-c17f-5979-e15e-afcf08899064@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6c71fcca-c17f-5979-e15e-afcf08899064@redhat.com>
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
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On Fri, Nov 04, 2022, Paolo Bonzini wrote:
> On 11/3/22 19:58, Sean Christopherson wrote:
> > 
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index 3e508f239098..ebe617ab0b37 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -191,6 +191,8 @@ static void default_init(struct cpuinfo_x86 *c)
> >                          strcpy(c->x86_model_id, "386");
> >          }
> >   #endif
> > +
> > +       clear_cpu_cap(c, X86_FEATURE_MSR_IA32_FEAT_CTL);
> >   }
> >   static const struct cpu_dev default_cpu = {
> 
> Not needed I think?  default_init does not call init_ia32_feat_ctl.

cpuid_deps is only processed by do_clear_cpu_cap(), so unless there's an explicit
"clear" action, the dependencies will not be updated.  It kinda makes sense since
hardware-based features shouldn't end up with scenarios where a dependent feature
exists but the base feature does not (barring bad KVM setups :-) ).

That said, this seems like a bug waiting to happen, and unless I'm missing something
it's quite straightforward to process all dependencies during setup.  Time to find
out if Boris and co. agree :-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 1a85e1fb0922..c4408d03b180 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -147,6 +147,7 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 
 extern void setup_clear_cpu_cap(unsigned int bit);
 extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
+extern void apply_cpuid_deps(struct cpuinfo_x86 *c);
 
 #define setup_force_cpu_cap(bit) do { \
        set_cpu_cap(&boot_cpu_data, bit);       \
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3e508f239098..28ce31dadd7f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1884,6 +1884,8 @@ static void identify_cpu(struct cpuinfo_x86 *c)
                        c->x86_capability[i] |= boot_cpu_data.x86_capability[i];
        }
 
+       apply_cpuid_deps(c);
+
        ppin_init(c);
 
        /* Init Machine Check Exception if available. */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index c881bcafba7d..7e91e97973ca 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -138,3 +138,13 @@ void setup_clear_cpu_cap(unsigned int feature)
 {
        do_clear_cpu_cap(NULL, feature);
 }
+
+void apply_cpuid_deps(struct cpuinfo_x86 *c)
+{
+       const struct cpuid_dep *d;
+
+       for (d = cpuid_deps; d->feature; d++) {
+               if (!cpu_has(c, d->feature))
+                       clear_cpu_cap(c, d->feature);
+       }
+}

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
