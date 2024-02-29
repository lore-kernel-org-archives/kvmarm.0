Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86C517554
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 00:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168023; cv=none; b=UzF9K0O4Wz9tp6z04fJFN5d4y+feEu1euDufoqYAElOmZgTGt4LfpYmhFTIqrYNfjClRTrptkIYhDrdcc3rpHurE1gj7WoDiTHgIvb+065sXyDmoissgLPeXDvvrBJovyW2AllHsR7bLI0eVWWYM00F+Nj7HhRpTDtU5AuQNQZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168023; c=relaxed/simple;
	bh=ixPn/WA/IkkMHbVj9xbnA+a/EFMiv0ErX3XQ1lo3UFc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YnIvk+csto2bYJJkknNusTSee66KBkjz3ORTy/WzjXnE8n24t5uXo0HARkvDIAvQ4mGulWfUhy/Hg8G02mkV6OriJOdLn5EWpJwCHQoiDEPP9E7teiKX1XKVweS4CdLb3W7bFq2jAJ7G+yyGviTHBRzNFaa04Ib0e7Ht5NwMIFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BG528EHs; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BG528EHs"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-299727c3e8bso203287a91.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 16:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709168021; x=1709772821; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1fAxVxcSGJDtvwC4OA6vg9SQpipa+6cd4wlsruGTgI=;
        b=BG528EHsBnO4wcE9OEEhDlnCi9OrfeucIUbwPXdPp8pdaUdgzRV/EFGOpXO/JyT611
         Q4ZdFLbU/QDJylwFX9NoGm5+/djh4SrtR6GT3S3Yfs7BGIl0Y0+0/5n5MR+zWd5loXZn
         GgBlhVBOZkBeQ9GDXQQnrTzPVYgjCQssjeHinHrPeEEcAZjuuIvTw5NAXurUvpILDDdI
         xoMYpBl9NDcmHFM266nmv0/aqq4s2Ts0yMEqQsC6T0Mq0gek2a+1alhnQas1VWkH/niA
         O1HHzP6XGVNxCrJZGQVDd3Bkh9fYyriTXJ9Win1b8tbAzw933/mZdiTUwXVKOyBASpWg
         xmfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709168021; x=1709772821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1fAxVxcSGJDtvwC4OA6vg9SQpipa+6cd4wlsruGTgI=;
        b=mWp/fE52i9cCFIEoXHcLLGX62ddgGzJy8HJDOJhC1eutzJ7oPM0FsXuIEqo3EtZBvO
         iJsWRNEfqmp0bAaQ/t3qYdapAzF7HDwfk9+eEfvBWjsIw1HhIRiOXreymzIvByGbVZxd
         BIQkNt4pGuPibJ9JhL6j99Im7ZQZ3NxaWPcxGIyMS08A3xj6D39EKMNjYE8SAjY2kBdQ
         /TMYGhMAc79bhvIW3ReMoELGEXxyEv4w5M6EJheQ0L+r19I2mJDWycC1SyjkAXJzPtTh
         I91d4iWhcn2w0s95yJkIAHwbwAkSjaB6N21L2LapkGiRm6hueAA4s0VSwaBnxfIXkws8
         Gbpw==
X-Forwarded-Encrypted: i=1; AJvYcCXazZc3T2ahScGsCWl29Kv7OVAed9qBqXLHiEi2myAiQ6lwRU/scdf1JhuAaXUmVj7zbWo6tAvflurTOPF/vhnS8YpLYD2b
X-Gm-Message-State: AOJu0Yz22AYcT8O/ccxTX+n8da2xMzo0nC3HTJWNGSFBKC8eJDkDXmfd
	vZ1n1dX3wnoT5hPbBTjWJkqDho8HbnxeoxgABBeXV75O2PdbljpTVdiRwgvBy0abLtZfg+vbLCJ
	3uA==
X-Google-Smtp-Source: AGHT+IEGDx9KNnQuVlFL1a+o7VDJ3fqoKiHSZ9fod3C0H0yXTT9TpbbqlundidtZGFnRpu3hKNN8Sj3g9iY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4f44:b0:29a:c5e6:c5f1 with SMTP id
 pj4-20020a17090b4f4400b0029ac5e6c5f1mr15628pjb.6.1709168021232; Wed, 28 Feb
 2024 16:53:41 -0800 (PST)
Date: Wed, 28 Feb 2024 16:53:39 -0800
In-Reply-To: <Zd6Wo0hQu11L4aPc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com> <20240223004258.3104051-8-seanjc@google.com>
 <75d37243-e2a3-421a-b74f-ccbe307fef96@intel.com> <Zd6Wo0hQu11L4aPc@google.com>
Message-ID: <Zd_Vk1dlpLNjUzQD@google.com>
Subject: Re: [PATCH v9 07/11] KVM: selftests: Allow tagging protected memory
 in guest page tables
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Carlos Bilbao <carlos.bilbao@amd.com>, Peter Gonda <pgonda@google.com>, 
	Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, Sean Christopherson wrote:
> On Wed, Feb 28, 2024, Xiaoyao Li wrote:
> > On 2/23/2024 8:42 AM, Sean Christopherson wrote:
> > ...
> > > diff --git a/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
> > > new file mode 100644
> > > index 000000000000..218f5cdf0d86
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
> > > @@ -0,0 +1,7 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > +#ifndef _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
> > > +#define _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
> > 
> > Since the file name is changed from kvm_host.h (in v7) to kvm_util_arch.h,
> > we need to update it as well.
> > 
> > Ditto for other archs
> 
> Ugh, nice catch.  I'll fixup and force push (likely tomorrow).

Here's the diff of my fixup:

diff --git a/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
index 218f5cdf0d86..e43a57d99b56 100644
--- a/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
-#define _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+#ifndef SELFTEST_KVM_UTIL_ARCH_H
+#define SELFTEST_KVM_UTIL_ARCH_H
 
 struct kvm_vm_arch {};
 
-#endif  // _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+#endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
index c8280d5659ce..e43a57d99b56 100644
--- a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
-#define _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+#ifndef SELFTEST_KVM_UTIL_ARCH_H
+#define SELFTEST_KVM_UTIL_ARCH_H
 
 struct kvm_vm_arch {};
 
-#endif  // _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+#endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h b/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
index 4c4c1c1e4bf8..e43a57d99b56 100644
--- a/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _TOOLS_LINUX_ASM_S390_KVM_HOST_H
-#define _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+#ifndef SELFTEST_KVM_UTIL_ARCH_H
+#define SELFTEST_KVM_UTIL_ARCH_H
 
 struct kvm_vm_arch {};
 
-#endif  // _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+#endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
index 205ed788aeb8..9f1725192aa2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _TOOLS_LINUX_ASM_X86_KVM_HOST_H
-#define _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+#ifndef SELFTEST_KVM_UTIL_ARCH_H
+#define SELFTEST_KVM_UTIL_ARCH_H
 
 #include <stdbool.h>
 #include <stdint.h>
@@ -20,4 +20,4 @@ static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
 #define vm_arch_has_protected_memory(vm) \
        __vm_arch_has_protected_memory(&(vm)->arch)
 
-#endif  // _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+#endif  // SELFTEST_KVM_UTIL_ARCH_H
