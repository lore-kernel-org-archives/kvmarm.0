Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A872337AA80
	for <kvmarm@lists.linux.dev>; Mon,  2 Feb 2026 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770045794; cv=none; b=aQ0xmhmc+5iiaIzaSXgO6Y4TvZe4VLEN1aa0hV3O3SvIcV9hBwfCpWoyisykvx8Ov3l7JI5EdJeUaEy/HcGduDBF0jEd4kErzZby3AmyaEJWwmXALtCSS6SWfwXltGc46u73OAO6F/ZB1inLqDTuvC/gJXfEiJtL2CrBbPVStrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770045794; c=relaxed/simple;
	bh=Ab3Qd2Bs1lzOiZYwU5lsA+uRRbsMAuV7jYxkaEW0QUc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LK1LNclbFeA0Hr5lO+Uy07Rzq/qA3gAAnn79ZHEDYEkv3TyIHf926j66qWn5uVcauidPLG8oz9Q/ta90W/+1CqhZvHiHnfCpjzXwJTPs7loBunngB4REnrrNBE5A3y5rLMgNWEShV+b20eNX24gkAZkvw7ROYLYvBsPK8woG/PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZKKHqsCt; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZKKHqsCt"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-480686b3b4cso38985655e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Feb 2026 07:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770045791; x=1770650591; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DpiJoHpkSUIEeyEcInw4W8Eny3OZ/gdfqU/Eqv54B88=;
        b=ZKKHqsCtgxkHd0MyLZ+du3NUnfKaeVZS25gBrrA86hPvPYKnJwlU79jk9kRJn8W9ER
         LKiCOZtJUMxM+yxA0k0TEjiaTPDCbwgsgrjlCNgs4IYv/2V1iKe2pCaSke8/M4fuwdnM
         z0affbICXoW6loD7tO+tEvgkz+LLKv8KHDUOQpPG2fSv6aMI11qk+15siwafitmrgrWe
         4mk9WEQXDjKRwR+H3/hPhQbjmaaWpYhv4Ee/ic1+UzeK3+LkCXwCKRFMJqrdgwj3/2i6
         s1mlK2mqDvEXWJ8hRiqSnn9Bvm24vlY96W/9oRRGsAg0TicoCU6St8Z/XicF8bHMq/7w
         RbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770045791; x=1770650591;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DpiJoHpkSUIEeyEcInw4W8Eny3OZ/gdfqU/Eqv54B88=;
        b=hgb2Vw+7U3ZZuDX4P5169ehtRnkmfWmlL58dQhF7MWyinW8ERmB4V1SbYMJ+2xoB6I
         7sLbrr7eYjsOujFHYQeYD42l8+F/2sYIHFfpgtf14XDZnnCCa2VX4zycShhPlFtldP1f
         uq2pvBroqDBzRYnW/pmlCJhcsedmsYUmDG7b1wlkDJS8x2DEd70u/G3Pzb51CCJbuJzx
         oDgxv40qvBDhnaK4SDQORnK1ltMVDBi0+QED8g8vHB9fYfaB3i/vuP8PpVvbir/YSVp4
         xPxMk3+GvzMiOn2ktj5qJdtTTYcoESyMhMfcZwtL/6nx2GNYmVv6OzlRQTBwB9Z0wXdD
         /O6g==
X-Forwarded-Encrypted: i=1; AJvYcCUJ7hz8IxbsZXbIx3v9LKd3P3cfaU3D3NFHAf6ldECHQ2P8fZTknHiOpr3co/V4BLxK6gxYG6M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoGyCDuOBI8KRuAYCpZIkKEw3oC/bngjAPmyt8/7w1LoAKE2EH
	7DmJ5szHMxkxEmRGc+aw2zikU7pfuKn1LdHecqwmc/V/jthiemCVuZ0h0sozRP4IfkGHsRImXty
	WVg==
X-Received: from wmop16.prod.google.com ([2002:a05:600c:4690:b0:480:4be7:3f3a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f8a:b0:477:76c2:49c9
 with SMTP id 5b1f17b1804b1-482db4568dbmr166795515e9.2.1770045790988; Mon, 02
 Feb 2026 07:23:10 -0800 (PST)
Date: Mon,  2 Feb 2026 15:22:53 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202152310.113467-1-tabba@google.com>
Subject: [PATCH v1] KVM: arm64: nv: Avoid NV stage-2 code when NV is not supported
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The NV stage-2 manipulation functions kvm_nested_s2_unmap(),
kvm_nested_s2_wp(), and others, are being called for any stage-2
manipulation regardless of whether nested virtualization is supported or
enabled for the VM.

For protected KVM (pKVM), `struct kvm_pgtable` uses the
`pkvm_mappings` member of the union. This member aliases `ia_bits`,
which is used by the non-protected NV code paths. Attempting to
read `pgt->ia_bits` in these functions results in treating
protected mapping pointers or state values as bit-shift amounts.
This triggers a UBSAN shift-out-of-bounds error:

    UBSAN: shift-out-of-bounds in arch/arm64/kvm/nested.c:1127:34
    shift exponent 174565952 is too large for 64-bit type 'unsigned long'
    Call trace:
     __ubsan_handle_shift_out_of_bounds+0x28c/0x2c0
     kvm_nested_s2_unmap+0x228/0x248
     kvm_arch_flush_shadow_memslot+0x98/0xc0
     kvm_set_memslot+0x248/0xce0

Since pKVM and NV are mutually exclusive, prevent entry into these
NV handling functions if the VM has not allocated any nested MMUs
(i.e., `kvm->arch.nested_mmus_size` is 0).

Fixes: 7270cc9157f47 ("KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
Based on Linux 6.19-rc8
---
 arch/arm64/kvm/nested.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index cdeeb8f09e72..d03e9b71bf6c 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1101,6 +1101,9 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	if (!kvm->arch.nested_mmus_size)
+		return;
+
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
@@ -1117,6 +1120,9 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	if (!kvm->arch.nested_mmus_size)
+		return;
+
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
@@ -1133,6 +1139,9 @@ void kvm_nested_s2_flush(struct kvm *kvm)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	if (!kvm->arch.nested_mmus_size)
+		return;
+
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
@@ -1145,6 +1154,9 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	int i;
 
+	if (!kvm->arch.nested_mmus_size)
+		return;
+
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 

base-commit: 18f7fcd5e69a04df57b563360b88be72471d6b62
-- 
2.53.0.rc1.225.gd81095ad13-goog

