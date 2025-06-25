Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B4638DDB
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 11:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750851205; cv=none; b=e+ORGdhRT+ZdFuZjeCfY6knccXGNyvxoe6UkITZDEsgDvCEq3ieZ3zcVXM5ozIK5difv8zOh7M16VHNKQ7+BW4b1/SdU6BPnLUzpLIsSpDWXEvgDDR+/5uRzDbcY2Iy+mmW/Cb/h0piLNkrjwbH0iTzwNoToz0nlTOJC/3jzEWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750851205; c=relaxed/simple;
	bh=/cwfe7cQie7eRGu4mTNSb1C1PMIa0UZgfLu+KikXDvc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oSP3NbCB8wn47d7Z3kn8InPNRHg5Qxk51DNC6lvUv24ZHcTceDO1+1diUDJ6BvG8nnSG8HUqzUB0KMq8854STOhtrg+Qu6UduC+Zlhdnp3EN7RTM7o3RNjG3dsKphqkwiev8IiTp3w7bBDI+4rnPY7y5RNPhC+AC9QCRJM3LP2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n2tHAFUy; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n2tHAFUy"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4532ff43376so52013855e9.3
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 04:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750851202; x=1751456002; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2NIlOMIrjnVsdM2AHEMlWacU0EQa3pY5nigk/W+dUCk=;
        b=n2tHAFUyOQvewHLZHeAPx6b4bysYsEK5g5vlNb3Y79lMol7HLPCW5xsyvVeEGRQn9J
         KYHBsRyX8GQqkAzKIQ+RuFa4kBFgWr7gL4vmEfBA/xzKjalBZ1LFN4Rh7vWsZ3g2XCQt
         HoGl4OP5DNuYRyGdx4T3xk7nF//ykBlpSRRQSyth2jHFUhKB96ypcZ01KnsaYVqU3wCY
         V4wd7JTqwlB33hbzKMPhadcKSBNFNayQFkYrnDxMyp4cPWK42poDcCcxyILIjW2mWrhr
         hNOKCLaXFNJxakOIFyyW2NQcwTbHVCSIJ9R42xQTl0z5ihlMEfu3DPng9VYGwpfaou5a
         arAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750851202; x=1751456002;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2NIlOMIrjnVsdM2AHEMlWacU0EQa3pY5nigk/W+dUCk=;
        b=Uo90zQmd6c4dRRRbXTwxRbKfSkZ6SwhE/JdtpYeoxbKxaazr6rozJA+qzYWdoJH4d3
         PmjExNHBas+oLQ9xibY0Oycp7h0Hg/I2B5uuxKbprwJTkA6at8+3VA9UNgBLId6+K6T1
         du/ggnCgl1xo+F9/NK1W24a+Ja4RGhc3GX6p5nPeSdJhxKLqEj7tqQZxfnMsHOhY7iNe
         3Ngjq45CUfmNWqLl9e+S9vUPAri/wIwwCZ76fWT9HvGpJ6cEZVEQbTs+y+/P5YVvMzuC
         U4EnBLTqEsCdjL9k6fir7HDMbBTLCZIxzOlZC7MFTxGPU/+2alGv+swPKqf+QqdB1X+T
         XFIQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+hHELj+NANy5Bc7SERUPHncpbcuujL8R13CZBXfMISinIJPe/f7eWxaoUULdgRsBz7n+vfY8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwswCZu0sLOQCfmG4vRbp6sFLBx/cfNlsk6104TIPxfPwDJvjdz
	Zcx7LzKi75vZpVo/+M6lgOGpHH8LWPnN16MSCpj921/F2i5hnQAeLla/bnsSRL63Fy+IM7RjY8A
	nW2WLFk7fR5mJBA==
X-Google-Smtp-Source: AGHT+IFOs0Gi4knoSxkuw3WEzWTeg5pmNz2XOZ2P1IvG2UaOypTfCATZEtKucsPAekJhdqLV//IPLmdoJn1rpQ==
X-Received: from wmbfs5.prod.google.com ([2002:a05:600c:3f85:b0:450:cfda:ece7])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:674a:b0:441:b076:fce8 with SMTP id 5b1f17b1804b1-45381ab25e9mr28886085e9.14.1750851201981;
 Wed, 25 Jun 2025 04:33:21 -0700 (PDT)
