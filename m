Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0037204583
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 10:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764671504; cv=none; b=DNTaOpaQ8tqd3nCeNJ1mFXJEAqktw4BIgXtSSO3bKb1djlQHQRZmGXkn99LQU2pxHSF0VYFZo+quY5d3sGwbmdC84xTpVe8i6vQ/EcNqgAepsFnR04f2YFoI/GVnVILJxIBQ/uV485fOKK7aGiF7Ac0nyg+9Lqz/Jo8Llsw2h9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764671504; c=relaxed/simple;
	bh=fgMjYj4bIL6AZNPeX1R5CQmvPztTnQWt1WpxvYC3K1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eILI7xF1ZYiNRe060ms/KuRYqNwW5aV+2qYI7NzI1zHrY1+EUVrvNvSd9Zc1ZSnXTtr1W6S6EiJiXJ7ZI2L5blXkb8nrPOTmqDNVDxGKjojxMwc+8F0lDPzYhY8E814QPHO83kyX/krIo39+ZqPBA17QWjwaNoxlTyzKFfOd6Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d86P3cTp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d86P3cTp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764671501;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vQZ1yQVfkBFCjcNblwsqZZNx6M3xDYjpded8RdSmjTQ=;
	b=d86P3cTpec6W43JAPcnMBhltuCbW+utw4OABzMAUri/J3/Oc/GZTNLi+yhsV+E12wxppc4
	quUMniyBaZ3eSgiTW2imVLR6VsuE+hV1xrK+zRfq531GHC4ALQIaa/AQUgv20lUvdEIsx3
	FWWGjII9BYtf0DsiQnXFnvHH6c8pimw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-TzM7ahc9OAyh9JYNb13nuw-1; Tue, 02 Dec 2025 05:31:40 -0500
X-MC-Unique: TzM7ahc9OAyh9JYNb13nuw-1
X-Mimecast-MFC-AGG-ID: TzM7ahc9OAyh9JYNb13nuw_1764671500
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b2f0be2cf0so1545853585a.0
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 02:31:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764671500; x=1765276300;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQZ1yQVfkBFCjcNblwsqZZNx6M3xDYjpded8RdSmjTQ=;
        b=JkQTQcSsKf5rqph6+/ckcF96lOL6n86Ktcpz9ustRsVrbqqY9OCvL3DL2dosh58CYe
         0dxTzWMiZ98uQwcLzFluZtbYbCRKW9YUF5xrBhUd5FiRANywWNqdZCg8xgyCGfBt9HxV
         rZ1rK01yicdve1d/eIDgFzzILq1gqdFTjt8WvaKX5k/D2RvIfjOBCco5x6ylV27rCmvd
         DmAVSvQn2NVZ6dDewaESyVJ/CbHkYphbeMvv+j6ILvoL9QUro75d6xa9PXbeGyD21jyh
         lmzwBSpWhN6IhBSuEFqeSPOrF/l9L0qtzaHgylDq6dgoSPzUuuQAPT8vEN3Mv70CwpcT
         c1aA==
X-Forwarded-Encrypted: i=1; AJvYcCWYgm8bOI5Roa3yWQbnGDYRHv+S9U5NUrJQLgkS+obHK5baSi1kXmAHWra9KwSacqnKTcIbFGg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwpLbq6Tfuf7Gg99BxWOpXXi7L6ExkzU/iMQ0HtDzJDc5aYy76E
	ldZhg3uRWLD6wkdlUVE2+1hOe4w8jbJywhVw5lg93xWeKD7FRhjoT851UxFldHbmSm5Y61mF9Ss
	yg+2OcVTnfM0axYKEc9RQEYi8vWHMYP436KywqLx+3mEV04L8V2qG13TZMg==
X-Gm-Gg: ASbGncuEzJRU9XOxxcB5XFGxL5WIr5nH/hF/z/kMoaP5uWi8jY0bLOQLVin9HxfT6oO
	UIfXDmREuTEWi8tHJHjgh46wZV/fuySNCUoFU929EIUX5nWRVPdevJmkm9v110Ye5ZP1nB5xLQ/
	ar0nvIalQgygmCY8LxkPfpeBszJYUtGOxh7O4gPE1hq78FBcpXl72qSDWmCYEZrvmV8WboJWPoN
	Ov9wql0iV/e8aYPg2EqTVfBifjhEE1+sVr1Nc1gmIQ2qCkAY91vSW2S059z0Lec+v56OhPS/ppS
	kOmS2ZSAzOH+Drm5zQDFwpoWBYrYz9zpzE5LnXeHQvXtKhDTj9HytHXE1caEtxraNuvlbs65mS8
	Iii7WWpseAKEhSCrS4I0Pzk6sibdOtfwlH4icg/Tf5cF7z/yN1yNpZzoy3g==
