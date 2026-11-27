Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798744;
	b=O0VGzbDBlmnwMUkeXCCYwp3zOPmeLBc++8+ldSXwjQRr2/Ien1huHbG2scIlJTUvpnF4
	 rKpgEcbHNAj8ab+cxpYqbgxMg0lEfJiyBGFA1Z3BTfAaNxHvNTZOuNhXXiWAVZs3HnOJo
	 LrIBQWlGQb0Ptm15GIlkTKwOZYdusCzo44APADJ6/CmC8bV+8+4jsdexLKa5lgIQ2MZem
	 zHaqGYp9Uz/tdWYJvPLZn8jE0snVpCeSqrs1Td9kPqMfotWVKWHAsFVLSAq6T92rNTvXP
	 GRSZpsXMJyEDTwjfFDYxwdtMqOCK9NE8f+3emPtunmu/5r70RjGbNDdaATzPn+PSTaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798744;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=DvmbVObzWQ/wjQetSsmCBr+QUtK2yXQRsQ+DR88rIOg=;
	b=bKZl8NyQwKZA/mr+qSmJc1nF6ju3mojXqNc9AlIf0UrANboDRtzVKSyi5cbUgtDRdDzt
	 5SgNQ4+0qaOv9c1OepaS9ebd+NqYH02+y5poD805fjdkoCo84iwE7QGKb+NvEPeN+KS0q
	 xV+UtaVDIHoLlq3qpkaG8CIEmdkWOHFYsdlK/xBu0Htvc4zgIEldqUuggsjCkwo6QqWuB
	 x48b6tcDd8fwnbTC9dZYj1/8RialwC+OM3+nPwrdy/QGkTIBPdYIxw06URi6MRVN7bOc7
	 1U1T53l36HbdvG7y3TQpcZgyEwbGm8ICRzROUZX9c52sgdphiBAtPVA/x+zowa4LUOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Qp/jnoLn";
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE1B606A31E
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 16:59:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEE1B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Qp/jnoLn
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4bb6bac1e84so53890635e9.0
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 08:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795798741; x=1796403541; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DvmbVObzWQ/wjQetSsmCBr+QUtK2yXQRsQ+DR88rIOg=;
        b=Qp/jnoLnvCcNT5+7Vi4uq52McljIpuueezBh/Afj3UmViq8sRcFVX0/tis5zyFQkIo
         3XBG8/A+Z0b4AGUS2DRhdD0ZajGLirfp/e+g1UdqsYF9+FiOcRZwrv8NTP4WgRbWb2i0
         aJl/Fv4hxqcPa24+Z7W0gCC3zAvwEDYQlFWmVi7KZa0IcGIVdzWPJY/HSRTnBVWXSlDk
         fLXXzuASxnVKfIhWOyc3rT3Zv9T5MXRcfTuFpbSttyj7XQT1Ycb1U68Oy4MDneZxrgzw
         NE9bLXIE/UGDX7dJHgyi8YLqHUgeVNpms6lM3dnTh1QYdyWI4DoIcK+5bBPDEZEwyL2L
         WZBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795798741; x=1796403541;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DvmbVObzWQ/wjQetSsmCBr+QUtK2yXQRsQ+DR88rIOg=;
        b=HHIeCelacSDtRxtxgtBusGvhM9b+EC8AKj0P3mzzMwzc3+dn2OPEuMxFJtpqqDgVEz
         quEoa5KEUYojwTMq0jfJomaktlUs2TQ4L1VUOGRjfOAhjtDnzRvj4648PUqLG5Mx+9Dd
         WfwD0a/L/wxiky8yXisYQSgcP0JmC6GdVo3Fj0h7Q8pGoIUwSP7rAy5XZtNGm19oTX0H
         1H/e9L3FV4KM6Mcb+eDG67n+KAzUPtbTYPLGsYoFqI+uVBHzvIO756rSaQGIWxFxr2kO
         zybTIy0U/QoHpivZRpzJ4eIJz5XUy89AiqkpgPnlehR23VFge61XhMpRyYp/PdP8CD2i
         LjVg==
X-Forwarded-Encrypted: i=1; AL+hErHBGN7pxoMQEETh5Nl3Zw9x20fnLCgo5iaXwq2gyKfLF5C26bSKa2EEX7PEOWbWSGpyuyk0nqA=@lists.linux.dev
X-Gm-Message-State: APuU4Z+5wDym22em6+3LGP/4pgVdR+yjBO2cZKyjCw0pQEwmXze663K4
	O6SheW9R81cX3el82fZ02BSHhzCHSvCWoEqJ5CoLdyAzHM4IyOLFP5i26h/9ZhGVG7Ryisdz6rM
	+eqeVCDPqeVycD/PUsDhrTg==
X-Received: from wrmk2.prod.google.com ([2002:adf:e3c2:0:b0:4ac:b8f7:9ef4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c84:b0:4a8:9a2f:d27 with SMTP id 5b1f17b1804b1-4bb8881f47emr524772265e9.25.1795798740885;
 Fri, 27 Nov 2026 08:59:00 -0800 (PST)
Date: Fri, 27 Nov 2026 16:58:40 +0000
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
Message-ID: <20261127165843.709034-1-vdonnefort@google.com>
Subject: [PATCH v2 0/2] arm64: THPs for systems with pages bigger than 4K
From: Vincent Donnefort <vdonnefort@google.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, 
	suzuki.poulose@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable THP support for arm64 guests on hosts with a page size larger
than 4K.

Changelog:

v2:
  * Memoize sysconf(_SC_PAGE_SIZE) in host_page_size() and back
    PAGE_SIZE with it to avoid repeated sysconf() calls. (Will)
  * Rebase on origin/master (2f3abe56dcd2).

v1 (https://lore.kernel.org/all/20261019145949.1922019-1-vdonnefort@google.com/)

Vincent Donnefort (2):
  util: Use a memoized value for PAGE_SIZE
  arm64: THPs for systems with pages bigger than 4K

 arm64/kvm.c        | 21 +++++++++++++--------
 builtin-run.c      | 14 +-------------
 include/kvm/kvm.h  |  4 ----
 include/kvm/util.h |  6 ++++++
 util/util.c        | 15 +++++++++++++++
 5 files changed, 35 insertions(+), 25 deletions(-)


base-commit: 2f3abe56dcd2658dc6dae3eeeb4996dc4b518bcf
-- 
2.56.1.839.g22a8290db9-goog

