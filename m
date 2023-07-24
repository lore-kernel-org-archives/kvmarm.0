Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48046568C
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 13:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690206417;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WqEzWNT97M6iM0NNIS448oB2cCfC/TF+skOz+vuPg6o=;
	b=J2hqxaLXgc9/4Tbfn0zoSqKNLoVhPa4qXJ8W1oZS8YvtC3s7Am6BeLCzAtmaA/d+Qrbn8U
	JKXUuYivfl68xdsdDS6qv9Iy3lcRW/nhJZX56QLtcCUF5rFlmKRHHVVtP1i8l1e8gHrIQx
	/Gb7c8QqrSZb8rmq6r/lfVkNJVQVnsg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-PCaKP0AvOlipALuEmMPSLg-1; Mon, 24 Jul 2023 09:46:55 -0400
X-MC-Unique: PCaKP0AvOlipALuEmMPSLg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-403b066c6e7so62460471cf.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 06:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690206415; x=1690811215;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WqEzWNT97M6iM0NNIS448oB2cCfC/TF+skOz+vuPg6o=;
        b=aLD4jn0Wtw5pOJitgThHSt8xYL3iLXMPoBLv9R4quVYZMa+e7qKnMrUWypGRBm42q5
         oNJgkzLtGauHIj948Vs+noNJU41y03ECBwlcmFL2uaODmOPYfAYwERBghdoAt46VeAQ5
         aPvGTeFEIysXbvfbKkanYXlGtDxpt+phWEoIbDTaTA/Pvy0GcgspVpan1SYkkrrNcRB7
         aU5JCZrk+frmJjfzs9tYpgHYuDP28Fc8oHG06sSneaJlmHEEm9nBcETKTRayFwmJmhgA
         UOzSzfw3Q/S1War9L6KHyRw18rkhxp3WTSV2/hBJG741WMm37uUdOjq6v5D54aeFrkxa
         iuGA==
X-Gm-Message-State: ABy/qLa/2UW8015QoAArAC+wOCZgl4YeRGLe7UT47aKSlwsaASS4Jgcv
	syD92r5W2oVviaXTrfFTX7Zr536hVCWjXSgIoySmy2iua7Ggzkw5VEx3alpz0W/Bz76Vd5gIL3i
	WXKphHZXWOEZmVmO5Bf50sO1p
X-Received: by 2002:a05:622a:5d0:b0:405:5b23:d0ea with SMTP id d16-20020a05622a05d000b004055b23d0eamr7353731qtb.16.1690206414862;
        Mon, 24 Jul 2023 06:46:54 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFcR9964zUfUQQUMDfuKRfZwWfI5ijyO7CY81jEBkz6RItOPi7O9UKPhvULxwFSgD8/hYaHBA==
X-Received: by 2002:a05:622a:5d0:b0:405:5b23:d0ea with SMTP id d16-20020a05622a05d000b004055b23d0eamr7353710qtb.16.1690206414537;
        Mon, 24 Jul 2023 06:46:54 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id g8-20020ac87748000000b0040549add997sm2818652qtu.71.2023.07.24.06.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 06:46:53 -0700 (PDT)
Message-ID: <986548fa-2cb0-28b6-5d35-6e45ace0a8e4@redhat.com>
Date: Mon, 24 Jul 2023 15:46:48 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 06/27] arm64: Add debug registers affected by HDFGxTR_EL2
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-7-maz@kernel.org>
 <a69eda3e-d255-1eb4-c6d2-7ba02ba02468@redhat.com>
 <86bkgev5j3.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <86bkgev5j3.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 7/14/23 18:09, Marc Zyngier wrote:
> Hey Eric,
>
> On Fri, 14 Jul 2023 15:47:20 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 7/12/23 16:57, Marc Zyngier wrote:
>>> The HDFGxTR_EL2 registers trap a (huge) set of debug and trace
>>> related registers. Add their encodings (and only that, because
>>> we really don't care about what these registers actually do at
>>> this stage).
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  arch/arm64/include/asm/sysreg.h | 78 +++++++++++++++++++++++++++++++++
>>>  1 file changed, 78 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>>> index 76289339b43b..9dfd127be55a 100644
>>> --- a/arch/arm64/include/asm/sysreg.h
>>> +++ b/arch/arm64/include/asm/sysreg.h
>>> @@ -194,6 +194,84 @@
>>>  #define SYS_DBGDTRTX_EL0		sys_reg(2, 3, 0, 5, 0)*
>>>  #define SYS_DBGVCR32_EL2		sys_reg(2, 4, 0, 7, 0)*
>>>  
>>> +#define SYS_BRBINF_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 0))*
>>> +#define SYS_BRBINFINJ_EL1		sys_reg(2, 1, 9, 1, 0)*
>>> +#define SYS_BRBSRC_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 1))*
>>> +#define SYS_BRBSRCINJ_EL1		sys_reg(2, 1, 9, 1, 1)*
>>> +#define SYS_BRBTGT_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 2))*
>>> +#define SYS_BRBTGTINJ_EL1		sys_reg(2, 1, 9, 1, 2)*
>>> +#define SYS_BRBTS_EL1			sys_reg(2, 1, 9, 0, 2)*
>>> +
>>> +#define SYS_BRBCR_EL1			sys_reg(2, 1, 9, 0, 0)*
>>> +#define SYS_BRBFCR_EL1			sys_reg(2, 1, 9, 0, 1)*
>>> +#define SYS_BRBIDR0_EL1			sys_reg(2, 1, 9, 2, 0)*
>>> +
>>> +#define SYS_TRCITECR_EL1		sys_reg(3, 0, 1, 2, 3)
>>> +#define SYS_TRCITECR_EL1		sys_reg(3, 0, 1, 2, 3)
>> I cannot find this one - which is duplicated by the way - in DDI0487Jaa
> Ah, that's one of the sucker I got from peeking at the 2023-03 XML and
> wrote it twice for a good measure. You can see it there:
>
> https://developer.arm.com/documentation/ddi0601/2023-03/AArch64-Registers/TRCITECR-EL1--Instrumentation-Trace-Control-Register--EL1-
>
>>> +#define SYS_TRCACATR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (2 | (m >> 3)))*
>>> +#define SYS_TRCACVR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (0 | (m >> 3)))*
>>> +#define SYS_TRCAUTHSTATUS		sys_reg(2, 1, 7, 14, 6)*
>>> +#define SYS_TRCAUXCTLR			sys_reg(2, 1, 0, 6, 0)*
>>> +#define SYS_TRCBBCTLR			sys_reg(2, 1, 0, 15, 0)*
>>> +#define SYS_TRCCCCTLR			sys_reg(2, 1, 0, 14, 0)*
>>> +#define SYS_TRCCIDCCTLR0		sys_reg(2, 1, 3, 0, 2)*
>>> +#define SYS_TRCCIDCCTLR1		sys_reg(2, 1, 3, 1, 2)*
>>> +#define SYS_TRCCIDCVR(m)		sys_reg(2, 1, 3, ((m & 7) << 1), 0)*
>>> +#define SYS_TRCCLAIMCLR			sys_reg(2, 1, 7, 9, 6)*
>>> +#define SYS_TRCCLAIMSET			sys_reg(2, 1, 7, 8, 6)*
>>> +#define SYS_TRCCNTCTLR(m)		sys_reg(2, 1, 0, (4 | (m & 3)), 5)*
>>> +#define SYS_TRCCNTRLDVR(m)		sys_reg(2, 1, 0, (0 | (m & 3)), 5)*
>>> +#define SYS_TRCCNTVR(m)			sys_reg(2, 1, 0, (8 | (m & 3)), 5)*
>>> +#define SYS_TRCCONFIGR			sys_reg(2, 1, 0, 4, 0)*
>>> +#define SYS_TRCDEVARCH			sys_reg(2, 1, 7, 15, 6)*
>>> +#define SYS_TRCDEVID			sys_reg(2, 1, 7, 2, 7)*
>>> +#define SYS_TRCEVENTCTL0R		sys_reg(2, 1, 0, 8, 0)*
>>> +#define SYS_TRCEVENTCTL1R		sys_reg(2, 1, 0, 9, 0)*
>>> +#define SYS_TRCEXTINSELR(m)		sys_reg(2, 1, 0, (8 | (m & 3)), 4)*
>>> +#define SYS_TRCIDR0			sys_reg(2, 1, 0, 8, 7)*
>>> +#define SYS_TRCIDR10			sys_reg(2, 1, 0, 2, 6)*
>>> +#define SYS_TRCIDR11			sys_reg(2, 1, 0, 3, 6)*
>>> +#define SYS_TRCIDR12			sys_reg(2, 1, 0, 4, 6)*
>>> +#define SYS_TRCIDR13			sys_reg(2, 1, 0, 5, 6)*
>>> +#define SYS_TRCIDR1			sys_reg(2, 1, 0, 9, 7)*
>>> +#define SYS_TRCIDR2			sys_reg(2, 1, 0, 10, 7)*
>>> +#define SYS_TRCIDR3			sys_reg(2, 1, 0, 11, 7)*
>>> +#define SYS_TRCIDR4			sys_reg(2, 1, 0, 12, 7)*
>>> +#define SYS_TRCIDR5			sys_reg(2, 1, 0, 13, 7)*
>>> +#define SYS_TRCIDR6			sys_reg(2, 1, 0, 14, 7)*
>>> +#define SYS_TRCIDR7			sys_reg(2, 1, 0, 15, 7)*
>>> +#define SYS_TRCIDR8			sys_reg(2, 1, 0, 0, 6)*
>>> +#define SYS_TRCIDR9			sys_reg(2, 1, 0, 1, 6)*
>>> +#define SYS_TRCIMSPEC0			sys_reg(2, 1, 0, 0, 7)*
>>> +#define SYS_TRCIMSPEC(m)		sys_reg(2, 1, 0, (m & 7), 7)*
>>> +#define SYS_TRCITEEDCR			sys_reg(2, 1, 0, 2, 1)
>> I cannot find this one in D18-1 or elsewhere in DDI0487Jaa
> Same thing. You can find it here:
>
> https://developer.arm.com/documentation/ddi0601/2023-03/AArch64-Registers/TRCITEEDCR--Instrumentation-Trace-Extension-External-Debug-Control-Register
>
>>> +#define SYS_TRCOSLSR			sys_reg(2, 1, 1, 1, 4)*
>>> +#define SYS_TRCPRGCTLR			sys_reg(2, 1, 0, 1, 0)*
>>> +#define SYS_TRCQCTLR			sys_reg(2, 1, 0, 1, 1)*
>>> +#define SYS_TRCRSCTLR(m)		sys_reg(2, 1, 1, (m & 15), (0 | (m >> 4)))*
>>> +#define SYS_TRCRSR			sys_reg(2, 1, 0, 10, 0)*
>>> +#define SYS_TRCSEQEVR(m)		sys_reg(2, 1, 0, (m & 3), 4)*
>>> +#define SYS_TRCSEQRSTEVR		sys_reg(2, 1, 0, 6, 4)*
>>> +#define SYS_TRCSEQSTR			sys_reg(2, 1, 0, 7, 4)*
>>> +#define SYS_TRCSSCCR(m)			sys_reg(2, 1, 1, (m & 7), 2)*
>>> +#define SYS_TRCSSCSR(m)			sys_reg(2, 1, 1, (8 | (m & 7)), 2)*
>>> +#define SYS_TRCSSPCICR(m)		sys_reg(2, 1, 1, (m & 7), 3)*
>>> +#define SYS_TRCSTALLCTLR		sys_reg(2, 1, 0, 11, 0)*
>>> +#define SYS_TRCSTATR			sys_reg(2, 1, 0, 3, 0)*
>>> +#define SYS_TRCSYNCPR			sys_reg(2, 1, 0, 13, 0)*
>>> +#define SYS_TRCTRACEIDR			sys_reg(2, 1, 0, 0, 1)*
>>> +#define SYS_TRCTSCTLR			sys_reg(2, 1, 0, 12, 0)*
>>> +#define SYS_TRCVICTLR			sys_reg(2, 1, 0, 0, 2)*
>>> +#define SYS_TRCVIIECTLR			sys_reg(2, 1, 0, 1, 2)*
>>> +#define SYS_TRCVIPCSSCTLR		sys_reg(2, 1, 0, 3, 2)*
>>> +#define SYS_TRCVISSCTLR			sys_reg(2, 1, 0, 2, 2)*
>>> +#define SYS_TRCVMIDCCTLR0		sys_reg(2, 1, 3, 2, 2)*
>>> +#define SYS_TRCVMIDCCTLR1		sys_reg(2, 1, 3, 3, 2)*
>>> +#define SYS_TRCVMIDCVR(m)		sys_reg(2, 1, 3, ((m & 7) << 1), 1)*
>>> +
>>> +/* ETM */
>>> +#define SYS_TRCOSLAR			sys_reg(2, 1, 1, 0, 4)
>> not able to locate this one either. I see the bit of HDFGWTR_EL2 though
> This one lives in the ETM spec:
>
> https://documentation-service.arm.com/static/60017fbb3f22832ff1d6872b
>
> Page 7-342 has the register number, and the encoding is computed as
> per the formula in 4.3.6 "System instructions", page 4-169.

OK then feel free to add my
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
>
> Thanks,
>
> 	M.
>

