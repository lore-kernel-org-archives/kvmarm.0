Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004B8258B
	for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 12:42:16 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-17ab3a48158so23037679fac.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 05:42:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680266536;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=beHNZoTWpfe1Iychh8E+2Pd1ABXoxogRlM+B8js6fxY=;
        b=7Uv4FLfEO71RTFT8Hc69+VQLoWdTS6CdGHWuehtdooDNBe1dSC+Ma/LY4Pl7p3xnl3
         IZsFRbbCSeJl/5dU2P9iUYb7Yej5s0OE8/EQ/dq0i6y+nqkuoc09FdWDAmuQL/xJyGVO
         EF7pgEr6ttni5IHjivQFkx7jeONXLtzCafW9vI10EtSef+x50JoAYMKAYr4Lqkm23CZP
         OGu+Srtp/2fDrF+n03AbdNwDCAzrhIYRh//yfoB/c/MNO2wO5/xEQG5wmhwEGTtHVOKT
         ub585H4jd+D1TxHbTPrPNY6eQx0Tk6lV9YCD516OT1d93MTTntFCDtRs9L2bIaAIiREn
         gsWQ==
X-Gm-Message-State: AAQBX9cSc9qGfJHtiE6pRk8PWsw6y0Np08t1E9HjukvOtVVpMowzNTfV
	O6k39VAyhcq4Tq1fh+jLQg==
X-Google-Smtp-Source: AKy350aZVWt7V5ZjS97pTxzJSN9yyHjuZdEBpdJxg6kf08veWsSig9HeD3mfdM5vIOgkoKYCiH1xbw==
X-Received: by 2002:a05:6870:8a0d:b0:17a:ce6b:72c with SMTP id p13-20020a0568708a0d00b0017ace6b072cmr15564322oaq.51.1680266535933;
        Fri, 31 Mar 2023 05:42:15 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id kw17-20020a056870ac1100b001802d3e181fsm902270oab.14.2023.03.31.05.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 05:42:15 -0700 (PDT)
Received: (nullmailer pid 690279 invoked by uid 1000);
	Fri, 31 Mar 2023 12:42:14 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Rob Herring <robh@kernel.org>
To: David Dai <davidai@google.com>
Cc: linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	linux-pm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Saravana Kannan <saravanak@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Sudeep Holla <sudeep.holla@arm.com>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Valentin Schneider <vschneid@redhat.com>, 
	James Morse <james.morse@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org, devicetree@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Daniel Bristot de Oliveira <bristot@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Will Deacon <will@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	kvmarm@lists.linux.dev
In-Reply-To: <20230331014356.1033759-6-davidai@google.com>
References: <20230331014356.1033759-1-davidai@google.com>
 <20230331014356.1033759-6-davidai@google.com>
Message-Id: <168026628573.685196.6713450502150551916.robh@kernel.org>
Subject: Re: [RFC PATCH v2 5/6] dt-bindings: cpufreq: add bindings for
 virtual kvm cpufreq
Date: Fri, 31 Mar 2023 07:42:14 -0500


On Thu, 30 Mar 2023 18:43:49 -0700, David Dai wrote:
> Add devicetree bindings for a virtual kvm cpufreq driver.
> 
> Co-developed-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: David Dai <davidai@google.com>
> ---
>  .../bindings/cpufreq/cpufreq-virtual-kvm.yaml | 39 +++++++++++++++++++
>  1 file changed, 39 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.example.dts:18.9-10 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:419: Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.example.dtb] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1512: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230331014356.1033759-6-davidai@google.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

