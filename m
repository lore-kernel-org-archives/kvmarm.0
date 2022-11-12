Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365A4A23
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 08:01:48 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id z26so6763911pff.1
        for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 00:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j7VZmjwtxmbTDgJG6yNy/NKZz0sCcAw91UAS7XNqqYU=;
        b=bpxwH/fsUWb40bD9Q3Zy01qs7U9eWAv1qNXbpwt51L21rpaRtLIEo8HIrWFdyzP4yL
         /zfNHocVpNHojMyhwgBgHy2szKnLMNF+RPhb9+6X7Mmz1XkrbHeq26Xl+crefpHvPBTj
         VZUOK8XbJ9QmuEWAjz94L45bEGdyvvlB3TEcSpfgnZsYH2lZ+QDrbdn1Y98qdDvq4WQr
         EtbFfoSn9+SDw60SOPYvBtOeI7s2U8ZGPeC2io7bRxTQyUQ6sC57jNdMZlg71ZfjNhQX
         2N5YW0rhU+GzqFbSMwjsYC6AnR7719veX3hI6FTd+js+hw7ZsrZf4vYAG1+uJd18gLmN
         BNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j7VZmjwtxmbTDgJG6yNy/NKZz0sCcAw91UAS7XNqqYU=;
        b=ztAQSZ0rKFGi3wzRc8n1TEUlHOOBqCaRuQ2s+4A1k0+rEv3zp/dOVd6ljtolDizRhZ
         wz6BtD4yimKZCgHtxxSToX6CZvJJAANMxb5/g4l4FPueBpVHl/qAElw4r5eZAkEc7pNt
         mk6y/hYakY79sZCRRKql3xMZl7IvJrhZ7dzNkAm5uw7cyj4CxdY0S4ve7hnc7Hl6eaAW
         k1zebYR0FdwxueY/yqz1JiwejYSHpdVANAk71aLrunLznbekgp7pxGSH3sfV52ezab4q
         tPvDN+vPUVk48xvOK8FPGhH/469TBfzlUYjAPAD4X3M1X0xVKO3GfHi769FhWZFqeS8M
         sdnQ==
X-Gm-Message-State: ANoB5pmyY2W1/6VfxoXW80EgTIcSaEgQpCorpktcSp7aK+K7QNmEuSxA
	OQIkQTJgsVow/tFdSAPTl8R+YD6yE4vWWqySQuuKkw==
X-Google-Smtp-Source: AA0mqf74mZ/Q5PIpOqoIn8jOkWvbTBKBd4IOdrQQX67B9+okXa8HRPAozoxqlNHz6mFBRo8PFEWGE7yhXHYJs+AwBLU=
X-Received: by 2002:a63:4a21:0:b0:46f:d9f:476 with SMTP id x33-20020a634a21000000b0046f0d9f0476mr4521743pga.468.1668240107535;
 Sat, 12 Nov 2022 00:01:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org> <20221028105402.2030192-4-maz@kernel.org>
In-Reply-To: <20221028105402.2030192-4-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Sat, 12 Nov 2022 00:01:31 -0800
Message-ID: <CAAeT=Fxs3ScU8oDtevsuG+7QH7Dyh8Gm0h+m+ibCmaFQ3LfL6w@mail.gmail.com>
Subject: Re: [PATCH v2 03/14] KVM: arm64: PMU: Always advertise the CHAIN event
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221112080131.R3EOI3Vm8cAQra1beF_8u_FC-3XwBI1JOcIJbuOT54Y@z>

On Fri, Oct 28, 2022 at 3:54 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Even when the underlying HW doesn't offer the CHAIN event
> (which happens with QEMU), we can always support it as we're
> in control of the counter overflow.
>
> Always advertise the event via PMCEID0_EL0.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
