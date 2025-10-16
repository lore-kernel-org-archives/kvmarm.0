Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297CA17C21E
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635812; cv=none; b=b0OBFTwceDY2sDQAtvrepG9eO8ZJpHZHBSjq8+S7nPCK4A6t9lINOBoFogVncLJT5OCmLnaysvH0Syg4czqws0ir3F9RxFRZ2QPTNZNv112ZDo3QLmgsZAT9cKSsu1Pomxf8i+nc1mQD0Q6xp0a0tyqz4iDzwyBEDAiX6KYUHWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635812; c=relaxed/simple;
	bh=4xC7NbtAYk7ZTEIvkayJzWq9oLb+GOKeL8BAa/1843A=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bGkedNEa9Cms4ltiANS2Py8X3hLHg1tkhWxTZoNQxMVEkLxD1HJrKdC8UxFqFLPXKsOEqeHs8vBr0svR24otjzTR0NaekjnAUNPq59ecMPGvVEDcjfZirT9LnCuZPM12m9yRTmHE8k6GLcYuNrIvgqD3uydWldkvwHc3xohdN8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4LQnU3l4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4LQnU3l4"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33ba9047881so1480107a91.1
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 10:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635808; x=1761240608; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fw6xiHjKYy4zBKVTH7gEKmT2HMgfZtlJ6SEn7/JK9n0=;
        b=4LQnU3l467lf8HjZAY8ftlVddLWScfDXm9B37pIyGA8NQBE9jDD/KbZMvE/IiAkclk
         1wgRPpoAt4F223mjven/erH0zOIB3zFAZSaQU7KVLkSjduv6FdjGZj22J9+Z0ED8IvzL
         brxEsLx5CxOMyH7D8XgKQVUrVFxWmcY+gAVWBnjd14F9OGHSx8jNdZ5bvDPwV8xEwfc/
         A3QPMguhkVK7tylmEh7DK/Cfh7HfCydTRbCbWdoBknHplezDttJdf11Ap4LyuBf8LKxz
         2iUd9rGk6u+HTprbORuoLWM3rT8AlL+O9Tx+yLmW4WoqfCsxu9FEsugiJyUuSh+PCVeB
         /X1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635808; x=1761240608;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fw6xiHjKYy4zBKVTH7gEKmT2HMgfZtlJ6SEn7/JK9n0=;
        b=UQG3w66gk3N1dajkjpVL8uOp+HbRIUe2j3Q16ruGR0XnxDPSwrAiX1vgrvFQ13Ap9Y
         eENonTlXzJeWtaFJuv/xZuaCnjJ1d7N1VRH4O5TUYXXe6KJezLl8arfBq139xVy981tO
         nK6hJMHn1//pMfkF8X5/zwWfnNYtV84syCzWhNIKgPLwZN/7QEEe3sgGcrn836AXwbtH
         SwEXWtAtK28lBRvHNBQ5ejmwflKcp+KdTj36FxlHPA3vEf+yP3eRiszAthS9EuZo6KSN
         xc+eshKSe1Gz9zyVbdUPLEMRHuWTbtX2qjbjcIvkpjbZrWRn+xdL/+X2cGBGu8ZAGhX+
         +cBg==
X-Forwarded-Encrypted: i=1; AJvYcCUchAK2smoVEr2ubzqJEGGRcJZlHH+ZGQjheKLgSd95Cptm7awyo7VekcS6JEjxv7aR4Y+D3Fg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwpwF0nXzbO0A18J7V0fVZ5tT/KWAteZ+xf52mcgbON0RhjszUm
	9evUsZZTzN4u2Pt81MzCf7PlxE24dEzoUQo8cnNqoQUNswk9TsuNj1CmFOajh1fwgip379se/UT
	dHV4aiQ==
