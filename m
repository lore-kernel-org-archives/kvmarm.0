Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0210935E55D
	for <kvmarm@lists.linux.dev>; Wed, 29 Apr 2026 16:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777478565; cv=none; b=Yp0Tq+BA7iE7+SRKCs+oz5NSFuFWbKZ+njznj3pEZbYjQ23Ho7QznTy1jUyuOXTqKcsG+j2vM2H0h2wnb4XZXOcKyfluFZqCRzSAH0pTlfnj6Z9rPdphgdy7Gldt7jmKHWoD6FEkoEpkp3yyHhSWhJlo3TtaN/E89n5Mc0omqLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777478565; c=relaxed/simple;
	bh=H/KEEfskYycnasnQfuH12d2ga4gEyfQ9kzvcqwKjQbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mM7qED/s4lWr2bytCVHGATc8ei5d1OygdBL7bufll40JFwS5gq5YKNXSBDJ8HqGz1fiZyOPkP7jroaWX7MVe9ejXN2upjM9pjQvwtLZpAQ0ySJJ4HVzumfGP7N3kPBHzd0G0HBMM2/2s0DSb/fHz+c5F1yrTmIDnXp+eLVsbqQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=hje9vJBw; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="hje9vJBw"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-899d6b7b073so132137076d6.2
        for <kvmarm@lists.linux.dev>; Wed, 29 Apr 2026 09:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777478562; x=1778083362; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yASPiEfENXoXTId8ZYq5p7RfB4nlyPfx9QREEY3VRUc=;
        b=hje9vJBwJgIEiX+a44RYa5u9nb/CNhdPWqSmDDYpwqPrXX9yhTSSWeNTIFvNKCzsR9
         SzRW5zsThr1M5JQdaeFlPYCGJU+3qf55Qmup2DDOWm/jshQySYzb5yCUsDMRv+ZdsB4L
         auEQLm5Y2qv8B1GaQ6QemTtEzx/3DwNOfSVGNSnglwipX6cCBkVVlW0qQpmmO9qM2GZb
         M+4FxK3qr8eVhtj3efgu7MKlfKSRmGwNqHwee5JS3FGVNPf68tOUQs9w7E3y15iPCzho
         Zuld6xdhzF54jCKyJOc90qqSRYEQlBxMkrmGkAP6NG4UNc1+RjA6NemJ8lFkHbic+FlU
         ehfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777478562; x=1778083362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yASPiEfENXoXTId8ZYq5p7RfB4nlyPfx9QREEY3VRUc=;
        b=Oz8JNo4v6W9RxuNDYOJG6TNoJMap4zKabGzdEg6oug1PcW1ofKrSCdnySf7AU3c2Jj
         qwt1q4Tp9Rwh6v7dC3Eh9WUftkFHhKsBKSweeu9Gs5znRyr4V+phHFCqzWVND4XAlWs/
         Q+RbiMXnylmXSm4Jjpnjg3oVkL+99dWXJplv8meWY7cPDLbx+gFyMBVy6HsQOkOJ5MnB
         tJxomcRyJIGCanWL0BuCML/H8xL2NJTggrhr0m49bE3FzcTyPh5BtdQoaupU8Q0yhJG5
         CmKpE0d8EUKgp8gKgbOsF5Lc9VTAlG+Ut1ynBGMmP9/jsb6U7cr0oOzIrX6hF+YQhwdI
         RgxQ==
X-Forwarded-Encrypted: i=1; AFNElJ8LNvFLDqK4lzix6dQG/1m/6zReBaKBqoYQU2DdG72txA3MwHnLmpIyBwC9WtIJu6qqsD1jY34=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSJEavlb53rthCbPtU1edtHlYwRNkBC8O1LJ+gihTyoIAigIBs
	8N1L27mlaygDoJmE1jC12n+k7vzd1WnDfHY5P1e3YvAYlMn+WvoPGi9eVcGL0s67KdY=
X-Gm-Gg: AeBDietGPpaKzisiEUpXfGbWjPWJc4rw6l1dlIQQDMDzolGsho4ylyDzGUaoQyM6YgX
	S2VjidoO0LtgueLn8QU9QoPyIbDioMTNFTyiNPRiDcpd5rGB5Cjm3C33RBVjLKRdrzWiGiQ4+97
	Oum2+0HswWPZt4U7u8zzNM1vLZvScoHbNLBEBtjZr5dklQ04qi8JoaU7dVocciS/7ATcvUI2a/E
	cWcV3UtwO0+X6eZDcRfC84WKhOz7KKbW2FG5uhc5LERAqsznCGLwj0rHAxIEUCQSq+DpMhUV3mZ
	EHXe3fO8yLDBrb0/6EGuzTYWBfkLJNt38Xv4ClUFdex3gmqs6U1Ig0pz0NkbPWq7XJv1D4gZBdj
	cYsrzC407I3CMnk7c+qa1nt8tUbOeDigIargFS7CD/C+eElKqoZn/wzvTGSCDxh4Wb2HJhvutEw
	vmfzL5fBsYvpa3IZ/h8uLLWzOp12uHOZVJj/DdoMcA/Pcpn3Q6F6l0A8/CVm40jA==
