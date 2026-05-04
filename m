Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEA44266A3
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 21:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929542; cv=none; b=rCGBy6yklSaNFKKQak5DL2mP+ptOdPWxplYQyT2ttJ1XuGr0bN44Kp4wgdGcODN83KJ/RmQvsBLfIu2YJ+VV9LR1GsyHSbowukmFNeFm9H95fWUMdxAi8YJmuz2H/DwXWN0dh9fpsJNomgFJt2UX+wGmAVgRD5zbCzH2NRNLbr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929542; c=relaxed/simple;
	bh=/Xt6rnYnGFBq52V4bBzNz6QqRctwemMB97jkZH74ots=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lTUSUj0mGGboh6HUCBySaWC9kfXKRQOevdANt2MZ1xY4d4Iw2bYccY0tTGlTar17huHfB6/FKcWM4K+VYXqV/6LtkQQv8bkNVw+CEVEgc0Bwj2Zj+azANW938TibAIEHmiB/NxoKea+qEHnUA41oD9o4B5xplWr39VduTUUmSgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FfnrinXl; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FfnrinXl"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-68cfc614246so6160235eaf.3
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 14:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929532; x=1778534332; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=59TeqgAKhZvxIms330HaGI06DkqMrz/YA7lL8opNhPQ=;
        b=FfnrinXlPWRTlc+SJazAXdOsStT7PL7M8FCqHKuUt3CPhM63VmaD2vSt0CWbfAIewp
         9lJFbV6eRq+qlc3aSaPhsRinhgtseZMCXSs6kL4KbX6v2KFePtIW9nZROcnuhVkoxOTh
         WPiqQhjty5xytwtUTPqQr7COkQg2MaCavfEflVuCestAH4+UeIhkwLANszyUuOHXMltc
         ok+UK2B08UgyKx2Tmw8nlVhl/gDwCkOk9HjYus6/58oSIH8RIQFCIHIhqKk3c0YpuCwX
         H3DDXn/QXaAy/0DGwodxomO3aQtwo6Swgkqg4ZjfGk37EuGVKfhP8jWIN0rfGE0zdi4M
         ZLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929532; x=1778534332;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=59TeqgAKhZvxIms330HaGI06DkqMrz/YA7lL8opNhPQ=;
        b=ThgZl0WqVZPJJTmQy7y7Jx4QSKCRkn3HPowgHak6l9SY09YZOMy+ubluf+nl3p6Fna
         yiBL48kFvTLo0Qe4bpfsk9zHW+IMHPmr0cUIF8yPNqgStEut+X2f1RCeQHFw3ttFraqt
         gW1neDFgvfChuYnw6gAAbZw3IB5t9Ow4S0d/FSX9znqsd/yagoaM8m2GnapfQ3XqZYH4
         15ot0U7SzdNOlDJYRT2GRyqgAVvDkyPPA4aVdSEehuZZof6tpmIlDXRz9S0DOnqI4+BE
         aIkiVv5Pftm0zCQJ0WSuhLLitbyLJcnQa+5+6xya71p05tN/C3Pba3jL9Tx2CJD8/q2p
         mpEw==
X-Forwarded-Encrypted: i=1; AFNElJ9Ol8+1rDx1QxEfl0gBmI7KOWuo2kDR7nAkZO8RCBqxLtFgNhzgNSwdgxBzyJ9O471q9cuG8q0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8OPYT3a+vMYXu11zi04xidviWXXTbWohEgtr7X2LfC7viY9ii
	jED8jtNs2+Q6z1abcySxj39VkNNzytjl+V1KSp7EZduRkoTIPuTBQvmN2b8PpsL1b18ofDPDdaF
	+JgY8S5FNFHTMG8E+PFm56xgoiw==
X-Received: from ildm3.prod.google.com ([2002:a92:8703:0:b0:4fa:5514:a367])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:629:b0:696:757d:1942 with SMTP id 006d021491bc7-69697c60c82mr5023525eaf.32.1777929531976;
 Mon, 04 May 2026 14:18:51 -0700 (PDT)
Date: Mon,  4 May 2026 21:18:11 +0000
In-Reply-To: <20260504211813.1804997-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504211813.1804997-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504211813.1804997-19-coltonlewis@google.com>
Subject: [PATCH v7 18/20] KVM: selftests: Add find_bit to KVM library
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
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
index 6471fa214a9f9..79a45807865b5 100644
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
2.54.0.545.g6539524ca2-goog

