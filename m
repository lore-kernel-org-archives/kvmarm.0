Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B686444AB86
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 13:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552045; cv=none; b=gfglTVHS7lRpzbiKZvPV8uALc01o6Aeo5Z6gTh3NgBvFI6PljobHRxdva2w/O0L4ZKL264M+oRtHS8ANY9hkMvSgjxI/4uFcr8WoSRZLBdK9c3McOqodjKIqlMTakk+8HlS+faMSuiqSw/rCWLk2eTVezWeE+vS3gzNX53vjzlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552045; c=relaxed/simple;
	bh=XOyCPOVOJVkEA8iQMHxsS+Sgslr6atxR1YJF6kOqPlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdYO8KNdbSAXYEJY40Z9d8KxItNmtPwsQr9Qqn27WJ/QxeNUz9K8cvGp4EHOUAfOSzwXQNt9yQdvNbrz5Dl6fRSpmflufFnwkW/l3S3tmrfW+lKeOGSLb/HCmPgbZQrE91xBd8xK6jXo1ayDjkMvwLPekThIcKhiwtJqd8/N4LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RcmVpPwx; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RcmVpPwx"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a171b677d2so29528235e9.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 06:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791552042; x=1792156842; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5WsxvmTXnugqlwlP9gNKWseJDOdqZigaqk1q1Hbj0aM=;
        b=RcmVpPwxjrrqoukd3YyB0zh6kp7cTJgQ0AtddJNp97PMNHDk2zgFj2xfcukVfyaFXZ
         bEUbVH9MNHFDYLm1jljWD5NJoKo1FNzaqHMMIfkdcqQLTF+xRDgICsVINcmUxtWpoJ3R
         n9UE/C9A3wh1F+qIDBvJTKrO+WV7Zy+XgNjRbrdoXXIdYdKi8+YtPxhyBAwhgZM2j3CY
         wwvhCq81zvz6NYSLz3GWU7VhOU4KOiuVEusJP0U59Gx6c4N+0Nzq4XDxYTj5WTCKHYjM
         seuQTN9lvBjYb1+sKSGBX/ZRMsonxXKgP6omwP7tt10FVf5sE3AI0Dgci3mUZa3+PwJh
         aChw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791552042; x=1792156842;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5WsxvmTXnugqlwlP9gNKWseJDOdqZigaqk1q1Hbj0aM=;
        b=1KTmKyjeVUD4aSvfSoDInRyoLBtaU/Poqz3DXDK5NquB/WmjOwlgjjF0u0A8r5Gzzf
         RIF6fouMdDFrli6X4ZKOI4QmfhcxDgTkBBCmPSwcJLDlYf5hDSEIz7vML6di8Zm0p4cn
         sgUKqDwyZTI2FmVx2gw/NzgsxeCIdlme3Z/6DKexTZXVU/Zk0OIQBEUC1RVWGfE+HpXE
         fv11fNKdOo4RNHghZVnirzOG03GpkPjG19rijjcuRisqd9MS5O4UI+16okuX3bHmz8VQ
         dV9sQBCWWGKUq85NpWK/lb/hFj5Vcpm4x5Biv48ymgYPDHiBC4KKfezjBIeSdl8DCET+
         ijyA==
X-Forwarded-Encrypted: i=1; AKwUvBwKCfXVxd29BGyoYAN/et8PrmFzrYlPIaOVOfw3y6aLvQ5QCI8zN8jD95Y2CIkpi3+CU6VLd8g=@lists.linux.dev
X-Gm-Message-State: AFuF++nsB9uHcpDNFjLGn8lvxu1HhJrn18mRw6blOSyhbuAEbGSYQnzU
	MplRtC0wczkYLFzjX2yBfv8ZWOYj4dbjCw6zNbcUA4JhWtgO1FT5knyJvEbvOpCf0g==
