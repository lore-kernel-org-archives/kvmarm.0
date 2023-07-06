Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A0FA934
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 15:23:39 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-3fbb07e7155so138165e9.0
        for <kvmarm@lists.linux.dev>; Thu, 06 Jul 2023 08:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688657017; x=1691249017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6qis8CnT+xpm3hc78+sJPYYplKlMZhcwZsxd3FBsB0=;
        b=bcB9+xfY27xSFVigr4qzoaT1bXwyVfL7cV9cR1lj4nkkq4cj6u6M70kYX6IKLgWfq/
         coCkE1TPHHK3J+UbNGZQEAzgG+pYn65TrDOgl7kosOEptK7fiIjPLER17OCXobybXyqH
         wKAuu72b5U0pogvwL/hTwJMiHrQkbdIAA2PQAGs5gElWRWG9ZNE7nJZIAEoRF1xXaQ7w
         0CylC9GSRUIRRHRNStCd8V2o/Uibwsr/2Ll1Kzxk2SvhsginXwiyMLDxZbhhsyEJhqB7
         yU9KbngrenPiE+8WiUYymW1F0B2FaJKOF2k3Inq/rBKqMKdmGPknGFq+E8IGafmiUKkB
         Mqgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688657017; x=1691249017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6qis8CnT+xpm3hc78+sJPYYplKlMZhcwZsxd3FBsB0=;
        b=ZuiuxgjUOXJKq5EVy2xTH3u6dHCPYHC9smjvxTl+tCTeGkR3K2K50cFscy1cCXNMi/
         J0MTTKeJ4iSdKkLwX3cCX0m87VVb4uVKfpsb8cRyPB7T+BVlwNeXV9/lk4LjMAGyQXDw
         kspu5xO4+vjD/qmGJIBwFvHdQ6vQ0RJS7OtMtmCC5KjiesptJ0iicljwJIwIMqEh5r4V
         qFyYF4h7CXZwDFCrQXEPGk++ntMfg6ewHptD8+h6W5I2fKeJoYYLTwpKsFWygiRIdW8N
         MjIiYj02WE5Jv/jx7/nrilARa6/gmWeQEfwBIPplMTwiwua+hZS0vGW48Cy/zRembXuv
         UY1w==
X-Gm-Message-State: ABy/qLY8JoOA+8ieMpJNsVVW6msfU+HLNjpk0XRIPllho8evFI2WYvSn
	s1J9QurA1/sGbr8ZM6I62l1JeQ==
X-Google-Smtp-Source: APBJJlEVZPjavZNR3a4RhEKi5usCLZuBG+o7AGWWWk8qr/QqNNQ1Ew+k2sJlSWVllKPPgSIFvYBf0Q==
X-Received: by 2002:a05:600c:45ca:b0:3f6:f4b:d4a6 with SMTP id s10-20020a05600c45ca00b003f60f4bd4a6mr87572wmo.7.1688657017311;
        Thu, 06 Jul 2023 08:23:37 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id j14-20020a056000124e00b0031274a184d5sm2110136wrx.109.2023.07.06.08.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 08:23:36 -0700 (PDT)
Date: Thu, 6 Jul 2023 15:23:32 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, tabba@google.com, qperret@google.com,
	will@kernel.org, catalin.marinas@arm.com, yuzenghui@huawei.com,
	suzuki.poulose@arm.com, james.morse@arm.com, bgardon@google.com,
	gshan@redhat.com
Subject: Re: [PATCH v3] KVM: arm64: Use BTI for nvhe
Message-ID: <ZKbcdGNurXPdNJgf@google.com>
References: <20230530150845.2856828-1-smostafa@google.com>
 <20230704134136.a5znw4jupt5yp5kg@bogus>
 <ZKQqIYRrckLlXqkx@google.com>
 <20230704143339.cqrvntq7rmmb2on3@bogus>
 <ZKRIWJKn7aVSOvjd@google.com>
 <20230704192529.d4x2p7ndz2dc4q52@bogus>
 <ZKWSkB1/5Zlm7mdR@google.com>
 <CAFgf54rQmBMgvRWj2yqQ90=12x-Tm1BkHj_-pf+ZBYPmBU_Swg@mail.gmail.com>
 <873521yv1j.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873521yv1j.wl-maz@kernel.org>

On Thu, Jul 06, 2023 at 03:27:36PM +0100, Marc Zyngier wrote:
> Hi Mostafa,
> 
> On Thu, 06 Jul 2023 13:49:04 +0100,
> Mostafa Saleh <smostafa@google.com> wrote:
> > 
> > Hi Marc and Oliver,
> > 
> > I was double checking that nothing else was missed.
> > 
> > I found there is another problem for hw that has BTI and is affected
> > by specterv3a.
> > 
> > "br'' instructions are generated at runtime for the vector
> > table(__bp_harden_hyp_vecs).  These branches would land on vectors
> > in __kvm_hyp_vector at offset 8.
> > 
> > As all the macros are defined with valid_vect/invalid_vect, it is
> > sufficient to add "bti j" there at the correct offset.
> >
> > I am not sure if such hardware exists. I tested this with a stubbed
> > "has_spectre_v3a" which confirms the issue and the fix.
> 
> Thanks for the heads up.
> 
> Fortunately, there is no such HW as far as I can tell. Only Cortex-A57
> and A72 are affected by this (and the only two CPUs for which we
> engage the mitigation), and they are way too old to know about BTI.
> 
> > Please let me know if this fix suitable, I can include it with the other fix in
> > "[PATCH] KVM: arm64: Add missing BTI instruction in kvm_host_psci_cpu_entry"
> > 
> > diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> > index 8f3f93fa119e..175c030379e3 100644
> > --- a/arch/arm64/kvm/hyp/hyp-entry.S
> > +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> > @@ -154,6 +154,12 @@ SYM_CODE_END(\label)
> >   esb
> >   stp x0, x1, [sp, #-16]!
> >  662:
> > + /*
> > + * Specter vectors __bp_harden_hyp_vecs generate br instructions at runtime
> > + * that jump at offset 8 at __kvm_hyp_vector.
> > + * As hyp .text is guarded section, it needs bti j.
> > + */
> > + bti j
> >   b \target
> > 
> >  check_preamble_length 661b, 662b
> > @@ -165,6 +171,8 @@ check_preamble_length 661b, 662b
> >   nop
> >   stp x0, x1, [sp, #-16]!
> >  662:
> > + /* Check valid_vect */
> > + bti j
> >   b \target
> > 
> >  check_preamble_length 661b, 662b
> 
> This looks correct to me.
> 
> If you can respin you initial patch (with maybe a slightly more
> generic subject) so that Oliver can pick it up as part of the next
> batch of fixes, that'd be great.

Thanks a lot, I just sent v2.
[PATCH v2] KVM: arm64: Add missing BTI instructions

> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
