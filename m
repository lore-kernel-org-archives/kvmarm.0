Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C65C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:55:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 389F761504
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:55:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 389F761504
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E30DA4B232;
	Fri, 24 Sep 2021 08:55:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cTRwGIjKlJD4; Fri, 24 Sep 2021 08:55:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD2264B224;
	Fri, 24 Sep 2021 08:55:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5A6B4B225
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:55:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aPlBI1l01jFP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:55:04 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67A7F4B21C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:55:03 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 x2-20020a5d54c2000000b0015dfd2b4e34so7999372wrv.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc:content-transfer-encoding;
 bh=Y3zYm0SRj3FD4wkWCBfd29+CqKAr1s9F0wHk7odJZK4=;
 b=iha4WANdOO0Eeb6o9Nbr9dDay/dtYchT70gSTmdOATbdUDAzq45HJHpryZLf+bWtXw
 WwEc8l1bqn9aL44QsgyAjzH23MsnYLNjg1otAMr7deyT0zFQa5P7u6AS4p6eBj6u+yBI
 SW2tCnP9/o7m/WQ9gblP7hQDvgKZgGqMZxYfar0TcYuuwqeN8DmGhjLY+KF/3GFX5W2o
 EKvHBUErTCE4G+wEEVTzyldkamEFaHJ6v4i3fZ9cJQX197rBjECmA848mVnsdr607xfP
 Nmq0WzF7uujiC1kaoNLxxSZChlP+9Ph6Wwc6dh6jeD+6B/rXWXu6Mi9jMWWIP0JOVMo5
 JZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc:content-transfer-encoding;
 bh=Y3zYm0SRj3FD4wkWCBfd29+CqKAr1s9F0wHk7odJZK4=;
 b=Rvohg8sqIwXyWgHCNfQwEI9KP3BQdiH60cuhC3426sjOhIjci16J/H3VZs9k+16iuo
 hZm6Nb2O3YhnqQLtNuLVZN8vEaEzf0b9PwCQ6tIhLqVuznGYz5dvxnWW2E/z5MOwfRd7
 zO1g9T2ve6EpTx3RR9yH9+4oeOwSOdprx0b5+mfoPYQD2u2gjHF++Kp6UMhvvCgbR8PR
 PIon6Auaqp7lt3qK3OeIMXCNEBPy1jr893vFrjanqNkEc9cKjRZ0LnB2l8Wr6ub7+e1B
 ywT3QGbaHqtd9i/kaCyCEB0Z3D5CDi8oXlp1z3rNqNgi7uFxESVwdFxozIcwuVB1hA/n
 /BSw==
X-Gm-Message-State: AOAM531aAEjeB52+y9NmjvByOqwvrlRY3uNdGGZNhhsPW+wmhoy+JdlX
 KX5eyXQkx+yJ3EHp21rgNRxnuXgQqFp+ZqIhm1+Bu3S+HkLt/pPzdXxXKKDoieZR8/yXqXWoFdb
 J9TJ9Y/zr14wFXIqf5JUmENwhYYy/wv8nTO+NrLuObrP+mosrI5/TIGYceUVRBsA5PGw=
