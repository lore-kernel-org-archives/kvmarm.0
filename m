Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.249
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794935190;
	b=TyCSn1LQIPdFehG6LE5kE0PQCFqMoB7NQbLH06wHStPn2j3JAHAJjuF2vOv1QWaSLjJa
	 eOWIH9mE/jBMFhprtaYJhfJEAYpj1YB5Xvwpbk78s9wG/PK9GHo+/cFTysf4cNUDVTnkf
	 1thDf4Wdvj2zI7bxXKF0IR4dRkoPii6T+WACeo2HV96yREUdcEfE6y7TsFHpGpAm3qs7H
	 pE2Tsp5tk7VGM8D4/eOY1iFdVf8Mg5vNrm/pzLZ0bPwxNdkm5VD7csEFXhTBKnHumm/6Y
	 0b9JZicpIq4uE5WaKtxmnnGHpE39SxMRiqmO31ynEd2Y+ez37zGpk+yCyVABB94B6Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935190;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=hixzDBYjex72mbAqfdJ0BMP0XnPJdhglkhJ+5expOLw=;
	b=zQsvFh8GNQE+PHnVuigR+x+1bK68VbIDM+nCYIgSwfKLFInsgMrCxKhVnEOjO8JePleM
	 2iW6Kqyi0tmVZN5p4nDCMqvPspDm0cR6GvAljA4bw0B4StPt3AK7/4CDgzdY7YNl5Fh7a
	 4ixG85VjP1TxU6G+k0WkE3clNOPKu1yOYrKuy+Z10soNmoQtJ9j1ffGQJXrBlhVQgwiRS
	 zRycByTRHSXHKXSpP8dzPSY+S3CyQ9AWoORhUyvsISm3R+lmBhupxdZMiEJPeRQXMH2cD
	 O/fGuFxhEXjERAQI33+AWk0egAuk73yThOtqouAwkDXb8mXtHPuFmhnJoKSDZPxwE/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cVG2SpNc;
	arc=none smtp.remote-ip=91.218.175.249
Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D35606A883
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:06:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75D35606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cVG2SpNc
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CuWYfoaIeUOLVmPy0v9FnC5ISe1ZRoIopzCKCHIxYjE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794935187; v=1; x=1795539987;
 b=cVG2SpNcGfjjeCF6BR9LSWPKUQlaIL7f29o9qhW9jyP3hBCeuxgzG+znoeRY+u0r5u/l3cin
 jN8YMNikwSH1yq0z6DSQq/WNzA5y6LKEMHYvS/c0Fz6nRk/XZ/QWny9UTD7opVjTEJF+tkBus4P
 4Oh1/Zrdci34Epr0qIbUB+vE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8be41952a0f8a6ed;
	Tue, 17 Nov 2026 17:06:27 +0000
X-Mizu-Trace-ID: 8be41952a0f8a6ed
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5c00d7ac49dso9471e87.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:06:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErENHbp1sL/LG4f2ZmLjPd5Jvq+Vg+Ai39Ifccf8i1Yyh/WYAWFcUXSvaMvcNik4JRYyPK3bTs0=@lists.linux.dev
X-Gm-Message-State: APuU4Z/R+I1P2409Ubz8DNo3j9r2Duas711CAoqYW3o/OhpxYeg10f9q
	21uXhCnJlEL66bg04UyNAYi9/jl9rxYA9RtKYop02VBCHA+3YjVp8Q7PXSgVBBdkmUnAO/7BBcc
	sPHl3cidOnhTt/8zNSG/raZ7eFdtIiD9H7laK8FZs
X-Received: by 2002:a05:6512:b8d:b0:5bf:f0fb:2c9c with SMTP id
 2adb3069b0e04-5c1a189bda1mr156069e87.5.1794935186033; Tue, 17 Nov 2026
 09:06:26 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261117074428.7544-1-fuad.tabba@linux.dev> <20261117074428.7544-2-fuad.tabba@linux.dev>
 <avxfgWNePsGPK9mm@gremlin>
In-Reply-To: <avxfgWNePsGPK9mm@gremlin>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 17 Nov 2026 17:05:49 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzUrDxLSMEo6X66XhKtQ-=ew3zZhMdFWR6U9Ga17WLWkw@mail.gmail.com>
X-Gm-Features: AclHuK8hlW_ShztJ0BsSWqDzcCkcDDTWK01dR1LguEsZLGP95yN_yfyBcMKgMpA
Message-ID: <CA+EHjTzUrDxLSMEo6X66XhKtQ-=ew3zZhMdFWR6U9Ga17WLWkw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's
 dirty ring is full
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Lorenzo,

