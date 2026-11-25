Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589801;
	b=RrrHotDnVGSeTAsaGAQFYSTDNiYdNc2USSORHUCFdPw0UCDFTrnUp4giZTVLeLgptQTa
	 OWuceYvnOahXGmbsmWk0SQxZrMeYL37EteEP9t+l0Oj0B89Npg46yiT7Ix0yC4cwUcFIr
	 fzVlYZQx3Rvh0k1xlmYN9wTM5LHFZEhix8ejtLIHoyky+bI7dqhKyagheI4IDdg/gyYlk
	 bo1ZPwG52epQEH4BdRNmWxhxlZg2DCdV92WtJ/TGLDTxTRVEgqKMQHjFu99P6C56ucEgE
	 XzheswyrD/xXbNLFhk9um2nkfcgkNT+2+u5VXpuu1RIzUzkKlZ0sXjrf1UYXK7HXm1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589801;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=CO0vZwWHnFlrPlO9I1IjS868FeGKeBrErc/5Mvm8QC0=;
	b=WY/8OfV6aWNlXLUm2+ai7MiKz7xzAfqOR87vT0/pTZvmWQQ26XCOxqigpF3b3CA951wv
	 G0ucUlo9u2V393sQSFHN6DiqwkpmyecY2LLGmZ6Q+xbEHOnbgJcxKgGxdG4kG7c7e9oB9
	 Nh2vynrizHn7nytOrPZXu3X9A2shnCmfQXrhyCEfl1Y410TCiSl/hzlzQXNRUbK5tD6jC
	 8VafS9mg6h39YJUudR7iBoWsD34vXqUSNpiojr+2GiYW5aOMhx1W6JK2edkyyW10RNGtY
	 4yEjYtaB8nU1R1I3R4xUmQORPSQcjnyp1yY0/mJauR5u0Y+04bN7NdRcL2WAN45KXCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=NZOBzwe9;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99906606A687
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:56:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99906606A687
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=NZOBzwe9
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-491f34b4e0fso2442698f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795589800; x=1796194600; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CO0vZwWHnFlrPlO9I1IjS868FeGKeBrErc/5Mvm8QC0=;
        b=NZOBzwe9Ylh+L2Nsgr+Vz1uPcK+um1l0rANOV59Br3lvuNJ6+30MkV3knfDzofW8Kl
         XpyE1SLuxCKWE8BytfD09mKhEbX184CW3u67/UckSsBUfeb8CbUu42+RpWgMol0nB5V+
         PVZ2Ycq8+w4e3HlV8Tpra7FmX7jw2ctia6FGoq6cpyKRUdKEUKYza65Cz2ELH1dCspdj
         DqB99PHeSaANpCfxaDflVnXsCsqimSTmhZiqh9cqAUzJKc4dbjFgnXFnWaed9PGi2Bml
         6IRbEYKdR4xE6FSTQYXbzzUie6kFuZwuzusm+QngccWXFXMoirdNQscguhQi9bTwydxY
         OtNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795589800; x=1796194600;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CO0vZwWHnFlrPlO9I1IjS868FeGKeBrErc/5Mvm8QC0=;
        b=Tlg4mra9IT/lGzPdlApycu/ODmUVIAQz+3eQdXDbWx2wcQz9oTc3Gjonq9/7vZ97eI
         hple++0sYyXT+AbT9C+KvExGf8EPBDm4Aqxtaa4obHDmrwwGpDgiDXJSqLzVZBsJIw4q
         KDb7LX7LHVlHa5+D/AfxPqDiKPOri6P9Z+T2yQ5YQuTFiiI1azw6ETHaSk/DX/pNSj3i
         s/O9QlqWkNoZqcZ0fVYZUcJfPbvHYtCBZUda8BsDmSQ2wsm1lIKj5XFCJJtVFeJT/tqO
         FCepqQQPxe4NqPMGfS7Y4u3gwyyJleIxxEN64sLqy+NnTM86sb/JYc0bndjCH2pUGhcl
         C+0g==
