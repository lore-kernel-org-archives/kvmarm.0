Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBE0329C54
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 22:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777673245; cv=none; b=t04g+ts5jzALwocUar8/qANTRQLXRAXjhUNFIU0PS46TqPHulblDVxYm9pO6CpM9VvyrNqWozF6V6ifw17u3v001ehRpxjDfTTe2vKmCOYZBGNwZUc9cIKR7ce/yM7foSDPHFKiSI8+wafspV3RjRb7m91xNAkbPAcmwaKqRLKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777673245; c=relaxed/simple;
	bh=wroTl+8BzVJ2Qacc7fn8+m+oL1wyfPNfkIwBnX//oCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGFP1M6hs/PgcIbGVJkY278gX040OKaAYZDjgPq1ya63rrYkojYmmmsPtjzrx0CuQD0VESzCNwHSp6rhZJggZPNW22JAnXYATDOn37hanQVUCrbDryoMVo231NkkC7veERvQeA8DzZfThkA1/sKbxrqTP8dBBCf/180YZ5GeBfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=iyklTN3s; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="iyklTN3s"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8eb5ad01402so259379385a.2
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 15:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777673243; x=1778278043; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZngdolWCwMllVgRY4Z72RBKMe/hCThaUf6aiHf3a+Hc=;
        b=iyklTN3sKnvkuOna7vfYeMtb2Oxqb31m3onFCobn6hLlbxLZPL/wXDJNqTbb9SzlL/
         gi0ukocst4PuIb9ccFTDVrLAF7YEGxTvF4hvOvGV7iWdmzQoX+vjI/+2E6dkLSvCpyWU
         Wf2Zq4V0Ua2Y0sI/Rmp5RmXraueSePQ6rnDuLrEAoFT9DiBgwqzOtAfgyo1SN4xBAoSH
         2TmgGGntds0tEm17i4og781jR3pdQl5HD+N59KwqZaWTD78Dfd6nhDW/cINHyhLBh27w
         APpCWYjk6ymfd6GmhhHbgWq7AY/Zr6930U8RUuaYLyj35PqBtS1CIAhIehQbSZutZzF6
         XlEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777673243; x=1778278043;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZngdolWCwMllVgRY4Z72RBKMe/hCThaUf6aiHf3a+Hc=;
        b=I+xPtcupvvFRzYhLJ65vxy9aWHpK5yFm/AdEVyGAs37o4CJ7dPig5RT6dVrz/hLsaX
         OPo1wcQcJHGBNOo1oVoGSZ/tvBXFWZvygi8Wmr/Q1HDdUIPZzVyNLhij3okPA1YW/UE6
         h6wRKgDeR+yXgNeGnzAvd7MThw0noJkDZyO4Lk+Wza/jxfww8fowJKUDC89mHCYE0KiZ
         9bHF9p07ZM2Nn2gLu1Cj05BPejAgVB4eECVOOK52zcIU8jJAz4/G3PeULNJWZGzhbZAK
         GUtFRKvtcqbIPk4yZd6rjJEszULF6A1kixKFNN+aSvmSp+VS9O6S3kpUmVAUo+UGmxoG
         2PIA==
X-Forwarded-Encrypted: i=1; AFNElJ/wRPlJOjucbD84uuEjDhy+KeNBkTmof5t/dWRU2OSNf1NELyMYFRePPy44RwmiCF2qeDD/pyk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCFGllrP73R2ZBEWeczll2miMc4jUDWYHwPDtqy5/brRYmEChh
	O3daY1hGNqKhwgb8Z5gG0ocplaciTVrUTw9wuaYQzLWrnRotGvu1iGJYNSaAgzvgI8Y=
