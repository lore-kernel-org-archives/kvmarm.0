Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2BC32ED5D
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762530877; cv=none; b=Va0QmehwWwJVBaZEYkwlt22dc/lNuu4w8knMuKCa74KLHqIfa8rtSnFaj+tXdJW0gN1CADSz1/vgSnJ8nSPnkMthGEJziYOEmDIFV3+h8C47Ze/OKZrTcUph8d6WSmgi5M3g86t+vIH6QFnpj4QZeeEgGIHAJdwpC3oZjO7T8oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762530877; c=relaxed/simple;
	bh=EGnBT7eq4xDsLWoMBKHX6mL+kag/LZD0AS27uXDXkfo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=khmDmUj34uwARVpUyBoC/b6o/SXP+cfelfOv6EY8rbp7Dn8iU6EnrX9lK86+SumPThv3kvIPsf7zssevU/pUq9JavrcseGT1luYYZRhirzjJ4KuoA7yo2IMRSxO6NrfD2hQUbpud66DEe226rqzEcS/ZPCmwltUIFKZGXl2eUMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a9RSXv0+; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a9RSXv0+"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477171bbf51so7270345e9.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 07:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762530873; x=1763135673; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k6QqLCiZ3bKYilApTrBVoLgHK6pPaQj/ENLeWCSsRM0=;
        b=a9RSXv0+FOxBL/c3sZKouXIJXlw2qjiUVNWertAUBH7LtWUESKMNzeNbwUmCluN/rO
         5xidh+Po3BZ/f9lFzi8XK6xF8dT4+7aoe5SoULjaUtUNUOc7ViMhAssDHw/T2IR2hszP
         qCgYv1q6wV40uXESl3C033kzXABOVDLrXXCyATiB3hVFs9y5VVL8MWCeZ5ULTb6KdcDf
         6bjqN2hCMyQIApYnVu/NeSC6clNpSld9TRPGt+5/ZRpA65hC0XEeFEdvqIj6V7EU2Bhs
         i8QkBGq78n9mWcJXoyn6IVOHF4DshhQ3l8xqsoVeOXfveZ6a1hNrFIZzWN2wewN9In7m
         yK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762530873; x=1763135673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k6QqLCiZ3bKYilApTrBVoLgHK6pPaQj/ENLeWCSsRM0=;
        b=r/vDsfI0g/eINCn9XTnsPhVASjZlY0zmUxQgDCn5h55LDAgt3n6jxAnS7uipZKfCv/
         WVv/6/WWYTN1qtYw7V9qhpo2Ta4ooeyAGrNhlMX9atzT6NX6uqD0SdmrSVsY87g1brL3
         4w3lVRAB5ja1CyBaQdX4JYX3pGauybCEj6lOP+oL0PG+6kc38XOCa8k3Wxj7Vh/+vIO/
         3YvhVI0y17atKfj+4s923sxra5dSfp2sFVLUdcpjusIesjqMDhN2NFiux3YMsMMdAoix
         Ufkwhu+1OHGBBmezgCZ/a/9eXacykCqgoUKFZ4cYiPDFmWY4jhriztS2QLe1x68btPTm
         xCeA==
X-Forwarded-Encrypted: i=1; AJvYcCVH+A/xanqtrB/nRR/k2pR/Cnp0Alq2CLmyvzPB+mdhmD8Qf3L7OGSvukXPlXiK1pEvv+jNoSc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwyILkbfxmgnnenltJaj4v5MAGuKtXVDx0sfiFcOUy2kAoNMNuj
	fU0iipGrsODMxwb1uMIkJlGI5FN5eo/jisj7mEiHTVAFaPp+rvm0sQyUpDWX9UfnyvUmrxxKkh6
	RBeRsCjszcLIdsg==
