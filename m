Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652438;
	b=XbiVvqwlji+Mu97xl+XO9CZrlTSxmaqFBvi9YVHO4+oPpJn9jADb142U/QhUlbz1m5z3
	 Ylp1fIz1YdxWiNZ1rLaFwnf34pIjPKXH22D0jmGp5ByZGfpkAqA353D6zFMkgMOeXUr+Y
	 gXo1zf9lpezRut1mUPr4em8//wkTCAy1Yl139hZgC1mGS229kcZ4PNSWi0gImTPFh/awT
	 MF/FJSNH/f/SywBh+rtefb02mRAFrDegOu6l59XxSopVal8MBJqPxRM0mKtJJyYXeKAOH
	 WSm+eNq+mR4HsQ7YGVC7AOHmo0Ux7cOCaUd/nqkM880OUTTxJDgUYQLzoFilHpsevNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652438;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=W8pU5bTLgvDP6PnnKl35Nqm4I8JchvKzNMP0M/KHP68=;
	b=YGQCaqJi0ZxrBhMxa7WSZQnBCiNscgqzzDCalbzKGMII+LT7SY30fhbmievMtLjDbqkC
	 kXwiMsb+STKDeRNTrTFb6AvELyGII0YUlL0GOyIHaFoWIX5IX5iw8pOvys55U5DuxiCDb
	 qYPJpWQH7Vyu2MZrCaUGEyhuKk/oe/S2j1H6QSwFy087Td0a4ePLMfcmoANdmFRNGm/lN
	 2i9qW/RLf67YRgXfRhsErln/gFaJOMEQBHm7fxnrkxrHQIeYjN/ytPIvGUsPBCfu5AR4F
	 bOGg2puB6a9eY6Wk7KEhWDbsOnxXHSsfp3ZSh0PvcMJwkGpI1Z7XDkUdTMpcgKwnQBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iTnrPlNh;
	arc=none smtp.remote-ip=209.85.221.70
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D8B606A32E
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16D8B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iTnrPlNh
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48e011829easo2350105f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652437; x=1794257237; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W8pU5bTLgvDP6PnnKl35Nqm4I8JchvKzNMP0M/KHP68=;
        b=iTnrPlNhWNo1zgxT+kYkgzEAgugB0nroOSBsh3eCkW8CKQ7liKI9LpvzJlhUnXaVc2
         7qx8+LZyk77bVE9k2JntdqigzKnHJ1IY/cGkM3Z6qoWbwISGYiCsvLDNLBlcT9f08D1i
         /UVvi76ESIdC2WmKL+hVpJOnIDa+2TGutksB1O0oERjpoPaqUxMV0dFPz6Cx9gl25fZX
         l2k6Q65Zi2CW4i0osaJtA18mHUx9zqx0IpkL3yQnSg1VAR5ZMTCZkTvfW5kT9cZe21jL
         DHhOj2bwFtNCv4mUOgESy+zabT9Yx3bQ4E9BlWmmBNqOK0UO3ysIAMSzFaMUvZoqS8ec
         6c8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652437; x=1794257237;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W8pU5bTLgvDP6PnnKl35Nqm4I8JchvKzNMP0M/KHP68=;
        b=21Hksz5/RQvzaSJ8xbo4OLqSMyEEhH057M9g8zXAB3uneTWt/RGRKWMSy1aeq6p0VS
         UlfDNZzxWu68RbM8PWvQ8B2mXeNh50QK+Aq0bDEQLRXMbAzUhry2f8OwwUmhmdPoZccI
         Cfn5X/F5r8BrGkkx5enF5U1b1pzHwz2g2MDhnvOQVUGt3zRQ3RCZ1kxO5djTg+0f83PE
         HbowAtUXm/8c4JAaFzfQm8mSsUlMzHShX4oaUuGthiRMvZ2xCVx/EqeMUsohnLr2SRay
         XC81djvKfGRV24htzrbO8CBuU2sH37JMQGMDeNl8iZuCO3ft7cGoG+F6XvSLkDcJ+OPR
         ZJnQ==
X-Forwarded-Encrypted: i=1; AKwUvByHbKrtwdVt5Gwp1h0mdRDqeQh7RSGgooL4L07F15dvbaTNjzmomYSOZKdIN/npOnDj/xFnCYc=@lists.linux.dev
X-Gm-Message-State: APuU4Z/93ej2D4u8Et4feKhnz2IubSktNqc25jh3JbpRB5eB4U7be28n
	2m1qDNcdbjBeIQr2PHc5zYkcwchJDk+DekyG9XJjFZlAsf2tlN28wD9Ih8sh0yoqDr6SOUJozmH
	LV4cFBmOnTE/DOu/K1mkW5Q==
X-Received: from wrwh9.prod.google.com ([2002:a5d:4fc9:0:b0:48d:eacb:c491])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4810:b0:487:106f:ee31 with SMTP id ffacd0b85a97d-48e6e304036mr28089625f8f.27.1793652436386;
 Mon, 02 Nov 2026 12:47:16 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:19 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-15-vdonnefort@google.com>
Subject: [PATCH v3 14/23] KVM: arm64: Handle huge mappings in __pkvm_vcpu_in_poison_fault()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs,
allow __pkvm_vcpu_in_poison_fault() to work with PMD_SIZE mappings.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 68ed886e294e..b9b591533b30 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -994,7 +994,7 @@ int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (ret)
 		goto unlock;
 
-	if (level != KVM_PGTABLE_LAST_LEVEL) {
+	if (level < KVM_PGTABLE_LAST_LEVEL - 1) {
 		ret = -EINVAL;
 		goto unlock;
 	}
-- 
2.56.0.385.gac671c819a-goog

