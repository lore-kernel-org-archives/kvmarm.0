Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06E52874FB
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 22:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765579373; cv=pass; b=dfu7dAH1NflFA5gnaVYqc/6loMvzkW8E1exwTGBHMUnoCbsdeBM83fcFaJvBJv+L3ToEmVlqLDmCiNkdjmEDpOEAzeqW1LqAitO8fTrzTVoQAO1yzq7vKn9ciNLM9+IsMPtdRjTrrRj6Xf5SdLJI00VcRjY7PiaSN1Qs7TBneIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765579373; c=relaxed/simple;
	bh=YOqs0y1dcE5aW9PtDdEhj4UaUFEQubxbJwDSGVsK6mc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hMYKyzRI/QDvmXiMYPg+qUVh1tCxHaUGuFQAU+DrFrHkWD3Zyo6lrc8kS231xI7Ai8HkFzaDk27reJ2EZs7lowu/dRksYE/av8JZ2i4HS5tboCuB8vqB1HCVI16puXXynqg1JOgIJTOBefm4m5nPaoOPeszRHC0dpCH132XYTR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BExf6Yll; arc=pass smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BExf6Yll"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4779a4fb9bfso152275e9.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 14:42:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765579369; cv=none;
        d=google.com; s=arc-20240605;
        b=QfaMtV1JLYJ1/dvtjeW5m65Z/Ea+IPj9BAM0ai2ZNF1G/D3ZMnwOtCSEW9ZjMPsvCe
         CUvbQsH76vhF2IkdpZm8I289r5itDkSApRf0lPTgKFR3Si/tp4YS34jfe3MapWZ8qRPp
         JtzBPmvXs4pJEcWngTBclUp09SODinMRzQigipvzYdSqTrHEER6pGRTvjRYdozQdXtem
         NEH2vN09Cq1ePzwj/8DGdHryyZ4oVds/8f7AbUwZsFrmkq/h3tBfIcakv7ooVUyXOU7t
         2YvJohA9F1r3M4ojgbvLBU+TEzkycfknb0asBw6ziC21QzZsxgcyr9niAAOOb5vFThUV
         0gAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GCLPUx88ZdHJmS22/LgzBzk06kvYjDGU5Iph4HFcUyk=;
        fh=Q8MfT5Unsg33T9slXEIiM2vj70kbqwqcmenaJ5W+f8c=;
        b=MZFAYOnlRYfvXt1bduShE2/YqE/oCiAfMkhLyZ5c7bMbI30xkRF87bkx+HnEEWS+Er
         Dh7i3DeI9U/K4WSOjlvloTk19hftqNNxfZ0qHW+VPykvNEYINtPKxuD9oBgrSX5zMUlf
         NX43nodhCNqk+DY14kZJgsVBwyyWDI5Xli3Cq12uYrapeYTCCQGsC8dUWuJ31nbEUnt9
         yJcW6kilNMt76O7FRe9N/qxKl3qCBsN34XjsXjN5BtWrVJBmuUvBFO6Rx6MkjxxDmNDf
         H2zL1LMR3LgXpYh6X1bFsCONGDhQuxsMwTGuIXlcdRps10UOY9ZzxdbMv/pzFY7hx0u2
         wO3w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765579369; x=1766184169; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GCLPUx88ZdHJmS22/LgzBzk06kvYjDGU5Iph4HFcUyk=;
        b=BExf6Yll9DeK8W3O8qwqIaFZTxGqD5gC6Rh6J5ZqAGukiaM3rQS0gNKsDlRDePhkJr
         4BRhAJVi+Z/heoQk1ZWCdwyAN8rAV79w5CW5TWeINrsYQIVMbCNWh+A3mwqgM+/2dPDk
         A+kf0BvEtW1G+Fa3/YNl8kAj/Wncr7LuK5hkNdGJVYQvj4fbvq8ygNOrpyYlxMTt4bGu
         9YH6euoYBnSO1IevLhxU86mhdxwsKlRDDcJpMjzrn0yloOuj+6n8/3TjWw44RgnKShYY
         jn0HgMhMpMcFKV5U0xbhea7k1BG0sVLbQfaITNYNcSeNI+KdLfXz3CdT8QV7sQCu67MA
         S6eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765579369; x=1766184169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GCLPUx88ZdHJmS22/LgzBzk06kvYjDGU5Iph4HFcUyk=;
        b=VC6PylukSv3AnzeRAR7LxxX6j/IuXtbifZcAhu4WWAUHqiMW1pEx1oGiqjuvxZi7sZ
         f2LbY8dmyU4MYOMXI948isM0G6PjakAvtvTXYVQD2HjYe54ECNsGKn5MuQgzi7N0hMv9
         lAENBrVQw0xy5qEFK2FdiJwlQ8QosmHMxb9L5DUoCGTdRQjjmhSylA5VlsP8Dk+tvu7M
         +K9EOsHm/MPYCm5inbL+rPd4pUa2Bm1OfStqVDd7algK4dm+BuMIaZDe4VaUIsJi+u6g
         AQ3Pd9FuiUvqKCjO21rpEM4V804bX+KpfqzUdD/OBez4qIv3W1wVclXDXPO6pdU6UmNo
         VrWA==
