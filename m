Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B71A5685
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 17:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675791119;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Emp7X43Gv6S0iQe88Vb8e/Pvs1J6U0weHKSQt4vkRo=;
	b=Eg6CkYics92qDxP/fu30gRuZBMWvtIParxF8taYziMI3+nafG93j7AxTemmyPPheRyF6m3
	0V9/4oUhAUAvofKMrLd2AgqdY8MNFbDwlgOjTRIcj7adU3VS/TG1EO/8yhmuwk0Q3InFSY
	oc5mCFMU02AF2W2OK/RtIDqJCqIHtBE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-263-9fYqFYcgO8WGjjo1LKPlsg-1; Tue, 07 Feb 2023 12:31:58 -0500
X-MC-Unique: 9fYqFYcgO8WGjjo1LKPlsg-1
Received: by mail-qv1-f72.google.com with SMTP id lw11-20020a05621457cb00b005376b828c22so7955983qvb.6
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 09:31:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Emp7X43Gv6S0iQe88Vb8e/Pvs1J6U0weHKSQt4vkRo=;
        b=aKFP6dz+kkoKl2ssVP1w2qBq/eBonWMpcZ4gQq70q3RzcXYhrFA15IYFnsWV80apm+
         ZplKM+qMJpYK7lb1VB0+/ThvbxUHxCL35rJpnxcholBb5xCKz0yM7AfGNXvM8Ig3ahme
         v8ClKJvd44BI0R/ZcrOvSyaOBMz9qW0JDoh97OhuNVVlCdgEzVXKCLjKej+iuAJdqu2U
         +RV46yP/hH2a0b29T0hG7L6d5toTnWROefhDQi8oplIS932E0DUU0AEOLwG8fql4cwCR
         txdfpbJSOUFqTnvj84leH/IFdVwIyxAeDVqG2P4sqTA/9fyJdDrQglarUknTPt/fYIed
         F2HA==
X-Gm-Message-State: AO0yUKVeNcAaQKQGtAfI2wbKgBEdSJGnh+Pn7xOOF3oF+b2yh1HH/POf
	B7KUULv/eaILiPs/OHgmv6zMvruN744wT9ie6zs071MeIGXbEwoSQSM8pZE/P80aovc3pz3tc0e
	YH7RAEjl4LzwiuU1NQmByVA==
X-Received: by 2002:ac8:59c1:0:b0:3b9:b2ba:9b3d with SMTP id f1-20020ac859c1000000b003b9b2ba9b3dmr6808797qtf.54.1675791117209;
        Tue, 07 Feb 2023 09:31:57 -0800 (PST)
X-Google-Smtp-Source: AK7set9rcKbwD3WF2oVGbNOSRg/intgOsW2YkNms5QyLWSOwVDl4uaTl+11DeZ2v3/KeMawWamox8w==
X-Received: by 2002:ac8:59c1:0:b0:3b9:b2ba:9b3d with SMTP id f1-20020ac859c1000000b003b9b2ba9b3dmr6808753qtf.54.1675791116759;
        Tue, 07 Feb 2023 09:31:56 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bj29-20020a05620a191d00b0071b158849e5sm10008223qkb.46.2023.02.07.09.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 09:31:56 -0800 (PST)
Message-ID: <45ea9f30-9196-88ad-09bb-b72204cb73c8@redhat.com>
Date: Tue, 7 Feb 2023 18:31:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 6/6] arm: pmu: Fix
 test_overflow_interrupt()
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 reijiw@google.com
References: <20230126165351.2561582-1-ricarkol@google.com>
 <20230126165351.2561582-7-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230126165351.2561582-7-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ricardo,

On 1/26/23 17:53, Ricardo Koller wrote:
> test_overflow_interrupt() (from arm/pmu.c) has a test that passes
> because the previous test leaves the state needed to pass: the
> overflow status register with the expected bits. The test (that should
> fail) does not enable the PMU after mem_access_loop(), which clears
> the PMCR, and before writing into the software increment register.
>
> Fix by clearing the previous test state (pmovsclr_el0) and by enabling
> the PMU before the sw_incr test.
>
> Fixes: 4f5ef94f3aac ("arm: pmu: Test overflow interrupts")
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thank you for the fix!

Eric

> ---
>  arm/pmu.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 1e93ea2..f91b5ca 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -914,10 +914,15 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  
>  	write_regn_el0(pmevcntr, 0, pre_overflow);
>  	write_regn_el0(pmevcntr, 1, pre_overflow);
> +	write_sysreg(ALL_SET_32, pmovsclr_el0);
>  	write_sysreg(ALL_SET_32, pmintenset_el1);
>  	isb();
>  
>  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	isb();
> +
>  	for (i = 0; i < 100; i++)
>  		write_sysreg(0x3, pmswinc_el0);
>  