On Tue, 17 Nov 2026 14:23:09 +0000, "Lorenzo Stoakes (ARM)"
<ljs@kernel.org> wrote:
[...]
> > The check also sets run->exit_reason, and arm64's KVM_RUN completes a
> > pending MMIO exit only if exit_reason is still KVM_EXIT_MMIO. If a
> > pre-fault stops on a full ring while an MMIO exit is pending, the next
> > KVM_RUN doesn't complete the exit and the guest repeats the MMIO
> > access. Userspace can avoid that by completing the exit with KVM_RUN
> > before it pre-faults.
>
> That's also true for riscv:
>
>         switch (run->exit_reason) {
>         case KVM_EXIT_MMIO:
>                 /* Process MMIO value returned from user-space */
>                 ret = kvm_riscv_vcpu_mmio_return(vcpu, vcpu->run);
>                 break;
>         case KVM_EXIT_RISCV_SBI:
>                 /* Process SBI value returned from user-space */
>                 ret = kvm_riscv_vcpu_sbi_return(vcpu, vcpu->run);
>                 break;
>         case KVM_EXIT_RISCV_CSR:
>                 /* Process CSR value returned from user-space */
>                 ret = kvm_riscv_vcpu_csr_return(vcpu, vcpu->run);
>                 break;
>         }
>
> (note that it skips CSR, SBI also with a changed exit_reason).

Ack.

> But the overflow bug only applies to x86 (see below), so is this something
> we should worry about at all?

The ring overflows on arm64 too (below). As for exit_reason, I asked
Sean about the arm64 MMIO case on v1, and his answer was that a VMM
that pre-faults between a KVM_EXIT_MMIO return and the next KVM_RUN
"gets to deal with the fallout" [1]. I think the same goes for riscv's
exits.

[...]
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
[...]
> >  The dirty ring can get full.  When it happens, the KVM_RUN of the
> > -vcpu will return with exit reason KVM_EXIT_DIRTY_RING_FULL.
> > +vcpu will return with exit reason KVM_EXIT_DIRTY_RING_FULL, and
> > +KVM_PRE_FAULT_MEMORY on the vcpu will process no more pages until the
> > +ring has been harvested and reset.
>
> Maybe worth mentioning the exit_reason thing if we keep this arch-generic?

Sure, I'll document that userspace should complete a pending exit with
KVM_RUN before it pre-faults on that vCPU.

[...]
> I wonder if this shouldn't just be an x86-only fix, since no other arch is
> impacted AFAICT.
>
> arm64 and riscv never map a dirty-logged memslot writable, so they're never
> pushed to the rin, and s390 doesn't have a dirty ring at all:
>
> arm64:
>
> static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                                      const struct kvm_s2_fault_vma_info *s2vi,
>                                      enum kvm_pgtable_prot *prot)
> {
>         ...
>         if (s2vi->map_writable && (s2vi->device ||
>                                    !memslot_is_logging(s2fd->memslot) ||
>                                    kvm_s2_fault_is_write(s2fd)))
>                 *prot |= KVM_PGTABLE_PROT_W;
>         ...
> }

arm64 does map a logged slot as writable today. memslot_is_logging()
tests memslot->dirty_bitmap, which isn't allocated when only the dirty
ring is enabled, and patch 2's selftest triggers the WARN in
kvm_dirty_ring_push() on arm64 without patch 1. Wei-Lin's fix to
memslot_is_logging() [2] is in kvmarm/fixes, not in mainline yet.

With it, the s2vi->device case above still maps a device page writable
on a read fault in a logged slot. kvm_arch_prepare_memory_region()
rejects logging on a VM_PFNMAP VMA, so that requires userspace to map
the device under the slot after creating it (I haven't tested it).

So I think the check should be in the generic loop.

[...]
> An x86-only version would be pretty simple, something like the below.
>
> This also covers off the retry (RET_PF_RETRY) loop which a generic version
> doesn't.

True. To overflow there, the retries for one page would have to push
more entries than the ring has in reserve (at least 64), and I don't
see a way to get that, so I left it alone.

Cheers,
/fuad

[1] https://lore.kernel.org/all/avs5UD79FB_DG1Vs@seanjc-mac.roam.internal/
[2] https://lore.kernel.org/all/20261029175238.3214788-2-weilin.chang@arm.com/
