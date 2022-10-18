Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D174C64
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 13:51:54 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id e18so10741267wmq.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 06:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ip4fB/O2dncy+wTIhlbp/UW+BPiXgCFv8LjkfDyNXyc=;
        b=uASQrGd8zGqIhI2gfu203qtfOZtr50VqLQ+dlG+Xezd9SxA/IDbDgEOtpsYz5YS33e
         JTS4YIpyPZ9UlaQK+MwpXOxCZP3vGjB5KrJA5EdXHA3OBUK0MzxFUh2+L301h9QKGTfF
         4oA9N8nnP8oV7zN9w/pp0Sa+bjghVyakTOndkVIhhM2X4i0xWgHhoAVPrUWoKg1BPUlN
         ajpH1yRDsv+WSC7g6YXHWGveEP0CHIbT/1UL4HXAzHumbiCygf/amoK2mA0NSpuVdpqc
         s8WTGMydarqKcWriHW+EmvvW5e0dQJX2jvfc861IREH31cqAlBgjfYOzs+YcW62aK1tZ
         ETTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ip4fB/O2dncy+wTIhlbp/UW+BPiXgCFv8LjkfDyNXyc=;
        b=njQz95rmUcF7xffJ6HkR364Qvc08fXukUCYN9W2HFCgP1m/C2f1fpW4QhDggSZFH1Y
         Kn5cGHGjw6axwHQ6+Oz8eM1BGmknPY34JTy6HNOkQ9h4Pl9QzD2dOgR8QJDPJnNmjE8y
         bQJ7xG5pHTJWTZ940eeHjPBBAChfEDAdmC8pybtzTvceJzaGEBp933L9yn/By+vOrSBI
         qOvAVXYiGuN3RPnygWkX79kuXWe40CtjD4uzL8956vVmJZtrbEN5f3xaHy5TUaF/OtIV
         6V7cRxR6J2gWJBngy2tEZk/4MLbuQn5lK7jujXO/gPj+KiCxc23DYBxcNUuo/FeeEuOD
         BFiw==
X-Gm-Message-State: ACrzQf3Et4zRb/OvbENRISy9A+GZoS/FHOmHbyy6b3AIlZ4VpcHfhC72
	VFbHM48NwXz2Xa+jEkbyIpJglA==
X-Google-Smtp-Source: AMsMyM7E+2Q1pbpwQ+k40AFxl6lABOVhZzIlvO8nSbYJqDspKlNqDFpLxTGlIUCKWEhgyQFjnvZRyA==
X-Received: by 2002:a05:600c:4f54:b0:3c6:edec:2787 with SMTP id m20-20020a05600c4f5400b003c6edec2787mr2163528wmq.109.1666101112917;
        Tue, 18 Oct 2022 06:51:52 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id q19-20020a05600c2ed300b003b3365b38f9sm12995962wmn.10.2022.10.18.06.51.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 06:51:52 -0700 (PDT)
Message-ID: <a238f56e-b663-4109-1b5d-745b62c4f04e@linaro.org>
Date: Tue, 18 Oct 2022 15:51:49 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 10/25] KVM: arm64: Add hyp_spinlock_t static
 initializer
Content-Language: en-US
To: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc: Sean Christopherson <seanjc@google.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, James Morse
 <james.morse@arm.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Quentin Perret <qperret@google.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 kernel-team@android.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-11-will@kernel.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221017115209.2099-11-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/10/22 13:51, Will Deacon wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Introduce a static initializer macro for 'hyp_spinlock_t' so that it is
> straightforward to instantiate global locks at EL2. This will be later
> utilised for locking the VM table in the hypervisor.
> 
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