X-Forwarded-Encrypted: i=1; AJvYcCV05VHGDDK+qY20Ha2gd8L7mqFkxCWedf/Bglvfr5WhnYrjmCb7Wt6xsyf4wCafejqUZG4XDKI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLipWdeurcruhuqLNsuzWjVwU32y3vo7X/THlDg20ho2NmEmjx
	S1xwozBu8oYm9MhSuOe3ibMM+Pbn9OOgHPBU9cGXV/ZMtr3GGYbmKO3m4SeFCeInBOUihHbccDR
	3c/k0UA+LU1BzCpTbsqyxqracSpby6ORPhc9p/T+J
X-Gm-Gg: AY/fxX4ZiySUBK6jYuFamGbRCClE0IgwmhOT6bwxanlb1mcDxN6JK+HdOlO8OZF0dVQ
	PxO/n4ZDC8OuEwBrQIIGarZjPOW73024DDrbUqKSAag7pV3tuQeup8ZDeW6sIZkbOBlzJxxAq+V
	DMjI6BRMnUEBcSqdhbDDgc3TdD6WiXajUMDI6To6k9j5p3pFmvU/Yp5y3lVD1qvr7+PsI/5t7wL
	HIWXXb9vqSikP2GlMlKAuejTyLuVoFFZtf19gYfCVi9iyToBcFJoK8l0jXIRxhe8u+hprnEOVPk
	Isax2rPmkPeNm3GgjlWM897pfwRy
X-Google-Smtp-Source: AGHT+IGycUDLgfiYo6g1zTqU/jgYJfkyvEbX43ygSbXNWZeJGMb236iTpZ88xPMSD0uFM0/wQUo7NV0Ahf4F4PzTuS8=
X-Received: by 2002:a05:600c:83c4:b0:477:86fd:fb18 with SMTP id
 5b1f17b1804b1-47a94869ebbmr337505e9.8.1765579369059; Fri, 12 Dec 2025
 14:42:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013185903.1372553-1-jiaqiyan@google.com> <20251013185903.1372553-3-jiaqiyan@google.com>
 <3061f5f8-cef0-b7b1-c4de-f2ceea29af9a@huawei.com> <CACw3F51mRXCDz7Hd4Vve98NoskhB2cSc88zAGfd6Hwr4uCBxPA@mail.gmail.com>
 <dbcfb853-5853-5967-1bf9-76c6b3839717@huawei.com>