X-Google-Smtp-Source: ABdhPJxfp36BOamuqS8wiRovtsjqG9I1ct8dLdKOW3rX3k86iF2BuhU/75LwpcAa4cCebcJScLWdvThjLw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:b652:: with SMTP id
 i18mr11136561wre.117.1632488102393; 
 Fri, 24 Sep 2021 05:55:02 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:58 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-30-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 29/30] [DONOTMERGE] Remove Coccinelle scripts added for
 refactoring
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The scripts are not needed anymore, and were included for the git
history.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 cocci_refactor/add_ctxt.cocci           | 169 ------------------------
 cocci_refactor/add_hypstate.cocci       | 125 ------------------
 cocci_refactor/hyp_ctxt.cocci           |  38 ------
 cocci_refactor/range.cocci              |  50 -------
 cocci_refactor/remove_unused.cocci      |  69 ----------
 cocci_refactor/test.cocci               |  20 ---
 cocci_refactor/use_ctxt.cocci           |  32 -----
 cocci_refactor/use_ctxt_access.cocci    |  39 ------
 cocci_refactor/use_hypstate.cocci       |  63 ---------
 cocci_refactor/vcpu_arch_ctxt.cocci     |  13 --
 cocci_refactor/vcpu_declr.cocci         |  59 ---------
 cocci_refactor/vcpu_flags.cocci         |  10 --
 cocci_refactor/vcpu_hyp_accessors.cocci |  35 -----
 cocci_refactor/vcpu_hyp_state.cocci     |  30 -----
 cocci_refactor/vgic3_cpu.cocci          | 118 -----------------
 15 files changed, 870 deletions(-)
 delete mode 100644 cocci_refactor/add_ctxt.cocci
 delete mode 100644 cocci_refactor/add_hypstate.cocci
 delete mode 100644 cocci_refactor/hyp_ctxt.cocci
 delete mode 100644 cocci_refactor/range.cocci
 delete mode 100644 cocci_refactor/remove_unused.cocci
 delete mode 100644 cocci_refactor/test.cocci
 delete mode 100644 cocci_refactor/use_ctxt.cocci
 delete mode 100644 cocci_refactor/use_ctxt_access.cocci
 delete mode 100644 cocci_refactor/use_hypstate.cocci
 delete mode 100644 cocci_refactor/vcpu_arch_ctxt.cocci
 delete mode 100644 cocci_refactor/vcpu_declr.cocci
 delete mode 100644 cocci_refactor/vcpu_flags.cocci
 delete mode 100644 cocci_refactor/vcpu_hyp_accessors.cocci
 delete mode 100644 cocci_refactor/vcpu_hyp_state.cocci
 delete mode 100644 cocci_refactor/vgic3_cpu.cocci

