Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBB6551987
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092247; cv=none; b=H3vl2dHl14b/KnY9b5qGGE5p+3y8B1rNhMfVrUJs8HRzH42KLG1M1gJJD5JNpEdtN51dFpCa5n9007ljlRpOGHQguAyqHH7p+RLNElDuXofGgBAxWWVNSW67kZdp8uv3iwTEoL2VCAs593m8CTt8OVyp0PavEPWRBmia8/ytNtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092247; c=relaxed/simple;
	bh=439gmKqGSkI0bSgfo/c8tSzeErhRdn6H6zh2Wpv0viM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mg9hi3WvihU5/haNyuoo6EnMwJADwticD2i2lE5sRrCiYsAMonUl/McrmABDU2M1Ssal4c40imnMCJYHAA+ah8hzr+N1BmZq9uxvGRtN9N72M84xmORVseij19baM0A/0vyGIQ6cy8SwvkkgDE/DlOf5YXmk2nER3Bb2fjcKtX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=axglfwqh; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="axglfwqh"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49e65a8f70eso47955e9.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 08:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790092242; x=1790697042; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pQklSd2If0fiviP4ibB0laMw7g6bcjewAcYXAq+ENYg=;
        b=axglfwqhIsiB0ziSpNONRgGwm7jvc4idaL2YenZ9uUTaKZrbrZ+XxyQRahlbeI9hRD
         ZtDuZlMCUtTJQxMN0Hix3jOJdXSQsZ5mIQV0jEvCy41+PproZC0qrSvwxKMqiv1lbIZf
         EXIyZuZsvu0SlCSdXlL1k22gOEPzD8T80HMzy6kKDwOhPgT9VBmaHutHgQAW1JW2tIVY
         NG4s78cKRis7DXV7r3fAYetGV6obE8u0rurZ1ZKtXmgWqHe6xNt57/mo7QoHY/kWJJsP
         nP5kmFNjoo6xBUbYQ/Ax+xq8u80vkwxo91wbjlJQfGBiS5UiJRqOBDuyetICz1dVCK+w
         4CNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790092242; x=1790697042;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pQklSd2If0fiviP4ibB0laMw7g6bcjewAcYXAq+ENYg=;
        b=njfbAHPDfqu24bslBPktkcpb4pVVAqX0WFQpi6Y6+ZKYseLZLeaYftXJeJoFtl7skV
         r5AKHBgYbS6qFU5mmbbYyk1C1NVzBWyaWRqQnXSs5XSUYQVWIeeOitPxCZ/sTeTIx2lr
         XsPCpYrb7w0qv2IC4SUpCWAoaDhaMyD8rG4GJ8q6ZHrzwe287sK6W6h8GD6UG0CMxiOI
         FjvIAguGlXrwOLtKK6CEqjQweNqKB9SQM4NXNGT/x1M+VcXpjQIHnW0fu8J5ki4GJl8X
         XiXRD0/YP5TbRdz152KSL4g2dCNSf2DwdrkKduKAESLgnBRKJAxWB+5L2RhyPRRdulKG
         lNug==
X-Gm-Message-State: AFuF++lo9/VzzlMwNRwEkn/+jRfvzQaoTEZYE9f/Tcao+UahSsOdzC6V
	8F6CLTEmXBbWvPkNC33g0LZpSfVUTLBK1Bg3tcN9TRkAx9i59Q85jDtv9Uove7FstH9RqEzjjXM
	EX3ojUg==
X-Gm-Gg: AYBFou1Sjzfv9rtvLCDsC7wp4v7lYHwcB2M3soPx0aScJvWbeXcVu0NvucsB3SaHM4g
	GkDi542CvceKsj3lDfbFK54rWmnLqCUyPcp2fPA7wU9JQiwDV8132zITWsndDu3s36ywDBztLC9
	FurBAiDJW7LjDWJLRDXPFaJ82YgT9lPirfGFrySHcP4p3pwae1n0ZtLD4c7koL9VsdKWcOoduY3
	ANWt/v8wsACqOHX8ydokg+Zi+5dc18/ygErw94u6OA6111mFB1gg04vhJF00QO7xACf+FLv848w
	8lMYOEJYgUGD1s7FRMgmE2+33H2fddbspn/I2QQt3933pDDey33xcL05ClXCIWvagst6PaCc2aA
	QTiRjt5ZpXJdwgDBo6/G6CynG7FdqWqLgllh4FCj8+50Wn52JmMz6R+V3zE2gbX61r0i9jb8mQ3
	/02Aa8aloDB/Uf44T97qPa4H8zxVZQMLDFIUs6xGOgvufCekCPbIGzs38KFT5hh7OPJzMsEF09T
	DvE+eXVxzUJFu+IN/oPuc07L35IsMWZWku8/iO15n6UM3uOBaM=
