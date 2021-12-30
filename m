Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D1AC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 30 Dec 2021 21:11:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68EB749EE3;
	Thu, 30 Dec 2021 16:11:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pWW55aEm1aOi; Thu, 30 Dec 2021 16:11:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3110549EE4;
	Thu, 30 Dec 2021 16:11:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA5F849EE2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 16:11:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q0lF3CWtILuD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Dec 2021 16:11:17 -0500 (EST)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4C6E49EE1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 16:11:17 -0500 (EST)
Received: by mail-pj1-f46.google.com with SMTP id
 v13-20020a17090a088d00b001b0e3a74cf7so16975529pjc.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 13:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=O9uAq6UJmnKzmV+AWu/IPUz6QsaX0JwW2QgMuru4++U=;
 b=CR4zvhEs4RsBKFZ7BYEUqjel7zmQtmB3npeTQLUP+BfmXKQ9xRKBBkzRMgmgwKiF9D
 oh7vh5kiHIlthNs5NuhIt8S+Tuv5Cktq6JLPKx6+QJKOpe9m2uOjqkBS+4Xpn7epigC3
 llMpxjWOr/MAiNBbpJu1FHx0yh+t0b1sITMewEYFI+Q323OnWlHiozlj/tIGiEdSDaQ/
 mcJTC/DEXV2Gp1IHgYvVEYb6R5lB87OMRV65kKvBIjh0c7rRAe1yozPo/Snp+/Ajru+i
 DhFUAbKoTz7iUm12rOYwWetKdrT2yJun3970QXsteW/DuWUwtFRKOuPRgIJ/U958N1s/
 8ZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=O9uAq6UJmnKzmV+AWu/IPUz6QsaX0JwW2QgMuru4++U=;
 b=V1RON6SFNbmPHE2G3SDL/9iYg/TtAoefs8ArzFBUfaL621PyY+vJfvg+GZMnHio8T4
 1m5/q6zs+FGYO0RQ57Cq+ywYiCDeqhTXpEVP7mJtqDZcB+WdnSFCLk86DdyKNcS6vscL
 g5uPtS9NvaZifbt+3Wa9B61R99U8cuuMiio3z6KceUbxMCLVk2qn5pa0DSYhtcnnWU9Z
 l4Xo6pV4x5OgC+fg3VvuTu+YvAj6Vj4TVc6HM2eyAjqufLfNsDRUffOQIiVbSvkOdFUA
 werjzOXgpXhgU/x7dVQ5F2RctEk8C4+2dnGFUJ3uAKfsFMmfAUWXHt8k5U/Tze3sM4S1
 t/gg==
X-Gm-Message-State: AOAM531zL4U6dykWGmzL93zPTxdfzJcOOD1vyTs9UjIK7wD0GrE/1RJ+
 AWm5E5fDyJ3vCh6C23Q8ZUsXjQ==
X-Google-Smtp-Source: ABdhPJx+cx79RAtXdUYF67GlhN1QHB5cXYw3p1t/cfWfSRpNCjl5aI0OKLoaNRWR8P1NzXt24TTVdA==
X-Received: by 2002:a17:902:bc82:b0:148:eb68:f6dd with SMTP id
 bb2-20020a170902bc8200b00148eb68f6ddmr32472643plb.98.1640898676281; 
 Thu, 30 Dec 2021 13:11:16 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id e7sm7345204pfv.9.2021.12.30.13.11.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Dec 2021 13:11:15 -0800 (PST)
Date: Thu, 30 Dec 2021 21:11:12 +0000
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Subject: Re: [RFC PATCH 00/10] KVM: selftests: Add support for
 test-selectable ucall implementations
Message-ID: <Yc4gcJdhxthBKUUd@google.com>
References: <20211210164620.11636-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211210164620.11636-1-michael.roth@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Orr <marcorr@google.com>,
 linux-kselftest@vger.kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Nathan Tempelman <natet@google.com>,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
 Mingwei Zhang <mizhang@google.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, Varad Gautam <varad.gautam@suse.com>,
 Jim Mattson <jmattson@google.com>, Steve Rutherford <srutherford@google.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw@amazon.co.uk>
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

On Fri, Dec 10, 2021, Michael Roth wrote:
> To summarize, x86 relies on a ucall based on using PIO intructions to generate
> an exit to userspace and provide the GVA of a dynamically-allocated ucall
> struct that resides in guest memory and contains information about how to
> handle/interpret the exit. This doesn't work for SEV guests for 3 main reasons:
> 
>   1) The guest memory is generally encrypted during run-time, so the guest
>      needs to ensure the ucall struct is allocated in shared memory.
>   2) The guest page table is also encrypted, so the address would need to be a
>      GPA instead of a GVA.
>   3) The guest vCPU register may also be encrypted in the case of
>      SEV-ES/SEV-SNP, so the approach of examining vCPU register state has
>      additional requirements such as requiring guest code to implement a #VC
>      handler that can provide the appropriate registers via a vmgexit.
> 
> To address these issues, the SEV selftest RFC1 patchset introduced a set of new
> SEV-specific interfaces that closely mirrored the functionality of
> ucall()/get_ucall(), but relied on a pre-allocated/static ucall buffer in
> shared guest memory so it that guest code could pass messages/state to the host
> by simply writing to this pre-arranged shared memory region and then generating
> an exit to userspace (via a halt instruction).
> 
> Paolo suggested instead implementing support for test/guest-specific ucall
> implementations that could be used as an alternative to the default PIO-based
> ucall implementations as-needed based on test/guest requirements, while still
> allowing for tests to use a common set interfaces like ucall()/get_ucall().