X-Gm-Gg: AYBFou2KQYzbb++tT1OBZEq8IM+YqrkvxseQKj1/uUlGErsw82PM7za0ZPEjYfn/zpO
	zLRtRhOBfYHoae+KPTInllAOQAWD1nfpdrnKLFhhVBBvCpePPYOM0c/Z+kQHNHS53PniBRRNPt2
	RUgUKalwvU87NAJiXS6MjgnDPqZflMwmq+CyNcAhblxiwh9iVzLhysG10iopt6vuU+LANL5kEja
	DB2fluiIGELMDy8jMCRg+jRR0n97B2SDx8nQT/jZbDlAxj3ZA9sB8jGfgcvLV/MyfpqLgIvuZQU
	S+MoiL4nVkpS/rZLLqBxOkClnWydogmCopmjflCFOyYYNoIPT1ePNh7X2dNikSYqEiyEnfxAfay
	nJ5EbRGOaOa7oSSvYREcA2yuiYvYg439Rbc3T0+p1Xon0B8sX7y8CxxW4SprqIM7X1OtjHusc/9
	CSAzBHoT6kWcLWrfThROgSK8N/PGcCVQO0c7QrsXFEFfQAkw5Ffihy3koISbv3prhiaBkFIEmR9
	CKGQQty2AKU29Iej8pvoYIGJN/pZPYoZjyWGcDpl4o=
X-Received: by 2002:a05:600c:5391:b0:49e:7a10:1b71 with SMTP id 5b1f17b1804b1-4a18e4a003cmr36287735e9.11.1791552041463;
        Fri, 09 Oct 2026 06:20:41 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18be964dfsm58570675e9.7.2026.10.09.06.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 06:20:39 -0700 (PDT)
Date: Fri, 9 Oct 2026 14:20:25 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add host_hvc hyp event
Message-ID: <asjqGQglerqNrMrG@google.com>
References: <20261009084529.462577-1-vdonnefort@google.com>
 <20261009084529.462577-4-vdonnefort@google.com>
 <CA+EHjTzdEXHxkMtSU3SybNxy+Fece339bsvyc6L6K_iySdRDfA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzdEXHxkMtSU3SybNxy+Fece339bsvyc6L6K_iySdRDfA@mail.gmail.com>

On Fri, Oct 09, 2026 at 01:26:22PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Fri, 09 Oct 2026 09:45:29 +0100, Vincent Donnefort
> <vdonnefort@google.com> wrote:
> 
> [...]
> > diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
> 
> [...]
> > +HYP_EVENT(host_hvc,
> > +        HE_PROTO(u8 id, u64 ret),
> > +        HE_STRUCT(
> > +                he_field(u8, id)
> > +                he_field(u64, ret)
> > +        ),
> > +        HE_ASSIGN(
> > +                __entry->id = id;
> > +                __entry->ret = ret;
> > +        ),
> > +        HE_PRINTK("id=%u ret=0x%llx", __entry->id, __entry->ret)
> > +);
> 
> id is the index into host_hcall[], so its value depends on that
> table's order. Could this log the SMCCC function ID instead, as
> guest_hvc does? The alignment issue from patch 2 applies here too: the
> format file puts ret at offset 3 instead of 8.

Ack. I thought this might be easier to get a simpler ID. I even contemplated to
stringify the list before convincing myself this wasn't really the hassle.

> 
> [...]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> 
> [...]
> > @@ -996,6 +996,8 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> >          cpu_reg(host_ctxt, 0) = SMCCC_RET_SUCCESS;
> >          hfn(host_ctxt);
> >
> > +        trace_host_hvc(id, cpu_reg(host_ctxt, 1));
> > +
> >          return;
> >  inval:
> >          cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
> 
> Only some of the handlers write a return value to x1. For the others,
> x1 still holds the first argument, e.g. the mmu pointer for
> __kvm_tlb_flush_vmid, so host_hvc's ret field shows that instead.
> Could the field be called x1 rather than ret?

x1 it is. Perhaps I'll rename too for guest_hvc.

> 
> Cheers,
> /fuad

And as always, thanks for reviewing.

-- 
Vincent
