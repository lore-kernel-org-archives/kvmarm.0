Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589799;
	b=nxtCIEdOB9b9GicN6PlpV7mpJtqAPebi8ExzRXRILXVuQK8h5s7CBVkAhP913+wI4Eqq
	 xBdqfggjyZ5Y5x/n7HmiSN4W0K0dnzIm2oStka777tR8wKqikyCXUNU8vRgiLADbuXZja
	 us3GLIbKqpVeKg0H/cQU8Pk+J+KqPk8sfxmK+WWYx7xNhr/NmoJSfp0OyQLDqy2+eXfNl
	 SxPXpoGOuLLmuDKRui/ArKcgqCR2ZD/X7zvzH+VrpcbmiElJY1KLlagidf2enwJJ8r/hw
	 wuL4ERFZcP5Za7Nwdmim9CDc3n0ZZbSy9gQJe0yBFo8HtylQP77/2aDa77SRkKCnyQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589799;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=4BneDH3BrmldgDuSfaRvWpkmdpUNgHqyqEERpyedMrs=;
	b=2WBa4rBEDdFdQRBQe6hB7e7oz0cBCC5lV6OuRn+2haWGT+OON6jPUnVud9swKr1XaZvm
	 0t2fZUA6r1RhEAsIvlTBZmeXnjYgMx+VMT843gzKTTJIMyxi+adXmZE41Oehy6Ed8CvM2
	 KuloOUzdyvwfh6mNbOz3JjgpXsmM5WoFMxqVO1XmzytfL6TOYCs3kVLjjZ7qmUYZhi6YT
	 j9M6Pe4Cd4YcaUQImUNAdMB0V10Sp9QwxthkSFDA2Zres3kkAKPkErQ4KBMp9EKF5wX8e
	 wQ6JcOB218f2budU4Xns2SpLvNeNOTZ/HSfmwPFd0QerGcWI6sUTbpPmll0eiQ8Xuaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=ThiTZ76U;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBEE606A682
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:56:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DBEE606A682
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=ThiTZ76U
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e46e449e8so3431040f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795589797; x=1796194597; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4BneDH3BrmldgDuSfaRvWpkmdpUNgHqyqEERpyedMrs=;
        b=ThiTZ76UoO+KPFw+lqq88oIcA1z5UDDryj3MQtYqsLQaOnUrs/m7axsp8aVZ3CQv9F
         OaPlyefAebL+InmqRTpl+8svTUoYreGR4IQYU5Kk8fLD9dy8pDu6tcqjGWKszVnIuNFj
         6SZ7rXoFA/E27vk2EBaqbIZT3/KbLBqLspmxJ4t9iryWD/a8LSuvhEwcb6zI14SgZgFH
         vJ357YOtEoIEWBl39dh4/wdGOQEfTCtzLDg1WFBnokFhBLyFBNEN39CUBQl5HB7C18JM
         ZzmeZ3iMsT9MJclE77N9YbNBhsaKZg+uGvUtq5kc8vBXpOFopjeC6AQ4RBdvRWE4frKJ
         jBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795589797; x=1796194597;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4BneDH3BrmldgDuSfaRvWpkmdpUNgHqyqEERpyedMrs=;
        b=iR2paHKBwL2cHccRqh56kjNNrEFGPxzbDVHOhegSnA6lPqK6tCndmG56S0ElSx9h0P
         mMmkdDjLYFwmia0gkTQKO5r+vz0tOzy73n0es0ZAoIIVC9bsGHPVJ1uQMxLonqocA42s
         VA/2AE70Yv0CPK2vHHdIwCsNA3FeUiEcaEQh84zdgAuD/0W3MHUfDuicWFGR2YFh+vbB
         Um115ueGove5vYABmMMxcDyvJA8R/OKCbRytno5AVlHxz9ZWXeUau2/xasd+eHqtAfGR
         AfuXiM0AbqjXTjPxgp0JyoQ3cvFKd9J2yK6d4Jy1ilLxR6qDtHTiBF03HeC3LoxRMfDv
         BubQ==
X-Forwarded-Encrypted: i=1; AL+hErHSy/MJXTLxSx6TPsXwBLoziB9dwXjnfPFXOAWswjCtqEhBSVycVlVNlzIktgJ7CxTN1bdy3MY=@lists.linux.dev
X-Gm-Message-State: APuU4Z+0GqpqwtPv1K1oi8l3wutjgCtOhrVL2+An1VV7cBnUfOMMeru4
	lLGd0F66YgVGJeW9bwdUCSUnXDJj1w66YxEuWZQo3h8G6TLerb2iN/I9uC7/ps9GmUw=
X-Gm-Gg: AZFdTZetk797KHqk1jKaY8GjPQ41hx+/nC/DPxWpiW5JEH6iQqgy8RiJsYfQxEiSXdm
	rAg9iueM41DnAXhTrq04aGGHOawjUQmfe2jVMCUN5kF4oa9rLl2Ke1PtET+109Sk2aVHkUGQ4MD
	okshYmnx3ITfc29eV44c0aj6NuN8kaZZTAqwkjQSEUPFjvYJwrU9Wy+9aMIgUy/jiuGGkv60HpD
	Bo9XLElweUO8MYwNvk3LM62Bt9kt/n7c5YzrmMMWRSA6y8XGt6b4gcq2CM8OsWycThL1AlRvTJg
	/0LMwqGNnQBt8YvDJnYJyXwh52wamz95DrYoYLlUXZ7X5d3xb4yOWnhc8bRxtVPOH98otKEzK92
	RFWPXX8YmVxr04YgZEMDABwmARcGpqzZ2m2NlK8cbF5TBvKj1wRBF3dMLoyFJe4MM8fdHP1Kyay
	Zs+PsILmQ0d8p1YhMsOr//114nEEjqlKORXc1US7ZYFo3nRwqN/dWBjlKQFljnKpp55qFLZWGAD
	/4hedELrDQDsGv6fTCi2Jx7t3uOQjkGbd/YkeBc7/YInKZkodW4543kuHpJBXG77NhO7eqqB3P7
	UR6dcAejjeubVuNaD6M=
X-Received: by 2002:adf:ee47:0:b0:4aa:5396:a792 with SMTP id ffacd0b85a97d-4abb514608bmr25076345f8f.23.1795589796866;
        Tue, 24 Nov 2026 22:56:36 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67fe75sm36981016f8f.24.2026.11.24.22.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 22:56:36 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Wed, 25 Nov 2026 09:56:16 +0300
Subject: [PATCH v2 1/8] KVM: arm64: Drop an incomplete MMIO access when
 resetting a vcpu
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
Message-Id: <20261125-double_exception-v2-1-224689d8a764@pereq.eu>
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
 stable@vger.kernel.org
X-Mailer: b4 0.16.0

When a vcpu exits to userspace for an MMIO access, the next KVM_RUN
completes it.  So for a read, the next run increments the PC counter
and copies data from userspace to the destination vcpu register.

A reset should cancel the MMIO read/write access.  Otherwise the next
run will copy memory from userspace to the vcpu and increment the PC
which skips the first instruction.

Clear vcpu->mmio_needed in kvm_reset_vcpu().

Fixes: 45e96ea6b369 ("KVM: ARM: Handle I/O aborts")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
v2: new patch
---
 arch/arm64/kvm/reset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 10eb7249aa9e..26081d273408 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -199,6 +199,7 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Reset core registers */
 	kvm_reset_vcpu_core(vcpu);
+	vcpu->mmio_needed = false;
 
 	/* Reset system registers */
 	kvm_reset_sys_regs(vcpu);

-- 
2.53.0

