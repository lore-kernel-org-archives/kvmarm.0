Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7232E32ED55
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 13:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766150357; cv=none; b=ifNNemka6VFHzztSuqFOOCXAJE54I49NXbSAClBpcb63KA5r0OhesXfKgnYOhQ8yQ1WNE/MypU4+ZYSEvcWGq/Qup4LPIzV0ZR0foQJOPJqv3dRlMacHWaEmQXWW92Ty4YLL3HKKFLPGHZ5HEi6M5i8B9iYnsXJIVPZXUwclQUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766150357; c=relaxed/simple;
	bh=9v+syDd3Z0HzkwZk1/UE5kzTMMPRhyUnQaTAmWWetbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=anr04gvTmsYi1p7R8ch/g/PWXuEWabepcrywGLxodfeD7J//0Njh3e+5xVfZpTKG+uaPVNpjVj1oy0XfifuPo2mHlP4IDm0VhxlhBANkDNAVxP2gNbkt4dxc/EADOzp7pwIQMJELIUg+0bBzMSvB5SRDmjd125QGigdKJ8p9H3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=o3xjw+ii; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="o3xjw+ii"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42e2e628f8aso751156f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 05:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1766150354; x=1766755154; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DFd4J9jPYMS9ZOzqXHiQyrB1Qi+JjAAfHpMnISnUCtk=;
        b=o3xjw+iiK1NPy8pqJmRCovyauwaKkRewt1zCJ9oPGxeh81fhAMZ1+dr4UKHO8PaWsz
         5ljGRPIgn/NUGSa/95NimgxmwS8IlLxMrLrBABbRm5j1TxOWZo0mqDz2rAr8msQLAFN9
         Pb0U54T93I4mGoHYmu0Qm6VuG2umFOk8xPkuPIWKheM2mMB94u2alYDIRxpPZ7Wuvsra
         AEpTjiw8vHXlJGeyqBl/24YIsrX8rSq62WPcKssAQBzEXPwX4Gb21p/Why+P8Exi3PBL
         YALadhCW+U3/opCqX3AsnSMFjl6cnqKaV2rmMk5WXZ9iqL3cbC3AcqiJbj1UNnBw9laD
         OOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766150354; x=1766755154;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DFd4J9jPYMS9ZOzqXHiQyrB1Qi+JjAAfHpMnISnUCtk=;
        b=Jp4qBwqbButQMf6CzUqO2fovTNJOf5isOdswQfu8ztjctBwJHOB/NvO73Ut4unvIb7
         wxPXQHUAW2bXlWLflFWSit1mcZj67k8YM11gZyFcLcDyvyXrt1XnqJgZ0NFCb6HuE2k+
         OV2LstYssceWwn1C/yf8OHGddhD/V/husgJ3XCRj2Uk7aqhXkihT/i6hhEN9O3B3LqfQ
         EkyozT8P5l4odTTxB0TvBTXs4fMYLUbd2gppPim7nhnElSfyeW1r51zehcNI0+6XIMLl
         76R2HuFxIDvCcORL00vqVWKtgzarsxPiqjdVKZsTD3rRp/shxBhpMTzQCrxCoEje+FGU
         tLkg==
X-Forwarded-Encrypted: i=1; AJvYcCW6wlSpZfSPnm96NIW2bwh6v+aWKegv5JqUbMRGddj/Mr5EogtMjo3oq2MOK4qJM31rTB29xPg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhaWiXWXmPmMRSyr2sAG/LRJfEiAj6ibaBqbHFLbkxa5wGIOaR
	Cjrvx0XxdhZCTpxR6ooheaf6Ua7d3wPTLf6Qx6aYlTVnXbZxdoDqnGg+pJjQmem+FBg=
X-Gm-Gg: AY/fxX4N0wPyafX1jzmaVnr6Saw6AdN63jgAO5GokAQhAIAQUH3MwnvLBtx2KB3IB9G
	9Mpcca2+RpCjF968tiHHXCq3gyZ1LgN2ZWKasbyxwJCKrVfZr3j+sqT32tMmokTaxao4HPgiurE
	+sRMu31RN9AuJTquvuerCSbI9V563Fu4KPBvsRo4eoCOdKWuHPxNFcJZcu7pkCP+41pz62I1dQj
	H9D5TknWqNLDesciZbAyFCsxTF48EiVPoYIfRQQIL7jftaiFnN0htFm9UPadwi+ZPkcJ7TeZO9A
	R7BDekSaEERLCypl4Fql50ON+x314hzKOkQEyyZ5LGSlODjtxZ4Osm+ZSU/pFVk6+eSkP8FiGai
	kROAv1XWzQyl3qIeojfk6lazKHcEAfW4+DG8f2eUlVUjz6xd3s2C0iE8uHIX6dLpS9GtW4gaLqv
	B4OgPjhp7Kdk5tvY1e+lFlGwz6C8VILNozIVEpnfb08ecoheWF91/jO4BjSFXB3zO1ogr5qf4jS
	RgMj/La3zls+b3ayilP9XPB7l4znddVNsu7ZUJKoF9Vd6Q=
