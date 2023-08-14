Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C158A11731
	for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 12:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692016382;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6/JHoYY/ymn4Vxj5nvf3P8cOen2famnfEyPWo6JqY4=;
	b=R7WLzthEnnQ0+6g+8q2jvAXuCtP3cJXgRgwTO1o6ycHYTeVtIcjGGA14b2uljRwsaE2R6I
	ltYzE2iz+Y5poNxDRGx4xngO7ru4x3Wn+UAAQC6TShg1brZ/kLKbHk5cCucRDC3x3geoho
	Q0ZNfiBm6md6wsA8WgHnufRxIqeJqWk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-JEKMVrzaOSeiAbK_4cS3AQ-1; Mon, 14 Aug 2023 08:33:00 -0400
X-MC-Unique: JEKMVrzaOSeiAbK_4cS3AQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3fe4bda379fso28362755e9.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 05:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692016379; x=1692621179;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U6/JHoYY/ymn4Vxj5nvf3P8cOen2famnfEyPWo6JqY4=;
        b=Ip97THbbMdgtodeNfeQGq9+zcgDtFE2R7147zDIt5Qaf8/EW3TOcoFLC4rEqq8cnRP
         XIMJ9jgPB/qChcp6/VE98tLrn7W3qbbcbugpMpTzUl8Oi3qhnKct/lQGc9TbuWpw2m4Q
         XoTSMKRlWmWGbR4nCRaE09JRG0js8YTJsV9OFkMD5evIJJiwlVl2R8Nmrb0lgKp94wlC
         hg9K9IpTUuSrzPeFK9CPIXtYtLkji0G6aF90YLB88aDb4qMm3U9r846qyzzLcUcXUBCY
         aLH6DOmkviO2wPnvtQzHpjLgwxkdCtbtWGJFQhjfVLEfRdeXxX5E/AzT8fVKkpYflelK
         O7tg==
X-Gm-Message-State: AOJu0YxjrytrVy6hj+iQy2Yu46SoA32Z4yQWW8nPHCiMRBNgTcqMBDgQ
	dversPtbYe9fEOsp3o4WTv6dhFFTnGofLOwOC5HE6lnYCdoeiSmZ4g6BUBGyZf3lrupQjxcnn2Y
	Duiu6zt9tlVjrPNd/
X-Received: by 2002:a1c:4b12:0:b0:3fd:2d33:6a9c with SMTP id y18-20020a1c4b12000000b003fd2d336a9cmr8178169wma.27.1692016379215;
        Mon, 14 Aug 2023 05:32:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEY5H1TYssF7Gen2AJ+Din8wU9zXqLDViFw1ussE/0sMxEza9mJmn7vtba0yYEgK7ZEZxkXhA==
X-Received: by 2002:a1c:4b12:0:b0:3fd:2d33:6a9c with SMTP id y18-20020a1c4b12000000b003fd2d336a9cmr8178151wma.27.1692016378864;
        Mon, 14 Aug 2023 05:32:58 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c231100b003fc01495383sm17307902wmo.6.2023.08.14.05.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 05:32:57 -0700 (PDT)
Message-ID: <039d3ed0-d86c-6e96-a0d0-71366abd9dff@redhat.com>
Date: Mon, 14 Aug 2023 14:32:55 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 08/27] arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230808114711.2013842-1-maz@kernel.org>
 <20230808114711.2013842-9-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230808114711.2013842-9-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 8/8/23 13:46, Marc Zyngier wrote:
> As we're about to implement full support for FEAT_FGT, add the
> full HDFGRTR_EL2 and HDFGWTR_EL2 layouts.
>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> ---
>  arch/arm64/include/asm/sysreg.h |   2 -
>  arch/arm64/tools/sysreg         | 129 ++++++++++++++++++++++++++++++++
>  2 files changed, 129 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 6d9d7ac4b31c..043c677e9f04 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -495,8 +495,6 @@
>  #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
>  
>  #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
> -#define SYS_HDFGRTR_EL2			sys_reg(3, 4, 3, 1, 4)
> -#define SYS_HDFGWTR_EL2			sys_reg(3, 4, 3, 1, 5)
>  #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
>  #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
>  #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 65866bf819c3..2517ef7c21cf 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2156,6 +2156,135 @@ Field	1	ICIALLU
>  Field	0	ICIALLUIS
>  EndSysreg
>  
> +Sysreg HDFGRTR_EL2	3	4	3	1	4
> +Field	63	PMBIDR_EL1
> +Field	62	nPMSNEVFR_EL1
> +Field	61	nBRBDATA
> +Field	60	nBRBCTL
> +Field	59	nBRBIDR
> +Field	58	PMCEIDn_EL0
> +Field	57	PMUSERENR_EL0
> +Field	56	TRBTRG_EL1
> +Field	55	TRBSR_EL1
> +Field	54	TRBPTR_EL1
> +Field	53	TRBMAR_EL1
> +Field	52	TRBLIMITR_EL1
> +Field	51	TRBIDR_EL1
> +Field	50	TRBBASER_EL1
> +Res0	49
> +Field	48	TRCVICTLR
> +Field	47	TRCSTATR
> +Field	46	TRCSSCSRn
> +Field	45	TRCSEQSTR
> +Field	44	TRCPRGCTLR
> +Field	43	TRCOSLSR
> +Res0	42
> +Field	41	TRCIMSPECn
> +Field	40	TRCID
> +Res0	39:38
> +Field	37	TRCCNTVRn
> +Field	36	TRCCLAIM
> +Field	35	TRCAUXCTLR
> +Field	34	TRCAUTHSTATUS
> +Field	33	TRC
> +Field	32	PMSLATFR_EL1
> +Field	31	PMSIRR_EL1
> +Field	30	PMSIDR_EL1
> +Field	29	PMSICR_EL1
> +Field	28	PMSFCR_EL1
> +Field	27	PMSEVFR_EL1
> +Field	26	PMSCR_EL1
> +Field	25	PMBSR_EL1
> +Field	24	PMBPTR_EL1
> +Field	23	PMBLIMITR_EL1
> +Field	22	PMMIR_EL1
> +Res0	21:20
> +Field	19	PMSELR_EL0
> +Field	18	PMOVS
> +Field	17	PMINTEN
> +Field	16	PMCNTEN
> +Field	15	PMCCNTR_EL0
> +Field	14	PMCCFILTR_EL0
> +Field	13	PMEVTYPERn_EL0
> +Field	12	PMEVCNTRn_EL0
> +Field	11	OSDLR_EL1
> +Field	10	OSECCR_EL1
> +Field	9	OSLSR_EL1
> +Res0	8
> +Field	7	DBGPRCR_EL1
> +Field	6	DBGAUTHSTATUS_EL1
> +Field	5	DBGCLAIM
> +Field	4	MDSCR_EL1
> +Field	3	DBGWVRn_EL1
> +Field	2	DBGWCRn_EL1
> +Field	1	DBGBVRn_EL1
> +Field	0	DBGBCRn_EL1
> +EndSysreg
> +
> +Sysreg HDFGWTR_EL2	3	4	3	1	5
> +Res0	63
> +Field	62	nPMSNEVFR_EL1
> +Field	61	nBRBDATA
> +Field	60	nBRBCTL
> +Res0	59:58
> +Field	57	PMUSERENR_EL0
> +Field	56	TRBTRG_EL1
> +Field	55	TRBSR_EL1
> +Field	54	TRBPTR_EL1
> +Field	53	TRBMAR_EL1
> +Field	52	TRBLIMITR_EL1
> +Res0	51
> +Field	50	TRBBASER_EL1
> +Field	49	TRFCR_EL1
> +Field	48	TRCVICTLR
> +Res0	47
> +Field	46	TRCSSCSRn
> +Field	45	TRCSEQSTR
> +Field	44	TRCPRGCTLR
> +Res0	43
> +Field	42	TRCOSLAR
> +Field	41	TRCIMSPECn
> +Res0	40:38
> +Field	37	TRCCNTVRn
> +Field	36	TRCCLAIM
> +Field	35	TRCAUXCTLR
> +Res0	34
> +Field	33	TRC
> +Field	32	PMSLATFR_EL1
> +Field	31	PMSIRR_EL1
> +Res0	30
> +Field	29	PMSICR_EL1
> +Field	28	PMSFCR_EL1
> +Field	27	PMSEVFR_EL1
> +Field	26	PMSCR_EL1
> +Field	25	PMBSR_EL1
> +Field	24	PMBPTR_EL1
> +Field	23	PMBLIMITR_EL1
> +Res0	22
> +Field	21	PMCR_EL0
> +Field	20	PMSWINC_EL0
> +Field	19	PMSELR_EL0
> +Field	18	PMOVS
> +Field	17	PMINTEN
> +Field	16	PMCNTEN
> +Field	15	PMCCNTR_EL0
> +Field	14	PMCCFILTR_EL0
> +Field	13	PMEVTYPERn_EL0
> +Field	12	PMEVCNTRn_EL0
> +Field	11	OSDLR_EL1
> +Field	10	OSECCR_EL1
> +Res0	9
> +Field	8	OSLAR_EL1
> +Field	7	DBGPRCR_EL1
> +Res0	6
> +Field	5	DBGCLAIM
> +Field	4	MDSCR_EL1
> +Field	3	DBGWVRn_EL1
> +Field	2	DBGWCRn_EL1
> +Field	1	DBGBVRn_EL1
> +Field	0	DBGBCRn_EL1
> +EndSysreg
> +
>  Sysreg	ZCR_EL2	3	4	1	2	0
>  Fields	ZCR_ELx
>  EndSysreg

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

