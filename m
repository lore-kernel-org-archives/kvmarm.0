Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE4F7FA
	for <kvmarm@lists.linux.dev>; Sat, 17 Jun 2023 01:49:56 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1b516978829so11330705ad.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Jun 2023 18:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966596; x=1689558596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oecw4cHm2e2h1exUu5iz9LoDoKel+rnByD4CKAVOjIY=;
        b=Mrvp2JnZiceRh9mG0LiVPW0321usomG4RlXWmvuSG75MS9sl3wTBE5Vk9ug3cjyzpU
         SV1w7HOX0Wt9l+GOUEkMJwYyJGN3XL+WYjhabirhKWLESE2p/LOXcFnooYtdtB04jKKT
         Vc/Me3HxBi2zNq7tSrW9sPWo/FSQNdYi6HXvmdNSmI2UF50dyDURC3Y/endI9L6tW36J
         prHnDUFKZm6w9ooIXneyXzl34vDxMnP5Ev7Wg3645q5RvVVNxHQVEgs2ziF+e/emNDsW
         /8cJPfj6eZmBU8CyAWGDbSEIGn3rIxflU+zg0bf8+TkxqHRFUJ5ntAW86ZngcGQQn3TC
         3Bwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966596; x=1689558596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oecw4cHm2e2h1exUu5iz9LoDoKel+rnByD4CKAVOjIY=;
        b=G/RrpgwhZ6yC0Si3aNUMWHSoiPi6Uzmb0nGQdlVbxmhglEA0Hxp0D4mfdYA270VsyP
         72L0UVlJwIHa+DQSOOc28EzVIJOB4ocg3RdCAWo+e34/YQgzXgnTE9acXZn2FG0c1QsQ
         KMqiVAX12mUjY8ozjxwvrWyfs8+RjnlRfUOmkuo9oYURFShLlYSLUpCU5+h/wg4+5ac2
         s/A3A1cjoLZuV1TDzdcrAHwV03k0rdOazJ7fjJipMk4zx6nd9wrHBOisibuukuvTreWK
         ads+Klcu/lKlv8hjCDiFBEzhbyGpuEf4N7DKDqKNMREtk/Li1khROl0EHmXbwPkfurr5
         pMAg==
X-Gm-Message-State: AC+VfDxb2ywgglay/xV9p3KZpVaXsIupip9fBrDPpj/CBfcTmQ6J6B+e
	Fsu7W7biB9RXgnO0/hYnFVk=
X-Google-Smtp-Source: ACHHUZ6X8GA1cQpq2woKJ6CnOZa9hGXLGvgUI5zPcjIdSU+YyL4dfK/rvK546JAqZeqN8MCF0I6FAg==
X-Received: by 2002:a17:903:445:b0:1b3:f3ae:e1ed with SMTP id iw5-20020a170903044500b001b3f3aee1edmr3321551plb.37.1686966595824;
        Fri, 16 Jun 2023 18:49:55 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:49:55 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 1/6] arm: keep efi debug information in a separate file
Date: Sat, 17 Jun 2023 01:49:25 +0000
Message-Id: <20230617014930.2070-2-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617014930.2070-1-namit@vmware.com>
References: <20230617014930.2070-1-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

Debugging tests that run on EFI is hard because the debug information is
not included in the EFI file. Dump it into a separeate .debug file to
allow the use of gdb or pretty_print_stacks script.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 arm/Makefile.common | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index d60cf8c..f904702 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -69,7 +69,7 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
 ifeq ($(CONFIG_EFI),y)
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
 %.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
-	$(CC) $(CFLAGS) -c -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
+	$(CC) $(CFLAGS) -c -g -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
 		-DPROGNAME=\"$(@:.so=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
 	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(@:.so=.aux.o) \
@@ -78,6 +78,9 @@ ifeq ($(CONFIG_EFI),y)
 
 %.efi: %.so
 	$(call arch_elf_check, $^)
+	$(OBJCOPY) --only-keep-debug $^ $@.debug
+	$(OBJCOPY) --strip-debug $^
+	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
 	$(OBJCOPY) \
 		-j .text -j .sdata -j .data -j .dynamic -j .dynsym \
 		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
-- 
2.34.1