X-Received: by 2002:ad4:5ded:0:b0:8ac:b402:9af1 with SMTP id 6a1803df08f44-8b3e3205df3mr124948086d6.47.1777478561091;
        Wed, 29 Apr 2026 09:02:41 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b3ef70d4c7sm21160016d6.19.2026.04.29.09.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 09:02:40 -0700 (PDT)
Date: Wed, 29 Apr 2026 16:02:38 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Alexander Graf <graf@amazon.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, rppt@kernel.org, pratyush@kernel.org, 
	pbonzini@redhat.com, seanjc@google.com, maz@kernel.org, oupton@kernel.org, 
	dwmw2@infradead.org, alex.williamson@redhat.com, kevin.tian@intel.com, 
	rientjes@google.com, Tycho.Andersen@amd.com, anthony.yznaga@oracle.com, 
	baolu.lu@linux.intel.com, david@kernel.org, dmatlack@google.com, mheyne@amazon.de, 
	jgowans@amazon.com, jgg@nvidia.com, pankaj.gupta.linux@gmail.com, 
	kpraveen.lkml@gmail.com, vipinsh@google.com, vannapurve@google.com, corbet@lwn.net, 
	loeser@linux.microsoft.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, pjt@google.com, "Petrongonas, Evangelos" <epetron@amazon.de>
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
Message-ID: <afIhL1c8gbz_1i4b@plex>
References: <afEwWZksU0Fw61oT@plex>
 <b52e7d0a-4275-48a0-850f-6ceccfd5204e@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b52e7d0a-4275-48a0-850f-6ceccfd5204e@amazon.com>

