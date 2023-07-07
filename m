Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000CFBA47
	for <kvmarm@lists.linux.dev>; Fri,  7 Jul 2023 10:59:37 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-3fbd200d354so74555e9.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Jul 2023 03:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688727576; x=1691319576;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N/x5Wj/WL6k7KcWrje94j9nFZPfPj+YDs51VmCpKkkI=;
        b=tLKBqqLcbwiuJ4HJSMiKoyUCqJ2pofweLBAP4wX35TMUoWjCm37+wTM8Vc1H9pAse1
         DAPjP/yBO/EcMTcpEQfvBMqU7uexy/8CI06hiLXPRojm/cm0aXwpzO5QyNS6Ddg/Pjus
         iHPjpLreMPzUk0NgRJFSF3WnaZohIxJrRZJPm3nmjsl5alBSVVCVfoItqdlS8PG/XeQ9
         H3Ng7liy8ktNjwz43gp+qpBf0ovJ2ReA+4dDz0P55Qewv8nWINbf0CXarkGqeXW5tyIx
         ah/7LgzBafIXOV3IGQKaXyNKPLKxXwnx8siuu1fs5Ui+W4sJZCFHNcehgZOcZEcNXWvF
         VCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688727576; x=1691319576;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N/x5Wj/WL6k7KcWrje94j9nFZPfPj+YDs51VmCpKkkI=;
        b=WoLJ3znW+23R0/3+qdxQATJDsfnzyWcmDZwiM+v261/pzMvBxct+K3lMMrLZjNR0Gu
         Fo/dbpgo1VX/wOU/aCEmEjwZSSLZi+aRz5LOlGzFtjwTuVOCt6kt36sqPe8Qplh/jkLM
         jv6DKniu9HnVl/gwVjlqyARFGdgFwHy5WgD/ijrF1+7Maj6TOf8z/SNGdlBqetQ4j6Mk
         ctS9OzRU666cbH05JMO+pK68UfLrfMQeuJAyYshhYY7Wykw6F/K/qbhIk89tmyZgPQea
         y23wHoJ3h05h1kOQjkfpysZbYAQlxeasVJBp53x1B38RI77Dp2o88YBTyYOeGOoqdvfx
         raYQ==
X-Gm-Message-State: ABy/qLb5XRJj/ROZxtZawMesVIKUCgbnYw7Y6n7c1rPqhhv//qtoEYyA
	hysceGbR+jR6gJVSXz+7ZSr11g==
X-Google-Smtp-Source: APBJJlHavId3npqyWjwmxxh+L3MOX+TI2eDAvEBy5QXlXnLOCWoT4gzGdsCPE5FEAqODsyU9NRKh2A==
X-Received: by 2002:a05:600c:1d15:b0:3fb:c838:c681 with SMTP id l21-20020a05600c1d1500b003fbc838c681mr104628wms.4.1688727575832;
        Fri, 07 Jul 2023 03:59:35 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id l4-20020a1ced04000000b003fbe561f6a3sm2100287wmh.37.2023.07.07.03.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 03:59:35 -0700 (PDT)
Date: Fri, 7 Jul 2023 10:59:31 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, tabba@google.com, qperret@google.com,
	will@kernel.org, catalin.marinas@arm.com, yuzenghui@huawei.com,
	suzuki.poulose@arm.com, james.morse@arm.com, bgardon@google.com,
	gshan@redhat.com
Subject: Re: [PATCH v2] KVM: arm64: Add missing BTI instructions
Message-ID: <ZKfwE2VlaxXDoh8R@google.com>
References: <20230706152240.685684-1-smostafa@google.com>
 <20230706162308.kyeitspgfaqb6vgn@bogus>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230706162308.kyeitspgfaqb6vgn@bogus>

On Thu, Jul 06, 2023 at 05:23:08PM +0100, Sudeep Holla wrote:
> On Thu, Jul 06, 2023 at 03:22:40PM +0000, Mostafa Saleh wrote:
> > Some bti instructions were missing from
> > commit b53d4a272349 ("KVM: arm64: Use BTI for nvhe")
> > 
> > 1) kvm_host_psci_cpu_entry
> > kvm_host_psci_cpu_entry is called from __kvm_hyp_init_cpu through "br"
> > instruction as __kvm_hyp_init_cpu resides in idmap section while
> > kvm_host_psci_cpu_entry is in hyp .text so the offset is larger than
> > 128MB range covered by "b".
> > Which means that this function should start with "bti j" instruction.
> > 
> > LLVM which is the only compiler supporting BTI for Linux, adds "bti j"
> > for jump tables or by when taking the address of the block [1].
> > Same behaviour is observed with GCC.
> > 
> > As kvm_host_psci_cpu_entry is a C function, this must be done in
> > assembly.
> > 
> > Another solution is to use X16/X17 with "br", as according to ARM
> > ARM DDI0487I.a RLJHCL/IGMGRS, PACIASP has an implicit branch
> > target identification instruction that is compatible with
> > PSTATE.BTYPE 0b01 which includes "br X16/X17"
> > And the kvm_host_psci_cpu_entry has PACIASP as it is an external
> > function.
> > Although, using explicit "bti" makes it more clear than relying on
> > which register is used.
> > 
> > A third solution is to clear SCTLR_EL2.BT, which would make PACIASP
> > compatible PSTATE.BTYPE 0b11 ("br" to other registers).
> > However this deviates from the kernel behaviour (in bti_enable()).
> > 
> > 2) Spectre vector table
> > "br" instructions are generated at runtime for the vector table
> > (__bp_harden_hyp_vecs).
> > These branches would land on vectors in __kvm_hyp_vector at offset 8.
> > As all the macros are defined with valid_vect/invalid_vect, it is
> > sufficient to add "bti j" at the correct offset.
> > 
> > [1] https://reviews.llvm.org/D52867
> > 
> > Fixes: b53d4a272349 ("KVM: arm64: Use BTI for nvhe")
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > Reported-by: Sudeep Holla <sudeep.holla@arm.com>
> 
> Nothing change w.r.t cpu suspend-resume path in v2 anyways, but I assure
> I tested this again just be absolutely sure and it still fixes the issue
> I reported 😄, so
> 
> Tested-by: Sudeep Holla <sudeep.holla@arm.com>

Thanks for testing the patch again!

