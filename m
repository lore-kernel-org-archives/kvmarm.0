Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795476409;
	b=4PyonlvxoSKmZ2ZI48n/jSLzp1qS+SrI1nHzrvINdtUXPVGMb/efNN/+Cz7grc2YKcXr
	 T9MhqoPlz69hgDhx6vJp24o1mlIt/vyioEQ9aMahxSuD52VPzwQJtVurBQq0ED+iTSq0G
	 kw7G5RUnfQhq619qIo4iaDZ6CTLLLS+aQLEaFAm3jooQqHCyYFiih1BkGo69s2WOfWKo3
	 zWR8H6+oYYArKc7sUgTiFaec6lLuWyfk+jTg3NPBMSxaVa1Ke3AO80T9OjoNMnlMxwCm1
	 udmiY2THAjXIk8HWt/S/PQUIYhDLsZUdiu8x0XYF3X02Uqj4TjWd0dcaB8HEp996jaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795476409;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=HseEX6n05FD1veyeX/WRfonp9sQvS52+uztmoZnoKtw=;
	b=WKoaaMbwkiXTjO+WK3zRUcNPdoR9Hz05acqyyKtF/hdTru7+eMKU4i+m1KSb4Yeo+6XD
	 E8OaXtSrVgzQKmyGYDVkD9TynOMOFmQa/2MylCKDgdmDoKz82bU9AT/uKmwrNwN+g1fSA
	 mQwpz2V5ABJ0bXn6+URfMqpYYRYx2Afi9EStUATxGEuQfabAxIZyNdN4uM69hZQFCqV3Q
	 5luED0XZ8UkicesE4uLU02qr1cORbDgH6YCs/mI7UMigqEIoX71UR+rMMGhQ6oYxOni25
	 8MfraSkyqrVkFvQVjNVD4GTjknmwyVuqzbiLjh1gZr27wliect0iWHzjh3V7jjAhtxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="e92/guai";
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE67606A321
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 23:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FE67606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=e92/guai
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b597558c4cso4648734b6e.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 15:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795476408; x=1796081208; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HseEX6n05FD1veyeX/WRfonp9sQvS52+uztmoZnoKtw=;
        b=e92/guaisVjvs/pfCRf9LW/aSNw/HxTW87P9kr7sDJS1fpAzVCspcihYPOd4ItCEJC
         NxwbfMcwYKrtTlXshokCldqNLNho+ALqyAakkZJzbBMFGfdhmA0xjeEl5ybD+Z3kqWUs
         T/rPoS6hwyY5BDgQm2KlYCebtjaOG5Ng/za0CwkeUGsPSgjEHRrHyMkCN4uYSIKcuMBC
         qYpGWL8fhGX4bngA/adgwZKaqwm3HIBcCT5znF4a/752hcSRtCgWpw4JHG247ccyWG0J
         jBYdXl9skP1fKGU7g+lOLiJ5iv6JlypfSznpMoIjkU2QINrD7IB7BFF99oKQ63BgowDo
         sxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795476408; x=1796081208;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HseEX6n05FD1veyeX/WRfonp9sQvS52+uztmoZnoKtw=;
        b=UiFhdbbGSldBlgiDKUw6NzpfQzf7BWJm8eC4W8TQ5CxYKU2ToW2VbUxVqGIgmlyXrQ
         jjmsykPx8G4i8BJ1b5GCuyq+zEemkPjqzLZhRlh9vjlIL3j+7hpsui6wkiuS4ArVtzbN
         7uEss6g2YCTC5Ks9eqB9+K624BJOW3S4HHfLqGggU7a+cjzO3PIY4byo+q7ahlUxKnfk
         Zz3nnQO7fF/mWIcX8OGxmbwpa64BYORX9Cv+wQKSyQja96BZlSXa8Px1Cdxi0zkVriI6
         kFrnAzB9Z6ofCN+gO2RoYL+Ng5gOo5NkYs+poRCo0ttkDi+q5PavDnxb6TLNORuNDgdy
         chgQ==
X-Forwarded-Encrypted: i=1; AL+hErElJ57zOs/Y+fmfBc53nczRlOFbn/NyWHtjkPsoJC7nqWX9gmh2qKZIYAA8ZqkcU3g4Ie1O9EU=@lists.linux.dev
X-Gm-Message-State: APuU4Z9MKrwpsXPwuCwHmk76k0ZAV9PpIngArhaWmPgmFhdmCGr7Ujxg
	1h1eE0jhpVJAqjXrF2Mn7RZ5IE2RTFG7NSQgivI2bbf2vPz1v/7t4AhYqVXr8ftjNvfYqrWTyDV
	eGwmAHVc7IiOqXBEGPEbEsf6COA==
X-Received: from ilbej20-n1.prod.google.com ([2002:a05:6e02:4e14:10b0:53c:d564:3a52])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:c123:b0:4f5:e12:b47c with SMTP id 5614622812f47-57a0be9dc7amr11961032b6e.48.1795476408097;
 Mon, 23 Nov 2026 15:26:48 -0800 (PST)
Date: Mon, 23 Nov 2026 23:26:45 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261123232647.3733149-1-coltonlewis@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: nv: Fix stale and duplicate guest S2
 tracking entries
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Dan Carpenter <dan@pereq.eu>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When an L1 guest issues TLBI IPAS2E1 with a TTL hint smaller than the
actual mapping, KVM clears the entire block from the shadow stage-2
page table while leaving the stale tracking entry in guest_s2_mappings.
Patch 1 drops undersized TTL hints in compute_tlb_inval_range() and
falls through to the unhinted path so the unmap and tracking removal
cover the same range. This follows Marc's suggestion [2] on Dan
Carpenter's sub-page TTL patch [1] (which Patch 1 overlaps with and
subsumes), fixing WARN_ON(size & ~PAGE_MASK) on 16kB/64kB hosts as well.

Patch 2 avoids inserting identical duplicate entries in
kvm_record_guest_s2_mapping().

Tool-generated content:
- Initial bug discovery: automated LLM-assisted audit of the arm64
  nested stage-2 tracking code.
- Patch and text drafting: interactive Gemini session (patches, commit
  messages, and cover letter).

Changes since v1:
- Drop the kvm_remove_guest_s2_mappings() change; discard undersized TTL
  hints in compute_tlb_inval_range() and fall through to the unhinted
  path (Marc Zyngier).
- Split duplicate suppression in kvm_record_guest_s2_mapping() into a
  separate patch, call kfree() under guard(spinlock), and drop the Fixes
  tag (Wei-Lin Chang).
- Rewrite the commit messages and cover letter.

Link to v1: https://lore.kernel.org/r/20261119185105.626343-1-coltonlewis@google.com
[1] https://lore.kernel.org/r/20261123-inval_range-v1-1-815e15797089@pereq.eu
[2] https://lore.kernel.org/r/86h5h7zn5a.wl-maz@kernel.org

Colton Lewis (2):
  KVM: arm64: nv: Discard undersized TTL hints in
    compute_tlb_inval_range()
  KVM: arm64: nv: Avoid duplicate guest stage-2 mapping entries

 arch/arm64/kvm/nested.c | 105 ++++++++++++++++++++++++++++++++--------
 1 file changed, 84 insertions(+), 21 deletions(-)


base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
2.56.1.839.g22a8290db9-goog