In-Reply-To: <dbcfb853-5853-5967-1bf9-76c6b3839717@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 12 Dec 2025 14:42:37 -0800
X-Gm-Features: AQt7F2rl2f5bneq6f6crNhZuIfA-M_NY1_crL-5oW0NtvHoqkZtXMaIozb_07o8
Message-ID: <CACw3F51FQwCLe17E4VC5wtpnCyuBOMrchvoBYCcwTxPkuxD+fg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] KVM: selftests: Test for KVM_EXIT_ARM_SEA
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, duenwen@google.com, 
	rananta@google.com, jthoughton@google.com, vsethi@nvidia.com, jgg@nvidia.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, 
	will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, shuah@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2025 at 1:22=E2=80=AFAM Zenghui Yu <yuzenghui@huawei.com> w=
rote:
>
> On 2025/12/12 9:53, Jiaqi Yan wrote:
> > On Thu, Dec 11, 2025 at 5:02=E2=80=AFAM Zenghui Yu <yuzenghui@huawei.co=
m> wrote:
> > >
> > > I can also hit this ASSERT with:
> > >
> > > Random seed: 0x6b8b4567
> > > # Mapped 0x40000 pages: gva=3D0x80000000 to gpa=3D0xff80000000
> > > # Before EINJect: data=3D0xbaadcafe
> > > # EINJ_GVA=3D0x81234bad, einj_gpa=3D0xff81234bad, einj_hva=3D0xffff41=
234bad,
> > > einj_hpa=3D0x2841234bad
> > > # echo 0x10 > /sys/kernel/debug/apei/einj/error_type - done
> > > # echo 0x2 > /sys/kernel/debug/apei/einj/flags - done
> > > # echo 0x2841234bad > /sys/kernel/debug/apei/einj/param1 - done
> > > # echo 0xffffffffffffffff > /sys/kernel/debug/apei/einj/param2 - done
> > > # echo 0x1 > /sys/kernel/debug/apei/einj/notrigger - done
> > > # echo 0x1 > /sys/kernel/debug/apei/einj/error_inject - done
> > > # Memory UER EINJected
> > > # Dump kvm_run info about KVM_EXIT_MMIO
> > > # kvm_run.arm_sea: esr=3D0xffff90ba0040, flags=3D0x691000
> > > # kvm_run.arm_sea: gva=3D0x100000008, gpa=3D0
> > > =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> > >   arm64/sea_to_user.c:207: exit_reason =3D=3D (41)
> > >   pid=3D38023 tid=3D38023 errno=3D4 - Interrupted system call
> > >      1  0x0000000000402d1b: run_vm at sea_to_user.c:207
> > >      2  0x0000000000402467: main at sea_to_user.c:330
> > >      3  0x0000ffff9122b03f: ?? ??:0
> > >      4  0x0000ffff9122b117: ?? ??:0
> > >      5  0x00000000004026ef: _start at ??:?
> > >   Wanted KVM exit reason: 41 (ARM_SEA), got: 6 (MMIO)
> > >
> > > Not sure what's wrong it..
> >
> > Does your test machine have SDEI or SCI enabled for host APEI? Do you
> > see any kernel log from "Memory failure:" saying hugetlb page
> > recovered, and recovered significant earlier than the KVM exit here.
> > It maybe the kernel has already unmapped hugepage in response to SDEI
> > or SCI before this test actually consumes memory error, so no SEA is
> > actually triggered.
>
> No kernel log was printed when I saw this failure.

Hmm, and even no CPER logged by APEI/GHES? That makes me suspect the
error wasn't injected successfully.

In that case, I found a bug in sea_to_user.c: GUEST_FAIL is not
handled by run_vm and results in unhandled MMIO.

Here is a fix I tested on my side, with some other minor fixes. Do you
mind trying it?

