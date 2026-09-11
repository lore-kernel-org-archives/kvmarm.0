Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2E846C82A
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134680; cv=none; b=IqiZs4PlEugG7WLrn/6rKIvVMirOLaXdYA86x06cCrwF9HjVNQraT1cfGsKLxlM2wwRRBGTDyVMYf1BMb7tZ9AuDJBq3YV18K+VoYhYtXCQSgPE3XFuRe3qb2i11EqSdTuo3fI/ZBPHRx9Gd74JPSTXMgo/KdXtYhf0IyS68fQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134680; c=relaxed/simple;
	bh=OBC7LHmVge4pln74KLH/o5W267C+dHnlYuJs0a/Fxs0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H9HVGaD+N7iTl7zPLSRxh4J9XMwko+mb+dQ/bT6y/KdVwESd0s9YKsaprop2hkfi4INUEXGApus/YJI9+qtKYw1CjqXur+DWG3CPMt4erPFV9VWwU8R2XaE8Ek6fud3bimgF/56jDtKOPzFiHfixhnwofKZsCWYmQneOogmX+E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZgOnlKHT; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZgOnlKHT"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a9a19c8bdbso1402091a12.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134677; x=1789739477; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U/SDRiEvlFPURLOqU9cvaEHLIGWmWIs1As/F4u7O1+A=;
        b=ZgOnlKHTU5Rly8z4eZyRZwlKZEzspTp+vvv2jEGtMl7DrdaMpCcpzibmAb/AV4Odr0
         uttOQnlKz2+psACwnpzehhqs/5LED9E7exkE+a1lJDd4og1vQ9hgkk5K6v+1/6T89wtp
         owFS0k5ErrusmAYxNphnGttgCSzsXhRjb1QzkZ/oWopTpAhdWBLgkm+HZN0sPGfgmXuB
         cnJg1wXep1YwssuJuxaFF0yBTCffQcLMei3LEVQXxZCH2p2pcTx6Keyvc+pTWJ12xh74
         3p+LzKgEy9Zh43fUdGGGUHF76N8aMZWqCIThfmlitVPQINOlKFtiGGPTVs0I0lP2+bIf
         tvag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134677; x=1789739477;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U/SDRiEvlFPURLOqU9cvaEHLIGWmWIs1As/F4u7O1+A=;
        b=C0lKLLzaZsK9YTEmw4TplQ3TRtMxAcYX5wIqyVmbcENszIT4agC5WAXCdo1waDXVfb
         pckVUn4dLE2urNVEy3mE7IQGM4xm1IZXVQNSufWHbK36DMscc2EN3/BO0fWB2RcsZvtw
         E9shjbGOjGZO24AroFv1GT4OJQzO6HidV3d/AlNMBDKLMH/b1n/MJQ6RdbdAc8mHpOvR
         OkfucI102DktrdDiwyYaI6Pb0QRVNrvx4jtEG2py4Mzd+LSAJ1LZVdlWbHGBdCajEj4a
         i1CLpWD9TmayiAVhbUFuNxkeOBmpiAsa2NilJ8UrLlU+s5K2O816y9VBJ/H8oO+jvmf/
         Ldcw==
X-Forwarded-Encrypted: i=1; AKwUvByZ3Ylg1t6Tn/v96eSdt3HBf2WYWzwqpOMSSIxRctyy54oepWofFNU3puzSemLco+vk5A26jig=@lists.linux.dev
X-Gm-Message-State: AFuF++l1t7nv6ONCxRUXq+O8Id53nu6ONROV2fOFqI3vr489KE0KUqLP
	AMMnx1/GnrPX2aFQlB+8vo25Dfjs1gbJUDozgFDHhaNduflfFUedickbnS0gb/ZNcru8DbFiSv3
	Vjx+066Rv2dA5g9MEMR9Mig==
X-Received: from edgd18-n2.prod.google.com ([2002:a05:6402:a512:20b0:6a3:ebb1:61f4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5346:20b0:6a9:8df4:13d3 with SMTP id 4fb4d7f45d1cf-6a9a3277ee7mr3752121a12.21.1789134677106;
 Fri, 11 Sep 2026 06:51:17 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:44 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-14-vdonnefort@google.com>
Subject: [PATCH v2 13/22] KVM: arm64: Handle huge mappings in __pkvm_vcpu_in_poison_fault()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs,
allow __pkvm_vcpu_in_poison_fault() to work with PMD_SIZE mappings.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 674159736495..cfcdf187cbc3 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -971,7 +971,7 @@ int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (ret)
 		goto unlock;
 
-	if (level != KVM_PGTABLE_LAST_LEVEL) {
+	if (level < KVM_PGTABLE_LAST_LEVEL - 1) {
 		ret = -EINVAL;
 		goto unlock;
 	}
-- 
2.55.0.1007.g17ff1f9808-goog

