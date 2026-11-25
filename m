Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589811;
	b=xLdInm4a45c2byLQdFJd/gJpMitTYmSnKvCW27TM/NSEhZaWQO8XYMzIqs4RjWufvgfe
	 XMSnoE/Nt9Hx85tdhTTVlqtMn2PsLNIZrUJBmtUa3z5/zkCqtU/3fh2nW67d8HYrVLTWC
	 j/KolmluaokRd5ustPHQNF7gsO7tDp1GzeLRTWTXo+5OdwEr3+Y/kMYcFSgE1F/yHhQdc
	 hYmtohGpRKooq8Lf+of4lBhsV1S6WlOa2Iv285F3OOR250DNwk6/HUFeIwIkXXd1lft5x
	 6zUd/eskl2mwAX8ZIx/Z8EGwQ2lgvWoSV6ksT7o+t1UotceVLIwXiczS4tXNxFxpsYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589811;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=RGa577wX/xgJLkYslmrPB3AiasjRjUBJpObETRH3ZKA=;
	b=FrynFIh5dMgh030RrU1lWGgoi+pbJeQZ8j0qNu+QdN+kZ+O5b4miHe/z8+2xYk9Q4IDU
	 C31KkXmJvN04JrFzE/wAP78nBj2A+gVs5WDACARCHqZNqS3KJETNHLNw3/i++Ynzv3wwr
	 ANJSZX/WYJdzZzua0l5jX/T68id1XvGDUY9FlxpNL596zva20ktnEWSvS1JCTM9ptIrdV
	 iz6fSPDKI99SD5O8gKK2nKH+OZ3OBQe4jVxxJzI85Ug+So4L7q3stScDcxVwObCnrNCDc
	 nJPcY1nrAH4s+nxpPpsUOjSomUOCsCCdfsvQE7Pcet94GnrQcdYYMhyjDo8bWsU/sfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=KBtBWaiJ;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42BC606A6B9
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:56:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E42BC606A6B9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=KBtBWaiJ
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so41148435e9.2
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795589809; x=1796194609; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RGa577wX/xgJLkYslmrPB3AiasjRjUBJpObETRH3ZKA=;
        b=KBtBWaiJEH2MCWNcgIEqYZnSEtjikvUTvJxKjzFJznh5KezaJpFFbTm6U4c2m8Khwc
         rfo3Ld2E5HuJeZN+PsvgZqJuQXTYDeWXyyZw6g3LwvhchJqyg+B3TrCecGvjm3GroTnC
         VMiRh6txn1V69Na3ulok5kotJ2DsnTAKm2WF9nq47GV94QVKxVJsyRfPmANqLZSjhTc6
         bP2wPi6cqREJnOJEryv6QtETlJZ+qGWAXDjKqJ/bsvong3cH8yxsna+8lWesTRlK/ala
         uHuv6MuqxNJ8pXG791Wjmb/X89vckEByjp+0eEvw2loz3UA+qPo6zSDBaiCnzQXX3ABz
         CAGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795589809; x=1796194609;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RGa577wX/xgJLkYslmrPB3AiasjRjUBJpObETRH3ZKA=;
        b=qnH24ixl0dT+ns/y0LkTQHosq48zWFMKU9CxtvKxqMTGQ+cthDPInjXLd4lgjGs7SP
         cy6uU30qhrt2AYBIneVakW/d3QX/TgvEfdYaVHI5AY3ZL4tNCZOyc+DLTERqGZIA5/X0
         I9tBHUTYuM2JdnYiRS0LHfxZ8Aiz3Zuu+2NFjwfapJ6QGAjS3+kRgmf0ZcFaYLwAABM/
         ZpS7EYIFUentgxlMsMYhrYzopbHZQiKSZKVHPRY8S8xac7+UqHNNJOlEfEg4zKGe10lf
         mi54XvuctZ2TEQK7WxDIXrj5abZIMFvhK06hDjacbKc2nEmX4SyZu2MUmUjoR8CTqUaK
         PUlQ==
