Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501D6254B0F
	for <kvmarm@lists.linux.dev>; Thu,  8 May 2025 09:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746695665; cv=none; b=O00qwh6iEhxCHDS13oIhKVhJYqAh0WrFH0G1WGxxuwGmmNjCx8MwJo2uGCIpaV5LEO4Il03MP98Dw6IMdDti6sg/CFhczQcwVbCrOoYeyEbrj7URqpQ1k8dxEYtmx3hrjeOlvlCCSpjvKHrTi0bX+Ew2jjkzpRpdP28hWuTlkuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746695665; c=relaxed/simple;
	bh=2LdP/A4VnpSZ8Arqppmfa4jFk7aBo9TTHIHZC8kq8fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+aI5ZnfpHCFyqjpuL0CLe9U1+kNX+Tk+WVWbxcgTRgbmDzaJrRC5fLVpXfLImIO82PHK4bipuyGSJXG1X6YWnUbYINrvH2YsRMhE2qxEuawOyNrIgtjXju9uq9cK9PPtljwPfhGPb7KY7aZCFoi2qpTyHEF/98gYdc1xUIXK60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G8cLCsSj; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G8cLCsSj"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43d04ea9d9aso3791015e9.3
        for <kvmarm@lists.linux.dev>; Thu, 08 May 2025 02:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746695662; x=1747300462; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jtD1t5SqwVfSCPyTjNxq3c+2H14P2VPj1wlw+YRYZjE=;
        b=G8cLCsSjBnk9zemPDMeyFnVR56Ynd70M44mSztGZO6MecsjdQruVkU/8+Yt/QZYtL8
         gqtzmsgB6lSRRCpTymWzU8jwZ3sb676ET5kYFpjVhO+DxSFp0Q5f6B+ZToWehi8W3Ocf
         80DBSsv/YHKGw6ngIvoZwG/lVYMkexVSK4O6SNXOuF32Y+eHBTPlpTazTaF726H+lsh2
         pnZ1R87O7FfDd14aY7gaYu1YbkfbhTwI0E1mLI9/pYwyrTfDgJ7Z0ysSEfLWku3T/8W+
         ASw1ffLYxzgAN52qUszVlkeDt9DiYAKhnGZpYDFBk2X8BGJfrUj4XaQrk6D/8TkjtpRY
         3blg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746695662; x=1747300462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtD1t5SqwVfSCPyTjNxq3c+2H14P2VPj1wlw+YRYZjE=;
        b=tiUW2ZXWIZuiIGkESvjzAJChXsZQ/D/hXHtkc7OJD6pTiBYyjp/7Srt8MGUr69IHLs
         N5BWN6phKDPkpXcwSEnxB7A6AmmCNqOYKjhpRJlGd07cPgtFmcXJW9jgK8T3QoU41JiO
         BUCuia1vv+GhVljocv6Vk9H5SYiOKJtZSK/+d2xxBHeQo7kX70IZHrte1tFaWObXPz49
         v1YCkN8x8/3Tt7ZxCtMR313f6Yvvv4NvJ+YVBvCFhsss8SdtmAS+5JSUxCxj/hj/OIZA
         CXsJKdphgngdLpEV8TQEQd1fdgFAVYZuURAort9gYYMxCpWlGdOdcBx5TkOi1UDVDqv+
         ky+Q==
X-Forwarded-Encrypted: i=1; AJvYcCX4UO4JkiVKPn29ZDKIkNXCvNt+V/k7rTPMy24Fvg9Fb1jBu4AiO9WTArgVNKBT844eUQ9kaNw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyemTRKPmf1W50lbEg+MFEn58DSUWmzXUiX5Ya8vHsyUX+36PWU
	C6+G2tGybPbQSN9vXrtf7QKcul6xmoaR0Z0BGSYdJZ7v81tMnvuytDld4oMwAQ==
X-Gm-Gg: ASbGnct9ds+zRYMSiXFcEMmjuxE24VzLs1RAV9gnk+XCzvDbubC7aMSWvmxYWHw6voc
	nkCe2q6ymxUpsP3yfsQZn1mwknLaAYSeuGqqqexuW7MLz6zth/I9WKtVR4oE14tEdNf6idFWb/L
	O+GXpyFyujqcTGlEBWcLsBbwqoLCf/sgTiyXqW/fA0S7YJEgquxPsQQzM29V1YynylQQmKPoE3E
	XsIUJYWHx+bGGlnDdFRbZEDf7znPhnTpQuwPi0GlNuhAjTkpmJ8zcHxG39BDxolY2zZxiagoCXN
	GBPbfkOizdMrNevgOBYOx2aA9cKb/n8mLuMzlNdpoFV0Vghzjqx20QP7LNzEekMw6M8USKCvypg
	GeWE4UQ==
X-Google-Smtp-Source: AGHT+IF9SUYOnKs3lJu1vUeKHxmfYUfp4eeX4TzwT3TxRpgJ2RHbyMATX+EQtKICG97KoSCFK8KYGg==
X-Received: by 2002:a05:600c:3e84:b0:43c:eeee:b70a with SMTP id 5b1f17b1804b1-441d44dd23dmr51647125e9.22.1746695662495;
        Thu, 08 May 2025 02:14:22 -0700 (PDT)
Received: from google.com (24.204.140.34.bc.googleusercontent.com. [34.140.204.24])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd333326sm29694785e9.16.2025.05.08.02.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 02:14:22 -0700 (PDT)
Date: Thu, 8 May 2025 10:14:18 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, kernel-team@android.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/24] tracing: Introduce trace remotes
Message-ID: <aBx16qth045MwQJV@google.com>
References: <20250506164820.515876-1-vdonnefort@google.com>
 <20250506164820.515876-3-vdonnefort@google.com>
 <20250507202444.43963c84@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507202444.43963c84@gandalf.local.home>

[...]
> > +		remote->cbs->unload_trace_buffer(remote->trace_buffer_desc, remote->priv);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void trace_remote_unload(struct trace_remote *remote)
> > +{
> > +	lockdep_assert_held(&remote->lock);
> > +
> > +	if (!trace_remote_loaded(remote) || trace_remote_busy(remote))
> > +		return;
> 
> Can this cause leaks? Should trace_remote_unload() return an error value to
> let the caller know it wasn't unloaded?

No risk of leak here. This acts a like a refcount to make sure the buffer is
unloaded only when no one is reading and tracing_on=0.


[...]
