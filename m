Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9B914EC53
	for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 10:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721729538; cv=none; b=lGOvrME9+d2Cee1q9PslV250afPuJgpvtRxCvhvy9LRbi1Bk2epMdVXuXq9NXx819z3lOhkbCdf+QTNIZfAyqQEoGB3STw/QeT7so4ytcq78LTyB25LI7XRKmst0ZHsiNuD8lwKNVq7zcrlGuTUdcPqym9rgDb1FtcBBdBCyfjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721729538; c=relaxed/simple;
	bh=itl1BX28HKdGQXXxJvtLtVN7uHwH3jOcmXGakq6ld9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L7v9/CCnJ+oEh6AQmrvkfLGtFLwL9VsKO289lsjgQHm3jFdqEdpIx242QWb4atDTFhB76tpWnUEH9vkbJe4eD49aCZ3XaSPWu2xV5aQyEt3VEWMKi14Fr41Ptf+gZ0Nx6HrYT+pfFD7hg1mO7DFDR25+4LkkFaOfxdMVIh1ZjcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ax7hHjUd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ax7hHjUd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721729535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xzuyk5RPlpL9t0A/8o4faeOblpZCzvEu932Ng83fGMs=;
	b=Ax7hHjUdqqEr5/IFwxcjzrrIGeCnd8gvWGGo9LVXwI2+3odmAH7dSjhejve5nqTeG8vx3k
	Z6cKL4hX8LCW/QTzoTsjKDdp6YUeTfecaDZLHoQRC6qYd2ALASjmKRrkRYbcsBpZseg0fx
	Di0U1Awd09Jh6u7EV/7XzCis+LXWM/Q=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-n2FdrsWUP6OJnwBoAxilqA-1; Tue, 23 Jul 2024 06:12:13 -0400
X-MC-Unique: n2FdrsWUP6OJnwBoAxilqA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7a16375187aso725998485a.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 03:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721729533; x=1722334333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xzuyk5RPlpL9t0A/8o4faeOblpZCzvEu932Ng83fGMs=;
        b=NUZwTxae4aw2DbLVtYvCnAMcHj7HtAl85oCcjKOu1WTJpNrdRzXxgX6t810EyVeGUd
         Q12wbQUlAc9Bl0dRJkFjPs+Vx764y5foaUW1DAXVjBHOua4lE7OOyl49NAAdlrC6BiGB
         xzxRPGwuCu78mJEq0hu9th3h+Mln1/Q6ofWlpnUTuEQQJ65YZuRThS+KEkIUGgFK9hHr
         wPKmuUACWaQF/euwIX66VvmoWNRLXWMeBJGNvDta4YfYuUnckxeHZ6EX8BVDNin8HFFx
         zLGR19C16d2V9wyX7jJBKdU9bqkU2uvGbKJzOziIbuuXIQwAgE4nvfKGND2ya4eglBLL
         Jsvw==
X-Forwarded-Encrypted: i=1; AJvYcCWGoyeUZ5JWsr5Pq5UYS0yAIxeTBS54jLCNtP0rTd7vjNdpH9PDESVZ8VZoDUVtnwE4ksW6nf7971DCXZN1pU8owNkUxtcf
X-Gm-Message-State: AOJu0YynN15xzvcdNr6Ltbd7IBIzIX6ko/R3YJMUCFgz+igfo2Gx3Gea
	h83cQAIJnNSdK5C8v5WryyaAVzpe2HuOw1fJzONqlaGcnL99dHTKzNBVBdFTK3Fd/nQmOB0JN3+
	aVSuUtwBTlCJ0iI/leIx+IFlJMabfm6RVRbV6WvQ7xhVFNmjQqY+D/g==
X-Received: by 2002:a05:620a:394a:b0:79f:16c8:b04a with SMTP id af79cd13be357-7a1c06bc41fmr275051285a.26.1721729533203;
        Tue, 23 Jul 2024 03:12:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvx7LA7H50ASsJ8L06HMjDMhwLdP2mNIndsn8L+inHJpH2PTr3YecDjb7uZQ/0eEz1EtS9Fw==
X-Received: by 2002:a05:620a:394a:b0:79f:16c8:b04a with SMTP id af79cd13be357-7a1c06bc41fmr275049785a.26.1721729532879;
        Tue, 23 Jul 2024 03:12:12 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f45e50062e5f8c654844c9a.dip0.t-ipconnect.de. [2003:c9:3f45:e500:62e5:f8c6:5484:4c9a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a1990063f2sm463780085a.64.2024.07.23.03.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 03:12:12 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 1/3] KVM: arm64: fix override-init warnings in W=1 builds
Date: Tue, 23 Jul 2024 12:12:02 +0200
Message-ID: <20240723101204.7356-2-sebott@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723101204.7356-1-sebott@redhat.com>
References: <20240723101204.7356-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Add -Wno-override-init to the build flags for sys_regs.c,
handle_exit.c, and switch.c to fix warnings like the following:

arch/arm64/kvm/hyp/vhe/switch.c:271:43: warning: initialized field overwritten [-Woverride-init]
  271 |         [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15_32,
      |

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/kvm/Makefile          | 3 +++
 arch/arm64/kvm/hyp/nvhe/Makefile | 2 ++
 arch/arm64/kvm/hyp/vhe/Makefile  | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index a6497228c5a8..86a629aaf0a1 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -10,6 +10,9 @@ include $(srctree)/virt/kvm/Makefile.kvm
 obj-$(CONFIG_KVM) += kvm.o
 obj-$(CONFIG_KVM) += hyp/
 
+CFLAGS_sys_regs.o += -Wno-override-init
+CFLAGS_handle_exit.o += -Wno-override-init
+
 kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 782b34b004be..b43426a493df 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -20,6 +20,8 @@ HOST_EXTRACFLAGS += -I$(objtree)/include
 lib-objs := clear_page.o copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
+CFLAGS_switch.nvhe.o += -Wno-override-init
+
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 3b9e5464b5b3..afc4aed9231a 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,6 +6,8 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
+CFLAGS_switch.o += -Wno-override-init
+
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
-- 
2.42.0

