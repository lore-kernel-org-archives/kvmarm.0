Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EA17B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 17:07:46 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-50e79ffba49so221594957b3.9
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 09:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I40PJrFRqn61VwCmmZvurXKna/KGPzaaS+rQHZXZvn0=;
        b=l8u1qpGgi11tT4E8pv9pTuFXHM/7WY2MCiv2bszlJ1zxeExjqm25IM6hph3zf0n+GH
         ysvNzeo91bE0dHqERdOSLN9nkAhwpdM8rvp4LDTHjt0IYdwmbCUNot0/sh9QF2e0g+4Z
         iXxjc61Os8fGMeChQfy7xU38ALBiYCz8AYDCwTG4waTH3d1iDkVZc0yYh5UNBmH9BNIC
         4s4k2LCWdlix0TbeFAYqhetPtDE28k4vgwnqcFslAgOyUWGhqcYIEmTs3P2wcstRRrmQ
         ULTCsPbzrtYJpit4Rb6KoytvdVRvTJo64CyT87HR+oXbZKIrYwa+Kqzs6Ne5vw5YvgZQ
         r+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I40PJrFRqn61VwCmmZvurXKna/KGPzaaS+rQHZXZvn0=;
        b=XA+EqMVVH6omC95XRmbZBxzR0qCRyalKT64VE1gL6JQ39wCMm3qJsthyyHwhu5zS1R
         U3frxTBSkx4w5DRThWpe1pRmXq32vbxF5k++JOcVnA00LdDUk7Eb3qVv0ckiY1ws2qrV
         6mpSd9EHzdx8gALGvaXoFK2ks7rwM5489Wym0+P1Mg9+oL+NVG/IZHFV/ELnYkB0pUWQ
         4ZT9JXp+zQaO/7MhRH3nLn4fyHxeJsiUeJu2JqdYmfOWC+XzMjYFRW4ecWhk0LJGDVQT
         rM3MlQ3V3ORgGZ/1Srlt85qbuJ3rbTlseY7PEQVPxuOwjKNx8XhDEBt/G8XVQzmlnW4h
         V+WQ==
X-Gm-Message-State: AO0yUKUiliQiHe452pNFnMRXfjRRIvSn7+94jMw9MbMZ1ljj49SzfQX7
	c7ShAk5qEJUBxtjcmxGtPJx1c/ory1E=
X-Google-Smtp-Source: AK7set/bKyGjjQSPDfHloXqvYliTaSoAw87YpPgzxpVLEYaD/uIjcgxZV0daIcoU5fiuPAjFav357tj93Iw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2c2:b0:920:2b79:84b4 with SMTP id
 w2-20020a05690202c200b009202b7984b4mr349239ybh.386.1676480865897; Wed, 15 Feb
 2023 09:07:45 -0800 (PST)
Date: Wed, 15 Feb 2023 09:07:44 -0800
In-Reply-To: <87mt5fz5g6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org>
Message-ID: <Y+0RYMfw6pHrSLX4@google.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Anish Moorthy <amoorthy@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, James Houghton <jthoughton@google.com>, 
	Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 15, 2023, Marc Zyngier wrote:
> On Wed, 15 Feb 2023 01:16:11 +0000, Anish Moorthy <amoorthy@google.com> wrote:
> >  8. Other capabilities.
> >  ======================
> >  
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 109b18e2789c4..9352e7f8480fb 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -801,6 +801,9 @@ struct kvm {
> >  	bool vm_bugged;
> >  	bool vm_dead;
> >  
> > +	rwlock_t mem_fault_nowait_lock;
> > +	bool mem_fault_nowait;
> 
> A full-fat rwlock to protect a single bool? What benefits do you
> expect from a rwlock? Why is it preferable to an atomic access, or a
> simple bitop?

There's no need to have any kind off dedicated atomicity.  The only readers are
in vCPU context, just disallow KVM_CAP_MEM_FAULT_NOWAIT after vCPUs are created.
