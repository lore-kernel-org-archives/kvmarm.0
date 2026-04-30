Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C746426D35
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 13:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777555760; cv=none; b=ZIakM8z6vsyujxmjds7gR2q3hJiBV0v8gliWh1OIGok8pG5ncmc0/TgnkwJXslVBRvv9RWkOfjaetOL6yFOu348jbH8zwV5YNyGFglOHB+4PK1gHBJpeN2rn21SG/zyrevFk4T7qtoz6s8nL3dWyh8i4oztMltuiDQqxDLGkBdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777555760; c=relaxed/simple;
	bh=NtaiARTaGUGdyQg7LuHIZhss0yE/vLQsauuxhTn9kTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aABCNBnMyCc7UWs3fzuAt07BEjpZbQHGhlGUJDjh4xcz7P/VF9mk4+i90LMu1+uXZvW4n4YsIsCN7v2dCveiVp2FHikLgFQPHJkg30oipnMwUSE1OoGs6tXtlUKSa0ORo/G9KJTUgzysP8dsuF+qTmkjSkfa04kNb2E+5bUndSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NuTgWu5w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NuTgWu5w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777555757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JSxzFXZjopyLpFtclGQ88sUN+Inh+k833IrCrSgzaTI=;
	b=NuTgWu5wctiWfCuBVMWMoCHWqp2+/nYx0/04gqNrRa9Zj/Wk5R0DT67voXeTRK9cyJp+6o
	J4CHadYQi9ciT6t5kHce/vRCytrtLF5A5/C7cNnBT+Ff+wzVI6HFJjsumWVcEheKls8J/r
	h+VVww+LhClIjcm9pxlZSOECfvmNuS8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-674-2wkaTtm3MWid4vDFKli5jg-1; Thu,
 30 Apr 2026 09:29:13 -0400
X-MC-Unique: 2wkaTtm3MWid4vDFKli5jg-1
X-Mimecast-MFC-AGG-ID: 2wkaTtm3MWid4vDFKli5jg_1777555749
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C154319560AA;
	Thu, 30 Apr 2026 13:29:06 +0000 (UTC)
Received: from [10.44.50.160] (unknown [10.44.50.160])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6D7DC300019F;
	Thu, 30 Apr 2026 13:28:53 +0000 (UTC)
Message-ID: <0a71472c-b397-4699-a518-61faffcf4ab2@redhat.com>
Date: Thu, 30 Apr 2026 15:28:51 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
To: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev
Cc: rppt@kernel.org, graf@amazon.com, pratyush@kernel.org, seanjc@google.com,
 maz@kernel.org, oupton@kernel.org, dwmw2@infradead.org,
 alex.williamson@redhat.com, kevin.tian@intel.com, rientjes@google.com,
 Tycho.Andersen@amd.com, anthony.yznaga@oracle.com, baolu.lu@linux.intel.com,
 david@kernel.org, dmatlack@google.com, mheyne@amazon.de, jgowans@amazon.com,
 jgg@nvidia.com, pankaj.gupta.linux@gmail.com, kpraveen.lkml@gmail.com,
 vipinsh@google.com, vannapurve@google.com, corbet@lwn.net,
 loeser@linux.microsoft.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 roman.gushchin@linux.dev, akpm@linux-foundation.org, pjt@google.com
References: <afEwWZksU0Fw61oT@plex>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <afEwWZksU0Fw61oT@plex>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: vqnOsQtwWeFTUl9TyO1IXgJBieCHeON8792zCeuZEZU_1777555749
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I have some very similar observations to Alex and some very similar 
observations to David.  This has to imply that everyone will agree with 
me. :)

Seriously, the main contention point, from reading the thread, is the 
placement and lifecycle of the caretaker.  More on this later...

On 4/29/26 00:29, Pasha Tatashin wrote:
> While this proposal focuses on its critical role in minimally disruptive
> Live Update, the Caretaker is fundamentally designed as an extensible
> primitive. Its architecture allows it to be leveraged for a variety of
> other advanced virtualization use cases, such as running custom
> lightweight hypervisors or completely offloading virtualization duties
> to an accelerator card.

One step at a time please---and as an initial step, just place it inside 
the kernel, a la Arm nVHE.

Since your design would have anyway the ability to update the caretaker, 
you can embed that part into the reattachment process, so that the new 
kernel can use its own caretaker.

This reduces a lot the need to establish a stable-ish ABI.  Only the 
handover (kexec/LUO) needs to be stable, so that the new kernel can 
populate its kvm and kvm_vcpu structs.  And for that we mostly have a 
solution already: a stream of serialized ioctls.