X-Google-Smtp-Source: AGHT+IEE+9lWsoGbrE1FsDpaiwGYQEz8y5mwph7bonrhgYb3kvgC58w2qMMIJ/4cUT39VkATDSw/u6xjb6I=
X-Received: from pjbpa17.prod.google.com ([2002:a17:90b:2651:b0:33b:51fe:1a8c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f4c:b0:32e:11cc:d17a
 with SMTP id 98e67ed59e1d1-33b9e08ff85mr5705111a91.4.1760635808296; Thu, 16
 Oct 2025 10:30:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:41 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-1-seanjc@google.com>
Subject: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Miguel, you got pulled in due to a one-line change to add a new iterator
macros in .clang-format.

Shivank's series to add support for NUMA-aware memory placement in
guest_memfd.  Based on kvm-x86/next.

Note, Ackerley pointed out that we should probably have testing for the
cpuset_do_page_mem_spread() behavior.  I 100% agree, but I'm also a-ok
merging without those tests.

v13:
 - Collect reviews.
 - Add kvm_gmem_for_each_file to .clang-format. [Ackerley]
 - Fix typos. [Ackerley]
 - Don't use get_task_policy() if the guest_memfd doesn't have its own
   policy, so that cpuset_do_page_mem_spread() works. [Ackerley]
 - Fix goofs in the changelogs related to numaif.h. [Ackerley]

v12:
 - https://lore.kernel.org/all/20251007221420.344669-1-seanjc@google.com
 - Add missing functionality to KVM selftests' existing numaif.h instead of
   linking to libnuma (which appears to have caveats with -static).
 - Add KVM_SYSCALL_DEFINE() infrastructure to reduce the boilerplate needed
   to wrap syscalls and/or to assert that a syscall succeeds.
 - Rename kvm_gmem to gmem_file, and use gmem_inode for the inode structure.
 - Track flags in a gmem_inode field instead of using i_private.
 - Add comments to call out subtleties in the mempolicy code (e.g. that
   returning NULL for vm_operations_struct.get_policy() is important for ABI
   reasons).
 - Improve debugability of guest_memfd_test (I kept generating SIGBUS when
   tweaking the tests).
 - Test mbind() with private memory (sadly, verifying placement with
   move_pages() doesn't work due to the dependency on valid page tables).

- V11: Rebase on kvm-next, remove RFC tag, use Ackerley's latest patch
       and fix a rcu race bug during kvm module unload.
- V10: Rebase on top of Fuad's V17. Use latest guest_memfd inode patch
       from Ackerley (with David's review comments). Use newer kmem_cache_create()
       API variant with arg parameter (Vlastimil)
- v9: Rebase on top of Fuad's V13 and incorporate review comments
- v8: Rebase on top of Fuad's V12: Host mmaping for guest_memfd memory.
- v7: Use inodes to store NUMA policy instead of file [0].
- v4-v6: Current approach using shared_policy support and vm_ops (based on
         suggestions from David [1] and guest_memfd bi-weekly upstream
         call discussion [2]).
- v3: Introduced fbind() syscall for VMM memory-placement configuration.
- v1,v2: Extended the KVM_CREATE_GUEST_MEMFD IOCTL to pass mempolicy.

[0] https://lore.kernel.org/all/diqzbjumm167.fsf@ackerleytng-ctop.c.googlers.com
[1] https://lore.kernel.org/all/6fbef654-36e2-4be5-906e-2a648a845278@redhat.com
[2] https://lore.kernel.org/all/2b77e055-98ac-43a1-a7ad-9f9065d7f38f@amd.com

Ackerley Tng (1):
  KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes

Sean Christopherson (7):
  KVM: guest_memfd: Rename "struct kvm_gmem" to "struct gmem_file"
  KVM: guest_memfd: Add macro to iterate over gmem_files for a
    mapping/inode
  KVM: selftests: Define wrappers for common syscalls to assert success
  KVM: selftests: Report stacktraces SIGBUS, SIGSEGV, SIGILL, and SIGFPE
    by default
  KVM: selftests: Add additional equivalents to libnuma APIs in KVM's
    numaif.h
  KVM: selftests: Use proper uAPI headers to pick up mempolicy.h
    definitions
  KVM: guest_memfd: Add gmem_inode.flags field instead of using
    i_private

Shivank Garg (4):
  KVM: guest_memfd: Add slab-allocated inode cache
  KVM: guest_memfd: Enforce NUMA mempolicy using shared policy
  KVM: selftests: Add helpers to probe for NUMA support, and multi-node
    systems
  KVM: selftests: Add guest_memfd tests for mmap and NUMA policy support

 .clang-format                                 |   1 +
 include/uapi/linux/magic.h                    |   1 +
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |   2 +-
 .../testing/selftests/kvm/guest_memfd_test.c  |  98 ++++++
 .../selftests/kvm/include/kvm_syscalls.h      |  81 +++++
 .../testing/selftests/kvm/include/kvm_util.h  |  29 +-
 tools/testing/selftests/kvm/include/numaif.h  | 110 +++---
 .../selftests/kvm/kvm_binary_stats_test.c     |   4 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  55 +--
 .../kvm/x86/private_mem_conversions_test.c    |   9 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |   5 +-
 virt/kvm/guest_memfd.c                        | 331 ++++++++++++++----
 virt/kvm/kvm_main.c                           |   7 +-
 virt/kvm/kvm_mm.h                             |   9 +-
 14 files changed, 565 insertions(+), 177 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/kvm_syscalls.h


base-commit: f222788458c8a7753d43befef2769cd282dc008e
-- 
2.51.0.858.gf9c4a03a3a-goog

