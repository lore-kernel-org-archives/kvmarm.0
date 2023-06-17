Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCB77FA
	for <kvmarm@lists.linux.dev>; Sat, 17 Jun 2023 01:50:05 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1a98cf01151so1466566fac.2
        for <kvmarm@lists.linux.dev>; Fri, 16 Jun 2023 18:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966605; x=1689558605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynKZKGuO4BrwSZJ0FNz6BaXOvj6HEfe3RCURjgJx+qM=;
        b=GZ3R+Vm33xO9SH7eHKsK6NVw/DOMl+0JCqN5rrBnjO/w0Nnxb24sfnL6Jbs48K6+WF
         xoR7hJFok8VQ3sDtldOMYpZRJRGic+z8rCZlNltsAjnlqikT2af3Vyg7iOecpaF77PkN
         trC3q+/uCVwvp3n59I3jFBjbuFs8dyI2J1zh7+BycQ8DFIOB0NIdxE1szXWYrLqfAbFc
         2FM6VxcEGnEowyw9M4wVM7MrMMFH/tm4caALAE70SbSS7snNVhPqW5+CyC9nO26Zwzde
         py7IRLyXG8ojr4T9EJzFdfaMl5wa0cR1YKeOrwrxLZ17MkgqJI4N8Z0sRqKpb0PjB66u
         pf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966605; x=1689558605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynKZKGuO4BrwSZJ0FNz6BaXOvj6HEfe3RCURjgJx+qM=;
        b=QK0wfAs1sYgZhaGh1+pjEGu3j7zsDDTUwjM5DSbrtzAsWH6t4ASW/JjQFhjiRrdFoL
         CvFtlSvkT6LM43VbJbfjGN5UiDwf8MIAQP6Hi+7fierQhNcA7OHnzvKjdQZsU/iuNy79
         k9SzcmdqnWP3r5XoT6IK7gNYcK164FOZL90KVQRW1M0vcXkcMsbHh3Qa8v4ApCmGl9+J
         mZxy8QTiLhqK45H8iKH9XpZH2lR+V6g3SFfBBPVgj6pScjaIfOZEgZ8Y5YSl9Zqrz+6Y
         B75U2JXsCONcm8M5GOpJkbf5ktAr0D5Mfr6cjQjK9TuJ8xcGSTApi2Zp8nVwE2lDkss4
         dGOQ==
X-Gm-Message-State: AC+VfDzManb6IbSk83EdsclocimpIPvHjBPihyrBTgN+V3SFghpRI6bm
	BPpvXNo07QuGzeI/QWtvj+c=
X-Google-Smtp-Source: ACHHUZ5nmJjaEn7DDaD5ykRWaLxUj8YZdDvEvRLN0jMPi/iqg5sETahn8WzHIj6AM0EqPUbXw+IEwA==
X-Received: by 2002:a05:6808:bca:b0:39e:6c93:3d2d with SMTP id o10-20020a0568080bca00b0039e6c933d2dmr4638438oik.30.1686966604946;
        Fri, 16 Jun 2023 18:50:04 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:50:04 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>,
	Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 6/6] arm64: dump stack on bad exception
Date: Sat, 17 Jun 2023 01:49:30 +0000
Message-Id: <20230617014930.2070-7-namit@vmware.com>
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

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/arm64/processor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 831207c..5bcad67 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -130,6 +130,7 @@ static void bad_exception(enum vector v, struct pt_regs *regs,
 	printf("Vector: %d (%s)\n", v, vector_names[v]);
 	printf("ESR_EL1: %8s%08x, ec=%#x (%s)\n", "", esr, ec, ec_names[ec]);
 	printf("FAR_EL1: %016lx (%svalid)\n", far, far_valid ? "" : "not ");
+	dump_stack();
 	printf("Exception frame registers:\n");
 	show_regs(regs);
 	abort();
-- 
2.34.1

