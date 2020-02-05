Return-Path: <SRS0=/ADY=3Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13E3C35247
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 21:50:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40EE220730
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 21:50:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K+oSpEZi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40EE220730
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 647614A3B4;
	Wed,  5 Feb 2020 16:50:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KBkpeZXWxipX; Wed,  5 Feb 2020 16:50:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F28C4A54B;
	Wed,  5 Feb 2020 16:50:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AE394A534
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 16:50:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vY85V2t5quUY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Feb 2020 16:50:02 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F333040456
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 16:50:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580939401;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PHbfdi8ZRsyWVwogAfSeTTBoWRCjyatgWuvRLnXYIZA=;
 b=K+oSpEZi1purkKImoWXzN7Uvh/HweRCdbMcwyw7HyC6ysiXdVgeYbAwYNXRnQTVn65IJKO
 EdkBEOfMKonuukO7UCv57+OADJ4zT0TtGo9BPmIjSwWxQ4ZHU6dS5iXnS/kn8Gl53x2rs8
 AY/ilrHqnT4u74P7JFfg5msqYHjouiQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-nxkxZtK9OJ6NC9MKQI6T0Q-1; Wed, 05 Feb 2020 16:49:59 -0500
Received: by mail-qk1-f197.google.com with SMTP id z21so2227311qki.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Feb 2020 13:49:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hzR+kWwgje3yUYdtQN4kRBB1wzrOCH+ul+GIZRQLQpQ=;
 b=PcwtS6NApCPART1NG9Ns9dPmMjjEBSIaFlxOefiwEJUWfvrh9pYy2QZICwAA7Gb4d0
 hyqoq2Y+qBtNuVEhkdJtrhdROYXL3ZcgN8t/JuZ3S+1Cw3OvP3OoLg3WzulhFDTr77ZA
 vPjmOFlDyr/GGaEw/cpbmH6ABXBMzx5y1ahRaspGJi/7/Wd4P1juACKBUZE07TbgGFoC
 HGdNvw3W7PSiayyAMpGBMBRnV6jBdWv7went5pt16DacwGcrP89D1df5SrsgrllEgEyO
 gX3RjsXNswEwFDlcNvklD3cJqTuhIGlZB7p/IQXI1w1aDT9lug0K72GBUgcY2eqCWgoz
 LONw==
X-Gm-Message-State: APjAAAUwtIy6q2wf/JZEWsb7iQyvrrMxRUZWNOiagy//mVjfUacyU3Ht
 ba2mkWVFnJsXBEaGiAC3VxA2pJiJxwpRxI19GvP9QzBosicWOmF6NnlWVDyzUlvc98F87Cq2Rvn
 pJAb5+eNd7/FXVMWgd4bU0JTv
X-Received: by 2002:ac8:3886:: with SMTP id f6mr34654880qtc.160.1580939396236; 
 Wed, 05 Feb 2020 13:49:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqy5rpTfXYiWMOZY+w99nw37RTfo9i89EWpQ1VoSvOcWQbgR5Y78NjhhnEKvcMCS6bstDLPhlA==
X-Received: by 2002:ac8:3886:: with SMTP id f6mr34654854qtc.160.1580939395875; 
 Wed, 05 Feb 2020 13:49:55 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id x11sm472147qkf.50.2020.02.05.13.49.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Feb 2020 13:49:55 -0800 (PST)
Date: Wed, 5 Feb 2020 16:49:52 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 01/19] KVM: x86: Allocate new rmap and large page
 tracking when moving memslot
Message-ID: <20200205214952.GD387680@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-2-sean.j.christopherson@intel.com>
X-MC-Unique: nxkxZtK9OJ6NC9MKQI6T0Q-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

