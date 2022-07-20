Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479C0C43334
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 21:17:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CE464D907;
	Wed, 20 Jul 2022 17:17:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a0BKbW6f2rV4; Wed, 20 Jul 2022 17:17:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 554674D90B;
	Wed, 20 Jul 2022 17:17:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FFDC4D908
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 17:17:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lRi8oTNb-BrU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 17:17:06 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3478A4D907
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 17:17:06 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id
 q43-20020a17090a17ae00b001f1f67e053cso3443136pja.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 14:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NaR9N4OauE6F0T95oi/viHvYl6qf1E4qOLQi4oxNhhA=;
 b=mrbEd58TiGtptOCoPLCXhfpXmWL49rNjaSwJG208LF+R4TIixb2rVR7TzJRgou4fHW
 PipSq09eCo0Mdd49eis1z42PYzkWmgRH5uwqBWxE/6U3O2Cfy1tMn+94neVjuL8CrckM
 d+I2u9iLudGhmsEsmJ5ChL8udKBuh3TMg1ehs0ukp4KQXyvZ1LeC6yvR9DBMOh9FDtYv
 u3SwP/6g6zQIulQGL42uGaBJaP/+SEw+/pskUr69kQGUPbKss7VW6jqk7UhsspSMYMJC
 tHRCErtwKmKL/mlpbOWyDSNTXyILnlM/ZEHypjrEorKszAMp8Y8EspKW5UXDeawAN4RL
 4r8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NaR9N4OauE6F0T95oi/viHvYl6qf1E4qOLQi4oxNhhA=;
 b=wMJCHNgHS4w4jQZIyFbiTTlLzblw830McvXSdQWS6E+f6FtrnHiLd44cbSNPn4zh7+
 ATZOY9K9toZqls3PsVIBAWy2XGctWZRLytjTYDmovMc9ZmtrvXh8NUAcDXUBUO3rziX0
 x7fT973YXthoR94nqBtIulxsH0Ei0DYYKo4x3obP3mQm1ZpKaI+/YLwkfmjXagUBCjtp
 XpElIVPlDP6qWXQbItzjaBMMgad8BFDRIGr5ywchBpimsSKiu085LqcPeX+Jwl/F+YoA
 DdXHYrW2emkiaAQqVoA9SELcxB7lfrcxwu98Bdlt4sKyEsn6aZ0cDRdVe4e/KiXmNtK4
 Mqqw==
X-Gm-Message-State: AJIora/73WjoNAN9YRhPQJZud2iRcxc48eghmV7VARHJcLlaZzD3VDz2
 aLnYWRhI8udYGozxLD3913KC/Q==
X-Google-Smtp-Source: AGRyM1svtaT0JDNnzpkJnrm0ReeF5LwlQes8hUEBf/V2rbihL8ZE5dTWTWPWSE3br/M9nX23k69eog==
X-Received: by 2002:a17:902:a3cc:b0:16d:1af4:6359 with SMTP id
 q12-20020a170902a3cc00b0016d1af46359mr7373088plb.56.1658351824738; 
 Wed, 20 Jul 2022 14:17:04 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 o10-20020a634e4a000000b00401a9bc0f33sm12131866pgl.85.2022.07.20.14.17.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 20 Jul 2022 14:17:04 -0700 (PDT)
Date: Wed, 20 Jul 2022 21:17:00 +0000
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 00/24] KVM: arm64: Introduce pKVM shadow state at EL2
Message-ID: <YthwzIS18mutjGhN@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <YsXfyVp6sg5XRVAp@google.com>
 <20220708162359.GA6286@willie-the-truck>
 <YtbXtI/lEnNL7fHQ@google.com>
 <20220720184859.GD16603@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220720184859.GD16603@willie-the-truck>
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Andy Lutomirski <luto@amacapital.net>,
 linux-arm-kernel@lists.infradead.org, Michael Roth <michael.roth@amd.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

On Wed, Jul 20, 2022, Will Deacon wrote:
> Hi Sean,
> 
> On Tue, Jul 19, 2022 at 04:11:32PM +0000, Sean Christopherson wrote:
> > Or maybe just "pkvm"?
> 
> I think the "hyp" part is useful to distinguish the pkvm code running at EL2
> from the pkvm code running at EL1. For example, we have a 'pkvm' member in
> 'struct kvm_arch' which is used by the _host_ at EL1.

Right, my suggestion was to rename that to pkvm_handle to avoid a direct conflict,
and then that naturally yields the "pkvm_handle => pkvm_vm" association.  Or are
you expecting to shove more stuff into the that "pkvm" struct?
 
> So I'd say either "pkvm_hyp" or "hyp" instead of "shadow". The latter is
> nice and short...

I 100% agree that differentating between EL1 and EL2 is important for functions,
structs and global variables, but I would argue it's not so important for fields
and local variables where the "owning" struct/function provides that context.  But
that's actually a partial argument for just using "hyp".