commit b96a92d1006fbe2752ba133eb76b0c45c9c54265
Author: Jiaqi Yan <jiaqiyan@google.com>
Date:   Fri Dec 12 22:27:53 2025 +0000

    KVM: selftests: Improve sea_to_user test

    Several improvments to the test for KVM_EXIT_ARM_SEA:
    - refactor run_vm to catch GUEST_FAIL, instead of causing confusing
    kvm exit with unhandled MMIO
    - sync far_invalid to guest
    - exit with KSFT_SKIP or KSFT_FAIL when should

    Change-Id: I8b735de3b669297f0638bea2d32a0b36211f7f5c

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c
b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index 573dd790aeb8e..6fd3cd881b415 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -98,11 +98,15 @@ static void write_einj_entry(const char
*einj_path, uint64_t val)

 static void inject_uer(uint64_t paddr)
 {
-       if (access("/sys/firmware/acpi/tables/EINJ", R_OK) =3D=3D -1)
-               ksft_test_result_skip("EINJ table no available in firmware"=
);
+       if (access("/sys/firmware/acpi/tables/EINJ", R_OK) =3D=3D -1) {
+               ksft_test_result_skip("EINJ table not available in firmware=
\n");
+               exit(KSFT_SKIP);
+       }

-       if (access(EINJ_ETYPE, R_OK | W_OK) =3D=3D -1)
+       if (access(EINJ_ETYPE, R_OK | W_OK) =3D=3D -1) {
                ksft_test_result_skip("EINJ module probably not loaded?\n")=
;
+               exit(KSFT_SKIP);
+       }

        write_einj_entry(EINJ_ETYPE, ERROR_TYPE_MEMORY_UER);
        write_einj_entry(EINJ_FLAGS, MASK_MEMORY_UER);
@@ -123,12 +127,13 @@ static void sigbus_signal_handler(int sig,
siginfo_t *si, void *v)
        ksft_print_msg("SIGBUS (%d) received, dumping siginfo...\n", sig);
        ksft_print_msg("si_signo=3D%d, si_errno=3D%d, si_code=3D%d, si_addr=
=3D%p\n",
                       si->si_signo, si->si_errno, si->si_code, si->si_addr=
);
-       if (si->si_code =3D=3D BUS_MCEERR_AR)
+       if (si->si_code =3D=3D BUS_MCEERR_AR) {
                ksft_test_result_skip("SEA is claimed by host APEI\n");
-       else
+               exit(KSFT_SKIP);
+       } else {
                ksft_test_result_fail("Exit with signal unhandled\n");
-
-       exit(0);
+               exit(KSFT_FAIL);
+       }
 }

 static void setup_sigbus_handler(void)
@@ -158,7 +163,6 @@ static void expect_sea_handler(struct ex_regs *regs)
 {
        u64 esr =3D read_sysreg(esr_el1);
        u64 far =3D read_sysreg(far_el1);
-       bool expect_far_invalid =3D far_invalid;

        GUEST_PRINTF("Handling Guest SEA\n");
        GUEST_PRINTF("ESR_EL1=3D%#lx, FAR_EL1=3D%#lx\n", esr, far);
@@ -166,7 +170,7 @@ static void expect_sea_handler(struct ex_regs *regs)
        GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_CUR);
        GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);

-       if (expect_far_invalid) {
+       if (far_invalid) {
                GUEST_ASSERT_EQ(esr & ESR_ELx_FnV, ESR_ELx_FnV);
                GUEST_PRINTF("Guest observed garbage value in FAR\n");
        } else {
@@ -185,25 +189,19 @@ static void vcpu_inject_sea(struct kvm_vcpu *vcpu)
        vcpu_events_set(vcpu, &events);
 }

-static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+static void validate_kvm_exit_arm_sea(struct kvm_vm *vm, struct kvm_vcpu *=
vcpu)
 {
-       struct ucall uc;
-       bool guest_done =3D false;
        struct kvm_run *run =3D vcpu->run;
        u64 esr;

-       /* Resume the vCPU after error injection to consume the error. */
-       vcpu_run(vcpu);
+       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);

-       ksft_print_msg("Dump kvm_run info about KVM_EXIT_%s\n",
-                      exit_reason_str(run->exit_reason));
+       ksft_print_msg("Dumping kvm_run as arm_sea:\n");
        ksft_print_msg("kvm_run.arm_sea: esr=3D%#llx, flags=3D%#llx\n",
                       run->arm_sea.esr, run->arm_sea.flags);
        ksft_print_msg("kvm_run.arm_sea: gva=3D%#llx, gpa=3D%#llx\n",
                       run->arm_sea.gva, run->arm_sea.gpa);

-       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
-
        esr =3D run->arm_sea.esr;
        TEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_LOW);
        TEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