Date: Wed, 25 Jun 2025 11:33:01 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250625113301.580253-1-smostafa@google.com>
Subject: [PATCH] KVM: arm64: Fix error path in init_hyp_mode()
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

In the unlikely case pKVM failed to allocate carveout, the error path
tries to access NULL ptr when it de-reference the SVE state from the
uninitialized nVHE per-cpu base.

[    1.575420] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[    1.576010] pc : teardown_hyp_mode+0xe4/0x180
[    1.576920] lr : teardown_hyp_mode+0xd0/0x180
[    1.577308] sp : ffff8000826fb9d0
[    1.577600] x29: ffff8000826fb9d0 x28: 0000000000000000 x27: ffff80008209b000
[    1.578383] x26: ffff800081dde000 x25: ffff8000820493c0 x24: ffff80008209eb00
[    1.579180] x23: 0000000000000040 x22: 0000000000000001 x21: 0000000000000000
[    1.579881] x20: 0000000000000002 x19: ffff800081d540b8 x18: 0000000000000000
[    1.580544] x17: ffff800081205230 x16: 0000000000000152 x15: 00000000fffffff8
[    1.581183] x14: 0000000000000008 x13: fff00000ff7f6880 x12: 000000000000003e
[    1.581813] x11: 0000000000000002 x10: 00000000000000ff x9 : 0000000000000000
[    1.582503] x8 : 0000000000000000 x7 : 7f7f7f7f7f7f7f7f x6 : 43485e525851ff30
[    1.583140] x5 : fff00000ff6e9030 x4 : fff00000ff6e8f80 x3 : 0000000000000000
[    1.583780] x2 : 0000000000000000 x1 : 0000000000000002 x0 : 0000000000000000
[    1.584526] Call trace:
[    1.584945]  teardown_hyp_mode+0xe4/0x180 (P)
[    1.585578]  init_hyp_mode+0x920/0x994
[    1.586005]  kvm_arm_init+0xb4/0x25c
[    1.586387]  do_one_initcall+0xe0/0x258
[    1.586819]  do_initcall_level+0xa0/0xd4
[    1.587224]  do_initcalls+0x54/0x94
[    1.587606]  do_basic_setup+0x1c/0x28
[    1.587998]  kernel_init_freeable+0xc8/0x130
[    1.588409]  kernel_init+0x20/0x1a4
[    1.588768]  ret_from_fork+0x10/0x20
[    1.589568] Code: f875db48 8b1c0109 f100011f 9a8903e8 (f9463100)
[    1.590332] ---[ end trace 0000000000000000 ]---

It seems also in other cases, it can try to free NULL ptrs, so add the
proper NULL checks in teardown_hyp_mode(), we can skip the loop early
if any of the ptrs is NULL as the order of free matches the order of
initialization.

I initially observed this on 6.12, but I could also repro in master.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/arm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 38a91bb5d4c7..5bb36c3b06b5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2344,15 +2344,22 @@ static void __init teardown_hyp_mode(void)
 	int cpu;
 
 	free_hyp_pgds();
+	/* Order matches the order of initialization init_hyp_mode() */
 	for_each_possible_cpu(cpu) {
+		if (!per_cpu(kvm_arm_hyp_stack_base, cpu))
+			continue;
 		free_pages(per_cpu(kvm_arm_hyp_stack_base, cpu), NVHE_STACK_SHIFT - PAGE_SHIFT);
+
+		if (!kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu])
+			continue;
 		free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nvhe_percpu_order());
 
 		if (free_sve) {
 			struct cpu_sve_state *sve_state;
 
 			sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
-			free_pages((unsigned long) sve_state, pkvm_host_sve_state_order());
+			if (sve_state)
+				free_pages((unsigned long) sve_state, pkvm_host_sve_state_order());
 		}
 	}
 }
-- 
2.50.0.714.g196bf9f422-goog