X-Received: by 2002:a05:620a:4687:b0:8a3:87ef:9245 with SMTP id af79cd13be357-8b33d4c71damr5820820085a.85.1764671499945;
        Tue, 02 Dec 2025 02:31:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkFzxmwelK7JWWOAoPq9zHQWlUTkFdQtGpxT5OnaUqoncZnDcZ0jY3Vwv2Xy+uzCGGTRumEg==
X-Received: by 2002:a05:620a:4687:b0:8a3:87ef:9245 with SMTP id af79cd13be357-8b33d4c71damr5820816985a.85.1764671499514;
        Tue, 02 Dec 2025 02:31:39 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1c909asm1040500585a.40.2025.12.02.02.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 02:31:39 -0800 (PST)
Message-ID: <a8951572-2d70-413e-90c7-9eb45a5d18a2@redhat.com>
Date: Tue, 2 Dec 2025 11:31:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 08/10] arm64: pmu: count EL2 cycles
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-9-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-9-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JhzDZ4c8Yw4-j6msXCaWTR5uAlsy3VWayb3HfTXdeao_1764671500
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> Count EL2 cycles if that's the EL kvm-unit-tests is running at!
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/pmu.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 2dc0822b..e6c0f05b 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -121,6 +121,8 @@ static struct pmu pmu;
>  #define PMINTENCLR   __ACCESS_CP15(c9, 0, c14, 2)
>  #define PMCCNTR64    __ACCESS_CP15_64(0, c9)
>  
> +#define PMCCFILTR_EL0_DEFAULT	0
> +
>  static inline uint32_t get_id_dfr0(void) { return read_sysreg(ID_DFR0); }
>  static inline uint32_t get_pmcr(void) { return read_sysreg(PMCR); }
>  static inline void set_pmcr(uint32_t v) { write_sysreg(v, PMCR); }
> @@ -206,6 +208,9 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
>  #define ID_DFR0_PMU_V3_8_5	0b0110
>  #define ID_DFR0_PMU_IMPDEF	0b1111
>  
> +#define PMCCFILTR_EL0_NSH	BIT(27)
> +#define PMCCFILTR_EL0_DEFAULT	(current_level() == CurrentEL_EL2 ? PMCCFILTR_EL0_NSH : 0)
> +
>  static inline uint32_t get_id_aa64dfr0(void) { return read_sysreg(id_aa64dfr0_el1); }
>  static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
>  static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
> @@ -246,8 +251,7 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>  #define PMCNTENSET_EL0 sys_reg(3, 3, 9, 12, 1)
>  #define PMCNTENCLR_EL0 sys_reg(3, 3, 9, 12, 2)
>  
> -#define PMEVTYPER_EXCLUDE_EL1 BIT(31)
> -#define PMEVTYPER_EXCLUDE_EL0 BIT(30)
> +#define PMEVTYPER_EXCLUDE_EL0 BIT(30) | (current_level() == CurrentEL_EL2 ? BIT(27) : 0)
>  
>  static bool is_event_supported(uint32_t n, bool warn)
>  {
> @@ -1063,7 +1067,8 @@ static bool check_cycles_increase(void)
>  	/* init before event access, this test only cares about cycle count */
>  	pmu_reset();
>  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> -	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> +
> +	set_pmccfiltr(PMCCFILTR_EL0_DEFAULT);
>  
>  	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
>  	isb();
> @@ -1118,7 +1123,7 @@ static bool check_cpi(int cpi)
>  	/* init before event access, this test only cares about cycle count */
>  	pmu_reset();
>  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> -	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> +	set_pmccfiltr(PMCCFILTR_EL0_DEFAULT);
>  
>  	if (cpi > 0)
>  		printf("Checking for CPI=%d.\n", cpi);

