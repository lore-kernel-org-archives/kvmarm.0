Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D81226CE33
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764667012; cv=none; b=ZHyYDVq+lTe9wobaH63TpkkR/6Tr3vkKiBey1SgSNgkhOkmhHHgLwZ0HIHf4Z6QjhDnM2YvuzN8cplnTTrTvrSDJep12DifIRy5dINhtcbI7Fbx9L7Sz2EgRvfODUDgR2T3ZPaUn1AWBIwXeKofrWvvRdGBkytp9BKhrMWFZexo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764667012; c=relaxed/simple;
	bh=mzqNBOpcLYerEcH5Q2GlKCwR0gaYp1181Z84TNL0evM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aQzuZZxyBY6wrQBme1zl4SDCW4M4hdhYsgBbne9wG6mROMkf8tpSM0fuFvlTuej1oZzzbw4k0oudwle/r9Rjcl5hn8U+OUWv9W9XFsvvZABmXG5rDd5zGbdWu9qdhnFQaq0os821LITovqTGACnQfry67ZzStoBpIt7oEpbMARo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gCQcYOOW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gCQcYOOW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764667007;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nO1OzCggv5Us6LpGbd3LZnEAwWb1hr2QplQRbye96P4=;
	b=gCQcYOOWhBBUkrfGIY5zebl/A2Y8lQNI4SLnwrdbACREtebYkRYo1dVGpD4M56k+bmdRL7
	lwj46eKB9laIJmrk64giQ/2lnXHCdSF7lcijXz433qaw2TLhBM9hSBj9tCSXagvU8H92Ai
	I2gdfxf4ao5aMe/XRsoj7zQlpqIx3Hc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-Cgs5nONpNLmfqfCyqSH5pw-1; Tue, 02 Dec 2025 04:16:46 -0500
X-MC-Unique: Cgs5nONpNLmfqfCyqSH5pw-1
X-Mimecast-MFC-AGG-ID: Cgs5nONpNLmfqfCyqSH5pw_1764667005
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-88249865db8so94653976d6.0
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:16:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764667005; x=1765271805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nO1OzCggv5Us6LpGbd3LZnEAwWb1hr2QplQRbye96P4=;
        b=uymJRuHPcLjHARa42jsElXevLkU4ZIH1Ma+4a5UGKfJTF7LP3U6DF+rQP0UXVmZo4Z
         q2nWSA8eYuV8fpTlr3rlhALoSQq4A0o4PghJNX5UoNWMkPK/Ei8e07ZvEliFOjOgE45U
         ElV7mH170FNKvSHVXNLxR0jU0BHW+s4Ir2pnaAqskkEIG7zJYH+1Sqm3GIhv2IFAH7M9
         9e/37xIE6jlr9zoDflgSfKAOelIAVodiIpMfIBvj65E6XPZlm7Lkq0lMoz3wQduc84EA
         94NaxLHsV8Y8aDu1J30FQlOeWX/IISpYiwdQ0JvB9ktr5Wsikd5z9fn56hhLVsb8+eDi
         XcqA==
X-Forwarded-Encrypted: i=1; AJvYcCXUv1S1NdNIMm5TXJT/p3opfsbOIQQ/Qmz2AP90YNSAzbPOV3MZkIstGrAqn4KtMLjtH5WmcVE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6uAXZTOuGfUMgnvak2AE6lfk1P2cmQLV5GDF4oQ7ZpBIS8Z46
	VBMkZB7KoncB20oTYqtbyZGkhQguctWt2+vFuda8skBmA79nBPNaT1MhvWwgn/uLyXZc++9sGj6
	2/abCSHU1D9R7+0iMsVEAKRT/2MgWQzjKzkO4lMO9CQY4fGV2S2OOYi604A==
