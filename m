Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A85433557B
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682531; cv=none; b=ZYSvrN9nyge3KQ7ltssljSCl99iMCK/53hw0Z88ak79Fqn4/Vr6qHkj8vio99vUUer12UXr0x9OS1kSNF5MNk5GuTwusRPPV49PD9UrNKMmy9CEK+Wq3To2y5IiSJUp67DS91LeEGXq9BIoCrCOuX5qG9wRhS1/3I2SCzJIdqUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682531; c=relaxed/simple;
	bh=AALkJl92/GpB0vDXcTqf/Xhr5ubXN5L/mRxqftaIeJI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tIznjr9cjgrnnwRGvD9dnqCS0EnG5sDrgMeardokl+amj9jQ3A79xQUiT0Z6wvb6RzG3l+iUdLUJWnEU5osadEr9Zg7OOKqdoWoE3wYmxFgtktbXNr/1Q1BAjeX1Kkxyflx4HF8MHR+a5yBUTLqgB1EfaLzfivO8TzniPDZfYPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QT/RXnJB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QT/RXnJB"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485397788b3so45907055e9.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682529; x=1774287329; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DrkEb2n12YyrcySqlJ1Endt4MHN6ko+q0The82lLn1s=;
        b=QT/RXnJB1lVp+m0frtH1eQ4UwBHqZq1psjc+IRTZxb9rijbX8lW6ZWST8eue4BWMtt
         dHo6xxqUC+zzFk/PZc5QdcxIbv8aCYbuIAwcX6C75lYxpAM+PSR5w7R9V+IRb7vhFCNn
         qMbYkKkFFsD9ShiadthpzUBNMPCcfMJuxmEAKuiNHe9DmUBa/Cm5Z/kOVu+A8UAjAvc6
         yV18i0P2zRzmLX6MlMvQ74cDTyApNHc/WMIkz72NJKisCegtd64qALLy68V4YQNuTDIF
         D2Rlqwf609YPJ5UHqKTA/OGZ9P4AmbCxA3UxW5iVcgVc9DPPkYSTUq3+mTK4nLhq6HvH
         u0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682529; x=1774287329;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DrkEb2n12YyrcySqlJ1Endt4MHN6ko+q0The82lLn1s=;
        b=kdfHzz51bqPK13NGQeD5MB9HUuYxUuTs/eKgkxd87KnGQMMToeWoVIPjBn7eLVcAQB
         l5v/OxBPjB17OQtqVvOauVaSflzi2TMnTWbf1F7RdvgmmqG2ObR4Me5o6aWffc4rNa9v
         eh+zIwhJew+usL8OzxQkFh/D525knGjZ3o5LDvvVl/cqAWgQquJ6mPKNU4TjItoGH50o
         sMji8FJwf4mIX8T28ULhhWswOzbUX14dcLLN5qV4EAaeopDnAu7jjYcWvDISpjg5Y5Ik
         r3aZzlJ19KMOf0lxXIUntvrZbPC7RzmMMPnnAOhMZE3x5/LGy2BO0hVOh0SlSaoXzXLh
         fy8g==
X-Forwarded-Encrypted: i=1; AJvYcCXXmSq/QECwF9zV1mB4+4/qccMY5NVHzrdKjnZrhceMfx0/x0smy60UoA7s9kNq2eWKAbXECoI=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywe+vP7OC/6mTTAl9JyTcb5Ox82SOAvqp8UbqTscJe9tsCsQs9N
	Rgp35WmY3p2RHBMuFpd/rRtKBujvMzVwwSFi7GK3CqKqY0glpXHviwgvQxP9GWcsn3ND1pnUiZi
	9dg==
X-Received: from wmno9.prod.google.com ([2002:a05:600c:1649:b0:485:38ca:51c9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:354b:b0:480:2521:4d92
 with SMTP id 5b1f17b1804b1-485567071a0mr226576455e9.24.1773682528999; Mon, 16
 Mar 2026 10:35:28 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:35:22 +0000
In-Reply-To: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260316-tabba-el2_guard-v1-1-456875a2c6db@google.com>
Subject: [PATCH 01/10] KVM: arm64: Add scoped resource management (guard) for hyp_spinlock
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"

The Linux kernel recently introduced scoped resource management macros
in <linux/cleanup.h>, enabling RAII-like patterns such as guard() and
scoped_guard(). These macros significantly reduce the risk of resource
leaks, deadlocks, and messy unwinding paths.

The arm64 KVM EL2 hypervisor heavily relies on its own locking
primitive, hyp_spinlock_t. Managing these locks carefully across
complex failure paths is critical, as missing an unlock at EL2
typically results in a lethal system-wide panic.

Add support for the guard(hyp_spinlock) and scoped_guard(hyp_spinlock)
macros by including <linux/cleanup.h> and using the DEFINE_LOCK_GUARD_1
infrastructure in the spinlock header. This paves the way for converting
error-prone manual locking into automatic scoped management.

Change-Id: Iba6d43c081b5fdf2496dc599fd6a781294493cb9
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
index 7c7ea8c55405..2681f8d2fde5 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
@@ -16,6 +16,7 @@
 #include <asm/alternative.h>
 #include <asm/lse.h>
 #include <asm/rwonce.h>
+#include <linux/cleanup.h>
 
 typedef union hyp_spinlock {
 	u32	__val;
@@ -98,6 +99,10 @@ static inline void hyp_spin_unlock(hyp_spinlock_t *lock)
 	: "memory");
 }
 
+DEFINE_LOCK_GUARD_1(hyp_spinlock, hyp_spinlock_t,
+		    hyp_spin_lock(_T->lock),
+		    hyp_spin_unlock(_T->lock))
+
 static inline bool hyp_spin_is_locked(hyp_spinlock_t *lock)
 {
 	hyp_spinlock_t lockval = READ_ONCE(*lock);

-- 
2.53.0.851.ga537e3e6e9-goog

