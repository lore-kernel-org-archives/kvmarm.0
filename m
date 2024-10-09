Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE2B20011E
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 15:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489002; cv=none; b=Y/QoRWws5u47GfFqmvo5tuwF73mF/l3Edoe7M8X0auRhs5kLNgi52MeZp//zGLacxpWmOLD2q2W2LSlKTTx9CZBE/d8OsBuJZk2T3tasJRKXttPXscHn0/qNDHd3yABZxS/n+nsrdFiOBxaXmUgy/jzws+R3/Sv8BlJ4zerbYls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489002; c=relaxed/simple;
	bh=/7fWtV+q7/Fq6/s5md+zD0Cb6GIP2xL9NGhc499VzYw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vGdD4peTdonFs4uXPkhraAhpmI+rodfvzRSjXl3YCl53vJCOB/FWlaCpPEj1saYcyNwpSUV04D4AwRORcA8EMwvEHjdrpyhD0ZEWByOmklTAZDCOm1SNA8UP2hD7wwbyqJrJDK8b5GsHPNHa9DMTOCuQ673c/IRoNNWI3lffBoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XDVX7k71; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XDVX7k71"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e0082c1dd0so146319997b3.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 08:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489000; x=1729093800; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jVTsixz4sZ4koZFPUtECwdZDuBQDlBcuBCpi0vcsFcE=;
        b=XDVX7k71d/OC5Yzwp1PkVk/o1FuwoNOWJnZs63s535irF4TJsRgDyJzkHy9ahncvVR
         DMex+oU52dxLA99yJdUfDO4XAZws2iUhbT3iQIFJDQk7TgjfOaOc/2tWV3voewS1+woL
         nIfK3i2CCVYBWm9PC3MPOx/dKfQMlNAR4cF70cyz35LMhen9ww7Qhx7xeolqCPobkrzr
         otPtEkKA6W+lcml+VROLn3Ky+fVIlHM0mX5E+eOyrOeb5fLG3mmrVfKaaqYjW4jZ+chW
         DpHMPuTtXEi0yor3LtsrwcfZWfQpSeDWFzQ3H4KlpDNLX84+ZYHYgX4Stwu3kVaV+l0R
         nXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489000; x=1729093800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jVTsixz4sZ4koZFPUtECwdZDuBQDlBcuBCpi0vcsFcE=;
        b=Qh8s5QwDgF5nDRExYRBnfFutVpZyAd524MPXwcgvhbBzwJz4G6jnA+PuqrJ8H/p9FI
         of+jQJQTjE79vX+2zk+17LskjyxTJUXk6urB1t52qXJHPsf6T111Xde7No76xYuk35jv
         w5AB/bEbLIwBtLtvcAVJMXc/QeDtgMRbooHparEv5VWhUqCACgactiYcb3jzE6V5KPi4
         sgxfnMkJTtkPim7zhXRstCNYvg3ewkMHb1YuTrVdwehgh/YtxXYaYhIsldcwYSLNgLZv
         ZYUBZUbFK8sFpaW8NStHGB8YEI7b4UGEONCp9RBrvj9xxiMvzNqtKMuXjUYCR11IO1te
         YvyA==
X-Forwarded-Encrypted: i=1; AJvYcCV2q5P5fye5MprfDBtL9caBKjSlXIm28XoO9fDPXRA0P2P422HEdmAiiIWl/VLkxC0FUvNPJrg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHJJ+s6sNnUckFXUM3IqAu6hkc87FqmTBEfnkiBCxDwko9tzz/
	Lnp3rLMmZANaBn8e93BVMhshg33ZMKlRdMAHqeg0XKNBxWDx1Ug1R7v0uEypxn2lFsW9I20/vZT
	1SA==
