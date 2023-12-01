Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDDE1FDD
	for <kvmarm@lists.linux.dev>; Fri,  1 Dec 2023 09:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="O1uxGBdF"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40b54261524so19544605e9.3
        for <kvmarm@lists.linux.dev>; Fri, 01 Dec 2023 01:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701422779; x=1702027579; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bjnUIjZvPfyuyaADWQAn6lsAbXJm4+j0sZmUamispe8=;
        b=O1uxGBdFocSQJfUx11HbjaLUDzSVjRh8dmI8oKp3KU3+qRN47okJpgZjGjNF/XQIwc
         McAa6Wt6jibLCtnjhfHGjFIlwW85PXH8FDLIqx+V3Fam5zDMpi5pUTqmVKcdxL/26nPx
         GfYP0r7SWV5xPTjAEnC4OUTLvNwyGyK6Mv+S6aSJ7RDJjbailhikMNSuOdh+QcGAMPWH
         TPUP5Y9l0z7/fOpQBT78vq8Q9SbIsEbuNAMlIpdt7n8NrC8owMWdHS6bGGA0uFKztoPH
         z48wDG1K+kJuw6d0RVsAKBLGj7uxeL6QLGHZSNxSJLFF74/agHRwO24MxmJbR0Ai7ABP
         VQsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701422779; x=1702027579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bjnUIjZvPfyuyaADWQAn6lsAbXJm4+j0sZmUamispe8=;
        b=HnCDva8Nvhy0ZcqFkjIoXaJECsZ0BG5glOD9FipLDo5KBz8Z13chFKBS+yoDRH8945
         H+zh6jvOyTwajAqlmEo5A01HeoBKIqHNmfvh0CDnZfUBMxwsIrYY9j1q3CVCUiNDF2DP
         vQXIlgM540qrBs5JxafyMj9j/sQw8Ydb3ojj+xm/Cr7mOB6iLO6UFPlq1NSOqEHUzCos
         T/+RS0tffwk2GcDF+XoUeD9JUKfqTq2o0JO7gPfy6XCVYHEykhjvqUPiK2Eu/7uenHSX
         d7wU8jghUEYrD0VT3ieQit4VjIWZRXU8b6z1zgdoRKeC/ExbvuTyGtwdjKftIFwkf8mB
         iMDg==
X-Gm-Message-State: AOJu0YwQouQxK6RazLzF+Bfn0LftbT7oYBD408XqrU6rwUSHMH2tEbie
	kKfZh1CDlLYkVcGcU3KkS0oekA==
X-Google-Smtp-Source: AGHT+IFqzSTcoNxST3FhOHCG+Us/Epbb855+4fIW887wnW7kaEu5A+g3d/FtOLxG6on8h/bTU+QRLA==
X-Received: by 2002:a05:600c:4709:b0:40b:5e1d:83a3 with SMTP id v9-20020a05600c470900b0040b5e1d83a3mr297560wmo.55.1701422778732;
        Fri, 01 Dec 2023 01:26:18 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id bi19-20020a05600c3d9300b0040b54d7ebb9sm4688580wmb.41.2023.12.01.01.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 01:26:18 -0800 (PST)
Date: Fri, 1 Dec 2023 10:26:17 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	maz@kernel.org, oliver.upton@linux.dev
Subject: Re: [PATCH] KVM: selftests: Drop newline from __TEST_REQUIRE
Message-ID: <20231201-08a259a1ef0bd02eba0c550d@orel>
References: <20231130182832.54603-2-ajones@ventanamicro.com>
 <ZWjfjAnZcomGa1Ey@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWjfjAnZcomGa1Ey@google.com>

On Thu, Nov 30, 2023 at 07:16:28PM +0000, Sean Christopherson wrote:
> On Thu, Nov 30, 2023, Andrew Jones wrote:
> > A few __TEST_REQUIRE callers are appending their own newline, resulting
> > in an extra one being output. Rather than remove the newlines from
> > those callers, remove it from __TEST_REQUIRE and add newlines to all
> > the other callers, as __TEST_REQUIRE was the only output function
> > appending newlines and consistency is a good thing.
> > 
> > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> > 
> > Applies to kvm-x86/selftests (I chose that branch to ensure I got the
> > MAGIC_TOKEN change)
> 
> Heh, and then I went and created a conflict anyways :-)
> 
> https://lore.kernel.org/all/20231129224042.530798-1-seanjc@google.com
> 
> If there are no objections, I'll grab this in kvm-x86/selftests and sort out the
> MAGIC_TOKEN conflict.

No objections from me.

Thanks,
drew