> During the execution of the KVM_SET_CARETAKER ioctl, instead of
> pointing the hardware's return path to standard KVM entry points (e.g.,
> vmx_vmexit or svm_vcpu_run), KVM reprograms the host-state return area
> of the CPU's hardware virtualization control structures (e.g., Intel
> VMCS, AMD VMCB, or ARM equivalent) to point directly into the
> bare-metal Caretaker environment.

This can be done unconditionally for all VMs based on a module 
parameter, again as in Arm nVHE.

> Note on Optimization vs. Security: Constantly switching the page table
> (CR3) on every VM Exit can be expensive due to TLB flushing. To
> optimize performance, the Caretaker can share the host kernel's page
> tables while the kernel is still around, and dynamically replace
> HOST_CR3 with the dedicated, isolated page tables only when the vCPU is
> orphaned (during the detachment phase). On the other hand, maintaining
> a permanently isolated CR3 for the Caretaker adds a strong security
> boundary, achieving hardware-enforced separation similar to KVM Address
> Space Isolation (ASI).

Agreed on this.

> The Caretaker requires a defined ABI to communicate with the host KVM
> subsystem. This ABI is implemented via the shared, identity-mapped .ccb
> section of the ELF payload, acting as the Caretaker Control Block
> (CCB).
> 
> The CCB acts as the source of truth for the Caretaker's execution loop
> and contains three primary elements:
> 
>    * Attachment State Flag: An atomic variable indicating the current
>      relationship with the host KVM subsystem (e.g., KVM_ATTACHED or
>      KVM_DETACHED).

This must be done atomically at the time Linux offlines/onlines a pCPU. 
The interface from Linux to the caretaker must use some kind of IPI so 
that the new kernel can force a VMEXIT (if needed) in the caretaker, ask 
it to serialize the vm state, and pass it down to the new kernel's 
caretaker.

>    * KVM Routing Pointers: The physical function pointers that the
>      Caretaker uses to safely jump into the host KVM's standard VM Exit
>      handlers when operating in normal mode.
>    * Shared Configuration Metadata: A physical pointer to dedicated
>      memory pages used by the kernel to share dynamic vCPU configuration
>      data with the Caretaker. Because every guest is configured
>      differently, KVM populates these pages with the specific parameters
>      negotiated during VM initialization (such as CPUID feature masks,
>      APIC routing, and timer states). These pages also include a
>      pre-allocated Telemetry Buffer for the Caretaker to log VM Exits
>      and spin-wait durations. These dedicated pages are explicitly
>      preserved across the host reboot via KHO, ensuring the Caretaker
>      maintains continuous access to the exact context required to
>      accurately emulate trivial exits during the gap.

All this is mostly unnecessary if the caretaker is provided by the 
kernel.  The recently introduced remote ring buffers can be used for 
tracing too.

> The Caretaker first evaluates the VM Exit reason. If the exit belongs to
> a category that the Caretaker is programmed to resolve natively, it
> handles it internally. For example, profiling of guests has identified
> the following exit categories for potential local resolution:
> 
>    * Guest Idle Exits (e.g., HLT): When the guest OS goes idle, it
>      triggers idle exits. The Caretaker intercepts these and halts the
>      physical core until the next guest-bound interrupt fires, preserving
>      host power.

I don't think HLT can be handled entirely here.  Either you skip the 
exit completely or you have to go out to the scheduler.  The HLT exit 
could be skipped unconditionally for an orphaned VM, but while there is 
a running kernel the caretaker has to run entirely with interrupts off 
and that limits what you can do.

In fact there is already a blueprint of what can be handled easily in 
the caretaker, namely 
vmx_exit_handlers_fastpath()/svm_exit_handlers_fastpath().  Stick to 
what exists already.

>    * Timer and APIC Exits: Even an idle guest frequently writes to
>      interrupt controllers and system registers to configure internal
>      timers. The Caretaker handles these trivial writes directly,
>      acknowledging the timer updates.

This depends heavily on the implementation of the hypervisor, for 
example it can be done on Intel via the preemption timer but not on AMD 
where an actual hrtimer is needed.

[...]

> When the new VMM process spawns, it retrieves the
>     preserved session and issues LIVEUPDATE_SESSION_RETRIEVE_FD using
>     its token. LUO invokes KVM's .retrieve() callback to map the
>     preserved vcpufd back into the new VMM's file descriptor table. As
>     part of this retrieval process, the host formally brings the
>     isolated pCPU back online, and the new VMM userspace thread is
>     attached back to the active VM thread running on the vCPU. Finally,
>     KVM populates the new KVM Routing Pointers in the CCB and
>     atomically flips the Host State Flag back to KVM_ATTACHED. This
>     breaks the Caretaker's spin-wait loop (if it is in this state),
>     allowing standard KVM operation to resume.

