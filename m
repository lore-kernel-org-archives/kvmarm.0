Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CDD37649B
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 16:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777827445; cv=none; b=o6c/YfUGUfOQPWN+6ml5SCvfytECuHl0g9IO5RgFi8bvpzq4J6tyAqr7Xaaf5FlWggXrlluoJc86ozF8Ne+VgSK1ZuZVacx9GlGpECyeBWfsqnBmuQcI0uyAntBl6udgnIM119cxp6DUi7/oxrcNvrjekyuitGhcKDo+N/JkvDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777827445; c=relaxed/simple;
	bh=dxYvE74iVdKlUnabVeaymaom4WUqjZShmtH2aclRsVw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UKAW5m89mz3YPCADGuK3BDM+KtPY+aA/q83D0SJHlTD65afkD6cqh8HlCNmYX8ocQgbU9A4tDqNP08DP9+ehQYVQGFbVriedOXoEEmOJdDNx7YT+TgYfH+4qNSDEt+2tOBNMLu3s2f114eOyb2Eq36gyXag5CN9RXsgZp4Za/Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e4jInsue; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e4jInsue"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777827443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZAX/3Dxul6ab0aa4nY+5/E1aKies+ngH//pLM2CQH8=;
	b=e4jInsueDTA2DOhpsbZZ/qz22pGRX5yhg7wAl/IRQALB4ndmYX8Op5sBAbaUgtODVyamMn
	LxqhsmLioZCtGLefUS5EDkH+J/JH1DhCm2Eg4rDFeTCk4b0QRLblj4lzl6TaWMt/MWUVrZ
	v3Jq3uDRPMckAL09aRyRcy4euKLQobQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-EIVc4O4bMImLoefyIEvTtw-1; Sun, 03 May 2026 12:57:20 -0400
X-MC-Unique: EIVc4O4bMImLoefyIEvTtw-1
X-Mimecast-MFC-AGG-ID: EIVc4O4bMImLoefyIEvTtw_1777827439
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-488dcaf2f2fso24787725e9.0
        for <kvmarm@lists.linux.dev>; Sun, 03 May 2026 09:57:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777827439; x=1778432239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wZAX/3Dxul6ab0aa4nY+5/E1aKies+ngH//pLM2CQH8=;
        b=X3dPafM9jQAqoNlJWzylifbUNFFd4La83SGZFoms8/YC1W//rHDSYcYPyDIQPuqN3Y
         yxsT3ELw6EfxIATTPjdOZu53pCezU5q5AoDJCUxXBmfXR8bPNixEEwG/bP8qNu/S80Wj
         +CprUrNBliD1v210vmuGmss79Fp+ONvqJCKxsMtal1iGU9a5hwcX6zJF53AxwnuX3KMo
         XOodMgRLxgoQyQ6DwUka8RkFPQt0g0pERquaofEezQVhDlRMgHhn5eGOLU6YOPe8DCon
         mlmrWBvjCc94UsvwfPrUXHI8gWpG4/Uq3PrEpbCbItkLTNVFeglrP6dBaNEXNGhnQE72
         h3kA==
X-Forwarded-Encrypted: i=1; AFNElJ+zbJbn+13es1f2f8z06+qf2QE4374OG3F7eQQcbLn1eV2zeORqfxZ131tSLqWBjf71Q5qIH+I=@lists.linux.dev
X-Gm-Message-State: AOJu0YxE9uklWYsQfAe/qmSkdDDodzbKeHGr6BE6K+iZn2eD38+ULdQk
	OZuBOJyib1Q37QAjWqQEPUV3t9mU1SLUaDOBMYnZK7weIZRgrgh5cFeEF1qYutk1FKpEOTzNCL8
	DRWNlt4SxKv5WLxnj1hlBWIKZToq0nAPziWwwhl6PUl8gkwjslIDjc3izouM3LiTYRpWuv43fln
	M02WqOa8iTaGN9CIbVRxrRTVaADonUaBlf
X-Gm-Gg: AeBDiesYDozLQRodg9W4pHC1j4OAy+PN85Si1UQ+aRzaHJkshKey17Ot3m5xccwEIqg
	TKjhNu2ZC4IvVoloMYLLCJ6I3ZBUXrDZsWI7OHaPgdl2qrqIQ7QJXvIBQAdpuQ67YFkufyTYLn8
	yaL05dY/692xh5U1OqU5xt6e/peYltNt7y2ImxMbZcwua9xzWe6f2/4iffGVCpPezbks5zc0UP3
	6huySmFPmEOMzpuXVFU1WT8OqKAm2Z4CUPhjq62nB1vlWwbx0My8nFnYW8aoRh1xUmhtk1r61+a
	voToRK+4oknEV0k=
X-Received: by 2002:a05:600c:c0c5:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-48a98662e71mr84651675e9.21.1777827438743;
        Sun, 03 May 2026 09:57:18 -0700 (PDT)
X-Received: by 2002:a05:600c:c0c5:b0:485:30d4:6b9e with SMTP id
 5b1f17b1804b1-48a98662e71mr84651295e9.21.1777827438361; Sun, 03 May 2026
 09:57:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <afEwWZksU0Fw61oT@plex> <0a71472c-b397-4699-a518-61faffcf4ab2@redhat.com>
 <afUNlL_lRDP6olHE@plex>
