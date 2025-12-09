Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC23308F36
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313579; cv=none; b=uldrSEwYpD0YkQ49LRYkH3EQ0WcoDXerW0BQLAC41oPBXz+nCjjUVkT4ivo31lH+HvECIdgvwfpZcG2TwsDLF+a9eeDsNOz1BuAGoaruAIoL6+JMR9H9u3VcRowJgc7+LaTenrMFraZykWmhckbMnRoMiCjr5ulVVvw6UX/cGSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313579; c=relaxed/simple;
	bh=cVZBJahaKSTV176PZqkKWritcCQlQjwr4hNs/Lq4IcY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nih/y7eO2NqyxkCvgXtNVTB5O4Fw7C8uQAs9LiFiXyiWuC2yMjdg8bVgaRym50u41HnGf17vEWOWylKZuhA9uZN3OzpLR8rokQh2IHVL5zLU2XLiIgfyxokPtpJM11z7d6z2BlK7FFz770wDX8sK42vqa/9vhLgIJ6dxzRzcA/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hLecvI5R; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hLecvI5R"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7c7595cde21so12009629a34.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313569; x=1765918369; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kv1AwMKfqms6xWA28lythBC3EJWNFQ3+8EnRHrSdP2Q=;
        b=hLecvI5RQ7ZgY0BK4SIBbJ0ZrIZO24mNfghzveCe4WyFFqtY90DDEaaZ4DmXojhzNz
         UBe6mYbrE7QeB2xDsoeSlQaYaxhvDQvudXAxukFq4enFKLo+CNP+FWdh7iVBhwatCN+M
         EtuVpA6VPOtZS91X0GIUPXBwnxAWbW7erB3MmlkZRNw7Owm47sk4TU4rSP+Z9gIZDGYq
         qZNXQcuTjYz90unkYBh9KGXfxHsuiCqPnr2GYArBx1RhsiNxkIRW5JIy5o+KeEUGMLOX
         sd9+/EXL6PdzIZDnitcYslHb2al33OdYe8i+GG6LK78roJuyGfRqAFEZrJLhY188Iirc
         3eAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313569; x=1765918369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kv1AwMKfqms6xWA28lythBC3EJWNFQ3+8EnRHrSdP2Q=;
        b=cfUQemxgmgZibaH5frIhDwtJB5tnV42m35e1/sWfR4oyVIq+OmO6mgJu5D+uJa7Z+j
         8skRqhgOkANoYteRm5mad93TXwdonq3JcH9DGlfRgK9uZICKKw9lxmzpktxs7uLHzCi4
         SDSSUy0PzLgkjq6b03ptfO1ZAjggtJw1nzSrG0iAmyxyFJf+YVdgr0o5VDk5yTpzDXhL
         mgtdyo1q3FqnguzyE46C0PSSaaL8SXUdiowouU9kwTzFMETI8vGn6BImkC7boavf0Rgb
         XQGT4NHGbgTyHAcBxuYXVZO/twAD+IHBExsHNMFkUXtbdYA33H3zwbWCe023Iggx0IXU
         kKMg==
X-Forwarded-Encrypted: i=1; AJvYcCUWJ3P1HoRdKChgoKn3yKYAZ7ETHdXF3A2K2/Ja9fddlUmxWcP0Wf5rTc5itFzaVylMZiOuTmE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwyGeZz+eZ38ozWbVEvMpINpq9/So2r7Ko0Miu8SqBI+WIhoSVU
	JWUANSIcjmvHbr53hKz9jD1kWD3WHSecQ4rwDppCmPzg9azAOW1ZNTKErytK+/Of+7jk102XPrQ
	iyT31iceAxZP6g0lu3k4T3OZTmg==
X-Google-Smtp-Source: AGHT+IHsfvWbHL/8tFP4Ochtqb9Gms3M4fhZnid/Y2W+XVpjJijy4/NNK2sgiQPwkhfDucK/Gz477ZQXRQW17NPhgA==
X-Received: from otfh13.prod.google.com ([2002:a05:6830:224d:b0:7c7:6609:92cd])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:2685:b0:7c7:5f6e:f26e with SMTP id 46e09a7af769-7cacec2e507mr73093a34.24.1765313569578;
 Tue, 09 Dec 2025 12:52:49 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:20 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-24-coltonlewis@google.com>
Subject: [PATCH v5 23/24] KVM: selftests: Add find_bit to KVM library
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Some selftests have a dependency on find_bit and weren't compiling
separately without it, so I've added it to the KVM library here using
the same method as files like rbtree.c.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm   | 1 +
 tools/testing/selftests/kvm/lib/find_bit.c | 1 +
 2 files changed, 2 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 148d427ff24be..f44822b7d0e20 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -5,6 +5,7 @@ all:
 
 LIBKVM += lib/assert.c
 LIBKVM += lib/elf.c
+LIBKVM += lib/find_bit.c
 LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
diff --git a/tools/testing/selftests/kvm/lib/find_bit.c b/tools/testing/selftests/kvm/lib/find_bit.c
new file mode 100644
index 0000000000000..67d9d9cbca85c
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/find_bit.c
@@ -0,0 +1 @@
+#include "../../../../lib/find_bit.c"
-- 
2.52.0.239.gd5f0c6e74e-goog

