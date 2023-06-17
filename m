Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370A77FA
	for <kvmarm@lists.linux.dev>; Sat, 17 Jun 2023 01:50:04 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-25ea33087aaso1048534a91.3
        for <kvmarm@lists.linux.dev>; Fri, 16 Jun 2023 18:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966603; x=1689558603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8wvopEEtJy+VQFi0jWO9AxOzf3zK7vuqzel5MQDBWI=;
        b=Fs0KtJc+jvQH/d7Pv0q5K80EW8ySTlxM8cegq9+AgS1Ijq7KgNoXaqB+A4eGobQeKr
         pJvQayWppVmdbd0EU9m6YPpPBaZ9x456vndxRPGFkjoA2nJTvu3LM6BPm2rZqOJ1vZ6C
         J6tJSBdgUSBiFXwgFArHHfL0HtnlvQKqff8gHCMtz/mx6A8fj+KXs9dNZCiy/237RyRW
         lWREmvxFnZE+IIRhMlxhkqaLLhvu1dj8FS5893DMTNX6qj9jkAzJpnto2x6n2mM64Q7c
         fvBfwOkrcevXEZUp1ZBRyA6ddDNEbVTTExuGeSFWtRiAU0GbnqIw9eBaTphsrorqAQZr
         ysEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966603; x=1689558603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8wvopEEtJy+VQFi0jWO9AxOzf3zK7vuqzel5MQDBWI=;
        b=MfEWiYH2HSQf5X64k6hCVwObD5zzv0T+AICUbOrPqN12wLp3eaz+C+X3FOx3wl10Lp
         0PFnWegGyTTnssSS/WA5nBchw+O8022bfV+b9TNQw3/yPPG6DDhPYAw7hHKHa/tTCGpn
         u4zQTTGfGahR0gGdbo/PoLgHeutgqh0fX2Q96jtHTbCDZIx+8561EBQfel+XFeJkD6xe
         bFQ4agK8AJhDv/yNjnxyj3CRnzvisAld/6IARzqCa6O9rQ25E6ii/LYOP4BtwjiYgKnp
         ioAhCWiGPVqzKuDQ3/d66tuRI23vJrWmbUd733RtTZD1HTPZILIQ5kRwCnI7tAfQsXhg
         s2sA==
X-Gm-Message-State: AC+VfDyK62MKOlHRETz8yPmAHefCAtSUoV3ULcNwOquPM14TG01eGvmr
	gZXzbjxRMFhkGu8Pd9+Rz0E=
X-Google-Smtp-Source: ACHHUZ5l3EtrTX/js9eRnKEPECFJgzUDyg+TRt4q/rH+tzKCj1LvKdE8J/YrR1AWrw2RkWTcCsLmcw==
X-Received: by 2002:a17:90a:470f:b0:259:dda1:bee1 with SMTP id h15-20020a17090a470f00b00259dda1bee1mr3215312pjg.46.1686966603339;
        Fri, 16 Jun 2023 18:50:03 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:50:02 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 5/6] efi: Print address of image
Date: Sat, 17 Jun 2023 01:49:29 +0000
Message-Id: <20230617014930.2070-6-namit@vmware.com>
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

Using gdb to debug tests that are run from efi is very hard without
knowing the base address in which the image was loaded. Print the
address so it can be used while debugging.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/efi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/efi.c b/lib/efi.c
index 2e127a4..f42edd4 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -18,6 +18,7 @@
 extern int __argc, __envc;
 extern char *__argv[100];
 extern char *__environ[200];
+extern char _text;
 
 extern int main(int argc, char **argv, char **envp);
 
@@ -363,6 +364,8 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 		goto efi_main_error;
 	}
 
+	printf("Address of image is: 0x%lx\n", (unsigned long)&_text);
+
 	/* Run the test case */
 	ret = main(__argc, __argv, __environ);
 
-- 
2.34.1

