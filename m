Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BC24C64
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 13:47:09 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id a3so23627072wrt.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 06:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X10zFHk+gUIqg0hoNlnRehZH3QTQ8G8IZ5CuTIEOKRU=;
        b=Jo0YpKBq6S17OGidEUkOtG6CIDckvoTjyeiOf3FJFuqJhcB1MjFa9POa9b+n0qc4rF
         CBZDlWM2SxNudvn9J3lODCzlOgOS43+tEOnSOFXvGhtz7Yb4NoWOfJZAZy9ftaSAe6Dw
         lKt0Vza1kvDD/U+Y/FFj9sftC3yJQpgovOyPKR2hJ2MmBnr9u3CrKbFkIkvwoDlfXDnp
         WsWtwSrjNDjvLnIragodfcAiEZvciSP9UoEoNuxhMsGaI2BS+x6SOG1IOrGgr20C5Xd2
         92XMCC1gzXED3dYyYvvOgqB3olBBa1czOZXGzYydGzXXw+K/41oJnaS9XNfAhfgRWngP
         jKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X10zFHk+gUIqg0hoNlnRehZH3QTQ8G8IZ5CuTIEOKRU=;
        b=P1WEDAIimhwTqFuemjz1lLpVk6oFrwSARRHlSRqiKklk8X2DRxs1+yBjygPIFk9tPk
         Oy+C8CWcLQRa1MQohIYqKMEPk3BCWn0pF/SpYctUd/FRIJrXWi3lwtdRx0TprGnnZKw5
         Jx0OECH/XEiJSrepYvycfpSxk1KF/5+BWHe5JW0hPHCS6+sfjyU67qBxUmJyCtSRaKL0
         2PTszdP2tz0D8FIoGG11fY+QWyCAvfzk2bw70xu2188W581JHCc3nhvPbI1/RYTh8d48
         mbLiR0ggh4CZRzVfWvCF9MzoXdMi/wHWWM7hQc7Nqm2yY66gxXod4ocBRq0P7jOMebfT
         Zarw==
X-Gm-Message-State: ACrzQf3vx8KrjIUq5Dp1VfcdDNMOlDgMKm8GgfqRfslqgvXdRCyuSpX+
	zqwmxcdw23QDzssiGxtjR57AUA==
X-Google-Smtp-Source: AMsMyM7g3KcQodof7aZl4G/4Hay96DX13W05O52I0GTomWaZMDcoMucMWfCtAn2SPEvunfMdGk9SCA==
X-Received: by 2002:a05:6000:168f:b0:232:bd06:d5c4 with SMTP id y15-20020a056000168f00b00232bd06d5c4mr1947910wrd.122.1666100827986;
        Tue, 18 Oct 2022 06:47:07 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id c10-20020a05600c0a4a00b003c6cdbface4sm13980107wmq.11.2022.10.18.06.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 06:47:07 -0700 (PDT)
Message-ID: <dada7b09-b853-342a-1d07-9f1e636941c3@linaro.org>
Date: Tue, 18 Oct 2022 15:47:04 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 11/25] KVM: arm64: Rename 'host_kvm' to 'host_mmu'
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
 <20221017115209.2099-12-will@kernel.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221017115209.2099-12-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/10/22 13:51, Will Deacon wrote:
> In preparation for introducing VM and vCPU state at EL2, rename the
> existing 'struct host_kvm' and its singleton 'host_kvm' instance to
> 'host_mmu' so as to avoid confusion between the structure tracking the
> host stage-2 MMU state and the host instance of a 'struct kvm' for a
> protected guest.
> 
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  6 +--
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 46 +++++++++----------
>   2 files changed, 26 insertions(+), 26 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
