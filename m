Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCF92C0280
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 21:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973290; cv=none; b=gnooOqYZjKpCk1xhpw5ufAwJxwMui/5YnpXEQf7hMHUhdkIr1tqRaEoXMDNkjpQtl97i1N/NPVoYp05pLyUTvnZixxjj6ls2EBAzjMLLFqHJ3P1qUNGMWhCHcUp+NXkryVPrxMJvyaKkmcaRQ2U+BwLSYsOGpXeKHQcRI0mfhbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973290; c=relaxed/simple;
	bh=BqECl176v/Gtm4B/mzO5FafL5ayJtu8vuAS8DstIHt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gmzhHyKhWyi7e19FyWxZ4r4ZXkc5Lzhjgjq99gbohUhz6kQArs54VqLFfae/yOUfgEsHyOIPP+wc514tKlN8rdpD+TT3shQNK0WvK+4rLtg/YgEtMp+SMVHQxOh3Cnf93QJ2wm0xBfqr6HrBzW9xvBgEkTMrpqh4oJcxdNi6XLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=RxGN44cv; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="RxGN44cv"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-827ec18434aso238392685a.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 14:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757973287; x=1758578087; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ombFoMObEj+Bm9MTRqLdHT2Je2br1eQyhTzkCsJmqpw=;
        b=RxGN44cvdwx/B/Yx1+tR3lfXtVfDrweloBv95caGn8AZm/Z46s8lQiPDgqAat9F7aC
         PRdeCSD7Dd087dCHuGPUomrAV5orX54t9JT19e3DfRL7U8ZFcUiiQPFpMb10REwX3pAF
         tTSaUuM7BhkbGQBJPnSgper5s+t0bJFZ52QZytHb5wqO2EAlHgU+PFR93/rxMVTdajey
         5fh/D0pmJjPCOhes3qtmp1/N5yWGiO/zQyL5HvcV8sY0MDw0Eeb5V52e02uEICds0SVm
         E/5EGTYXkEOqmccOmd+ciaO0vp+E/EqN8K59lYjQRK+SdTOm8iz7oQdrqq0CAmDdPYoI
         P6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757973287; x=1758578087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ombFoMObEj+Bm9MTRqLdHT2Je2br1eQyhTzkCsJmqpw=;
        b=qDpjH1hYJuOWToGDwQa3zpbQgIwBbiZHwADPHDAOyBwOE2ua1I4GseFDcyca3TZC+H
         w3zXz0HIR3D1fNliTe9KAWWrjlNg4nYfOl+K630VCF5uxGP73263MkprG9vNrjBUPTE3
         8COugrwT5HH+z6MeFedJBDtZPvOaPxKRBMaa23TLwbEA7jWXWkWvPv8Ta8LbFv+bL4wL
         v2pnqoI12r5xBhuU+zM3KVrf+F6PF0hlKRru7SjEsNcdSwNGHKNbFXYGyLiL9du4hCBN
         +16XCLeU7TU3urPjWGRQWv9eGot2oX/I1da5QNCHQGVg2QbGfffWUqfxfZsvNCP+MsfU
         fX0A==
X-Forwarded-Encrypted: i=1; AJvYcCVccCsZvPKWa41VfzF8F8QCmFtFHZnGy5L+UaLO6bYgCHrlzmSmtFXeO7RZh8YiIPiuaCh22Sc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLIS45hdUUGLzBGJmWuSPUROUtgaUT2YkhapDUUFe83qTt9oUZ
	nkczt8kDa3PWP/njbO6HMNaEYW8hXcF+HHqPl66lDs1NPYdWo50R2lJVsKEzFjgjIOM=
X-Gm-Gg: ASbGnculuR1Ph7h5sRxG4ZyoZiwtZWlycSF8DpK6zmWmiy5jFg1z0eZqVQrCd5WlsBY
	r0nJCqZq4Pai9BwS+IiLPZmxfIJDie95CbQCMbB6O9ch5iPsLywp+fJz2ogMFUKkJ6KlbDYWA36
	RBn6SEzXRzh2EdlgHz14XZKmhYr79LxNNxw4WSohE79uNGMkDQwRaLJHob4a7J3YyGwncQzSBLa
	2n6EEgObl/UvT7BS3VtsK1kgVe/o6XV2CvioyhMrucW4ELAfe7C3oMNzEclkpzpeOYhSWfEN8Gl
	5GuoktsHST94uQc2wIOSYj9VcqeidZdVI/GSgm2wva3tsZciptPDwVuP8saQhHLbMNlim1feyix
	BwYmkOnP96hUMdBkWUUTWtta4UanQTciL+1AzaVCdhJtdJNgPjNer5cu8MwgyM2Fqrw+i/YXpLI
	9nx4hFPXYSnmzPv9KLyw==
X-Google-Smtp-Source: AGHT+IEuqGdoGYF5m+yzcc+prlAqTqhfn1vJxl4k2UEJlpzW4xTYt2Bva1hztcSng6jqi/2eVt6xsQ==
X-Received: by 2002:a05:620a:319a:b0:7e7:fc32:f07f with SMTP id af79cd13be357-823fd4191fbmr1919575285a.22.1757973287213;
        Mon, 15 Sep 2025 14:54:47 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-783edc88db3sm25104796d6.66.2025.09.15.14.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 14:54:46 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf functions
Date: Mon, 15 Sep 2025 23:54:28 +0200
Message-ID: <20250915215432.362444-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of [1], trying to enhance backtraces involving leaf
functions.

This version fixes backtraces on ARM and ARM64 as well, as ARM currently
fails hard for leaf functions lacking a proper stack frame setup, making
it dereference invalid pointers. ARM64 just skips frames, much like x86
does.

v2 fixes this by introducing the concept of "late CFLAGS" that get
evaluated in the top-level Makefile once all other optional flags have
been added to $(CFLAGS), which is needed for x86's version at least.

Please apply!

Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20250724181759.1974692-1-minipli@grsecurity.net/

Mathias Krause (4):
  Makefile: Provide a concept of late CFLAGS
  x86: Better backtraces for leaf functions
  arm64: Better backtraces for leaf functions
  arm: Fix backtraces involving leaf functions

 Makefile            |  4 ++++
 arm/Makefile.arm    |  8 ++++++++
 arm/Makefile.arm64  |  6 ++++++
 x86/Makefile.common | 11 +++++++++++
 lib/arm/stack.c     | 18 ++++++++++++++++--
 5 files changed, 45 insertions(+), 2 deletions(-)

-- 
2.47.3

