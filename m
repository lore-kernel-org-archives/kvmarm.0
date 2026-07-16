Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8ED43991D
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 17:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784223198; cv=none; b=fQvupHp2Sr37XeK7TFu7Fx/kUWkImEogU93bPS81jY5LgCAAN/nzZumuE26oPSHqD+eGZgVGFOT0jFWEiAJbtmEVJLTclSOzuSMRYBhr+aDABKZYFg5wRWjSbFFxiUR5tiTvkGT54bD14mw1b1TkXDJLq2kIrtcy50FIxwDVch0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784223198; c=relaxed/simple;
	bh=XgbCD7Ssd+kGo1rqUZiy76sXUoW6AqZaTNUHW5cVLiA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qnh2HxFdv07Zo+0MTzNRHJnGSMnwFDcN2FfUJ+2mIx9a3szi7Gyhx/Bt1ukF7QRMqsUtqqGOFGQNhrepSV8Y4HsgwCo+WcTdk2AWAmbw1VXrxAplcCnxlsOOH+Ji0gnTg5Ak8J9lHmPhq7uZrwptOTNMCkQRg/ZsIXKbzNW+uRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HM7RTEYa; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HM7RTEYa"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-487059fb570so5165511b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784223196; x=1784827996; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0Z+anC+/1XFqwXmxKZk/3VItIn4RPKH7QLbFgNe4Yzs=;
        b=HM7RTEYazpnc8dKNoPLWuBp0/rnFsEdZ+j+PfoT38dC5a0mNvDogb4uJuyXgSBq+CC
         3yA+v0tgf0gH9EjeDSounU91tUXvCitlt8ZlTV2Ua9/TwBjlpgv/wF7E3AoBLQ551HRl
         Gsq3VG/TlZeZYQ7NSnFktQ+YmhBZBhiROiIug9O8ej9EIp2VMAa576nQjOucx0U429nS
         j+tuQKcbQoKORDguXkJkdfxa5lspfYX8uW6s51PYH7zmO2zdm1Gv0iCX83ur2y55IiDj
         g01YR9aLzcDo2xMZBKsyEA6ypWKVNz9zdnVx9IsOWOAtwkDXXBah3hhmi+X3vbMMdEk7
         Ft7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784223196; x=1784827996;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Z+anC+/1XFqwXmxKZk/3VItIn4RPKH7QLbFgNe4Yzs=;
        b=dRfl6Gat4jUgzkqwni2pHdFnu4LR+tYOFoh7wo8HWhzxdfQ9RRTqn+Qs1/V2s1zH0c
         gpc+pkV5ftOWMY8fr3nxovVOqo8rL+u8w1QKKjV4diPDa5aTSoKeoLryiFoYCnX7AXm8
         W4hmzLTD/ydu6lnpXY05e310qqya6HFeAKc9oSQtCqdZ/4RuXz8Po2CaFnszBSRpin8q
         rFecsUK0Zi7nKU3MTwX0eoDS2xW07EqIRYtaAkPhcD5q3X/cJQvHe67LGac/arDnrWPZ
         3m7ziUwQLuEocjQWPQuwcRB4ye+kStFleVX/WLpKx4zvL27P4cYZvmGK7l+LjCU/jIPm
         lAhA==
X-Forwarded-Encrypted: i=1; AHgh+RoEjKkhmr7q2v++nwsgcOMJNbhYprMSrpaZe+ZHtATfP3FUtZdcoybewr8Bl6RuelOqyVXj17M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxk9hLkMpyGyEyQsh5WvQ74Pbc5gkq4Z9d0/oVrwPQahvu+5W1y
	pa2Odb7UXe6D6fQlEDa3wZO+KBkMqHWXnjL9bxvM0qOMV5DQU33xUFg95R6rPB89A+ewOj52Hl3
	QxTYeX7+LIl34MbepBLGZArO62w==
X-Received: from ileg2.prod.google.com ([2002:a05:6e02:1a22:b0:503:a191:13b7])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:524b:b0:497:df42:1dee with SMTP id 5614622812f47-4a4c878effamr415255b6e.35.1784223195562;
 Thu, 16 Jul 2026 10:33:15 -0700 (PDT)
Date: Thu, 16 Jul 2026 17:33:15 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260716173315.2775989-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH] Makefile: efi: preserve .dynstr section for
 LLVM objcopy compatibility
From: Colton Lewis <coltonlewis@google.com>
To: andrew.jones@linux.dev, pbonzini@redhat.com
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

When building EFI binaries with llvm-objcopy, keeping sections with
'-j .dynamic -j .dynsym' without '-j .dynstr' fails with:

  llvm-objcopy: error: 'arm/spinlock-test.so': section '.dynstr'
  cannot be removed because it is referenced by the section '.dynamic'

Include '.dynstr' in the list of preserved sections across
arm/Makefile.common, riscv/Makefile, and x86/Makefile.common so that
EFI binaries can be built cleanly using llvm-objcopy.

Assisted-by: Gemini:gemini-next
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arm/Makefile.common | 2 +-
 riscv/Makefile      | 2 +-
 x86/Makefile.common | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index a5d97bcf..550ec0a1 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -88,7 +88,7 @@ ifeq ($(CONFIG_EFI),y)
 	$(OBJCOPY) --strip-debug $^
 	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
 	$(OBJCOPY) \
-		-j .text -j .sdata -j .data -j .dynamic -j .dynsym \
+		-j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .dynstr \
 		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
 		-j .reloc \
 		-O binary $^ $@
diff --git a/riscv/Makefile b/riscv/Makefile
index 64720c38..348a30a7 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -123,7 +123,7 @@ cflatobjs += lib/efi.o
 	$(OBJCOPY) --strip-debug $^
 	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
 	$(OBJCOPY) \
-		-j .text -j .sdata -j .data -j .rodata -j .dynamic -j .dynsym \
+		-j .text -j .sdata -j .data -j .rodata -j .dynamic -j .dynsym -j .dynstr \
 		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
 		-j .reloc \
 		-O binary $^ $@
diff --git a/x86/Makefile.common b/x86/Makefile.common
index a251dd71..054e2391 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -58,7 +58,7 @@ ifeq ($(CONFIG_EFI),y)
 	$(OBJCOPY) --strip-debug $^
 	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
 	$(OBJCOPY) \
-		-j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel \
+		-j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .dynstr -j .rel \
 		-j .rela -j .reloc -S --target=$(FORMAT) $< $@
 	@chmod a-x $@
 else
-- 
2.55.0.229.g6434b31f56-goog

