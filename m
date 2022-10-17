Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4C24A01
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 20:26:18 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id iv17so9414244wmb.4
        for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 13:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jee5xT/EbIpj8zhUcGkaQNaDYXtiHF+Gr32UNKB5FwY=;
        b=dwz6lIdYbrjvZM5oFp3vrUl6kps0z9vWWwePBaTB+aDUjB7JK7VH3f6r52qEY+S72e
         Xmkse56HzsT336u3PHmC4ONwmO+pCZU22xi+6FwCpOCjmO3p130J4QRorjEFmAanLLpi
         AhJNT0DG1Wy9iuEYE5F9kuO4tjTij8VMkvFH91LFt2XiGiaRQCAhHqxXg8Z7LgfGlSLz
         fSl0omG71v29cAivfgDwvOARC65kRdnAx6A6PNaq8kZjn+wnf0DJbO0rbFeedz1AzFFb
         WDbmWTQZ6gjTAEX44LZbh+O4TYT39VkdTAQd7vCwi47eFbKdC4E5uuWXg3TRKeH6keDk
         uLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jee5xT/EbIpj8zhUcGkaQNaDYXtiHF+Gr32UNKB5FwY=;
        b=0R3396S/Vrn5Ok6LkxlaWgfbv5XNyxsbWeqEWXNel6fg1kiTzXrV64AvrDoUNx27YG
         aX5GwI8zybPm1a506Z8t9BfQtDuO8iiucZILyBn3oYabl913NoMoMvvrmniTObFxOB7q
         ba3yqkEfN4+gvsi1f6ATNW3wUU8sEuWLqwAfPxQRt27Q4GAintApI2dyrx0D0TeWEIRV
         FlZ7kHkp5GvtE5fhN8eH43ehmmtPJqBWXEC4DaAUR3VWIWRbRmtJuqsmfuKtxUrrz8ln
         Wu5LyhaOKYFJcoypF+zvVOsouDudIcrHCZ++5vMK9av7CDDgMlUiyAqMIApE4vQ5+6OK
         VEfQ==
X-Gm-Message-State: ACrzQf2bkG5XjRLHXgVF0cW/n8CmCI8RhP6sDaaqtFMHPARburNEoIAw
	s0RkBv1n22wmcg7o8yLiQ94YAkuKZPItC8QwfeY=
X-Google-Smtp-Source: AMsMyM4kLOVDIjrvsg0+K4Qqr9feEXAFShXtdhEF1u2/AMVlJREkPwYkiJZmoEr23KoivW+580TlgQ==
X-Received: by 2002:a05:600c:5127:b0:3c6:47ff:5d33 with SMTP id o39-20020a05600c512700b003c647ff5d33mr9249484wms.68.1666038377313;
        Mon, 17 Oct 2022 13:26:17 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c35d000b003a84375d0d1sm18144979wmq.44.2022.10.17.13.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 13:26:16 -0700 (PDT)
Message-ID: <905d1ff0-f039-85ef-f998-051c6879ad6e@linaro.org>
Date: Mon, 17 Oct 2022 22:26:14 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 15/25] KVM: arm64: Initialise hypervisor copies of host
 symbols unconditionally
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
 <20221017115209.2099-16-will@kernel.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221017115209.2099-16-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/10/22 13:51, Will Deacon wrote:
> The nVHE object at EL2 maintains its own copies of some host variables
> so that, when pKVM is enabled, the host cannot directly modify the
> hypervisor state. When running in normal nVHE mode, however, these
> variables are still mirrored at EL2 but are not initialised.
> 
> Initialise the hypervisor symbols from the host copies regardless of
> pKVM, ensuring that any reference to this data at EL2 with normal nVHE
> will return a sensibly initialised value.
> 
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/arm.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
