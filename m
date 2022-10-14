Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEF84680
	for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 21:28:10 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id e129so5377917pgc.9
        for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 14:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TUL+SkC7/koWX+CyJ2/PD9/CBLbq2G9cpQ2gXTLP9mQ=;
        b=FJYhKHLLUm8mE2yX5H3zXOKYKhzcfIgAAI3C4FwOqjzD20sYlqciVAS8RJXmxiA9qW
         kJp1PhxazDMYSVxpUukm6au9DxjlqdYP6whWFEfbgIf77SwMmddhg/CqZuGs98m0hMCG
         52W2g/gteeV0i+2OswtkKH13tGy0Mba6L0JUuwwIAg9mFQVs1iMatpv15wJ43T16ycoV
         Lx2qBbAEDz7K+c8Qqf0Ika5zgaROXj26MSIwKp4jihHI2OXLZT9aO6mnet0aiUfWCzSf
         oejKV/39Uc76CV9VlOVngnUQ9XTvIZD8itnKt5lXysuPjQs0RWTBFj8uxUzfBvAecfdO
         V6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUL+SkC7/koWX+CyJ2/PD9/CBLbq2G9cpQ2gXTLP9mQ=;
        b=xV9ZWNE3BbPa9lkYxbfWfo1DR8PUAQMD/DzTsoMduRjpbAA2s6OpntHr5XDzNBrj7r
         ZaENiIrb+Ap/H4ZeMrx5ni9dtLdLDBc86Y45ekarbv0Gy/mKsaOsLkjRAVCtK4WK5ALJ
         a95J2AstTuLRJ0npC0u1p1Rb2/mx/tI6a4ba9NLC1qHPkkqyTEIkAwr/vqRvfV833KqU
         Mm4EHMXSIsSzrggGdbtvJzHdPLGEH4WH/BX2P81pIG3MLeeB5olFYUTu8+SF40LIBQOf
         l6781lkzNx5G2hNXqNXGt4uk1mMqUQSGvdJgaXsa/XUSuXOT5ztVPuviFrzML8526+hn
         nd1w==
X-Gm-Message-State: ACrzQf3bKhlBk+xnit+aJWlJy8+KDVsRB1Cj1YoprkiqfyrcrARrSA6l
	mhvTsM8SE3OKh3h33lUquMgprw==
X-Google-Smtp-Source: AMsMyM7DX2VY33DbNCRga+aaC9tQU3wY2Pnt5YZgE/m67b//0sp7Yz2kcSc6xw7BXLbNRSRIGls7RQ==
X-Received: by 2002:a63:8b44:0:b0:45f:952f:c426 with SMTP id j65-20020a638b44000000b0045f952fc426mr6083058pge.623.1665782890167;
        Fri, 14 Oct 2022 14:28:10 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c16-20020a17090a109000b0020d39ffe987sm1893977pja.50.2022.10.14.14.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:28:09 -0700 (PDT)
Date: Fri, 14 Oct 2022 21:28:06 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, dmatlack@google.com,
	axelrasmussen@google.com
Subject: Re: [PATCH v9 12/14] KVM: selftests: aarch64: Add dirty logging
 tests into page_fault_test
Message-ID: <Y0nUZuiRJh/WUnVd@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-13-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-13-ricarkol@google.com>
Message-ID: <20221014212806.HEMLuQluXLahIzjfniBQbLFQ4TILqgATwEZukHfP0lI@z>

On Tue, Oct 11, 2022, Ricardo Koller wrote:
> @@ -395,6 +415,21 @@ static bool punch_hole_in_backing_store(struct kvm_vm *vm,
>  	return true;
>  }
>  
> +static bool check_write_in_dirty_log(struct kvm_vm *vm,
> +		struct userspace_mem_region *region, uint64_t host_pg_nr)

static bool check_write_in_dirty_log(struct kvm_vm *vm,
				     struct userspace_mem_region *region,
				     uint64_t host_pg_nr)
