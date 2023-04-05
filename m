Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EAD7FC
	for <kvmarm@lists.linux.dev>; Wed,  5 Apr 2023 08:04:26 +0000 (UTC)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-947cd8b2de3so31871266b.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Apr 2023 01:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680681864; x=1683273864;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1qeWL9csSccLs6fLdE0uQkmoTpVTl/CNeE7DAxN2MXc=;
        b=Xhq2FpN6Mn9U+EjSMWm81/rOkL0bCFC+/2wjeKRsitvqUzxRSPfp9fuoLeyBFssxEy
         uDCSbz1YbvYjEPswqb3S2GTeD5WrMfOxja6ExrIKkGQLeADhlgbB7YOPra4MuzjHMrmj
         ZXdFh+JVuRGjSQyYZanQX5QlEVziDHiVidIiylGL7f0MyJUhqMsMEyHDcOQ7gNiV1wC+
         ahUaXralaKBaRSz4fOK+iGVNv27U4eaNu+zC6QxXTv6Jps/OaYMBUjv3ab9gY0hKw4g7
         NAydS21zEz4TOSL9DVk3uvDj3K8Lk9ct3FFtJCd1yGfrC7kCaSATBwW4q2DaUE7YXwsp
         DLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680681864; x=1683273864;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qeWL9csSccLs6fLdE0uQkmoTpVTl/CNeE7DAxN2MXc=;
        b=zYzyrtOfRCwZgcKFgIeccCJCHWLBSW9d8NoMCXhHl9KmtJRDncjVrC40D8y0CE0rmB
         6Tt/K1GsmXfhY5VUJpPww0zhKYIVUTz4RIjdWldwUlzqfw4qmH+CsKNJy/+iYtflSvqz
         UnxyzqVhYWh+x8pR3WBDGdIAgak6cuo9cmSSiEltSpjgRjApPslLr+F3NxOd6mpr2qFB
         uVuddgLOh58kA++DfTlsnRV+DyxXP4I0D4I/E4p2K9BCjqdLXyos1faZdky1e/I8eGWh
         Y3FnA3t4fN9HJ8ZeweAJvJttahMsXbAUkA3lRgXU0f7SwD2iutyNg6skihB9tndiqBOz
         SGtQ==
X-Gm-Message-State: AAQBX9ezZSZX5oSaIuZChiffIZap2TnTHQ39CCxNuyYM6TAdIB6zYn5b
	AMjCV3jID7LmOrqSh82snsjXYA==
X-Google-Smtp-Source: AKy350bF5rLJogTrsY1f6blQnOqzcwkAlbB5v+pmHg+Ta3p4lfp6J5hb3yzzRk5ijVMDrTT8n0Y6cA==
X-Received: by 2002:a05:6402:2026:b0:4fd:2533:f56 with SMTP id ay6-20020a056402202600b004fd25330f56mr1005988edb.39.1680681864506;
        Wed, 05 Apr 2023 01:04:24 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id a65-20020a509ec7000000b004fbf6b35a56sm6955177edf.76.2023.04.05.01.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 01:04:23 -0700 (PDT)
Date: Wed, 5 Apr 2023 08:04:20 +0000
From: Quentin Perret <qperret@google.com>
To: David Dai <davidai@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH 2/6] kvm: arm64: Add support for get_cur_cpufreq
 service
Message-ID: <ZC0rhEHTlz6dHKC0@google.com>
References: <20230330224348.1006691-1-davidai@google.com>
 <20230330224348.1006691-3-davidai@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330224348.1006691-3-davidai@google.com>

On Thursday 30 Mar 2023 at 15:43:37 (-0700), David Dai wrote:
> This service allows guests to query the host for frequency of the CPU
> that the vCPU is currently running on.

I assume the intention here is to achieve scale invariance in the guest
to ensure its PELT signals represent how much work is actually being
done. If so, it's likely the usage of activity monitors will be superior
for this type of thing as that may allow us to drop the baked-in
assumption about vCPU pinning. IIRC, AMUs v2 (arm64-specific obv) have
extended support for virtualization, so I'd suggest looking into
supporting that first.

And assuming we also want to support this on hardware that don't have
AMUs, or don't have the right virt extensions, then the only thing I can
think of is to have the VMM expose non-architectural AMUs to the guest,
maybe emulated using PMUs. If the guest uses Linux, it'll need to grow
support for non-architectural AMUs which is its own can of worms though.

Thanks,
Quentin
