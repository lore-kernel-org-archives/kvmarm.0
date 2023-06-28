Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C81110F
	for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 00:14:36 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1b7f9d66812so28074755ad.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Jun 2023 17:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911276; x=1690503276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zfLc8s8ukm6B8uTEBNuw3gp/VvXLK+Q2HtLxCf87RA=;
        b=YiltKE2ojsIX1IvRFbadB/0W28pDqxr5SG/QQIxwovOvmZ9ydT8id2x0lPVM3uyNhL
         +ZNnoR099reijdo5nZNejbjtA05aUK6BoRdrWc34UIh9gnx3uYugc5CfZP6vXjS9gCSo
         EalYHyIYYHbKSPH/e68MDdibpEtocA/g0bi2v7l+wSsr9krzQJOyqjLZAUruqdRuTW28
         utyqzx++PLQxnUUPXe1ADwHd3SIDVD+iQTLA+65K2IjyGguv19PtDEXPA8LlvDCWf5go
         +UnSlaPneGiafRR8I7UAC/X8Xb1En9rp615e8UMcYaDSjdlHFCj9bVlX/N8v6RrQ/0MP
         VYgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911276; x=1690503276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zfLc8s8ukm6B8uTEBNuw3gp/VvXLK+Q2HtLxCf87RA=;
        b=XkQWLh6DrLNXCezmdW76p6LD9XI5pUJOSVe2OqXzTlC6NgmkhWWheu+qmak70HYntc
         mnGN571oAduJpWE6RvEOrBZDJ1DTuTeJCGexaj2IDVVG0F02pkTnvRNzoFV0tkjGsvHe
         +3NTH6VtbEisHY7lu4nLNKWEbAx1TxM07bRHbKKk9mEux8jmqHmX7rzjzxvOPQfR76iN
         iJobV+qOG6u0MAGKO2X+vf/uumajeoBd4v15O+/oQm1z3g2m+UVPpG2jTlRyn2Z5XIrp
         xGNvcypbcER0BKZ193am2JdN69RP3h5AwT4Prt1I2l0v3iWQ9RCOe/tAL9Z7cyE/pW3G
         9dxA==
X-Gm-Message-State: AC+VfDzYSNK2eSts3X2SXX+pl7GlgDIHLwy5xD7AB2WuGGfXi9uwUaLn
	r77lGimkpDYdWTnpj4lm4C/mkOOU65o=
X-Google-Smtp-Source: ACHHUZ5SRvbDizcqRaoRTMdNa0syYFknidVMQDwP1iEsY47BtD7BGVVdrneA3ak5Wa0+9ZhMSPeWTA==
X-Received: by 2002:a17:903:41c7:b0:1b7:ef04:da55 with SMTP id u7-20020a17090341c700b001b7ef04da55mr11767181ple.11.1687911275849;
        Tue, 27 Jun 2023 17:14:35 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:35 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v3 5/6] efi: print address of image
Date: Wed, 28 Jun 2023 00:13:54 +0000
Message-Id: <20230628001356.2706-7-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230628001356.2706-1-namit@vmware.com>
References: <20230628001356.2706-1-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

Using gdb to debug tests that are run from efi is very hard without
knowing the base address in which the image was loaded. Print the
address so it can be used while debugging.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/efi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/efi.c b/lib/efi.c
index 2e127a4..2091771 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -19,6 +19,8 @@ extern int __argc, __envc;
 extern char *__argv[100];
 extern char *__environ[200];
 
+extern char _text;
+
 extern int main(int argc, char **argv, char **envp);
 
 efi_system_table_t *efi_system_table = NULL;
@@ -363,6 +365,8 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 		goto efi_main_error;
 	}
 
+	printf("Address of image is: 0x%lx\n", (unsigned long)&_text);
+
 	/* Run the test case */
 	ret = main(__argc, __argv, __environ);
 
-- 
2.34.1

