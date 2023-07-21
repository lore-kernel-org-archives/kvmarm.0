Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ED427F00
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 17:41:17 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-cab7304dcccso2064188276.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 10:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689961276; x=1690566076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0EsEuc6ZrLkBpjfXrbTj3wl8CGw2RCGPAyUMK4WwkjA=;
        b=DoHzE6IB/gTaLmkueM9yb30EUG6tzOb2A5AXrz9PQw1Ifq3ks790NG9A8kHnulrV92
         RNCrZzNkmPOc83fANNDf5nXf1wPVFL2y5FNAhz+fPjDVllxc5Oizeq9OoCoSO3jrCWPO
         Fdo3zuU1ITNzecPSKDNY0XL2xmTCfJibF/rCjlkemXFUh+Sr371B5TqkScdP+lHN0Bsv
         l8bJ71cW4eJgHOkXZEVFnapIkfHWHqvRivBGgXBk81wx3rhHxJzYdjltDTwHbRDPypPU
         FqCvfBjArc5TGgWA7G3s9Jm2aOIc06rnT78obfljmzEALSkpFg35cZZdMznfZTRdtzpx
         x88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689961276; x=1690566076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0EsEuc6ZrLkBpjfXrbTj3wl8CGw2RCGPAyUMK4WwkjA=;
        b=GsOQp3wXEHUoZR2ovniyFluQ4Uey4Zij1TJDikMnHd2JVC//rFtxfnrl9SJYz2d+S6
         0ahU3J70WjfelmTMEcjRv+FylhQyoWGqk4b8HeXk4ZdFavfJn2+/KuvjGZ1E4ha/7fRn
         CnlnRee7KgxBhnaMAXpL+TEZKoGwECzabdzNRPsrlX3QErd1gorQWT5jRvI3+9pvRTp1
         CMb92bZqT1Bz4DBal4eR29qfrJimAWQTKEjOXwowPy55Loo90KyJfKk+mSeKefynllYt
         K3WnbZ03eib9G5DsqE+ZqeKc/+PAIzitO9JvKkhyyujGwoBCRr4JYbfX5nAoWr9CeUop
         Vmeg==
X-Gm-Message-State: ABy/qLYr7EWPCFL6t4jezJVUw8DwQoR+9pGlyfumD8nSfxlmfqaPI8ij
	lXysgUqQtZs+We9NW+0fmD5PFoRGUXs=
X-Google-Smtp-Source: APBJJlFxyzDv1jxbiR1ec3ea79Hb3YohAr96lgMadcKGyfL8Br8SJoCJpXRoXSNCjiu8EtZhgF/6XBpHBow=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4f41:0:b0:cb6:6c22:d0f8 with SMTP id
 d62-20020a254f41000000b00cb66c22d0f8mr17638ybb.4.1689961276130; Fri, 21 Jul
 2023 10:41:16 -0700 (PDT)
Date: Fri, 21 Jul 2023 10:41:14 -0700
In-Reply-To: <6118063e-5c91-acc4-129f-3bacc19f25ce@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-10-seanjc@google.com>
 <6118063e-5c91-acc4-129f-3bacc19f25ce@redhat.com>
Message-ID: <ZLrDOljnluTrt+l+@google.com>
Subject: Re: [RFC PATCH v11 09/29] KVM: x86: Disallow hugepages when memory
 attributes are mixed
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, Vlastimil Babka <vbabka@suse.cz>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 21, 2023, Paolo Bonzini wrote:
> On 7/19/23 01:44, Sean Christopherson wrote:
> > +static bool range_has_attrs(struct kvm *kvm, gfn_t start, gfn_t end,
> > +			    unsigned long attrs)
> > +{
> > +	XA_STATE(xas, &kvm->mem_attr_array, start);
> > +	unsigned long index;
> > +	bool has_attrs;
> > +	void *entry;
> > +
> > +	rcu_read_lock();
> > +
> > +	if (!attrs) {
> > +		has_attrs = !xas_find(&xas, end);
> > +		goto out;
> > +	}
> > +
> > +	has_attrs = true;
> > +	for (index = start; index < end; index++) {
> > +		do {
> > +			entry = xas_next(&xas);
> > +		} while (xas_retry(&xas, entry));
> > +
> > +		if (xas.xa_index != index || xa_to_value(entry) != attrs) {
> > +			has_attrs = false;
> > +			break;
> > +		}
> > +	}
> > +
> > +out:
> > +	rcu_read_unlock();
> > +	return has_attrs;
> > +}
> > +
> 
> Can you move this function to virt/kvm/kvm_main.c?

Ah, yeah, that's a good idea.