X-Forwarded-Encrypted: i=1; AL+hErGhXWAYS0Jj9BDebpykKJYI9WV6nZbHczovLLwluPHP8Nrj+YGNi82vSJ/ngwS0jSazAPPy0OI=@lists.linux.dev
X-Gm-Message-State: APuU4Z8K5jFY2YOhxeE1QqyLgfIPqxz1HnWiQeYMxY/fa88FDCLp/lSD
	wMrl2NexxsEfxx4E0HtwPEE54JmLKAaTJr59Iogk3NsP9a7XhYqgwQlUrzwBJUaKNVE=
X-Gm-Gg: AZFdTZcddTXf5AmtVbml8fU1D0JEaiAYeG6uS5fErdNuP9e6Wkq2JIXflcxxMIMC6cv
	M/s9v+35/cHt8jyoq/GB6tXwC7mVUHfYiqxpTH06HaY4cnxOK4Mnnj+mN7Q0iU97KyNdVpXf9AP
	x0s33LGO1xHBmw2PgO+Lwc0ioBf3NAlugZhkMCX7nZkDHEIALDJg9bmebMq6KWv0GYWV1gBYNg0
	lTlWVGP7VTkVpoYSNTocmH1knHpv9wTUUsUWPj+NaloZ44Tghs+OCRv8kHZSjKne4tdVHp4wNBB
	X1tJJF+DxVppY5JLc/443HhP5VYDcX8yRx9/iiwXU2s6s40soXFG+oHii0NeBNbEzAsXS0PuSQW
	+Gb/2vBG8C/4iLCxEvjYL5k155G+cg/RBuEQ+dwPncKj7HzMV41Bh8y9CHw6DXQYATO7tRyW1fJ
	jkZqwu5k2NXlQkfyb8lUbhQNKoJFrRMFQksY4pcAGeT6m8zJuiQlJk387QHWrwKy99d1g3fSsS/
	7NWGZnZ8DANF7jOPQxaz1jHjSsn7DszDuMhtxezDbj9k24AAYcVBC9M3yjt4kWspGfUDhmWAic9
	GkqW7g4dVQG9Mc6NAZI=
X-Received: by 2002:a05:6000:25ca:b0:4ac:7595:6f67 with SMTP id ffacd0b85a97d-4ac7595721cmr27351070f8f.40.1795589799898;
        Tue, 24 Nov 2026 22:56:39 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a680483sm32730554f8f.28.2026.11.24.22.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 22:56:39 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Wed, 25 Nov 2026 09:56:17 +0300
Subject: [PATCH v2 2/8] KVM: arm64: Reset SP_EL1, ELR_EL1 and SPSR_EL1 when
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
Message-Id: <20261125-double_exception-v2-2-224689d8a764@pereq.eu>
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

Resetting a vcpu keeps the old values of SP_EL1, ELR_EL1 and SPSR_EL1.
Commit e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
changed the reset to only clear the general purpose registers, SP, PC
and PSTATE, and later commits moved these three registers to the system
register array without a reset value.  Commit 85d703746154 ("KVM: arm64:
Fully zero the vcpu state on reset") fixed the FP registers and the
32-bit SPSRs the same commit missed, but not these three.

The impact is that the guest that boots next can read the previous
kernel's stack pointer and exception return address.  KVM_GET_ONE_REG
also returns the old values to userspace, and a rebooted VM doesn't
start in the same state as a new one.

Zero them in kvm_reset_vcpu().

Fixes: e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
 arch/arm64/kvm/reset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 26081d273408..9c1b42890c96 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -199,6 +199,9 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Reset core registers */
 	kvm_reset_vcpu_core(vcpu);
+	__vcpu_assign_sys_reg(vcpu, SP_EL1, 0);
+	__vcpu_assign_sys_reg(vcpu, ELR_EL1, 0);
+	__vcpu_assign_sys_reg(vcpu, SPSR_EL1, 0);
 	vcpu->mmio_needed = false;
 
 	/* Reset system registers */

-- 
2.53.0