In-Reply-To: <afUNlL_lRDP6olHE@plex>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 3 May 2026 18:57:06 +0200
X-Gm-Features: AVHnY4LZ9SLOVvMSSNVqrWN2ReqSfwRcQuKsaciqQRZIlDN_XSMAX0q55GthIJg
Message-ID: <CABgObfaqZ8GGaLV_gp8o+nQSe+JfnBbZP0X9cDxdvEpyUZQRnQ@mail.gmail.com>
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	rppt@kernel.org, graf@amazon.com, pratyush@kernel.org, seanjc@google.com, 
	maz@kernel.org, oupton@kernel.org, dwmw2@infradead.org, 
	alex.williamson@redhat.com, kevin.tian@intel.com, rientjes@google.com, 
	Tycho.Andersen@amd.com, anthony.yznaga@oracle.com, baolu.lu@linux.intel.com, 
	david@kernel.org, dmatlack@google.com, mheyne@amazon.de, jgowans@amazon.com, 
	jgg@nvidia.com, pankaj.gupta.linux@gmail.com, kpraveen.lkml@gmail.com, 
	vipinsh@google.com, vannapurve@google.com, corbet@lwn.net, 
	loeser@linux.microsoft.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	roman.gushchin@linux.dev, akpm@linux-foundation.org, pjt@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: h-2O1um6AlvZWcZZ0lp8G2MUX0vwRpKXv_8nIgZrRwo_1777827439
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 1, 2026 at 11:48=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
> The way I see it, vmfd and vcpufd need to support LUO preservation by
> implementing the liveupdate_file_ops callbacks (.preserve, .restore).
>
> When userspace preserves the vcpufd, the kernel isolates the assigned
> pCPU (probably requiring the vCPU to be pinned to the CPU, and the CPU
> to be in an isolated cpuset),

Generally speaking vCPUs do not care if they are pinned. Do we need a
preparatory ioctl for this on the vcpufd side, even just a
KVM_ENABLE_CAP or a new bit for
KVM_ENABLE_CAP(KVM_CAP_X86_DISABLE_EXITS)?  If
LIVEUPDATE_SESSION_PRESERVE_FD suddenly can start offlining pCPUs,
that would require a capability check.

> Even for this simplest form, we still need a defined ABI between the
> host kernel and the Caretaker. The host must send an IPI to
> synchronously notify the Caretaker of attach and detach transitions.

Yes, but it's unlikely to need stability unlike the KHO serialization.

> This ABI must also handle Caretaker replacement during the adoption
> phase: when the new kernel retrieves the vCPU, it requires a protocol to
> notify the running Caretaker that the pCPU is being onlined. The
> Caretaker must reach a known, state at that moment so the kernel can
> seamlessly replace the previous kernel's Caretaker version with the
> current one. Finally, the Caretaker still relies on the CCB to access
> KVM routing pointers for forwarding VM exits back to the host during
> normal operation.

I'm not sure if routing pointers are needed, as opposed to just a
call/ret (ignoring detachment and reattachment which are different
anyway). In the end, the x86 caretaker is basically the
non-preemptable part of vcpu_enter_guest(). Even once you add
attach/detach, the body of code that runs in the caretaker is roughly
the same and what changes is setting up the address space, the IDT,
etc.

> > This must be done atomically at the time Linux offlines/onlines a pCPU.=
 The
> > interface from Linux to the caretaker must use some kind of IPI so that=
 the
> > new kernel can force a VMEXIT (if needed) in the caretaker, ask it to
> > serialize the vm state, and pass it down to the new kernel's caretaker.
>
> Yes, agree.

BTW, the same IPI is needed to force a VMEXIT even before kexec, if
the old kernel does anything that breaks the running VM such as
madvise(MADV_FREE).  Should not happen with properly behaving
userspace, but it must be accounted for.

> During the kexec gap (when the host kernel is completely offline), the
> Caretaker acts purely as a producer, writing trace events directly to
> this physical memory block and advancing the ring buffer pointers.
>
> When the new kernel boots and re-adopts the orphaned vCPU, it retrieves
> this memory from KHO and attaches it back to the tracing subsystem.

Yes, this should work with remote trace buffers.

> I agree regarding HLT: during the gap, the simplest approach is to just
> skip the exit and return directly to the VM without attempting to handle
> it.

Or even disable intercepts for HLT/PAUSE/MONITOR/MWAIT.

> I completely agree that the transition into and out of the gap must be
> synchronous. As discussed above, using an IPI is the right approach. For
> entry, the host kernel signals the Caretaker via IPI to ensure it
> reaches a known state before the pCPU is offlined.

And then does INIT/SIPI on the offlined pCPU to re-enter the caretaker
in detached mode.

> For exit, the new
> kernel sends an IPI to the orphaned pCPU to force a VM exit, allowing
> the new kernel to take control, update the Caretaker environment,
> and complete the reattachment.

> > Yeah, I think APIC emulation to some extent must be moved into the VMX/=
SVM
> > fastpaths.  The good news is that this can be done already as a PoC wit=
hout
> > needing the whole caretaker and LUO infrastructure.
>
> Moving APIC emulation into the VMX/SVM fastpaths makes sense as a
> standalone effort.

Yup, that's nice to have.

Thanks for the detailed reply, I limited mine to where I wanted your
input as the author of LUO - especially with respect to privilege
separation.

Paolo