On 04-29 10:13, Alexander Graf wrote:
> 
> On 29.04.26 00:29, Pasha Tatashin wrote:
> > Hi all,
> > 
> > TL;DR: Below is a proposal for the next step in Live Update
> > functionality: maintaining vCPU execution during a host kernel reboot
> > via a "Caretaker" for orphaned VMs.
> > 
> > As cloud infrastructure continues to push toward zero-downtime host
> > maintenance, extending the capabilities of kexec-based Live Update to
> > minimize guest disruption is becoming increasingly critical.
> > 
> > I would greatly appreciate your thoughts on the overall architecture,
> > the proposed ABI, and any security or hardware-specific edge cases we
> > might have missed.
> > 
> > Background
> > ==========
> > 
> > Currently, Live Update allows us to preserve hardware resources across a
> > kexec boundary, enabling VMs to be re-attached and resumed on the new
> > kernel. This resource preservation is orchestrated from the kernel side
> > by the LUO (https://docs.kernel.org/core-api/liveupdate.html). This
> > proposal outlines how we can extend this foundation to keep the VMs
> > running rather than just suspended during the transition, significantly
> > reducing the effective blackout experienced by the virtual machines.
> > 
> > Orphaned VMs
> > ============
> > 
> > Definition: An Orphaned VM is a virtual machine actively executing guest
> > instructions on isolated physical hardware, completely decoupled from a
> > Host Operating System or a userspace Virtual Machine Monitor (VMM).
> > 
> > Historically, a VM's lifecycle has been strictly tied to a userspace VMM
> > process. The Orphaned VM strategy breaks this dependency by separating
> > resource ownership from active execution.
> > 
> > Before the old kernel shuts down, it uses the Live Update Orchestrator
> > to maintain ownership of the guest's underlying resources. The LUO
> > preserves the vmfd and vcpufd structures, guest memory, secondary page
> > tables, and other critical KVM metadata required to successfully restore
> > the VM state in the new kernel.
> > 
> > During the transition, the active execution of the VM is not managed by
> > the host kernel. Instead, execution is handed off to a specialized
> > bare-metal component: The Caretaker.
> > 
> > While the VM is "orphaned," it operates entirely outside of standard
> > userspace and kernel space. The physical CPU (pCPU) hosting the VM is
> > completely isolated from the Host OS. The vCPUs continue to execute
> > guest instructions uninterrupted, and any VM Exits are trapped and
> > handled exclusively by the Caretaker. This isolated execution continues
> > while the host kernel reboots on separate management cores (or while
> > the VMM restarts, if the Live Update is limited to a userspace
> > component).
> > 
> > The Caretaker
> > =============
> > 
> > The Caretaker is a specialized, identity-mapped bare-metal executable
> > attached to each vCPU. While it is installed during the initial VM setup
> > and remains permanently enabled as an interpose layer between the Guest
> > and KVM, it is the key architectural feature required for a VM to be
> > orphaned. By providing an execution environment independent of the host
> > OS, the Caretaker enables the guest workload to safely survive the host
> > lifecycle transition.
> > 
> > During normal VM operation, the Caretaker acts as a fast-path shim: it
> > forwards standard VM Exits down to the backing KVM kernel module and
> > handles certain exits autonomously. However, during the "Management Gap"
> > (when no host OS is active and standard KVM handlers are offline), the
> > Caretaker enters a standalone mode to ensure continuous guest execution
> > without host intervention.
> > 
> > While this proposal focuses on its critical role in minimally disruptive
> > Live Update, the Caretaker is fundamentally designed as an extensible
> > primitive. Its architecture allows it to be leveraged for a variety of
> > other advanced virtualization use cases, such as running custom
> > lightweight hypervisors or completely offloading virtualization duties
> > to an accelerator card.
> > 
> > Constraints
> > -----------
> > 
> > The Caretaker is a bare-metal executable. It does not have a backing
> > kernel, it makes zero syscalls, and it lacks access to underlying
> > hardware devices or complex I/O components.
> 
> 
> I think you still want to define an ABI with the outer execution environment
> to allow primitives such as timers. The same the other way around: You want
> to define multiple entry points, so that you can for example have one that
> says "You're up for running this vCPU now" or "Stop all your work, serialize
> your state".

You are right. The intent is to use the CCB as the ABI between the Linux
kernel and the Caretaker.

To keep execution as similar as possible between normal operation and
the orphaned state, this shared memory region is always populated by the
kernel. Because the Caretaker lacks syscalls, all communication, basic
primitives, and lifecycle signaling must be negotiated through the CCB.

Regarding lifecycle commands (like "Stop all your work"), the design
currently relies on the Attachment State Flag in the CCB.

> 
> 
> > 
> > Hardware Setup & ABI Interface
> > ==============================
> > 
> > To interpose the Caretaker between the guest and the host OS, the
> > initialization sequence must load the bare-metal payload, rewire the
> > physical CPU's virtualization structures, and establish a syscall-free
> > communication channel.
> > 
> > API Design & Caretaker Installation
> > -----------------------------------
> > 
> > The Caretaker is installed early in the VM's lifecycle (e.g., shortly
> > after KVM_CREATE_VM). To manage this, we introduce a new KVM ioctl
> > (KVM_SET_CARETAKER) that configures the shim on the vcpufd
> > (alternatively on vmfd). Userspace provides the Caretaker payload
> > compiled as an ELF binary.
> 
> 
> Yikes. So you get a random unprivileged user space injects binary code into
> the kernel primitive? Not great.
> 
> I think it would be better to think of the caretaker as a separate
> subsystem. Maybe even a kernel module that you load (that way it goes
> through the same signing logic as everything else). It can then take a KVM
> fd and cooperate in-kernel with KVM to do the hand-over.
> 
> 
> Or alternatively you follow a model where the caretaker is always compiled
> in as part of KVM. That makes the outgoing ABI easier, but complicates the
> incoming path a bit.

The intent is not to allow unprivileged userspace to load random code.
As outlined in the RFC under "Compromised Caretaker", the security
model mirrors kexec_file_load(). The kernel mandates cryptographic
signature verification of the ELF payload against the trusted kernel
keyring before allowing it to be mapped.

Regarding the kernel module approach: standard modules are tied to the
running kernel version. Because the Caretaker must survive the kexec
transition and interact with the next kernel upon reattachment, it must
maintain ABI compatibility (via the CCB) across different kernel
versions. Treating it as a standalone, signed payload facilitates this
cross-kernel lifecycle.

Compiling the Caretaker directly into KVM also has drawbacks. It reduces
extendability, preventing use cases like forwarding VM Exits to a remote
VMM (e.g., running on an accelerator card or in another VM). 

Additionally, loading it as a distinct payload allows us to leverage
Address Space Isolation. By running the Caretaker in its own
isolated CR3, it provides a hardware-enforced security boundary that
protects the host kernel.

