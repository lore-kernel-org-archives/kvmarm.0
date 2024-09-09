Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D151B791D
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 12:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725886048; cv=none; b=keuCQeCaeSZp8/MZEAlQcSZ9Erlnfqmt+qyKtpoEQPDvBRwyjsHwjrl4toQ0ySZEckS7athGEpsINK4pHmM6Tpd+UJW+FmMfy1nkQw22WMx3JA+KtyI/06yX1GwutPmBm0H58v7wgegyqEjv56N/mgnXo9a5Z43iBm//f7+8uLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725886048; c=relaxed/simple;
	bh=H/NVYlGTHG1CXjE08kuE1gJa++H9PJIKBPlhRFnY2lE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DiyDmKHTReJSYQYh5bkHfj3gVARZZZ0e2MNXbZF3bnR0QVZ/nsrTOdKIEGsqFog7I5foML+kcy60ZTAjyhLINkln+C6D56ef9XY2RlT7DydhKSstReomuI4Xj6Cf9z4uGC7N0Ysz4ICIRZnAR3RQzkAmBYYV0eBduMpIvgrzfiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U921uBEW; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U921uBEW"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-42cbadcbb6eso3249095e9.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 05:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725886045; x=1726490845; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IlZyZtIGrV2CPbYg0OEeBmlf5fsA3oDUDmzVRgQ/v3c=;
        b=U921uBEW5914OMNd6dqvVmLp70/1HX5yTZdaFA7RcaeshClSSvO6o7W733+x2d3VdM
         RzQ0eb0DB4mY9dO2k7tWxXBHNYt9KWa23CLX5l10AkGv8xwtuT2/sN7/lMKKq6Yr1d6Y
         f0Pa7LgrlDji+5+qEiGHhXdhCSL9sSNT4EJCXTm+EDMjE45sGtnrnntjr0lt/Cs6XkW1
         gk5bwTOhOrOS5qcvKV7YpXon4GPJC5wuE2zKBg2Hll1hBpfknTsrCbNn2WUOwU8zKtlx
         fHqIHKuRiItg47NidNJ7/bcRo0QtL9iHz6EMM/Tvm6mt7gjh+mXFWaveDzC+yLY5H3NL
         Qa0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725886045; x=1726490845;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IlZyZtIGrV2CPbYg0OEeBmlf5fsA3oDUDmzVRgQ/v3c=;
        b=vjOdtqMztUvjJP309B0boMXVdc+Y70spOQl75g1cxyAUhvDhNAUNzgrj+/xukcpAD9
         0SyNpOI63nX9uHAoymUbyHanYHiIxMPj7U0FrMd/Wr+pKMjt6EszffU+BhaelVjKfkyC
         tYKL+FO/p8TZaaPsqtflZdZ+xWOabAsqqFVdLEpaEMhxmF1D1UogM0ffZSOoUW8nAtoJ
         ILwD7SdkDT23d/c7vPgR6pGb2ItNqXOdFNr2PT3hSsDTu2a/3O+DeELqQPGS2pT0tcxW
         WZUYutUnLUQDT+BzZ+RBaRcS/Yk7KWHJxcPtcK+ziHlKiHplSXqbseegls92kt50DloO
         hXJQ==
X-Gm-Message-State: AOJu0YyGzS6oMtjsMvh2SD34D3Ls/yLSShzuN1JsZAeQrKVwsS6xi35S
	KgYr/PWfbdnESzSiS8NfQNmaulhUjYJ4hP5OOAI9fUAnUdopb/mfRCE1yPQ6W+DLgb0X7QhDpIL
	7wThfxh7iGM02p1aJCmLo1AcSFw==
X-Google-Smtp-Source: AGHT+IFPy2PIuXKZYcZ1PpWXhqlsmpm8ImunIqIrLYSf8HL4qfOuEF6su/TfY2ypMjBdw3Dnvz3I1KPqRvnLXHq94pc=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:68:fe9:ac10:f1b7])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:5845:b0:428:1088:edc with
 SMTP id 5b1f17b1804b1-42c9f8bf2c2mr485515e9.0.1725886044561; Mon, 09 Sep 2024
 05:47:24 -0700 (PDT)
