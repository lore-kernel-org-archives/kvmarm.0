Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BCE46BF
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 20:22:52 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id l32so9412994wms.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 13:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JrKN18W87AYFXD5PlQt7lxgKU8jhcXd6zar4jEw9XRE=;
        b=pYjyMUo9vjde9CwJEWDbvq8/0slw62HtVPwFTM+pDyhN3fHer0ZaXFvrjZfGVO4M/n
         avpoKj5eQelybWgryeuJYx+Bje4Wi4CULhjeXUwOpxW/ZwAgr6qB0aAgFMKJGqLZAS7x
         OrckU5NrYwte9OnfjmhIXtQ213T8Lc2i+oFvMLO0lCdJ6U+2SzCDtk5Dgrt28+vzUM+k
         JTHcaJmhCJymwEY9lv9KIeoZuWzakxlD5Xn4p0EOBHV5EU4XLRCHuVIsMjO0lw1p2x80
         EHKj4ebPnVdJcj0ofuhwYafhSMxExKeTmFcnjFmFnaxF/pbVApFhCIApJ5nDJnLD0AS4
         UiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JrKN18W87AYFXD5PlQt7lxgKU8jhcXd6zar4jEw9XRE=;
        b=JZKL1hS3mnSzLz2eu6h18VmuJ+S/q2p+UgjESBIFub/NttetUoB5M4Njwu3TLfW5cT
         3WVmt3o0DlwSudrFgYRyvSW0nJe50ZH78ao4VPm4xQlwkRanfPEWvZGWhefNWiHjALNI
         knGG9CQg/jJSOAgm45wDInmmuYFiwBqndRd6DUzKA8Dq9Vg7z+r4ailYmTjRdseItI3O
         FLCCRbsw/v4sYVSGGBLlyBp/PeOyTaBHfZtsYsqSuts09eSz3mkHHQ/S1MOwqtQptRmd
         6pwC1GjTjhZtLVoQT/vDz+Oq+GgXZvgdbeXanvDT9N6borPTyd6WBTTK6xzQH5/huStR
         1obA==
X-Gm-Message-State: ACrzQf1VidDI6oANn0JwktdDoUH4IbX6TaEW/TCXG/ocxyvjW1R0lKbF
	xXlliKpuxzk6z+a2gwggSH3I4A==
X-Google-Smtp-Source: AMsMyM4W02jJyaMrj6v6271VbUvwIuV9Pt8lCk+LFTp83BMflcvVqAx4MdjC3dhHrOAeVnRs8Q+TuQ==
X-Received: by 2002:a1c:7c14:0:b0:3b5:1133:d2ed with SMTP id x20-20020a1c7c14000000b003b51133d2edmr8588026wmc.133.1666038170648;
        Mon, 17 Oct 2022 13:22:50 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id s16-20020a5d4250000000b0022e47b57735sm9093029wrr.97.2022.10.17.13.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 13:22:50 -0700 (PDT)
Message-ID: <d7ad8c43-95c6-fee9-e216-a3d51591ef69@linaro.org>
Date: Mon, 17 Oct 2022 22:22:47 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 09/25] KVM: arm64: Include asm/kvm_mmu.h in
 nvhe/mem_protect.h
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
 <20221017115209.2099-10-will@kernel.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221017115209.2099-10-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/10/22 13:51, Will Deacon wrote:
> nvhe/mem_protect.h refers to __load_stage2() in the definition of
> __load_host_stage2() but doesn't include the relevant header.
> 
> Include asm/kvm_mmu.h in nvhe/mem_protect.h so that users of the latter
> don't have to do this themselves.
> 
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 1 +
>   1 file changed, 1 insertion(+)
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