This all seems way more complicated than it needs to be.  HLT is _worse_ than
PIO on x86 because it triggers a userspace exit if and only if the local APIC is
not in-kernel.  That is bound to bite someone.  The only issue with SEV is the
address, not the VM-Exit mechanism.  That doesn't change with SEV-ES, SEV-SNP,
or TDX, as PIO and HLT will both get reflected as #VC/#VE, i.e. the guest side
needs to be updated to use VMGEXIT/TDCALL no matter what, at which point having
the hypercall request PIO emulation is just as easy as requesting HLT.

I also don't like having to differentiate between a "shared" and "regular" ucall.
I kind of like having to explicitly pass the ucall object being used, but that
puts undue burden on simple single-vCPU tests.

The inability to read guest private memory is really the only issue, and that can
be easily solved without completely revamping the ucall framework, and without
having to update a huge pile of tests to make them place nice with private memory.

This would also be a good opportunity to clean up the stupidity of tests having to
manually call ucall_init(), drop the unused/pointless @arg from ucall_init(), and
maybe even fix arm64's lurking landmine of not being SMP safe (the address is shared
by all vCPUs).

To reduce the burden on tests and avoid ordering issues with creating vCPUs,
allocate a ucall struct for every possible vCPU when the VM is created and stuff
the GPA of the struct in the struct itself so that the guest can communicate the
GPA instead of the GVA.  Then confidential VMs just need to make all structs shared.

If all architectures have a way to access a vCPU ID, the ucall structs could be
stored as a simple array.  If not, a list based allocator would probably suffice.

E.g. something like this, except the list management is in common code instead of
x86, and also delete all the per-test ucall_init() calls.

diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index a3489973e290..9aab6407bd42 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -8,19 +8,59 @@

 #define UCALL_PIO_PORT ((uint16_t)0x1000)

-void ucall_init(struct kvm_vm *vm, void *arg)
+static struct list_head *ucall_list;
+
+void ucall_init(struct kvm_vm *vm)
 {
+       struct ucall *ucalls;
+       int nr_cpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
+       int i;
+
+       TEST_ASSERT(!ucall_list, "ucall() can only be used by one VM at a time");
+
+       INIT_LIST_HEAD(&vm->ucall_list);
+
+       ucalls = vm_vaddr_alloc(nr_cpus * sizeof(struct ucall));
+       ucall_make_shared(ucall_list, <size>);
+
+       for (i = 0; i < nr_cpus; i++) {
+               ucalls[i].gpa = addr_gva2gpa(vm, &ucalls[i]);
+
+               list_add(&vm->ucall_list, &ucalls[i].list)
+       }
+
+       ucall_list = &vm->ucall_list;
+       sync_global_to_guest(vm, ucall_list);
 }

 void ucall_uninit(struct kvm_vm *vm)
 {
+       ucall_list =  NULL;
+       sync_global_to_guest(vm, ucall_list);
+}
+
+static struct ucall *ucall_alloc(void)
+{
+       struct ucall *uc;
+
+       /* Is there a lock primitive for the guest? */
+       lock_something(&ucall_lock);
+       uc = list_first_entry(ucall_list, struct ucall, list);
+
+       list_del(&uc->list);
+       unlock_something(&ucall_lock);
+}
+
+static void ucall_free(struct ucall *uc)
+{
+       lock_something(&ucall_lock);
+       list_add(&uc->list, ucall_list);
+       unlock_something(&ucall_lock);
 }

 void ucall(uint64_t cmd, int nargs, ...)
 {
-       struct ucall uc = {
-               .cmd = cmd,
-       };
+       struct ucall *uc = ucall_alloc();
        va_list va;
        int i;

@@ -32,7 +72,9 @@ void ucall(uint64_t cmd, int nargs, ...)
        va_end(va);

        asm volatile("in %[port], %%al"
-               : : [port] "d" (UCALL_PIO_PORT), "D" (&uc) : "rax", "memory");
+               : : [port] "d" (UCALL_PIO_PORT), "D" (uc->gpa) : "rax", "memory");
+
+       ucall_free(uc);
 }

 uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
@@ -47,7 +89,7 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
                struct kvm_regs regs;

                vcpu_regs_get(vm, vcpu_id, &regs);
-               memcpy(&ucall, addr_gva2hva(vm, (vm_vaddr_t)regs.rdi),
+               memcpy(&ucall, addr_gpa2hva(vm, (vm_paddr_t)regs.rdi),
                       sizeof(ucall));

                vcpu_run_complete_io(vm, vcpu_id);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
