Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18D51F78E0
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 06:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753857911; cv=none; b=urVXCWYiKMQ7xP+fkH3BAylVSKmCtUFciWxC4eMzb5HFrtyYv0b31JYQcyRrmz3A9bVeZAdPV7EIHxMte7wiuqFuj06Imb8kgGOjNe7R3w4DZvN3sD84VoyrC/cCAFrBL2NtrIIQhlIOYduhxxMo/Jcv3oM/3EbOAuHIxt/zi44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753857911; c=relaxed/simple;
	bh=jNVURA18k9N/tg357HCFv05U9rIUf2FI6eipsrsVGnw=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=BGBS/MEBcf7447W0sYKFgrINeOKviOZzv4VFljVjl9R4ol6tFKwpYiAz730wkVEvvo8tXgfrNFCZvINFYGagedc/M+OHDNM3CAziX+k+nWbgGf6TBxxQDZTF438XGOFgnvEADL414jtZltd5KJlxQVr7cT75d6gRDMxG67EY37E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LZterDdR; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LZterDdR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753857905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JrAp38vK4enw6Q0yIyw2K+Bi1i0jWc5saQVy5NUb5F0=;
	b=LZterDdRiOvHbh/nLmIL5GfVuVYwA8QXiL5o0QXO6h5a8yuZ+GbL6puDQNHNuL60cYnHcq
	EVfc7saOzBKUhHbeBNUWbiQT7X4nNlj5L0DV23xUtRlUUEqE0VaF+cEmwX8W4Y1IVf5Zrm
	P6du/rUlCp4LaNKlmtTHeJ7m3wunkww=
From: Itaru Kitayama <itaru.kitayama@linux.dev>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: KVM selftest for L2 guest execution fails  
Message-Id: <C37BCE4D-0958-4C74-BEFC-F3A7A689A848@linux.dev>
Date: Wed, 30 Jul 2025 15:44:48 +0900
To: kvmarm@lists.linux.dev
X-Migadu-Flow: FLOW_OUT

Hi,
My small kvm sefltest tested on the kvmarm/next with NV2+VHE on FVP =
fails:

# ./arm64/test5
Random seed: 0x6b8b4567
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  lib/kvm_util.c:1746: !ret
  pid=3D257 tid=3D257 errno=3D11 - Resource temporarily unavailable
sh: line 1: addr2line: command not found
  KVM_RUN failed, rc: -1 errno: 11 (Resource temporarily unavailable)

Below is the test code, am I doing still wrong?

Thanks,
Itaru.

 // SPDX-License-Identifier: GPL-2.0-only

#include "test_util.h"
#include "kvm_util.h"
#include "processor.h"
#include "ucall.h"

#define GUEST_SYNC_VAL 0x1234
#define UCALL_GPA 0x500000

static void l1_guest_code(void)
{
        /*
        * Set up HCR_EL2 to enable virtualization and nested support:
        *   - HCR_EL2.VM  =3D 1 (enable stage-2 translation)
        *   - HCR_EL2.NV  =3D 1 (trap to EL2 on guest HVC, SMC, WFI, =
etc.)
        *   - HCR_EL2.TGE =3D 1 (trap general exceptions in EL1 to EL2)
        */
       uint64_t hcr =3D (1UL << 0)   |  // VM
                      (1UL << 27)  |  // TGE
                      (1UL << 31);    // NV

       uint64_t spsr =3D 0x3c5;  // EL1h, AArch64, interrupts masked
       uint64_t l2_pc =3D 0x500000;     // L2 guest entry address
       uint64_t l2_sp =3D 0x510000;     // L2 guest stack

       __asm__ volatile(
               // Set up EL2 to EL1 return
               "msr hcr_el2, %[hcr]\n"
               "msr elr_el2, %[el1_pc]\n"
               "msr spsr_el2, %[spsr]\n"
               "mov sp, %[el1_sp]\n"
               "eret\n"
               :
               : [hcr] "r"(hcr),
                 [el1_pc] "r"(l2_pc),
                 [spsr] "r"(spsr),
                 [el1_sp] "r"(l2_sp)
               : "memory"
       );
}

static void l2_guest(void)
{
        asm volatile(
                "mov x0, #0x2a\n\t"
                "mov x1, %[ucall_sync]\n\t"
                "hvc #0\n\t"
                :
                : [ucall_sync] "i"(UCALL_SYNC)
                : "x0", "x1"
        );
}

static void guest_code()
{
       GUEST_SYNC(42);
}

int main(void)
{
        struct kvm_vm *vm;
        struct kvm_vcpu *vcpu;
        struct kvm_vcpu_init init =3D {};
        u64 feat =3D 0;

        /* NV2 must be supported or we skip */
        if (!kvm_check_cap(KVM_CAP_ARM_EL2))
                exit(KSFT_SKIP);

        feat |=3D BIT(KVM_ARM_VCPU_HAS_EL2); // Ask for virtual EL2

        vm =3D vm_create(1);

        vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
        init.features[0] =3D feat;

        vcpu =3D aarch64_vcpu_add(vm, 0, &init, l1_guest_code);

        // Backing memory for ucalls
        virt_pg_map(vm, UCALL_GPA, UCALL_GPA);
        ucall_init(vm, UCALL_GPA);

#define L2_MEM_START  0x500000
#define L2_MEM_SIZE   0x20000  // 128KB is enough

        vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, =
L2_MEM_START, 12, L2_MEM_SIZE / vm->page_size, KVM_MEM_LOG_DIRTY_PAGES);
        virt_pg_map(vm, 0x500000, 0x500000); // L2 code
        virt_pg_map(vm, 0x510000, 0x510000); // L2 stack
        memcpy(addr_gpa2hva(vm, 0x500000), l2_guest, vm->page_size);

        vcpu_run(vcpu);

        printf("vcpu_run exited: reason =3D %u\n", =
vcpu->run->exit_reason);

        struct ucall uc;
        switch (get_ucall(vcpu, &uc)) {
                case UCALL_SYNC:
                printf("Guest sync: val =3D 0x%lx\n", uc.args[1]);
                break;
                case UCALL_DONE:
                printf("Guest done\n");
                break;
                default:
                TEST_FAIL("Unknown ucall %lu\n", uc.cmd);
        }

        return 0;

}=