X-Gm-Gg: ASbGncuujNNKzr/OTKdprEQm1Dz7cBIAGFscuZWEoi1R+0CSf39cCsDs4cYlRTOEb/R
	LN0zcVXq84yCSUynohnQfNkhW8ShizhO9TSpBi0EGmXLxk3bXAnWmuidB20vHoYWIK5Mn4c/5nx
	CaEqRh3FtI03Wya5tByPjrC1rbgBGTg+bwpvzcwLgYOXe2KwWINrSThehYojBvBHsUqBJolpnfW
	PnJ6qmqIFA2zLmbWA+uxA0FQRd+djhTbGnAvr+5N0yGj8lErtWYp4e9E/VJ2dPUgQPTKwHWGuCS
	cvCOj6KI8TzeYlu2aXI/2FT8AGv0lJ/Ad3gcrtD+Nx0i9UtgcPOr/d9ID1zaDzVRFrhP9DygLM5
	6rqYBpxTENf3yxQ7mBKLFEE3IsQCR7JXDK3turkstnwC3OQuQJuR84Ovv1Q==
X-Received: by 2002:a05:6214:1248:b0:882:4580:a86f with SMTP id 6a1803df08f44-8880db021c1mr29191586d6.6.1764667005009;
        Tue, 02 Dec 2025 01:16:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGP9KNEjOZYxyZznBw4V2byRMo0JTnBVwuhJhps/sxAJFUEHYQNXcEnamOc4VWRu0BX+pj4Eg==
X-Received: by 2002:a05:6214:1248:b0:882:4580:a86f with SMTP id 6a1803df08f44-8880db021c1mr29191386d6.6.1764667004575;
        Tue, 02 Dec 2025 01:16:44 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b494d5sm99219806d6.27.2025.12.02.01.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 01:16:44 -0800 (PST)
Message-ID: <5160dadb-1ff3-487e-bd0b-9f643c3d9ec3@redhat.com>
Date: Tue, 2 Dec 2025 10:16:42 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 07/10] arm64: selftest: update test for
 running at EL2
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-8-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-8-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V8d55pVG0veO9-_e4Ggbq5XOH8oojR0CSAl2HqfYGxY_1764667005
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
>
> Remove some hard-coded assumptions that this test is running at EL1.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arm/selftest.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 1553ed8e..01691389 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -232,6 +232,7 @@ static void user_psci_system_off(struct pt_regs *regs)
>  	__user_psci_system_off();
>  }
>  #elif defined(__aarch64__)
> +static unsigned long expected_level;
>  
>  /*
>   * Capture the current register state and execute an instruction
> @@ -276,8 +277,7 @@ static bool check_regs(struct pt_regs *regs)
>  {
>  	unsigned i;
>  
> -	/* exception handlers should always run in EL1 */
> -	if (current_level() != CurrentEL_EL1)
> +	if (current_level() != expected_level)
>  		return false;
>  
>  	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
> @@ -301,7 +301,11 @@ static enum vector check_vector_prep(void)
>  		return EL0_SYNC_64;
>  
>  	asm volatile("mrs %0, daif" : "=r" (daif) ::);
> -	expected_regs.pstate = daif | PSR_MODE_EL1h;
> +	expected_regs.pstate = daif;
> +	if (current_level() == CurrentEL_EL1)
> +		expected_regs.pstate |= PSR_MODE_EL1h;
> +	else
> +		expected_regs.pstate |= PSR_MODE_EL2h;
>  	return EL1H_SYNC;
>  }
>  
> @@ -317,8 +321,8 @@ static bool check_und(void)
>  
>  	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
>  
> -	/* try to read an el2 sysreg from el0/1 */
> -	test_exception("", "mrs x0, sctlr_el2", "", "x0");
> +	/* try to read an el3 sysreg from el0/1/2 */
> +	test_exception("", "mrs x0, sctlr_el3", "", "x0");
>  
>  	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
>  
> @@ -429,6 +433,10 @@ int main(int argc, char **argv)
>  	if (argc < 2)
>  		report_abort("no test specified");
>  
> +#if defined(__aarch64__)
> +	expected_level = current_level();
nit I would directly use current_level() in the calling function,
check_regs() to avoid that #ifdef

Eric
> +#endif
> +
>  	report_prefix_push(argv[1]);
>  
>  	if (strcmp(argv[1], "setup") == 0) {

