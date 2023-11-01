Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41201B294
	for <kvmarm@lists.linux.dev>; Wed,  1 Nov 2023 21:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EnbaiymE"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-586cf3eccbeso133769eaf.2
        for <kvmarm@lists.linux.dev>; Wed, 01 Nov 2023 14:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698875625; x=1699480425; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNGtVCoxYNTqqb91lIin52vLqJx98695iGNTRt2vMkQ=;
        b=EnbaiymEHqOZTGNCAb1VogPARfgS5xi8fsWvsqrp5Y2BglR9AYLRxzpB9z2uARJcGs
         EUE9CHJokpSohXeLeIVjiT5F0xt49pgG6XWIl2shuyEW2u16bKHPHUNBP5JJleRqu6nx
         ZTPlLrHS1+Bb1KvRWM+ltdy3aEOXQdkZgVUoRh5sBfIT89M9fJlKgSuwdnVgae3KfSl5
         ZsjRtZRUh6P5GGOye2r32eMe/8D5Y1MSTGyLhsS1jWtCBnL108yBb7Ui+HvcUygv7nwU
         aAM26U6lrAcIJhwpYQmdu30PhSFrLdVqDH63URiQMQIVAd9Gs31UQ7e30q9GK96VzQWM
         XcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698875625; x=1699480425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNGtVCoxYNTqqb91lIin52vLqJx98695iGNTRt2vMkQ=;
        b=t7fQcUkUBdh4wL5UilHHMX2cYwq3fQhGv3tmHPTjyCUMpW0AiWMnllXnf9SuKrDzsM
         NZanF/9zgkmn7gC2/REVQ9PxfV9YqBWGLrUr5IStpmN2xgDO10yqQ3QWkE2Hp90pVXo3
         a1RtTrxf5zqy55tnZ1PCBNmtWJLTEQPXaVxIcKzjMlrsExh3MJbM1qywehyvU7RpZcjA
         H3UAcYmquUL3Q8p8AMi3czqgd9B7MEIykFwBvrHp+4swRHP8J1YnWhCdLC6k9h7X28b4
         rKaA6GReJVcC+uR9t8nnTtX4HovmobAAGoF0BBMHXfzPT5JuHY+CBHQWiAsFG4phQQ+n
         m6SA==
X-Gm-Message-State: AOJu0YxbqP3mYd4Y3vpKaiC/6be5eHC+0EMAPvPv0rDEMzYGDLcqh4aU
	yiKyCJMBCddKX1AyA0fQuGzMJ5K9yp+9GnAm9kVsdw==
X-Google-Smtp-Source: AGHT+IHbn1+cpbAI+nliVXgth/Acy7IzPuB2yfJ1vWUR+O6XaiKCG2ZEex24dfHa/3lbHwAMIWL2L6Fx5V4/upuTheA=
X-Received: by 2002:a4a:de89:0:b0:57b:86f5:701c with SMTP id
 v9-20020a4ade89000000b0057b86f5701cmr13459410oou.4.1698875625558; Wed, 01 Nov
 2023 14:53:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com>
In-Reply-To: <ZR4U_czGstnDrVxo@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 1 Nov 2023 14:53:09 -0700
Message-ID: <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Eh, the shortlog basically says "do work" with a lot of fancy words.  It =
really
> just boils down to:
>
>   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_MISS=
ING

Proposed commit message for v6:

> KVM: Implement KVM_CAP EXIT_ON_MISSING by checking memslot flag in __gfn_=
to_pfn_memslot()
>
> When the slot flag is enabled, forbid __gfn_to_pfn_memslot() from
> faulting in pages for which mappings are absent. However, some callers of
> __gfn_to_pfn_memslot() (such as kvm_vcpu_map()) must be able to opt out
> of this behavior: allow doing so via the new can_exit_on_missing
> parameter.

Although separately, I don't think the parameter should be named
can_exit_on_missing (or, as you suggested, can_do_userfault)-
__gfn_to_pfn_memslot() shouldn't know or care how its callers are
setting up KVM exits, after all.

I think it makes sense to rename the new parameter and, for the same
reasoning, the memslot flag to "forbid_fault_on_missing" and
KVM_MEM_FORBID_FAULT_ON_MISSING respectively. Objections?
