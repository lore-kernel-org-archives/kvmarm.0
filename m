Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB6115A3
	for <kvmarm@lists.linux.dev>; Sat,  1 Apr 2023 03:12:20 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id ix20so23195068plb.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 20:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680318739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GMsqA2/S4acnYNFGSszhcxD2t1ID/uK62fRiA76JiBA=;
        b=izzE5BwTcnLtWXiLFvb1b1GiNKSO8qGbitdSPuU2w3doJeL1SXvD/0YcRCbyPbSHd0
         LJwJSLBiDslPaI69lmy9Y/1xjuqTF2IXhiJ8wNO0q2bY7aTUTx/B/sgRoZFeuoGkJ6wA
         rNdMRDFWVWTizj4ktebC7jnALxztJWSYdPqf2/gQSMTizk+5ibKtsgavvHVVIoewpNJT
         fsfUbERSIZUx5xKiNwnld9prEvcpmyju0cY2+8iMbiB9tuZCpC6ZGmadcu0dWe3w5hyx
         2hhXx2L3psFIFJb0tN83ePDQsMHg7eNPqt3ZzfYzibSAlBikvflC3XtoU4IgYDVIoPzb
         1dJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680318739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMsqA2/S4acnYNFGSszhcxD2t1ID/uK62fRiA76JiBA=;
        b=zpOrOFPGFUWUUZnjs9ww+xylJ8/xGvKPHIbfZq8HQ04z46R7vU9Z5vL1ehayJZPGU/
         LWWDl2HiTmidTuhd08xBRXPlG7SczyPc1G5Foz0+j3LCcKKSv86jMiW7FQhlOnWApXFh
         IkZ/hOnwkEVbnHgH+5R3Y/xYUcP0GEjD0XsEKV0ZLqAtR1nAjuL2xTjgXuibXidTYyWQ
         Hdsl0AqEvghNtoXKW6vJuOcrw5qTBAR3AkHTlJ7edL1n/sM0rFnUwEjcGDcTJb1iWFZ3
         Ll5M/mOOXw3ngfdrVes8THI8Kg+tcSlurOhz0DPYKMMXf55eG3EX/pIIJceAN5SkH5SE
         sNfw==
X-Gm-Message-State: AAQBX9c7w+UY65eiucSIitRPvgKgaICf5s3gFXkunXZTNMEcvh3atdED
	p5b9TN7HWyOXCsw2swZnKRw=
X-Google-Smtp-Source: AKy350bPTa+6wCaLlfIe0t8Z/dZpxNsv/Fw1CdcxoSM2Sy7O3EUGDsMbmYmRcGqE3Vk4WsBjOQymQA==
X-Received: by 2002:a17:902:fa43:b0:1a1:a8db:495d with SMTP id lb3-20020a170902fa4300b001a1a8db495dmr22990145plb.4.1680318739546;
        Fri, 31 Mar 2023 20:12:19 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-71.three.co.id. [180.214.232.71])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b0019f789cddccsm2292207pll.19.2023.03.31.20.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 20:12:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 31AA4101622; Sat,  1 Apr 2023 10:12:15 +0700 (WIB)
Date: Sat, 1 Apr 2023 10:12:15 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: David Dai <davidai@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>
Cc: Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
	linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH v2 2/6] kvm: arm64: Add support for get_cur_cpufreq
 service
Message-ID: <ZCehD15QJyDapG3u@debian.me>
References: <20230331014356.1033759-1-davidai@google.com>
 <20230331014356.1033759-3-davidai@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230331014356.1033759-3-davidai@google.com>

On Thu, Mar 30, 2023 at 06:43:46PM -0700, David Dai wrote:
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 62de0768d6aa..b0ff0ad700bf 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8380,6 +8380,14 @@ structure.
>  When getting the Modified Change Topology Report value, the attr->addr
>  must point to a byte where the value will be stored or retrieved from.
>  
> +8.40 KVM_CAP_GET_CUR_CPUFREQ
> +------------------------
> +
> +:Architectures: arm64
> +
> +This capability indicates that KVM supports getting the
> +frequency of the current CPU that the vCPU thread is running on.
> +
>  9. Known KVM API problems
>  =========================
>  
> diff --git a/Documentation/virt/kvm/arm/get_cur_cpufreq.rst b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
> new file mode 100644
> index 000000000000..06e0ed5b3868
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
> @@ -0,0 +1,21 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +get_cur_cpufreq support for arm/arm64
> +=============================
> +
> +Get_cur_cpufreq support is used to get current frequency(in KHz) of the
> +current CPU that the vCPU thread is running on.
> +
> +* ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID: 0x86000040
> +
> +This hypercall uses the SMC32/HVC32 calling convention:
> +
> +ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID
> +    ==============    ========    =====================================
> +    Function ID:      (uint32)    0x86000040
> +    Return Values:    (int32)     NOT_SUPPORTED(-1) on error, or
> +                      (uint32)    Frequency in KHz of current CPU that the
> +                                  vCPU thread is running on.
> +    Endianness:                   Must be the same endianness
> +                                  as the host.
> +    ==============    ========    =====================================

Sphinx reports htmldocs warnings:
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/api.rst:8384: WARNING: Title underline too short.

8.40 KVM_CAP_GET_CUR_CPUFREQ
------------------------
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/api.rst:8384: WARNING: Title underline too short.

8.40 KVM_CAP_GET_CUR_CPUFREQ
------------------------
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/api.rst:8404: WARNING: Title underline too short.

I have applied the fixup:

---- >8 ----
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8f905456e2b4a1..baf8a4c43b5839 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8381,7 +8381,7 @@ When getting the Modified Change Topology Report value, the attr->addr
 must point to a byte where the value will be stored or retrieved from.
 
 8.40 KVM_CAP_GET_CUR_CPUFREQ
-------------------------
+----------------------------
 
 :Architectures: arm64
 
diff --git a/Documentation/virt/kvm/arm/get_cur_cpufreq.rst b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
index 06e0ed5b3868d7..76f112efb99f92 100644
--- a/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
+++ b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
@@ -11,11 +11,12 @@ current CPU that the vCPU thread is running on.
 This hypercall uses the SMC32/HVC32 calling convention:
 
 ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID
-    ==============    ========    =====================================
+
+    ==============    ========    ========================================
     Function ID:      (uint32)    0x86000040
     Return Values:    (int32)     NOT_SUPPORTED(-1) on error, or
                       (uint32)    Frequency in KHz of current CPU that the
                                   vCPU thread is running on.
     Endianness:                   Must be the same endianness
                                   as the host.
-    ==============    ========    =====================================
+    ==============    ========    ========================================

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
