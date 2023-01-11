Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493EC2560
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 22:46:20 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id 203so16675113yby.10
        for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 14:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7XUNRQSkmgxBwPtlFe+tY4O7Zk2hAxIaFzmJ+ZbBo5g=;
        b=FlburyiZ8GT2QW0nv2OtZ0LUE1v2vF0Y/pHEWD9oGzHjZ4h/FjWKkwyFdBbDcaNnUP
         2Ie9tt3h4rkQPD0tXq/TDTvxnd6ZigemFV6kwDmtr8N+ST9EWS/PCcr60+Ix/1/nGs5f
         AsS3qP6KlbbwLtD/WwC5f8YbOx3QguruaU1rcVfGrW/ie+zf83l970YFUufIsjbNIiUq
         sOpWBWkriYTJY68Ckrn/LOIFaYAJD092cfmRDNVLZVBMwe/94H2PMXzYvDpzZX5913qn
         pafqeUDZuj3eeU+GBKGCKPCf9+dxdSStYgPnHgAplUUBx6hqL3oUwA4GwRhTGZB6hRam
         i74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7XUNRQSkmgxBwPtlFe+tY4O7Zk2hAxIaFzmJ+ZbBo5g=;
        b=c2BnP8d24rAAVyUHs5VKtW9rPsyamiIoBi46PqNulEyg0hLTG+yO806KFRe+8vfts+
         y7GUE7Ws58xd6xosz/ZHJg/xb/WHVo/huSUesos6ThT44w71RqjsdaWwMt1VokH9AJqT
         42ZWzs4BOjQTbnu4ru8UCSURKdOBUFrNkcx+dPI3biScNs0EPgVCqxOgPZ+1ZxeEzJzq
         f+EuQREt+h8AyylK6fUGjmPpMUg5cuc+53NgYGmbfOAy9D7bZX/UXeN+HVeXJRuDISwW
         2KhaPL+AGysTF46aK9+Vk/0aztdEs0ptKru4QcBvG9xJf022ul4nVwtv+uEYYWRFk4UW
         unqA==
X-Gm-Message-State: AFqh2kpcHTQqTIXGVa9kTC5Tnh3Y2zbFHSV/6dFpC/dz42rWW+JQ0Taj
	Q2hfc+IXSDjCzc3NWRFr7glKZJizyACLODdEoB+nWQ==
X-Google-Smtp-Source: AMrXdXvjcRQ0s93N60oB4UG+s8wkaJANmmRe0uXkJseN3DOope/rh00sX6ExARGo71QZgK8ljnJFa82hwhnRQq3QYv0=
X-Received: by 2002:a5b:189:0:b0:723:96ad:6761 with SMTP id
 r9-20020a5b0189000000b0072396ad6761mr8600316ybl.326.1673477179137; Wed, 11
 Jan 2023 14:46:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-5-dmatlack@google.com>
 <b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com>
In-Reply-To: <b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 11 Jan 2023 14:45:53 -0800
Message-ID: <CALzav=eQVLAH2coTU1FaOFstFp-AqQBb0JCycrRcP5qjqfMwEg@mail.gmail.com>
Subject: Re: [RFC PATCH 04/37] KVM: x86/mmu: Invert sp->tdp_mmu_page to sp->shadow_mmu_page
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit <namit@vmware.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 12, 2022 at 3:15 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/8/22 20:38, David Matlack wrote:
> > Invert the meaning of sp->tdp_mmu_page and rename it accordingly. This
> > allows the TDP MMU code to not care about this field, which will be used
> > in a subsequent commit to move the TDP MMU to common code.
> >
> > No functional change intended.
>
> Let's use a bit of the role instead.

Will do in v2, thanks.