This would also include some kind of serialization of the old VM into 
the new kernel's struct kvm_vcpu.

Also some kind of feature negotiation is needed (if that fails, the VMs 
are terminated unceremoniously) so I believe that the transition into 
and out of the gap must be synchronous.  For example with INIT/SIPI for 
the entry, and an IPI for the exit?

> Guest-to-Guest IPIs
> -------------------
> 
>    * The Problem: If the guest OS attempts to wake up a sleeping thread,
>      one orphaned vCPU will send an Inter-Processor Interrupt (IPI) to
>      another orphaned vCPU. In standard virtualization without hardware
>      assistance, writing to the APIC ICR (or sending an ARM SGI) causes
>      a VM Exit so the host KVM can emulate the message delivery. During
>      the gap, KVM is unavailable to route this message.
> 
>    * Proposed Solution: The architecture may leverage hardware virtualized
>      interrupts (Intel APICv, AMD AVIC, or ARM GICv4.1 virtual SGIs).
>      This allows the hardware silicon to handle IPI delivery between the
>      isolated pCPUs natively, eliminating the VM Exit. Alternatively,
>      the Caretaker can be programmed to emulate the IPI delivery. By
>      utilizing the shared memory metadata, the Caretaker can determine
>      the target vCPU and directly update its pending interrupt state.

Yeah, I think APIC emulation to some extent must be moved into the 
VMX/SVM fastpaths.  The good news is that this can be done already as a 
PoC without needing the whole caretaker and LUO infrastructure.

>    * The Problem: What happens if a Non-Maskable Interrupt (NMI), a
>      hardware timer tick, or a Machine Check Exception / System Error
>      (MCE / ARM SError) arrives while the CPU is actively executing
>      Caretaker code in KVM_DETACHED mode?
> 
>    * Proposed Solution: To safely handle these asynchronous events, [...]
>      on x86, when transitioning into the gap, KVM explicitly programs
>      HOST_IDTR and HOST_GDTR to [the caretaker's] tables.

Agreed and this also shows that the transition must be synchronous.
>    * The Problem: As the guest executes, it may attempt to access memory
>      that has not yet been mapped by the hypervisor, or it may interact
>      with MMIO regions. Normally, this triggers an EPT Violation (Intel)
>      or NPT Page Fault (AMD), prompting KVM to allocate host pages and
>      update the secondary page tables. How are these updates handled
>      when the host KVM subsystem is offline during the gap?
> 
>    * Proposed Solution: During the "Management Gap," there are absolutely
>      no updates made to the NPT/EPT. The existing secondary page tables
>      are fully preserved in memory via LUO kvmfd preservation prior to
>      detachment, allowing the guest to seamlessly access all previously
>      mapped memory. If the guest triggers a new page fault (requiring an
>      NPT/EPT update) during the gap, the Caretaker simply categorizes it
>      as a Blocking Exit.

Yes, by default everything is a blocking exit.  In particular, unless 
one day we do x86/pKVM, page tables can be handled entirely by Linux 
rather than the caretaker with no change to the existing MMU notifier 
architecture.

As a consequence, the caretaker is absolutely not going to be a TCB---at 
least not in the beginning.

> Compromised Caretaker
> ---------------------
> 
>    * The Problem: The Caretaker runs in Host Mode. If left unprotected,
>      this could allow a lightly privileged userspace process (e.g., QEMU
>      or crosvm) to inject arbitrary executable code directly into the
>      CPU's most privileged hardware state (VMX Root / Ring 0 / EL2).
> 
>    * Proposed Solution: To mitigate this risk, the KVM_SET_CARETAKER
>      ioctl may adopt the security model used by the kexec_file_load()
>      syscall. Rather than trusting userspace to pass physical addresses,
>      the kernel must take full ownership of payload validation:

-EOVERENGINEERED.  Just shove it into the kernel.

> Caretaker Update
> ----------------
> 
>    * The Problem: Given that the Caretaker is permanently installed
>      during VM setup, how does it get updated on long-running VMs?

Via kexec. :)  I understand you have bigger plans, but we need to crawl 
before walk^Wattempting a marathon.

I even wonder if, for long term simplicity, the interface for 
host->caretaker should be just for the caretaker to swallow the host 
into non-root mode, again as in Arm nVHE.  That would make it much 
harder to implement some kind of live update, but my answer to that 
*really* is just to use kexec.

Paolo

