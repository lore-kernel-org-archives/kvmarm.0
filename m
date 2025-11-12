Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2A32C0296
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 09:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939261; cv=none; b=DIzDWD1EIx2OJZq/AaC3YR6jbfUb7UO1e7sqMmW9nbl1Ybr7SZH8R2oqysFe7adiZglASn537v+zeRKMsLqaSl1mDU2mDca4HsltzCLjHXU+gShRpu/BBe2UgOWppA2c/fNb5NAt/zZoH3fCN2xKZd14feywnZp4r7kA4xie0dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939261; c=relaxed/simple;
	bh=xbfitl4GommyE/l6/hRTNOmW8qDDpshL5lNa/2GOPtI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DQpLFzPhKt9SBsOdD2pED1FIIqcqjcxvTFDVd4nv1dqEc6+k1fIVq3UmkK70Q6zwE4NYvxP6gpE9HgHKlaOptmivytjm9OiORwC60b8GVcuGMU6VuAD/jHEHYmJ1jeer1awWEDvtjH6vkkkui7t264KKoTwNmk6V7ihKmpX7jJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V3YDG6bi; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V3YDG6bi"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b4961ec4eso304682f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 01:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762939258; x=1763544058; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3UiihDcnKW0VJqAaYu8pQvusxgYgxZn4k0ZJXyIYZzM=;
        b=V3YDG6bihJccO6LrnK/xvWE1OxnwYus6vYrS4YTYuWqiPOHC7Y8BFcQ7XLoGnuPj7v
         FE4TEfCVAb0O2JMi/r8mr2XpC4FsqocjgoF4jVrSrKwW6h637kBlfJeZbqbIU3G6r54/
         cwhR0m8+JZli/oh/10ivZk+pj69ayJaFJUe5ORc70fReFcrcbs21FyGJLYbxamPNzZ2W
         9lQtNw9KJRAOGHCnd5wmArPR+GLth/Fe7JNwQOgzNVWKyFYiRWxWy9i/iIaVuritTZjy
         HSo255lQyf8iw1dR+B66805YfIJGwLz9wPYFAEKU/UskGlYi7arUQqyvtCTWCdZ3sv9v
         qrqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762939258; x=1763544058;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3UiihDcnKW0VJqAaYu8pQvusxgYgxZn4k0ZJXyIYZzM=;
        b=leXLUL82XKguW7hNJiThELuH4QV9p2NLxL4/TFFW5p2e2ja0fjpz64mk9zR9LYHgYM
         DHqbtTEsU8eCYdxU9JZgbw0EFUC4p1LBZiU21AmK6NNEmM7oqS5rjguBfOKwSjnS1p6c
         RXgcp6lysHewq4JDdPR57yJWnmW6LTTeNO3aYqPpUG7wDjwdt7k/Z8ESGuw6Gcc4MWRl
         8G1AKV8E50LqVEKfLqC8MPO5t/Mtc6+e6yJVhMS1rYMH2614ZOVpLOuBjgGKtAkS3DEO
         PBbyKuJec4w3PWtW6/uKbEd6TNIqKN60z2VAGkBDackNX+c/+IJqdVXEUumBlCG86pT7
         g+AA==
X-Gm-Message-State: AOJu0YzSblqJ2uHFoKiMbsOmSX+rpsUZ3mD+m79QD4ASbdCvwhUHiRke
	mjWvw0EgRXjQkdssJ3G0qMJOlefwN3/ythRxqG/ujflMRxW8l9x8Sjn2G8zm6c+V/P0WjMUPp5R
	MsT3O2Y6JkgEXcVZSjRHEev9PTKC0KssmqSYKE6n+jN/HJ3mJUJ+uA+7U2SKaRCYeyoGSohubaw
	RdkoDVbj3iMtOA7l9DcG7xQQsaB7P5cSA=
X-Google-Smtp-Source: AGHT+IG9Z9ldAGnK/5TxJtrTX2haYhAOVMVAPtuPkpmokyvUQiqI1TdWGyQz5OrOITlNTdMFtTr2FYZKcw==
X-Received: from wrvd4.prod.google.com ([2002:a5d:5384:0:b0:429:ec82:22dd])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d0b:0:b0:429:d350:8012
 with SMTP id ffacd0b85a97d-42b4bb909femr1517120f8f.8.1762939257515; Wed, 12
 Nov 2025 01:20:57 -0800 (PST)
Date: Wed, 12 Nov 2025 09:20:49 +0000
In-Reply-To: <20251112092051.1376245-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251112092051.1376245-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112092051.1376245-7-tabba@google.com>
Subject: [PATCH v4 6/8] KVM: arm64: Do not allow KVM_CAP_ARM_MTE for any guest
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Supporting MTE in pKVM introduces significant complexity to the
hypervisor at EL2, even for non-protected VMs, since it would require
EL2 to handle tag management.

For now, do not allow KVM_CAP_ARM_MTE for all VM types in protected
mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 7195be508d99..5b564576160d 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -44,6 +44,8 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		return true;
+	case KVM_CAP_ARM_MTE:
+		return false;
 	default:
 		return !kvm || !kvm_vm_is_protected(kvm);
 	}
-- 
2.51.2.1041.gc1ab5b90ca-goog