X-Forwarded-Encrypted: i=1; AL+hErGmZHwJBm8vLP/BNgN0UBI3Vsu4RliG9cw6mu2qfRVbJ9j1CB7fsBQZ9elg6E3Gm1azHTEl1ZY=@lists.linux.dev
X-Gm-Message-State: APuU4Z+BA3bOZJpy5ED5+tVGwEaft3Trv1DrM/nqZcYiOFrwgh6mDagK
	xeUyIHpKvdGD4D7DNExlGAG8V3cMBUROPuNboB/LA7adjntgdx+4jDzqXThZ5Hc+Wm0=
X-Gm-Gg: AZFdTZcmR7S6UHcMbils9XWoKhwCz+EP5Ft1frGrvmk11m654iyrn1KARsL5R8f/RYF
	wpQ8k5rfFANKmic90cIim/9QZtkHDimIkpoEEcbj/ZyoeWQlCkcg4s+RmVLvB3q8jnj9bC2jNTJ
	8m+KNX00HfJbwrYJ6vH1PSayNIrdd614lImE3uS6qukfXYEZ2Lp2MJsyFSa9oWlXEc5b+gx+r92
	VYmARY+NgwLcgg//sq+QdUhaaQoQNsh3+acFkkzseKryeTrvyoq/XKoVAXqW0L+BXxDvG5wd/bo
	LRn9sQPaHZjRFWnc6jKbEjw1Y8WsQKbGYJh/YI1mh3UY6agfA7ziPqSsYtmzaIbcFFJEvkQEPIF
	i6wRlcdqji0D4TEHrg/YbsuW21Ljzh6yi6WUa54+F6h8RLSMZguEqxegN167PdwS8622iw5sgc5
	eCl2qlXjPQ7kezR1a4gNmTQ5KmNQF95cVNpD+x9GaadNx03lmnyMCrTfrGQHm1t61QKQoV4mt6G
	kIhfzB05Ldf16Un3dfx1aLeL+M8LTi78uxiQSW5yb2P4WL3UO9wkzAv8R3ksCf3MHMYgQ5TJc04
	Pr9VBHbH1NzdR4UwT9g=
X-Received: by 2002:a05:600c:8b11:b0:4a1:dda8:eb73 with SMTP id 5b1f17b1804b1-4bb8881c630mr352660555e9.27.1795589809163;
        Tue, 24 Nov 2026 22:56:49 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a1e8bsm414574595e9.9.2026.11.24.22.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 22:56:48 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Wed, 25 Nov 2026 09:56:20 +0300
Subject: [PATCH v2 5/8] KVM: arm64: nv: Replace a pending SError when
 injecting a new one
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
Message-Id: <20261125-double_exception-v2-5-224689d8a764@pereq.eu>
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

The kvm_inject_serror_esr() function injects SErrors as the name
implies.  The bug is that it doesn't handle already pending errors
correctly in nested virtualization.

In vanilla KVM the kvm_inject_serror_esr() function always sets
the SError to pending.  However with nested KVM, it might set it
to pending or it might deliver the SError directly.  We can only
have one pending error at a time.  Imagine we enter the function
with an SError pending already.  In the current code if we decide
to pend the new error that's fine, everything works.  However if
we decide to deliver it directly then the pend flags should be
cleared but they are not.  So we deliver the SError directly and
then the SError that was pending on the next exit or entry.

Clear the pend flags unconditionally at the start of the function.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-229065@kernel.org/
Fixes: ce66109cec86 ("KVM: arm64: nv: Take "masked" aborts to EL2 when HCRX_EL2.TMEA is set")
Fixes: 77ee70a07357 ("KVM: arm64: nv: Honor SError exception routing / masking")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
v2: New patch
---
 arch/arm64/kvm/inject_fault.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index aa2011cc0d5a..0f6a89b65074 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -361,6 +361,10 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 {
 	lockdep_assert_held(&vcpu->mutex);
 
+	/* A new SError replaces any that is already pending. */
+	vcpu_clear_flag(vcpu, NESTED_SERROR_PENDING);
+	*vcpu_hcr(vcpu) &= ~HCR_EL2_VSE;
+
 	if (is_nested_ctxt(vcpu) && kvm_serror_target_is_el2(vcpu))
 		return kvm_inject_nested_serror(vcpu, esr);
 

-- 
2.53.0

