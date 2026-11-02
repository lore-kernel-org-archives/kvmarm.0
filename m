Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.68
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793606336;
	b=R5eFjgBTlij2TKVvsJFK9/Oz0Oto5dwmagvWGgsSUxK51GmmsoeIj8o3EVNn6MkA0o8q
	 eV73dOqnC/Hy8l9wI/uQ4mhxDc/MwIwMp1eqaydkZLpGax0shl38lRBTqYG8Ta5d6VLZW
	 aSlgwBm4LxFHsTNy5mQ3JzFQZ9hMFXbK3E7JeyRrlGP6Fs/JI22mjlWoWfVBjEWm+OyW4
	 vF32qjryfl3/gmOb/NY9ECNehxd7kiG6N5rAxMSplJasXQEFrxOCi+M+7yR0wthwieZen
	 EoB4R1W3BdxoIN+9Dqu2MXPwKNZBedBRdmo6Pxrtzy78cNCeSrW0LDNQKIGuAgdSeWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793606336;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=I7f0XyCAtF4SJfvjHPyOeR1juZYlK47QDPUr9ArN18s=;
	b=i2NE60Om53+HDlAYtQzMiG4j5ANxH25kxsyyQ7Yx8eQvqfQ0CtHglAuHUW8K1YZzuynL
	 +OnKnNVNqsgN7V0t2J8sb3hUenWkJp3jrM1eCW7XeSEDsRTLItpJMEuKuVUWloMLmzpq1
	 vTud9hj5Cj32wrBgEP3YbABSReXIpOJmbK7jIEcf/C9nzPKHaoL/NslCiy+fvWNhh+y5k
	 ZY1pZXjSKUMtysClh6LFtqjFf29OLYC6rp4OXPegUolusYWeVe5sOMvUAqjziFVYa9gJe
	 rGb7Q4Ept8JWfy0cAukDEuLX3qAw2Jb6GRll5xnufflRy3TrYDqk3YPkc5MVnp6ug/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=91.218.175.68
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CA1606A324
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 07:58:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93CA1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=0wwKFnAfKLxHm3MqsSLnib+x1Cbbb0RE6cyNuCZw7gg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793606328; v=1; x=1794211128;
 b=ogl8CBtQDjMx17gldrzG8y9aQpsv613GYEwNn1rJXC+6g/+opPkIIcn+HlXnAavrY1GAUOPR
 txvgIyi154ghhKYCU0qOvD37Z8I+Q68/aAi2YXxkuHE8YpTvtAEVvcChEiA6LpGxcNy4ifYtDgx
 6Gx1AIx4F8D+VlBhLhO16xlA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9c4dd2f3ef011e26;
	Mon, 02 Nov 2026 07:58:48 +0000
X-Mizu-Trace-ID: 9c4dd2f3ef011e26
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jack Thomson <jackabt@amazon.com>,
	Congkai Tan <congkai@amazon.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v4 1/2] KVM: arm64: Clear the VM's feature bitmap when kvm_setup_vcpu() fails
Date: Mon,  2 Nov 2026 07:58:42 +0000
Message-ID: <20261102075843.2556018-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102075843.2556018-1-fuad.tabba@linux.dev>
References: <20261102075843.2556018-1-fuad.tabba@linux.dev>
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

KVM_ARM_VCPU_INIT records the requested features in the VM-wide bitmap
before kvm_setup_vcpu() runs, and leaves them there when setup fails
(e.g., HAS_EL2_E2H0 on a host without FEAT_NV1). The PMU attributes
read that bitmap before the vCPU is initialized, so after such a
failure with PMU_V3 requested, KVM_SET_DEVICE_ATTR on the PMU group no
longer returns -ENODEV.

Until an INIT has succeeded, every INIT that gets past the feature
checks rewrites the bitmap. After that, kvm_vcpu_init_changed()
requires the requested features to match it, so the copy is a no-op.
Clear the bitmap on failure while KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED
is clear.

Fixes: 427733579744e ("KVM: arm64: Select default PMU in KVM_ARM_VCPU_INIT handler")
Suggested-by: Oliver Upton <oupton@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/arm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 157bf4b812020..3e91e01b032c4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1856,8 +1856,13 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 
 	ret = kvm_setup_vcpu(vcpu);
-	if (ret)
+	if (ret) {
+		/* Clear the bitmap if setup fails on the first vCPU to be initialized. */
+		if (!test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags))
+			bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
+
 		goto out_unlock;
+	}
 
 	/* Now we know what it is, we can reset it. */
 	kvm_reset_vcpu(vcpu);
-- 
2.47.3