X-Google-Smtp-Source: AGHT+IF10pfYz/aX86VOtk1/4ToFDHxeKDSFR7QzVJHGBwU7n9WXznaipUt0c+mOTXVDyymnjKnmVDeDshscaw==
X-Received: from wmbjd18.prod.google.com ([2002:a05:600c:68d2:b0:477:554c:6842])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e88:b0:471:14af:c715 with SMTP id 5b1f17b1804b1-4776bc9f963mr29299435e9.3.1762530872213;
 Fri, 07 Nov 2025 07:54:32 -0800 (PST)
Date: Fri, 07 Nov 2025 15:54:31 +0000
In-Reply-To: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
X-Mailer: aerc 0.21.0
Message-ID: <DE2L1SAOC55E.E4JY62WJQ2A8@google.com>
Subject: Re: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
From: Brendan Jackman <jackmanb@google.com>
To: Patrick Roy <patrick.roy@campus.lmu.de>
Cc: Patrick Roy <roypat@amazon.co.uk>, <pbonzini@redhat.com>, <corbet@lwn.net>, 
	<maz@kernel.org>, <oliver.upton@linux.dev>, <joey.gouly@arm.com>, 
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <catalin.marinas@arm.com>, 
	<will@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>, 
	<luto@kernel.org>, <peterz@infradead.org>, <willy@infradead.org>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <lorenzo.stoakes@oracle.com>, 
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <song@kernel.org>, <jolsa@kernel.org>, 
	<ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>, 
	<martin.lau@linux.dev>, <eddyz87@gmail.com>, <yonghong.song@linux.dev>, 
	<john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@fomichev.me>, 
	<haoluo@google.com>, <jgg@ziepe.ca>, <jhubbard@nvidia.com>, 
	<peterx@redhat.com>, <jannh@google.com>, <pfalcato@suse.de>, 
	<shuah@kernel.org>, <seanjc@google.com>, <kvm@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>, 
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, <bpf@vger.kernel.org>, 
	<linux-kselftest@vger.kernel.org>, <xmarcalx@amazon.co.uk>, 
	<kalyazin@amazon.co.uk>, <jackabt@amazon.co.uk>, <derekmn@amazon.co.uk>, 
	<tabba@google.com>, <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed Sep 24, 2025 at 3:10 PM UTC, Patrick Roy wrote:
