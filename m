Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E9A285075
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649759; cv=none; b=IscLemmCpzmACEjhgCym2pxFrgw5gPuPqkxKg6aAc4f/op5aBof2ItbDvWmYy0ElEHBGWLV7NI249pWyeWHcLXwDRCrY3A5HoooepnVOsY95E5Al4rk5U7KLqixFVqKYSbQ/dSYZWya+DdgAbaQseBP5ibL4arXq9aOEWLGrlAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649759; c=relaxed/simple;
	bh=IxGhrLdSalovyrKDiZneygwserb+KOVKCLOtvAqrp8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K6+c/gjAJM9qR+1iRfRe7HIw3BeNTXuPoVJEEMhDJTPMSHnEvn6rNUUrhX+GWI1fTegivJEOQHfTaF1RQLLT0bfE0ZGtW7N3LqDCuhyIOcZ57CyfyfXyUEUlEGvsjq5FozlILdeJo3Qmm/c5Dk0r3IO5RS0YSoIjhOX1x3zIR3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 914C7497;
	Tue, 23 Sep 2025 10:49:07 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B928A3F5A1;
	Tue, 23 Sep 2025 10:49:11 -0700 (PDT)
From: Ada Couprie Diaz <ada.coupriediaz@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>
Subject: [RFC PATCH 00/16] arm64: make alternative patching callbacks safe
Date: Tue, 23 Sep 2025 18:48:47 +0100
Message-ID: <20250923174903.76283-1-ada.coupriediaz@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This started as an optimization of an alternative (patch 16) but quickly
devolved into a patching rabbit hole, raising more questions than answers.
Hence my looking for comments and some of the patches being
"half-done", as per the notes you will find in patches 7 and 12.


Currently, we use a few callbacks to patch the kernel code, mostly
for KVM and Spectre mitigation handling.
However, almost all of those callbacks are instrumentable or call
instrumentable functions : which means they can be patched themselves.

While applying alternatives, there is no guarantee that a function
might be in a consistent state if it is called by the patching callback,
nor is there a guarantee that the patching of a function calling another
will be consistent between both.
Further, `__apply_alternatives()` doesn't flush the instruction cache
until having applied all alternatives, so there is a possibility that
a patching callback or one of its callees might have been patched
while the I-cache contains an unpatched or partially patched version.

This has (mostly[0]) not blown up so far, but it is mechanically unsound :
we cannot be sure it will not happen in the future.


The goal of this series is to gather feedback on how we can make sure
that the patching callbacks we use are safe and not instrumentable,
as well as all of their callees.
Details on the thought process and the results follow, with open questions
at then end.


Callbacks are made safe when all their callees are, current callbacks
are covered by patches 1-12.
Patches 13-16 are illustrative of what might be required to implement
a new callback using functions not yet covered.


Reasoning
===

I felt that the safest way to be sure that the callbacks would not be
instrumented would be if they were `noinstr` and if all of their callees
were `__always_inline`, or `noinstr` if that were not possible.
That way, if the callback itself is not patchable neither would be any
of the functions it calls, nor any of those that they call, etc.
(Marking all patching callbacks `noinstr` would also make them easily
indentifialbe as internal callbacks, re:[1])

I noted the following alternative callbacks, and went through all of their
callees recursively :
 - kvm_compute_final_ctr_el0
 - kvm_get_kimage_voffset
 - kvm_update_va_mask
 - kvm_patch_vector_branch
 - spectre_bhb_patch_loop_iter (noinstr)
 - spectre_bhb_patch_loop_mitigation_enable (safe, noinstr)
 - spectre_bhb_patch_clearbhb
 - spectre_bhb_patch_wa3 (noinstr)
 - spectre_v4_patch_fw_mitigation_enable
 - smccc_patch_fw_mitigation_conduit
 - kasan_hw_tags_enable
 - alt_cb_patch_nops (safe, noinstr)

Only a couple of them are already safe, and a few more `noinstr` but
calling not inlined nor `noinstr` functions.


The largest source of unsafe functions being called is the
`aarch64_insn_...` functions. There is a large number of them, but only
a few are used in alternative callbacks (directly or transitively).
As they are usually quite simple it made sense to `__always_inline`
those few used in callbacks, which also limits the scope of a complete
`insn` rework.
All the `...get_<insn>_value()`/`is_<insn>()` are `__always_inline`
already, which reduces the number of functions to take care of.


The second one is calls to `printk`, throug `WARN`s or `pr_...` functions.
This is something that we cannot make `__always_inline` or `noinstr`,
so we must either remove them entirely or find another way to make
the information available.

`aarch64_insn_...` functions call `pr_err` a lot to denote invalid
input data, but it is often a dynamically provided argument : if not
in the callbacks, in other use cases (mostly, the BPF JIT compiler).
I removed those as they should always lead to an a break fault instruction
being generated, though the source of the issue becomes less clear.
In cases where the arguments are all available at compile time, I replaced
the runtime `pr_err()` by a `compiletime_assert()`, as a way to preserve
some of the error messages.


Outcome
===

