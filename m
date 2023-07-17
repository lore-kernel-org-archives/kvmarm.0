Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64294A927
	for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 09:48:25 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so12252a12.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 02:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689587303; x=1692179303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xcfAMuwOY+oPetXy5qABvv5WWymZbV8JjdfSgt/USaw=;
        b=P84DhTSzyZDW2DrvdeoORjpxBqoxHEIEega8g9wKlZ9UXX5Rd5HZwc48jZnp3QPFBD
         yMZ6Atn9BHZiRyvS425DKqZp9zKGPq4dlGK/eGNfEJiv90y7kxnRL5FJtgtkO7FSNRN1
         BQ32Y+V0stntMjhKObS3+Xhfis2KnVUC7EZDWDG2mFfvljm3l7D54xbNPHWFrd+UmACj
         eWJw/0Y1bybARKARRhGifrAZgP39Wqm+kCrcVDOclfYdGkD7IHhU9CC0lTat6uhn+XRL
         dSYu9KPvCBWPFnzP1gNnXYS3N/BNg4BeFLLhmayWbC8D50puIZ98DJ2ENGize8qawdzs
         ZXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689587303; x=1692179303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xcfAMuwOY+oPetXy5qABvv5WWymZbV8JjdfSgt/USaw=;
        b=fkApNJz1YeKGqxK3szGKIe9E6RV8RiPyn4Dq3M9CToSNOzVJ2yAeblx1rld0+bOv+i
         5X7+JNi797fCvBhtEGnKpYa0KIVzibX8siFT3o2ibhg1X85RyK6D49fW+Z24i5sgJydk
         PTlqLQhr3FGXAl2MBrZvhOu4iclbxOMt1oGVHOOlaeqTN1jB+S1EOcfUIMljevkm6/Gs
         xdd3akTzfaxZ8atAV100f0c4LgR1iapXnm45WgcrUB727HFxLL9kgx6ipKPHEajGjNfJ
         zDadJuMx8bEQOKiRdAc5OQOv17ByrTCbqIkojJCYmLmSKVkY6/GM2zKAtJ6SvEvgfSER
         CQmg==
X-Gm-Message-State: ABy/qLagkXtsVhAyDvDzStym/P4l/xOoNLMOW7zFeNP7kaurrct+ZvQ+
	Z+Uss6o2zt6qZPSADqyTyGv1YA==
X-Google-Smtp-Source: APBJJlG+5dDrquqW2BDi3ZctcLI40czlf8hUMmKlaKfWXwDnH9h988NKHFNTR5bg9i3L2y3YgKm3CQ==
X-Received: by 2002:a50:c346:0:b0:51e:5773:891d with SMTP id q6-20020a50c346000000b0051e5773891dmr611167edb.4.1689587303303;
        Mon, 17 Jul 2023 02:48:23 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id y17-20020adfee11000000b0031274a184d5sm18752365wrn.109.2023.07.17.02.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 02:48:22 -0700 (PDT)
Date: Mon, 17 Jul 2023 09:48:18 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, maz@kernel.org, suzuki.poulose@arm.com,
	tabba@google.com, james.morse@arm.com, qperret@google.com,
	bgardon@google.com, sudeep.holla@arm.com, gshan@redhat.com,
	yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
Subject: Re: [PATCH v2] KVM: arm64: Add missing BTI instructions
Message-ID: <ZLUOYn8bujcIrgaG@google.com>
References: <20230706152240.685684-1-smostafa@google.com>
 <168920214959.3096128.780259299986215400.b4-ty@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168920214959.3096128.780259299986215400.b4-ty@linux.dev>

On Wed, Jul 12, 2023 at 10:50:34PM +0000, Oliver Upton wrote:
> On Thu, 6 Jul 2023 15:22:40 +0000, Mostafa Saleh wrote:
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
> > [...]
> 
> Applied to kvmarm/fixes. Sorry this took longer than expected, Mostafa. I
> was hitting an unrelated issue with pKVM initialization on the only system
> I have that supports BTI.
> 
> [1/1] KVM: arm64: Add missing BTI instructions
>       https://git.kernel.org/kvmarm/kvmarm/c/dcf89d111199
> 

Thanks Oliver, hopefully everything is sorted out now.
