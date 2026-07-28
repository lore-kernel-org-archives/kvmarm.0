Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323D44302F2
	for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 12:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785240706; cv=none; b=cRaedBsIvhdrdRCueuCaY7Ku42z888FNmlqxaCI4tB/9gUmTCnBRDAaujvEsQ56SaqlrXAj4MUSMxQoX60FEBMNFL8TzsBQYVYpQkcNath5WOPwe/yHZFnf9er9QD+myjc2b01cQEBEOsSF+mrUFUaoi9i9VsC1DwH7HKYSXcnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785240706; c=relaxed/simple;
	bh=AkM7QJa0UrXPuPGuYE60hJYzttXPkaZSTzOr1esbiW8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jxrT4ExDaN1fXBsOs3pGaO4lFUZrJhERQrRPu1AvqwVbjnvirJAgrFk3+/n7Tgv9jWtiL78z8zXO7nrJQfIjUbkA1f2FmUvTuherqbAt6scMmm6U0c6ScVPvLLRmp3Llf7ZLduhe+XWCGz0aWoX0QmqLugAQDdT/RI0xJgg7AXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=amkwV4Fe; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="amkwV4Fe"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-69e70c286ecso3978826a12.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 05:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240702; x=1785845502; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gVnIMBasyGsCgYKzJa454oI7ZPXv6Y6JMFDgs68eV4E=;
        b=amkwV4FeOkp9yXZPI+TV3MkfAwNhDXmSeEnLoOAIuzN3hXz/g0+0e6n/3EX0rGT/Cl
         6UA/Ine6vvMjQqDwqBl02vv0GiQqu93wrd8EcED+VsLkR0KuiqMwKXQULiCnY4g4/+iX
         AyAYIrY6Bi27jPiWblgfn9FlyT5ErBbOwsqdtql+Nfa+dyqiRzNZG0kAlKYu+0WdTq47
         X6HoYPxDdU+wmu6Jq7/L4kclbiWYwI6hxn9ne8JOs7Jpf1vJlE6RbDDVh9mOUMZC9WLu
         nClyTFI965r+BdkBLqRSLHj9Dqt5kpgOMF+vAuL6XCyriZiCNFIEtGzzi+cS+HRL+Aq0
         3sbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240702; x=1785845502;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gVnIMBasyGsCgYKzJa454oI7ZPXv6Y6JMFDgs68eV4E=;
        b=Gzn5nhv+3LC5tsHzHZbl1SLNKSf2/ID/gRPuwl0ORB9zlBtN4dKbXVdJQ0EJEx/3tz
         akzOzSdO1CGgxB7H/YJA7dQu1Fv2BpEvjeE0Go02drmcVRNc67sVshQTMPaS6QfPWgIJ
         /ynw5ImX22uuANXwIomcxXPWcZGDOIG25AVNWMDldQqh9lxtmIWidGdbdBuBVNzx/5do
         tVGfuvlUTm2miGVhCeAs3Nf/5thDjPM9TT1sEfiF8nI6Kpf2P0FJpM3rYtOpASjIKYm/
         AEnkhE12U4gpi1nIXY/17bqAgVGKKBdcfdwXhZ296HLRzsbilWwn2FCZipmkmS410Sqq
         dZQw==
X-Forwarded-Encrypted: i=1; AHgh+RoPWalbRUPYwgCMilkOBdD3U6rNfWnFg0i3dm1bncBCdpNkySwzJZGO3kddjdlJkDJRKihrods=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTKXHn28aX0X7nTanBwiPTsibN93j8oZNPpNN+32LYorXuoTrw
	dMV3YVSCwY8/mB5TH6o+4S5OKGWdrO02WKHtkF+8pBcnRkurcPc1Gc47BkbdfD+eeQ+D4PGduRV
	39saVVptcE8GxkU1LBQ==
X-Received: from edfy21.prod.google.com ([2002:a05:6402:a3d5:b0:698:3510:43a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2b93:b0:69f:d5a9:c957 with SMTP id 4fb4d7f45d1cf-6a034a765a3mr1074401a12.35.1785240701982;
 Tue, 28 Jul 2026 05:11:41 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:28 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-2-tarunsahu@google.com>
Subject: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
enables live update support for KVM guest_memfd files, enabling
guest_memfd-backed memory preservation across kernel upgrades.

Currently this support only guest_memfd files that are full-shared
(INIT_SHARED and no support for private_mem).

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 kernel/liveupdate/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index c13af38ba23a..2490f9a9b838 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -86,4 +86,19 @@ config LIVEUPDATE_MEMFD
 
 	  If unsure, say N.
 
+config LIVEUPDATE_GUEST_MEMFD
+	bool "Live update support for guest_memfd"
+	depends on LIVEUPDATE
+	depends on KVM_GUEST_MEMFD
+	default LIVEUPDATE
+	help
+	  Enable live update support for KVM guest_memfd files. This allows
+	  preserving VM Memory backed by guest_memfd file across kernel live
+	  updates.
+
+	  This can only be used for the guest_memfd that are fully-shared
+	  and pre-faulted.
+
+	  If unsure, say N.
+
 endmenu
-- 
2.55.0.229.g6434b31f56-goog

