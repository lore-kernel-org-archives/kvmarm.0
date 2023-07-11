Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB7B14AB5
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 14:25:28 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5704e551e8bso64873967b3.3
        for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 07:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689085527; x=1691677527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p56sBbCS+VPrS5cOX2wwAyiH2Cg/fGXPAAbSLjc9HmQ=;
        b=G9ZmthhhEWojkB7p9qdG0NlmayOu64h8X2dBXxGMYbiFdGXXEUX2oyzC6fFrumID5N
         98vlOxYGDbsB8BsZYbCu5+cNjdgpXDDF3wPvFmpX1D/3wiXeEI7iIbWaLd2Y8S1kcK51
         g9AEp3AGfRn3IH5ErdyFegxvkav3Hez4Pqo60UTx9c8Mo77h2wLDQUn/qNlpfbjeYv3l
         BXG4TLJ1lnjA9oyO1JcxOVrUNvF1oP+UeGFwZ78x/HxF67SpfkkngNuMfv0ud6ParpnM
         ur81S62LVTRhXeUfmkPypJAXBF0q5GmQYpveV1kpJbP42oZcLd7cONmfF2+Ipt3sxdG7
         gZpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689085527; x=1691677527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p56sBbCS+VPrS5cOX2wwAyiH2Cg/fGXPAAbSLjc9HmQ=;
        b=Ei5RdsEdGDZv+hSAGb0bYCIe8YdLL/h+uX6rYJCkZTFeSndS95ARhoYub12Syiwhbi
         ABYp7aiU7rb2tUtZPFi2bQK4QWlqZwX5h9zmH8nU/Oq7W8IpA3SUw1o1QqCap/neqQd0
         vaC1mtClo0nPfyZDRBEY0imdH5nCNCZuAPwL4qS+wPqNGvDOKcKwlPZIiJ7MtYjwn4wy
         GA8Nh6hjtdb24dIxByRNrNZOZykyN6VX9Gds4Z0z8TlkUEvV0q3OVBrmpU1gGAmmb/KP
         RpqTnlXxnvQVAk8eZPxQPJgwggvrDiYtHfR4R+XT2DqGm1wnly+KNRzFQL44bnBKfMwk
         oTCQ==
X-Gm-Message-State: ABy/qLY/QoeD6TA/EDnY06CX1W/kpcgeTgfa9Yi/xqynqv2nc9jcexEX
	7wun3gmQgjPrvIgHRIlrDRVcn+FBF6w=
X-Google-Smtp-Source: APBJJlGypUsi6FziBQD/5n1q9oaBq8wtOZmggi8VuvEfNqxbkCHQTwUdZQaONZSNZ8Qt3Y2NvWdpI/kBNjM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac44:0:b0:55d:6af3:1e2c with SMTP id
 z4-20020a81ac44000000b0055d6af31e2cmr126252ywj.3.1689085527641; Tue, 11 Jul
 2023 07:25:27 -0700 (PDT)
Date: Tue, 11 Jul 2023 07:25:26 -0700
In-Reply-To: <ZKzSf82kuik7wYkA@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <ZKf7+D474ESdNP3D@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <CAF7b7mr7BZayOxE2y8K87+AfYuGoDc7_kA2ouA3kBuhSgDiomg@mail.gmail.com> <ZKzSf82kuik7wYkA@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Message-ID: <ZK1mVriphYnZu6Cd@google.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From: Sean Christopherson <seanjc@google.com>
To: Kautuk Consul <kconsul@linux.vnet.ibm.com>
Cc: Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 11, 2023, Kautuk Consul wrote:
> > > That said, I agree that there's a risk that KVM could clobber vcpu->run_run by
> > > hitting an -EFAULT without the vCPU loaded, but that's a solvable problem, e.g.
> > > the helper to fill KVM_EXIT_MEMORY_FAULT could be hardened to yell if called
> > > without the target vCPU being loaded:
> > >
> > >     int kvm_handle_efault(struct kvm_vcpu *vcpu, ...)
> > >     {
> > >         preempt_disable();
> > >         if (WARN_ON_ONCE(vcpu != __this_cpu_read(kvm_running_vcpu)))
> > >             goto out;
> > >
> > >         vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> > >         ...
> > >     out:
> > >         preempt_enable();
> > >         return -EFAULT;
> > >     }
> > 
> > Ancient history aside, let's figure out what's really needed here.
> > 
> > > Why use WARN_ON_ONCE when there is a clear possiblity of preemption
> > > kicking in (with the possibility of vcpu_load/vcpu_put being called
> > > in the new task) before preempt_disable() is called in this function ?
> > > I think you should use WARN_ON_ONCE only where there is some impossible
> > > or unhandled situation happening, not when there is a possibility of that
> > > situation clearly happening as per the kernel code.
> > 
> > I did some mucking around to try and understand the kvm_running_vcpu
> > variable, and I don't think preemption/rescheduling actually trips the
> > WARN here? From my (limited) understanding, it seems that the
> > thread being preempted will cause a vcpu_put() via kvm_sched_out().
> > But when the thread is eventually scheduled back in onto whatever
> > core, it'll vcpu_load() via kvm_sched_in(), and the docstring for
> > kvm_get_running_vcpu() seems to imply the thing that vcpu_load()
> > stores into the per-cpu "kvm_running_vcpu" variable will be the same
> > thing which would have been observed before preemption.
> > 
> > All that's to say: I wouldn't expect the value of
> > "__this_cpu_read(kvm_running_vcpu)" to change in any given thread. If
> > that's true, then the things I would expect this WARN to catch are (a)
> > bugs where somehow the thread gets scheduled without calling
> > vcpu_load() or (b) bizarre situations (probably all bugs?) where some
> > vcpu thread has a hold of some _other_ kvm_vcpu* and is trying to do
> > something with it.
> Oh I completely missed the scheduling path for KVM.
> But since vcpu_put and vcpu_load are exported symbols, I wonder what'll
> happen when there are calls to these functions from places other
> than kvm_sched_in() and kvm_sched_out() ? Just thinking out loud.

Invoking this helper without the target vCPU loaded on the current task would be
considered a bug.  kvm.ko exports a rather disgusting number of symbols purely for
use by vendor modules, e.g. kvm-intel.ko and kvm-amd.ko on x86.  The exports are
not at all intended to be used by non-KVM code, i.e. any such misuse would also be
considered a bug.
