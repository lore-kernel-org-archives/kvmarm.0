Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794836440;
	b=IM5+fcj/+DuyGE932m0gf2KpzAQ1dsZ5Y3wPZxpc4d9OdOzO320b9A68gzGF+TpI15My
	 eqogv4bjEzNhmV5tqDCGl6N+ab/lgINRS4nspPEVSKEb45h9GoU8K+DD1gTTeL217J0l1
	 6XLdLXc6AkjeLu1in3faV5T+Wq02JY4vhU5IEjtwWxlh00d1ZbFQ+Ns5b0KS1dGhxppVq
	 xrSe2VgjB5bRfBMtHvlr/29MJP7cXUj2+8rmK5ZAGRa0DHD7jAER5HuoGtj9TI+W4rhDB
	 Pb00rO4H+5u9xXg48X2bBzk0y5AM7EJvVxXU+7EqRaCj7isyrKV3reIBwtBqtvCoFdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794836440;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:X-Mailer;
	bh=rYZSKiWzbzGDSkOFczv6tAqyqip908dCHTB+bDdlwYA=;
	b=c/XFeg/DIaK0lZdE+IOC5MqN4QJh70pYKBY7ouhPCF0zrl8/tEKcDLUfgmnWtoLFCRvs
	 592c+9N9UWe8pys7Mc5nqx2LLDCtMQoAlOUhRg911tHC5ms4Hgto5cGg0uhMpghu50OOY
	 fA2FmYF7an9hpnZDgAF23n9sHtAka4m6IsCEPHCgqFaNOOSgFlFlD5PaoVVjKi2/pR12N
	 JryxkL5vP6DriDhaFaIb7xCfvuLdqYhMEapZp1hFFjpBZDKWMnmkHHwdkJf7HVz+ldOD3
	 Bz/SfpAbRw6dJmmujwn2v9E5o82d4Gxpes3GP1rehc/RUddfV9ReDHX/t+BMNh7JKWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=VQnsuG5U;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DED606A891
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 13:40:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72DED606A891
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=VQnsuG5U
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4cb6834eaaso104796366b.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 05:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1794836439; x=1795441239; darn=lists.linux.dev;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rYZSKiWzbzGDSkOFczv6tAqyqip908dCHTB+bDdlwYA=;
        b=VQnsuG5UYPekOV0ZCP0oqPjA89uFJGxSAOJUH4ZkgtLF5z6U3H42joWmkczpGjsiwC
         Qq9ElPWqCRE77NWPHCSSbKlGXf0eUKpI22NeiL+DA2g/dcO8XkOyV6VfM7bipNI7Qm7D
         YRt/+Uld4WJnBA+TIpYr01fFiktXg4WwDnkLRdiu/OFzW81SdeR47JRcjC6iWespjrR+
         yw9WHfRlZz5u/06NZDgM+xdIJ+7azY09N4HD9Ilxip2iNumgAp9eHyvSlVhr9jN4gNcD
         ZhJ7wAjjucnZCvtdO1VpsIkvNHYBeIYkj7JGzHauci/OnlzGyw7rXKVJ8tiYbWhg64Pn
         vJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794836439; x=1795441239;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rYZSKiWzbzGDSkOFczv6tAqyqip908dCHTB+bDdlwYA=;
        b=BHOgpuujEE/qbUA+bxYyHKslbor57sYXy9x+wgOGrOw6dOd6n2laCYyx9qVF1oScJS
         OindzxTSTg57uZPYonWpy8ME1DmsdKDc43aLhwd7MzPQ/LtzB05KRg54+itocHCK4zQ0
         QkeLNOe6v1ZreoJSUxq/2AA8maL6UXecQmjd19OcUtxOaMs8fqEXsM1dRCPrpG13rWGa
         MFt3BPt7PEPkD+zEInneA01U1OskrM78W+EApUBFK+jXVpBhkm+aoRANfBktrOkvzHRK
         rijwDRNPNB34JkawzfnQXVbTFaUl5tC+dO7BrnzxivzrUg9r1tycoNYMxcyap31JAdvG
         hC4A==
X-Forwarded-Encrypted: i=1; AL+hErF5hX5aSs2SYsEOIZKFusgzp/5Nr7XOlXHr4VEUexrKm3xrEq3Xl/tG32gtwoETpjBlBEqv04M=@lists.linux.dev
X-Gm-Message-State: APuU4Z989Gt8eiVI4Z2F0ymVlWQQSU6BLNm3WEIs1JmSRu0dkdOw9ZSw
	+u+hdUDx1AH6Qex01kncR9wcCnztqfmqZ0A2sMBiinYmNp0K/B4qJxLTuYYEGcudPlQ=
