Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795801966;
	b=AYjX01ShLtswkrHiDKLwbhqwW6Le6zjM/BbDIhHMqjvHteumj51Y8lxptqnPzB/kQles
	 OEYETKgesgaQRgVa1KqKkoaxtX89QD/uhbZjX+3o31higqkBbbsj4odv6QGBIyKrcC09p
	 ZwdRXUHaOwLBWl6kdRmRHKLAB7F4WzT0G3WevgYPDCXh7+YrwD1cDOhefBZjgi6Ss/KXC
	 CUyZ6/DtkdgBJXM6uoVydyPWlKOY1jw6rPQsnZ3PJJeWGN98/UfIjU00AWVGcrs6/v1Zh
	 HAzwERlPbZsh1qKgiK/es26CIFF4lcWlPaig6bXWmQzBuXuuavb0nCu3PV9ERdVZc/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795801966;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=HrpoliOMKq3aKEsYDXSMctB2Gs1JdFSq0O+s/fh27WY=;
	b=FRXyoSGMrwlK1tpLOq8CK86iR7i0skncUEMl8LheA4ixcttsxJlfqJNeS0Cbi39o0zgg
	 D11qgKHYxzUh2NuTI4YFWJga06bDuZ45O8Czp/P4PC7O9nR8IjsccbPHUhT8OffKSCgK2
	 I6Ld4EoF39low8rPp27WZ5olRp2OPGTcDb30eUr7rwz7kYLUy9VYUJ9ZN7nBzCN3XOFyK
	 JOtBh/GqhJ7ODf9QKSamFFRjlZvirzvr/rxw2J9MLgJtkxo+DeGyrLnLgX08757MBto4H
	 ZPqqQOXwTc4Fypv3UIeEx/lv/LF9jbWvxatfDsFVQRenNh4qfIT+RPINngIuCkUgSGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=G09ZMXNc;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1737D606A31E
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:52:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1737D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=G09ZMXNc
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb77a462c6so67432685e9.1
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 09:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795801964; x=1796406764; darn=lists.linux.dev;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HrpoliOMKq3aKEsYDXSMctB2Gs1JdFSq0O+s/fh27WY=;
        b=G09ZMXNcfzuLdvM9Bwm/7zB4J+8hsw/HZaAUxwb4gK1ncQajRw46fvikY/N+LSfiS5
         w93z5V+XhSED1Ws7h2lwyq/VDipQI7uR/7WU3dJvATNId52+gsaMiIpfHFavXrLGmzt8
         2OygqMgQdOtFid9iRATf9MLMoZiBqCjAQ/NF7CYQg+wLx/Y2xgcssEu7FncTYIjBLpNZ
         3eh7A0wUQplf1Uw5JNaFhuu89tNeWwsFxpesVPPxRlVNJr3o9mQAwYAwhFrxlEACBpMj
         JS3H/8ynfLOkq1JKnDrypRjocR6f5BJM0UduFX+Cp7sDY81BjnlKDZG11kjJfLGnCzaD
         Hn9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795801964; x=1796406764;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=HrpoliOMKq3aKEsYDXSMctB2Gs1JdFSq0O+s/fh27WY=;
        b=Oy9aIVo87GdEtuFvw8gjVpKEnGv2LDX5+K2KNHuz5VhtVm4UdwqtfOCBzrM6S4T4sD
         t2libNuT6OS6IUDeDNK4oaxbAQR7gl95TPMIjFW2idRi+wOXPf+6BydOg5LcT5tSPYvQ
         813bFUykObZFzpKQgBw8EYOtrBQ0b7LpCfj6fNZWOwvT8htNDBs5ajWp8BDbTWz2znx4
         QUEtZooqpNGal303AY6HxcrepT0FQjPCaJsTTIBQWTJnCk/I1jBy6OrIzq0TSEedaZBP
         bIl/W6cluPU+LSbFsMuwP6yOjPZ4Vb8HiyQLfdFvck+8vWCKkb0NQ5Nyxv8SZqJn4LLa
         PiBQ==
X-Forwarded-Encrypted: i=1; AL+hErH27nJO4ktkTmUtbTCKaPm7WYP2AnENMF6hWzMdpmylPcP5Au0H/5c9mOgqyFAnz+Lq5ITyuAw=@lists.linux.dev
X-Gm-Message-State: APuU4Z9V0f5o1tLG2N2KVYD3tbC1CQFLQL0Bs9010D6MQxnxnGaS4hNU
	9ClhYFMwUMaa91gagu/ZvS1WZBVefljKKYPljTI+4xolMQN9fJoNMQNiPXLnF+JyHO0=
