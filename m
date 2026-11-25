Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589814;
	b=mLfSBdzxrLpt+OYqHAAq30CnAJpJHk9NOJ3NxK+9giNyO4rdYmhEqfUqqZA18iHKUJQf
	 a7wBliCe2gBBnL5EOEXnA0psZiUuyDSnGaAUNfuhq92AhXi/raHgf/JOOmIOXOMn3DC7l
	 FvmIRoidGovn2Oshd/pZ3iFn1SCE0izkO4YFG3tYTcuHXIMk3iGTOnBgKmfDQdBBqbWzS
	 gPRgZU8YyaGDKf2sopWKtzAyPL8I7AkbpBYkCpwkCQfFgWNLMbny4j/sb1d7r7OJnzJFt
	 /ntYavN0LuZjefBnvEwVaeZ3Ih+ta+NSXm8oAIhIemcPMkeA2Vaww9WAQI3FenQQOsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589814;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=TsvjkV1z3SJCt8rGDNCxfVDi6AQK70itPPBCytlT4MM=;
	b=nnHulYmLdT8iGc1zjLGFfNcpm7LsGQmwVatwV1c+x/iRzojS7z6nQYAl5YP+hh6hPvXE
	 9iYKua+UwnG8G3JM/QcKYPaNHT+9hpvCwC+UA3ensdSiBg5KG36R5z8tKoTn22sv2fpDF
	 gjgyC900yiXOB6khI2lolQs6Fwo1/1LlP2sE9zID6QCJ1zTPZyNBr3Fm+cPIinSXhHuRw
	 RHpXmvXvINPMay9rxIPW8J9CAxDFuYlPKqniamwijm7YZz8Rqbu9zJA6ZuZ/9pzWb0aq2
	 KYJc/19MRcY0WF07ZwdyzVDcsiY904f4fgkKIBAkg5OkEtAs7rfJO956F1Rrw+8R13Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=Ull8ein6;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0204606A681
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:56:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0204606A681
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=Ull8ein6
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so3456436f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795589812; x=1796194612; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TsvjkV1z3SJCt8rGDNCxfVDi6AQK70itPPBCytlT4MM=;
        b=Ull8ein68iHOascH0HE+XyBPnqxcrky2qQD04u0y0NqTuvt67PxTiYwNBEgKSpzHrX
         i7EQRQboclfsCieBQsdMH9QCdqbsr5UMstVmjJT8+BrVl2B70XlRbS/hBAip8DcY2p4b
         TJNjMSCAfSPnwDeEUuAISoLemIryvAtIe0z18sGS36KslJx/1egLiIoFyvcPe3PR0+XH
         VTAGpE4z1l+8Lf/X0AxxkSUMrutDte94+8/pqOJoRroqiToE28vRNG2zIR0mnBEF1H74
         hLH8kKFQIBj1k8zGv9BGKbF+/BAoBMCwRVbfYf+fDvmk0mGZuW8Qgf+EUIj7YR2+4QzO
         WyXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795589812; x=1796194612;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TsvjkV1z3SJCt8rGDNCxfVDi6AQK70itPPBCytlT4MM=;
        b=QbQ8XA1VcvpZrZUiKptTmK9WEI+tjJwUJfBffzf020Uy1VeJ98KQTkvOGBsCTzo8Hv
         9WxrRzy79xLdIaoFGyI7igILBSIqU8OEbpR+4GFM6WUGRfModhPGdie24Hw7zyJkK+7T
         /ZdaZkB/d2P+f1DzqVf4p5pSRIN5X5+9y2/2TkpopYE4cY2BXobfhe5D9mnhyU+Te/kc
         gxgomnPFA+qnOCZAUB60PEsYPfwL2e58RtOv5Y403/RhFDbiUVEXFr3YGNgWW2fc0+/0
         YBfMBO7PA9dHhRvBAlWVazsHnD84F6ErCnz1dArK0ob9bPy5ruBhb/DzFF5eTLMUPCpY
         5cUg==
X-Forwarded-Encrypted: i=1; AL+hErE59OLr1pv2yyl90axtzljXx1GUTbYCoRUSw8QMf1AXP3azyPCsRpKjc4UyCEuZE64jLr8DvoA=@lists.linux.dev
X-Gm-Message-State: APuU4Z/yOX1nCpWJkV2TokC5os1YNMPlpMBCeE/jqRIlDm9LmSCi5seH
	d/f4YHoaR2fEGLVtj38X+VUWYzuPcjs7/asAOAk2Xva25QsVOUF/HRtVKbFkIH9IDR8=
