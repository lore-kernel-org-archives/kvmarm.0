Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863294C92
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714348; cv=none; b=SepZffuElNF8e/gsJpJw5XmWOno9DudRnqJLxsrQwqAMpH8Yqc6NirUV7a2l04tZ8ZElEOfx7yiJQMvNIMFt49gWJ6bt90M5bLYQxght/iV7WcMQcVXmEL812ml2gG+uKDqN4E6Uhx5eLqTxsx+hsyfy2KY5Eg0Ill8W29LNIrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714348; c=relaxed/simple;
	bh=iqhjSaFY1NK2RmEHmEY4nfC3XYq9uJMqxq+Q9/68dqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRe2axeIY2DNQsXt8FWaOQaiECYwbLZHqX53IiC90hmIiZnltSjrLYekOqs3IEPa3RB/B4gmeb35a9kV1tHzxqD348T9ZE98BYntEQPwfSkse1gvIHXgMPuZal7rq0nDbR2pQNwtLZkEfFqKbcPLBIDePa1rYGBjeOB4ZNT6z10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z/uMQ1Qo; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z/uMQ1Qo"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47aa03d3326so9538335e9.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 07:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767714345; x=1768319145; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vwkvkcWyxTfbsBLkYMdbStPrn+nfObXSdUlXH9TTP/A=;
        b=Z/uMQ1Qo5i8sRs8MWF8AXR8f+4T79Ef+6QXvAAhgnIoHgvL2lR0YXwZOPhJ3clqd64
         kJpA5RAe0se7cL5sVczhQAMNpI8c1yRtsNBzplgnILCncxVO6+TmGOsKapQ3b47ho/xz
         plPUowcpNE5shuFkZTr8q3JRlZ1Y81uz7v0lQ/ZGt9mkZTeFfuPLEt7H+CfvGevsFwfW
         kgCx56TrNPllZ3590IT9oHlVWMEuz/4Up0f277x2QWe0Cqkp+9xO1gjtURb/4956J7yw
         nkjEj5NlkUxgT9yZdDwtmCQMvfkCGJbycxF0+pj9ilGmOW3V4iptCE8Mo7pZy8JeN6Kq
         P3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767714345; x=1768319145;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vwkvkcWyxTfbsBLkYMdbStPrn+nfObXSdUlXH9TTP/A=;
        b=YiSUZn6R7tCATlr8WRwnSxQG95DDFrAdgZoGJzw+CSdErf8QPH7Kv+hXnJTy70cVay
         gbUzqhgDGMJ/ykyAzyvSpqz1J+V8xjqmO6MMABssqc9av0Reckr60d1XbqEBoJk1AToH
         IPY1N53w/pAaEcmJU+FXybK2LptdfogsLfIVdQJkFaYKnSXZc6PBEud53h0nHft+nHxT
         mb/whd9RPhmEkLljsce7IHPIkWSvv6XUJbOVfbRA7JY2Z/oASxv8WI6WCGMBGHtLkMzC
         5ekO3bh/YzuXAtthvO0l+4SnXUZ+6lMA7pC4bRAJdbEL2h8NKCZXvHuYUyr+nQT2VZWf
         kUjg==
X-Gm-Message-State: AOJu0Yzsj2FH6j2TVVJ8rqkJEX+SyF3sYE1VTP0jsGMxFzMF3QUyXHPd
	bZ4ffuPgHEx2YoyhXBzgy7k6itux7b2LtlKoNSCimLkQMtQTLnMbluYv9pZnP5xF9w==
X-Gm-Gg: AY/fxX4xlpf0W7vn2cXBaDG35i+pSmZuFRWYBiSXgwWd5xEGEK+5y291MSjUmIggs94
	3UgmrdU7szz+Y1pwBMK7I0nCjxzAX55k7G0od/qcV29GlA6X/EM/FLcEh7bA+xO+ww67kp20b/b
	FC8u39k4nJ4T3Xjwhsinp3oPvJN66U6wCpq2i1SDWwhMtY7LtQZD2FmwQq7eEfXoPgO+t9+Q4yn
	y5aPkNtx3/WTmJwTx3uDYtmUKGpqeScV9lytEf7tS7gRiS8KMbFNKxoqHbE29xW133UkHVlV6wu
	8KjUhhQfPxit/fhIw3dOS23I82dqf3WpflqnwvSTrD+XHf/s4zSsj7LhzmH8BKwihayhCNmd+d+
	Ww7JQTnzmW1cgU0yFl+0ZKVh4zVI09R7PLwKjWsRJBHxpqUu7VR+VixNXvLgQLXhwcqpPOeEALT
	/2lEc2sDym8NBmu3g0AHMpNPvixZxJF0EJnOHRxLStlCsPudzuhQ==
X-Google-Smtp-Source: AGHT+IFtTU8v0TC6GJrNdhgpjBrqhdm4O/5Wgr4IoH2l3qKTodlEKzvW1qkwoysFQFNCHokEYgD4gA==
X-Received: by 2002:a05:600c:4e16:b0:477:63b5:6f3a with SMTP id 5b1f17b1804b1-47d7f09d505mr43410595e9.27.1767714344644;
        Tue, 06 Jan 2026 07:45:44 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f4184cbsm53680785e9.6.2026.01.06.07.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:45:44 -0800 (PST)
Date: Tue, 6 Jan 2026 15:45:40 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 24/30] KVM: arm64: Implement the MEM_SHARE hypercall for
 protected VMs
Message-ID: <aV0uJDtZwbu2iKhs@google.com>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-25-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-25-will@kernel.org>

[...]

> @@ -952,6 +1004,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>  		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_SHARE);
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID:
>  		if (smccc_get_arg1(vcpu) ||
> @@ -962,6 +1015,14 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
>  
>  		val[0] = PAGE_SIZE;
>  		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
> +		if (smccc_get_arg2(vcpu) ||
> +		    smccc_get_arg3(vcpu)) {
> +			break;
> +		}

I wonder if that shouldn't go into pkvm_memshare_call(): that function has the
knowledge of the argument content since we pass vcpu.

Otherwise:

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> +
> +		handled = pkvm_memshare_call(val, vcpu, exit_code);
> +		break;
>  	default:
>  		/* Punt everything else back to the host, for now. */
>  		handled = false;
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