X-Gm-Gg: AYBFou1eZBeX+Y8iCvZUUvCNpGHmdpCajCbrTgT9UZq011QWbYPRsM8pzAqRecM7zOE
	/UAAzMt6fSiThK+7014DTk80GMTHhI8f5TiXMLA0/Z8Ge8V39/u3AzxNdb7HttBYVXrYNMGstJI
	FPTUz59356LEqAUct5ex3x38Pl7/P7wuST/H7be8AsRjxP49glYWSfO+v+MM8XSzdoPEYmeqi9z
	+25jFC14Ln7DmxMb7uRXgnM9aGp6dco8G200PhMpNOQKqZ8EqOy6qeMUNSjXqxsBZMfgBM4PNfK
	qDoWDib87dayq7YgzTEcUM3G4h5GqI3qfaAX4I1RJUf7W8n1e29Pgpj1docHhPC23TtDBsu8taw
	dwqpel/46I1iG71NNDxkjmYziboUixKVsVKu6lZQwlkLui1NNbxOsPzXZyfkHFKRR+yiBCGlG89
	BMKDKGEzcb4/rYfkLGYHMzVNHJSD3MNH7QOD7CL8xwPZ61pSPmc3ZL6VkFSJeQ2cy2L30LDntPN
	1H92MOnG072ntfJ7K/qmmQNLrmPGGm0+Rwy3L7pEr4xOEb5ueoEvoqR3Q+EFwz3f/eJAby4X1L1
	Q7YOXYY1XWQedjs2138=
X-Received: by 2002:a17:907:9492:b0:c2e:52d6:1fb7 with SMTP id a640c23a62f3a-c509636a2ffmr771296866b.22.1794836438561;
        Mon, 16 Nov 2026 05:40:38 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b2369asm426229866b.25.2026.11.16.05.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 05:40:37 -0800 (PST)
Date: Mon, 16 Nov 2026 16:40:34 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH] KVM: arm64: nv: Fix NULL dereference in kvm_inject_nested()
Message-ID: <avsH0lxpLIF2Ug64@stanley.mountain>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

There is a NULL dereference of vcpu->arch.hw_mmu in kvm_inject_nested()

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000084
  kvm_vcpu_put_hw_mmu (arch/arm64/kvm/nested.c:1046) (P)
  vhe_vcpu_put (arch/arm64/kvm/arm.c:827)
  kvm_arch_vcpu_put (arch/arm64/kvm/arm.c:860)
  kvm_inject_nested (arch/arm64/kvm/emulate-nested.c:2903)
  kvm_inject_nested_serror (arch/arm64/kvm/emulate-nested.c:2976)
  kvm_inject_serror_esr (arch/arm64/kvm/inject_fault.c:365)
  __kvm_arm_vcpu_set_events (arch/arm64/kvm/guest.c:827)
  kvm_arch_vcpu_ioctl (arch/arm64/kvm/arm.c:2017 arch/arm64/kvm/arm.c:2157)
  kvm_vcpu_ioctl (arch/arm64/kvm/../../../virt/kvm/kvm_main.c:4772)

KVM_SET_VCPU_EVENTS does not load the vcpu, but it injects a pending
SError or external abort straight away.  If the vcpu is in L2 context
and L1 has asked for the exception, kvm_inject_nested() puts and loads
a vcpu that is not loaded.  vcpu->arch.hw_mmu is NULL when the vcpu is
not loaded, so kvm_vcpu_put_hw_mmu() dereferences a NULL pointer.

To fix this bug, only put and load the vcpu when it is loaded, similar
to what kvm_reset_vcpu() does.  When the vcpu is not loaded there is
nothing to switch: the next kvm_arch_vcpu_load() loads L1's context.

Fixes: 9aba641b9ec2 ("KVM: arm64: nv: Respect exception routing rules for SEAs")
Fixes: 77ee70a07357 ("KVM: arm64: nv: Honor SError exception routing / masking")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
This was found through Pereq's formal analysis but the stack trace
comes from real life testing.

x86 implements kvm_arch_vcpu_ioctl() differently and puts vcpu_load()
at the start of the ioctl.  But the way arm64 does it is deliberately
and just something that people working with the code need to be aware
of, I guess.

 arch/arm64/kvm/emulate-nested.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 2bec81668361..22ca735a34f6 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2862,7 +2862,7 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 			     enum exception_type type)
 {
 	u64 pstate, mode;
-	bool direct_inject;
+	bool direct_inject, loaded;
 
 	if (!vcpu_has_nv(vcpu)) {
 		kvm_err("Unexpected call to %s for the non-nesting configuration\n",
@@ -2891,6 +2891,7 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	}
 
 	preempt_disable();
+	loaded = (vcpu->cpu != -1);
 
 	vcpu_set_flag(vcpu, IN_NESTED_EXCEPTION);
 
@@ -2900,7 +2901,8 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	 */
 	__kvm_adjust_pc(vcpu);
 
-	kvm_arch_vcpu_put(vcpu);
+	if (loaded)
+		kvm_arch_vcpu_put(vcpu);
 
 	kvm_inject_el2_exception(vcpu, esr_el2, type);
 
@@ -2915,7 +2917,8 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	 */
 	__kvm_adjust_pc(vcpu);
 
-	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	if (loaded)
+		kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	vcpu_clear_flag(vcpu, IN_NESTED_EXCEPTION);
 
 	preempt_enable();
-- 
2.53.0

