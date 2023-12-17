Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B59ED8
	for <kvmarm@lists.linux.dev>; Sun, 17 Dec 2023 02:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J3piIZ0i"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6d9f069e9b0so1709278a34.3
        for <kvmarm@lists.linux.dev>; Sat, 16 Dec 2023 18:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702779161; x=1703383961; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=ZU4udhAe9yRwJhQWBqF+GjdBA5/uiRNgWqIJoHsE7co=;
        b=J3piIZ0iN1U/EC9Ts2WdFaLvs6XX6wkqZ/cGjg40myv3+e1ywNCgHDDRcRc8Qrxqq2
         9mBJQFtHY1vgO64umhg6azkFH31jMvqjWgyJs32v7WefS6LHw54snEQq4VVHq6wahWEV
         KWt513xJvbXk3w4zrqzCfHdSNuF0Sa4L+s0Mm6pAmn04BCVA7UK/k35cwxn1QpGJWd6p
         tgYFMoINJIdxrPGQCBlpU3I+whScEOZMKMzhNupKjq4NCKr+LbNdIe2ezwIa+iLur0XK
         AYeVUYfgW/9nGrkugQTPtDQ2iAOWcd0DLDu9lwEsyAl4cv5c5KnJTI1jLDr0Jzv03feR
         Fdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702779161; x=1703383961;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZU4udhAe9yRwJhQWBqF+GjdBA5/uiRNgWqIJoHsE7co=;
        b=Z+//B05SIJgnZN/ydr18BfQpjkAqa5tU2sBy64PlDHxENgfpk02ptg+I/D+17PkfTN
         470sdaPYQC/vG5BzQi3Wm/d/ovUJoGgYPriOwDH4q3kVk/FCkag8ZF5DlgSVoqlLxLyj
         GEnLao9ILn+mz+pVB0wOGA9wihjHbXC+teIkXVzLdWhJcC/cl96Gq2uR7v3stlu3XjE2
         +bjO/EOP7RKVL1rby2wP5kqX3xFjQkclNCfFuCEehJ/yhaLvNWT0dUobWXCy26NYGVG2
         Ha3Jq6pSqnB3C8q931fHFFMWX0cZJ0E58dzjqZvPuASRSGtDKv9NPs8HsfjZnmQagvJq
         IhEw==
X-Gm-Message-State: AOJu0YyT9TzBDPvRftDvUAFR/HOvxhw09MWwzCGKYYCwtP5pxkHgclpf
	OHcNzLmNrlpUxzupS62R7U5s1Q==
X-Google-Smtp-Source: AGHT+IF6d0b9WINtfrmG2vZvKrSnvlJEjZ4mHUhu7B/LaY8JjOvAXCc/5DohR5MVIJGhP2NUssRkGA==
X-Received: by 2002:a05:6808:128b:b0:3b9:dd5e:86f2 with SMTP id a11-20020a056808128b00b003b9dd5e86f2mr19868232oiw.13.1702779160745;
        Sat, 16 Dec 2023 18:12:40 -0800 (PST)
Received: from localhost ([2804:14d:7e39:8470:a30f:cc0e:7239:16c3])
        by smtp.gmail.com with ESMTPSA id f10-20020a170902e98a00b001d39ac5cbf7sm1784886plb.201.2023.12.16.18.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 18:12:40 -0800 (PST)
References: <20231122-arm64-gcs-v7-0-201c483bd775@kernel.org>
 <20231122-arm64-gcs-v7-36-201c483bd775@kernel.org>
User-agent: mu4e 1.10.8; emacs 29.1
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton
 <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>, Oleg
 Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees
 Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, "Rick P.
 Edgecombe" <rick.p.edgecombe@intel.com>, Deepak Gupta
 <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, Szabolcs Nagy
 <Szabolcs.Nagy@arm.com>, "H.J. Lu" <hjl.tools@gmail.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Florian Weimer <fweimer@redhat.com>, Christian
 Brauner <brauner@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v7 36/39] selftests/arm64: Add GCS signal tests
In-reply-to: <20231122-arm64-gcs-v7-36-201c483bd775@kernel.org>
Date: Sat, 16 Dec 2023 23:12:37 -0300
Message-ID: <875y0x7f1m.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Mark Brown <broonie@kernel.org> writes:

> diff --git a/tools/testing/selftests/arm64/signal/testcases/gcs_exception_fault.c b/tools/testing/selftests/arm64/signal/testcases/gcs_exception_fault.c
> new file mode 100644
> index 000000000000..532d533592a1
> --- /dev/null
> +++ b/tools/testing/selftests/arm64/signal/testcases/gcs_exception_fault.c
> @@ -0,0 +1,59 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023 ARM Limited
> + */
> +
> +#include <errno.h>
> +#include <signal.h>
> +#include <unistd.h>
> +
> +#include <sys/mman.h>
> +#include <sys/prctl.h>
> +
> +#include "test_signals_utils.h"
> +#include "testcases.h"
> +
> +/* This should be includable from some standard header, but which? */
> +#ifndef SEGV_CPERR
> +#define SEGV_CPERR 10
> +#endif

