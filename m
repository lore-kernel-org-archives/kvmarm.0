Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4E21B546
	for <kvmarm@lists.linux.dev>; Fri, 11 Nov 2022 23:00:16 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso5865797pjc.2
        for <kvmarm@lists.linux.dev>; Fri, 11 Nov 2022 15:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EXxysosi2pB1lHjcZe6TR6GN44puMGv7Sb4rfuvd3b8=;
        b=bOkMHaWMX8iYB/kv7bjVFPLxhSAgXvRcQzvvr0YMaufhZIiWvsZMZcpNSTN3jUaB1n
         +Z3wqSA0VeQ0pDal5g+FwtfY77ZNBrO9/cS6ob4mhSujxdETPi2+GYpWmWz8zjE9JVgF
         VQnp5EuqjWQP9mIrrXMpPC3YYMjaxKc6FM/2TVC2l1EDOIGZX0pvCBdRV81LIxT+Invc
         jDYfrm8JvweZAp1ipwPYCqC1XFNkwzcdYsYgxrr8+PzsFqOYTxfqiHht86Yv5fs5MBS9
         Q2MGl8ce9QLTQpnR72MeMr3Vwrx9QgnLZEmDZh37YMBxh+I9RvW8v1Lcpz3w6KnlmGIG
         mk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EXxysosi2pB1lHjcZe6TR6GN44puMGv7Sb4rfuvd3b8=;
        b=LzBpPfGXawfHl2NH7RqYGmyNlF+iC7FvdIdGJ78OTkegYbHfxTQfB+GgzLgECb9ynF
         iNda1ljtI0jeRH2leTZeBlYfVjC18XHOV+aCt4gCyM+D8YwgJL2YP9vtYrgtcWTbE+XW
         +92mJ0Up/DCN7iUIwIimO7q72meSPPtQUd61lXwHW8QIU8W8ZCtRGgySNk7VafbY1wz3
         CCMKX1BBH9ogy4pEFgkaYZteeOtFmujJ+hnPXhAoGELXSYILRntq+QmCMgUuPyGveRyM
         9hMo3ObR/SYW+DbRedbncEPxPW8Ce5eTRIJKHaJmo70Ffqu5HVOwkd1UADPdXp2o5pfL
         nTHw==
X-Gm-Message-State: ANoB5pl/QTf2ncWqTZUBGL5b0lOmP1Nqb2bmoKqkiSKRjbF29RZMomIT
	2udiOFTXV/vW3dsfHJVwCGSzgg==
X-Google-Smtp-Source: AA0mqf6rHbHOxSOsy5zgUU8q0v9Y6gE7Cr/fm1KW8Ltanni/hVq24i1abbayy3TtoD+n1xu+b7dmXw==
X-Received: by 2002:a17:902:7896:b0:186:f256:91cd with SMTP id q22-20020a170902789600b00186f25691cdmr4405929pll.152.1668207615644;
        Fri, 11 Nov 2022 15:00:15 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t8-20020a63b248000000b00439d071c110sm1821495pgo.43.2022.11.11.15.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 15:00:15 -0800 (PST)
Date: Fri, 11 Nov 2022 23:00:11 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shuah@kernel.org,
	catalin.marinas@arm.com, andrew.jones@linux.dev,
	ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
	will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
	pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with
 bitmap
Message-ID: <Y27T+1Y8w0U6j63k@google.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com>
 <Y20q3lq5oc2gAqr+@google.com>
 <1cfa0286-9a42-edd9-beab-02f95fc440ad@redhat.com>
 <86h6z5plhz.wl-maz@kernel.org>
 <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
Message-ID: <20221111230011.xa8cYB-3mhMS_kQNfKocnQr-J0b_nWiy28mnJZgi3TE@z>

On Sat, Nov 12, 2022, Gavin Shan wrote:
> Hi Marc,
> 
> On 11/11/22 11:19 PM, Marc Zyngier wrote:
> > On Thu, 10 Nov 2022 23:47:41 +0000,
> > Gavin Shan <gshan@redhat.com> wrote:
> > But that I don't get. Or rather, I don't get the commit message that
> > matches this hunk. Do we want to catch the case where all of the
> > following are true:
> > 
> > - we don't have a vcpu,
> > - we're allowed to log non-vcpu dirtying
> > - we *only* have the ring?

As written, no, because the resulting WARN will be user-triggerable.  As mentioned
earlier in the thread[*], if ARM rejects KVM_DEV_ARM_ITS_SAVE_TABLES when dirty
logging is enabled with a bitmap, then this code can WARN.

> > If so, can we please capture that in the commit message?
> > 
> 
> Nice catch! This particular case needs to be warned explicitly. Without
> the patch, kernel crash is triggered. With this patch applied, the error
> or warning is dropped silently. We either check memslot->dirty_bitmap
> in mark_page_dirty_in_slot(), or check it in kvm_arch_allow_write_without_running_vcpu().
> I personally the later one. Let me post a formal patch on top of your
> 'next' branch where the commit log will be improved accordingly.

As above, a full WARN is not a viable option unless ARM commits to rejecting
KVM_DEV_ARM_ITS_SAVE_TABLES in this scenario.  IMO, either reject the ITS save
or silently ignore the goof.  Adding a pr_warn_ratelimited() to alert the user
that they shot themselves in the foot after the fact seems rather pointless if 
KVM could have prevented the self-inflicted wound in the first place.

[*] https://lore.kernel.org/all/Y20q3lq5oc2gAqr+@google.com
