Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE4B1FAE
	for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 09:28:21 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id k2so11636590ejr.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 02:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o1dEA6QDjwPI5Lqqp4PnQXLAiiJ6pk7DSaf8g2e6LNg=;
        b=rpEWC7xCFV/pUAbhRF1OBflH1ReSXldbCEKcEiVXMZLJXp8WrR3mYW7CBPs9qGTxSM
         UGFff4Lu0d14TN77FyLd0S9EnSY0LwHdWlyjmpIw5Uh3bqrlOxRssh9m5P40Wz4xRloS
         OLJbpdgCIaF2TJ1p94MYswxOseYLaRD3oo1680naj5NFO8VNcKuVHpXns4R/T0kzSnSl
         6sG2RtN/JJuOujfjwbAwgoeAyXZeOCk7QVT+a7GTgDbEMqsXhoFR3DCAWpYLwzhnx/3T
         862fYsgfYJ1UwFXWPaEkP6iNe3jaIGVJaxoW84T8ZgKGeEwDHbbx+wTlIeFXqFzuv6Nl
         iVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1dEA6QDjwPI5Lqqp4PnQXLAiiJ6pk7DSaf8g2e6LNg=;
        b=bJNoZ4kxzpmlWSawHJh5d1DzGr7d/hr7HpWuK33sClrMlGQ8riE0Ta0RMWQLAM7QCa
         v+0nkaQjCd5vuL7Ju/Km6/D0HVd6IkEunaqo1YU3/5AYt7MDl1nnp4A3raVsadiilLSh
         m33gKh+gqQ/uMJ66U5vtKnQmP4x2nQ1mEmJOEw6oIZ2fBi6DC6G3WCZe9SyaIHTjE2bE
         4ghTS98NxEnvhKwsLiCcJkZvqVIElhfmnI0DDkfLxymGo2SmfiSQrvoEV7BZe2Q34KDf
         nKaJ3uHuUICgTK3PV77wKg00bXT9MNsE7wl8XjEUOKK7KWVmBS6bK5Scfg8rNnqXDykS
         3XNg==
X-Gm-Message-State: ACrzQf0kJf1mAcl1GIjRsKsX019FBAJn0cs4WZ/K7gRlKb6e8FWTsTYN
	2TFqtlS26zuuii9RGnx2u2wG5w==
X-Google-Smtp-Source: AMsMyM7L7iJ/b3nYLQTZha1zpDQVJblHC8G85NArgRqyqWymZq33WRAiEkkyQmt3H6qTWyPBQb1TDQ==
X-Received: by 2002:a17:907:980e:b0:78d:b6ea:25b3 with SMTP id ji14-20020a170907980e00b0078db6ea25b3mr45999011ejc.98.1666949299844;
        Fri, 28 Oct 2022 02:28:19 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id 24-20020a170906311800b007933047f930sm1909751ejx.157.2022.10.28.02.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 02:28:19 -0700 (PDT)
Date: Fri, 28 Oct 2022 09:28:15 +0000
From: Quentin Perret <qperret@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 02/25] KVM: arm64: Allow attaching of non-coalescable
 pages to a hyp pool
Message-ID: <Y1ugr1WKKbNIRKAh@google.com>
References: <20221020133827.5541-1-will@kernel.org>
 <20221020133827.5541-3-will@kernel.org>
 <Y1sfpM3IjNvr8ckf@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1sfpM3IjNvr8ckf@google.com>

Hey Oliver,

On Friday 28 Oct 2022 at 00:17:40 (+0000), Oliver Upton wrote:
> On Thu, Oct 20, 2022 at 02:38:04PM +0100, Will Deacon wrote:
> > From: Quentin Perret <qperret@google.com>
> > 
> > All the contiguous pages used to initialize a 'struct hyp_pool' are
> > considered coalescable, which means that the hyp page allocator will
> > actively try to merge them with their buddies on the hyp_put_page() path.
> > However, using hyp_put_page() on a page that is not part of the inital
> > memory range given to a hyp_pool() is currently unsupported.
> > 
> > In order to allow dynamically extending hyp pools at run-time, add a
> > check to __hyp_attach_page() to allow inserting 'external' pages into
> > the free-list of order 0. This will be necessary to allow lazy donation
> > of pages from the host to the hypervisor when allocating guest stage-2
> > page-table pages at EL2.
> 
> Is it ever going to be the case that we wind up mixing static and
> dynamic memory within the same buddy allocator? Reading ahead a bit it
> would seem pKVM uses separate allocators (i.e. pkvm_hyp_vm::pool for
> donated memory) but just wanted to make sure.

So, in the code we have that builds on top of this, yes, but to be
frank it's a bit of a corner case. The per-guest pool is initially
populated with a physically contiguous memory range that covers the
need to allocate the guest's stage-2 PGD, which may be up to 16
contiguous pages IIRC. But aside from that, all subsequent allocations
will be at order 0 granularity, and those pages are added to the pool
dynamically.

> I suppose what I'm getting at is the fact that the pool range makes
> little sense in this case. Adding a field to hyp_pool describing the
> type of pool that it is would make this more readable, such that we know
> a pool contains only donated memory, and thus zero order pages should
> never be coalesced.

Right. In fact I think it would be fair to say that the buddy allocator
is overkill for what we need so far. The only high-order allocations we
do are for concatenated stage-2 PGDs (host and guest), but these could
be easily special-cased, and we'd be left with only page-size allocs for
which a simple free list would do just fine. I've considered removing
the buddy allocator TBH, but it doesn't really hurt to have it, and it
might turn out to be useful in the future (e.g. SMMU support might
require high-order allocs IIUC, and the ability to coalesce would come
handy then).
