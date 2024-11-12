Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8B6226B99
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 10:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407858; cv=none; b=tc2Y/O21GBPrX5LU94cGWaZO51JDxecZbJXk5TAzx8NuKLZC5+EebwkDeewUMJBfr1W96ZF0nQ7Cev4220WuivSELOLTVbBOiJRt0u+3gCCEPYAxZJVm4W6KNM82dzy2Ou7WdeaC5Hjnk+m36XIGRmkPSb8IAlCtCSdW5RfSKRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407858; c=relaxed/simple;
	bh=NvSG3zelG+rR4cIjRHjFyNRBSUc2x1i3rn1BQtgcjyg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dksI7pPh8e6uqdUNZqbXhyAvqZYzL+E+19M2rI2PIAGdzfw2ntsRPXiLXKxcx+OYuiPkUI2CbbX+mF335ji7MSuqJ/S34CqOYFoHdZ2QYek8z6F4BRHqsC1h4F6CEY7GXvakvtwNhMWE4mtEEcXSd/UQefttf9o1YdyRDQszCE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OL2N8skO; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OL2N8skO"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4315c1c7392so48441415e9.1
        for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 02:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731407855; x=1732012655; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LA9dViqKYqwFBgszUeA0NVjaCyBCvEgaySoNXwjG8Lo=;
        b=OL2N8skOuwhMMk+kU7cj95WrP8SwOGxE87TyNDa+3zE+O5fNmdxp5JFabaI84bqAIo
         Y645Lw9F1xphu7cdlJ24EsIYFcIuIJIz0jRX/Oar0gDhWCFkc/Lg+10XhUeq3BaRU0l+
         qoypRduUfj7LbE5KU6JPwiXbfz6j3ejussMfePKRRQUalPcFQOskLnsUjocAE1eQoCtM
         su4IO2nH9cmEaZ18VBdyB1IF3SPNZucK2nCE6qedatn4lSDQUmJDbocWU2Fi7UW95z19
         a1TDJ+2AgBNh4I96d6D7GMXeF7HO3/ZkowNiU0UntV74oU/L2kdz828bLQUmLLTd5ESr
         CKIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731407855; x=1732012655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LA9dViqKYqwFBgszUeA0NVjaCyBCvEgaySoNXwjG8Lo=;
        b=FSMQPXOfPcPJYO3mLmqvTARobl+EgyweEWyVvHWjZ2GbJm2FhDAcvazMERyUFewr/3
         Fi2VRkyB6DQYNEO2dqfNUQpdoSOhj5PkhDCKxfr1HLRlLB1OQflOgKviVBoMsiemv5iu
         mNd/JJUInbU7VVYurvx331aL+9YhT8vwzK7n/NNXpO+6qCKY3nnDwI5JVDInTrlpsIm2
         OMiS8mTTaQ6muneFlquhXsF4/FfopYE5fah6cw7dJJmV4cyflmmL2SwF7a09Ye3Oq5H4
         ZUbpjSTcJobNcBb2NKkJyGQPe7ykpfPke5HjldTLDEGjcQKzsX0bkUAr8f/DWO6oXudP
         8BGA==
X-Forwarded-Encrypted: i=1; AJvYcCUPudHxudKdPr6k9LSeAyjIAa3VjQ9ciIUTIaMerdghj3eSm5PmkS2CudEHhd0HAlA3F71/gjU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCz1ix5bOd5nTQ7KQLEdB1QIKv2IE2+jENV59vXm/rAMTXJTwI
	V00nEjy5Q7W72cYo6kKJQnPe2QxGgZFq5KBnyvLrGWc4YhLgm+uCjXtUGr1OW2w=
X-Google-Smtp-Source: AGHT+IEJtm4ivV1htjbZWKRvdvQU4deS33CMMl/XnYQuXPgkmNTFagTge7vJGgMMOIhXkLqCtkpxGQ==
X-Received: by 2002:a05:600c:1e03:b0:431:518a:683b with SMTP id 5b1f17b1804b1-432b7509b0emr146282075e9.18.1731407854903;
        Tue, 12 Nov 2024 02:37:34 -0800 (PST)
Received: from pop-os.. ([145.224.90.214])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432bbf436ffsm142270955e9.44.2024.11.12.02.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 02:37:34 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	coresight@lists.linaro.org,
	kvmarm@lists.linux.dev
Cc: James Clark <james.clark@arm.com>,
	Mark Brown <broonie@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 01/12] arm64/sysreg: Add a comment that the sysreg file should be sorted
Date: Tue, 12 Nov 2024 10:37:00 +0000
Message-Id: <20241112103717.589952-2-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241112103717.589952-1-james.clark@linaro.org>
References: <20241112103717.589952-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Clark <james.clark@arm.com>

There are a few entries particularly at the end of the file that aren't
in order. To avoid confusion, add a comment that might help new entries
to be added in the right place.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/tools/sysreg | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index ed3bf6a0f5c1..a26c0da0c42d 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -48,6 +48,8 @@
 # feature that introduces them (eg, FEAT_LS64_ACCDATA introduces enumeration
 # item ACCDATA) though it may be more taseful to do something else.
 
+# Please try to keep entries in this file sorted by sysreg encoding.
+
 Sysreg	OSDTRRX_EL1	2	0	0	0	2
 Res0	63:32
 Field	31:0	DTRRX
-- 
2.34.1

