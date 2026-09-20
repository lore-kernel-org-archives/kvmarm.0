Received: from mail-yx2-f29.google.com (mail-yx2-f29.google.com [74.125.224.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299D34718DD
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933020; cv=none; b=O8YTY+we4IzRGs63scOPy2AcshyR6QRkNLsHkX4ZQhNrU70pKmOV6ihLf2INzj11xC7hrlgNqQiq9Ekz5FxLH62Wy5Zgq89+PzxCzuMG/JKLdLS0tKH0RRQsk4u8hI6QEGwzI62dKV2ikZXTTXXy+DHtoET2M8muBk/gSmMBw08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933020; c=relaxed/simple;
	bh=5/jzvqe0BI1q/7sUFWqbU0QbLDpwftKxNlY814+z1KU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=TZu1r1mjhq241GqiLYKdwJ7jjFAFGPAsWdAnO1K3rDAfn62xrzeSBnc2r2+TZiVllUaNsHOBy8LhjIGyh3pgxYmKGgZ/rS4EB3xKB+PlS0rbyNO30QaGRfjy38MzXv4cyAofv6/keZ6NA4Ghdf2ucJ/vulo5qSAF94S99pmxMf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=a107lkiu; arc=none smtp.client-ip=74.125.224.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="a107lkiu"
Received: by mail-yx2-f29.google.com with SMTP id 00721157ae682-85d43da99easo18599807b3.1
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933016; x=1790537816; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SWKz/8OeAkiGFbZLGJoBxcLgC1DzN7WUJVOWNvZAQ8A=;
        b=a107lkiucAhI9rzJOBKFBxtpzRzr40+UZ9ug49xV1SIFRQAdK0vs8GG2sUlPPzue16
         mSNMZQ050yUsAiUWSKDDaBlZV7mshwJt1P8vrY08Pcivx+35CVdMXdurTFtMEBZn9RQw
         yCIPUl/t37fm2cIps2WaMqamHKypQ4Scd5viYKisrm9YsjRzH6baYGLu91TuK9/TvQ82
         0DVR73CTd6js019aSCRuAs4UrWFCxFboQi84gvy37Y5qeF3U2AiyTD6lkQq2LyYdV7pe
         WOpuKOYpf+wK3rhOQSTGQpgLNSylgECTFXS789ZwxZ9lXh0Ox61MLewr1aofiOesMwMP
         kP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933016; x=1790537816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SWKz/8OeAkiGFbZLGJoBxcLgC1DzN7WUJVOWNvZAQ8A=;
        b=O9PJZQjm87d/SYso1yygVW+ErsrF6eK/0SxhL/BaOFRRmN2jR1JWbquc87s/4Qj8Bp
         VIVrnANlpnNes+8lAHakT/dkizbw7Lnq8psH0X02OepkboBZZl1SOoXW/+uhNbBirIwC
         2d5janth5/RfQZ5njBVybmO3r3DVnevLVI16CG4j/tItSoQmkjkVjCksil6bQSa4d2RC
         9Ar7X/PM1dtPJaWH7It24oMJ2r1U1rAfNd8ZN3fkcQTZuN4Y1N9/mLNE3esbBxEpIAbc
         DABX+4JD1HOA7PyxPFeQ+/dR8FzU/v4DOf7YqGYdGGhEgH4wg0bFQjVvEo7fn9U+AxSh
         Lrig==
X-Forwarded-Encrypted: i=1; AKwUvBwaWbbYuXS4i6E0pE/o8uTUPRCJS+L1D+1QXqJiHLUIYlCZBhLYj+M2SqB0pt/b7ls4jCR7+xM=@lists.linux.dev
X-Gm-Message-State: AFuF++nKsf3lFsXKxzwMM5gGQMeiczHkhfMPgJFMZzdUzxL4N49YDhNW
	A1LiBml/jyMrwxl9R4THwDt5zNJtqwGu4LVtLw2SCqLUQFpo+6fX6LIUeLbY0AJFPQc=
X-Gm-Gg: AYBFou1iqKp/g8tlVeLb16OAlQ0aqmWD57qbXxlByADpXTxJpgaYR9lCrWWQVIlc1ff
	LXcb1zRFePyV8XlHamr+cc12hZnN9DX/MVIhHLckdNriv00opjSVAzx1o3XU48o5OtBLEfIxriH
	rs0IunxTxTlaE9Ip9KqrR7N4HjEjOnS2i3bb3IiQkOu57xPzIHfVxW44oaFmRy7q1UED6TqApdY
	7Il+9ZkvMYZiATM3yj2hoY+oOGsy+WzEhEB5ghpmKxho9aBCSJS5faxz8phDfOIoIz2NAsWGAs5
	Kq/WL+RE7Pt2SD2aaeX8CYUF9pGI3pc7I+NT8Q7xCadnhVhxNhz0qA/HtvnQhYuxvIFGaXw73qj
	e8Xhlum5TWqngbA4lGlI8FDMUE6jGHmFrlpH9JkmiG4+hNgjel7IQpyNqn8UcgfiXIxZa1Zzqq6
	XjitLycKgH0ujhAVhgZCdYln9KyrtwMzO8fyguF/BIi/o9CpRwWIBs5KtyxYRfqY4iyknegS7fs
	oIphNw3SqLs2wByqNMMi1dKDq4kBQthSS1TD2Bx112upu5BYC2okVObq398hkcr9vSsdDb+EydC
	NmlmKBa/Ti1z9VjJ0Mk=
X-Received: by 2002:a05:690c:c6d2:b0:873:5bd1:98cf with SMTP id 00721157ae682-89738781626mr20406527b3.65.1789933015865;
        Sun, 20 Sep 2026 12:36:55 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a415208bfsm19230137b3.3.2026.09.20.12.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:36:55 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 00/46] Orphaned Virtual Machines
Date: Sun, 20 Sep 2026 15:36:04 -0400
Message-ID: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This RFC series is a PoC intended to showcase e2e working OrphanVMs
uninterrupted continuing execution on preserved physical CPUs across a
host kernel live update, prepared for the LPC'26 presentation at the
KVM Microconf [1].

The original design proposal discussion can be found at [2].

This series is applied on top of v7.3-rc1 + the "[PATCH v4 00/11]
liveupdate: kvm: Guest_memfd preservation" series [3]. The whole branch
can be accessed at [4].

It was tested on Intel Xeon Granite Rapids-AP, AMD EPYC Turin, and ARM
Neoverse V2, as well as in emulation on QEMU and Intel Simics. However,
it is still very early WIP, and is not anywhere near being production
ready.

Overview & Submission Strategy
==============================
While this RFC bundles the e2e stack, it is NOT intended to be merged as
a single series, the goal of this series is to have a discussion about
the technical layers, and the challenges that need to be solved in order
to have full Caretaker support within the kernel.

Some of the arch/* changes duplicate small helpers (such as GICv3 list
register accessors or low-level VMCS/VMCB/sysreg helpers) that could be
shared with existing KVM/arch code if those routines and their callees
are moved to static inlines or annotated with __cpu_preserved_text (and
built without ftrace/KASAN/per-CPU references, as enforced by objtool
and modpost). To avoid sprinkling __cpu_preserved_text annotations
across core arch/* files in this PoC, those helpers are kept local to
caretaker.c for now and can be consolidated when individual platform
support is upstreamed.

The series is structured into at least 8 workstreams that will be
discussed and worked on separately:

1. Workstream 1: Preparation Patches (Patches 01-06)
   Architecture-neutral and arch-specific preparatory cleanups (in
   future these could be bundled with the workstreams that require these
   changes):
     01. KVM: luo: Delegate VM creation type to kvm_arch_vm_luo_preserve
     02. KVM: arm64: Split demux_c15_{get,set}_val from userspace
         accessors
     03. KVM: arm64: Split kvm_sys_reg_{get,set}_user from kernel
         accessors
     04. x86/mm/ident_map: Add force_pte to support 4K PTE identity
         mappings
     05. arm64: mm: Add trans_pgd_map_range() support
     06. x86/smp: Skip offline CPUs for REBOOT_VECTOR in
         native_stop_other_cpus()

2. Workstream 2: In-Kernel In-RAM vCPU State Preservation via LUO
   (Patches 07-10)
   Allows performing suspend/resume-type preservation across kexec
   without carrying the vCPU internal state in the VMM in userspace,
   keeping all vCPU state in-kernel:
     07. KVM: luo: Support vCPU file preservation across live updates
     08. KVM: x86: Add x86 vCPU LUO preservation ABI and register
         helpers
     09. KVM: x86: Implement architectural vCPU state preservation via
         LUO
     10. KVM: arm64: Implement architectural vCPU state preservation via
         LUO

3. Workstream 3: Physical CPU Preservation Core & x86 Support
   (Patches 11-24)
   Introduces the physical CPU preservation subsystem (cpu_preserve),
   linker sections (.text.cpu_preserved, .data.cpu_preserved) with
   build-time section isolation checks in modpost and objtool, isolated
   transition page table management (struct cpu_preserved_as), and sysfs
   interfaces. Allows booting the machine with some CPUs removed from
   the OS scheduler, and provides infrastructure for executing orphaned
   jobs on such CPUs:
     11. liveupdate: Define CPU preservation linker sections
     12. liveupdate: Add liveupdate_session_name() helper
     13. cpu_preserve: Add physical CPU preservation ABI and core API
         headers
     14. cpu_preserve: Add core physical CPU preservation state and park
         loop
     15. cpu_preserve: Add physical CPU preservation lifecycle and build
         rules
     16. liveupdate: cpu_preserve: Add sysfs interface
     17. liveupdate: cpu_preserve: Add isolated address space management
         API
     18. liveupdate: cpu_preserve: Add LUO file handler for preserved
         physical CPUs
     19. x86: liveupdate: Add low-level physical CPU preservation
         assembly
     20. x86: liveupdate: Add physical CPU preservation context and page
         table support
     21. selftests: liveupdate: Add physical CPU preservation unit tests
     22. selftests: liveupdate: Add physical CPU preservation live
         update tests
     23. Documentation: liveupdate: Add physical CPU preservation
         documentation
     24. MAINTAINERS: Add entry for KVM Caretaker

4. Workstream 4: ARM64 Support for Physical CPU Preservation (Patch 25)
   Enables physical CPU preservation on ARM64 using isolated transition
   page tables (trans_pgd_map_range()), cache maintenance to PoC, and
   GICv3 redistributor SGI wake helpers:
     25. arm64: liveupdate: Add support for physical CPU preservation

5. Workstream 5: On-Core Scheduling Framework (oncore) (Patches 26-27)
   (Note: This layer sits between cpu_preserve and the KVM Caretaker and
   Kernel Caretaker (Future Work for Orphaned Processes))
   Provides a runqueue and time-slice scheduling framework
   (kernel/liveupdate/oncore.c) that multiplexes preserved workloads
   onto preserved physical CPUs during the kexec blackout window:
     26. oncore: Add on-core KHO ABI and public framework headers
     27. oncore: Implement on-core session lifecycle and scheduling loop

6. Workstream 6: KVM Caretaker Core & Intel VMX Support
   (Patches 28-39)
   Introduces the KVM Caretaker execution engine (virt/kvm/caretaker.c),
   vCPU detach/attach/cancel lifecycle, optional cross-kexec execution
   telemetry and debugfs reporting, x86 TDP MMU KHO page table
   preservation, x86 common Caretaker runtime (LAPIC timer injection,
   VM-exit dispatch, instruction decoding), and the Intel VMX Caretaker
   backend:
     28. KVM: caretaker: Add Caretaker control block and architecture
         ops headers
     29. KVM: caretaker: Implement Caretaker session memory mapping
         helpers
     30. KVM: caretaker: Integrate Caretaker vCPU detach, attach, and
         cancel with KVM
     31. KVM: caretaker: Add generic KHO ABI telemetry and debugfs
         reporting
     32. KVM: x86: Add TDP MMU KHO preservation helpers
     33. KVM: x86: Add Caretaker x86 KHO ABI and runtime context headers
     34. KVM: x86: Implement Caretaker LAPIC timer and interrupt
         injection
     35. KVM: x86: Implement Caretaker VM-exit dispatch and instruction
         decoders
     36. KVM: x86: Implement Caretaker run loop and LUO detach/attach
         lifecycle
     37. KVM: VMX: Add Caretaker VMX assembly guest entry/exit routine
         and helpers
     38. KVM: VMX: Implement Caretaker VMX VMCS lifecycle and exit
         dispatch
     39. KVM: VMX: Integrate Caretaker VMX detach serialization and KVM
         registration

7. Workstream 7: KVM Caretaker for AMD SVM (Patches 40-41)
   Implements the AMD SVM Caretaker backend (caretaker_vmenter.S, VMCB
   lifecycle, exit decoding, and next-RIP sync):
     40. KVM: SVM: Add Caretaker SVM assembly guest entry/exit routine
     41. KVM: SVM: Implement Caretaker SVM VMCB lifecycle and exit
         dispatch

8. Workstream 8: KVM Caretaker for ARM64 (Patches 42-46)
   Implements the ARM64 VHE Caretaker backend (caretaker_vmenter.S,
   EL2 exception vectors, GICv3 CPU interface & arch timer emulation,
   system register trap handling, and Stage-2 fault handling):
     42. KVM: arm64: Add Caretaker arm64 KHO ABI and runtime context
         headers
     43. KVM: arm64: Add Caretaker EL2 exception vectors and guest
         entry/exit assembly
     44. KVM: arm64: Implement Caretaker GICv3 CPU interface and arch
         timer emulation
     45. KVM: arm64: Implement Caretaker system register trap and
         exception handlers
     46. KVM: arm64: Implement Caretaker vCPU run loop and LUO
         detach/attach lifecycle

Architectural Design Layers
===========================
The OrphanVM architecture is layered so that each subsystem has zero
upward symbol dependencies:

  +--------------------------------------------------------------------+
  | Layer 4: KVM Caretaker Engine (virt/kvm/caretaker.c + arch/kvm/*)  |
  |   - VMENTER/VMRUN/ERET guest execution loop                        |
  |   - Handling of timer preemption, HLT/WFI, MSR/sysreg traps        |
  |   - Yield on unhandled I/O or Stage-2 MMIO faults                  |
  +--------------------------------------------------------------------+
                                    |
                                    v (registers oncore jobs)
  +--------------------------------------------------------------------+
  | Layer 3: On-Core Scheduler Framework (kernel/liveupdate/oncore.c)  |
  |   - Runqueue and time-slice scheduler on preserved cores           |
  |   - Architecture-neutral counter frequency deadline calculation    |
  |   - Session memory mapping into isolated address spaces            |
  +--------------------------------------------------------------------+
                                    |
                                    v (attaches cpu_preserve workload)
  +--------------------------------------------------------------------+
  | Layer 2: Physical CPU Preservation (kernel/liveupdate/cpu_preserve)|
  |   - Offlines CPUs into preserved park loop (.text.cpu_preserved)   |
  |   - Switches CR3/TTBR to isolated transition page tables           |
  |   - Manages cpu_present state across kexec and hotplug reclaim     |
  +--------------------------------------------------------------------+
                                    |
                                    v (persists state via KHO / LUO)
  +--------------------------------------------------------------------+
  | Layer 1: KHO & LUO                                                 |
  |   - Preserves guest_memfd RAM, TDP/Stage-2 MMU, and vCPU state     |
  |   - Cross-kexec ABI (include/linux/kho/abi/*)                      |
  +--------------------------------------------------------------------+

1. Layer 1: KHO & LUO In-RAM Preservation (kvm_luo)
   Preserves VM and vCPU file descriptors across kexec using KHO memory
   preservation. Guest memory (guest_memfd) and secondary MMU page
   tables remain in place in physical RAM. Architectural vCPU state is
   serialized into struct kvm_vcpu_arch_luo_state buffers.

2. Layer 2: Physical CPU Preservation (cpu_preserve)
   Before kexec, selected physical CPUs are taken offline and
   transitioned into a park loop compiled into .text.cpu_preserved and
   copied into KHO-preserved pages outside KHO scratch memory. Each
   preserved CPU switches to an isolated address space (struct
   cpu_preserved_as) that maps ONLY the preserved text/data, per-CPU
   stack, and mapped workload buffers. Build-time section checks in
   modpost and objtool enforce that .text.cpu_preserved and
   .data.cpu_preserved do not reference unmapped host kernel symbols.
   Because preserved CPUs are marked !cpu_present(cpu) while preserved,
   the host kernel's SMP stop routines and incoming kernel's SMP boot
   bringup skip them without hotplug workarounds.

3. Layer 3: On-Core Scheduling Framework (oncore)
   Provides a runqueue and session scheduler (kernel/liveupdate/oncore.c)
   that runs inside the cpu_preserve park loop. Multiple preserved
   workloads (such as vCPUs) can be scheduled across one or more
   preserved physical CPUs using hardware counter deadlines (TSC on x86,
   CNTPCT_EL0 on ARM64).

4. Layer 4: KVM Caretaker Execution Engine (caretaker)
   Attaches preserved KVM vCPUs to oncore jobs. During the kexec
   blackout window, the Caretaker enters the guest directly from
   preserved text with baseline speculative execution mitigations
   (VERW CPU buffer clearing on x86 VM-entry, RSB stuffing on x86
   VM-exit, and Spectre-BHB loop clearing on ARM64 EL2 guest exit):
   - On Intel VMX (vmx/caretaker.c), executes VMLAUNCH/VMRESUME against
     a preserved VMCS page and handles VMX preemption timer / physical
     LAPIC timer, HLT, PAUSE, CPUID, RDTSC, COM1 UART, and basic MSR
     exits. Software emulation of x2APIC ICR IPIs is intentionally
     omitted (trapped ICR writes park the vCPU until the incoming kernel
     reclaims it); instead, the Caretaker KHO-preserves the virtual APIC
     page and the VM's Posted-Interrupt Descriptor pointer table
     (pid_table), allowing hardware with APICv and Intel IPIv to deliver
     inter-vCPU IPIs without VM-exits.
   - On AMD SVM (svm/caretaker.c), executes VMRUN with a preserved VMCB,
     preserved MSR/IO permission bitmaps (msrpm/iopm), and host save
     area (MSR_VM_HSAVE_PA), sharing the common x86 Caretaker exit and
     timer handlers.
   - On ARM64 VHE (arm64/kvm/caretaker.c), switches EL2 exception
     vectors (VBAR_EL2) to Caretaker vectors, emulates the GICv3 CPU
     interface (including inter-vCPU SGI delivery via ICC_SGI1R_EL1
     trapping and GICv3 List Register injection) and arch timer, and
     handles WFI/WFE and system register traps.
   - Note that the set of supported VM-exits can be adjusted as needed;
     initial upstreaming can start by not supporting any VM-exits at
     all, waiting in the Caretaker loop if a vCPU exits until the
     incoming host kernel finishes booting and reclaims the vCPU.
   - Cross-Kexec Re-Attachment: When the incoming kernel boots and
     retrieves the preserved VM, it signals detach via the Caretaker
     control block. The Caretaker serializes live hardware state on the
     preserved core into struct kvm_vcpu_arch_luo_state before yielding,
     exits the park loop, and allows the incoming kernel to reclaim the
     physical CPU and resume KVM execution. Optional execution telemetry
     (runs, exits, stalls, exit reasons, and last RIP) is preserved via
     the KHO ABI and exposed in dmesg and per-vCPU debugfs
     (caretaker_telemetry), both live during detached execution and upon
     re-attachment.

Links
=====
[1] https://lpc.events/event/20/contributions/2553/
[2] https://lore.kernel.org/all/afEwWZksU0Fw61oT@plex/
[3] https://lore.kernel.org/all/20260728121138.1103610-1-tarunsahu@google.com/#r
[4] https://github.com/soleen/linux/tree/ovm/rfc/v1

Pasha Tatashin (46):
  KVM: luo: Delegate VM creation type to kvm_arch_vm_luo_preserve
  KVM: arm64: Split demux_c15_{get,set}_val from userspace accessors
  KVM: arm64: Split kvm_sys_reg_{get,set}_user from kernel accessors
  x86/mm/ident_map: Add force_pte to support 4K PTE identity mappings
  arm64: mm: Add trans_pgd_map_range() support
  x86/smp: Skip offline CPUs for REBOOT_VECTOR in
    native_stop_other_cpus()
  KVM: luo: Support vCPU file preservation across live updates
  KVM: x86: Add x86 vCPU LUO preservation ABI and register helpers
  KVM: x86: Implement architectural vCPU state preservation via LUO
  KVM: arm64: Implement architectural vCPU state preservation via LUO
  liveupdate: Define CPU preservation linker sections
  liveupdate: Add liveupdate_session_name() helper
  cpu_preserve: Add physical CPU preservation ABI and core API headers
  cpu_preserve: Add core physical CPU preservation state and park loop
  cpu_preserve: Add physical CPU preservation lifecycle and build rules
  liveupdate: cpu_preserve: Add sysfs interface
  liveupdate: cpu_preserve: Add isolated address space management API
  liveupdate: cpu_preserve: Add LUO file handler for preserved physical
    CPUs
  x86: liveupdate: Add low-level physical CPU preservation assembly
  x86: liveupdate: Add physical CPU preservation context and page table
    support
  selftests: liveupdate: Add physical CPU preservation unit tests
  selftests: liveupdate: Add physical CPU preservation live update tests
  Documentation: liveupdate: Add physical CPU preservation documentation
  MAINTAINERS: Add entry for KVM Caretaker
  arm64: liveupdate: Add support for physical CPU preservation
  oncore: Add on-core KHO ABI and public framework headers
  oncore: Implement on-core session lifecycle and scheduling loop
  KVM: caretaker: Add Caretaker control block and architecture ops
    headers
  KVM: caretaker: Implement Caretaker session memory mapping helpers
  KVM: caretaker: Integrate Caretaker vCPU detach, attach, and cancel
    with KVM
  KVM: caretaker: Add generic KHO ABI telemetry and debugfs reporting
  KVM: x86: Add TDP MMU KHO preservation helpers
  KVM: x86: Add Caretaker x86 KHO ABI and runtime context headers
  KVM: x86: Implement Caretaker LAPIC timer and interrupt injection
  KVM: x86: Implement Caretaker VM-exit dispatch and instruction
    decoders
  KVM: x86: Implement Caretaker run loop and LUO detach/attach lifecycle
  KVM: VMX: Add Caretaker VMX assembly guest entry/exit routine and
    helpers
  KVM: VMX: Implement Caretaker VMX VMCS lifecycle and exit dispatch
  KVM: VMX: Integrate Caretaker VMX detach serialization and KVM
    registration
  KVM: SVM: Add Caretaker SVM assembly guest entry/exit routine
  KVM: SVM: Implement Caretaker SVM VMCB lifecycle and exit dispatch
  KVM: arm64: Add Caretaker arm64 KHO ABI and runtime context headers
  KVM: arm64: Add Caretaker EL2 exception vectors and guest entry/exit
    assembly
  KVM: arm64: Implement Caretaker GICv3 CPU interface and arch timer
    emulation
  KVM: arm64: Implement Caretaker system register trap and exception
    handlers
  KVM: arm64: Implement Caretaker vCPU run loop and LUO detach/attach
    lifecycle

 .../ABI/testing/sysfs-devices-system-cpu      |   20 +
 Documentation/liveupdate/cpu_preservation.rst |   48 +
 Documentation/liveupdate/index.rst            |   11 +
 Documentation/liveupdate/vmm.rst              |   15 +
 Documentation/virt/kvm/api.rst                |   16 +
 MAINTAINERS                                   |   11 +
 arch/arm64/Kconfig                            |    1 +
 arch/arm64/include/asm/caretaker.h            |   56 +
 arch/arm64/include/asm/cpu_preserve.h         |   44 +
 arch/arm64/include/asm/oncore.h               |   24 +
 arch/arm64/include/asm/trans_pgd.h            |    4 +
 arch/arm64/kernel/Makefile                    |    7 +
 arch/arm64/kernel/cpu_preserve.c              |  674 ++++++
 arch/arm64/kernel/preserve_cpu.S              |   44 +
 arch/arm64/kernel/smp.c                       |    8 +-
 arch/arm64/kernel/vmlinux.lds.S               |    1 +
 arch/arm64/kvm/Kconfig                        |    2 +
 arch/arm64/kvm/Makefile                       |   14 +
 arch/arm64/kvm/caretaker.c                    | 1162 +++++++++++
 arch/arm64/kvm/caretaker.h                    |  130 ++
 arch/arm64/kvm/caretaker_vmenter.S            |  248 +++
 arch/arm64/kvm/kvm_luo.c                      |  304 +++
 arch/arm64/kvm/sys_regs.c                     |  247 ++-
 arch/arm64/kvm/sys_regs.h                     |    4 +
 arch/arm64/mm/trans_pgd.c                     |   70 +
 arch/x86/Kconfig                              |    1 +
 arch/x86/include/asm/cpu_preserve.h           |   34 +
 arch/x86/include/asm/init.h                   |    3 +-
 arch/x86/include/asm/oncore.h                 |   25 +
 arch/x86/kernel/Makefile                      |    7 +
 arch/x86/kernel/cpu_preserve.c                |  432 ++++
 arch/x86/kernel/preserve_cpu.S                |   62 +
 arch/x86/kernel/smp.c                         |    2 +-
 arch/x86/kernel/vmlinux.lds.S                 |    2 +
 arch/x86/kvm/Kconfig                          |    2 +
 arch/x86/kvm/Makefile                         |   32 +
 arch/x86/kvm/caretaker.c                      | 1129 ++++++++++
 arch/x86/kvm/caretaker.h                      |  238 +++
 arch/x86/kvm/caretaker_asm.h                  |  117 ++
 arch/x86/kvm/cpuid.c                          |    4 +-
 arch/x86/kvm/cpuid.h                          |    1 +
 arch/x86/kvm/kvm-asm-offsets.c                |   32 +
 arch/x86/kvm/kvm_luo.c                        |  368 ++++
 arch/x86/kvm/mmu.h                            |    7 +
 arch/x86/kvm/mmu/kho.c                        |  193 ++
 arch/x86/kvm/msrs.c                           |   17 +
 arch/x86/kvm/msrs.h                           |    2 +
 arch/x86/kvm/regs.c                           |    8 +-
 arch/x86/kvm/regs.h                           |    4 +
 arch/x86/kvm/svm/caretaker.c                  |  467 +++++
 arch/x86/kvm/svm/caretaker.h                  |   63 +
 arch/x86/kvm/svm/caretaker_vmenter.S          |   91 +
 arch/x86/kvm/svm/svm.c                        |   11 +-
 arch/x86/kvm/vmx/caretaker.c                  |  658 ++++++
 arch/x86/kvm/vmx/caretaker.h                  |   78 +
 arch/x86/kvm/vmx/caretaker_vmenter.S          |  110 +
 arch/x86/kvm/vmx/vmx.c                        |    6 +-
 arch/x86/kvm/vmx/vmx.h                        |    1 +
 arch/x86/kvm/x86.c                            |    8 +-
 arch/x86/kvm/x86.h                            |    4 +
 arch/x86/mm/ident_map.c                       |   72 +-
 include/asm-generic/vmlinux.lds.h             |   29 +
 include/linux/cpu_preserve.h                  |  464 +++++
 include/linux/kho/abi/cpu.h                   |  151 ++
 include/linux/kho/abi/kvm.h                   |  137 +-
 include/linux/kho/abi/kvm_arm64.h             |   93 +
 include/linux/kho/abi/kvm_x86.h               |  106 +
 include/linux/kvm_caretaker.h                 |  439 ++++
 include/linux/kvm_host.h                      |   63 +
 include/linux/liveupdate.h                    |    6 +
 include/linux/oncore.h                        |  129 ++
 include/uapi/linux/kvm.h                      |    2 +
 kernel/cpu.c                                  |    2 +
 kernel/liveupdate/Kconfig                     |   45 +
 kernel/liveupdate/Makefile                    |   15 +
 kernel/liveupdate/cpu_preserve.c              | 1811 +++++++++++++++++
 kernel/liveupdate/luo_session.c               |   14 +
 kernel/liveupdate/oncore.c                    |  947 +++++++++
 scripts/mod/modpost.c                         |   32 +-
 tools/objtool/check.c                         |   35 +-
 tools/objtool/include/objtool/check.h         |    1 +
 tools/objtool/include/objtool/elf.h           |    2 +-
 tools/testing/selftests/liveupdate/Makefile   |    1 +
 tools/testing/selftests/liveupdate/config     |    6 +
 tools/testing/selftests/liveupdate/init.c     |   27 +-
 .../testing/selftests/liveupdate/liveupdate.c |  251 +++
 .../selftests/liveupdate/luo_cpu_preserve.c   |  145 ++
 .../selftests/liveupdate/run-vmtests.sh       |    1 +
 tools/testing/selftests/liveupdate/vmtest.sh  |    4 +-
 virt/kvm/Kconfig                              |   41 +
 virt/kvm/Makefile.kvm                         |    8 +
 virt/kvm/caretaker.c                          |  639 ++++++
 virt/kvm/caretaker_debug.c                    |  120 ++
 virt/kvm/kvm_luo.c                            |  249 ++-
 virt/kvm/kvm_main.c                           |   66 +-
 95 files changed, 13415 insertions(+), 122 deletions(-)
 create mode 100644 Documentation/liveupdate/cpu_preservation.rst
 create mode 100644 Documentation/liveupdate/index.rst
 create mode 100644 arch/arm64/include/asm/caretaker.h
 create mode 100644 arch/arm64/include/asm/cpu_preserve.h
 create mode 100644 arch/arm64/include/asm/oncore.h
 create mode 100644 arch/arm64/kernel/cpu_preserve.c
 create mode 100644 arch/arm64/kernel/preserve_cpu.S
 create mode 100644 arch/arm64/kvm/caretaker.c
 create mode 100644 arch/arm64/kvm/caretaker.h
 create mode 100644 arch/arm64/kvm/caretaker_vmenter.S
 create mode 100644 arch/arm64/kvm/kvm_luo.c
 create mode 100644 arch/x86/include/asm/cpu_preserve.h
 create mode 100644 arch/x86/include/asm/oncore.h
 create mode 100644 arch/x86/kernel/cpu_preserve.c
 create mode 100644 arch/x86/kernel/preserve_cpu.S
 create mode 100644 arch/x86/kvm/caretaker.c
 create mode 100644 arch/x86/kvm/caretaker.h
 create mode 100644 arch/x86/kvm/caretaker_asm.h
 create mode 100644 arch/x86/kvm/kvm_luo.c
 create mode 100644 arch/x86/kvm/mmu/kho.c
 create mode 100644 arch/x86/kvm/svm/caretaker.c
 create mode 100644 arch/x86/kvm/svm/caretaker.h
 create mode 100644 arch/x86/kvm/svm/caretaker_vmenter.S
 create mode 100644 arch/x86/kvm/vmx/caretaker.c
 create mode 100644 arch/x86/kvm/vmx/caretaker.h
 create mode 100644 arch/x86/kvm/vmx/caretaker_vmenter.S
 create mode 100644 include/linux/cpu_preserve.h
 create mode 100644 include/linux/kho/abi/cpu.h
 create mode 100644 include/linux/kho/abi/kvm_arm64.h
 create mode 100644 include/linux/kho/abi/kvm_x86.h
 create mode 100644 include/linux/kvm_caretaker.h
 create mode 100644 include/linux/oncore.h
 create mode 100644 kernel/liveupdate/cpu_preserve.c
 create mode 100644 kernel/liveupdate/oncore.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_cpu_preserve.c
 create mode 100644 virt/kvm/caretaker.c
 create mode 100644 virt/kvm/caretaker_debug.c

-- 
2.55.0.1082.g2b9226bbc0-goog

