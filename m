Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8BF32E131
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 18:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762538702; cv=none; b=IDQTav/oIKJgNAW5N+Vs/P7xxPGlKUp44ll8zGZajxnZws0FNw86nco+h90h3u8I4FzDVWjcrKsGq3LEDTIn+J5wQy5Z1HBEciPGJDLppa+aEGclVRtKp60puMd7YPzJG8LMUUvjppbuQcRyU9tjokTu6SRQhwvF2FKlh08X/Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762538702; c=relaxed/simple;
	bh=yVzlCT5Uu1SxfjDUt0JzOKp9XvXdUS1XaZo2iK8crO0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SiGXMqKdUkHnlJ47tlYM9GaA5Vwa3FrnocQu0QtXjtTYlCAS3VQulpMT4iWbslRS02Aj3rYn1OR+C86p5kfV84B/nMRXnbidY+davri8wj+99o0K6OYuESLyRSqa/9cANIdsuPogqW223s/2zCGnzj1mQNncu36INHZn9ud/Ypo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=24iFe7RJ; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="24iFe7RJ"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42b2ad29140so319166f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 10:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762538697; x=1763143497; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/AqAgTDxm6jquTqnEsjA3Waymb6wOkAp7ZeQjd8rqgw=;
        b=24iFe7RJ8RvNWLXyDdWicIgPV6ZXIycZdyo4OQ8JVMh6uM1QHCzp9uMT7ppMZeNf7Q
         C4v4t7JFqLbB7zbBC+A5udGDyOyaiaNnoBhcDH3Ub3t/Jy4//mAjj2WepXDKTX+5hEgW
         7wNZh8C9sAT4AIi2Ujmf0oTDbK4OjI1frhXeN0Mdeg30AM+ANI+j1KL4IK9poLv9wz5+
         wIKIdX9I1ytTUeDhxg8aCs7oRsWAwTZCj93nDbA1At4M16piugePkpP01/6KcwwfzpXM
         OLe70Mf1fbRpfYwePHtuaWduocUQ/VQGMVsouBu2GVFvNcnvm112OHMkOczCGL7xNO44
         aIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762538697; x=1763143497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/AqAgTDxm6jquTqnEsjA3Waymb6wOkAp7ZeQjd8rqgw=;
        b=RSi7k+hP3d+o1p0uN41Y0hVnyBAy3sElIolb0NL2zwXM3QRDNm85TyUrdmKnCenuUl
         JcrZfCK6UfD8fWEZNOrg+AuFIpundQcdvEPvB71c5qJ0ZCi3UQR1diJn8Y8DPqOaaTsQ
         y9LqePaZzf7L1u+gI8EE5cmf/K0ZFbEFowaEF5TkQ4O6X07k1qOIu37ejfastVnH+74d
         ficU0f0Vl0GqQgFdsyXBYJYBHtEpr5R9tRt4KZqY6d4wpMnLia2SD3J9BR07m2JLPLf5
         UyeoXIjWOTKrv9tVmRGp2zn49PoMTQkLXFzWQUM3Sm5BiIDsO7mOIBHvI8PxHWIZ72FQ
         wgww==
X-Forwarded-Encrypted: i=1; AJvYcCUMktioNS51PVHK9ADjQhsCqMNYerXO/06cG9kXotFaXzd8LOzTetdW6Gu2QqyMPQsNci/vq6I=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaiCp2qspJBxHndW8sncaLGO5+17SuTbmzxKjyaGhLIHXnn11A
	kMbU2lFFBzXfi6rEUIL+s/XdGex9j/T5aK/Tm59qTS3guKY/RJyNDhuFMrz94ZPMWYIQX8ZV8Hq
	iWJMXnfQZwQfLIg==
X-Google-Smtp-Source: AGHT+IFOkVmSQK/jYvTSHAXnkCCnA0joruckYbu4Ldmd5HExfLsxuZZgznGEf8JFTpeS7lG61pD7MYDnH/6ugg==
X-Received: from wrvs14.prod.google.com ([2002:a5d:4ece:0:b0:425:f04a:4d98])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2408:b0:429:d3b8:7387 with SMTP id ffacd0b85a97d-42aefb4351dmr3543783f8f.42.1762538697024;
 Fri, 07 Nov 2025 10:04:57 -0800 (PST)
