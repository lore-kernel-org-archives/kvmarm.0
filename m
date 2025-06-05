Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F5524BD1F
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749120617; cv=none; b=bWQFK85CfeUWDxDi53OzdQd4sPV+Vit2oyV1ULcsw/h8WdiUjyEOk/+z9DayhCPS7F7akyIGJFTuVzNt3i+QvUOWVKZpUV9VZNCBnsInbIEcp8ii9XRPz3rccMjDU6bZgPbpSV3OtGizjHUmsPX4SEEz5FRHKhW+9uTTvzVCqnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749120617; c=relaxed/simple;
	bh=XeTbgg1YCZhnU/IzLKbCe1re6NeCWvfz3HX4Zc0ZwHU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mMSZXB6VvYWfBR39fuIU3CKfgoL3RhQY41LULXNUUkDJdbx61ypF8fyALc94SB/UxWy4g4N/eFojge7Py3ipQrPiBQ5EOOPu6J+sXRy6XJOOgFXDDotEorKCs0f2pRpZMrMSSqbWHubvRRd/ELw1egp9WKCrb0o3UiI4JSbt+mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PS33KD02; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PS33KD02"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so9300535e9.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749120613; x=1749725413; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l6klp9EUNzNQb89anQF9S8nNJOTrH6bgf7Ht0lN5b5Y=;
        b=PS33KD02B0BiG0/TOoO6L62JNXz42wPVr+nAU6/LjzKy29nagLmW++vFzESKbf2lZp
         vFHj3Z61Gn5lRYBAFfikDbmOjmRUThoLjNJzIjoFapgEBmFmNtSdzECV8jhvyZZ2c15l
         l57VvLnIXanIbZD2W7ToJE4ZUdeS+ZuXa+M4TOAMgPoxU38eK6zDNqfO0grIfav52N7s
         +jEqJNG6jHs4h/OIehtLXWm3cmihYMBs7yoovlca9p2qRbesAPDpAadcsr9mdw9EJCDc
         GzyVOUEHZL6uaQQE7Iy25sJCEBhBkcsV2SiyZYE4bRePI7Y4IFXuTPVDKaKoTmAtc1Sc
         b6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749120613; x=1749725413;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l6klp9EUNzNQb89anQF9S8nNJOTrH6bgf7Ht0lN5b5Y=;
        b=us7m+wBslibNZv+Y5FNg2cbxpSWDg3L+qFHCrOKBk51eUP05PQ/4vpxn+Dm/K1tosP
         KgA8eqNbGaJyVxJXEmXJ0boCCcx8CY158A4ZNREOR17DObFeNXOVL6GxqoRKtbAAGclr
         Oo24TXefaw+Gf/g+tiPpZ3XpneYhRq+JkVjQ74kMSqLChfoGeZDh5ETlcli1r1rWyKUu
         6/IrqdMgxDmiqj44G8RvEyRZWsBXZkX5+XO56HeaEBXNsVIpDy6RGZHSoVqNuUb2qJ+Z
         7EsUC0CGC8oU0k/Vq43O6jInP/06WzXPaIQ3pqvNSZNue0UkIBkMZ74ccPXdzuZurocs
         0Xrw==
X-Forwarded-Encrypted: i=1; AJvYcCXJ6rFPcuXH4XEqYlFRZy3sm9BpsXFiWr86bRD8jCiPppsh/NFBNrpDDQtw5Sy+NwrVlpR+ANY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJK1IHdYjr3rUqNw62VcysbKUI4B5KdBVFNY9ARB4uL4xHVctj
	njsSj0HIqpwJbqV9aIXL5Qz/3Yhc4h3TVCZ9q8cau+e2yu82ye44Ys6j0N9QIEuLFpo=
X-Gm-Gg: ASbGnctMRZ1gOXzTaU/7IFL5+Yi2lm7mf/4aK7/uuUcM2oeR0alwzEaexdBDg5UzfYi
	vEFQygNU6ZEOD+xLhimyucMWTW6wQPYqM974YVoGK+TUu2gb+ehRzbxliXQNQxI8UjRR6QXRR3k
	J/tdNIi9aJZIkZYGyQLSqiEn6nfSn8Mf7tSmiD4BxG8ciBj2kSwCJzc020cT95qse92B5HtcVmI
	Cv/X0W3OhpL6Vubo14+8LxDmYG9BrOPOhMofZJMiPwea2Wsa4ByjqNYoTorBxtw93CBu8jiJZ9F
	wDRJ7fJvaUIcy7hibUOo1TGQMKu3l0baIoCARXgG1BMCHA85nLbdAnUNab67MkLQ4knqjYg=
X-Google-Smtp-Source: AGHT+IH02Sm8uYqylsDIHsGX3ZEWWx30EqeNhSMG+4n8yfcZZZ5mpZsxJSCawBIvfoWGFHbxRM6qAw==
X-Received: by 2002:adf:e38c:0:b0:3a5:2670:e220 with SMTP id ffacd0b85a97d-3a52670e28dmr2309297f8f.32.1749120613386;
        Thu, 05 Jun 2025 03:50:13 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f990cfe3sm20629965e9.23.2025.06.05.03.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:50:13 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Jun 2025 11:49:06 +0100
Subject: [PATCH v3 08/10] tools headers UAPI: Sync linux/perf_event.h with
 the kernel sources
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250605-james-perf-feat_spe_eft-v3-8-71b0c9f98093@linaro.org>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

To pickup config4 changes.

Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 tools/include/uapi/linux/perf_event.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/uapi/linux/perf_event.h b/tools/include/uapi/linux/perf_event.h
index 78a362b80027..0d0ed85ad8cb 100644
--- a/tools/include/uapi/linux/perf_event.h
+++ b/tools/include/uapi/linux/perf_event.h
@@ -382,6 +382,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER6			120	/* Add: aux_sample_size */
 #define PERF_ATTR_SIZE_VER7			128	/* Add: sig_data */
 #define PERF_ATTR_SIZE_VER8			136	/* Add: config3 */
+#define PERF_ATTR_SIZE_VER9			144	/* add: config4 */
 
 /*
  * 'struct perf_event_attr' contains various attributes that define
@@ -543,6 +544,7 @@ struct perf_event_attr {
 	__u64	sig_data;
 
 	__u64	config3; /* extension of config2 */
+	__u64	config4; /* extension of config3 */
 };
 
 /*

-- 
2.34.1

