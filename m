Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11E832A3CA
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 12:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769170481; cv=none; b=h8JvUfBnPm1rJFRrQFPwaQBLpaYhkcqTiAkitqKguN0xVl6C2zVq9LI6x9U/02eSZkIObdzDV2pBc5Rrq7vMUNzXzd0Bsz3uva5GHTrOJ8ZioleB/5N97MR75YOO6vbXNJHD55O242bVUW8PMw5bFXTPeYPMnlF4IthEneg3NWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769170481; c=relaxed/simple;
	bh=Ce9T3W4m6/vcOQUXLPphIZlsQw/xgJGwy4YRYY0Co0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pLzYJx6YmiAiB9MtlXvJBOx7FD3bZUPhI0HSF5vJx5Di6wv7WsT1zsHVjawemcUQ+2vseCxe8PRpmeDeooMdsHuc5RwD2uxypa3XRAkUF9zjfmWWpEq+c6JZlPHugl75j00utoLqAV4xrF82exDwvmE1CzfG0oeXLyywRXoErNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J9qtoVsJ; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J9qtoVsJ"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b885e8c679bso111651566b.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 04:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769170478; x=1769775278; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7TjQY4k+dQBxbGIX17/gmMMohp7SpaOH5R0C6AKyoiw=;
        b=J9qtoVsJRt9khJQYBJKhisL3apohCQSr0nVwd6GjkEEFLuI+ELepbFHcy6c++McVzF
         NTHF1/+9geXUTGNZViZ7RXdbPeBfbHS2eCqrAhy2jHY89CL4lSlHUIgNbIIxmUJY80XD
         hX0wO5qqIrF728b4rajOdQzxn0mPoxA3C8Gb8yJgoDy6GN1W3eCXAlobS6wYtHnAXpSB
         lRwDNiJP83WQDfngEntYqNGcR/JW+Q/mpKbk0wfFwy7VYRyRyJp3eAzaeFj1MEKXAmaM
         N8ZNSg4Mv3qBkq3jNXB9v9bp1jS5tuuO4tSMzIXJNiMDVI23q3/VRTCHLff0FXtOuzr2
         7ESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769170478; x=1769775278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7TjQY4k+dQBxbGIX17/gmMMohp7SpaOH5R0C6AKyoiw=;
        b=caevz5CZ+3+djnvGdJ4LsJBZC9vylSPN+yZW18ymopy/9PqR2z/euYEp4uHkzoV4Mt
         +IuybfqsusyDgOgN1nsaYzq92TsCzU4vAgQOh4qjHDQr1O2tq1J798BnzfjpfdP+sWWU
         CHJmorAL96AQcOTcaSbuSCTk9sdHrPdIxFnHqbhx59LtIatr622dyzPOnhBXoccHNdDn
         7/z7GmwBX+snLfXk9hi5cZtB62GTmMsdcZjdEBe/8HbjcnIHkaxrMmsrHHzMBJBpqCZW
         /hOY+Cf/IQnk62r8MuSYrDAb4HY8AXDPgo7NBMQzMMw0MKh0TPJky/UG76sD6GySAIjb
         bQ3g==
X-Forwarded-Encrypted: i=1; AJvYcCVLgRzaAy9GrotzR5/8+sAvSYYByIPVeeO2sSqNruohG6g+Zj4VnhyevUlOsqKH1zJkQnJ+EYk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGjoPMoRxrRDc+nj1Em6Cf2JT/nTuLcD/0NXeVzbnosaxUnkFs
	t4xghjlx+CW+5njUxKB7FUM3NhtMXDkfbosAmlL0t70CybxqBMBbKo/Z6/BlbUzEYg==