One suggestion is include/uapi/asm-generic/siginfo.h. It already has
SEGV_MTEAERR and SEGV_MTESERR, as well as si_codes specific to other
arches.

From there, it should find its way to glibc's
sysdeps/unix/sysv/linux/bits/siginfo-consts.h.

> +static int gcs_regs(struct tdescr *td, siginfo_t *si, ucontext_t *uc)
> +{
> +	size_t offset;
> +	struct _aarch64_ctx *head = GET_BUF_RESV_HEAD(context);
> +	struct gcs_context *gcs;
> +	unsigned long expected, gcspr;
> +	int ret;
> +
> +	ret = prctl(PR_GET_SHADOW_STACK_STATUS, &expected, 0, 0, 0);
> +	if (ret != 0) {
> +		fprintf(stderr, "Unable to query GCS status\n");
> +		return 1;
> +	}
> +
> +	/* We expect a cap to be added to the GCS in the signal frame */
> +	gcspr = get_gcspr_el0();
> +	gcspr -= 8;
> +	fprintf(stderr, "Expecting GCSPR_EL0 %lx\n", gcspr);
> +
> +	if (!get_current_context(td, &context.uc, sizeof(context))) {
> +		fprintf(stderr, "Failed getting context\n");
> +		return 1;
> +	}

At this point, before any function call is made, can the test check that
*(gcspr + 8) == 0? This would detect the issue I mentioned in
patch 24 of gcs_restore_signal() not zeroing the location of the cap.

> +	fprintf(stderr, "Got context\n");
> +
> +	head = get_header(head, GCS_MAGIC, GET_BUF_RESV_SIZE(context),
> +			  &offset);
> +	if (!head) {
> +		fprintf(stderr, "No GCS context\n");
> +		return 1;
> +	}
> +
> +	gcs = (struct gcs_context *)head;
> +
> +	/* Basic size validation is done in get_current_context() */
> +
> +	if (gcs->features_enabled != expected) {
> +		fprintf(stderr, "Features enabled %llx but expected %lx\n",
> +			gcs->features_enabled, expected);
> +		return 1;
> +	}
> +
> +	if (gcs->gcspr != gcspr) {
> +		fprintf(stderr, "Got GCSPR %llx but expected %lx\n",
> +			gcs->gcspr, gcspr);
> +		return 1;
> +	}

I suggest adding a new check here to ensure that gcs->reserved == 0.

> +	fprintf(stderr, "GCS context validated\n");
> +	td->pass = 1;
> +
> +	return 0;
> +}
> +
> +struct tdescr tde = {
> +	.name = "GCS basics",
> +	.descr = "Validate a GCS signal context",
> +	.feats_required = FEAT_GCS,
> +	.timeout = 3,
> +	.run = gcs_regs,
> +};
> diff --git a/tools/testing/selftests/arm64/signal/testcases/gcs_write_fault.c b/tools/testing/selftests/arm64/signal/testcases/gcs_write_fault.c
> new file mode 100644
> index 000000000000..126b1a294a29
> --- /dev/null
> +++ b/tools/testing/selftests/arm64/signal/testcases/gcs_write_fault.c
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023 ARM Limited
> + */
> +
> +#include <errno.h>
> +#include <signal.h>
> +#include <unistd.h>
> +
> +#include <sys/mman.h>
> +#include <sys/prctl.h>
> +
> +#include "test_signals_utils.h"
> +#include "testcases.h"
> +
> +static uint64_t *gcs_page;
> +
> +#ifndef __NR_map_shadow_stack
> +#define __NR_map_shadow_stack 452
> +#endif
> +
> +static bool alloc_gcs(struct tdescr *td)
> +{
> +	long page_size = sysconf(_SC_PAGE_SIZE);
> +
> +	gcs_page = (void *)syscall(__NR_map_shadow_stack, 0,
> +				   page_size, 0);
> +	if (gcs_page == MAP_FAILED) {
> +		fprintf(stderr, "Failed to map %ld byte GCS: %d\n",
> +			page_size, errno);

This call is failing with EINVAL for me:

# timeout set to 45
# selftests: arm64/signal: gcs_write_fault
# # GCS write fault :: Normal writes to a GCS segfault
# Registered handlers for all signals.
# Detected MINSTKSIGSZ:4720
# Required Features: [ GCS ] supported
# Incompatible Features: [] absent
# Failed to map 4096 byte GCS: 22
# FAILED Testcase initialization.
# ==>> completed. FAIL(0)
not ok 11 selftests: arm64/signal: gcs_write_fault # exit=1

> +		return false;
> +	}
> +
> +	return true;
> +}

-- 
Thiago