X-Google-Smtp-Source: AGHT+IFJReZxJVdNM9WOc4CTIpT8xwBaol9zgUnZweoXlrW7QgctCL6Q+XRwMroT/XXO2vZfV7gZvg3Vxc0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4ac:b0:e28:fdfc:b788 with SMTP id
 3f1490d57ef6-e28fe4426b8mr2248276.9.1728488999652; Wed, 09 Oct 2024 08:49:59
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:41 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-3-seanjc@google.com>
Subject: [PATCH v3 02/14] KVM: selftests: Disable strict aliasing
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Disable strict aliasing, as has been done in the kernel proper for decades
(literally since before git history) to fix issues where gcc will optimize
away loads in code that looks 100% correct, but is _technically_ undefined
behavior, and thus can be thrown away by the compiler.

E.g. arm64's vPMU counter access test casts a uint64_t (unsigned long)
pointer to a u64 (unsigned long long) pointer when setting PMCR.N via
u64p_replace_bits(), which gcc-13 detects and optimizes away, i.e. ignores
the result and uses the original PMCR.

The issue is most easily observed by making set_pmcr_n() noinline and
wrapping the call with printf(), e.g. sans comments, for this code:

  printf("orig = %lx, next = %lx, want = %lu\n", pmcr_orig, pmcr, pmcr_n);
  set_pmcr_n(&pmcr, pmcr_n);
  printf("orig = %lx, next = %lx, want = %lu\n", pmcr_orig, pmcr, pmcr_n);

gcc-13 generates:

 0000000000401c90 <set_pmcr_n>:
  401c90:       f9400002        ldr     x2, [x0]
  401c94:       b3751022        bfi     x2, x1, #11, #5
  401c98:       f9000002        str     x2, [x0]
  401c9c:       d65f03c0        ret

 0000000000402660 <test_create_vpmu_vm_with_pmcr_n>:
  402724:       aa1403e3        mov     x3, x20
  402728:       aa1503e2        mov     x2, x21
  40272c:       aa1603e0        mov     x0, x22
  402730:       aa1503e1        mov     x1, x21
  402734:       940060ff        bl      41ab30 <_IO_printf>
  402738:       aa1403e1        mov     x1, x20
  40273c:       910183e0        add     x0, sp, #0x60
  402740:       97fffd54        bl      401c90 <set_pmcr_n>
  402744:       aa1403e3        mov     x3, x20
  402748:       aa1503e2        mov     x2, x21
  40274c:       aa1503e1        mov     x1, x21
  402750:       aa1603e0        mov     x0, x22
  402754:       940060f7        bl      41ab30 <_IO_printf>

with the value stored in [sp + 0x60] ignored by both printf() above and
in the test proper, resulting in a false failure due to vcpu_set_reg()
simply storing the original value, not the intended value.

  $ ./vpmu_counter_access
  Random seed: 0x6b8b4567
  orig = 3040, next = 3040, want = 0
  orig = 3040, next = 3040, want = 0
  ==== Test Assertion Failure ====
    aarch64/vpmu_counter_access.c:505: pmcr_n == get_pmcr_n(pmcr)
    pid=71578 tid=71578 errno=9 - Bad file descriptor
       1        0x400673: run_access_test at vpmu_counter_access.c:522
       2         (inlined by) main at vpmu_counter_access.c:643
       3        0x4132d7: __libc_start_call_main at libc-start.o:0
       4        0x413653: __libc_start_main at ??:0
       5        0x40106f: _start at ??:0
    Failed to update PMCR.N to 0 (received: 6)

Somewhat bizarrely, gcc-11 also exhibits the same behavior, but only if
set_pmcr_n() is marked noinline, whereas gcc-13 fails even if set_pmcr_n()
is inlined in its sole caller.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=116912
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 960cf6a77198..6246d69d82d7 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -241,10 +241,10 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
 	-fno-builtin-memcmp -fno-builtin-memcpy \
 	-fno-builtin-memset -fno-builtin-strnlen \
-	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
-	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
-	$(KHDR_INCLUDES)
+	-fno-stack-protector -fno-PIE -fno-strict-aliasing \
+	-I$(LINUX_TOOL_INCLUDE) -I$(LINUX_TOOL_ARCH_INCLUDE) \
+	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(ARCH_DIR) \
+	-I ../rseq -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
 ifeq ($(ARCH),s390)
 	CFLAGS += -march=z10
 endif
-- 
2.47.0.rc0.187.ge670bccf7e-goog

