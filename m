Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E69E33A036
	for <kvmarm@lists.linux.dev>; Fri, 24 Oct 2025 16:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761325044; cv=none; b=ks93vhEIr4T7js8BSXsekB74qRj9tH/8j5TJ1d05TW72qU4aCiOw8ANcWTx1Wk5R3gsGe2AmaImCWfFxXJ8UPqiKbZhscOUSze4b16QvfM3vTPGCaOBacnWRzpxVzbKk8gAvxo/zTX4gmn+SjXDWlIC+J7NiDOod6azGXRiGv38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761325044; c=relaxed/simple;
	bh=znxPntvSK0iLuvDlLrIc6oUoFoqXWddOvlpeLWfjD/8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=APrPzk8PtUlf8j//O869PiNC5oeygFTvED1eoH5oYcYGNiPIg9OoF5l7wdbo/4wuifZblvZBXs476jvnkUPMLHW9X6gDy3r4FTsCIO+2tfbSCAR8dRK3fGB0jYufKz8D+Lx9BrNaJWf+TMgg4Zp38isROWq4CNWysdw6pk+DnIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lXsDjtKh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lXsDjtKh"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bba464b08so2210950a91.0
        for <kvmarm@lists.linux.dev>; Fri, 24 Oct 2025 09:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761325041; x=1761929841; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kCSFoTED+bN9czctrBnViFjaUxjZI+PzjY/BcjiPyhU=;
        b=lXsDjtKhCaY1rBJc2jqehOuknakz0A98ZaSpRzNq1GsPDmAUV2o+6BPsaH8P/FcxuT
         Lc7hg0U6P4tJ1Xv7CzOGMsh8Q7YdEWHUIgWF6GsCh4swV4RdE7aUlTbkQNEKYlaWKyd5
         hVWmCQ2IMBG/eQKi/v03ejeMX2dvcih2ZhfY32v6z0VWMm5azYVVi9QpxIVs662H+dCN
         fTlG06Op9BL5KkezFF62XjC1NM4jmYmJdBP6XZ2/4YtjNE20sRxTgXzdA5N6JVLo6QFf
         a4kpSl+pE2lGhs94yyBx0dQAZpimQtQZIYNtPXza0c0TjDic3hKOWFtrmu4D0oDpdUUU
         RR9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761325041; x=1761929841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kCSFoTED+bN9czctrBnViFjaUxjZI+PzjY/BcjiPyhU=;
        b=Wkr1buJT25/3gnTMWkMi3hR/S2spj2y4naubu/GhsaofS03PagLrO6RQATcjxDdCc6
         8Q1cU5CFJYoQZKxSIiZDLph3Aed2g54RA6B5P5gPb3ONcOs1gCRGRq6DOneXD34eoSm+
         EfCN1BMlH6g2v90Vxv2IKQKNzOeRwtbnbVXyXs1EFjiP69U5YCiqPSeu7FATnD0/Dh19
         ZgnwxUuLTaI/YD8b9aacqfNcNW3riQ3LFNPI6Gm2u/JODiAOXL4FCMy4jXYWr5MmMPVA
         m+iUM18SlRcnDj1GS2IgkMhnBpZeujMZ9uRLg/+V/uq4vpkeiPq1f3EA83EEEDqlLFE3
         LCzQ==
X-Forwarded-Encrypted: i=1; AJvYcCU02ZQaMeU/RNNkYaj8NL/qA41SH50vkgVZeGqBgBhtZpYQVsmCXj4YQxqoHarB2pr1jdOW2A4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwN8aId+WHTGZFUUTibWYPL0clfq2/qoQa/3jgqu247+j3m/E3T
	sh6CAZk0wIWmX/lBxT2V0aZiCsnOBO36cLFiSyKeCvQvsu/hqpCauqoJanpznA2DgCnCG5kNLyP
	qqCzvgw==
