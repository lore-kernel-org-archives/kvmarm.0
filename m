Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952462C11D1
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 21:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973295; cv=none; b=GydTHTfxP6yM2gJfSa3lsxOQ8JWmgG/WDJ57ivO6/dnReEAmlXu49m/+VzolOiD+kIawtf35UIsf25nMe2rArcFo5XKEuj38cevkBt1gOWyqnkiQFiun0mZAbIr8BVOKFs36jHpzcOc0Afxvv7pATtTqwYYo8oG2/kjoV9EUw7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973295; c=relaxed/simple;
	bh=V74ryi50fllprQ+sbnAnYVxeP6t7/qch9aRTHY0lIig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwI4kb8POxXgmExj8VarFoUOt3ourjxveaN3vqhou02e8a7TAgdRfAaCNTJIR7QgzSpzUyBo25etk60Y17opz68/GYsW5ISQ2PwEpxZQs6lVxolbrOxRAwWFyiQ8aw9Jcg9B/pRpRRs7SYSdq4rw5VIwGKYCZqjck9e7JelvF5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=oUF2PJab; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="oUF2PJab"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-76b8fd4ba2cso28190336d6.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 14:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757973292; x=1758578092; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uS1hCbLa4Et7x6l9f592uuKlwLa7KX/sJXToAiHGN0g=;
        b=oUF2PJab9JFFVA07D9XMKELAQKj+8i0ulR1XVb/vG8xYDYQSvpJEoQ4oUMFSSXW5Q6
         2ZKWIQaqhOrj+61J5OFfyy+fyeojC7S59SiSaPMeWKfmNd9OHCpW8+VFqDMfwzCiu/Db
         QRZrawcoYWcx4U5V0mQc00Vpt4eEBYcoSOxxI6JSy4Ug44aiHrjGUpYgs3+m0hHKFbSB
         JZQS55tBUaMEP/sHcM3rxFafROyFyKbntJzJWAQL1PFI9BfzGEAJvEYv+l34bb2KCgs7
         3LNMhKb1jfbx1J8nXt1WnWNs8uE8cYnbq9/0nM4qSAGZExFsOs7eSdg3cSUobNrSPlFH
         +sjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757973292; x=1758578092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uS1hCbLa4Et7x6l9f592uuKlwLa7KX/sJXToAiHGN0g=;
        b=KhaM7LUSKZZFuAadoDWG5hvSW4KwX3nhXN7DfmUZ/162OTNH3GX/sGghF6F0OrhppE
         DVE/cO97Pb95pPUX9WFVlWvmx+7yMgYc3FE3J88TMyKYWCcSv2MXVtQ5KKYg8KCTZUi0
         fzoZawE7wSrVm4pRRmk1LpyGlPXLdVEXvyOZdpbUEU3dj8bDY8+AYY8bxRew6zNwFocJ
         4I3OFAXqd3oVcIHSrokNZ1mShKQQcgUm6e6bfXxX0v4SdyS7CkPP8q4WZx/mNaJd65ki
         bMJs73Y1t/xKXt7GiZoIViLU7EXECfak5fcE7xUMcuRyOMk3vWnv7xOKcSwmRUEEOonJ
         S2Tw==
X-Forwarded-Encrypted: i=1; AJvYcCUH+zfSMzKuZRxi1SmophAd/PsgDkY3U2lyza8g6SaAP7ex8NdANR2og40TfVUUJo+1MPd9FBk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKKbdqTEXwW9fTsulfSPm+yqZZdT42gJP+PDHTWc6rk+JX+4Cf
	V0FBdBj4aWQRgUWBqvJj4WA7DqelITLrYR9eOia8zykOwDJDa0JH6TQS4B3FIuSk5NYai0HcOBA
	6+zlK
