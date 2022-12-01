Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD0310F6
	for <kvmarm@lists.linux.dev>; Thu,  1 Dec 2022 16:38:23 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id k79so2362570pfd.7
        for <kvmarm@lists.linux.dev>; Thu, 01 Dec 2022 08:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wz5UjU3Ma0W7cBTZ/63jSNwcUzSf/RN7ETO0YflOK9Q=;
        b=L5oONEpJeyYInhCN8kEGfJ8WS2VPlfmSQI0EIRyACnSb62Ho4uiLAZ+22FZ0LpKSBY
         OanLGdeorUn/O6YHVn5BHqcWoMtKOfzbPKcz+4fsn48JXXYOuwBU81HsoXu4yIA+KxBs
         oNf69ULLkYXBFawHATlUKtmTRlCCGuue7O3x4Uj20kNa312jwW6CLd6dDy2pzPGk3DaL
         y4jm5SpqWS/wMH/C2TjT2ihvVuFcoRw2TnuuxPCYPfzDwkDLPEA8hE11/Idhqhxr7xt0
         rj/FXhrQIb1ypgd2I2CBp8L/oyRKWO3NUq8Jq7LgrgnoUKAu1/kU3hKmcHIeaOcvmDNO
         M6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wz5UjU3Ma0W7cBTZ/63jSNwcUzSf/RN7ETO0YflOK9Q=;
        b=lDVF2X0Xhv3PxjbAc9BXU+rjiUblDungalxQbgf6175pHlKBOurQ0tgFdHVCDTWtNh
         pYSrvex06A3e0L9QcLUM95TFgHJw61+Bg6PjXtZ1lEzXlMtxlS6IYjqgdF8F+D6BGeo1
         PBhGrUBtdPLzWDLXRJOAhk7Qvbb3avoyiJ+VLAL8g9EnwptX1WpQ1bk7l7Z1/j1YWYaL
         GFza6OAGFz7ZxYMU3IYi703EyfqqLheNERrA1WzkXyyQFrFciu0NOx0/n7QPpG56JkWx
         FD2H2n2OUP4m1QGDGXcklIQBaLCeYiou84kR8djfBjf6XnRrMHLRe3fEMU3S8lFBKKQt
         nF1A==
X-Gm-Message-State: ANoB5pkL0cZvUErYjqD8FqhO7Hh9/CUe3MVFAS0suoYd/iOa6vRY0pm/
	Qw5d/1BjoRyTH1wYRzbwWaI0gg==
X-Google-Smtp-Source: AA0mqf7E8VTs9g+yA9GqMgTdFbO4YLYoa36a9KLdCj074cztIQB7gniXVzh1et27ldGMC17rtCxmqQ==
X-Received: by 2002:aa7:8512:0:b0:575:65ff:8831 with SMTP id v18-20020aa78512000000b0057565ff8831mr16235817pfn.80.1669912703144;
        Thu, 01 Dec 2022 08:38:23 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l4-20020a17090a384400b00212c27abcaesm5118172pjf.17.2022.12.01.08.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:38:22 -0800 (PST)
Date: Thu, 1 Dec 2022 16:38:16 +0000
From: Sean Christopherson <seanjc@google.com>
To: Michael Ellerman <mpe@ellerman.id.au>
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
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
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
	linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Fabiano Rosas <farosas@linux.ibm.com>,
	Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 26/50] KVM: PPC: Move processor compatibility check to
 module init
Message-ID: <Y4jXuh4P9Oibki6W@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-27-seanjc@google.com>
 <87cz93snqc.fsf@mpe.ellerman.id.au>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87cz93snqc.fsf@mpe.ellerman.id.au>
Message-ID: <20221201163816.d1CdTmvQ9q2mt89XTgxdQ5E9RcBt-Ua_P6Moqb0Hhys@z>

On Thu, Dec 01, 2022, Michael Ellerman wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > Move KVM PPC's compatibility checks to their respective module_init()
> > hooks, there's no need to wait until KVM's common compat check, nor is
> > there a need to perform the check on every CPU (provided by common KVM's
> > hook), as the compatibility checks operate on global data.
> >
> >   arch/powerpc/include/asm/cputable.h: extern struct cpu_spec *cur_cpu_spec;
> >   arch/powerpc/kvm/book3s.c: return 0
> >   arch/powerpc/kvm/e500.c: strcmp(cur_cpu_spec->cpu_name, "e500v2")
> >   arch/powerpc/kvm/e500mc.c: strcmp(cur_cpu_spec->cpu_name, "e500mc")
> >                              strcmp(cur_cpu_spec->cpu_name, "e5500")
> >                              strcmp(cur_cpu_spec->cpu_name, "e6500")
> 
> I'm not sure that output is really useful in the change log unless you
> explain more about what it is.

Agreed, I got lazy.  I'll write a proper description.
 
> > diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
> > index 57e0ad6a2ca3..795667f7ebf0 100644
> > --- a/arch/powerpc/kvm/e500mc.c
> > +++ b/arch/powerpc/kvm/e500mc.c
> > @@ -388,6 +388,10 @@ static int __init kvmppc_e500mc_init(void)
> >  {
> >  	int r;
> >  
> > +	r = kvmppc_e500mc_check_processor_compat();
> > +	if (r)
> > +		return kvmppc_e500mc;
>  
> This doesn't build:
> 
> linux/arch/powerpc/kvm/e500mc.c: In function ‘kvmppc_e500mc_init’:
> linux/arch/powerpc/kvm/e500mc.c:391:13: error: implicit declaration of function ‘kvmppc_e500mc_check_processor_compat’; did you mean ‘kvmppc_core_check_processor_compat’? [-Werror=implicit-function-declaration]
>   391 |         r = kvmppc_e500mc_check_processor_compat();
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |             kvmppc_core_check_processor_compat
> linux/arch/powerpc/kvm/e500mc.c:393:24: error: ‘kvmppc_e500mc’ undeclared (first use in this function); did you mean ‘kvm_ops_e500mc’?
>   393 |                 return kvmppc_e500mc;
>       |                        ^~~~~~~~~~~~~
>       |                        kvm_ops_e500mc
> linux/arch/powerpc/kvm/e500mc.c:393:24: note: each undeclared identifier is reported only once for each function it appears in

Huh, CONFIG_PPC_E500MC got unselected in the config I use to compile test this
flavor.  I suspect I botched an oldconfig at some point.
 
Anyways, fixed that and the bugs.

Thanks much!

--
Subject: [PATCH] KVM: PPC: Move processor compatibility check to module init

Move KVM PPC's compatibility checks to their respective module_init()
hooks, there's no need to wait until KVM's common compat check, nor is
there a need to perform the check on every CPU (provided by common KVM's
hook).  The compatibility checks are either a nop (Book3S), or simply
check the CPU name stored in the global CPU spec (e500 and e500mc).

Cc: Fabiano Rosas <farosas@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |  1 -
 arch/powerpc/kvm/book3s.c          | 10 ----------
 arch/powerpc/kvm/e500.c            |  4 ++--
 arch/powerpc/kvm/e500mc.c          |  6 +++++-
 arch/powerpc/kvm/powerpc.c         |  2 +-
 5 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index bfacf12784dd..51a1824b0a16 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -118,7 +118,6 @@ extern int kvmppc_xlate(struct kvm_vcpu *vcpu, ulong eaddr,
 extern int kvmppc_core_vcpu_create(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu);
-extern int kvmppc_core_check_processor_compat(void);
 extern int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
                                       struct kvm_translation *tr);
 
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 6d525285dbe8..87283a0e33d8 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -999,16 +999,6 @@ int kvmppc_h_logical_ci_store(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvmppc_h_logical_ci_store);
 
-int kvmppc_core_check_processor_compat(void)
-{
-	/*
-	 * We always return 0 for book3s. We check
-	 * for compatibility while loading the HV
-	 * or PR module
-	 */
-	return 0;
-}
-
 int kvmppc_book3s_hcall_implemented(struct kvm *kvm, unsigned long hcall)
 {
 	return kvm->arch.kvm_ops->hcall_implemented(hcall);
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index c8b2b4478545..0ea61190ec04 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -314,7 +314,7 @@ static void kvmppc_core_vcpu_put_e500(struct kvm_vcpu *vcpu)
 	kvmppc_booke_vcpu_put(vcpu);
 }
 
-int kvmppc_core_check_processor_compat(void)
+static int kvmppc_e500_check_processor_compat(void)
 {
 	int r;
 
@@ -507,7 +507,7 @@ static int __init kvmppc_e500_init(void)
 	unsigned long handler_len;
 	unsigned long max_ivor = 0;
 
-	r = kvmppc_core_check_processor_compat();
+	r = kvmppc_e500_check_processor_compat();
 	if (r)
 		goto err_out;
 
diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
index 57e0ad6a2ca3..4564aa27edcf 100644
--- a/arch/powerpc/kvm/e500mc.c
+++ b/arch/powerpc/kvm/e500mc.c
@@ -168,7 +168,7 @@ static void kvmppc_core_vcpu_put_e500mc(struct kvm_vcpu *vcpu)
 	kvmppc_booke_vcpu_put(vcpu);
 }
 
-int kvmppc_core_check_processor_compat(void)
+int kvmppc_e500mc_check_processor_compat(void)
 {
 	int r;
 
@@ -388,6 +388,10 @@ static int __init kvmppc_e500mc_init(void)
 {
 	int r;
 
+	r = kvmppc_e500mc_check_processor_compat();
+	if (r)
+		goto err_out;
+
 	r = kvmppc_booke_init();
 	if (r)
 		goto err_out;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 5faf69421f13..d44b85ba8cef 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -442,7 +442,7 @@ int kvm_arch_hardware_enable(void)
 
 int kvm_arch_check_processor_compat(void *opaque)
 {
-	return kvmppc_core_check_processor_compat();
+	return 0;
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)

base-commit: 00e4493db7c6163d48d5b45034d1a77e16a1c8dc
-- 

