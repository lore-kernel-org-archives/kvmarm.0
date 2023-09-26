Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E81638DD6
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 18:19:44 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d8943298013so5587447276.2
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 11:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695752383; x=1696357183; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YW0WUIw1E3cvbWwV232u/IH+Aixvc0zUf199VogM9Ws=;
        b=FPmgMNhyFmdZpCA1EK7Q2AlaIQ1Ci0iazOM9LsLfvxfk4ZxddlBq9awYZ+GdtrkVgz
         P8uaZhMlhZZ+MbXQTzDbCX5JjekEFxOXv+UX+CBX71LZgQyiY0vbaUgRLTPdYbVyicZJ
         Vc9pg80e++KNXgHp+cLf6PjaBwZgNoc20dQ8+UrugCpvd8JqSn8wxbGiLqUCl9TOM4rS
         7O9MrYlUG2a5gQUl4EbEw6M8Exe9CqQYvj9m0kg9e5UM1WHshiGO3id2n0ygw6071cGE
         OSlGe2oXj0KPbrTtadsk0E/2LpOT6d7y2qJYBjYVXYgb1xib2OrKGbqe2IazBf58krGq
         tdNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695752383; x=1696357183;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YW0WUIw1E3cvbWwV232u/IH+Aixvc0zUf199VogM9Ws=;
        b=AK+vd5ToL/x8tQCgzxWhwuo2V3oR7wd0dukeWBaanff9LPD+nKJct8ZwSGRa/v2Skc
         VdWn4wraK+G5NXk+kEmKY4U64WfiM0iMZqkVsiqqPLNMDyRrm3elCqF1hJy5MDZVc79n
         gNmbzYEcOc3Sd5KM2l3Kl+jcg1HaD+82FSlU8q571NNRqdIiPV8pFHyTx/wZQ4xV1QCL
         KZFJ7P9tXOBwxcqRYLGZ19hWCqGVJmGbS6vpUNIIkVp24/A42IP66b5HchzrHf4E1+Am
         xNmWPwLQzCGBzdM5dixRLLiLZ28LGwI+Yka9CG6SEG4isX5PcEXwG3c431ILTaafY1is
         iZwA==
X-Gm-Message-State: AOJu0Yxr+rLZpCbls5tCxNFQfnkMjOklbEGZXmCp3Pdqdoye6GOdsolK
	iLU7irlDNNaxnHkRVylLQ/pgtB2wVmlnmCub
X-Google-Smtp-Source: AGHT+IEqqNH7N1Eu2i1+4mhsYn51y/vBcs1ex7uhBxjOydv7OeJn056085iZEk4qCeKXW1RxODFO0USXQl8Jp4ws
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a25:b11f:0:b0:d78:245a:aac4 with SMTP
 id g31-20020a25b11f000000b00d78245aaac4mr103847ybj.1.1695752383116; Tue, 26
 Sep 2023 11:19:43 -0700 (PDT)
Date: Tue, 26 Sep 2023 19:19:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230926181932.1650692-1-vdonnefort@google.com>
Subject: [PATCH v1 0/2] KVM: arm64: Use folio for THP support
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kernel-team@android.com, will@kernel.org, willy@infradead.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

With the introduction of folios for transparent huge pages [1], we
can rely on this support to identify if a page is backed by a huge one,
saving a page table walk.

[1] https://lkml.kernel.org/r/20220504182857.4013401-3-willy@infradead.org

Vincent Donnefort (2):
  KVM: arm64: Do not transfer page refcount for THP adjustment
  KVM: arm64: Use folio for THP adjustment

 arch/arm64/kvm/mmu.c | 79 ++------------------------------------------
 1 file changed, 3 insertions(+), 76 deletions(-)


base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
-- 
2.42.0.515.g380fc7ccd1-goog