diff --git a/cocci_refactor/add_ctxt.cocci b/cocci_refactor/add_ctxt.cocci
deleted file mode 100644
index 203644944ace..000000000000
--- a/cocci_refactor/add_ctxt.cocci
+++ /dev/null
@@ -1,169 +0,0 @@
-// <smpl>
-
-/*
-spatch --sp-file add_ctxt.cocci --dir arch/arm64/kvm/hyp --ignore arch/arm64/kvm/hyp/nvhe/debug-sr.c --ignore arch/arm64/kvm/hyp/vhe/debug-sr.c --include-headers --in-place
-*/
-
-
-@exists@
-identifier vcpu;
-fresh identifier vcpu_ctxt = vcpu ## "_ctxt";
-identifier fc;
-@@
-<...
-(
-  struct kvm_vcpu *vcpu = NULL;
-+ struct kvm_cpu_context *vcpu_ctxt;
-|
-  struct kvm_vcpu *vcpu = ...;
-+ struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-|
-  struct kvm_vcpu *vcpu;
-+ struct kvm_cpu_context *vcpu_ctxt;
-)
-<...
-  vcpu = ...;
-+ vcpu_ctxt = &vcpu_ctxt(vcpu);
-...>
-fc(..., vcpu, ...)
-...>
-
-@exists@
-identifier func != {kvm_arch_vcpu_run_pid_change};
-identifier fc != {vcpu_ctxt};
-identifier vcpu;
-fresh identifier vcpu_ctxt = vcpu ## "_ctxt";
-@@
-func(..., struct kvm_vcpu *vcpu, ...) {
-+ struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-<+...
-fc(..., vcpu, ...)
-...+>
- }
-
-@@
-expression a, b;
-identifier vcpu;
-fresh identifier vcpu_ctxt = vcpu ## "_ctxt";
-iterator name kvm_for_each_vcpu;
-identifier fc;
-@@
-kvm_for_each_vcpu(a, vcpu, b)
- {
-+ vcpu_ctxt = &vcpu_ctxt(vcpu);
-<+...
-fc(..., vcpu, ...)
-...+>
- }
-
-@@
-identifier vcpu_ctxt, vcpu;
-iterator name kvm_for_each_vcpu;
-type T;
-identifier x;
-statement S1, S2;
-@@
-kvm_for_each_vcpu(...)
- {
-- vcpu_ctxt = &vcpu_ctxt(vcpu);
-... when != S1
-+ vcpu_ctxt = &vcpu_ctxt(vcpu);
- S2
- ... when any
- }
-
-@
-disable optional_qualifier
-exists
-@
-identifier vcpu;
-identifier vcpu_ctxt;
-@@
-<...
-  const struct kvm_vcpu *vcpu = ...;
-- struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-+ const struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-...>
-
-@disable optional_qualifier@
-identifier func, vcpu;
-identifier vcpu_ctxt;
-@@
-func(..., const struct kvm_vcpu *vcpu, ...) {
-- struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-+ const struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-...
- }
-
-@exists@
-expression r1, r2;
-identifier vcpu;
-fresh identifier vcpu_ctxt = vcpu ## "_ctxt";
-@@
-(
-- vcpu_gp_regs(vcpu)
-+ ctxt_gp_regs(vcpu_ctxt)
-|
-- vcpu_spsr_abt(vcpu)
-+ ctxt_spsr_abt(vcpu_ctxt)
-|
-- vcpu_spsr_und(vcpu)
-+ ctxt_spsr_und(vcpu_ctxt)
-|
-- vcpu_spsr_irq(vcpu)
-+ ctxt_spsr_irq(vcpu_ctxt)
-|
-- vcpu_spsr_fiq(vcpu)
-+ ctxt_spsr_fiq(vcpu_ctxt)
-|
-- vcpu_fp_regs(vcpu)
-+ ctxt_fp_regs(vcpu_ctxt)
-|
-- __vcpu_sys_reg(vcpu, r1)
-+ ctxt_sys_reg(vcpu_ctxt, r1)
-|
-- __vcpu_read_sys_reg(vcpu, r1)
-+ __ctxt_read_sys_reg(vcpu_ctxt, r1)
-|
-- __vcpu_write_sys_reg(vcpu, r1, r2)
-+ __ctxt_write_sys_reg(vcpu_ctxt, r1, r2)
-|
-- __vcpu_write_spsr(vcpu, r1)
-+ __ctxt_write_spsr(vcpu_ctxt, r1)
-|
-- __vcpu_write_spsr_abt(vcpu, r1)
-+ __ctxt_write_spsr_abt(vcpu_ctxt, r1)
-|
-- __vcpu_write_spsr_und(vcpu, r1)
-+ __ctxt_write_spsr_und(vcpu_ctxt, r1)
-|
-- vcpu_pc(vcpu)
-+ ctxt_pc(vcpu_ctxt)
-|
-- vcpu_cpsr(vcpu)
-+ ctxt_cpsr(vcpu_ctxt)
-|
-- vcpu_mode_is_32bit(vcpu)
-+ ctxt_mode_is_32bit(vcpu_ctxt)
-|
-- vcpu_set_thumb(vcpu)
-+ ctxt_set_thumb(vcpu_ctxt)
-|
-- vcpu_get_reg(vcpu, r1)
-+ ctxt_get_reg(vcpu_ctxt, r1)
-|
-- vcpu_set_reg(vcpu, r1, r2)
-+ ctxt_set_reg(vcpu_ctxt, r1, r2)
-)
-
-
-/* Handles one case of a call within a call. */
-@@
-expression r1, r2;
-identifier vcpu;
-fresh identifier vcpu_ctxt = vcpu ## "_ctxt";
-@@
-- vcpu_pc(vcpu)
-+ ctxt_pc(vcpu_ctxt)
-
-// </smpl>
diff --git a/cocci_refactor/add_hypstate.cocci b/cocci_refactor/add_hypstate.cocci
deleted file mode 100644
index e8635d0e8f57..000000000000
--- a/cocci_refactor/add_hypstate.cocci
+++ /dev/null
@@ -1,125 +0,0 @@
-// <smpl>
-
-/*
-FILES="$(find arch/arm64/kvm/hyp -name "*.[ch]" ! -name "debug-sr*") arch/arm64/include/asm/kvm_hyp.h"
-spatch --sp-file add_hypstate.cocci $FILES --in-place
-*/
-
-@exists@
-identifier vcpu;
-fresh identifier hyps = vcpu ## "_hyps";
-identifier fc;
-@@
-<...
-(
-  struct kvm_vcpu *vcpu = NULL;
-+ struct vcpu_hyp_state *hyps;
-|
-  struct kvm_vcpu *vcpu = ...;
-+ struct vcpu_hyp_state *hyps = &hyp_state(vcpu);
-|
-  struct kvm_vcpu *vcpu;
-+ struct vcpu_hyp_state *hyps;
-)
-<...
-  vcpu = ...;
-+ hyps = &hyp_state(vcpu);
-...>
-fc(..., vcpu, ...)
-...>
-
-@exists@
-identifier func != {kvm_arch_vcpu_run_pid_change};
-identifier vcpu;
-fresh identifier hyps = vcpu ## "_hyps";
-identifier fc;
-@@
-func(..., struct kvm_vcpu *vcpu, ...) {
-+ struct vcpu_hyp_state *hyps = &hyp_state(vcpu);
-<+...
-fc(..., vcpu, ...)
-...+>
- }
-
-@@
-expression a, b;
-identifier vcpu;
-fresh identifier hyps = vcpu ## "_hyps";
-iterator name kvm_for_each_vcpu;
-identifier fc;
-@@
-kvm_for_each_vcpu(a, vcpu, b)
- {
-+ hyps = &hyp_state(vcpu);
-<+...
-fc(..., vcpu, ...)
-...+>
- }
-
-@@
-identifier hyps, vcpu;
-iterator name kvm_for_each_vcpu;
-statement S1, S2;
-@@
-kvm_for_each_vcpu(...)
- {
-- hyps = &hyp_state(vcpu);
-... when != S1
-+ hyps = &hyp_state(vcpu);
- S2
- ... when any
- }
-
-@
-disable optional_qualifier
-exists
-@
-identifier vcpu, hyps;
-@@
-<...
-  const struct kvm_vcpu *vcpu = ...;
-- struct vcpu_hyp_state *hyps = &hyp_state(vcpu);
-+ const struct vcpu_hyp_state *hyps = &hyp_state(vcpu);
-...>
-
-
-@@
-identifier func, vcpu, hyps;
-@@
-func(..., const struct kvm_vcpu *vcpu, ...) {
-- struct vcpu_hyp_state *hyps = &hyp_state(vcpu);
-+ const struct vcpu_hyp_state *hyps = &hyp_state(vcpu);
-...
- }
-
-@exists@
-identifier vcpu;
-fresh identifier hyps = vcpu ## "_hyps";
-@@
-(
-- vcpu_hcr_el2(vcpu)
-+ hyp_state_hcr_el2(hyps)
-|
-- vcpu_mdcr_el2(vcpu)
-+ hyp_state_mdcr_el2(hyps)
-|
-- vcpu_vsesr_el2(vcpu)
-+ hyp_state_vsesr_el2(hyps)
-|
-- vcpu_fault(vcpu)
-+ hyp_state_fault(hyps)
-|
-- vcpu_flags(vcpu)
-+ hyp_state_flags(hyps)
-|
-- vcpu_has_sve(vcpu)
-+ hyp_state_has_sve(hyps)
-|
-- vcpu_has_ptrauth(vcpu)
-+ hyp_state_has_ptrauth(hyps)
-|
-- kvm_arm_vcpu_sve_finalized(vcpu)
-+ kvm_arm_hyp_state_sve_finalized(hyps)
-)
-
-// </smpl>
diff --git a/cocci_refactor/hyp_ctxt.cocci b/cocci_refactor/hyp_ctxt.cocci
deleted file mode 100644
index af7974e3a502..000000000000
--- a/cocci_refactor/hyp_ctxt.cocci
+++ /dev/null
@@ -1,38 +0,0 @@
-// Remove vcpu if all we're using is hypstate and ctxt
-
-/*
-FILES="$(find arch/arm64/kvm/hyp -name "*.[ch]")"
-spatch --sp-file hyp_ctxt.cocci $FILES --in-place;
-*/
-
-// <smpl>
-
-@remove@
-identifier func !~ "^trap_|^access_|dbg_to_reg|check_pmu_access_disabled|match_mpidr|get_ctr_el0|emulate_cp|unhandled_cp_access|index_to_sys_reg_desc|kvm_pmu_|pmu_counter_idx_valid|reset_|read_from_write_only|write_to_read_only|undef_access|vgic_|kvm_handle_|handle_sve|handle_smc|handle_no_fpsimd|id_visibility|reg_to_dbg|ptrauth_visibility|sve_visibility|kvm_arch_sched_in|kvm_arch_vcpu_|kvm_vcpu_pmu_|kvm_psci_|kvm_arm_copy_fw_reg_indices|kvm_arm_pvtime_|kvm_trng_|kvm_arm_timer_";
-identifier vcpu;
-fresh identifier vcpu_ctxt = vcpu ## "_ctxt";
-fresh identifier vcpu_hyps = vcpu ## "_hyps";
-identifier hyps_remove;
-identifier ctxt_remove;
-@@
-func(...,
-- struct kvm_vcpu *vcpu
-+ struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps
-,...) {
-?- struct vcpu_hyp_state *hyps_remove = ...;
-?- struct kvm_cpu_context *ctxt_remove = ...;
-... when != vcpu
- }
-
-@@
-identifier vcpu;
-fresh identifier vcpu_ctxt = vcpu ## "_ctxt";
-fresh identifier vcpu_hyps = vcpu ## "_hyps";
-identifier remove.func;
-@@
- func(
-- vcpu
-+ vcpu_ctxt, vcpu_hyps
-  , ...)
-
-// </smpl>
\ No newline at end of file
diff --git a/cocci_refactor/range.cocci b/cocci_refactor/range.cocci
deleted file mode 100644
index d99b9ee30657..000000000000
--- a/cocci_refactor/range.cocci
+++ /dev/null
@@ -1,50 +0,0 @@
-
-
-// <smpl>
-
-/*
- FILES="$(find arch/arm64 -name "*.[ch]") include/kvm/arm_hypercalls.h"; spatch --sp-file range.cocci $FILES
-*/
-
-@initialize:python@
-@@
-starts = ("start", "begin", "from", "floor", "addr", "kaddr")
-ends = ("size", "length", "len")
-
-//ends = ("end", "to", "ceiling", "size", "length", "len")
-
-
-@start_end@
-identifier f;
-type A, B;
-identifier start, end;
-parameter list[n] ps;
-@@
-f(ps, A start, B end, ...) {
-...
-}
-
-@script:python@
-start << start_end.start;
-end << start_end.end;
-ta << start_end.A;
-tb << start_end.B;
-@@
-
-if ta != tb and tb != "size_t":
-        cocci.include_match(False)
-elif not any(x in start for x in starts) and not any(x in end for x in ends):
-        cocci.include_match(False)
-
-@@
-identifier f = start_end.f;
-expression list[start_end.n] xs;
-expression a, b;
-@@
-(
-* f(xs, a, a, ...)
-|
-* f(xs, a, a - b, ...)
-)
-
-// </smpl>
\ No newline at end of file
diff --git a/cocci_refactor/remove_unused.cocci b/cocci_refactor/remove_unused.cocci
deleted file mode 100644
index c06278398198..000000000000
--- a/cocci_refactor/remove_unused.cocci
+++ /dev/null
@@ -1,69 +0,0 @@
-// <smpl>
-
-/*
-spatch --sp-file remove_unused.cocci --dir arch/arm64/kvm/hyp --in-place --include-headers --force-diff
-*/
-
-@@
-identifier hyps;
-@@
-{
-...
-(
-- struct vcpu_hyp_state *hyps = ...;
-|
-- struct vcpu_hyp_state *hyps;
-)
-... when != hyps
-    when != if (...) { <+...hyps...+> }
-?- hyps = ...;
-... when != hyps
-    when != if (...) { <+...hyps...+> }
-}
-
-@@
-identifier vcpu_ctxt;
-@@
-{
-...
-(
-- struct kvm_cpu_context *vcpu_ctxt = ...;
-|
-- struct kvm_cpu_context *vcpu_ctxt;
-)
-... when != vcpu_ctxt
-    when != if (...) { <+...vcpu_ctxt...+> }
-?- vcpu_ctxt = ...;
-... when != vcpu_ctxt
-    when != if (...) { <+...vcpu_ctxt...+> }
-}
-
-@@
-identifier x;
-identifier func;
-statement S;
-@@
-func(...)
- {
-...
-struct kvm_cpu_context *x = ...;
-+
-S
-...
- }
-
-@@
-identifier x;
-identifier func;
-statement S;
-@@
-func(...)
- {
-...
-struct vcpu_hyp_state *x = ...;
-+
-S
-...
- }
-
-// </smpl>
diff --git a/cocci_refactor/test.cocci b/cocci_refactor/test.cocci
deleted file mode 100644
index 5eb685240ce7..000000000000
--- a/cocci_refactor/test.cocci
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- FILES="$(find arch/arm64 -name "*.[ch]") include/kvm/arm_hypercalls.h"; spatch --sp-file test.cocci $FILES
-
-*/
-
-@r@
-identifier fn;
-@@
-fn(...) {
- hello;
- ...
-}
-
-@@
-identifier r.fn;
-@@
-static fn(...) {
-+ world;
- ...
-}
diff --git a/cocci_refactor/use_ctxt.cocci b/cocci_refactor/use_ctxt.cocci
deleted file mode 100644
index f3f961f567fd..000000000000
--- a/cocci_refactor/use_ctxt.cocci
+++ /dev/null
@@ -1,32 +0,0 @@
-// <smpl>
-/*
-spatch --sp-file use_ctxt.cocci  --dir arch/arm64/kvm/hyp --ignore debug-sr --include-headers  --in-place
-spatch --sp-file use_ctxt.cocci  --dir arch/arm64/kvm/hyp --ignore debug-sr --include-headers  --in-place
-*/
-
-@remove_vcpu@
-identifier vcpu;
-fresh identifier vcpu_ctxt = vcpu ## "_ctxt";
-identifier ctxt_remove;
-identifier func !~ "(reset_unknown|reset_val|kvm_pmu_valid_counter_mask|reset_pmcr|kvm_arch_vcpu_in_kernel|__vgic_v3_)";
-@@
-func(
-- struct kvm_vcpu *vcpu
-+ struct kvm_cpu_context *vcpu_ctxt
-, ...) {
-- struct kvm_cpu_context *ctxt_remove = ...;
-... when != vcpu
-    when != if (...) { <+...vcpu...+> }
-}
-
-@@
-identifier vcpu;
-fresh identifier vcpu_ctxt = vcpu ## "_ctxt";
-identifier func = remove_vcpu.func;
-@@
-func(
-- vcpu
-+ vcpu_ctxt
-  , ...)
-
-// </smpl>
diff --git a/cocci_refactor/use_ctxt_access.cocci b/cocci_refactor/use_ctxt_access.cocci
deleted file mode 100644
index 74f94141e662..000000000000
--- a/cocci_refactor/use_ctxt_access.cocci
+++ /dev/null
@@ -1,39 +0,0 @@
-// </smpl>
-
-/*
-spatch --sp-file use_ctxt_access.cocci --dir arch/arm64/kvm/ --include-headers --in-place
-*/
-
-@@
-constant r;
-@@
-- __ctxt_sys_reg(&vcpu->arch.ctxt, r)
-+ &__vcpu_sys_reg(vcpu, r)
-
-@@
-identifier r;
-@@
-- vcpu->arch.ctxt.regs.r
-+ vcpu_gp_regs(vcpu)->r
-
-@@
-identifier r;
-@@
-- vcpu->arch.ctxt.fp_regs.r
-+ vcpu_fp_regs(vcpu)->r
-
-@@
-identifier r;
-fresh identifier accessor = "vcpu_" ## r;
-@@
-- &vcpu->arch.ctxt.r
-+ accessor(vcpu)
-
-@@
-identifier r;
-fresh identifier accessor = "vcpu_" ## r;
-@@
-- vcpu->arch.ctxt.r
-+ *accessor(vcpu)
-
-// </smpl>
\ No newline at end of file
diff --git a/cocci_refactor/use_hypstate.cocci b/cocci_refactor/use_hypstate.cocci
deleted file mode 100644
index f685149de748..000000000000
--- a/cocci_refactor/use_hypstate.cocci
+++ /dev/null
@@ -1,63 +0,0 @@
-// <smpl>
-
-/*
-FILES="$(find arch/arm64/kvm/hyp -name "*.[ch]" ! -name "debug-sr*") arch/arm64/include/asm/kvm_hyp.h"
-spatch --sp-file use_hypstate.cocci $FILES --in-place
-*/
-
-
-@remove_vcpu_hyps@
-identifier vcpu;
-fresh identifier hyps = vcpu ## "_hyps";
-identifier hyps_remove;
-identifier func;
-@@
-func(
-- struct kvm_vcpu *vcpu
-+ struct vcpu_hyp_state *hyps
-, ...) {
-- struct vcpu_hyp_state *hyps_remove = ...;
-... when != vcpu
-    when != if (...) { <+...vcpu...+> }
-}
-
-@@
-identifier vcpu;
-fresh identifier hyps = vcpu ## "_hyps";
-identifier func = remove_vcpu_hyps.func;
-@@
-func(
-- vcpu
-+ hyps
-  , ...)
-
-@remove_vcpu_hyps_ctxt@
-identifier vcpu;
-fresh identifier hyps = vcpu ## "_hyps";
-identifier hyps_remove;
-identifier ctxt_remove;
-identifier func;
-@@
-func(
-- struct kvm_vcpu *vcpu
-+ struct vcpu_hyp_state *hyps
-, ...) {
-- struct vcpu_hyp_state *hyps_remove = ...;
-- struct kvm_cpu_context *ctxt_remove = ...;
-... when != vcpu
-    when != if (...) { <+...vcpu...+> }
-    when != ctxt_remove
-    when != if (...) { <+...ctxt_remove...+> }
-}
-
-@@
-identifier vcpu;
-fresh identifier hyps = vcpu ## "_hyps";
-identifier func = remove_vcpu_hyps_ctxt.func;
-@@
-func(
-- vcpu
-+ hyps
-  , ...)
-
-// </smpl>
diff --git a/cocci_refactor/vcpu_arch_ctxt.cocci b/cocci_refactor/vcpu_arch_ctxt.cocci
deleted file mode 100644
index 69b3a000de4e..000000000000
--- a/cocci_refactor/vcpu_arch_ctxt.cocci
+++ /dev/null
@@ -1,13 +0,0 @@
-// spatch --sp-file vcpu_arch_ctxt.cocci --no-includes --include-headers  --dir arch/arm64
-
-// <smpl>
-@@
-identifier vcpu;
-@@
-(
-- vcpu->arch.ctxt.regs
-+ vcpu_gp_regs(vcpu)
-|
-- vcpu->arch.ctxt.fp_regs
-+ vcpu_fp_regs(vcpu)
-)
diff --git a/cocci_refactor/vcpu_declr.cocci b/cocci_refactor/vcpu_declr.cocci
deleted file mode 100644
index 59cd46bd6b2d..000000000000
--- a/cocci_refactor/vcpu_declr.cocci
+++ /dev/null
@@ -1,59 +0,0 @@
-
-/*
-FILES="$(find arch/arm64 -name "*.[ch]") include/kvm/arm_hypercalls.h";  spatch --sp-file vcpu_declr.cocci $FILES --in-place
-*/
-
-// <smpl>
-
-@@
-identifier vcpu;
-expression E;
-@@
-<...
-- struct kvm_vcpu *vcpu;
-+ struct kvm_vcpu *vcpu = E;
-
-- vcpu = E;
-...>
-
-
-/*
-@@
-identifier vcpu;
-identifier f1, f2;
-@@
-f1(...)
-{
-- struct kvm_vcpu *vcpu = NULL;
-+ struct kvm_vcpu *vcpu;
-... when != f2(..., vcpu, ...)
-}
-*/
-
-/*
-@find_after@
-identifier vcpu;
-position p;
-identifier f;
-@@
-<...
- struct kvm_vcpu *vcpu@p;
- ... when != vcpu = ...;
- f(..., vcpu, ...);
-...>
-
-@@
-identifier vcpu;
-expression E;
-position p != find_after.p;
-@@
-<...
-- struct kvm_vcpu *vcpu@p;
-+ struct kvm_vcpu *vcpu = E;
- ...
-- vcpu = E;
-...>
-
-*/
-
-// </smpl>
diff --git a/cocci_refactor/vcpu_flags.cocci b/cocci_refactor/vcpu_flags.cocci
deleted file mode 100644
index 609bb7bd7bd0..000000000000
--- a/cocci_refactor/vcpu_flags.cocci
+++ /dev/null
@@ -1,10 +0,0 @@
-// spatch --sp-file el2_def_flags.cocci --no-includes --include-headers  --dir arch/arm64
-
-// <smpl>
-@@
-expression vcpu;
-@@
-
-- vcpu->arch.flags
-+ vcpu_flags(vcpu)
-// </smpl>
\ No newline at end of file
diff --git a/cocci_refactor/vcpu_hyp_accessors.cocci b/cocci_refactor/vcpu_hyp_accessors.cocci
deleted file mode 100644
index 506b56f7216f..000000000000
--- a/cocci_refactor/vcpu_hyp_accessors.cocci
+++ /dev/null
@@ -1,35 +0,0 @@
-// <smpl>
-
-/*
-spatch --sp-file vcpu_hyp_accessors.cocci --dir arch/arm64 --include-headers --in-place
-*/
-
-@find_defines@
-identifier macro;
-identifier vcpu;
-position p;
-@@
-#define macro(vcpu) vcpu@p
-
-@@
-identifier vcpu;
-position p != find_defines.p;
-@@
-(
-- vcpu@p->arch.hcr_el2
-+ vcpu_hcr_el2(vcpu)
-|
-- vcpu@p->arch.mdcr_el2
-+ vcpu_mdcr_el2(vcpu)
-|
-- vcpu@p->arch.vsesr_el2
-+ vcpu_vsesr_el2(vcpu)
-|
-- vcpu@p->arch.fault
-+ vcpu_fault(vcpu)
-|
-- vcpu@p->arch.flags
-+ vcpu_flags(vcpu)
-)
-
-// </smpl>
diff --git a/cocci_refactor/vcpu_hyp_state.cocci b/cocci_refactor/vcpu_hyp_state.cocci
deleted file mode 100644
index 3005a6f11871..000000000000
--- a/cocci_refactor/vcpu_hyp_state.cocci
+++ /dev/null
@@ -1,30 +0,0 @@
-// <smpl>
-
-// spatch --sp-file vcpu_hyp_state.cocci --no-includes --include-headers  --dir arch/arm64 --very-quiet --in-place
-
-@@
-expression vcpu;
-@@
-- vcpu->arch.
-+ vcpu->arch.hyp_state.
-(
- hcr_el2
-|
- mdcr_el2
-|
- vsesr_el2
-|
- fault
-|
- flags
-|
- sysregs_loaded_on_cpu
-)
-
-@@
-identifier arch;
-@@
-- arch.fault
-+ arch.hyp_state.fault
-
-// </smpl>
\ No newline at end of file
diff --git a/cocci_refactor/vgic3_cpu.cocci b/cocci_refactor/vgic3_cpu.cocci
deleted file mode 100644
index f7495b2e49cb..000000000000
--- a/cocci_refactor/vgic3_cpu.cocci
+++ /dev/null
@@ -1,118 +0,0 @@
-// <smpl>
-
-/*
-spatch --sp-file vgic3_cpu.cocci arch/arm64/kvm/hyp/vgic-v3-sr.c --in-place
-*/
-
-
-@@
-identifier vcpu;
-fresh identifier vcpu_hyps = vcpu ## "_hyps";
-@@
-(
-- kvm_vcpu_sys_get_rt
-+ kvm_hyp_state_sys_get_rt
-|
-- kvm_vcpu_get_esr
-+ kvm_hyp_state_get_esr
-)
-- (vcpu)
-+ (vcpu_hyps)
-
-@add_cpu_if@
-identifier func;
-identifier c;
-@@
-int func(
-- struct kvm_vcpu *vcpu
-+ struct vgic_v3_cpu_if *cpu_if
- , ...)
-{
-<+...
-- vcpu->arch.vgic_cpu.vgic_v3.c
-+ cpu_if->c
-...+>
-}
-
-@@
-identifier func = add_cpu_if.func;
-@@
- func(
-- vcpu
-+ cpu_if
- , ...
- )
-
-
-@add_vgic_ctxt_hyps@
-identifier func;
-@@
-void func(
-- struct kvm_vcpu *vcpu
-+ struct vgic_v3_cpu_if *cpu_if, struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps
- , ...) {
-?- struct vcpu_hyp_state *vcpu_hyps = ...;
-?- struct kvm_cpu_context *vcpu_ctxt = ...;
- ...
- }
-
-@@
-identifier func = add_vgic_ctxt_hyps.func;
-@@
- func(
-- vcpu,
-+ cpu_if, vcpu_ctxt, vcpu_hyps,
- ...
- )
-
-
-@find_calls@
-identifier fn;
-type a, b;
-@@
-- void (*fn)(struct kvm_vcpu *, a, b);
-+ void (*fn)(struct vgic_v3_cpu_if *, struct kvm_cpu_context *, struct vcpu_hyp_state *, a, b);
-
-@@
-identifier fn = find_calls.fn;
-identifier a, b;
-@@
-- fn(vcpu, a, b);
-+ fn(cpu_if, vcpu_ctxt, vcpu_hyps, a, b);
-
-@@
-@@
-int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu) {
-+ struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-...
-}
-
-@remove@
-identifier func;
-identifier vcpu;
-fresh identifier vcpu_ctxt = vcpu ## "_ctxt";
-fresh identifier vcpu_hyps = vcpu ## "_hyps";
-identifier hyps_remove;
-identifier ctxt_remove;
-@@
-func(...,
-- struct kvm_vcpu *vcpu
-+ struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps
-,...) {
-?- struct vcpu_hyp_state *hyps_remove = ...;
-?- struct kvm_cpu_context *ctxt_remove = ...;
-... when != vcpu
- }
-
-@@
-identifier vcpu;
-fresh identifier vcpu_ctxt = vcpu ## "_ctxt";
-fresh identifier vcpu_hyps = vcpu ## "_hyps";
-identifier remove.func;
-@@
- func(
-- vcpu
-+ vcpu_ctxt, vcpu_hyps
-  , ...)
-
-// </smpl>
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
