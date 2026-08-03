Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C304413230
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 12:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760963; cv=none; b=Ca0+AdCaZ/L29pNFJp8/aw5Hib4SgVmE+J/9/bL+1Ba81LHB9XfDQGcaOn2QjhGohFpjxrIjRqZVIDBrQ4TpQAJGXB0TiYmYy0y4IvrAP0L2ZOsLEU+hw6sTHB79RDIvGPlWKvwwRIOifhNpALadPGKJcOeOpw2aW2dlQieDS+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760963; c=relaxed/simple;
	bh=6vjscQrClzVT4F4XREBTRLne0iHV1Wy0KnvkCTlPWv4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gE3oCz850lR2X6scO/zmMhs9UCeYcnWNeID2vhNxnFVIRsK24CT4rvPvAJhX+l6F4nf3oF06NWORt+puDxMqDTl/yu+bPo87OlA2vRd1faUoye3c19DY4O7KVApf+cIK2O48YdXY3FGFUE3gsyx5O5DV7owMotvzhBJcWwOzG5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a8Lwm1ML; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a8Lwm1ML"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785760949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s2C/t+LCEjcqSfWUCGjWxx3LOQas+/HlzStTuTp4oLk=;
	b=a8Lwm1MLwSZsJfe8o93yECgNngMizembpSilKwQjxAAmEd66ERWCK5454jBeHwlJr3sJq2
	i8DWbVAQP6iS8oWHPv2jAF5IyUlEVjvGmtckSc/jspPNy3ph5fn31Zae4vtHkZMxhfydK8
	xlhXiXm2xDZtlQFlZDRvtS2wSDg9DAU=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	alexandru.elisei@arm.com,
	vdonnefort@google.com,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	ardb@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	tabba@google.com,
	fuad.tabba@linux.dev
Subject: [PATCH v2 00/11] KVM: arm64: Restore type-checking across the host/hyp hypercall boundary
Date: Mon,  3 Aug 2026 13:42:09 +0100
Message-Id: <20260803124220.332248-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Changes since v1 [1]:
  - Dropped the explicit argument-count parameter from the hypercall
    declarations and the handler definitions. The macro ladder derives it
    from COUNT_ARGS() instead. (Marc, Will)
  - Renamed the __hostva address space to __kern. (Vincent)
  - Rebased onto 7.2-rc6.

The SMCCC conversion of the host/hyp interface reduced every hypercall
to a function number and a pile of registers: kvm_call_hyp_nvhe() never
shows the compiler a callable, so the caller's arguments and the
handler's DECLARE_REG() casts can disagree in type, count or order
without a diagnostic. Reviewing a fix for exactly that class of bug,
Marc wrote [2]:

  "we lost all form of type-checking when everything was hastily
   converted to SMCCC to avoid function pointers. Somehow, I feel that
   the cure was worse than the disease.

   I wish we'd reintroduce some form of compile-time checks, maybe by
   having generated stubs?"

and sketched the shape he preferred [3]: a generated nvhe_hvc_##f()
stub that does the type-checking, driven by "some form of declarative
IDL", with "both the caller and callee stubs ... totally generated".

This series implements that, in plain preprocessor macros rather
than an external generator, in the mold of the syscall wrappers.
Each hypercall's signature is declared once, in kvm_hcall.h:
kvm_call_hyp_nvhe() resolves to a typed nvhe_hvc_##f() stub
generated from the declaration, and the hyp-main.c handlers
unmarshal their arguments through glue that is type-checked
against the same declaration. A mistyped or stale call, or a
handler that drifts from its caller, now fails to compile. On top
of that shared declaration, host-VA parameters gain a __kern
sparse address space, so dereferencing one at EL2 without
kern_hyp_va_host() translation is flagged by sparse. The address
space is KVM-private and lives with the interface it annotates
rather than in compiler_types.h, like x86's __seg_gs in asm/percpu.h.
The deeper instances of that bug class, host VAs reached through
struct fields after the boundary, are follow-up work.

The declarations do not also generate the function-number enum or the
dispatch table. The enum carries the availability-band markers that
decide when each hypercall becomes reachable, and its base entry is
consumed from assembly, so generating it would hide the banding. The
remaining duplication cannot drift silently: a name mismatch between
declaration, caller and handler fails to compile, and a missing
dispatch-table entry is rejected at run time as
SMCCC_RET_NOT_SUPPORTED.

