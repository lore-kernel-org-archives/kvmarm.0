Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CDB4A00
	for <kvmarm@lists.linux.dev>; Thu,  6 Oct 2022 20:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665088133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PzDMEFf3RvC/4HsJdVTaIeB4nK1mYRC18rZsRN9dEDk=;
	b=YJfqeW3sXP8g69SYnC1k/jZ19/FFaX1eUW9THcKQypOnDiBgBurXJLHMRpIQ32S0I1Yiel
	amWaJ7kaqUBKUDozx2qfY2zOvvM7fGFOWyGkcAYlwOb1BVcRtZGrz8sncpMZZVl4deb3ar
	T5clE12evMtDbe+E//Jjh2RzMkFVbho=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-aJfAunR-M-mmla6v3CrPbw-1; Thu, 06 Oct 2022 16:28:51 -0400
X-MC-Unique: aJfAunR-M-mmla6v3CrPbw-1
Received: by mail-qt1-f197.google.com with SMTP id s21-20020a05622a1a9500b0035bb9e79172so1829963qtc.20
        for <kvmarm@lists.linux.dev>; Thu, 06 Oct 2022 13:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PzDMEFf3RvC/4HsJdVTaIeB4nK1mYRC18rZsRN9dEDk=;
        b=HIo+0sZPTZRlOaqudAs2YgUUWrW+XV1MAbV9dmdymZWFiutC7YFkW27KEJw5BIcDef
         kuvzXjNmql/9k/OwjnhAADrg78LDs3Kinxm6P6kZRJC6TdpQ6UKC6nOQJt3azzwj6sCQ
         37W5QS/HqbgUEv6mtf4OGwOsknut3TsjDZ6A3mGuhR/D3xePouEfoUJrs0HT0MHrhWXs
         tu7I2TfwHfRd1zEyPwgh9DtaK+0Hs4G3X8WgAlDOd0FO42LK6+U7bBSe+fsdLc3LC0XW
         Mh4tgXgkj5mJIeU5I2bArdPjQ64NYwtZhffuW7him5jKriMIQf7ac9ZmJqmaqIgL6H+A
         rXJQ==
X-Gm-Message-State: ACrzQf2ZLlZOPuS6+SNfBBGWvPfJdCFzviyXA5cyeYMnjj9ApZXjBwWV
	cmeWmcWRAKRKHzD0qvJ3+OEQy4ETiuzeqMmtgbHTu7MGAvG5GDTfQIsfrD2zrz1WN+ePYSCJZFT
	5nyMp4h9d3HtKrZFp
X-Received: by 2002:a05:6214:d8b:b0:4b2:f6f4:bf5b with SMTP id e11-20020a0562140d8b00b004b2f6f4bf5bmr471081qve.91.1665088131464;
        Thu, 06 Oct 2022 13:28:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7wdSO+0rTVDOZDD3Csrns1eNjrxa7fASHygvAI0zZa7rTZmRLseTk486PcRmkPdgJRBXB+uw==
X-Received: by 2002:a05:6214:d8b:b0:4b2:f6f4:bf5b with SMTP id e11-20020a0562140d8b00b004b2f6f4bf5bmr471062qve.91.1665088131285;
        Thu, 06 Oct 2022 13:28:51 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id o19-20020a05620a2a1300b006cddf59a600sm74769qkp.34.2022.10.06.13.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 13:28:50 -0700 (PDT)
Date: Thu, 6 Oct 2022 16:28:48 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
	shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
	dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
	james.morse@arm.com, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, oliver.upton@linux.dev, seanjc@google.com,
	shan.gavin@gmail.com
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Yz86gEbNflDpC8As@x1n>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20221005004154.83502-4-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221006202848.kMPEYQ_o-ccwR_AMjjNXxYr2eOzOpg4ZExv8Zt4ffBM@z>

On Wed, Oct 05, 2022 at 08:41:50AM +0800, Gavin Shan wrote:
> -8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> -----------------------------------------------------------
> +8.29 KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL, RING_ALLOW_BITMAP}
> +--------------------------------------------------------------

Shall we make it a standalone cap, just to rely on DIRTY_RING[_ACQ_REL]
being enabled first, instead of making the three caps at the same level?

E.g. we can skip creating bitmap for DIRTY_RING[_ACQ_REL] && !_ALLOW_BITMAP
(x86).

> @@ -2060,10 +2060,6 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
>  	unsigned long n;
>  	unsigned long any = 0;
>  
> -	/* Dirty ring tracking is exclusive to dirty log tracking */
> -	if (kvm->dirty_ring_size)
> -		return -ENXIO;

Then we can also have one dirty_ring_exclusive(), with something like:

bool dirty_ring_exclusive(struct kvm *kvm)
{
        return kvm->dirty_ring_size && !kvm->dirty_ring_allow_bitmap;
}

Does it make sense?  Thanks,

-- 
Peter Xu