> From: Patrick Roy <roypat@amazon.co.uk>
>
> [ based on kvm/next ]
>
> Unmapping virtual machine guest memory from the host kernel's direct map is a
> successful mitigation against Spectre-style transient execution issues: If the
> kernel page tables do not contain entries pointing to guest memory, then any
> attempted speculative read through the direct map will necessarily be blocked
> by the MMU before any observable microarchitectural side-effects happen. This
> means that Spectre-gadgets and similar cannot be used to target virtual machine
> memory. Roughly 60% of speculative execution issues fall into this category [1,
> Table 1].
>
> This patch series extends guest_memfd with the ability to remove its memory
> from the host kernel's direct map, to be able to attain the above protection
> for KVM guests running inside guest_memfd.
>
> Additionally, a Firecracker branch with support for these VMs can be found on
> GitHub [2].
>
> For more details, please refer to the v5 cover letter [v5]. No
> substantial changes in design have taken place since.
>
> === Changes Since v6 ===
>
> - Drop patch for passing struct address_space to ->free_folio(), due to
>   possible races with freeing of the address_space. (Hugh)
> - Stop using PG_uptodate / gmem preparedness tracking to keep track of
>   direct map state.  Instead, use the lowest bit of folio->private. (Mike, David)
> - Do direct map removal when establishing mapping of gmem folio instead
>   of at allocation time, due to impossibility of handling direct map
>   removal errors in kvm_gmem_populate(). (Patrick)
> - Do TLB flushes after direct map removal, and provide a module
>   parameter to opt out from them, and a new patch to export
>   flush_tlb_kernel_range() to KVM. (Will)
>
> [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
> [2]: https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding

I just got around to trying this out, I checked out this patchset using
its base-commit and grabbed the Firecracker branch. Things seem OK until
I set the secrets_free flag in the Firecracker config which IIUC makes
it set GUEST_MEMFD_FLAG_NO_DIRECT_MAP.

If I set it, I find the guest doesn't show anything on the console.
Running it in a VM and attaching GDB suggests that it's entering the
guest repeatedly, it doesn't seem like the vCPU thread is stuck or
anything. I'm a bit clueless about how to debug that (so far, whenever
I've broken KVM, things always exploded very dramatically).
 
Anyway, if I then kill the firecracker process, the host sometimes
crashes, I think this is the most suggestive splat I've seen:

[   99.673420][    T2] BUG: unable to handle page fault for address: ffff888012804000
[   99.676216][    T2] #PF: supervisor write access in kernel mode
[   99.678381][    T2] #PF: error_code(0x0002) - not-present page
[   99.680499][    T2] PGD 2e01067 P4D 2e01067 PUD 2e02067 PMD 12801063 PTE 800fffffed7fb020
[   99.683374][    T2] Oops: Oops: 0002 [#1] SMP
[   99.685004][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted 6.17.0-rc7-00366-g473c46a3cb2a #106 NONE 
[   99.688514][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.1 11/11/2019
[   99.691547][    T2] RIP: 0010:clear_page_erms+0x7/0x10
[   99.693440][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
[   99.700188][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
[   99.702321][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
[   99.705100][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
[   99.707861][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
[   99.710648][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[   99.713412][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
[   99.716191][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
[   99.719316][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   99.721648][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
[   99.724421][    T2] Call Trace:
[   99.725608][    T2]  <TASK>
[   99.726646][    T2]  get_page_from_freelist+0x6fe/0x14b0
[   99.728583][    T2]  ? fs_reclaim_acquire+0x43/0xe0
[   99.730325][    T2]  ? find_held_lock+0x2b/0x80
[   99.731965][    T2]  __alloc_frozen_pages_noprof+0x147/0x2d0
[   99.734003][    T2]  __alloc_pages_noprof+0x5/0x50
[   99.735766][    T2]  copy_process+0x1b1/0x1b30
[   99.737398][    T2]  ? lock_is_held_type+0x89/0x100
[   99.739157][    T2]  ? kthreadd+0x25/0x190
[   99.740664][    T2]  kernel_clone+0x59/0x390
[   99.742213][    T2]  ? kthreadd+0x25/0x190
[   99.743728][    T2]  kernel_thread+0x55/0x70
[   99.745310][    T2]  ? kthread_complete_and_exit+0x20/0x20
[   99.747265][    T2]  kthreadd+0x117/0x190
[   99.748748][    T2]  ? kthread_is_per_cpu+0x30/0x30
[   99.750509][    T2]  ret_from_fork+0x16b/0x1e0
[   99.752193][    T2]  ? kthread_is_per_cpu+0x30/0x30
[   99.753992][    T2]  ret_from_fork_asm+0x11/0x20
[   99.755717][    T2]  </TASK>
[   99.756861][    T2] CR2: ffff888012804000
[   99.758353][    T2] ---[ end trace 0000000000000000 ]---
[   99.760319][    T2] RIP: 0010:clear_page_erms+0x7/0x10
[   99.762209][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
[   99.769129][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
[   99.771297][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
[   99.774126][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
[   99.777013][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
[   99.779827][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[   99.782641][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
[   99.785487][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
[   99.788671][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   99.791012][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
[   99.793863][    T2] Kernel panic - not syncing: Fatal exception
[   99.796760][    T2] Kernel Offset: disabled
[   99.798296][    T2] ---[ end Kernel panic - not syncing: Fatal exception ]---

This makes me suspect the kvm_gmem_folio_restore_direct_map() path isn't
working or isn't getting called.

If anyone wants help trying to reproduce this let me know.