Along the way it turned out "make C=2" has never checked the nVHE
objects at all: the custom %.nvhe.o rule reuses rule_cc_o_c, which
only hooks the checker for C=1, and that only on a rebuild. Patches
2-5 fix the hook and the handful of pre-existing sparse warnings it
flushes out, so the checker lands clean. The libfdt objects under
arch/arm64/kernel/pi/ have the same gap through the same rule, so
patch 6 gives them the same one-line fix; it touches arm64 core
rather than KVM, so it can go through either tree. Patch 1 is
adjacent: trace_remote_event.h is not self-contained (it uses bool
without including linux/types.h), which the nVHE include order had
been silently working around; it can go through the tracing tree
instead if preferred.

The first six patches do not depend on the type-checking work (the
tracing-header fix, the sparse cleanups, and the two C=2 hook fixes),
so they could be taken on their own, ahead of the rest of the series
if that is easier.

The series is structured as follows:

  01:     Make trace_remote_event.h self-contained.
  02-04:  Fix the pre-existing sparse warnings in the nVHE code.
  05:     Run the source checker on nVHE objects under C=2.
  06:     Same for the libfdt objects under arch/arm64/kernel/pi/.
  07:     Pass the host-VA hypercall arguments as pointers at EL2.
  08:     Move the dispatch macros to a new kvm_hcall.h.
  09:     Declare the hypercall signatures, type-check the callers.
  10:     Generate the handler unmarshalling, type-check the handlers.
  11:     Tag host-VA parameters __kern for sparse.

The generated code is unchanged, checked by comparing the disassembly
of every KVM object, function by function, against the base: the
callers are identical apart from hypercall returns now being tested at
their declared width and the stage-2 TLB-flush level argument now
being sign-extended as it is loaded (an s8 passed as an int), and the
handlers are instruction-for-instruction identical apart from
flush_hyp_vcpu()/sync_hyp_vcpu() being inlined into their only
caller. The extra argument that prompted the thread, a
mistyped or reordered argument, and a handler that disagrees with its
declaration all now fail to compile. checkpatch complains about the
__KVM_HCALL_MAP() machinery, the (type, name) pair syntax and the
generated signature typedefs, as it does about __MAP() in the syscall
wrappers; the idiom cannot be parenthesized, and the typedef is what
checks the handler against the declaration. Enforcing the
__kern tag needs sparse v0.6.5-rc1 or later for __typeof_unqual__,
as all sparse checking on current kernels does; no stable sparse
release has it yet, so build from sparse.git (checker-valid.sh skips
the check, with a warning, on anything older).

Based on Linux 7.2-rc6 (075b74841bd00).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260720161343.1367007-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/86zf7po2n3.wl-maz@kernel.org/
[3] https://lore.kernel.org/all/86wm2tnsd8.wl-maz@kernel.org/

Fuad Tabba (11):
  tracing: Include linux/types.h in trace_remote_event.h
  KVM: arm64: nVHE: Share the stacktrace per-CPU declarations with EL2
  KVM: arm64: nVHE: Declare the hyp event IDs before defining them
  KVM: arm64: nVHE: Use NULL to reset the trace buffer backing pointer
  KVM: arm64: nVHE: Run the source checker under C=2
  arm64: pi: Run the source checker on the libfdt objects under C=2
  KVM: arm64: nVHE: Pass host VA arguments as pointers
  KVM: arm64: Move the host hypercall interface to its own header
  KVM: arm64: Type-check hypercall arguments at the caller
  KVM: arm64: nVHE: Check hypercall handlers against the declared ABI
  KVM: arm64: Tag host-VA hypercall parameters __kern

 arch/arm64/include/asm/kvm_hcall.h       | 258 +++++++++++++
 arch/arm64/include/asm/kvm_host.h        |  48 +--
 arch/arm64/include/asm/kvm_mmu.h         |  10 +
 arch/arm64/include/asm/stacktrace/nvhe.h |  10 +-
 arch/arm64/kernel/pi/Makefile            |   1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h   |   7 +-
 arch/arm64/kvm/hyp/include/nvhe/trace.h  |   5 +-
 arch/arm64/kvm/hyp/nvhe/Makefile         |   1 +
 arch/arm64/kvm/hyp/nvhe/events.c         |   2 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c       | 444 +++++++++++------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c           |  12 +-
 arch/arm64/kvm/hyp/nvhe/stacktrace.c     |   3 +-
 arch/arm64/kvm/hyp/nvhe/trace.c          |   6 +-
 arch/arm64/kvm/hyp_trace.c               |   2 +-
 arch/arm64/kvm/stacktrace.c              |   3 -
 include/linux/trace_remote_event.h       |   2 +
 16 files changed, 512 insertions(+), 302 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_hcall.h


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
2.39.5