X-Google-Smtp-Source: AGHT+IHXmSeD3kNK6POSE1hGR7Jvio0RnirzUH7WSrLaKZ09lPaFZJIUb09S/aBT/hnx0ZxmJITFzdMKVRo=
X-Received: from pjnu4.prod.google.com ([2002:a17:90a:8904:b0:339:dc19:ae5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:48c8:b0:33b:ba55:f5dd
 with SMTP id 98e67ed59e1d1-33bcf93ab88mr32766320a91.37.1761325041555; Fri, 24
 Oct 2025 09:57:21 -0700 (PDT)
Date: Fri, 24 Oct 2025 09:57:20 -0700
In-Reply-To: <aPtOtzGLigbY0Vqw@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-25-seanjc@google.com>
 <aPtOtzGLigbY0Vqw@yzhao56-desk.sh.intel.com>
Message-ID: <aPuv8F8iDp3SLb9q@google.com>
Subject: Re: [PATCH v3 24/25] KVM: TDX: Guard VM state transitions with "all"
 the locks
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 24, 2025, Yan Zhao wrote:
> On Thu, Oct 16, 2025 at 05:32:42PM -0700, Sean Christopherson wrote:
> > Acquire kvm->lock, kvm->slots_lock, and all vcpu->mutex locks when
> > servicing ioctls that (a) transition the TD to a new state, i.e. when
> > doing INIT or FINALIZE or (b) are only valid if the TD is in a specific
> > state, i.e. when initializing a vCPU or memory region.  Acquiring "all"
> > the locks fixes several KVM_BUG_ON() situations where a SEAMCALL can fail
> > due to racing actions, e.g. if tdh_vp_create() contends with either
> > tdh_mr_extend() or tdh_mr_finalize().
> > 
> > For all intents and purposes, the paths in question are fully serialized,
> > i.e. there's no reason to try and allow anything remotely interesting to
> > happen.  Smack 'em with a big hammer instead of trying to be "nice".
> > 
> > Acquire kvm->lock to prevent VM-wide things from happening, slots_lock to
> > prevent kvm_mmu_zap_all_fast(), and _all_ vCPU mutexes to prevent vCPUs
> slots_lock to prevent kvm_mmu_zap_memslot()?
> kvm_mmu_zap_all_fast() does not operate on the mirror root.

Oh, right.

> We may have missed a zap in the guest_memfd punch hole path:
> 
> The SEAMCALLs tdh_mem_range_block(), tdh_mem_track() tdh_mem_page_remove()
> in the guest_memfd punch hole path are only protected by the filemap invaliate
> lock and mmu_lock, so they could contend with v1 version of tdh_vp_init().
>
> (I'm writing a selftest to verify this, haven't been able to reproduce
> tdh_vp_init(v1) returning BUSY yet. However, this race condition should be
> theoretically possible.)
> 
> Resources              SHARED  users              EXCLUSIVE users
> ------------------------------------------------------------------------
> (1) TDR                tdh_mng_rdwr               tdh_mng_create
>                        tdh_vp_create              tdh_mng_add_cx
>                        tdh_vp_addcx               tdh_mng_init
>                        tdh_vp_init(v0)            tdh_mng_vpflushdone
>                        tdh_vp_enter               tdh_mng_key_config
>                        tdh_vp_flush               tdh_mng_key_freeid
>                        tdh_vp_rd_wr               tdh_mr_extend
>                        tdh_mem_sept_add           tdh_mr_finalize
>                        tdh_mem_sept_remove        tdh_vp_init(v1)
>                        tdh_mem_page_aug           tdh_mem_page_add
>                        tdh_mem_page_remove
>                        tdh_mem_range_block
>                        tdh_mem_track
>                        tdh_mem_range_unblock
>                        tdh_phymem_page_reclaim
> 
> Do you think we can acquire the mmu_lock for cmd KVM_TDX_INIT_VCPU?

Ugh, I'd rather not?  Refresh me, what's the story with "v1"?  Are we now on v2?
If this is effectively limited to deprecated TDX modules, my vote would be to
ignore the flaw and avoid even more complexity in KVM.

> > @@ -3155,12 +3198,13 @@ int tdx_vcpu_unlocked_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> >  	if (r)
> >  		return r;
> >  
> > +	CLASS(tdx_vm_state_guard, guard)(kvm);
> Should we move the guard to inside each cmd? Then there's no need to acquire the
> locks in the default cases. 

No, I don't think it's a good tradeoff.  We'd also need to move vcpu_{load,put}()
into the cmd helpers, and theoretically slowing down a bad ioctl invocation due
to taking extra locks is a complete non-issue.
