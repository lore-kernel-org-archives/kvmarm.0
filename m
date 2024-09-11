Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F0D1BC081
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 20:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087353; cv=none; b=DMmRGIq4fRAFNFqaTO8fhWUvRRG5snM4jOBjVudtZ64cQ8hlSiL+6nodtfsTlunpWccJZ0VQsx6UUXx6wCS/6orrPQ1jM6HLF/AqZ4Rp1Okc5YgT3N7hYu2xTMwfB6Aapoi/vEUbrvIjK4OeI2DaCxrI9Pq9qB/CCslsoJtVXAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087353; c=relaxed/simple;
	bh=hbb0RaWzaTd3JfZQZX9GdrY3DUCQafK7uAfY73KOAY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=na9bwvH2nWdiXRIDyAiNY6oNPR5ZZ249iaidRciCHGEdol6t3jTwOC36/1URlJtn5VeyJIrkZ45VJ8JOlZ/CI5kqDqZZs1YTngkZpPYdZS+gnlTX9N/X/J5JMqYKxqUVyGwA3izG2X6I8xpLXEeKTBdGaZj36eAMNKot9D7yLCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o2rgCP3x; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o2rgCP3x"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1a91576564so1016710276.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 13:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087351; x=1726692151; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQRYVtp40gN2JN3r5ECO8yPdv4xFpWyP5ZtXJGFNMpg=;
        b=o2rgCP3xF71UBn80BjQj/IohfTy5L/NVt9qCJT1hytWjWgw6K8vsWdbT+FIuErP8cj
         2lDwegTtUJaCDsLPVOdRqnGuD2ZmbN0OPL3nrF9fBIR4AiC2jdM5sD4dXdasWmYzPX+7
         +BNjh5O8ozkTmRXg+ZvFgP5tGdjMDERGZSu9eZApFLen1WTaQLRydfxKWdK/hdMmVaO7
         IFBOwOL6+ulXHW2PIy3RFCBLkFdYSYL5sQTj7ZZh5lIQoib+ydpFf9ugBxr4AC+bXAH5
         IHLDQx2t5Gh9yy1lwhqZUQJardAgcXGw7Md8HfIfnglLbSjBb89SXYxJ2eKgVXQw4AsS
         cSeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087351; x=1726692151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZQRYVtp40gN2JN3r5ECO8yPdv4xFpWyP5ZtXJGFNMpg=;
        b=Z7GO1zUh7J7YM8DIau73Ong2Lz2XY0LrEN5fCs4rcmV6g9y+Ovyxi5kQyWlmhiD1TB
         vGEgdFcp7ZDYP8+8jeFm9INoHsy0zWBYHS+ElqPb8Q2nnBx9bs1VNQuF4Ze9nZqOzyAq
         ePfCoRV/Rc0lCl1HPZFhz1TbSS8PZj28pXebamUmau6RnzKOIXIxlOpzxHS3bMklJTET
         biPh25iIfKz0CK3B3t0kN9+N1R/pQa6fgAYMkD5cC0j877qfBZ8M+9ueJQFBFI+YADcH
         4HyvyFRtNtl4bYXhWhdJ62Bh3LyHo2YT1p9LQz7vXejEIqRjQj5AHbkC1x7gVEcek2tY
         ZVgg==
X-Forwarded-Encrypted: i=1; AJvYcCWZAaKL3PWo5ILeF5v9Ay0m8gDsjq9QzJbM7ysuO8srrWJVGpZpGl64X3dDHqCO1IW7UZmznMY=@lists.linux.dev
X-Gm-Message-State: AOJu0YweNVbPkVg1m8XXORmNn+ggNbeBIBnv+xMNwSGUsGcxd/A8t3SJ
	emqXHkeJz/72Ve1n6RfC7lPxijYVlgtWmcydFzKDkJiBginKKi4+odw7rTdgC4Bxmom2w6MjyDQ
	33w==
X-Google-Smtp-Source: AGHT+IH8ZQwfCbzagdZgU+EpISSX/A630EuGAq7pLp9hJDXsMNgEZzJ88I5801BwyQ8RRGJvBOpit5rNgP4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c711:0:b0:e0b:af9b:fb79 with SMTP id
 3f1490d57ef6-e1d9dbc1dc5mr2910276.3.1726087350958; Wed, 11 Sep 2024 13:42:30
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:50 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-6-seanjc@google.com>
Subject: [PATCH v2 05/13] KVM: selftests: Check for a potential unhandled
 exception iff KVM_RUN succeeded
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't check for an unhandled exception if KVM_RUN failed, e.g. if it
returned errno=EFAULT, as reporting unhandled exceptions is done via a
ucall, i.e. requires KVM_RUN to exit cleanly.  Theoretically, checking
for a ucall on a failed KVM_RUN could get a false positive, e.g. if there
were stale data in vcpu->run from a previous exit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 56b170b725b3..0e25011d9b51 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1719,7 +1719,8 @@ int _vcpu_run(struct kvm_vcpu *vcpu)
 		rc = __vcpu_run(vcpu);
 	} while (rc == -1 && errno == EINTR);
 
-	assert_on_unhandled_exception(vcpu);
+	if (!rc)
+		assert_on_unhandled_exception(vcpu);
 
 	return rc;
 }
-- 
2.46.0.598.g6f2099f65c-goog