> 
> > 
> > Using an ELF binary allows the Caretaker to be separated into distinct
> > memory sections:
> > 
> >    * .text: The executable bare-metal instructions. This section is
> >      mapped as read-execute (RX).
> >    * .data / .rodata: The static data and variables. This includes the
> >      pre-populated per-vCPU metadata (such as CPUID topology responses)
> >      generated by the VMM.
> >    * .ccb: A dedicated section specifically reserved for the Caretaker
> >      Control Block.
> > 
> > During installation, the userspace VMM opens the ELF file and passes a
> > file descriptor to the KVM_SET_CARETAKER ioctl. By utilizing a
> > structured ELF payload, the Caretaker's logic remains highly flexible,
> > and allows the architecture to be utilized for broader features, such
> > as injecting a custom lightweight hypervisor, or unconditionally
> > forwarding VM exits to an accelerator card.
> 
> 
> Again, no way you want to have a random kernel binary load API :).
> 
> 
> > Hardware Interposition
> > ----------------------
> > 
> > During the execution of the KVM_SET_CARETAKER ioctl, instead of
> > pointing the hardware's return path to standard KVM entry points (e.g.,
> > vmx_vmexit or svm_vcpu_run), KVM reprograms the host-state return area
> > of the CPU's hardware virtualization control structures (e.g., Intel
> > VMCS, AMD VMCB, or ARM equivalent) to point directly into the
> > bare-metal Caretaker environment.
> > 
> > Specifically, the following critical host-state fields (using x86
> > terminology for illustration) are updated:
> > 
> >    * HOST_RIP: Set to point to the e_entry (entry point) of the provided
> >      ELF .text segment. Whenever the guest triggers a VM Exit, the CPU
> >      hardware will unconditionally jump to this address.
> >    * HOST_RSP: Programmed to point to a specialized, pre-allocated
> >      bare-metal stack dedicated strictly to this vCPU's Caretaker. This
> >      allows it to execute completely independently of the host kernel's
> >      normal thread stacks.
> >    * HOST_SSP and HOST_INTR_SSP_TABLE: KVM pre-allocates a Shadow Stack
> >      for the Caretaker. These VMCS fields are programmed during
> >      initialization to ensure that RET and IRET instructions executed by
> >      the Caretaker do not trigger fatal #CP faults when the host kernel
> >      is detached.
> >    * HOST_GS_BASE: Programmed to point to the CCB/Shared Metadata for
> >      this vCPU.
> >    * HOST_CR3: Configured to point to the Caretaker's isolated,
> >      identity-mapped page tables, ensuring memory fetch safety when the
> >      host kernel's page tables are torn down.
> > 
> > Note on Optimization vs. Security: Constantly switching the page table
> > (CR3) on every VM Exit can be expensive due to TLB flushing. To
> > optimize performance, the Caretaker can share the host kernel's page
> > tables while the kernel is still around, and dynamically replace
> > HOST_CR3 with the dedicated, isolated page tables only when the vCPU is
> > orphaned (during the detachment phase). On the other hand, maintaining
> > a permanently isolated CR3 for the Caretaker adds a strong security
> > boundary, achieving hardware-enforced separation similar to KVM Address
> > Space Isolation (ASI).
> 
> 
> This means you're pulling the rug underneath Linux executing that code. How
> will this work in practice? Won't Linux get upset and scream that it can no
> longer access the CPU? What happens on IPI?

It will not because the CPU is fully isolated and appears offline from
the kernel's perspective. The host kernel explicitly offlines the core
before the Caretaker takes full control, meaning the scheduler and host
interrupt routing no longer target it.

In fact, this isolation can be achieved without kexec. The host kernel
can offline and isolate the CPU while the Caretaker keeps the vCPU
executing, and later re-adopt and online the CPU back into the host.

Regarding IPIs, the handling of guest-to-guest IPIs and stray hardware
interrupts is covered later in the RFC under the "Challenges During Gap"
section.

> 
> 
> > KVM-Caretaker ABI
> > =================
> > 
> > The Caretaker requires a defined ABI to communicate with the host KVM
> > subsystem. This ABI is implemented via the shared, identity-mapped .ccb
> > section of the ELF payload, acting as the Caretaker Control Block
> > (CCB).
> > 
> > The CCB acts as the source of truth for the Caretaker's execution loop
> > and contains three primary elements:
> > 
> >    * Attachment State Flag: An atomic variable indicating the current
> >      relationship with the host KVM subsystem (e.g., KVM_ATTACHED or
> >      KVM_DETACHED).
> >    * KVM Routing Pointers: The physical function pointers that the
> >      Caretaker uses to safely jump into the host KVM's standard VM Exit
> >      handlers when operating in normal mode.
> >    * Shared Configuration Metadata: A physical pointer to dedicated
> >      memory pages used by the kernel to share dynamic vCPU configuration
> >      data with the Caretaker. Because every guest is configured
> >      differently, KVM populates these pages with the specific parameters
> >      negotiated during VM initialization (such as CPUID feature masks,
> >      APIC routing, and timer states). These pages also include a
> >      pre-allocated Telemetry Buffer for the Caretaker to log VM Exits
> >      and spin-wait durations. These dedicated pages are explicitly
> >      preserved across the host reboot via KHO, ensuring the Caretaker
> >      maintains continuous access to the exact context required to
> >      accurately emulate trivial exits during the gap.
> 
> 
> Why not create a clear handover point? You are either running with KVM and
> its user space vmm or you are running this "caretaker vmm" which then runs
> its own binary hypervisor thing. That way the handover can also be done
> fully through UAPI. You could even implement the same KVM API on a caretaker
> fd for example and just serialize/deserialize the vCPU state.
> 
> Or if we embed it into KVM proper, we can probably define a KHO
> representation of that state and reuse that. Then ingesting it on the
> incoming environment is the same problem you already have to solve with KHO
> compatibility.