X-Gm-Gg: AeBDiesznQCBgIdXr+9hXUcInO7+o+/tjd5t/H/ZHv/SLpbuzhACOvbAZY3fR/A/uZR
	0u6OfWAVMcbTG2Yv0v7yQMMODz1XXSSl+85grjD9ZHc5hMIrCj8ug+DkA576zdIrEo2f0MPLJRC
	c/GAkBYMNaOQcdqebZTB4kebi5SjcTkSu5ln1i87nq+8pkl/cMA0yOVOrrUrHQffA7mJkfOCotP
	P1wyo/Hl92w3DeSnBhmdjjlL9YXxfREYMptrs93o64zgwRnkqImm4jaPzHKUt26UuuNxMAIsGub
	LTNBtjRTqMo7UXRm/I3pF8K9cKF3Wbrp6aB5h9XGDhSxljzxI9ePYrxjEKDm96yJRz8TL4cjfFG
	CM3v0/SQSt+sJkQgh1t52ZWsbiAOuFLUgEJa4AuJs1dk5V6cLmE7mpVHjNovJjpgqQmbMZ8sg35
	dqnxWb0LSBeyzfGMPHuDYwH+M8AaxnBOmnZsMA3QWNKbDhx6pZN7Nfe4VajryafA==
X-Received: by 2002:a05:620a:454a:b0:8ee:18e7:9406 with SMTP id af79cd13be357-8fd17867649mr205532585a.29.1777673243076;
        Fri, 01 May 2026 15:07:23 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc29a80784sm280411885a.12.2026.05.01.15.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 15:07:22 -0700 (PDT)
Date: Fri, 1 May 2026 22:07:20 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, rppt@kernel.org, 
	graf@amazon.com, pratyush@kernel.org, seanjc@google.com, maz@kernel.org, 
	oupton@kernel.org, alex.williamson@redhat.com, kevin.tian@intel.com, 
	rientjes@google.com, Tycho.Andersen@amd.com, anthony.yznaga@oracle.com, 
	baolu.lu@linux.intel.com, david@kernel.org, dmatlack@google.com, mheyne@amazon.de, 
	jgowans@amazon.com, jgg@nvidia.com, pankaj.gupta.linux@gmail.com, 
	kpraveen.lkml@gmail.com, vipinsh@google.com, vannapurve@google.com, corbet@lwn.net, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, hpa@zytor.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, pjt@google.com
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
Message-ID: <afUf7d3Zg2pBCfxs@plex>
References: <afEwWZksU0Fw61oT@plex>
 <0a71472c-b397-4699-a518-61faffcf4ab2@redhat.com>
 <c004f333ed4f7dedae1383f22d43b009cd83837e.camel@infradead.org>
 <3ff53353-3842-4a63-80a1-90a60d09fe02@redhat.com>
 <718a82870c8f3c913791f12a993e11b2d26d08d9.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <718a82870c8f3c913791f12a993e11b2d26d08d9.camel@infradead.org>

On 05-01 09:56, David Woodhouse wrote:
> On Fri, 2026-05-01 at 05:32 +0200, Paolo Bonzini wrote:
> > On 4/30/26 17:27, David Woodhouse wrote:
> > > On Thu, 2026-04-30 at 15:28 +0200, Paolo Bonzini wrote:
> > > > I even wonder if, for long term simplicity, the interface for
> > > > host->caretaker should be just for the caretaker to swallow the host
> > > > into non-root mode, again as in Arm nVHE.
> > > 
> > > There's a lot of merit in that approach.
> > > 
> > > I talked about wanting to use this 'caretaker' for secret hiding.  But
> > > why have *voluntary* secret hiding with the kernel hiding things from
> > > its own address space, when you have have *mandatory* secret hiding
> > > with something running in EL2, like pKVM.
> > 
> > Well, other than because it's a lot of work? :)
> 
> If we avoided those things then we've never have any fun!
> 
> And in a week where there seems to be a new user-to-root exploit posted
> every day, the 'deprivilege the VMM and assume the guest has owned it'
> security model is looking rather scary. So the additional defence in
> depth of knowing that even *root* can't get the kernel to access other
> guests' memory might be the only thing that lets you sleep at night :)
> 
> Yes, it's a lot of work. But I think we've reached the point where
> mandatory secret hiding is... well... mandatory.
> 
> > > The *userspace* ABI considerations are all about how you make a vCPU
> > > that runs asynchronously (should it conceptually just be an async
> > > KVM_RUN call, which allows the vCPU to run in a kernel thread up to the
> > > point of kexec? Why is it fundamentally tied to kexec at all?).
> > 
> > It's not tied to kexec.  kexec is just forcing a handoff + forcing an
> > update.
> > 
> > The big difference is that:
> > 
> > 1) if you don't tie it to kexec, a detached vCPU thread is a struct 
> > vhost_task and a blocking vmexit schedules out the thread; while during 
> > kexec you have s/kthread/pCPU/ and halting the CPU instead of scheduling 
> > it out.
> 
> For now maybe. But "how does the caretaker do scheduling" is on
> definitely the list of future problems, for any environment where a
> physical host with N pCPUs is hosting >= N vCPUs.
> 
> (In the case of a true mandatory-secret-hiding caretaker at EL2, the
> scheduling part *could* be done by the residual purgatory-caretaker-
> thing at EL1 that all the secondary CPUs go to instead of being turned
> off. It would just be calling into EL2 to run the actual vCPUs. Thus
> leaving the EL2 code just to do its *one* job, which has the added
> benefit that the automated reasoning people put the knives down and no
> longer have that look in their eyes that they got when they thought you
> wanted to put a scheduler in their formally-proven EL2 code...)