@@ -211,39 +209,48 @@ static void run_vm(struct kvm_vm *vm, struct
kvm_vcpu *vcpu)
        TEST_ASSERT_EQ((esr & ESR_ELx_INST_SYNDROME), 0);
        TEST_ASSERT_EQ(esr & ESR_ELx_VNCR, 0);

-       if (!(esr & ESR_ELx_FnV)) {
-               ksft_print_msg("Expect gva to match given FnV bit is 0\n");
+       far_invalid =3D esr & ESR_ELx_FnV;
+       sync_global_to_guest(vm, far_invalid);
+
+       if (!far_invalid) {
+               ksft_print_msg("Expect gva to match\n");
                TEST_ASSERT_EQ(run->arm_sea.gva, EINJ_GVA);
        }

        if (run->arm_sea.flags & KVM_EXIT_ARM_SEA_FLAG_GPA_VALID) {
-               ksft_print_msg("Expect gpa to match given
KVM_EXIT_ARM_SEA_FLAG_GPA_VALID is set\n");
+               ksft_print_msg("Expect gpa to match\n");
                TEST_ASSERT_EQ(run->arm_sea.gpa, einj_gpa & PAGE_ADDR_MASK)=
;
        }
+}

-       far_invalid =3D esr & ESR_ELx_FnV;
-
-       /* Inject a SEA into guest and expect handled in SEA handler. */
-       vcpu_inject_sea(vcpu);
+static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+       struct ucall uc;
+       bool guest_done =3D false;

        /* Expect the guest to reach GUEST_DONE gracefully. */
        do {
                vcpu_run(vcpu);
-               switch (get_ucall(vcpu, &uc)) {
-               case UCALL_PRINTF:
-                       ksft_print_msg("From guest: %s", uc.buffer);
-                       break;
-               case UCALL_DONE:
-                       ksft_print_msg("Guest done gracefully!\n");
-                       guest_done =3D 1;
-                       break;
-               case UCALL_ABORT:
-                       ksft_print_msg("Guest aborted!\n");
-                       guest_done =3D 1;
-                       REPORT_GUEST_ASSERT(uc);
-                       break;
-               default:
-                       TEST_FAIL("Unexpected ucall: %lu\n", uc.cmd);
+               if (vcpu->run->exit_reason =3D=3D KVM_EXIT_ARM_SEA) {
+                       validate_kvm_exit_arm_sea(vm, vcpu);
+                       vcpu_inject_sea(vcpu);
+               } else {
+                       switch (get_ucall(vcpu, &uc)) {
+                       case UCALL_PRINTF:
+                               ksft_print_msg("From guest: %s", uc.buffer)=
;
+                               break;
+                       case UCALL_DONE:
+                               ksft_print_msg("Guest done gracefully!\n");
+                               guest_done =3D 1;
+                               break;
+                       case UCALL_ABORT:
+                               ksft_print_msg("Guest aborted!\n");
+                               guest_done =3D 1;
+                               REPORT_GUEST_ASSERT(uc);
+                               break;
+                       default:
+                               TEST_FAIL("Unexpected ucall: %lu\n", uc.cmd=
);
+                       }
                }
        } while (!guest_done);
 }

>
> Thanks,
> Zenghui