Date: Mon,  9 Sep 2024 12:47:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240909124721.1672199-1-sebastianene@google.com>
Subject: [PATCH v10 0/5] arm64: ptdump: View the second stage page-tables
From: Sebastian Ene <sebastianene@google.com>
To: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com, 
	ardb@kernel.org, catalin.marinas@arm.com, christophe.leroy@csgroup.eu, 
	james.morse@arm.com, vdonnefort@google.com, mark.rutland@arm.com, 
	maz@kernel.org, oliver.upton@linux.dev, rananta@google.com, 
	ryan.roberts@arm.com, sebastianene@google.com, shahuang@redhat.com, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hi,


This series extends the ptdump support to allow dumping the guest
stage-2 pagetables. When CONFIG_PTDUMP_STAGE2_DEBUGFS is enabled, ptdump
registers the new following files under debugfs:
- /sys/debug/kvm/<guest_id>/stage2_page_tables
- /sys/debug/kvm/<guest_id>/stage2_levels
- /sys/debug/kvm/<guest_id>/ipa_range

This allows userspace tools (eg. cat) to dump the stage-2 pagetables by
reading the 'stage2_page_tables' file.
The output format has the following fields:
<IPA range> <size> <level> <access permissions> <mem_attributes>

Below is the output of a guest stage-2 pagetable dump running under Qemu.
After a VM is created, the following files are available:

# cat /sys/kernel/debug/kvm/256-4/stage2_levels 
4
# cat /sys/kernel/debug/kvm/256-4/ipa_range 
44
# cat /sys/kernel/debug/kvm/256-4/stage2_page_tables 
---[ Guest IPA ]---
0x0000000000000000-0x0000000001000000          16M 2
0x0000000001000000-0x0000000001020000         128K 3
0x0000000001020000-0x0000000001021000           4K 3   R W X AF    
0x0000000001021000-0x0000000001200000        1916K 3
0x0000000001200000-0x0000000040000000        1006M 2
0x0000000040000000-0x0000000080000000           1G 0
0x0000000080000000-0x0000000081200000          18M 2   R W   AF BLK
0x0000000081200000-0x0000000081a00000           8M 2   R W X AF BLK
0x0000000081a00000-0x0000000081c00000           2M 2   R W   AF BLK
0x0000000081c00000-0x0000000082200000           6M 2   R W X AF BLK
0x0000000082200000-0x0000000082400000           2M 2   R W   AF BLK
0x0000000082400000-0x0000000082800000           4M 2   R W X AF BLK
0x0000000082800000-0x0000000082a00000           2M 2   R W   AF BLK
0x0000000082a00000-0x0000000082c00000           2M 2
0x0000000082c00000-0x0000000083200000           6M 2   R W X AF BLK
0x0000000083200000-0x0000000083400000           2M 2
0x0000000083400000-0x0000000083a00000           6M 2   R W X AF BLK
0x0000000083a00000-0x000000008fe00000         196M 2
0x000000008fe00000-0x0000000090000000           2M 2   R W   AF BLK
0x0000000090000000-0x0000000099400000         148M 2
0x0000000099400000-0x0000000099600000           2M 2   R W X AF BLK
0x0000000099600000-0x000000009b600000          32M 2
0x000000009b600000-0x000000009be00000           8M 2   R W X AF BLK
0x000000009be00000-0x000000009c000000           2M 2   R W   AF BLK
0x000000009c000000-0x00000000c0000000         576M 2

Changelog:
v9 -> current:
 * fixed an issue reported by Mark - when using CONFIG_ARM64_VA_BITS=47
   and CONFIG_PAGE_SIZE_16KB=y ptdump was entering a check used for
   kernel pagetables to interpret the folded levels, thus overriding the
   current page table level. This was resulting in bogus output when ran
   on the stage-2 pagetables. 

 * folded the Kconfig patch in the one that introduces kvm/ptdump.c as
   suggested by Vincent. Collected Vincent's Reviewed-by tag, thanks.

 * applied Mark's sugegstion to use the callbacks by construct when
   interpretting the level and the ipa_bits instead of a string
   comparison on the pseudo-file.

 * fixed a bunch of nits

