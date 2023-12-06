Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DF54597B
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="hrx5SD/W"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2c9f85eff28so65008831fa.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 09:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701882459; x=1702487259; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVDl0W64scqWE1Z8AX7nRmNMJAFAUWb+DRtdm5KXlE4=;
        b=hrx5SD/WQ2/6aqUYe7CqQm7DFpYEwJg+99QJSAF2QNCa6IInugNPo3fmzrUBgpTRGM
         hDYQqF/zgeOAl1QjeChnk7fnnU//qLAwAIn4ANK9avfUf9T3G3oOFZW6PpYSdIBqPmsZ
         nI1zF1Z7KmkLleQuUXleFuzDr4QzXQpGBuK9YfkUwTA7mBpuAgcZm7zcioRTryLdJOhd
         +xrTnPdVLgRvkdQt0I8NyvqQY8yMn01xIHpi4n6kBDOU1nCU1C0CXBA52hdan5MX8PzM
         iQR1cQHAESxsDAbL1kym2BQA8E1A5XSTkSo9f0vuxrrWGZx/byl88SiPDWdHQsYkGLbD
         6yDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882459; x=1702487259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVDl0W64scqWE1Z8AX7nRmNMJAFAUWb+DRtdm5KXlE4=;
        b=rgyzJxeO5hUd/ZEfCgD2JYOCSt3eqJcNdTb/00Mk9uZu8l5LXm7g6PIcshmHsoTEw3
         0xHQXYVGF5dKLspDn5QZdQO9TX9if0dBSv3F0o0Vd910uyLgD4gunV83ol5oupEdOi9O
         3zSByBbI90N4Xlv4nlnZ0MAyeIdNEmU72eaELihLKjsf6M50GrLVv8fT/VmUiVYn2tyD
         287ylHzc4YqIJK+LDdQx67AOhaM8wVBHYTwEgknG14TZCALQ2V/AcI5jvJ00RU2A9o7z
         ZzpXKNPokZ33PzRmYOENCjXzqHiiqojqDwXWS70MX0pvyo8ZfY+hVMzywd/cmBILalHz
         hNJw==
X-Gm-Message-State: AOJu0YwW+oCAvk6gY7h2rOdBWgtTiipdScGIKVljp2zsZaVyCy+huQ/i
	pwdS+VxMkKINk+/AMLnXh3GQmw==
X-Google-Smtp-Source: AGHT+IGeQ+chN8itji8iVK88ohy3+dv9u0czbDONNHlaOKS0xWPMsN/mkH2BtWaLEtpakXlc6flIbA==
X-Received: by 2002:a05:6512:507:b0:50c:c7d:9ef5 with SMTP id o7-20020a056512050700b0050c0c7d9ef5mr827625lfb.10.1701882458751;
        Wed, 06 Dec 2023 09:07:38 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id fx14-20020a170906b74e00b00a1cc1be1158sm171675ejb.165.2023.12.06.09.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:07:38 -0800 (PST)
Date: Wed, 6 Dec 2023 18:07:37 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, maz@kernel.org, 
	oliver.upton@linux.dev, anup@brainfault.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [PATCH 0/5] KVM: selftests: Remove redundant newlines
Message-ID: <20231206-6c869e5bc8ddf3b93e5b6fd6@orel>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206170241.82801-7-ajones@ventanamicro.com>

On Wed, Dec 06, 2023 at 06:02:42PM +0100, Andrew Jones wrote:
> This series has a lot of churn for dubious value, but I'm posting it
> anyway since I've already done the work. Each patch in the series is
> simply removing trailing newlines from format strings in TEST_* function
> callsites, since TEST_* functions append their own. The first patch
> addresses common lib and test code, the rest of the changes are split
> by arch in the remaining patches.
> 
> Figuring out which newlines to delete was done with a long, ugly
> grep regular expression[*] and then highlighting '\n' in the output
> and manually skimming to find, and then manually fix, each instance.
> I'm sure there's some AI tool that would have done everything for me,
> but this was my chance to prove I'm still as capable as AI (well,
> unless I missed some...)
> 
> [*] grep -rn . tools/testing/selftests/kvm |
>     grep -Pzo '(?s)\n[^\n]*TEST_(ASSERT|REQUIRE|FAIL)\(.*?\)\s*;' |
>     tr '\0' '\n'
> 
> 
> Andrew Jones (5):
>   KVM: selftests: Remove redundant newlines
>   KVM: selftests: aarch64: Remove redundant newlines
>   KVM: selftests: riscv: Remove redundant newlines
>   KVM: selftests: s390x: Remove redundant newlines
>   KVM: selftests: x86_64: Remove redundant newlines
>

I forgot to mention that this series is based on kvm-x86/selftests.

Thanks,
drew
