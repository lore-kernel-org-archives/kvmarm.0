Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB0D35CB70
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 21:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769722493; cv=none; b=WbdMRGymgjd3Jt+rQbr+VP2sRX6VWxltXb7KrKzvy+GA02iW3er6Oc2EJjmQCB4qdcJq+svsXzc9Hn5RgGNeKHflVGYDt678GiVPvqBKPySNyy7I25qO/NPArmPJ8F33kJpyhdc7CuAE3eE8GGuvauEYyHKmhztrOoqGDVYeDsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769722493; c=relaxed/simple;
	bh=gNib5OzDxnus3NMxZ0EBqOkqUXY/IHxRC7kvLGUhqaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CT6KBAIYRWKtQLdRJGHpX0hu3pECN5lwCzVevWS4V/zOzQCM0exgNU6QQEB0L4iLvWdebX89vTF9rOSN4h6GZlWvMwRvgLzuCbFHxi0Gmg534nukueww+K9l8P+l9wg0XtQjxu3Wj8+CYh1XRT+vWztIk73oUjKlbQ6K64qYV6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=arfNFDIs; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="arfNFDIs"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4801d7c72a5so11105465e9.0
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 13:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769722490; x=1770327290; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fuuFLD2E0Oz9BYdeyyjQ2aqYMkX3G7CJ//5VT0Rpgo4=;
        b=arfNFDIs6/a0/zSl0fmmqAuPCKCIxbEKn9X3DTQJEc7xUzqm2enqEvPwJ5CpkOuw3f
         urAdVV+n1cV2mh7mVi1lwfVmSnD0u65iY7DH5LATK+7gVJV5GYOdIMEN6FXFG9dZiacX
         cmPLHHjNguIqAfV3rUxnOGMYC+9yrTiRJXw658hOZYdnCRs851fpesJVUxqlrrjk+9uW
         3RO1890mfCISSGUHBHPvXoicUXStOWcj9IqYaTdXSezi/0MSkN+Sg7FP6NXD+qLVNDCk
         86DUtkekElYRiWJ8rlSd2tiEwX2QPY5acCKqH3kCW96vQf146Eqz0yztrLp64Leq9SgJ
         kCVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769722490; x=1770327290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fuuFLD2E0Oz9BYdeyyjQ2aqYMkX3G7CJ//5VT0Rpgo4=;
        b=KmpCcEi07xAYnNoHVxB6EvGhLuOMSgx7DfqdmpIMoKn1R+d+56xcO38eVvTVx6tUrF
         d9OWFAAOAIRysrydENoQukOTA9kwhR22roEbDFsMfPRnDqCA55AKnsmnoPj1rltAO0LB
         DJ8naoxefTlAyLMLy5r0TWqI4XN0nTMpoUGEqbT+z/zzZ8KtmdzvIwAqazaYDjLwXT9Z
         HqLvm1FIzbZ10zlcijezO0e51RXtFaVjxuGIk0R9sfYnn5StcKWJ1EKedZCeb67AyJZR
         rFQYQ4WArBrXbyNTUABJS8fyjZOBbAU4afB6ra3DRhBSqUTAAMaIYEmb+dIBjS2D843+
         xW2g==
X-Forwarded-Encrypted: i=1; AJvYcCXHCZouW76ySauakYXG7oI6xpNDIEA4dHxKx73ooLqyl0o1Gj9jsnyJR0CB5I8b2B+uNbaFZo0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5PVgEfMWbCK0AlwQiyaFFC2lz67D/nvgjI1TPz8YP3n6+V3Ld
	76W+cAH9tsMtfOAoEPHUdKSDHYYHDJOB/Ti2pWf1N7hpDSzlhjAijP193OWcW8skDg==
X-Gm-Gg: AZuq6aKFh/s3GwEdjx1ulWn9R+d8mvVO2UjCqsZMhj0EbDFe0snFbt7MwI7YLoUXuHH
	a8DE7P2PwToHg8hjQ+xhS8a8L6ZNq5/rm7CORobvmg9CLNsR5yN66u0qHvDu/N28gdNziCEML7E
	S0mUZGei9JhZsv07dsJJbIdx7KbitnXzGctT+u+u4VvRGckyKeZhjBclz64lWOkiH6I8uZuvW98
	tApf3zna857P673Zp5ju9SM4QvN73Vx5jqckluiAqJFtfZ5eLADAICqn6M/4z28jGay1oYRz3UY
	MgVJLLi+1lbOEmN3m3tHTCUVnNMhpThxuHKb2t6nkErlU3gc5J17BmckRgY0RfPXNOgWKMo5zCY
	3L+YTz7Chd4LP4pEhazyDHsHjnGXxdAWm7q5cXNrhcpsijfnE1WMIFvp6L2h4aoaqy5k8Mr3ZQY
	zyvTAaIzZHgwsElts+aFYh6TpHfWFtUx9IJ4/BGJj7cgwDFI+QQA==
X-Received: by 2002:a05:600c:310f:b0:477:7ae0:cd6e with SMTP id 5b1f17b1804b1-482db493e6bmr6275085e9.5.1769722490186;
        Thu, 29 Jan 2026 13:34:50 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4806cdd78d3sm156950105e9.1.2026.01.29.13.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:34:49 -0800 (PST)
Date: Thu, 29 Jan 2026 21:34:46 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 00/30] Tracefs support for pKVM
Message-ID: <aXvSdljSYlartF1S@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
 <20260129123739.3c00155b@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129123739.3c00155b@gandalf.local.home>

On Thu, Jan 29, 2026 at 12:37:39PM -0500, Steven Rostedt wrote:
> Hi Vincent,
> 
> I finished my review. I replied to every patch (before the KVM ones) and
> either made comments or added a Reviewed-by tag.

Thanks a lot! I will try to send an update tomorrow.

> 
> When you send the next version, if you don't modify one of the patches I
> replied with a RB tag, add the tag to the patch and it will let me know I
> don't need to look at it again.
> 
> You can use b4 or download the series from here[1] and it will automatically
> add the tags for you. Just create a new branch and apply the download via
> git am and work from there.
> 
> Thanks,
> 
> -- Steve
> 
> [1] https://patchwork.kernel.org/series/1047043/mbox/
