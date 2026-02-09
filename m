Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE9C329E65
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676867; cv=none; b=gwv4u14kLKl+mj7ZlzlZFI7lkdz87Qk2n6QmD95WigdFh9kXCZD8gG2HIf7HlxwolEcM+3l3LBnocA6TIKsTxSC2N6HRLvmbTBpj2rw3czKhek6MhSTkkCLOrAe5HXokuev7KyxU02QMqYD1vRnN8acvqgzbs8SMhke7i48Qdwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676867; c=relaxed/simple;
	bh=pKWQ8eiEG2mrdGJZiqdIDMjf5MzF6cSVZ2+ozjk63zY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eh3SraY7Z0GomCTxKCc2HaunfsuCz19mLiPCI9IMTGze7ThGO25sREpKXYynePzLkChXh27kH3tikZezcKAxKLGt0tcqHON+xVr/oqNJUDwMF959uDhNRnizAYwV0M0ltcjyF5huqsC2u8FHeam0wlb27yHX+t9RpDAH2YdnbeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qOpRV36O; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qOpRV36O"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-6632b0d7401so16116047eaf.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676863; x=1771281663; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N13aFr3ll/bgxK3rlveFMtlg5cOY53+sxi39a+VtEUU=;
        b=qOpRV36OcXSd1RtORCXbzF2sRoEl1aKUyx2okDXTVHzPZF5eL0PW8FNh81tSZEYEl1
         lAHizr0b6ZJ61ABjbh3p3kdlsXHtCBOo7deSV4zpaWFpvbc/SNmx92lee6ZQ65JrWU5c
         yCRaGAjTLuUG5r73wpnNORooJy0uTbXUhAC3eIKWbfUyGG8AcZamEB/shssbHuDCOMpv
         ayx3TaG7zSMHQx8lyS8G67wuZj7+bTF0G9TocX3gV1+8ENMs2zlDZk9+XsUAS+iB56h2
         BBzNjd29IKKbxUwmhT7FUIoJOLlgKM4kTY6XUQq6OyesJdrCki13N629yTfzjbqb3YXU
         MeMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676863; x=1771281663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N13aFr3ll/bgxK3rlveFMtlg5cOY53+sxi39a+VtEUU=;
        b=e2hXwPPkyVWjZdeGYp64BpX+wQ3Of/GYkAkBUx6sWpMGSZ4dtJAAgvpTldPkDdF8lE
         TCUjNvlCmcgkGDAbI1S7U2fRUkIA9pDtrXOC/2a6MtNjMzSSlCRZU0v3evjsWQkbSThk
         yVt7HevAnWuSDCwQg+gkI32+SwdtASYnTbc47AWlZS3fP20OLo/XAm8t/OCR79we8vVG
         c/akE+LPSWJ66xdTqNZIuLfowyMaVItc7iff3CCKbh6vIDNXcuZ6rS6ZeFZjghq28ZWS
         F4+e/+tmBb30Mx/TsXKHcqBUFD9UEiAga3W+zqfRoY1RojTem6iraXE25yNNqRGpYg+L
         V72Q==
X-Forwarded-Encrypted: i=1; AJvYcCUjaKDiptr50cJ6kc0jMf1cW1cDf47QE7h8BRFWBkVo41a7FJsyM8paPh+Px78eCuoXzfJjFYM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzd/0s3O/S5Nnt7spbGmItqgMnokXaDy8ZxDF0+RaoxoKsRbmLU
	nA8yhVxT/h3ziC58wJY02JG8cFXOkCTQmEAO9R4FwXqceBF7DS0vR3HoldULeMJCoyNV7R4cfAH
	lqNMk6LjrVLWekaK5Z3+9NsL3ig==
X-Received: from iobfj4.prod.google.com ([2002:a05:6602:644:b0:957:6f27:bbe0])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4b94:b0:662:f452:648f with SMTP id 006d021491bc7-66d09dacae7mr6166360eaf.17.1770676862961;
 Mon, 09 Feb 2026 14:41:02 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:12 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-18-coltonlewis@google.com>
Subject: [PATCH v6 17/19] KVM: selftests: Add find_bit to KVM library
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
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
index ba5c2b643efaa..1f7465348e545 100644
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
2.53.0.rc2.204.g2597b5adb4-goog

