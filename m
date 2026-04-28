Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7731D37CD25
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 10:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372216; cv=none; b=Mh72K0dVY0G65LxdxhNZHQvUPe7VZRtXYS7T/PmJOCSjmSO9SZ60AVc9EvJfQ9oHuDdRAT6JOIWKL+zS4E5PmYggq/F+g/xUC0cwAOQam7mwBNf9Hp82aLZb0/ijrrWgCS0+NtOo6L7cg9445yhh60RLecYRXT9yJ5OD/HTrQKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372216; c=relaxed/simple;
	bh=ZtY1NVCPXnAC9eiQixJVX87FIa55uNvzITzHg3dFSas=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iWtkCiSEGrYBCyU4qywcn+pcxp3Re6l3yw6sR7CD1ws1hcJdSKjaNw6HXowzPquBaTpsjjwGVDpxPMhv8gj4N1DLCft14vBJGAG7Sv0act1Pga2fd4dOFuVZJhZCPKPX8qNn9zP0+WX5wdJiYXSl11GQV7eD00w5cotsT+wLCZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MhQbTG2K; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MhQbTG2K"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486fa07f2bbso78103755e9.2
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 03:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777372213; x=1777977013; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2V4DeFz5zQx5vHTeG+ccViUA0qR3iKjsW9CqkQ1XIv0=;
        b=MhQbTG2KmLj5b/K8W5wMLWWPjk1FI5LQfe7lnHVi+tK6wvpSQoOuE2MQF2aHUVmKmi
         xFIR5lvJCWnAduDRrQYTq7rEaJ4cMAk1XuUZPOgFwZv3kI4jo/bWH0I8I96YY9xOpX+f
         +2GBWFmbySEq8zAUla5K1l+OxkEbpTO46v7Xlhj9FtOPlctmLnI5qTFjkCRILMA3i3eG
         Z/8L3iuUFwOE9cOBG7V1AVd4whzaA4MKkk+bwc21CPDt5kdv/lrJSbbxVZJlOHmktluS
         XnG/KsmihMAMraavA9rmCISxY0qlJoQIXbB6RthlU+TiDVw+TMCav1aGnu6Z1M3nqk97
         6RhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372213; x=1777977013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2V4DeFz5zQx5vHTeG+ccViUA0qR3iKjsW9CqkQ1XIv0=;
        b=GfDjkUtV5uahhsgn1wUq9AoSUHz7OUFkdysWwJXJ+tjihgs+dRVAzry7MFdLHKmtdh
         ctfddKSKegHBJfZ61uycQyGW4MOtBgHao5cY1y0ODMtfOA+CYQzbmXM35XmByZFOzAsH
         Hdyblo/7OQ/gYJsOyU99uEFaOltXSeZwH75cX6lyM3IAhYsmtapc0yHbuFY1y8mBMv43
         +sPcsHfp0U5hTssHOabUpjV1Q0YwoTW0cUTElPLVNZTrveAVjpFdAH/lagcwyoGZa9W1
         t6LGUFaPNoY0NGxhrgjfNJnvkPLgs4F1XoJLmyvl7nxjRpRWYaO5WP5oYIAKwlUS0jbl
         8iOg==
X-Forwarded-Encrypted: i=1; AFNElJ9J3rbb12OYKMQzC/Ef6qzIHGQBKgQ306vPC4j7Y64r8IaQwo80BuxuguE71pE/Sco9YNDcRwo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+vKqtIb8zlPjEablyhinrsE7UTsm53+0652m4e9C/+Qgazklu
	PxRCNo2Vfn6DXpWVmDJJoBagBXOTH+TZPJXxnUDw8iR7lvsZNhd0hsBVOEuqAT+r9A4R8Sc2mCX
	sgg==
X-Received: from wmpc9.prod.google.com ([2002:a05:600c:4a09:b0:48a:54ff:28b2])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c177:b0:48a:5301:bb5c
 with SMTP id 5b1f17b1804b1-48a77b12a49mr34221165e9.16.1777372212793; Tue, 28
 Apr 2026 03:30:12 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:30:03 +0100
In-Reply-To: <20260428103008.696141-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428103008.696141-4-tabba@google.com>
Subject: [PATCH 3/8] KVM: arm64: Guard against NULL vcpu on VHE hyp panic path
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On VHE, __hyp_call_panic() unconditionally calls __deactivate_traps(vcpu)
on the vcpu pointer read from host_ctxt->__hyp_running_vcpu. That pointer
is cleared after every guest exit (and is never set when no guest is
running), so an unexpected EL2 exception landing in _guest_exit_panic,
e.g. via the el2t*_invalid / el2h_irq_invalid vectors - reaches this
function with vcpu == NULL. __deactivate_traps() then dereferences vcpu
via ___deactivate_traps() -> vserror_state_is_nested() -> vcpu_has_nv()
-> vcpu->arch.features, faulting inside the panic handler and obscuring
the original failure.

The nVHE counterpart (hyp_panic() in arch/arm64/kvm/hyp/nvhe/switch.c)
already guards its vcpu-using cleanup with "if (vcpu)"; mirror that
here. sysreg_restore_host_state_vhe() and __hyp_do_panic() do not depend
on vcpu and continue to run unconditionally, preserving panic forensics.
The trailing panic("...VCPU:%p", vcpu) prints "(null)" safely via
printk's %p handling.

Fixes: 6a0259ed29bb ("KVM: arm64: Remove hyp_panic arguments")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 140d3bcb5651..8912863cc238 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -674,7 +674,8 @@ static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 	host_ctxt = host_data_ptr(host_ctxt);
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
-	__deactivate_traps(vcpu);
+	if (vcpu)
+		__deactivate_traps(vcpu);
 	sysreg_restore_host_state_vhe(host_ctxt);
 
 	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n",
-- 
2.54.0.545.g6539524ca2-goog