With this series, most of the callbacks are deemede "safe", with
the following exceptions :
 - kvm_patch_vector_branch
 - spectre_bhb_patch_wa3
 - spectre_v4_patch_fw_mitigation_enable
 - smccc_patch_fw_mitigation_conduit

This is due to the use of `WARN`s which I do not know if
they can be safely removed and calling into non-arch code.
There is a bit more info on the Spectre and KVM ones in patches 7 and 12.

This also doesn't (currently, I think it would make sense to do it)
apply the same fixes to the functions called by `patch_alternative()`,
which thus remains "unsound".

There is no size difference in the final image after forcing all those
new inlines with the base defconfig.
A clean compilation on my machine is about 1% faster wall clock time,
using 1% more total CPU time. (20 samples for each, -j110, 125GB of RAM)

This also allows safely introducing a new callback which handles the
Cortex-A57 erratum 832075 (Patch 16), which would be sent separately
after discussion on the RFC.


Open questions
===

There are quite a few things that I am unsure about and would appreciate
some input on :

 - I do prefer when we have error messages, but the current series
   removes a lot of them and fully completing the goal requires the
   removal of more yet.
   - Instead of removing all of them, would it make sense to gate them
     behind a config option (depending on `CONFIG_EXPERT`) ? For example
     `CONFIG_ARM64_UNSAFE_ALTERNATIVE` ? But that would only help for
     developpers or when actively trying to debug.
   - Alternatively, would a command line option make sense ? But then,
     I'm afraid that it would call into more instrumentable/patchable
     functions, leading us back to the beginning. 
   - Are the `compiletime_assert` messages a useful alternative ?
     Are they more limiting than needed ? (Given the arguments _need_
     to be decidable at compile time, that would limit new users that
     create them dynamically)

 - Some alternative callbacks are `__init`. This makes them incompatible
   with the default `noinstr`, as they place functions in different
   text sections. I worked around that for now by using
   `__noinstr_section(".init.text")`, which adds all the `noinstr`
   attributes, but maintains the function in the init section.
   However, it seems to me that Kprobes do not care about the attributes
   and only look at the section to block instrumentation, which could
   be an issue.
   What to do with `__init` callbacks then ? Would this be "good enough" ?
   Is there a proper way to have non-instrumented `__init` functions ?
   What would be the impact of not marking them `__init` anymore ?

 - Given all the limitations and issues above, is this the right way to go
   about it ?

 - `__always_inline`'ing seems to make sense here, but does create
   a disparity in the `aarch64_insn_...` functions,
   but marking everything `noinstr` instead would work as well. Given
   that there is no size difference with and without the patches,
   I would assume that the compiler already inlines them all,
   given we compile with -O2 which considers all functions for inlining.

 - It also means a change of visibility for a few helper functions.
   I have tried to add relevant checks when needed, but I assume there
   were reasons for them to be static to the C file, which they cannot
   be anymore if the functions that need them are `__always_inline`



Thanks very much for taking the time and apologies for another
lengthy cover.
Best,
Ada

Based on v6.17-rc4

[0]: https://lore.kernel.org/all/aNF0gb1iZndz0-be@J2N7QTR9R3/
[1]: https://lore.kernel.org/all/aJnccgC5E-ui2Oqo@willie-the-truck/

Ada Couprie Diaz (16):
  kasan: mark kasan_(hw_)tags_enabled() __always_inline
  arm64: kasan: make kasan_hw_tags_enable() callback safe
  arm64/insn: always inline aarch64_insn_decode_register()
  arm64/insn: always inline aarch64_insn_encode_register()
  arm64/insn: always inline aarch64_insn_encode_immediate()
  arm64/insn: always inline aarch64_insn_gen_movewide()
  arm64/proton-pack: make alternative callbacks safe
  arm64/insn: always inline aarch64_insn_gen_logical_immediate()
  arm64/insn: always inline aarch64_insn_gen_add_sub_imm()
  arm64/insn: always inline aarch64_insn_gen_branch_reg()
  arm64/insn: always inline aarch64_insn_gen_extr()
  kvm/arm64: make alternative callbacks safe
  arm64/insn: introduce missing is_store/is_load helpers
  arm64/insn: always inline aarch64_insn_encode_ldst_size()
  arm64/insn: always inline aarch64_insn_gen_load_acq_store_rel()
  arm64/io: rework Cortex-A57 erratum 832075 to use callback

 arch/arm64/include/asm/insn.h   | 632 ++++++++++++++++++++++++++++++--
 arch/arm64/include/asm/io.h     |  27 +-
 arch/arm64/kernel/image-vars.h  |   1 +
 arch/arm64/kernel/io.c          |  21 ++
 arch/arm64/kernel/mte.c         |   1 +
 arch/arm64/kernel/proton-pack.c |   1 +
 arch/arm64/kvm/va_layout.c      |  12 +-
 arch/arm64/lib/insn.c           | 530 +-------------------------
 include/linux/kasan-enabled.h   |   6 +-
 9 files changed, 657 insertions(+), 574 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.43.0