X-Gm-Gg: AZuq6aLIM/NtdMTCgeBuKSuGvOUHnyI5nV4OsHZQuFux5PPbc6ohAiHsRWxlZHhOamJ
	F/GUAEIQ3wNOVq6ytpnKrnZiHA2De6E7z0A2dw7PF/trRYR4jul94xyZqVq1YCMDN8WJonXjCR7
	og1DnDlxktTL4iBzzhls6wWFw3Yqcckf8A7/qFnP4NhtLAj7XJl0mt74ZxdjPsqdQ0Engrfq99X
	EenABjyBTl1hYVdz1jACBm7g73yLxVlN2IfJTXU6nahrAUQMQq1NVdjC/wxDyvCCSobyB6PSUTK
	oQZeJ7tLwGQF4QzT2BO5igHx2nHCOpjfQ6oxrsUfOmEPdsGxv4zwFAqvakITV44v9l1irK6uowj
	4/DTi9oJ738yKf5xBwCH/uyd+crB/UYqzzw+yRaJ5pYSbwUfm3Jtozpj1Vu837xt9sNnKf3WHZF
	84MQN/c/hPc31CmZxnTKL35AZQkL12umoeascVVnTuSJpqIBdljg==
X-Received: by 2002:a17:907:2d20:b0:b73:544d:b963 with SMTP id a640c23a62f3a-b885abea126mr190175566b.13.1769170477880;
        Fri, 23 Jan 2026 04:14:37 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b885b6ff08csm99028966b.43.2026.01.23.04.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 04:14:37 -0800 (PST)
Date: Fri, 23 Jan 2026 12:14:34 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 29/30] KVM: arm64: Add selftest event support to
 nVHE/pKVM hyp
Message-ID: <aXNmKpHqVw93BegX@google.com>
References: <20251202093623.2337860-1-vdonnefort@google.com>
 <20251202093623.2337860-30-vdonnefort@google.com>
 <868qe9mnx5.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868qe9mnx5.wl-maz@kernel.org>

On Wed, Jan 07, 2026 at 03:40:22PM +0000, Marc Zyngier wrote:
> On Tue, 02 Dec 2025 09:36:22 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > Add a selftest event that can be triggered from a `write_event` tracefs
> > file. This intends to be used by trace remote selftests.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 37c015b54ff6..e2de7ad64938 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -96,6 +96,7 @@ enum __kvm_host_smccc_func {
> >  	__KVM_HOST_SMCCC_FUNC___tracing_update_clock,
> >  	__KVM_HOST_SMCCC_FUNC___tracing_reset,
> >  	__KVM_HOST_SMCCC_FUNC___tracing_enable_event,
> > +	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
> >  };
> >  
> >  #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
> > diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
> > index 268b3cd7a1b2..c276fd28e0bf 100644
> > --- a/arch/arm64/include/asm/kvm_hypevents.h
> > +++ b/arch/arm64/include/asm/kvm_hypevents.h
> > @@ -42,4 +42,15 @@ HYP_EVENT(hyp_exit,
> >  	),
> >  	HE_PRINTK("reason=%s", __hyp_enter_exit_reason_str(__entry->reason))
> >  );
> > +
> > +HYP_EVENT(selftest,
> > +	HE_PROTO(u64 id),
> > +	HE_STRUCT(
> > +		he_field(u64, id)
> > +	),
> > +	HE_ASSIGN(
> > +		__entry->id = id;
> > +	),
> > +	RE_PRINTK("id=%llu", __entry->id)
> 
> Not strictly related to this patch, but I find that the trace itself
> lacks context. For example:
> 
> [001]	  323.847422: hyp_enter reason=hvc
> [001]	  323.847423: hyp_exit reason=eret_host
> [001]	  323.847688: hyp_enter reason=hvc
> [001]	  323.847688: hyp_exit reason=eret_host
> [001]	  323.847706: hyp_enter reason=hvc
> [001]	  323.847707: hyp_exit reason=eret_host
> [001]	  323.847722: hyp_enter reason=hvc
> [001]	  323.847723: hyp_exit reason=eret_host
> 
> That's all fine as long as I'm dealing with a single guest, or even
> with a single vcpu. Trying to trace multiple guests, or even multiple
> vcpus makes the whole thing completely unusable, because I have no
> idea what I'm looking at.
> 
> To make this useful, having some context provided by the host really
> is required.

I could add to the event header the VM pid related to the currently loaded vCPU
(if any). I can access it easily with host_kvm->userspace_pid. WDYS?

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