X-Gm-Gg: AZFdTZfwSvhyWGjw3zMcGXieQBb1AKYVIDIZSVsFCqAYH/kjKXApBeabTEF+uGBeqUv
	NhKZcxr0cX+bgY993Jykg7ZlWEw8fmBuhB1xM3FiTEphaAhMjS0/uHhA+mpVfs3UFIRjfRZLxnC
	L4Ekwln6DXtVSv7sc36QolNCDy8RECCCFHM3QP+9v8L2OoJnsKRGULUuM75vUh/teLqVVD+X7uZ
	HoC8W404JOHUSYld6BdC5RAEy7sism3XYzxORlSQvO1ygRzcz3aS3dETqzCb/Rkq5MVRX3xyfmN
	fSLzsTwj6NacWSKl+VP1j15psW6a1/kLcAKOwucbk2HCaUqvtm1W3is0rtOUMai4RMZGmAryUyE
	CXON2ugKm/BNXrXdHFwWuJhXxLQXSJZWBCggyQhsJ4jlDEGsWg0FzAtoJnNp1c31gh7GwZvWRoi
	x0D6IgIlt8wpBnqxHKXvSH/M/uKbCbcA+hQ++xp14+rsy8rFdNxyTMm4K/3s3LhELAgtFY3Wbvp
	CMlWqbJNdwQdScGqV4hIw7ovUThJnZ+o6XFvYC630YgmtR33zNcbXhOTqKehZXgMwicZqCWni/8
	ffBUs6D+xA830OspXXVH/P8yPjPgxx4BYj7CRmVS
X-Received: by 2002:a05:600c:17d1:b0:49e:795e:ba89 with SMTP id 5b1f17b1804b1-4bb861398d2mr396602295e9.6.1795801964219;
        Fri, 27 Nov 2026 09:52:44 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6c4353d6sm46675405f8f.56.2026.11.27.09.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 09:52:43 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Fri, 27 Nov 2026 20:52:37 +0300
Subject: [PATCH] KVM: arm64: Drop a pending MMIO access when injecting an
 unmasked SError
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
Message-Id: <20261127-serror-drop-mmio-v2-v1-1-96bd01bef6d8@pereq.eu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22MQQ7CMAwEv1L5jCWSQwt8BXFIYpcaqUllQ4VU9
 e8kcOU4q9nZwFiFDS7dBsqrmJRcwR06SFPId0ahyuCPvnfOD1h9LYqkZcF5loKrR6KBKJ7OyfU
 j1OeiPMr7W73efmyv+OD0bKlmxGCMUUNOU5v+RZsC+/4BM0yFlKIAAAA=
X-Change-ID: 20261127-serror-drop-mmio-v2-dd7ddb89c16f
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>
X-Mailer: b4 0.16.0

Oliver's commit bfb7a30b1986 ("KVM: arm64: Don't retire MMIO instruction
w/ pending (emulated) SError") established the rule that when userspace
injects an SError that we drop the MMIO.  An MMIO access dropped this way
runs again when the guest returns from the SError.

However, since commit 3bd107ed6b23 ("KVM: arm64: Only emulate an SError's
entry for vCPUs with NV"), a vcpu without EL2 pends the SError through
HCR_EL2.VSE instead.  The next KVM_RUN completes the access, and then
the guest takes the SError.  So the behavior is not consistent depending
on whether the vcpu has EL2 (MMIO dropped) or not (MMIO completes).

To make things consistent, drop the pending MMIO access in the non-EL2
case as well.

This change only affects unmasked SErrors, if they are masked the MMIO
always completes.  The host's copy of a protected vcpu's PSTATE always
has SErrors masked, so for protected vcpus the MMIO always completes.

I discovered this inconsistency while writing a selftest and I don't
believe real life users have noticed it.

Fixes: 3bd107ed6b23 ("KVM: arm64: Only emulate an SError's entry for vCPUs with NV")
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
v2: Fuad pointed out a bug in v1.  I was checking serror_is_masked()
    but I should have been checking PSR_A_BIT instead.  The
    serror_is_masked() function returns false if effective_sctlr2_nmea()
    is set so we would have dropped the access but left the SError
    pending.

    Checking PSTATE.A also means we can drop the !vcpu_is_protected()
    condition.
---
 arch/arm64/kvm/inject_fault.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 1d5dfd4b9e00..cdb4fcc71d94 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -396,6 +396,13 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 		return 1;
 	}
 
+	/*
+	 * Like the emulated entry above, an unmasked SError cancels the MMIO
+	 * access the vcpu exited on.
+	 */
+	if (!(*vcpu_cpsr(vcpu) & PSR_A_BIT))
+		vcpu->mmio_needed = false;
+
 	vcpu_set_vsesr(vcpu, esr & ESR_ELx_ISS_MASK);
 	*vcpu_hcr(vcpu) |= HCR_EL2_VSE;
 	return 1;

---
base-commit: 4a1b7259e337e8a2ea999436b47151a75c7572dc
change-id: 20261127-serror-drop-mmio-v2-dd7ddb89c16f

Best regards,
--  
Dan Carpenter <dan@pereq.eu>

