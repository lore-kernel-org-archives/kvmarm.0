Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A955D3839AC
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 14:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271422; cv=none; b=ppbl0+2E/hoRzKQBeJ5CJxrjp0ed6f3bdPqdyt+7BeGKgRQn4UO3I9NcyTaNAFdCmbuPFQ939TV9ZT/kZGScc1buQ5o2+RJKIGGjfk0SIQdycR1OfafkuL3FM97TV7j5mgtuT9QJcX7D0WzaDJRF568A8GnLMcV3fEdufelmLA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271422; c=relaxed/simple;
	bh=xqsWMT0UQL17844m89J+TS6qe4Mn9+Ht1tW6y+PjAdY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uZPBpwwpowYFP4YNijZrHyBhYMQLYXziWaMYMcHCr3xIdRxIgFTXohggIOJy1RSIwEONM7ms736niEH2tx8wMI/SmXm9Wkcg5Ep74OnBH5hJcf+lC+GtvBrbBAxU1ZyPZqhNWN1uVdraC7w/nkrGy03esYzQEG0xc5XPCIP7LB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fa/woO21; arc=none smtp.client-ip=95.215.58.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fa/woO21"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=xqsWMT0UQL17844m89J+TS6qe4Mn9+Ht1tW6y+PjAdY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788271418; v=1; x=1788876218;
 b=Fa/woO21G23fEikBufbY6K4v2pvS4WZr/+k9yJAtmaJKE3OMR/ial/D0Njc9D3EhJjyt6Qzb
 aDgpy/adDmjyVqH9Z8FJeSlbSWj4E3yRqX7RaWgKznm1Ni+aDCYcxbyWnxozf0bp+nXSIF1grKZ
 AbX3m+kGBuG0WsfyZKnf58SQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4bf510939060550e;
	Tue, 01 Sep 2026 14:03:28 +0000
X-Mizu-Trace-ID: 4bf510939060550e
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH v4 00/11] KVM: arm64: Restore type-checking across the host/hyp hypercall boundary
Date: Tue,  1 Sep 2026 15:03:15 +0100
Message-Id: <20260901140326.3812068-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v3 [1]:
  - Rebased onto 7.3-rc1. The pkvm-7.3 handler rework that made patches
    9-11 deviate on kvmarm/next is upstream now, so there is a single
    version of the series again. It applies to kvmarm/next unchanged.
  - Dropped the Fixes: tag from patch 1. No config fails to build
    without the include, so it is a self-containment fix rather than a
    fix for an active break. (Steven)
  - Collected Marc's series-wide Reviewed-by, and Vincent's on patch 1.

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

and sketched how he would do it [3]: a generated nvhe_hvc_##f()
stub that does the type-checking, driven by "some form of declarative
IDL", with "both the caller and callee stubs ... totally generated".

This series implements that, in plain preprocessor macros rather than
an external generator, in the mold of the syscall wrappers. Each
hypercall's signature is declared once, in kvm_hcall.h:
kvm_call_hyp_nvhe() resolves to a typed nvhe_hvc_##f() stub generated
from the declaration, and the hyp-main.c handlers unmarshal their
arguments through glue that is type-checked against the same
declaration. A mistyped or stale call, or a handler that drifts from
its caller, now fails to compile. On top of that shared declaration,
host-VA parameters gain a __kern sparse address space, so
dereferencing one at EL2 without kern_hyp_va_host() translation is
flagged by sparse. The address space is KVM-private and lives with the
interface it annotates rather than in compiler_types.h, like x86's
__seg_gs in asm/percpu.h. The deeper instances of that bug class, host
VAs reached through struct fields after the boundary, are follow-up
work.

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
patch 6 gives them the same one-line fix. It touches arm64 core
rather than KVM, so it can go through either tree. Patch 1 is
adjacent: trace_remote_event.h is not self-contained (it uses bool
without including linux/types.h), which the nVHE include order had
been silently working around. It can go through the tracing tree
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

The generated code is unchanged, checked by comparing the disassembly of
every KVM object, function by function, against the base: the callers
are identical apart from hypercall returns now being tested at their
declared width and the stage-2 TLB-flush level argument now being
sign-extended as it is loaded (an s8 passed as an int). The handlers are
instruction-for-instruction identical apart from
flush_hyp_vcpu()/sync_hyp_vcpu() being inlined into their only caller,
and the two vgic_v3 apr handlers addressing the cpu_if directly where
the base reached it at a fixed offset from the vcpu (patch 11). The
extra argument that prompted the thread, a mistyped or reordered
argument, and a handler that disagrees with its declaration all now fail
to compile. checkpatch complains about the __KVM_HCALL_MAP() machinery,
the (type, name) pair syntax and the generated signature typedefs, as it
does about __MAP() in the syscall wrappers. The idiom cannot be
parenthesized, and the typedef is what checks the handler against the
declaration. Enforcing the __kern tag needs sparse v0.6.5-rc1 or later
for __typeof_unqual__, as all sparse checking on current kernels does.
No stable sparse release has it yet, so build from sparse.git
(kbuild warns and skips the check on anything older).

Based on Linux 7.3-rc1 (cee9395acd804).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260804112317.1937387-1-fuad.tabba@linux.dev/
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

 arch/arm64/include/asm/kvm_hcall.h       | 241 ++++++++++++
 arch/arm64/include/asm/kvm_host.h        |  48 +--
 arch/arm64/include/asm/kvm_mmu.h         |  10 +
 arch/arm64/include/asm/stacktrace/nvhe.h |  10 +-
 arch/arm64/kernel/pi/Makefile            |   1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h   |   7 +-
 arch/arm64/kvm/hyp/include/nvhe/trace.h  |   5 +-
 arch/arm64/kvm/hyp/nvhe/Makefile         |   1 +
 arch/arm64/kvm/hyp/nvhe/events.c         |   2 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c       | 459 +++++++++++------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c           |  12 +-
 arch/arm64/kvm/hyp/nvhe/stacktrace.c     |   3 +-
 arch/arm64/kvm/hyp/nvhe/trace.c          |   6 +-
 arch/arm64/kvm/hyp_trace.c               |   2 +-
 arch/arm64/kvm/stacktrace.c              |   3 -
 include/linux/trace_remote_event.h       |   2 +
 16 files changed, 493 insertions(+), 319 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_hcall.h


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.39.5

