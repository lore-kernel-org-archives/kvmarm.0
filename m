Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519742C11FB
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 21:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973297; cv=none; b=Y4AsHnqVCg1nRo2Lydpnsytat27SiZjH4f6n/bgCfuVTtl0L7VhFaMoY2VLtunzSXgdVC9+Zph9EVCVEKosJOnRQD04b8lLXpGOsCkOtrmR6f36VDgvYsE5pPCHS3xJ1nFn6zMoG7V4V2aJmASLamKVYSoxN41O1LNyAqEKs9EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973297; c=relaxed/simple;
	bh=PdHvRfevfRqxtXXEl7OhG5gE+ulxsfMQaWQYO3eysx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeUWqanVFJUHBsU9fRZoi+RYD9dy7daZ9xkpWvh9fzooGjHUD0vLE4fllNdIoaPBjgdFD42LH0A+HT8txqoCO872DcQmi5ugjUIlueLG6HgvWVE/XySxFCva48f6MBF5IA6mK4IJu9nUXcEj9fBQdzrFcNBJk0exFjDgNqBNQNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=WmWXcB+I; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="WmWXcB+I"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-77766aae1abso18032266d6.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 14:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757973295; x=1758578095; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osV/NIjrIH3bFRop0adAnSBkm9yQEHuI7nZrGLeMdNc=;
        b=WmWXcB+InIMWpNXU9CbgpHdALA9sZczF0xB4Fjb+dx94n+vYCv+rHp4SbKvANO9TiO
         NOFlG2wucKFT5uMcd+A/YEm5RfE7EKPkynRUnpVF6S3JLzmezh43Av4FsP9W7JvRAETu
         XEm3yFKp3Zoq6JLDFuRkecL3hfhGiYjUUvdrYXuNBzZU1YiTJhS962crwe3OBeNjfPiX
         Xx7KCDcJOApctYes3nNTt2kWSmFvWAhcajTcaLIVL7RFEyZIgjK4xeQnDyVyPzQ0uK4q
         pwdbNWBj8YqOwd4kDau+3QCV/ubK/g2dp3GPOA/115/wJcoH715mVcnaxJvEZTYbKRwa
         zDzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757973295; x=1758578095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=osV/NIjrIH3bFRop0adAnSBkm9yQEHuI7nZrGLeMdNc=;
        b=kY9VD6JOPt7biURJwXZI5/IK8o8GF+HEQb75yo+S2d9v+fvK7viYQnQQVtEwvHiFib
         xsWrHROPuhSMgc8VPQY/4eChCIFx5UTFuHZvHv+BJwCm3+lmind/fDJiL1fl72paSFFQ
         8iZ5YB5C+ArTZwM6CiBAtb0a5aPyDq7DG1QR0uTaFol7ovpWu1VB1JjPVx4bw5+4hxZJ
         hXbOCWLJD76DQKbaIvPGvoj8z4IUIJGjXdtPccCp34jICwngIkyvUerEGPSprrfYBI3c
         1BWOKmkuoSIYYwC2+jMaJVYKoOKGGUQkTjOfIMDfYMGs/i6fiyiXpPxUYi4rzsBNX7o1
         dFuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWX3PQgZUby52StjZ9eqc3esvi7yTM4e13lG7u1KV8p/LLwNNM55QSdxW3AzKyQPDkSllq6jsg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZ5IUO/Yp7NvhawO9zHJ/N74TW0G4wAaCYAh/tWd1RB4TDVAaH
	/i25V5Hvk5g1Dj1CfPOnfxCR8bHfm3iNP7LSnEhbcC0Eilgqz7bsCgBCU6vJ97bcTn49YhREa0h
	MPOXV
X-Gm-Gg: ASbGncv4I76Sznjyr5giu4TlQXQ+Z13By+FQi2BFJOrDuLebQQs18UlKUiZfxiPJBcd
	Jl5dirt5niJuS4aRGmc9bBOXlDwMF/jdIGkSldrS3FuxH6vvp4EnihY6JbBvIEjWv/dOexrPJLN
	yDsxgZNJpJVE0vX1NV0pCP/ikcRwkJ4V5+sNr3ZAqD7XssCRq/1L/6WW3B4NBDSbGCtuGEs8aD3
	0M/F/AYQQTo+RZHh1qv+oNFFwLNRX3yLhcnut3/gyLXEQqhQaD2cHB+hFA6Jf7dVmbwzLA6gcVn
	T9F3PM5WtUdtTr1Kz7zL+ya4PD6Bcz6/O5o0Ceyn24wLI2b1qFdmQ//yX4pLoexPayfMMq9Txrc
	rM7pzZ/jn+So1hzrOqVhKZ4xBuOjAtxpJAixbjvz4UoL/ymGeqBLrM3qBzjN67+xN2aVZeDWxY3
	JD+hzg9eIJHHknH43DG7lXQ6tjoY7Z
X-Google-Smtp-Source: AGHT+IHFw5J+yWr+E/blgWAggycz6gvE13byABTAUgHBbzCSHqYp1RjFAsQBSWhl5BL4Ce51buVRAQ==
X-Received: by 2002:a05:6214:1d23:b0:743:15ff:94dc with SMTP id 6a1803df08f44-767bb4acc69mr166749496d6.7.1757973295050;
        Mon, 15 Sep 2025 14:54:55 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-783edc88db3sm25104796d6.66.2025.09.15.14.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 14:54:54 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 3/4] arm64: Better backtraces for leaf functions
Date: Mon, 15 Sep 2025 23:54:31 +0200
Message-ID: <20250915215432.362444-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915215432.362444-1-minipli@grsecurity.net>
References: <20250915215432.362444-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to x86 before, ARM64 skips the stack frame setup for leaf
functions, making backtraces miss frames.

Fortunately, gcc supports forcing generating stack frames for these via
-mno-omit-leaf-frame-pointer.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arm/Makefile.arm64 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index bf7ea2a36d3a..a40c830df20f 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -67,5 +67,11 @@ tests += $(TEST_DIR)/mte.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
+ifneq ($(KEEP_FRAME_POINTER),)
+# Force the generation of a regular stack frame even for leaf functions to make
+# stack walking reliable.
+LATE_CFLAGS += $(call cc-option, -mno-omit-leaf-frame-pointer, "")
+endif
+
 arch_clean: arm_clean
 	$(RM) lib/arm64/.*.d
-- 
2.47.3

