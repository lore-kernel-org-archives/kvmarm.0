Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA8426FA72
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 14:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740494702; cv=none; b=ReI1rtaMLrxcr8vLaGSLLhoqE4SOtM0RcXZTK47/PBFesI6RQQ8lP5OzYCq+2O4PauBHQsOkhd/bKhXyp8QJxLFplMaEALbMH9f0CGKAosbZkpBQmzWD01XebMTPNxFpzDWkQlChW5Av9qSW4EsT9tQ2Ni27O5Gz3LfO+eZOltY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740494702; c=relaxed/simple;
	bh=JVQ6Hr0btkRg9FyQveqK2uYTu6pLizXhjF4MAm5RJjg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pwVGIbQ+/wsJrerFnBRI2Gy7633FvDmCLtSompDepFEU8iRSXujAfQ+YGu5MwovVy1b4xptsGMhkMztrLTkrvxS42quQjZFyflZ4QK0SsWIstLDd3IZpsjHIrSo7WdT2nZG/j0kjduMi9P/PozsZZi99lL6Tnd9oYR7A48irnKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ErDm6Qnr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ErDm6Qnr"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1c7c8396so11799564a91.0
        for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 06:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740494700; x=1741099500; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NffzjCDpuTmdNSnLuEbvoNsdUgp9uFncpWixfvcrqX0=;
        b=ErDm6Qnr22k+IEMH7rw+JceY/6JGM1BtZxk9OemMdvx8e8Dw6DYt41goWr+00YOe6h
         P5xdKZ604HzPxsOpvY3Rmq3VyE8AFxswqIEqrGbB2giN2Jzt/YNxvCmBpXA857LcRlop
         jt7IhXyKQGytdOFk/F8PzmNHWUMHe/xF3NH90zgYVyOuBHM+5hfL2nf90/4ZbjRXCloR
         HGmdCoRLRfZhHlc7jMCSEROOJDe4iq9yAHiwQTp2nroff8RlQS0ZvWpRaXnUxQF++xCj
         zl5Wx8ksBsNfWwBNN7fTSQWF6VxMe9hsUSo3ofbFvzOo1ZkXW50kZYO73NsFesP+0bwH
         zElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740494700; x=1741099500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NffzjCDpuTmdNSnLuEbvoNsdUgp9uFncpWixfvcrqX0=;
        b=kARh7zT/E89e4VKNXZfq7rEoT74f8koWlQSewAisa+qk7WXEvaY9HW+C5AWKWATuYl
         E5BM4s3LnwVyI7Fu0dGvJx4f+7oYd/oO027Uv+ELTKk1nqS9PyEDK6x7UsHvINDJCWqn
         wrNr1Oe69s3GLa2LE3c4MkNUqQDvj+PliYxTbI3I7lfH1IhMbdWgqGqqdU3Khd/UwHXE
         swb9lCvMlotH+7/N2w2guLaXq1X+QvjBNlHdaY+6aetFxubQIcSwUoks25q4N8xDgpC4
         5ICmYgjFzWoaY7xD8ua54qWDE3lsAgCzADboJBtzC25bKb7E0zCIw6XIpMBMv31pn8Ms
         /GXg==
X-Forwarded-Encrypted: i=1; AJvYcCWRKysnp5D+4HUVt7f8c6AgwE1gmBpBuELrj9flJgYJaJDO/v4EyEZXr/m0Y1tKt7k0SOhg+IM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAEHTctcJvqJtF8X8j9QCrZvrNShWMHHIM4dtLYocwC6vGAAcQ
	bFcTDiVNjW+5jwu1Voa6Nd1t6g5Ja/3rlnwCXaRIsi3VEDmAJ1AFBrjzBpyDoNnUiwEXNFZluKp
	clQ==
X-Google-Smtp-Source: AGHT+IG2KruXetDYoI9qbCSWmcITW+yhg6mxBcrrqoCenX7IkOOc3aJKkHxPw+LBj1f6DGaIHr4WklpxusU=
X-Received: from pjh14.prod.google.com ([2002:a17:90b:3f8e:b0:2ea:29de:af10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:548f:b0:2ee:d7d3:3008
 with SMTP id 98e67ed59e1d1-2fce86ae5d0mr31991980a91.12.1740494700343; Tue, 25
 Feb 2025 06:45:00 -0800 (PST)
Date: Tue, 25 Feb 2025 06:44:58 -0800
In-Reply-To: <Z71tlzQJISk6PFAL@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com> <20250224235542.2562848-5-seanjc@google.com>
 <Z71tlzQJISk6PFAL@yzhao56-desk.sh.intel.com>
Message-ID: <Z73XaiRZMIi_vyvK@google.com>
Subject: Re: [PATCH 4/7] KVM: x86: Don't load/put vCPU when unloading its MMU
 during teardown
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 25, 2025, Yan Zhao wrote:
> On Mon, Feb 24, 2025 at 03:55:39PM -0800, Sean Christopherson wrote:
> > Don't load (and then put) a vCPU when unloading its MMU during VM
> > destruction, as nothing in kvm_mmu_unload() accesses vCPU state beyond the
> > root page/address of each MMU, i.e. can't possible need to run with the
> > vCPU loaded.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 9 +--------
> >  1 file changed, 1 insertion(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 045c61cc7e54..9978ed4c0917 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12767,13 +12767,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >  	return ret;
> >  }
> >  
> > -static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
> > -{
> > -	vcpu_load(vcpu);
> > -	kvm_mmu_unload(vcpu);
> > -	vcpu_put(vcpu);
> > -}
> > -
> >  static void kvm_unload_vcpu_mmus(struct kvm *kvm)
> >  {
> >  	unsigned long i;
> > @@ -12781,7 +12774,7 @@ static void kvm_unload_vcpu_mmus(struct kvm *kvm)
> >  
> >  	kvm_for_each_vcpu(i, vcpu, kvm) {
> >  		kvm_clear_async_pf_completion_queue(vcpu);
> > -		kvm_unload_vcpu_mmu(vcpu);
> > +		kvm_mmu_unload(vcpu);
> What about just dropping kvm_unload_vcpu_mmu() here?
> kvm_mmu_unload() will be invoked again in kvm_mmu_destroy().
> 
> kvm_arch_vcpu_destroy() --> kvm_mmu_destroy() --> kvm_mmu_unload().

Ugh, I missed that there's yet another call to kvm_mmu_unload().  I definitely
agree with dropping the first kvm_mmu_load(), but I'll do it in a follow-up patch
so that all three changes are isolated (not doing the load/put, doing unload as
part of vCPU destruction, doing unload only once at the end).

And looking at both calls to kvm_mmu_unload(), I suspect that grabbing kvm->srcu
around kvm_mmu_destroy() is unnecessary.  I'll try cleaning that up as well.
