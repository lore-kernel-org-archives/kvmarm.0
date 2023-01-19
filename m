Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AF5A950
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 18:17:41 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id f3so2209171pgc.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 10:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T97gz6Bdfm+yNe+YRAHaCA8lPMcmr0KKDU8hjh4V/OY=;
        b=S62eIbGCR48HzJ0dxRt+FcY1H+wMEDIgps64urcsiB/Xc9UNElGPfDG3M7k3dXhjgf
         IC5/b7TPA5WN8B2zCt5l4+xmMaFP9NYLJK/lZmuCXs/8t+pmpeQvndT/TDDBr+7AJom4
         4pkvYO9rfSviaNIp2nYLbIFOYwSHuwxcCYcbKuCg3UatPoX1KOHQvANMvhPeXSzraKoZ
         wJ7ujoqoxRw++cokwdmUjITxy2xnHEMqWV+aLlcTduAxpgrCgUVkdbhB/vJmoBfElJ/7
         HKH7b5gqivDXkVuH5iLHJd1+y95HqWRJUApg9Cqz/NX8HJl04xAO3dA1YVhbAm6S3N6x
         ybFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T97gz6Bdfm+yNe+YRAHaCA8lPMcmr0KKDU8hjh4V/OY=;
        b=5vYjcC8hAxzGaJI5zOg4ww7wf7VeZA1bzS33RWgyeNJaBI6U0vlNjMcwL1w4jxMaIL
         65LHBcIVvVlVkeTHSROq5qpVd8B7j5RGcCmrxwdAeZh41I1zEm0wPavOHFisEvt2xVeJ
         wgJlAd/z9/VJjn3ScRW4GqdsbkQtWRWeZee/WKNFFwnkZBs5au1UWSpr9Lay0JI6WLvc
         3JsFyPiTvChkSBKwDpiEKZXXsahhEGFNrdEYryEwGXHbYO+mYIT3g0/qlmGLWkVznxt5
         pqU2tX4+XYH1LSFDtv2QaQzeAF1CqPyo4BpbFcdvo3lfqBGlvzUv5xuvk3spzrVsAAHT
         4Whg==
X-Gm-Message-State: AFqh2krdXmmld6lzeDLzo6upY1sy1gM/ZDRhZiqI3wySY4sczziMOOac
	t0Zw0g04j4a/N1iQ6OP2DvmJYw==
X-Google-Smtp-Source: AMrXdXvE6V2XSH75DoWttX7FazNC7q5yK1/5LBnbOsot2oHEv4jYnuIT3ADTTrFdNA17lYqBgz1nVA==
X-Received: by 2002:a05:6a00:a87:b0:582:13b5:d735 with SMTP id b7-20020a056a000a8700b0058213b5d735mr3493507pfl.0.1674152261141;
        Thu, 19 Jan 2023 10:17:41 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f127-20020a623885000000b00588cb819473sm19996079pfa.39.2023.01.19.10.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 10:17:40 -0800 (PST)
Date: Thu, 19 Jan 2023 18:17:36 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH 4/7] KVM: x86/mmu: Rename
 kvm_flush_remote_tlbs_with_address()
Message-ID: <Y8mJQH4VqC76sX7k@google.com>
References: <20230119173559.2517103-1-dmatlack@google.com>
 <20230119173559.2517103-5-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119173559.2517103-5-dmatlack@google.com>

On Thu, Jan 19, 2023, David Matlack wrote:
> Rename kvm_flush_remote_tlbs_with_address() to
> kvm_flush_remote_tlbs_range(). This name is shorter, which reduces the
> number of callsites that need to be broken up across multiple lines, and
> more readable since it conveys a range of memory is being flushed rather
> than a single address.

FYI, this conflicts with Hou's series, which I'm in the process of queueing for
v6.3.

https://lore.kernel.org/all/cover.1665214747.git.houwenlong.hwl@antgroup.com