My concern with just using e.g. "kvm_hyp" is that, because non-pKVM nVHE also has
the host vs. hyp split, it could lead people to believe that "kvm_hyp" is also
used for the non-pKVM case.

So, what about a blend?  E.g. "struct pkvm_hyp_vcpu *hyp_vcpu".  That provides
the context that the struct is specific to the EL2 side of pKVM, most usage is
nice and short, and the "hyp" prefix avoids the ambiguity that a bare "pkvm" would
suffer for EL1 vs. EL2.

Doesn't look awful?

static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
{
	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
	int ret;

	host_vcpu = kern_hyp_va(host_vcpu);

	if (unlikely(is_protected_kvm_enabled())) {
		struct pkvm_hyp_vcpu *hyp_vcpu;
		struct kvm *host_kvm;

		host_kvm = kern_hyp_va(host_vcpu->kvm);

		hyp_vcpu = pkvm_load_hyp_vcpu(host_kvm->arch.pkvm.handle,
					      host_vcpu->vcpu_idx);
		if (!hyp_vcpu) {
			ret = -EINVAL;
			goto out;
		}

		flush_pkvm_guest_state(hyp_vcpu);

		ret = __kvm_vcpu_run(shadow_vcpu);

		sync_pkvm_guest_state(hyp_vcpu);

		pkvm_put_hyp_vcpu(shadow_state);
	} else {
		/* The host is fully trusted, run its vCPU directly. */
		ret = __kvm_vcpu_run(host_vcpu);
	}

out:
	cpu_reg(host_ctxt, 1) =  ret;
}

	
 
> > I think that's especially viable if you do away with
> > kvm_shadow_vcpu_state.  As of this series at least, kvm_shadow_vcpu_state is
> > completely unnecessary.  kvm_vcpu.kvm can be used to get at the VM, and thus pKVM
> > state via container_of().  Then the host_vcpu can be retrieved by using the
> > vcpu_idx, e.g.
> > 
> > 	struct pkvm_vm *pkvm_vm = to_pkvm_vm(pkvm_vcpu->vm);
> > 	struct kvm_vcpu *host_vcpu;
> > 
> > 	host_vcpu = kvm_get_vcpu(pkvm_vm->host_vm, pkvm_vcpu->vcpu_idx);
> 
> Using container_of() here is neat; we can definitely go ahead with that
> change. However, looking at this in more detail with Fuad, removing
> 'struct kvm_shadow_vcpu_state' entirely isn't going to work:

> > struct kvm_vcpu *pkvm_vcpu_load(pkvm_handle_t handle, unsigned int vcpu_idx)
> > {
> > 	struct kvm_vpcu *pkvm_vcpu = NULL;
> > 	struct kvm *vm;
> > 
> > 	hyp_spin_lock(&pkvm_global_lock);
> > 	vm = pkvm_get_vm(handle);
> > 	if (!vm || atomic_read(&vm->online_vcpus) <= vcpu_idx)
> > 		goto unlock;
> > 
> > 	pkvm_vcpu = kvm_get_vcpu(vm, vcpu_idx);
> 
> kvm_get_vcpu() makes use of an xarray to hold the vCPUs pointers and this is
> really something which we cannot support at EL2 where, amongst other things,
> we do not have support for RCU. Consequently, we do need to keep our own
> mapping from the shad^H^H^H^Hhyp vCPU to the host vCPU.

Hmm, are there guardrails in place to prevent using "unsafe" fields from "struct kvm"
and "struct kvm_vcpu" at EL2?  If not, it seems like embedding the common structs
in the hyp/pkvm-specific structs is going bite us in the rear at some point.

Mostly out of curiosity, I assume the EL2 restriction only applies to nVHE mode?

And waaaay off topic, has anyone explored adding macro magic to generate wrappers
to (un)marshall registers to parameters/returns for the hyp functions?  E.g. it'd
be neat if you could make the code look like this without having to add a wrapper
for every function:

static int handle___kvm_vcpu_run(unsigned long __host_vcpu)
{
	struct kvm_vcpu *host_vcpu = kern_hyp_va(__host_vcpu);
	int ret;

	if (unlikely(is_protected_kvm_enabled())) {
		struct pkvm_hyp_vcpu *hyp_vcpu;
		struct kvm *host_kvm;

		host_kvm = kern_hyp_va(host_vcpu->kvm);

		hyp_vcpu = pkvm_load_hyp_vcpu(host_kvm->arch.pkvm.handle,
					      host_vcpu->vcpu_idx);
		if (!hyp_vcpu)
			return -EINVAL;

		flush_hypervisor_state(hyp_vcpu);

		ret = __kvm_vcpu_run(shadow_vcpu);

		sync_hypervisor_state(hyp_vcpu);
		pkvm_put_hyp_vcpu(shadow_state);
	} else {
		/* The host is fully trusted, run its vCPU directly. */
		ret = __kvm_vcpu_run(host_vcpu);
	}
	return ret;
}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