On Tue, Jan 21, 2020 at 02:31:39PM -0800, Sean Christopherson wrote:
> Reallocate a rmap array and recalcuate large page compatibility when
> moving an existing memslot to correctly handle the alignment properties
> of the new memslot.  The number of rmap entries required at each level
> is dependent on the alignment of the memslot's base gfn with respect to
> that level, e.g. moving a large-page aligned memslot so that it becomes
> unaligned will increase the number of rmap entries needed at the now
> unaligned level.
> 
> Not updating the rmap array is the most obvious bug, as KVM accesses
> garbage data beyond the end of the rmap.  KVM interprets the bad data as
> pointers, leading to non-canonical #GPs, unexpected #PFs, etc...
> 
>   general protection fault: 0000 [#1] SMP
>   CPU: 0 PID: 1909 Comm: move_memory_reg Not tainted 5.4.0-rc7+ #139
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:rmap_get_first+0x37/0x50 [kvm]
>   Code: <48> 8b 3b 48 85 ff 74 ec e8 6c f4 ff ff 85 c0 74 e3 48 89 d8 5b c3
>   RSP: 0018:ffffc9000021bbc8 EFLAGS: 00010246
>   RAX: ffff00617461642e RBX: ffff00617461642e RCX: 0000000000000012
>   RDX: ffff88827400f568 RSI: ffffc9000021bbe0 RDI: ffff88827400f570
>   RBP: 0010000000000000 R08: ffffc9000021bd00 R09: ffffc9000021bda8
>   R10: ffffc9000021bc48 R11: 0000000000000000 R12: 0030000000000000
>   R13: 0000000000000000 R14: ffff88827427d700 R15: ffffc9000021bce8
>   FS:  00007f7eda014700(0000) GS:ffff888277a00000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007f7ed9216ff8 CR3: 0000000274391003 CR4: 0000000000162eb0
>   Call Trace:
>    kvm_mmu_slot_set_dirty+0xa1/0x150 [kvm]
>    __kvm_set_memory_region.part.64+0x559/0x960 [kvm]
>    kvm_set_memory_region+0x45/0x60 [kvm]
>    kvm_vm_ioctl+0x30f/0x920 [kvm]
>    do_vfs_ioctl+0xa1/0x620
>    ksys_ioctl+0x66/0x70
>    __x64_sys_ioctl+0x16/0x20
>    do_syscall_64+0x4c/0x170
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>   RIP: 0033:0x7f7ed9911f47
>   Code: <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48
>   RSP: 002b:00007ffc00937498 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>   RAX: ffffffffffffffda RBX: 0000000001ab0010 RCX: 00007f7ed9911f47
>   RDX: 0000000001ab1350 RSI: 000000004020ae46 RDI: 0000000000000004
>   RBP: 000000000000000a R08: 0000000000000000 R09: 00007f7ed9214700
>   R10: 00007f7ed92149d0 R11: 0000000000000246 R12: 00000000bffff000
>   R13: 0000000000000003 R14: 00007f7ed9215000 R15: 0000000000000000
>   Modules linked in: kvm_intel kvm irqbypass
>   ---[ end trace 0c5f570b3358ca89 ]---
> 
> The disallow_lpage tracking is more subtle.  Failure to update results
> in KVM creating large pages when it shouldn't, either due to stale data
> or again due to indexing beyond the end of the metadata arrays, which
> can lead to memory corruption and/or leaking data to guest/userspace.
> 
> Note, the arrays for the old memslot are freed by the unconditional call
> to kvm_free_memslot() in __kvm_set_memory_region().

If __kvm_set_memory_region() failed, I think the old memslot will be
kept and the new memslot will be freed instead?

> 
> Fixes: 05da45583de9b ("KVM: MMU: large page support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4c30ebe74e5d..1953c71c52f2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9793,6 +9793,13 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
>  {
>  	int i;
>  
> +	/*
> +	 * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
> +	 * old arrays will be freed by __kvm_set_memory_region() if installing
> +	 * the new memslot is successful.
> +	 */
> +	memset(&slot->arch, 0, sizeof(slot->arch));

I actually gave r-b on this patch but it was lost... And then when I
read it again I start to confuse on why we need to set these to zeros.
Even if they're not zeros, iiuc kvm_free_memslot() will compare each
of the array pointer and it will only free the changed pointers, then
it looks fine even without zeroing?

> +
>  	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
>  		struct kvm_lpage_info *linfo;
>  		unsigned long ugfn;
> @@ -9867,6 +9874,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  				const struct kvm_userspace_memory_region *mem,
>  				enum kvm_mr_change change)
>  {
> +	if (change == KVM_MR_MOVE)
> +		return kvm_arch_create_memslot(kvm, memslot,
> +					       mem->memory_size >> PAGE_SHIFT);
> +

Instead of calling kvm_arch_create_memslot() explicitly again here,
can it be replaced by below?

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 72b45f491692..85a7b02fd752 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1144,7 +1144,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
                new.dirty_bitmap = NULL;
 
        r = -ENOMEM;
-       if (change == KVM_MR_CREATE) {
+       if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
                new.userspace_addr = mem->userspace_addr;
 
                if (kvm_arch_create_memslot(kvm, &new, npages))

>  	return 0;
>  }
>  
> -- 
> 2.24.1
> 

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
