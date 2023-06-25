Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708129463
	for <kvmarm@lists.linux.dev>; Sun, 25 Jun 2023 23:07:55 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-676f16e0bc4so215335b3a.0
        for <kvmarm@lists.linux.dev>; Sun, 25 Jun 2023 16:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687734475; x=1690326475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zfLc8s8ukm6B8uTEBNuw3gp/VvXLK+Q2HtLxCf87RA=;
        b=AynI/fZMfTDQaf+uit3KBv2q/DJ9daWnRBz76NzDxTFBam4mj9rsWeOM1TwnMy+mdN
         ziXPVeb9KYV5pHMUL8bdcpq4qsWMJr95dKpz+LOP5Jbex2hnflc+lSHY+PdGj7sK4i5D
         nsFBHOASa9caRVyrAtp1ZZmHDj7x+bkkg1j64ePu+xNpfX7//dja9qtd9yLknR9rSG/K
         NKUtJ/4ZDik9XNgCp9/ClIyBiPO+nSxKki06oJKV54kGbMdwTqV+Lme7P1PucGT00oK/
         hVOIQuVOuQgGl3CmUnuEXLxyPXn+eIkNPlTXpCLd4wPWx9a9+A2/Y6kJYucUiBdAdWVu
         rMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687734475; x=1690326475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zfLc8s8ukm6B8uTEBNuw3gp/VvXLK+Q2HtLxCf87RA=;
        b=QdBW1dDcnMB7w6aQJymdMMosfdIwUcK6FhapgVSoZcs50QOPM+R4kiOrdi/bOgUGEi
         MG8S3ALuUNiwR9/wyuelBEndx0PYAIz8J8p47qKnduKRHZu/WJnXDRek2+mT14Lb7LzF
         y/TJT5CEf8kBA28oiW+o9hQDY34oxY/ipjnt1Q4FMjmy5ts0gmRECVCLMo6x+j7Xy1mL
         67WyDNoMQiXKgciOPSXocLIzgSqfsFipRKHWIm5eFxzgPsxNs/fVvnzGHgTREQhLH93A
         nWkkTk5oB42b1X1sEsdiBIxX1c/K/1yyYLXc5/Qi0nOtTuULdp//aix8vyxJgAjLkKNR
         49Gg==
X-Gm-Message-State: AC+VfDy8MlgTxVRAJeYQJkY8DgX1LBwgIURvUbtm7vrDw4c4RRudk6jH
	jAXcVq3NzZAt4FUeU4t79BQ=
X-Google-Smtp-Source: ACHHUZ51li6kaeUchqHwWbbjtLqSUUE2pFgSQxSkwB36acZS+Cdmp79EVQgN2I58zJnvMK3amYaQaA==
X-Received: by 2002:a05:6a00:194d:b0:666:2889:32bd with SMTP id s13-20020a056a00194d00b00666288932bdmr16655032pfk.9.1687734474490;
        Sun, 25 Jun 2023 16:07:54 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79194000000b006668f004420sm2716397pfa.148.2023.06.25.16.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 16:07:53 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v2 5/6] efi: print address of image
Date: Sun, 25 Jun 2023 23:07:15 +0000
Message-Id: <20230625230716.2922-6-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230625230716.2922-1-namit@vmware.com>
References: <20230625230716.2922-1-namit@vmware.com>
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

