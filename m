Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E26817C7
	for <kvmarm@lists.linux.dev>; Sat,  1 Apr 2023 03:28:25 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id w4so23180762plg.9
        for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 20:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680319704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1aOQ4eYy8N4YCSiaLMCwB/yerXMVOmw3wp9ck3pUmQA=;
        b=Ok8vzWQ0fTWrdQmBekE/vwQkYJaeU+hCLGvU18l6tpgh+LY+guFyw1PCOkt6cTIDi2
         Bi2rSAQ4ZWcSGNL5VXFZfhfY9W+UUMxFc836pBNMtI/YKiNa3lkmWiIeZkq/HOE2i6v1
         CrYVfVRFvUIKsb9OYQYZttYR9+0qI6gi6G2q3B6O6heI5B6NINqaX8Decf4bPIdmgNnw
         OaJfm9V/8H+3AActZ4CZ6pmApo3U2T1Addxc3QfoMJxKRJcGIg7WF89sAh+ZjT4HrCSn
         og13ZG7hFc8Nl0yLoQjtBu0DXS/TVzMXnQhNidB4L5HU73Pr3qRkc91hBgz7qlyfdc9C
         2WzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680319704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1aOQ4eYy8N4YCSiaLMCwB/yerXMVOmw3wp9ck3pUmQA=;
        b=jnDiIcKMlbKaZ5ciLz52VNumgJlkhFQLLvdyj74X8hXtJLgCZKG0igxy2vH9LmTzgz
         OvDa27fU+DkHY6/JU2vy+yn1cKRvYlVEgq51dDpITrShQ+N3lu+9FMISJPpaFI7oIR4X
         fjsFJUCdtilRdo3Y6jNuHf9veWt6IUCHPtCKE5lY7mRoasldJ4dFxsB3CFBkVBK0hhEp
         ps8fWN7XQykljMFGQ4utpdNWFnWPcyFbaxxIWtk55moQYRrY6YBDwULb3lLHX3G8fm88
         MAcQI6d2w170uheSz5QIHQ/lrGY6rqDqiCHqpbTJGQaQUhhoX2RHUvCUS6mQHdnvgqCU
         2Vxg==
X-Gm-Message-State: AAQBX9dvb6FIQxHP7UPwANZR6NkqEynkQPxzO5jWPSsod3BwP0F+sNyL
	rp2RrbF5yo0WswUmxxG4PN8=
X-Google-Smtp-Source: AKy350Yoi20kGNomZnY7Fh4bdxg2fFhnur0eeEf88TS9IaTsvuK0id2OfKq0eADwsFcWp5pRxAwcFg==
X-Received: by 2002:a17:902:f683:b0:1a0:7156:f8d1 with SMTP id l3-20020a170902f68300b001a07156f8d1mr37983907plg.19.1680319704568;
        Fri, 31 Mar 2023 20:28:24 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-71.three.co.id. [180.214.232.71])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902ab8600b001a1f5dc64e5sm2271330plr.177.2023.03.31.20.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 20:28:24 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id CC3F510677D; Sat,  1 Apr 2023 10:28:21 +0700 (WIB)
Date: Sat, 1 Apr 2023 10:28:21 +0700
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
Subject: Re: [RFC PATCH v2 4/6] kvm: arm64: Add support for get_freqtbl
 service
Message-ID: <ZCek1YOmg99d6l9A@debian.me>
References: <20230331014356.1033759-1-davidai@google.com>
 <20230331014356.1033759-5-davidai@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230331014356.1033759-5-davidai@google.com>

On Thu, Mar 30, 2023 at 06:43:48PM -0700, David Dai wrote:
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 38ce33564efc..8f905456e2b4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8400,6 +8400,14 @@ after normalizing for architecture. This is useful when guests are tracking
>  workload on its vCPUs. Util hints allow the host to make more accurate
>  frequency selections and task placement for vCPU threads.
>  
> +8.42 KVM_CAP_GET_CPUFREQ_TBL
> +---------------------------
> +
> +:Architectures: arm64
> +
> +This capability indicates that the KVM supports getting the
> +frequency table of the current CPU that the vCPU thread is running on.
> +
>  9. Known KVM API problems
>  =========================
>  
> diff --git a/Documentation/virt/kvm/arm/get_freqtbl.rst b/Documentation/virt/kvm/arm/get_freqtbl.rst
> new file mode 100644
> index 000000000000..f6832d7566e7
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/get_freqtbl.rst
> @@ -0,0 +1,23 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +get_freqtbl support for arm/arm64
> +=============================
> +
> +Allows guest to query the frequency(in KHz) table of the current CPU that
> +the vCPU thread is running on.
> +
> +* ARM_SMCCC_VENDOR_HYP_KVM_GET_CPUFREQ_TBL_FUNC_ID: 0x86000042
> +
> +This hypercall uses the SMC32/HVC32 calling convention:
> +
> +ARM_SMCCC_VENDOR_HYP_KVM_GET_CPUFREQ_TBL_FUNC_ID
> +    ==============    ========    =====================================
> +    Function ID:      (uint32)    0x86000042
> +    Arguments:        (uint32)    index of the current CPU's frequency table
> +    Return Values:    (int32)     NOT_SUPPORTED(-1) on error, or
> +                      (uint32)    Frequency table entry of requested index
> +                                  in KHz
> +                                  of current CPU(r1)
> +    Endianness:                   Must be the same endianness
> +                                  as the host.
> +    ==============    ========    =====================================

Sphinx reports htmldocs warnings:
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/api.rst:8404: WARNING: Title underline too short.

8.42 KVM_CAP_GET_CPUFREQ_TBL
---------------------------
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/api.rst:8404: WARNING: Title underline too short.

8.42 KVM_CAP_GET_CPUFREQ_TBL
---------------------------
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/arm/get_freqtbl.rst:4: WARNING: Title underline too short.

get_freqtbl support for arm/arm64
=============================

I have applied the fixup:

---- >8 ----
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index baf8a4c43b5839..3579c470375938 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8401,7 +8401,7 @@ workload on its vCPUs. Util hints allow the host to make more accurate
 frequency selections and task placement for vCPU threads.
 
 8.42 KVM_CAP_GET_CPUFREQ_TBL
----------------------------
+----------------------------
 
 :Architectures: arm64
 
diff --git a/Documentation/virt/kvm/arm/get_freqtbl.rst b/Documentation/virt/kvm/arm/get_freqtbl.rst
index f6832d7566e7e5..215bf0f653e461 100644
--- a/Documentation/virt/kvm/arm/get_freqtbl.rst
+++ b/Documentation/virt/kvm/arm/get_freqtbl.rst
@@ -1,7 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
 get_freqtbl support for arm/arm64
-=============================
+=================================
 
 Allows guest to query the frequency(in KHz) table of the current CPU that
 the vCPU thread is running on.

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