X-Received: by 2002:a05:600c:1c06:b0:49f:ddcf:45b7 with SMTP id 5b1f17b1804b1-49fddcf467fmr169095e9.10.1790092241625;
        Tue, 22 Sep 2026 08:50:41 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886277def8sm6355003f8f.14.2026.09.22.08.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:50:40 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:50:37 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 17/25] iommu/arm-smmu-v3-kvm: Shadow stream table
Message-ID: <arKjzVDb56JmHJMc@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-18-smostafa@google.com>
 <20260922133309.CD1F51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260922133309.CD1F51F000FF@smtp.kernel.org>

On Tue, Sep 22, 2026 at 01:33:09PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] arm-smmu-v3-kvm: unhandled break in switch statement causes EL2 panic on STRTAB access
> - [Medium] arm-smmu-v3-kvm: improper WARN_ON() usage for host inputs allows trivial EL2 panics
> --
> 
> commit a05ba1b1951c6df5b35f980e9826eb9d8a4ea188
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Shadow stream table
> 
> This patch allocates the shadow stream table per SMMU with a maximum size
> of 1MB for 2-level tables. It sets up passthrough for host writes to the
> stream table base and configuration registers, laying groundwork for future
> CFGI command trapping.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> [ ... ]
> > @@ -438,6 +499,46 @@ static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
> >  	return ret;
> >  }
> >  
> > +static int smmu_update_ste_shadow(struct hyp_arm_smmu_v3_device *smmu, bool enabled)
> [ ... ]
> > +static void smmu_emulate_enable(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	/* Enabling SMMU without CMDQ, means TLB invalidation won't work. */
> > +	if (WARN_ON(!is_cmdq_enabled(smmu)))
> > +		return;
> 
> [Severity: Medium]
> Could this WARN_ON panic EL2 if the host enables the SMMU without enabling
> the CMDQ? Since WARN_ON at EL2 behaves as a fatal panic, using it for
> host-controlled inputs converts an invalid host state into a hypervisor DoS.
> Would returning an error be safer here?
> 

Yes, as I replied before.

> > +
> > +	WARN_ON(smmu_update_ste_shadow(smmu, true));
> > +}
> 
> [Severity: Medium]
> Similarly, does this panic EL2 if the host provides an invalid stream table
> configuration? The pKVM guidelines suggest that EL2 should not assert on
> contracted host inputs.
> 
> [ ... ]
> > @@ -525,7 +626,23 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> >  		}
> >  	/* Passthrough the register access for bisectability, handled later */
> >  	case ARM_SMMU_STRTAB_BASE:
> > +		if (is_write) {
> > +			/* Must only be written when SMMU_CR0.SMMUEN == 0.*/
> > +			if (is_smmu_enabled(smmu))
> > +				break;
> 
> [Severity: Medium]
> Does this break statement erroneously exit the entire switch block for
> ARM_SMMU_STRTAB_BASE? If the host writes to this register while the SMMU is
> enabled, the break bypasses the mask assignment, leaving mask = 0. Later in
> the function, if (WARN_ON(!mask)) evaluates to true, which triggers a fatal
> hypervisor panic.

Not an error, that is the intent, a panic will happen if the host
violate the spec.

> 
> > +			smmu->host_ste_base = val;
> > +		}
> > +		mask = read_write;
> > +		break;
> >  	case ARM_SMMU_STRTAB_BASE_CFG:
> > +		if (is_write) {
> > +			/* Must only be written when SMMU_CR0.SMMUEN == 0.*/
> > +			if (is_smmu_enabled(smmu))
> > +				break;
> 
> [Severity: Medium]
> Could this break statement similarly cause an EL2 panic on STRTAB_BASE_CFG
> access? Like the case above, this appears to leave mask = 0 and panic the
> hypervisor.

Same as above.

> 
> > +			smmu->host_ste_cfg = val;
> > +		}
> > +		mask = read_write;
> > +		break;
> >  	case ARM_SMMU_GBPA:
> [ ... ]
> 
> [Severity: Medium]
> Are there other instances where WARN_ON is used to validate host inputs?
> For example, in smmu_emulate_cmdq_insert():
> 
> smmu_emulate_cmdq_insert()
>     skip = smmu_filter_command(smmu, cmd);
>     if (WARN_ON(skip))
>         continue;
> 
> And at the end of smmu_dabt_device():
> 
> smmu_dabt_device()
>     if (WARN_ON(!mask))
>         goto out_ret;
> 
> Since these are directly reachable by the host kernel, they allow a trivial
> host self-DoS by inserting an unsupported command or performing an unhandled
> access length. Could these assertions be replaced with standard error
> handling or abort injection?
> 

Same as above.

Thanks,
Mostafa

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260922131259.2975334-1-smostafa@google.com?part=17
