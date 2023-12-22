Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B541A71D
	for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 13:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L8nJsjou"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5cda3e35b26so769447a12.1
        for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 05:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253072; x=1703857872; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7GbTP9pyEfLW8+fO86ti39WKj5aM3Ikce3+WhF/QSJE=;
        b=L8nJsjouP48YULqqBG2u78CRNcRbI/Eo8OQdloh+pFNbY7HkMaGVYEUFbRUoEjArVj
         7Ls90ZOBw0GG1Bt9e9N4ptB2DnjPgJzCEMl96PlH02YwvlqIuIl6DnBd+wSCtILD1Kq0
         NTI3QtzXaLhhu8YGIGXcnlkpqftJEhPUjNSlZA7Nl70soMlpeQtNIFMINkj5bHjspxOD
         qenL0hHGiOCnQpKmA2drtQTHUKHV4rQoSSN/7Gxav/lFXgGSMMf8SrgohrTlNRGXY+NL
         4tgsUXWvuQSW7++M747560oxIGP81Cham7Zu2XolK7pMFafnt1ZVPvxl48xE8uU29miy
         kdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253072; x=1703857872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7GbTP9pyEfLW8+fO86ti39WKj5aM3Ikce3+WhF/QSJE=;
        b=uZeIjSQwUC5aMP9azU+Q7lFsKCUI7KIJApf75CjzWjiami/YllTKMweyS5o3GoTHOx
         WrFMzElpZhZyaiLmEbKcKIXN/hWFaPKf91yHiy1TylcewyoPM5JF9vey64p2AqVPf3LV
         FPbfPfX8zjyUoIRHAV0pyTKuD9lnKm8AOetT3cRsDckRWgUzq9UTjfUJDCXOX27HMXZU
         td40fLUpeMotC05EmjESzS6+0p43M8VfxCoFJOZbsGEj07SuaN8ENia+v3M9c2JJ3srL
         8mIUKoA1K1z99dK+PdI+4BIrLb1GibawWCdo2d8c7R8tvUDoT3zhiFJCBhBevAxkfrQ/
         udfA==
X-Gm-Message-State: AOJu0YzcNQgaHyWtKPUuJ+BCQ91HMPOpr+Go5641hc4DsFE6sIalacom
	4eZ2IuujL5x1q/hTLgW/s6M=
X-Google-Smtp-Source: AGHT+IGJI92l6o3kvWR/9nnc+3uwUDhIQTyXexnYVp7D+d/n+yWUp/xYOOZ+9JgltI8VuCq6hAiw9g==
X-Received: by 2002:a17:90b:e8b:b0:28c:27:dc87 with SMTP id fv11-20020a17090b0e8b00b0028c0027dc87mr840659pjb.49.1703253072589;
        Fri, 22 Dec 2023 05:51:12 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:51:11 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 1/9] s390x: clean lib/auxinfo.o
Date: Fri, 22 Dec 2023 23:50:40 +1000
Message-ID: <20231222135048.1924672-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231222135048.1924672-1-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 s390x/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index f79fd009..95ef9533 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -227,7 +227,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 
 
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
+	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d lib/auxinfo.o $(comm-key)
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
-- 
2.42.0