A clear handover point implies maintaining two entirely distinct
execution paths. We explicitly want to avoid that because execution
during normal operation and during the Live Update gap should remain as
similar as possible. Running the Caretaker continuously minimizes state
transitions and avoids introducing untested, hard-to-debug corner cases
that only manifest during a host transition.

Additionally, we want the Caretaker to provide architectural value
beyond Live Update. By keeping it permanently installed in the VM Exit
path, it serves as the foundation for Address Space Isolation and
offers an extendability point for routing or offloading virtualization
tasks. Switching to a separate environment only during the gap defeats
these broader goals.

> 
> 
> > 
> > Caretaker VM Exit Flow
> > ======================
> > 
> > Upon vmexit, the Caretaker's execution flow follows a routing hierarchy:
> > 
> > The Fast Path
> > -------------
> > 
> > The Caretaker first evaluates the VM Exit reason. If the exit belongs to
> > a category that the Caretaker is programmed to resolve natively, it
> > handles it internally. For example, profiling of guests has identified
> > the following exit categories for potential local resolution:
> > 
> >    * Guest Idle Exits (e.g., HLT): When the guest OS goes idle, it
> >      triggers idle exits. The Caretaker intercepts these and halts the
> >      physical core until the next guest-bound interrupt fires, preserving
> >      host power.
> >    * Timer and APIC Exits: Even an idle guest frequently writes to
> >      interrupt controllers and system registers to configure internal
> >      timers. The Caretaker handles these trivial writes directly,
> >      acknowledging the timer updates.
> >    * CPUID and System Registers: Exits like CPUID or safe system register
> >      accesses are resolved by reading pre-computed responses from the
> >      shared metadata pages to accurately service the guest dynamically.
> > 
> > Host Routing
> > ------------
> > 
> > If the VM Exit requires KVM/VMM intervention (e.g., a Page Fault or
> > emulated device I/O), the Caretaker cannot resolve it locally. It must
> > check the CCB attachment state flag to determine where to route the
> > exit:
> > 
> >    * If KVM_ATTACHED: The host kernel is actively managing the system.
> >      The Caretaker acts as a fast-path trampoline, setting up the
> >      standard host registers and transferring execution to the KVM
> >      Routing Pointers.
> >    * If KVM_DETACHED: The host kernel is offline for Live Update. The
> >      Caretaker places the specific vCPU into a safe "spin-wait" polling
> >      loop, continuously checking the CCB flag for a change.
> > 
> > Preservation of the vCPU
> > ========================
> > 
> > For this orchestration to work across a host OS replacement, the file
> > descriptor associated with the vCPU must outlive the userspace process
> > that created it, leveraging the LUO:
> > 
> >    * Creation: The VMM initially creates the vcpufd via the standard
> >      KVM_CREATE_VCPU ioctl on the VM-wide kvmfd. Immediately after
> >      creation, the VMM issues the KVM_SET_CARETAKER ioctl on the newly
> >      created vcpufd. This installs the Caretaker as an interpose layer,
> >      allocating the CCB and rewiring the hardware virtualization control
> >      structures (e.g., HOST_RIP) for this specific vCPU. A dedicated
> >      userspace thread then takes ownership of this file descriptor to
> >      drive the KVM_RUN loop.
> > 
> >    * LUO Registration & Isolation: In preparation for minimally
> >      disruptive Live Update, the VMM acquires a session from the
> >      userspace luo-agent and registers the vcpufd using
> >      LIVEUPDATE_SESSION_PRESERVE_FD. KVM's LUO .preserve() handler is
> >      invoked. Prior to this step, the VMM must pause emulated devices;
> >      the guest relies on VFIO pass-through for primary I/O to survive
> >      the gap without triggering VMM-bound exits. Crucially, the
> >      .preserve() phase is the moment when the pCPU is isolated from the
> >      host OS. The kernel finalizes the state, offlines the core (from
> >      the OS perspective), transitions the vCPU fully into the Caretaker,
> >      and preserves the required KVM data to KHO.
> > 
> >    * The Gap: When the VMM process exits prior to the kexec transition,
> >      open file descriptors are normally destroyed. However, because the
> >      vcpufd is registered with LUO, the kernel holds a reference to the
> >      underlying struct file to ensure it survives the reboot. While the
> >      VMM has exited, the isolated pCPU appears completely offline to the
> >      host OS. During the boot of the Next Kernel, the core smp_init()
> >      routine parses the LUO FLB data and explicitly skips initializing
> >      these preserved pCPUs. This shields the dedicated cores from reset
> >      signals, allowing the guest workload to continue uninterrupted.
> > 
> >    * Reclamation: The Next Kernel boots and LUO deserializes the
> >      session. When the new VMM process spawns, it retrieves the
> >      preserved session and issues LIVEUPDATE_SESSION_RETRIEVE_FD using
> >      its token. LUO invokes KVM's .retrieve() callback to map the
> >      preserved vcpufd back into the new VMM's file descriptor table. As
> >      part of this retrieval process, the host formally brings the
> >      isolated pCPU back online, and the new VMM userspace thread is
> >      attached back to the active VM thread running on the vCPU. Finally,
> >      KVM populates the new KVM Routing Pointers in the CCB and
> >      atomically flips the Host State Flag back to KVM_ATTACHED. This
> >      breaks the Caretaker's spin-wait loop (if it is in this state),
> >      allowing standard KVM operation to resume.
> 
> 
> How does the caretaker continue execution across kexec?