Date: Fri, 07 Nov 2025 18:04:56 +0000
In-Reply-To: <add94932-290c-4037-b4e6-c3c760240819@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
 <DE2L1SAOC55E.E4JY62WJQ2A8@google.com> <add94932-290c-4037-b4e6-c3c760240819@amazon.com>
X-Mailer: aerc 0.21.0
Message-ID: <DE2NTMZXQ1MT.2TH9VAKM6WP6I@google.com>
Subject: Re: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
From: Brendan Jackman <jackmanb@google.com>
To: <kalyazin@amazon.com>, Brendan Jackman <jackmanb@google.com>
Cc: <pbonzini@redhat.com>, <corbet@lwn.net>, <maz@kernel.org>, 
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>, 
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>, 
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, 
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
	<tabba@google.com>, <ackerleytng@google.com>, 
	Patrick Roy <patrick.roy@campus.lmu.de>
Content-Type: text/plain; charset="UTF-8"

On Fri Nov 7, 2025 at 5:23 PM UTC, Nikita Kalyazin wrote:
>
>
> On 07/11/2025 15:54, Brendan Jackman wrote:
>> On Wed Sep 24, 2025 at 3:10 PM UTC, Patrick Roy wrote:
>>> From: Patrick Roy <roypat@amazon.co.uk>
>>>
>>> [ based on kvm/next ]
>>>
>>> Unmapping virtual machine guest memory from the host kernel's direct map is a
>>> successful mitigation against Spectre-style transient execution issues: If the
>>> kernel page tables do not contain entries pointing to guest memory, then any
>>> attempted speculative read through the direct map will necessarily be blocked
>>> by the MMU before any observable microarchitectural side-effects happen. This
>>> means that Spectre-gadgets and similar cannot be used to target virtual machine
>>> memory. Roughly 60% of speculative execution issues fall into this category [1,
>>> Table 1].
>>>
>>> This patch series extends guest_memfd with the ability to remove its memory
>>> from the host kernel's direct map, to be able to attain the above protection
>>> for KVM guests running inside guest_memfd.
>>>
>>> Additionally, a Firecracker branch with support for these VMs can be found on
>>> GitHub [2].
>>>
>>> For more details, please refer to the v5 cover letter [v5]. No
>>> substantial changes in design have taken place since.
>>>
>>> === Changes Since v6 ===
>>>
>>> - Drop patch for passing struct address_space to ->free_folio(), due to
>>>    possible races with freeing of the address_space. (Hugh)
>>> - Stop using PG_uptodate / gmem preparedness tracking to keep track of
>>>    direct map state.  Instead, use the lowest bit of folio->private. (Mike, David)
>>> - Do direct map removal when establishing mapping of gmem folio instead
>>>    of at allocation time, due to impossibility of handling direct map
>>>    removal errors in kvm_gmem_populate(). (Patrick)
>>> - Do TLB flushes after direct map removal, and provide a module
>>>    parameter to opt out from them, and a new patch to export
>>>    flush_tlb_kernel_range() to KVM. (Will)
>>>
>>> [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
>>> [2]: https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
>> 
>> I just got around to trying this out, I checked out this patchset using
>> its base-commit and grabbed the Firecracker branch. Things seem OK until
>> I set the secrets_free flag in the Firecracker config which IIUC makes
>> it set GUEST_MEMFD_FLAG_NO_DIRECT_MAP.
>> 
>> If I set it, I find the guest doesn't show anything on the console.
>> Running it in a VM and attaching GDB suggests that it's entering the
>> guest repeatedly, it doesn't seem like the vCPU thread is stuck or
>> anything. I'm a bit clueless about how to debug that (so far, whenever
>> I've broken KVM, things always exploded very dramatically).
>> 
>> Anyway, if I then kill the firecracker process, the host sometimes
>> crashes, I think this is the most suggestive splat I've seen:
>> 
>> [   99.673420][    T2] BUG: unable to handle page fault for address: ffff888012804000
>> [   99.676216][    T2] #PF: supervisor write access in kernel mode
>> [   99.678381][    T2] #PF: error_code(0x0002) - not-present page
>> [   99.680499][    T2] PGD 2e01067 P4D 2e01067 PUD 2e02067 PMD 12801063 PTE 800fffffed7fb020
>> [   99.683374][    T2] Oops: Oops: 0002 [#1] SMP
>> [   99.685004][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted 6.17.0-rc7-00366-g473c46a3cb2a #106 NONE
>> [   99.688514][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.1 11/11/2019
>> [   99.691547][    T2] RIP: 0010:clear_page_erms+0x7/0x10
>> [   99.693440][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
>> [   99.700188][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
>> [   99.702321][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
>> [   99.705100][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
>> [   99.707861][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
>> [   99.710648][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
>> [   99.713412][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
>> [   99.716191][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
>> [   99.719316][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   99.721648][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
>> [   99.724421][    T2] Call Trace:
>> [   99.725608][    T2]  <TASK>
>> [   99.726646][    T2]  get_page_from_freelist+0x6fe/0x14b0
>> [   99.728583][    T2]  ? fs_reclaim_acquire+0x43/0xe0
>> [   99.730325][    T2]  ? find_held_lock+0x2b/0x80
>> [   99.731965][    T2]  __alloc_frozen_pages_noprof+0x147/0x2d0
>> [   99.734003][    T2]  __alloc_pages_noprof+0x5/0x50
>> [   99.735766][    T2]  copy_process+0x1b1/0x1b30
>> [   99.737398][    T2]  ? lock_is_held_type+0x89/0x100
>> [   99.739157][    T2]  ? kthreadd+0x25/0x190
>> [   99.740664][    T2]  kernel_clone+0x59/0x390
>> [   99.742213][    T2]  ? kthreadd+0x25/0x190
>> [   99.743728][    T2]  kernel_thread+0x55/0x70
>> [   99.745310][    T2]  ? kthread_complete_and_exit+0x20/0x20
>> [   99.747265][    T2]  kthreadd+0x117/0x190
>> [   99.748748][    T2]  ? kthread_is_per_cpu+0x30/0x30
>> [   99.750509][    T2]  ret_from_fork+0x16b/0x1e0
>> [   99.752193][    T2]  ? kthread_is_per_cpu+0x30/0x30
>> [   99.753992][    T2]  ret_from_fork_asm+0x11/0x20
>> [   99.755717][    T2]  </TASK>
>> [   99.756861][    T2] CR2: ffff888012804000
>> [   99.758353][    T2] ---[ end trace 0000000000000000 ]---
>> [   99.760319][    T2] RIP: 0010:clear_page_erms+0x7/0x10
>> [   99.762209][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
>> [   99.769129][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
>> [   99.771297][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
>> [   99.774126][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
>> [   99.777013][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
>> [   99.779827][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
>> [   99.782641][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
>> [   99.785487][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
>> [   99.788671][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   99.791012][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
>> [   99.793863][    T2] Kernel panic - not syncing: Fatal exception
>> [   99.796760][    T2] Kernel Offset: disabled
>> [   99.798296][    T2] ---[ end Kernel panic - not syncing: Fatal exception ]---
>> 
>> This makes me suspect the kvm_gmem_folio_restore_direct_map() path isn't
>> working or isn't getting called.
>> 
>> If anyone wants help trying to reproduce this let me know.
>
> Hi Brendan,
>
> Thanks for trying to run it!
>
> Just as a sanity check, the way it is known for us to work is we apply 
> all patches from [1].  For booted VMs (as opposed to restored from 
> snapshot), apart from the v6 of the direct map removal series, the only 
> additional patch is a fix for kvmclock on x86 [2].  Please let me know 
> if you see the same issue with that patch applied too.
>
> Nikita
>
> [1] 
> https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding/resources/hiding_ci/linux_patches
> [2] 
> https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding/resources/hiding_ci/linux_patches/11-kvm-clock

Ah, thanks! Seems I should have checked my inbox before sending my other
mail. With the kvmclock fix applied to my host kernel, I start setting
the other crash immediately when the VM boots. If I comment out the
actual unmapping of memory, it boots (before, it wouldn't boot even with
that commented out).

For the other linux_patches, I couldn't apply them on top of this
series, do you have a branch I can use as a reference?

Anyway, the solution I'm hoping to present for your problem gets rid of
that explicit unmapping code (the allocator will do it for you), so in
the meantime I have something I can work with.