v8 -> v9:
 * squashed the last 3 patches and separated the Kconfig change as the
   last patch.
 * updated the commit message of the 3rd patch
 * printing level numbers instead of names as suggested by Mark
 * fixed one return code to ERR_PTR(-ENOMEM) as spotted by Vincent
 * dropped a barely empty header 'kvm_ptdump.h'
 * general cosmetic changes 

v7 -> v8:
 * applied Will's feedback and prefixed the exported structure names
   with ptdump_
 * dropped PTE_CONT and PTE_NG attribute parsing from Oliver's
   suggestion
 * fixed spurious BLK annotation reported by Vincent
 * repurposed `stage2_levels` debugfs file to show the number of the
   levels
 * tried changing the order of the patches:
   "5/6 Initialize the ptdump parser with stage-2 attributes" before
   exposing the debugfs file but ended up keeping the same order
   as this depends on the later one.

 v6 -> v7:
 * Reworded commit for this patch : [PATCH v6 2/6] arm64: ptdump: Expose
   the attribute parsing functionality
 * fixed minor conflicts in the struct pg_state definition
 * moved the kvm_ptdump_guest_registration in the
 * kvm_arch_create_vm_debugfs
 * reset the parse state before walking the pagetables
 * copy the level name to the pg_level buffer

 v5 -> v6:
 * don't return an error if the kvm_arch_create_vm_debugfs fails to
   initialize (ref.
https://lore.kernel.org/all/20240216155941.2029458-1-oliver.upton@linux.dev/)  
 * fix use-after-free suggested by getting a reference to the
   KVM struct while manipulating the debugfs files
   and put the reference on the file close.
 * do all the allocations at once for the ptdump parser state tracking
   and simplify the initialization.
 * move the ptdump parser state initialization as part of the file_open
 * create separate files for printing the guest stage-2 pagetable
   configuration such as: the start level of the pagetable walk and the
   number of bits used for the IPA space representation.
 * fixed the wrong header format for the newly added file
 * include missing patch which hasn't been posted on the v5:
   "KVM-arm64-Move-pagetable-definitions-to-common-heade.patch" 

 
Links to previous versions:
v9:
https://lore.kernel.org/all/20240827084549.45731-1-sebastianene@google.com/
v8:
https://lore.kernel.org/all/20240816123906.3683425-1-sebastianene@google.com/  
v7:
https://lore.kernel.org/all/20240621123230.1085265-1-sebastianene@google.com/
v6:
https://lore.kernel.org/all/20240220151035.327199-1-sebastianene@google.com/
v5:
https://lore.kernel.org/all/20240207144832.1017815-2-sebastianene@google.com/

Thanks,
Sebastian

Sebastian Ene (5):
  KVM: arm64: Move pagetable definitions to common header
  arm64: ptdump: Expose the attribute parsing functionality
  arm64: ptdump: Use the ptdump description from a local context
  arm64: ptdump: Don't override the level when operating on the stage-2
    tables
  KVM: arm64: Register ptdump with debugfs on guest creation

 arch/arm64/include/asm/kvm_host.h    |   6 +
 arch/arm64/include/asm/kvm_pgtable.h |  42 +++++
 arch/arm64/include/asm/ptdump.h      |  42 ++++-
 arch/arm64/kvm/Kconfig               |  17 ++
 arch/arm64/kvm/Makefile              |   1 +
 arch/arm64/kvm/arm.c                 |   1 +
 arch/arm64/kvm/hyp/pgtable.c         |  42 -----
 arch/arm64/kvm/ptdump.c              | 268 +++++++++++++++++++++++++++
 arch/arm64/mm/ptdump.c               |  70 ++-----
 9 files changed, 396 insertions(+), 93 deletions(-)
 create mode 100644 arch/arm64/kvm/ptdump.c

-- 
2.46.0.469.g59c65b2a67-goog