X-Gm-Gg: AZFdTZfBfVSi6RrR8OudIA8x4p4BxWbbSAkCC1Ob2geCt5gtJRkEM1O58Uf+8dxpKpS
	ZqHcDk02t4aw3yPfe6IKgLmZm9NC+VMNfdUUHKB1eO9q6A0ljRLHbUWVEj3Emm2Sh257joKSHvF
	x66XZH8CsJlTQkUQtViDGi/+CHy931uiaakmFq4uels3cYjIy4S4Wz0qHubBE5s0J7hx0r77TRm
	iZH+dY0xF0PYmh+8JvpWBId4pUhsqhzpQsuTh04Z/ceLyEnzlheo9EXCvnlsqUDeQACpqwBrrMp
	IJxA8RK7MUSXeugbPottRbnfRLKRv0ErUsXZNXg/8HYNkzcGpdgDlDjYJoqZHnoBvQdFMFpy14N
	aSYyE7ktS+7KSBLTI+4uBQ+KhqKeXlsWAESW2GN2YABsHq8ZQLZxvzh/bzwPL9Y7AOICjBxOLJK
	dXY6/uLTnf5vKCp1KutxiCuMnAfopqLvn/3q+4BfEB6/Vbw5vG5uxSJ789b8A+rwadc1nSKNW5Y
	FqKCPLBJM+HMGJgTHkazSRpleP+Il01xfI/qbjGW5b5u3cB02LOX+Nu2+Idy2lSWcCgEkqP8pbh
	vzJxWeaJl/sDgFh1jU4=
X-Received: by 2002:a05:6000:461a:b0:491:1e3f:a427 with SMTP id ffacd0b85a97d-4abb4b84d2cmr32386732f8f.42.1795589812021;
        Tue, 24 Nov 2026 22:56:52 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d55sm32520868f8f.5.2026.11.24.22.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 22:56:51 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Wed, 25 Nov 2026 09:56:21 +0300
Subject: [PATCH v2 6/8] KVM: arm64: nv: Don't deliver a pending SError to
 the wrong guest
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-double_exception-v2-6-224689d8a764@pereq.eu>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
In-Reply-To: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Christoffer Dall <c.dall@virtualopensystems.com>, 
 Rusty Russell <rusty@rustcorp.com.au>, 
 Marcelo Tosatti <mtosatti@redhat.com>, Sebastian Ott <sebott@redhat.com>, 
 Eric Auger <eric.auger@redhat.com>, James Morse <james.morse@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0

With nested virtualization, when we inject an SError that the guest
has masked, we set the VSE bit in ->hcr_el2 and the CPU delivers it once
the guest unmasks SErrors.  The problem is that the bit stays set when
we switch between L1 and L2, so an SError meant for L2 can be delivered
to L1, and the other way around.

When we switch, clear the VSE bit and set NESTED_SERROR_PENDING instead.

This matches what kvm_nested_sync_hwstate() does after every guest exit.
Then kvm_nested_flush_hwstate() injects the SError again and decides
where it should go in the new context.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-229065@kernel.org/
Fixes: 77ee70a07357 ("KVM: arm64: nv: Honor SError exception routing / masking")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
v2: new patch
---
 arch/arm64/kvm/emulate-nested.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 39136a89d74b..cccaf02610e8 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2792,6 +2792,18 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 	return spsr;
 }
 
+/*
+ * HCR_EL2.VSE was set for the context we are leaving.  Store the SError
+ * instead, so that kvm_nested_flush_hwstate() routes it in the new context.
+ */
+static void kvm_nested_stash_serror(struct kvm_vcpu *vcpu)
+{
+	if (*vcpu_hcr(vcpu) & HCR_EL2_VSE) {
+		*vcpu_hcr(vcpu) &= ~HCR_EL2_VSE;
+		vcpu_set_flag(vcpu, NESTED_SERROR_PENDING);
+	}
+}
+
 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 {
 	u64 spsr, elr, esr;
@@ -2823,6 +2835,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	preempt_disable();
 	vcpu_set_flag(vcpu, IN_NESTED_ERET);
 	kvm_arch_vcpu_put(vcpu);
+	kvm_nested_stash_serror(vcpu);
 
 	if (!esr_iss_is_eretax(esr))
 		elr = __vcpu_sys_reg(vcpu, ELR_EL2);
@@ -2909,6 +2922,7 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	__kvm_adjust_pc(vcpu);
 
 	kvm_arch_vcpu_put(vcpu);
+	kvm_nested_stash_serror(vcpu);
 
 	kvm_inject_el2_exception(vcpu, esr_el2, type);
 

-- 
2.53.0

