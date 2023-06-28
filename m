Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63AF1106
	for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 00:14:37 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6687466137bso2903679b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Jun 2023 17:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911277; x=1690503277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bl2xS0hpaMhLNXGaRDLAye8tC/jIz9OZNyY0aYdzy3U=;
        b=XnE7sHOaoiCiEDBeNgd0++hU1hInSAuTGEsviDuRnsgTiROjl7wXCi0UPgpCNhLZxs
         jlquyq3qXBoDECqebVv+5HJ+HRK62YGd6gcNgoEdoEpu1+76yZBjl+rtS6joGSZopdG4
         kH5hQyzJy9TCtxAUmrwsU+S+2DOpAjOt2nl6TlAbVErCh/OART8zPMqgW5D/a2CnH2Jl
         iGlrOYqV4Khw+5DFAjRRNMhMQb0Ibh2sBI2n/g1DQmZ1V/oRvmwEhv6mT5z037dshhRs
         Um7O/P/kLQqtmMDsDZRv2Tmz3WnVkvyTcoAYHO2WU7W2YAe+krcXaM4gr+xzi2fy/wdj
         lZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911277; x=1690503277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bl2xS0hpaMhLNXGaRDLAye8tC/jIz9OZNyY0aYdzy3U=;
        b=Ph+VLophontEto4/aLKUnK1UBwgsanWQ0jL7mMnkhSe5kXbrAjHR9cuXcz59WX8ZXh
         CbhcaMg462GJGYyFvZ41tV65HRGnTVPBmqmL7P14yzNZC8+BwLiQGq3CRxU0I6RH7XUY
         ZeumpScfv0GJwbQCgLpZfPq8PPiCb/BixoEyW7P6DGmzVIYwlzL2AS4g67ZZpgQc7eAv
         NzztJ5zVYHZLBtCyZbbbUHL50cBnGyV1tgutahUtt8gdA7EGJSZPAuL1pNHQ9PfsI3Mb
         2XAOTtLTZcZrZYSE07wjqYeNgoUMOH7D2jF5EPeAEqthb++Je7/SbH1X1paxFnH27Nux
         9iBA==
X-Gm-Message-State: AC+VfDzsWMK1qpB9tniytyn9Uthe0uBbXDi0pWKt3tl6AMzrrc7C2KL1
	kCY3eoYYIaqhF7rWsb72Cpw=
X-Google-Smtp-Source: ACHHUZ5A7eHI61T59Oo5W/n0/S2XLNxWb6ZKzhIq4esUMRLC0gP+UewjIjEq/P7PoSZ4CFQE3HJIow==
X-Received: by 2002:a05:6a20:7d81:b0:12a:cc8:75dc with SMTP id v1-20020a056a207d8100b0012a0cc875dcmr4706951pzj.31.1687911277047;
        Tue, 27 Jun 2023 17:14:37 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:36 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v3 6/6] arm64: dump stack on bad exception
Date: Wed, 28 Jun 2023 00:13:55 +0000
Message-Id: <20230628001356.2706-8-namit@vmware.com>
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

