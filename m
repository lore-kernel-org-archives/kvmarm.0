Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA303FCB10
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 11:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789903051; cv=none; b=TjP9XOdcO6osEFtHNW3NU3hd0hoNtPuXU48R09uzoS0eGrOHfmykx3mWK7QyG9VXZadzXzLMG8PD83QrM7AC34aKHpKQJWlCWZ5GR8xvf0PwzLOsSdmOY0E4tq4xMG/sHZK4m/bUmiu6mKDh3HnUNCOem5ZlqeAyTOFXa7I1kxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789903051; c=relaxed/simple;
	bh=4Obo9XjIF0UkNH8AWri0rSIBncxG4P+FKPM/rfdlUYk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b6xfVO49tq9Fs6rIwv6FiJHUDQdAe6xZTXM9o+HlSn7uvI/rwKKd4S5fBqVpSvIwFp2zg2TrEVlPGEeLlv8sT+HAlzYpaOd1nXqUiARXFs26g8IUK+a0p8HXpBkM1dPgp6HGcLRhn7jxCKzSa5kyMgmA8hndN4o3CrKNpdHbvZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=Rbb9uuT2; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="Rbb9uuT2"
Received: from [192.168.10.153] (p865013-ipoe.ipoe.ocn.ne.jp [153.242.222.12])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68KBG36O088236
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 20 Sep 2026 20:16:08 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=zmfuG+7dS3FcYFGM455cq0LUuDyDjiU3XUc0eMviZCU=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789902968; v=1;
        b=Rbb9uuT2coqtm36v3HFjEpsHy109ixacCKT60ybmEKoONtVBGERz59oyiX3u5XxY
         Nma9hoGUvVDmoja+DjQvk+sNqNSWLKoqcM2ArLaMGNYoDoc4jip/vbGUPDlrGmqz
         DFD1RakXFcgskRGnehj8HJvj57cpwxvUSDBLZSVRn25zNiYvG2jvIKjZLpSrzna9
         pDdTR2WK10H7spQslASJEmH9/eCQ/ELMSV/BaGILp16EhoKQdSnYXYrWpjdl5Y1U
         Xa9yR1Z5RHKG7AAYXo3MOBQUJuWfzgeXG41fS9KqPDO8C56J8dDDf0E/6vn5eZtk
         R7cL0QnNJIUIC9M4sKia0Q==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Sun, 20 Sep 2026 20:15:42 +0900
Subject: [PATCH v11 01/21] KVM: arm64: Serialize repeated vCPU
 initialization
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-hybrid-v11-1-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Andrew Jones <andrew.jones@oss.qualcomm.com>,
        Fuad Tabba <fuad.tabba@linux.dev>, Mark Rutland <mark.rutland@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2195;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=4Obo9XjIF0UkNH8AWri0rSIBncxG4P+FKPM/rfdlUYk=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9b6A8n8r0rTYp6ra6+1enjkVaabcdZRtfpWJt1LKbX1P
 3y+TyjtKGVhEONikBVTZEkp2s2tEV37qTAhvgVmDisTyBAGLk4BmEiqJSPDAtm29tsRrGpuc2Z1
 m3xMeaQqangs43/ld/kfNkl6s7ctY2S45Xx9ftg7N+2qCilDYdPfc6xXT17CG9W00dfK8tELW2s
 +AA==
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

The initial KVM_ARM_VCPU_INIT path holds config_lock while resetting the
vCPU, but repeated initialization of an existing vCPU does not. As a
result, reset_mdcr() can race with VM-wide PMU configuration and
overwrite MDCR_EL2 with a stale counter count.

Take config_lock around the repeated-init checks and reset. The vCPU
ioctl already holds vcpu->mutex, matching the established lock ordering.

Fixes: c8823e51b534 ("KVM: arm64: Fix MDCR_EL2.HPMN reset value")
Closes: https://sashiko.dev/#/patchset/20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp?part=1
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/arm.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b0de4ea7dc39..997f24f5fb91 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1691,29 +1691,26 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 {
 	unsigned long features = init->features[0];
 	struct kvm *kvm = vcpu->kvm;
-	int ret = -EINVAL;
+	int ret;
 
-	mutex_lock(&kvm->arch.config_lock);
+	lockdep_assert_held(&kvm->arch.config_lock);
 
 	if (test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags) &&
 	    kvm_vcpu_init_changed(vcpu, init))
-		goto out_unlock;
+		return -EINVAL;
 
 	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 
 	ret = kvm_setup_vcpu(vcpu);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	/* Now we know what it is, we can reset it. */
 	kvm_reset_vcpu(vcpu);
 
 	set_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags);
 	vcpu_set_flag(vcpu, VCPU_INITIALIZED);
-	ret = 0;
-out_unlock:
-	mutex_unlock(&kvm->arch.config_lock);
-	return ret;
+	return 0;
 }
 
 static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
@@ -1729,6 +1726,8 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	if (ret)
 		return ret;
 
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
+
 	if (!kvm_vcpu_initialized(vcpu))
 		return __kvm_vcpu_set_target(vcpu, init);
 

-- 
2.55.0

