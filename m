Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E71B122AD
	for <kvmarm@lists.linux.dev>; Mon,  7 Nov 2022 19:48:35 +0000 (UTC)
Received: by mail-oi1-f177.google.com with SMTP id l127so13300860oia.8
        for <kvmarm@lists.linux.dev>; Mon, 07 Nov 2022 11:48:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pC3VraCs8s6YEvpVTV0I2PtrYdEY09JJSU0EEtgPIig=;
        b=kqhX2QLlatai23P/+HcYID8dQfod4FlGiEpnKlITXffShFnz6f6YX35DD+FuX8Yh1s
         SGX5YX4ILjqvQPeQsdDLb+15j+lX73YSya3mLMRfR6X19IRRBlemVN6UJioXgdPMv1zB
         6BkqYh5WBEUruV3vpb/y02UKkSHYLT8fUb1JMziEX8z0i4e+D2K1Ki6mq84YJ6F+K+IC
         Q6ZqdJBmA7EVAmHvNXAjKZY9VZZCod1YVskkqasHgtGjmu+EhHjzwnhI1BkR/teI04Yp
         nBpdsT7jPGxRKErcNbxFfu67Has+WfSGGEx9pvKATG1doUM5ap8lbjYqn9OW/4xJkRM5
         knwA==
X-Gm-Message-State: ACrzQf0i0eATNmMSQbR9omB3KCODMEmP+O85zM7wWchLSTpEl5KEIN0Q
	N5+/EOqNIUaV88/SGfgfeXwOXdECEotxjim2tdQ=
X-Google-Smtp-Source: AMsMyM4Z/18xRjOjvwABmJlezj2L/eczEI73izOERN6BTvW3w6fEqYeDeoy80slhhl69ZKNf1gn6csGrVR6G4/dsA4Q=
X-Received: by 2002:aca:2805:0:b0:359:e340:d53 with SMTP id
 5-20020aca2805000000b00359e3400d53mr26615294oix.209.1667850515046; Mon, 07
 Nov 2022 11:48:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org> <20220825-arm-spe-v8-7-v3-8-87682f78caac@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v3-8-87682f78caac@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 7 Nov 2022 11:48:23 -0800
Message-ID: <CAM9d7ciYabTpo0q5Z8h229dZ+RXG7JP1zgOoR1fgdZZCH87vow@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] perf: arm_spe: Add support for SPEv1.2 inverted
 event filtering
To: Rob Herring <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Ingo Molnar <mingo@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	James Clark <james.clark@arm.com>, Mark Brown <broonie@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221107194823.YMs53i9pmf_0FhdStqi17RuO2tIcMpDokAcGtquESCI@z>

Hello,

On Fri, Nov 4, 2022 at 8:55 AM Rob Herring <robh@kernel.org> wrote:
>
> Arm SPEv1.2 (Arm v8.7/v9.2) adds a new feature called Inverted Event
> Filter which excludes samples matching the event filter. The feature
> mirrors the existing event filter in PMSEVFR_EL1 adding a new register,
> PMSNEVFR_EL1, which has the same event bit assignments.

Just out of curiosity, is it possible to have the event filter and
inverted filter at the same time?  What if they have the same?

Thanks,
Namhyung

>
> Tested-by: James Clark <james.clark@arm.com>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> v3:
>  - No change
> v2:
>  - Update for auto generated register defines
>  - Avoid accessing SYS_PMSNEVFR_EL1 on < v8.7
> ---
