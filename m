Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36409463
	for <kvmarm@lists.linux.dev>; Sun, 25 Jun 2023 23:07:56 +0000 (UTC)
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3a0457d6b77so2540648b6e.0
        for <kvmarm@lists.linux.dev>; Sun, 25 Jun 2023 16:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687734476; x=1690326476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bl2xS0hpaMhLNXGaRDLAye8tC/jIz9OZNyY0aYdzy3U=;
        b=KbMaFmSofqmick+plETX0T+mF+UV+45vO49VyJ7JA6kAtF+qJwHiCKXRLip4J88uGr
         Igti9yUpic3Ls6GY/9Wha/3gaYHrnG0Vxf5eLjXHL2OBTYPXyySoTPm2MXH7nuyXL0zU
         nbMWVHtWgtx2khr7nFXLRQQ0Si1b2nK8iKK5ux5dix7U+Av1DAG0gxqpg3bvLu2vjNRH
         cY5Rfh6Ydbm7PeimaHCmBjEwAROiXJBBi8gYYHMhnc+vDRaXgpPoGCvSxKCqxtHElfxu
         +iL7UjdJ6KTTDR9xGg5mXl5jSq58WqIZyVbupMgxcQcFva87aSVNt4dDoCsITFwlVVGE
         cFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687734476; x=1690326476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bl2xS0hpaMhLNXGaRDLAye8tC/jIz9OZNyY0aYdzy3U=;
        b=a9YBlTX+9QWc8E7mtGPi6+9qqALn0YAwGyT4q0yPmmBw3bKgwNHhCn52E87VTRhDuq
         SIL2YWs2v90SIJ1qAm3Mw2KMCM4h6FyAJ1XqbgbG0UJuq+OrB9IKrAxiP90SI/Ior2XI
         hMinrdQ8F5UrwBDRydkJvJBMz4fV65WPE3OV+4YheUVbS2L+gjrmjI26499ntT6N6F+i
         vpCFHEx0mMr9rxxbXqR5Q/5Hky7EwvkeN7iw26BPVGqpbzmF+bF6nmXAIENCM7aa1fcR
         U3B8ZCz/kYuoFiOtsOw1zOty10BVnVa8eq6KaAAKPw8e3NwV/anDMj3Kt0O+wOdh1eTJ
         Iy9w==
X-Gm-Message-State: AC+VfDyHLdhnXbzuJwleQfMmWJRjqZd0jyYOlpQ3CsqZ7m4kfWFPin+i
	XDNteqW8gxOGNOtUfYP8IZU=
X-Google-Smtp-Source: ACHHUZ5+5W+RcZMMKDb8pS61tgrv8Ela1lzVu99tUh2smk0denIO+W1dQYrHPE6NAvbWasv4+kzOUg==
X-Received: by 2002:a05:6808:14c5:b0:39f:393f:688c with SMTP id f5-20020a05680814c500b0039f393f688cmr27624441oiw.22.1687734475810;
        Sun, 25 Jun 2023 16:07:55 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79194000000b006668f004420sm2716397pfa.148.2023.06.25.16.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 16:07:55 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v2 6/6] arm64: dump stack on bad exception
Date: Sun, 25 Jun 2023 23:07:16 +0000
Message-Id: <20230625230716.2922-7-namit@vmware.com>
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

Upon a bad exception, the stack is rather useful for debugging, splat it
out.

Signed-off-by: Nadav Amit <namit@vmware.com>
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

