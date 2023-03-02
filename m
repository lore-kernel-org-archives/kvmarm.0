Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758AE10FA
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 19:06:42 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id m20-20020a17090ab79400b00239d8e182efso3775413pjr.5
        for <kvmarm@lists.linux.dev>; Thu, 02 Mar 2023 11:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677784002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i950zL3EMtEtsFlpDuMJZ9iaTlDb9zorW5KZE1wh+50=;
        b=FHY7SRoDoR5AcqGgEUJe/jwrFQL4dY5auk//rpn0O18POlf5dfI79qcNZvluQvj8Te
         kqI0JOoZuAnwcMX9mFAqZPltTza30mtoYGkh4k5vIW4PbhtPSeUb5JtjSgaMX11lsKxD
         b0od4H6OnKerSCIJ3qRqbOEEZrLHrOS0nrcQXP+fUScewuqA56nvhv7gf6ijY8oxXYG6
         C/fuGBzLMrb4eeO7ch6pYqrPI2sW2lYyN1jFVyA/fQgcoHPA9iBBdxtyrl0SCMWDHCTB
         M4DMNd8CKwjvYikBE7g1UJfLTT5n9XQNBD1570DR8iGFJNL56hhwV6jpnM+tvb+TYzcD
         XnLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677784002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i950zL3EMtEtsFlpDuMJZ9iaTlDb9zorW5KZE1wh+50=;
        b=Q5sYMwIj1Ccql3WUYkWmh/orzfD8WTv5BfzbAqR4vsf8OkADdvOqbNYpLRgrq9KzdR
         mCuca86zfhszE7QEG4vG7l4JImdVADdBEynJb0AFvhvufJFChLv3VYpFOZm7yWpyUyhS
         TLhSnD0Fw6pANDp41ey2fwZbNTPKzksKymJBJnEBdCgJGp3dGsgjVHYArsXqFO61Prq1
         Jskno8G/VET1Fa7dOvlaKxAGmLDVg7/JPlF6NYoqIzSvMlHaLVjV1KCJi9MeSp1qxZ+g
         zLk9deOzfy0NKp4hczJS+JjgXwhCedhkkwfzJ8SvGqGgE8nDIawGTX4DcSwRMfeWkQp3
         4KcQ==
X-Gm-Message-State: AO0yUKU0oldbFU79UrAW+2+rvIl8X1XfWMUKIXQU2SgyTtAdS9rEuR2l
	CzRy1SZ0HslFKgY2ArvMf/lrJw==
X-Google-Smtp-Source: AK7set/lwHcJWPhRwDJHfG9z85lSAImCzpQ6QcQdgHZJVVnEfRiwrAew4INWC6nv3Raom5EcrizSNg==
X-Received: by 2002:a17:902:fb8d:b0:19a:f556:e37f with SMTP id lg13-20020a170902fb8d00b0019af556e37fmr17986plb.4.1677784001555;
        Thu, 02 Mar 2023 11:06:41 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id y20-20020a17090aca9400b0023317104415sm1965197pjt.17.2023.03.02.11.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:06:41 -0800 (PST)
Date: Thu, 2 Mar 2023 11:06:37 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com,
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com,
	reijiw@google.com, rananta@google.com, bgardon@google.com,
	ricarkol@gmail.com
Subject: Re: [PATCH v5 12/12] KVM: arm64: Use local TLBI on permission
 relaxation
Message-ID: <ZADzvSK77CHBwcNN@google.com>
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-13-ricarkol@google.com>
 <6d407882-c34e-16f1-1662-2af588e982f7@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d407882-c34e-16f1-1662-2af588e982f7@arm.com>

Hi Vladimir,

On Thu, Mar 02, 2023 at 10:45:25AM +0000, Vladimir Murzin wrote:
> On 3/1/23 21:09, Ricardo Koller wrote:
> > Second, KVM does not set the VTTBR_EL2.CnP bit, so each
> > PE has its own TLB entry for the same page. KVM could tolerate that when
> > doing permission relaxation (i.e., not having changes broadcasted to all
> > PEs).
> 
> I'm might be missing something, but it seems that we do set CnP bit, at
> least in v6.2 we have
> 
> arch/arm64/include/asm/kvm_mmu.h
> 
> static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
> {
>         struct kvm_vmid *vmid = &mmu->vmid;
>         u64 vmid_field, baddr;
>         u64 cnp = system_supports_cnp() ? VTTBR_CNP_BIT : 0;
> 
>         baddr = mmu->pgd_phys;
>         vmid_field = atomic64_read(&vmid->id) << VTTBR_VMID_SHIFT;
>         vmid_field &= VTTBR_VMID_MASK(kvm_arm_vmid_bits);
>         return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
> }
> 
> Cheers
> Vladimir

I need to fix the commit message. What I meant to say is that
this optimization is correct in the case where CnP is not set.

Thanks,
Ricardo
