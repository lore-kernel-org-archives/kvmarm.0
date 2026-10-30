Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.107
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793357509;
	b=wATbWVF+0Tv1R+R3kZ1UY8v1DVMKyLc9KfqgcJVpCbnl32JDjk1xTwlel9IjrT/eBo/p
	 fVzEePoN6TfI71K1EHRw534ZHB1qdh2inbgsEdUcBhkonc2qNOXVrpfQlm2eYRexHqUV0
	 JZw4JVWGzZtT0rDZM86qH5vfO/pACEi0A4yWqarEWVC3xCI9m9gTxMt261TIJr89DmzsS
	 UBRrR0O5J3X0YaEjiAoyJnu+hsI4y3aCjOIMLuf0QlGlP5lqRgEmYQ+S+HPDAGR2UkK5M
	 /8rZNeqswXE6k872yedDY8NinOEF2jMrt5YdHmV5xTXtVKUlAR9Tf7LVyOr/IEC6EPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793357509;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=A0dv3I3LgauzsxhnnoQrRe1KXsYEPPAsnmbINkJOsD0=;
	b=txQrwcZDuhTWddVvtFvd+qIR3tHEHY2hmZ1CSZ0yAoI+fdNhZFV+NBmEgTgGKjL2We3Z
	 UJLKf39grJxdkraiNOHNT7gfzjD6zYXNVuXc+2jIT4qwzoKJRqpjX55hUvhfg2pY15/m5
	 angAN9ZtAG4qvSMp4nRhr7If6nKImPBu0tjNbZY4camEBX2URk1kFnnTDeDj4tOMO6J2l
	 kDFYhmSEKPSN70P0ViYl+gQ2n5fmYtiFJ4FWtkw4fPXmkvgM4+IvtTTeSRjDs7h1gB3Ji
	 kCFYF82YpIBhJE2S4J6Wxb+7fCJzu3e2vXfr9WtVxJQ28ftdVbeW0n2zw/UI0khxCUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WaW7JSgj;
	arc=none smtp.remote-ip=95.215.58.107
Received: from mta1.migadu.com (out-107.mta1.migadu.com [95.215.58.107])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7345606A32F
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 10:51:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7345606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WaW7JSgj
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1TcNP8eN2SDjaN1bgFoh1AhCvsMUSR+eK5knTA7zNYY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793357500; v=1; x=1793962300;
 b=WaW7JSgjXWApB6refU7TiKFy0lROwj3+RfWnq20yuV2N98nGHhAB6ziOqqeP9BpIOPXQqMUU
 ElrZJIq8g/+aCsrrc+TY/96zGGojdAqmTHiSFfwRDYjDQQiAj7CdxoGBrpz5sG21DjkMhqry/QS
 3gDeuAleuuo4FQQ+2Ewf+St0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7a928a9d3355d0ef;
	Fri, 30 Oct 2026 10:51:40 +0000
X-Mizu-Trace-ID: 7a928a9d3355d0ef
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH] KVM: arm64: nv: Size nested stage-2 MMUs by the NV PARange cap
Date: Fri, 30 Oct 2026 10:51:39 +0000
Message-ID: <20261030105139.3543230-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

init_nested_s2_mmu()'s comment says nested stage-2 MMUs use the PARange
exposed to the guest, but it sizes them with kvm_get_pa_bits(), which
returns the host's IPA limit rather than the 48 bits limit_nv_id_reg()
caps an NV guest at.

On a 52-bit host, every TLBI ALLE1IS from the guest hypervisor then has
KVM unmap each valid nested stage-2 across a range 16 times the one the
guest can use. Under QEMU, the KVM init of an E2H0 guest hypervisor
doesn't complete within 20 minutes.

Make kvm_get_pa_bits() return the 48-bit cap for an NV VM. That also
bounds the nested walker's limits, the emulated TLBI ranges and AT's
address size checks.

Fixes: 4f128f8e1aaac ("KVM: arm64: nv: Support multiple nested Stage-2 mmu structures")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
The 48 is written here and in limit_nv_id_reg(). I couldn't derive it
from the VM's ID_AA64MMFR0_EL1, since the nested MMUs are created in
kvm_setup_vcpu(), before kvm_reset_vcpu() initialises the VM's ID
registers. Userspace can also lower PARange afterwards.

 arch/arm64/kvm/reset.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 10eb7249aa9e8..1918837757682 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -220,6 +220,10 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 u32 kvm_get_pa_bits(struct kvm *kvm)
 {
+	/* An NV guest's PARange is capped by limit_nv_id_reg() */
+	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features))
+		return min(kvm_ipa_limit, 48U);
+
 	/* Fixed limit until we can configure ID_AA64MMFR0.PARange */
 	return kvm_ipa_limit;
 }
-- 
2.47.3