X-Google-Smtp-Source: AGHT+IFUedUyaN7FVM4hNwKAqMiuSpJ80gJNt0Ya1FnndgUrjUxzdooMyM8p/7osbYBPFxG9KOMkKQ==
X-Received: by 2002:a05:6000:26cf:b0:42f:b649:6dc9 with SMTP id ffacd0b85a97d-4324e70997cmr3518881f8f.58.1766150353635;
        Fri, 19 Dec 2025 05:19:13 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eab33f5sm5096298f8f.41.2025.12.19.05.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 05:19:13 -0800 (PST)
Message-ID: <9887353c-28ed-4a83-b0d8-551d78a29a93@grsecurity.net>
Date: Fri, 19 Dec 2025 14:19:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
 <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
 <3bac29b9-4c49-4e5d-997e-9e4019a2fceb@grsecurity.net>
 <aUNci6Oy1EXXoQuY@google.com>
 <769da4d7-0e8c-447a-be6b-1e3ad9a0ae36@grsecurity.net>
 <aURHXUX3tC8ElwFa@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <aURHXUX3tC8ElwFa@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18.12.25 19:26, Sean Christopherson wrote:
> VICTORY IS MINE!!!!!!!

🏆

> [...]
> Writing MSR_KVM_WALL_CLOCK_NEW via the AP's VM-Entry load list passes with.
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 510454a6..2d140ee5 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -6,6 +6,7 @@
>  
>  #include <asm/debugreg.h>
>  
> +#include "kvmclock.h"
>  #include "vmx.h"
>  #include "msr.h"
>  #include "processor.h"
> @@ -1967,7 +1968,7 @@ struct vmx_msr_entry {
>         u32 index;
>         u32 reserved;
>         u64 value;
> -} __attribute__((packed));
> +} __attribute__((packed)) __attribute__((aligned(16)));
>  
>  #define MSR_MAGIC 0x31415926
>  struct vmx_msr_entry *exit_msr_store, *entry_msr_load, *exit_msr_load;
> @@ -9861,6 +9862,8 @@ static void vmx_init_signal_test(void)
>          */
>  }
>  
> +static bool use_kvm_wall_clock;
> +
>  #define SIPI_SIGNAL_TEST_DELAY 100000000ULL
>  
>  static void vmx_sipi_test_guest(void)
> @@ -9869,7 +9872,7 @@ static void vmx_sipi_test_guest(void)
>                 /* wait AP enter guest with activity=WAIT_SIPI */
>                 while (vmx_get_test_stage() != 1)
>                         ;
> -               delay(SIPI_SIGNAL_TEST_DELAY);
> +               // delay(SIPI_SIGNAL_TEST_DELAY);
>  
>                 /* First SIPI signal */
>                 apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP | APIC_INT_ASSERT, id_map[1]);
> @@ -9903,6 +9906,12 @@ static void vmx_sipi_test_guest(void)
>         }
>  }
>  
> +static const struct vmx_msr_entry msr_load_wall_clock = {
> +       .index = MSR_KVM_WALL_CLOCK_NEW,
> +       .reserved = 0,
> +       .value = 1,
> +};
> +
>  static void sipi_test_ap_thread(void *data)
>  {
>         struct guest_regs *regs = this_cpu_guest_regs();
> @@ -9937,7 +9946,15 @@ static void sipi_test_ap_thread(void *data)
>         /* Set guest activity state to wait-for-SIPI state */
>         vmcs_write(GUEST_ACTV_STATE, ACTV_WAIT_SIPI);
>  
> -       vmx_set_test_stage(1);
> +       if (use_kvm_wall_clock) {
> +               wrmsr(MSR_KVM_WALL_CLOCK_NEW, 0);
> +               vmcs_write(ENT_MSR_LD_CNT, 1);
> +               vmcs_write(ENTER_MSR_LD_ADDR, virt_to_phys(&msr_load_wall_clock));
> +       } else {
> +               vmx_set_test_stage(1);
> +       }
> +
> +       delay(SIPI_SIGNAL_TEST_DELAY);
>  
>         /* AP enter guest */
>         enter_guest();
> @@ -9980,6 +9997,8 @@ static void vmx_sipi_signal_test(void)
>         u64 cpu_ctrl_0 = CPU_SECONDARY;
>         u64 cpu_ctrl_1 = 0;
>  
> +       use_kvm_wall_clock = this_cpu_has_kvm() && this_cpu_has(KVM_FEATURE_CLOCKSOURCE2);
> +
>         /* passthrough lapic to L2 */
>         disable_intercept_for_x2apic_msrs();
>         vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_EXTINT);
> @@ -9996,6 +10015,13 @@ static void vmx_sipi_signal_test(void)
>         /* start AP */
>         on_cpu_async(1, sipi_test_ap_thread, NULL);
>  
> +       if (use_kvm_wall_clock) {
> +               while (rdmsr(MSR_KVM_WALL_CLOCK_NEW) != 1)
> +                       cpu_relax();
> +
> +               vmx_set_test_stage(1);
> +       }
> +
>         /* BSP enter guest */
>         enter_guest();
>  }
>  

What a hack! I like it :D

Happy holidays!

Thanks,
Mathias
