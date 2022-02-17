Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40F2C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 03:50:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3107F48F9C;
	Wed, 16 Feb 2022 22:50:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lTvjyjTylqjy; Wed, 16 Feb 2022 22:50:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEC4D40E00;
	Wed, 16 Feb 2022 22:50:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2D1D40E00
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 22:50:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mWNFS1FfrAA5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Feb 2022 22:50:12 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EC39408A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 22:50:12 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 q14-20020a170902eb8e00b0014f5d754fa5so459683plg.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 19:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=vRtM/cROOx5FsqNMttv0pPiPYqWySn+ox7xCpR/R9pQ=;
 b=VXI/EO5uA+etW0dY+bDcMbof9vcOt9SX4c8MIwKYL2KjJK778sgRC4ONa+S96Tq0kC
 2DNAkeg32L87pidTLjIxaGqseJc+3T5vMuB+w+93GZkI2D2TVXTTsK9tLKdq55IVduJd
 HY6Yt6e7ITaZd1JWGm6SAif/ms7rSjFues9sLIJCzp12Jt5VwgzXhnRJusVMPVi7fx7K
 EGLTgjyoji9r7qxZ7uhq821QmUs0eEGMKzsvl5mW4BzjI4gNlfYLd+rvssbuo7pt2BsP
 pXyzTyGwbqarreY8cymIKeiUQtmMLmNlCpb2jOchN184vkaWtt52ENyHw4o+hy9Vex4V
 c4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=vRtM/cROOx5FsqNMttv0pPiPYqWySn+ox7xCpR/R9pQ=;
 b=v+NLmYWbD19ONc5G+g1zgUAiSshHqrcNSeII3eb6sJynOQ1yKi1qrs+bhaMwLZ6iSr
 XjuIHqe4MLZ72g7Ug6MP5I79LSw/OUqJQsYOVsMuED9XJsKi/FYV3+zc+c5qVwfJMRV8
 5PSVgyy3qapXFN8xLT+EScRAIOsQXM9+jgByOy2Z4CUhaVzRS2RaZBOwo/jnD8oislw4
 X23FjMPShdBlWdk3leH/dNzB9hKCvic1wQM3eHI5F9tDkj7SWO+VYvnaovipWurTbmoM
 A4GqvwzwxTlRP/pVY9GXXrehEAMEhyHxcFCdp5zNG8M4gaKJc2QqyIzHpACSsGaB/pPZ
 UbVQ==
X-Gm-Message-State: AOAM531MVHcKnaqOqwIQfBwA9wR+AJiY9W/z91oB59Lzf+EsjZ+MDsJC
 KFAqEIyc1evSntC3hGEF+BZ9HEv7tH4=
X-Google-Smtp-Source: ABdhPJz43oeS5F0siXWsZh061o21n+qfPtthgPIgTIT8DyUX6v2rSoMU2ZNvcsVNXhRZGwvcQO+2wDnOY7E=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:1f4d:b0:1bb:a657:ace5 with SMTP id
 y13-20020a17090a1f4d00b001bba657ace5mr2283133pjy.39.1645069811410; Wed, 16
 Feb 2022 19:50:11 -0800 (PST)
Date: Wed, 16 Feb 2022 19:49:46 -0800
Message-Id: <20220217034947.180935-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH 1/2] KVM: selftests: kvm_vm_elf_load() and elfhdr_get() should
 close fd
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

kvm_vm_elf_load() and elfhdr_get() open one file each, but they
never close the opened file descriptor.  If a test repeatedly
creates and destroys a VM with vm_create_with_vcpus(), which
(directly or indirectly) calls those two functions, the test
might end up getting a open failure with EMFILE.
Fix those two functions to close the file descriptor.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/lib/elf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 13e8e3dcf984..9b23537a3caa 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -91,6 +91,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
 		"  hdrp->e_shentsize: %x\n"
 		"  expected: %zx",
 		hdrp->e_shentsize, sizeof(Elf64_Shdr));
+	close(fd);
 }
 
 /* VM ELF Load
@@ -190,4 +191,5 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 				phdr.p_filesz);
 		}
 	}
+	close(fd);
 }
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