X-Gm-Gg: ASbGncuqSTyWW7l0z2O9ztstYb2kqN0asMhhZETG1phDF9ngHIck03ZytjMZIDrRX6P
	lirCxBW8TGjs/piNwb/Ups6naAqKN0ee8M83pB3Pzvn/6HfDmtOboQLx2N9dpECLbs8R1uA0g1z
	rSvLQ5XuBlBgsTXaIEbDcd247ABX4fI8w+kC0WVRmvdPtxRn6rupFjt3hEGd03TsAaJYwcZzzjr
	cWkCRSPs7YxF36lU1s4+FQg1CSwYiN6AsDnnm7ClzQ2bCQx1i321119yvRhQvEmhemLOgYhJUOw
	mPKBozDyu0KOhI0eV0aogKHBBLZZYCs0bEe12I58M8jE8drW3o2AhjQeZuz96lD/h8Q+o/YsjfI
	Hl+Qsa7SLbxOh7Lz97xdGAzL2odsNh1srs9Aj2jrmRbeO7v4xV4hh71dWQJeLe2CW3LOWBCqGll
	KjBiOgbMZr30x+PdKktA==
X-Google-Smtp-Source: AGHT+IGV5e0judTPviZfC121RGuql1NEb4uEFiPSK4CkEMEQ03cwtJ5PHz8OZy22/jFB8T1ux5L+WA==
X-Received: by 2002:a05:6214:20a5:b0:72a:d613:317e with SMTP id 6a1803df08f44-767c46cdaf2mr171830896d6.53.1757973292430;
        Mon, 15 Sep 2025 14:54:52 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-783edc88db3sm25104796d6.66.2025.09.15.14.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 14:54:52 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 2/4] x86: Better backtraces for leaf functions
Date: Mon, 15 Sep 2025 23:54:30 +0200
Message-ID: <20250915215432.362444-3-minipli@grsecurity.net>
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

Leaf functions are problematic for backtraces as they lack the frame
pointer setup epilogue. If such a function causes a fault, the original
caller won't be part of the backtrace. That's problematic if, for
example, memcpy() is failing because it got passed a bad pointer. The
generated backtrace will look like this, providing no clue what the
issue may be:

	STACK: @401b31 4001ad
  0x0000000000401b31: memcpy at lib/string.c:136 (discriminator 3)
        	for (i = 0; i < n; ++i)
      > 		a[i] = b[i];

  0x00000000004001ac: gdt32_end at x86/cstart64.S:127
        	lea __environ(%rip), %rdx
      > 	call main
        	mov %eax, %edi

By abusing profiling, we can force the compiler to emit a frame pointer
setup epilogue even for leaf functions, making the above backtrace
change like this:

	STACK: @401c21 400512 4001ad
  0x0000000000401c21: memcpy at lib/string.c:136 (discriminator 3)
        	for (i = 0; i < n; ++i)
      > 		a[i] = b[i];

  0x0000000000400511: main at x86/hypercall.c:91 (discriminator 24)

      > 	memcpy((void *)~0xbadc0de, (void *)0xdeadbeef, 42);

  0x00000000004001ac: gdt32_end at x86/cstart64.S:127
        	lea __environ(%rip), %rdx
      > 	call main
        	mov %eax, %edi

Above backtrace includes the failing memcpy() call, making it much
easier to spot the bug.

Enable "fake profiling" if supported by the compiler to get better
backtraces. The runtime overhead should be negligible for the gained
debugability as the profiling call is actually a NOP.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
One may argure that the "ifneq ($(KEEP_FRAME_POINTER),) ... endif"
wrapping isn't needed, and that's true. However, it simplifies toggling
that variable, if there'll ever be a need for it.

 x86/Makefile.common | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 5663a65d3df4..be18a77a779e 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -43,6 +43,17 @@ COMMON_CFLAGS += -O1
 # stack.o relies on frame pointers.
 KEEP_FRAME_POINTER := y
 
+ifneq ($(KEEP_FRAME_POINTER),)
+# Fake profiling to force the compiler to emit a frame pointer setup also in
+# leaf function (-mno-omit-leaf-frame-pointer doesn't work, unfortunately).
+#
+# Note:
+# We need to defer the cc-option test until -fno-pic or -no-pie have been
+# added to CFLAGS as -mnop-mcount needs it. The lazy evaluation of CFLAGS
+# during compilation makes this do "The Right Thing."
+LATE_CFLAGS += $(call cc-option, -pg -mnop-mcount, "")
+endif
+
 FLATLIBS = lib/libcflat.a
 
 ifeq ($(CONFIG_EFI),y)
-- 
2.47.3