The pCPU running the Caretaker is offlined and isolated by the host OS
prior to the kexec transition. 

Although the pCPUs are offlined, they remain owned by the kernel because
the associated vcpu file descriptors are preserved in the LUO.

During kexec, the primary boot CPU drives the kernel replacement.
Because the Caretaker's pCPUs are offline, they are ignored by the kexec
teardown path. The memory is preserved via KHO, and the host stops
targeting them with interrupts or scheduling tasks.

During the new kernel's boot, smp_init() normally sends INIT/SIPI (on
x86) to reset all secondary cores. In this architecture, smp_init()
parses the KHO/LUO metadata, identifies the preserved pCPUs, and skips
sending reset signals to them.

Because the hardware core is not reset by the kexec process or the new
kernel's boot sequence, the Caretaker continues executing in preserved
memory while the new host kernel boots.

> 
> 
> > 
> > Gap Observability and Telemetry
> > ===============================
> > 
> > During the host transition standard host-level observability tools
> > (e.g., ftrace, perf, eBPF) are completely offline. To ensure production
> > readiness, site reliability, and precise latency accounting, the
> > Caretaker must act as a standalone micro-profiler while the host is
> > detached.
> > 
> > The architecture includes a pre-allocated, identity-mapped Telemetry
> > Buffer, passed to the Caretaker via the Shared Configuration Metadata
> > during installation. During the gap, the Caretaker writes to this
> > memory region to record execution data:
> > 
> >    * Exit Counters: The Caretaker increments hardware-specific counters
> >      for every VM Exit reason it encounters. This provides a precise
> >      tally of natively handled events (e.g., HLT, CPUID, or APIC writes)
> >      that occurred while the host was offline.
> > 
> >    * Spin-Wait Profiling: If a complex exit forces the Caretaker to
> >      block, it reads the hardware time stamp counter (e.g., RDTSC on
> >      x86, CNTVCT_EL0 on ARM64) immediately before entering the spin-wait
> >      loop. It reads the counter again the exact moment the CCB flag
> >      flips back to KVM_ATTACHED. The Caretaker records the specific exit
> >      reason that caused the block and the total accumulated stall time.
> > 
> >    * Post-Gap Ingestion: Upon successful reattachment, the newly booted
> >      host KVM subsystem parses this Telemetry Buffer. The recorded data
> >      is exported via debugfs (e.g., /sys/kernel/debug/kvm/).
> > 
> > Challenges During Gap
> > =====================
> > 
> > While the Caretaker manages standard VM Exits, completely offlining a
> > physical CPU introduces critical edge cases regarding asynchronous
> > hardware interrupts. Below are the primary architectural challenges and
> > their proposed mitigations.
> > 
> > VFIO Interrupt Routing
> > ----------------------
> > 
> >    * The Problem: The design relies on VFIO pass-through for primary
> >      I/O to survive the gap. However, when a physical device (e.g., an
> >      NVMe drive) completes a read, it sends a hardware interrupt
> >      (MSI/MSI-X) back to the CPU. By default, external hardware
> >      interrupts cause a VM Exit. Because the Caretaker natively lacks
> >      Linux IRQ routing tables, it has no immediate mechanism to inject
> >      that specific device interrupt into the guest's virtual APIC or
> >      GIC. The guest would stall indefinitely waiting for the I/O
> >      completion.
> > 
> >    * Proposed Solution: The deployment may utilize hardware-accelerated
> >      interrupt routing, such as Posted Interrupts (Intel PI), Advanced
> >      Virtual Interrupt Controller (AMD AVIC), or GICv4 Direct Virtual
> >      Interrupt Injection (ARM64). This hardware feature allows the
> >      IOMMU/SMMU to route physical device interrupts directly into the
> >      guest's virtual interrupt controller without causing a VM Exit.
> >      Alternatively, KVM could share its IRQ routing tables with the
> >      Caretaker via the Shared Configuration Metadata during setup. This
> >      would allow the Caretaker to intercept the hardware interrupt and
> >      manually inject the virtual interrupt into the guest in software.
> > 
> > Guest-to-Guest IPIs
> > -------------------
> > 
> >    * The Problem: If the guest OS attempts to wake up a sleeping thread,
> >      one orphaned vCPU will send an Inter-Processor Interrupt (IPI) to
> >      another orphaned vCPU. In standard virtualization without hardware
> >      assistance, writing to the APIC ICR (or sending an ARM SGI) causes
> >      a VM Exit so the host KVM can emulate the message delivery. During
> >      the gap, KVM is unavailable to route this message.
> > 
> >    * Proposed Solution: The architecture may leverage hardware virtualized
> >      interrupts (Intel APICv, AMD AVIC, or ARM GICv4.1 virtual SGIs).
> >      This allows the hardware silicon to handle IPI delivery between the
> >      isolated pCPUs natively, eliminating the VM Exit. Alternatively,
> >      the Caretaker can be programmed to emulate the IPI delivery. By
> >      utilizing the shared memory metadata, the Caretaker can determine
> >      the target vCPU and directly update its pending interrupt state.
> > 
> > Stray Hardware Interrupts
> > -------------------------
> > 
> >    * The Problem: What happens if a Non-Maskable Interrupt (NMI), a
> >      hardware timer tick, or a Machine Check Exception / System Error
> >      (MCE / ARM SError) arrives while the CPU is actively executing
> >      Caretaker code in KVM_DETACHED mode?
> > 
> >    * Proposed Solution: To safely handle these asynchronous events, the
> >      Caretaker payload should establish and load its own minimal,
> >      self-contained Interrupt Descriptor Table (IDT on x86) or Exception
> >      Vector Table (via VBAR_EL2 on ARM64) during initialization. This
> >      ensures that if a stray hardware event or NMI arrives while
> >      executing Caretaker instructions in host mode, the CPU can catch
> >      the fault and park the core in a known state rather than triggering
> >      a catastrophic host reboot.
> > 
> >      On x86, when transitioning into the gap, KVM explicitly programs
> >      HOST_IDTR and HOST_GDTR to these self-contained tables. If an NMI
> >      or stray hardware event arrives, the CPU catches the fault using
> >      the Caretaker's native handlers, parking the core or logging the
> >      event rather than attempting host recovery. KVM also programs
> >      HOST_INTR_SSP_TABLE within the Caretaker's isolated environment so
> >      that if the exception handlers execute an IRET, the hardware's CET
> >      shadow stack unroll succeeds without triggering a #CP exception.
> > 
> > Timekeeping Drift
> > -----------------
> > 
> >    * The Problem: While the guest is orphaned, it continues executing
> >      and reading time via the physical CPU's hardware Time Stamp Counter
> >      (TSC or ARM generic timer). Because the host kernel is offline,
> >      software-based paravirtualized clocks (such as kvmclock) are no
> >      longer being updated by host background threads. Furthermore, when
> >      the Next Kernel boots, its calculation of host CLOCK_MONOTONIC or
> >      wall-time might drift from the old kernel. If the new KVM
> >      subsystem resets the VM's TSC offsets or updates the PV clock
> >      structures with standard initialization values upon adoption, the
> >      guest could experience a time jump.
> > 
> >    * Proposed Solution: During the gap, the guest relies entirely on the
> >      physical CPU's Invariant TSC (which the hardware automatically
> >      offsets natively via the VMCS/VMCB) for continuous timekeeping. To
> >      ensure safe reattachment, KVM must serialize the exact state of the
> >      guest's PV clocks, TSC offsets, and the old kernel's base reference
> >      times into KHO memory during the LUO .preserve() phase. Upon
> >      adoption, the new KVM subsystem must synchronize its internal
> >      tracking with this preserved data, ensuring that any subsequent
> >      updates to the guest's PV clock memory guarantee a strictly
> >      monotonic and smooth time progression.
> > 
> > Nested Page Table Updates
> > -------------------------
> > 
> >    * The Problem: As the guest executes, it may attempt to access memory
> >      that has not yet been mapped by the hypervisor, or it may interact
> >      with MMIO regions. Normally, this triggers an EPT Violation (Intel)
> >      or NPT Page Fault (AMD), prompting KVM to allocate host pages and
> >      update the secondary page tables. How are these updates handled
> >      when the host KVM subsystem is offline during the gap?
> > 
> >    * Proposed Solution: During the "Management Gap," there are absolutely
> >      no updates made to the NPT/EPT. The existing secondary page tables
> >      are fully preserved in memory via LUO kvmfd preservation prior to
> >      detachment, allowing the guest to seamlessly access all previously
> >      mapped memory. If the guest triggers a new page fault (requiring an
> >      NPT/EPT update) during the gap, the Caretaker simply categorizes it
> >      as a Blocking Exit.
> 
> 
> You may want to prefault all nested page tables before you switch to
> detached mode.

