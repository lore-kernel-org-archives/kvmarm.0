Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793628890;
	b=ZPPzVDE8q1aU/SAYmURB+XtfA/IX0LKatOtH2PniSuEdPFHNrxCQw+aehoG5BdiBXKaV
	 JxQXbyGvMqllbsF4Vuf7/cINGvYb5Qcr7isR8ZrrWAz5eLLmjE8qch/I/nN1nW/fcRPEi
	 I+aq7P++dwxLNvkcoJ9rnHe0P8kuhrJvKKaIUtXDH7y6nYU74XVtF4VnIYVYoqrvqQao7
	 izPBAVvl+n12KL/arSDCOhEtfg4zG6pCkPVkKty5k2FZ3mw52xLRwFjNiJyoBUPUD0lBV
	 jzwCz0JR0CCWTDrJ3Qox+Gy673Nc5e+OsQxnBC/f0rFEkVGKWWTe2iuRlkdQjAfO3hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628890;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Tq1Dinw97u5EFy5drMhI1ClpCkMeAoB7KpvZ0g2Cdjg=;
	b=KHwXsDBJbwBfNTRHrLYKB0bvMz5FopjUqGQZ3sYt23BCFMoTe51pbwDCldp0REBSwAqX
	 A3j2kdNHzMqB2QBNCRHfM22utdmvGe+RfPH0Odtwu9tvEcyfEE+q5ib+VSlNcqLs6/y7u
	 dcO4+9o5gKqiGgLTrP8cdtGcnFe6fdIu6Vm5q6hH1oeaEKIaQObERAHV/MfibC4UZvnnc
	 lYWOyE2T6zap0S7BfVrLC7I+d6/3dRbMsXu7Qf+CrKg+WwIdGsdqK3PTAknm2fd9t42Gb
	 QIL7pppCYj1T+LqE/xJuD5rnCbMOs/zhW9P9hKr0F6B28RiyNThI/09CHx1g66GUUmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XAHr3wmZ;
	arc=none smtp.remote-ip=209.85.208.72
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E884160A260F
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 14:14:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E884160A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XAHr3wmZ
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b1d6c10725so3966705a12.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 06:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793628887; x=1794233687; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tq1Dinw97u5EFy5drMhI1ClpCkMeAoB7KpvZ0g2Cdjg=;
        b=XAHr3wmZwBY3AM+HIhhY1Z70jSdeEBn6uFWrZQQ6cd/aDf9ndSoq56k1LZ5JJ4dMZo
         iQBHMfpbtdMzrfQ17gyc3caygzmnxCX7aoB9wHGjh2oItl3pcjnZqOy/LPLVi+p3fLZP
         ErpNs9xrkDvLKBFI+MFImQlrY+56s1s6qzNOi2KO5O5t3WoN6Zyws4DeNnCuwbiqibmQ
         8JTme+10tupVElHm4p/3SVHPR7RRY292sHueLIwx0KqGX0rKganYYGlyYKLBlmarC9L3
         xilsFM974UYexSbHyESVGCUZi3cu+GvsZgB7j37RtAxq/3WtZYp+2+J5DLSDW2DCuYG+
         teSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793628887; x=1794233687;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tq1Dinw97u5EFy5drMhI1ClpCkMeAoB7KpvZ0g2Cdjg=;
        b=T+oaNqGdW78f660RKkdjsYJ4PsKmGDeVtrDQpC0jn8TTeA03hYsXHpt0ZhcoMh3Ty4
         DyZvbV/YC5QGWt8j9utMhhqO2vddHuVctmEabaVxdTQPrxspQBh0GVlGWhqwSL/IoAPy
         yDpfmCMprgY79DpgYBKpnrblXNvR/ULy3BGz6sZ+gesqc4Nv8qbH2fESuXB6L62FlcCm
         fescWoTWvxC6VLVgASDUIpBAwO8Oie9BvqbDwTs84sXAZNf3QTgfeeiyzExEjE4Q0ahZ
         5oFAJkDUhX288VW2OkYJ7rHvBgmEc07jMNICfSMR392AWEiRsi1vgamRCJou1hzQQhK4
         TRYQ==
X-Forwarded-Encrypted: i=1; AKwUvBwwyjkdh62mUEeIYJzmZaLaBx80EmdZqKx0QnZEuZ71iaGCA2V+U2QDie0coU5Q3qXj/oKEZgA=@lists.linux.dev
X-Gm-Message-State: APuU4Z+GLdl2U/RsSWUs8MUZLNUB4SSoSUsB/deqz1gfPYHkzwWM3mNF
	LSouRFH3Lj7K/mSJDEdDmorScT8vG7r6S/z77r3KnmBoqa3Tmypd5+wBa6jUD5zOq45J+LDx670
	sE5YL3BfEA4RqIuSfgU0zafhkDg==
X-Received: from edgd16-n1.prod.google.com ([2002:a05:6402:a510:10b0:6b1:b88a:bd11])
 (user=snehalreddy job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5683:b0:6ae:550e:59e2 with SMTP id 4fb4d7f45d1cf-6b4d5ee26a2mr5205769a12.35.1793628887174;
 Mon, 02 Nov 2026 06:14:47 -0800 (PST)
Date: Mon,  2 Nov 2026 14:14:43 +0000
In-Reply-To: <20261102141444.1830221-1-snehalreddy@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102141444.1830221-1-snehalreddy@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102141444.1830221-2-snehalreddy@google.com>
Subject: [PATCH v3 1/2] firmware: arm_ffa: Add FFA_MEM_RECLAIM2 function ID
From: Snehal Koukuntla <snehalreddy@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Sudeep Holla <sudeep.holla@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Snehal Koukuntla <snehalreddy@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

FF-A v1.3 BET0 (DEN0140 rev K) introduces the optional FFA_MEM_RECLAIM2
(0xC4000091) ABI, which enables an Owner to reclaim exclusive access to
a subset of pages of a memory region without requiring the Relayer to
maintain intermediate transaction state.

Add the FFA_MEM_RECLAIM2 function ID definition to arm_ffa.h.

Link: https://support.arm.com/documentation/den0140/k
Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
---
Changes in v3:
- Drop RFC tag and update specification reference to FF-A v1.3 BET0
  (DEN0140 rev K)

Changes in v2:
- Rename FFA_FN64_MEM_RECLAIM2 to FFA_MEM_RECLAIM2, following the
  existing convention for 64-bit-only ABIs (sashiko)

 include/linux/arm_ffa.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index e71d83ee0aef..85c2e490a387 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -78,6 +78,7 @@
 #define FFA_EL3_INTR_HANDLE		FFA_SMC_32(0x8C)
 #define FFA_MSG_SEND_DIRECT_REQ2	FFA_SMC_64(0x8D)
 #define FFA_MSG_SEND_DIRECT_RESP2	FFA_SMC_64(0x8E)
+#define FFA_MEM_RECLAIM2		FFA_SMC_64(0x91)
 
 /*
  * For some calls it is necessary to use SMC64 to pass or return 64-bit values.
-- 
2.56.0.317.g454f8302e1-goog

