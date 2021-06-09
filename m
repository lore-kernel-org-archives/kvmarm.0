Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E891CC48BCD
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:37:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62C916139A
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:37:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62C916139A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE2B740629;
	Wed,  9 Jun 2021 10:37:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xSLdXaVKpkUD; Wed,  9 Jun 2021 10:37:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9006C4080B;
	Wed,  9 Jun 2021 10:37:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3422405A6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:37:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eW57nlujvSbr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 10:37:23 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8D404048B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:37:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623249443;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=bvCtC8uoQFN+N2CnQbF7Wd+VOqQKX0tbrscPImqjZYg=;
 b=I5axyqtdA4cQDPO1kFj73z0zgmvST9QA2XXRZ3od5ovav14ZhuUdkJSh8okgDVqBvbKRHc
 PFlqdBnzbCtBKZpVuk6+t03NAMgFBKVkTz2Tfj+tZ5Y3YzYEJ6yYGaYfp0FKMESWfObPnF
 h7rW4cdYLZcmiel97sdt60zXbprSSAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-12DbjUfyNT2vsDPVFvykVA-1; Wed, 09 Jun 2021 10:37:22 -0400
X-MC-Unique: 12DbjUfyNT2vsDPVFvykVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0722A801B14;
 Wed,  9 Jun 2021 14:37:21 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-134.ams2.redhat.com
 [10.36.113.134])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 5C3FE19726;
 Wed,  9 Jun 2021 14:37:15 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v2 0/7] unify header guards
Date: Wed,  9 Jun 2021 16:37:05 +0200
Message-Id: <20210609143712.60933-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: Laurent Vivier <lvivier@redhat.com>, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 kvm-ppc@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu
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

This is an extension of "s390x: unify header guards" to the rest
of kvm-unit-tests. I tried to choose a pattern that minimizes the
changes; most of them are for s390x and x86.

v1->v2:
- change the patterns and document them
- change other architectures and architecture-independent code as well

Cornelia Huck (7):
  README.md: add guideline for header guards format
  lib: unify header guards
  asm-generic: unify header guards
  arm: unify header guards
  powerpc: unify header guards
  s390x: unify header guards
  x86: unify header guards

 README.md                         | 9 +++++++++
 lib/alloc_page.h                  | 4 ++--
 lib/arm/asm/assembler.h           | 6 +++---
 lib/arm64/asm/assembler.h         | 6 +++---
 lib/asm-generic/atomic.h          | 4 ++--
 lib/asm-generic/barrier.h         | 6 +++---
 lib/asm-generic/memory_areas.h    | 4 ++--
 lib/asm-generic/pci-host-bridge.h | 4 ++--
 lib/libcflat.h                    | 4 ++--
 lib/list.h                        | 4 ++--
 lib/pci-edu.h                     | 4 ++--
 lib/pci-host-generic.h            | 4 ++--
 lib/s390x/asm/arch_def.h          | 4 ++--
 lib/s390x/asm/barrier.h           | 4 ++--
 lib/s390x/asm/cpacf.h             | 6 +++---
 lib/s390x/asm/facility.h          | 4 ++--
 lib/s390x/asm/float.h             | 4 ++--
 lib/s390x/asm/mem.h               | 4 ++--
 lib/s390x/asm/sigp.h              | 6 +++---
 lib/s390x/asm/spinlock.h          | 4 ++--
 lib/s390x/asm/time.h              | 4 ++--
 lib/s390x/asm/uv.h                | 4 ++--
 lib/s390x/css.h                   | 4 ++--
 lib/s390x/interrupt.h             | 4 ++--
 lib/s390x/mmu.h                   | 4 ++--
 lib/s390x/sclp.h                  | 6 +++---
 lib/s390x/sie.h                   | 6 +++---
 lib/s390x/smp.h                   | 4 ++--
 lib/s390x/uv.h                    | 4 ++--
 lib/s390x/vm.h                    | 6 +++---
 lib/setjmp.h                      | 4 ++--
 lib/string.h                      | 6 +++---
 lib/vmalloc.h                     | 4 ++--
 lib/x86/acpi.h                    | 4 ++--
 lib/x86/apic-defs.h               | 6 +++---
 lib/x86/apic.h                    | 4 ++--
 lib/x86/asm/barrier.h             | 4 ++--
 lib/x86/asm/debugreg.h            | 6 +++---
 lib/x86/asm/io.h                  | 4 ++--
 lib/x86/asm/memory_areas.h        | 4 ++--
 lib/x86/asm/page.h                | 4 ++--
 lib/x86/asm/pci.h                 | 4 ++--
 lib/x86/asm/spinlock.h            | 4 ++--
 lib/x86/asm/stack.h               | 4 ++--
 lib/x86/atomic.h                  | 4 ++--
 lib/x86/delay.h                   | 4 ++--
 lib/x86/desc.h                    | 4 ++--
 lib/x86/fault_test.h              | 4 ++--
 lib/x86/fwcfg.h                   | 4 ++--
 lib/x86/intel-iommu.h             | 4 ++--
 lib/x86/isr.h                     | 4 ++--
 lib/x86/msr.h                     | 6 +++---
 lib/x86/processor.h               | 4 ++--
 lib/x86/smp.h                     | 4 ++--
 lib/x86/usermode.h                | 4 ++--
 lib/x86/vm.h                      | 4 ++--
 powerpc/spapr.h                   | 6 +++---
 s390x/sthyi.h                     | 4 ++--
 x86/hyperv.h                      | 4 ++--
 x86/ioram.h                       | 4 ++--
 x86/kvmclock.h                    | 4 ++--
 x86/svm.h                         | 4 ++--
 x86/types.h                       | 4 ++--
 x86/vmx.h                         | 4 ++--
 64 files changed, 148 insertions(+), 139 deletions(-)

-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