Yes, prefaulting all nested page tables is an option to minimize guest
stalls. However, it is not strictly necessary.

If a VM Exit due to an EPT or NPT violation occurs during the gap, the
Caretaker categorizes it as a Blocking Exit. The vCPU stalls and waits
for the next kernel to re-adopt the vCPU and handle the fault before
continuing execution.

> 
> 
> > 
> > Compromised Caretaker
> > ---------------------
> > 
> >    * The Problem: The Caretaker runs in Host Mode. If left unprotected,
> >      this could allow a lightly privileged userspace process (e.g., QEMU
> >      or crosvm) to inject arbitrary executable code directly into the
> >      CPU's most privileged hardware state (VMX Root / Ring 0 / EL2).
> > 
> >    * Proposed Solution: To mitigate this risk, the KVM_SET_CARETAKER
> >      ioctl may adopt the security model used by the kexec_file_load()
> >      syscall. Rather than trusting userspace to pass physical addresses,
> >      the kernel must take full ownership of payload validation:
> > 
> >      - In-Kernel ELF Parsing: Instead of passing raw segment addresses
> >        (which is vulnerable to manipulation), the VMM passes a file
> >        descriptor for the Caretaker binary. The host KVM subsystem then
> >        performs the ELF parsing entirely in-kernel. This guarantees that
> >        the kernel controls exactly where the .text, .data, and .ccb
> >        sections are mapped, preventing userspace from tricking the
> >        kernel into overwriting sensitive host memory.
> > 
> >      - Signature Verification & Secure Boot: If the host is running with
> >        Secure Boot or Kernel Lockdown enabled, KVM mandates that the
> >        Caretaker ELF binary be cryptographically signed. The kernel
> >        verifies the signature against the system's trusted keyring
> >        (e.g., .builtin_trusted_keys) before loading it. An unsigned or
> >        modified payload is outright rejected.
> > 
> >      - IMA (Integrity Measurement Architecture) Integration: The loading
> >        of the Caretaker is hooked directly into the kernel's IMA
> >        subsystem. The binary is measured (hashed and extended into the
> >        hardware TPM) for remote attestation and appraised against local
> >        security policies before execution is permitted.
> 
> 
> We have all of this already. It's called "kernel module loader", no? :)

