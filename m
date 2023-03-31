Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579F9EC3
	for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 08:55:51 +0000 (UTC)
Received: by mail-lf1-f48.google.com with SMTP id g17so28001968lfv.4
        for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 01:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680252949;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4dm+BPEOnC7e4hjDLH6po2CUlQmPHlDI5qtCyO0in2Q=;
        b=h9p+asgoR7hjf3xWGqt0dESGNOGLYImfThLBriNOU0tdhyee4Dj/v82aPxY1l+yshP
         rJxuPxGgYI6jUI6DBjgYqYHHxlm+3k4RYYjQX99sNkOanqarLy2UZMupY9g1Qv7egTfD
         3iQbRP3qKjrBlBC8MLOcVhwBkT2DGC+KDRqi3qP+7TvgmVGRfbMfZRu/AYlQ4SaPljzg
         eKCGp/zIAvGJhIBwkH1RyLPXBc3rwVclVdlHiyQi2cfc80JRI6qtQmM/Tw/rIsAQTfyg
         fAv4m06xtOPLY7yFFiKTKST/6WJIbCvp+KFLiospIbLfJzI44pgopG9eozFO+yO6h/5e
         dQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680252949;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4dm+BPEOnC7e4hjDLH6po2CUlQmPHlDI5qtCyO0in2Q=;
        b=Gs3jX3WS89vip1Tl+gHK0GD86hLV+pLSV3gSujZSz62n06RMvNLBkZU7qcNgvEeVJQ
         u0GP0vL2u/Ii/rIHY2FQ+DXOKpiIwcobx02wti22GSjWwqyzr9NwGfZ9vuXfYT4LYePn
         f05hFDZ48p29NPl8rgJpLFT3rRUFkp0Gmxx3bYWiXfo0TLYtIc7vmECjSN4EmRM4vEP3
         7P61OyYsMCpkeuyx4YWzr28jzADV/VXVhRFolCa9iBFdOxKn/BXPtLKGS/NYHoQ4jJ0u
         U2kaMob/CXnXxp9/GUubDrI1pW0iqcgp5f27s7JBCemLpz6u7B/uG9ZDnKQhKGJjpoZL
         v1Gg==
X-Gm-Message-State: AAQBX9faamQ4NsJbESAXjpyqWT1Qu+2AK6Y9I+v7d/lRmn2X3BSM6qdK
	QZ2Q7rerUheXo3QwbfvaQYDrGQ==
X-Google-Smtp-Source: AKy350ZI/3UGdFSqbHDvzrq0gk2lxo1Tz6xoBuV/VTSFHLt8yiKO4pkQahghPdhIFyzf5V5sRpBGCA==
X-Received: by 2002:a19:f619:0:b0:4d5:831a:1af8 with SMTP id x25-20020a19f619000000b004d5831a1af8mr7934107lfe.40.1680252949296;
        Fri, 31 Mar 2023 01:55:49 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id z9-20020ac25de9000000b004eb2dab8a61sm294109lfq.44.2023.03.31.01.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 01:55:48 -0700 (PDT)
Message-ID: <e28e76e2-f392-44d9-e88c-27c6d26115d0@linaro.org>
Date: Fri, 31 Mar 2023 10:55:46 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH v2 5/6] dt-bindings: cpufreq: add bindings for virtual
 kvm cpufreq
Content-Language: en-US
To: David Dai <davidai@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Sudeep Holla <sudeep.holla@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira
 <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>
Cc: Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
 linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
References: <20230331014356.1033759-1-davidai@google.com>
 <20230331014356.1033759-6-davidai@google.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230331014356.1033759-6-davidai@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 31/03/2023 03:43, David Dai wrote:
> Add devicetree bindings for a virtual kvm cpufreq driver.

Why? Why virtual devices should be documented in DT? DT is for
non-discoverable hardware, right? You have entire commit msg to explain
it instead of saying something easily visible by the diff.

> 
> Co-developed-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: David Dai <davidai@google.com>
> ---
>  .../bindings/cpufreq/cpufreq-virtual-kvm.yaml | 39 +++++++++++++++++++
>  1 file changed, 39 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
> 
> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml b/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
> new file mode 100644
> index 000000000000..31e64558a7f1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
> @@ -0,0 +1,39 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/cpufreq/cpufreq-virtual-kvm.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Virtual KVM CPUFreq
> +
> +maintainers:
> +  - David Dai <davidai@google.com>
> +
> +description: |

Do not need '|'.
> +

Drop stray blank line.

> +  KVM CPUFreq is a virtualized driver in guest kernels that sends utilization
> +  of its vCPUs as a hint to the host. The host uses hint to schedule vCPU
> +  threads and select CPU frequency. It enables accurate Per-Entity Load
> +  Tracking for tasks running in the guest by querying host CPU frequency
> +  unless a virtualized FIE exists(Like AMUs).

No clue why you need DT bindings for this. KVM has interfaces between
host and guests.

> +
> +properties:
> +  compatible:
> +    const: virtual,kvm-cpufreq
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    {

This is some broken syntax and/or indentation.

I don't get what this node is about.

> +      #address-cells = <2>;
> +      #size-cells = <2>;

Why?

> +
> +      cpufreq {
> +            compatible = "virtual,kvm-cpufreq";
> +      };
> +

Drop stray blank lines

> +    };

Best regards,
Krzysztof

