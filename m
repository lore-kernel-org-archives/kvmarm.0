Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9954723FA0E
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026785; cv=none; b=SzQftfnZTgCuScLQql36nH9S37V2vJ7BILOTXJOqSw14U7p07epZUuj9QWU52zRrWBL75ODXq0mW/ZH6bVVbr5AXvEYMDV+uGGe6+7oak4fasBBQID5WHziu5BxCIo+HXylL6nGu112shJ6mwXVNcfU34rZSP9t4MsLZ8WDavNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026785; c=relaxed/simple;
	bh=KBex4nSvV8st4JIwyXj9uqMSukyDo5x+//eUZ7ElLyI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=owe55tSoQ2qqyqx2Paqc3B8JdOgd/dp6f+z+gNWgMCZ9N6jwzw+6XAHq1EYj2KzMz8FIqP4f7uWxkPAajOrKRaISR03Qa/mw2XRgXOw/Y881flkoe0Jj3FFs8D9TPck9TnXkLo3vTSkVUe5nJJDWpMJSkL3IwTmlPSmPIka0o4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PzZ5w8qy; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PzZ5w8qy"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa67855b3deso78674566b.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026782; x=1734631582; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oA4flaYxQ5BGtfLZd9pc3kG1NLnmtH/l93s5ei2WXOY=;
        b=PzZ5w8qyXZ1G/0WMWUdyzG+RqMf6mcAafZi952fp+uBjkV/CEKdxcMyJY/fn/ptscI
         FSPiPD+/W+K4mwJ2bzw5VECIA9rirxAN/b2JsCKvoW+NkR39YvJ+Ak6m+NTy0hnLjTgm
         RoMIBqygaoRkGZGofeWPLRCtpSxHg03pN8ca2BrIOOn+bQN69bUELw9LyN4L9SH4ONDj
         zzvZpPIDhj+aGjT3s7ZcITP7YK9G9Rxw7Ei3zsYhYtLAxBmzJ3J5dNRVa+PSCkViDKgc
         y94RQcs+Z/nK9+KEs7R6N0XlE+Q/72NRgXtW0URpO3QEYlyXgFHD0MWyVnqlgDaZn2Ar
         PRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026782; x=1734631582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oA4flaYxQ5BGtfLZd9pc3kG1NLnmtH/l93s5ei2WXOY=;
        b=ARZTGTzxYcnRBN24tYdx94Oo2KtSuYPI0QJp0cvvWxM74G5mFYQz8ELM0z7ceKRYyB
         RjMDpVLQKscBKX9YYXI5QoNkCLnoli50aNjUbuA+zVfdn75kUQQ0cA1HChy/3GMukaDN
         JEQokDTa1iRddq5LmCb4d8GOFXiaHfJFK09vIl8wyClmgskH/DuFHIWzikBJdw41zfUS
         U5DtOy+Gt9toIoT1E2D7nQEuC7o4sSdQ6eqwdDB+XXKPwauW0ecZCd2hfhcM2CK5sLrJ
         jEcZh/g2gj/3TaxH5wKFwictDwc9Ztg3waRZDA47YwckBOpi8+4dfsGfS6CgwolxC8h3
         fSlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjrxIcn9sVYjgDJuOtNs6VFWPHxzSQHits27UG4QqMWih2lD45BTvYsuVq4OgDimOlYv9nQg0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPV81bJwjKtld8rAI2ZDQ2D8UgW8Gx3GMt5HUSLPT1Q6ywIIOM
	JPIM0LW6vR4OFWhgLdopnrR18BwgV2wzPA+ICeKFeBOSFiFox5kqJjibUMJcMO/A4hKjNUKaD/M
	QEC+L/HYI5A==
X-Google-Smtp-Source: AGHT+IH16CwAGQZdlZ+j17KujE/o9PMEBvOMuLsm290SY8dsLy1Bla7B610srDL7eN2tped3VnaOKpJ7Tllo2w==
X-Received: from ejxj19.prod.google.com ([2002:a17:906:8313:b0:aa6:a222:16c7])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:15c3:b0:aa6:8a1b:8b84 with SMTP id a640c23a62f3a-aa6c1d26981mr510164566b.57.1734026782147;
 Thu, 12 Dec 2024 10:06:22 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:11 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-48-smostafa@google.com>
Subject: [RFC PATCH v2 47/58] KVM: arm64: Add macro for SMCCC call with all returns
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a macro that returns SMCCC returns from a hypercall.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 59a23828bd0e..3cdc99ebdd0d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1248,7 +1248,18 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 #define vcpu_has_run_once(vcpu)	!!rcu_access_pointer((vcpu)->pid)
 
 #ifndef __KVM_NVHE_HYPERVISOR__
-#define kvm_call_hyp_nvhe(f, ...)						\
+#define kvm_call_hyp_nvhe_smccc(f, ...)					\
+	({								\
+		struct arm_smccc_res res;				\
+									\
+		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f),		\
+				  ##__VA_ARGS__, &res);			\
+		WARN_ON(res.a0 != SMCCC_RET_SUCCESS);			\
+									\
+		res;							\
+	})
+
+#define kvm_call_hyp_nvhe(f, ...)					\
 	({								\
 		struct arm_smccc_res res;				\
 									\
-- 
2.47.0.338.g60cca15819-goog

