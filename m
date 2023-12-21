Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A436B8487
	for <kvmarm@lists.linux.dev>; Thu, 21 Dec 2023 18:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zshKhxW2"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40d3b2c8517so4635e9.1
        for <kvmarm@lists.linux.dev>; Thu, 21 Dec 2023 10:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703184115; x=1703788915; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VwZTHk3UTSsz5JMRNija8+Bfh2RqE8ERmTcvnZMhCzg=;
        b=zshKhxW2qvnB3yS90h+rEwpC8IFXBfWR4shFkLCCF5ZKIs3nG139KxlzdScX43yLS7
         Zh/26P0KoxdsRR6MVEeKBXxt0CR6EowtmcJi0Dk6LJPtN4GWke4lmL37LnzMzJ/W8nSs
         FftYHQm7knx3SMrdDYxuno+av8Fu3DmvosxHiy+C9iSJAhFLLznfn7UIJkI4uwxdbu+r
         sE0M79QtioTmnH0dU6nvNty102nt0nKCTWo6oShiAI0Az0LSN/5GBSiWQr6rI5VUf/C+
         7X+bz81MbE0G1l/Ecwmb1fFp2+RNSkULMrU9QHlJsX5zUZbsLJegY9pXnhdVIGuSVX4Q
         RfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703184115; x=1703788915;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VwZTHk3UTSsz5JMRNija8+Bfh2RqE8ERmTcvnZMhCzg=;
        b=gZ31s6tiQRT51ZUGm6fZBhYutLLs2MJ+zmQe5G7n6nQlrofOv02K7wrYCEA9o8ORLL
         W40aWFvdN/1CKLwznqulfLzkn6liUko40yj1my1OJsX7RH1MOoOZofLJ16dDGSFWZmEZ
         pmilskPHasw841slFELsxzqZc9dMZlKPmPo/KxDyL4x1Q0f2B4M5aG4KWPIN3KwD+8Ti
         ZsqOXHg1RKhhqdb5m3CLoXWC4Ey/lsfyeR2lBC0NA/LV0SnqZDS/tbIX+f5LvSh+nqPg
         WU+DsXfUcN+kQY/HqlsxGs+Mosj6Hwl3MpzaTWbz3hy2oLvIINlxhLxKvI7uukzPpdYF
         r7Ew==
X-Gm-Message-State: AOJu0YyBSPHJ4wqtqLSNJja3SXOKx4P3RZdeKUrRxWHwJ16ehUmsU06K
	iE+g6BEKqE/NiEN/qhGSZMNVIqtCcOom
X-Google-Smtp-Source: AGHT+IHmRtbvypnZnpOZwWfjpjGEUn4VFd/E7QiMtlf9JClG0PYD+H6AEfgvooHxAe2DNf7e962CdQ==
X-Received: by 2002:a05:600c:982:b0:40d:3fbd:dda2 with SMTP id w2-20020a05600c098200b0040d3fbddda2mr234wmp.1.1703184114704;
        Thu, 21 Dec 2023 10:41:54 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d530e000000b0033668ac65ddsm2592115wrv.25.2023.12.21.10.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 10:41:54 -0800 (PST)
Date: Thu, 21 Dec 2023 18:41:52 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: will@kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com,
	mark.rutland@arm.com, akpm@linux-foundation.org, maz@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	vdonnefort@google.com, qperret@google.com, smostafa@google.com
Subject: Re: [PATCH v4 00/10] arm64: ptdump: View the second stage page-tables
Message-ID: <ZYSG8JvOGy8Silz1@google.com>
References: <20231218135859.2513568-2-sebastianene@google.com>
 <ZYSFrFDHKo_ZTkxM@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYSFrFDHKo_ZTkxM@linux.dev>

On Thu, Dec 21, 2023 at 06:36:28PM +0000, Oliver Upton wrote:

Hello Oliver,

> Hi Sebastian,
> 
> I'm going to try and review the series a bit more after the holidays,
> but in general this is unecessarily complex. Furthermore, building out
> the feature for pKVM *first* rather than 'normal' VMs makes it all very
> challenging to follow.
> 

Thanks for having a look. This sounds good, I can split the series into
two afer the holidays and push a new version because I am really not
happy with my current state of the patches (especially because I
discovered some issues after I subimtted on the list).


> I would strongly prefer that this series be split in two, adding support
> for 'normal' VMs with a follow-up series for getting the pKVM plumbing
> in place for host stage-2.
> 
> -- 
> Thanks,
> Oliver

Thank you,
Seb