Yes, the mechanisms are identical. However, standard kernel modules are
tied to specific kernel versions.

Because the Caretaker must survive the kexec transition and interface
with the next kernel, it requires a standalone payload verified through
the same security primitives (similar to kexec_file_load). This avoids
the version coupling of standard modules while maintaining the same
security guarantees.

> 
> 
> > Caretaker Update
> > ----------------
> > 
> >    * The Problem: Given that the Caretaker is permanently installed
> >      during VM setup, how does it get updated on long-running VMs?
> > 
> >    * Proposed Solution: To update the Caretaker, we can only perform the
> >      update when vCPUs are not isolated (i.e., not during the live
> >      update gap):
> > 
> >      - vCPU Quiescence: The userspace VMM issues the KVM_SET_CARETAKER
> >        ioctl. KVM then sends kvm_vcpu_kick to force the target vCPU to
> >        exit the guest and return to the host kernel.
> >      - KVM parses the new ELF. It allocates fresh memory pages for the
> >        new .text and .data segments.
> >      - The kernel populates the new .ccb with the existing VM context.
> >      - After the new environment is fully staged, KVM updates the
> >        physical CPU's virtualization control structures.
> >      - When the vCPU thread resumes and re-enters the guest, the next
> >        VM Exit will trigger the hardware to jump into the new Caretaker
> >        payload. The old memory segments are then safely freed.
> 
> 
> I would prefer we only attach the whole caretaker and all of its specialties
> right around the point when live update happens. Why keep it dangling and
> active forever? That way you can also late load the kernel module that
> contains it, so you can be sure it's an up to date version.

I touched on this earlier in the reply. Keeping the Caretaker active
permanently ensures execution symmetry and provides architectural
benefits beyond Live Update, such as Address Space Isolation and
extendability, which would be lost if it were only attached during the
gap.