For the initial PoC, however, we will bypass the scheduling problem 
entirely by enforcing a 1:1 mapping of active vCPUs to isolated pCPUs. 
If a system is overcommitted, we can either pin some vCPUs, or simply be 
suspend the across the kexec gap and wait for the new kernel's scheduler 
to resume them, i.e. the same as what we have now without Orphaned VM 
support.

> > 2) if you don't tie it to kexec, address space isolation is the only 
> > real reason for the complication of treating the caretaker as a separate 
> > bare metal program.  OTOH maybe that's a feature - you could do:
> > 
> > - ioctl(KVM_RUN_ASYNC)
> > 
> > - then vmfd/vcpufd handoff to a new mm on top
> 
> This much gives you a seamless upgrade of the userspace VMM without
> having to play fd-handover tricks. The old VMM detaches, the new one
> attaches. If you're quick, and the guests aren't doing much "admin"
> work but only passing traffic through passthrough PCI devices, the
> guests might not experience any non-negligible steal time at all.

I agree. During development, we should maintain a workflow that is 
functionally identical to the kexec transition. Even without a kernel 
reboot, the process should be: preserve resources via LUO, isolate and 
offline the pCPU, launch the new VMM, and then retrieve the resources to 
online the pCPU and re-adopt the vCPU.

> 
> > - then address space isolation on top
> 
> Even voluntary secret hiding lets you sleep at night when the next
> Retbleed happens.
> 
> > - then kexec (de)serialization on top
> 
> ... and this one is the holy grail.
> 
> So yes, that's exactly the kind of thing I was thinking, rather than
> trying to boil the ocean. There are sensible milestones along the way
> which give practical benefits.
> 
> But my point was *also* about understanding the actual userspace
> interface for this, even if we were to just focus on the live update
> and do it all in one amphetamine-and-tokens-fueled epic. What does it
> even look like, from the VMM point of view? How does the new VMM under
> the new kernel 'reattach' to the existing vCPUs?
> 
> I think we need the userspace API concepts for 'detach' and 'attach',
> including the permissions model for reattach, and we might as well
> implement and test them without the kexec in the middle to start with.

From the VMM point of view, the interface would follow the standard Live 
Update Orchestrator flow for file descriptor preservation. This is 
the same mechanism used to preserve and restore resources like vfiofd, 
iommufd, and memfd across a transition.

> 
> > > I'd love to start without kexec in the picture at all. Just show me the
> > > KVM API for starting a *confidential* guest (pKVM, SEV-SNP, whatever),
> > > leaving it running, completely stopping the VMM and then starting a new
> > > VMM to pick up from where it left off.
> > 
> > Why confidential?
> 
> Mostly so that confidential VMs aren't an *afterthought*, and the
> design of the detach/attach userspace ABI gets them right from the
> start.


